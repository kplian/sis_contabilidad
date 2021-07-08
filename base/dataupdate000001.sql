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

/********************************************I-DAUP-MGM-CONTA-1-30/09/2020********************************************/
--rollback
--UPDATE conta.tdoc_compra_venta SET nota_debito_agencia='' WHERE id_doc_compra_venta = 181038;
--UPDATE conta.tdoc_compra_venta SET nota_debito_agencia='' WHERE id_doc_compra_venta = 181039;
--UPDATE conta.tdoc_compra_venta SET nota_debito_agencia='' WHERE id_doc_compra_venta = 181040;
--UPDATE conta.tdoc_compra_venta SET nota_debito_agencia='' WHERE id_doc_compra_venta = 181041;
--UPDATE conta.tdoc_compra_venta SET nota_debito_agencia='' WHERE id_doc_compra_venta = 181042;
--UPDATE conta.tdoc_compra_venta SET nota_debito_agencia='' WHERE id_doc_compra_venta = 181982;
--UPDATE conta.tdoc_compra_venta SET nota_debito_agencia='' WHERE id_doc_compra_venta = 181984;
--UPDATE conta.tdoc_compra_venta SET nota_debito_agencia='' WHERE id_doc_compra_venta = 181987;
--UPDATE conta.tdoc_compra_venta SET nota_debito_agencia='' WHERE id_doc_compra_venta = 181988;
--UPDATE conta.tdoc_compra_venta SET nota_debito_agencia='' WHERE id_doc_compra_venta = 181991;
--UPDATE conta.tdoc_compra_venta SET nota_debito_agencia='' WHERE id_doc_compra_venta = 181996;
--UPDATE conta.tdoc_compra_venta SET nota_debito_agencia='' WHERE id_doc_compra_venta = 181997;
--UPDATE conta.tdoc_compra_venta SET nota_debito_agencia='' WHERE id_doc_compra_venta = 181998;

--commit
UPDATE conta.tdoc_compra_venta SET nota_debito_agencia='232572' WHERE id_doc_compra_venta = 181038; 
UPDATE conta.tdoc_compra_venta SET nota_debito_agencia='232641' WHERE id_doc_compra_venta = 181039;
UPDATE conta.tdoc_compra_venta SET nota_debito_agencia='232816' WHERE id_doc_compra_venta = 181040;
UPDATE conta.tdoc_compra_venta SET nota_debito_agencia='232816' WHERE id_doc_compra_venta = 181041;
UPDATE conta.tdoc_compra_venta SET nota_debito_agencia='232811' WHERE id_doc_compra_venta = 181042;
UPDATE conta.tdoc_compra_venta SET nota_debito_agencia='233020' WHERE id_doc_compra_venta = 181982;
UPDATE conta.tdoc_compra_venta SET nota_debito_agencia='233022' WHERE id_doc_compra_venta = 181984;
UPDATE conta.tdoc_compra_venta SET nota_debito_agencia='233023' WHERE id_doc_compra_venta = 181987;
UPDATE conta.tdoc_compra_venta SET nota_debito_agencia='233026' WHERE id_doc_compra_venta = 181988;
UPDATE conta.tdoc_compra_venta SET nota_debito_agencia='232987' WHERE id_doc_compra_venta = 181991;
UPDATE conta.tdoc_compra_venta SET nota_debito_agencia='232986' WHERE id_doc_compra_venta = 181996;
UPDATE conta.tdoc_compra_venta SET nota_debito_agencia='233025' WHERE id_doc_compra_venta = 181997;
UPDATE conta.tdoc_compra_venta SET nota_debito_agencia='233021' WHERE id_doc_compra_venta = 181998;

/********************************************F-DAUP-MGM-CONTA-1-30/09/2020********************************************/
/********************************************I-DAUP-MGM-CONTA-0-01/10/2020********************************************/
--rollback
--UPDATE conta.tdoc_compra_venta SET nro_documento=930385235377 WHERE id_doc_compra_venta=181870;
--commit
UPDATE conta.tdoc_compra_venta SET nro_documento=9303852305377 WHERE id_doc_compra_venta=181870;
/********************************************F-DAUP-MGM-CONTA-0-01/10/2020********************************************/


/********************************************I-DAUP-MGM-CONTA-0-12/10/2020********************************************/
--rollback
--UPDATE conta.tdoc_compra_venta SET id_periodo=45,fecha= '07/09/2020' WHERE id_doc_compra_venta=185445;
--commit
UPDATE conta.tdoc_compra_venta SET id_periodo=46,fecha= '07/10/2020' WHERE id_doc_compra_venta=185445;

