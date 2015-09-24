CREATE OR REPLACE FUNCTION "conta"."ft_agrupador_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_agrupador_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tagrupador'
 AUTOR: 		 (admin)
 FECHA:	        22-09-2015 16:47:53
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

	v_nombre_funcion = 'conta.ft_agrupador_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_AGR_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		22-09-2015 16:47:53
	***********************************/

	if(p_transaccion='CONTA_AGR_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						agr.id_agrupador,
						agr.estado_reg,
						agr.fecha_ini,
						agr.fecha_fin,
						agr.tipo,
						agr.id_depto_conta,
						agr.id_moneda,
						agr.id_usuario_reg,
						agr.fecha_reg,
						agr.id_usuario_ai,
						agr.usuario_ai,
						agr.id_usuario_mod,
						agr.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	
						from conta.tagrupador agr
						inner join segu.tusuario usu1 on usu1.id_usuario = agr.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = agr.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_AGR_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		22-09-2015 16:47:53
	***********************************/

	elsif(p_transaccion='CONTA_AGR_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_agrupador)
					    from conta.tagrupador agr
					    inner join segu.tusuario usu1 on usu1.id_usuario = agr.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = agr.id_usuario_mod
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
ALTER FUNCTION "conta"."ft_agrupador_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
