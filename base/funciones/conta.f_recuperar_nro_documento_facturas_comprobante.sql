CREATE OR REPLACE FUNCTION conta.f_recuperar_nro_documento_facturas_comprobante (
  ct_id_int_comprobante integer
)
RETURNS varchar AS
$body$
DECLARE
  	v_documentos 	record;
    v_i				integer;
    v_array_documentos varchar[];
BEGIN

	v_i=0;
	FOR v_documentos IN (select d.nro_documento
                          from conta.tint_comprobante c
                          inner join conta.tdoc_compra_venta d on d.id_int_comprobante=c.id_int_comprobante
                          where c.id_int_comprobante=ct_id_int_comprobante)LOOP

    v_array_documentos[v_i]=v_documentos.nro_documento;
    v_i = v_i + 1;
    END LOOP;

    return array_to_string(v_array_documentos,',');
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;