/********************************************F-DAUP-MGM-CONTA-0-12/10/2020********************************************/

/********************************************I-DAUP-MGM-CONTA-0-21/10/2020********************************************/
--rollback
--begin;
--UPDATE conta.tdoc_compra_venta SET id_periodo=45,fecha= '06/09/2020' WHERE id_doc_compra_venta=186010;
--commit;

--commit
BEGIN;
UPDATE conta.tdoc_compra_venta SET id_periodo=46,fecha= '06/10/2020' WHERE id_doc_compra_venta=186010;
COMMIT;
/********************************************F-DAUP-MGM-CONTA-0-21/10/2020********************************************/

/********************************************I-DAUP-EGS-CONTA-0-21/10/2020********************************************/
--rollback
--begin;
-- UPDATE conta.tint_comprobante SET
--         id_clase_comprobante = 5
-- WHERE id_int_comprobante in (96995,97033,97036,97038,97039,97040);
--commit;

--commit
BEGIN;
UPDATE conta.tint_comprobante SET
        id_clase_comprobante = 4
WHERE id_int_comprobante in (96995,97033,97036,97038,97039,97040);
COMMIT;
/********************************************F-DAUP-EGS-CONTA-0-21/10/2020********************************************/
/********************************************I-DAUP-EGS-CONTA-1-04/11/2020********************************************/
--rollback
--begin;
-- UPDATE conta.tint_comprobante SET
--         id_clase_comprobante = 5
--WHERE id_int_comprobante in (98078,98081,98082);
--commit;

--commit
BEGIN;
UPDATE conta.tint_comprobante SET
    id_clase_comprobante = 4
WHERE id_int_comprobante in (98078,98081,98082);
COMMIT;
/********************************************F-DAUP-EGS-CONTA-1-04/11/2020********************************************/

/********************************************I-DAUP-EGS-CONTA-2-05/11/2020********************************************/
--rollback
--begin;
-- UPDATE conta.tint_comprobante SET
--         id_clase_comprobante = 5
--WHERE id_int_comprobante in (98489,98493,98596,98600,98602,98606,98607,98610,98613,98616);
--commit;

--commit
BEGIN;
UPDATE conta.tint_comprobante SET
    id_clase_comprobante = 4
WHERE id_int_comprobante in (98489,98493,98596,98600,98602,98606,98607,98610,98613,98616);
COMMIT;
/********************************************F-DAUP-EGS-CONTA-2-05/11/2020********************************************/


/********************************************I-DAUP-MGM-CONTA-1-06/11/2020********************************************/
--rollback
--begin;
--UPDATE conta.tdoc_compra_venta 
--SET sw_pgs='reg'
--WHERE id_doc_compra_venta=187344;
--commit;

--commit
BEGIN;
UPDATE conta.tdoc_compra_venta 
SET sw_pgs='proc'
WHERE id_doc_compra_venta=187344;
COMMIT;
/********************************************F-DAUP-MGM-CONTA-1-06/11/2020********************************************/


/********************************************I-DAUP-MGM-CONTA-2-06/11/2020********************************************/
--rollback
--begin;
--UPDATE conta.tint_comprobante
--SET beneficiario = 'SERVIDUMBRES - CLAUDINA FERRUFINO OJALVO'
--WHERE id_int_comprobante = 98910;
--commit;

--commit
BEGIN;
UPDATE conta.tint_comprobante
SET beneficiario = 'SERVIDUMBRES- CALIXTO OROSCO HINOJOSA'
WHERE id_int_comprobante = 98910;
COMMIT;
/********************************************F-DAUP-MGM-CONTA-2-06/11/2020********************************************/


/********************************************I-DAUP-MGM-CONTA-3-11/11/2020********************************************/
--rollback
--begin;
--UPDATE conta.tint_transaccion
--SET glosa='ES SAN JUAN BAUTISTA S.R.L. - Combustibles para Vehiculos ( PAGO COMB. VEH. 3064DUD< REUBICACIÓN DE ESTRUCTURA LD031, LÍNEA 230 KV SAN JOSÉ – VILLA TUNARI, CONTRATO N° 191/2020.) Nro Doc: 162055'
--WHERE id_int_transaccion = 1398006;

