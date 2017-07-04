CREATE OR REPLACE FUNCTION conta.ft_entrega_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_entrega_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tentrega'
 AUTOR: 		 (admin)
 FECHA:	        17-11-2016 19:50:19
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
    v_filtro			varchar;
    v_record 			record;
    v_id_usuario_rev	record;

BEGIN

	v_nombre_funcion = 'conta.ft_entrega_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'CONTA_ENT_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin
 	#FECHA:		17-11-2016 19:50:19
	***********************************/

	if(p_transaccion='CONTA_ENT_SEL')then

    	begin
    		--Sentencia de la consulta
         v_filtro = '';

            SELECT vfcl.id_oficina, vfcl.nombre_cargo,  vfcl.oficina_nombre,
            tf.id_funcionario, vfcl.desc_funcionario1 INTO v_record
            FROM segu.tusuario tu
            INNER JOIN orga.tfuncionario tf on tf.id_persona = tu.id_persona
            INNER JOIN orga.vfuncionario_cargo_lugar vfcl on vfcl.id_funcionario = tf.id_funcionario
            WHERE tu.id_usuario = p_id_usuario ;

         if p_administrador 	THEN
            v_filtro = ' 0=0 AND ';

         ELSIF v_parametros.pes_estado = 'EntregaConsulta' THEN


          select u.id_persona,count(u.id_usuario)::varchar as cant_reg
          into v_id_usuario_rev
         from wf.testado_wf es
         inner JOIN orga.tfuncionario fu on fu.id_funcionario = es.id_funcionario
         inner join segu.tusuario u on u.id_persona = fu.id_persona
         LEFT JOIN wf.testado_wf te ON te.id_estado_anterior = es.id_estado_wf
         LEFT JOIN conta.tentrega e on e.id_estado_wf = es.id_estado_wf
         WHERE e.estado = 'vbconta'
         GROUP BY u.id_usuario;

         IF(v_id_usuario_rev.cant_reg IS NULL)THEN

         v_filtro = 'tew.id_funcionario = '||v_record.id_funcionario||' AND  ';
         ELSE

         v_filtro = '(ent.id_usuario_mod = '||v_id_usuario_rev.id_persona||' OR  tew.id_funcionario = '||v_record.id_funcionario||') AND';
         END IF;
         END IF;

			v_consulta:='select
                            ent.id_entrega,
                            ent.fecha_c31,
                            ent.c31,
                            ent.estado,
                            ent.estado_reg,
                            ent.id_usuario_ai,
                            ent.usuario_ai,
                            ent.fecha_reg,
                            ent.id_usuario_reg,
                            ent.fecha_mod,
                            ent.id_usuario_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                            ent.id_depto_conta,
                            ent.id_estado_wf,
                            ent.id_proceso_wf,
							com.nro_tramite::varchar
						from conta.tentrega ent
						inner join segu.tusuario usu1 on usu1.id_usuario = ent.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = ent.id_usuario_mod
				        inner join conta.tentrega_det det on det.id_entrega = ent.id_entrega
                        inner join conta.vint_comprobante com on com.id_int_comprobante = det.id_int_comprobante
                        where  '||v_filtro;

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'CONTA_ENT_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin
 	#FECHA:		17-11-2016 19:50:19
	***********************************/

	elsif(p_transaccion='CONTA_ENT_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(ent.id_entrega)
					    from conta.tentrega ent
						inner join segu.tusuario usu1 on usu1.id_usuario = ent.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = ent.id_usuario_mod
				        inner join conta.tentrega_det det on det.id_entrega = ent.id_entrega
                        inner join conta.vint_comprobante com on com.id_int_comprobante = det.id_int_comprobante
                       	where ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
     /*********************************
 	#TRANSACCION:  'CONTA_REPENT_SEL'
 	#DESCRIPCION:	Consulta de datos para reporte de entrega
 	#AUTOR:		RAC KPLIAN
 	#FECHA:		23-11-2016 19:50:19
	***********************************/
    elseif(p_transaccion='CONTA_REPENT_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='SELECT
                            id_entrega,
                            estado::varchar,
                            c31::varchar,
                            id_depto_conta,
                            fecha_c31,
                            codigo::varchar,
                            nombre_partida::varchar,
                            importe_debe_mb::numeric,
                            importe_haber_mb::numeric,
                            importe_debe_mb_completo::numeric,
                            importe_haber_mb_completo::numeric,
                            importe_gasto_mb::numeric,
                            importe_recurso_mb::numeric,
                            factor_reversion::numeric,
                            codigo_cc::varchar,
                            codigo_categoria::varchar,
                            codigo_cg::varchar,
                            nombre_cg::varchar,
                            beneficiario::varchar,
                            glosa1::varchar,
                            id_int_comprobante,
                            id_int_comprobante_dev
                          FROM
                            conta.ventrega   e
                          WHERE id_entrega = '||v_parametros.id_entrega||'
						  ORDER by e.codigo_cg , e.codigo_categoria , e.codigo';


			--Devuelve la respuesta
			return v_consulta;

		end;
					--asd
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