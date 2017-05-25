CREATE OR REPLACE FUNCTION conta.ft_ajuste_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_ajuste_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tajuste'
 AUTOR: 		 (admin)
 FECHA:	        10-12-2015 15:16:16
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
    v_registros_config   	record;
    v_sw_trans				boolean;
	v_id_requerimiento     	integer;
    v_id_centro_costo_depto integer;
    v_id_partida  integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_ajuste				integer;
    v_registros				record;
    v_registros_det			record;
    v_rec_periodo			record;
    v_registros_rel			record;
    v_id_moneda_base 		integer;
    v_id_moneda_tri 		integer;
    v_id_ajuste_det 		integer;
    v_prioridad_depto	    integer;
    v_conta_prioridad_depto_inter  varchar;
    v_depto_inter 			boolean;
    va_id_deptos_lbs		integer[];
    va_id_moneda			integer[];
    v_id_moneda				integer;
    v_id_subsistema  		integer;
    v_id_clase_comprobante 	integer;
    v_id_int_comprobante	integer;
    v_codigo_clase_cbte 	varchar;
    v_tipo_trans 			varchar;
    v_relacion 				varchar; 
    v_monto_debe_mb			numeric;
    v_monto_haber_mb		numeric;
    v_monto_debe_mt			numeric;
    v_monto_haber_mt		numeric;
    v_tipo_cambio_1			numeric;
    v_tipo_cambio_2			numeric;
    v_monto_debe 			numeric;
    v_monto_haber	 		numeric;
    v_sw_cambio				boolean;
    
			    