--UPDATE conta.tint_transaccion
--SET glosa='ES SAN JUAN BAUTISTA S.R.L. - Combustibles para Vehiculos ( PAGO COMB. VEH. 3064DUD< REUBICACIÓN DE ESTRUCTURA LD031, LÍNEA 230 KV SAN JOSÉ – VILLA TUNARI, CONTRATO N° 191/2020.) Nro Doc: 162055'
--WHERE id_int_transaccion = 1398007;
--commit;

--commit
BEGIN;
UPDATE conta.tint_transaccion
SET glosa='ES SAN JUAN BAUTISTA S.R.L. - Combustibles para Vehiculos ( PAGO COMB. VEH. 3064DUD- REUBICACIÓN DE ESTRUCTURA LD031, LÍNEA 230 KV SAN JOSÉ – VILLA TUNARI, CONTRATO N° 191/2020.
 ) Nro Doc: 162055'
WHERE id_int_transaccion = 1398006;

UPDATE conta.tint_transaccion
SET glosa='ES SAN JUAN BAUTISTA S.R.L. - Combustibles para Vehiculos ( PAGO COMB. VEH. 3064DUD- REUBICACIÓN DE ESTRUCTURA LD031, LÍNEA 230 KV SAN JOSÉ – VILLA TUNARI, CONTRATO N° 191/2020.
 ) Nro Doc: 162055'
WHERE id_int_transaccion = 1398007;
COMMIT;
/********************************************F-DAUP-MGM-CONTA-3-11/11/2020********************************************/



/********************************************I-DAUP-MGM-CONTA-0-16/11/2020********************************************/
--rollback
--begin;
--UPDATE conta.tdoc_compra_venta SET id_periodo=46,fecha= '11/10/2020' WHERE id_doc_compra_venta=192599;
--commit;

BEGIN;
UPDATE conta.tdoc_compra_venta SET id_periodo=47,fecha= '11/11/2020' WHERE id_doc_compra_venta=192599;
COMMIT;
/********************************************F-DAUP-MGM-CONTA-0-16/11/2020********************************************/
/********************************************I-DAUP-EGS-CONTA-3-17/11/2020********************************************/
--rollback
--begin;
-- update conta.tint_transaccion set
--     id_auxiliar = 13354
-- Where id_int_transaccion = 1401607;
--commit;
BEGIN;
update conta.tint_transaccion set
    id_auxiliar = 12830
Where id_int_transaccion = 1401607;
COMMIT;
/********************************************F-DAUP-EGS-CONTA-3-17/11/2020********************************************/
/********************************************I-DAUP-EGS-CONTA-ETR-1902-30/11/2020********************************************/
--rollback
--begin;
-- update conta.tint_transaccion set
--     id_auxiliar = 3109
-- Where id_int_transaccion = 1353070;
--commit;
BEGIN;
update conta.tint_transaccion set
    id_auxiliar = null
Where id_int_transaccion = 1353070;
COMMIT;
/********************************************F-DAUP-EGS-CONTA-ETR-1902-30/11/2020********************************************/
/********************************************I-DAUP-EGS-CONTA-ETR-1987-30/11/2020********************************************/
--rollback
--begin;
-- UPDATE conta.tint_comprobante SET
--         id_clase_comprobante = 5
--WHERE id_int_comprobante in (101685);
--commit;

--commit
BEGIN;
UPDATE conta.tint_comprobante SET
    id_clase_comprobante = 4
WHERE id_int_comprobante in (101685);
COMMIT;
/********************************************F-DAUP-EGS-CONTA-ETR-1987-30/11/2020********************************************/

/********************************************I-DAUP-MGM-CONTA-0-22/12/2020********************************************/

--rollback
--begin;
--UPDATE conta.tdoc_compra_venta SET id_periodo=47,fecha= '12/11/2020' WHERE id_doc_compra_venta=200044;
--commit;

BEGIN;
UPDATE conta.tdoc_compra_venta SET id_periodo=48,fecha= '12/12/2020' WHERE id_doc_compra_venta=200044;
COMMIT;
/********************************************F-DAUP-MGM-CONTA-0-22/12/2020********************************************/



/********************************************I-DAUP-MGM-CONTA-1-22/12/2020********************************************/

--rollback
--begin;
--UPDATE conta.tdoc_compra_venta SET id_periodo=48,fecha= '12/12/2020' WHERE id_doc_compra_venta=200044;
--UPDATE conta.tdoc_compra_venta SET id_periodo=47,fecha= '12/11/2020' WHERE id_doc_compra_venta=200045;
--commit;

