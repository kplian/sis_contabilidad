CREATE OR REPLACE FUNCTION "conta"."ft_regimen_simplificado_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_regimen_simplificado_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tregimen_simplificado'
 AUTOR: 		 (admin)
 FECHA:	        31-05-2017 20:17:05
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

	v_nombre_funcion = 'conta.ft_regimen_simplificado_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_RSO_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		31-05-2017 20:17:05
	***********************************/

	if(p_transaccion='CONTA_RSO_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						rso.id_simplificado,
						rso.precio_unitario,
						rso.descripcion,
						rso.codigo_cliente,
						rso.cantidad_bonificado,
						rso.codigo_producto,
						rso.estado_reg,
						rso.descripcion_bonificado,
						rso.importe_bonificado,
						rso.nombre,
						rso.descuento,
						rso.cantidad_bonificacion,
						rso.cantidad_producto,
						rso.nit,
						rso.id_usuario_reg,
						rso.fecha_reg,
						rso.usuario_ai,
						rso.id_usuario_ai,
						rso.fecha_mod,
						rso.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	
						from conta.tregimen_simplificado rso
						inner join segu.tusuario usu1 on usu1.id_usuario = rso.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = rso.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_RSO_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		31-05-2017 20:17:05
	***********************************/

	elsif(p_transaccion='CONTA_RSO_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_simplificado)
					    from conta.tregimen_simplificado rso
					    inner join segu.tusuario usu1 on usu1.id_usuario = rso.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = rso.id_usuario_mod
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
ALTER FUNCTION "conta"."ft_regimen_simplificado_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
