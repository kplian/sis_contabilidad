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
  ADD COLUMN factor_reversion NUMERIC DEFAULT 0 NOT NULL;

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


/***********************************I-SCP-RCM-CONTA-0-25/10/2013****************************************/
alter table conta.ttabla_relacion_contable
add column tabla_id_fk VARCHAR(100);

alter table conta.ttabla_relacion_contable
add column recorrido_arbol VARCHAR(20);
/***********************************F-SCP-RCM-CONTA-0-25/10/2013****************************************/

/***********************************I-SCP-RAC-CONTA-0-30/10/2013****************************************/

CREATE TABLE conta.tcuenta_ids (
  id_cuenta_uno INTEGER NOT NULL, 
  id_cuenta_dos INTEGER NOT NULL, 
  sw_cambio_gestion VARCHAR(10) DEFAULT 'gestion'::character varying, 
  CONSTRAINT tcuenta_ids_pkey PRIMARY KEY(id_cuenta_uno)
) WITHOUT OIDS;

CREATE INDEX tcuenta_ids_idx ON conta.tcuenta_ids
  USING btree (id_cuenta_dos);
  
/***********************************F-SCP-RAC-CONTA-0-30/10/2013****************************************/


/***********************************I-SCP-RAC-CONTA-0-14/11/2013****************************************/