BEGIN;
UPDATE conta.tdoc_compra_venta SET id_periodo=48,fecha= '09/12/2020' WHERE id_doc_compra_venta=200044;
UPDATE conta.tdoc_compra_venta SET id_periodo=48,fecha= '12/12/2020' WHERE id_doc_compra_venta=200045;
COMMIT;
/********************************************F-DAUP-MGM-CONTA-1-22/12/2020********************************************/
/********************************************I-DAUP-EGS-CONTA-ETR-2355-30/12/2020********************************************/
--rollback
--begin;
-- update conta.tint_transaccion set
--     id_auxiliar = null
-- Where id_int_transaccion = 1298084;
--commit;
BEGIN;
update conta.tint_transaccion set
    id_auxiliar = 12318
Where id_int_transaccion = 1298084;
COMMIT;
/********************************************F-DAUP-EGS-CONTA-ETR-2355-30/12/2020********************************************/


/********************************************I-DAUP-MGM-CONTA-0-12/01/2020********************************************/
--rollback
--begin;
--UPDATE conta.tint_transaccion SET id_auxiliar=12651 WHERE id_int_transaccion=1229169;
--commit;
UPDATE conta.tint_transaccion SET id_auxiliar=NULL WHERE id_int_transaccion=1229169;
---

--rollback
--begin;
--UPDATE conta.tint_transaccion SET id_auxiliar=12651 WHERE id_int_transaccion=1229162;
--commit;
UPDATE conta.tint_transaccion SET id_auxiliar=NULL WHERE id_int_transaccion=1229162;


--rollback
--begin;
--UPDATE conta.tint_transaccion SET id_auxiliar=NULL WHERE id_int_transaccion=1438124;
--commit;
UPDATE conta.tint_transaccion SET id_auxiliar=13772 WHERE id_int_transaccion=1438124;

--rollback
--begin;
--UPDATE conta.tint_transaccion SET id_auxiliar=NULL WHERE id_int_transaccion=1294565;
--commit;
UPDATE conta.tint_transaccion SET id_auxiliar=13776 WHERE id_int_transaccion=1294565;

--rollback
--begin;
--UPDATE conta.tint_transaccion SET id_auxiliar=NULL WHERE id_int_transaccion=1409310;
--commit;
UPDATE conta.tint_transaccion SET id_auxiliar=13776 WHERE id_int_transaccion=1409310;

--rollback
--begin;
--UPDATE conta.tint_transaccion SET id_auxiliar=NULL WHERE id_int_transaccion=1409308;
--commit;
UPDATE conta.tint_transaccion SET id_auxiliar=13775 WHERE id_int_transaccion=1409308;


--rollback
--begin;
--UPDATE conta.tint_transaccion SET id_auxiliar=NULL WHERE id_int_transaccion=1409312;
--commit;
UPDATE conta.tint_transaccion SET id_auxiliar=13774 WHERE id_int_transaccion=1409312;

--rollback
--begin;
--UPDATE conta.tint_transaccion SET id_auxiliar=NULL WHERE id_int_transaccion=1482705;
--commit;
UPDATE conta.tint_transaccion SET id_auxiliar=13772 WHERE id_int_transaccion=1482705;


--rollback
--begin;
--UPDATE conta.tint_transaccion SET id_auxiliar=NULL WHERE id_int_transaccion=1482708;
--commit;
UPDATE conta.tint_transaccion SET id_auxiliar=13774 WHERE id_int_transaccion=1482708;


--rollback
--begin;
--UPDATE conta.tint_transaccion SET id_auxiliar=NULL WHERE id_int_transaccion=1482710;
--commit;
UPDATE conta.tint_transaccion SET id_auxiliar=13775 WHERE id_int_transaccion=1482710;

--rollback
--begin;
--UPDATE conta.tint_transaccion SET id_auxiliar=NULL WHERE id_int_transaccion=1482708;
--commit;
UPDATE conta.tint_transaccion SET id_auxiliar=13776 WHERE id_int_transaccion=1482708;
/********************************************F-DAUP-MGM-CONTA-0-12/01/2020********************************************/


/********************************************I-DAUP-MGM-CONTA-0-13/01/2021********************************************/
--rollback
--begin;
--UPDATE conta.tint_transaccion SET id_auxiliar=13776 WHERE id_int_transaccion=1482708;
--commit;
UPDATE conta.tint_transaccion SET id_auxiliar=13774 WHERE id_int_transaccion=1482708;
/********************************************F-DAUP-MGM-CONTA-0-13/01/2021********************************************/

