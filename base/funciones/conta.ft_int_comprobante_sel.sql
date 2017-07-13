--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_int_comprobante_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_int_comprobante_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tint_comprobante'
 AUTOR: 		 (admin)
 FECHA:	        29-08-2013 00:28:30
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
    v_registro_moneda	record;
	v_nombre_funcion   	text;
	v_resp				varchar;
    v_id_moneda_base	integer;
    v_id_moneda_tri	    integer;
    v_filtro 			varchar;
    va_id_depto			integer[];
    v_codigo_moneda_base		varchar;
			    
BEGIN

	v_nombre_funcion = 'conta.ft_int_comprobante_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_INCBTE_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		29-08-2013 00:28:30
	***********************************/
    if(p_transaccion='CONTA_INCBTE_SEL') then
     				
    	begin
        
            v_id_moneda_base=param.f_get_moneda_base();
            v_filtro = ' 0 = 0 and ';
            
            select 
             *
            into
             v_registro_moneda
            from param.tmoneda m 
            where m.id_moneda = v_id_moneda_base;
            
            -- si no es administrador, solo puede listar al responsable del depto o al usuario que creo e documentos
            IF p_administrador !=1 THEN  
               
                select  
                   pxp.aggarray(depu.id_depto)
                into 
                   va_id_depto
                from param.tdepto_usuario depu 
                where depu.id_usuario =  p_id_usuario and depu.cargo = 'responsable';

				IF v_parametros.nombreVista != 'IntComprobanteLd' THEN
	                v_filtro = ' ( incbte.id_usuario_reg = '||p_id_usuario::varchar ||'  or   (ew.id_depto  in ('|| COALESCE(array_to_string(va_id_depto,','),'0')||'))) and ';
                END IF;

            END IF;
    		--Sentencia de la consulta
			v_consulta := 'select
                              incbte.id_int_comprobante,
                              incbte.id_clase_comprobante,
                              incbte.id_subsistema,
                              incbte.id_depto,
                              incbte.id_moneda,
                              incbte.id_periodo,
                              incbte.id_funcionario_firma1,
                              incbte.id_funcionario_firma2,
                              incbte.id_funcionario_firma3,
                              incbte.tipo_cambio,
                              incbte.beneficiario,
                              incbte.nro_cbte,
                              incbte.estado_reg,
                              incbte.glosa1,
                              incbte.fecha,
                              incbte.glosa2,
                              incbte.nro_tramite,
                              incbte.momento,
                              incbte.id_usuario_reg,
                              incbte.fecha_reg,
                              incbte.id_usuario_mod,
                              incbte.fecha_mod,
                              incbte.usr_reg,
                              incbte.usr_mod,
                              incbte.desc_clase_comprobante,
                              incbte.desc_subsistema,
                              incbte.desc_depto,
                              incbte.desc_moneda,
                              incbte.desc_firma1,
                              incbte.desc_firma2,
                              incbte.desc_firma3,
                              incbte.momento_comprometido,
                              incbte.momento_ejecutado,
                              incbte.momento_pagado,
                              incbte.manual,
                              incbte.id_int_comprobante_fks,
                              incbte.id_tipo_relacion_comprobante,
                              incbte.desc_tipo_relacion_comprobante,
                              '||v_id_moneda_base::VARCHAR||'::integer as id_moneda_base,
                              '''||v_registro_moneda.codigo::TEXT||'''::TEXT as desc_moneda_base,
                              incbte.cbte_cierre,
                              incbte.cbte_apertura,
                              incbte.cbte_aitb,
                              incbte.fecha_costo_ini,
                              incbte.fecha_costo_fin,
                              incbte.tipo_cambio_2,
                              incbte.id_moneda_tri,
                              incbte.sw_tipo_cambio,
                              incbte.id_config_cambiaria,
                              incbte.ope_1,
                              incbte.ope_2,
                              incbte.desc_moneda_tri,
                              incbte.origen,
                              incbte.localidad,
                              incbte.sw_editable,
                              incbte.cbte_reversion,
                              incbte.volcado,
                              incbte.id_proceso_wf,
                              incbte.id_estado_wf,
                              incbte.fecha_c31,
                              incbte.c31,
                              incbte.id_gestion,
                              incbte.periodo,
                              incbte.forma_cambio,
                              incbte.ope_3,
                              incbte.tipo_cambio_3,
                              incbte.id_moneda_act
                              
                              
                          from conta.vint_comprobante incbte
                          inner join wf.tproceso_wf pwf on pwf.id_proceso_wf = incbte.id_proceso_wf
                          inner join wf.testado_wf ew on ew.id_estado_wf = incbte.id_estado_wf
                          where  incbte.estado_reg in (''borrador'',''validado'') and '||v_filtro;

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --raise exception '--> %', v_consulta;
            raise notice  '-- % --', v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'CONTA_INCBTE_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin
 	#FECHA:		29-08-2013 00:28:30
	***********************************/

	elsif(p_transaccion='CONTA_INCBTE_CONT')then

		begin

            v_filtro = ' 0 = 0 and ';

           -- si no es administrador, solo puede listar al responsable del depto o al usuario que creo e documentos
            IF p_administrador !=1 THEN

                select
                   pxp.aggarray(depu.id_depto)
                into
                   va_id_depto
                from param.tdepto_usuario depu
                where depu.id_usuario =  p_id_usuario and depu.cargo = 'responsable';

            	IF v_parametros.nombreVista != 'IntComprobanteLd' THEN
	                v_filtro = ' ( incbte.id_usuario_reg = '||p_id_usuario::varchar ||'  or  (ew.id_depto  in ('||COALESCE(array_to_string(va_id_depto,','),'0')||'))) and ';
                END IF;

            END IF;

            --Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_int_comprobante)
					     from conta.vint_comprobante incbte
                         inner join wf.tproceso_wf pwf on pwf.id_proceso_wf = incbte.id_proceso_wf
                         inner join wf.testado_wf ew on ew.id_estado_wf = incbte.id_estado_wf
                         where  incbte.estado_reg in (''borrador'',''validado'') and '||v_filtro;

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;

    /*********************************
 	#TRANSACCION:  'CONTA_ICSIM_SEL'
 	#DESCRIPCION:	Consulta simplificada de comprobantes intermedios
 	#AUTOR:		rac
 	#FECHA:		29-12-2014 00:28:30
	***********************************/
    elseif(p_transaccion='CONTA_ICSIM_SEL') then

    	begin
    		--Sentencia de la consulta
			v_consulta :=  'select inc.id_int_comprobante,
                                   inc.nro_cbte,
                                   inc.nro_tramite,
                                   inc.fecha,
                                   inc.glosa1,
                                   inc.glosa2,
                                   cc.id_clase_comprobante,
                                   cc.codigo,
                                   cc.descripcion,
                                   mon.codigo::text AS desc_moneda

                            from conta.vint_comprobante inc
                            inner JOIN param.tmoneda mon ON mon.id_moneda = inc.id_moneda
                            inner JOIN param.tperiodo per ON per.id_periodo = inc.id_periodo
                            inner join conta.tclase_comprobante cc on cc.id_clase_comprobante = inc.id_clase_comprobante
                            where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

    /*********************************
 	#TRANSACCION:  'CONTA_ICSIM_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin
 	#FECHA:		29-08-2013 00:28:30
	***********************************/

	elsif(p_transaccion='CONTA_ICSIM_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_int_comprobante)
			             from conta.vint_comprobante inc
                         inner JOIN param.tmoneda mon ON mon.id_moneda = inc.id_moneda
                         inner JOIN param.tperiodo per ON per.id_periodo = inc.id_periodo
                         inner join conta.tclase_comprobante cc on cc.id_clase_comprobante = inc.id_clase_comprobante
                         where ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;


	/*********************************
 	#TRANSACCION:  'CONTA_CABCBT_SEL'
 	#DESCRIPCION:	Cabecera para el reporte de Comprobante
 	#AUTOR:			RAC
 	#FECHA:			22/05/2015
	***********************************/

	elsif(p_transaccion='CONTA_CABCBT_SEL')then

    	begin
             v_id_moneda_base=param.f_get_moneda_base();

            --recuperar el codigo de la moneda base

            select
               m.codigo into v_codigo_moneda_base
            from param.tmoneda m
            where m.id_moneda = v_id_moneda_base;


    		--Sentencia de la consulta
			v_consulta:='select
                            incbte.id_int_comprobante,
                            incbte.id_clase_comprobante,
                            incbte.id_subsistema,
                            incbte.id_depto,
                            incbte.id_moneda,
                            incbte.id_periodo,
                            incbte.id_funcionario_firma1,
                            incbte.id_funcionario_firma2,
                            incbte.id_funcionario_firma3,
                            incbte.tipo_cambio,
                            incbte.beneficiario,
                            incbte.nro_cbte,
                            incbte.estado_reg,
                            incbte.glosa1,
                            incbte.fecha,
                            incbte.glosa2,
                            incbte.nro_tramite,
                            incbte.momento,
                            incbte.id_usuario_reg,
                            incbte.fecha_reg,
                            incbte.id_usuario_mod,
                            incbte.fecha_mod,
                            incbte.usr_reg,
                            incbte.usr_mod,
                            incbte.desc_clase_comprobante,
                            incbte.desc_subsistema,
                            incbte.desc_depto,
                            incbte.desc_moneda,
                            incbte.desc_firma1,
                            incbte.desc_firma2,
                            incbte.desc_firma3,
                            incbte.momento_comprometido,
                            incbte.momento_ejecutado,
                            incbte.momento_pagado,
                            incbte.manual,
                            incbte.id_int_comprobante_fks,
                            incbte.id_tipo_relacion_comprobante,
                            incbte.desc_tipo_relacion_comprobante,
                            '||v_id_moneda_base::VARCHAR||'::integer as id_moneda_base,
                            '''||v_codigo_moneda_base::VARCHAR||'''::varchar as codigo_moneda_base,
                            incbte.codigo_depto,
                            conta.f_recuperar_nro_documento_facturas_comprobante(incbte.id_int_comprobante) as documentos,
                            COALESCE(en.c31,'''') as c31
                          from conta.vint_comprobante incbte
                          left join conta.tentrega_det ed on ed.id_int_comprobante = incbte.id_int_comprobante
                          left join conta.tentrega en on en.id_entrega = ed.id_entrega
                          
                          where incbte.id_proceso_wf = '||v_parametros.id_proceso_wf;
			
			--Devuelve la respuesta
			return v_consulta;
						
		end;
		
	/*********************************    
 	#TRANSACCION:  'CONTA_DETCBT_SEL'
 	#DESCRIPCION:	detalle para el reporte de Comprobante
 	#AUTOR:			RCM	
 	#FECHA:			10/09/2013
	***********************************/

	elsif(p_transaccion='CONTA_DETCBT_SEL')then
     				
    	begin
       
    		--Sentencia de la consulta
			v_consulta:='select    
                                nro_cuenta,
                                nombre_cuenta,
                                codigo_auxiliar,
                                nombre_auxiliar,
                                ccc,
                                codigo_partida,
                                nombre_partida,
                                desc_orden,
                                glosa,
                                importe_gasto, 
                                importe_recurso,
                                importe_debe, 
                                importe_haber,
                                importe_debe_mb,
                                importe_haber_mb,
                                sw_movimiento,
                                tipo_partida
                                FROM ((select
                                                  CASE 
                                                    WHEN  (sum(tra.importe_debe) > 0 or sum(tra.importe_debe_mb) >0) then  1 
                                                    ELSE   2
                                                   END as tipo,
                                                  max(tra.orden) as orden_rank,
                                                  cue.nro_cuenta,
                                                  cue.nombre_cuenta,
                                                  aux.codigo_auxiliar,
                                                  aux.nombre_auxiliar,
                                                  cc.codigo_cc as ccc,
                                                  par.codigo as codigo_partida,
                                                  par.nombre_partida,
                                                  ot.desc_orden,
                                                  tra.glosa::varchar as glosa,
                                                  sum(tra.importe_gasto) as importe_gasto,
                                                  sum(tra.importe_recurso) as importe_recurso,
                                                  sum(tra.importe_debe) as importe_debe, 
                                                  sum(tra.importe_haber) as importe_haber,
                                                  sum(tra.importe_debe_mb) as importe_debe_mb,
                                                  sum(tra.importe_haber_mb) as importe_haber_mb,
                                                  par.sw_movimiento,
                                                  par.tipo as tipo_partida
                                                from conta.tint_transaccion tra
                                                inner join conta.tint_comprobante cbte on cbte.id_int_comprobante = tra.id_int_comprobante
                                                inner join conta.tcuenta cue on cue.id_cuenta = tra.id_cuenta  
                                                inner join param.vcentro_costo cc on cc.id_centro_costo = tra.id_centro_costo
                                                left join pre.tpartida par on par.id_partida = tra.id_partida
                                                left join conta.tauxiliar aux on aux.id_auxiliar = tra.id_auxiliar
                                                left join conta.torden_trabajo ot on ot.id_orden_trabajo = tra.id_orden_trabajo
                                                where cbte.id_proceso_wf =  '||v_parametros.id_proceso_wf||'
                                                
                                                group by 
                                                  cue.nro_cuenta,
                                                  cue.nombre_cuenta,
                                                  aux.codigo_auxiliar,
                                                  aux.nombre_auxiliar,
                                                  cc.codigo_cc ,
                                                  par.codigo ,
                                                  par.nombre_partida,
                                                  ot.desc_orden,
                                                  tra.glosa,
                                                  par.sw_movimiento,
                                                  par.tipo
                                          )
                                          
                                                  
                                ) iii 
                                
                                order by tipo, orden_rank';
						
			
			--Devuelve la respuesta
			return v_consulta;
						
		end;
        
    /*********************************    
 	#TRANSACCION:  'CONTA_DEPCBT_SEL'
 	#DESCRIPCION:	Listado de dependencia en formato arbol
 	#AUTOR:			RAC	
 	#FECHA:			11/04/2016
	***********************************/

	elsif(p_transaccion='CONTA_DEPCBT_SEL')then
     				
    	begin
        
           --si el priemro obtener el razi
           
           
           -- si no obtener los otros
           
           if(v_parametros.id_padre = '%') then
           
                 v_consulta:='WITH RECURSIVE path_rec(id_int_comprobante, id_int_comprobante_fks, nro_tramite, nro_cbte, glosa1,volcado, cbte_reversion,id_tipo_relacion_comprobante, id_proceso_wf ) AS (
                                SELECT  
                                  c.id_int_comprobante,
                                  c.id_int_comprobante_fks,
                                  c.nro_tramite,
                                  c.nro_cbte,
                                  c.glosa1,
                                  c.volcado,
                                  c.cbte_reversion,
                                  c.id_tipo_relacion_comprobante, 
                                  c.id_proceso_wf
                                FROM conta.tint_comprobante c 
                                WHERE c.id_int_comprobante = '||v_parametros.id_int_comprobante_basico::varchar||'
                        	
                                UNION
                                SELECT  
                                  c2.id_int_comprobante,
                                  c2.id_int_comprobante_fks,
                                  c2.nro_tramite,
                                  c2.nro_cbte,
                                  c2.glosa1,
                                  c2.volcado,
                                  c2.cbte_reversion,
                                  c2.id_tipo_relacion_comprobante, 
                                  c2.id_proceso_wf
                                FROM conta.tint_comprobante c2
                                inner join path_rec  pr on c2.id_int_comprobante = ANY(pr.id_int_comprobante_fks)
                                
                        	     
                            )
                            SELECT 
                              c.id_int_comprobante,
                              NULL::integer as id_int_comprobante_padre,
                              c.nro_cbte,
                              c.glosa1,
                              rc.nombre,
                              c.volcado,
                              c.cbte_reversion,
                              ''raiz''::varchar as tipo_nodo, 
                              c.id_proceso_wf
                            FROM path_rec c
                            left join conta.ttipo_relacion_comprobante rc on rc.id_tipo_relacion_comprobante = c.id_tipo_relacion_comprobante
                            order by id_int_comprobante  limit 1 offset 0';
                  
                     
               else
               
                --Sentencia de la consulta
			    v_consulta:='SELECT
                              c.id_int_comprobante,
                              '||v_parametros.id_padre||'::integer as id_int_comprobante_padre,
                              c.nro_cbte,
                              c.glosa1,
                              rc.nombre,
                              c.volcado,
                              c.cbte_reversion,
                              ''hijo''::varchar as tipo_nodo, 
                              c.id_proceso_wf
                          FROM conta.tint_comprobante c
                          inner join conta.ttipo_relacion_comprobante rc on rc.id_tipo_relacion_comprobante = c.id_tipo_relacion_comprobante
                          WHERE  '||v_parametros.id_padre||' = ANY(c.id_int_comprobante_fks)';
              
              
              
              
              
              
              end if;
        
          
					
			
			--Devuelve la respuesta
			return v_consulta;
						
		end;    
    
    /*********************************    
 	#TRANSACCION:  'CONTA_INCBTEWF_SEL'
 	#DESCRIPCION:	consulta de comprobantes para el wf
 	#AUTOR:		admin	
 	#FECHA:		29-08-2013 00:28:30
	***********************************/
    elseif(p_transaccion='CONTA_INCBTEWF_SEL') then
     				
    	begin
        
            v_id_moneda_base=param.f_get_moneda_base();
            
            select 
             *
            into
             v_registro_moneda
            from param.tmoneda m 
            where m.id_moneda = v_id_moneda_base;
            
            
             
            IF p_administrador !=1 THEN
                v_filtro = ' (ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||') and (lower(incbte.estado_reg)!=''anulado'') and (lower(incbte.estado_reg)!=''borrador'') and (lower(incbte.estado_reg)!=''validado'' ) and ';
            ELSE
                v_filtro = ' (lower(incbte.estado_reg)!=''borrador'') and (lower(incbte.estado_reg)!=''validado'' ) and ';
            END IF;
           
            
            
            
            --TODO si no es administrador, solo puede listar al responsable del depto o al usuario que creo e documentos
            
    		--Sentencia de la consulta
			v_consulta := 'select
                              incbte.id_int_comprobante,
                              incbte.id_clase_comprobante,
                              incbte.id_subsistema,
                              incbte.id_depto,
                              incbte.id_moneda,
                              incbte.id_periodo,
                              incbte.id_funcionario_firma1,
                              incbte.id_funcionario_firma2,
                              incbte.id_funcionario_firma3,
                              incbte.tipo_cambio,
                              incbte.beneficiario,
                              incbte.nro_cbte,
                              incbte.estado_reg,
                              incbte.glosa1,
                              incbte.fecha,
                              incbte.glosa2,
                              incbte.nro_tramite,
                              incbte.momento,
                              incbte.id_usuario_reg,
                              incbte.fecha_reg,
                              incbte.id_usuario_mod,
                              incbte.fecha_mod,
                              incbte.usr_reg,
                              incbte.usr_mod,
                              incbte.desc_clase_comprobante,
                              incbte.desc_subsistema,
                              incbte.desc_depto,	
                              incbte.desc_moneda,
                              incbte.desc_firma1,
                              incbte.desc_firma2,
                              incbte.desc_firma3,
                              incbte.momento_comprometido,
                              incbte.momento_ejecutado,
                              incbte.momento_pagado,
                              incbte.manual,
                              incbte.id_int_comprobante_fks,
                              incbte.id_tipo_relacion_comprobante,
                              incbte.desc_tipo_relacion_comprobante,
                              '||v_id_moneda_base::VARCHAR||'::integer as id_moneda_base,
                              '''||v_registro_moneda.codigo::TEXT||'''::TEXT as desc_moneda_base,
                              incbte.cbte_cierre,
                              incbte.cbte_apertura,
                              incbte.cbte_aitb,
                              incbte.fecha_costo_ini,
                              incbte.fecha_costo_fin,
                              incbte.tipo_cambio_2,
                              incbte.tipo_cambio_3,
                              incbte.id_moneda_tri,
                              incbte.id_moneda_act,
                              incbte.sw_tipo_cambio,
                              incbte.id_config_cambiaria,
                              incbte.ope_1,
                              incbte.ope_2,
                              incbte.desc_moneda_tri,
                              incbte.origen,
                              incbte.localidad,
                              incbte.sw_editable,
                              incbte.cbte_reversion,
                              incbte.volcado,
                              incbte.id_proceso_wf,
                              incbte.id_estado_wf,
                              incbte.fecha_c31,
                              incbte.c31,
                              incbte.id_gestion,
                              incbte.periodo,
                              incbte.forma_cambio
                          from conta.vint_comprobante incbte
                          inner join wf.tproceso_wf pwf on pwf.id_proceso_wf = incbte.id_proceso_wf
                          inner join wf.testado_wf ew on ew.id_estado_wf = incbte.id_estado_wf
                          where   incbte.estado_reg not in (''borrador'',''validado'') and '||v_filtro;
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            
            --raise exception '--> %', v_consulta;	
            raise notice  '-- % --', v_consulta;
			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_INCBTEWF_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		29-08-2013 00:28:30
	***********************************/

	elsif(p_transaccion='CONTA_INCBTEWF_CONT')then

		begin
        
            IF p_administrador !=1 THEN
                v_filtro = ' (ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||') and (lower(incbte.estado_reg)!=''anulado'') and (lower(incbte.estado_reg)!=''borrador'') and (lower(incbte.estado_reg)!=''validado'' ) and ';
            ELSE
                v_filtro = ' (lower(incbte.estado_reg)!=''borrador'') and (lower(incbte.estado_reg)!=''validado'' ) and ';
            END IF;
            
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_int_comprobante)
					     from conta.vint_comprobante incbte
                         inner join wf.tproceso_wf pwf on pwf.id_proceso_wf = incbte.id_proceso_wf
                         inner join wf.testado_wf ew on ew.id_estado_wf = incbte.id_estado_wf
                         where incbte.estado_reg not in (''borrador'',''validado'') and '||v_filtro;
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

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