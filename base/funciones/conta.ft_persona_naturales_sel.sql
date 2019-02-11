CREATE OR REPLACE FUNCTION conta.ft_persona_naturales_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_persona_naturales_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tpersona_naturales'
 AUTOR: 		 (admin)
 FECHA:	        31-05-2017 20:17:08
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

	v_nombre_funcion = 'conta.ft_persona_naturales_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'CONTA_PNS_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin
 	#FECHA:		31-05-2017 20:17:08
	***********************************/

	if(p_transaccion='CONTA_PNS_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						pns.id_persona_natural,
						pns.precio_unitario,
						pns.descripcion,
						pns.codigo_cliente,
						pns.tipo_documento,
						pns.codigo_producto,
						pns.estado_reg,
						pns.nombre,
						pns.importe_total,
						pns.nro_documeneto,
						pns.cantidad_producto,
						pns.id_usuario_reg,
						pns.fecha_reg,
						pns.usuario_ai,
						pns.id_usuario_ai,
						pns.fecha_mod,
						pns.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        pns.revisado,
                        pns.id_periodo,
                        pns.id_depto_conta,
                        pns.registro,
                        pns.tipo_persona_natural,
                        pns.lista_negra,
                        ges.gestion
						from conta.tpersona_naturales pns
						inner join segu.tusuario usu1 on usu1.id_usuario = pns.id_usuario_reg
						inner join param.tperiodo per on per.id_periodo = pns.id_periodo
                        inner join param.tgestion ges on ges.id_gestion = per.id_gestion
                        left join segu.tusuario usu2 on usu2.id_usuario = pns.id_usuario_mod
                        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'CONTA_PNS_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin
 	#FECHA:		31-05-2017 20:17:08
	***********************************/

	elsif(p_transaccion='CONTA_PNS_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_persona_natural)
					    from conta.tpersona_naturales pns
					  	inner join segu.tusuario usu1 on usu1.id_usuario = pns.id_usuario_reg
						inner join param.tperiodo per on per.id_periodo = pns.id_periodo
                        inner join param.tgestion ges on ges.id_gestion = per.id_gestion
                        left join segu.tusuario usu2 on usu2.id_usuario = pns.id_usuario_mod
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