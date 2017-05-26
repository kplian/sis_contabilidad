CREATE OR REPLACE FUNCTION "conta"."ft_bancarizacion_gestion_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_bancarizacion_gestion_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tbancarizacion_gestion'
 AUTOR: 		 (admin)
 FECHA:	        09-02-2017 20:12:18
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

	v_nombre_funcion = 'conta.ft_bancarizacion_gestion_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_BANGES_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		09-02-2017 20:12:18
	***********************************/

	if(p_transaccion='CONTA_BANGES_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						banges.id_bancarizacion_gestion,
						banges.estado_reg,
						banges.estado,
						banges.id_gestion,
						banges.id_usuario_reg,
						banges.fecha_reg,
						banges.usuario_ai,
						banges.id_usuario_ai,
						banges.id_usuario_mod,
						banges.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
							ges.gestion as desc_gestion
						from conta.tbancarizacion_gestion banges
						inner join segu.tusuario usu1 on usu1.id_usuario = banges.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = banges.id_usuario_mod
						inner join param.tgestion ges on ges.id_gestion = banges.id_gestion
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_BANGES_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		09-02-2017 20:12:18
	***********************************/

	elsif(p_transaccion='CONTA_BANGES_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_bancarizacion_gestion)
					    from conta.tbancarizacion_gestion banges
					    inner join segu.tusuario usu1 on usu1.id_usuario = banges.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = banges.id_usuario_mod
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
ALTER FUNCTION "conta"."ft_bancarizacion_gestion_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
