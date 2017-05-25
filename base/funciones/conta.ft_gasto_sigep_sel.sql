CREATE OR REPLACE FUNCTION conta.ft_gasto_sigep_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_gasto_sigep_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tgasto_sigep'
 AUTOR: 		 (gsarmiento)
 FECHA:	        08-05-2017 20:06:08
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

	v_nombre_funcion = 'conta.ft_gasto_sigep_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'CONTA_GTSG_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		gsarmiento
 	#FECHA:		08-05-2017 20:06:08
	***********************************/

	if(p_transaccion='CONTA_GTSG_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						gtsg.id_gasto_sigep,
						gtsg.programa,
						gtsg.gestion,
						gtsg.actividad,
						gtsg.nro_preventivo,
						gtsg.nro_comprometido,
                        gtsg.nro_devengado,
						gtsg.proyecto,
						gtsg.organismo,
						gtsg.estado_reg,
						gtsg.estado,
						gtsg.descripcion_gasto,
						gtsg.entidad_transferencia,
						gtsg.fuente,
						gtsg.objeto,
						gtsg.monto,
						gtsg.fecha_reg,
						gtsg.usuario_ai,
						gtsg.id_usuario_reg,
						gtsg.id_usuario_ai,
						gtsg.fecha_mod,
						gtsg.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod
						from conta.tgasto_sigep gtsg
						inner join segu.tusuario usu1 on usu1.id_usuario = gtsg.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = gtsg.id_usuario_mod
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'CONTA_GTSG_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		gsarmiento
 	#FECHA:		08-05-2017 20:06:08
	***********************************/

	elsif(p_transaccion='CONTA_GTSG_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_gasto_sigep)
					    from conta.tgasto_sigep gtsg
					    inner join segu.tusuario usu1 on usu1.id_usuario = gtsg.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = gtsg.id_usuario_mod
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