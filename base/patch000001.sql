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



/***********************************I-SCP-RAC-CONTA-0-15/07/2013****************************************/

CREATE TABLE conta.tint_comprobante(
	id_int_comprobante SERIAL NOT NULL,
	id_clase_comprobante int4 NOT NULL,
	id_int_comprobante_fk int4 NOT NULL,
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
	CONSTRAINT pk_tcomprobante__id_int_comprobante PRIMARY KEY (id_int_comprobante)
) INHERITS (pxp.tbase) WITHOUT OIDS;

ALTER TABLE conta.tcomprobante OWNER TO postgres;

ALTER TABLE conta.tplantilla_comprobante
  ADD COLUMN id_clase_comprobante INTEGER;

ALTER TABLE conta.tplantilla_comprobante
  ADD COLUMN id_subsistema INTEGER;

ALTER TABLE conta.tint_comprobante
  ALTER COLUMN id_clase_comprobante DROP NOT NULL;
 
 ALTER TABLE conta.tint_comprobante
  ALTER COLUMN id_int_comprobante_fk DROP NOT NULL;
 
ALTER TABLE conta.tdetalle_plantilla_comprobante
  ADD COLUMN primaria VARCHAR(4) DEFAULT 'si' NOT NULL;
 

 
  
/***********************************F-SCP-RAC-CONTA-0-15/07/2013****************************************/



/***********************************I-SCP-RAC-CONTA-0-02/08/2013****************************************/

ALTER TABLE conta.tdetalle_plantilla_comprobante
  ADD COLUMN otros_campos VARCHAR(250); 
  
ALTER TABLE conta.tplantilla_comprobante
  ADD COLUMN otros_campos VARCHAR(250); 
  
ALTER TABLE conta.tplantilla_comprobante
  ADD COLUMN campo_gestion_relacion VARCHAR(255);
  
/***********************************F-SCP-RAC-CONTA-0-02/08/2013****************************************/


/***********************************I-SCP-RCM-CONTA-18-29/08/2013*****************************************/
CREATE TABLE conta.ttransaccion(
  id_transaccion  SERIAL NOT NULL,
  id_comprobante int4 NOT NULL, 
  id_cuenta int4 NOT NULL,
  id_auxiliar int4 NOT NULL, 
  id_centro_costo int4 NOT NULL, 
  id_partida int4, 
  id_partida_ejecucion int4, 
  id_transaccion_fk int4 NOT NULL, 
  glosa varchar(1000),
  CONSTRAINT pk_ttransaccion__id_transaccion PRIMARY KEY (id_transaccion)
) INHERITS (pxp.tbase)
WITH OIDS;

CREATE TABLE conta.ttrans_val(
  id_trans_val  SERIAL NOT NULL,
  id_transaccion int4 NOT NULL, 
  id_moneda int4, 
  importe_debe numeric(19, 2), 
  importe_haber numeric(19, 2), 
  importe_recurso numeric(19, 2), 
  importe_gasto numeric(19, 2), 
  CONSTRAINT pk_ttrans_val__id_trans_val PRIMARY KEY (id_trans_val)
) INHERITS(pxp.tbase)
WITH OIDS;


CREATE TABLE conta.tplantilla_calculo (
  id_plantilla_calculo SERIAL, 
  id_plantilla INTEGER NOT NULL, 
  codigo_tipo_relacion VARCHAR(10),
  prioridad integer NOT NULL, 
  debe_haber varchar(5) NOT NULL, 
  importe NUMERIC(18,2) NOT NULL, 
  descripcion VARCHAR(50), 
  tipo_importe VARCHAR(15) NOT NULL, 
  CONSTRAINT tplantilla_calculo__id_plantilla_calculo PRIMARY KEY(id_plantilla_calculo), 
  CONSTRAINT chk_tplantilla_calculo__prioridad CHECK (prioridad between 1 and 3), 
  CONSTRAINT chk_tplantilla_calculo__debe_haber CHECK (debe_haber in ('debe','haber')),
  CONSTRAINT chk_tplantilla_calculo__tipo_importe CHECK (tipo_importe in ('porcentaje','importe'))
) INHERITS(pxp.tbase) 
WITHOUT OIDS;


