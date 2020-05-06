
/***********************************I-DAT-RAC-CONTA-0-01/01/2012*****************************************/
--PAra poder usar la funcion al restaurar  archivos de DATA

CREATE OR REPLACE VIEW pxp.vtabla_llave_secuencia(
    tabla,
    llave,
    secuencia)
AS
WITH fq_objects AS(
  SELECT c.oid,
         (n.nspname::text || '.'::text) || c.relname::text AS fqname,
         c.relkind,
         c.relname AS relation
  FROM pg_class c
       JOIN pg_namespace n ON n.oid = c.relnamespace), sequences AS(
    SELECT fq_objects.oid,
           fq_objects.fqname AS secuencia
    FROM fq_objects
    WHERE fq_objects.relkind = 'S'::"char"), tables AS(
      SELECT fq_objects.oid,
             fq_objects.fqname AS tabla
      FROM fq_objects
      WHERE fq_objects.relkind = 'r'::"char"), llaves AS(
        SELECT DISTINCT n.nspname AS esquema,
               c.relname AS tabla,
               a.attname AS llave
        FROM pg_class c
             JOIN pg_namespace n ON n.oid = c.relnamespace
             JOIN pg_attribute a ON a.attrelid = c.oid
             JOIN pg_constraint cc ON cc.conrelid = c.oid AND cc.conkey [ 1 ] =
               a.attnum
        WHERE c.relkind = 'r'::"char" AND
              cc.contype = 'p'::"char" AND
              a.attnum > 0 AND
              NOT a.attisdropped)
          SELECT t.tabla,
                 k.llave,
                 s.secuencia
          FROM pg_depend d
               JOIN sequences s ON s.oid = d.objid
               JOIN tables t ON t.oid = d.refobjid
               JOIN llaves k ON ((k.esquema::text || '.'::text) || k.tabla::text
                 ) = t.tabla
          WHERE d.deptype = 'a'::"char";


/***********************************F-DAT-RAC-CONTA-0-01/01/2012*****************************************/



/***********************************I-DAT-GSS-CONTA-48-20/02/2013*****************************************/

/*
*	Author: Gonzalo Sarmiento Sejas GSS
*	Date: 20/02/2013
*	Description: Build the menu definition and the composition
*/
/*

Para  definir la la metadata, menus, roles, etc

1) sincronize ls funciones y procedimientos del sistema
2)  verifique que la primera linea de los datos sea la insercion del sistema correspondiente
3)  exporte los datos a archivo SQL (desde la interface de sistema en sis_seguridad),
    verifique que la codificacion  se mantenga en UTF8 para no distorcionar los caracteres especiales
4)  remplaze los sectores correspondientes en este archivo en su totalidad:  (el orden es importante)
                             menu,
                             funciones,
                             procedimietnos
*/


INSERT INTO segu.tsubsistema ( codigo, nombre, prefijo, estado_reg, nombre_carpeta, id_subsis_orig)
VALUES ('CONTA', 'Sistema de Contabilidad', 'CONTA', 'activo', 'contabilidad', NULL);

-------------------------------------
--DEFINICION DE INTERFACES
-----------------------------------

select pxp.f_insert_tgui ('SISTEMA DE CONTABILIDAD', '', 'CONTA', 'si', 1, '', 1, '', '', 'CONTA');
select pxp.f_insert_tgui ('Plan de Cuentas', 'Cuentas', 'CTA', 'si', 1, 'sis_contabilidad/vista/cuenta/Cuenta.php', 2, '', 'Cuenta', 'CONTA');
select pxp.f_insert_tgui ('Auxiliares de Cuentas', 'Auxiliares de cuenta', 'AUXCTA', 'si', 2, 'sis_contabilidad/vista/auxiliar/Auxiliar.php', 2, '', 'Auxiliar', 'CONTA');
select pxp.f_insert_tgui ('Ordenes de Trabajo', 'ordenes de trabajo', 'ODT', 'si', 3, 'sis_contabilidad/vista/orden_trabajo/OrdenTrabajo.php', 2, '', 'OrdenTrabajo', 'CONTA');

select pxp.f_insert_testructura_gui ('CONTA', 'SISTEMA');
select pxp.f_insert_testructura_gui ('CTA', 'CONTA');
select pxp.f_insert_testructura_gui ('AUXCTA', 'CONTA');
select pxp.f_insert_testructura_gui ('ODT', 'CONTA');


select pxp.f_insert_tgui ('Config Tipo Cuenta', 'Configuracion de numero para los tipos de cuenta', 'CTIP', 'si', 1, 'sis_contabilidad/vista/config_tipo_cuenta/ConfigTipoCuenta.php', 2, '', 'ConfigTipoCuenta', 'CONTA');
select pxp.f_insert_testructura_gui ('CTIP', 'CONTA');


/* Data for the 'conta.tconfig_tipo_cuenta' table  (Records 1 - 5) */

INSERT INTO conta.tconfig_tipo_cuenta ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "nro_base", "tipo_cuenta")
VALUES (1, NULL, E'2013-02-26 15:38:28.392', NULL, E'activo', 1, E'activo');
INSERT INTO conta.tconfig_tipo_cuenta ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "nro_base", "tipo_cuenta")
VALUES (1, NULL, E'2013-02-26 15:38:34.610', NULL, E'activo', 2, E'pasivo');
INSERT INTO conta.tconfig_tipo_cuenta ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "nro_base", "tipo_cuenta")
VALUES (1, NULL, E'2013-02-26 15:38:40.187', NULL, E'activo', 3, E'patrimonio');
INSERT INTO conta.tconfig_tipo_cuenta ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "nro_base", "tipo_cuenta")
VALUES (1, NULL, E'2013-02-26 15:38:46.675', NULL, E'activo', 4, E'gasto');
INSERT INTO conta.tconfig_tipo_cuenta ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "nro_base", "tipo_cuenta")
VALUES (1, NULL, E'2013-02-26 15:38:52.716', NULL, E'activo', 5, E'ingreso');


/***********************************F-DAT-GSS-CONTA-48-20/02/2013*****************************************/


/***********************************I-DAT-RAC-CONTA-05-29/05/2013*****************************************/

select pxp.f_insert_tgui ('Clases de Comprobantes', 'Clases de Comprobantes', 'CCBT', 'si', 6, 'sis_contabilidad/vista/clase_comprobante/ClaseComprobante.php', 2, '', 'ClaseComprobante', 'CONTA');
select pxp.f_insert_testructura_gui ('CCBT', 'CONTA');

SELECT * FROM param.f_inserta_documento('CONTA', 'CDIR', 'Comprobante de Diario', 'periodo', NULL, 'depto', NULL);

SELECT * FROM param.f_inserta_documento('CONTA', 'CPAG', 'Comprobante de Pago', 'periodo', NULL, 'depto', NULL);

/***********************************F-DAT-RAC-CONTA-05-29/05/2013*****************************************/


/****************************************I-DAT-JRR-CONTA-0-15/05/2013************************************************/

select pxp.f_insert_tgui ('Relaciones Contables por Tabla', 'Relaciones Contables por Tabla', 'RELCON', 'si', 1, 'sis_contabilidad/vista/tabla_relacion_contable/TablaRelacionContable.php', 2, '', 'TablaRelacionContable', 'CONTA');
select pxp.f_insert_tgui ('Relaciones Contables', 'Relaciones Contables', 'RELACON', 'si', 4, '', 2, '', '', 'CONTA');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'PROVCUEN', 'si', 1, 'sis_contabilidad/vista/proveedor_cuenta/Proveedor.php', 3, '', 'ProveedorCuenta', 'CONTA');
select pxp.f_insert_tgui ('Definición de Relaciones Contables', 'Definición de Relaciones Contables', 'DEFRECONCAR', 'si', 1, '', 2, '', '', 'CONTA');
select pxp.f_insert_tgui ('Relaciones Contables Generales', 'Relaciones Contables Generales', 'RELCONGEN', 'si', 2, 'sis_contabilidad/vista/tipo_relacion_contable/TipoRelacionContableGeneral.php', 3, '', 'TipoRelacionContableGeneral', 'CONTA');
select pxp.f_insert_tgui ('Concepto de Gasto', 'Concepto de Gasto', 'CONGASCUE', 'si', 2, 'sis_contabilidad/vista/concepto_ingas_cta/ConceptoIngas.php', 3, '', 'ConceptoIngasCuenta', 'CONTA');
select pxp.f_insert_testructura_gui ('RELCON', 'DEFRECONCAR');
select pxp.f_insert_testructura_gui ('RELACON', 'CONTA');
select pxp.f_insert_testructura_gui ('PROVCUEN', 'RELACON');
select pxp.f_insert_testructura_gui ('DEFRECONCAR', 'CONTA');
select pxp.f_insert_testructura_gui ('RELCONGEN', 'RELACON');
select pxp.f_insert_testructura_gui ('CONGASCUE', 'RELACON');

/****************************************F-DAT-JRR-CONTA-0-15/05/2013************************************************/


/***********************************I-DAT-GSS-CONTA-9-10/06/2013*****************************************/

select pxp.f_insert_tgui ('Plantilla Comprobante', 'comprobante', 'CMPB', 'si', 5, 'sis_contabilidad/vista/plantilla_comprobante/PlantillaComprobante.php', 2, '', 'PlantillaComprobante', 'CONTA');
select pxp.f_insert_tgui ('Detalle de Comprobante', 'Detalle de Comprobante', 'CMPB.1', 'no', 0, 'sis_contabilidad/vista/detalle_plantilla_comprobante/DetallePlantillaComprobante.php', 3, '', '50%', 'CONTA');

select pxp.f_insert_testructura_gui ('CMPB', 'CONTA');
select pxp.f_insert_testructura_gui ('CMPB.1', 'CMPB');



/***********************************F-DAT-GSS-CONTA-9-10/06/2013*****************************************/






/***********************************I-DAT-RAC-CONTA-0-10/07/2013*****************************************/


/* Data for the 'conta.ttabla_relacion_contable' table  (Records 1 - 2) */

INSERT INTO conta.ttabla_relacion_contable ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tabla_relacion_contable", "tabla", "esquema", "tabla_id")
VALUES (1, NULL, E'2013-06-25 14:29:34.603', NULL, E'activo', 1, E'tconcepto_ingas', E'PARAM', E'id_concepto_ingas');

INSERT INTO conta.ttabla_relacion_contable ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tabla_relacion_contable", "tabla", "esquema", "tabla_id")
VALUES (1, NULL, E'2013-07-10 17:39:38.107', NULL, E'activo', 2, E'tcuenta_bancaria', E'TES', E'id_cuenta_bancaria');

INSERT INTO conta.ttipo_relacion_contable ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg",  "nombre_tipo_relacion", "codigo_tipo_relacion", "tiene_centro_costo", "tiene_partida", "tiene_auxiliar", "id_tabla_relacion_contable")
VALUES (1, NULL, E'2013-06-25 14:32:13.255', NULL, E'activo',  E'Cuenta para realizar compras', E'CUECOMP', E'si-general', E'si', E'si', 1);

INSERT INTO conta.ttipo_relacion_contable ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg",  "nombre_tipo_relacion", "codigo_tipo_relacion", "tiene_centro_costo", "tiene_partida", "tiene_auxiliar", "id_tabla_relacion_contable")
VALUES (1, NULL, E'2013-07-10 17:40:17.829', NULL, E'activo',  E'Cuentas Bancarias', E'CUEBANCEGRE', E'no', E'no', E'si', 2);

--menu de cuentas contable por cuenta bancaria
select pxp.f_insert_tgui ('Clases de Comprobantes', 'Clases de Comprobantes', 'CCBT', 'si', 6, 'sis_contabilidad/vista/clase_comprobante/ClaseComprobante.php', 2, '', 'ClaseComprobante', 'CONTA');
select pxp.f_insert_tgui ('Cuentas Bancarias', 'relacion de cuentas bancarias y cuentas contables', 'RELCCCB', 'si', 4, 'sis_contabilidad/vista/cta_cuenta_bancaria/CtaCuentaBancaria.php', 3, '', 'CtaCuentaBancaria', 'CONTA');
select pxp.f_insert_testructura_gui ('CCBT', 'CONTA');
select pxp.f_insert_testructura_gui ('RELCCCB', 'RELACON');



/***********************************F-DAT-RAC-CONTA-0-10/07/2013*****************************************/

/***********************************I-DAT-RCM-CONTA-0-15/07/2013*****************************************/
select pxp.f_insert_tgui ('Comprobantes', 'Comprobantes', 'CBTE.1', 'si', 3, '', 2, '', '', 'CONTA');
select pxp.f_insert_tgui ('Registro de Comprobantes', 'Registro de Comprobantes', 'CBTE.1.1', 'si', 1, 'sis_contabilidad/vista/comprobante/Comprobante.php', 3, '', 'Comprobante', 'CONTA');

select pxp.f_insert_testructura_gui ('CBTE.1', 'CONTA');
select pxp.f_insert_testructura_gui ('CBTE.1.1', 'CBTE.1');
/***********************************F-DAT-RCM-CONTA-0-15/07/2013*****************************************/



/***********************************I-DAT-RAC-CONTA-0-03/09/2013*****************************************/


INSERT INTO conta.ttabla_relacion_contable ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tabla_relacion_contable", "tabla", "esquema", "tabla_id")
VALUES (1, NULL, E'2013-08-27 20:11:39.946', NULL, E'activo', 3, E'tproveedor', E'PARAM', E'id_proveedor');

INSERT INTO conta.ttabla_relacion_contable ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tabla_relacion_contable", "tabla", "esquema", "tabla_id")
VALUES (1, NULL, E'2013-08-28 06:22:11.955', NULL, E'activo', 4, E'tdepto', E'PARAM', E'id_depto');

--tipo relacion contable, IVA- CF
INSERT INTO conta.ttipo_relacion_contable ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "nombre_tipo_relacion", "codigo_tipo_relacion", "tiene_centro_costo", "tiene_partida", "tiene_auxiliar", "id_tabla_relacion_contable")
VALUES (1, NULL, E'2013-08-26 23:33:17.859', NULL, E'activo',  E'IVA- CF', E'IVA-CF', E'no', E'si', E'si', NULL);

--tipo relacion contable, Cuenta  Devengado Proveedor
INSERT INTO conta.ttipo_relacion_contable ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg",  "nombre_tipo_relacion", "codigo_tipo_relacion", "tiene_centro_costo", "tiene_partida", "tiene_auxiliar", "id_tabla_relacion_contable")
VALUES (1, NULL, E'2013-08-27 20:12:31.331', NULL, E'activo',  E'Cuenta  Devengado Proveedor', E'CUENDEVPRO', E'no', E'si', E'si', 3);


--tipo relacion contable, Centro de Costo Depto Conta
INSERT INTO conta.ttipo_relacion_contable ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg",  "nombre_tipo_relacion", "codigo_tipo_relacion", "tiene_centro_costo", "tiene_partida", "tiene_auxiliar", "id_tabla_relacion_contable")
VALUES (1, NULL, E'2013-08-28 06:23:24.403', NULL, E'activo',  E'Centro de Costo Depto Conta', E'CCDEPCON', E'si', E'no', E'no', 4);

select pxp.f_insert_tgui ('Departamentos', 'Cuntas por Deptos Contables', 'DEPTCON', 'si', 5, 'sis_contabilidad/vista/cta_relacion_contable/CtaDepto.php', 3, '', 'CtaDepto', 'CONTA');
select pxp.f_insert_testructura_gui ('DEPTCON', 'RELACON');

/***********************************F-DAT-RAC-CONTA-0-03/09/2013*****************************************/



/***********************************I-DAT-RCM-CONTA-18-29/08/2013*****************************************/
select pxp.f_insert_tgui ('Registro de Comprobantes', 'Registro de Comprobantes', 'CBTE.1.1', 'si', 1, 'sis_contabilidad/vista/int_comprobante/IntComprobante.php', 3, '', 'IntComprobante', 'CONTA');

select pxp.f_insert_tgui ('Plantilla de Documentos', 'Plantilla de Documentos', 'PLADOC', 'si', 1, 'sis_contabilidad/vista/plantilla/Plantilla.php', 2, '', 'PlantillaConta', 'CONTA');
select pxp.f_insert_testructura_gui ('PLADOC', 'DEFRECONCAR');

select pxp.f_add_catalog('CONTA','tplantilla_calculo__prioridad','1');
select pxp.f_add_catalog('CONTA','tplantilla_calculo__prioridad','2');
select pxp.f_add_catalog('CONTA','tplantilla_calculo__prioridad','3');

select pxp.f_add_catalog('CONTA','tplantilla_calculo__debe_haber','debe');
select pxp.f_add_catalog('CONTA','tplantilla_calculo__debe_haber','haber');

select pxp.f_add_catalog('CONTA','tplantilla_calculo__tipo_importe','porcentaje');
select pxp.f_add_catalog('CONTA','tplantilla_calculo__tipo_importe','importe');

select pxp.f_add_catalog('CONTA','tcomprobante__accion','contable');
select pxp.f_add_catalog('CONTA','tcomprobante__accion','ejecucion');

select pxp.f_insert_tgui ('Gestión de Períodos', 'Gestión de Períodos', 'CONPER', 'si', 3, 'sis_contabilidad/vista/periodo_subsistema/PeriodoConta.php', 2, '', 'PeriodoConta', 'CONTA');
select pxp.f_insert_testructura_gui ('CONPER', 'CONTA');

select pxp.f_insert_tgui ('Libros Contables', 'Libros Contables', 'CBTE.1.3', 'si', 3, '', 2, '', '', 'CONTA');
select pxp.f_insert_tgui ('Libro Diario', 'Libro Diario', 'CBTE.1.3.1', 'si', 1, 'sis_contabilidad/vista/comprobante/Comprobante.php', 3, '', 'Comprobante', 'CONTA');
select pxp.f_insert_testructura_gui ('CBTE.1.3', 'CONTA');
select pxp.f_insert_testructura_gui ('CBTE.1.3.1', 'CBTE.1.3');

/***********************************F-DAT-RCM-CONTA-0-29/08/2013*****************************************/



/***********************************I-DAT-RAC-CONTA-0-17/09/2013*****************************************/
-------- DATOS TEMPORALES  PARA PLANTILLA DE COMPROBANTE DE DEVENGADO

/* Data for the 'conta.tplantilla_comprobante' table  (Records 1 - 1) */

INSERT INTO conta.tplantilla_comprobante ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_plantilla_comprobante", "codigo", "clase_comprobante", "momento_presupuestario", "tabla_origen", "id_tabla", "campo_descripcion", "campo_subsistema", "campo_fecha", "campo_moneda", "campo_acreedor", "campo_fk_comprobante", "funcion_comprobante_validado", "funcion_comprobante_eliminado", "campo_depto", "id_clase_comprobante", "id_subsistema", "otros_campos", "campo_gestion_relacion")
VALUES (1, 1, E'2013-08-04 23:52:23.333', E'2013-09-06 21:15:53.018', E'activo', 1, E'DEVTESPROV', E'DIARIO', E'Devengado', E'tes.vcomp_devtesprov_plan_pago', E'id_plan_pago', E'{$tabla.numero}', E'TES', E'{$tabla.fecha_actual}', E'{$tabla.id_moneda}', E'{$tabla.desc_proveedor}', E'', E'f_tes_conta_validacion_comprobante_dev', E'f_tes_conta_eliminacion_comprobante_dev', E'{$tabla.id_depto_conta}', NULL, NULL, E'{$tabla.id_plantilla},{$tabla.id_proveedor},{$tabla.monto},{$tabla.monto_retgar_mo},{$talba.otros_descuentos}', E'{$tabla.id_gestion_cuentas}');

/* Data for the 'conta.tdetalle_plantilla_comprobante' table  (Records 1 - 4) */

INSERT INTO conta.tdetalle_plantilla_comprobante ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_detalle_plantilla_comprobante", "id_plantilla_comprobante", "tabla_detalle", "debe_haber", "campo_monto", "agrupar", "campo_cuenta", "campo_auxiliar", "campo_partida", "campo_centro_costo", "es_relacion_contable", "tipo_relacion_contable", "campo_relacion_contable", "aplicar_documento", "campo_documento", "campo_fecha", "campo_concepto_transaccion", "primaria", "otros_campos", "nom_fk_tabla_maestro", "campo_partida_ejecucion", "descripcion", "campo_monto_pres", "id_detalle_plantilla_fk", "forma_calculo_monto")
VALUES (1, 1, E'2013-08-04 23:57:41.208', E'2013-08-28 03:22:01.166', E'activo', 1, 1, E'tes.vcomp_devtesprov_det_plan_pago', E'debe', E'{$tabla.monto_pago_mo}', E'si', E'', E'', E'', E'{$tabla.id_centro_costo}', E'si', E'CUECOMP', E'{$tabla.id_concepto_ingas}', E'si', E'{$tabla_padre.id_plantilla}', E'', E'{$tabla.descripcion}', E'si', NULL, E'id_plan_pago', E'{$tabla.id_partida_ejecucion_com}', E'Concepto de Gasto', NULL, NULL, E'simple');

INSERT INTO conta.tdetalle_plantilla_comprobante ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_detalle_plantilla_comprobante", "id_plantilla_comprobante", "tabla_detalle", "debe_haber", "campo_monto", "agrupar", "campo_cuenta", "campo_auxiliar", "campo_partida", "campo_centro_costo", "es_relacion_contable", "tipo_relacion_contable", "campo_relacion_contable", "aplicar_documento", "campo_documento", "campo_fecha", "campo_concepto_transaccion", "primaria", "otros_campos", "nom_fk_tabla_maestro", "campo_partida_ejecucion", "descripcion", "campo_monto_pres", "id_detalle_plantilla_fk", "forma_calculo_monto")
VALUES (1, 1, E'2013-08-04 23:57:53.089', E'2013-08-27 20:19:55.418', E'activo', 2, 1, E'', E'haber', E'{$tabla_padre.monto}', E'si', E'', E'', E'', E'', E'si', E'CUENDEVPRO', E'{$tabla_padre.id_proveedor}', E'no', E'', E'', E'', E'no', NULL, NULL, NULL, E'Proveedor por pagar', E'0', 1, E'diferencia');

