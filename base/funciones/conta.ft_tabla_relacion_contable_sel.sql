--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_tabla_relacion_contable_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_tabla_relacion_contable_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.ttabla_relacion_contable'
 AUTOR: 		 (admin)
 FECHA:	        16-05-2013 21:05:26
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

	v_nombre_funcion = 'conta.ft_tabla_relacion_contable_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_TABRECON_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		16-05-2013 21:05:26
	***********************************/

	if(p_transaccion='CONTA_TABRECON_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						tabrecon.id_tabla_relacion_contable,
						tabrecon.estado_reg,
						tabrecon.tabla,
						tabrecon.esquema,
                        tabrecon.tabla_id,
						tabrecon.fecha_reg,
						tabrecon.id_usuario_reg,
						tabrecon.fecha_mod,
						tabrecon.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						tabrecon.tabla_id_fk,
						tabrecon.recorrido_arbol,
                        tabrecon.tabla_codigo_auxiliar,
                        tabrecon.tabla_id_auxiliar,
                        tabrecon.tabla_codigo_aplicacion
						from conta.ttabla_relacion_contable tabrecon
						inner join segu.tusuario usu1 on usu1.id_usuario = tabrecon.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = tabrecon.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_TABRECON_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		16-05-2013 21:05:26
	***********************************/

	elsif(p_transaccion='CONTA_TABRECON_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_tabla_relacion_contable)
					    from conta.ttabla_relacion_contable tabrecon
					    inner join segu.tusuario usu1 on usu1.id_usuario = tabrecon.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = tabrecon.id_usuario_mod
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