BEGIN

    v_nombre_funcion = 'conta.ft_ajuste_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_AJT_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		10-12-2015 15:16:16
	***********************************/

	if(p_transaccion='CONTA_AJT_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.tajuste(
              fecha,
              id_depto_conta,
              estado,
              obs,
              estado_reg,
              id_usuario_ai,
              usuario_ai,
              fecha_reg,
              id_usuario_reg,
              fecha_mod,
              id_usuario_mod,
              tipo
          	) values(
              v_parametros.fecha,
              v_parametros.id_depto_conta,
              'borrador',
              v_parametros.obs,
              'activo',
              v_parametros._id_usuario_ai,
              v_parametros._nombre_usuario_ai,
              now(),
              p_id_usuario,
              null,
              null,
              v_parametros.tipo
			)RETURNING id_ajuste into v_id_ajuste;
            
            
             -- recuepramos la gestion del ajsute
             
             v_rec_periodo = param.f_get_periodo_gestion( v_parametros.fecha);
             
            
             
             
             v_id_moneda_base = param.f_get_moneda_base();
             v_id_moneda_tri  = param.f_get_moneda_triangulacion();
             
             
          
             
             
             select
               d.prioridad
             into
              v_prioridad_depto
             from param.tdepto d
             where d.id_depto = v_parametros.id_depto_conta;
             
             --verificamos si es un depto internacional
              v_conta_prioridad_depto_inter = pxp.f_get_variable_global('conta_prioridad_depto_inter');
              
              IF  v_prioridad_depto::varchar =   v_conta_prioridad_depto_inter THEN
                 v_depto_inter = true;
              ELSE
                 v_depto_inter =  false;
              END IF;
            
            ----------------------------------------------------------------------
            --  segun el tipo de ajsute se inserta cuentas  de manera automatica
            -----------------------------------------------------------------------
           
            IF  v_parametros.tipo = 'bancos'  THEN
                    
            
                  --  recuperar los libros de bancos relacionados con el depto de contabilidad
                  select
                    pxp.aggarray(dd.id_depto_origen)
                  into
                    va_id_deptos_lbs
                  
                  from param.tdepto_depto dd
                  inner join param.tdepto d on d.id_depto = dd.id_depto_origen
                  inner join segu.tsubsistema s on s.id_subsistema = d.id_subsistema and s.codigo = 'TES'
                  where  dd.id_depto_destino = v_parametros.id_depto_conta
                         and  d.modulo = 'LB';
                  
                  
                   FOR v_registros in (
                                       select *
                                       from tes.tcuenta_bancaria cb
                                       inner join tes.tdepto_cuenta_bancaria dep on dep.id_cuenta_bancaria = cb.id_cuenta_bancaria
                                       where dep.id_depto = ANY(va_id_deptos_lbs)
                   
                   
                                      ) LOOP
                                            
                                            
                  
                        -- insertar cuenta y calcular mayores ...
                         v_id_ajuste_det = conta.f_ajusta_tc_cuenta(p_id_usuario, 
                                                              v_id_ajuste, 
                                                              v_parametros.tipo,
                                                              NULL, --id_cuenta,
                                                              NULL, --id_auxiliar,
                                                              NULL, --id_partida_ingreso,
                                                              NULL, --id_partida_egreso,
                                                              v_registros.id_cuenta_bancaria,
                                                              NULL,                                                             
                                                              v_id_moneda_base, 
                                                              v_id_moneda_tri, 
                                                              v_parametros.fecha,
                                                              v_parametros.id_depto_conta,
                                                              v_depto_inter,
                                                              true);
                                                              
                                                                   
                                                              
                  END LOOP;
                  
            
            
            
            
            ELSEIF v_parametros.tipo = 'cajas'   THEN
              raise exception 'TODO, no se definio el proceso de cajas';
            ELSEIF v_parametros.tipo = 'manual'  THEN
              raise notice 'tipo manual no tiene registros previos';
            ELSE 
               raise exception 'Tipo no reconocido';
            END IF;
             -- listamos todas las cuentas de efectivo de la gestion
           
            
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Ajuste almacenado(a) con exito (id_ajuste'||v_id_ajuste||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_ajuste',v_id_ajuste::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_AJT_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		10-12-2015 15:16:16
	***********************************/

	elsif(p_transaccion='CONTA_AJT_MOD')then

		begin
        
        
            raise exception 'Los ajustes no pueden editarce';
        
            /*
			--Sentencia de la modificacion
			update conta.tajuste set
			fecha = v_parametros.fecha,
			id_depto_conta = v_parametros.id_depto_conta,
			estado = v_parametros.estado,
			obs = v_parametros.obs,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_ajuste=v_parametros.id_ajuste;*/
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Ajuste modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_ajuste',v_parametros.id_ajuste::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_AJT_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		10-12-2015 15:16:16
	***********************************/

	elsif(p_transaccion='CONTA_AJT_ELI')then

		begin
			
            select 
              *
            into
              v_registros
            from  conta.tajuste a 
            where  a.id_ajuste = v_parametros.id_ajuste;
            
            IF v_registros.estado  != 'borrador' THEN
               raise exception 'no puede eliminar ajustes que no esten en borrador';
            END IF;
            
            
            --elimina el detalle del ajuste
            delete from conta.tajuste_det ajd
            where id_ajuste=v_parametros.id_ajuste;
            
            --Sentencia de la eliminacion
			delete from conta.tajuste
            where id_ajuste=v_parametros.id_ajuste;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Ajuste eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_ajuste',v_parametros.id_ajuste::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
    
    /*********************************    
 	#TRANSACCION:  'CONTA_GENCBTEAJU_IME'
 	#DESCRIPCION:	Genera comprobante de ajuste
 	#AUTOR:		admin	
 	#FECHA:		10-12-2015 15:16:16
	***********************************/

	elsif(p_transaccion='CONTA_GENCBTEAJU_IME')then

		begin
        
        
              v_sw_cambio = true;
             --recuperamos datos del ajuste 
             
             select 
                 a.*,
                 dep.prioridad 
              into 
               v_registros
              from conta.tajuste a
              inner join param.tdepto dep on a.id_depto_conta = dep.id_depto
              where  a.id_ajuste = v_parametros.id_ajuste;
              
              
               --obtener el periodo a partir de la fecha
    
               v_rec_periodo = param.f_get_periodo_gestion(v_registros.fecha);
               
               --recueprar centro de costo del departamento
             
              SELECT 
                  ps_id_centro_costo 
                 into 
                   v_id_centro_costo_depto 
               FROM conta.f_get_config_relacion_contable('CCDEPCON', -- relacion contable que almacena los centros de costo por departamento
                                                         v_rec_periodo.po_id_gestion,  
                                                         v_registros.id_depto_conta, 
                                                         NULL);  --id_dento_costo
              
              
			
              --verificamos si es un depto internacional
              v_conta_prioridad_depto_inter = pxp.f_get_variable_global('conta_prioridad_depto_inter');
              
              IF  v_registros.prioridad::varchar =   v_conta_prioridad_depto_inter THEN
                 v_depto_inter = true;
                 v_codigo_clase_cbte = 'ESPECIAL';
              ELSE
                 v_depto_inter =  false;
                  v_codigo_clase_cbte = 'DIARIO';
              END IF;
              
          
           
           --  array de monedas para los que se va generar el cbte
           
            v_id_moneda_base = param.f_get_moneda_base();
            v_id_moneda_tri  = param.f_get_moneda_triangulacion();
            
            va_id_moneda[0] = v_id_moneda_base;
            va_id_moneda[1] = v_id_moneda_tri;
            
        
           -- For listado de monedas
           
           FOREACH v_id_moneda  IN ARRAY va_id_moneda   LOOP
             
             
                    ----------------------------------- 
                    -- genera cabecera del comprobante
                    -----------------------------------
                    --TODO recueprar ID configuracion cambiaria
                    --  obtener id_subsistema
    
                     Select  id_subsistema  into   v_id_subsistema 
                     from  segu.tsubsistema sub 
                     where sub.estado_reg = 'activo' 
                        and sub.codigo =  'CONTA';
                        
                    IF v_id_subsistema is null THEN                      
                           raise exception 'No existe un subsistema con el codigo CONTA';
                    END IF;  
    
                    --  obtener id clase comprobante
                    Select  
                        id_clase_comprobante  into   v_id_clase_comprobante 
                    from  conta.tclase_comprobante cl 
                    where cl.estado_reg = 'activo' 
                      and cl.codigo = v_codigo_clase_cbte;
                      
                    IF v_id_moneda = v_id_moneda_base THEN
                      v_tipo_cambio_1 = 1;
                      v_tipo_cambio_2 = 0;                    
                    ELSE
                      v_tipo_cambio_1 = 0;
                      v_tipo_cambio_2 = 1;
                    END IF; 
                    
                    -- recuepra configuracion cambiaria,  no se usas 
                    -- es solo apra cumplir con el inner join ya qu elos valores son cambiados mas adelante
                      
                      SELECT  
                         po_id_config_cambiaria ,
                         po_valor_tc1 ,
                         po_valor_tc2 ,
                         po_tc1 ,
                         po_tc2 
                       into
                        v_registros_config
                       FROM conta.f_get_tipo_cambio_segu_config(v_id_moneda, 
                                                                v_registros.fecha,
                                                                'nacional',
                                                                'si'); 
                      
                      
                      
                    IF v_id_clase_comprobante is null THEN                    
                         raise exception 'No existe un comprobante de la clase codigo : %',v_codigo_clase_cbte;                     
                    END IF;
                    
                     INSERT INTO  conta.tint_comprobante
                            (
                              id_usuario_reg,
                              fecha_reg,
                              estado_reg,
                              id_clase_comprobante,
                              id_subsistema,
                              id_depto,
                              id_depto_libro,
                              id_moneda,
                              id_periodo,
                              momento,
                              momento_comprometido,
                              momento_ejecutado,
                              momento_pagado,
                              id_plantilla_comprobante,
                              glosa1,
                              beneficiario,
                              tipo_cambio,
                              tipo_cambio_2,
                              fecha,
                              funcion_comprobante_validado,
                              funcion_comprobante_eliminado,
                              id_cuenta_bancaria, 
                              id_cuenta_bancaria_mov, 
                              nro_cheque, 
                              nro_cuenta_bancaria_trans,
                              nro_tramite,
                             
                              temporal,
                              fecha_costo_ini,
                              fecha_costo_fin,
                              localidad,
                              sw_editable,
                              id_config_cambiaria,
                              id_moneda_tri,
                              sw_tipo_cambio,
                              id_ajuste
                                     
                            ) 
                            VALUES (
                              p_id_usuario,
                              now(),
                             'borrador',
                              v_id_clase_comprobante,
                              v_id_subsistema, --TODO agregar a la interface de plantilla,
                              v_registros.id_depto_conta,
                              NULL,
                              v_id_moneda,   -- moneda base o moenda de triangulacion 
                              v_rec_periodo.po_id_periodo,
                              'contable', -- contable, o presupuestario
                              'no', -- momento_comprometido,
                              'no', -- momento_ejecutado,
                              'no', --  momento_pagado,
                              NULL,
                              'Ajuste por diferencia cambiaria',
                              '',
                              v_tipo_cambio_1,
                              v_tipo_cambio_2,
                              v_registros.fecha,
                              NULL,
                              NULL,
                              NULL, -- id_cuenta_bancaria, 
                              NULL, -- id_cuenta_bancaria_mov, 
                              NULL, -- nro_cheque, 
                              NULL, -- nro_cuenta_bancaria_trans,
                              NULL, -- nro_tramite,
                            
                              'no', -- temporal,
                              NULL, -- fecha_costo_ini,
                              NULL, -- fecha_costo_fin,
                              'nacional',
                              'no',
                              v_registros_config.po_id_config_cambiaria,
                              v_id_moneda_tri,
                              'si',
                              v_registros.id_ajuste
                                                            
                            ) RETURNING id_int_comprobante into v_id_int_comprobante;
                    
               
                    -------------------------------------
                    -- genera cuerpo del comprobante
                    -------------------------------------
                       v_tipo_trans = 'ganacia';
                       
                       v_sw_trans = false;
                       
                      
                      
                    --   For listado de ajuste  según moneda del cbte solo los ajustes diferentes de cero
                       FOR v_registros_det in (
                        						select ad.*,
                                                       ctc.incremento,
                                                       ctc.id_cofig_tipo_cuenta,
                                                       CASE  
                                                         WHEN ad.dif_mb != 0 THEN
                                                               ad.dif_mb
                                                         ELSE
                                                               ad.dif_mt    
                                                         END  as  diferencia
                                                from conta.tajuste_det ad
                                                inner join conta.tcuenta c on c.id_cuenta = ad.id_cuenta
                                                inner join conta.tconfig_tipo_cuenta ctc on ctc.tipo_cuenta = c.tipo_cuenta
                                                where      ad.id_ajuste = v_registros.id_ajuste
                                                      and ad.revisado = 'si'
                                                      and  
                                                          CASE 
                                                           WHEN v_id_moneda =  v_id_moneda_base THEN
                                                               ad.dif_mb != 0
                                                           ELSE
                                                               ad.dif_mt != 0    
                                                           END
                                                      
                       							) LOOP
                               
                                  
                                    v_sw_trans = true;
                                    v_monto_debe_mb = 0;
                                    v_monto_haber_mb = 0;
                                    v_monto_debe_mt = 0;
                                    v_monto_haber_mt = 0;
                                    v_monto_debe = 0;
                                    v_monto_haber = 0;
                               
                                  --  define si es  perdida o ganancia 
                                  IF  v_registros_det.incremento = 'debe'   THEN
                                   
                                       if  v_registros_det.diferencia > 0 then
                                            
                                            v_tipo_trans = 'ganacia';
                                            
                                            IF v_id_moneda =  v_id_moneda_base  THEN
                                                  v_monto_debe_mb = (v_registros_det.diferencia);
                                            ELSE  
                                                  v_monto_debe_mt =  (v_registros_det.diferencia);                                                  
                                            END IF;
                                            
                                            v_monto_debe =  (v_registros_det.diferencia); 
                                            
                                       else
                                            v_tipo_trans = 'perdida';
                                            IF v_id_moneda =  v_id_moneda_base  THEN
                                                  v_monto_haber_mb = (v_registros_det.diferencia)*(-1);
                                            ELSE  
                                                  v_monto_haber_mt =  (v_registros_det.diferencia)*(-1);                                                  
                                            END IF;
                                            
                                            v_monto_haber =  (v_registros_det.diferencia)*(-1); 
                                       end if;
                                  ELSE
                                       if  v_registros_det.diferencia > 0 then
                                            v_tipo_trans = 'perdida';
                                            IF v_id_moneda =  v_id_moneda_base  THEN
                                                  v_monto_haber_mb = (v_registros_det.diferencia);
                                            ELSE  
                                                  v_monto_haber_mt =  (v_registros_det.diferencia);                                                  
                                            END IF;
                                            v_monto_haber =  (v_registros_det.diferencia); 
                                       else
                                            
                                            v_tipo_trans = 'ganacia';
                                            
                                            IF v_id_moneda =  v_id_moneda_base  THEN
                                                  v_monto_debe_mb = (v_registros_det.diferencia)*(-1);
                                            ELSE  
                                                  v_monto_debe_mt =  (v_registros_det.diferencia)*(-1);                                                  
                                            END IF;
                                            v_monto_debe =  (v_registros_det.diferencia)*(-1); 
                                       end if;
                                  END IF;                 
                                
                               
                                IF  v_tipo_trans = 'ganacia' THEN
                                   v_relacion = 'GAN-RD'; 
                                   v_id_partida = v_registros_det.id_partida_ingreso;
                                  
                                 ELSE
                                   v_relacion = 'PER-RD';
                                   v_id_partida = v_registros_det.id_partida_egreso;
                                
                                 END IF;
                               
                               SELECT 
                                  * 
                                 into 
                                   v_registros_rel
                               FROM conta.f_get_config_relacion_contable(v_relacion, -- relacion contable que almacena los centros de costo por departamento
                                                                         v_rec_periodo.po_id_gestion,  
                                                                         v_registros.id_depto_conta, 
                                                                         NULL);  --id_centro_costo 
                                                           
                                                         
                                 ---------------------------------------------
                                 --  inserta transaccion de  perdida/ganancia
                                 ---------------------------------------------
                                 
                                            
                                  insert into conta.tint_transaccion(
                                                                  id_partida,
                                                                  id_centro_costo,
                                                                  estado_reg,
                                                                  id_cuenta,
                                                                  glosa,
                                                                  id_int_comprobante,
                                                                  id_auxiliar,
                                                                  
                                                                  importe_debe,
                                                                  importe_haber,
                                                                  importe_gasto,
                                                                  importe_recurso,
                                                                  
                                                                  importe_debe_mb,
                                                                  importe_haber_mb,
                                                                  importe_gasto_mb,
                                                                  importe_recurso_mb,
                                                                  
                                                                  importe_debe_mt,
                                                                  importe_haber_mt,
                                                                  importe_gasto_mt,
                                                                  importe_recurso_mt,
                                                                  
                                                                  id_usuario_reg,
                                                                  fecha_reg,
                                                                  tipo_cambio,
                                                                  tipo_cambio_2,
                                                                  id_moneda,
                                                                  id_moneda_tri,
                                                                  actualizacion
                                                                  
                                                              ) values(
                                                                  v_registros_rel.ps_id_partida,
                                                                  v_id_centro_costo_depto,
                                                                  'activo',
                                                                  v_registros_rel.ps_id_cuenta,
                                                                  'actulización por ajustes diferencia cambiaria',
                                                                  v_id_int_comprobante,
                                                                  NULL,
                                                                  
                                                                  v_monto_debe,
                                                                  v_monto_haber,
                                                                  v_monto_debe,
                                                                  v_monto_haber,
                                                                  
                                                                  v_monto_debe_mb,
                                                                  v_monto_haber_mb,
                                                                  v_monto_debe_mb,
                                                                  v_monto_haber_mb,
                                                                  
                                                                  v_monto_debe_mt,
                                                                  v_monto_haber_mt,
                                                                  v_monto_debe_mt,
                                                                  v_monto_haber_mt,
                                                                 
                                                                  p_id_usuario,
                                                                  now(),
                                                                  v_tipo_cambio_1,
                                                                  v_tipo_cambio_2,
                                                                  v_id_moneda,
                                                                  v_id_moneda_tri,
                                                                  'si' --actulizacion
                                                              );   
                              
                                --------------------------------------------------
                                --  insertar transaccion para la cuenta ajustada
                                --------------------------------------------------
                                v_sw_cambio = false;
                                 insert into conta.tint_transaccion(
                                                                  id_partida,
                                                                  id_centro_costo,
                                                                  estado_reg,
                                                                  id_cuenta,
                                                                  glosa,
                                                                  id_int_comprobante,
                                                                  id_auxiliar,
                                                                  
                                                                  importe_debe,
                                                                  importe_haber,
                                                                  importe_gasto,
                                                                  importe_recurso,
                                                                  
                                                                  importe_debe_mb,
                                                                  importe_haber_mb,
                                                                  importe_gasto_mb,
                                                                  importe_recurso_mb,
                                                                  
                                                                  importe_debe_mt,
                                                                  importe_haber_mt,
                                                                  importe_gasto_mt,
                                                                  importe_recurso_mt,
                                                                  
                                                                  id_usuario_reg,
                                                                  fecha_reg,
                                                                  tipo_cambio,
                                                                  tipo_cambio_2,
                                                                  id_moneda,
                                                                  id_moneda_tri,
                                                                  actualizacion
                                                                  
                                                              ) values(
                                                                  v_id_partida,
                                                                  v_id_centro_costo_depto,
                                                                  'activo',
                                                                  v_registros_det.id_cuenta,
                                                                  'actulización por ajustes diferencia cambiaria',
                                                                  v_id_int_comprobante,
                                                                  v_registros_det.id_auxiliar,
                                                                  v_monto_haber,
                                                                  v_monto_debe,
                                                                  v_monto_haber,
                                                                  v_monto_debe,
                                                                  
                                                                  v_monto_haber_mb,
                                                                  v_monto_debe_mb,
                                                                  v_monto_haber_mb,
                                                                  v_monto_debe_mb,
                                                                  
                                                                  v_monto_haber_mt,
                                                                  v_monto_debe_mt,
                                                                  v_monto_haber_mt,
                                                                  v_monto_debe_mt,
                                                                 
                                                                 
                                                                  p_id_usuario,
                                                                  now(),
                                                                  v_tipo_cambio_1,
                                                                  v_tipo_cambio_2,
                                                                  v_id_moneda,
                                                                  v_id_moneda_tri,
                                                                  'si' --actulizacion
                                                              );   
                              
                                
                      END LOOP;
                      
                      
                     if not  v_sw_trans then                     
                        delete from conta.tint_comprobante where id_int_comprobante = v_id_int_comprobante;
                     end if;
                     
                     
             END LOOP;
             
             
            
             IF  v_sw_cambio  then
               raise exception 'No tiene ningun ajuste habilitado';
             end if;
           
             -- TODO  cambiar estado del ajuste  
             /*
             update conta.tajuste set
               estado = 'procesado'
             where id_ajuste = v_registros.id_ajuste;*/
               
             
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cbtes generados para ajuste por mayores)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_ajuste',v_parametros.id_ajuste::varchar);
              
        
            --Devuelve la respuesta
            return v_resp;

		end;
    
        
	else
     
    	raise exception 'Transaccion inexistente: %',p_transaccion;

	end if;

EXCEPTION
				
	WHEN OTHERS THEN
		v_resp='';
		v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
		v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
		v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
		raise exception '%',v_resp;
				        
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;