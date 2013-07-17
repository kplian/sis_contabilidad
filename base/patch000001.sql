/***********************************I-SCP-RAC-CONTA-1-04/02/2013****************************************/
CREATE TABLE conta.tconfig_tipo_cuenta(
    id_cofig_tipo_cuenta SERIAL NOT NULL,
    nro_base int4,
    tipo_cuenta varchar,
    CONSTRAINT chk_tconfig_tipo_cuenta__tipo_cuenta CHECK ((tipo_cuenta)::text = ANY (ARRAY[('activo'::character varying)::text, ('pasivo'::character varying)::text, ('patrimonio'::character varying)::text, ('ingreso'::character varying)::text, ('gasto'::character varying)::text])), 
    PRIMARY KEY (id_cofig_tipo_cuenta))
    INHERITS (pxp.tbase);
  
/***********************************F-SCP-RAC-CONTA-1-04/02/2013****************************************/

/***********************************I-SCP-GSS-CONTA-48-20/02/2013****************************************/

CREATE TABLE conta.tcuenta (
  id_cuenta SERIAL, 
  id_empresa INTEGER, 
  id_parametro INTEGER, 
  id_cuenta_padre INTEGER, 
  nro_cuenta VARCHAR(20), 
  id_gestion INTEGER, 
  id_moneda INTEGER, 
  nombre_cuenta VARCHAR(100), 
  desc_cuenta VARCHAR(500), 
  nivel_cuenta INTEGER, 
  tipo_cuenta VARCHAR(30), 
  sw_transaccional VARCHAR(10), 
  sw_oec INTEGER, 
  sw_auxiliar VARCHAR(2), 
  tipo_cuenta_pat VARCHAR(20), 
  cuenta_sigma VARCHAR(100), 
  sw_sigma VARCHAR(2), 
  id_cuenta_actualizacion INTEGER, 
  id_auxliar_actualizacion INTEGER, 
  sw_sistema_actualizacion VARCHAR(12), 
  id_cuenta_dif INTEGER, 
  id_auxiliar_dif INTEGER, 
  id_cuenta_sigma INTEGER, 
  cuenta_flujo_sigma VARCHAR(50), 
  CONSTRAINT pk_tcuenta__id_cuenta PRIMARY KEY(id_cuenta), 
  CONSTRAINT chk_tcuenta__tipo_cuenta CHECK ((tipo_cuenta)::text = ANY (ARRAY[('activo'::character varying)::text, ('pasivo'::character varying)::text, ('patrimonio'::character varying)::text, ('ingreso'::character varying)::text, ('gasto'::character varying)::text])), 
  CONSTRAINT chk_tcuenta__tipo_cuenta_pat CHECK ((tipo_cuenta_pat)::text = ANY (ARRAY[('capital'::character varying)::text, ('reserva'::character varying)::text]))
) INHERITS (pxp.tbase)
WITHOUT OIDS;

    
ALTER TABLE conta.tcuenta OWNER TO postgres;  

--tabla conta.tauxiliar

CREATE TABLE conta.tauxiliar (
  id_auxiliar SERIAL NOT NULL, 
  id_empresa INTEGER, 
  codigo_auxiliar VARCHAR(15), 
  nombre_auxiliar VARCHAR(300), 
  CONSTRAINT pk_tauxiliar__id_auxiliar PRIMARY KEY(id_auxiliar)
) INHERITS (pxp.tbase)
WITHOUT OIDS; 

ALTER TABLE conta.tauxiliar OWNER TO postgres;

--tabla conta.tauxiliar

