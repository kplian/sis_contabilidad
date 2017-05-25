CREATE OR REPLACE FUNCTION "conta"."ft_oficina_ot_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_oficina_ot_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.toficina_ot'
 AUTOR: 		 (jrivera)
 FECHA:	        09-10-2015 18:48:40
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

	v_nombre_funcion = 'conta.ft_oficina_ot_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_OFOT_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		jrivera	
 	#FECHA:		09-10-2015 18:48:40
	***********************************/

	if(p_transaccion='CONTA_OFOT_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						ofot.id_oficina_ot,
						ofot.id_oficina,
						ofot.id_orden_trabajo,
						ofot.estado_reg,
						ofot.usuario_ai,
						ofot.fecha_reg,
						ofot.id_usuario_reg,
						ofot.id_usuario_ai,
						ofot.id_usuario_mod,
						ofot.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						ot.desc_orden,
						ofi.nombre	as nombre_oficina
						from conta.toficina_ot ofot
						inner join segu.tusuario usu1 on usu1.id_usuario = ofot.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = ofot.id_usuario_mod
						inner join conta.torden_trabajo ot on ot.id_orden_trabajo = ofot.id_orden_trabajo
						inner join orga.toficina ofi on ofi.id_oficina = ofot.id_oficina
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_OFOT_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		jrivera	
 	#FECHA:		09-10-2015 18:48:40
	***********************************/

	elsif(p_transaccion='CONTA_OFOT_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_oficina_ot)
					    from conta.toficina_ot ofot
					    inner join segu.tusuario usu1 on usu1.id_usuario = ofot.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = ofot.id_usuario_mod
						inner join conta.torden_trabajo ot on ot.id_orden_trabajo = ofot.id_orden_trabajo
						inner join orga.toficina ofi on ofi.id_oficina = ofot.id_oficina
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
ALTER FUNCTION "conta"."ft_oficina_ot_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