/********************************************I-DAUP-MGM-CONTA-0-15/01/2021********************************************/
--rollback
--begin;
--UPDATE conta.tint_transaccion SET id_auxiliar=null WHERE id_int_transaccion=1482712;
--commit;
UPDATE conta.tint_transaccion SET id_auxiliar=13776 WHERE id_int_transaccion=1482712;
/********************************************F-DAUP-MGM-CONTA-0-15/01/2021********************************************/


/********************************************I-DAUP-MGM-CONTA-0-25/01/2021********************************************/
--rollback
--begin;
--UPDATE conta.tint_transaccion SET id_cuenta=4591,id_partida=4119 WHERE id_int_transaccion = 1484563; 
--UPDATE conta.tint_transaccion SET id_cuenta=4591,id_partida=4119 WHERE id_int_transaccion = 1484564;
--commit;

UPDATE conta.tint_transaccion SET id_cuenta=4910,id_partida=4259 WHERE id_int_transaccion = 1484563; 
UPDATE conta.tint_transaccion SET id_cuenta=4910,id_partida=4259 WHERE id_int_transaccion = 1484564;
/********************************************F-DAUP-MGM-CONTA-0-25/01/2021********************************************/

/********************************************I-DAUP-MMV-CONTA-ETR-2920-10/02/2021********************************************/
update conta.tint_comprobante  set
    id_usuario_reg = 366
where id_int_comprobante in (108273,
                             108274,
                             108275,
                             108276,
                             108277,
                             108328);

update conta.tint_transaccion set
    id_usuario_reg = 366
where id_int_comprobante in (108273,
                             108274,
                             108275,
                             108276,
                             108277,
                             108328);
/********************************************F-DAUP-MMV-CONTA-ETR-2920-10/02/2021********************************************/


/********************************************I-DAUP-MGM-CONTA-0-19/02/2021********************************************/
--rollback
--begin;
--UPDATE conta.tdoc_compra_venta SET id_funcionario=NULL WHERE id_doc_compra_venta=204893;
--commit;

BEGIN;
UPDATE conta.tdoc_compra_venta SET id_funcionario=607 WHERE id_doc_compra_venta=204893;
COMMIT;
/********************************************F-DAUP-MGM-CONTA-0-19/02/2021********************************************/

/********************************************I-DAUP-MGM-CONTA-1-19/02/2021********************************************/
--rollback
--begin;
--UPDATE conta.tint_transaccion SET glosa='DIEGO PLACIDO - Viaticos del Personal ( PAGO POR VIATICOS A LA CIUDAD DE TRINIDAD  DEL 04 AL 09/01/2021 ING. HORACIO CONDARCO ) Nro Doc:' WHERE id_int_transaccion=1489199;
--commit;

BEGIN;
UPDATE conta.tint_transaccion SET glosa='HORACIO CONDARCO - Viaticos del Personal ( PAGO POR VIATICOS A LA CIUDAD DE TRINIDAD  DEL 04 AL 09/01/2021 ING. HORACIO CONDARCO ) Nro Doc:' WHERE id_int_transaccion=1489199;
COMMIT;
/********************************************F-DAUP-MGM-CONTA-1-19/02/2021********************************************/




/********************************************I-DAUP-MGM-CONTA-1-22/02/2021********************************************/
--rollback
--begin;
--UPDATE conta.tint_transaccion SET glosa='CREDITO FISCAL SUBSIDIO LACTANCIA DICIEMBRE/20 OF. CENTRAL' WHERE id_int_transaccion=1533488;
--UPDATE conta.tint_transaccion SET glosa='CREDITO FISCAL SUBSIDIO LACTANCIA DICIEMBRE/20 OF. CENTRAL' WHERE id_int_transaccion=1533489;
--commit;

BEGIN;
UPDATE conta.tint_transaccion SET glosa='CREDITO FISCAL SUBSIDIO LACTANCIA ENERO/21 OF. CENTRAL' WHERE id_int_transaccion=1533488;
UPDATE conta.tint_transaccion SET glosa='CREDITO FISCAL SUBSIDIO LACTANCIA ENERO/21 OF. CENTRAL' WHERE id_int_transaccion=1533489;
COMMIT;
/********************************************F-DAUP-MGM-CONTA-1-22/02/2021********************************************/


/********************************************I-DAUP-MGM-CONTA-2-22/02/2021********************************************/
--rollback
--begin;
--UPDATE conta.tint_comprobante SET beneficiario='PROVEEDORES VARIOS' WHERE id_int_comprobante=109044;
--commit;