INSERT INTO conta.tdetalle_plantilla_comprobante ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_detalle_plantilla_comprobante", "id_plantilla_comprobante", "tabla_detalle", "debe_haber", "campo_monto", "agrupar", "campo_cuenta", "campo_auxiliar", "campo_partida", "campo_centro_costo", "es_relacion_contable", "tipo_relacion_contable", "campo_relacion_contable", "aplicar_documento", "campo_documento", "campo_fecha", "campo_concepto_transaccion", "primaria", "otros_campos", "nom_fk_tabla_maestro", "campo_partida_ejecucion", "descripcion", "campo_monto_pres", "id_detalle_plantilla_fk", "forma_calculo_monto")
VALUES (1, 1, E'2013-08-04 23:57:53', E'2013-08-27 20:19:55', E'activo', 4, 1, E'', E'haber', E'{$tabla.monto_retgar_mo}', E'si', NULL, NULL, NULL, NULL, E'si', E'CUENRETGARPRO', E'{$tabla_padre.id_proveedor}', E'no', NULL, NULL, NULL, E'no', NULL, NULL, NULL, E'Retencion de garantia Proveedor', E'0', 2, E'descuento');

INSERT INTO conta.tdetalle_plantilla_comprobante ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_detalle_plantilla_comprobante", "id_plantilla_comprobante", "tabla_detalle", "debe_haber", "campo_monto", "agrupar", "campo_cuenta", "campo_auxiliar", "campo_partida", "campo_centro_costo", "es_relacion_contable", "tipo_relacion_contable", "campo_relacion_contable", "aplicar_documento", "campo_documento", "campo_fecha", "campo_concepto_transaccion", "primaria", "otros_campos", "nom_fk_tabla_maestro", "campo_partida_ejecucion", "descripcion", "campo_monto_pres", "id_detalle_plantilla_fk", "forma_calculo_monto")
VALUES (1, 1, E'2013-08-04 23:57:53', E'2013-08-27 20:19:55', E'activo', 3, 1, E'', E'haber', E'{$tabla.padre.otros_descuentos}', E'si', NULL, NULL, NULL, NULL, E'si', E'CUENRETPRO', E'{$tabla_padre.id_proveedor}', E'no', NULL, NULL, NULL, E'no', NULL, NULL, NULL, E'otras descuentos proveedor', E'0', 2, E'descuento');




/***********************************F-DAT-RAC-CONTA-0-17/09/2013*****************************************/


/***********************************I-DAT-RAC-CONTA-0-16/10/2013*****************************************/


/* Data for the 'conta.tclase_comprobante' table  (Records 1 - 2) */

INSERT INTO conta.tclase_comprobante ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_clase_comprobante", "id_documento", "descripcion", "tipo_comprobante", "codigo")
VALUES (1, 1, E'2013-05-27 12:47:24.095', E'2013-05-27 14:37:18.709', E'activo', 1, 9, NULL, NULL, E'PAGO');

INSERT INTO conta.tclase_comprobante ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_clase_comprobante", "id_documento", "descripcion", "tipo_comprobante", "codigo")
VALUES (1, 1, E'2013-05-27 13:17:09.732', E'2013-07-11 11:20:39.469', E'activo', 3, 8, NULL, NULL, E'DIARIO');


-- Plantillas de comprobantes de PAGO


INSERT INTO conta.tplantilla_comprobante ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_plantilla_comprobante", "codigo", "clase_comprobante", "momento_presupuestario", "tabla_origen", "id_tabla", "campo_descripcion", "campo_subsistema", "campo_fecha", "campo_moneda", "campo_acreedor", "campo_fk_comprobante", "funcion_comprobante_validado", "funcion_comprobante_eliminado", "campo_depto", "id_clase_comprobante", "id_subsistema", "otros_campos", "campo_gestion_relacion")
VALUES (1, 1, E'2013-09-18 17:21:26.021', E'2013-09-23 14:35:04.949', E'activo', 2, E'PAGTESPROV', E'PAGO', E'pagado', E'tes.vcomp_devtesprov_plan_pago', E'id_plan_pago', E'{$tabla.numero}', E'TES', E'{$tabla.fecha_actual}', E'{$tabla.id_moneda}', E'{$tabla.desc_proveedor}', E'{id_int_comprobante}', E'tes.f_gestionar_cuota_plan_pago', E'tes.f_gestionar_cuota_plan_pago_eliminacion', E'{$tabla.id_depto_conta}', NULL, NULL, E'{$tabla.id_plantilla},{$tabla.id_proveedor},{$tabla.monto},{$tabla.monto_retgar_mo},{$tabla.otros_descuentos},{$tabla.liquido_pagable},{$tabla.id_cuenta_bancaria}', E'{$tabla.id_gestion_cuentas}');





INSERT INTO conta.tdetalle_plantilla_comprobante ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_detalle_plantilla_comprobante", "id_plantilla_comprobante", "tabla_detalle", "debe_haber", "campo_monto", "agrupar", "campo_cuenta", "campo_auxiliar", "campo_partida", "campo_centro_costo", "es_relacion_contable", "tipo_relacion_contable", "campo_relacion_contable", "aplicar_documento", "campo_documento", "campo_fecha", "campo_concepto_transaccion", "primaria", "otros_campos", "nom_fk_tabla_maestro", "campo_partida_ejecucion", "descripcion", "campo_monto_pres", "id_detalle_plantilla_fk", "forma_calculo_monto", "func_act_transaccion", "campo_id_tabla_detalle", "rel_dev_pago", "campo_trasaccion_dev")
VALUES (1, 1, E'2013-09-19 20:10:41.411', E'2013-09-23 12:39:57.663', E'activo', 7, 2, E'tes.vcomp_devtesprov_det_plan_pago', E'debe', E'{$tabla.monto_pago_mo}', E'no', E'', E'', E'', E'{$tabla.id_centro_costo}', E'no', E'', E'', E'no', E'', E'', E'', E'no', E'', E'id_plan_pago', E'', E'relacion devengado pago', E'', 5, E'simple', E'', E'{$tabla.id_prorrateo}', E'si', E'{$tabla.id_int_transaccion}');

INSERT INTO conta.tdetalle_plantilla_comprobante (
"id_usuario_reg",
 "id_usuario_mod",
 "fecha_reg",
 "fecha_mod",
 "estado_reg",
 "id_detalle_plantilla_comprobante", "id_plantilla_comprobante", "tabla_detalle", "debe_haber", "campo_monto", "agrupar", "campo_cuenta", "campo_auxiliar", "campo_partida", "campo_centro_costo", "es_relacion_contable", "tipo_relacion_contable", "campo_relacion_contable", "aplicar_documento", "campo_documento", "campo_fecha", "campo_concepto_transaccion", "primaria", "otros_campos", "nom_fk_tabla_maestro", "campo_partida_ejecucion", "descripcion", "campo_monto_pres", "id_detalle_plantilla_fk", "forma_calculo_monto", "func_act_transaccion", "campo_id_tabla_detalle", "rel_dev_pago", "campo_trasaccion_dev")
VALUES (1, 1, E'2013-09-23 12:34:39.340', E'2013-09-23 16:30:21.498', E'activo', 8, 2, E'', E'haber', E'{$tabla_padre.otros_descuentos}', E'si', E'', E'', E'', E'', E'si', E'CUENRETPRO', E'{$tabla_padre.id_proveedor}', E'no', E'', E'', E'', E'si', E'', E'', E'', E'otras descuentos proveedor', E'0', 5, E'incremento', E'', E'', E'no', E'');


INSERT INTO conta.tdetalle_plantilla_comprobante ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_detalle_plantilla_comprobante", "id_plantilla_comprobante", "tabla_detalle", "debe_haber", "campo_monto", "agrupar", "campo_cuenta", "campo_auxiliar", "campo_partida", "campo_centro_costo", "es_relacion_contable", "tipo_relacion_contable", "campo_relacion_contable", "aplicar_documento", "campo_documento", "campo_fecha", "campo_concepto_transaccion", "primaria", "otros_campos", "nom_fk_tabla_maestro", "campo_partida_ejecucion", "descripcion", "campo_monto_pres", "id_detalle_plantilla_fk", "forma_calculo_monto", "func_act_transaccion", "campo_id_tabla_detalle", "rel_dev_pago", "campo_trasaccion_dev")
VALUES (1, 1, E'2013-09-18 17:27:06.762', E'2013-09-19 17:47:09.519', E'activo', 5, 2, E'', E'debe', E'{$tabla_padre.liquido_pagable}', E'si', E'', E'', E'', E'', E'si', E'CUENPAGPRO', E'{$tabla_padre.id_proveedor}', E'no', E'', E'', E'', E'si', NULL, NULL, NULL, E'Cuenta de proveedores por pagar', E'{$tabla_padre.liquido_pagable}', NULL, E'simple', NULL, E'', E'no', NULL);

INSERT INTO conta.tdetalle_plantilla_comprobante ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_detalle_plantilla_comprobante", "id_plantilla_comprobante", "tabla_detalle", "debe_haber", "campo_monto", "agrupar", "campo_cuenta", "campo_auxiliar", "campo_partida", "campo_centro_costo", "es_relacion_contable", "tipo_relacion_contable", "campo_relacion_contable", "aplicar_documento", "campo_documento", "campo_fecha", "campo_concepto_transaccion", "primaria", "otros_campos", "nom_fk_tabla_maestro", "campo_partida_ejecucion", "descripcion", "campo_monto_pres", "id_detalle_plantilla_fk", "forma_calculo_monto", "func_act_transaccion", "campo_id_tabla_detalle", "rel_dev_pago", "campo_trasaccion_dev")
VALUES (1, 1, E'2013-09-18 17:35:47.621', E'2013-09-19 17:47:34.701', E'activo', 6, 2, E'', E'haber', E'{$tabla_padre.liquido_pagable}', E'si', E'', E'', E'', E'', E'si', E'CUEBANCEGRE', E'{$tabla_padre.id_cuenta_bancaria}', E'no', E'', E'', E'', E'si', NULL, NULL, NULL, E'Cuenta Bancaria', E'{$tabla_padre.liquido_pagable}', NULL, E'simple', NULL, E'', E'no', NULL);



INSERT INTO conta.ttipo_relacion_contable ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg",  "nombre_tipo_relacion", "codigo_tipo_relacion", "tiene_centro_costo", "tiene_partida", "tiene_auxiliar", "id_tabla_relacion_contable")
VALUES (1, NULL, E'2013-09-19 09:45:31.693', NULL, E'activo', E'Retenciones IT', E'IT-RET', E'si-general', E'si', E'si', NULL);

INSERT INTO conta.ttipo_relacion_contable ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg",  "nombre_tipo_relacion", "codigo_tipo_relacion", "tiene_centro_costo", "tiene_partida", "tiene_auxiliar", "id_tabla_relacion_contable")
VALUES (1, NULL, E'2013-09-19 10:20:58.567', NULL, E'activo',  E'Retencion de IUE por compra de bienes', E'IUE-RET-BIE', E'si-general', E'si', E'si', NULL);


--relaciones contable proveedor

INSERT INTO conta.ttipo_relacion_contable ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg",  "nombre_tipo_relacion", "codigo_tipo_relacion", "tiene_centro_costo", "tiene_partida", "tiene_auxiliar", "id_tabla_relacion_contable")
VALUES (1, 1, E'2013-08-29 15:08:16.991', E'2013-08-29 18:09:58.611', E'activo',  E'Cuentas de retenciones de proveedor', E'CUENRETPRO', E'si-general', E'si', E'si', 3);

INSERT INTO conta.ttipo_relacion_contable ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg",  "nombre_tipo_relacion", "codigo_tipo_relacion", "tiene_centro_costo", "tiene_partida", "tiene_auxiliar", "id_tabla_relacion_contable")
VALUES (1, NULL, E'2013-08-29 18:14:19.261', NULL, E'activo',  E'Cuentas para retencion de garantia proveedor', E'CUENRETGARPRO', E'si-general', E'si', E'si', 3);

INSERT INTO conta.ttipo_relacion_contable ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg",  "nombre_tipo_relacion", "codigo_tipo_relacion", "tiene_centro_costo", "tiene_partida", "tiene_auxiliar", "id_tabla_relacion_contable")
VALUES (1, NULL, E'2013-09-18 17:54:57.881', NULL, E'activo',  E'Cuenta para el pago de Proveedores', E'CUENPAGPRO', E'si-general', E'si', E'si', 3);


/***********************************F-DAT-RAC-CONTA-0-16/10/2013*****************************************/

/***********************************I-DAT-RCM-CONTA-0-19/10/2013*****************************************/
select pxp.f_insert_tgui ('Cuentas por Almacenes', 'Cuentas por Almacenes', 'ALMCUE', 'si', 5, 'sis_contabilidad/vista/cta_relacion_contable/CtaAlmacen.php', 3, '', 'CtaAlmacen', 'CONTA');
select pxp.f_insert_testructura_gui ('ALMCUE', 'RELACON');

select pxp.f_insert_tgui ('Cuentas por Clasificación', 'Cuentas por Clasificación', 'CLACUE', 'si', 5, 'sis_contabilidad/vista/cta_relacion_contable/CtaClasificacion.php', 3, '', 'CtaClasificacion', 'CONTA');
select pxp.f_insert_testructura_gui ('CLACUE', 'RELACON');

select pxp.f_add_catalog('PARAM','tgral__direc','asc');
select pxp.f_add_catalog('PARAM','tgral__direc','desc');
/***********************************F-DAT-RCM-CONTA-0-19/10/2013*****************************************/


/***********************************I-DAT-RCM-CONTA-0-21/11/2013*****************************************/

select pxp.f_add_catalog('CONTA','tttipo_relacion_contable__partida_tipo','flujo');
select pxp.f_add_catalog('CONTA','tttipo_relacion_contable__partida_tipo','presupuestaria');
select pxp.f_add_catalog('CONTA','tttipo_relacion_contable__partida_tipo','flujo_presupuestaria');

select pxp.f_add_catalog('CONTA','tttipo_relacion_contable__partida_rubro','recurso');
select pxp.f_add_catalog('CONTA','tttipo_relacion_contable__partida_rubro','gasto');
select pxp.f_add_catalog('CONTA','tttipo_relacion_contable__partida_rubro','recurso_gasto');

/***********************************F-DAT-RCM-CONTA-0-21/11/2013*****************************************/

/***********************************I-DAT-RCM-CONTA-0-10/12/2013*****************************************/
select pxp.f_insert_tgui ('Replicación Relaciones Contables', 'Replicación Relaciones Contables', 'RERELCON', 'si', 1, 'sis_contabilidad/vista/gestion/GestionConta.php', 2, '', 'GestionConta', 'CONTA');
select pxp.f_insert_testructura_gui ('RERELCON', 'CONTA');
/***********************************F-DAT-RCM-CONTA-0-10/12/2013*****************************************/


/***********************************I-DAT-JRR-CONTA-0-24/04/2014*****************************************/


