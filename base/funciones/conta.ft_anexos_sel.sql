--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_anexos_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_anexos_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tint_transaccion'
 AUTOR: 		 (Manuel Guerra)
 FECHA:	        16-12-2013 20:43:44
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/
DECLARE
	v_consulta 			varchar;
    v_parametros  		record;
	v_nombre_funcion   	text;
    v_resp				varchar;
    
    v_cuenta			varchar;

    v_gestion			integer;
    v_contador 			integer = 0;
    v_record			record;
    v_saldo 			numeric;
    v_operacion			numeric;
    v_monto 			numeric;
    v_array			 	varchar [];
  
    v_recorrer				record;
    v_id_plantilla			integer;
    v_id_cuenta				integer;
    v_importes				record;
    v_cuentas				varchar;
    v_codigo_columna			varchar[];
    v_aux_recorrer			record;
    v_monto_recorrido 				numeric;
    
    v_monto_a    numeric;
    v_monto_b 	numeric;
    
    
    
    
    v_array_cuenta 			varchar [];
    v_array_patida			varchar [];
    v_recorf_m				record;
  	v_cuenta_ids			text;
    v_partidas_ids			text;
    v_nombre_cuenta  varchar;
    
BEGIN
   	v_nombre_funcion = 'conta.ft_anexos_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
 	#TRANSACCION:  'CONTA_AUNE_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin
 	#FECHA:		16-12-2013 20:43:44
	***********************************/
    IF(p_transaccion='CONTA_AUNE_SEL')THEN

    	BEGIN	
         
        select gestion
        into v_gestion
        from param.tgestion
        where id_gestion = v_parametros.id_gestion; 
        
        select pr.id_plantilla_reporte
            into
            v_id_plantilla
            from conta.tplantilla_reporte pr
            where pr.nombre = 'Anexos 1';
            
            CREATE TEMPORARY TABLE temporal( id_periodo integer,
            								 codigo_columna varchar,
                                             columna varchar,
            								 titulo varchar,
            							     monto numeric,
                                             detalle varchar )ON COMMIT DROP;
            
            FOR v_recorrer in (select 	dr.codigo_columna,
                                        dr.order_fila,
                                        dr.columna,
                                        dr.origen,
                                        dr.formula,
                                        dr.concepto,
                                        dr.partida,
                                        dr.nombre_columna,
                                        dr.saldo_inical,
                                        dr.formulario,
                        				dr.codigo_formulario,
                                        dr.tipo_detalle
                                from conta.tplantilla_det_reporte dr 
                                where dr.id_plantilla_reporte = v_id_plantilla
                                order by order_fila ) LOOP
            
       IF v_recorrer.concepto = '0' THEN
       
       		
       	FOR  v_importes in (select pe.id_periodo
                            from param.tperiodo pe
                            where pe.id_gestion = v_parametros.id_gestion)LOOP
        
     	insert into temporal (id_periodo,
                             codigo_columna,
                             titulo,
                             columna,
                             monto,
                             detalle)
                             values(
                             v_importes.id_periodo,
                             v_recorrer.codigo_columna,
                             v_recorrer.nombre_columna,
                             v_recorrer.columna,
                             0,
                             v_recorrer.tipo_detalle);  
        END LOOP; 
        
     --  ELSIF  v_recorrer.formulario != '' THEN
               ELSIF  v_recorrer.formulario != '' THEN			
       
       		FOR v_importes in (select de.id_periodo,
                                de.importe as importe_form
                                from conta.tdeclaraciones_juridicas de
                                where de.tipo = v_recorrer.formulario and de.codigo = v_recorrer.codigo_formulario
                                order by id_periodo)LOOP
            	
                insert into temporal (id_periodo,
                             codigo_columna,
                             titulo,
                             columna,
                             monto,
                             detalle)
                             values(
                             v_importes.id_periodo,
                             v_recorrer.codigo_columna,
                             v_recorrer.nombre_columna,
                             v_recorrer.columna,
                             v_importes.importe_form,
                             v_recorrer.tipo_detalle);          
                                
            END LOOP;
       ELSE
       
       
                    WITH RECURSIVE cuenta_rec (id_cuenta,nro_cuenta, nombre_cuenta ,id_cuenta_padre) AS (
                            SELECT cue.id_cuenta,cue.nro_cuenta,cue.nombre_cuenta, cue.id_cuenta_padre
                            FROM conta.tcuenta cue
                            WHERE cue.id_cuenta in ((select cu.id_cuenta
                                                    from conta.tcuenta cu 
                                                    where cu.nro_cuenta = ANY (string_to_array(v_recorrer.concepto,','))
                                                    and cu.id_gestion = v_parametros.id_gestion )) and   cue.estado_reg = 'activo'
                          UNION ALL
                            SELECT cue2.id_cuenta,cue2.nro_cuenta, cue2.nombre_cuenta, cue2.id_cuenta_padre
                            FROM cuenta_rec lrec 
                            INNER JOIN conta.tcuenta cue2 ON lrec.id_cuenta = cue2.id_cuenta_padre
                            where cue2.estado_reg = 'activo'
                          )select pxp.list(id_cuenta::varchar)
                          into
                          v_cuentas
                          from cuenta_rec;
                          
                        v_array = string_to_array(v_cuentas,',');
                    
                   FOR v_importes in (select per.id_periodo,	
                   							(case
                                            	when v_recorrer.origen = 'saldo'then
                                             		COALESCE(sum(transa.importe_debe_mb),0)::numeric - COALESCE(sum(transa.importe_haber_mb),0)
                                                when v_recorrer.origen = 'debe'then
                                                	COALESCE(sum(transa.importe_debe_mb),0)::numeric 
                                                when v_recorrer.origen = 'haber'then
                                                 	COALESCE(sum(transa.importe_haber_mb),0)
                                            	end::numeric ) as monto
                                             from conta.tint_transaccion transa
                                             inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                                             inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
                                             where icbte.estado_reg = 'validado' and transa.id_cuenta::varchar = ANY (v_array) and per.id_gestion = v_parametros.id_gestion
                                             group by per.id_periodo
                                             order by periodo )LOOP
            			
                   insert into temporal (id_periodo,
                   						 codigo_columna,
                   						 titulo,
                                         columna,
                                         monto,
                                         detalle)
                                         values(
                                         v_importes.id_periodo,
                                         v_recorrer.codigo_columna,
                                         v_recorrer.nombre_columna,
                                          v_recorrer.columna,
                                         case
                                         	when  v_importes.monto < 0 then
                                           -1 * v_importes.monto
                                            else
                                            v_importes.monto
                                         end ,
                                         v_recorrer.tipo_detalle
                                          );      
                   		END LOOP;
                  END IF;
              END LOOP;
           
       
       for v_aux_recorrer in ( select dr.codigo_columna,
       							dr.order_fila
                               from conta.tplantilla_reporte pr
                               inner join conta.tplantilla_det_reporte dr on dr.id_plantilla_reporte = pr.id_plantilla_reporte
                               where pr.nombre = 'Anexos 1' order by order_fila )loop
     		v_codigo_columna = array_append(v_codigo_columna,v_aux_recorrer.codigo_columna);
       end loop;
     
       v_consulta:=' with  columna1 as (select  te.id_periodo,
                                                         te.titulo,
                               							 te.codigo_columna,
                                                         te.columna,
                                                         te.monto
                                                        from temporal te
                                                          where te.codigo_columna = '''||v_codigo_columna[1]||'''),
                                   columna2 as (select te.id_periodo,
                                                       te.codigo_columna,
                                                       te.titulo,
                                                       te.columna,
                                                       te.monto
                                                       from temporal te
                                                       where te.codigo_columna = '''||v_codigo_columna[2]||''' ),
                                    columna3 as (select te.id_periodo,
                                                     te.codigo_columna,
                                                     te.titulo,
                                                     te.columna,
                                                     te.monto
                                                     from temporal te
                                                     where te.codigo_columna = '''||v_codigo_columna[3]||'''),
                                    columna4 as (select te.id_periodo,
                                                   te.codigo_columna,
                                                   te.titulo,
                                                   te.columna,
                                                   te.monto
                                                   from temporal te
                                                   where te.codigo_columna = '''||v_codigo_columna[4]||''' ),
                                    columna5 as (select te.id_periodo,
                                                     te.codigo_columna,
                                                     te.titulo,
                                                     te.columna,
                                                     te.monto
                                                     from temporal te
                                                     where te.codigo_columna = '''||v_codigo_columna[5]||''' ),
                                    columna6 as (select te.id_periodo,
                                                     te.codigo_columna,
                                                     te.titulo,
                                                     te.columna,
                                                     te.monto
                                                     from temporal te
                                                     where te.codigo_columna = '''||v_codigo_columna[6]||'''),
                                    columna7 as (select te.id_periodo,
                                                     te.codigo_columna,
                                                     te.titulo,
                                                     te.columna,
                                                     te.monto
                                                     from temporal te
                                                     where te.codigo_columna = '''||v_codigo_columna[7]||'''),
                                     columna8 as (select te.id_periodo,
                                                   te.codigo_columna,
                                                   te.titulo,
                                                   te.columna,
                                                   te.monto
                                                   from temporal te
                                                   where te.codigo_columna = '''||v_codigo_columna[8]||'''),
                                    columna9 as (select te.id_periodo,
                                                   te.codigo_columna,
                                                   te.titulo,
                                                   te.columna,
                                                   te.monto
                                                   from temporal te
                                                   where te.codigo_columna = '''||v_codigo_columna[9]||'''),
                                    columna10 as (select te.id_periodo,
                                                   te.codigo_columna,
                                                   te.titulo,
                                                   te.columna,
                                                   te.monto
                                                   from temporal te
                                                   where te.codigo_columna = '''||v_codigo_columna[10]||'''),
                                    columna11 as (select te.id_periodo,
                                                   te.codigo_columna,
                                                   te.titulo,
                                                   te.columna,
                                                   te.monto,
                                                   te.detalle
                                                   from temporal te
                                                   where te.codigo_columna = '''||v_codigo_columna[11]||'''),
                                     columna12 as (select te.id_periodo,
                                                   te.codigo_columna,
                                                   te.titulo,
                                                   te.columna,
                                                   te.monto,
                                                   te.detalle
                                                   from temporal te
                                                   where te.codigo_columna = '''||v_codigo_columna[12]||'''),
                                     columna13 as (select te.id_periodo,
                                                   te.codigo_columna,
                                                   te.titulo,
                                                   te.columna,
                                                   te.monto,
                                                   te.detalle
                                                   from temporal te
                                                   where te.codigo_columna = '''||v_codigo_columna[13]||'''),
                                     columna14 as (select te.id_periodo,
                                                   te.codigo_columna,
                                                   te.titulo,
                                                   te.columna,
                                                   te.monto,
                                                   te.detalle
                                                   from temporal te
                                                   where te.codigo_columna = '''||v_codigo_columna[14]||''')
                                  select per.periodo,
                                  		 col.codigo_columna as codigo_columna1,
                                         col.columna as columna1,
                                         col.monto as monto1,
                                         co2.columna as columna2,
                                         co2.monto as monto2,
                                         co3.columna as columna3,
                                         COALESCE(co3.monto,0) as monto3,
                                         co4.columna as columna4,
                                         COALESCE(co4.monto,0) as monto4,
                                         co5.columna as columna5,
                                         co5.monto as monto5,
                                         co6.columna as columna6,
                                         co6.monto as monto6,
                                         co7.columna as columna7,
                                         co7.monto as monto7,
                                         co8.columna as columna8,
                                         co8.monto as monto8,
                                         co9.columna as columna9,
                                         co9.monto as monto9,
                                         co10.columna as columna10,
                                         co10.monto as monto10,
                                         co11.detalle,
                                         COALESCE(co11.monto,0)  as monto11,
                                         COALESCE(co12.monto,0)  as monto13,
                                         COALESCE(co13.monto,0)  as monto13,
                                         COALESCE(co14.monto,0)  as monto14
                                         
                                  from param.tperiodo per 
                                  inner join columna1 col on col.id_periodo = per.id_periodo
                                  inner join columna2 co2 on co2.id_periodo = per.id_periodo
                                  inner join columna3 co3 on co3.id_periodo = per.id_periodo
                                  inner join columna4 co4 on co4.id_periodo = per.id_periodo
                                  inner join columna5 co5 on co5.id_periodo = per.id_periodo
                                  inner join columna6 co6 on co6.id_periodo = per.id_periodo
                                  inner join columna7 co7 on co7.id_periodo = per.id_periodo
                                  inner join columna8 co8 on co8.id_periodo = per.id_periodo
                                  inner join columna9 co9 on co9.id_periodo = per.id_periodo
                                  left join columna10 co10 on co10.id_periodo = per.id_periodo
                                  left join columna11 co11 on co11.id_periodo = per.id_periodo
                                  left join columna12 co12 on co12.id_periodo = per.id_periodo
                                  left join columna13 co13 on co13.id_periodo = per.id_periodo
                                  left join columna14 co14 on co14.id_periodo = per.id_periodo
                                  ';
                                  
        		raise notice '-o- %',v_consulta;
              RETURN v_consulta;  
		END;
   
  
    /*********************************
 	#TRANSACCION:  'CONTA_ANX_SEL'
 	#DESCRIPCION:	Anexos 2
 	#AUTOR:		MMV
 	#FECHA:		8/23/2018
	***********************************/
    ELSIF(p_transaccion='CONTA_ANX_SEL')THEN
    
      BEGIN
       select gestion
        into v_gestion
        from param.tgestion
        where id_gestion = v_parametros.id_gestion; 
        
       select pr.id_plantilla_reporte
            into
            v_id_plantilla
            from conta.tplantilla_reporte pr
            where pr.nombre = 'Anexos 2';
     
             CREATE TEMPORARY TABLE temporal( codigo  varchar,
                                              ordern  integer,
                                              columna varchar,
                                              periodo integer,
                                              monto_a numeric,
                                              monto_b numeric,
                                              monto_c numeric,
                                              monto_d numeric,
                                              monto_e numeric,
                                              monto_f numeric,
                                              monto_g numeric,
                                              monto_h numeric,
                                              monto_i numeric,
                                              monto_j numeric,
                                              monto_k numeric,
                                              monto_l numeric,
                                              monto_m numeric,
                                              monto_n numeric   ) ON COMMIT DROP;
                                              
      FOR v_recorrer in (	select 	dr.codigo_columna,
                                    dr.order_fila,
                                    dr.nombre_columna,
                                    dr.columna,
                                    dr.operacion,
                                    dr.origen,
                                    dr.concepto,
                                    dr.partida,
                                    dr.origen2,
                                    dr.concepto2,
                                    dr.partida2,
                                    dr.tipo,
                                    dr.calculo,
                                    dr.saldo_inical,
                                    dr.saldo_anterior,
                                    dr.periodo,
                                    dr.formulario,
                        			dr.codigo_formulario
                            from conta.tplantilla_det_reporte dr 
                            where dr.id_plantilla_reporte = v_id_plantilla
                            order by order_fila )LOOP
              
      IF NOT EXISTS ( select 1
                      from temporal)THEN
       
      	
           --  IF v_recorrer.saldo_inical = 'si' THEN
                        
                          FOR v_aux_recorrer in (
                          
                                select pe.periodo,
                                          conta.f_configuracion_plantilla_reporte (
                                            cu.nro_cuenta,
                                            v_recorrer.origen,
                                            v_recorrer.saldo_inical,
                                            v_recorrer.saldo_anterior,
                                            v_parametros.id_gestion,
                                            pe.periodo,
                                            v_recorrer.periodo
                                          ) as monto 
                                    from conta.tint_transaccion tra
                                    inner join conta.tint_comprobante icb on icb.id_int_comprobante = tra.id_int_comprobante
                                    inner join param.tperiodo pe on pe.id_periodo = icb.id_periodo
                                    inner join conta.tcuenta cu on cu.id_cuenta = tra.id_cuenta
                                    where icb.estado_reg = 'validado' and  cu.nro_cuenta in (v_recorrer.concepto)  and pe.id_gestion = v_parametros.id_gestion
                                    group by pe.periodo,cu.nro_cuenta
                                    order by periodo
                                    
                                    )LOOP
                            		
                                   insert into temporal( codigo,
                                                          ordern,
                                                          columna,
                                                          periodo,
                                                          monto_a,
                                                          monto_b,
                                                          monto_c,
                                                          monto_d,
                                                          monto_e,
                                                          monto_f,
                                                          monto_g,
                                                          monto_h,
                                                          monto_i,
                                                          monto_j,
                                                          monto_k,
                                                          monto_l,
                                                          monto_m,
                                                          monto_n)
                                                          values(
                                                          v_recorrer.codigo_columna,
                                                          v_recorrer.order_fila,
                                                          v_recorrer.columna,
                                                          v_aux_recorrer.periodo,
                                                          v_aux_recorrer.monto,
                                                          0,
                                                          0,
                                                          0,
                                                          0,
                                                          0,
                                                          0,
                                                          0,
                                                          0,
                                                          0,
                                                          0,
                                                          0,
                                                          0,
                                                          0
                                                          );
                                
                                  END LOOP;
                    --    END IF;
                        
                ELSE
                
               IF  v_recorrer.formulario != '' THEN
               
               ---		raise EXCEPTION 'hola %',v_recorrer.codigo_formulario;
       		FOR v_aux_recorrer in (select pe.periodo,
                                de.importe as monto
                                from conta.tdeclaraciones_juridicas de
                                inner join param.tperiodo pe on pe.id_periodo = de.id_periodo
                                where de.tipo = v_recorrer.formulario and de.codigo = v_recorrer.codigo_formulario
                                order by periodo)LOOP
            	
                   IF v_recorrer.columna = 'B' THEN
                                                    
                                                    update temporal set 
                                                    monto_b = v_aux_recorrer.monto
                                                    where periodo = v_aux_recorrer.periodo;
                                                    
                                                ELSIF  v_recorrer.columna = 'C' THEN
                                                 
                                                    update temporal set 
                                                    monto_c = v_aux_recorrer.monto
                                                    where periodo = v_aux_recorrer.periodo;
                                                    
                                                 ELSIF  v_recorrer.columna = 'D' THEN
                                                    
                                                  update temporal set 
                                                  monto_d = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                 ELSIF  v_recorrer.columna = 'E' THEN
                                                    
                                                  update temporal set 
                                                  monto_e = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                 
                                                 ELSIF  v_recorrer.columna = 'F' THEN
                                                    
                                                  update temporal set 
                                                  monto_f = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                  
                                                  ELSIF  v_recorrer.columna = 'G' THEN
                                                    
                                                  update temporal set 
                                                  monto_g = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                  
                                                  ELSIF  v_recorrer.columna = 'H' THEN
                                                    
                                                  update temporal set 
                                                  monto_h = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                  
                                                 ELSIF  v_recorrer.columna = 'I' THEN
                                                    
                                                  update temporal set 
                                                  monto_i = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                  
                                                   
                                                 ELSIF  v_recorrer.columna = 'J' THEN
                                                    
                                                  update temporal set 
                                                  monto_j = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                  
                                                      
                                                 ELSIF  v_recorrer.columna = 'K' THEN
                                                    
                                                  update temporal set 
                                                  monto_k = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                    
                                                ELSIF  v_recorrer.columna = 'L' THEN
                                                    
                                                  update temporal set 
                                                  monto_l = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                  
                                                ELSIF  v_recorrer.columna = 'M' THEN
                                                   
                                                  update temporal set 
                                                  monto_m = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                  
                                                ELSIF  v_recorrer.columna = 'N' THEN
                                                    
                                                  update temporal set 
                                                  monto_n = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                  
                                                END IF;     
                                
            END LOOP;
                ELSE	
                 IF v_recorrer.calculo = 'si' THEN
                     FOR v_aux_recorrer in (with uno as  (select pe.periodo,
                                                            conta.f_configuracion_plantilla_reporte (
                                                                 cu.nro_cuenta,
                                                                  v_recorrer.origen,
                                                                  v_recorrer.saldo_inical,
                                                                  v_recorrer.saldo_anterior	,
                                                                  v_parametros.id_gestion,
                                                                  pe.periodo,
                                                                  v_recorrer.periodo) as monto 
                                                      from conta.tint_transaccion tra
                                                      inner join conta.tint_comprobante icb on icb.id_int_comprobante = tra.id_int_comprobante
                                                      inner join param.tperiodo pe on pe.id_periodo = icb.id_periodo
                                                      inner join conta.tcuenta cu on cu.id_cuenta = tra.id_cuenta
                                                      where icb.estado_reg = 'validado' and  cu.nro_cuenta in (v_recorrer.concepto)  
                                                      and pe.id_gestion = v_parametros.id_gestion
                                                      group by pe.periodo,cu.nro_cuenta
                                                      order by periodo),
                                                      dos as (select pe.periodo,
                                                          conta.f_configuracion_plantilla_reporte (
                                                                                                  cu.nro_cuenta,
                                                                                                  v_recorrer.origen2,
                                                                                                  v_recorrer.saldo_inical,
                                                                                                  v_recorrer.saldo_anterior	,
                                                                                                  v_parametros.id_gestion,
                                                                                                  pe.periodo,
                                                                                                  v_recorrer.periodo ) as monto 
                                                                                      from conta.tint_transaccion tra
                                                                                      inner join conta.tint_comprobante icb on icb.id_int_comprobante = tra.id_int_comprobante
                                                                                      inner join param.tperiodo pe on pe.id_periodo = icb.id_periodo
                                                                                      inner join conta.tcuenta cu on cu.id_cuenta = tra.id_cuenta
                                                                                      where icb.estado_reg = 'validado' and  cu.nro_cuenta in (v_recorrer.concepto2)  
                                                                                      and pe.id_gestion = v_parametros.id_gestion
                                                                                      group by pe.periodo,cu.nro_cuenta 
                                                                                      order by periodo)                                
                                                                                      select un.periodo,
                                                                                                 un.monto - ds.monto as monto
                                                                                          from uno un
                                                                                          inner join dos ds on ds.periodo = un.periodo
                                                                                          order by periodo )LOOP
                                                
                                                IF v_recorrer.columna = 'B' THEN
                                                    
                                                    update temporal set 
                                                    monto_b = v_aux_recorrer.monto
                                                    where periodo = v_aux_recorrer.periodo;
                                                    
                                                ELSIF  v_recorrer.columna = 'C' THEN
                                                 
                                                    update temporal set 
                                                    monto_c = v_aux_recorrer.monto
                                                    where periodo = v_aux_recorrer.periodo;
                                                    
                                                 ELSIF  v_recorrer.columna = 'D' THEN
                                                    
                                                  update temporal set 
                                                  monto_d = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                 ELSIF  v_recorrer.columna = 'E' THEN
                                                    
                                                  update temporal set 
                                                  monto_e = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                 
                                                 ELSIF  v_recorrer.columna = 'F' THEN
                                                    
                                                  update temporal set 
                                                  monto_f = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                  
                                                  ELSIF  v_recorrer.columna = 'G' THEN
                                                    
                                                  update temporal set 
                                                  monto_g = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                  
                                                  ELSIF  v_recorrer.columna = 'H' THEN
                                                    
                                                  update temporal set 
                                                  monto_h = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                  
                                                 ELSIF  v_recorrer.columna = 'I' THEN
                                                    
                                                  update temporal set 
                                                  monto_i = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                  
                                                   
                                                 ELSIF  v_recorrer.columna = 'J' THEN
                                                    
                                                  update temporal set 
                                                  monto_j = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                  
                                                      
                                                 ELSIF  v_recorrer.columna = 'K' THEN
                                                    
                                                  update temporal set 
                                                  monto_k = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                    
                                                ELSIF  v_recorrer.columna = 'L' THEN
                                                    
                                                  update temporal set 
                                                  monto_l = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                  
                                                ELSIF  v_recorrer.columna = 'M' THEN
                                                    
                                                  update temporal set 
                                                  monto_m = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                  
                                                ELSIF  v_recorrer.columna = 'N' THEN
                                                    
                                                  update temporal set 
                                                  monto_n = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                  
                                                END IF;
                                                
                                                
                          END LOOP;
                 
                 
                 ELSE	
                     			
                       FOR v_aux_recorrer in (select pe.periodo,
                                                      conta.f_configuracion_plantilla_reporte (
                                                        cu.nro_cuenta,
                                                        v_recorrer.origen,
                                                        v_recorrer.saldo_inical,
                                                        v_recorrer.saldo_anterior	,
                                                        v_parametros.id_gestion,
                                                        pe.periodo,
                                                        v_recorrer.periodo
                                                      ) as monto 
                                                from conta.tint_transaccion tra
                                                inner join conta.tint_comprobante icb on icb.id_int_comprobante = tra.id_int_comprobante
                                                inner join param.tperiodo pe on pe.id_periodo = icb.id_periodo
                                                inner join conta.tcuenta cu on cu.id_cuenta = tra.id_cuenta
                                                where icb.estado_reg = 'validado' and  cu.nro_cuenta in (v_recorrer.concepto)  and pe.id_gestion = v_parametros.id_gestion
                                                group by pe.periodo,cu.nro_cuenta
                                                order by periodo )LOOP
                                                
                                                 IF v_recorrer.columna = 'B' THEN
                                                    
                                                    update temporal set 
                                                    monto_b = v_aux_recorrer.monto
                                                    where periodo = v_aux_recorrer.periodo;
                                                    
                                                ELSIF  v_recorrer.columna = 'C' THEN
                                                 
                                                    update temporal set 
                                                    monto_c = v_aux_recorrer.monto
                                                    where periodo = v_aux_recorrer.periodo;
                                                    
                                                 ELSIF  v_recorrer.columna = 'D' THEN
                                                    
                                                  update temporal set 
                                                  monto_d = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                 ELSIF  v_recorrer.columna = 'E' THEN
                                                    
                                                  update temporal set 
                                                  monto_e = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                 
                                                 ELSIF  v_recorrer.columna = 'F' THEN
                                                    
                                                  update temporal set 
                                                  monto_f = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                  
                                                  ELSIF  v_recorrer.columna = 'G' THEN
                                                    
                                                  update temporal set 
                                                  monto_g = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                  
                                                  ELSIF  v_recorrer.columna = 'H' THEN
                                                    
                                                  update temporal set 
                                                  monto_h = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                  
                                                 ELSIF  v_recorrer.columna = 'I' THEN
                                                    
                                                  update temporal set 
                                                  monto_i = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                  
                                                   
                                                 ELSIF  v_recorrer.columna = 'J' THEN
                                                    
                                                  update temporal set 
                                                  monto_j = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                  
                                                      
                                                 ELSIF  v_recorrer.columna = 'K' THEN
                                                    
                                                  update temporal set 
                                                  monto_k = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                    
                                                ELSIF  v_recorrer.columna = 'L' THEN
                                                    
                                                  update temporal set 
                                                  monto_l = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                  
                                                ELSIF  v_recorrer.columna = 'M' THEN
                                                    
                                                  update temporal set 
                                                  monto_m = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                  
                                                ELSIF  v_recorrer.columna = 'N' THEN
                                                    
                                                  update temporal set 
                                                  monto_n = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                  
                                                END IF;
                                                
                                                
                          END LOOP;
                      END IF;
	 	 		 END IF;
      	END IF;
             
      END LOOP;                                  
       v_consulta:='select  '|| v_gestion ||'::integer as gestion,
                                t.codigo,
                                t.ordern,
                                t.columna,
                                t.periodo,
                                t.monto_a,
                                t.monto_b,
                                t.monto_c,
                                t.monto_d,
                                t.monto_e,
                                t.monto_f,
                                t.monto_g,
                                t.monto_h,
                                t.monto_i,
                                t.monto_j,
                                t.monto_k,
                                t.monto_l,
                                t.monto_m,
                                t.monto_n   	
                        from temporal t
                        order by periodo';
         return v_consulta;
      
      END;
      /*********************************
 	#TRANSACCION:  'CONTA_ANF_SEL'
 	#DESCRIPCION:	Anexos 4
 	#AUTOR:		MMV
 	#FECHA:		8/23/2018
	***********************************/
    ELSIF(p_transaccion='CONTA_ANF_SEL')THEN
      BEGIN
      
        CREATE TEMPORARY TABLE temporal( codigo  varchar,
                                              ordern  integer,
                                              columna varchar,
                                              periodo integer,
                                              monto_a numeric,
                                              monto_b numeric,
                                              monto_c numeric,
                                              monto_d numeric,
                                              monto_e numeric,
                                              monto_f numeric ) ON COMMIT DROP;
      
       select gestion
        into v_gestion
        from param.tgestion
        where id_gestion = v_parametros.id_gestion; 
        
       select pr.id_plantilla_reporte
            into
            v_id_plantilla
            from conta.tplantilla_reporte pr
            where pr.nombre = 'Anexos 4';
            
            
              FOR v_recorrer in (	select 	dr.codigo_columna,
                                    dr.order_fila,
                                    dr.nombre_columna,
                                    dr.columna,
                                    dr.operacion,
                                    dr.origen,
                                    dr.concepto,
                                    dr.partida,
                                    dr.origen2,
                                    dr.concepto2,
                                    dr.partida2,
                                    dr.tipo,
                                    dr.calculo,
                                    dr.saldo_inical,
                                    dr.saldo_anterior,
                                    dr.periodo,
                                    dr.formulario,
                        			dr.codigo_formulario
                            from conta.tplantilla_det_reporte dr 
                            where dr.id_plantilla_reporte = v_id_plantilla
                            order by order_fila )LOOP
                 
              
              IF NOT EXISTS ( 	select 1
              					from temporal)THEN           
              FOR v_aux_recorrer in (with ingreso as ( select 	per.id_periodo,
                            -1 * ( sum(transa.importe_debe_mb) -  sum(transa.importe_haber_mb))  as monto
                            from conta.tint_transaccion transa
                            inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                            inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
                            where icbte.estado_reg = 'validado'
                            and transa.id_cuenta in (1478,2370,1483,1485,1488,1487,1489,1517,1518,1519,1520,1521,1522,1523,1524,1526,1525,1600,1593,1594,1595,1596,1597,1598,1599,1601,1602,1755,1753,1747,1748,1749,1750,1751,1752,1754,1756,1757,1759,1758,2336,2386,1916,1927,1938,1939,2118,2119,2120,2121,2122,2123,2124,2125,2126,2127,2128,2129,2130,2131,2132,2133,2134,2135,2136,2137,2138,2139)
                            and per.id_gestion = 2
                            group by per.id_periodo
                            order by id_periodo),
  ajustes as ( select 	per.id_periodo,
                             -1*(sum(transa.importe_debe_mb)-  sum(transa.importe_haber_mb)) as monto
                            from conta.tint_transaccion transa
                            inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                            inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
                            where icbte.estado_reg = 'validado'
                            and transa.id_cuenta in (1602,1758,2127)
                            and per.id_gestion = 2
                            group by per.id_periodo
                            order by id_periodo),
  ingreso_grabado as ( select 	per.id_periodo,
                             -1*(sum(transa.importe_debe_mb) - sum(transa.importe_haber_mb)) as monto
                            from conta.tint_transaccion transa
                            inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                            inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
                            where icbte.estado_reg = 'validado'
                            and transa.id_cuenta in (1755,2131,2137,2138)
                            and per.id_gestion = 2
                            group by per.id_periodo
                            order by id_periodo)
                            select  pe.periodo,
                            		(i.monto - a.monto -  g.monto)/0.87 as monto
                            from ingreso i
                            inner join ajustes a on a.id_periodo = i.id_periodo
                            inner join ingreso_grabado g on g.id_periodo = i.id_periodo 
                            inner join param.tperiodo pe on pe.id_periodo = i.id_periodo
                            order by periodo)LOOP
                        				
                                        insert into temporal( codigo,
                                                              ordern,
                                                              columna,
                                                              periodo,
                                                              monto_a,
                                                              monto_b,
                                                              monto_c,
                                                              monto_d,
                                                              monto_e,
                                                              monto_f )
                                                              values(
                                                              v_recorrer.codigo_columna,
                                                              v_recorrer.order_fila,
                                                              v_recorrer.columna,
                                                              v_aux_recorrer.periodo,
                                                              v_aux_recorrer.monto,
                                                              0,
                                                              0,
                                                              0,
                                                              0,
                                                              0);							              
                  
              
              
              END LOOP;
              
              ELSE
               IF  v_recorrer.formulario != '' THEN
       			FOR v_aux_recorrer in (select pe.periodo,
                                de.importe as monto
                                from conta.tdeclaraciones_juridicas de
                                inner join param.tperiodo pe on pe.id_periodo = de.id_periodo
                                where de.tipo = v_recorrer.formulario and de.codigo = v_recorrer.codigo_formulario
                                order by periodo)LOOP
            	
                   					IF v_recorrer.columna = 'B' THEN
                                    	
                                        update temporal set 
                                        monto_b = v_aux_recorrer.monto
                                        where periodo = v_aux_recorrer.periodo;
                                                    
                                    ELSIF  v_recorrer.columna = 'C' THEN
                                                 
                                    	update temporal set 
                                        monto_c = v_aux_recorrer.monto
                                        where periodo = v_aux_recorrer.periodo;
                                                    
                                    ELSIF  v_recorrer.columna = 'D' THEN
                                                    
                                          update temporal set 
                                          monto_d = v_aux_recorrer.monto
                                          where periodo = v_aux_recorrer.periodo;
                                                  
                                	ELSIF  v_recorrer.columna = 'E' THEN
                                                    
                                          update temporal set 
                                          monto_e = v_aux_recorrer.monto
                                          where periodo = v_aux_recorrer.periodo;
                                                 
                                	ELSIF  v_recorrer.columna = 'F' THEN
                                                    
                                            update temporal set 
                                            monto_f = v_aux_recorrer.monto
                                            where periodo = v_aux_recorrer.periodo;
                                    END IF;     
                                
            		END LOOP;
                END IF;    
              
               END IF;           
              				
              END LOOP;
            
     
         v_consulta:='select  '|| v_gestion ||'::integer as gestion,
                                t.codigo,
                                t.ordern,
                                t.columna,
                                t.periodo,
                                t.monto_a,
                                t.monto_b,
                                t.monto_c,
                                t.monto_d,
                                t.monto_e,
                                t.monto_f	
                        from temporal t
                        order by periodo';   	            
	  		raise notice '%',v_consulta;
            --raise exception '%',v_consulta;          
    	RETURN v_consulta;
      
      END;
      /*********************************
 	#TRANSACCION:  'CONTA_ANC_SEL'
 	#DESCRIPCION:	Anexos 5
 	#AUTOR:		MMV
 	#FECHA:		8/23/2018
	***********************************/
      ELSIF(p_transaccion='CONTA_ANC_SEL')THEN
      	BEGIN
    	
                                               
        CREATE TEMPORARY TABLE temporal( id integer,
              								   periodo integer,
                                               saldo numeric,
                                               it numeric,
                                               operacion numeric,
                                               tipo varchar
                                               )ON COMMIT DROP;
                                               
    FOR  v_record in (select	per.periodo,
        COALESCE(transa.importe_debe_mb,0)::numeric as monto,
        'saldo'::varchar as tipo
        from conta.tint_transaccion transa
        inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
        inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
        where icbte.estado_reg = 'validado' and  transa.id_cuenta in (1866)  
        and  per.id_gestion = 2 and icbte.cbte_apertura = 'si'
                union
                select	5 as periodo,
                        COALESCE(transa.importe_debe_mb,0)::numeric as monto,
                        'Subtotal 1'::varchar as tipo
                        from conta.tint_transaccion transa
                        inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                        inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
                        where icbte.estado_reg = 'validado' and  transa.id_cuenta in (1866)  
                        and  per.id_gestion = 2 and icbte.cbte_apertura = 'si'
                union
                select 5 as periodo,
                                                    COALESCE(transa.importe_haber_mb,0)::numeric as monto,
                                                    'saldo'::varchar as tipo
                                                    from conta.tint_transaccion transa
                                                    inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                                                    inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
                                                    where icbte.estado_reg = 'validado' and  transa.id_cuenta in (1917)  
                                                    and  per.id_gestion = 2 and icbte.cbte_apertura = 'si'
                union
                select 13 as periodo,
                                                    COALESCE(transa.importe_haber_mb,0)::numeric as monto,
                                                    'Subtotal 2'::varchar as tipo
                                                    from conta.tint_transaccion transa
                                                    inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                                                    inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
                                                    where icbte.estado_reg = 'validado' and  transa.id_cuenta in (1917)  
                                                    and  per.id_gestion = 2 and icbte.cbte_apertura = 'si'
                union
                        select p.periodo,
                                        (select	case when(sum(COALESCE(transa.importe_debe_mb,0)) - sum(COALESCE(transa.importe_haber_mb,0)))<0  
                                                                    then
                                                                    (sum(COALESCE(transa.importe_debe_mb,0))::numeric - sum(COALESCE(transa.importe_haber_mb,0))::numeric)*(-1) 
                                                                else    
                                                                    0
                                                                end as importe_haber_mb
                                                                from conta.tint_transaccion transa
                                                                inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                                                                inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
                                                                where icbte.estado_reg = 'validado' 
                                                                      and  transa.id_cuenta in (1915)  
                                                                      and extract(MONTH from icbte.fecha::date)  < p.periodo + 1
                                                                      and per.id_gestion = 2 ) as  monto,
                                                                      'it'::varchar as tipo
                                    from conta.tint_transaccion t
                                    inner join conta.tint_comprobante i on i.id_int_comprobante = t.id_int_comprobante
                                    inner join param.tperiodo p on p.id_periodo = i.id_periodo
                                    where i.estado_reg = 'validado'and  
                                    t.id_cuenta in (1915) and 
                                    p.id_gestion = 2
                                    group by  p.periodo
                                    order by periodo , tipo desc)LOOP
      		
        				v_contador = v_contador + 1;
        			IF v_record.tipo = 'saldo' THEN
                    
                    
						insert into temporal ( id,
                                               periodo,
                                               saldo,
                                               it,
                                               operacion,
                                               tipo
                        					   )values(
                                               v_contador,
                                               v_record.periodo,
                                               v_record.monto,
                                               0,
                                               0,
                                               v_record.tipo
                                               );  
                    ELSIF v_record.tipo = 'Subtotal 1' or v_record.tipo = 'Subtotal 2'  THEN       
                              insert into temporal ( id,
                                               periodo,
                                               saldo,
                                               it,
                                               operacion,
                                               tipo
                        					   )values(
                                               v_contador,
                                               v_record.periodo,
                                               v_record.monto,
                                               0,
                                               0,
                                               v_record.tipo
                                               );   
                                               
    
                   ELSIF (v_record.tipo = 'it' and v_record.periodo = 1 ) THEN
                       
                          select tr.saldo
                          into 
                          v_saldo
                          from temporal tr
                          where tr.id = 1;
                     
                          
                              update temporal set 
                              it = v_record.monto,
                              operacion = v_saldo - v_record.monto
                              where id = 1; 
                              
                   ELSIF (v_record.tipo = 'it' and v_record.periodo = 5 ) THEN
                       
                          select tr.saldo
                          into 
                          v_saldo
                          from temporal tr
                          where tr.id = (select max(id)from temporal);
                     
                          
                              update temporal set 
                              it = v_record.monto,
                              operacion = v_saldo - v_record.monto
                              where id = (select max(id)from temporal); 
                   
                    ELSE
                    
                    select operacion
                            into 
                            v_operacion
                            from temporal 
                            where id = (select max(id)from temporal);
                            
                          
                    	insert into temporal ( id,
                                               periodo,
                                               saldo,
                                               it,
                                               operacion,
                                                tipo
                        					   )values(
                                               v_contador,
                                               v_record.periodo,
                                               v_operacion,
                                               v_record.monto,
                                               v_operacion - v_record.monto,
                                               v_record.tipo
                                               );     

                    END IF;
                    v_contador = v_contador + v_contador;                          
        END LOOP;
        
         v_consulta:='select  tr.periodo,
                               tr.saldo,
                               tr.it,
                               tr.operacion,
                               tr.tipo
                          from temporal tr
                          order by periodo';    	            
    	RETURN v_consulta;
        
    	END;
        
      /*********************************
 	#TRANSACCION:  'CONTA_AXV_SEL'
 	#DESCRIPCION:	Anexos 6
 	#AUTOR:		MMV
 	#FECHA:		8/23/2018
	***********************************/
    ELSIF(p_transaccion='CONTA_AXV_SEL')THEN
      	BEGIN
          select gestion
          into v_gestion
          from param.tgestion
          where id_gestion = v_parametros.id_gestion; 
          
            CREATE TEMPORARY TABLE temporal(  codigo  varchar,
                                              ordern  integer,
                                              columna varchar,
                                              periodo integer,
                                              monto_a numeric,
                                              monto_b numeric,
                                              monto_c numeric,
                                              monto_d numeric,
                                              monto_e numeric,
                                              monto_f numeric,
                                              monto_g numeric,
                                              monto_h numeric,
                                              monto_i numeric,
                                              monto_j numeric,
                                              monto_k numeric,
                                              monto_l numeric,
                                              monto_m numeric ) ON COMMIT DROP;
        
       		select pr.id_plantilla_reporte
            into
            v_id_plantilla
            from conta.tplantilla_reporte pr
            where pr.nombre = 'Anexos 6';
        
        FOR v_recorrer in (	select 	dr.codigo_columna,
                                    dr.order_fila,
                                    dr.nombre_columna,
                                    dr.columna,
                                    dr.operacion,
                                    dr.origen,
                                    dr.concepto,
                                    dr.partida,
                                    dr.origen2,
                                    dr.concepto2,
                                    dr.partida2,
                                    dr.tipo,
                                    dr.calculo,
                                    dr.saldo_inical,
                                    dr.saldo_anterior,
                                    dr.periodo,
                                    dr.formulario,
                        			dr.codigo_formulario
                            from conta.tplantilla_det_reporte dr 
                            where dr.id_plantilla_reporte = v_id_plantilla
                            order by order_fila )LOOP
                            
                            v_array_cuenta = string_to_array(v_recorrer.concepto::varchar,',');  
                            v_array_patida = string_to_array(v_recorrer.partida::varchar,',');  
                        
                         WITH RECURSIVE cuenta_rec (id_cuenta,nro_cuenta, nombre_cuenta ,id_cuenta_padre) AS (
                                SELECT cue.id_cuenta,cue.nro_cuenta,cue.nombre_cuenta, cue.id_cuenta_padre
                                FROM conta.tcuenta cue
                                WHERE cue.id_cuenta in ((select cu.id_cuenta
                                                        from conta.tcuenta cu 
                                                        where cu.nro_cuenta = ANY (v_array_cuenta)
                                                        and cu.id_gestion = v_parametros.id_gestion)) and cue.estado_reg = 'activo'
                          UNION ALL
                            SELECT cue2.id_cuenta,cue2.nro_cuenta, cue2.nombre_cuenta, cue2.id_cuenta_padre
                            FROM cuenta_rec lrec 
                            INNER JOIN conta.tcuenta cue2 ON lrec.id_cuenta = cue2.id_cuenta_padre
                            where cue2.estado_reg = 'activo'
                          )select pxp.list(c.id_cuenta::varchar)
                          	into v_cuenta_ids
                          from cuenta_rec c;
                          
                          select pxp.list(pa.id_partida::text) 
                            into v_partidas_ids
                          from pre.tpartida pa
                          where pa.id_gestion = v_parametros.id_gestion and pa.codigo = ANY (v_array_patida);
   
   			IF NOT EXISTS (	select 1
            				from temporal)THEN
                            
                            FOR v_aux_recorrer in (
                                           
                          select 	per.periodo,
                                                        (case
                                              when v_recorrer.origen = 'saldo' then
                                                  COALESCE(sum(transa.importe_debe_mb),0)::numeric - COALESCE(sum(transa.importe_haber_mb),0)::numeric 
                                             when v_recorrer.origen  = 'debe' then
                                                  COALESCE(sum(transa.importe_debe_mb),0)::numeric 
                                             when v_recorrer.origen  = 'haber' then
                                                  COALESCE(sum(transa.importe_haber_mb),0)::numeric 
                                              end::numeric ) as monto
                                              from conta.tint_transaccion transa
                                              inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                                              inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
                                              inner join conta.tcuenta cu on cu.id_cuenta = transa.id_cuenta
                                              inner join pre.tpartida pa on pa.id_partida = transa.id_partida
                                              where icbte.estado_reg = 'validado' and 
                                              transa.id_cuenta::varchar = ANY (string_to_array(v_cuenta_ids::varchar,',')) and
                                              transa.id_partida::varchar = ANY (string_to_array(v_partidas_ids::varchar,','))
                                              and per.id_gestion = v_parametros.id_gestion
                                              group by per.periodo
                                              order by periodo
                                                
                                                )LOOP
                                        		
                                               insert into temporal( codigo,
                                                                      ordern,
                                                                      columna,
                                                                      periodo,
                                                                      monto_a,
                                                                      monto_b,
                                                                      monto_c,
                                                                      monto_d,
                                                                      monto_e,
                                                                      monto_f,
                                                                      monto_g,
                                                                      monto_h,
                                                                      monto_i,
                                                                      monto_j,
                                                                      monto_k,
                                                                      monto_l,
                                                                      monto_m)
                                                                      values(
                                                                      v_recorrer.codigo_columna,
                                                                      v_recorrer.order_fila,
                                                                      v_recorrer.columna,
                                                                      v_aux_recorrer.periodo,
                                                                      v_aux_recorrer.monto,
                                                                      0,
                                                                      0,
                                                                      0,
                                                                      0,
                                                                      0,
                                                                      0,
                                                                      0,
                                                                      0,
                                                                      0,
                                                                      0,
                                                                      0,
                                                                      0);
                                            
                                              END LOOP;
            ELSE
            
            IF  v_recorrer.formulario != '' THEN
            
              FOR v_aux_recorrer in (select pe.periodo,
                                                  de.importe as monto
                                                  from conta.tdeclaraciones_juridicas de
                                                  inner join param.tperiodo pe on pe.id_periodo = de.id_periodo
                                                  where de.tipo = v_recorrer.formulario and de.codigo = v_recorrer.codigo_formulario
                                                  order by periodo)LOOP
                              	
                                     IF v_recorrer.columna = 'B' THEN
                                                                      
                                                                      update temporal set 
                                                                      monto_b = v_aux_recorrer.monto
                                                                      where periodo = v_aux_recorrer.periodo;
                                                                      
                                                                  ELSIF  v_recorrer.columna = 'C' THEN
                                                                   
                                                                      update temporal set 
                                                                      monto_c = v_aux_recorrer.monto
                                                                      where periodo = v_aux_recorrer.periodo;
                                                                      
                                                                   ELSIF  v_recorrer.columna = 'D' THEN
                                                                      
                                                                    update temporal set 
                                                                    monto_d = v_aux_recorrer.monto
                                                                    where periodo = v_aux_recorrer.periodo;
                                                                   ELSIF  v_recorrer.columna = 'E' THEN
                                                                      
                                                                    update temporal set 
                                                                    monto_e = v_aux_recorrer.monto
                                                                    where periodo = v_aux_recorrer.periodo;
                                                                   
                                                                   ELSIF  v_recorrer.columna = 'F' THEN
                                                                      
                                                                    update temporal set 
                                                                    monto_f = v_aux_recorrer.monto
                                                                    where periodo = v_aux_recorrer.periodo;
                                                                    
                                                                    ELSIF  v_recorrer.columna = 'G' THEN
                                                                      
                                                                    update temporal set 
                                                                    monto_g = v_aux_recorrer.monto
                                                                    where periodo = v_aux_recorrer.periodo;
                                                                    
                                                                    ELSIF  v_recorrer.columna = 'H' THEN
                                                                      
                                                                    update temporal set 
                                                                    monto_h = v_aux_recorrer.monto
                                                                    where periodo = v_aux_recorrer.periodo;
                                                                    
                                                                   ELSIF  v_recorrer.columna = 'I' THEN
                                                                      
                                                                    update temporal set 
                                                                    monto_i = v_aux_recorrer.monto
                                                                    where periodo = v_aux_recorrer.periodo;
                                                                    
                                                                     
                                                                   ELSIF  v_recorrer.columna = 'J' THEN
                                                                      
                                                                    update temporal set 
                                                                    monto_j = v_aux_recorrer.monto
                                                                    where periodo = v_aux_recorrer.periodo;
                                                                    
                                                                        
                                                                   ELSIF  v_recorrer.columna = 'K' THEN
                                                                      
                                                                    update temporal set 
                                                                    monto_k = v_aux_recorrer.monto
                                                                    where periodo = v_aux_recorrer.periodo;
                                                                      
                                                                  ELSIF  v_recorrer.columna = 'L' THEN
                                                                      
                                                                    update temporal set 
                                                                    monto_l = v_aux_recorrer.monto
                                                                    where periodo = v_aux_recorrer.periodo;
                                                                    
                                                                  ELSIF  v_recorrer.columna = 'M' THEN
                                                                     
                                                                    update temporal set 
                                                                    monto_m = v_aux_recorrer.monto
                                                                    where periodo = v_aux_recorrer.periodo;
                                                                    
                                                                  ELSIF  v_recorrer.columna = 'N' THEN
                                                                      
                                                                    update temporal set 
                                                                    monto_n = v_aux_recorrer.monto
                                                                    where periodo = v_aux_recorrer.periodo;
                                                                    
                                                                  END IF;     
                                                  
                              END LOOP;
            
            
            ELSE
            FOR v_aux_recorrer in (
                                select 	per.periodo,
                                            (case
                                  when v_recorrer.origen = 'saldo' then
                                      COALESCE(sum(transa.importe_debe_mb),0)::numeric - COALESCE(sum(transa.importe_haber_mb),0)::numeric 
                                 when v_recorrer.origen  = 'debe' then
                                      COALESCE(sum(transa.importe_debe_mb),0)::numeric 
                                 when v_recorrer.origen  = 'haber' then
                                      COALESCE(sum(transa.importe_haber_mb),0)::numeric 
                                  end::numeric ) as monto
                                  from conta.tint_transaccion transa
                                  inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                                  inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
                                  where icbte.estado_reg = 'validado'
                                  and transa.id_cuenta::varchar = ANY (string_to_array(v_cuenta_ids::varchar,',')) 
                                  and case
                                        when v_partidas_ids = '' or v_partidas_ids is null then
                                  		0=0
                                        else
                                   transa.id_partida::varchar = ANY (string_to_array(v_partidas_ids::varchar,','))
                                   end
                                  and per.id_gestion = v_parametros.id_gestion
                                  group by per.periodo
                                  order by periodo
                                    
                                    )LOOP
                                  
                                         IF v_recorrer.columna = 'B' THEN
                                                    
                                                    update temporal set 
                                                    monto_b = v_aux_recorrer.monto
                                                    where periodo = v_aux_recorrer.periodo;
                                                    
                                                ELSIF  v_recorrer.columna = 'C' THEN
                                                        
                                                    update temporal set 
                                                    monto_c = v_aux_recorrer.monto
                                                    where periodo = v_aux_recorrer.periodo;
                                                    
                                                 ELSIF  v_recorrer.columna = 'D' THEN
                                                    
                                              ---------
     									FOR v_recorf_m in (with aux as (select 	per.id_periodo,
                                                              (case
                                                    when v_recorrer.origen = 'saldo' then
                                                        COALESCE(sum(transa.importe_debe_mb),0)::numeric - COALESCE(sum(transa.importe_haber_mb),0)::numeric 
                                                   when v_recorrer.origen  = 'debe' then
                                                        COALESCE(sum(transa.importe_debe_mb),0)::numeric 
                                                   when v_recorrer.origen  = 'haber' then
                                                        COALESCE(sum(transa.importe_haber_mb),0)::numeric 
                                                    end::numeric ) as monto
                                                    from conta.tint_transaccion transa
                                                    inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                                                    inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
                                                    inner join conta.tcuenta cu on cu.id_cuenta = transa.id_cuenta
                                                    inner join pre.tpartida pa on pa.id_partida = transa.id_partida
                                                    where icbte.estado_reg = 'validado'
                                                    and  cu.nro_cuenta = ANY (v_array_cuenta)
                                                    and  pa.codigo = ANY (v_array_patida)
                                                    and per.id_gestion = v_parametros.id_gestion
                                                    group by per.id_periodo
                                                    order by id_periodo),
                                                aux2 as (select per.id_periodo,
                                                                sum(COALESCE(transa.importe_debe_mb,0)) as monto
                                                                from conta.tint_transaccion transa
                                                                inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                                                                inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
                                                                where icbte.estado_reg = 'validado'  and transa.id_cuenta in (1880)
                                                                and per.id_gestion = v_parametros.id_gestion
                                                                group by per.id_periodo
                                                                order by id_periodo),
                                                aux3 as (with  desepenio as (
                                                        select		per.id_periodo,
                                                        sum(COALESCE(transa.importe_debe_mb,0))::numeric as monto
                                                        from conta.tint_transaccion transa
                                                        inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                                                        inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
                                                        where icbte.estado_reg = 'validado'
                                                              and  transa.id_cuenta in (1881)  
                                                              and  per.id_gestion = v_parametros.id_gestion
                                                              and transa.cerrado in ('si','no') 
                                                        group by per.id_periodo
                                                        order by id_periodo asc ), 
                                             aportes as ( select per.id_periodo,
                                                                sum(COALESCE(transa.importe_debe_mb,0))::numeric as monto
                                                                from conta.tint_transaccion transa
                                                                inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                                                                inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
                                                                where icbte.estado_reg = 'validado' 
                                                                      and  transa.id_cuenta in (1881)  
                                                                      and  per.id_gestion = v_parametros.id_gestion
                                                                      and transa.cerrado in ('si','no') 
                                                                      and (icbte.glosa1::varchar ILIKE '%APORTES%'  or icbte.glosa1::varchar ILIKE '%REVERSION%')
                                                                group by per.id_periodo
                                                                order by id_periodo asc )
                                            select 	en.id_periodo,
                                                    en.monto - COALESCE( ap.monto,0) as monto
                                            from desepenio en
                                            left join aportes ap on ap.id_periodo = en.id_periodo
                                                      )select  
                                                      pe.periodo,
                                                      a1.monto + a2.monto+ COALESCE(a3.monto,0) as monto
                                                      from param.tperiodo pe 
                                                      inner join aux a1 on a1.id_periodo = pe.id_periodo
                                                      inner join  aux2 a2 on a2.id_periodo = pe.id_periodo
                                                      left join  aux3 a3 on a3.id_periodo = pe.id_periodo
                                                      order by periodo)LOOP
                                                                  
                                                                            update temporal set 
                                                                            monto_d = v_recorf_m.monto
                                                                            where periodo = v_recorf_m.periodo;
                                                  
                                       				 END LOOP;
                                               ----------
                                                 
                                                  
                                                 ELSIF  v_recorrer.columna = 'E' THEN
                                          			
                                                  update temporal set 
                                                  monto_e = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                 
                                                 ELSIF  v_recorrer.columna = 'F' THEN
                                                   
                                                  update temporal set 
                                                  monto_f = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                  
                                                  ELSIF  v_recorrer.columna = 'G' THEN
                                                    
                                                  update temporal set 
                                                  monto_g = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                  
                                                  ELSIF  v_recorrer.columna = 'H' THEN
                                                    
                                                  update temporal set 
                                                  monto_h = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                  
                                                 ELSIF  v_recorrer.columna = 'I' THEN
                                                    
                                                  update temporal set 
                                                  monto_i = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                  
                                                   
                                                 ELSIF  v_recorrer.columna = 'J' THEN
                                                -- raise exception '---> %',v_recorrer.columna;
                                                  update temporal set 
                                                  monto_j = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                  
                                                      
                                                 ELSIF  v_recorrer.columna = 'K' THEN
                                                    
                                                  update temporal set 
                                                  monto_k = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                    
                                                ELSIF  v_recorrer.columna = 'L' THEN
                                                    
                                                  update temporal set 
                                                  monto_l = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                  
                                                ELSIF  v_recorrer.columna = 'M' THEN
                                                   
                                                  update temporal set 
                                                  monto_m = v_aux_recorrer.monto
                                                  where periodo = v_aux_recorrer.periodo;
                                                
                                                END IF; 
                                
                                  END LOOP;
                   END IF;
        	END IF;                                  
          END LOOP;
        
         v_consulta:='select  '|| v_gestion ||'::integer as gestion,
                                t.codigo,
                                t.ordern,
                                t.columna,
                                t.periodo,
                                t.monto_a,
                                t.monto_b,
                                t.monto_c,
                                t.monto_d,
                                t.monto_e,
                                t.monto_f,
                                t.monto_g,
                                t.monto_h,
                                t.monto_i,
                                t.monto_j,
                                t.monto_k,
                                t.monto_l,
                                t.monto_m	
                        from temporal t
                        order by periodo';
       
		 RETURN v_consulta;  
    	END;
    /*********************************
 	#TRANSACCION:  'CONTA_ANZ_SEL'
 	#DESCRIPCION:	Anexos 7
 	#AUTOR:		MMV
 	#FECHA:		8/23/2018
	***********************************/
     ELSIF(p_transaccion='CONTA_ANZ_SEL')THEN
       BEGIN
       
     
       
       if (v_parametros.tipo_anexo = 'ane_7_1')then
       		select pr.id_plantilla_reporte
            into
            v_id_plantilla
            from conta.tplantilla_reporte pr
            where pr.nombre = 'Anexos 7.1';
            
       ELSIF (v_parametros.tipo_anexo = 'ane_11')then
       		select pr.id_plantilla_reporte
            into
            v_id_plantilla
            from conta.tplantilla_reporte pr
            where pr.nombre = 'Anexos 11';
     	ELSE
        select pr.id_plantilla_reporte
            into
            v_id_plantilla
            from conta.tplantilla_reporte pr
            where pr.nombre = 'Anexos 7';
        END IF;    
        
        ---  raise exception '-->  %',v_id_plantilla;
             CREATE TEMPORARY TABLE temporal( codigo_columna varchar,
                                              ordern integer,
                                              columna varchar,
                                              titulo varchar,
            							      monto_a numeric,
                                              monto_b numeric,
                                              monto_c numeric,
                                              monto_d numeric,
                                              monto_e numeric )ON COMMIT DROP;
                                         
             
    FOR v_recorrer in (	select 	dr.codigo_columna,
                                dr.order_fila,
                                dr.nombre_columna,
                                dr.columna,
                                dr.operacion,
                                dr.origen,
                                dr.concepto,
                                dr.partida,
                                dr.origen2,
                                dr.concepto2,
                                dr.partida2,
                                dr.tipo,
                                dr.calculo
                        from conta.tplantilla_det_reporte dr 
                        where dr.id_plantilla_reporte = v_id_plantilla
                        order by order_fila )LOOP
        
     
    IF v_recorrer.calculo = 'si' THEN
    
    
    CASE v_recorrer.operacion
      WHEN 'resta' THEN   
      
      select conta.f_calcular_monto_nro_cuenta(v_recorrer.concepto,v_parametros.id_gestion,v_recorrer.origen,v_recorrer.partida)
              into v_monto_a;
      select conta.f_calcular_monto_nro_cuenta(v_recorrer.concepto2,v_parametros.id_gestion,v_recorrer.origen2,v_recorrer.partida2)  
     		 into v_monto_b;
      	if v_monto_a < 0 then
              v_monto_recorrido =  -1 * v_monto_a - v_monto_b;
        else
               v_monto_recorrido =  v_monto_a - v_monto_b;
        end if;
        
	END CASE;

