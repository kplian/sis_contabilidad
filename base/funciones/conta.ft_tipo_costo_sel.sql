CREATE OR REPLACE FUNCTION conta.ft_tipo_costo_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistemas de Costos
 FUNCION: 		conta.ft_tipo_costo_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'cos.ttipo_costo'
 AUTOR: 		 (admin)
 FECHA:	        27-12-2016 20:53:14
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
    v_where				varchar;
    v_filtro 			varchar;
    v_id_gestion		integer;

BEGIN

	v_nombre_funcion = 'conta.ft_tipo_costo_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'COS_TCO_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin
 	#FECHA:		27-12-2016 20:53:14
	***********************************/

	if(p_transaccion='COS_TCO_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						tco.id_tipo_costo,
						tco.codigo,
						tco.nombre,
						tco.sw_trans,
						tco.descripcion,
						tco.id_tipo_costo_fk,
						tco.estado_reg,
						tco.id_usuario_ai,
						tco.usuario_ai,
						tco.fecha_reg,
						tco.id_usuario_reg,
						tco.id_usuario_mod,
						tco.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod
						from conta.ttipo_costo tco
						inner join segu.tusuario usu1 on usu1.id_usuario = tco.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = tco.id_usuario_mod
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'COS_TCO_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin
 	#FECHA:		27-12-2016 20:53:14
	***********************************/

	elsif(p_transaccion='COS_TCO_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_tipo_costo)
					    from conta.ttipo_costo tco
					    inner join segu.tusuario usu1 on usu1.id_usuario = tco.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = tco.id_usuario_mod
					    where ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;

   /*********************************
     #TRANSACCION:  'COS_TICOSARB_SEL'
     #DESCRIPCION:    consulta en formato arbol para tipos de costo
     #AUTOR:            Rensi Arteaga Copari
     #FECHA:            27-12-2016
    ***********************************/

    elseif(p_transaccion='COS_TICOSARB_SEL')then

        begin
              if(v_parametros.id_padre = '%') then
                v_where := ' tco.id_tipo_costo_fk is NULL';

              else
                v_where := ' tco.id_tipo_costo_fk = '||v_parametros.id_padre;
              end if;

            --Sentencia de la consulta
            v_consulta:='select
						tco.id_tipo_costo,
						tco.codigo,
						CASE
                        WHEN tco.nombre = ''CLASIFICADOR DE COSTOS''::varchar then tco.nombre||'' - ''||g.gestion
                        ELSE
                        tco.nombre
                        END::VARCHAR as nombre,
						tco.sw_trans,
						tco.descripcion,
						tco.id_tipo_costo_fk,
						tco.estado_reg,
						tco.id_usuario_ai,
						tco.usuario_ai,
						tco.fecha_reg,
						tco.id_usuario_reg,
						tco.id_usuario_mod,
						tco.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                         case
                          when (tco.id_tipo_costo_fk is null )then
                               ''raiz''::varchar
                          when (tco.sw_trans=''titular'' )then
                               ''hijo''::varchar
                          when (tco.sw_trans=''movimiento'' )then
                               ''hoja''::varchar
                          END as tipo_nodo,
                          tco.id_gestion
                        from conta.ttipo_costo tco
						inner join segu.tusuario usu1 on usu1.id_usuario = tco.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = tco.id_usuario_mod
                        inner join param.tgestion g on g.id_gestion = tco.id_gestion
                        where  '||v_where||' and  tco.estado_reg = ''activo''
                        ORDER BY codigo ';

            raise notice '%',v_consulta;

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