select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'CTA.1', 'no', 0, 'sis_contabilidad/vista/cuenta_auxiliar/CuentaAuxiliar.php', 3, '', 'CuentaAuxiliar', 'CONTA');
select pxp.f_insert_tgui ('Tipo Relacion Contable', 'Tipo Relacion Contable', 'RELCON.1', 'no', 0, 'sis_contabilidad/vista/tipo_relacion_contable/TipoRelacionContableTabla.php', 3, '', '60%', 'CONTA');
select pxp.f_insert_tgui ('Catálogo', 'Catálogo', 'RELCON.2', 'no', 0, 'sis_parametros/vista/catalogo/Catalogo.php', 3, '', 'Catalogo', 'CONTA');
select pxp.f_insert_tgui ('Catálogo', 'Catálogo', 'RELCON.1.1', 'no', 0, 'sis_parametros/vista/catalogo/Catalogo.php', 4, '', 'Catalogo', 'CONTA');
select pxp.f_insert_tgui ('Relacion Contable', 'Relacion Contable', 'PROVCUEN.1', 'no', 0, 'sis_contabilidad/vista/relacion_contable/RelacionContableTabla.php', 4, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Personas', 'Personas', 'PROVCUEN.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 4, '', 'persona', 'CONTA');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'PROVCUEN.3', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 4, '', 'Institucion', 'CONTA');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'PROVCUEN.2.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 5, '', 'subirFotoPersona', 'CONTA');
select pxp.f_insert_tgui ('Personas', 'Personas', 'PROVCUEN.3.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'CONTA');
select pxp.f_insert_tgui ('Relacion Contable', 'Relacion Contable', 'RELCONGEN.1', 'no', 0, 'sis_contabilidad/vista/relacion_contable/RelacionContableGeneral.php', 4, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Catálogo', 'Catálogo', 'RELCONGEN.2', 'no', 0, 'sis_parametros/vista/catalogo/Catalogo.php', 4, '', 'Catalogo', 'CONTA');
select pxp.f_insert_tgui ('Relacion Contable', 'Relacion Contable', 'CONGASCUE.1', 'no', 0, 'sis_contabilidad/vista/relacion_contable/RelacionContableTabla.php', 4, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Catálogo', 'Catálogo', 'CONGASCUE.2', 'no', 0, 'sis_parametros/vista/catalogo/Catalogo.php', 4, '', 'Catalogo', 'CONTA');
select pxp.f_insert_tgui ('Relacion Contable', 'Relacion Contable', 'RELCCCB.1', 'no', 0, 'sis_contabilidad/vista/relacion_contable/RelacionContableTabla.php', 4, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Chequeras', 'Chequeras', 'RELCCCB.2', 'no', 0, 'sis_tesoreria/vista/chequera/Chequera.php', 4, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'RELCCCB.3', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 4, '', 'Institucion', 'CONTA');
select pxp.f_insert_tgui ('Personas', 'Personas', 'RELCCCB.3.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'CONTA');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'RELCCCB.3.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 6, '', 'subirFotoPersona', 'CONTA');
select pxp.f_insert_tgui ('Transacciones', 'Transacciones', 'CBTE.1.1.1', 'no', 0, 'sis_contabilidad/vista/int_transaccion/IntTransaccion.php', 4, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Catálogo', 'Catálogo', 'CBTE.1.1.2', 'no', 0, 'sis_parametros/vista/catalogo/Catalogo.php', 4, '', 'Catalogo', 'CONTA');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'CBTE.1.1.3', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 4, '', 'funcionario', 'CONTA');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'CBTE.1.1.3.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 5, '', 'FuncionarioCuentaBancaria', 'CONTA');
select pxp.f_insert_tgui ('Personas', 'Personas', 'CBTE.1.1.3.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'CONTA');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'CBTE.1.1.3.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 6, '', 'Institucion', 'CONTA');
select pxp.f_insert_tgui ('Personas', 'Personas', 'CBTE.1.1.3.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'CONTA');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'CBTE.1.1.3.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 8, '', 'subirFotoPersona', 'CONTA');
select pxp.f_insert_tgui ('Relacion Contable', 'Relacion Contable', 'DEPTCON.1', 'no', 0, 'sis_contabilidad/vista/relacion_contable/RelacionContableTabla.php', 4, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Usuarios por Departamento', 'Usuarios por Departamento', 'DEPTCON.2', 'no', 0, 'sis_parametros/vista/depto_usuario/DeptoUsuario.php', 4, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Depto - UO', 'Depto - UO', 'DEPTCON.3', 'no', 0, 'sis_parametros/vista/depto_uo/DeptoUo.php', 4, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Depto - EP', 'Depto - EP', 'DEPTCON.4', 'no', 0, 'sis_parametros/vista/depto_ep/DeptoEp.php', 4, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Depto UO - EP', 'Depto UO - EP', 'DEPTCON.5', 'no', 0, 'sis_parametros/vista/depto_uo_ep/DeptoUoEp.php', 4, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Firmas Documentos', 'Firmas Documentos', 'DEPTCON.6', 'no', 0, 'sis_parametros/vista/firma/Firma.php', 4, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Subsistema', 'Subsistema', 'DEPTCON.7', 'no', 0, 'id_subsistema', 4, '', 'Subsistema...', 'CONTA');
select pxp.f_insert_tgui ('Usuarios', 'Usuarios', 'DEPTCON.2.1', 'no', 0, 'sis_seguridad/vista/usuario/Usuario.php', 5, '', 'usuario', 'CONTA');
select pxp.f_insert_tgui ('Personas', 'Personas', 'DEPTCON.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 6, '', 'persona', 'CONTA');
select pxp.f_insert_tgui ('Roles', 'Roles', 'DEPTCON.2.1.2', 'no', 0, 'sis_seguridad/vista/usuario_rol/UsuarioRol.php', 6, '', 'usuario_rol', 'CONTA');
select pxp.f_insert_tgui ('EP\', 'EP\', 'DEPTCON.2.1.3', 'no', 0, 'sis_seguridad/vista/usuario_grupo_ep/UsuarioGrupoEp.php', 6, '', ',
          width:400,
          cls:', 'CONTA');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'DEPTCON.2.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 7, '', 'subirFotoPersona', 'CONTA');
select pxp.f_insert_tgui ('Plantilla Cálculo', 'Plantilla Cálculo', 'PLADOC.1', 'no', 0, 'sis_contabilidad/vista/plantilla_calculo/PlantillaCalculo.php', 3, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Catálogo', 'Catálogo', 'PLADOC.1.1', 'no', 0, 'sis_parametros/vista/catalogo/Catalogo.php', 4, '', 'Catalogo', 'CONTA');
select pxp.f_insert_tgui ('Transacciones', 'Transacciones', 'CBTE.1.3.1.1', 'no', 0, 'sis_contabilidad/vista/transaccion/Transaccion.php', 4, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Catálogo', 'Catálogo', 'CBTE.1.3.1.2', 'no', 0, 'sis_parametros/vista/catalogo/Catalogo.php', 4, '', 'Catalogo', 'CONTA');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'CBTE.1.3.1.3', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 4, '', 'funcionario', 'CONTA');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'CBTE.1.3.1.3.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 5, '', 'FuncionarioCuentaBancaria', 'CONTA');
select pxp.f_insert_tgui ('Personas', 'Personas', 'CBTE.1.3.1.3.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'CONTA');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'CBTE.1.3.1.3.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 6, '', 'Institucion', 'CONTA');
select pxp.f_insert_tgui ('Personas', 'Personas', 'CBTE.1.3.1.3.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'CONTA');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'CBTE.1.3.1.3.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 8, '', 'subirFotoPersona', 'CONTA');
select pxp.f_insert_tgui ('Relacion Contable', 'Relacion Contable', 'ALMCUE.1', 'no', 0, 'sis_contabilidad/vista/relacion_contable/RelacionContableTabla.php', 4, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Personal del Almacén', 'Personal del Almacén', 'ALMCUE.2', 'no', 0, 'sis_almacenes/vista/almacenUsuario/AlmacenUsuario.php', 4, '', 'AlmacenUsuario', 'CONTA');
select pxp.f_insert_tgui ('Stock Minimo de almacenes', 'Stock Minimo de almacenes', 'ALMCUE.3', 'no', 0, 'sis_almacenes/vista/almacenStock/AlmacenStock.php', 4, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Upload archivos', 'Upload archivos', 'ALMCUE.4', 'no', 0, 'sis_parametros/vista/tabla_upload/TablaUpload.php', 4, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('btnSwitchEstado', 'btnSwitchEstado', 'ALMCUE.5', 'no', 0, 'btnAlmacenUsuario', 4, '', 'inactivo', 'CONTA');
select pxp.f_insert_tgui ('Gestión Almacenes', 'Gestión Almacenes', 'ALMCUE.6', 'no', 0, 'sis_almacenes/vista/almacen_gestion/AlmacenGestion.php', 4, '', '70%', 'CONTA');
select pxp.f_insert_tgui ('Items', 'Items', 'ALMCUE.3.1', 'no', 0, 'sis_almacenes/vista/item/BuscarItem.php', 5, '', 'BuscarItem', 'CONTA');
select pxp.f_insert_tgui ('Existencia de Materiales por Almacén', 'Existencia de Materiales por Almacén', 'ALMCUE.3.1.1', 'no', 0, 'sis_almacenes/vista/item/ItemExistenciaAlmacen.php', 6, '', '30%', 'CONTA');
select pxp.f_insert_tgui ('Histórico Gestión', 'Histórico Gestión', 'ALMCUE.6.1', 'no', 0, 'sis_almacenes/vista/almacen_gestion_log/AlmacenGestionLog.php', 5, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Movimientos Pendientes', 'Movimientos Pendientes', 'ALMCUE.6.2', 'no', 0, 'sis_almacenes/vista/movimiento/MovimientoReq.php', 5, '', '70%', 'CONTA');
select pxp.f_insert_tgui ('Detalle de Movimiento', 'Detalle de Movimiento', 'ALMCUE.6.2.1', 'no', 0, 'sis_almacenes/vista/movimientoDetalle/MovimientoDetalle.php', 6, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Alarmas', 'Alarmas', 'ALMCUE.6.2.2', 'no', 0, 'sis_parametros/vista/alarma/AlarmaFuncionario.php', 6, '', 'AlarmaFuncionario', 'CONTA');
select pxp.f_insert_tgui ('Items', 'Items', 'ALMCUE.6.2.1.1', 'no', 0, 'sis_almacenes/vista/item/BuscarItem.php', 7, '', 'BuscarItem', 'CONTA');
select pxp.f_insert_tgui ('Valoracion del Detalle', 'Valoracion del Detalle', 'ALMCUE.6.2.1.2', 'no', 0, 'sis_almacenes/vista/movimientoDetValorado/MovimientoDetValorado.php', 7, '', '20%', 'CONTA');
select pxp.f_insert_tgui ('Relacion Contable', 'Relacion Contable', 'CLACUE.1', 'no', 0, 'sis_contabilidad/vista/relacion_contable/RelacionContableTabla.php', 4, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Materiales', 'Materiales', 'CLACUE.2', 'no', 0, 'sis_almacenes/vista/item/Item.php', 4, '', 'Item', 'CONTA');
select pxp.f_insert_tgui ('Items de Reemplazo', 'Items de Reemplazo', 'CLACUE.2.1', 'no', 0, 'sis_almacenes/vista/itemReemplazo/ItemReemplazo.php', 5, '', 'ItemReemplazo', 'CONTA');
select pxp.f_insert_tgui ('Archivos del Item', 'Archivos del Item', 'CLACUE.2.2', 'no', 0, 'sis_almacenes/vista/itemArchivo/ItemArchivo.php', 5, '', 'ItemArchivo', 'CONTA');
select pxp.f_insert_tgui ('Unidades de Medida', 'Unidades de Medida', 'CLACUE.2.3', 'no', 0, 'sis_parametros/vista/unidad_medida/UnidadMedida.php', 5, '', 'UnidadMedida', 'CONTA');
select pxp.f_insert_tgui ('Items', 'Items', 'CLACUE.2.1.1', 'no', 0, 'sis_almacenes/vista/item/BuscarItem.php', 6, '', 'BuscarItem', 'CONTA');
select pxp.f_insert_tgui ('Existencia de Materiales por Almacén', 'Existencia de Materiales por Almacén', 'CLACUE.2.1.1.1', 'no', 0, 'sis_almacenes/vista/item/ItemExistenciaAlmacen.php', 7, '', '30%', 'CONTA');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'CLACUE.2.2.1', 'no', 0, 'sis_almacenes/vista/itemArchivo/SubirArchivo.php', 6, '', 'SubirArchivo', 'CONTA');
select pxp.f_insert_tgui ('Catálogo', 'Catálogo', 'CLACUE.2.3.1', 'no', 0, 'sis_parametros/vista/catalogo/Catalogo.php', 6, '', 'Catalogo', 'CONTA');
select pxp.f_insert_tgui ('Periodos', 'Periodos', 'RERELCON.1', 'no', 0, 'sis_parametros/vista/periodo/Periodo.php', 3, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Catálogo', 'Catálogo', 'RERELCON.2', 'no', 0, 'sis_parametros/vista/catalogo/Catalogo.php', 3, '', 'Catalogo', 'CONTA');
select pxp.f_insert_tgui ('Periodo Subistema', 'Periodo Subistema', 'RERELCON.1.1', 'no', 0, 'sis_parametros/vista/periodo_subsistema/PeriodoSubsistema.php', 4, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'PROVCUEN.3.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 6, '', 'subirFotoPersona', 'CONTA');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'CBTE.1.1.3.2.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 6, '', 'subirFotoPersona', 'CONTA');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'CBTE.1.3.1.3.2.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 6, '', 'subirFotoPersona', 'CONTA');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'ALMCUE.6.2.3', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 6, '', 'funcionario', 'CONTA');
select pxp.f_insert_tgui ('Existencia de Materiales por Almacén', 'Existencia de Materiales por Almacén', 'ALMCUE.6.2.1.1.1', 'no', 0, 'sis_almacenes/vista/item/ItemExistenciaAlmacen.php', 8, '', '30%', 'CONTA');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'ALMCUE.6.2.3.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 7, '', 'FuncionarioCuentaBancaria', 'CONTA');
select pxp.f_insert_tgui ('Personas', 'Personas', 'ALMCUE.6.2.3.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'CONTA');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'ALMCUE.6.2.3.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 8, '', 'Institucion', 'CONTA');
select pxp.f_insert_tgui ('Personas', 'Personas', 'ALMCUE.6.2.3.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 9, '', 'persona', 'CONTA');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'ALMCUE.6.2.3.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 10, '', 'subirFotoPersona', 'CONTA');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'ALMCUE.6.2.3.2.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 8, '', 'subirFotoPersona', 'CONTA');

/***********************************F-DAT-JRR-CONTA-0-24/04/2014*****************************************/




/***********************************I-DAT-RAC-CONTA-0-17/04/2014*****************************************/



----------------------------------
--COPY LINES TO data.sql FILE
---------------------------------

select pxp.f_insert_tgui ('Plan de Cuentas', 'Cuentas', 'CTA', 'si', 0, 'sis_contabilidad/vista/cuenta/Cuenta.php', 2, '', 'Cuenta', 'CONTA');
select pxp.f_insert_tgui ('Auxiliares de Cuentas', 'Auxiliares de cuenta', 'AUXCTA', 'si', 0, 'sis_contabilidad/vista/auxiliar/Auxiliar.php', 2, '', 'Auxiliar', 'CONTA');
select pxp.f_insert_tgui ('Ordenes de Trabajo', 'ordenes de trabajo', 'ODT', 'si', 0, 'sis_contabilidad/vista/orden_trabajo/OrdenTrabajo.php', 2, '', 'OrdenTrabajo', 'CONTA');
select pxp.f_insert_tgui ('Config Tipo Cuenta', 'Configuracion de numero para los tipos de cuenta', 'CTIP', 'si', 0, 'sis_contabilidad/vista/config_tipo_cuenta/ConfigTipoCuenta.php', 2, '', 'ConfigTipoCuenta', 'CONTA');
select pxp.f_insert_tgui ('Clases de Comprobantes', 'Clases de Comprobantes', 'CCBT', 'si', 0, 'sis_contabilidad/vista/clase_comprobante/ClaseComprobante.php', 2, '', 'ClaseComprobante', 'CONTA');
select pxp.f_insert_tgui ('Plantilla Comprobante', 'comprobante', 'CMPB', 'si', 0, 'sis_contabilidad/vista/plantilla_comprobante/PlantillaComprobante.php', 2, '', 'PlantillaComprobante', 'CONTA');
select pxp.f_insert_tgui ('Plantilla de Documentos', 'Plantilla de Documentos', 'PLADOC', 'si', 0, 'sis_contabilidad/vista/plantilla/Plantilla.php', 2, '', 'PlantillaConta', 'CONTA');
select pxp.f_insert_tgui ('Gestión de Períodos', 'Gestión de Períodos', 'CONPER', 'si', 0, 'sis_contabilidad/vista/periodo_subsistema/PeriodoConta.php', 2, '', 'PeriodoConta', 'CONTA');
select pxp.f_insert_tgui ('Replicación Relaciones Contables', 'Replicación Relaciones Contables', 'RERELCON', 'si', 0, 'sis_contabilidad/vista/gestion/GestionConta.php', 2, '', 'GestionConta', 'CONTA');
select pxp.f_insert_tgui ('Grupos de OTs', 'Grupos de ordenes de trabajo', 'GRUOT', 'si', 0, 'sis_contabilidad/vista/grupo_ot/GrupoOt.php', 2, '', 'GrupoOt', 'CONTA');
select pxp.f_insert_tgui ('Catálogo', 'Catálogo', 'DEPTCON.2.2', 'no', 0, 'sis_parametros/vista/catalogo/Catalogo.php', 5, '', 'Catalogo', 'CONTA');
select pxp.f_insert_tgui ('Estados', 'Estados', 'GRUOT.1', 'no', 0, 'sis_contabilidad/vista/grupo_ot_det/GrupoOtDet.php', 3, '', '60%', 'CONTA');
select pxp.f_insert_tgui ('Tipo Obligacion (Planillas)', 'Tipo Obligacion (Planillas)', 'TIPOBLICUE', 'si', 99, 'sis_contabilidad/vista/tipo_obligacion_cuenta/TipoObligacionCuenta.php', 3, '', 'TipoObligacionCuenta', 'CONTA');
select pxp.f_insert_tgui ('AFP (Planillas)', 'AFP (Planillas)', 'CUEAFP', 'si', 100, 'sis_contabilidad/vista/afp_cuenta/AfpCuenta.php', 3, '', 'AfpCuenta', 'CONTA');
select pxp.f_insert_tgui ('Ordenes de trabajo', 'Ordenes de trabajo', 'CROT', 'si', 1, '', 2, '', '', 'CONTA');
select pxp.f_insert_tgui ('Nomenclatura', 'Nomenclatura', 'NOMEN', 'si', 1, '', 2, '', '', 'CONTA');
select pxp.f_insert_tgui ('Configuraciones', 'Configuraciones', 'CONF', 'si', 1, '', 2, '', '', 'CONTA');
select pxp.f_insert_tgui ('Tipo de relaicon comprobantes', 'Tipo de relaicon comprobantes', 'TRECOM', 'si', 4, 'sis_contabilidad/vista/tipo_relacion_comprobante/TipoRelacionComprobante.php', 3, '', 'TipoRelacionComprobante', 'CONTA');

----------------------------------
--COPY LINES TO dependencies.sql FILE
---------------------------------

select pxp.f_delete_testructura_gui ('CTA', 'CONTA');
select pxp.f_delete_testructura_gui ('AUXCTA', 'CONTA');
select pxp.f_delete_testructura_gui ('ODT', 'CONTA');
select pxp.f_delete_testructura_gui ('CTIP', 'CONTA');
select pxp.f_delete_testructura_gui ('CCBT', 'CONTA');
select pxp.f_delete_testructura_gui ('CMPB', 'CONTA');
select pxp.f_delete_testructura_gui ('PLADOC', 'DEFRECONCAR');
select pxp.f_delete_testructura_gui ('CONPER', 'CONTA');
select pxp.f_delete_testructura_gui ('RERELCON', 'CONTA');
select pxp.f_delete_testructura_gui ('GRUOT', 'CONTA');
select pxp.f_insert_testructura_gui ('DEPTCON.2.2', 'DEPTCON.2');
select pxp.f_insert_testructura_gui ('GRUOT.1', 'GRUOT');
select pxp.f_insert_testructura_gui ('TIPOBLICUE', 'RELACON');
select pxp.f_insert_testructura_gui ('CUEAFP', 'RELACON');
select pxp.f_delete_testructura_gui ('GRUOT', 'DEFRECONCAR');
select pxp.f_delete_testructura_gui ('CCBT', 'DEFRECONCAR');
select pxp.f_delete_testructura_gui ('CTA', 'DEFRECONCAR');
select pxp.f_delete_testructura_gui ('CTIP', 'DEFRECONCAR');
select pxp.f_delete_testructura_gui ('ODT', 'DEFRECONCAR');
select pxp.f_insert_testructura_gui ('CROT', 'CONTA');
select pxp.f_insert_testructura_gui ('ODT', 'CROT');
select pxp.f_insert_testructura_gui ('GRUOT', 'CROT');
select pxp.f_insert_testructura_gui ('NOMEN', 'CONTA');
select pxp.f_insert_testructura_gui ('AUXCTA', 'NOMEN');
select pxp.f_insert_testructura_gui ('CTA', 'NOMEN');
select pxp.f_insert_testructura_gui ('CTIP', 'NOMEN');
select pxp.f_delete_testructura_gui ('CMPB', 'NOMEN');
select pxp.f_delete_testructura_gui ('CONPER', 'NOMEN');
select pxp.f_insert_testructura_gui ('CONF', 'CONTA');
select pxp.f_insert_testructura_gui ('CMPB', 'CONF');
select pxp.f_insert_testructura_gui ('CONPER', 'CONF');
select pxp.f_insert_testructura_gui ('RERELCON', 'CONF');
select pxp.f_insert_testructura_gui ('PLADOC', 'CONF');
select pxp.f_insert_testructura_gui ('CCBT', 'CONF');
select pxp.f_insert_testructura_gui ('TRECOM', 'CONF');
/* Data for the 'conta.ttipo_relacion_comprobante' table  (Records 1 - 4) */

INSERT INTO conta.ttipo_relacion_comprobante ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "codigo", "nombre")
VALUES (1, NULL, E'2014-12-17 16:13:43.521', NULL, E'activo', NULL, NULL, E'AJUSTE', E'Ajuste del comprobante');

INSERT INTO conta.ttipo_relacion_comprobante ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "codigo", "nombre")
VALUES (1, NULL, E'2014-12-17 16:14:06.581', NULL, E'activo', NULL, NULL, E'PAGODEV', E'Pago del devengado');

INSERT INTO conta.ttipo_relacion_comprobante ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "codigo", "nombre")
VALUES (1, NULL, E'2014-12-17 16:14:25.580', NULL, E'activo', NULL, NULL, E'REVERSION', E'Reversion del comprobante');

INSERT INTO conta.ttipo_relacion_comprobante ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "codigo", "nombre")
VALUES (1, NULL, E'2014-12-17 16:15:09.388', NULL, E'activo', NULL, NULL, E'APLICACIONANT', E'Aplicación del anticipo');



/***********************************F-DAT-RAC-CONTA-0-17/04/2014*****************************************/



/***********************************I-DAT-RAC-CONTA-0-21/05/2015*****************************************/


INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES (E'conta_partidas', E'si', E'si o no,  considerar partidas presupeustarias en el sistema de contabilidad');


/***********************************F-DAT-RAC-CONTA-0-21/05/2015*****************************************/




/***********************************I-DAT-RAC-CONTA-0-28/05/2015*****************************************/

select pxp.f_insert_tgui ('Libro Mayor', 'Libro Mayor', 'LIBMAY', 'si', 2, 'sis_contabilidad/vista/int_transaccion/FormFiltro.php', 3, '', 'FormFiltro', 'CONTA');
select pxp.f_insert_testructura_gui ('LIBMAY', 'CBTE.1.3');

/***********************************F-DAT-RAC-CONTA-0-28/05/2015*****************************************/


/***********************************I-DAT-RAC-CONTA-0-25/06/2015*****************************************/
select pxp.f_insert_tgui ('Libro Diario', 'Libro Diario', 'CBTE.1.3.1', 'si', 1, 'sis_contabilidad/vista/int_comprobante/IntComprobanteLd.php', 3, '', 'IntComprobanteLd', 'CONTA');
/***********************************F-DAT-RAC-CONTA-0-25/06/2015*****************************************/

/***********************************I-DAT-RAC-CONTA-0-07/07/2015****************************************/


select pxp.f_insert_tgui ('Reportes', 'Reportes', 'REPCON', 'si', 10, '', 2, '', '', 'CONTA');
select pxp.f_insert_tgui ('Balance de cuentas', 'Balance general', 'BALCON', 'si', 1, 'sis_contabilidad/vista/cuenta/FormFiltroBalance.php', 3, '', 'FormFiltroBalance', 'CONTA');


select pxp.f_insert_testructura_gui ('REPCON', 'CONTA');
select pxp.f_insert_testructura_gui ('BALCON', 'REPCON');

/***********************************F-DAT-RAC-CONTA-0-07/07/2015****************************************/




/***********************************I-DAT-RAC-CONTA-0-09/07/2015*****************************************/

select pxp.f_insert_tgui ('Plantilla de Resultados', 'Plantilla  para reporte de resultados', 'PLANRES', 'si', 3, 'sis_contabilidad/vista/resultado_plantilla/ResultadoPlantilla.php', 3, '', 'ResultadoPlantilla', 'CONTA');
select pxp.f_insert_tgui ('Resultados', 'Reportes de Resutlados', 'REPRES', 'si', 2, 'sis_contabilidad/vista/cuenta/FormFiltroResultado.php', 3, '', 'FormFiltroResultado', 'CONTA');
select pxp.f_insert_testructura_gui ('REPRES', 'REPCON');
select pxp.f_insert_testructura_gui ('PLANRES', 'CONF');
/***********************************F-DAT-RAC-CONTA-0-09/07/2015*****************************************/


/***********************************I-DAT-RAC-CONTA-0-13/07/2015*****************************************/

select pxp.f_insert_tgui ('Balance de Cuentas', 'Balance de Cuentas', 'BALCON', 'si', 1, 'sis_contabilidad/vista/cuenta/FormFiltroBalanceCuentas.php', 3, '', 'FormFiltroBalanceCuentas', 'CONTA');
select pxp.f_insert_tgui ('Balance General', 'Balance general', 'BALGEN', 'si', 1, 'sis_contabilidad/vista/cuenta/FormFiltroBalance.php', 3, '', 'FormFiltroBalance', 'CONTA');
select pxp.f_insert_testructura_gui ('BALCON', 'REPCON');
select pxp.f_insert_testructura_gui ('BALGEN', 'REPCON');

/***********************************F-DAT-RAC-CONTA-0-13/07/2015*****************************************/



/***********************************I-DAT-RAC-CONTA-0-14/08/2015*****************************************/


INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES (E'conta_validar_forma_pago', E'no', E'al validar cbtes manuales verifica si la trasaccion es bancaria y exige los datos forma_pago, nro_cheque, etc');

/***********************************F-DAT-RAC-CONTA-0-14/08/2015*****************************************/



/***********************************I-DAT-RAC-CONTA-0-01/09/2015*****************************************/

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES (E'sincronizar_internacional', E'false', E'si tiene libro de banco internenacional  sincroniza ');

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES (E'conta_prioridad_depto_internacional', E'3', E'prioridad del depto de conta internacional');

/***********************************F-DAT-RAC-CONTA-0-01/09/2015*****************************************/


/***********************************I-DAT-RAC-CONTA-0-03/09/2015*****************************************/


INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES (E'conta_integrar_libro_bancos', E'si', E'Si integra contabilidad con libro de bancos');


/***********************************F-DAT-RAC-CONTA-0-03/09/2015*****************************************/


/***********************************I-DAT-RAC-CONTA-0-16/09/2015*****************************************/

select pxp.f_insert_tgui ('Periodos Compra Venta', 'Configuracion de periodos de compra  y venta', 'PCV', 'si', 1, 'sis_contabilidad/vista/periodo_compra_venta/DeptoConta.php', 3, '', 'DeptoConta', 'CONTA');
select pxp.f_insert_testructura_gui ('PCV', 'CONF');

/***********************************F-DAT-RAC-CONTA-0-16/09/2015*****************************************/




/***********************************I-DAT-FFP-CONTA-0-16/09/2015*****************************************/


INSERT INTO conta.tconfig_banca ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "id_config_banca", "tipo", "digito", "descripcion")
VALUES (1, NULL, E'2015-09-11 12:59:01.003', NULL, E'activo', NULL, E'NULL', 1, E'Tipo de documento de pago', 1, E'Cheque de cualquier naturaleza');

INSERT INTO conta.tconfig_banca ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "id_config_banca", "tipo", "digito", "descripcion")
VALUES (1, NULL, E'2015-09-11 12:59:11.145', NULL, E'activo', NULL, E'NULL', 2, E'Tipo de documento de pago', 2, E'Orden de transferencia');

INSERT INTO conta.tconfig_banca ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "id_config_banca", "tipo", "digito", "descripcion")
VALUES (1, NULL, E'2015-09-11 12:59:26.034', NULL, E'activo', NULL, E'NULL', 3, E'Tipo de documento de pago', 3, E'Ordenes de transferencia electrónica de fondos');

INSERT INTO conta.tconfig_banca ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "id_config_banca", "tipo", "digito", "descripcion")
VALUES (1, NULL, E'2015-09-11 12:59:39.608', NULL, E'activo', NULL, E'NULL', 4, E'Tipo de documento de pago', 4, E'Transferencia de fondos');

INSERT INTO conta.tconfig_banca ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "id_config_banca", "tipo", "digito", "descripcion")
VALUES (1, NULL, E'2015-09-11 12:59:54.119', NULL, E'activo', NULL, E'NULL', 5, E'Tipo de documento de pago', 5, E'Tarjeta de débito');

INSERT INTO conta.tconfig_banca ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "id_config_banca", "tipo", "digito", "descripcion")
VALUES (1, NULL, E'2015-09-11 13:00:04.007', NULL, E'activo', NULL, E'NULL', 6, E'Tipo de documento de pago', 6, E'Tarjeta de crédito');

INSERT INTO conta.tconfig_banca ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "id_config_banca", "tipo", "digito", "descripcion")
VALUES (1, NULL, E'2015-09-11 13:00:14.862', NULL, E'activo', NULL, E'NULL', 7, E'Tipo de documento de pago', 7, E'Tarjeta pre pagada');