CREATE TABLE conta.tcuenta_partida (
  id_cuenta_partida SERIAL, 
  id_cuenta INTEGER, 
  id_partida INTEGER, 
  sw_deha VARCHAR(10) NOT NULL, 
  se_rega VARCHAR(10) NOT NULL, 
  CONSTRAINT tcuenta_partida_pkey PRIMARY KEY(id_cuenta_partida)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

COMMENT ON COLUMN conta.tcuenta_partida.sw_deha
IS 'debe, haber';

COMMENT ON COLUMN conta.tcuenta_partida.se_rega
IS 'recurso, gasto';

--------------- SQL ---------------



/***********************************F-SCP-RAC-CONTA-0-14/11/2013****************************************/

/***********************************I-SCP-RCM-CONTA-0-21/11/2013****************************************/
ALTER TABLE conta.ttipo_relacion_contable
  ADD COLUMN partida_tipo VARCHAR(25);

ALTER TABLE conta.ttipo_relacion_contable
  ALTER COLUMN partida_tipo SET DEFAULT 'flujo_presupuestaria';

ALTER TABLE conta.ttipo_relacion_contable
  ADD COLUMN partida_rubro VARCHAR(15);

ALTER TABLE conta.ttipo_relacion_contable
  ALTER COLUMN partida_rubro SET DEFAULT 'ingreso_gasto';
/***********************************F-SCP-RCM-CONTA-0-21/11/2013****************************************/


/***********************************I-SCP-RCM-CONTA-0-12/12/2013****************************************/
ALTER TABLE conta.tint_transaccion
  ADD COLUMN id_cuenta_bancaria INTEGER;
  
ALTER TABLE conta.tint_transaccion
  ADD COLUMN id_cuenta_bancaria_mov INTEGER;
/***********************************F-SCP-RCM-CONTA-0-12/12/2013****************************************/

/***********************************I-SCP-RCM-CONTA-0-16/12/2013****************************************/
ALTER TABLE conta.tdetalle_plantilla_comprobante
  ADD COLUMN campo_id_cuenta_bancaria varchar(100);
  
ALTER TABLE conta.tdetalle_plantilla_comprobante
  ADD COLUMN campo_id_cuenta_bancaria_mov varchar(100);
  
ALTER TABLE conta.tdetalle_plantilla_comprobante
  ADD COLUMN campo_nro_cheque VARCHAR(100);
  
ALTER TABLE conta.tplantilla_comprobante
  ADD COLUMN campo_id_cuenta_bancaria VARCHAR(100);
  
ALTER TABLE conta.tplantilla_comprobante
  ADD COLUMN campo_id_cuenta_bancaria_mov VARCHAR(100);
  
ALTER TABLE conta.tplantilla_comprobante
  ADD COLUMN campo_nro_cheque VARCHAR(100);
  
ALTER TABLE conta.tint_transaccion
  ADD COLUMN nro_cheque INTEGER;
  
/***********************************F-SCP-RCM-CONTA-0-16/12/2013****************************************/

/***********************************I-SCP-RCM-CONTA-0-19/12/2013****************************************/
ALTER TABLE conta.trelacion_contable
  ALTER COLUMN fecha_mod DROP DEFAULT;
/***********************************F-SCP-RCM-CONTA-0-19/12/2013****************************************/


/***********************************I-SCP-RAC-CONTA-0-03/01/2014****************************************/
--------------- SQL ---------------

ALTER TABLE conta.ttipo_relacion_contable
  ALTER COLUMN partida_rubro SET DEFAULT 'recurso_gasto'::character varying;

/***********************************F-SCP-RAC-CONTA-0-03/01/2014****************************************/


/***********************************I-SCP-RAC-CONTA-0-08/02/2014****************************************/


--------------- SQL ---------------

COMMENT ON COLUMN conta.tplantilla_comprobante.otros_campos
IS 'Sirve para sacar de la consulta maestro otros campos que pueden ser utilies en las plantilla detalle (para las trasacciones)';

ALTER TABLE conta.tplantilla_comprobante
  ALTER COLUMN otros_campos TYPE VARCHAR(1000) COLLATE pg_catalog."default";


--------------- SQL ---------------

ALTER TABLE conta.tplantilla_comprobante
  ADD COLUMN campo_nro_tramite VARCHAR(350);
  
  
--------------- SQL ---------------

ALTER TABLE conta.tplantilla_comprobante
  ADD COLUMN campo_nro_cuenta_bancaria_trans VARCHAR(350);
   

--------------- SQL ---------------

--------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ADD COLUMN nro_cuenta_bancaria_trans VARCHAR(300);

COMMENT ON COLUMN conta.tint_transaccion.nro_cuenta_bancaria_trans
IS 'Nro de cuenta destino para transferencias bancarias';


--------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ADD COLUMN porc_monto_excento_var NUMERIC(1000,8);

COMMENT ON COLUMN conta.tint_transaccion.porc_monto_excento_var
IS 'Porcentaje para el calculo de montos excentos variable, emeplo utilizado para las facturas electrica dondel no se conoce con exactiud el porcentaje excento de antemoano (antes de la emision del factura)';


--------------- SQL ---------------

ALTER TABLE conta.tdetalle_plantilla_comprobante
  ADD COLUMN campo_nro_cuenta_bancaria_trans VARCHAR(350);

COMMENT ON COLUMN conta.tdetalle_plantilla_comprobante.campo_nro_cuenta_bancaria_trans
IS 'Define el campo desde donde capturamos el nro de cuenta bancarias destino para transferencias';


--------------- SQL ---------------

ALTER TABLE conta.tdetalle_plantilla_comprobante
  ADD COLUMN campo_porc_monto_excento_var VARCHAR(350);

COMMENT ON COLUMN conta.tdetalle_plantilla_comprobante.campo_porc_monto_excento_var
IS 'Aca definimos el porcenta para el monto excento que se aplican a las plantillas de calculo';

  
ALTER TABLE conta.tint_comprobante
  ADD COLUMN id_cuenta_bancaria INTEGER;
  
ALTER TABLE conta.tint_comprobante
  ADD COLUMN id_cuenta_bancaria_mov INTEGER;
  
ALTER TABLE conta.tint_comprobante
  ADD COLUMN nro_cheque INTEGER;
  
ALTER TABLE conta.tint_comprobante
  ADD COLUMN nro_cuenta_bancaria_trans VARCHAR(255);

/***********************************F-SCP-RAC-CONTA-0-08/02/2014****************************************/


/***********************************I-SCP-RCM-CONTA-0-10/02/2014****************************************/
ALTER TABLE conta.tint_transaccion
  ADD COLUMN nombre_cheque_trans VARCHAR(200);

COMMENT ON COLUMN conta.tint_transaccion.nombre_cheque_trans
IS 'Nombre a la cual se emitirá el cheque o transferencia';

ALTER TABLE conta.tdetalle_plantilla_comprobante
  ADD COLUMN campo_nombre_cheque_trans VARCHAR(350);

COMMENT ON COLUMN conta.tdetalle_plantilla_comprobante.campo_nombre_cheque_trans
IS 'Columna para obtener el nombre del cheque o transferencia con la que se hará el pago';

/***********************************F-SCP-RCM-CONTA-0-10/02/2014****************************************/


/***********************************I-SCP-RAC-CONTA-0-11/02/2014****************************************/
ALTER TABLE conta.tint_transaccion
  ALTER COLUMN factor_reversion TYPE NUMERIC;
  
/***********************************F-SCP-RAC-CONTA-0-11/02/2014****************************************/




/***********************************I-SCP-RAC-CONTA-0-24/02/2014****************************************/
--------------- SQL ---------------
ALTER TABLE conta.tint_comprobante
  ADD COLUMN id_plantilla_comprobante INTEGER;
--------------- SQL ---------------
ALTER TABLE conta.tplantilla_calculo
  ALTER COLUMN importe TYPE NUMERIC;
--------------- SQL ---------------
ALTER TABLE conta.tplantilla_calculo
  ALTER COLUMN importe_presupuesto TYPE NUMERIC;
/***********************************F-SCP-RAC-CONTA-0-24/02/2014****************************************/


/***********************************I-SCP-RAC-CONTA-0-27/02/2014****************************************/

--------------- SQL ---------------

ALTER TABLE conta.tplantilla_calculo
  ALTER COLUMN importe TYPE NUMERIC;


--------------- SQL ---------------

ALTER TABLE conta.tplantilla_calculo
  ALTER COLUMN importe_presupuesto TYPE NUMERIC;
/***********************************F-SCP-RAC-CONTA-0-27/02/2014****************************************/



/***********************************I-SCP-RAC-CONTA-0-18/07/2014****************************************/

--------------- SQL ---------------

ALTER TABLE conta.ttabla_relacion_contable
  ADD COLUMN tabla_id_auxiliar VARCHAR(100);

COMMENT ON COLUMN conta.ttabla_relacion_contable.tabla_id_auxiliar
IS 'cahe referencia al nombre del campo que contiene el id_auxiliar';

--------------- SQL ---------------

ALTER TABLE conta.ttabla_relacion_contable
  ADD COLUMN tabla_codigo_auxiliar VARCHAR(100);

COMMENT ON COLUMN conta.ttabla_relacion_contable.tabla_codigo_auxiliar
IS 'hace referencia al nombre del campo que contiene el codigo del auxiliar';


--------------- SQL ---------------

ALTER TABLE conta.ttipo_relacion_contable
  ALTER COLUMN tiene_auxiliar TYPE VARCHAR(20) COLLATE pg_catalog."default";

/***********************************F-SCP-RAC-CONTA-0-18/07/2014****************************************/


/***********************************I-SCP-RAC-CONTA-0-22/07/2014****************************************/

--------------- SQL ---------------

ALTER TABLE conta.tdetalle_plantilla_comprobante
  ADD COLUMN prioridad_documento INTEGER DEFAULT 2 NOT NULL;

/***********************************F-SCP-RAC-CONTA-0-22/07/2014****************************************/


/***********************************I-SCP-RAC-CONTA-0-04/09/2014****************************************/

--------------- SQL ---------------

ALTER TABLE conta.tdetalle_plantilla_comprobante
  ADD COLUMN campo_orden_trabajo VARCHAR(350);

COMMENT ON COLUMN conta.tdetalle_plantilla_comprobante.campo_orden_trabajo
IS 'este campo hace referencia al id_orden_trabajo';


--------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ADD COLUMN id_orden_trabajo INTEGER;
  
  
--------------- SQL ---------------

ALTER TABLE conta.ttransaccion
  ADD COLUMN id_orden_trabajo INTEGER;  

/***********************************F-SCP-RAC-CONTA-0-04/09/2014****************************************/




/***********************************I-SCP-RAC-CONTA-0-11/09/2014****************************************/

--------------- SQL ---------------

ALTER TABLE param.tconcepto_ingas
  ADD COLUMN requiere_ot VARCHAR(20) DEFAULT 'opcional' NOT NULL;

COMMENT ON COLUMN param.tconcepto_ingas.requiere_ot
IS 'obligatorio, opcional';

--------------- SQL ---------------

ALTER TABLE param.tconcepto_ingas
  ADD COLUMN filtro_ot VARCHAR(25) DEFAULT 'todos' NOT NULL;

COMMENT ON COLUMN param.tconcepto_ingas.filtro_ot
IS 'todos, listado  , si es listado filtra atravez de la relacion ot_concepto_gasto';


/***********************************F-SCP-RAC-CONTA-0-11/09/2014****************************************/




/***********************************I-SCP-RAC-CONTA-0-02/10/2014****************************************/

--------------- SQL ---------------

ALTER TABLE conta.tdetalle_plantilla_comprobante
  ADD COLUMN campo_forma_pago VARCHAR(350);

COMMENT ON COLUMN conta.tdetalle_plantilla_comprobante.campo_forma_pago
IS 'este campo carga los valores cheque o transferencia';

--------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ADD COLUMN forma_pago VARCHAR(100);

COMMENT ON COLUMN conta.tint_transaccion.forma_pago
IS 'cheque o transferencia';



/***********************************F-SCP-RAC-CONTA-0-02/10/2014****************************************/




/***********************************I-SCP-RAC-CONTA-0-05/10/2014****************************************/

--------------- SQL ---------------

CREATE TABLE conta.tgrupo_ot (
  id_grupo_ot SERIAL,
  descripcion VARCHAR(500),
  PRIMARY KEY(id_grupo_ot)
) INHERITS (pxp.tbase)
;

ALTER TABLE conta.tgrupo_ot
  OWNER TO postgres;
  
--------------- SQL ---------------

CREATE TABLE conta.tgrupo_ot_det (
  id_grupo_ot_det SERIAL,
  id_grupo_ot INTEGER,
  id_orden_trabajo INTEGER,
  PRIMARY KEY(id_grupo_ot_det)
) INHERITS (pxp.tbase)
;

ALTER TABLE conta.tgrupo_ot_det
  OWNER TO postgres; 



/***********************************F-SCP-RAC-CONTA-0-05/10/2014****************************************/


/***********************************I-SCP-RAC-CONTA-0-05/11/2014****************************************/

--------------- SQL ---------------

ALTER TABLE conta.tint_comprobante
  ALTER COLUMN beneficiario TYPE VARCHAR(500) COLLATE pg_catalog."default";

--------------- SQL ---------------

ALTER TABLE conta.tcomprobante
  ALTER COLUMN beneficiario TYPE VARCHAR(500) COLLATE pg_catalog."default";
  
  
/***********************************F-SCP-RAC-CONTA-0-05/11/2014****************************************/




/***********************************I-SCP-RAC-CONTA-0-11/12/2014****************************************/


CREATE TABLE conta.tint_trans_val (
  id_int_trans_val SERIAL,
  id_int_transaccion INTEGER NOT NULL,
  id_moneda INTEGER,
  importe_debe NUMERIC(19,2),
  importe_haber NUMERIC(19,2),
  importe_recurso NUMERIC(19,2),
  importe_gasto NUMERIC(19,2),
  CONSTRAINT pk_ttrans_val__id_int_trans_val PRIMARY KEY(id_int_trans_val)
) INHERITS (pxp.tbase)

WITH (oids = true);


--------------- SQL ---------------

  ALTER TABLE conta.ttransaccion
  ADD COLUMN importe_debe NUMERIC(18,2) DEFAULT 0 NOT NULL;
  
  ALTER TABLE conta.ttransaccion
  ADD COLUMN importe_haber NUMERIC(18,2) DEFAULT 0 NOT NULL;
  
  ALTER TABLE conta.ttransaccion
  ADD COLUMN importe_gasto NUMERIC(18,2) DEFAULT 0 NOT NULL;
  
  ALTER TABLE conta.ttransaccion
  ADD COLUMN importe_recurso NUMERIC(18,2) DEFAULT 0 NOT NULL;
  
  
  
/***********************************F-SCP-RAC-CONTA-0-11/12/2014****************************************/


/***********************************I-SCP-RAC-CONTA-0-15/12/2014****************************************/
--------------- SQL ---------------

ALTER TABLE conta.tclase_comprobante
  ADD COLUMN momento_comprometido VARCHAR(30) DEFAULT 'opcional' NOT NULL;

COMMENT ON COLUMN conta.tclase_comprobante.momento_comprometido
IS 'define si para este comprobante el comprometido es opcional, obligatorio o no_permitido';


ALTER TABLE conta.tclase_comprobante
  ADD COLUMN momento_ejecutado VARCHAR(30) DEFAULT 'opcional' NOT NULL;

COMMENT ON COLUMN conta.tclase_comprobante.momento_ejecutado
IS 'define si para este comprobante el comprometido es opcional, obligatorio o no_permitido';


ALTER TABLE conta.tclase_comprobante
  ADD COLUMN momento_pagado VARCHAR(30) DEFAULT 'opcional' NOT NULL;

COMMENT ON COLUMN conta.tclase_comprobante.momento_pagado
IS 'define si para este comprobante el comprometido es opcional, obligatorio o no_permitido';

--------------- SQL ---------------

COMMENT ON COLUMN conta.tclase_comprobante.tipo_comprobante
IS 'contable o presupuestario,  se refleja en el campo momento de la tabla int_comprobante';

ALTER TABLE conta.tclase_comprobante
  ALTER COLUMN tipo_comprobante SET DEFAULT 'contable';

--------------- SQL ---------------

ALTER TABLE conta.tint_comprobante
  ADD COLUMN manual VARCHAR(5) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN conta.tint_comprobante.manual
IS 'si o no, es un comprobante manual o generado por otros sistemas, los comprobantes generados tienen edicion limitada ..';




/***********************************F-SCP-RAC-CONTA-0-15/12/2014****************************************/

/***********************************I-SCP-RAC-CONTA-0-17/12/2014****************************************/


--------------- SQL ---------------

CREATE TABLE conta.ttipo_relacion_comprobante (
  id_tipo_relacion_comprobante SERIAL,
  codigo VARCHAR(100) NOT NULL,
  nombre VARCHAR(200) NOT NULL,
  PRIMARY KEY(id_tipo_relacion_comprobante)
) INHERITS (pxp.tbase)
;

--------------- SQL ---------------

ALTER TABLE conta.tint_comprobante
  ADD COLUMN id_int_comprobante_fks INTEGER[];


--------------- SQL ---------------

ALTER TABLE conta.tint_comprobante
  ADD COLUMN id_tipo_relacion_comprobante INTEGER;

COMMENT ON COLUMN conta.tint_comprobante.id_tipo_relacion_comprobante
IS 'define el tipo de relacion en tre so comprobantes que sen encuentran en el array id_int_comprobante_fks';


/***********************************F-SCP-RAC-CONTA-0-17/12/2014****************************************/


/***********************************I-SCP-RAC-CONTA-0-15/01/2015****************************************/


ALTER TABLE conta.tint_transaccion
  ALTER COLUMN id_auxiliar DROP NOT NULL;

/***********************************F-SCP-RAC-CONTA-0-15/01/2015****************************************/


/***********************************I-SCP-RAC-CONTA-0-31/03/2015****************************************/

ALTER TABLE conta.tplantilla_comprobante
  ADD COLUMN campo_tipo_cambio VARCHAR(350);
  

  
/***********************************F-SCP-RAC-CONTA-0-31/03/2015****************************************/



/***********************************I-SCP-RAC-CONTA-0-13/04/2015****************************************/

ALTER TABLE conta.ttransaccion
  ALTER COLUMN glosa TYPE VARCHAR COLLATE pg_catalog."default";
  
--------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ALTER COLUMN glosa TYPE VARCHAR COLLATE pg_catalog."default";

/***********************************F-SCP-RAC-CONTA-0-13/04/2015****************************************/


/***********************************I-SCP-RAC-CONTA-0-16/04/2015****************************************/

--------------- SQL ---------------

ALTER TABLE conta.tint_comprobante
  ADD COLUMN id_depto_libro INTEGER;

COMMENT ON COLUMN conta.tint_comprobante.id_depto_libro
IS 'departamento de libro de bancos';


--------------- SQL ---------------

ALTER TABLE conta.tplantilla_comprobante
  ADD COLUMN campo_depto_libro TEXT;

COMMENT ON COLUMN conta.tplantilla_comprobante.campo_depto_libro
IS 'este campo es para definir el depto de libro de bancos del comprobante';

/***********************************F-SCP-RAC-CONTA-0-16/04/2015****************************************/




/***********************************I-SCP-RAC-CONTA-0-05/05/2015****************************************/


--------------- SQL ---------------

ALTER TABLE conta.ttransaccion
  ALTER COLUMN id_auxiliar DROP NOT NULL;
  
/***********************************F-SCP-RAC-CONTA-0-05/05/2015****************************************/

/***********************************I-SCP-GSS-CONTA-0-07/05/2015****************************************/

ALTER TABLE conta.tcomprobante
  ADD COLUMN id_depto_libro INTEGER;

COMMENT ON COLUMN conta.tcomprobante.id_depto_libro
IS 'identifica el depto de libro de banco';

ALTER TABLE conta.tplantilla_comprobante
  ADD COLUMN campo_depto_libro TEXT;

COMMENT ON COLUMN conta.tplantilla_comprobante.campo_depto_libro
IS 'este campo es para definir el depto de libro de bancos del comprobante';

/***********************************F-SCP-GSS-CONTA-0-07/05/2015****************************************/




/***********************************I-SCP-RAC-CONTA-0-07/05/2015****************************************/

--------------- SQL ---------------

DROP TRIGGER f_trig_insert_int_trans_val ON conta.tint_transaccion;
--------------- SQL ---------------

DROP TABLE conta.tint_trans_val;

/***********************************F-SCP-RAC-CONTA-0-07/05/2015****************************************/




/***********************************I-SCP-RAC-CONTA-0-03/06/2015****************************************/

--------------- SQL ---------------

ALTER TABLE conta.tconfig_tipo_cuenta
  ADD COLUMN incremento VARCHAR(10) DEFAULT 'debe' NOT NULL;

COMMENT ON COLUMN conta.tconfig_tipo_cuenta.incremento
IS 'la cuenta se incrementa al debe o al haber';

--------------- SQL ---------------

ALTER TABLE conta.tcuenta
  ADD COLUMN valor_incremento VARCHAR(10) DEFAULT 'positivo' NOT NULL;

COMMENT ON COLUMN conta.tcuenta.valor_incremento
IS 'positivo o negativo, caso depresiacion acumulado es negativo';

--------------- SQL ---------------

ALTER TABLE conta.tcuenta
  ADD COLUMN eeff VARCHAR(15) DEFAULT 'defecto' NOT NULL;

COMMENT ON COLUMN conta.tcuenta.eeff
IS 'defecto, (toma valor de config del tipo), resultado o balance';

--------------- SQL ---------------

ALTER TABLE conta.tconfig_tipo_cuenta
  DROP CONSTRAINT chk_tconfig_tipo_cuenta__tipo_cuenta RESTRICT;
  
  
/***********************************F-SCP-RAC-CONTA-0-03/06/2015****************************************/


/***********************************I-SCP-RAC-CONTA-0-15/06/2015****************************************/


--------------- SQL ---------------

ALTER TABLE conta.tconfig_tipo_cuenta
  ADD COLUMN eeff VARCHAR(20)[] DEFAULT '{"balance"}' NOT NULL;

COMMENT ON COLUMN conta.tconfig_tipo_cuenta.eeff
IS 'array que permite configurar el valor por defecto de la cuenta balance, resultado, ... otro que pudieran aparecer';


ALTER TABLE conta.tcuenta
  DROP COLUMN eeff;
  
  
 --------------- SQL ---------------

ALTER TABLE conta.tcuenta
  ADD COLUMN eeff VARCHAR(20)[] DEFAULT '{balance}' NOT NULL; 
 

/***********************************F-SCP-RAC-CONTA-0-15/06/2015****************************************/


/***********************************I-SCP-RAC-CONTA-0-07/07/2015****************************************/


select pxp.f_insert_tgui ('Reportes', 'Reportes', 'REPCON', 'si', 10, '', 2, '', '', 'CONTA');
select pxp.f_insert_tgui ('Balance de cuentas', 'Balance general', 'BALCON', 'si', 1, 'sis_contabilidad/vista/cuenta/FormFiltroBalance.php', 3, '', 'FormFiltroBalance', 'CONTA');


select pxp.f_insert_testructura_gui ('REPCON', 'CONTA');
select pxp.f_insert_testructura_gui ('BALCON', 'REPCON');

/***********************************F-SCP-RAC-CONTA-0-07/07/2015****************************************/



/***********************************I-SCP-RAC-CONTA-0-08/07/2015****************************************/
--------------- SQL ---------------

CREATE TABLE conta.tresultado_plantilla (
  id_resultado_plantilla SERIAL NOT NULL,
  codigo VARCHAR(100),
  nombre VARCHAR,
  PRIMARY KEY(id_resultado_plantilla)
) INHERITS (pxp.tbase);



--------------- SQL ---------------

CREATE TABLE conta.tresultado_det_plantilla (
  id_resultado_det_plantilla SERIAL,
  origen VARCHAR(20) DEFAULT 'balance' NOT NULL,
  formula VARCHAR,
  subrayar VARCHAR(3) DEFAULT 'si',
  font_size VARCHAR DEFAULT 10,
  posicion VARCHAR DEFAULT 'left',
  signo VARCHAR(15) DEFAULT 'positivo',
  nivel_detalle INTEGER DEFAULT 1,
  codigo_cuenta VARCHAR,
  codigo VARCHAR,
  orden NUMERIC NOT NULL,
  nombre_variable VARCHAR,
  montopos INTEGER,
  PRIMARY KEY(id_resultado_det_plantilla)
) INHERITS (pxp.tbase)
;

ALTER TABLE conta.tresultado_det_plantilla
  OWNER TO postgres;

COMMENT ON COLUMN conta.tresultado_det_plantilla.origen
IS 'balance(balance de la cuenta), detalle (listado segun nivel, y balance de los detalles), titulo (Solo titulo sin monto), formula (aplica la suma de varios campos)';

COMMENT ON COLUMN conta.tresultado_det_plantilla.posicion
IS 'left  center rihgt';

COMMENT ON COLUMN conta.tresultado_det_plantilla.signo
IS 'signo que v apor delante el texto';

COMMENT ON COLUMN conta.tresultado_det_plantilla.nivel_detalle
IS 'nivel del detalle en caso de que el origen sea detalle';

COMMENT ON COLUMN conta.tresultado_det_plantilla.codigo_cuenta
IS 'codigo de la cuenta contable raiz';

COMMENT ON COLUMN conta.tresultado_det_plantilla.codigo
IS 'codigo de registros se utiliza en las formulas';

COMMENT ON COLUMN conta.tresultado_det_plantilla.orden
IS 'orden en el que aparecen en el reprote ademas de ser el orden de evaluacion';

COMMENT ON COLUMN conta.tresultado_det_plantilla.nombre_variable
IS 'nombre que aparece en el texto, si se especifica prevalece sobre el nombre de la cuenta';

COMMENT ON COLUMN conta.tresultado_det_plantilla.montopos
IS 'posicion en que va el monto, 1, 2 o 3';


--------------- SQL ---------------

ALTER TABLE conta.tresultado_det_plantilla
  ADD COLUMN id_resultado_plantilla INTEGER NOT NULL;

--------------- SQL ---------------

ALTER TABLE conta.tresultado_det_plantilla
  ALTER COLUMN signo SET DEFAULT '+'::character varying;

/***********************************F-SCP-RAC-CONTA-0-08/07/2015****************************************/


/***********************************I-SCP-RAC-CONTA-0-13/07/2015****************************************/


--------------- SQL ---------------

ALTER TABLE conta.tint_comprobante
  ADD COLUMN cbte_cierre VARCHAR(20) DEFAULT 'no' NOT NULL;


--------------- SQL ---------------

COMMENT ON COLUMN conta.tint_comprobante.cbte_cierre
IS 'no, balance, resultado, si es o no un comprobante de cierres, (peude ser ciere de balance o cierre de resutlados), los comprobantes de cierre netean las cuentas, por esto es encesario identificarlo para incluirlos o no en algunos reportes';


/***********************************F-SCP-RAC-CONTA-0-13/07/2015****************************************/

