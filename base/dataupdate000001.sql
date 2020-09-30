/********************************************I-DAUP-AUTOR-SCHEMA-0-31/02/2019********************************************/
--SHEMA : Esquema (CONTA) contabilidad         AUTHOR:Siglas del autor de los scripts' dataupdate000001.txt
/********************************************F-DAUP-AUTOR-SCHEMA-0-31/02/2019********************************************/



/********************************************I-DAUP-MGM-SCHEMA-0-30/09/2020********************************************/
--rollback
--UPDATE conta.tdoc_compra_venta SET importe_doc = 1776.1,importe_neto=1578.76,importe_pago_liquido=1578.76 WHERE id_doc_compra_venta = 182885;

--commit
UPDATE conta.tdoc_compra_venta SET importe_doc = 1973.44,importe_neto=1776.10,importe_pago_liquido=1776.10 WHERE id_doc_compra_venta = 182885;

--rollaback
--UPDATE conta.tdoc_concepto SET precio_unitario= 1776.1,precio_total= 1776.1,precio_total_final=1578.76 WHERE id_doc_compra_venta=182885;

--commit
UPDATE conta.tdoc_concepto SET precio_unitario= 1973.44,precio_total= 1973.44,precio_total_final=1776.10 WHERE id_doc_compra_venta=182885;
/********************************************F-DAUP-MGM-SCHEMA-0-30/09/2020********************************************/