INSERT INTO conta.tconfig_banca ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "id_config_banca", "tipo", "digito", "descripcion")
VALUES (1, NULL, E'2015-09-11 13:00:25.605', NULL, E'activo', NULL, E'NULL', 8, E'Tipo de documento de pago', 8, E'Depósito en cuenta');

INSERT INTO conta.tconfig_banca ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "id_config_banca", "tipo", "digito", "descripcion")
VALUES (1, NULL, E'2015-09-11 13:02:41.636', NULL, E'activo', NULL, E'NULL', 9, E'Tipo de documento de pago', 9, E'Cartas de crédito');

INSERT INTO conta.tconfig_banca ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "id_config_banca", "tipo", "digito", "descripcion")
VALUES (1, NULL, E'2015-09-11 13:02:51.083', NULL, E'activo', NULL, E'NULL', 10, E'Tipo de documento de pago', 10, E'Otros');

INSERT INTO conta.tconfig_banca ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "id_config_banca", "tipo", "digito", "descripcion")
VALUES (1, NULL, E'2015-09-11 14:10:25.099', NULL, E'activo', NULL, E'NULL', 11, E'Modalidad de transacción', 1, E'Compras al contado');

INSERT INTO conta.tconfig_banca ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "id_config_banca", "tipo", "digito", "descripcion")
VALUES (1, NULL, E'2015-09-11 14:10:49.594', NULL, E'activo', NULL, E'NULL', 12, E'Modalidad de transacción', 2, E'Compras al crédito');

INSERT INTO conta.tconfig_banca ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "id_config_banca", "tipo", "digito", "descripcion")
VALUES (1, NULL, E'2015-09-11 14:11:53.854', NULL, E'activo', NULL, E'NULL', 13, E'Tipo de transacción', 1, E'Compra con factura');

INSERT INTO conta.tconfig_banca ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "id_config_banca", "tipo", "digito", "descripcion")
VALUES (1, NULL, E'2015-09-11 14:12:07.869', NULL, E'activo', NULL, E'NULL', 14, E'Tipo de transacción', 2, E'Compra con retenciones');

INSERT INTO conta.tconfig_banca ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "id_config_banca", "tipo", "digito", "descripcion")
VALUES (1, NULL, E'2015-09-11 14:12:21.763', NULL, E'activo', NULL, E'NULL', 15, E'Tipo de transacción', 3, E'Compra con inmuebles');


select pxp.f_insert_tgui ('Bancarizacion', 'banca', 'banca', 'si', 1, '', 2, '', '', 'CONTA');
select pxp.f_insert_tgui ('Config. Bancarizacion', 'configuraciones', 'CONFBA', 'si', 2, 'sis_contabilidad/vista/config_banca/ConfigBanca.php', 3, '', 'ConfigBanca', 'CONTA');
select pxp.f_insert_tgui ('Banca Compra', 'Banca Compra', 'BACO', 'si', 3, 'sis_contabilidad/vista/banca_compra_venta/BancaCompra.php', 3, '', 'BancaCompra', 'CONTA');
select pxp.f_insert_tgui ('Banca Ventas', 'Banca Ventas', 'BAVE', 'si', 4, 'sis_contabilidad/vista/banca_compra_venta/BancaVenta.php', 3, '', 'BancaVenta', 'CONTA');

/***********************************F-DAT-FFP-CONTA-0-16/09/2015*****************************************/



/***********************************I-DAT-RAC-CONTA-0-17/09/2015*****************************************/

INSERT INTO conta.ttipo_relacion_contable ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "nombre_tipo_relacion", "codigo_tipo_relacion", "tiene_centro_costo", "tiene_partida", "tiene_auxiliar", "id_tabla_relacion_contable", "partida_tipo", "partida_rubro")
VALUES (1, 1, E'2015-09-17 10:06:28.544', E'2015-09-17 10:10:30.401', E'activo', NULL, NULL, E'Cuenta para realizar ventas', E'CUEVENT', E'si-general', E'si', E'si', 1, E'presupuestaria', E'recurso');

/***********************************F-DAT-RAC-CONTA-0-17/09/2015*****************************************/




/***********************************I-DAT-RAC-CONTA-0-24/09/2015*****************************************/


INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES (E'conta_cod_plan_venta', E'VENTADOC', E'codigo de plantilla de comprobante para generar un cbte desde el libro de ventas');

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES (E'conta_cod_plan_compra', E'COMPRADOC', E'codigo de plantilla de comprobante para generar un cbte desde el libro de compras');


/***********************************F-DAT-RAC-CONTA-0-24/09/2015*****************************************/


/***********************************I-DAT-RAC-CONTA-1-24/09/2015*****************************************/

select pxp.f_insert_tgui ('Registros Contables', 'Comprobantes', 'CBTE.1', 'si', 3, '', 2, '', '', 'CONTA');

select pxp.f_insert_tgui ('Registro de Compras', 'Registro de Compras', 'DOC', 'si', 3, 'sis_contabilidad/vista/doc_compra_venta/DocCompra.php', 3, '', 'DocCompra', 'CONTA');
select pxp.f_insert_tgui ('Registro de Ventas', 'Registro de Ventas', 'LIBVEN', 'si', 2, 'sis_contabilidad/vista/doc_compra_venta/DocVenta.php', 3, '', 'DocVenta', 'CONTA');
select pxp.f_insert_testructura_gui ('LIBVEN', 'CBTE.1');
select pxp.f_insert_testructura_gui ('DOC', 'CBTE.1');
/***********************************F-DAT-RAC-CONTA-1-24/09/2015*****************************************/



/***********************************I-DAT-RAC-CONTA-1-27/09/2015*****************************************/

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES (E'conta_codigo_estacion', E'CENTRAL', E'Codigo de la estacion, regioanl o central, setuiliza para las misgracion de cbtes');

/***********************************F-DAT-RAC-CONTA-1-27/09/2015*****************************************/



/***********************************I-SCP-RAC-CONTA-0-12/11/2015****************************************/

select pxp.f_insert_tgui ('Configuración Cambiaria', 'para configurar moneda de triangulacion', 'CFCA', 'si', 1, 'sis_contabilidad/vista/config_cambiaria/ConfigCambiaria.php', 3, '', 'ConfigCambiaria', 'CONTA');
select pxp.f_insert_testructura_gui ('CFCA', 'CONF');

/***********************************F-SCP-RAC-CONTA-0-12/11/2015****************************************/




/***********************************I-SCP-RAC-CONTA-0-19/11/2015****************************************/


INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES (E'conta_error_limite_redondeo', E'0.1', E'error limite de redondeo que se peude igualar automaticamente');



INSERT INTO conta.ttipo_relacion_contable ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "nombre_tipo_relacion", "codigo_tipo_relacion", "tiene_centro_costo", "tiene_partida", "tiene_auxiliar", "id_tabla_relacion_contable", "partida_tipo", "partida_rubro")
VALUES (1, NULL, E'2015-11-19 15:16:50.261', NULL, E'activo', NULL, NULL, E'Perdida por redondeo', E'PER-RD', E'si-unico', E'si', E'no', NULL, E'presupuestaria', E'gasto');

INSERT INTO conta.ttipo_relacion_contable ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "nombre_tipo_relacion", "codigo_tipo_relacion", "tiene_centro_costo", "tiene_partida", "tiene_auxiliar", "id_tabla_relacion_contable", "partida_tipo", "partida_rubro")
VALUES (1, 1, E'2015-11-19 15:17:58.896', E'2015-11-19 15:18:17.232', E'activo', NULL, NULL, E'Ganancia por redondeo', E'GAN-RD', E'si-unico', E'si', E'no', NULL, E'presupuestaria', E'recurso');




INSERT INTO conta.ttipo_relacion_contable ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "nombre_tipo_relacion", "codigo_tipo_relacion", "tiene_centro_costo", "tiene_partida", "tiene_auxiliar", "id_tabla_relacion_contable", "partida_tipo", "partida_rubro")
VALUES (1, NULL, E'2015-11-19 15:16:50.261', NULL, E'activo', NULL, NULL, E'Perdida por tipo de cambio', E'PER-DCB', E'si-unico', E'si', E'no', NULL, E'presupuestaria', E'gasto');

INSERT INTO conta.ttipo_relacion_contable ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "nombre_tipo_relacion", "codigo_tipo_relacion", "tiene_centro_costo", "tiene_partida", "tiene_auxiliar", "id_tabla_relacion_contable", "partida_tipo", "partida_rubro")
VALUES (1, 1, E'2015-11-19 15:17:58.896', E'2015-11-19 15:18:17.232', E'activo', NULL, NULL, E'Ganancia por tipo de cambio', E'GAN-DCB', E'si-unico', E'si', E'no', NULL, E'presupuestaria', E'recurso');




/***********************************F-SCP-RAC-CONTA-0-19/11/2015****************************************/


/***********************************I-SCP-RAC-CONTA-0-23/11/2015****************************************/

select pxp.f_insert_tgui ('Registros Contables', 'Comprobantes', 'CBTE.1', 'si', 3, '', 2, '', '', 'CONTA');
select pxp.f_insert_tgui ('Registro de Comprobantes', 'Registro de Comprobantes', 'CBTE.1.1', 'si', 1, 'sis_contabilidad/vista/int_comprobante/IntComprobanteReg.php', 3, '', 'IntComprobanteReg', 'CONTA');
select pxp.f_insert_tgui ('Registro de Ventas', 'Registro de Ventas', 'LIBVEN', 'si', 2, 'sis_contabilidad/vista/doc_compra_venta/DocVenta.php', 3, '', 'DocVenta', 'CONTA');
select pxp.f_insert_tgui ('Registro de Compras', 'Registro de Compras', 'DOC', 'si', 3, 'sis_contabilidad/vista/doc_compra_venta/DocCompra.php', 3, '', 'DocCompra', 'CONTA');
select pxp.f_insert_testructura_gui ('LIBVEN', 'CBTE.1');
select pxp.f_insert_testructura_gui ('DOC', 'CBTE.1');

/***********************************F-SCP-RAC-CONTA-0-23/11/2015****************************************/






/***********************************I-SCP-RAC-CONTA-0-10/12/2015****************************************/

select pxp.f_insert_tgui ('Ajustes', 'diferentes proceso de ajuste', 'CAJT', 'si', 4, '', 2, '', '', 'CONTA');
select pxp.f_insert_tgui ('Ajuste TC', 'Ajuste por diferencia de tipo de cambio', 'AJST', 'si', 1, 'sis_contabilidad/vista/ajuste/Ajuste.php', 3, '', 'Ajuste', 'CONTA');


select pxp.f_insert_testructura_gui ('CAJT', 'CONTA');
select pxp.f_insert_testructura_gui ('AJST', 'CAJT');


select pxp.f_delete_testructura_gui ('RELACON', 'CONTA');
select pxp.f_delete_testructura_gui ('RELCONGEN', 'RELACON');

select pxp.f_insert_testructura_gui ('RELACON', 'DEFRECONCAR');
select pxp.f_insert_testructura_gui ('RELCONGEN', 'DEFRECONCAR');


/* Data for the 'pxp.variable_global' table  (Records 1 - 1) */

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES (E'conta_prioridad_depto_inter', E'3', E'prioridad depto de contabilidad internacional');

/***********************************F-SCP-RAC-CONTA-0-10/12/2015****************************************/


/***********************************I-DAT-RAC-CONTA-0-12/01/2016****************************************/

----------------------------------
--COPY LINES TO data.sql FILE
---------------------------------

