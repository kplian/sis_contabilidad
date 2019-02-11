--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_orden_suborden_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_orden_suborden_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.torden_suborden'
 AUTOR: 		 (admin)
 FECHA:	        15-05-2017 10:36:02
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

	v_nombre_funcion = 'conta.ft_orden_suborden_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_ORSUO_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		15-05-2017 10:36:02
	***********************************/

	if(p_transaccion='CONTA_ORSUO_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						orsuo.id_orden_suborden,
						orsuo.id_suborden,
						orsuo.estado_reg,
						orsuo.id_orden_trabajo,
						orsuo.id_usuario_ai,
						orsuo.id_usuario_reg,
						orsuo.usuario_ai,
						orsuo.fecha_reg,
						orsuo.id_usuario_mod,
						orsuo.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        (''(''||suo.codigo||'') ''||suo.nombre)::varchar  as desc_suborden
						from conta.torden_suborden orsuo
						inner join segu.tusuario usu1 on usu1.id_usuario = orsuo.id_usuario_reg
                        inner join conta.tsuborden suo on suo.id_suborden = orsuo.id_suborden
						left join segu.tusuario usu2 on usu2.id_usuario = orsuo.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_ORSUO_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		15-05-2017 10:36:02
	***********************************/

	elsif(p_transaccion='CONTA_ORSUO_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_orden_suborden)
					    from conta.torden_suborden orsuo
						inner join segu.tusuario usu1 on usu1.id_usuario = orsuo.id_usuario_reg
                        inner join conta.tsuborden suo on suo.id_suborden = orsuo.id_suborden
						left join segu.tusuario usu2 on usu2.id_usuario = orsuo.id_usuario_mod
				        where  ';
			
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