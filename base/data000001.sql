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
VALUES (1, NULL, E'2013-07-10 17:40:17.829', NULL, E'activo', 2, E'Cuentas Bancarias', E'CUEBANC', E'no', E'no', E'si', 2);

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
/***********************************F-DAT-RCM-CONTA-0-29/08/2013*****************************************/