alter table conta.tcomprobante
add column nro_tramite varchar(70);

alter table conta.tint_comprobante
add column nro_tramite varchar(70);

CREATE TABLE conta.tint_transaccion(
  id_int_transaccion  SERIAL NOT NULL,
  id_int_comprobante int4 NOT NULL, 
  id_cuenta int4 NOT NULL,
  id_auxiliar int4 NOT NULL, 
  id_centro_costo int4 NOT NULL, 
  id_partida int4, 
  id_partida_ejecucion int4, 
  id_int_transaccion_fk int4, 
  glosa varchar(1000),
  importe_debe numeric(18, 2), 
  importe_haber numeric(18, 2), 
  importe_recurso numeric(18, 2), 
  importe_gasto numeric(18, 2),
  importe_debe_mb numeric(18, 2), 
  importe_haber_mb numeric(18, 2), 
  importe_recurso_mb numeric(18, 2), 
  importe_gasto_mb numeric(18, 2),
  CONSTRAINT pk_tint_transaccion__id_int_transaccion PRIMARY KEY (id_int_transaccion)
) INHERITS (pxp.tbase)
WITH OIDS;

alter table conta.tcomprobante
add column id_int_comprobante integer not null;

alter table conta.ttransaccion
add column id_int_transaccion integer not null;

ALTER TABLE conta.tcomprobante
  ALTER COLUMN id_comprobante_fk DROP NOT NULL;
  
ALTER TABLE conta.ttransaccion
  ALTER COLUMN id_transaccion_fk DROP NOT NULL;

/***********************************F-SCP-RCM-CONTA-18-29/08/2013*****************************************/



/***********************************I-SCP-RAC-CONTA-0-03/09/2013****************************************/

ALTER TABLE conta.trelacion_contable
  ALTER COLUMN id_cuenta DROP NOT NULL;
  
/***********************************F-SCP-RAC-CONTA-0-03/09/2013****************************************/


/***********************************I-SCP-RAC-CONTA-0-04/09/2013****************************************/

ALTER TABLE conta.tdetalle_plantilla_comprobante
  ALTER COLUMN aplicar_documento TYPE VARCHAR(3);
  
ALTER TABLE conta.tdetalle_plantilla_comprobante
  ALTER COLUMN aplicar_documento SET DEFAULT 'no';
  
ALTER TABLE conta.tdetalle_plantilla_comprobante
  ADD COLUMN campo_partida_ejecucion TEXT; 
  
--------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ADD COLUMN id_detalle_plantilla_comprobante INTEGER;

COMMENT ON COLUMN conta.tint_transaccion.id_detalle_plantilla_comprobante
IS 'Hace referencia a la a la plantilla que origino esta transaccion, tambien sirve para agrupar transacciones de la misma clase';  

--------------- SQL ---------------

ALTER TABLE conta.tplantilla_calculo
  ADD COLUMN importe_presupuesto NUMERIC(18,2) DEFAULT 0 NOT NULL;

ALTER TABLE conta.tdetalle_plantilla_comprobante
  ADD COLUMN mensaje_error VARCHAR(250);

ALTER TABLE conta.tdetalle_plantilla_comprobante
  ADD COLUMN descripcion varchar(250) DEFAULT 'Transaccion de plantilla';   
  
ALTER TABLE conta.tdetalle_plantilla_comprobante
  ALTER COLUMN descripcion SET NOT NULL;  


  
 

ALTER TABLE conta.tdetalle_plantilla_comprobante
  ADD COLUMN campo_monto_pres VARCHAR(255);

COMMENT ON COLUMN conta.tdetalle_plantilla_comprobante.campo_monto_pres
IS '''sirve para configurar el origen del monsto que figura como ejecucion para trasaccion''';

