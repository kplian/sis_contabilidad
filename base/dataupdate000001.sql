/********************************************I-DAUP-AUTOR-SCHEMA-0-31/02/2019********************************************/
--SHEMA : Esquema (CONTA) contabilidad         AUTHOR:Siglas del autor de los scripts' dataupdate000001.txt
/********************************************F-DAUP-AUTOR-SCHEMA-0-31/02/2019********************************************/



/********************************************I-DAUP-MGM-SCHEMA-0-30/09/2020********************************************/

UPDATE conta.tdoc_compra_venta d
SET d.importe_doc = 1973.44,d.importe_neto=1776.10,d.importe_pago_liquido=1776.10
WHERE d.id_doc_compra_venta = 182885

UPDATE conta.tdoc_concepto 
SET c.precio_unitario= 1973.44,c.precio_total= 1973.44,c.precio_total_final=1776.10
WHERE c.id_doc_compra_venta=182885
/********************************************F-DAUP-MGM-SCHEMA-0-30/09/2020********************************************/