select pxp.f_insert_tgui ('SISTEMA DE CONTABILIDAD', '', 'CONTA', 'si', 1, '', 1, '', '', 'CONTA');
select pxp.f_insert_tgui ('Plan de Cuentas', 'Cuentas', 'CTA', 'si', 0, 'sis_contabilidad/vista/cuenta/Cuenta.php', 2, '', 'Cuenta', 'CONTA');
select pxp.f_insert_tgui ('Auxiliares de Cuentas', 'Auxiliares de cuenta', 'AUXCTA', 'si', 0, 'sis_contabilidad/vista/auxiliar/Auxiliar.php', 2, '', 'Auxiliar', 'CONTA');
select pxp.f_insert_tgui ('Ordenes de Trabajo', 'ordenes de trabajo', 'ODT', 'si', 0, 'sis_contabilidad/vista/orden_trabajo/OrdenTrabajo.php', 2, '', 'OrdenTrabajo', 'CONTA');
select pxp.f_insert_tgui ('Config Tipo Cuenta', 'Configuracion de numero para los tipos de cuenta', 'CTIP', 'si', 0, 'sis_contabilidad/vista/config_tipo_cuenta/ConfigTipoCuenta.php', 2, '', 'ConfigTipoCuenta', 'CONTA');
select pxp.f_insert_tgui ('Clases de Comprobantes', 'Clases de Comprobantes', 'CCBT', 'si', 6, 'sis_contabilidad/vista/clase_comprobante/ClaseComprobante.php', 2, '', 'ClaseComprobante', 'CONTA');
select pxp.f_insert_tgui ('Relaciones Contables por Tabla', 'Relaciones Contables por Tabla', 'RELCON', 'si', 1, 'sis_contabilidad/vista/tabla_relacion_contable/TablaRelacionContable.php', 2, '', 'TablaRelacionContable', 'CONTA');
select pxp.f_insert_tgui ('Relaciones Contables', 'Relaciones Contables', 'RELACON', 'si', 0, '', 2, '', '', 'CONTA');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'PROVCUEN', 'si', 1, 'sis_contabilidad/vista/proveedor_cuenta/Proveedor.php', 3, '', 'ProveedorCuenta', 'CONTA');
select pxp.f_insert_tgui ('Definición de Relaciones Contables', 'Definición de Relaciones Contables', 'DEFRECONCAR', 'si', 1, '', 2, '', '', 'CONTA');
select pxp.f_insert_tgui ('Relaciones Contables Generales', 'Relaciones Contables Generales', 'RELCONGEN', 'si', 2, 'sis_contabilidad/vista/tipo_relacion_contable/TipoRelacionContableGeneral.php', 3, '', 'TipoRelacionContableGeneral', 'CONTA');
select pxp.f_insert_tgui ('Concepto de Gasto', 'Concepto de Gasto', 'CONGASCUE', 'si', 2, 'sis_contabilidad/vista/concepto_ingas_cta/ConceptoIngas.php', 3, '', 'ConceptoIngasCuenta', 'CONTA');
select pxp.f_insert_tgui ('Plantilla Comprobante', 'comprobante', 'CMPB', 'si', 7, 'sis_contabilidad/vista/plantilla_comprobante/PlantillaComprobante.php', 2, '', 'PlantillaComprobante', 'CONTA');
select pxp.f_insert_tgui ('Detalle de Comprobante', 'Detalle de Comprobante', 'CMPB.1', 'no', 0, 'sis_contabilidad/vista/detalle_plantilla_comprobante/DetallePlantillaComprobante.php', 3, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Cuentas Bancarias', 'relacion de cuentas bancarias y cuentas contables', 'RELCCCB', 'si', 4, 'sis_contabilidad/vista/cta_cuenta_bancaria/CtaCuentaBancaria.php', 3, '', 'CtaCuentaBancaria', 'CONTA');
select pxp.f_insert_tgui ('Registros Contables', 'Comprobantes', 'CBTE.1', 'si', 3, '', 2, '', '', 'CONTA');
select pxp.f_insert_tgui ('Registro de Comprobantes', 'Registro de Comprobantes', 'CBTE.1.1', 'si', 1, 'sis_contabilidad/vista/int_comprobante/IntComprobanteReg.php', 3, '', 'IntComprobanteReg', 'CONTA');
select pxp.f_insert_tgui ('Departamentos', 'Cuntas por Deptos Contables', 'DEPTCON', 'si', 5, 'sis_contabilidad/vista/cta_relacion_contable/CtaDepto.php', 3, '', 'CtaDepto', 'CONTA');
select pxp.f_insert_tgui ('Plantilla de Documentos', 'Plantilla de Documentos', 'PLADOC', 'si', 5, 'sis_contabilidad/vista/plantilla/Plantilla.php', 2, '', 'PlantillaConta', 'CONTA');
select pxp.f_insert_tgui ('Gestión de Períodos', 'Gestión de Períodos', 'CONPER', 'si', 8, 'sis_contabilidad/vista/periodo_subsistema/PeriodoConta.php', 2, '', 'PeriodoConta', 'CONTA');
select pxp.f_insert_tgui ('Libros Contables', 'Libros Contables', 'CBTE.1.3', 'si', 3, '', 2, '', '', 'CONTA');
select pxp.f_insert_tgui ('Libro Diario', 'Libro Diario', 'CBTE.1.3.1', 'si', 1, 'sis_contabilidad/vista/int_comprobante/IntComprobanteLd.php', 3, '', 'IntComprobanteLd', 'CONTA');
select pxp.f_insert_tgui ('Cuentas por Almacenes', 'Cuentas por Almacenes', 'ALMCUE', 'si', 5, 'sis_contabilidad/vista/cta_relacion_contable/CtaAlmacen.php', 3, '', 'CtaAlmacen', 'CONTA');
select pxp.f_insert_tgui ('Cuentas por Clasificación', 'Cuentas por Clasificación', 'CLACUE', 'si', 5, 'sis_contabilidad/vista/cta_relacion_contable/CtaClasificacion.php', 3, '', 'CtaClasificacion', 'CONTA');
select pxp.f_insert_tgui ('Replicación Relaciones Contables', 'Replicación Relaciones Contables', 'RERELCON', 'si', 2, 'sis_contabilidad/vista/gestion/GestionConta.php', 2, '', 'GestionConta', 'CONTA');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'CTA.1', 'no', 0, 'sis_contabilidad/vista/cuenta_auxiliar/CuentaAuxiliar.php', 3, '', 'CuentaAuxiliar', 'CONTA');
select pxp.f_insert_tgui ('Tipo Relacion Contable', 'Tipo Relacion Contable', 'RELCON.1', 'no', 0, 'sis_contabilidad/vista/tipo_relacion_contable/TipoRelacionContableTabla.php', 3, '', '60%', 'CONTA');
select pxp.f_insert_tgui ('Catálogo', 'Catálogo', 'RELCON.2', 'no', 0, 'sis_parametros/vista/catalogo/Catalogo.php', 3, '', 'Catalogo', 'CONTA');
select pxp.f_insert_tgui ('Catálogo', 'Catálogo', 'RELCON.1.1', 'no', 0, 'sis_parametros/vista/catalogo/Catalogo.php', 4, '', 'Catalogo', 'CONTA');
select pxp.f_insert_tgui ('Relacion Contable', 'Relacion Contable', 'PROVCUEN.1', 'no', 0, 'sis_contabilidad/vista/relacion_contable/RelacionContableTabla.php', 4, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Personas', 'Personas', 'PROVCUEN.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 4, '', 'persona', 'CONTA');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'PROVCUEN.3', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 4, '', 'Institucion', 'CONTA');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'PROVCUEN.2.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 5, '', 'subirFotoPersona', 'CONTA');
select pxp.f_insert_tgui ('Personas', 'Personas', 'PROVCUEN.3.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'CONTA');
select pxp.f_insert_tgui ('Relacion Contable', 'Relacion Contable', 'RELCONGEN.1', 'no', 0, 'sis_contabilidad/vista/relacion_contable/RelacionContableGeneral.php', 4, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Catálogo', 'Catálogo', 'RELCONGEN.2', 'no', 0, 'sis_parametros/vista/catalogo/Catalogo.php', 4, '', 'Catalogo', 'CONTA');
select pxp.f_insert_tgui ('Relacion Contable', 'Relacion Contable', 'CONGASCUE.1', 'no', 0, 'sis_contabilidad/vista/relacion_contable/RelacionContableTabla.php', 4, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Catálogo', 'Catálogo', 'CONGASCUE.2', 'no', 0, 'sis_parametros/vista/catalogo/Catalogo.php', 4, '', 'Catalogo', 'CONTA');
select pxp.f_insert_tgui ('Relacion Contable', 'Relacion Contable', 'RELCCCB.1', 'no', 0, 'sis_contabilidad/vista/relacion_contable/RelacionContableTabla.php', 4, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Chequeras', 'Chequeras', 'RELCCCB.2', 'no', 0, 'sis_tesoreria/vista/chequera/Chequera.php', 4, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'RELCCCB.3', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 4, '', 'Institucion', 'CONTA');
select pxp.f_insert_tgui ('Personas', 'Personas', 'RELCCCB.3.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'CONTA');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'RELCCCB.3.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 6, '', 'subirFotoPersona', 'CONTA');
select pxp.f_insert_tgui ('Transacciones', 'Transacciones', 'CBTE.1.1.1', 'no', 0, 'sis_contabilidad/vista/int_transaccion/IntTransaccion.php', 4, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Catálogo', 'Catálogo', 'CBTE.1.1.2', 'no', 0, 'sis_parametros/vista/catalogo/Catalogo.php', 4, '', 'Catalogo', 'CONTA');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'CBTE.1.1.3', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 4, '', 'funcionario', 'CONTA');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'CBTE.1.1.3.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 5, '', 'FuncionarioCuentaBancaria', 'CONTA');
select pxp.f_insert_tgui ('Personas', 'Personas', 'CBTE.1.1.3.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'CONTA');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'CBTE.1.1.3.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 6, '', 'Institucion', 'CONTA');
select pxp.f_insert_tgui ('Personas', 'Personas', 'CBTE.1.1.3.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'CONTA');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'CBTE.1.1.3.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 8, '', 'subirFotoPersona', 'CONTA');
select pxp.f_insert_tgui ('Relacion Contable', 'Relacion Contable', 'DEPTCON.1', 'no', 0, 'sis_contabilidad/vista/relacion_contable/RelacionContableTabla.php', 4, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Usuarios por Departamento', 'Usuarios por Departamento', 'DEPTCON.2', 'no', 0, 'sis_parametros/vista/depto_usuario/DeptoUsuario.php', 4, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Depto - UO', 'Depto - UO', 'DEPTCON.3', 'no', 0, 'sis_parametros/vista/depto_uo/DeptoUo.php', 4, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Depto - EP', 'Depto - EP', 'DEPTCON.4', 'no', 0, 'sis_parametros/vista/depto_ep/DeptoEp.php', 4, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Depto UO - EP', 'Depto UO - EP', 'DEPTCON.5', 'no', 0, 'sis_parametros/vista/depto_uo_ep/DeptoUoEp.php', 4, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Firmas Documentos', 'Firmas Documentos', 'DEPTCON.6', 'no', 0, 'sis_parametros/vista/firma/Firma.php', 4, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Subsistema', 'Subsistema', 'DEPTCON.7', 'no', 0, 'id_subsistema', 4, '', 'Subsistema...', 'CONTA');
select pxp.f_insert_tgui ('Usuarios', 'Usuarios', 'DEPTCON.2.1', 'no', 0, 'sis_seguridad/vista/usuario/Usuario.php', 5, '', 'usuario', 'CONTA');
select pxp.f_insert_tgui ('Personas', 'Personas', 'DEPTCON.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 6, '', 'persona', 'CONTA');
select pxp.f_insert_tgui ('Roles', 'Roles', 'DEPTCON.2.1.2', 'no', 0, 'sis_seguridad/vista/usuario_rol/UsuarioRol.php', 6, '', 'usuario_rol', 'CONTA');
select pxp.f_insert_tgui ('EP\', 'EP\', 'DEPTCON.2.1.3', 'no', 0, 'sis_seguridad/vista/usuario_grupo_ep/UsuarioGrupoEp.php', 6, '', ',
          width:400,
          cls:', 'CONTA');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'DEPTCON.2.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 7, '', 'subirFotoPersona', 'CONTA');
select pxp.f_insert_tgui ('Plantilla Cálculo', 'Plantilla Cálculo', 'PLADOC.1', 'no', 0, 'sis_contabilidad/vista/plantilla_calculo/PlantillaCalculo.php', 3, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Catálogo', 'Catálogo', 'PLADOC.1.1', 'no', 0, 'sis_parametros/vista/catalogo/Catalogo.php', 4, '', 'Catalogo', 'CONTA');
select pxp.f_insert_tgui ('Transacciones', 'Transacciones', 'CBTE.1.3.1.1', 'no', 0, 'sis_contabilidad/vista/transaccion/Transaccion.php', 4, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Catálogo', 'Catálogo', 'CBTE.1.3.1.2', 'no', 0, 'sis_parametros/vista/catalogo/Catalogo.php', 4, '', 'Catalogo', 'CONTA');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'CBTE.1.3.1.3', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 4, '', 'funcionario', 'CONTA');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'CBTE.1.3.1.3.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 5, '', 'FuncionarioCuentaBancaria', 'CONTA');
select pxp.f_insert_tgui ('Personas', 'Personas', 'CBTE.1.3.1.3.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'CONTA');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'CBTE.1.3.1.3.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 6, '', 'Institucion', 'CONTA');
select pxp.f_insert_tgui ('Personas', 'Personas', 'CBTE.1.3.1.3.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'CONTA');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'CBTE.1.3.1.3.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 8, '', 'subirFotoPersona', 'CONTA');
select pxp.f_insert_tgui ('Relacion Contable', 'Relacion Contable', 'ALMCUE.1', 'no', 0, 'sis_contabilidad/vista/relacion_contable/RelacionContableTabla.php', 4, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Personal del Almacén', 'Personal del Almacén', 'ALMCUE.2', 'no', 0, 'sis_almacenes/vista/almacenUsuario/AlmacenUsuario.php', 4, '', 'AlmacenUsuario', 'CONTA');
select pxp.f_insert_tgui ('Stock Minimo de almacenes', 'Stock Minimo de almacenes', 'ALMCUE.3', 'no', 0, 'sis_almacenes/vista/almacenStock/AlmacenStock.php', 4, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Upload archivos', 'Upload archivos', 'ALMCUE.4', 'no', 0, 'sis_parametros/vista/tabla_upload/TablaUpload.php', 4, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('btnSwitchEstado', 'btnSwitchEstado', 'ALMCUE.5', 'no', 0, 'btnAlmacenUsuario', 4, '', 'inactivo', 'CONTA');
select pxp.f_insert_tgui ('Gestión Almacenes', 'Gestión Almacenes', 'ALMCUE.6', 'no', 0, 'sis_almacenes/vista/almacen_gestion/AlmacenGestion.php', 4, '', '70%', 'CONTA');
select pxp.f_insert_tgui ('Items', 'Items', 'ALMCUE.3.1', 'no', 0, 'sis_almacenes/vista/item/BuscarItem.php', 5, '', 'BuscarItem', 'CONTA');
select pxp.f_insert_tgui ('Existencia de Materiales por Almacén', 'Existencia de Materiales por Almacén', 'ALMCUE.3.1.1', 'no', 0, 'sis_almacenes/vista/item/ItemExistenciaAlmacen.php', 6, '', '30%', 'CONTA');
select pxp.f_insert_tgui ('Histórico Gestión', 'Histórico Gestión', 'ALMCUE.6.1', 'no', 0, 'sis_almacenes/vista/almacen_gestion_log/AlmacenGestionLog.php', 5, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Movimientos Pendientes', 'Movimientos Pendientes', 'ALMCUE.6.2', 'no', 0, 'sis_almacenes/vista/movimiento/MovimientoReq.php', 5, '', '70%', 'CONTA');
select pxp.f_insert_tgui ('Detalle de Movimiento', 'Detalle de Movimiento', 'ALMCUE.6.2.1', 'no', 0, 'sis_almacenes/vista/movimientoDetalle/MovimientoDetalle.php', 6, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Alarmas', 'Alarmas', 'ALMCUE.6.2.2', 'no', 0, 'sis_parametros/vista/alarma/AlarmaFuncionario.php', 6, '', 'AlarmaFuncionario', 'CONTA');
select pxp.f_insert_tgui ('Items', 'Items', 'ALMCUE.6.2.1.1', 'no', 0, 'sis_almacenes/vista/item/BuscarItem.php', 7, '', 'BuscarItem', 'CONTA');
select pxp.f_insert_tgui ('Valoracion del Detalle', 'Valoracion del Detalle', 'ALMCUE.6.2.1.2', 'no', 0, 'sis_almacenes/vista/movimientoDetValorado/MovimientoDetValorado.php', 7, '', '20%', 'CONTA');
select pxp.f_insert_tgui ('Relacion Contable', 'Relacion Contable', 'CLACUE.1', 'no', 0, 'sis_contabilidad/vista/relacion_contable/RelacionContableTabla.php', 4, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Materiales', 'Materiales', 'CLACUE.2', 'no', 0, 'sis_almacenes/vista/item/Item.php', 4, '', 'Item', 'CONTA');
select pxp.f_insert_tgui ('Items de Reemplazo', 'Items de Reemplazo', 'CLACUE.2.1', 'no', 0, 'sis_almacenes/vista/itemReemplazo/ItemReemplazo.php', 5, '', 'ItemReemplazo', 'CONTA');
select pxp.f_insert_tgui ('Archivos del Item', 'Archivos del Item', 'CLACUE.2.2', 'no', 0, 'sis_almacenes/vista/itemArchivo/ItemArchivo.php', 5, '', 'ItemArchivo', 'CONTA');
select pxp.f_insert_tgui ('Unidades de Medida', 'Unidades de Medida', 'CLACUE.2.3', 'no', 0, 'sis_parametros/vista/unidad_medida/UnidadMedida.php', 5, '', 'UnidadMedida', 'CONTA');
select pxp.f_insert_tgui ('Items', 'Items', 'CLACUE.2.1.1', 'no', 0, 'sis_almacenes/vista/item/BuscarItem.php', 6, '', 'BuscarItem', 'CONTA');
select pxp.f_insert_tgui ('Existencia de Materiales por Almacén', 'Existencia de Materiales por Almacén', 'CLACUE.2.1.1.1', 'no', 0, 'sis_almacenes/vista/item/ItemExistenciaAlmacen.php', 7, '', '30%', 'CONTA');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'CLACUE.2.2.1', 'no', 0, 'sis_almacenes/vista/itemArchivo/SubirArchivo.php', 6, '', 'SubirArchivo', 'CONTA');
select pxp.f_insert_tgui ('Catálogo', 'Catálogo', 'CLACUE.2.3.1', 'no', 0, 'sis_parametros/vista/catalogo/Catalogo.php', 6, '', 'Catalogo', 'CONTA');
select pxp.f_insert_tgui ('Periodos', 'Periodos', 'RERELCON.1', 'no', 0, 'sis_parametros/vista/periodo/Periodo.php', 3, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Catálogo', 'Catálogo', 'RERELCON.2', 'no', 0, 'sis_parametros/vista/catalogo/Catalogo.php', 3, '', 'Catalogo', 'CONTA');
select pxp.f_insert_tgui ('Periodo Subistema', 'Periodo Subistema', 'RERELCON.1.1', 'no', 0, 'sis_parametros/vista/periodo_subsistema/PeriodoSubsistema.php', 4, '', '50%', 'CONTA');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'PROVCUEN.3.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 6, '', 'subirFotoPersona', 'CONTA');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'CBTE.1.1.3.2.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 6, '', 'subirFotoPersona', 'CONTA');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'CBTE.1.3.1.3.2.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 6, '', 'subirFotoPersona', 'CONTA');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'ALMCUE.6.2.3', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 6, '', 'funcionario', 'CONTA');
select pxp.f_insert_tgui ('Existencia de Materiales por Almacén', 'Existencia de Materiales por Almacén', 'ALMCUE.6.2.1.1.1', 'no', 0, 'sis_almacenes/vista/item/ItemExistenciaAlmacen.php', 8, '', '30%', 'CONTA');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'ALMCUE.6.2.3.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 7, '', 'FuncionarioCuentaBancaria', 'CONTA');
select pxp.f_insert_tgui ('Personas', 'Personas', 'ALMCUE.6.2.3.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'CONTA');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'ALMCUE.6.2.3.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 8, '', 'Institucion', 'CONTA');
select pxp.f_insert_tgui ('Personas', 'Personas', 'ALMCUE.6.2.3.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 9, '', 'persona', 'CONTA');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'ALMCUE.6.2.3.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 10, '', 'subirFotoPersona', 'CONTA');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'ALMCUE.6.2.3.2.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 8, '', 'subirFotoPersona', 'CONTA');
select pxp.f_insert_tgui ('Libro Mayor', 'Libro Mayor', 'LIBMAY', 'si', 2, 'sis_contabilidad/vista/int_transaccion/FormFiltro.php', 3, '', 'FormFiltro', 'CONTA');
select pxp.f_insert_tgui ('Bancarizacion', 'banca', 'banca', 'si', 1, '', 2, '', '', 'CONTA');
select pxp.f_insert_tgui ('Config. Bancarizacion', 'configuraciones', 'CONFBA', 'si', 2, 'sis_contabilidad/vista/config_banca/ConfigBanca.php', 3, '', 'ConfigBanca', 'CONTA');
select pxp.f_insert_tgui ('Banca Compra', 'Banca Compra', 'BACO', 'si', 3, 'sis_contabilidad/vista/banca_compra_venta/BancaCompra.php', 3, '', 'BancaCompra', 'CONTA');
select pxp.f_insert_tgui ('Banca Ventas', 'Banca Ventas', 'BAVE', 'si', 4, 'sis_contabilidad/vista/banca_compra_venta/BancaVenta.php', 3, '', 'BancaVenta', 'CONTA');
select pxp.f_insert_tgui ('Registro de Compras', 'Registro de Compras', 'DOC', 'si', 3, 'sis_contabilidad/vista/doc_compra_venta/DocCompra.php', 3, '', 'DocCompra', 'CONTA');
select pxp.f_insert_tgui ('Registro de Ventas', 'Registro de Ventas', 'LIBVEN', 'si', 2, 'sis_contabilidad/vista/doc_compra_venta/DocVenta.php', 3, '', 'DocVenta', 'CONTA');
select pxp.f_insert_tgui ('Nomenclatura', 'Nomenclatura', 'CNOM', 'si', 1, '', 2, '', '', 'CONTA');
select pxp.f_delete_tgui ('CBONF');
select pxp.f_insert_tgui ('Reportes', 'Reportes', 'REPCON', 'si', 10, '', 2, '', '', 'CONTA');
select pxp.f_insert_tgui ('Balance de Cuentas', 'Balance de Cuentas', 'BALCON', 'si', 1, 'sis_contabilidad/vista/cuenta/FormFiltroBalanceCuentas.php', 3, '', 'FormFiltroBalanceCuentas', 'CONTA');
select pxp.f_insert_tgui ('Resultados', 'Reportes de Resutlados', 'REPRES', 'si', 2, 'sis_contabilidad/vista/cuenta/FormFiltroResultado.php', 3, '', 'FormFiltroResultado', 'CONTA');
select pxp.f_insert_tgui ('Balance General', 'Balance general', 'BALGEN', 'si', 1, 'sis_contabilidad/vista/cuenta/FormFiltroBalance.php', 3, '', 'FormFiltroBalance', 'CONTA');
select pxp.f_insert_tgui ('Plantilla de Resultados', 'Plantilla  para reporte de resultados', 'PLANRES', 'si', 3, 'sis_contabilidad/vista/resultado_plantilla/ResultadoPlantilla.php', 3, '', 'ResultadoPlantilla', 'CONTA');
select pxp.f_insert_tgui ('Periodos Compra Venta', 'Configuracion de periodos de compra  y venta', 'PCV', 'si', 1, 'sis_contabilidad/vista/periodo_compra_venta/DeptoConta.php', 3, '', 'DeptoConta', 'CONTA');
select pxp.f_insert_tgui ('Tipo de relación en comprobantes', 'Tipo de relación en comprobantes', 'TRECOM', 'si', 4, 'sis_contabilidad/vista/tipo_relacion_comprobante/TipoRelacionComprobante.php', 3, '', 'TipoRelacionComprobante', 'CONTA');
select pxp.f_insert_tgui ('Configuraciones', 'Configuraciones', 'CONF', 'si', 1, '', 2, '', '', 'CONTA');
select pxp.f_insert_tgui ('Configuración Cambiaria', 'para configurar moneda de triangulacion', 'CFCA', 'si', 1, 'sis_contabilidad/vista/config_cambiaria/ConfigCambiaria.php', 3, '', 'ConfigCambiaria', 'CONTA');




/***********************************F-DAT-RAC-CONTA-0-12/01/2016****************************************/


/***********************************I-DAT-RAC-CONTA-0-10/02/2016****************************************/


/* Data for the 'conta.ttipo_relacion_contable' table  (Records 1 - 42) */

INSERT INTO conta.ttipo_relacion_contable ("id_usuario_reg", "fecha_reg", "estado_reg", "id_usuario_ai", "usuario_ai", "nombre_tipo_relacion", "codigo_tipo_relacion", "tiene_centro_costo", "tiene_partida", "tiene_auxiliar", "id_tabla_relacion_contable", "partida_tipo", "partida_rubro")
VALUES

  (1, E'2015-08-20 10:20:21.948', E'activo', NULL, NULL, E'IVA-DF', E'IVA-DF', E'no', E'si', E'si', NULL, E'presupuestaria', E'recurso'),
  (1, E'2015-08-20 10:22:29.125', E'activo', NULL, NULL, E'IT', E'IT', E'no', E'si', E'si', NULL, E'presupuestaria', E'gasto'),
  (1, E'2015-08-20 10:24:29.179', E'activo', NULL, NULL, E'IT por pagar', E'ITxPagar', E'no', E'si', E'si', NULL, E'flujo', E'recurso'),
  (1, E'2015-09-24 13:20:42.111', E'activo', NULL, NULL, E'Compras por defecto', E'CMPDEF', E'no', E'si', E'si', NULL, E'flujo', E'gasto'),
  (1, E'2015-09-24 14:03:20.381', E'activo', NULL, NULL, E'Cuenta de Banco para ventas por defecto', E'VENDEF', E'si-unico', E'si', E'si', NULL, E'flujo', E'recurso'),
  (175, E'2015-10-20 10:12:43.844', E'activo', NULL, NULL, E'Cuentas Bancarias Ingresos', E'CUEBANCING', E'no', E'si', E'si', 2, E'flujo', E'recurso_gasto');


/* Data for the 'conta.ttipo_relacion_contable' table  (Records 1 - 6) */

INSERT INTO conta.ttipo_relacion_contable ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "nombre_tipo_relacion", "codigo_tipo_relacion", "tiene_centro_costo", "tiene_partida", "tiene_auxiliar", "id_tabla_relacion_contable", "partida_tipo", "partida_rubro")
VALUES
  (1, NULL, E'2016-02-15 17:30:01.038', NULL, E'activo', NULL, NULL, E'Cuentas por Pagar por defecto', E'CXPDF', E'no', E'si', E'no', NULL, E'flujo', E'recurso'),
  (1, NULL, E'2016-02-15 17:27:50.168', NULL, E'activo', NULL, NULL, E'Cuentas por Cobrar defecto', E'CXCDF', E'no', E'si', E'no', NULL, E'flujo', E'gasto'),
  (1, NULL, E'2016-02-15 17:10:03.802', NULL, E'activo', NULL, NULL, E'Retención de anticipos en ventas por defecto', E'VRETANTD', E'no', E'si', E'no', NULL, E'flujo', E'recurso'),
  (1, NULL, E'2016-02-15 17:07:04.488', NULL, E'activo', NULL, NULL, E'Retencion de anticipo en compras por defecto', E'CMRETANTD', E'no', E'si', E'no', NULL, E'flujo', E'recurso'),
  (1, NULL, E'2016-02-15 17:04:27.022', NULL, E'activo', NULL, NULL, E'Retención de garantía en ventas por defecto', E'VRETGARDF', E'no', E'si', E'no', NULL, E'flujo', E'gasto'),
  (1, NULL, E'2016-02-15 17:02:12.003', NULL, E'activo', NULL, NULL, E'Retencion de garantia en compras por defecto', E'CMRETGARDF', E'no', E'si', E'no', NULL, E'flujo', E'recurso');




SELECT pxp.f_update_table_sequence ('conta','tplantilla_comprobante');
SELECT pxp.f_update_table_sequence ('conta','tdetalle_plantilla_comprobante');
----------------------------------
--comprobante de compras
---------------------------------

select conta.f_import_tplantilla_comprobante ('insert','COMPRADOC','conta.f_ges_cbte_eliminacion_doc_compra_venta','id_agrupador','CONTA','Varias Compras','','{$tabla.fecha_cbte}','activo','','{$tabla.id_depto_conta}','contable','','conta.vagrupador','DIARIO','{$tabla.id_moneda}','{$tabla.id_gestion}','{$tabla.id_moneda},{$tabla.id_gestion},{$tabla.id_depto_conta},{id_agrupador}','no','no','no','','','','','','','','','','');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','COMPRADOC','COMPRADOC.3','haber','no','si','','','CMRETGARDF','','{$tabla.importe_retgar}','','','no','','{$tabla.id_auxiliar}','','si','','id_agrupador','','retencion de garantia','{$tabla.importe_retgar}',NULL,'simple','','{$tabla.id_doc_compra_venta}','no','','','','','','','','2','','conta.vdoc_compra_venta',NULL,'');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','COMPRADOC','COMPRADOC.1','debe','si','si','','{$tabla.descripcion}','CUECOMP','','{$tabla.precio_total_final}','{$tabla.id_concepto_ingas}','{$tabla.id_plantilla}','si','{$tabla.id_centro_costo}','','','si','','id_agrupador','','Concepto de Gasto','{$tabla.precio_total_final}',NULL,'simple','','{$tabla.id_doc_concepto}','no','','','','','','{$tabla.importe_total_excento}','','2','{$tabla.id_orden_trabajo}','conta.vdoc_compra_venta_det',NULL,'');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','COMPRADOC','COMPRADOC.2','haber','no','si','','','CMPDEF','','{$tabla.importe_pago_liquido}','','','no','','','','si','','id_agrupador','','cuenta para bancos','{$tabla.importe_pago_liquido}','39','simple','','{$tabla.id_doc_compra_venta}','no','','','','','','','','2','','conta.vdoc_compra_venta',NULL,'');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','COMPRADOC','COMPRADOC.4','haber','no','si','','','CMRETANTD','','{$tabla.importe_anticipo}','','','no','','{$tabla.id_auxiliar}','','si','','id_agrupador','','retención de anticipos','{$tabla.importe_anticipo}',NULL,'simple','','{$tabla.id_doc_compra_venta}','no','','','','','','','','2','','conta.vdoc_compra_venta',NULL,'');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','COMPRADOC','COMPRADOC.5','haber','no','si','','','CXPDF','','{$tabla.importe_pendiente}','','','no','','{$tabla.id_auxiliar}','','si','','id_agrupador','','cuentas por pagar','{$tabla.importe_pendiente}',NULL,'simple','','{$tabla.id_doc_compra_venta}','no','','','','','','','','2','','conta.vdoc_compra_venta',NULL,'');
----------------------------------
-- Comprobante de ventas
---------------------------------


select conta.f_import_tplantilla_comprobante ('insert','VENTADOC','conta.f_ges_cbte_eliminacion_doc_compra_venta','id_agrupador','CONTA','Ventas según LCV','','{$tabla.fecha_cbte}','activo','','{$tabla.id_depto_conta}','contable','','conta.vagrupador','DIARIO','{$tabla.id_moneda}','{$tabla.id_gestion}','{$tabla.id_moneda},{$tabla.id_gestion},{$tabla.id_depto_conta},{id_agrupador}','no','no','no','','','','','','','','','','');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','VENTADOC','VENTADOC.2','debe','si','si','','','VENDEF','','{$tabla.importe_pago_liquido}','','','no','','','','si','','id_agrupador','','ingreso a bancos','{$tabla.importe_pago_liquido}','41','simple','','{$tabla.id_doc_compra_venta}','no','','','','','','','','2','','conta.vdoc_compra_venta','PAGRRHH.2','');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','VENTADOC','VENTADOC.1','haber','si','si','','{$tabla.descripcion}','CUEVENT','','{$tabla.precio_total_final}','{$tabla.id_concepto_ingas}','{$tabla.id_plantilla}','si','{$tabla.id_centro_costo}','','','si','','id_agrupador','','Venta concepto de gasto','{$tabla.precio_total_final}',NULL,'simple','','{$tabla.id_doc_concepto}','no','','','','','','{$tabla.importe_total_excento}','','2','{$tabla.id_orden_trabajo}','conta.vdoc_compra_venta_det',NULL,'');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','VENTADOC','VENTADOC.3','debe','si','si','','','VRETGARDF','','{$tabla.importe_retgar}','','','no','','{$tabla.id_auxiliar}','','si','','id_agrupador','','Retencion de garantías por cobrar','{$tabla.importe_retgar}',NULL,'simple','','{$tabla.id_doc_compra_venta}','no','','','','','','','','2','','conta.vdoc_compra_venta',NULL,'');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','VENTADOC','VENTADOC.4','debe','no','si','','','VRETANTD','','{$tabla.importe_anticipo}','','','no','','{$tabla.id_auxiliar}','','si','','id_agrupador','','descuento de anticipo pagados por adelantado','{$tabla.importe_anticipo}',NULL,'simple','','{$tabla.id_doc_compra_venta}','no','','','','','','','','2','','conta.vdoc_compra_venta',NULL,'');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','VENTADOC','VENTADOC.5','debe','no','si','','','CXCDF','','{$tabla.importe_pendiente}','','','no','','{$tabla.id_auxiliar}','','si','','id_agrupador','','cuentas por cobrar','{$tabla.importe_pendiente}',NULL,'simple','','{$tabla.id_doc_compra_venta}','no','','','','','','','','2','','conta.vdoc_compra_venta',NULL,'');

/***********************************F-DAT-RAC-CONTA-0-10/02/2016****************************************/



/***********************************I-DAT-RAC-CONTA-0-22/02/2016****************************************/

/* Data for the 'conta.ttipo_doc_compra_venta' table  (Records 1 - 10) */

INSERT INTO conta.ttipo_doc_compra_venta ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "codigo", "nombre", "tipo", "obs")
VALUES
  (1, NULL, E'2016-02-22 12:45:59.328', NULL, E'activo', NULL, E'NULL', E'1', E'mercado interno con destino a actividades gravadas', E'compra', E'Compras para mercado interno con destino a actividades gravadas'),
  (1, NULL, E'2016-02-22 12:46:17.472', NULL, E'activo', NULL, E'NULL', E'2', E'mercado interno con destino a actividades no gravadas,', E'compra', E'Compras para mercado interno con destino a actividades no gravadas'),
  (1, NULL, E'2016-02-22 12:46:51.278', NULL, E'activo', NULL, E'NULL', E'3', E'sujetas a proporcionalidad', E'compra', E'Compras sujetas a proporcionalidad, no se puede determinar si es 1  o 2'),
  (1, 1, E'2016-02-22 12:47:12.068', E'2016-02-22 12:47:37.274', E'activo', NULL, E'NULL', E'4', E'para exportaciones', E'compra', E'Compras para exportaciones'),
  (1, NULL, E'2016-02-22 12:47:30.322', NULL, E'activo', NULL, E'NULL', E'5', E'para el mercado interno como para exportaciones', E'compra', E'Compras tanto para el mercado interno como para exportaciones'),
  (1, NULL, E'2016-02-22 12:49:33.293', NULL, E'activo', NULL, E'NULL', E'A', E'ANULADA', E'venta', E'facturas anuladas'),
  (1, NULL, E'2016-02-22 12:49:46.540', NULL, E'activo', NULL, E'NULL', E'V', E'VALIDA', E'venta', E'facturas calida'),
  (1, NULL, E'2016-02-22 12:50:00.442', NULL, E'activo', NULL, E'NULL', E'E', E'EXTRAVIADA', E'venta', E'facturas extraviada'),
  (1, NULL, E'2016-02-22 12:50:14.012', NULL, E'activo', NULL, E'NULL', E'N', E'NO UTILIZADA', E'venta', E'NO UTILIZADA'),
  (1, 1, E'2016-02-22 12:50:25.858', E'2016-02-22 12:51:08.179', E'activo', NULL, E'NULL', E'C', E'EMITIDA POR CONTINGENCIA', E'venta', E'EMITIDA POR CONTINGENCIA, por corte de energía por ejemplo en el caso de ser emitida manualmente, necesitara un informe de justificación');



 select pxp.f_insert_tgui ('Tipo Doc LCV', 'Tipo de documentos compra y venta', 'TIPLCV', 'si', 5, 'sis_contabilidad/vista/tipo_doc_compra_venta/TipoDocCompraVenta.php', 3, '', 'TipoDocCompraVenta', 'CONTA');
 select pxp.f_insert_testructura_gui ('TIPLCV', 'CONF');


/***********************************F-DAT-RAC-CONTA-0-22/02/2016****************************************/


/***********************************I-DAT-RAC-CONTA-0-29/02/2016****************************************/


/* Data for the 'pxp.variable_global' table  (Records 1 - 1) */

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES
  (E'conta_libro_compras_detallado', E'si', E'Si la interface de libro de compras permite el registro del detalle de la factura');

/***********************************F-DAT-RAC-CONTA-0-29/02/2016****************************************/




/***********************************I-DAT-RAC-CONTA-0-10/03/2016*****************************************/

select pxp.f_insert_tgui ('Reporte LCV - IVA', 'Reporte LCV - IVA', 'REPLCV', 'si', 4, 'sis_contabilidad/reportes/formularios/LibroComprasVentasIVA.php', 3, '', 'ReporteLibroComprasVentasIVA', 'CONTA');
select pxp.f_insert_testructura_gui ('REPLCV', 'REPCON');


/***********************************F-DAT-RAC-CONTA-0-10/03/2016*****************************************/




/***********************************I-DAT-RAC-CONTA-0-22/03/2016*****************************************/

INSERT INTO conta.ttabla_relacion_contable ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "id_tabla_relacion_contable", "tabla", "esquema", "tabla_id", "tabla_id_fk", "recorrido_arbol", "tabla_id_auxiliar", "tabla_codigo_auxiliar")
VALUES
  (1, NULL, E'2016-03-22 13:21:05.346', NULL, E'activo', NULL, NULL, 11, E'tfuncionario', E'ORGA', E'id_funcionario', E'', E'', E'', E'codigo');



INSERT INTO conta.ttipo_relacion_contable ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai",  "nombre_tipo_relacion", "codigo_tipo_relacion", "tiene_centro_costo", "tiene_partida", "tiene_auxiliar", "id_tabla_relacion_contable", "partida_tipo", "partida_rubro")
VALUES
  (1, NULL, E'2016-03-22 13:22:39.393', NULL, E'activo', NULL, NULL,  E'Cuenta por Rendir', E'CUEXREND', E'no', E'si', E'dinamico', 11, E'flujo', E'recurso_gasto');


/* Data for the 'conta.ttipo_relacion_contable' table  (Records 1 - 1) */

INSERT INTO conta.ttipo_relacion_contable ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai",  "nombre_tipo_relacion", "codigo_tipo_relacion", "tiene_centro_costo", "tiene_partida", "tiene_auxiliar", "id_tabla_relacion_contable", "partida_tipo", "partida_rubro")
VALUES
  (1, NULL, E'2016-03-24 14:46:07.159', NULL, E'activo', NULL, NULL,  E'Entrega de Dinero por Rendir', E'EDINXRENDIR', E'no', E'si', E'si', 11, E'flujo', E'gasto');


/***********************************F-DAT-RAC-CONTA-0-22/03/2016*****************************************/


/***********************************I-DAT-RAC-CONTA-0-12/04/2016*****************************************/

select param.f_import_tdocumento ('insert','CBT','Numero de Tramite Cbte','CONTA','depto','gestion','',NULL);

/***********************************F-DAT-RAC-CONTA-0-12/04/2016*****************************************/



/***********************************I-DAT-RAC-CONTA-0-25/05/2016*****************************************/



INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES
  (E'conta_codigo_macro_wf_cbte', E'CBT', E'codigo de proceso macro del WF de contabilidad');


/***********************************F-DAT-RAC-CONTA-0-25/05/2016*****************************************/





/**********************************I-DAT-RAC-CONTA-0-29/06/2016*****************************************/


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
---------------------------------

select wf.f_import_tproceso_macro ('insert','CBT', 'CONTA', 'Comprobante','si');
select wf.f_import_tcategoria_documento ('insert','legales', 'Legales');
select wf.f_import_tcategoria_documento ('insert','proceso', 'Proceso');
select wf.f_import_ttipo_proceso ('insert','CBTE',NULL,NULL,'CBT','Comprobante','','','si','','','','CBTE',NULL);
select wf.f_import_ttipo_estado ('insert','borrador','CBTE','Borrador','si','no','no','ninguno','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','validado','CBTE','Validado','no','si','si','ninguno','','anterior','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','vbcbte','CBTE','VoBo','no','no','no','segun_depto','','anterior','','','si','si',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','anulado','CBTE','Anulado','no','no','si','anterior','','anterior','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','eliminado','CBTE','Eliminado','no','no','si','anterior','','anterior','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_documento ('insert','CBTE','CBTE','Comprobante','Comprobante','sis_contabilidad/control/IntComprobante/reporteCbte/','generado',1.00,'{}');
select wf.f_import_testructura_estado ('delete','borrador','vbcbte','CBTE',NULL,NULL);
select wf.f_import_testructura_estado ('insert','vbcbte','validado','CBTE',1,'');
select wf.f_import_testructura_estado ('insert','borrador','validado','CBTE',1,'');


----------------------------------
--COPY LINES TO SUBSYSTEM dependencies.sql FILE
---------------------------------

select wf.f_import_ttipo_documento_estado ('insert','CBTE','CBTE','borrador','CBTE','crear','superior','');
select wf.f_import_ttipo_documento_estado ('insert','CBTE','CBTE','borrador','CBTE','insertar','superior','');
select wf.f_import_ttipo_documento_estado ('insert','CBTE','CBTE','borrador','CBTE','eliminar','superior','');


--estos origenes estan comentados por que necesitan estar previamente registros en WF

/*
select wf.f_import_ttipo_proceso_origen ('insert','CBTE','CBT','SFA','pendiente','manual','');
select wf.f_import_ttipo_proceso_origen ('insert','CBTE','CBT','RFA','pendiente','manual','');
select wf.f_import_ttipo_proceso_origen ('insert','CBTE','CBT','TPLAP','pendiente','manual','');
select wf.f_import_ttipo_proceso_origen ('insert','CBTE','CBT','TPLPP','pendiente','manual','');
select wf.f_import_ttipo_proceso_origen ('insert','CBTE','CBT','PD_ANT_PAR','pendiente','manual','');
select wf.f_import_ttipo_proceso_origen ('insert','CBTE','CBT','PD_AP_ANT','pendiente','manual','');
select wf.f_import_ttipo_proceso_origen ('insert','CBTE','CBT','PUPLAP','pendiente','manual','');
select wf.f_import_ttipo_proceso_origen ('insert','CBTE','CBT','PUPLPP','pendiente','manual','');
select wf.f_import_ttipo_proceso_origen ('insert','CBTE','CBT','PU_ANT_PAR','pendiente','manual','');
select wf.f_import_ttipo_proceso_origen ('insert','CBTE','CBT','PU_ANT_PAR','pendiente','manual','');
select wf.f_import_ttipo_proceso_origen ('insert','CBTE','CBT','PU_AP_ANT','pendiente','manual','');
select wf.f_import_ttipo_proceso_origen ('insert','CBTE','CBT','CBTE','validado','manual','');
select wf.f_import_ttipo_proceso_origen ('insert','CBTE','CBT','REPO','pendiente','manual','');
select wf.f_import_ttipo_proceso_origen ('insert','CBTE','CBT','REN','pendiente','manual','');*/




/**********************************F-DAT-RAC-CONTA-0-29/06/2016*****************************************/




/**********************************I-DAT-RAC-CONTA-1-29/06/2016*****************************************/


select pxp.f_insert_tgui ('Estados Financieros', 'Reportes de Estados Financieros (desde la plantilla de resultados)', 'REPRES', 'si', 2, 'sis_contabilidad/vista/cuenta/FormFiltroResultado.php', 3, '', 'FormFiltroResultado', 'CONTA');

/**********************************F-DAT-RAC-CONTA-1-29/06/2016*****************************************/



/**********************************I-DAT-RAC-CONTA-1-17/11/2016*****************************************/

select pxp.f_insert_tgui ('Entrega C31', 'Entrega C31', 'ENTR', 'si', 4, 'sis_contabilidad/vista/entrega/Entrega.php', 3, '', 'Entrega', 'CONTA');
select pxp.f_insert_testructura_gui ('ENTR', 'CBTE.1');

/**********************************F-DAT-RAC-CONTA-1-17/11/2016*****************************************/


/**********************************I-DAT-RAC-CONTA-1-07/12/2016*****************************************/

select pxp.f_insert_tgui ('Estado de Resultados', 'Estado de Resultados', 'REPESTRE', 'si', 2, 'sis_contabilidad/vista/cuenta/FormFiltroEstadoResultado.php', 3, '', 'FormFiltroEstadoResultado', 'CONTA');
select pxp.f_insert_testructura_gui ('REPESTRE', 'REPCON');
select pxp.f_insert_tgui ('Balance de cuentas', 'Balance general', 'BALCON', 'si', 1, 'sis_contabilidad/vista/cuenta/FormFiltroBalanceCuentas.php', 3, '', 'FormFiltroBalanceCuentas', 'CONTA');

/**********************************F-DAT-RAC-CONTA-1-07/12/2016*****************************************/



/**********************************I-DAT-RAC-CONTA-1-13/12/2016*****************************************/


INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES
  (E'conta_ejecucion_igual_pres_conta', E'si', E'si o no, define si laejecucion presupuestaria sera igual a la contabe, ejemplo el caso de algunas empresas ejecutar el 100 % de las facturas y no solo el 13 %, en ese caso definir como no');


/**********************************F-DAT-RAC-CONTA-1-13/12/2016*****************************************/



/**********************************I-DAT-RAC-CONTA-1-15/05/2017*****************************************/

select pxp.f_insert_tgui ('Parametrización de Ordenes de Trabajo', 'Ordenes de trabajo', 'CROT', 'si', 3, '', 2, '', '', 'CONTA');
select pxp.f_insert_testructura_gui ('CROT', 'CONTA');

select pxp.f_insert_tgui ('Grupos de OTs', 'Grupos de ordenes de trabajo', 'GRUOT', 'si', 0, 'sis_contabilidad/vista/grupo_ot/GrupoOt.php', 2, '', 'GrupoOt', 'CONTA');
select pxp.f_insert_tgui ('Ordenes de Costo', 'Ordenes de Costo', 'ORDARB', 'si', 1, 'sis_contabilidad/vista/orden_trabajo/OrdenTrabajoArb.php', 3, '', 'OrdenTrabajoArb', 'CONTA');
select pxp.f_insert_tgui ('Subordenes', 'Subordenes', 'SUOINT', 'si', 4, 'sis_contabilidad/vista/suborden/Suborden.php', 3, '', 'Suborden', 'CONTA');
select pxp.f_insert_tgui ('OT por Oficina', 'OT por Oficina', 'OFIOT', 'si', 3, 'sis_contabilidad/vista/oficina_ot/OficinaOt.php', 3, '', 'OficinaOt', 'CONTA');

select pxp.f_insert_testructura_gui ('ORDARB', 'CROT');
select pxp.f_insert_testructura_gui ('SUOINT', 'CROT');
select pxp.f_insert_testructura_gui ('ODT', 'CROT');
select pxp.f_insert_testructura_gui ('GRUOT', 'CROT');
select pxp.f_insert_testructura_gui ('OFIOT', 'CROT');



/**********************************F-DAT-RAC-CONTA-1-15/05/2017*****************************************/


/**********************************I-DAT-RAC-CONTA-1-26/05/2017*****************************************/
select pxp.f_insert_tgui ('<i class="fa fa-signal  fa-2x"></i> SISTEMA DE CONTABILIDAD', '', 'CONTA', 'si', 17, '', 1, '', '', 'CONTA');
/**********************************F-DAT-RAC-CONTA-1-26/05/2017*****************************************/

/**********************************I-DAT-RAC-CONTA-1-01/06/2017*****************************************/
select pxp.f_insert_tgui ('Balance de Ordenes de Costos', 'Balance de Ordenes de Costos', 'FBAOR', 'si', 5, 'sis_contabilidad/vista/cuenta/FormFiltroBalanceOrdenes.php', 3, '', 'FormFiltroBalanceOrdenes', 'CONTA');
select pxp.f_insert_testructura_gui ('FBAOR', 'REPCON');
/**********************************F-DAT-RAC-CONTA-1-01/06/2017*****************************************/



/**********************************I-DAT-RAC-CONTA-1-02/06/2017*****************************************/
select pxp.f_insert_tgui ('Registro de Cbte (Auxiliares)', 'Registro de Cbte (Auxiliares)', 'RECBTAX', 'si', 1, 'sis_contabilidad/vista/int_comprobante/IntComprobanteRegAux.php', 3, '', 'IntComprobanteRegAux', 'CONTA');
select pxp.f_insert_testructura_gui ('RECBTAX', 'CBTE.1');
/**********************************F-DAT-RAC-CONTA-1-02/06/2017*****************************************/



/**********************************I-DAT-RAC-CONTA-1-13/06/2017*****************************************/


INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES  (E'conta_val_doc_venta', E'no', E'validar que el cbte cuadre con los documentos de venta');

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES
  (E'conta_val_doc_compra', E'no', E'validar que el cbte cuadre con los documentos de compra');


/* Data for the 'pxp.variable_global' table  (Records 1 - 1) */

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES
  (E'conta_dif_doc_cbte', E'0.6', E'la difenrecia permitida al validar cbtes y documentos  facturas, invoice etc');

/**********************************F-DAT-RAC-CONTA-1-13/06/2017*****************************************/




/**********************************I-DAT-RAC-CONTA-1-19/06/2017*****************************************/


/* Data for the 'pxp.variable_global' table  (Records 1 - 1) */

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES
  (E'conta_val_doc_otros_subcuentas_compras', E'INVERSION,ACTIVO FIJO,ALMACENES,OTROS ACTIVOS', E'Nombre de subcuenta que tienen que incluirse en la validacion de documentos de compras,al vaidar cbte, se las separa por comas');

/**********************************F-DAT-RAC-CONTA-1-19/06/2017*****************************************/
 /**********************************I-DAT-MMV-CONTA-1-28/06/2017*****************************************/
 select pxp.f_insert_tgui ('Resolución 101700000010', 'Resolución 101700000010', 'RESO', 'si', 11, '', 3, '', '', 'CONTA');
 select pxp.f_insert_tgui ('Comisionistas', 'Comisionistas', 'COMISI', 'si', 1, 'sis_contabilidad/vista/comisionistas/Comisionistas.php', 4, '', 'Comisionistas', 'CONTA');
 select pxp.f_insert_tgui ('Régimen Simplificado', 'RÃ©gimen Simplificado', 'SIMPLI', 'si', 2, 'sis_contabilidad/vista/regimen_simplificado/RegimenSimplificado.php', 4, '', 'RegimenSimplificado', 'CONTA');
 select pxp.f_insert_tgui ('Personas Naturales', 'Personas Naturales', 'PERNAT', 'si', 3, 'sis_contabilidad/vista/persona_naturales/PersonaNaturales.php', 4, '', 'PersonaNaturales', 'CONTA');
 select pxp.f_insert_tgui ('Anexos Actualizaciones', 'Anexos Actualizaciones', 'ANS', 'si', 4, 'sis_contabilidad/vista/anexos_actualizaciones/AnexosActualizaciones.php', 4, '', 'AnexosActualizaciones', 'CONTA');
 select pxp.f_insert_tgui ('Periodo Resolución ', 'Periodo Resolución ', 'PRC', 'si', 9, 'sis_contabilidad/vista/periodo_resolucion/DeptoConta.php', 3, '', 'DeptoConta', 'CONTA');
 select pxp.f_insert_testructura_gui ('RESO', 'CONTA');
 select pxp.f_insert_testructura_gui ('COMISI', 'RESO');
 select pxp.f_insert_testructura_gui ('SIMPLI', 'RESO');
 select pxp.f_insert_testructura_gui ('PERNAT', 'RESO');
 select pxp.f_insert_testructura_gui ('ANS', 'RESO');
 select pxp.f_insert_testructura_gui ('PRC', 'CONF');
 /**********************************F-DAT-MMV-CONTA-1-28/06/2017*****************************************/



/**********************************I-DAT-RAC-CONTA-1-29/06/2017*****************************************/
select pxp.f_insert_tgui ('Análisis de Costos', 'Análisis de Costos', 'ANCOS', 'si', 20, 'sis_contabilidad/vista/rango/TipoCcArbRep.php', 3, '', 'TipoCcArbRep', 'CONTA');
select pxp.f_insert_testructura_gui ('ANCOS', 'REPCON');
/**********************************F-DAT-RAC-CONTA-1-29/06/2017*****************************************/




/***********************************I-DAT-RAC-CONTA-0-03/07/2017*****************************************/

select pxp.f_insert_tgui ('Balance por Tipos de Centros ', 'Balance por Tipos de Centros ', 'BATCC', 'si', 12, 'sis_contabilidad/vista/cuenta/FormFiltroBalanceTipoCC.php', 3, '', 'FormFiltroBalanceTipoCC', 'CONTA');
select pxp.f_insert_testructura_gui ('BATCC', 'REPCON');

/***********************************F-DAT-RAC-CONTA-0-03/07/2017*****************************************/


/***********************************I-DAT-RAC-CONTA-0-20/07/2017*****************************************/
/* Data for the 'conta.ttipo_relacion_contable' table  (Records 1 - 4) */

INSERT INTO conta.ttipo_relacion_contable ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "nombre_tipo_relacion", "codigo_tipo_relacion", "tiene_centro_costo", "tiene_partida", "tiene_auxiliar", "partida_tipo", "partida_rubro", "id_tabla_relacion_contable")
VALUES
  (1, NULL, E'2017-07-20 15:14:51.622', NULL, E'activo', NULL, NULL, E'Ajuste AITB al debe', E'AJT_AITB_DEBE', E'no', E'si', E'no', E'flujo_presupuestaria', E'recurso_gasto', NULL),
  (1, NULL, E'2017-07-20 15:15:23.220', NULL, E'activo', NULL, NULL, E'Ajuste AITB  al haber', E'AJT_AITB_HABER', E'no', E'si', E'no', E'flujo_presupuestaria', E'recurso_gasto', NULL),
  (1, NULL, E'2017-07-20 15:32:34.246', NULL, E'activo', NULL, NULL, E'Gasto por AITB', E'GASTO_AITB', E'no', E'si', E'no', E'flujo', E'gasto', NULL),
  (1, NULL, E'2017-07-20 15:33:03.064', NULL, E'activo', NULL, NULL, E'Recurso AITB', E'RECURSO_AITB', E'no', E'si', E'no', E'flujo', E'recurso', NULL);

/***********************************F-DAT-RAC-CONTA-0-20/07/2017*****************************************/


/***********************************I-DAT-RAC-CONTA-0-01/08/2017*****************************************/

select pxp.f_insert_tgui ('Tipo de Estado de Cuentas', 'Configuración de tipos de estados de cuentas', 'CFTEC', 'si', 21, 'sis_contabilidad/vista/tipo_estado_cuenta/TipoEstadoCuenta.php', 3, '', 'TipoEstadoCuenta', 'CONTA');
select pxp.f_insert_testructura_gui ('CFTEC', 'CONF');
select pxp.f_insert_tgui ('Estado de Cuentas', 'Estado de Cuentas', 'ESTCUNT', 'si', 20, 'sis_contabilidad/vista/tipo_estado_cuenta/FormFiltroEstadoCuenta.php', 3, '', 'FormFiltroEstadoCuenta', 'CONTA');
select pxp.f_insert_testructura_gui ('ESTCUNT', 'REPCON');


INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES
  (E'conta_lista_blanca_cbte_docs', E'RENDICIONFONDO,RENCAJA', E'Lista de codigos de plnatillas de cbte, que se saltara la validacion de documentos de compra /venta');


/***********************************F-DAT-RAC-CONTA-0-01/08/2017*****************************************/




/***********************************I-DAT-RAC-CONTA-0-29/08/2017*****************************************/

/* Data for the 'pxp.variable_global' table  (Records 1 - 1) */

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES
  (E'conta_ajustar_tipo_cambio_cbte_rel', E'no', E'ajustar automaticamente diferencia por tipo de cambio en trasaccion y comprobantes reacionados');


/***********************************F-DAT-RAC-CONTA-0-29/08/2017*****************************************/


/***********************************I-DAT-RAC-CONTA-0-08/09/2017*****************************************/

select pxp.f_insert_tgui ('Cuentas por Tipo de Centro', 'Cuentas por Tipo de Centro', 'TCCUAX', 'si', 5, 'sis_contabilidad/vista/tipo_cc_cuenta/TipoCcConf.php', 3, '', 'TipoCcConf', 'CONTA');
select pxp.f_insert_testructura_gui ('TCCUAX', 'CNOM');

/* Data for the 'pxp.variable_global' table  (Records 1 - 1) */

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES (E'conta_filtrar_cuenta_por_tipo_cc_interface_junior', E'no', E'esta variable habilita el filtro de cuentas y auxiliares segun el tipo de centor de consto en la inteface de cntadores junior');

/***********************************F-DAT-RAC-CONTA-0-08/09/2017*****************************************/

/***********************************I-DAT-MANU-CONTA-0-25/09/2017*****************************************/
select pxp.f_insert_tgui ('Reporte Retencion', 'Reporte Retencion', 'REPRET', 'si', 13, 'sis_contabilidad/reportes/formularios/LibroComprasVentasRetenciones.php', 3, '', 'ReporteRetenciones', 'CONTA');
/***********************************F-DAT-MANU-CONTA-0-25/09/2017*****************************************/



/***********************************I-DAT-RAC-CONTA-0-22/12/2017*****************************************/

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES
  (E'conta_libro_ventas_detallado', E'si', E'Si la interface de libro de ventas permite el registro del detalle de la factura');

  /* Data for the 'pxp.variable_global' table  (Records 1 - 1) */

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES
  (E'conta_forzar_validacion_documentos', E'si', E'cuando se fuera la validacion no permite validar el cbte si los datos o cudran, en caso contrario deja al usuario decidir');


INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES
  (E'conta_revertir_iva_comprometido', E'no', E'Por dfecto no revierte el iva comprometido, asumiendo que la solictud fue hecha sobre el valor NETO');

/***********************************F-DAT-RAC-CONTA-0-22/12/2017*****************************************/

/***********************************I-DAT-JUAN-CONTA-0-03/04/2017*****************************************/
select pxp.f_insert_tgui ('Diferencias en libros contables', 'Diferencias en libros contables', 'COLM', 'si', 12, 'sis_contabilidad/reportes/formularios/Dif_libro_contables.php', 3, '', 'Dif_libro_contables', 'CONTA');

select pxp.f_insert_testructura_gui ('COLM', 'REPCON');

/***********************************F-DAT-JUAN-CONTA-0-03/04/2017*****************************************/



/***********************************I-DAT-RAC-CONTA-0-08/05/2018*****************************************/

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES
  (E'conta_solictar_codigo_aplicacion_doc', E'no', E'Para odcumentos de venta al generar comprobante solo considerar los documneots con codigo de aplicacion');

  ----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
---------------------------------

select param.f_import_tcatalogo_tipo ('insert','tipo_venta','CONTA','tdoc_compra_venta');
select param.f_import_tcatalogo ('insert','CONTA','Peaje','peaje','tipo_venta');
select param.f_import_tcatalogo ('insert','CONTA','Pliegos','pliegos','tipo_venta');
select param.f_import_tcatalogo ('insert','CONTA','Peaje Empresas del Grupo','peaje_grupo','tipo_venta');
select param.f_import_tcatalogo ('insert','CONTA','Servicios a Terceros','terceros','tipo_venta');
select param.f_import_tcatalogo ('insert','CONTA','Servicios Empresas del Grupo','servicos_grupo','tipo_venta');


/***********************************F-DAT-RAC-CONTA-0-08/05/2018*****************************************/




/***********************************I-DAT-RAC-CONTA-0-29/05/2018*****************************************/


select pxp.f_insert_tgui ('Estado de Auxiliares', 'Estado de Auxiliares', 'EXUMAY', 'si', 10, 'sis_contabilidad/vista/int_transaccion/FormFiltroAuxiliarMayor.php', 3, '', 'FormFiltroAuxiliarMayor', 'CONTA');
select pxp.f_insert_testructura_gui ('EXUMAY', 'REPCON');



select conta.f_import_tplantilla ('insert','Venta con Debito Fiscal (Regularizado no entra a libros LCV)','si','si','5','1','no','no','si','si','venta','no','no','variable','0','regularizacion');


select pxp.f_insert_tgui ('Regularización', 'Regularización', 'REGUCON', 'si', 1, '', 2, '', '', 'CONTA');
select pxp.f_insert_tgui ('Registro de facturas Regularización', 'Registro de facturas regularización', 'REFAREG', 'si', 1, 'sis_contabilidad/vista/doc_compra_venta/DocVentaRegul.php', 3, '', 'DocVentaRegul', 'CONTA');
select pxp.f_insert_testructura_gui ('REGUCON', 'CONTA');
select pxp.f_insert_testructura_gui ('REFAREG', 'REGUCON');


/***********************************F-DAT-RAC-CONTA-0-29/05/2018*****************************************/

/***********************************I-DAT-EGS-CONTA-0-27/09/2018*****************************************/

select conta.f_import_tplantilla_comprobante ('insert','CBRRG','cbr.f_gestionar_cbte_cobro_simple_eliminacion','id_cobro_simple','CBR','{$tabla.obs}','cbr.f_gestionar_cbte_cobro_simple','{$tabla.fecha}','activo','{$tabla.desc_proveedor}','{$tabla.id_depto_conta}','contable','','cbr.vcobro_simple_cbte','INGRESOCON','{$tabla.id_moneda}','{$tabla.id_gestion}','{$tabla.id_moneda},{$tabla.id_gestion},{$tabla.id_depto_conta},{$tabla.id_cobro_simple},{$tabla.id_cuenta_bancaria},{$tabla.id_funcionario},{$tabla.id_proveedor},{$tabla.importe},{$tabla.importe_mb},{$tabla.id_proveedor},{$tabla.importe_mt},{$tabla.tipo_cambio},{$tabla.tipo_cambio_ma},{$tabla.tipo_cambio_mt},{$tabla.id_config_cambiaria}','no','no','no','{$tabla.id_cuenta_bancaria}','','0','0','{$tabla.nro_tramite}','{$tabla.tipo_cambio}','{$tabla.id_depto_lb}','','','','Cobro de clientes Retencion Garantias','','','{$tabla.tipo_cambio_mt}','{$tabla.tipo_cambio_ma}','{$tabla.id_config_cambiaria}');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','CBRRG','INGREBAN','debe','si','si','','{$tabla_padre.desc_proveedor}','CUEBANCING','','{$tabla_padre.importe}','{$tabla_padre.id_cuenta_bancaria}','','no','','','','si','','','','Ingreso de Bancos','{$tabla_padre.importe}',NULL,'simple','','','no','','{$tabla_padre.id_cuenta_bancaria}','','0','0','','{$tabla_padre.desc_proveedor}','2','','',NULL,'deposito','','','');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','CBRRG','CUXCORGH','haber','si','si','','{$tabla.desc_dcv}','CUXCRRGH','','{$tabla.importe}','{$tabla_padre.id_proveedor}','','no','','','','si','','id_cobro_simple','','Cuentas por cobrar clientes Retencion Garantias','{$tabla.importe}',NULL,'simple','','{$tabla.id_cobro_simple_det}','no','','','','','','','','2','','cbr.vcobro_simple_det',NULL,'','','','');



/***********************************F-DAT-EGS-CONTA-0-27/09/2018*****************************************/


/***********************************I-DAT-RAC-CONTA-0-06/11/2018*****************************************/


INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES
  (E'conta_cod_plan_nota_credito', E'NOTACREDITODOC', NULL);


INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES
  (E'conta_cod_plan_nota_debito', E'NOTADEBITODOC', NULL);



INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES
  (E'conta_migrar_rc_concepto_version', E'no', E'al apretar el boton para migrar relacion contable de una gestion a otra, si esta habilita insertara la nuevas relacion en funcion a la tabla conceptos_ids\r\n');




/***********************************F-DAT-RAC-CONTA-0-06/11/2018*****************************************/

/***********************************I-DAT-EGS-CONTA-1-30/11/2018*****************************************/


select param.f_import_tcatalogo_tipo ('insert','tauxiliar','CONTA','tauxiliar');
select param.f_import_tcatalogo ('insert','CONTA','Nacional','nacional','tauxiliar');
select param.f_import_tcatalogo ('insert','CONTA','Interno','interno','tauxiliar');
select param.f_import_tcatalogo ('insert','CONTA','Internacional','internacional','tauxiliar');

select param.f_import_tcatalogo_tipo ('insert','finalidad_nota_debito_sobre_compra','CONTA','tdoc_compra_venta');
select param.f_import_tcatalogo ('insert','CONTA','Cobro Clientes por Peaje','cbr_peaje','finalidad_nota_debito_sobre_compra');



select param.f_import_tcatalogo_tipo ('insert','tipo_venta_nota_debito','CONTA','tdoc_compra_venta');
select param.f_import_tcatalogo ('insert','CONTA','PLIEGOS CLIENTES DEL EXTRANJERO','pliegos','tipo_venta_nota_debito');
select param.f_import_tcatalogo ('insert','CONTA','CLIENTES POR PEAJE E INGRESOS TARIFARIO','peaje','tipo_venta_nota_debito');
select param.f_import_tcatalogo ('insert','CONTA','PEAJES EMPRESAS DEL GRUPO','peaje_grupo','tipo_venta_nota_debito');
select param.f_import_tcatalogo ('insert','CONTA','SERVICIOS TERCEROS Y PLIEGOS A PROVEEDORES NACIONALES','terceros','tipo_venta_nota_debito');
select param.f_import_tcatalogo ('insert','CONTA','SERVICIOS A EMPRESAS DEL GRUPO','servicos_grupo','tipo_venta_nota_debito');
select param.f_import_tcatalogo ('insert','CONTA','VENTA ACTIVOS FIJOS','activo_fijo','tipo_venta_nota_debito');
select param.f_import_tcatalogo ('insert','CONTA','VENTA DE SUMINISTROS A PROVEEDORES','suministros','tipo_venta_nota_debito');
select param.f_import_tcatalogo ('insert','CONTA','MULTAS A PROVEEDORES','multas','tipo_venta_nota_debito');
select param.f_import_tcatalogo ('insert','CONTA','Alquiler de Parqueo al Personal','parqueo','tipo_venta_nota_debito');
select param.f_import_tcatalogo ('insert','CONTA','Intereses por prestamos al personal','intereses','tipo_venta_nota_debito');
select param.f_import_tcatalogo ('insert','CONTA','Cobro Clientes por Peaje','cbr_peaje','tipo_venta_nota_debito');

/***********************************F-DAT-EGS-CONTA-1-30/11/2018*****************************************/

/***********************************I-DAT-MMV-CONTA-92-19/12/2018*****************************************/
select pxp.f_insert_tgui ('Movimiento de Auxiliares', 'Movimiento de Auxiliares', 'MOVSAL', 'si', 12, '', 2, '', '', 'CONTA');
select pxp.f_insert_testructura_gui ('MOVSAL', 'CONTA');
select pxp.f_insert_tgui ('Auxiliares Detalle ', 'Auxiliares Detalle ', 'LMT', 'si', 2, 'sis_contabilidad/vista/int_transaccion/FormFiltroMayorNroTramite.php', 3, '', 'FormFiltroMayorNroTramite', 'CONTA');
select pxp.f_insert_testructura_gui ('LMT', 'MOVSAL');
/***********************************F-DAT-MMV-CONTA-92-19/12/2018*****************************************/

/***********************************I-DAT-MMV-CONTA-2-19/12/2018*****************************************/
select pxp.f_insert_tgui ('Reporte Proyectos', 'Reporte Proyectos', 'RRP', 'si', 11, 'sis_contabilidad/vista/reporte_proyectos/ReporteProyectos.php', 3, '', 'ReporteProyectos', 'CONTA');
select pxp.f_insert_testructura_gui ('RRP', 'REPCON');
/***********************************F-DAT-MMV-CONTA-2-19/12/2018*****************************************/

/***********************************I-DAT-MMV-CONTA-4-20/12/2018*****************************************/
select conta.f_import_tresultado_plantilla ('insert','C-IN','activo','Asiento de cierre de las cuentas de ingreso','cbte','no','no','resultado','rango','Asiento de cierre de las cuentas de ingreso','PAGOCON','C-IN','C-IN','conta.f_plantilla_cierre_ingreso');
select conta.f_import_tresultado_plantilla ('insert','C-GAS','activo','Asiento de cierre de las cuentas de Gasto','cbte','no','no','resultado','rango','Asiento de cierre de las cuentas de Gasto','PAGOCON','C-GAS','C-GAS','conta.f_plantilla_cierre_gasto');
select conta.f_import_tresultado_plantilla ('insert','C-UTI','activo','Asiento de Cierre de la Cuenta Utilidad de Gestión','cbte','no','no','resultado','rango','Cierre de cuenta utilidad por Gestion ','PAGOCON','C-UTI','C-UTI','conta.f_plantilla_cierre_utilidad');
select conta.f_import_tresultado_plantilla ('insert','C-CBL','activo','Asiento de Cierre de las Cuentas de Balance','cbte','no','no','balance','rango','Asiento de Cierre de las Cuentas de Balance','DIARIOCON','C-CBL','C-CBL','conta.f_plantilla_cierre_balance');
/***********************************F-DAT-MMV-CONTA-4-20/12/2018*****************************************/
/***********************************I-DAT-MMV-CONTA-23-27/12/2018*****************************************/
select pxp.f_insert_tgui ('Detalle Auxiliares por Cuenta', 'Detalle Auxiliares por Cuenta', 'RDA', 'si', 30, 'sis_contabilidad/vista/reporte_detalle_auxiliar/ReporteDetalleAuxiliar.php', 3, '', 'ReporteDetalleAuxiliar', 'CONTA');
select pxp.f_insert_testructura_gui ('RDA', 'REPCON');
/***********************************F-DAT-MMV-CONTA-23-27/12/2018*****************************************/

/***********************************I-DAT-EGS-CONTA-3-09/01/2019*****************************************/

/*catalogos*/
select param.f_import_tcatalogo_tipo ('insert','finalidad_nota_debito_sobre_compra','CONTA','tdoc_compra_venta');
select param.f_import_tcatalogo ('insert','CONTA','Cobro Clientes por Peaje','cbr_peaje','finalidad_nota_debito_sobre_compra');

select param.f_import_tcatalogo_tipo ('insert','tipo_venta_nota_debito','CONTA','tdoc_compra_venta');
select param.f_import_tcatalogo ('insert','CONTA','PLIEGOS CLIENTES DEL EXTRANJERO','pliegos','tipo_venta_nota_debito');
select param.f_import_tcatalogo ('insert','CONTA','CLIENTES POR PEAJE E INGRESOS TARIFARIO','peaje','tipo_venta_nota_debito');
select param.f_import_tcatalogo ('insert','CONTA','PEAJES EMPRESAS DEL GRUPO','peaje_grupo','tipo_venta_nota_debito');
select param.f_import_tcatalogo ('insert','CONTA','SERVICIOS TERCEROS Y PLIEGOS A PROVEEDORES NACIONALES','terceros','tipo_venta_nota_debito');
select param.f_import_tcatalogo ('insert','CONTA','SERVICIOS A EMPRESAS DEL GRUPO','servicos_grupo','tipo_venta_nota_debito');
select param.f_import_tcatalogo ('insert','CONTA','VENTA ACTIVOS FIJOS','activo_fijo','tipo_venta_nota_debito');
select param.f_import_tcatalogo ('insert','CONTA','VENTA DE SUMINISTROS A PROVEEDORES','suministros','tipo_venta_nota_debito');
select param.f_import_tcatalogo ('insert','CONTA','MULTAS A PROVEEDORES','multas','tipo_venta_nota_debito');
select param.f_import_tcatalogo ('insert','CONTA','Alquiler de Parqueo al Personal','parqueo','tipo_venta_nota_debito');
select param.f_import_tcatalogo ('insert','CONTA','Intereses por prestamos al personal','intereses','tipo_venta_nota_debito');
select param.f_import_tcatalogo ('insert','CONTA','Cobro Clientes por Peaje','cbr_peaje','tipo_venta_nota_debito');


select param.f_import_tcatalogo_tipo ('insert','tipo_credito_sobre_venta','CONTA','tdoc_compra_venta');
select param.f_import_tcatalogo ('insert','CONTA','Devolución Peaje Empresas de Grupo','dev_peaje_grupo','tipo_credito_sobre_venta');
select param.f_import_tcatalogo ('insert','CONTA','Devolución Peaje  Otros','dev_peaje_otros','tipo_credito_sobre_venta');

/*insercion de relaciones contables*/
select conta.f_import_ttipo_relacion_contable ('insert','DEVVENTA','TCON','Devoluciones sobre Ventas','activo','si-general','si','no','flujo_presupuestaria','recurso_gasto','no','no','si','');
select conta.f_import_ttipo_relacion_contable ('insert','DEVCOMPRA','TCON','Devoluciones sobre compras','activo','si-general','si','no','flujo_presupuestaria','recurso_gasto','no','no','si','');

select conta.f_import_ttipo_relacion_contable ('insert','CUXCOBRARNOTAS','TPRO','Cuenta por Cobrar Notas de debito por ventas','activo','si-general','si','dinamico','flujo','recurso_gasto','no','no','no','');
select conta.f_import_ttipo_relacion_contable ('insert','CUXPAGARNOTAS','TPRO','Cuenta por pagar notas de credito por ventas','activo','si-general','si','dinamico','flujo','recurso_gasto','si','no','no','');
select conta.f_import_ttipo_relacion_contable ('insert','CXPDEV','TPRO','Cuenta por Pagar Devoluciones','activo','no','si','dinamico','flujo_presupuestaria','recurso_gasto','si','no','no','tipo_credito_sobre_venta');
select conta.f_import_ttipo_relacion_contable ('insert','CXCDFPRO','TPRO','CUENTAS POR COBRAR CLIENTES','activo','no','si','dinamico','flujo_presupuestaria','recurso_gasto','si','no','no','tipo_venta_nota_debito');


/*# 43 insercion de plantillas de comprobante*/
select conta.f_import_tplantilla_comprobante ('insert','NOTACREDITODOC','conta.f_ges_cbte_eliminacion_doc_compra_venta','id_agrupador','CONTA','Notas Credito','','{$tabla.fecha_cbte}','activo','','{$tabla.id_depto_conta}','contable','','conta.vagrupador','DIARIO','{$tabla.id_moneda}','{$tabla.id_gestion}','{$tabla.id_moneda},{$tabla.id_gestion},{$tabla.id_depto_conta},{id_agrupador}','no','no','no','','','','','','','','','','','Notas de Credito de Facturas sobre Ventas','','','','','');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','NOTACREDITODOC','NOTACREDITO.1','debe','si','si','','{$tabla.descripcion}','DEVVENTA','','{$tabla.precio_total_final}','{$tabla.id_concepto_ingas}','{$tabla.id_plantilla}','si','{$tabla.id_centro_costo}','','','si','','id_agrupador','','Concepto de Gasto','{$tabla.precio_total_final}',NULL,'simple','','{$tabla.id_doc_concepto}','no','','','','','','{$tabla.importe_total_excento}','','2','{$tabla.id_orden_trabajo}','conta.vdoc_compra_venta_det',NULL,'','','','','todos','','si');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','NOTACREDITODOC','NOTACREDITO.3','haber','no','si','','','CMRETGARDF','','{$tabla.importe_retgar}','','','no','','{$tabla.id_auxiliar}','','si','','id_agrupador','','retencion de garantia','{$tabla.importe_retgar}',NULL,'simple','','{$tabla.id_doc_compra_venta}','no','','','','','','','','2','','conta.vdoc_compra_venta',NULL,'','','','','todos','','si');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','NOTACREDITODOC','NOTACREDITO.5','haber','no','si','','','CXPDEV','','{$tabla.importe_pendiente}','{$tabla.id_proveedor}','','no','','{$tabla.id_auxiliar}','','si','','id_agrupador','','cuentas por pagar','{$tabla.importe_pendiente}',NULL,'simple','','{$tabla.id_doc_compra_venta}','no','','','','','','','','2','','conta.vdoc_compra_venta_proveedor',NULL,'','','','','todos','{$tabla.codigo_aplicacion}','si');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','NOTACREDITODOC','NOTACREDITO.4','haber','no','si','','','CMRETANTD','','{$tabla.importe_anticipo}','','','no','','{$tabla.id_auxiliar}','','si','','id_agrupador','','retención de anticipos','{$tabla.importe_anticipo}',NULL,'simple','','{$tabla.id_doc_compra_venta}','no','','','','','','','','2','','conta.vdoc_compra_venta',NULL,'','','','','todos','','si');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','NOTACREDITODOC','NOTACREDITO.2','haber','no','si','','','CMPDEF','','{$tabla.importe_pago_liquido}','','','no','','','','si','','id_agrupador','','cuenta para bancos','{$tabla.importe_pago_liquido}',NULL,'simple','','{$tabla.id_doc_compra_venta}','no','','','','','','','','2','','conta.vdoc_compra_venta',NULL,'','','','','todos','','si');

