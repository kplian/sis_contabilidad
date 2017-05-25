CREATE OR REPLACE FUNCTION "conta"."ft_grupo_ot_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_grupo_ot_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tgrupo_ot'
 AUTOR: 		 (admin)
 FECHA:	        06-10-2014 14:11:14
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

	v_nombre_funcion = 'conta.ft_grupo_ot_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_GOT_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		06-10-2014 14:11:14
	***********************************/

	if(p_transaccion='CONTA_GOT_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						got.id_grupo_ot,
						got.descripcion,
						got.estado_reg,
						got.id_usuario_ai,
						got.id_usuario_reg,
						got.usuario_ai,
						got.fecha_reg,
						got.fecha_mod,
						got.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	
						from conta.tgrupo_ot got
						inner join segu.tusuario usu1 on usu1.id_usuario = got.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = got.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_GOT_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		06-10-2014 14:11:14
	***********************************/

	elsif(p_transaccion='CONTA_GOT_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_grupo_ot)
					    from conta.tgrupo_ot got
					    inner join segu.tusuario usu1 on usu1.id_usuario = got.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = got.id_usuario_mod
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
ALTER FUNCTION "conta"."ft_grupo_ot_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
