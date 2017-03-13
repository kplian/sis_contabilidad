CREATE OR REPLACE FUNCTION conta.ft_doc_int_comprobante_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_doc_int_comprobante_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tdoc_int_comprobante'
 AUTOR: 		 (gsarmiento)
 FECHA:	        13-03-2017 15:41:29
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_doc_int_comprobante	integer;
    v_registros				record;

BEGIN

    v_nombre_funcion = 'conta.ft_doc_int_comprobante_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'CONTA_DOCCBTE_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		gsarmiento
 	#FECHA:		13-03-2017 15:41:29
	***********************************/

	if(p_transaccion='CONTA_DOCCBTE_INS')then

        begin
        	--Sentencia de la insercion
        	insert into conta.tdoc_int_comprobante(
			estado_reg,
			fecha,
			nit,
			razon_social,
			desc_plantilla,
			nro_documento,
			nro_dui,
			nro_autorizacion,
			codigo_control,
			importe_doc,
			importe_ice,
			importe_descuento,
			importe_excento,
			liquido,
			importe_sujeto,
			importe_iva,
			importe_gasto,
			porc_gasto_prorrateado,
			sujeto_prorrateado,
			iva_prorrateado,
			codigo,
			nro_cuenta,
			origen,
			id_int_comprobante,
			id_doc_compra_venta,
			usuario,
			id_usuario_reg,
			fecha_reg,
			id_usuario_ai,
			usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.fecha,
			v_parametros.nit,
			v_parametros.razon_social,
			v_parametros.desc_plantilla,
			v_parametros.nro_documento,
			v_parametros.nro_dui,
			v_parametros.nro_autorizacion,
			v_parametros.codigo_control,
			v_parametros.importe_doc,
			v_parametros.importe_ice,
			v_parametros.importe_descuento,
			v_parametros.importe_excento,
			v_parametros.liquido,
			v_parametros.importe_sujeto,
			v_parametros.importe_iva,
			v_parametros.importe_gasto,
			v_parametros.porc_gasto_prorrateado,
			v_parametros.sujeto_prorrateado,
			v_parametros.iva_prorrateado,
			v_parametros.codigo,
			v_parametros.nro_cuenta,
			v_parametros.origen,
			v_parametros.id_int_comprobante,
			v_parametros.id_doc_compra_venta,
			v_parametros.usuario,
			p_id_usuario,
			now(),
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			null,
			null



			)RETURNING id_doc_int_comprobante into v_id_doc_int_comprobante;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Documento Comprobante almacenado(a) con exito (id_doc_int_comprobante'||v_id_doc_int_comprobante||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_doc_int_comprobante',v_id_doc_int_comprobante::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'CONTA_DOCCBTE_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		gsarmiento
 	#FECHA:		13-03-2017 15:41:29
	***********************************/

	elsif(p_transaccion='CONTA_DOCCBTE_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.tdoc_int_comprobante set
			fecha = v_parametros.fecha,
			nit = v_parametros.nit,
			razon_social = v_parametros.razon_social,
			desc_plantilla = v_parametros.desc_plantilla,
			nro_documento = v_parametros.nro_documento,
			nro_dui = v_parametros.nro_dui,
			nro_autorizacion = v_parametros.nro_autorizacion,
			codigo_control = v_parametros.codigo_control,
			importe_doc = v_parametros.importe_doc,
			importe_ice = v_parametros.importe_ice,
			importe_descuento = v_parametros.importe_descuento,
			importe_excento = v_parametros.importe_excento,
			liquido = v_parametros.liquido,
			importe_sujeto = v_parametros.importe_sujeto,
			importe_iva = v_parametros.importe_iva,
			importe_gasto = v_parametros.importe_gasto,
			porc_gasto_prorrateado = v_parametros.porc_gasto_prorrateado,
			sujeto_prorrateado = v_parametros.sujeto_prorrateado,
			iva_prorrateado = v_parametros.iva_prorrateado,
			codigo = v_parametros.codigo,
			nro_cuenta = v_parametros.nro_cuenta,
			origen = v_parametros.origen,
			id_int_comprobante = v_parametros.id_int_comprobante,
			id_doc_compra_venta = v_parametros.id_doc_compra_venta,
			usuario = v_parametros.usuario,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_doc_int_comprobante=v_parametros.id_doc_int_comprobante;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Documento Comprobante modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_doc_int_comprobante',v_parametros.id_doc_int_comprobante::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'CONTA_DOCCBTE_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		gsarmiento
 	#FECHA:		13-03-2017 15:41:29
	***********************************/

	elsif(p_transaccion='CONTA_DOCCBTE_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tdoc_int_comprobante
            where id_doc_int_comprobante=v_parametros.id_doc_int_comprobante;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Documento Comprobante eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_doc_int_comprobante',v_parametros.id_doc_int_comprobante::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

    /*********************************
     #TRANSACCION:    'CONTA_DOCINTCOMP_INS'
     #DESCRIPCION:     Procesa el llenado de informacion en la tabla conta.tdoc_int_comprobante
     #AUTOR:           Gonzalo Sarmiento
     #FECHA:           01-03-2017
    ***********************************/

	elsif(p_transaccion='CONTA_DOCINTCOMP_INS')then

    			TRUNCATE conta.tdoc_int_comprobante;

    			FOR v_registros IN (
                  SELECT doc.fecha::date, doc.nit::varchar, doc.razon_social::varchar, pla.desc_plantilla::varchar, doc.nro_documento::varchar, doc.nro_dui::varchar,
                 doc.nro_autorizacion::varchar, doc.codigo_control::varchar, doc.importe_doc::numeric, doc.importe_ice::numeric, doc.importe_descuento::numeric,
                 doc.importe_excento::numeric, doc.importe_pago_liquido::numeric as liquido,
                 (doc.importe_pago_liquido - COALESCE(doc.importe_excento, 0))::numeric as importe_sujeto,
                 doc.importe_iva::numeric,
                 con.precio_total_final::numeric as importe_gasto,
                 (con.precio_total_final / doc.importe_pago_liquido)::numeric as porc_gasto_prorrateado,
                 case
                   when (doc.importe_pago_liquido - COALESCE(doc.importe_excento, 0)) != 0
                     then round((doc.importe_pago_liquido - COALESCE(doc.importe_excento,
                     0)) * con.precio_total_final / doc.importe_pago_liquido, 2)::numeric
                   else 0::numeric
                 end as sujeto_prorrateado,
                 case
                   when (doc.importe_pago_liquido - COALESCE(doc.importe_excento, 0)) != 0
                     then round(doc.importe_iva * con.precio_total_final /
                     doc.importe_pago_liquido, 2)::numeric
                   else 0::numeric
                 end as iva_prorrateado,
                 par.codigo::varchar,
                 cta.nro_cuenta::varchar,
                 case when doc.tabla_origen = 'cd.trendicion_det' then 'Fondo en Avance'::varchar
                 when doc.tabla_origen = 'tes.tsolicitud_rendicion_det' then 'Caja Chica'::varchar
                 end as origen,
                 doc.id_int_comprobante::integer,
                 doc.id_doc_compra_venta::integer,
                 usu.cuenta
          FROM conta.tdoc_compra_venta doc
               INNER JOIN conta.tdoc_concepto con on con.id_doc_compra_venta =
                 doc.id_doc_compra_venta
               INNER JOIN pre.tpartida par on par.id_partida = con.id_partida
               INNER JOIN param.tplantilla pla on pla.id_plantilla = doc.id_plantilla
               LEFT JOIN conta.trelacion_contable rel on rel.id_tabla =
                 con.id_concepto_ingas and rel.id_partida = con.id_partida and
                 rel.id_centro_costo = con.id_centro_costo
               LEFT JOIN conta.tcuenta cta on cta.id_cuenta = rel.id_cuenta
               LEFT JOIN segu.tusuario usu on usu.id_usuario = doc.id_usuario_reg
          WHERE doc.fecha between v_parametros.fecha_ini and
                v_parametros.fecha_fin      and
                pla.tipo_informe = 'lcv'
          UNION ALL
          SELECT doc.fecha::date, doc.nit::varchar, doc.razon_social::varchar, pla.desc_plantilla::varchar, doc.nro_documento::varchar, doc.nro_dui::varchar,
                 doc.nro_autorizacion::varchar, doc.codigo_control::varchar, doc.importe_doc::numeric, doc.importe_ice::numeric, doc.importe_descuento::numeric,
                 doc.importe_excento::numeric, doc.importe_pago_liquido::numeric as liquido,
                 (doc.importe_neto - doc.importe_excento)::numeric as importe_sujeto,
                 doc.importe_iva::numeric,
                 round((tra.importe_gasto /(1 - tra.factor_reversion)),2)::numeric as importe_gasto,
                 (tra.importe_gasto /(1 - tra.factor_reversion) / conta.f_importe_gasto_comprobante(cmp.id_int_comprobante))::numeric as porc_gasto_prorrateado,
                 case when doc.id_int_comprobante is not null then
                 round((doc.importe_pago_liquido - COALESCE(doc.importe_excento, 0)) * (tra.importe_gasto /(1 - tra.factor_reversion) / conta.f_importe_gasto_comprobante(cmp.id_int_comprobante)),2)::numeric
                 else (doc.importe_pago_liquido - COALESCE(doc.importe_excento,0))::numeric end as sujeto_prorrateado,
                 case when doc.id_int_comprobante is not null then
                 round((doc.importe_pago_liquido - COALESCE(doc.importe_excento, 0)) * (tra.importe_gasto /(1 - tra.factor_reversion) / conta.f_importe_gasto_comprobante(cmp.id_int_comprobante))*0.13,2)::numeric
                 else doc.importe_iva::numeric end as iva_prorrateado,
                 par.codigo::varchar,
                 cta.nro_cuenta::varchar,
                 case when doc.tabla_origen is null then 'Pago a Proveedor'::varchar end as origen,
                 doc.id_int_comprobante::integer,
                 doc.id_doc_compra_venta::integer,
                 usu.cuenta
          FROM conta.tdoc_compra_venta doc
               LEFT JOIN conta.tint_comprobante cmp on cmp.id_int_comprobante =
                 doc.id_int_comprobante
               LEFT JOIN conta.tint_transaccion tra on tra.id_int_comprobante =
                 cmp.id_int_comprobante and tra.id_partida_ejecucion_dev is not null
               LEFT JOIN pre.tpartida par on par.id_partida = tra.id_partida
               INNER JOIN param.tplantilla pla on pla.id_plantilla = doc.id_plantilla
               LEFT JOIN conta.tcuenta cta on cta.id_cuenta = tra.id_cuenta
               LEFT JOIN segu.tusuario usu on usu.id_usuario = doc.id_usuario_reg
          WHERE doc.fecha between v_parametros.fecha_ini and
                v_parametros.fecha_fin and
                pla.tipo_informe = 'lcv' and
                doc.tabla_origen is null
          order by fecha, id_doc_compra_venta) LOOP
                INSERT INTO conta.tdoc_int_comprobante
                (fecha, nit, razon_social, desc_plantilla, nro_documento, nro_dui,
                nro_autorizacion, codigo_control, importe_doc, importe_ice, importe_descuento,
                importe_excento, liquido, importe_sujeto, importe_iva, importe_gasto,
                porc_gasto_prorrateado, sujeto_prorrateado, iva_prorrateado, codigo, nro_cuenta,
                origen, id_int_comprobante, id_doc_compra_venta, usuario, id_usuario_reg)VALUES
                (v_registros.fecha, v_registros.nit, v_registros.razon_social, v_registros.desc_plantilla, v_registros.nro_documento, v_registros.nro_dui,
                v_registros.nro_autorizacion, v_registros.codigo_control, v_registros.importe_doc, v_registros.importe_ice, v_registros.importe_descuento,
                v_registros.importe_excento, v_registros.liquido, v_registros.importe_sujeto,
                v_registros.importe_iva, v_registros.importe_gasto, v_registros.porc_gasto_prorrateado,
                v_registros.sujeto_prorrateado, v_registros.iva_prorrateado, v_registros.codigo,
                v_registros.nro_cuenta, v_registros.origen, v_registros.id_int_comprobante,
                v_registros.id_doc_compra_venta, v_registros.cuenta, p_id_usuario);
          END LOOP;

          v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Procesamiento Exitoso');
          return v_resp;

	else

    	raise exception 'Transaccion inexistente: %',p_transaccion;

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