CREATE TABLE conta.torden_trabajo (
  id_orden_trabajo SERIAL NOT NULL, 
  desc_orden VARCHAR(100), 
  motivo_orden VARCHAR(500), 
  fecha_inicio DATE, 
  fecha_final DATE, 
  CONSTRAINT pk_torden_trabajo__id_orden_trabajo PRIMARY KEY(id_orden_trabajo)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

ALTER TABLE conta.tauxiliar OWNER TO postgres;

/***********************************F-SCP-GSS-CONTA-48-20/02/2013****************************************/

/***********************************I-SCP-RAC-CONTA-05-29/05/2013****************************************/

CREATE TABLE conta.tclase_comprobante(
    id_clase_comprobante SERIAL NOT NULL,
    id_documento int4,
    descripcion varchar(300),
    tipo_comprobante varchar(300),
    PRIMARY KEY (id_clase_comprobante))
    INHERITS (pxp.tbase);
    
 
    
/***********************************F-SCP-RAC-CONTA-05-29/05/2013****************************************/



/****************************************I-SCP-JRR-CONTA-0-15/05/2013************************************************/

CREATE TABLE conta.ttabla_relacion_contable (
  id_tabla_relacion_contable SERIAL, 
  tabla VARCHAR(100), 
  esquema VARCHAR(15),
  tabla_id VARCHAR(100),
  CONSTRAINT ttabla_relacion_contable_pkey PRIMARY KEY(id_tabla_relacion_contable)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

CREATE TABLE conta.ttipo_relacion_contable (
  id_tipo_relacion_contable SERIAL, 
  nombre_tipo_relacion VARCHAR(200) NOT NULL, 
  codigo_tipo_relacion VARCHAR(15) NOT NULL,
  tiene_centro_costo VARCHAR(10) DEFAULT 'si'::character varying NOT NULL,
  tiene_partida VARCHAR(2) DEFAULT 'si'::character varying NOT NULL,
  tiene_auxiliar VARCHAR(2) DEFAULT 'si'::character varying NOT NULL,
  id_tabla_relacion_contable INTEGER,
  CONSTRAINT ttipo_relacion_contable_pkey PRIMARY KEY(id_tipo_relacion_contable)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

COMMENT ON COLUMN conta.ttipo_relacion_contable.tiene_centro_costo
IS 'si|no|si-general (Esta opción permite registrar el centro de costo pero habilita para que pueda estar vacio en caso de configuraciones generales';

CREATE TABLE conta.trelacion_contable (
  id_relacion_contable SERIAL, 
  id_tipo_relacion_contable INTEGER NOT NULL,
  id_centro_costo INTEGER,
  id_cuenta INTEGER NOT NULL,
  id_auxiliar INTEGER,
  id_partida INTEGER,
  id_gestion INTEGER NOT NULL,
  id_tabla INTEGER,
  CONSTRAINT trelacion_contable_pkey PRIMARY KEY(id_relacion_contable)
) INHERITS (pxp.tbase)
WITHOUT OIDS;
  

/****************************************F-SCP-JRR-CONTA-0-15/05/2013************************************************/

/***********************************I-SCP-GSS-CONTA-9-07/06/2013****************************************/

CREATE TABLE conta.tplantilla_comprobante (
  id_plantilla_comprobante SERIAL,  
  codigo VARCHAR(20),  
  clase_comprobante VARCHAR(255), 
  momento_presupuestario VARCHAR(255), 
  tabla_origen VARCHAR(255), 
  id_tabla VARCHAR(255),
  campo_descripcion TEXT, 
  campo_subsistema TEXT, 
  campo_fecha TEXT,
  campo_moneda TEXT, 
  campo_acreedor TEXT, 
  campo_fk_comprobante TEXT, 
  funcion_comprobante_validado TEXT, 
  funcion_comprobante_eliminado TEXT,
  campo_depto TEXT,
  CONSTRAINT pk_tplantilla_comprobante__id_plantilla_comprobante PRIMARY KEY (id_plantilla_comprobante)
) INHERITS (pxp.tbase)
WITHOUT OIDS;


CREATE TABLE conta.tdetalle_plantilla_comprobante (
  id_detalle_plantilla_comprobante SERIAL, 
  id_plantilla_comprobante INTEGER, 
  tabla_detalle VARCHAR(255), 
  debe_haber VARCHAR(255), 
  campo_monto TEXT, 
  agrupar VARCHAR(255), 
  campo_cuenta TEXT, 
  campo_auxiliar TEXT, 
  campo_partida TEXT, 
  campo_centro_costo TEXT, 
  es_relacion_contable VARCHAR(255), 
  tipo_relacion_contable VARCHAR(255), 
  campo_relacion_contable TEXT, 
  aplicar_documento INTEGER, 
  campo_documento TEXT, 
  campo_fecha TEXT, 
  campo_concepto_transaccion TEXT,
  CONSTRAINT pk_tdetalle_plantilla_comprobante__id_detalle_plantilla_comprob PRIMARY KEY(id_detalle_plantilla_comprobante), 
  CONSTRAINT chk_tdetalle_plantilla_comprobante__debe_haber CHECK ((debe_haber)::text = ANY (ARRAY['debe'::text, 'haber'::text])),
  CONSTRAINT chk_tdetalle_plantilla_comprobante__agrupar CHECK ((agrupar)::text = ANY (ARRAY['si'::text, 'no'::text])), 
  CONSTRAINT chk_tdetalle_plantilla_comprobante__es_relacion_contable CHECK ((es_relacion_contable)::text = ANY (ARRAY['si'::text, 'no'::text]))   
) INHERITS (pxp.tbase)
WITHOUT OIDS;

/***********************************F-SCP-GSS-CONTA-9-07/06/2013****************************************/


/***********************************I-SCP-GSS-CONTA-9-18/06/2013****************************************/

CREATE TABLE conta.tinter_comprobante (
  id_comprobante SERIAL, 
  id_parametro INTEGER, 
  nro_cbte INTEGER, 
  momento_cbte NUMERIC(1,0), 
  fecha_cbte DATE NOT NULL, 
  concepto_cbte VARCHAR(1500), 
  glosa_cbte VARCHAR(1500), 
  acreedor VARCHAR, 
  aprobacion VARCHAR(550), 
  conformidad VARCHAR(1500), 
  pedido VARCHAR(550), 
  id_periodo_subsis INTEGER, 
  id_usuario INTEGER, 
  id_subsistema INTEGER NOT NULL, 
  id_clase_cbte INTEGER, 
  fk_comprobante INTEGER, 
  id_depto INTEGER NOT NULL, 
  nro_cbte_siscon INTEGER, 
  origen VARCHAR, 
  id_moneda INTEGER, 
  nro_cheque TEXT, 
  tipo_cambio NUMERIC(18,6), 
  tipo_relacion VARCHAR(30), 
  sw_activo_fijo VARCHAR(2), 
  sw_actualizacion VARCHAR DEFAULT 'si-no'::character varying, 
  id_documento_firma INTEGER, 
  tipo VARCHAR(20), 
  sw_comprobante_apertura VARCHAR(2) DEFAULT 'no'::character varying, 
  CONSTRAINT pk_tinter_comprobante__id_comprobante PRIMARY KEY(id_comprobante), 
  CONSTRAINT chk_tinter_comprobante__origen CHECK (((((((((((((((((((((((((((origen)::text = 'alta_activo_fijo'::text) OR ((origen)::text = 'depreciacion_activo_fijo'::text)) OR ((origen)::text = 'devengado_diario'::text)) OR ((origen)::text = 'fv_facturacion_mesual'::text)) OR ((origen)::text = 'devengado_pago'::text)) OR ((origen)::text = 'devengado_reg'::text)) OR ((origen)::text = 'duplicado'::text)) OR ((origen)::text = 'finalizacion'::text)) OR ((origen)::text = 'planilla_devengado'::text)) OR ((origen)::text = 'planilla_pago'::text)) OR ((origen)::text = 'plan_pago_anticipo'::text)) OR ((origen)::text = 'plan_pago_devengado'::text)) OR ((origen)::text = 'plan_pago_pago'::text)) OR ((origen)::text = 'rendicion'::text)) OR ((origen)::text = 'reposicion'::text)) OR ((origen)::text = 'solicitud'::text)) OR ((origen)::text = 'sucursal'::text)) OR ((origen)::text = 'kp_planilla_diario_pre'::text)) OR ((origen)::text = 'actualizacion'::text)) OR ((origen)::text = 'kp_planilla_anticipo'::text)) OR ((origen)::text = 'activo_fijo'::text)) OR ((origen)::text = 'kp_planilla_diario_costo'::text)) OR (origen IS NULL)) OR ((origen)::text = 'cierre_apertura'::text)) OR ((origen)::text = 'kp_planilla_obligacion'::text)) OR ((origen)::text = 'comprobante_apertura'::text))
) INHERITS (pxp.tbase)
WITHOUT OIDS;

COMMENT ON COLUMN conta.tinter_comprobante.id_comprobante
IS 'nombre=id_comprobante&label=id_comprobante&grid_visible=no&grid_editable=no&disabled=no&width_grid=100&width=100%&filtro=si&defecto=&desc=id_comprobante''';

COMMENT ON COLUMN conta.tinter_comprobante.id_parametro
IS 'nombre=id_parametro&label=id_parametro&grid_visible=no&grid_editable=no&disabled=si&width_grid=100&width=100%&filtro=si&defecto=&desc=id_parametro''';

COMMENT ON COLUMN conta.tinter_comprobante.nro_cbte
IS 'nombre=nro_cbte&label=Número&grid_visible=si&grid_editable=no&disabled=no&width_grid=100&width=100%&filtro=si&defecto=&desc=nro_cbte''';

COMMENT ON COLUMN conta.tinter_comprobante.momento_cbte
IS '''nombre=momento_cbte&label=Momento&grid_visible=si&grid_editable=no&disabled=no&width_grid=100&width=100%&filtro=si&defecto=&desc=momento_cbte''';

COMMENT ON COLUMN conta.tinter_comprobante.fecha_cbte
IS '''nombre=fecha_cbte&label=Fecha&grid_visible=si&grid_editable=no&disabled=no&width_grid=100&width=100%&filtro=si&defecto=&desc=fecha_cbte''';

COMMENT ON COLUMN conta.tinter_comprobante.concepto_cbte
IS '''nombre=concepto_cbte&label=Concepto&grid_visible=si&grid_editable=no&disabled=no&width_grid=100&width=100%&filtro=si&defecto=&desc=concepto_cbte''';

COMMENT ON COLUMN conta.tinter_comprobante.glosa_cbte
IS '''nombre=glosa_cbte&label=Glosa&grid_visible=si&grid_editable=no&disabled=no&width_grid=100&width=100%&filtro=si&defecto=&desc=glosa_cbte''';

COMMENT ON COLUMN conta.tinter_comprobante.acreedor
IS '''nombre=acreedor&label=Acreedor&grid_visible=si&grid_editable=no&disabled=no&width_grid=100&width=100%&filtro=si&defecto=&desc=acreedor''';

COMMENT ON COLUMN conta.tinter_comprobante.aprobacion
IS '''nombre=aprobacion&label=Aprobación&grid_visible=si&grid_editable=no&disabled=no&width_grid=100&width=100%&filtro=si&defecto=&desc=aprobacion''';

COMMENT ON COLUMN conta.tinter_comprobante.conformidad
IS '''nombre=conformidad&label=Conformidad&grid_visible=si&grid_editable=no&disabled=no&width_grid=100&width=100%&filtro=si&defecto=&desc=conformidad''';

COMMENT ON COLUMN conta.tinter_comprobante.pedido
IS '''nombre=pedido&label=Pedido&grid_visible=si&grid_editable=no&disabled=no&width_grid=100&width=100%&filtro=si&defecto=&desc=pedido''';

COMMENT ON COLUMN conta.tinter_comprobante.id_periodo_subsis
IS '''nombre=id_periodo_subsis&label=Periodo Subsisteam&grid_visible=si&grid_editable=no&disabled=no&width_grid=100&width=100%&filtro=si&defecto=&desc=id_periodo_subsis''';

COMMENT ON COLUMN conta.tinter_comprobante.id_usuario
IS '''nombre=id_usuario&label=Usuario&grid_visible=si&grid_editable=no&disabled=no&width_grid=100&width=100%&filtro=si&defecto=&desc=id_usuario''';

COMMENT ON COLUMN conta.tinter_comprobante.id_subsistema
IS '''nombre=id_subsistema&label=Subsistema&grid_visible=si&grid_editable=no&disabled=no&width_grid=100&width=100%&filtro=si&defecto=&desc=id_subsistema''';

COMMENT ON COLUMN conta.tinter_comprobante.id_clase_cbte
IS '''nombre=id_clase_cbte&label=Documento&grid_visible=si&grid_editable=no&disabled=no&width_grid=100&width=100%&filtro=si&defecto=&desc=id_documento_nro''';

COMMENT ON COLUMN conta.tinter_comprobante.origen
IS '''origen = ''''alta_activo_fijo'''' OR origen = ''''depreciacion_activo_fijo'''' OR origen = ''''devengado_diario'''' OR origen=''''fv_facturacion_mesual'''' or origen = ''''devengado_pago'''' OR origen = ''''devengado_reg'''' OR origen = ''''duplicado'''' OR origen = ''''finalizacion'''' OR origen = ''''planilla_devengado'''' OR origen = ''''planilla_pago'''' OR origen = ''''plan_pago_anticipo'''' OR origen = ''''plan_pago_devengado'''' OR origen = ''''plan_pago_pago'''' OR origen = ''''rendicion'''' OR origen = ''''reposicion'''' OR origen = ''''solicitud'''' OR origen = ''''sucursal'''' OR origen = ''''kp_planilla_diario_pre'''' OR origen = ''''actualizacion'''' OR origen = ''''kp_planilla_anticipo'''' OR origen=''''activo_fijo'''' or origen=''''kp_planilla_diario_costo'''' or origen is NULL or origen =''''cierre_apertura'''' or origen =''''kp_planilla_obligacion''''''';

COMMENT ON COLUMN conta.tinter_comprobante.id_documento_firma
IS '''referencia a las firmas autorizadas que corresponden al momento de la validación del comprobante'';';

/***********************************F-SCP-GSS-CONTA-9-18/06/2013****************************************/

/***********************************I-SCP-RAC-CONTA-0-16/07/2013****************************************/


CREATE TABLE conta.tcuenta_auxiliar(
    id_cuenta_auxiliar SERIAL NOT NULL,
    id_auxiliar int4 NOT NULL,
    id_cuenta int4 NOT NULL,
    PRIMARY KEY (id_cuenta_auxiliar))
INHERITS (pxp.tbase);

/***********************************F-SCP-RAC-CONTA-0-16/07/2013****************************************/

/***********************************I-SCP-RCM-CONTA-0-15/07/2013****************************************/
CREATE TABLE conta.tcomprobante(
	id_comprobante SERIAL NOT NULL,
	id_clase_comprobante int4 NOT NULL,
	id_comprobante_fk int4 NOT NULL,
	id_subsistema int4,
	id_depto int4,
	id_moneda int4,
	id_periodo int4,
	nro_cbte varchar(30),
	momento varchar(30),
	glosa1 varchar(1500),
	glosa2 varchar(400),
	beneficiario varchar(100),
	tipo_cambio numeric(18, 2),
	id_funcionario_firma1 int4,
	id_funcionario_firma2 int4,
	id_funcionario_firma3 int4,
	fecha date,
	CONSTRAINT pk_tcomprobante__id_comprobante PRIMARY KEY (id_comprobante)
) INHERITS (pxp.tbase) WITHOUT OIDS;

ALTER TABLE conta.tcomprobante OWNER TO postgres;

/***********************************F-SCP-RCM-CONTA-0-15/07/2013****************************************/