select conta.f_import_tplantilla_comprobante ('insert','NOTADEBITODOC','conta.f_ges_cbte_eliminacion_doc_compra_venta','id_agrupador','CONTA','Notas Debito','','{$tabla.fecha_cbte}','activo','','{$tabla.id_depto_conta}','presupuestario','','conta.vagrupador','DIARIO','{$tabla.id_moneda}','{$tabla.id_gestion}','{$tabla.id_moneda},{$tabla.id_gestion},{$tabla.id_depto_conta},{id_agrupador}','si','si','no','','','','','','','','','','','Notas de Debito de Facturas sobre Compras','','','','','');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','NOTADEBITODOC','NOTADEBITO.4','debe','no','si','','','VRETANTDPRO','','{$tabla.importe_anticipo}','{$tabla.id_proveedor}','','no','','{$tabla.id_auxiliar}','','si','','id_agrupador','','descuento de anticipo pagados por adelantado','{$tabla.importe_anticipo}',NULL,'simple','','{$tabla.id_doc_compra_venta}','no','','','','','','','','2','','conta.vdoc_compra_venta_proveedor',NULL,'','','','','todos','','si');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','NOTADEBITODOC','NOTADEBITO.3','debe','si','si','','','VRETGARDFPRO','','{$tabla.importe_retgar}','{$tabla.id_proveedor}','','no','','{$tabla.id_auxiliar}','','si','','id_agrupador','','Retencion de garantías por cobrar','{$tabla.importe_retgar}',NULL,'simple','','{$tabla.id_doc_compra_venta}','no','','','','','','','','2','','conta.vdoc_compra_venta_proveedor',NULL,'','','','','todos','','si');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','NOTADEBITODOC','NOTADEBITO.5','debe','no','si','','','CXCDFPRO','','{$tabla.importe_pendiente}','{$tabla.id_proveedor}','','no','','{$tabla.id_auxiliar}','','si','','id_agrupador','','cuentas por cobrar','{$tabla.importe_pendiente}',NULL,'simple','','{$tabla.id_doc_compra_venta}','no','','','','','','','','2','','conta.vdoc_compra_venta_proveedor',NULL,'','','','','todos','{$tabla.codigo_aplicacion}','si');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','NOTADEBITODOC','NOTADEBITO.1','haber','si','si','','{$tabla.descripcion}','DEVCOMPRA','','{$tabla.precio_total_final}','{$tabla.id_concepto_ingas}','{$tabla.id_plantilla}','si','{$tabla.id_centro_costo}','','','si','','id_agrupador','','Venta concepto de gasto','{$tabla.precio_total_final}',NULL,'simple','','{$tabla.id_doc_concepto}','no','','','','','','{$tabla.importe_total_excento}','','2','{$tabla.id_orden_trabajo}','conta.vdoc_compra_venta_det',NULL,'','','','','todos','','si');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','NOTADEBITODOC','NOTADEBITO.2','debe','si','si','','','VENDEF','','{$tabla.importe_pago_liquido}','','','no','','','','si','','id_agrupador','','ingreso a bancos','{$tabla.importe_pago_liquido}',NULL,'simple','','{$tabla.id_doc_compra_venta}','no','','','','','','','','2','','conta.vdoc_compra_venta',NULL,'','','','','todos','','si');

