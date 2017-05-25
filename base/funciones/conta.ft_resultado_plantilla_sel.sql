--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_resultado_plantilla_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_resultado_plantilla_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tresultado_plantilla'
 AUTOR: 		 (admin)
 FECHA:	        08-07-2015 13:12:43
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
    v_gestion			varchar;
    v_id_gestion		integer;
			    
BEGIN

	v_nombre_funcion = 'conta.ft_resultado_plantilla_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_RESPLAN_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		08-07-2015 13:12:43
	***********************************/

	if(p_transaccion='CONTA_RESPLAN_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
                            resplan.id_resultado_plantilla,
                            resplan.codigo,
                            resplan.estado_reg,
                            resplan.nombre,
                            resplan.id_usuario_reg,
                            resplan.usuario_ai,
                            resplan.fecha_reg,
                            resplan.id_usuario_ai,
                            resplan.fecha_mod,
                            resplan.id_usuario_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod	,
                            resplan.tipo,
                            resplan.cbte_aitb,
                            resplan.cbte_apertura,
                            resplan.cbte_cierre,
                            resplan.periodo_calculo,
                            resplan.id_clase_comprobante,
                            resplan.glosa,
                            cc.descripcion as desc_clase_comprobante,
                            resplan.id_tipo_relacion_comprobante,
                            resplan.relacion_unica,
                            resplan.nombre as desc_tipo_relacion_comprobante
						
                        from conta.tresultado_plantilla resplan
                        inner join segu.tusuario usu1 on usu1.id_usuario = resplan.id_usuario_reg
						left join conta.tclase_comprobante cc on cc.id_clase_comprobante = resplan.id_clase_comprobante                        
						left join conta.ttipo_relacion_comprobante trc on trc.id_tipo_relacion_comprobante = resplan.id_tipo_relacion_comprobante
						left join segu.tusuario usu2 on usu2.id_usuario = resplan.id_usuario_mod
				        where  ';
                        
                
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_RESPLAN_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		08-07-2015 13:12:43
	***********************************/

	elsif(p_transaccion='CONTA_RESPLAN_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_resultado_plantilla)
					    from conta.tresultado_plantilla resplan
                        inner join segu.tusuario usu1 on usu1.id_usuario = resplan.id_usuario_reg
						left join conta.tclase_comprobante cc on cc.id_clase_comprobante = resplan.id_clase_comprobante                        
						left join conta.ttipo_relacion_comprobante trc on trc.id_tipo_relacion_comprobante = resplan.id_tipo_relacion_comprobante
						left join segu.tusuario usu2 on usu2.id_usuario = resplan.id_usuario_mod
				        where ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
        
    /*********************************    
 	#TRANSACCION:   'CONTA_EXPRESPLT_SEL'
 	#DESCRIPCION:	exportar plantilla de resultados
 	#AUTOR:		rac	
 	#FECHA:		02-06-2016 13:12:43
	***********************************/

	elseif(p_transaccion='CONTA_EXPRESPLT_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
                            ''maestro''::varchar as tipo_reg,
                            resplan.id_resultado_plantilla,
                            resplan.codigo,
                            resplan.estado_reg,
                            resplan.nombre,
                            resplan.id_usuario_reg,
                            resplan.usuario_ai,
                            resplan.fecha_reg,
                            resplan.id_usuario_ai,
                            resplan.fecha_mod,
                            resplan.id_usuario_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                            resplan.tipo,
                            resplan.cbte_aitb,
                            resplan.cbte_apertura,
                            resplan.cbte_cierre,
                            resplan.periodo_calculo,
                            resplan.id_clase_comprobante,
                            resplan.glosa,
                            cc.codigo as codigo_clase_comprobante,
                            resplan.id_tipo_relacion_comprobante,
                            resplan.relacion_unica,
                            resplan.codigo as codigo_tipo_relacion_comprobante
                      from conta.tresultado_plantilla resplan
                      inner join segu.tusuario usu1 on usu1.id_usuario = resplan.id_usuario_reg
                      left join conta.ttipo_relacion_comprobante trc on trc.id_tipo_relacion_comprobante = resplan.id_tipo_relacion_comprobante
 					  left join conta.tclase_comprobante cc on cc.id_clase_comprobante = resplan.id_clase_comprobante
                      left join segu.tusuario usu2 on usu2.id_usuario = resplan.id_usuario_mod
                      where  resplan.id_resultado_plantilla = '||v_parametros.id_resultado_plantilla;
			
            return v_consulta;
						
		end;    
        
					
	/*********************************    
 	#TRANSACCION:  'CONTA_EXPREPD_SEL'
 	#DESCRIPCION:	exportar plantilla detalle de resultados
 	#AUTOR:		rac	
 	#FECHA:		02-06-2016 13:13:15
	***********************************/

	elseif(p_transaccion='CONTA_EXPREPD_SEL')then
     				
    	begin
        
              --recupera la gestion actual
              v_gestion =  (EXTRACT(YEAR FROM  now()))::varchar;
              
             
              
              select 
               ges.id_gestion
              into
               v_id_gestion
              from param.tgestion ges 
              where ges.gestion::varchar  = v_gestion and ges.estado_reg = 'activo';
                
              IF v_id_gestion is null THEN
                 raise exception 'No se encontro gestion para la fecha %', now()::Date;
              END IF;
              
             
              
    		--Sentencia de la consulta
            
			v_consulta:='select
                          ''detalle''::varchar as tipo_reg,
                          resdet.id_resultado_det_plantilla,
                          resdet.orden,
                          resdet.font_size,
                          resdet.formula,
                          resdet.subrayar,
                          resdet.codigo,
                          resdet.montopos,
                          resdet.nombre_variable,
                          resdet.posicion,
                          resdet.estado_reg,
                          resdet.nivel_detalle,
                          resdet.origen,
                          resdet.signo,
                          resdet.codigo_cuenta,
                          resdet.id_usuario_ai,
                          resdet.usuario_ai,
                          resdet.fecha_reg,
                          resdet.id_usuario_reg,
                          resdet.id_usuario_mod,
                          resdet.fecha_mod,
                          usu1.cuenta as usr_reg,
                          usu2.cuenta as usr_mod	,
                          resdet.id_resultado_plantilla,
                          resdet.visible,
                          resdet.incluir_apertura,
                          resdet.incluir_cierre,
                          COALESCE(cue.nombre_cuenta,''S/C'')::varchar as desc_cuenta,
                          resdet.negrita,
                          resdet.cursiva,
                          resdet.espacio_previo,
                          resdet.incluir_aitb,
                          resdet.tipo_saldo,
                          resdet.signo_balance,
                          resdet.relacion_contable,
                          resdet.codigo_partida,
                          resdet.id_auxiliar,
                          resdet.destino,
                          resdet.orden_cbte,
                          aux.codigo_auxiliar,
                          par.nombre_partida as desc_partida,
                          rp.codigo as codigo_resultado_plantilla
                      from conta.tresultado_det_plantilla resdet
                       inner join conta.tresultado_plantilla rp  on rp.id_resultado_plantilla = resdet.id_resultado_plantilla
                       inner join segu.tusuario usu1 on usu1.id_usuario = resdet.id_usuario_reg
                       left  join conta.tauxiliar aux on aux.id_auxiliar = resdet.id_auxiliar
                       left join conta.tcuenta cue on cue.estado_reg = ''activo'' and cue.nro_cuenta = resdet.codigo_cuenta and cue.id_gestion = '||v_id_gestion::varchar||' 
                       left join pre.tpartida par on par.estado_reg = ''activo'' and par.codigo = resdet.codigo_partida and par.id_gestion = '||v_id_gestion::varchar||' 
                       left join segu.tusuario usu2 on usu2.id_usuario = resdet.id_usuario_mod
				      where  resdet.id_resultado_plantilla = '||v_parametros.id_resultado_plantilla;
                        
			--Devuelve la respuesta
			return v_consulta;
						
		end;
    /*********************************    
 	#TRANSACCION:  'CONTA_EXRPDEP_SEL'
 	#DESCRIPCION:  exportacion de dependencias
 	#AUTOR:		rac	(kplian)
 	#FECHA:		02-06-2016 13:40:02
	***********************************/

	elsif(p_transaccion='CONTA_EXRPDEP_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
                            ''dependencia''::varchar as tipo_reg,
                            resdep.id_resultado_dep,
                            resdep.id_resultado_plantilla,
                            resdep.obs,
                            resdep.prioridad,
                            resdep.estado_reg,
                            resdep.id_usuario_ai,
                            resdep.fecha_reg,
                            resdep.usuario_ai,
                            resdep.id_usuario_reg,
                            resdep.fecha_mod,
                            resdep.id_usuario_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                            rp.codigo as codigo_resultado_plantilla	,                        
                            rp.nombre as nombre_resultado_plantilla	,
                            resdep.id_resultado_plantilla_hijo,
                            rpp.codigo as codigo_resultado_plantilla_padre
						from conta.tresultado_dep resdep
                        inner join conta.tresultado_plantilla rp  on rp.id_resultado_plantilla = resdep.id_resultado_plantilla_hijo
                        inner join conta.tresultado_plantilla rpp  on rpp.id_resultado_plantilla = resdep.id_resultado_plantilla
						inner join segu.tusuario usu1 on usu1.id_usuario = resdep.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = resdep.id_usuario_mod
				        where  resdep.id_resultado_plantilla = '||v_parametros.id_resultado_plantilla;
			
            
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