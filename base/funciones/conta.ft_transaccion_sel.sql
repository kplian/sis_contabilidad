CREATE OR REPLACE FUNCTION "conta"."ft_transaccion_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_transaccion_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.ttransaccion'
 AUTOR: 		 (admin)
 FECHA:	        22-07-2013 03:51:00
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

	v_nombre_funcion = 'conta.ft_transaccion_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_CONTRA_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		22-07-2013 03:51:00
	***********************************/

	if(p_transaccion='CONTA_CONTRA_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						contra.id_transaccion,
						contra.id_comprobante,
						contra.id_cuenta,
						contra.id_auxiliar,
						contra.id_centro_costo,
						contra.id_partida,
						contra.id_transaccion_fk,
						contra.id_partida_ejecucion,
						contra.estado_reg,
						contra.descripcion,
						contra.fecha_reg,
						contra.id_usuario_reg,
						contra.id_usuario_mod,
						contra.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	
						from conta.ttransaccion contra
						inner join segu.tusuario usu1 on usu1.id_usuario = contra.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = contra.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CONTRA_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		22-07-2013 03:51:00
	***********************************/

	elsif(p_transaccion='CONTA_CONTRA_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_transaccion)
					    from conta.ttransaccion contra
					    inner join segu.tusuario usu1 on usu1.id_usuario = contra.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = contra.id_usuario_mod
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
ALTER FUNCTION "conta"."ft_transaccion_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