/*insercion de plantillas de documento*/
select conta.f_import_tplantilla ('insert','Notas de Debito Fiscal Sobre Compras','si','si','6','4','no','no','si','si','venta','no','no','variable','0','ncd');
select conta.f_import_tplantilla_calculo ('insert','Notas de Debito Fiscal Sobre Compras','ingreso por devolucion','1','haber','porcentaje','','0.87','0.87','no');
select conta.f_import_tplantilla_calculo ('insert','Notas de Debito Fiscal Sobre Compras','IVA-DF','2','haber','porcentaje','IVA-DF','0.13','0.13','no');
select conta.f_import_tplantilla_calculo ('insert','Notas de Debito Fiscal Sobre Compras','cuentas por cobrar','3','debe','porcentaje','CUXCOBRARNOTAS','1','1','no');

select conta.f_import_tplantilla ('insert','Notas de Crédito Fiscal Sobre Ventas','si','si','6','4','no','no','si','si','compra','no','no','variable','0','ncd');
select conta.f_import_tplantilla_calculo ('insert','Notas de Crédito Fiscal Sobre Ventas','IVA-CF','2','debe','porcentaje','IVA-CF','0.13','0.13','no');
select conta.f_import_tplantilla_calculo ('insert','Notas de Crédito Fiscal Sobre Ventas','Cuentas por pagar','3','haber','porcentaje','CUXPAGARNOTAS','1','1','no');
select conta.f_import_tplantilla_calculo ('insert','Notas de Crédito Fiscal Sobre Ventas','Perdida por devolución','1','debe','porcentaje','','0.87','0.87','no');

