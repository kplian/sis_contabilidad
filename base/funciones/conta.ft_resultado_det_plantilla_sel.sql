--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_resultado_det_plantilla_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_resultado_det_plantilla_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tresultado_det_plantilla'
 AUTOR: 		 (admin)
 FECHA:	        08-07-2015 13:13:15
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
    v_gestion 			varchar;
    v_id_gestion		integer;
			    
BEGIN

	v_nombre_funcion = 'conta.ft_resultado_det_plantilla_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_RESDET_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		08-07-2015 13:13:15
	***********************************/

	if(p_transaccion='CONTA_RESDET_SEL')then
     				
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
                          aux.nombre_auxiliar as desc_auxiliar,
                          par.nombre_partida as desc_partida
                          from conta.tresultado_det_plantilla resdet
                          inner join segu.tusuario usu1 on usu1.id_usuario = resdet.id_usuario_reg
                          left  join conta.tauxiliar aux on aux.id_auxiliar = resdet.id_auxiliar
                          left join conta.tcuenta cue on cue.estado_reg = ''activo'' and cue.nro_cuenta = resdet.codigo_cuenta and cue.id_gestion = '||v_id_gestion::varchar||' 
                          left join pre.tpartida par on par.estado_reg = ''activo'' and par.codigo = resdet.codigo_partida and par.id_gestion = '||v_id_gestion::varchar||' 
                          
                          left join segu.tusuario usu2 on usu2.id_usuario = resdet.id_usuario_mod
				        where  ';
                        
             
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_RESDET_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		08-07-2015 13:13:15
	***********************************/

	elsif(p_transaccion='CONTA_RESDET_CONT')then

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
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_resultado_det_plantilla)
					    from conta.tresultado_det_plantilla resdet
                          inner join segu.tusuario usu1 on usu1.id_usuario = resdet.id_usuario_reg
                          left  join conta.tauxiliar aux on aux.id_auxiliar = resdet.id_auxiliar
                          left join conta.tcuenta cue on cue.estado_reg = ''activo'' and cue.nro_cuenta = resdet.codigo_cuenta and cue.id_gestion = '||v_id_gestion::varchar||' 
                          left join pre.tpartida par on par.estado_reg = ''activo'' and par.codigo = resdet.codigo_partida and par.id_gestion = '||v_id_gestion::varchar||' 
                          
                          left join segu.tusuario usu2 on usu2.id_usuario = resdet.id_usuario_mod
				        where   ';
			
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