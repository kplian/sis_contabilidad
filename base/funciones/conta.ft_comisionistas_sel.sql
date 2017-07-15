CREATE OR REPLACE FUNCTION conta.ft_comisionistas_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_comisionistas_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tcomisionistas'
 AUTOR: 		 (admin)
 FECHA:	        31-05-2017 20:17:02
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

	v_nombre_funcion = 'conta.ft_comisionistas_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'CONTA_CMS_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin
 	#FECHA:		31-05-2017 20:17:02
	***********************************/

	if(p_transaccion='CONTA_CMS_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select		cm.id_comisionista,
                                    cm.nit_comisionista,
                                    cm.nro_contrato,
                                    cm.codigo_producto,
                                    cm.descripcion_producto,
                                    cm.cantidad_total_entregado,
                                    cm.cantidad_total_vendido,
                                    cm.precio_unitario,
                                    cm.monto_total,
                                    cm.monto_total_comision,
                                    cm.revisado,
                                    cm.id_periodo,
                                    cm.id_depto_conta,
                                    cm.registro,
                                    cm.tipo_comisionista,
                                    cm.lista_negra,
                                    ges.gestion,
                                    usu1.cuenta as usr_reg,
                                    usu2.cuenta as usr_mod,
                                    cm.estado_reg,
                                    cm.id_usuario_reg,
                                    cm.usuario_ai,
                                    cm.fecha_reg,
                                    cm.id_usuario_ai,
                                    cm.fecha_mod,
                                    cm.id_usuario_mod
                                    from conta.tcomisionistas cm
                                    inner join segu.tusuario usu1 on usu1.id_usuario = cm.id_usuario_reg
                                    inner join param.tperiodo per on per.id_periodo = cm.id_periodo
                                    inner join param.tgestion ges on ges.id_gestion = per.id_gestion
                                    left join segu.tusuario usu2 on usu2.id_usuario = cm.id_usuario_mod
                                    where ';
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'CONTA_CMS_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin
 	#FECHA:		31-05-2017 20:17:02
	***********************************/

	elsif(p_transaccion='CONTA_CMS_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_comisionista)
					    from conta.tcomisionistas cm
                        inner join segu.tusuario usu1 on usu1.id_usuario = cm.id_usuario_reg
                        inner join param.tperiodo per on per.id_periodo = cm.id_periodo
                        inner join param.tgestion ges on ges.id_gestion = per.id_gestion
                        left join segu.tusuario usu2 on usu2.id_usuario = cm.id_usuario_mod
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