CREATE OR REPLACE FUNCTION conta.ft_archivo_sigep_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_archivo_sigep_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tarchivo_sigep'
 AUTOR: 		 (gsarmiento)
 FECHA:	        10-05-2017 15:38:14
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

	v_nombre_funcion = 'conta.ft_archivo_sigep_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'CONTA_ARCSGP_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		gsarmiento
 	#FECHA:		10-05-2017 15:38:14
	***********************************/

	if(p_transaccion='CONTA_ARCSGP_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						arcsgp.id_archivo_sigep,
						arcsgp.nombre_archivo,
						arcsgp.estado_reg,
						arcsgp.url,
						arcsgp.extension,
						arcsgp.id_usuario_reg,
						arcsgp.fecha_reg,
						arcsgp.usuario_ai,
						arcsgp.id_usuario_ai,
						arcsgp.fecha_mod,
						arcsgp.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod
						from conta.tarchivo_sigep arcsgp
						inner join segu.tusuario usu1 on usu1.id_usuario = arcsgp.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = arcsgp.id_usuario_mod
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'CONTA_ARCSGP_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		gsarmiento
 	#FECHA:		10-05-2017 15:38:14
	***********************************/

	elsif(p_transaccion='CONTA_ARCSGP_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_archivo_sigep)
					    from conta.tarchivo_sigep arcsgp
					    inner join segu.tusuario usu1 on usu1.id_usuario = arcsgp.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = arcsgp.id_usuario_mod
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