--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_tipo_estado_cuenta_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_tipo_estado_cuenta_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.ttipo_estado_cuenta'
 AUTOR: 		 (admin)
 FECHA:	        26-07-2017 21:48:36
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

	v_nombre_funcion = 'conta.ft_tipo_estado_cuenta_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_TEC_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		26-07-2017 21:48:36
	***********************************/

	if(p_transaccion='CONTA_TEC_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						tec.id_tipo_estado_cuenta,
						tec.codigo,
						tec.estado_reg,
						tec.columna_codigo_aux,
						tec.columna_id_tabla,
						tec.tabla,
						tec.nombre,
						tec.usuario_ai,
						tec.fecha_reg,
						tec.id_usuario_reg,
						tec.id_usuario_ai,
						tec.id_usuario_mod,
						tec.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	
						from conta.ttipo_estado_cuenta tec
						inner join segu.tusuario usu1 on usu1.id_usuario = tec.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = tec.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_TEC_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		26-07-2017 21:48:36
	***********************************/

	elsif(p_transaccion='CONTA_TEC_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_tipo_estado_cuenta)
					    from conta.ttipo_estado_cuenta tec
					    inner join segu.tusuario usu1 on usu1.id_usuario = tec.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = tec.id_usuario_mod
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
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;