ALTER TABLE conta.tdetalle_plantilla_comprobante
  ADD COLUMN id_detalle_plantilla_fk INTEGER;

ALTER TABLE conta.tdetalle_plantilla_comprobante
  ADD COLUMN forma_calculo_monto VARCHAR(50);

COMMENT ON COLUMN conta.tdetalle_plantilla_comprobante.forma_calculo_monto
IS 'define la forma en que se calcula el monto de la trasaccion

simple ->  directo valor por defecto usado en primarias
diferencia ->  solo para secunadaria calcula la diferencia entre debe y haber
descuento -> solo para trasaccion secundaria o superior,  aplica en el monto, y los decuenta a la trasaccion padre';

ALTER TABLE conta.tdetalle_plantilla_comprobante
  ALTER COLUMN forma_calculo_monto SET DEFAULT 'simple';

ALTER TABLE conta.tdetalle_plantilla_comprobante
  ALTER COLUMN forma_calculo_monto SET NOT NULL;

ALTER TABLE conta.trelacion_contable
  ADD COLUMN defecto VARCHAR(3) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN conta.trelacion_contable.defecto
IS 'rsta columna sirve para identificar el registro como valor por defecto para el tipo de relacion contable y la gestion. Esto permite resumir la cantidad de parametrizaciones';


/***********************************F-SCP-RAC-CONTA-0-04/09/2013****************************************/
  

/***********************************I-SCP-RAC-CONTA-0-11/09/2013****************************************/

ALTER TABLE conta.tclase_comprobante
  ADD COLUMN codigo VARCHAR(50);
 
ALTER TABLE conta.tclase_comprobante
  ALTER COLUMN codigo SET NOT NULL;

ALTER TABLE conta.tclase_comprobante
  ADD UNIQUE (codigo); 
  
ALTER TABLE conta.tint_comprobante
  ADD COLUMN funcion_comprobante_eliminado VARCHAR(200);  
  
ALTER TABLE conta.tint_comprobante
  ADD COLUMN funcion_comprobante_validado VARCHAR(200);  
  
 
  
/***********************************F-SCP-RAC-CONTA-0-11/09/2013****************************************/


/***********************************I-SCP-RAC-CONTA-0-18/09/2013****************************************/

ALTER TABLE conta.tdetalle_plantilla_comprobante
  ADD COLUMN func_act_transaccion VARCHAR(100);

ALTER TABLE conta.tdetalle_plantilla_comprobante
  ADD COLUMN campo_id_tabla_detalle VARCHAR(100);

ALTER TABLE conta.tdetalle_plantilla_comprobante
  ALTER COLUMN campo_id_tabla_detalle SET DEFAULT '';

--------------- SQL ---------------

ALTER TABLE conta.tplantilla_calculo
  ADD COLUMN descuento VARCHAR(3) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN conta.tplantilla_calculo.descuento
IS 'este campo es util para que sistema como e de tesoreria sepan si aplica un decuento o no a las oclicitudes de pago en funcion del tipo de documento escogido';

ALTER TABLE conta.tplantilla_calculo
  ALTER COLUMN codigo_tipo_relacion TYPE VARCHAR(20) COLLATE pg_catalog."default";

ALTER TABLE conta.tplantilla_calculo
  ALTER COLUMN descripcion TYPE VARCHAR(200) COLLATE pg_catalog."default";


--------------- SQL ---------------

