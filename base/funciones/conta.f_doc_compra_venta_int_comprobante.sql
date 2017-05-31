CREATE OR REPLACE FUNCTION conta.f_doc_compra_venta_int_comprobante (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS SETOF record AS
$body$
DECLARE

v_parametros  		record;
v_nombre_funcion   	text;
v_resp				varchar;
v_registros  		record;  -- PARA ALMACENAR EL CONJUNTO DE DATOS RESULTADO DEL SELECT

BEGIN

     v_nombre_funcion = 'conta.f_doc_compra_venta_int_comprobante';
     v_parametros = pxp.f_get_record(p_tabla);


    /*********************************
     #TRANSACCION:    'CONTA_DOCINTCOMP_REP'
     #DESCRIPCION:     reporte de documentos relacion con comprobantes
     #AUTOR:           Gonzalo Sarmiento
     #FECHA:           01-03-2017
    ***********************************/

	IF(p_transaccion='CONTA_DOCINTCOMP_REP')then
    			FOR v_registros IN (
                  SELECT doc.fecha::date, doc.nit::varchar, doc.razon_social::varchar, pla.desc_plantilla::varchar, doc.nro_documento::varchar, doc.nro_dui::varchar,
                 doc.nro_autorizacion::varchar, doc.codigo_control::varchar, doc.importe_doc::numeric, COALESCE(doc.importe_ice::numeric,0) as importe_ice, doc.importe_descuento::numeric,
                 doc.importe_excento::numeric,
                 doc.importe_pago_liquido::numeric as liquido,
                 (doc.importe_pago_liquido - COALESCE(doc.importe_excento, 0))::numeric as importe_sujeto,
                 doc.importe_iva::numeric,
                 COALESCE(con.precio_total_final::numeric,0) as importe_gasto,
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
                 doc.id_doc_compra_venta::integer
          FROM conta.tdoc_compra_venta doc
               INNER JOIN conta.tdoc_concepto con on con.id_doc_compra_venta =
                 doc.id_doc_compra_venta
               INNER JOIN pre.tpartida par on par.id_partida = con.id_partida
               INNER JOIN param.tplantilla pla on pla.id_plantilla = doc.id_plantilla
               LEFT JOIN conta.trelacion_contable rel on rel.id_tabla =
                 con.id_concepto_ingas and rel.id_partida = con.id_partida and
                 rel.id_centro_costo = con.id_centro_costo
               LEFT JOIN conta.tcuenta cta on cta.id_cuenta = rel.id_cuenta
          WHERE doc.fecha between v_parametros.fecha_ini and
                v_parametros.fecha_fin      and
                pla.tipo_informe = 'lcv'
          UNION ALL
          SELECT doc.fecha::date, doc.nit::varchar, doc.razon_social::varchar, pla.desc_plantilla::varchar, doc.nro_documento::varchar, doc.nro_dui::varchar,
                 doc.nro_autorizacion::varchar, doc.codigo_control::varchar, doc.importe_doc::numeric, COALESCE(doc.importe_ice::numeric,0) as importe_ice, doc.importe_descuento::numeric,
                 doc.importe_excento::numeric,
                 doc.importe_pago_liquido::numeric as liquido,
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
                 doc.id_doc_compra_venta::integer
          FROM conta.tdoc_compra_venta doc
               LEFT JOIN conta.tint_comprobante cmp on cmp.id_int_comprobante =
                 doc.id_int_comprobante
               LEFT JOIN conta.tint_transaccion tra on tra.id_int_comprobante =
                 cmp.id_int_comprobante and tra.id_partida_ejecucion_dev is not null
               LEFT JOIN pre.tpartida par on par.id_partida = tra.id_partida
               INNER JOIN param.tplantilla pla on pla.id_plantilla = doc.id_plantilla
               LEFT JOIN conta.tcuenta cta on cta.id_cuenta = tra.id_cuenta
          WHERE doc.fecha between v_parametros.fecha_ini and
                v_parametros.fecha_fin and
                pla.tipo_informe = 'lcv' and
                doc.tabla_origen is null
          order by fecha, id_doc_compra_venta) LOOP
          RETURN NEXT v_registros;
          END LOOP;
END IF;

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
COST 100 ROWS 1000;