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

----------------------------------------------
--  DEF DE FUNCIONES
--------------------------------------------------

select pxp.f_insert_tfuncion ('conta.f_cuenta_ime', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.f_cuenta_sel', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.f_auxiliar_sel', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.f_auxiliar_ime', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.f_orden_trabajo_sel', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.f_orden_trabajo_ime', 'Funcion para tabla     ', 'CONTA');

---------------------------------
--DEF DE PROCEDIMIETOS
---------------------------------

select pxp.f_insert_tprocedimiento ('CONTA_CTA_INS', 'Insercion de registros', 'si', '', '', 'conta.f_cuenta_ime');
select pxp.f_insert_tprocedimiento ('CONTA_CTA_MOD', 'Modificacion de registros', 'si', '', '', 'conta.f_cuenta_ime');
select pxp.f_insert_tprocedimiento ('CONTA_CTA_ELI', 'Eliminacion de registros', 'si', '', '', 'conta.f_cuenta_ime');
select pxp.f_insert_tprocedimiento ('CONTA_CTA_SEL', 'Consulta de datos', 'si', '', '', 'conta.f_cuenta_sel');
select pxp.f_insert_tprocedimiento ('CONTA_CTA_CONT', 'Conteo de registros', 'si', '', '', 'conta.f_cuenta_sel');
select pxp.f_insert_tprocedimiento ('CONTA_CTA_ARB_SEL', 'Consulta de datos', 'si', '', '', 'conta.f_cuenta_sel');
select pxp.f_insert_tprocedimiento ('CONTA_AUXCTA_SEL', 'Consulta de datos', 'si', '', '', 'conta.f_auxiliar_sel');
select pxp.f_insert_tprocedimiento ('CONTA_AUXCTA_CONT', 'Conteo de registros', 'si', '', '', 'conta.f_auxiliar_sel');
select pxp.f_insert_tprocedimiento ('CONTA_AUXCTA_INS', 'Insercion de registros', 'si', '', '', 'conta.f_auxiliar_ime');
select pxp.f_insert_tprocedimiento ('CONTA_AUXCTA_MOD', 'Modificacion de registros', 'si', '', '', 'conta.f_auxiliar_ime');
select pxp.f_insert_tprocedimiento ('CONTA_AUXCTA_ELI', 'Eliminacion de registros', 'si', '', '', 'conta.f_auxiliar_ime');
select pxp.f_insert_tprocedimiento ('CONTA_ODT_SEL', 'Consulta de datos', 'si', '', '', 'conta.f_orden_trabajo_sel');
select pxp.f_insert_tprocedimiento ('CONTA_ODT_CONT', 'Conteo de registros', 'si', '', '', 'conta.f_orden_trabajo_sel');
select pxp.f_insert_tprocedimiento ('CONTA_ODT_INS', 'Insercion de registros', 'si', '', '', 'conta.f_orden_trabajo_ime');
select pxp.f_insert_tprocedimiento ('CONTA_ODT_MOD', 'Modificacion de registros', 'si', '', '', 'conta.f_orden_trabajo_ime');
select pxp.f_insert_tprocedimiento ('CONTA_ODT_ELI', 'Eliminacion de registros', 'si', '', '', 'conta.f_orden_trabajo_ime');


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

/***********************************I-DAT-GSS-CONTA-81-26/03/2013*****************************************/

--funciones

select pxp.f_insert_tfuncion ('conta.f_config_tipo_cuenta_ime', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.f_config_tipo_cuenta_sel', 'Funcion para tabla     ', 'CONTA');

--procedimientos

select pxp.f_insert_tprocedimiento ('CONTA_CTA_INS', 'Insercion de registros', 'si', '', '', 'conta.f_cuenta_ime');
select pxp.f_insert_tprocedimiento ('CONTA_CTA_MOD', 'Modificacion de registros', 'si', '', '', 'conta.f_cuenta_ime');
select pxp.f_insert_tprocedimiento ('CONTA_CTA_ELI', 'Eliminacion de registros', 'si', '', '', 'conta.f_cuenta_ime');
select pxp.f_insert_tprocedimiento ('CONTA_CTA_SEL', 'Consulta de datos', 'si', '', '', 'conta.f_cuenta_sel');
select pxp.f_insert_tprocedimiento ('CONTA_CTA_CONT', 'Conteo de registros', 'si', '', '', 'conta.f_cuenta_sel');
select pxp.f_insert_tprocedimiento ('CONTA_CTA_ARB_SEL', 'Consulta de datos', 'si', '', '', 'conta.f_cuenta_sel');
select pxp.f_insert_tprocedimiento ('CONTA_AUXCTA_SEL', 'Consulta de datos', 'si', '', '', 'conta.f_auxiliar_sel');
select pxp.f_insert_tprocedimiento ('CONTA_AUXCTA_CONT', 'Conteo de registros', 'si', '', '', 'conta.f_auxiliar_sel');
select pxp.f_insert_tprocedimiento ('CONTA_AUXCTA_INS', 'Insercion de registros', 'si', '', '', 'conta.f_auxiliar_ime');
select pxp.f_insert_tprocedimiento ('CONTA_AUXCTA_MOD', 'Modificacion de registros', 'si', '', '', 'conta.f_auxiliar_ime');
select pxp.f_insert_tprocedimiento ('CONTA_AUXCTA_ELI', 'Eliminacion de registros', 'si', '', '', 'conta.f_auxiliar_ime');
select pxp.f_insert_tprocedimiento ('CONTA_ODT_SEL', 'Consulta de datos', 'si', '', '', 'conta.f_orden_trabajo_sel');
select pxp.f_insert_tprocedimiento ('CONTA_ODT_CONT', 'Conteo de registros', 'si', '', '', 'conta.f_orden_trabajo_sel');
select pxp.f_insert_tprocedimiento ('CONTA_ODT_INS', 'Insercion de registros', 'si', '', '', 'conta.f_orden_trabajo_ime');
select pxp.f_insert_tprocedimiento ('CONTA_ODT_MOD', 'Modificacion de registros', 'si', '', '', 'conta.f_orden_trabajo_ime');
select pxp.f_insert_tprocedimiento ('CONTA_ODT_ELI', 'Eliminacion de registros', 'si', '', '', 'conta.f_orden_trabajo_ime');
select pxp.f_insert_tprocedimiento ('CONTA_CTC_INS', 'Insercion de registros', 'si', '', '', 'conta.f_config_tipo_cuenta_ime');
select pxp.f_insert_tprocedimiento ('CONTA_CTC_MOD', 'Modificacion de registros', 'si', '', '', 'conta.f_config_tipo_cuenta_ime');
select pxp.f_insert_tprocedimiento ('CONTA_CTC_ELI', 'Eliminacion de registros', 'si', '', '', 'conta.f_config_tipo_cuenta_ime');
select pxp.f_insert_tprocedimiento ('CONTA_CTC_SEL', 'Consulta de datos', 'si', '', '', 'conta.f_config_tipo_cuenta_sel');
select pxp.f_insert_tprocedimiento ('CONTA_CTC_CONT', 'Conteo de registros', 'si', '', '', 'conta.f_config_tipo_cuenta_sel');

--procedimientos_gui

select pxp.f_insert_tprocedimiento_gui ('CONTA_CTC_SEL', 'CTA', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CTA_INS', 'CTA', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CTA_MOD', 'CTA', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CTA_ELI', 'CTA', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CTA_ARB_SEL', 'CTA', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_AUXCTA_INS', 'AUXCTA', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_AUXCTA_MOD', 'AUXCTA', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_AUXCTA_ELI', 'AUXCTA', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_AUXCTA_SEL', 'AUXCTA', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_ODT_INS', 'ODT', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_ODT_MOD', 'ODT', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_ODT_ELI', 'ODT', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_ODT_SEL', 'ODT', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CTC_INS', 'CTIP', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CTC_MOD', 'CTIP', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CTC_ELI', 'CTIP', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CTC_SEL', 'CTIP', 'no');

/***********************************F-DAT-GSS-CONTA-81-26/03/2013*****************************************/

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

select pxp.f_insert_tfuncion ('conta.ft_plantilla_comprobante_ime', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.ft_plantilla_comprobante_sel', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.ft_detalle_plantilla_comprobante_ime', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.ft_detalle_plantilla_comprobante_sel', 'Funcion para tabla     ', 'CONTA');

select pxp.f_insert_tprocedimiento ('CONTA_CMPB_INS', 'Insercion de registros', 'si', '', '', 'conta.ft_plantilla_comprobante_ime');
select pxp.f_insert_tprocedimiento ('CONTA_CMPB_MOD', 'Modificacion de registros', 'si', '', '', 'conta.ft_plantilla_comprobante_ime');
select pxp.f_insert_tprocedimiento ('CONTA_CMPB_ELI', 'Eliminacion de registros', 'si', '', '', 'conta.ft_plantilla_comprobante_ime');
select pxp.f_insert_tprocedimiento ('CONTA_CMPB_SEL', 'Consulta de datos', 'si', '', '', 'conta.ft_plantilla_comprobante_sel');
select pxp.f_insert_tprocedimiento ('CONTA_CMPB_CONT', 'Conteo de registros', 'si', '', '', 'conta.ft_plantilla_comprobante_sel');
select pxp.f_insert_tprocedimiento ('CONTA_CMPBDET_INS', 'Insercion de registros', 'si', '', '', 'conta.ft_detalle_plantilla_comprobante_ime');
select pxp.f_insert_tprocedimiento ('CONTA_CMPBDET_MOD', 'Modificacion de registros', 'si', '', '', 'conta.ft_detalle_plantilla_comprobante_ime');
select pxp.f_insert_tprocedimiento ('CONTA_CMPBDET_ELI', 'Eliminacion de registros', 'si', '', '', 'conta.ft_detalle_plantilla_comprobante_ime');
select pxp.f_insert_tprocedimiento ('CONTA_CMPBDET_SEL', 'Consulta de datos', 'si', '', '', 'conta.ft_detalle_plantilla_comprobante_sel');
select pxp.f_insert_tprocedimiento ('CONTA_CMPBDET_CONT', 'Conteo de registros', 'si', '', '', 'conta.ft_detalle_plantilla_comprobante_sel');

select pxp.f_insert_tprocedimiento_gui ('PM_GES_SEL', 'CTA', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'CTA', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CMPB_INS', 'CMPB', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CMPB_MOD', 'CMPB', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CMPB_ELI', 'CMPB', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CMPB_SEL', 'CMPB', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CMPBDET_INS', 'CMPB.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CMPBDET_MOD', 'CMPB.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CMPBDET_ELI', 'CMPB.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CMPBDET_SEL', 'CMPB.1', 'no');

/***********************************F-DAT-GSS-CONTA-9-10/06/2013*****************************************/






/***********************************I-DAT-RAC-CONTA-0-10/07/2013*****************************************/


/* Data for the 'conta.ttabla_relacion_contable' table  (Records 1 - 2) */

INSERT INTO conta.ttabla_relacion_contable ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tabla_relacion_contable", "tabla", "esquema", "tabla_id")
VALUES (1, NULL, E'2013-06-25 14:29:34.603', NULL, E'activo', 1, E'tconcepto_ingas', E'PARAM', E'id_concepto_ingas');

INSERT INTO conta.ttabla_relacion_contable ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tabla_relacion_contable", "tabla", "esquema", "tabla_id")
VALUES (1, NULL, E'2013-07-10 17:39:38.107', NULL, E'activo', 2, E'tcuenta_bancaria', E'TES', E'id_cuenta_bancaria');

INSERT INTO conta.ttipo_relacion_contable ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_relacion_contable", "nombre_tipo_relacion", "codigo_tipo_relacion", "tiene_centro_costo", "tiene_partida", "tiene_auxiliar", "id_tabla_relacion_contable")
VALUES (1, NULL, E'2013-06-25 14:32:13.255', NULL, E'activo', 1, E'Cuenta para realizar compras', E'CUECOMP', E'si-general', E'si', E'si', 1);

INSERT INTO conta.ttipo_relacion_contable ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_relacion_contable", "nombre_tipo_relacion", "codigo_tipo_relacion", "tiene_centro_costo", "tiene_partida", "tiene_auxiliar", "id_tabla_relacion_contable")
VALUES (1, NULL, E'2013-07-10 17:40:17.829', NULL, E'activo', 2, E'Cuentas Bancarias', E'CUEBANCEGRE', E'no', E'no', E'si', 2);

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
INSERT INTO conta.ttipo_relacion_contable ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_relacion_contable", "nombre_tipo_relacion", "codigo_tipo_relacion", "tiene_centro_costo", "tiene_partida", "tiene_auxiliar", "id_tabla_relacion_contable")
VALUES (1, NULL, E'2013-08-26 23:33:17.859', NULL, E'activo', 3, E'IVA- CF', E'IVA-CF', E'no', E'si', E'si', NULL);

--tipo relacion contable, Cuenta  Devengado Proveedor
INSERT INTO conta.ttipo_relacion_contable ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_relacion_contable", "nombre_tipo_relacion", "codigo_tipo_relacion", "tiene_centro_costo", "tiene_partida", "tiene_auxiliar", "id_tabla_relacion_contable")
VALUES (1, NULL, E'2013-08-27 20:12:31.331', NULL, E'activo', 4, E'Cuenta  Devengado Proveedor', E'CUENDEVPRO', E'no', E'si', E'si', 3);


--tipo relacion contable, Centro de Costo Depto Conta
INSERT INTO conta.ttipo_relacion_contable ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_relacion_contable", "nombre_tipo_relacion", "codigo_tipo_relacion", "tiene_centro_costo", "tiene_partida", "tiene_auxiliar", "id_tabla_relacion_contable")
VALUES (1, NULL, E'2013-08-28 06:23:24.403', NULL, E'activo', 5, E'Centro de Costo Depto Conta', E'CCDEPCON', E'si', E'no', E'no', 4);

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



INSERT INTO conta.ttipo_relacion_contable ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_relacion_contable", "nombre_tipo_relacion", "codigo_tipo_relacion", "tiene_centro_costo", "tiene_partida", "tiene_auxiliar", "id_tabla_relacion_contable")
VALUES (1, NULL, E'2013-09-19 09:45:31.693', NULL, E'activo', 9, E'Retenciones IT', E'IT-RET', E'si-general', E'si', E'si', NULL);

INSERT INTO conta.ttipo_relacion_contable ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_relacion_contable", "nombre_tipo_relacion", "codigo_tipo_relacion", "tiene_centro_costo", "tiene_partida", "tiene_auxiliar", "id_tabla_relacion_contable")
VALUES (1, NULL, E'2013-09-19 10:20:58.567', NULL, E'activo', 10, E'Retencion de IUE por compra de bienes', E'IUE-RET-BIE', E'si-general', E'si', E'si', NULL);


--relaciones contable proveedor

INSERT INTO conta.ttipo_relacion_contable ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_relacion_contable", "nombre_tipo_relacion", "codigo_tipo_relacion", "tiene_centro_costo", "tiene_partida", "tiene_auxiliar", "id_tabla_relacion_contable")
VALUES (1, 1, E'2013-08-29 15:08:16.991', E'2013-08-29 18:09:58.611', E'activo', 6, E'Cuentas de retenciones de proveedor', E'CUENRETPRO', E'si-general', E'si', E'si', 3);

INSERT INTO conta.ttipo_relacion_contable ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_relacion_contable", "nombre_tipo_relacion", "codigo_tipo_relacion", "tiene_centro_costo", "tiene_partida", "tiene_auxiliar", "id_tabla_relacion_contable")
VALUES (1, NULL, E'2013-08-29 18:14:19.261', NULL, E'activo', 7, E'Cuentas para retencion de garantia proveedor', E'CUENRETGARPRO', E'si-general', E'si', E'si', 3);

INSERT INTO conta.ttipo_relacion_contable ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_relacion_contable", "nombre_tipo_relacion", "codigo_tipo_relacion", "tiene_centro_costo", "tiene_partida", "tiene_auxiliar", "id_tabla_relacion_contable")
VALUES (1, NULL, E'2013-09-18 17:54:57.881', NULL, E'activo', 8, E'Cuenta para el pago de Proveedores', E'CUENPAGPRO', E'si-general', E'si', E'si', 3);


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
select pxp.f_insert_tfuncion ('conta.f_validar_cbte', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.ft_int_comprobante_sel', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.f_get_cuenta_ids', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.f_replicar_cbte', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.f_get_descuento_plantilla_calculo', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.ft_transaccion_sel', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.ft_transaccion_valor_ime', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.f_tri_trelacion_contable', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.ft_plantilla_calculo_sel', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.ft_comprobante_ime', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.f_gen_comprobante', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.f_gen_inser_transaccion', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.f_eliminar_int_comprobante', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.f_gen_transaccion_from_plantilla', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.ft_int_comprobante_ime', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.f_replicar_relacion_contable_cambio_gestion', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.f_get_config_relacion_contable', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.f_obtener_columnas', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.ft_tipo_relacion_contable_ime', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.f_gen_transaccion_unitaria', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.ft_tipo_relacion_contable_sel', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.ft_int_transaccion_ime', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.f_get_columna', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.ft_clase_comprobante_ime', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.ft_int_trans_val_ime', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.ft_cuenta_auxiliar_ime', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.ft_relacion_contable_ime', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.ft_cuenta_auxiliar_sel', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.ft_int_transaccion_sel', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.ft_relacion_contable_sel', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.ft_transaccion_valor_sel', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.ft_tabla_relacion_contable_ime', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.ft_int_trans_val_sel', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.ft_tabla_relacion_contable_sel', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.f_gen_proc_plantilla_calculo', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.ft_clase_comprobante_sel', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.f_gen_transaccion', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.ft_comprobante_sel', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.f_get_variables_plantilla_comprobante', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.f_gestionar_presupuesto_cbte', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.f_obtener_columnas_detalle', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.ft_plantilla_calculo_ime', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.ft_transaccion_ime', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tprocedimiento ('CONTA_INCBTE_SEL', 'Consulta de datos', 'si', '', '', 'conta.ft_int_comprobante_sel');
select pxp.f_insert_tprocedimiento ('CONTA_INCBTE_CONT', 'Conteo de registros', 'si', '', '', 'conta.ft_int_comprobante_sel');
select pxp.f_insert_tprocedimiento ('CONTA_CABCBT_SEL', 'Cabecera para el reporte de Comprobante', 'si', '', '', 'conta.ft_int_comprobante_sel');
select pxp.f_insert_tprocedimiento ('CONTA_DETCBT_SEL', 'Cabecera para el reporte de Comprobante', 'si', '', '', 'conta.ft_int_comprobante_sel');
select pxp.f_insert_tprocedimiento ('CONTA_TRANSA_SEL', 'Consulta de datos', 'si', '', '', 'conta.ft_transaccion_sel');
select pxp.f_insert_tprocedimiento ('CONTA_TRANSA_CONT', 'Conteo de registros', 'si', '', '', 'conta.ft_transaccion_sel');
select pxp.f_insert_tprocedimiento ('CONTA_CONTVA_INS', 'Insercion de registros', 'si', '', '', 'conta.ft_transaccion_valor_ime');
select pxp.f_insert_tprocedimiento ('CONTA_CONTVA_MOD', 'Modificacion de registros', 'si', '', '', 'conta.ft_transaccion_valor_ime');
select pxp.f_insert_tprocedimiento ('CONTA_CONTVA_ELI', 'Eliminacion de registros', 'si', '', '', 'conta.ft_transaccion_valor_ime');
select pxp.f_insert_tprocedimiento ('CONTA_PLACAL_SEL', 'Consulta de datos', 'si', '', '', 'conta.ft_plantilla_calculo_sel');
select pxp.f_insert_tprocedimiento ('CONTA_PLACAL_CONT', 'Conteo de registros', 'si', '', '', 'conta.ft_plantilla_calculo_sel');
select pxp.f_insert_tprocedimiento ('CONTA_CBTE_INS', 'Insercion de registros', 'si', '', '', 'conta.ft_comprobante_ime');
select pxp.f_insert_tprocedimiento ('CONTA_CBTE_MOD', 'Modificacion de registros', 'si', '', '', 'conta.ft_comprobante_ime');
select pxp.f_insert_tprocedimiento ('CONTA_CBTE_ELI', 'Eliminacion de registros', 'si', '', '', 'conta.ft_comprobante_ime');
select pxp.f_insert_tprocedimiento ('CONTA_INCBTE_INS', 'Insercion de registros', 'si', '', '', 'conta.ft_int_comprobante_ime');
select pxp.f_insert_tprocedimiento ('CONTA_INCBTE_MOD', 'Modificacion de registros', 'si', '', '', 'conta.ft_int_comprobante_ime');
select pxp.f_insert_tprocedimiento ('CONTA_INCBTE_ELI', 'Eliminacion de registros', 'si', '', '', 'conta.ft_int_comprobante_ime');
select pxp.f_insert_tprocedimiento ('CONTA_INCBTE_VAL', 'Validación del comprobante', 'si', '', '', 'conta.ft_int_comprobante_ime');
select pxp.f_insert_tprocedimiento ('CONTA_TIPRELCO_INS', 'Insercion de registros', 'si', '', '', 'conta.ft_tipo_relacion_contable_ime');
select pxp.f_insert_tprocedimiento ('CONTA_TIPRELCO_MOD', 'Modificacion de registros', 'si', '', '', 'conta.ft_tipo_relacion_contable_ime');
select pxp.f_insert_tprocedimiento ('CONTA_TIPRELCO_ELI', 'Eliminacion de registros', 'si', '', '', 'conta.ft_tipo_relacion_contable_ime');
select pxp.f_insert_tprocedimiento ('CONTA_TIPRELCO_SEL', 'Consulta de datos', 'si', '', '', 'conta.ft_tipo_relacion_contable_sel');
select pxp.f_insert_tprocedimiento ('CONTA_TIPRELCO_CONT', 'Conteo de registros', 'si', '', '', 'conta.ft_tipo_relacion_contable_sel');
select pxp.f_insert_tprocedimiento ('CONTA_INTRANSA_INS', 'Insercion de registros', 'si', '', '', 'conta.ft_int_transaccion_ime');
select pxp.f_insert_tprocedimiento ('CONTA_INTRANSA_MOD', 'Modificacion de registros', 'si', '', '', 'conta.ft_int_transaccion_ime');
select pxp.f_insert_tprocedimiento ('CONTA_INTRANSA_ELI', 'Eliminacion de registros', 'si', '', '', 'conta.ft_int_transaccion_ime');
select pxp.f_insert_tprocedimiento ('CONTA_CCOM_INS', 'Insercion de registros', 'si', '', '', 'conta.ft_clase_comprobante_ime');
select pxp.f_insert_tprocedimiento ('CONTA_CCOM_MOD', 'Modificacion de registros', 'si', '', '', 'conta.ft_clase_comprobante_ime');
select pxp.f_insert_tprocedimiento ('CONTA_CCOM_ELI', 'Eliminacion de registros', 'si', '', '', 'conta.ft_clase_comprobante_ime');
select pxp.f_insert_tprocedimiento ('CONTA_TRAVAL_INS', 'Insercion de registros', 'si', '', '', 'conta.ft_int_trans_val_ime');
select pxp.f_insert_tprocedimiento ('CONTA_TRAVAL_MOD', 'Modificacion de registros', 'si', '', '', 'conta.ft_int_trans_val_ime');
select pxp.f_insert_tprocedimiento ('CONTA_TRAVAL_ELI', 'Eliminacion de registros', 'si', '', '', 'conta.ft_int_trans_val_ime');
select pxp.f_insert_tprocedimiento ('CONTA_CAX_INS', 'Insercion de registros', 'si', '', '', 'conta.ft_cuenta_auxiliar_ime');
select pxp.f_insert_tprocedimiento ('CONTA_CAX_MOD', 'Modificacion de registros', 'si', '', '', 'conta.ft_cuenta_auxiliar_ime');
select pxp.f_insert_tprocedimiento ('CONTA_CAX_ELI', 'Eliminacion de registros', 'si', '', '', 'conta.ft_cuenta_auxiliar_ime');
select pxp.f_insert_tprocedimiento ('CONTA_RELCON_INS', 'Insercion de registros', 'si', '', '', 'conta.ft_relacion_contable_ime');
select pxp.f_insert_tprocedimiento ('CONTA_RELCON_MOD', 'Modificacion de registros', 'si', '', '', 'conta.ft_relacion_contable_ime');
select pxp.f_insert_tprocedimiento ('CONTA_RELCON_ELI', 'Eliminacion de registros', 'si', '', '', 'conta.ft_relacion_contable_ime');
select pxp.f_insert_tprocedimiento ('CONTA_REPRELCON_REP', 'Replicación de parametrización de Relaciones Contables', 'si', '', '', 'conta.ft_relacion_contable_ime');
select pxp.f_insert_tprocedimiento ('CONTA_CAX_SEL', 'Consulta de datos', 'si', '', '', 'conta.ft_cuenta_auxiliar_sel');
select pxp.f_insert_tprocedimiento ('CONTA_CAX_CONT', 'Conteo de registros', 'si', '', '', 'conta.ft_cuenta_auxiliar_sel');
select pxp.f_insert_tprocedimiento ('CONTA_INTRANSA_SEL', 'Consulta de datos', 'si', '', '', 'conta.ft_int_transaccion_sel');
select pxp.f_insert_tprocedimiento ('CONTA_INTRANSA_CONT', 'Conteo de registros', 'si', '', '', 'conta.ft_int_transaccion_sel');
select pxp.f_insert_tprocedimiento ('CONTA_RELCON_SEL', 'Consulta de datos', 'si', '', '', 'conta.ft_relacion_contable_sel');
select pxp.f_insert_tprocedimiento ('CONTA_RELCON_CONT', 'Conteo de registros', 'si', '', '', 'conta.ft_relacion_contable_sel');
select pxp.f_insert_tprocedimiento ('CONTA_CONTVA_SEL', 'Consulta de datos', 'si', '', '', 'conta.ft_transaccion_valor_sel');
select pxp.f_insert_tprocedimiento ('CONTA_CONTVA_CONT', 'Conteo de registros', 'si', '', '', 'conta.ft_transaccion_valor_sel');
select pxp.f_insert_tprocedimiento ('CONTA_TABRECON_INS', 'Insercion de registros', 'si', '', '', 'conta.ft_tabla_relacion_contable_ime');
select pxp.f_insert_tprocedimiento ('CONTA_TABRECON_MOD', 'Modificacion de registros', 'si', '', '', 'conta.ft_tabla_relacion_contable_ime');
select pxp.f_insert_tprocedimiento ('CONTA_TABRECON_ELI', 'Eliminacion de registros', 'si', '', '', 'conta.ft_tabla_relacion_contable_ime');
select pxp.f_insert_tprocedimiento ('CONTA_TRAVAL_SEL', 'Consulta de datos', 'si', '', '', 'conta.ft_int_trans_val_sel');
select pxp.f_insert_tprocedimiento ('CONTA_TRAVAL_CONT', 'Conteo de registros', 'si', '', '', 'conta.ft_int_trans_val_sel');
select pxp.f_insert_tprocedimiento ('CONTA_TABRECON_SEL', 'Consulta de datos', 'si', '', '', 'conta.ft_tabla_relacion_contable_sel');
select pxp.f_insert_tprocedimiento ('CONTA_TABRECON_CONT', 'Conteo de registros', 'si', '', '', 'conta.ft_tabla_relacion_contable_sel');
select pxp.f_insert_tprocedimiento ('CONTA_CCOM_SEL', 'Consulta de datos', 'si', '', '', 'conta.ft_clase_comprobante_sel');
select pxp.f_insert_tprocedimiento ('CONTA_CCOM_CONT', 'Conteo de registros', 'si', '', '', 'conta.ft_clase_comprobante_sel');
select pxp.f_insert_tprocedimiento ('CONTA_CBTE_SEL', 'Consulta de datos', 'si', '', '', 'conta.ft_comprobante_sel');
select pxp.f_insert_tprocedimiento ('CONTA_CBTE_CONT', 'Conteo de registros', 'si', '', '', 'conta.ft_comprobante_sel');
select pxp.f_insert_tprocedimiento ('CONTA_PLACAL_INS', 'Insercion de registros', 'si', '', '', 'conta.ft_plantilla_calculo_ime');
select pxp.f_insert_tprocedimiento ('CONTA_PLACAL_MOD', 'Modificacion de registros', 'si', '', '', 'conta.ft_plantilla_calculo_ime');
select pxp.f_insert_tprocedimiento ('CONTA_PLACAL_ELI', 'Eliminacion de registros', 'si', '', '', 'conta.ft_plantilla_calculo_ime');
select pxp.f_insert_tprocedimiento ('CONTA_GETDEC_IME', 'Recuperar decuetnos de la plantilla de calculo indicada', 'si', '', '', 'conta.ft_plantilla_calculo_ime');
select pxp.f_insert_tprocedimiento ('CONTA_CONTRA_INS', 'Insercion de registros', 'si', '', '', 'conta.ft_transaccion_ime');
select pxp.f_insert_tprocedimiento ('CONTA_CONTRA_MOD', 'Modificacion de registros', 'si', '', '', 'conta.ft_transaccion_ime');
select pxp.f_insert_tprocedimiento ('CONTA_CONTRA_ELI', 'Eliminacion de registros', 'si', '', '', 'conta.ft_transaccion_ime');
select pxp.f_delete_trol ('Relación Contable Concepto Gasto');
select pxp.f_delete_trol ('CONTA-Rleacion contable concepto gatos');
select pxp.f_insert_trol ('CONTA- Relación Contable Concepto Gasto', 'CONTA- Relación Contable Concepto Gasto', 'CONTA');
select pxp.f_insert_trol ('Rol para ingreso de relaciones de proveedores con Auxiliar Contable', 'CONTA - Relacion Proveedor - Cuenta Contable', 'CONTA');
select pxp.f_insert_trol ('Para registrar relaciones contables con cuenta bancaria', 'CONTA - Relacion cuenta Bancaria', 'CONTA');
select pxp.f_insert_trol ('Rol para relaciones contables', 'CONTA - Relaciones contables ELACIONES CONTABLES', 'CONTA');
select pxp.f_insert_trol ('Rol pra edicion modiificacion o configuracion de plantilla de docuemntos contables ', 'CONTA - Plantilla de Documentos', 'CONTA');

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
select pxp.f_insert_tfuncion ('conta.ft_grupo_ot_sel', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.ft_grupo_ot_ime', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.f_mig_presupuestos', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.f_verificar_presupuesto_cbte', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.ft_grupo_ot_det_sel', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tfuncion ('conta.ft_grupo_ot_det_ime', 'Funcion para tabla     ', 'CONTA');
select pxp.f_insert_tprocedimiento ('CONTA_GOT_SEL', 'Consulta de datos', 'si', '', '', 'conta.ft_grupo_ot_sel');
select pxp.f_insert_tprocedimiento ('CONTA_GOT_CONT', 'Conteo de registros', 'si', '', '', 'conta.ft_grupo_ot_sel');
select pxp.f_insert_tprocedimiento ('CONTA_GOT_INS', 'Insercion de registros', 'si', '', '', 'conta.ft_grupo_ot_ime');
select pxp.f_insert_tprocedimiento ('CONTA_GOT_MOD', 'Modificacion de registros', 'si', '', '', 'conta.ft_grupo_ot_ime');
select pxp.f_insert_tprocedimiento ('CONTA_GOT_ELI', 'Eliminacion de registros', 'si', '', '', 'conta.ft_grupo_ot_ime');
select pxp.f_insert_tprocedimiento ('CONTA_GOTD_SEL', 'Consulta de datos', 'si', '', '', 'conta.ft_grupo_ot_det_sel');
select pxp.f_insert_tprocedimiento ('CONTA_GOTD_CONT', 'Conteo de registros', 'si', '', '', 'conta.ft_grupo_ot_det_sel');
select pxp.f_insert_tprocedimiento ('CONTA_GOTD_INS', 'Insercion de registros', 'si', '', '', 'conta.ft_grupo_ot_det_ime');
select pxp.f_insert_tprocedimiento ('CONTA_GOTD_MOD', 'Modificacion de registros', 'si', '', '', 'conta.ft_grupo_ot_det_ime');
select pxp.f_insert_tprocedimiento ('CONTA_GOTD_ELI', 'Eliminacion de registros', 'si', '', '', 'conta.ft_grupo_ot_det_ime');
select pxp.f_delete_trol ('Relación Contable Concepto Gasto');
select pxp.f_delete_trol ('CONTA-Rleacion contable concepto gatos');
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
select pxp.f_insert_tprocedimiento_gui ('CONTA_GOT_SEL', 'CONGASCUE', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPAR_SEL', 'CONGASCUE', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CATCMB_SEL', 'DEPTCON.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_SUBSIS_SEL', 'DEPTCON.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PACATI_SEL', 'DEPTCON.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_INS', 'DEPTCON.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_MOD', 'DEPTCON.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_ELI', 'DEPTCON.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_SEL', 'DEPTCON.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CATCMB_SEL', 'DEPTCON.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SINCEPUO_IME', 'DEPTCON.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPAR_SEL', 'ALMCUE.6.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_GOT_INS', 'GRUOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_GOT_MOD', 'GRUOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_GOT_ELI', 'GRUOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_GOT_SEL', 'GRUOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_GOTD_INS', 'GRUOT.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_GOTD_MOD', 'GRUOT.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_GOTD_ELI', 'GRUOT.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_GOTD_SEL', 'GRUOT.1', 'no');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CONIG_INS', 'CONGASCUE');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CONIG_MOD', 'CONGASCUE');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CONIG_ELI', 'CONGASCUE');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CONIG_SEL', 'CONGASCUE');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CONIGPP_SEL', 'CONGASCUE');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CATCMB_SEL', 'CONGASCUE');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'SEG_SUBSIS_SEL', 'CONGASCUE.2');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_PACATI_SEL', 'CONGASCUE.2');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CAT_INS', 'CONGASCUE.2');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CAT_MOD', 'CONGASCUE.2');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CAT_ELI', 'CONGASCUE.2');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CAT_SEL', 'CONGASCUE.2');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CATCMB_SEL', 'CONGASCUE.2');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'CONTA_TIPRELCO_SEL', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'CONTA_RELCON_INS', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'CONTA_RELCON_MOD', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'CONTA_RELCON_ELI', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'CONTA_RELCON_SEL', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_GES_SEL', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CEC_SEL', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CECCOM_SEL', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CECCOMFU_SEL', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CCFILDEP_SEL', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CONIG_INS', 'CONGASCUE');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CONIG_MOD', 'CONGASCUE');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CONIG_ELI', 'CONGASCUE');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CONIG_SEL', 'CONGASCUE');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CONIGPP_SEL', 'CONGASCUE');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CATCMB_SEL', 'CONGASCUE');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'SEG_SUBSIS_SEL', 'CONGASCUE.2');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_PACATI_SEL', 'CONGASCUE.2');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CAT_INS', 'CONGASCUE.2');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CAT_MOD', 'CONGASCUE.2');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CAT_ELI', 'CONGASCUE.2');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CAT_SEL', 'CONGASCUE.2');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CATCMB_SEL', 'CONGASCUE.2');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'CONTA_TIPRELCO_SEL', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'CONTA_RELCON_INS', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'CONTA_RELCON_MOD', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'CONTA_RELCON_ELI', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'CONTA_RELCON_SEL', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_GES_SEL', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CEC_SEL', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CECCOM_SEL', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CECCOMFU_SEL', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CCFILDEP_SEL', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'CONTA_RELCON_INS', 'RELCONGEN.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'CONTA_RELCON_MOD', 'RELCONGEN.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'CONTA_RELCON_ELI', 'RELCONGEN.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'CONTA_RELCON_SEL', 'RELCONGEN.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'PM_GES_SEL', 'RELCONGEN.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_MONEDA_SEL', 'RELCCCB');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_INSTIT_SEL', 'RELCCCB');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CTABAN_INS', 'RELCCCB');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CTABAN_MOD', 'RELCCCB');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CTABAN_ELI', 'RELCCCB');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CTABAN_SEL', 'RELCCCB');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_TIPRELCO_SEL', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_INS', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_MOD', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_ELI', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_SEL', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_GES_SEL', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CEC_SEL', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CECCOM_SEL', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CECCOMFU_SEL', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CCFILDEP_SEL', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CHQ_SEL', 'RELCCCB.2');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CHQ_INS', 'RELCCCB.2');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CHQ_MOD', 'RELCCCB.2');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CHQ_ELI', 'RELCCCB.2');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSONMIN_SEL', 'RELCCCB.3');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_SEL', 'RELCCCB.3');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_INSTIT_INS', 'RELCCCB.3');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_INSTIT_MOD', 'RELCCCB.3');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_INSTIT_ELI', 'RELCCCB.3');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_INSTIT_SEL', 'RELCCCB.3');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSONMIN_SEL', 'RELCCCB.3.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_ELI', 'RELCCCB.3.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_MOD', 'RELCCCB.3.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_INS', 'RELCCCB.3.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_UPFOTOPER_MOD', 'RELCCCB.3.1.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_MONEDA_SEL', 'RELCCCB');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_INSTIT_SEL', 'RELCCCB');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CTABAN_INS', 'RELCCCB');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CTABAN_MOD', 'RELCCCB');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CTABAN_ELI', 'RELCCCB');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CTABAN_SEL', 'RELCCCB');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_TIPRELCO_SEL', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_INS', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_MOD', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_ELI', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_SEL', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_GES_SEL', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CEC_SEL', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CECCOM_SEL', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CECCOMFU_SEL', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CCFILDEP_SEL', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CHQ_SEL', 'RELCCCB.2');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CHQ_INS', 'RELCCCB.2');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CHQ_MOD', 'RELCCCB.2');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CHQ_ELI', 'RELCCCB.2');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSONMIN_SEL', 'RELCCCB.3');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_SEL', 'RELCCCB.3');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_INSTIT_INS', 'RELCCCB.3');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_INSTIT_MOD', 'RELCCCB.3');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_INSTIT_ELI', 'RELCCCB.3');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_INSTIT_SEL', 'RELCCCB.3');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSONMIN_SEL', 'RELCCCB.3.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_ELI', 'RELCCCB.3.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_MOD', 'RELCCCB.3.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_INS', 'RELCCCB.3.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_UPFOTOPER_MOD', 'RELCCCB.3.1.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CONIG_INS', 'CONGASCUE');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CONIG_MOD', 'CONGASCUE');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CONIG_ELI', 'CONGASCUE');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CONIG_SEL', 'CONGASCUE');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CONIGPP_SEL', 'CONGASCUE');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CATCMB_SEL', 'CONGASCUE');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'SEG_SUBSIS_SEL', 'CONGASCUE.2');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_PACATI_SEL', 'CONGASCUE.2');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CAT_INS', 'CONGASCUE.2');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CAT_MOD', 'CONGASCUE.2');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CAT_ELI', 'CONGASCUE.2');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CAT_SEL', 'CONGASCUE.2');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CATCMB_SEL', 'CONGASCUE.2');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'CONTA_TIPRELCO_SEL', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'CONTA_RELCON_INS', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'CONTA_RELCON_MOD', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'CONTA_RELCON_ELI', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'CONTA_RELCON_SEL', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_GES_SEL', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CEC_SEL', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CECCOM_SEL', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CECCOMFU_SEL', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CCFILDEP_SEL', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_MONEDA_SEL', 'RELCCCB');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_INSTIT_SEL', 'RELCCCB');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CTABAN_INS', 'RELCCCB');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CTABAN_MOD', 'RELCCCB');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CTABAN_ELI', 'RELCCCB');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CTABAN_SEL', 'RELCCCB');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_TIPRELCO_SEL', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_INS', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_MOD', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_ELI', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_SEL', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_GES_SEL', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CEC_SEL', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CECCOM_SEL', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CECCOMFU_SEL', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CCFILDEP_SEL', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CHQ_SEL', 'RELCCCB.2');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CHQ_INS', 'RELCCCB.2');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CHQ_MOD', 'RELCCCB.2');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CHQ_ELI', 'RELCCCB.2');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSONMIN_SEL', 'RELCCCB.3');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_SEL', 'RELCCCB.3');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_INSTIT_INS', 'RELCCCB.3');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_INSTIT_MOD', 'RELCCCB.3');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_INSTIT_ELI', 'RELCCCB.3');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_INSTIT_SEL', 'RELCCCB.3');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSONMIN_SEL', 'RELCCCB.3.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_ELI', 'RELCCCB.3.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_MOD', 'RELCCCB.3.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_INS', 'RELCCCB.3.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_UPFOTOPER_MOD', 'RELCCCB.3.1.1');


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