/***********************************F-DAT-EGS-CONTA-3-09/01/2019*****************************************/
/***********************************I-SCP-MMV-CONTA-19-09/01/2019****************************************/
select conta.f_import_tresultado_plantilla ('insert','ACT-ING','activo','Actualizaciones Ingresos','cbte','si','no','no','rango','ACTUALIZACIÓN  DE INGRESOS','DIARIOCON','no','ACT-ING','conta.f_plantilla_actualizacion_ingresos');
/***********************************F-SCP-MMV-CONTA-19-09/01/2019****************************************/
/***********************************I-DAT-MMV-CONTA-28-28/01/2019****************************************/
select pxp.f_insert_tgui ('Cuadro de Actualizaciones', 'Cuadro de Actualizaciones', 'RCA', 'si', 22, 'sis_contabilidad/vista/cuadro_actualizacion/CuadroActualizacion.php', 3, '', 'CuadroActualizacion', 'CONTA');
select pxp.f_insert_testructura_gui ('RCA', 'REPCON');
/***********************************F-DAT-MMV-CONTA-28-28/01/2019****************************************/

/***********************************I-DAT-MMV-CONTA-32-08/02/2019****************************************/
select conta.f_import_tresultado_plantilla ('insert','AJUS-MT','activo','Asiento Ajuste moneda MT','cbte','no','no','no','rango','Asiento Ajusto moneda MT','DIARIOCON','no','AJUS-MT','conta.f_plantilla_ajuste_moneda_mt');
select conta.f_import_tresultado_plantilla ('insert','AJUS-MA','activo','Asiento Ajuste Moneda MA','cbte','si','no','no','rango','Ajuste moneda MA','DIARIOCON','no','AJUS-MA','conta.f_plantilla_ajuste_moneda_ma');
select conta.f_import_tresultado_plantilla ('insert','APE-CU','activo','Asiento Apertura','cbte','no','si','no','rango','Asiento de Apertura Cuentas','DIARIOCON','no','APE-CU','conta.f_plantilla_apertura_cuenta');
select conta.f_import_tresultado_plantilla ('insert','C-CBL','activo','Asiento Cuentas de Balance','cbte','no','no','balance','rango','Asiento de Cierre de las Cuentas de Balance','DIARIOCON','C-CBL','C-CBL','conta.f_plantilla_cierre_balance');
select conta.f_import_tresultado_plantilla ('insert','C-UTI','activo','Asiento de Utilidad de Gestión','cbte','no','no','resultado','rango','Cierre de cuenta utilidad por Gestion ','DIARIOCON','C-UTI','C-UTI','conta.f_plantilla_cierre_utilidad');
select conta.f_import_tresultado_plantilla ('insert','C-GAS','activo','Cierre de las cuentas de Gasto','cbte','no','no','resultado','rango','Asiento de cierre de las cuentas de Gasto','DIARIOCON','C-GAS','C-GAS','conta.f_plantilla_cierre_gasto');
select conta.f_import_tresultado_plantilla ('insert','C-IN','activo','Cerrar de cuentas de Ingreso','cbte','no','no','resultado','rango','Asiento de cierre de las cuentas de ingreso','DIARIOCON','C-IN','C-IN','conta.f_plantilla_cierre_ingreso');
/***********************************F-DAT-MMV-CONTA-32-08/02/2019****************************************/

/***********************************I-DAT-EGS-CONTA-4-28/03/2019****************************************/
-----actualizacion comprobantes DEVTESPROV,PAGTESPROV---

select conta.f_import_tplantilla_comprobante ('insert','DEVTESPROV','tes.f_gestionar_cuota_plan_pago_eliminacion','id_plan_pago','TES','{$tabla.obs_pp}','tes.f_gestionar_cuota_plan_pago','{$tabla.fecha_tentativa}','activo','{$tabla.desc_proveedor}','{$tabla.id_depto_conta}','presupuestario','','tes.vcomp_devtesprov_plan_pago','DIARIO','{$tabla.id_moneda}','{$tabla.id_gestion_cuentas}','{$tabla.id_plantilla},{$tabla.id_proveedor},{$tabla.monto},{$tabla.monto_retgar_mo},{$tabla.otros_descuentos},{$tabla.otros_descuentos},{$tabla.porc_monto_excento_var},{$tabla.liquido_pagable},{$tabla.descuento_anticipo},{$tabla.descuento_inter_serv},{$tabla.monto_anticipo},{$tabla.descuento_ley}','no','si','no','','','','','{$tabla.num_tramite}','','{$tabla.id_depto_libro}','{$tabla.fecha_costo_ini}','{$tabla.fecha_costo_fin}','','Devengado desde Obligaciones de Pago','','','','','');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','DEVTESPROV','DEVTESPROV2','debe','si','si','','{$tabla.descripcion}','PAGOANT','','{$tabla_padre.monto_anticipo}','{$tabla_padre.id_proveedor}','{$tabla_padre.id_plantilla}','si','{$tabla.id_centro_costo}','','','si','','','','Anticipo proveedores','{$tabla_padre.monto_anticipo}',NULL,'simple','','','no','','','','','','{$tabla_padre.porc_monto_excento_var}','','2','','',NULL,'','','','','todos','','si');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','DEVTESPROV','DEVTESPROV1','haber','si','si','','','CUENDEVPRO','','{$tabla_padre.descuento_anticipo}','{$tabla_padre.id_proveedor}','','no','','','','si','','','','Suma el descuento de anticipo a proveedor por pagar','{$tabla_padre.descuento_anticipo}',NULL,'simple','','','no','','','','','','','','2','','',NULL,'','','','','todos','','si');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','DEVTESPROV','x3','debe','si','si','','{$tabla.descripcion}','CUECOMP','','{$tabla.monto_pago_mo}','{$tabla.id_concepto_ingas}','{$tabla_padre.id_plantilla}','si','{$tabla.id_centro_costo}','','','si','','id_plan_pago','{$tabla.id_partida_ejecucion_com}','Concepto de Gasto','{$tabla.monto_pago_mo}',NULL,'simple','tes.f_conta_act_tran_plan_pago_dev','{$tabla.id_prorrateo}','no','','','','','','{$tabla_padre.porc_monto_excento_var}','','2','{$tabla.id_orden_trabajo}','tes.vcomp_devtesprov_det_plan_pago',NULL,'','','','','no_descuento','','si');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','DEVTESPROV','x','haber','si','si','','','CUENDEVPRO','','{$tabla_padre.otros_descuentos}','{$tabla_padre.id_proveedor}','','no','','','','no','','','','Suma la multa a la cuenta de proveedores por pagar','{$tabla_padre.otros_descuentos}','2','simple','','','no','','','','','','','','2','','','CXP','','','',NULL,'todos',NULL,'si');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','DEVTESPROV','CXP','haber','si','si','','','CUENDEVPRO','','select  COALESCE({$tabla_padre.liquido_pagable}) + COALESCE({$tabla_padre.descuento_inter_serv})+ COALESCE({$tabla_padre.descuento_ley})+ COALESCE({$tabla_padre.monto_retgar_mo})','{$tabla_padre.id_proveedor}','','no','','','','no','','','','Proveedor por pagar','select  COALESCE({$tabla_padre.liquido_pagable}) + COALESCE({$tabla_padre.descuento_inter_serv})+ COALESCE({$tabla_padre.descuento_ley})+ COALESCE({$tabla_padre.monto_retgar_mo})','1','simple','','','no','','','','','','','','2','','','x3','','','','','todos','','si');

select conta.f_import_tplantilla_comprobante ('insert','PAGTESPROV','tes.f_gestionar_cuota_plan_pago_eliminacion','id_plan_pago','TES','{$tabla.obs_pp}','tes.f_gestionar_cuota_plan_pago','{$tabla.fecha_actual}','activo','{$tabla.desc_proveedor}','{$tabla.id_depto_conta}','contable','{id_int_comprobante}','tes.vcomp_devtesprov_plan_pago','PAGOCON','{$tabla.id_moneda}','{$tabla.id_gestion_cuentas}','{$tabla.id_plantilla},{$tabla.id_proveedor},{$tabla.monto},{$tabla.monto_retgar_mo},{$tabla.otros_descuentos},{$tabla.liquido_pagable},{$tabla.id_cuenta_bancaria},{$tabla.nombre_pago},{$tabla.descuento_anticipo},{$tabla.forma_pago},{$tabla.descuento_inter_serv},{$tabla.descuento_ley}','no','no','no','{$tabla.id_cuenta_bancaria}','{$tabla.id_cuenta_bancaria_mov}','{$tabla.nro_cheque}','{$tabla.nro_cuenta_bancaria}','{$tabla.num_tramite}','','{$tabla.id_depto_libro}','{$tabla.fecha_costo_ini}','{$tabla.fecha_costo_fin}','','Pago a Proveedores desde  el sistema de Obligaciones de Pago','{$tabla.id_int_comprobante_rel}','PAGODEV','','','');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','PAGTESPROV','PAGTESPROV1','haber','si','si','','','RETINSER','','{$tabla_padre.descuento_inter_serv}','{$tabla_padre.id_proveedor}','','no','','','','si','','','','Descuento por intercambio de servicios','{$tabla_padre.descuento_inter_serv}',NULL,'simple','','','no','','','','','','','','2','','',NULL,'','','','','todos','','si');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','PAGTESPROV','PAGTESPROV2','haber','si','si','','{$tabla_padre.nombre_pago}','CUEBANCEGRE','','{$tabla_padre.liquido_pagable}','{$tabla_padre.id_cuenta_bancaria}','','no','','','','si','','','','Cuenta Bancaria','{$tabla_padre.liquido_pagable}',NULL,'simple','','','no','','{$tabla_padre.id_cuenta_bancaria}','{$tabla_padre.id_cuenta_bancaria_mov}','{$tabla_padre.nro_cheque}','{$tabla_padre.nro_cuenta_bancaria}','{$tabla_padre.porc_monto_excento_var}','{$tabla_padre.nombre_pago}','2','','',NULL,'{$tabla_padre.forma_pago}','','','','todos','','si');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','PAGTESPROV','RET.1','haber','si','si','','','RETANT','','{$tabla_padre.descuento_anticipo}','{$tabla_padre.id_proveedor}','','no','','','','si','','','','Retencion de anticipo','{$tabla_padre.descuento_anticipo}',NULL,'simple','','','no','','','','','','','','2','','',NULL,'','','','','todos','','si');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','PAGTESPROV','x2','haber','si','si','','','CUENMULPRO','','{$tabla_padre.otros_descuentos}','{$tabla_padre.id_proveedor}','','no','','','','si','','','','otras descuentos proveedor','{$tabla_padre.otros_descuentos}',NULL,'simple','','','no','','','','','','','','2','','',NULL,'','','','','todos','','si');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','PAGTESPROV','CXP','debe','si','si','','','CUENPAGPRO','','select COALESCE({$tabla_padre.monto},0)   ','{$tabla_padre.id_proveedor}','{$tabla_padre.id_plantilla}','si','','','','si','','','','Cuenta de proveedores por pagar','select COALESCE({$tabla_padre.monto},0)    ',NULL,'simple','','','no','','','','','','','','2','','',NULL,'','','','','descuento','','no');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','PAGTESPROV','REGAR','haber','si','si','','','CUENRETGARPRO','','{$tabla_padre.monto_retgar_mo}','{$tabla_padre.id_proveedor}','','no','','','','si','','','','retencion de garantia','{$tabla_padre.monto_retgar_mo}',NULL,'simple','','','no','','','','','','','','2','','',NULL,'','','','','todos','','si');
/***********************************F-DAT-EGS-CONTA-4-28/03/2019****************************************/

/***********************************I-DAT-RAC-CONTA-53-20/05/2019****************************************/
INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES
  (E'conta_generar_pago_planilla', E'SI', E'habilitar pagos de planilla, por ejemplo No cuando se paga por la CUT');
/***********************************F-DAT-RAC-CONTA-53-20/05/2019****************************************/

/***********************************I-DAT-EGS-CONTA-4-29/05/2019****************************************/
select pxp.f_insert_tgui ('Configuración Tipo Presup ETASA', 'Configuración Tipo Presup ETASA', 'CTP', 'si', 22, '/sis_contabilidad/vista/config_tpre/ConfigTpre.php', 4, '', 'ConfigTpre', 'CONTA');
select pxp.f_insert_testructura_gui ('CTP', 'CONF');
/***********************************F-DAT-EGS-CONTA-4-29/05/2019****************************************/

/***********************************I-DAT-EGS-CONTA-05-29/05/2019****************************************/

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES
  (E'conta_host_migracion', E'hostaddr=172.18.79.XXXX port=5432 dbname=db user=dbamigracion password=dbamigracion', E'configuracion para la conexion para migrar el comprobante al host mencionado'),
  (E'conta_migrar_comprobante', E'false', E'habilita migracion de comprobantes validados a centro de costo seleccionados');

/***********************************F-DAT-EGS-CONTA-05-29/05/2019****************************************/

/***********************************I-DAT-EGS-CONTA-06-05/06/2019****************************************/
select pxp.f_insert_tgui ('Configuraciones Etasa', 'configuraciones e etasa', 'CFGETASA', 'si', 22, '', 3, '', '', 'CONTA');
select pxp.f_insert_tgui ('Configuración Tipo Presup ETASA', 'Configuración Tipo Presup ETASA', 'CTP', 'si', 1, '/sis_contabilidad/vista/config_tpre/ConfigTpre.php', 4, '', 'ConfigTpre', 'CONTA');
select pxp.f_insert_tgui ('Configuracion Auxiliar Etasa', 'Configuracion Auxiliar Etasa', 'CFGAUX', 'si', 2, 'sis_contabilidad/vista/config_auxiliar/ConfigAuxiliar.php', 4, '', 'ConfigAuxiliar', 'CONTA');
/***********************************F-DAT-EGS-CONTA-06-05/06/2019****************************************/

/***********************************I-DAT-EGS-CONTA-07-11/06/2019****************************************/
select pxp.f_insert_tgui ('Configuracion Marca Cbte', 'Configuracion de la marca de comprobante', 'cbtemarca', 'si', 20, 'sis_contabilidad/vista/marca/Marca.php', 3, '', 'Marca', 'CONTA');
/***********************************F-DAT-EGS-CONTA-07-11/06/2019****************************************/


/***********************************I-DAT-RAC-CONTA-66-25/07/2019****************************************/

select conta.f_import_ttabla_relacion_contable ('insert','TZIMP','activo','ttaza_impuesto','PARAM','id_taza_impuesto','','','','','');
select conta.f_import_ttipo_relacion_contable ('insert','TAZAIMP','TZIMP','Taza Impuesto','activo','si-general','si','no','flujo_presupuestaria','recurso_gasto','no','no','no','');

--inserta menu
select pxp.f_insert_tgui ('Taza Impuesto', 'Taza Impuesto', 'TAZAIMP', 'si', 10, 'sis_contabilidad/vista/relacion_contable/TazaImpuestoCuenta.php', 3, '', 'TazaImpuestoCuenta', 'CONTA');
select pxp.f_insert_testructura_gui ('TAZAIMP', 'RELACON');

/***********************************F-DAT-RAC-CONTA-66-25/07/2019****************************************/



/***********************************I-DAT-MANU-CONTA-1-30/10/2019****************************************/

select pxp.f_insert_tgui ('VoBo Verificacion', 'VoBo Verificacion', 'VBVER', 'si', 50, 'sis_contabilidad/vista/int_comprobante/IntComprobanteVeri.php', 3, '', 'IntComprobanteVeri', 'CONTA');

/***********************************F-DAT-MANU-CONTA-1-30/10/2019****************************************/

/***********************************I-DAT-RCM-CONTA-86-06/01/2019****************************************/
select pxp.f_insert_tgui ('MISC - Contabilización Almacenes SIGEMA', 'MISC - Contabilización Almacenes SIGEMA', 'MISCALMREL', 'si', 13, 'sis_miscelaneo/vista/conta_alm_tipo_mat/ContaAlmTipoMat.php', 3, '', 'ContaAlmTipoMat', 'CONTA');
select pxp.f_insert_testructura_gui ('MISCALMREL', 'RELACON');
/***********************************F-DAT-RCM-CONTA-86-06/01/2019****************************************/



/***********************************I-DAT-RAC-CONTA-89-15/01/2020****************************************/

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES 
  (E'conta_control_correlativo_cbte', E'no', E'si o no, habilita el control de ccorelativo segun numero y fecha, por ejemplo, si tiene validado el cbte nro 10 el 10 de nero , no puedes validar el cbte nro 11 el 8 de enero');
  
  
/***********************************F-DAT-RAC-CONTA-89-15/01/2020****************************************/
  
  
  
/***********************************I-DAT-RAC-CONTA-103-06/02/2020****************************************/
  
INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES 
  (E'conta_cbte_apertura_cuentas_centro_reset', E'1.1.3.04.001.001,2.1.3.01.001.001', E'Nro de cuentas separadas por comas sin espacions. Estas cuentas en el bte de apertura sin partidas se llevan al centro de costo configurado en conta_cbte_apertura_centro_reset'),
  (E'conta_cbte_apertura_centro_reset', E'00000', E'Codigo centro de costo. En cbte de apertura lleva las cuentas configuras en aconta_cbte_apertura_cuentas_centro_reset');
  
  
  
/***********************************F-DAT-RAC-CONTA-103-06/02/2020****************************************/



/***********************************I-DAT-RAC-CONTA-108-04/03/2020****************************************/

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES 
  (E'conta_generar_lb_manual_oc', E'no', E'si o no, si la integracion con libro de bancos esta activada, define si  segenera al validar el cbte o desde interface (solo para regional 0m oficina central)');
  

/***********************************F-DAT-RAC-CONTA-108-04/03/2020****************************************/
/***********************************I-DAT-MMV-CONTA-113-29/04/2020****************************************/
select pxp.f_insert_tgui ('Reporte Registro Ventas CC', 'Reporte Registro Ventas CC', 'RVC', 'si', 50, 'sis_contabilidad/vista/reporte_registro_ventas/ReporteRegistroVentas.php', 3, '', 'ReporteRegistroVentas', 'CONTA');
select pxp.f_insert_testructura_gui ('RVC', 'REPCON');
/***********************************F-DAT-MMV-CONTA-113-29/04/2020****************************************/


  
  
  
  
  