BEGIN;
UPDATE conta.tint_comprobante SET beneficiario='WILLY CANAVIRI' WHERE id_int_comprobante=109044;
COMMIT;
/********************************************F-DAUP-MGM-CONTA-2-22/02/2021********************************************/

/********************************************I-DAUP-MGM-CONTA-3-22/02/2021********************************************/
--rollback
--begin;
--UPDATE conta.tint_transaccion SET glosa='TECNOPOR S.A. - Suministros Menores ( COMPRZ< KOLLER DE PLASTOFORMO ) Nro Doc: 2622' WHERE id_int_transaccion=1533891;
--UPDATE conta.tint_transaccion SET glosa='TECNOPOR S.A. - Suministros Menores ( COMPRZ< KOLLER DE PLASTOFORMO ) Nro Doc: 2622' WHERE id_int_transaccion=1533892;
--commit;

BEGIN;
UPDATE conta.tint_transaccion SET glosa='TECNOPOR S.A. - Suministros Menores ( COMPRA KOLLER DE PLASTOFORMO ) Nro Doc: 2622' WHERE id_int_transaccion=1533891;
UPDATE conta.tint_transaccion SET glosa='TECNOPOR S.A. - Suministros Menores ( COMPRA KOLLER DE PLASTOFORMO ) Nro Doc: 2622' WHERE id_int_transaccion=1533892;
COMMIT;
/********************************************F-DAUP-MGM-CONTA-3-22/02/2021********************************************/



/********************************************I-DAUP-MGM-CONTA-ETR-3059-04/03/2021********************************************/

--rollback
--UPDATE conta.tint_transaccion SET id_auxiliar=NULL WHERE id_int_transaccion= 1534678;
--commit;

UPDATE conta.tint_transaccion SET id_auxiliar=1 WHERE id_int_transaccion= 1534678;

/********************************************F-DAUP-MGM-CONTA-ETR-3059-04/03/2021********************************************/


/********************************************I-DAUP-MGM-CONTA-ETR-3450-26/03/2021********************************************/
--rollback
--UPDATE conta.tint_transaccion SET glosa='BOLIVIANA DE AVIACIÓN - Gastos de Viaje Transporte ( TKT CBB/LPB/CBB 16/03 INSPECCIÓN SUBESTACIÓN LA PALCA ) Nro Doc: 9304877139027' WHERE id_int_transaccion= 1565753;
--commit;
UPDATE conta.tint_transaccion SET glosa='BOLIVIANA DE AVIACIÓN - Gastos de Viaje Transporte ( TKT CBB/LPB/CBB 16/03 INSPECCIÓN SUBESTACIÓN LA PALCA - MACHACA HERRERA NORMA KAREN ) Nro Doc: 9304877139027' WHERE id_int_transaccion= 1565753;
--rollback
--UPDATE conta.tint_transaccion SET glosa='BOLIVIANA DE AVIACIÓN - Gastos de Viaje Transporte ( TKT CBB/LPB/CBB 16/03 INSPECCIÓN SUBESTACIÓN LA PALCA ) Nro Doc: 9304877139027' WHERE id_int_transaccion= 1565754;
--commit;
UPDATE conta.tint_transaccion SET glosa='BOLIVIANA DE AVIACIÓN - Gastos de Viaje Transporte ( TKT CBB/LPB/CBB 16/03 INSPECCIÓN SUBESTACIÓN LA PALCA - MACHACA HERRERA NORMA KAREN ) Nro Doc: 9304877139027' WHERE id_int_transaccion= 1565754;
--rollback
--UPDATE conta.tint_transaccion SET glosa='BOLIVIANA DE AVIACIÓN - Gastos de Viaje Transporte ( TKT CBB/LPB/CBB 16/03 INSPECCIÓN SUBESTACIÓN LA PALCA ) Nro Doc: 9304877139027' WHERE id_int_transaccion= 1565755;
--commit;
UPDATE conta.tint_transaccion SET glosa='BOLIVIANA DE AVIACIÓN - Gastos de Viaje Transporte ( TKT CBB/LPB/CBB 16/03 INSPECCIÓN SUBESTACIÓN LA PALCA - MACHACA HERRERA NORMA KAREN ) Nro Doc: 9304877139027' WHERE id_int_transaccion= 1565755;
/********************************************F-DAUP-MGM-CONTA-ETR-3450-26/03/2021********************************************/


