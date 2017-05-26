CREATE OR REPLACE FUNCTION conta.ft_factura_airbp_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_factura_airbp_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tfactura_airbp'
 AUTOR: 		 (gsarmiento)
 FECHA:	        12-01-2017 21:45:40
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

	v_nombre_funcion = 'conta.ft_factura_airbp_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'CONTA_FAIRBP_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		gsarmiento
 	#FECHA:		12-01-2017 21:45:40
	***********************************/

	if(p_transaccion='CONTA_FAIRBP_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						fairbp.id_factura_airbp,
						fairbp.id_doc_compra_venta,
						fairbp.tipo_cambio,
						fairbp.punto_venta,
						fairbp.id_cliente,
						fairbp.estado,
						fairbp.estado_reg,
						fairbp.id_usuario_ai,
						fairbp.id_usuario_reg,
						fairbp.fecha_reg,
						fairbp.usuario_ai,
						fairbp.id_usuario_mod,
						fairbp.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod
						from conta.tfactura_airbp fairbp
						inner join segu.tusuario usu1 on usu1.id_usuario = fairbp.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = fairbp.id_usuario_mod
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'CONTA_FAIRBP_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		gsarmiento
 	#FECHA:		12-01-2017 21:45:40
	***********************************/

	elsif(p_transaccion='CONTA_FAIRBP_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_factura_airbp)
					    from conta.tfactura_airbp fairbp
					    inner join segu.tusuario usu1 on usu1.id_usuario = fairbp.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = fairbp.id_usuario_mod
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