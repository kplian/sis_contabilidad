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
ISSUE	FORK		 FECHA:				 AUTOR:				DESCRIPCION:
 1A					23/08/2018				EGS				se creo las transsacciones CONTA_INCBTECB_SEL,CONTA_INCBTECB_CONT
 #7		endeETR		27/12/2018			manuel guerra		agrega columna nro_tramite_aux, y listado de tramites
 #32     ETR	    08/01/2019		    MMV			    		Nuevo campo documento iva  si o no validar documentacion de via
 #33     ETR     	10/02/2019		  Miguel Mamani	  		Mostrar moneda $us en reporte comprobante
 #45	 ETR		15/05/2019			manuel guerra		cambiar la fecha de filtrado del reporte
 #50	 ETR		17/05/2019			manuel guerra		agregar filtro depto
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
    v_desde				varchar;
    v_hasta				varchar;
    v_func				varchar;
    v_id_moneda			integer;	 --#33
    v_id_monedar_mt		integer;     --#33
    v_depto     		varchar;     
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
                where depu.id_usuario =  p_id_usuario and depu.cargo in ('responsable','administrador');

				IF v_parametros.nombreVista != 'IntComprobanteLd' THEN
	                v_filtro = ' ( incbte.id_usuario_reg = '||p_id_usuario::varchar ||'  or   (ew.id_depto  in ('|| COALESCE(array_to_string(va_id_depto,','),'0')||'))) and ';
                END IF;

            END IF;
    		--Sentencia de la consulta
            --#7
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
                              incbte.id_moneda_act,
                              incbte.nro_tramite_aux,
                              incbte.documento_iva, -- #32
                              incbte.id_int_comprobante_migrado
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
	---
    /*********************************    
 	#TRANSACCION:  'CONTA_REPINCBTE_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		mp	
 	#FECHA:		29-08-2013 00:28:30
	***********************************/
    elsif(p_transaccion='CONTA_REPINCBTE_SEL') then
     				
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
            
            v_desde =  'incbte.fecha >= '''||v_parametros.fecIni||''' and incbte.fecha <='''||v_parametros.fecFin||''' ';
                      
			IF (v_desde IS NULL) THEN
            	v_desde='0=0';
            END IF;
    		--Sentencia de la consulta
			v_consulta := '
                           SELECT 
                              incbte.id_int_comprobante,
                              incbte.nro_cbte,
                              incbte.nro_tramite,
                              incbte.glosa1,
                              incbte.fecha,
                              incbte.glosa2,
                              incbte.beneficiario,
                              incbte.c31,
                              incbte.fecha_costo_ini,
                              incbte.fecha_costo_fin,
                              incbte.id_depto,
                              incbte.id_gestion,
                              tra.glosa,
                              par.nombre_partida,
							  (cue.nro_cuenta || '' - '' || cue.nombre_cuenta)::VARCHAR	 as desc_cuenta, 
                              cc.codigo_cc::VARCHAR as desc_centro_costo,                            
                              tra.importe_debe_mb,tra.importe_haber_mb,tra.importe_gasto_mb,
                              tra.importe_debe_mt,tra.importe_haber_mt,tra.importe_gasto_mt,
                              tra.importe_debe_ma,tra.importe_haber_ma,tra.importe_gasto_ma
                              FROM conta.tint_transaccion tra
                              INNER JOIN conta.vint_comprobante incbte ON tra.id_int_comprobante = incbte.id_int_comprobante
                              JOIN pre.tpartida par ON par.id_partida = tra.id_partida
							  JOIN conta.tcuenta cue ON cue.id_cuenta = tra.id_cuenta
                              LEFT JOIN param.vcentro_costo cc on cc.id_centro_costo = tra.id_centro_costo
                              WHERE incbte.nro_cbte!=''''
                              AND '||v_desde||'
                              ORDER BY incbte.fecha,incbte.id_int_comprobante	                             
                              ';
        	--RAISE NOTICE '%',v_consulta;
            --RAISE EXCEPTION '%',v_consulta;
			return v_consulta;

		end;
    
    ---	
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
            --Moneda Base MB
        v_id_moneda_base  =param.f_get_moneda_base();
         ------------#33------------
        ---Obtener La moneda del comprobante cabezera
        select  incbte.id_moneda
            	into
        		v_id_moneda
        from conta.vint_comprobante incbte
        where incbte.id_proceso_wf =v_parametros.id_proceso_wf;

          --recuperar el codigo de la moneda base

          if(v_id_moneda = v_id_moneda_base)then

              select id_moneda
                      into
                      v_id_monedar_mt
              from param.tmoneda
              where tipo_moneda='intercambio';

            select m.codigo into v_codigo_moneda_base
                  from param.tmoneda m
                  where m.id_moneda = v_id_monedar_mt;

            	---  v_id_moneda_base = v_id_monedar_mt;
          else

           select m.codigo into v_codigo_moneda_base
                  from param.tmoneda m
                  where m.id_moneda = v_id_moneda_base;

          end if;
          ------------#33------------


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
                            COALESCE(en.c31,'''') as c31,
                            incbte.sw_tipo_cambio
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
                                importe_debe_mt, --#33
                                importe_haber_mt, --#33
                                sw_movimiento,
                                tipo_partida,
                                tipo_cambio
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
                                                  sum(tra.importe_debe_mt) as importe_debe_mt, --#33
                                                  sum(tra.importe_haber_mt) as importe_haber_mt, --#33
                                                  par.sw_movimiento,
                                                  par.tipo as tipo_partida,
                                                  tra.tipo_cambio
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
                                                  par.tipo,
                                                  tra.tipo_cambio
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

    /*********************************    
    #TRANSACCION:  'CONTA_CBTENCUE_SEL'
    #DESCRIPCION:   Listado de comprobantes por cuenta contable y Tipo CC
    #AUTOR:         RCM
    #FECHA:         31/10/2017
    ***********************************/
    elsif(p_transaccion='CONTA_CBTENCUE_SEL') then
                    
        begin
        
            --Sentencia de la consulta
            v_consulta := 'select
                        com.id_int_comprobante, com.fecha, com.nro_tramite, com.glosa1
                        from conta.tint_transaccion tra
                        inner join conta.tint_comprobante com
                        on com.id_int_comprobante = tra.id_int_comprobante
                        inner join conta.tcuenta cue
                        on cue.id_cuenta = tra.id_cuenta
                        inner join param.tcentro_costo cc
                        on cc.id_centro_costo = tra.id_centro_costo
                        inner join param.ttipo_cc tcc
                        on tcc.id_tipo_cc = cc.id_tipo_cc
                        where ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --Devuelve la respuesta
            return v_consulta;

        end;

    /*********************************    
    #TRANSACCION:  'CONTA_CBTENCUE_CONT'
    #DESCRIPCION:   Conteo de registros del Listado de comprobantes por cuenta contable y Tipo CC
    #AUTOR:         RCM
    #FECHA:         31/10/2017
    ***********************************/

    elsif(p_transaccion='CONTA_CBTENCUE_CONT')then

        begin
            
            --Sentencia de la consulta de conteo de registros
            v_consulta:='select count(1) as total
                        from conta.tint_transaccion tra
                        inner join conta.tint_comprobante com
                        on com.id_int_comprobante = tra.id_int_comprobante
                        inner join conta.tcuenta cue
                        on cue.id_cuenta = tra.id_cuenta
                        inner join param.tcentro_costo cc
                        on cc.id_centro_costo = tra.id_centro_costo
                        inner join param.ttipo_cc tcc
                        on tcc.id_tipo_cc = cc.id_tipo_cc
                        where ';
            
            --Definicion de la respuesta            
            v_consulta:=v_consulta||v_parametros.filtro;

            --Devuelve la respuesta
            return v_consulta;

        end;
         /*********************************    
 	#TRANSACCION:  'CONTA_INCBTECB_SEL'
 	#DESCRIPCION:	Consulta de datos lista comprobante combo
 	#AUTOR:		admin	
 	#FECHA:		29-08-2013 00:28:30
	***********************************/
    ELSIF(p_transaccion='CONTA_INCBTECB_SEL') then
     				
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
               /*
                select  
                   pxp.aggarray(depu.id_depto)
                into 
                   va_id_depto
                from param.tdepto_usuario depu 
                where depu.id_usuario =  p_id_usuario and depu.cargo in ('responsable','administrador');

				IF v_parametros.nombreVista != 'IntComprobanteLd' THEN
	                v_filtro = ' ( incbte.id_usuario_reg = '||p_id_usuario::varchar ||'  or   (ew.id_depto  in ('|| COALESCE(array_to_string(va_id_depto,','),'0')||'))) and ';
                END IF;
				*/
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
                              incbte.id_moneda_act,
                              clc.movimiento
                          from conta.vint_comprobante incbte
                          inner join wf.tproceso_wf pwf on pwf.id_proceso_wf = incbte.id_proceso_wf
                          inner join wf.testado_wf ew on ew.id_estado_wf = incbte.id_estado_wf
                          left join conta.tclase_comprobante clc on clc.id_clase_comprobante=incbte.id_clase_comprobante
                          where  incbte.estado_reg in (''borrador'',''validado'') and '||v_filtro;

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
            raise notice  '-- % --', v_consulta;
        --    raise exception '--> %', v_consulta;
            
			
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --Devuelve la respuesta
			return v_consulta;

		end;
        /*********************************
 	#TRANSACCION:  'CONTA_INCBTECB_CONT'
 	#DESCRIPCION:	Conteo de registros de la lista de comprobantes combo
 	#AUTOR:		admin
 	#FECHA:		29-08-2013 00:28:30
	***********************************/

	elsif(p_transaccion='CONTA_INCBTECB_CONT')then

		begin

            v_filtro = ' 0 = 0 and ';

           -- si no es administrador, solo puede listar al responsable del depto o al usuario que creo e documentos
            IF p_administrador !=1 THEN
				/*
                select
                   pxp.aggarray(depu.id_depto)
                into
                   va_id_depto
                from param.tdepto_usuario depu
                where depu.id_usuario =  p_id_usuario and depu.cargo = 'responsable';

            	IF v_parametros.nombreVista != 'IntComprobanteLd' THEN
	                v_filtro = ' ( incbte.id_usuario_reg = '||p_id_usuario::varchar ||'  or  (ew.id_depto  in ('||COALESCE(array_to_string(va_id_depto,','),'0')||'))) and ';
                END IF;
				*/
            END IF;

            --Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_int_comprobante)
					     from conta.vint_comprobante incbte
                         inner join wf.tproceso_wf pwf on pwf.id_proceso_wf = incbte.id_proceso_wf
                         inner join wf.testado_wf ew on ew.id_estado_wf = incbte.id_estado_wf
                         left join conta.tclase_comprobante clc on clc.id_clase_comprobante=incbte.id_clase_comprobante

                         where  incbte.estado_reg in (''borrador'',''validado'') and '||v_filtro;

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
    
	 /*********************************    
 	#TRANSACCION:  'CONTA_REPCBT_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		mp	   
 	#FECHA:		29-08-2013 00:28:30
	***********************************/
    elsif(p_transaccion='CONTA_REPCBT_SEL') then
     				
    	begin
               
            IF v_parametros.id_usuario is not NULL and v_parametros.id_usuario <> 0 THEN
            	v_func = 'incbte.id_usuario_reg ='||v_parametros.id_usuario||' ';  
            ELSE
				v_func = '0=0';     
            END IF;  
            --#50
            IF v_parametros.id_depto is not NULL  THEN
            	v_depto = 'incbte.id_depto in ('||v_parametros.id_depto||')';  
            ELSE
				v_depto = '0=0';     
            END IF;   
            --#45     
            --v_desde =  'incbte.fecha_reg >= '''||v_parametros.fecha_ini||''' and incbte.fecha_reg <='''||v_parametros.fecha_fin||''' ';                                     
			IF v_parametros.fecha_ini is not null THEN
            	v_desde =  'incbte.fecha::date >= '''||v_parametros.fecha_ini||'''::date ';  
            ELSE
            	v_desde = '0=0';    
            END IF;
            
            IF v_parametros.fecha_fin is not null THEN
            	v_hasta =  'incbte.fecha::date <='''||v_parametros.fecha_fin||'''::date ';      
            ELSE
            	v_hasta = '0=0';    
            END IF;
            
    		--Sentencia de la consulta
			v_consulta := 'SELECT
                          incbte.id_int_comprobante,
                          incbte.beneficiario,
                          incbte.nro_cbte,
                          incbte.desc_clase_comprobante,
                          p.periodo,
                          SUBSTRING(incbte.nro_cbte, strpos(incbte.nro_cbte, ''/'')+1)::varchar as cbte,
                          (left(SUBSTRING(incbte.nro_cbte, strpos(incbte.nro_cbte, ''/'')+1), strpos(SUBSTRING(incbte.nro_cbte, strpos(incbte.nro_cbte, ''/'')+1), ''-'') - 1))::integer as cbte_m,
                          incbte.glosa1,
                          incbte.fecha,
                          incbte.nro_tramite,
                          incbte.cbte_reversion,
                          incbte.usr_reg::varchar,
                          incbte.fecha_reg::date,
                          dep.nombre

                          FROM conta.vint_comprobante incbte
                          JOIN param.tdepto dep on dep.id_depto = incbte.id_depto
                          JOIN param.tperiodo p on p.id_periodo = incbte.id_periodo
                          JOIN conta.tclase_comprobante ccbte ON ccbte.id_clase_comprobante = incbte.id_clase_comprobante
                          JOIN segu.tusuario usu1 on usu1.id_usuario = incbte.id_usuario_reg 
                          where incbte.estado_reg in (''validado'')
                          AND (incbte.temporal = ''no'' or (incbte.temporal = ''si'' and vbregional = ''si''))
                          AND '||v_func||' 
                          AND '||v_depto||' 
                          AND '||v_desde||' 
                          AND '||v_hasta||' 
                          AND';
               v_consulta:=v_consulta||v_parametros.filtro;                          
               v_consulta:=v_consulta||'order by CAST(left(SUBSTRING(incbte.nro_cbte, strpos(incbte.nro_cbte, ''/'')+1), strpos(SUBSTRING(incbte.nro_cbte, strpos(incbte.nro_cbte, ''/'')+1), ''-'') - 1) as INTEGER) asc';
			return v_consulta;

		end;				
	
    /*********************************
 	#TRANSACCION:  'CONTA_LISTRA_SEL'
 	#DESCRIPCION:	Listado de nro tramites
 	#AUTOR:		#7  Manuel guerra
 	#FECHA:		28-12-2018
	***********************************/
    elseif(p_transaccion='CONTA_LISTRA_SEL') then

    	begin
    		--Sentencia de la consulta
			v_consulta :=  'SELECT 
            				t2.id_proceso_wf,
            				w.nro_tramite
                            
                            FROM wf.tproceso_wf w
                            JOIN (
                                    SELECT 
                                    DISTINCT ON (nro_tramite) nro_tramite,
                                    id_proceso_wf
                                    FROM wf.tproceso_wf 
                            	 )t2
                            ON t2.id_proceso_wf = w.id_proceso_wf 
                            where 0=0 and';
			--Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro; 
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			--Devuelve la respuesta
			return v_consulta;
		end;
    
    /*********************************
 	#TRANSACCION:  'CONTA_LISTRA_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		#7  Manuel guerra
 	#FECHA:		28-12-20180
	***********************************/

	elsif(p_transaccion='CONTA_LISTRA_CONT')then
		begin
     		--Sentencia de la consulta
			v_consulta :=  'SELECT 
            				count(w.id_proceso_wf)
                            FROM wf.tproceso_wf w
                            JOIN (
                                    SELECT 
                                    DISTINCT ON (nro_tramite) nro_tramite,
                                    id_proceso_wf
                                    FROM wf.tproceso_wf 
                            	 )t2
                            ON t2.id_proceso_wf = w.id_proceso_wf                             
                            where 0=0 and';
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