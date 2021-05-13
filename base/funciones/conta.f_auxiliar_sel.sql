--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_auxiliar_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.f_auxiliar_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tauxiliar'
 AUTOR: 		Gonzalo Sarmiento Sejas
 FECHA:	        21-02-2013 20:44:52
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
   ISUUE			FECHA			 AUTHOR 		 DESCRIPCION
 	1A			30/08/2018			EGS		 se aumento el campo aplicacion en las transcacciones CONTA_AUXCTA_SEL
    #71             13/08/2019      EGS              Se filtra los auxiliares que no tengan proveedores y tambien sean solo de funcionarios

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
    v_inner 			varchar;
    v_filtor_tipo_cc	varchar;
    v_id_cuenta_permitidas	varchar;
    v_add_filtro		varchar;
    v_auxiliar			varchar;

BEGIN

	v_nombre_funcion = 'conta.f_auxiliar_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'CONTA_AUXCTA_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		21-02-2013 20:44:52
	***********************************/

	if(p_transaccion='CONTA_AUXCTA_SEL')then

    	begin

            v_inner = '';
            v_add_filtro   = ' 0=0 and ';

            IF pxp.f_existe_parametro(p_tabla,'id_cuenta') THEN
                  v_inner = 'inner join conta.tcuenta_auxiliar c on  c.id_auxiliar = auxcta.id_auxiliar and c.id_cuenta ='|| v_parametros.id_cuenta::varchar;
            END IF;


            v_filtor_tipo_cc = pxp.f_get_variable_global('conta_filtrar_cuenta_por_tipo_cc_interface_junior');

             IF v_filtor_tipo_cc = 'si'  and   pxp.f_existe_parametro(p_tabla, 'id_centro_costo')  THEN

                 select
                   pxp.list(tccc.id_auxiliar::varchar)
                 into
                    v_id_cuenta_permitidas
                 from conta.ttipo_cc_cuenta tccc
                 inner join param.tcentro_costo cc on tccc.id_tipo_cc = cc.id_tipo_cc
                 where cc.id_centro_costo = v_parametros.id_centro_costo;

                 v_add_filtro = '  auxcta.id_auxiliar in ('|| COALESCE(v_id_cuenta_permitidas,'0') ||')  and ';

            END IF;

            IF pxp.f_existe_parametro(p_tabla,'no_es_proveedor') THEN
              IF v_parametros.no_es_proveedor = 'si' THEN --#71
                 v_add_filtro = v_add_filtro|| 'pro.id_proveedor is null and ';
              END IF;
            END IF;

            IF pxp.f_existe_parametro(p_tabla,'es_funcionario') THEN
              IF v_parametros.es_funcionario = 'si' THEN --#71
                 v_add_filtro = v_add_filtro|| '(auxcta.codigo_auxiliar like ''FUN%'' or auxcta.codigo_auxiliar like ''ODT%'') and';
              END IF;
            END IF;
			
          /*  IF v_add_filtro is not null THEN
				v_auxiliar=
            ELSE
            	v_auxiliar=
            END IF;
*/

    		--Sentencia de la consulta
			v_consulta:='select
						auxcta.id_auxiliar,
						auxcta.id_empresa,
						emp.nombre,
						auxcta.estado_reg,
						auxcta.codigo_auxiliar,
						auxcta.nombre_auxiliar,
						auxcta.fecha_reg,
						auxcta.id_usuario_reg,
						auxcta.id_usuario_mod,
						auxcta.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        auxcta.corriente,
                        auxcta.aplicacion,
                        auxcta.estado
						from conta.tauxiliar auxcta
						inner join segu.tusuario usu1 on usu1.id_usuario = auxcta.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = auxcta.id_usuario_mod
				        left join param.tempresa emp on emp.id_empresa=auxcta.id_empresa
                        left join param.tproveedor pro on pro.id_auxiliar = auxcta.id_auxiliar '||
                        v_inner || '
				        where  '||v_add_filtro;

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			--Devuelve la respuesta
            RAISE NOTICE 'v_consulta %',v_consulta;
             --RAISE exception 'v_consulta %',v_consulta;
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'CONTA_AUXCTA_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		21-02-2013 20:44:52
	***********************************/

	elsif(p_transaccion='CONTA_AUXCTA_CONT')then

		begin
            v_inner = '';
            v_add_filtro   = ' 0=0 and ';
            IF pxp.f_existe_parametro(p_tabla,'id_cuenta') THEN
               v_inner = 'inner join conta.tcuenta_auxiliar c on  c.id_auxiliar = auxcta.id_auxiliar and c.id_cuenta ='|| v_parametros.id_cuenta::varchar;
            END IF;

            v_filtor_tipo_cc = pxp.f_get_variable_global('conta_filtrar_cuenta_por_tipo_cc_interface_junior');

             IF v_filtor_tipo_cc = 'si'  and   pxp.f_existe_parametro(p_tabla, 'id_centro_costo')  THEN



                 select
                   pxp.list(tccc.id_auxiliar::varchar)
                 into
                    v_id_cuenta_permitidas
                 from conta.ttipo_cc_cuenta tccc
                 inner join param.tcentro_costo cc on tccc.id_tipo_cc = cc.id_tipo_cc
                 where cc.id_centro_costo = v_parametros.id_centro_costo;

                 v_add_filtro = '  auxcta.id_auxiliar in ('|| COALESCE(v_id_cuenta_permitidas,'0') ||')  and ';

            END IF;

            IF pxp.f_existe_parametro(p_tabla,'no_es_proveedor') THEN
              IF v_parametros.no_es_proveedor = 'si'  THEN --#71
                 v_add_filtro = v_add_filtro|| 'pro.id_proveedor is null and';
              END IF;
            END IF;

            IF pxp.f_existe_parametro(p_tabla,'es_funcionario') THEN
              IF v_parametros.es_funcionario = 'si' THEN --71
                 v_add_filtro = v_add_filtro|| '(auxcta.codigo_auxiliar like ''FUN%'' or auxcta.codigo_auxiliar like ''ODT%'') and';
              END IF;
            END IF;
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(auxcta.id_auxiliar)
					    from conta.tauxiliar auxcta
					    inner join segu.tusuario usu1 on usu1.id_usuario = auxcta.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = auxcta.id_usuario_mod
                        left join param.tproveedor pro on pro.id_auxiliar = auxcta.id_auxiliar '||
                        v_inner || '
					    where '||v_add_filtro ;--#47

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
            RAISE  NOTICE 'v_consulta %',v_consulta;
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
PARALLEL UNSAFE
COST 100;