CREATE TABLE conta.tint_rel_devengado (
  id_int_rel_devengado SERIAL NOT NULL, 
  id_int_transaccion_dev INTEGER, 
  id_int_transaccion_pag INTEGER, 
  monto_pago NUMERIC(18,2), 
  id_partida_ejecucion_pag INTEGER, 
  PRIMARY KEY(id_int_rel_devengado)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

--------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ADD COLUMN id_partida_ejecucion_dev INTEGER;

----------------------------------------

--------------- SQL ---------------

ALTER TABLE conta.tdetalle_plantilla_comprobante
  ADD COLUMN rel_dev_pago VARCHAR(3) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN conta.tdetalle_plantilla_comprobante.rel_dev_pago
IS 'si el campo es igual a si, indica que la plantilla es para registrar la relacion entre devengado  y pago';



--------------- SQL ---------------

ALTER TABLE conta.tdetalle_plantilla_comprobante
  ADD COLUMN campo_trasaccion_dev TEXT;

COMMENT ON COLUMN conta.tdetalle_plantilla_comprobante.campo_trasaccion_dev
IS 'xste campo siver par aalmacenar la referencia temporal, para tabla de relacion devengado paga';

/***********************************F-SCP-RAC-CONTA-0-18/09/2013****************************************/

/***********************************I-SCP-RAC-CONTA-0-27/09/2013****************************************/


ALTER TABLE conta.tdetalle_plantilla_comprobante
  ADD COLUMN nom_fk_tabla_maestro VARCHAR(80);


/***********************************F-SCP-RAC-CONTA-0-27/09/2013****************************************/


/***********************************I-SCP-RAC-CONTA-0-18/10/2013****************************************/

ALTER TABLE conta.tint_comprobante
  ALTER COLUMN momento SET DEFAULT 'contable';

ALTER TABLE conta.tint_comprobante
  ALTER COLUMN momento SET NOT NULL;


COMMENT ON COLUMN conta.tint_comprobante.momento
IS 'contable o presupuestario';

ALTER TABLE conta.tint_comprobante
  ADD COLUMN momento_comprometido VARCHAR(4) DEFAULT 'no' NOT NULL;
  
ALTER TABLE conta.tint_comprobante
  ADD COLUMN momento_ejecutado VARCHAR(4) DEFAULT 'no' NOT NULL;  

ALTER TABLE conta.tint_comprobante
  ADD COLUMN momento_pagado VARCHAR(4) DEFAULT 'no' NOT NULL;
  
  --------------- SQL ---------------

ALTER TABLE conta.tplantilla_comprobante
  ADD COLUMN momento_comprometido VARCHAR(3) DEFAULT 'no' NOT NULL;

--------------- SQL ---------------

ALTER TABLE conta.tplantilla_comprobante
  ADD COLUMN momento_ejecutado VARCHAR(3) DEFAULT 'no' NOT NULL;

--------------- SQL ---------------

ALTER TABLE conta.tplantilla_comprobante
  ADD COLUMN momento_pagado VARCHAR(3) DEFAULT 'no' NOT NULL;

--------------- SQL ---------------

ALTER TABLE conta.tplantilla_comprobante
  ALTER COLUMN momento_presupuestario SET DEFAULT 'contable';

ALTER TABLE conta.tplantilla_comprobante
  ALTER COLUMN momento_presupuestario SET NOT NULL;
 

--------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ADD COLUMN importe_reversion NUMERIC(18,2) DEFAULT 0 NOT NULL;

COMMENT ON COLUMN conta.tint_transaccion.importe_reversion
IS 'este importe se revierte del comprometido si es mayor a 0, por ejm. util para facturas que solo ejecutan 87 %';

--------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ADD COLUMN factor_reversion NUMERIC(18,2) DEFAULT 0 NOT NULL;

COMMENT ON COLUMN conta.tint_transaccion.factor_reversion
IS 'porcentaje de reversion con repecto al comprometido, sirve para prorratear las cotas de pago con referencian al monto devengado';



--------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ADD COLUMN monto_pagado_revertido NUMERIC(18,2) DEFAULT 0 NOT NULL;

COMMENT ON COLUMN conta.tint_transaccion.monto_pagado_revertido
IS 'Este campo  acumula el monto que falta por descontar en el momento pagado, nuca debe ser mayor que el importe_reversion';


ALTER TABLE conta.tint_transaccion
  ADD COLUMN id_partida_ejecucion_rev INTEGER;

COMMENT ON COLUMN conta.tint_transaccion.id_partida_ejecucion_rev
IS 'elmacena la partida ejecucion del monto revertido';

/***********************************F-SCP-RAC-CONTA-0-18/10/2013****************************************/





