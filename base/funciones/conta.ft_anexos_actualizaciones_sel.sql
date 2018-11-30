CREATE OR REPLACE FUNCTION conta.ft_anexos_actualizaciones_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_anexos_actualizaciones_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tanexos_actualizaciones'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        27-06-2017 13:39:16
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

	v_nombre_funcion = 'conta.ft_anexos_actualizaciones_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'CONTA_ANS_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		miguel.mamani
 	#FECHA:		27-06-2017 13:39:16
	***********************************/

	if(p_transaccion='CONTA_ANS_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						ans.id_anexos_actualizaciones,
						ans.descripcion_producto,
						ans.nit_proveerdor,
						ans.tipo_comision,
						ans.lista_negra,
						ans.tipo_anexo,
						ans.nit_comisionista,
						ans.monto_porcentaje,
						ans.revisado,
						ans.fecha_vigente,
						ans.nro_contrato,
						ans.id_depto_conta,
						ans.id_periodo,
						ans.tipo_documento,
						ans.precio_unitario,
						ans.codigo_producto,
						ans.estado_reg,
						ans.registro,
						ans.id_usuario_ai,
						ans.fecha_reg,
						ans.usuario_ai,
						ans.id_usuario_reg,
						ans.fecha_mod,
						ans.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        ge.gestion
						from conta.tanexos_actualizaciones ans
						inner join segu.tusuario usu1 on usu1.id_usuario = ans.id_usuario_reg
						inner join param.tperiodo pe on pe.id_periodo = ans.id_periodo
                        inner join param.tgestion ge on ge.id_gestion = pe.id_gestion
                        left join segu.tusuario usu2 on usu2.id_usuario = ans.id_usuario_mod
						where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'CONTA_ANS_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		27-06-2017 13:39:16
	***********************************/

	elsif(p_transaccion='CONTA_ANS_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_anexos_actualizaciones)
					    from conta.tanexos_actualizaciones ans
					    inner join segu.tusuario usu1 on usu1.id_usuario = ans.id_usuario_reg
						inner join param.tperiodo pe on pe.id_periodo = ans.id_periodo
                        inner join param.tgestion ge on ge.id_gestion = pe.id_gestion
                        left join segu.tusuario usu2 on usu2.id_usuario = ans.id_usuario_mod
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