/********************************************I-DAUP-MGM-CONTA-ETR-3526-06/04/2021********************************************/
--rollback
--update conta.tdoc_compra_venta set sw_pgs='no' where id_doc_compra_venta=218741;
--update conta.tdoc_compra_venta set sw_pgs='no' where id_doc_compra_venta=218740;
--update conta.tdoc_compra_venta set sw_pgs='no' where id_doc_compra_venta=218730;
--update conta.tdoc_compra_venta set sw_pgs='no' where id_doc_compra_venta=218673;
--update conta.tdoc_compra_venta set sw_pgs='no' where id_doc_compra_venta=218651;
--update conta.tdoc_compra_venta set sw_pgs='no' where id_doc_compra_venta=218647;
--update conta.tdoc_compra_venta set sw_pgs='no' where id_doc_compra_venta=218637;
--update conta.tdoc_compra_venta set sw_pgs='no' where id_doc_compra_venta=218634;
--update conta.tdoc_compra_venta set sw_pgs='no' where id_doc_compra_venta=218633;
--update conta.tdoc_compra_venta set sw_pgs='no' where id_doc_compra_venta=218630;
--update conta.tdoc_compra_venta set sw_pgs='no' where id_doc_compra_venta=218625;
--update conta.tdoc_compra_venta set sw_pgs='no' where id_doc_compra_venta=218606;
--update conta.tdoc_compra_venta set sw_pgs='no' where id_doc_compra_venta=218589;
--update conta.tdoc_compra_venta set sw_pgs='no' where id_doc_compra_venta=218586;
--update conta.tdoc_compra_venta set sw_pgs='no' where id_doc_compra_venta=218584;
--update conta.tdoc_compra_venta set sw_pgs='no' where id_doc_compra_venta=218582;
--update conta.tdoc_compra_venta set sw_pgs='no' where id_doc_compra_venta=218572;
--update conta.tdoc_compra_venta set sw_pgs='no' where id_doc_compra_venta=218566;
--commit;
update conta.tdoc_compra_venta set sw_pgs='reg' where id_doc_compra_venta=218741;
update conta.tdoc_compra_venta set sw_pgs='reg' where id_doc_compra_venta=218740;
update conta.tdoc_compra_venta set sw_pgs='reg' where id_doc_compra_venta=218730;
update conta.tdoc_compra_venta set sw_pgs='reg' where id_doc_compra_venta=218673;
update conta.tdoc_compra_venta set sw_pgs='reg' where id_doc_compra_venta=218651;
update conta.tdoc_compra_venta set sw_pgs='reg' where id_doc_compra_venta=218647;
update conta.tdoc_compra_venta set sw_pgs='reg' where id_doc_compra_venta=218637;
update conta.tdoc_compra_venta set sw_pgs='reg' where id_doc_compra_venta=218634;
update conta.tdoc_compra_venta set sw_pgs='reg' where id_doc_compra_venta=218633;
update conta.tdoc_compra_venta set sw_pgs='reg' where id_doc_compra_venta=218630;
update conta.tdoc_compra_venta set sw_pgs='reg' where id_doc_compra_venta=218625;
update conta.tdoc_compra_venta set sw_pgs='reg' where id_doc_compra_venta=218606;
update conta.tdoc_compra_venta set sw_pgs='reg' where id_doc_compra_venta=218589;
update conta.tdoc_compra_venta set sw_pgs='reg' where id_doc_compra_venta=218586;
update conta.tdoc_compra_venta set sw_pgs='reg' where id_doc_compra_venta=218584;
update conta.tdoc_compra_venta set sw_pgs='reg' where id_doc_compra_venta=218582;
update conta.tdoc_compra_venta set sw_pgs='reg' where id_doc_compra_venta=218572;
update conta.tdoc_compra_venta set sw_pgs='reg' where id_doc_compra_venta=218566;

/********************************************F-DAUP-MGM-CONTA-ETR-3526-06/04/2021********************************************/

/********************************************I-DAUP-MGM-CONTA-ETR-3973-19/05/2021********************************************/
--update conta.tauxiliar set estado='no';
update conta.tauxiliar set estado='si';
/********************************************F-DAUP-MGM-CONTA-ETR-3973-19/05/2021********************************************/


/********************************************I-DAUP-MGM-CONTA-ETR-4078-25/02/2021********************************************/
--rollback
--begin;
--UPDATE conta.tint_comprobante SET beneficiario='SERVIDUMBRES - VIRGILIO VILLCA CONDOR' WHERE id_int_comprobante=117092;
--commit;