IF EXISTS ( select	1
                     from temporal 
                     where codigo_columna = v_recorrer.codigo_columna )THEN
         
        if v_recorrer.columna =  '2'  then
                    update temporal set
                    ordern = v_recorrer.order_fila,
                    columna =  v_recorrer.columna,
                    monto_b = v_monto_recorrido
                    where  codigo_columna = v_recorrer.codigo_columna;
                    
            elsif v_recorrer.columna =  '3' then
         
         		update temporal set
                    ordern = v_recorrer.order_fila,
                    columna =  v_recorrer.columna,
                    monto_c = v_monto_recorrido
                    where  codigo_columna = v_recorrer.codigo_columna;
            elsif v_recorrer.columna =  '4' then
            
            update temporal set
                    ordern = v_recorrer.order_fila,
                    columna =  v_recorrer.columna,
                    monto_d = v_monto_recorrido
                    where  codigo_columna = v_recorrer.codigo_columna;
             elsif v_recorrer.columna =  '5' then
            
            update temporal set
                    ordern = v_recorrer.order_fila,
                    columna =  v_recorrer.columna,
                    monto_e = v_monto_recorrido
                    where  codigo_columna = v_recorrer.codigo_columna;
            end if;
         	if( v_recorrer.codigo_columna = 'ANE8')then
           -- raise exception '--> %', v_recorrer.codigo_columna;
                insert into temporal( codigo_columna,
                                          ordern,
                                          columna,
                                          titulo,
                                          monto_a,
                                          monto_b,
                                          monto_c,
                                          monto_d,
                                          monto_e)    
                                          values (
                                          v_recorrer.codigo_columna,
                                          v_recorrer.order_fila,
                                          v_recorrer.columna,
                                          v_recorrer.nombre_columna,
                                          v_monto_recorrido,
                                          0,
                                          0,
                                          0,
                                          0); 
            end if;
         
          ELSE
         insert into temporal( codigo_columna,
                                          ordern,
                                          columna,
                                          titulo,
                                          monto_a,
                                          monto_b,
                                          monto_c,
                                          monto_d,
                                          monto_e)    
                                          values (
                                          v_recorrer.codigo_columna,
                                          v_recorrer.order_fila,
                                          v_recorrer.columna,
                                          v_recorrer.nombre_columna,
                                          v_monto_recorrido,
                                          0,
                                          0,
                                          0,
                                          0);     
      
     END IF; 
    
    ELSE
   		 
         IF v_recorrer.tipo = 'titulo' THEN
         	insert into  temporal(  codigo_columna,
            			            ordern,
                                    columna,
                                    titulo)
                                    VALUES(
                                    v_recorrer.codigo_columna,
                                    v_recorrer.order_fila,
                                    v_recorrer.columna,
                                    v_recorrer.nombre_columna
                                    );
         ELSE
         
       select conta.f_calcular_monto_nro_cuenta(v_recorrer.concepto,v_parametros.id_gestion,v_recorrer.origen,v_recorrer.partida)
              into
            v_monto_recorrido;
          
         
         IF EXISTS ( select	1
                     from temporal 
                     where codigo_columna = v_recorrer.codigo_columna )THEN
            
        	if v_recorrer.columna =  '2'  then
                    update temporal set
                    ordern = v_recorrer.order_fila,
                    columna =  v_recorrer.columna,
                    monto_b = v_monto_recorrido
                    where  codigo_columna = v_recorrer.codigo_columna;
            elsif v_recorrer.columna =  '3' then
         
         		update temporal set
                    ordern = v_recorrer.order_fila,
                    columna =  v_recorrer.columna,
                    monto_c = v_monto_recorrido
                    where  codigo_columna = v_recorrer.codigo_columna;
            elsif v_recorrer.columna =  '4' then
            
            update temporal set
                    ordern = v_recorrer.order_fila,
                    columna =  v_recorrer.columna,
                    monto_d = v_monto_recorrido
                    where  codigo_columna = v_recorrer.codigo_columna;
             elsif v_recorrer.columna =  '5' then
            
            update temporal set
                    ordern = v_recorrer.order_fila,
                    columna =  v_recorrer.columna,
                    monto_e = v_monto_recorrido
                    where  codigo_columna = v_recorrer.codigo_columna;
            end if;
            
          ELSE
        
         			insert into temporal( codigo_columna,
                                          ordern,
                                          columna,
                                          titulo,
                                          monto_a,
                                          monto_b,
                                          monto_c,
                                          monto_d,
                                          monto_e)    
                                          values (
                                          v_recorrer.codigo_columna,
                                          v_recorrer.order_fila,
                                          v_recorrer.columna,
                                          v_recorrer.nombre_columna,
                                          v_monto_recorrido,
                                          0,
                                          0,
                                          0,
                                          0);     
                     
         	END IF;
         END IF;
   END IF;
    
    END LOOP;
     
                                              
        v_consulta:='select codigo_columna,
                            ordern,
                            columna,
                            titulo,
                            monto_a,
                            monto_b,
                            monto_c,
                            monto_d,
                            monto_e 
                            from temporal 
                             order by ordern';
        raise notice '-o- %',v_consulta;
        RETURN v_consulta;  
       END;
    
    /*********************************
 	#TRANSACCION:  'CONTA_ANOC_SEL'
 	#DESCRIPCION:	Anexos 8
 	#AUTOR:		MMV
 	#FECHA:		8/23/2018
	***********************************/
       ELSIF(p_transaccion='CONTA_ANOC_SEL')THEN
      	 BEGIN
         
         	select pr.id_plantilla_reporte
            into
            v_id_plantilla
            from conta.tplantilla_reporte pr
            where pr.nombre = 'Anexos 8';
            
            CREATE TEMPORARY TABLE temporal( titulo varchar,
                                             nro_cuenta varchar,
                                             nombre_cuenta varchar,
                                             motivo varchar,
                                             normativa varchar,
                                             importe numeric,
                                             ordenar integer )ON COMMIT DROP;
            
            
             FOR v_recorrer in (select 	dr.codigo_columna,
                                        dr.order_fila,
                                        dr.columna,
                                        dr.origen,
                                        dr.formula,
                                        dr.concepto,
                                        dr.partida,
                                        dr.nombre_columna,
                                        dr.saldo_inical,
                                        dr.formulario,
                        				dr.codigo_formulario,
                                        dr.tipo_aux
                                from conta.tplantilla_det_reporte dr 
                                where dr.id_plantilla_reporte = v_id_plantilla
                                order by order_fila ) LOOP                                 
         select conta.f_calcular_monto_nro_cuenta(v_recorrer.concepto,v_parametros.id_gestion,v_recorrer.origen,'no')
              into
            v_monto_recorrido;     
                                
            	insert into temporal ( 	titulo,
                						nro_cuenta,
                                     	nombre_cuenta,
                                     	motivo,
                                        normativa,
                                     	importe,
                                     	ordenar)
                                        values(
                                        v_recorrer.tipo_aux,
                                        v_recorrer.concepto,
                                        v_recorrer.nombre_columna,
                                        '',
                                        '',
                                       v_monto_recorrido ,
                                        v_recorrer.order_fila
                                        );
                                
             END LOOP;
             
            v_consulta ='select initcap(titulo)::varchar as titulo,
                                nro_cuenta,
                                nombre_cuenta,
                                motivo,
                                normativa,
                                importe,
                               	ordenar
            					from temporal 
                            	order by ordenar,titulo';
            
        	raise notice '-o- %',v_consulta;
         RETURN v_consulta;  
       END;
       /*********************************
 	#TRANSACCION:  'CONTA_NINE_SEL'
 	#DESCRIPCION:	Anexos 9
 	#AUTOR:		MMV
 	#FECHA:		8/23/2018
	***********************************/
       ELSIF(p_transaccion='CONTA_NINE_SEL')THEN
      	 BEGIN
         
         	select pr.id_plantilla_reporte
            into
            v_id_plantilla
            from conta.tplantilla_reporte pr
            where pr.nombre = 'Anexos 9';
            
            CREATE TEMPORARY TABLE temporal( titulo varchar,
                                             nro_cuenta varchar,
                                             nombre_cuenta varchar,
                                             motivo varchar,
                                             normativa varchar,
                                             importe numeric,
                                             ordenar integer )ON COMMIT DROP;
            
            
             FOR v_recorrer in (select 	dr.codigo_columna,
                                        dr.order_fila,
                                        dr.columna,
                                        dr.origen,
                                        dr.formula,
                                        dr.concepto,
                                        dr.partida,
                                        dr.nombre_columna,
                                        dr.saldo_inical,
                                        dr.formulario,
                        				dr.codigo_formulario,
                                        dr.tipo_aux
                                from conta.tplantilla_det_reporte dr 
                                where dr.id_plantilla_reporte = v_id_plantilla
                                order by order_fila ) LOOP 
                                
                                
         select conta.f_calcular_monto_nro_cuenta(v_recorrer.concepto,v_parametros.id_gestion,v_recorrer.origen,'no')
              into
            v_monto_recorrido;     
                                
            	insert into temporal ( 	titulo,
                						nro_cuenta,
                                     	nombre_cuenta,
                                     	motivo,
                                        normativa,
                                     	importe,
                                     	ordenar)
                                        values(
                                        v_recorrer.tipo_aux,
                                        v_recorrer.concepto,
                                        v_recorrer.nombre_columna,
                                        '',
                                        '',
                                        v_monto_recorrido ,
                                        v_recorrer.order_fila
                                        );
                               
                                
             END LOOP;
             
            v_consulta ='select initcap(titulo)::varchar as titulo,
                                nro_cuenta,
                                nombre_cuenta,
                                motivo,
                                normativa,
                                importe,
                               	ordenar
            					from temporal 
                            	order by ordenar,nro_cuenta';
            
        	raise notice '-o- %',v_consulta;
         RETURN v_consulta;  
       END;
  
   /*********************************
 	#TRANSACCION:  'CONTA_AUD_SEL'
 	#DESCRIPCION:	Auxliar detalle anexos
 	#AUTOR:		MMV
 	#FECHA:		19/10/2018
	***********************************/
     ELSIF(p_transaccion='CONTA_AUD_SEL')THEN
    	 BEGIN
         
          select gestion
          into v_gestion
          from param.tgestion
          where id_gestion = v_parametros.id_gestion; 
          
            CREATE TEMPORARY TABLE temporal_aux(periodo integer,
            									nro_cuenta varchar,
                                                codigo_partida varchar,
                                                titulo	varchar,
                                                importe numeric  ) ON COMMIT DROP;
     		select pr.id_plantilla_reporte
            into
            v_id_plantilla
            from conta.tplantilla_reporte pr
            where pr.nombre = 'Anexos 6';
            
        
     		FOR v_recorrer in (select 	de.concepto,
                                        de.partida,
                                        de.origen,
                                        de.orden_fila
                                from conta.tdetalle_det_reporte_aux de 
                                where de.id_plantilla_reporte = v_id_plantilla
                                order by orden_fila)LOOP
               -----Obtener ID numero cuenta
               
                v_array_cuenta = string_to_array(v_recorrer.concepto::varchar,',');  
                v_array_patida = string_to_array(v_recorrer.partida::varchar,',');   
                
                                
                WITH RECURSIVE cuenta_rec (id_cuenta,nro_cuenta, nombre_cuenta ,id_cuenta_padre) AS (
                                SELECT cue.id_cuenta,cue.nro_cuenta,cue.nombre_cuenta, cue.id_cuenta_padre
                                FROM conta.tcuenta cue
                                WHERE cue.id_cuenta in ((select cu.id_cuenta
                                                        from conta.tcuenta cu 
                                                        where cu.nro_cuenta = ANY (v_array_cuenta)
                                                        and cu.id_gestion = v_parametros.id_gestion)) and cue.estado_reg = 'activo'
                                UNION ALL
                                  SELECT cue2.id_cuenta,cue2.nro_cuenta, cue2.nombre_cuenta, cue2.id_cuenta_padre
                                  FROM cuenta_rec lrec 
                                  INNER JOIN conta.tcuenta cue2 ON lrec.id_cuenta = cue2.id_cuenta_padre
                                  where cue2.estado_reg = 'activo'
                                )select pxp.list(c.id_cuenta::varchar)
                                  into v_cuenta_ids
                                  from cuenta_rec c;
                                  
                                  
          		/*select  pxp.list(cue.id_cuenta::varchar)
                		into v_cuenta_ids
                from conta.tcuenta cue
                where cue.nro_cuenta = ANY (v_array_cuenta) 
                and cue.id_gestion = v_parametros.id_gestion
                and cue.estado_reg =  'activo';
                          */
                select pxp.list(pa.id_partida::text) 
                  into v_partidas_ids
                from pre.tpartida pa
                where pa.id_gestion = v_parametros.id_gestion and pa.codigo = ANY (v_array_patida);
                -----Fin 
                
                
                select cu.nombre_cuenta
                into
                	v_nombre_cuenta
                from conta.tcuenta cu
                where cu.nro_cuenta = v_recorrer.concepto and cu.id_gestion = v_parametros.id_gestion;
                
                
               IF  v_recorrer.concepto = '2.1.2.01.099.001' THEN 
               
               FOR v_aux_recorrer in (with  desepenio as (
                                                        select		per.periodo,
                                                        sum(COALESCE(transa.importe_debe_mb,0))::numeric as monto
                                                        from conta.tint_transaccion transa
                                                        inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                                                        inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
                                                        where icbte.estado_reg = 'validado'
                                                              and  transa.id_cuenta in (1881)  
                                                              and  per.id_gestion = 2
                                                              and transa.cerrado in ('si','no') 
                                                        group by per.periodo
                                                        order by periodo asc ), 
                                             aportes as ( select per.periodo,
                                                                sum(COALESCE(transa.importe_debe_mb,0))::numeric as monto
                                                                from conta.tint_transaccion transa
                                                                inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                                                                inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
                                                                where icbte.estado_reg = 'validado' 
                                                                      and  transa.id_cuenta in (1881)  
                                                                      and  per.id_gestion = 2
                                                                      and transa.cerrado in ('si','no') 
                                                                      and (icbte.glosa1::varchar ILIKE '%APORTES%'  or icbte.glosa1::varchar ILIKE '%REVERSION%')
                                                                group by per.periodo
                                                                order by periodo asc )
                                            select 	en.periodo,
                                                    en.monto - COALESCE( ap.monto,0) as monto
                                            from desepenio en
                                            left join aportes ap on ap.periodo = en.periodo)LOOP
                                            
                                            
                        insert into temporal_aux( periodo,
                                                  nro_cuenta,
                                                  codigo_partida,
                                                  titulo,
                                                  importe
                                                  )values(
                                                  v_aux_recorrer.periodo,
                                                  v_recorrer.concepto,
                                                  v_recorrer.partida,
                                                  v_nombre_cuenta,
                                                  v_aux_recorrer.monto
                                                  );                    
                                            
                                         
               END LOOP;
               ELSE
                 FOR v_aux_recorrer in (
                  
                    with periodo as (select pe.id_periodo,
                                             pe.periodo
                                             from param.tperiodo pe
                                             where pe.id_gestion = v_parametros.id_gestion
                                             order by id_periodo),
                         cuenta as ( select  per.id_periodo,
                                              (case
                                          when v_recorrer.origen = 'saldo' then
                                              COALESCE(sum(transa.importe_debe_mb),0)::numeric - COALESCE(sum(transa.importe_haber_mb),0)::numeric 
                                         when v_recorrer.origen  = 'debe' then
                                              COALESCE(sum(transa.importe_debe_mb),0)::numeric 
                                         when v_recorrer.origen  = 'haber' then
                                              COALESCE(sum(transa.importe_haber_mb),0)::numeric 
                                          end::numeric ) as monto
                                          from conta.tint_transaccion transa
                                          inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                                          inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
                                          inner join pre.tpartida pa on pa.id_partida = transa.id_partida
                                          where icbte.estado_reg = 'validado'
                                          and transa.id_cuenta::varchar = ANY (string_to_array(v_cuenta_ids::varchar,',')) 
                                          and case
                                                when v_partidas_ids = '' or v_partidas_ids is null then
                                                0=0
                                                else
                                           pa.id_partida::varchar = ANY (string_to_array(v_partidas_ids::varchar,','))
                                           end
                                          and per.id_gestion = v_parametros.id_gestion
                                          group by per.id_periodo
                                          order by id_periodo)
                                            select pr.periodo,
                                                  COALESCE(cu.monto, 0) as monto
                                                  from periodo pr
                                                  left join cuenta cu on cu.id_periodo = pr.id_periodo)LOOP
                             
            			insert into temporal_aux( periodo,
                                                  nro_cuenta,
                                                  codigo_partida,
                                                  titulo,
                                                  importe
                                                  )values(
                                                  v_aux_recorrer.periodo,
                                                  v_recorrer.concepto,
                                                  v_recorrer.partida,
                                                  v_nombre_cuenta,
                                                  v_aux_recorrer.monto
                                                  );
                		END LOOP;
                 
               END IF;            
                                
            END LOOP;
     
    		 v_consulta ='	select 	periodo,
                                    nro_cuenta,
                                    codigo_partida,
                                    titulo,
                                    importe
             				from temporal_aux
                            order by periodo,nro_cuenta desc ';
     
     
         
     RETURN v_consulta;  
       END;
        /*********************************
      #TRANSACCION:  'CONTA_THE_SEL'
      #DESCRIPCION:	Anexos 10 
      #AUTOR:		MMV
      #FECHA:		19/10/2018
      ***********************************/
     ELSIF(p_transaccion='CONTA_THE_SEL')THEN
    	 BEGIN
       
    /*   FOR v_recorrer in (  with remesa as ( select distinct com.id_int_comprobante
                                             from conta.tint_transaccion tran
                                             inner join conta.tint_comprobante com on com.id_int_comprobante = tran.id_int_comprobante
                                             where tran.id_cuenta = 1899 and com.cbte_apertura = 'no' and com.estado_reg = 'validado'),
                              auxiliar as ( select  cu.id_cuenta,
                                                    com.id_periodo,
                                                    com.id_int_comprobante,
                                                    au.nombre_auxiliar, 
                                                    au.codigo_auxiliar, 
                                                   sum( transa.importe_haber_mb) as monto
                                                    from conta.tint_transaccion transa
                                                    inner join conta.tint_comprobante com on com.id_int_comprobante = transa.id_int_comprobante
                                                    inner join conta.tcuenta cu on cu.id_cuenta = transa.id_cuenta
                                                    inner join conta.tconfig_subtipo_cuenta su on su.id_config_subtipo_cuenta = cu.id_config_subtipo_cuenta
                                                    inner join conta.tconfig_tipo_cuenta tp on tp.id_config_tipo_cuenta = su.id_config_tipo_cuenta
                                                    inner join conta.tauxiliar au on au.id_auxiliar = transa.id_auxiliar
                                                    inner join remesa re on re.id_int_comprobante = com.id_int_comprobante
                                                    where tp.tipo_cuenta = 'pasivo' and com.estado_reg = 'validado' and  su.nombre in ('CUENTAS POR PAGAR','PROVEEDORES')
                                                    and au.codigo_auxiliar <> 'IMPINT' and  transa.importe_haber_mb > 0
                                                    group by  cu.id_cuenta,
                                                              com.id_periodo,
                                                              com.id_int_comprobante,
                                                              au.nombre_auxiliar, 
                                                              au.codigo_auxiliar
                                                    order by  id_periodo),
                                cuenta as (select 	cu.id_cuenta,
                                                      cu.nro_cuenta,
                                                      comp.id_periodo,
                                                      cu.nombre_cuenta,
                                                      tran.id_int_comprobante, 
                                                      sum( tran.importe_debe_mb ) as monto
                                                      from conta.tcuenta cu
                                                      inner join conta.tconfig_subtipo_cuenta cc on cc.id_config_subtipo_cuenta = cu.id_config_subtipo_cuenta
                                                      inner join conta.tconfig_tipo_cuenta cp on cp.id_config_tipo_cuenta = cc.id_config_tipo_cuenta
                                                      inner join conta.tint_transaccion tran on tran.id_cuenta = cu.id_cuenta
                                                      inner join conta.tint_comprobante comp on comp.id_int_comprobante = tran.id_int_comprobante
                                                      inner join  remesa re on re.id_int_comprobante = comp.id_int_comprobante
                                                      where cp.tipo_cuenta <> 'pasivo' and comp.estado_reg = 'validado' and cu.id_cuenta not in (2110,2174,1687)
                                                      and  tran.importe_debe_mb >  0
                                                      group by  cu.id_cuenta,
                                                                cu.nombre_cuenta,
                                                                tran.id_int_comprobante,
                                                                comp.id_periodo,
                                                                cu.nro_cuenta
                                                    order by id_periodo)     
                                          select 	pe.periodo,
                                                  cu.id_int_comprobante, 
                                                  cu.nro_cuenta,
                                                  cu.nombre_cuenta,
                                                  re.nombre_auxiliar,
                                                  cu.monto 
                                          from  cuenta cu      
                                          inner join auxiliar re on re.id_int_comprobante = cu.id_int_comprobante 
                                          inner join param.tperiodo pe on pe.id_periodo = cu.id_periodo)LOOP
            
  
 		 END LOOP;
            */
   v_consulta = 'with remesa as ( select distinct com.id_int_comprobante
                                             from conta.tint_transaccion tran
                                             inner join conta.tint_comprobante com on com.id_int_comprobante = tran.id_int_comprobante
                                             where tran.id_cuenta = 1899 and com.cbte_apertura = ''no'' and com.estado_reg = ''validado''),
                              auxiliar as ( select  cu.id_cuenta,
                                                    com.id_periodo,
                                                    com.id_int_comprobante,
                                                    au.nombre_auxiliar, 
                                                    au.codigo_auxiliar, 
                                                   sum( transa.importe_haber_mb) as monto
                                                    from conta.tint_transaccion transa
                                                    inner join conta.tint_comprobante com on com.id_int_comprobante = transa.id_int_comprobante
                                                    inner join conta.tcuenta cu on cu.id_cuenta = transa.id_cuenta
                                                    inner join conta.tconfig_subtipo_cuenta su on su.id_config_subtipo_cuenta = cu.id_config_subtipo_cuenta
                                                    inner join conta.tconfig_tipo_cuenta tp on tp.id_config_tipo_cuenta = su.id_config_tipo_cuenta
                                                    inner join conta.tauxiliar au on au.id_auxiliar = transa.id_auxiliar
                                                    inner join remesa re on re.id_int_comprobante = com.id_int_comprobante
                                                    where tp.tipo_cuenta = ''pasivo'' and com.estado_reg = ''validado'' and  su.nombre in (''CUENTAS POR PAGAR'',''PROVEEDORES'')
                                                    and au.codigo_auxiliar <> ''IMPINT'' and  transa.importe_haber_mb > 0
                                                    group by  cu.id_cuenta,
                                                              com.id_periodo,
                                                              com.id_int_comprobante,
                                                              au.nombre_auxiliar, 
                                                              au.codigo_auxiliar
                                                    order by  id_periodo),
                                cuenta as (select 	cu.id_cuenta,
                                                      cu.nro_cuenta,
                                                      comp.id_periodo,
                                                      cu.nombre_cuenta,
                                                      tran.id_int_comprobante, 
                                                      sum( tran.importe_debe_mb ) as monto
                                                      from conta.tcuenta cu
                                                      inner join conta.tconfig_subtipo_cuenta cc on cc.id_config_subtipo_cuenta = cu.id_config_subtipo_cuenta
                                                      inner join conta.tconfig_tipo_cuenta cp on cp.id_config_tipo_cuenta = cc.id_config_tipo_cuenta
                                                      inner join conta.tint_transaccion tran on tran.id_cuenta = cu.id_cuenta
                                                      inner join conta.tint_comprobante comp on comp.id_int_comprobante = tran.id_int_comprobante
                                                      inner join  remesa re on re.id_int_comprobante = comp.id_int_comprobante
                                                      where cp.tipo_cuenta <> ''pasivo'' and comp.estado_reg = ''validado'' and cu.id_cuenta not in (2110,2174,1687)
                                                      and  tran.importe_debe_mb >  0
                                                      group by  cu.id_cuenta,
                                                                cu.nombre_cuenta,
                                                                tran.id_int_comprobante,
                                                                comp.id_periodo,
                                                                cu.nro_cuenta
                                                    order by id_periodo)     
                                          select  pe.periodo,
                                                  sum (cu.monto) as  monto
                                          from  cuenta cu      
                                          inner join auxiliar re on re.id_int_comprobante = cu.id_int_comprobante 
                                          inner join param.tperiodo pe on pe.id_periodo = cu.id_periodo
                                          group by  pe.periodo
                                          order by periodo';
         
         RETURN v_consulta;  
       END; 
       
	ELSE					     
		RAISE EXCEPTION 'Transaccion inexistente';				         
	END IF;
					
EXCEPTION			
	WHEN OTHERS THEN
        v_resp='';
        v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
        v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
        v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
        RAISE EXCEPTION '%',v_resp;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;