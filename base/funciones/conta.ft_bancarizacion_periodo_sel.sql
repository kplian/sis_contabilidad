CREATE OR REPLACE FUNCTION "conta"."ft_bancarizacion_periodo_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_bancarizacion_periodo_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tbancarizacion_periodo'
 AUTOR: 		 (favio.figueroa)
 FECHA:	        24-05-2017 16:07:40
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
			    
BEGIN

	v_nombre_funcion = 'conta.ft_bancarizacion_periodo_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_BANCAPER_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		favio.figueroa	
 	#FECHA:		24-05-2017 16:07:40
	***********************************/

	if(p_transaccion='CONTA_BANCAPER_SEL')then
     				
    	begin

			--	RAISE EXCEPTION '%','llega';
    		--Sentencia de la consulta
			v_consulta:='select
										bancaper.id_bancarizacion_periodo,
										bancaper.estado,
										per.id_periodo,
										bancaper.estado_reg,
										bancaper.usuario_ai,
										bancaper.fecha_reg,
										bancaper.id_usuario_reg,
										bancaper.id_usuario_ai,
										bancaper.fecha_mod,
										bancaper.id_usuario_mod,
										usu1.cuenta as usr_reg,
										usu2.cuenta as usr_mod,
										param.f_literal_periodo(per.id_periodo) as periodo
									from param.tperiodo per
										INNER JOIN param.tgestion ges on ges.id_gestion = per.id_gestion
										left JOIN conta.tbancarizacion_periodo bancaper on bancaper.id_periodo = per.id_periodo
										left join segu.tusuario usu1 on usu1.id_usuario = bancaper.id_usuario_reg
										left join segu.tusuario usu2 on usu2.id_usuario = bancaper.id_usuario_mod
									where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_BANCAPER_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		favio.figueroa	
 	#FECHA:		24-05-2017 16:07:40
	***********************************/

	elsif(p_transaccion='CONTA_BANCAPER_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(per.id_periodo)
					      from param.tperiodo per
  INNER JOIN param.tgestion ges on ges.id_gestion = per.id_gestion
  left JOIN conta.tbancarizacion_periodo bancaper on bancaper.id_periodo = per.id_periodo
  left join segu.tusuario usu1 on usu1.id_usuario = bancaper.id_usuario_reg
  left join segu.tusuario usu2 on usu2.id_usuario = bancaper.id_usuario_mod
					    where ';
			
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
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;
ALTER FUNCTION "conta"."ft_bancarizacion_periodo_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
