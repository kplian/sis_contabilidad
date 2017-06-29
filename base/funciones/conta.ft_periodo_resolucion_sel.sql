CREATE OR REPLACE FUNCTION conta.ft_periodo_resolucion_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_periodo_resolucion_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tperiodo_resolucion'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        27-06-2017 21:35:54
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

	v_nombre_funcion = 'conta.ft_periodo_resolucion_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'CONTA_PRN_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		miguel.mamani
 	#FECHA:		27-06-2017 21:35:54
	***********************************/

	if(p_transaccion='CONTA_PRN_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						prn.id_periodo_resolucion,
						prn.estado_reg,
						prn.estado,
						prn.id_periodo,
						prn.id_depto,
						prn.fecha_reg,
						prn.usuario_ai,
						prn.id_usuario_reg,
						prn.id_usuario_ai,
						prn.id_usuario_mod,
						prn.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        pe.id_gestion,
                        param.f_literal_periodo(pe.id_periodo) as periodo
						from conta.tperiodo_resolucion prn
						inner join segu.tusuario usu1 on usu1.id_usuario = prn.id_usuario_reg
						inner join param.tperiodo pe on pe.id_periodo = prn.id_periodo
                        left join segu.tusuario usu2 on usu2.id_usuario = prn.id_usuario_mod
						where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'CONTA_PRN_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		27-06-2017 21:35:54
	***********************************/

	elsif(p_transaccion='CONTA_PRN_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_periodo_resolucion)
					    from conta.tperiodo_resolucion prn
					    inner join segu.tusuario usu1 on usu1.id_usuario = prn.id_usuario_reg
						inner join param.tperiodo pe on pe.id_periodo = prn.id_periodo
                        left join segu.tusuario usu2 on usu2.id_usuario = prn.id_usuario_mod
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