BEGIN;
UPDATE conta.tint_comprobante SET beneficiario='SEVIDUMBRES - VIRGILIO VILLCA CONDORI' WHERE id_int_comprobante=117092;
COMMIT;
/********************************************F-DAUP-MGM-CONTA-ETR-4078-25/02/2021********************************************/


/********************************************I-DAUP-MGM-CONTA-31/05/2021********************************************/
--UPDATE conta.tdoc_compra_venta SET sw_pgs='no' WHERE id_doc_compra_venta in (232051,232048,232046,232045,232042,232039,232038,232037,232036,232034,232033,232032,232031,);
UPDATE conta.tdoc_compra_venta SET sw_pgs='reg' WHERE id_doc_compra_venta=232051;
UPDATE conta.tdoc_compra_venta SET sw_pgs='reg' WHERE id_doc_compra_venta=232048;
UPDATE conta.tdoc_compra_venta SET sw_pgs='reg' WHERE id_doc_compra_venta=232046;
UPDATE conta.tdoc_compra_venta SET sw_pgs='reg' WHERE id_doc_compra_venta=232045;
UPDATE conta.tdoc_compra_venta SET sw_pgs='reg' WHERE id_doc_compra_venta=232042;
UPDATE conta.tdoc_compra_venta SET sw_pgs='reg' WHERE id_doc_compra_venta=232039;
UPDATE conta.tdoc_compra_venta SET sw_pgs='reg' WHERE id_doc_compra_venta=232038;
UPDATE conta.tdoc_compra_venta SET sw_pgs='reg' WHERE id_doc_compra_venta=232037;
UPDATE conta.tdoc_compra_venta SET sw_pgs='reg' WHERE id_doc_compra_venta=232036;
UPDATE conta.tdoc_compra_venta SET sw_pgs='reg' WHERE id_doc_compra_venta=232034;
UPDATE conta.tdoc_compra_venta SET sw_pgs='reg' WHERE id_doc_compra_venta=232033;
UPDATE conta.tdoc_compra_venta SET sw_pgs='reg' WHERE id_doc_compra_venta=232032;
UPDATE conta.tdoc_compra_venta SET sw_pgs='reg' WHERE id_doc_compra_venta=232031;
/********************************************F-DAUP-MGM-CONTA-31/05/2021********************************************/
/********************************************I-DAUP-MGM-CONTA-ETR-4324-22/06/2021********************************************/
--UPDATE conta.tdoc_compra_venta
---SET obs='VIÁTICOS 3 DÍAS SUBESTACIONES VILLA TUNARI, CHIMORE Y CARRASCO UN DÍA 66<5, UN DIA 70%, RETORNO 100% DEL 31/05 AL 02/06'
--WHERE id_doc_compra_venta=235570;

UPDATE conta.tdoc_compra_venta
SET obs='VIÁTICOS 3 DÍAS SUBESTACIONES VILLA TUNARI, CHIMORE Y CARRASCO UN DÍA 665, UN DIA 70%, RETORNO 100% DEL 31/05 AL 02/06'
WHERE id_doc_compra_venta=235570;
/********************************************F-DAUP-MGM-CONTA-ETR-4324-22/06/2021********************************************/
/********************************************I-DAUP-MGM-CONTA-ETR-4324-02-22/06/2021********************************************/
--UPDATE conta.tdoc_concepto
--SET descripcion='VIÁTICOS 3 DÍAS SUBESTACIONES VILLA TUNARI, CHIMORE Y CARRASCO UN DÍA 66<5, UN DIA 70%, RETORNO 100% DEL 31/05 AL 02/06'
--WHERE id_doc_concepto=213942;

UPDATE conta.tdoc_concepto
SET descripcion='VIÁTICOS 3 DÍAS SUBESTACIONES VILLA TUNARI, CHIMORE Y CARRASCO UN DÍA 665, UN DIA 70%, RETORNO 100% DEL 31/05 AL 02/06'
WHERE id_doc_concepto=213942;
/********************************************F-DAUP-MGM-CONTA-ETR-4324-02-22/06/2021********************************************/
/********************************************I-DAUP-MGM-CONTA-ETR-4073-07/07/2021********************************************/
UPDATE conta.tdoc_compra_venta as d
SET nro_tramite_aux = t.nro_tramite_aux_old
FROM conta.tmp t
WHERE trim(t.nro_documento)=trim(d.nro_documento)  and trim(t.nro_autorizacion)=trim(d.nro_autorizacion);
/********************************************F-DAUP-MGM-CONTA-ETR-4073-07/07/2021********************************************/