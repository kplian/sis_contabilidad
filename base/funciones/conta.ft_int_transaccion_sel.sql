--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_int_transaccion_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_int_transaccion_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tint_transaccion'
 AUTOR: 		 (RAC)
 FECHA:	        01-09-2013 18:10:12
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
    v_cuentas			varchar;
    v_ordenes			varchar;
    v_tipo_cc			varchar;
    v_filtro_cuentas	varchar;
    v_filtro_ordenes	varchar;
    v_filtro_tipo_cc	varchar;
    v_filtro			varchar;
			    
BEGIN

	v_nombre_funcion = 'conta.ft_int_transaccion_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_INTRANSA_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		01-09-2013 18:10:12
	***********************************/

	if(p_transaccion='CONTA_INTRANSA_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
                            transa.id_int_transaccion,
                            transa.id_partida,
                            transa.id_centro_costo,
                            transa.id_partida_ejecucion,
                            transa.estado_reg,
                            transa.id_int_transaccion_fk,
                            transa.id_cuenta,
                            transa.glosa,
                            transa.id_int_comprobante,
                            transa.id_auxiliar,
                            transa.id_usuario_reg,
                            transa.fecha_reg,
                            transa.id_usuario_mod,
                            transa.fecha_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                            CASE par.sw_movimiento
                                WHEN ''flujo'' THEN
                                    ''(F) ''||par.codigo || '' - '' || par.nombre_partida 
                                ELSE
                                    par.codigo || '' - '' || par.nombre_partida 
                                END  as desc_partida,
                            
                            cc.codigo_cc as desc_centro_costo,
                            cue.nro_cuenta || '' - '' || cue.nombre_cuenta as desc_cuenta,
                            aux.codigo_auxiliar || '' - '' || aux.nombre_auxiliar as desc_auxiliar,
                            par.sw_movimiento as tipo_partida,
                            ot.id_orden_trabajo,
                            ot.desc_orden,
                            transa.importe_debe,	
                            transa.importe_haber,
                            transa.importe_gasto,
                            transa.importe_recurso,
                            transa.importe_debe_mb,	
                            transa.importe_haber_mb,
                            transa.importe_gasto_mb,
                            transa.importe_recurso_mb,
                            transa.banco,
                            transa.forma_pago,
                            transa.nombre_cheque_trans,
                            transa.nro_cuenta_bancaria_trans,
                            transa.nro_cheque,
                            transa.importe_debe_mt,	
                            transa.importe_haber_mt,
                            transa.importe_gasto_mt,
                            transa.importe_recurso_mt,
                            
                            transa.importe_debe_ma,	
                            transa.importe_haber_ma,
                            transa.importe_gasto_ma,
                            transa.importe_recurso_ma,
                            
                            
                            transa.id_moneda_tri,
                            transa.id_moneda_act,
                            transa.id_moneda,
                            transa.tipo_cambio,
                            transa.tipo_cambio_2,
                            transa.tipo_cambio_3,
                            transa.actualizacion,
                            transa.triangulacion,
                            suo.id_suborden,
                            (''(''||suo.codigo||'') ''||suo.nombre)::varchar as desc_suborden,
                            ot.codigo as codigo_ot,
                            cp.codigo_categoria::varchar
                        from conta.tint_transaccion transa
						inner join segu.tusuario usu1 on usu1.id_usuario = transa.id_usuario_reg
                        inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
						left join segu.tusuario usu2 on usu2.id_usuario = transa.id_usuario_mod
						left join pre.tpartida par on par.id_partida = transa.id_partida
						left join pre.vpresupuesto_cc cc on cc.id_centro_costo = transa.id_centro_costo
						left join conta.tauxiliar aux on aux.id_auxiliar = transa.id_auxiliar
                        left join conta.torden_trabajo ot on ot.id_orden_trabajo =  transa.id_orden_trabajo
                        left join conta.tsuborden suo on suo.id_suborden =  transa.id_suborden
                        left join pre.vcategoria_programatica cp ON cp.id_categoria_programatica = cc.id_categoria_prog
                        
                        
				        where ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_INTRANSA_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		01-09-2013 18:10:12
	***********************************/

	elsif(p_transaccion='CONTA_INTRANSA_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select 
                          count(transa.id_int_transaccion) as total,
                          sum(transa.importe_debe) as total_debe,
                          sum(transa.importe_haber) as total_haber,
                          sum(transa.importe_debe_mb) as total_debe_mb,
                          sum(transa.importe_haber_mb) as total_haber_mb,
                          sum(transa.importe_debe_mt) as total_debe_mt,
                          sum(transa.importe_haber_mt) as total_haber_mt,
                          sum(transa.importe_debe_ma) as total_debe_ma,
                          sum(transa.importe_haber_ma) as total_haber_ma,
                          sum(transa.importe_gasto) as total_gasto,
                          sum(transa.importe_recurso) as total_recurso
					     from conta.tint_transaccion transa
						inner join segu.tusuario usu1 on usu1.id_usuario = transa.id_usuario_reg
                        inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
						left join segu.tusuario usu2 on usu2.id_usuario = transa.id_usuario_mod
						left join pre.tpartida par on par.id_partida = transa.id_partida
						left join pre.vpresupuesto_cc cc on cc.id_centro_costo = transa.id_centro_costo
						left join conta.tauxiliar aux on aux.id_auxiliar = transa.id_auxiliar
                        left join conta.torden_trabajo ot on ot.id_orden_trabajo =  transa.id_orden_trabajo
                        left join conta.tsuborden suo on suo.id_suborden =  transa.id_suborden
                        left join pre.vcategoria_programatica cp ON cp.id_categoria_programatica = cc.id_categoria_prog
                        
                        where  ';
			
            
           
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;
 raise notice '%',v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;
	/*********************************    
 	#TRANSACCION:  'CONTA_INTMAY_SEL'
 	#DESCRIPCION:	listado de transacicones para el mayor
 	#AUTOR:		rac	
 	#FECHA:		24-04-2015 18:10:12
	***********************************/

	elsif(p_transaccion='CONTA_INTMAY_SEL')then
     				
    	begin
        
            v_cuentas = '0';
            v_ordenes = '0';
            v_tipo_cc = '0';
            v_filtro_cuentas = '0=0';
            v_filtro_ordenes = '0=0';
            v_filtro_tipo_cc = '0=0';
    		
             IF  pxp.f_existe_parametro(p_tabla,'id_cuenta')  THEN
             
                  IF v_parametros.id_cuenta is not NULL THEN
                
                      WITH RECURSIVE cuenta_rec (id_cuenta, id_cuenta_padre) AS (
                        SELECT cue.id_cuenta, cue.id_cuenta_padre
                        FROM conta.tcuenta cue
                        WHERE cue.id_cuenta = v_parametros.id_cuenta and cue.estado_reg = 'activo'
                      UNION ALL
                        SELECT cue2.id_cuenta, cue2.id_cuenta_padre
                        FROM cuenta_rec lrec 
                        INNER JOIN conta.tcuenta cue2 ON lrec.id_cuenta = cue2.id_cuenta_padre
                        where cue2.estado_reg = 'activo'
                      )
                    SELECT  pxp.list(id_cuenta::varchar) 
                      into 
                        v_cuentas
                    FROM cuenta_rec;
                    
                    
                    
                    v_filtro_cuentas = ' transa.id_cuenta in ('||v_cuentas||') ';
                END IF;
                
            END IF;
            
            IF  pxp.f_existe_parametro(p_tabla,'id_orden_trabajo')  THEN
             
                  IF v_parametros.id_orden_trabajo is not NULL THEN
                
            
                    IF v_parametros.id_orden_trabajo != 0 THEN
                          WITH RECURSIVE orden_rec (id_orden_trabajo, id_orden_trabajo_fk) AS (
                            SELECT cue.id_orden_trabajo, cue.id_orden_trabajo_fk
                            FROM conta.torden_trabajo cue
                            WHERE cue.id_orden_trabajo = v_parametros.id_orden_trabajo and cue.estado_reg = 'activo'
                          UNION ALL
                            SELECT cue2.id_orden_trabajo, cue2.id_orden_trabajo_fk
                            FROM orden_rec lrec 
                            INNER JOIN conta.torden_trabajo cue2 ON lrec.id_orden_trabajo = cue2.id_orden_trabajo_fk
                            where cue2.estado_reg = 'activo'
                          )
                        SELECT  pxp.list(id_orden_trabajo::varchar) 
                          into 
                            v_ordenes
                        FROM orden_rec;
                        
                        v_filtro_ordenes = ' transa.id_orden_trabajo in ('||v_ordenes||') ';
                    ELSE
                        --cuando la orden de trabajo es cero, se requiere msotrar las ordenes de trabajo nulas
                        v_filtro_ordenes = ' transa.id_orden_trabajo is null ';
                    
                    END IF;
                END IF;
            END IF;
            
            
            IF  pxp.f_existe_parametro(p_tabla,'id_tipo_cc')  THEN
             
                  IF v_parametros.id_tipo_cc is not NULL THEN
                
                      WITH RECURSIVE tipo_cc_rec (id_tipo_cc, id_tipo_cc_fk) AS (
                        SELECT tcc.id_tipo_cc, tcc.id_tipo_cc_fk
                        FROM param.ttipo_cc tcc
                        WHERE tcc.id_tipo_cc = v_parametros.id_tipo_cc and tcc.estado_reg = 'activo'
                      UNION ALL
                        SELECT tcc2.id_tipo_cc, tcc2.id_tipo_cc_fk
                        FROM tipo_cc_rec lrec 
                        INNER JOIN param.ttipo_cc tcc2 ON lrec.id_tipo_cc = tcc2.id_tipo_cc_fk
                        where tcc2.estado_reg = 'activo'
                      )
                    SELECT  pxp.list(id_tipo_cc::varchar) 
                      into 
                        v_tipo_cc
                    FROM tipo_cc_rec;
                    
                    
                    
                    v_filtro_tipo_cc = ' cc.id_tipo_cc in ('||v_tipo_cc||') ';
                END IF;
             END IF;
            
           
            
            --Sentencia de la consulta
			v_consulta:='select
						transa.id_int_transaccion,
						transa.id_partida,
						transa.id_centro_costo,
						transa.id_partida_ejecucion,
						transa.estado_reg,
						transa.id_int_transaccion_fk,
						transa.id_cuenta,
						transa.glosa,
						transa.id_int_comprobante,
						transa.id_auxiliar,
						transa.id_usuario_reg,
						transa.fecha_reg,
						transa.id_usuario_mod,
						transa.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        COALESCE(transa.importe_debe_mb,0) as importe_debe_mb,
                        COALESCE(transa.importe_haber_mb,0) as importe_haber_mb, 
                       	COALESCE(transa.importe_gasto_mb,0) as importe_gasto_mb,
						COALESCE(transa.importe_recurso_mb,0) as importe_recurso_mb,
                        
                        COALESCE(transa.importe_debe_mt,0) as importe_debe_mt,
                        COALESCE(transa.importe_haber_mt,0) as importe_haber_mt, 
                       	COALESCE(transa.importe_gasto_mt,0) as importe_gasto_mt,
						COALESCE(transa.importe_recurso_mt,0) as importe_recurso_mt,
                        
                        COALESCE(transa.importe_debe_ma,0) as importe_debe_ma,
                        COALESCE(transa.importe_haber_ma,0) as importe_haber_ma, 
                       	COALESCE(transa.importe_gasto_ma,0) as importe_gasto_ma,
						COALESCE(transa.importe_recurso_ma,0) as importe_recurso_ma,
						
                        CASE par.sw_movimiento
                        	WHEN ''flujo'' THEN
								''(F) ''||par.codigo || '' - '' || par.nombre_partida 
                            ELSE
                            	par.codigo || '' - '' || par.nombre_partida 
                        	END  as desc_partida,
                        
						cc.codigo_cc as desc_centro_costo,
						cue.nro_cuenta || '' - '' || cue.nombre_cuenta as desc_cuenta,
						aux.codigo_auxiliar || '' - '' || aux.nombre_auxiliar as desc_auxiliar,
                        par.sw_movimiento as tipo_partida,
                        ot.id_orden_trabajo,
                        ot.desc_orden,
                        icbte.nro_cbte,
                        icbte.nro_tramite,
                        dep.nombre_corto,
                        icbte.fecha,
                        icbte.glosa1,
                        icbte.id_proceso_wf,
                        icbte.id_estado_wf
                        
						from conta.tint_transaccion transa
                        inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                        inner join param.tdepto dep on dep.id_depto = icbte.id_depto
                        inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
						inner join segu.tusuario usu1 on usu1.id_usuario = transa.id_usuario_reg
                       
                        inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                        inner join conta.tconfig_tipo_cuenta ctc on ctc.tipo_cuenta = cue.tipo_cuenta                        
                        inner join conta.tconfig_subtipo_cuenta csc on csc.id_config_subtipo_cuenta = cue.id_config_subtipo_cuenta
						left join segu.tusuario usu2 on usu2.id_usuario = transa.id_usuario_mod
						left join pre.tpartida par on par.id_partida = transa.id_partida
						left join param.vcentro_costo cc on cc.id_centro_costo = transa.id_centro_costo
						left join conta.tauxiliar aux on aux.id_auxiliar = transa.id_auxiliar
                        left join conta.torden_trabajo ot on ot.id_orden_trabajo =  transa.id_orden_trabajo
				        where icbte.estado_reg = ''validado'' 
                              and ' ||v_filtro_cuentas||' 
                              and '||v_filtro_ordenes||' 
                              and '||v_filtro_tipo_cc||' and';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            raise notice '%', v_consulta;
			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_INTMAY_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		01-09-2013 18:10:12
	***********************************/

	elsif(p_transaccion='CONTA_INTMAY_CONT')then

		begin
            v_cuentas = '0';
            v_ordenes = '0';
            v_tipo_cc = '0';
            v_filtro_cuentas = '0=0';
            v_filtro_ordenes = '0=0';
            v_filtro_tipo_cc = '0=0';
    		
             IF  pxp.f_existe_parametro(p_tabla,'id_cuenta')  THEN
             
                  IF v_parametros.id_cuenta is not NULL THEN
                
                      WITH RECURSIVE cuenta_rec (id_cuenta, id_cuenta_padre) AS (
                        SELECT cue.id_cuenta, cue.id_cuenta_padre
                        FROM conta.tcuenta cue
                        WHERE cue.id_cuenta = v_parametros.id_cuenta and cue.estado_reg = 'activo'
                      UNION ALL
                        SELECT cue2.id_cuenta, cue2.id_cuenta_padre
                        FROM cuenta_rec lrec 
                        INNER JOIN conta.tcuenta cue2 ON lrec.id_cuenta = cue2.id_cuenta_padre
                        where cue2.estado_reg = 'activo'
                      )
                    SELECT  pxp.list(id_cuenta::varchar) 
                      into 
                        v_cuentas
                    FROM cuenta_rec;
                    
                    
                    
                    v_filtro_cuentas = ' transa.id_cuenta in ('||v_cuentas||') ';
                END IF;
                
            END IF;
            
             IF  pxp.f_existe_parametro(p_tabla,'id_orden_trabajo')  THEN
             
                  IF v_parametros.id_orden_trabajo is not NULL THEN
                
            
                    IF v_parametros.id_orden_trabajo != 0 THEN
                          WITH RECURSIVE orden_rec (id_orden_trabajo, id_orden_trabajo_fk) AS (
                            SELECT cue.id_orden_trabajo, cue.id_orden_trabajo_fk
                            FROM conta.torden_trabajo cue
                            WHERE cue.id_orden_trabajo = v_parametros.id_orden_trabajo and cue.estado_reg = 'activo'
                          UNION ALL
                            SELECT cue2.id_orden_trabajo, cue2.id_orden_trabajo_fk
                            FROM orden_rec lrec 
                            INNER JOIN conta.torden_trabajo cue2 ON lrec.id_orden_trabajo = cue2.id_orden_trabajo_fk
                            where cue2.estado_reg = 'activo'
                          )
                        SELECT  pxp.list(id_orden_trabajo::varchar) 
                          into 
                            v_ordenes
                        FROM orden_rec;
                        
                        v_filtro_ordenes = ' transa.id_orden_trabajo in ('||v_ordenes||') ';
                    ELSE
                        --cuando la orden de trabajo es cero, se requiere msotrar las ordenes de trabajo nulas
                        v_filtro_ordenes = ' transa.id_orden_trabajo is null ';
                    
                    END IF;
                END IF;
            END IF;
            
            
            IF  pxp.f_existe_parametro(p_tabla,'id_tipo_cc')  THEN
             
                  IF v_parametros.id_tipo_cc is not NULL THEN
                
                      WITH RECURSIVE tipo_cc_rec (id_tipo_cc, id_tipo_cc_fk) AS (
                        SELECT tcc.id_tipo_cc, tcc.id_tipo_cc_fk
                        FROM param.ttipo_cc tcc
                        WHERE tcc.id_tipo_cc = v_parametros.id_tipo_cc and tcc.estado_reg = 'activo'
                      UNION ALL
                        SELECT tcc2.id_tipo_cc, tcc2.id_tipo_cc_fk
                        FROM tipo_cc_rec lrec 
                        INNER JOIN param.ttipo_cc tcc2 ON lrec.id_tipo_cc = tcc2.id_tipo_cc_fk
                        where tcc2.estado_reg = 'activo'
                      )
                    SELECT  pxp.list(id_tipo_cc::varchar) 
                      into 
                        v_tipo_cc
                    FROM tipo_cc_rec;
                    
                    
                    
                    v_filtro_tipo_cc = ' cc.id_tipo_cc in ('||v_tipo_cc||') ';
                END IF;
             END IF;
            
            --RAC 16´/05/2017 quite esta suma de la consulta me parece incorecta, pero no estoy 100% seguro
            
            /*
            
            sum(CASE cue.valor_incremento 
                        	WHEN ''negativo'' THEN
								COALESCE(transa.importe_debe_mb*-1,0)
                            ELSE
                            	COALESCE(transa.importe_debe_mb,0)
                        	END)  as total_debe,
            */
        
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select 
                        count(transa.id_int_transaccion) as total,
                         
                        
                        sum(COALESCE(transa.importe_debe_mb,0)) as total_debe,
                        sum(COALESCE(transa.importe_haber_mb,0)) as total_haber,
                        sum(COALESCE(transa.importe_debe_mt,0)) as total_debe_mt,
                        sum(COALESCE(transa.importe_haber_mt,0)) as total_haber_mt,
                        sum(COALESCE(transa.importe_debe_ma,0)) as total_debe_ma,
                        sum(COALESCE(transa.importe_haber_ma,0)) as total_haber_ma
                        
					    from conta.tint_transaccion transa
                        inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                        inner join param.tdepto dep on dep.id_depto = icbte.id_depto
                        inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
						inner join segu.tusuario usu1 on usu1.id_usuario = transa.id_usuario_reg
                       
                        inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                        inner join conta.tconfig_tipo_cuenta ctc on ctc.tipo_cuenta = cue.tipo_cuenta                        
                        inner join conta.tconfig_subtipo_cuenta csc on csc.id_config_subtipo_cuenta = cue.id_config_subtipo_cuenta
						left join segu.tusuario usu2 on usu2.id_usuario = transa.id_usuario_mod
						left join pre.tpartida par on par.id_partida = transa.id_partida
						left join param.vcentro_costo cc on cc.id_centro_costo = transa.id_centro_costo
						left join conta.tauxiliar aux on aux.id_auxiliar = transa.id_auxiliar
                        left join conta.torden_trabajo ot on ot.id_orden_trabajo =  transa.id_orden_trabajo
				        where icbte.estado_reg = ''validado'' 
                              and ' ||v_filtro_cuentas||' 
                              and '||v_filtro_ordenes||' 
                              and '||v_filtro_tipo_cc||' and';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;
            --raise notice '%',v_consulta;

			--Devuelve la respuesta
			return v_consulta;

		end;
    
    /*********************************    
 	#TRANSACCION:  'CONTA_INTANA_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		01-09-2013 18:10:12
	***********************************/

	elseif(p_transaccion='CONTA_INTANA_SEL')then
     				
    	begin
        
             if pxp.f_existe_parametro(p_tabla,'id_periodo') then
               v_filtro = ' id_periodo='||v_parametros.id_periodo::varchar;
             elseif pxp.f_existe_parametro(p_tabla,'fecha_ini') then
               v_filtro = ' fecha BETWEEN '''||v_parametros.fecha_ini||'''::date and '''||v_parametros.fecha_fin||'''::Date';
             else
                v_filtro = ' 0=0 ';
             end if;
             
         
    		--Sentencia de la consulta
			v_consulta:='SELECT
            				id_orden_trabajo, 
                            sum(importe_debe_mb) as importe_debe_mb,
                            sum(importe_haber_mb) as importe_haber_mb,
                            sum(importe_debe_mt) as importe_debe_mt,
                            sum(importe_haber_mt) as importe_haber_mt, 
                            sum(importe_debe_ma) as importe_debe_ma,
                            sum(importe_haber_ma) as importe_haber_ma,                            
                            codigo_ot::varchar,
                            desc_orden::varchar

                          FROM 
                            conta.vint_transaccion_analisis  v
                          where    '||v_parametros.id_tipo_cc::varchar||' =ANY(ids) and '||v_filtro|| ' and ';
                          
                          
              --Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
           
           
            v_consulta:=v_consulta||'
                            group by  
                                id_orden_trabajo,
                                codigo_ot,
                                desc_orden ';
                            
            
			--Definicion de la respuesta
			
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            raise notice '%',v_consulta;
			--Devuelve la respuesta
			return v_consulta;
						
		end;    
    
    /*********************************    
 	#TRANSACCION:  'CONTA_INTANA_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		01-09-2013 18:10:12
	***********************************/

	elsif(p_transaccion='CONTA_INTANA_CONT')then

		begin
        
             if pxp.f_existe_parametro(p_tabla,'id_periodo') then
               v_filtro = ' id_periodo='||v_parametros.id_periodo::varchar;
             elseif pxp.f_existe_parametro(p_tabla,'fecha_ini') then
               v_filtro = ' fecha BETWEEN '''||v_parametros.fecha_ini||'''::date and '''||v_parametros.fecha_fin||'''::Date';
             else
                v_filtro = ' 0=0 ';
             end if;
             
                          
             v_consulta:='WITH parcial AS (
                                            SELECT 
                                                      id_orden_trabajo as id_orden_trabajo,
                                                      sum(importe_debe_mb) as importe_debe_mb,
                                                      sum(importe_haber_mb) as importe_haber_mb,
                                                      sum(importe_debe_mt) as importe_debe_mt,
                                                      sum(importe_haber_mt) as importe_haber_mt,
                                                      sum(importe_debe_ma) as importe_debe_ma,
                                                      sum(importe_haber_ma) as importe_haber_ma
                                                   FROM 
                                                      conta.vint_transaccion_analisis  v
                                                   where    '||v_parametros.id_tipo_cc::varchar||' =ANY(ids) and '||v_filtro|| ' and ';   
                                             
             v_consulta:=v_consulta||v_parametros.filtro;                              
                                             
             v_consulta:= v_consulta|| 'group by  
                                                    id_orden_trabajo,
                                                    codigo_ot,
                                                    desc_orden  ) 
                                                                            
                                             SELECT 
                                                   count(id_orden_trabajo) as total,
                                                   sum(importe_debe_mb) as importe_debe_mb,
                                                   sum(importe_haber_mb) as importe_haber_mb,
                                                   sum(importe_debe_mt) as importe_debe_mt,
                                                   sum(importe_haber_mt) as importe_haber_mt,
                                                   sum(importe_debe_ma) as importe_debe_ma,
                                                   sum(importe_haber_ma) as importe_haber_ma
                                            FROM parcial';                      
             
            raise notice '%',v_consulta;
 
			--Devuelve la respuesta
			return v_consulta;

		end;
        
    /*********************************    
 	#TRANSACCION:  'CONTA_INTPAR_SEL'
 	#DESCRIPCION:	consulta de analisis de partidas por tipo_cc
 	#AUTOR:		admin	
 	#FECHA:		01-09-2013 18:10:12
	***********************************/

	elseif(p_transaccion='CONTA_INTPAR_SEL')then
     				
    	begin
        
             if pxp.f_existe_parametro(p_tabla,'id_periodo') then
               v_filtro = ' id_periodo='||v_parametros.id_periodo::varchar;
             elseif pxp.f_existe_parametro(p_tabla,'fecha_ini') then
               v_filtro = ' fecha BETWEEN '''||v_parametros.fecha_ini||'''::date and '''||v_parametros.fecha_fin||'''::Date';
             else
                v_filtro = ' 0=0 ';
             end if;
             
         
    		--Sentencia de la consulta
			v_consulta:='SELECT
            				id_partida, 
                            sum(importe_debe_mb) as importe_debe_mb,
                            sum(importe_haber_mb) as importe_haber_mb,
                            sum(importe_debe_mt) as importe_debe_mt,
                            sum(importe_haber_mt) as importe_haber_mt,
                            sum(importe_debe_ma) as importe_debe_ma,
                            sum(importe_haber_ma) as importe_haber_ma,                            
                            codigo_partida::varchar,
                            sw_movimiento::varchar,
                            descripcion_partida::varchar

                          FROM 
                            conta.vint_transaccion_analisis  v
                          where    '||v_parametros.id_tipo_cc::varchar||' =ANY(ids) and '||v_filtro|| ' and ';
                          
                          
              --Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
           
           
            v_consulta:=v_consulta||'
                            group by  
                                id_partida,
                                codigo_partida,
                                descripcion_partida,
                                sw_movimiento ';
                            
            
			--Definicion de la respuesta
			
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            
            raise notice '%',v_consulta;
			--Devuelve la respuesta
			return v_consulta;
						
		end;    
    
    /*********************************    
 	#TRANSACCION:  'CONTA_INTPAR_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		01-09-2013 18:10:12
	***********************************/

	elsif(p_transaccion='CONTA_INTPAR_CONT')then

		begin
        
             if pxp.f_existe_parametro(p_tabla,'id_periodo') then
               v_filtro = ' id_periodo='||v_parametros.id_periodo::varchar;
             elseif pxp.f_existe_parametro(p_tabla,'fecha_ini') then
               v_filtro = ' fecha BETWEEN '''||v_parametros.fecha_ini||'''::date and '''||v_parametros.fecha_fin||'''::Date';
             else
                v_filtro = ' 0=0 ';
             end if;
             
             
             v_consulta:='WITH parcial AS (
                                            SELECT 
                                                      id_partida as id_partida,
                                                      sum(importe_debe_mb) as importe_debe_mb,
                                                      sum(importe_haber_mb) as importe_haber_mb,
                                                      sum(importe_debe_mt) as importe_debe_mt,
                                                      sum(importe_haber_mt) as importe_haber_mt,
                                                      sum(importe_debe_ma) as importe_debe_ma,
                                                      sum(importe_haber_ma) as importe_haber_ma
                                                   FROM 
                                                      conta.vint_transaccion_analisis  v
                                                   where    '||v_parametros.id_tipo_cc::varchar||' =ANY(ids) and '||v_filtro|| ' and ';   
                                             
             v_consulta:=v_consulta||v_parametros.filtro;                              
                                             
             v_consulta:= v_consulta|| 'group by  
                                                      id_partida,
                                                      codigo_partida,
                                                      descripcion_partida,
                                                      sw_movimiento  ) 
                                                                            
                                             SELECT 
                                                   count(id_partida) as total,
                                                   sum(importe_debe_mb) as importe_debe_mb,
                                                   sum(importe_haber_mb) as importe_haber_mb,
                                                   sum(importe_debe_mt) as importe_debe_mt,
                                                   sum(importe_haber_mt) as importe_haber_mt,
                                                   sum(importe_debe_ma) as importe_debe_ma,
                                                   sum(importe_haber_ma) as importe_haber_ma
                                            FROM parcial';  
             
             
             
            raise notice '%',v_consulta;
 
			--Devuelve la respuesta
			return v_consulta;

		end;         				
	
    else
					     
		raise exception 'Transaccion inexistente';
					         
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