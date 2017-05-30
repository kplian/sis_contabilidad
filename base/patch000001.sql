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
  nombre_cuenta VARCHAR(200), 
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

/***********************************F-SCP-GSS-CONTA-0-07/05/2015****************************************/




/***********************************I-SCP-RAC-CONTA-0-07/05/2015****************************************/

--------------- SQL ---------------

--DROP TRIGGER f_trig_insert_int_trans_val ON conta.tint_transaccion;
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



 --------------- SQL ---------------

ALTER TABLE conta.tcuenta
  ADD COLUMN eeff VARCHAR(20)[] DEFAULT '{balance}' NOT NULL; 

COMMENT ON COLUMN conta.tcuenta.eeff
IS 'defecto, (toma valor de config del tipo), resultado o balance'; 

/***********************************F-SCP-RAC-CONTA-0-15/06/2015****************************************/




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

/***********************************I-SCP-RAC-CONTA-0-14/07/2015****************************************/
--------------- SQL ---------------

CREATE TABLE conta.tresultado_dep (
  id_resultado_dep SERIAL NOT NULL,
  id_resultado_plantilla INTEGER,
  prioridad NUMERIC,
  obs VARCHAR,
  PRIMARY KEY(id_resultado_dep)
) INHERITS (pxp.tbase)
;

--------------- SQL ---------------

ALTER TABLE conta.tresultado_det_plantilla
  ADD COLUMN visible VARCHAR(4) DEFAULT 'si' NOT NULL;

COMMENT ON COLUMN conta.tresultado_det_plantilla.visible
IS 'si o no , aparece o no en el reporte';

--------------- SQL ---------------

ALTER TABLE conta.tresultado_det_plantilla
  ADD COLUMN incluir_cierre VARCHAR(15) DEFAULT 'todos' NOT NULL;

COMMENT ON COLUMN conta.tresultado_det_plantilla.incluir_cierre
IS 'todos, resultado, balance,  no, solo_cierre incuye en e calculo deo monto los comprobantes de cierre';

--------------- SQL ---------------

ALTER TABLE conta.tresultado_det_plantilla
  ADD COLUMN incluir_apertura VARCHAR(20) DEFAULT 'todos' NOT NULL;

COMMENT ON COLUMN conta.tresultado_det_plantilla.incluir_apertura
IS 'todo o solo_apertura ,  icluey een el calculo del monto el comprobante de apetura  o hace el calculo solo con apertura,...';


--------------- SQL ---------------

ALTER TABLE conta.tresultado_dep
  ADD COLUMN id_resultado_plantilla_hijo INTEGER NOT NULL;

COMMENT ON COLUMN conta.tresultado_dep.id_resultado_plantilla_hijo
IS 'plantilla que se procesar primero por depedencia segun orden de prioridad';

--------------- SQL ---------------

ALTER TABLE conta.tint_comprobante
  ADD COLUMN cbte_apertura VARCHAR(10) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN conta.tint_comprobante.cbte_apertura
IS 'si o no, es un comprobante de apertura ...';


/***********************************F-SCP-RAC-CONTA-0-14/07/2015****************************************/



/***********************************I-SCP-RAC-CONTA-0-16/07/2015****************************************/


--------------- SQL ---------------

ALTER TABLE conta.tresultado_det_plantilla
  ADD COLUMN negrita VARCHAR(4) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN conta.tresultado_det_plantilla.negrita
IS 'si o no';

--------------- SQL ---------------

ALTER TABLE conta.tresultado_det_plantilla
  ADD COLUMN cursiva VARCHAR(4) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN conta.tresultado_det_plantilla.cursiva
IS 'si o no';

--------------- SQL ---------------

ALTER TABLE conta.tresultado_det_plantilla
  ADD COLUMN espacio_previo INTEGER DEFAULT 0 NOT NULL;

COMMENT ON COLUMN conta.tresultado_det_plantilla.espacio_previo
IS 'espacios previos en reprote';

/***********************************F-SCP-RAC-CONTA-0-16/07/2015****************************************/


/***********************************I-SCP-RAC-CONTA-0-17/07/2015****************************************/

--------------- SQL ---------------

ALTER TABLE conta.tint_comprobante
  ADD COLUMN cbte_aitb VARCHAR(10) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN conta.tint_comprobante.cbte_aitb
IS 'no o si, (si en un futuro es necesario disgregar dejar el NO)';


--------------- SQL ---------------

ALTER TABLE conta.tresultado_det_plantilla
  ADD COLUMN incluir_aitb VARCHAR(20) DEFAULT 'todos' NOT NULL;

COMMENT ON COLUMN conta.tresultado_det_plantilla.incluir_aitb
IS 'todos, no , solo_aitb';


--------------- SQL ---------------

ALTER TABLE conta.tresultado_det_plantilla
  ADD COLUMN signo_balance VARCHAR(20) DEFAULT 'defecto_cuenta' NOT NULL;

COMMENT ON COLUMN conta.tresultado_det_plantilla.signo_balance
IS 'defecto_cuenta,  deudor, acreedor';


--------------- SQL ---------------

ALTER TABLE conta.tresultado_det_plantilla
  ADD COLUMN tipo_saldo VARCHAR(20) DEFAULT 'balance' NOT NULL;

COMMENT ON COLUMN conta.tresultado_det_plantilla.tipo_saldo
IS '1) balance hace la resta segun signo_balance de los saldos acredor y deudor, 2) solo suma los montos del debe 3) solo suma los monstos del haber';


/***********************************F-SCP-RAC-CONTA-0-17/07/2015****************************************/



/***********************************I-SCP-RAC-CONTA-0-23/07/2015****************************************/

--------------- SQL ---------------

ALTER TABLE conta.tresultado_plantilla
  ADD COLUMN tipo VARCHAR(15) DEFAULT 'reporte' NOT NULL;

COMMENT ON COLUMN conta.tresultado_plantilla.tipo
IS 'reporte o cbte';

--------------- SQL ---------------

ALTER TABLE conta.tresultado_plantilla
  ADD COLUMN cbte_aitb VARCHAR(20) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN conta.tresultado_plantilla.cbte_aitb
IS 'cuando sea del tipo comprobante';

--------------- SQL ---------------

ALTER TABLE conta.tresultado_plantilla
  ADD COLUMN cbte_apertura VARCHAR(20) DEFAULT 'no' NOT NULL;
  
  --------------- SQL ---------------

ALTER TABLE conta.tresultado_plantilla
  ADD COLUMN cbte_cierre VARCHAR(20) DEFAULT 'no' NOT NULL;

--------------- SQL ---------------

ALTER TABLE conta.tresultado_plantilla
  ADD COLUMN periodo_calculo VARCHAR(20) DEFAULT 'gestion' NOT NULL;

COMMENT ON COLUMN conta.tresultado_plantilla.periodo_calculo
IS 'gestion,  toma fecha incial y final de la gestion,  rango pide las fecha inico y fin, diario, lo hace con la fecha del dia';

--------------- SQL ---------------

ALTER TABLE conta.tresultado_plantilla
  ADD COLUMN clase_cbte VARCHAR(20);

COMMENT ON COLUMN conta.tresultado_plantilla.clase_cbte
IS 'en el caso de ser del tipo cbte , define la clase del comprobante';



--------------- SQL ---------------

ALTER TABLE conta.tresultado_plantilla
  ADD COLUMN glosa VARCHAR;

COMMENT ON COLUMN conta.tresultado_plantilla.glosa
IS 'glosa que va en el comprobante';


--------------- SQL ---------------

ALTER TABLE conta.tresultado_det_plantilla
  ADD COLUMN relacion_contable VARCHAR(50);

COMMENT ON COLUMN conta.tresultado_det_plantilla.relacion_contable
IS 'codigo de la relacion contable (solo generales) a utilizar, el calor de los campos cuenta, partida, auxiliar prevalecen sobre este si tienen valor';

--------------- SQL ---------------

ALTER TABLE conta.tresultado_det_plantilla
  ADD COLUMN codigo_partida VARCHAR(50);

COMMENT ON COLUMN conta.tresultado_det_plantilla.codigo_partida
IS 'codigo de la partida';

--------------- SQL ---------------

ALTER TABLE conta.tresultado_det_plantilla
  ADD COLUMN id_auxiliar INTEGER;

COMMENT ON COLUMN conta.tresultado_det_plantilla.id_auxiliar
IS 'define el auxiliar que va a la transaccion';


--------------- SQL ---------------

ALTER TABLE conta.tresultado_det_plantilla
  ADD COLUMN destino VARCHAR(20) DEFAULT 'reporte' NOT NULL;

COMMENT ON COLUMN conta.tresultado_det_plantilla.destino
IS 'reporte (no se utiliza para generar comprobantes, solo como calculo auxiliar),  (no entra en combaste), debe (al debe si es positivo si no al haber), haber (al haber si espositivo si no al contrario) o segun_saldo (lo suficiente para cuadrar al debe o al haber)';


--------------- SQL ---------------

ALTER TABLE conta.tresultado_det_plantilla
  ADD COLUMN orden_cbte NUMERIC;

COMMENT ON COLUMN conta.tresultado_det_plantilla.orden_cbte
IS 'orden en el que se ingresase inserta en el comprobante, (no se tuliza para el calculo)';



/***********************************F-SCP-RAC-CONTA-0-23/07/2015****************************************/


/***********************************I-SCP-RAC-CONTA-1-23/07/2015****************************************/


--------------- SQL ---------------

ALTER TABLE conta.tresultado_plantilla
  DROP COLUMN clase_cbte;
  
--------------- SQL ---------------

ALTER TABLE conta.tresultado_plantilla
  ADD COLUMN id_clase_comprobante INTEGER;

/***********************************F-SCP-RAC-CONTA-1-23/07/2015****************************************/






/***********************************I-SCP-RAC-CONTA-1-13/08/2015****************************************/


--------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ADD COLUMN banco VARCHAR(3) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN conta.tint_transaccion.banco
IS 'si la trasaccion necesita el registro de banco y forma de apgo (para cbtes manuales)';


--------------- SQL ---------------

ALTER TABLE conta.tint_comprobante
  ADD COLUMN origen VARCHAR(30);

COMMENT ON COLUMN conta.tint_comprobante.origen
IS 'identifica donde se origina el comprobante,  util para el caso de comprobantes provienietnes de la integracion regioanles';




/***********************************F-SCP-RAC-CONTA-1-13/08/2015****************************************/



/***********************************I-SCP-RAC-CONTA-1-18/08/2015****************************************/

--ALTER TABLE conta.tint_comprobante
--  DROP CONSTRAINT chk_tconfig_tipo_cuenta__tipo_cuenta RESTRICT;
  
CREATE TABLE conta.tdoc_compra_venta (
  id_doc_compra_venta BIGSERIAL,
  id_plantilla INTEGER,
  fecha DATE,
  estado VARCHAR(30) DEFAULT 'registrado'::character varying,
  tabla_origen VARCHAR(150),
  id_origen INTEGER,
  nro_autorizacion VARCHAR(200),
  codigo_control VARCHAR(200),
  nro_documento VARCHAR(100) NOT NULL,
  id_depto_conta INTEGER,
  nit VARCHAR(100),
  razon_social VARCHAR,
  sw_contabilizar VARCHAR(3) DEFAULT 'no'::character varying,
  obs VARCHAR,
  importe_excento NUMERIC(18,2),
  importe_ice NUMERIC(18,2),
  importe_it NUMERIC(18,2),
  importe_iva NUMERIC(18,2),
  importe_descuento NUMERIC(18,2),
  importe_doc NUMERIC(18,2),
  revisado VARCHAR(3) DEFAULT 'no'::character varying,
  tipo VARCHAR(25) NOT NULL,
  movil VARCHAR(3) DEFAULT 'no'::character varying,
  manual VARCHAR(3) DEFAULT 'no'::character varying NOT NULL,
  id_int_comprobante INTEGER,
  importe_descuento_ley NUMERIC(18,2),
  importe_pago_liquido NUMERIC(18,2),
  CONSTRAINT tdoc_compra_venta_pkey PRIMARY KEY(id_doc_compra_venta)
) INHERITS (pxp.tbase)

WITH (oids = false);

COMMENT ON COLUMN conta.tdoc_compra_venta.estado
IS 'registrado, validado';

COMMENT ON COLUMN conta.tdoc_compra_venta.tabla_origen
IS 'esquema mas tabla donde se origina el documento';

COMMENT ON COLUMN conta.tdoc_compra_venta.id_origen
IS 'id de la tabla origen del documento';

COMMENT ON COLUMN conta.tdoc_compra_venta.nro_documento
IS 'nro de factura o depoliza o recibo segun plantilla';

COMMENT ON COLUMN conta.tdoc_compra_venta.nit
IS 'nro de identificacion de proveedor';

COMMENT ON COLUMN conta.tdoc_compra_venta.sw_contabilizar
IS 'si o no, se considera para generar cbte, por ejemplo los que venga de obligacion de pago tiene el valor NO, por que ese sistema se encarga de generar el cbte corespondiente';

COMMENT ON COLUMN conta.tdoc_compra_venta.revisado
IS 'si o no, si ya fue revisado fisicamente';

COMMENT ON COLUMN conta.tdoc_compra_venta.tipo
IS 'compra o venta';

COMMENT ON COLUMN conta.tdoc_compra_venta.movil
IS 'cargado desde aplicacion movil con codigo QR';

COMMENT ON COLUMN conta.tdoc_compra_venta.manual
IS 'si o no , si fue registrado a mano';

COMMENT ON COLUMN conta.tdoc_compra_venta.id_int_comprobante
IS 'identifica al comprobante donde fue contabilizado';

COMMENT ON COLUMN conta.tdoc_compra_venta.importe_descuento_ley
IS 'campo para registras descuentos de ley como el it o eiue o iuebe';

/***********************************F-SCP-RAC-CONTA-1-18/08/2015****************************************/



/***********************************I-SCP-RAC-CONTA-1-21/08/2015****************************************/


--------------- SQL ---------------

ALTER TABLE conta.tdoc_compra_venta
  ADD COLUMN id_periodo INTEGER;

COMMENT ON COLUMN conta.tdoc_compra_venta.id_periodo
IS 'id del periodo correpondiente con la fecha';



/***********************************F-SCP-RAC-CONTA-1-21/08/2015****************************************/




/***********************************I-SCP-RAC-CONTA-1-24/08/2015****************************************/

CREATE TABLE conta.tperiodo_compra_venta (
  id_periodo_compra_venta SERIAL,
  id_depto INTEGER,
  id_periodo INTEGER,
  estado VARCHAR(20) DEFAULT 'abierto'::character varying NOT NULL,
  CONSTRAINT tperiodo_compra_venta_pkey PRIMARY KEY(id_periodo_compra_venta)
) INHERITS (pxp.tbase)

WITH (oids = false);

COMMENT ON COLUMN conta.tperiodo_compra_venta.id_depto
IS 'depto de contabilidad';

COMMENT ON COLUMN conta.tperiodo_compra_venta.id_periodo
IS 'periodo general en parametros';

COMMENT ON COLUMN conta.tperiodo_compra_venta.estado
IS 'cerrado (no se permite mas el registro de facturas), cerrado_parcial (solo contabilidad puede registrar), abierto(todos peuden registrar)';
/***********************************F-SCP-RAC-CONTA-1-24/08/2015****************************************/




/***********************************I-SCP-RAC-CONTA-1-26/08/2015****************************************/




--------------- SQL ---------------

ALTER TABLE conta.tdoc_compra_venta
  ADD COLUMN nro_dui VARCHAR(16) DEFAULT 0 NOT NULL;

COMMENT ON COLUMN conta.tdoc_compra_venta.nro_dui
IS 'solo para polizas de impoestacion';

--------------- SQL ---------------

/***********************************F-SCP-RAC-CONTA-1-26/08/2015****************************************/




/***********************************I-SCP-RAC-CONTA-1-01/09/2015****************************************/
--------------- SQL ---------------
ALTER TABLE conta.tint_comprobante
  ADD COLUMN temporal VARCHAR(3) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN conta.tint_comprobante.temporal
IS 'para los comprobantes donde solo se utilicem la estructura como temporalmente(caso antes de migrar a contabilidad de la regional internacional o al contrario)';

/***********************************F-SCP-RAC-CONTA-1-01/09/2015****************************************/


/***********************************I-SCP-RAC-CONTA-1-02/09/2015****************************************/


--------------- SQL ---------------

ALTER TABLE conta.tint_comprobante
  ADD COLUMN id_int_comprobante_origen_central INTEGER;

COMMENT ON COLUMN conta.tint_comprobante.id_int_comprobante_origen_central
IS 'identifica los cbtes migrados desde la central hacia la regional';


/***********************************F-SCP-RAC-CONTA-1-02/09/2015****************************************/


/***********************************I-SCP-FFP-CONTA-1-11/09/2015****************************************/

CREATE TABLE conta.tbanca_compra_venta (
  id_banca_compra_venta SERIAL,
  tipo VARCHAR(255),
  modalidad_transaccion INTEGER, 
  fecha_documento date,
  tipo_transaccion INTEGER,
  nit_ci VARCHAR(255),
  razon VARCHAR(255),
  num_documento VARCHAR(255),
  num_contrato VARCHAR(255),
  importe_documento numeric(10,2),
  autorizacion numeric,
  num_cuenta_pago varchar(255),
  monto_pagado numeric(10,2),
  monto_acumulado numeric(10,2),
  nit_entidad numeric,
  num_documento_pago varchar(255),
  tipo_documento_pago numeric,
  fecha_de_pago date,
  CONSTRAINT pk_tbanca_compra_venta__id_cuenta PRIMARY KEY(id_banca_compra_venta) 
) INHERITS (pxp.tbase)
WITHOUT OIDS;

ALTER TABLE conta.tbanca_compra_venta
  ADD COLUMN id_depto_conta INTEGER;
  
ALTER TABLE conta.tbanca_compra_venta
  ADD COLUMN id_periodo INTEGER;
  

  
  
COMMENT ON COLUMN conta.tbanca_compra_venta.tipo
IS 'tipo puede ser compra o venta';

COMMENT ON COLUMN conta.tbanca_compra_venta.modalidad_transaccion
IS 'Consignar cuando corresponda: 1 Compras al contado , 2 Compras al crédito';

COMMENT ON COLUMN conta.tbanca_compra_venta.fecha_documento
IS 'Fecha del documento con el que se realizó la transacción por un importe mayor o igual a Bs50.000.-';

COMMENT ON COLUMN conta.tbanca_compra_venta.tipo_transaccion
IS 'Consignar uno de los siguientes números de acuerdo a lo que corresponda: 1. Compra con factura  2. Compra con retenciones 3. Compra de inmuebles';


COMMENT ON COLUMN conta.tbanca_compra_venta.nit_ci
IS 'Consignar el dato del NIT del proveedor de la factura,  o  N° de identificación del beneficiario del pago retenido.';

COMMENT ON COLUMN conta.tbanca_compra_venta.razon
IS 'Consignar la razón social del proveedor o el nombre del beneficiario del pago realizado';


COMMENT ON COLUMN conta.tbanca_compra_venta.num_documento
IS 'Consignar el N° de factura o el N° de documento  que corresponda  de acuerdo al tipo de  transacción';


COMMENT ON COLUMN conta.tbanca_compra_venta.num_contrato
IS 'Consignar el número de contrato o cero en caso de no existir contrato.';

COMMENT ON COLUMN conta.tbanca_compra_venta.importe_documento
IS 'Consignar el monto total de la factura o de la transacción retenida';

COMMENT ON COLUMN conta.tbanca_compra_venta.autorizacion
IS 'Consignar el N° de autorización de la factura, o el   N° 4 para retenciones';

COMMENT ON COLUMN conta.tbanca_compra_venta.num_cuenta_pago
IS 'N° de cuenta de la Entidad Financiera de desembolso del pago o Nº de documento de depósito en cuenta';

COMMENT ON COLUMN conta.tbanca_compra_venta.monto_pagado
IS 'Monto Pagado';

COMMENT ON COLUMN conta.tbanca_compra_venta.monto_acumulado
IS 'Monto acumulado de pagos parciales';


COMMENT ON COLUMN conta.tbanca_compra_venta.nit_entidad
IS 'NIT Entidad Financiera emisora del documento de pago.';

COMMENT ON COLUMN conta.tbanca_compra_venta.num_documento_pago
IS 'N° del documento utilizado para la realización del pago';

COMMENT ON COLUMN conta.tbanca_compra_venta.tipo_documento_pago
IS 'Consignar uno de los siguientes números de acuerdo a lo que corresponda:  
1. Cheque de cualquier naturaleza 2. Orden de transferencia  3. Ordenes de transferencia electrónica de fondos 4. Transferencia de fondos 
5. Tarjeta de débito 
6. Tarjeta de crédito 7. Tarjeta prepagada 8. Depósito en cuenta. 9. Cartas de crédito 10. Otros';

COMMENT ON COLUMN conta.tbanca_compra_venta.fecha_de_pago
IS 'Fecha de la emisión del documento de pago';







CREATE TABLE conta.tconfig_banca (
  id_config_banca SERIAL,
  tipo VARCHAR(255),
  digito INTEGER, 
  descripcion varchar(255),
  CONSTRAINT pk_tconfig_banca__id_cuenta PRIMARY KEY(id_config_banca) 
) INHERITS (pxp.tbase)
WITHOUT OIDS;




/***********************************F-SCP-FFP-CONTA-1-11/09/2015****************************************/




/***********************************I-SCP-RAC-CONTA-1-15/09/2015****************************************/

--------------- SQL ---------------

ALTER TABLE conta.tdoc_compra_venta
  ADD COLUMN id_moneda INTEGER  NOT NULL;

COMMENT ON COLUMN conta.tdoc_compra_venta.id_moneda
IS 'Moneda del documento';
-------------- SQL ---------------

CREATE TABLE conta.tdoc_concepto (
  id_doc_concepto SERIAL NOT NULL,
  id_orden_trabajo INTEGER,
  id_centro_costo INTEGER,
  id_concepto_ingas INTEGER,
  descripcion TEXT,
  cantidad NUMERIC,
  precio_unitario NUMERIC(19,2) NOT NULL,
  precio_total NUMERIC(19,2) NOT NULL,
  PRIMARY KEY(id_doc_concepto)
) INHERITS (pxp.tbase)
;


--------------- SQL ---------------

ALTER TABLE conta.tdoc_concepto
  ADD COLUMN id_doc_compra_venta INTEGER NOT NULL;

/***********************************F-SCP-RAC-CONTA-1-15/09/2015****************************************/





/***********************************I-SCP-FFP-CONTA-1-16/09/2015****************************************/

ALTER TABLE conta.tbanca_compra_venta
  ADD COLUMN revisado VARCHAR(2);

ALTER TABLE conta.tbanca_compra_venta
  ALTER COLUMN revisado SET DEFAULT 'no';
  
  
  ALTER TABLE conta.tbanca_compra_venta
  ADD COLUMN id_proveedor INTEGER;
  
  ALTER TABLE conta.tbanca_compra_venta
  ADD COLUMN id_contrato INTEGER;
  
  ALTER TABLE conta.tbanca_compra_venta
  ADD COLUMN id_cuenta_bancaria INTEGER;
  
--------------- SQL ---------------

ALTER TABLE conta.tdoc_concepto
  RENAME COLUMN cantidad TO cantidad_sol;
  
   
/***********************************F-SCP-FFP-CONTA-1-16/09/2015****************************************/


/***********************************I-SCP-RAC-CONTA-1-22/09/2015****************************************/
--------------- SQL ---------------

CREATE TABLE conta.tagrupador (
  id_agrupador INTEGER,
  fecha_ini DATE,
  fecha_fin DATE,
  tipo INTEGER,
  id_depto_conta INTEGER,
  id_moneda INTEGER,
  PRIMARY KEY(id_agrupador)
) INHERITS (pxp.tbase)
;

ALTER TABLE conta.tagrupador
  OWNER TO postgres;

COMMENT ON COLUMN conta.tagrupador.tipo
IS 'compra o venta';


--------------- SQL ---------------

CREATE TABLE conta.tagrupador_doc (
  id_agrupador_doc INTEGER,
  id_doc_compra_venta INTEGER,
  id_agrupador INTEGER,
  PRIMARY KEY(id_agrupador_doc)
) INHERITS (pxp.tbase);


ALTER TABLE conta.tagrupador_doc
  OWNER TO postgres;



--------------- SQL ---------------

COMMENT ON COLUMN conta.tagrupador.fecha_ini
IS 'fechade inicio para buscar documentos de compra venta';

ALTER TABLE conta.tagrupador
  ALTER COLUMN fecha_ini SET NOT NULL;

--------------- SQL ---------------

COMMENT ON COLUMN conta.tagrupador.fecha_fin
IS 'fecha fin para buscar en rango de documentos';

ALTER TABLE conta.tagrupador
  ALTER COLUMN fecha_fin SET NOT NULL;
  
--------------- SQL ---------------

ALTER TABLE conta.tagrupador
  ADD COLUMN fecha_cbte DATE NOT NULL;

COMMENT ON COLUMN conta.tagrupador.fecha_cbte
IS 'fecha para colocar al comprobante';  


--------------- SQL ---------------

ALTER TABLE conta.tagrupador
  ADD COLUMN incluir_rev VARCHAR(4) DEFAULT 'si' NOT NULL;

COMMENT ON COLUMN conta.tagrupador.incluir_rev
IS 'inlucir solo documentos que esten marcados como revisados o de lo contrario todos los disponibles';


/***********************************F-SCP-RAC-CONTA-1-22/09/2015****************************************/



/***********************************I-SCP-RAC-CONTA-1-23/09/2015****************************************/


--------------- SQL ---------------

ALTER TABLE conta.tagrupador
  ALTER COLUMN tipo TYPE VARCHAR(20);

ALTER TABLE conta.tagrupador
  ALTER COLUMN tipo SET NOT NULL;

--------------- SQL ---------------

CREATE SEQUENCE conta.tagrupador_id_agrupador_seq
MAXVALUE 2147483647;

ALTER TABLE conta.tagrupador
  ALTER COLUMN id_agrupador TYPE INTEGER;

ALTER TABLE conta.tagrupador
  ALTER COLUMN id_agrupador SET DEFAULT nextval('conta.tagrupador_id_agrupador_seq'::text);

--------------- SQL ---------------

CREATE SEQUENCE conta.tagrupador_doc_id_agrupador_doc_seq
MAXVALUE 2147483647;

ALTER TABLE conta.tagrupador_doc
  ALTER COLUMN id_agrupador_doc TYPE INTEGER;

ALTER TABLE conta.tagrupador_doc
  ALTER COLUMN id_agrupador_doc SET DEFAULT nextval('conta.tagrupador_doc_id_agrupador_doc_seq'::text);

--------------- SQL ---------------

ALTER TABLE conta.tagrupador
  ADD COLUMN id_gestion INTEGER; 
/***********************************F-SCP-RAC-CONTA-1-23/09/2015****************************************/



/***********************************I-SCP-RAC-CONTA-1-27/09/2015****************************************/

--------------- SQL ---------------

ALTER TABLE conta.tint_comprobante
  ADD COLUMN vbregional VARCHAR(4) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN conta.tint_comprobante.vbregional
IS 'cuando la regional valida el comprobante el de central queda en borrador,  pero con vbregional = si';



ALTER TABLE conta.tint_comprobante
  ADD COLUMN codigo_estacion_origen VARCHAR(30);

COMMENT ON COLUMN conta.tint_comprobante.codigo_estacion_origen
IS 'codigo de la estacion origen';



ALTER TABLE conta.tint_comprobante
  ADD COLUMN id_int_comprobante_origen_regional INTEGER;

COMMENT ON COLUMN conta.tint_comprobante.id_int_comprobante_origen_regional
IS 'identidica el id del comprobante en la regional se usa de manera combinada con el codigo de estacion';

/***********************************F-SCP-RAC-CONTA-1-27/09/2015****************************************/





/***********************************I-SCP-RAC-CONTA-1-02/10/2015****************************************/


--------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ADD COLUMN id_int_transaccion_origen INTEGER;

COMMENT ON COLUMN conta.tint_transaccion.id_int_transaccion_origen
IS 'hace referencia a al id de la trasaccion original';

/***********************************F-SCP-RAC-CONTA-1-02/10/2015****************************************/



/***********************************I-SCP-RAC-CONTA-1-08/10/2015****************************************/


--------------- SQL ---------------

ALTER TABLE conta.tint_rel_devengado
  ADD COLUMN monto_pago_mb NUMERIC(18,2);

COMMENT ON COLUMN conta.tint_rel_devengado.monto_pago_mb
IS 'la insertar la relacion se calcula segun el tc de cbte de pago';


/***********************************F-SCP-RAC-CONTA-1-08/10/2015****************************************/

/***********************************I-SCP-JRR-CONTA-0-09/10/2015****************************************/

CREATE TABLE conta.toficina_ot (
  id_oficina_ot SERIAL,
  id_oficina INTEGER,
  id_orden_trabajo INTEGER,
  PRIMARY KEY(id_oficina_ot)
) INHERITS (pxp.tbase);

/***********************************F-SCP-JRR-CONTA-0-09/10/2015****************************************/



/***********************************I-SCP-JRR-CONTA-0-14/10/2015****************************************/

ALTER TABLE conta.tint_comprobante
  ADD COLUMN fecha_costo_ini DATE;

COMMENT ON COLUMN conta.tint_comprobante.fecha_costo_ini
IS 'Cuando un concepto de gasto es del tipo servicio, esta fecha indica el inico del costo';

--------------- SQL ---------------

ALTER TABLE conta.tint_comprobante
  ADD COLUMN fecha_costo_fin DATE;

COMMENT ON COLUMN conta.tint_comprobante.fecha_costo_fin
IS 'Cuando un concepto de gasto es del tipo servicio, esta fecha indica el fin del costo';



ALTER TABLE conta.tplantilla_comprobante
  ADD COLUMN campo_fecha_costo_ini TEXT;

COMMENT ON COLUMN conta.tplantilla_comprobante.campo_fecha_costo_ini
IS 'Cuando un concepto de gasto es del tipo servicio, esta fecha indica el inico del costo';

--------------- SQL ---------------

ALTER TABLE conta.tplantilla_comprobante
  ADD COLUMN campo_fecha_costo_fin TEXT;

COMMENT ON COLUMN conta.tplantilla_comprobante.campo_fecha_costo_fin
IS 'Cuando un concepto de gasto es del tipo servicio, esta fecha indica el fin del costo';

/***********************************F-SCP-JRR-CONTA-0-14/10/2015****************************************/



/***********************************I-SCP-RAC-CONTA-0-03/11/2015****************************************/


--------------- SQL ---------------

DROP VIEW  IF EXISTS  conta.vint_comprobante;

--------------- SQL ---------------

ALTER TABLE conta.tint_comprobante
  ADD COLUMN id_moneda_tri INTEGER;

COMMENT ON COLUMN conta.tint_comprobante.id_moneda_tri
IS 'identifica la moneda de triangulacion';


--------------- SQL ---------------

ALTER TABLE conta.tint_comprobante
  ALTER COLUMN tipo_cambio TYPE NUMERIC;
  
--------------- SQL ---------------

ALTER TABLE conta.tint_comprobante
  ADD COLUMN tipo_cambio_2 NUMERIC;

COMMENT ON COLUMN conta.tint_comprobante.tipo_cambio_2
IS 'tipo de cambio para la segunda operacion, (la triangulacion requiere dos oepraciones)';

 
--------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ADD COLUMN id_moneda INTEGER;

COMMENT ON COLUMN conta.tint_transaccion.id_moneda
IS 'id moneda de la transaccion';


--------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ADD COLUMN id_moneda_tri INTEGER;

COMMENT ON COLUMN conta.tint_transaccion.id_moneda_tri
IS 'id de la moenda de triangulacion';


--------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ADD COLUMN tipo_cambio NUMERIC;

COMMENT ON COLUMN conta.tint_transaccion.tipo_cambio
IS 'tipo de cambio para la primera operacion';


--------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ADD COLUMN tipo_cambio_2 NUMERIC;

COMMENT ON COLUMN conta.tint_transaccion.tipo_cambio_2
IS 'tipo de cambio para la segunda operación';


--------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ADD COLUMN triangulacion VARCHAR(5) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN conta.tint_transaccion.triangulacion
IS 'si,  si para esta transaccion se aplica la triangulacion con la moneda base';


--------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ADD COLUMN actualizacion VARCHAR(5) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN conta.tint_transaccion.actualizacion
IS 'si, si esta transacion solo afecta una moenda y no tiene que convertir  su equivalente en otra moenda';


--------------- SQL ---------------

ALTER TABLE conta.tint_rel_devengado
  ADD COLUMN monto_pago_mt NUMERIC(18,2);

COMMENT ON COLUMN conta.tint_rel_devengado.monto_pago_mt
IS 'monto de pago en la moneda de triangulacion';


--------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ADD COLUMN importe_debe_mt NUMERIC(18,2);

COMMENT ON COLUMN conta.tint_transaccion.importe_debe_mt
IS 'monto en moneda de triangulacion';


--------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ADD COLUMN importe_haber_mt NUMERIC(18,2);

COMMENT ON COLUMN conta.tint_transaccion.importe_haber_mt
IS 'monto haber en la moneda de triangulacion';

--------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ADD COLUMN importe_gasto_mt NUMERIC(18,2);


--------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ADD COLUMN importe_recurso_mt NUMERIC(18,2);
  
  
 --------------- SQL ---------------

ALTER TABLE conta.tint_comprobante
  ADD COLUMN sw_tipo_cambio VARCHAR(5) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN conta.tint_comprobante.sw_tipo_cambio
IS 'no,  la transaccion no son diferentes de la cabecera, si, las trasaccion son diferente de la cabecera (no podemos actulizar todo en uno)';
/***********************************F-SCP-RAC-CONTA-0-03/11/2015****************************************/



/***********************************I-SCP-RAC-CONTA-0-04/11/2015****************************************/

--------------- SQL ---------------

CREATE TABLE conta.tconfig_cambiaria (
  id_config_cambiaria SERIAL,
  origen VARCHAR(20) DEFAULT 'nacional' NOT NULL,
  ope_1 VARCHAR NOT NULL,
  ope_2 VARCHAR NOT NULL,
  obs VARCHAR,
  habilitado VARCHAR(5) DEFAULT 'no' NOT NULL,
  fecha_habilitado DATE,
  PRIMARY KEY(id_config_cambiaria)
) INHERITS (pxp.tbase)
;

ALTER TABLE conta.tconfig_cambiaria
  OWNER TO postgres;

COMMENT ON COLUMN conta.tconfig_cambiaria.origen
IS 'nacional o internacional';

COMMENT ON COLUMN conta.tconfig_cambiaria.habilitado
IS 'sio o no, esta habilitado para ser usado';

COMMENT ON COLUMN conta.tconfig_cambiaria.fecha_habilitado
IS 'fecha en que se modifica si esta habilitado o no';



--------------- SQL ---------------

ALTER TABLE conta.tint_comprobante
  ADD COLUMN id_config_cambiaria INTEGER;

COMMENT ON COLUMN conta.tint_comprobante.id_config_cambiaria
IS 'define la configuracion cambiaria utilizada para este comprobante';


--------------- SQL ---------------

ALTER TABLE conta.tint_comprobante
  ADD COLUMN localidad VARCHAR(20) DEFAULT 'nacional' NOT NULL;

COMMENT ON COLUMN conta.tint_comprobante.localidad
IS 'nacional o internacional, sirve para definir la configuracion cambiaria aplicada en el comprobante';


/***********************************F-SCP-RAC-CONTA-0-04/11/2015****************************************/




/***********************************I-SCP-RAC-CONTA-0-27/11/2015****************************************/

CREATE TABLE conta.tint_comprobante_bk (
  id_int_comprobante_bk serial,
  id_int_comprobante integer,
  id_clase_comprobante INTEGER,
  id_subsistema INTEGER,
  id_depto INTEGER,
  id_moneda INTEGER,
  id_periodo INTEGER,
  nro_cbte VARCHAR(30),
  momento VARCHAR(30) DEFAULT 'contable'::character varying NOT NULL,
  glosa1 VARCHAR(1500),
  glosa2 VARCHAR(400),
  beneficiario VARCHAR(500),
  tipo_cambio NUMERIC,
  id_funcionario_firma1 INTEGER,
  id_funcionario_firma2 INTEGER,
  id_funcionario_firma3 INTEGER,
  fecha DATE,
  nro_tramite VARCHAR(70),
  funcion_comprobante_eliminado VARCHAR(200),
  funcion_comprobante_validado VARCHAR(200),
  momento_comprometido VARCHAR(4) DEFAULT 'no'::character varying NOT NULL,
  momento_ejecutado VARCHAR(4) DEFAULT 'no'::character varying NOT NULL,
  momento_pagado VARCHAR(4) DEFAULT 'no'::character varying NOT NULL,
  id_cuenta_bancaria INTEGER,
  id_cuenta_bancaria_mov INTEGER,
  nro_cheque INTEGER,
  nro_cuenta_bancaria_trans VARCHAR(255),
  id_plantilla_comprobante INTEGER,
  manual VARCHAR(5) DEFAULT 'no'::character varying NOT NULL,
  id_int_comprobante_fks INTEGER[],
  id_tipo_relacion_comprobante INTEGER,
  id_depto_libro INTEGER,
  cbte_cierre VARCHAR(20) DEFAULT 'no'::character varying NOT NULL,
  cbte_apertura VARCHAR(10) DEFAULT 'no'::character varying NOT NULL,
  cbte_aitb VARCHAR(10) DEFAULT 'no'::character varying NOT NULL,
  origen VARCHAR(30),
  temporal VARCHAR(3) DEFAULT 'no'::character varying NOT NULL,
  id_int_comprobante_origen_central INTEGER,
  vbregional VARCHAR(4) DEFAULT 'no'::character varying NOT NULL,
  codigo_estacion_origen VARCHAR(30),
  id_int_comprobante_origen_regional INTEGER,
  fecha_costo_ini DATE,
  fecha_costo_fin DATE,
  id_moneda_tri INTEGER,
  tipo_cambio_2 NUMERIC,
  sw_tipo_cambio VARCHAR(5) DEFAULT 'no'::character varying NOT NULL,
  id_config_cambiaria INTEGER,
  localidad VARCHAR(20) DEFAULT 'nacional'::character varying NOT NULL,
  CONSTRAINT tint_comprobante_bk_pk_tcomprobante__id_int_comprobante_bk PRIMARY KEY(id_int_comprobante_bk)
 
) INHERITS (pxp.tbase)

WITH (oids = false);

COMMENT ON COLUMN conta.tint_comprobante_bk.momento
IS 'contable o presupuestario';

COMMENT ON COLUMN conta.tint_comprobante_bk.manual
IS 'si o no, es un comprobante manual o generado por otros sistemas, los comprobantes generados tienen edicion limitada ..';

COMMENT ON COLUMN conta.tint_comprobante_bk.id_tipo_relacion_comprobante
IS 'define el tipo de relacion en tre so comprobantes que sen encuentran en el array id_int_comprobante_fks';

COMMENT ON COLUMN conta.tint_comprobante_bk.id_depto_libro
IS 'departamento de libro de bancos';

COMMENT ON COLUMN conta.tint_comprobante_bk.cbte_cierre
IS 'no, balance, resultado, si es o no un comprobante de cierres, (peude ser ciere de balance o cierre de resutlados), los comprobantes de cierre netean las cuentas, por esto es encesario identificarlo para incluirlos o no en algunos reportes';

COMMENT ON COLUMN conta.tint_comprobante_bk.cbte_apertura
IS 'si o no, es un comprobante de apertura ...';

COMMENT ON COLUMN conta.tint_comprobante_bk.cbte_aitb
IS 'no o si, (si en un futuro es necesario disgregar dejar el NO)';

COMMENT ON COLUMN conta.tint_comprobante_bk.origen
IS 'identifica donde se origina el comprobante,  util para el caso de comprobantes provienietnes de la integracion regioanles';

COMMENT ON COLUMN conta.tint_comprobante_bk.temporal
IS 'para los comprobantes donde solo se utilicem la estructura como temporalmente(caso antes de migrar a contabilidad de la regional internacional o al contrario)';

COMMENT ON COLUMN conta.tint_comprobante_bk.id_int_comprobante_origen_central
IS 'identifica los cbtes migrados desde la central hacia la regional';

COMMENT ON COLUMN conta.tint_comprobante_bk.vbregional
IS 'cuando la regional valida el comprobante el de central queda en borrador,  pero con vbregional = si';

COMMENT ON COLUMN conta.tint_comprobante_bk.codigo_estacion_origen
IS 'codigo de la estacion origen';

COMMENT ON COLUMN conta.tint_comprobante_bk.id_int_comprobante_origen_regional
IS 'identidica el id del comprobante en la regional se usa de manera combinada con el codigo de estacion';

COMMENT ON COLUMN conta.tint_comprobante_bk.fecha_costo_ini
IS 'Identifica el inicio del periodo del costo';

COMMENT ON COLUMN conta.tint_comprobante_bk.fecha_costo_fin
IS 'identifica el fin del periodo de costo';

COMMENT ON COLUMN conta.tint_comprobante_bk.id_moneda_tri
IS 'identifica la moneda de triangulacion';

COMMENT ON COLUMN conta.tint_comprobante_bk.tipo_cambio_2
IS 'tipo de cambio para la segunda operacion, (la triangulacion requiere dos oepraciones)';

COMMENT ON COLUMN conta.tint_comprobante_bk.sw_tipo_cambio
IS 'no,  la transaccion no son diferentes de la cabecera, si, las trasaccion son diferente de la cabecera (no podemos actulizar todo en uno)';

COMMENT ON COLUMN conta.tint_comprobante_bk.id_config_cambiaria
IS 'define la configuracion cambiaria utilizada para este comprobante';

COMMENT ON COLUMN conta.tint_comprobante_bk.localidad
IS 'nacional o internacional,  sirve para definir la configuracion cambiaria aplicada en el comprobante';


--------------- SQL ---------------

CREATE TABLE conta.tint_transaccion_bk (
  id_int_transaccion_bk SERIAL,
  id_int_transaccion INTEGER,
  id_int_comprobante INTEGER NOT NULL,
  id_cuenta INTEGER NOT NULL,
  id_auxiliar INTEGER,
  id_centro_costo INTEGER NOT NULL,
  id_partida INTEGER,
  id_partida_ejecucion INTEGER,
  id_int_transaccion_fk INTEGER,
  glosa VARCHAR,
  importe_debe NUMERIC(18,2),
  importe_haber NUMERIC(18,2),
  importe_recurso NUMERIC(18,2),
  importe_gasto NUMERIC(18,2),
  importe_debe_mb NUMERIC(18,2),
  importe_haber_mb NUMERIC(18,2),
  importe_recurso_mb NUMERIC(18,2),
  importe_gasto_mb NUMERIC(18,2),
  id_detalle_plantilla_comprobante INTEGER,
  id_partida_ejecucion_dev INTEGER,
  importe_reversion NUMERIC(18,2) DEFAULT 0 NOT NULL,
  monto_pagado_revertido NUMERIC(18,2) DEFAULT 0 NOT NULL,
  id_partida_ejecucion_rev INTEGER,
  id_cuenta_bancaria INTEGER,
  id_cuenta_bancaria_mov INTEGER,
  nro_cheque INTEGER,
  nro_cuenta_bancaria_trans VARCHAR(300),
  porc_monto_excento_var NUMERIC(1000,8),
  nombre_cheque_trans VARCHAR(200),
  factor_reversion NUMERIC DEFAULT 0 NOT NULL,
  id_orden_trabajo INTEGER,
  forma_pago VARCHAR(100),
  banco VARCHAR(3) DEFAULT 'no'::character varying NOT NULL,
  id_int_transaccion_origen INTEGER,
  id_moneda INTEGER,
  id_moneda_tri INTEGER,
  tipo_cambio NUMERIC,
  tipo_cambio_2 NUMERIC,
  actualizacion VARCHAR(5) DEFAULT 'no'::character varying NOT NULL,
  triangulacion VARCHAR(5) DEFAULT 'no'::character varying NOT NULL,
  importe_debe_mt NUMERIC(18,2),
  importe_haber_mt NUMERIC(18,2),
  importe_gasto_mt NUMERIC(18,2),
  importe_recurso_mt NUMERIC(18,2),
  CONSTRAINT tint_transaccion_bk_pk_tint_transaccion__id_int_transaccion_bk PRIMARY KEY(id_int_transaccion_bk)
  
) INHERITS (pxp.tbase)

WITH (oids = true);

COMMENT ON COLUMN conta.tint_transaccion_bk.id_detalle_plantilla_comprobante
IS 'Hace referencia a la a la plantilla que origino esta transaccion, tambien sirve para agrupar transacciones de la misma clase';

COMMENT ON COLUMN conta.tint_transaccion_bk.importe_reversion
IS 'este importe se revierte del comprometido si es mayor a 0, por ejm. util para facturas que solo ejecutan 87 %';

COMMENT ON COLUMN conta.tint_transaccion_bk.monto_pagado_revertido
IS 'Este campo  acumula el monto que falta por descontar en el momento pagado, nuca debe ser mayor que el importe_reversion';

COMMENT ON COLUMN conta.tint_transaccion_bk.id_partida_ejecucion_rev
IS 'elmacena la partida ejecucion del monto revertido';

COMMENT ON COLUMN conta.tint_transaccion_bk.nro_cuenta_bancaria_trans
IS 'Nro de cuenta destino para transferencias bancarias';

COMMENT ON COLUMN conta.tint_transaccion_bk.porc_monto_excento_var
IS 'Porcentaje para el calculo de montos excentos variable, emeplo utilizado para las facturas electrica dondel no se conoce con exactiud el porcentaje excento de antemoano (antes de la emision del factura)';

COMMENT ON COLUMN conta.tint_transaccion_bk.nombre_cheque_trans
IS 'Nombre a la cual se emitirá el cheque o transferencia';

COMMENT ON COLUMN conta.tint_transaccion_bk.forma_pago
IS 'cheque o transferencia';

COMMENT ON COLUMN conta.tint_transaccion_bk.banco
IS 'si la trasaccion necesita el registro de banco y forma de apgo (para cbtes manuales)';

COMMENT ON COLUMN conta.tint_transaccion_bk.id_int_transaccion_origen
IS 'hace referencia a al id de la trasaccion original';

COMMENT ON COLUMN conta.tint_transaccion_bk.id_moneda
IS 'id moneda de la transaccion';

COMMENT ON COLUMN conta.tint_transaccion_bk.id_moneda_tri
IS 'id de la moenda de triangulacion';

COMMENT ON COLUMN conta.tint_transaccion_bk.tipo_cambio
IS 'tipo de cambio para la primera operacion';

COMMENT ON COLUMN conta.tint_transaccion_bk.tipo_cambio_2
IS 'tipo de cambio para la segunda operación';

COMMENT ON COLUMN conta.tint_transaccion_bk.actualizacion
IS 'si, si esta transacion solo afecta una moenda y no tiene que convertir  su equivalente en otra moenda';

COMMENT ON COLUMN conta.tint_transaccion_bk.triangulacion
IS 'si,  si para esta transaccion se aplica la triangulacion con la moneda base';

COMMENT ON COLUMN conta.tint_transaccion_bk.importe_debe_mt
IS 'monto en moneda de triangulacion';

COMMENT ON COLUMN conta.tint_transaccion_bk.importe_haber_mt
IS 'monto haber en la moneda de triangulacion';


--------------- SQL ---------------

ALTER TABLE conta.tint_transaccion_bk
  ADD COLUMN id_int_comprobante_bk INTEGER NOT NULL;


--------------- SQL ---------------

ALTER TABLE conta.tint_comprobante_bk
  ADD COLUMN fecha_bk TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL;

COMMENT ON COLUMN conta.tint_comprobante_bk.fecha_bk
IS 'fecha en que fue generado el backup';



--------------- SQL ---------------

CREATE TABLE conta.tint_rel_devengado_bk (
  id_int_rel_devengado_bk SERIAL,
  id_int_rel_devengado INTEGER,
  id_int_transaccion_dev INTEGER,
  id_int_transaccion_pag INTEGER,
  id_int_transaccion_bk_dev INTEGER,
  id_int_transaccion_bk_pag INTEGER,
  monto_pago NUMERIC(18,2),
  id_partida_ejecucion_pag INTEGER,
  monto_pago_mb NUMERIC(18,2),
  monto_pago_mt NUMERIC(18,2),
  CONSTRAINT tint_rel_devengado_bk_pkey PRIMARY KEY(id_int_rel_devengado_bk)
) INHERITS (pxp.tbase)

WITH (oids = false);

COMMENT ON COLUMN conta.tint_rel_devengado_bk.monto_pago_mb
IS 'la insertar la relacion se calcula segun el tc de cbte de pago';

COMMENT ON COLUMN conta.tint_rel_devengado_bk.monto_pago_mt
IS 'monto de pago en la moneda de triangulacion';

/***********************************F-SCP-RAC-CONTA-0-27/11/2015****************************************/



/***********************************I-SCP-RAC-CONTA-0-30/11/2015****************************************/


--------------- SQL ---------------

ALTER TABLE conta.tint_comprobante
  ADD COLUMN sw_editable VARCHAR(4) DEFAULT 'si' NOT NULL;

COMMENT ON COLUMN conta.tint_comprobante.sw_editable
IS 'por defecto los cbte en borrador se peude editar , pero no los internacionales,
cuando se habilita la edicion se genera un backup del cbte';


--------------- SQL ---------------

ALTER TABLE conta.tint_comprobante
  ADD COLUMN id_int_comprobante_bk INTEGER;

COMMENT ON COLUMN conta.tint_comprobante.id_int_comprobante_bk
IS 'idetifica el ulitmo backup de este comprobante';


ALTER TABLE conta.tplantilla_comprobante
  ADD COLUMN funcion_comprobante_editado TEXT;

COMMENT ON COLUMN conta.tplantilla_comprobante.funcion_comprobante_editado
IS 'esta funcion se ejecuta al momento de validar un comprobante que a sido editado (por ejem para revirt el comprometido original del plan de pagos)';

/***********************************F-SCP-RAC-CONTA-0-30/11/2015****************************************/




/***********************************I-SCP-FFP-CONTA-1-30/11/2015****************************************/

ALTER TABLE conta.tbanca_compra_venta
  ALTER COLUMN monto_acumulado SET NOT NULL;


ALTER TABLE conta.tbanca_compra_venta
  ADD COLUMN id_documento INTEGER;



CREATE TYPE conta.json_imp_banca_compra_venta AS (
  modalidad_transaccion INTEGER,
  fecha_documento DATE,
  tipo_transaccion INTEGER,
  nit_ci VARCHAR(255),
  razon VARCHAR(255),
  num_documento VARCHAR(255),
  importe_documento NUMERIC(10,2),
  autorizacion numeric,
  num_cuenta_pago VARCHAR(255),
  monto_pagado NUMERIC(10,2),
  monto_acumulado NUMERIC(10,2),
  nit_entidad NUMERIC,
  num_documento_pago VARCHAR(255),
  tipo_documento_pago INTEGER,
  fecha_de_pago DATE
);


CREATE TYPE conta.json_imp_banca_compra_venta_dos AS (
  modalidad_transaccion VARCHAR(255),
  fecha_documento VARCHAR(255),
  tipo_transaccion VARCHAR(255),
  nit_ci VARCHAR(255),
  razon VARCHAR(255),
  num_documento VARCHAR(255),
  importe_documento VARCHAR(255),
  autorizacion VARCHAR(255),
  num_cuenta_pago VARCHAR(255),
  monto_pagado VARCHAR(255),
  monto_acumulado VARCHAR(255),
  nit_entidad VARCHAR(255),
  num_documento_pago VARCHAR(255),
  tipo_documento_pago VARCHAR(255),
  fecha_de_pago VARCHAR(255)
);


CREATE TABLE conta.ttxt_importacion_bcv (
 id_txt_importacion_bcv SERIAL,
  nombre_archivo varchar(255),
  id_periodo INTEGER,
  CONSTRAINT pk_ttxt_importacion_bcv__id_txt_importacion_bcv PRIMARY KEY(id_txt_importacion_bcv)
) INHERITS (pxp.tbase)
WITHOUT OIDS; 


ALTER TABLE conta.ttxt_importacion_bcv
  ADD UNIQUE (nombre_archivo);


ALTER TABLE conta.tbanca_compra_venta
  ADD COLUMN periodo_servicio VARCHAR(255);

ALTER TABLE conta.tbanca_compra_venta
  ADD COLUMN numero_cuota INTEGER;


/***********************************F-SCP-FFP-CONTA-0-30/11/2015****************************************/



/***********************************I-SCP-RAC-CONTA-0-10/12/2015****************************************/

--------------- SQL ---------------

CREATE TABLE conta.tajuste (
  id_ajuste SERIAL,
  fecha DATE DEFAULT now() NOT NULL,
  id_depto_conta INTEGER NOT NULL,
  obs TEXT,
  estado VARCHAR(20) DEFAULT 'borrador' NOT NULL,
  PRIMARY KEY(id_ajuste)
) INHERITS (pxp.tbase)
;

ALTER TABLE conta.tajuste
  OWNER TO postgres;

COMMENT ON COLUMN conta.tajuste.id_depto_conta
IS 'identificador del depto de contabilidad';

COMMENT ON COLUMN conta.tajuste.estado
IS 'borrador ,  procesado';


CREATE TABLE conta.tajuste_det (
  id_ajuste_det SERIAL,
  id_cuenta INTEGER NOT NULL,
  mayor NUMERIC DEFAULT 0 NOT NULL,
  mayor_mb NUMERIC DEFAULT 0 NOT NULL,
  mayor_mt NUMERIC DEFAULT 0 NOT NULL,
  act_mb NUMERIC,
  act_mt NUMERIC,
  dif_mb NUMERIC,
  dif_mt NUMERIC,
  tipo_cambio_1 NUMERIC,
  tipo_cambio_2 NUMERIC,
  id_ajuste INTEGER NOT NULL,
  PRIMARY KEY(id_ajuste_det)
) INHERITS (pxp.tbase)

WITH (oids = false);

COMMENT ON COLUMN conta.tajuste_det.id_cuenta
IS 'indetica la cuenta contable a ser ajustada';

COMMENT ON COLUMN conta.tajuste_det.mayor
IS 'mayor de la cuenta, en la moenda de la cuenta';

COMMENT ON COLUMN conta.tajuste_det.mayor_mb
IS 'mayor de la cuenta en moneda base';

COMMENT ON COLUMN conta.tajuste_det.mayor_mt
IS 'mayor de la cuenta en moneda de triangulacion';

COMMENT ON COLUMN conta.tajuste_det.act_mb
IS 'actulizacion de la cuenta en moneda base a la fache del ajuste';

COMMENT ON COLUMN conta.tajuste_det.act_mt
IS 'actulizacion de la cuenta en moneda de triangulación a la fecha del ajuste';

COMMENT ON COLUMN conta.tajuste_det.dif_mb
IS 'difenrecia en mb de la actulizacion y el mayor  en moenda base';

COMMENT ON COLUMN conta.tajuste_det.dif_mt
IS 'difenrecia en mb de la actulizacion y el mayor  en moenda de triangulación';

COMMENT ON COLUMN conta.tajuste_det.tipo_cambio_1
IS 'tipo de cambio 1 entre  la moneda de la cuenta y moneda base';

COMMENT ON COLUMN conta.tajuste_det.tipo_cambio_2
IS 'tipo de cambio 2,   entre la moneda de la cuenta y moneda de triangulacion';



--------------- SQL ---------------

ALTER TABLE conta.tcuenta
  ADD COLUMN sw_control_efectivo VARCHAR(6) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN conta.tcuenta.sw_control_efectivo
IS 'la cuenta realiza control de efectivo se marca en si la cuentas de bancos y cajas para sabe que estan tienen que ser actulizadas';


--------------- SQL ---------------

ALTER TABLE conta.tajuste_det
  ADD COLUMN revisado VARCHAR(4) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN conta.tajuste_det.revisado
IS 'solo los registros revisados se inlcuyen en el cbte de ajuste';


--------------- SQL ---------------

ALTER TABLE conta.tajuste_det
  ADD COLUMN dif_manual VARCHAR(4) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN conta.tajuste_det.dif_manual
IS 'si la diferencia a sido modificado manaulamente queda marcado como si';


--------------- SQL ---------------

ALTER TABLE conta.tajuste_det
  ADD COLUMN id_cuenta_bancaria INTEGER;

COMMENT ON COLUMN conta.tajuste_det.id_cuenta_bancaria
IS 'hace referancia a la cuenta bancaria';

--------------- SQL ---------------

ALTER TABLE conta.tajuste_det
  ADD COLUMN id_auxiliar INTEGER;

COMMENT ON COLUMN conta.tajuste_det.id_auxiliar
IS 'auxiliar contable';


--------------- SQL ---------------

ALTER TABLE conta.tajuste_det
  ADD COLUMN id_partida_ingreso INTEGER;

COMMENT ON COLUMN conta.tajuste_det.id_partida_ingreso
IS 'id partida para el ingreso en caso de ganancia';


--------------- SQL ---------------

ALTER TABLE conta.tajuste_det
  ADD COLUMN id_partida_egreso INTEGER;

COMMENT ON COLUMN conta.tajuste_det.id_partida_egreso
IS 'partida para el egreso en caso de perdida';

--------------- SQL ---------------

ALTER TABLE conta.tajuste
  ADD COLUMN tipo VARCHAR(30) DEFAULT 'bancos' NOT NULL;

COMMENT ON COLUMN conta.tajuste.tipo
IS 'tipo de ajuste , puede ser bancos, cajas o manual';



--------------- SQL ---------------

ALTER TABLE conta.tint_comprobante
  ADD COLUMN id_ajuste INTEGER;

COMMENT ON COLUMN conta.tint_comprobante.id_ajuste
IS 'idnetifica el ajuste de tipo de cambio que origino el comprobante';


/***********************************F-SCP-RAC-CONTA-0-10/12/2015****************************************/


/***********************************I-SCP-RAC-CONTA-0-17/12/2015****************************************/




--------------- SQL ---------------

ALTER TABLE conta.tajuste_det
  ADD COLUMN id_moneda_ajuste INTEGER;

COMMENT ON COLUMN conta.tajuste_det.id_moneda_ajuste
IS 'moenda sobre la que se realiza el ajuste, por defecto es la moneda de la cuenta, pero en ajsutes manaules puede variar segun la necesidad';



/***********************************F-SCP-RAC-CONTA-0-17/12/2015****************************************/


/***********************************I-SCP-RAC-CONTA-0-12/01/2016****************************************/

ALTER TABLE conta.tcuenta DROP CONSTRAINT chk_tcuenta__tipo_cuenta_pat RESTRICT;
  
/***********************************F-SCP-RAC-CONTA-12/01/2016****************************************/



/***********************************I-SCP-RAC-CONTA-0-05/02/2016****************************************/

--------------- SQL ---------------

ALTER TABLE conta.tdoc_compra_venta
  ADD COLUMN importe_retgar NUMERIC(18,2) DEFAULT 0 NOT NULL;

COMMENT ON COLUMN conta.tdoc_compra_venta.importe_retgar
IS 'importe de retencion de garantia';


--------------- SQL ---------------

ALTER TABLE conta.tdoc_compra_venta
  ADD COLUMN importe_anticipo NUMERIC(18,2) DEFAULT 0 NOT NULL;

COMMENT ON COLUMN conta.tdoc_compra_venta.importe_anticipo
IS 'importe anticipo ya sea apra compras o ventas';


--------------- SQL ---------------

ALTER TABLE conta.tdoc_compra_venta
  ADD COLUMN importe_pendiente NUMERIC(18,2) DEFAULT 0 NOT NULL;

COMMENT ON COLUMN conta.tdoc_compra_venta.importe_pendiente
IS 'cuentas por pagar o cuentas por cobrar';



--------------- SQL ---------------

ALTER TABLE conta.tdoc_concepto
  ADD COLUMN precio_total_final NUMERIC(19,2) DEFAULT 0 NOT NULL;

COMMENT ON COLUMN conta.tdoc_concepto.precio_total_final
IS 'precio final con que incluye los descuentos';


--------------- SQL ---------------

ALTER TABLE conta.tdoc_compra_venta
  ADD COLUMN importe_neto NUMERIC(19,2) DEFAULT 0 NOT NULL;

COMMENT ON COLUMN conta.tdoc_compra_venta.importe_neto
IS 'importe neto = importe doc - descuentos,
sobre este monto se ejecuta presupuesto y hacen las mayoria de los calculos';


/***********************************F-SCP-RAC-CONTA-0-05/02/2016****************************************/




/***********************************I-SCP-RAC-CONTA-0-11/02/2016****************************************/

--------------- SQL ---------------

ALTER TABLE conta.tdetalle_plantilla_comprobante
  ADD COLUMN codigo VARCHAR;

COMMENT ON COLUMN conta.tdetalle_plantilla_comprobante.codigo
IS 'codigo';


--------------- SQL ---------------

ALTER TABLE conta.tdoc_compra_venta
  ADD COLUMN id_proveedor INTEGER;
  
--------------- SQL ---------------

ALTER TABLE conta.tdoc_compra_venta
  ADD COLUMN id_cliente INTEGER;

COMMENT ON COLUMN conta.tdoc_compra_venta.id_cliente
IS 'identifica el cliente en ventas';  


--------------- SQL ---------------

ALTER TABLE conta.tdoc_compra_venta
  ADD COLUMN id_auxiliar INTEGER;

COMMENT ON COLUMN conta.tdoc_compra_venta.id_auxiliar
IS 'si la retencion de garantia, ancitipo, o pago pendiente son diferentes de cero es necesario indicar el auxiliar contable para identificar el provedor o cliente en contabilidad';


--------------- SQL ---------------

ALTER TABLE conta.tauxiliar
  ADD COLUMN corriente VARCHAR(4) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN conta.tauxiliar.corriente
IS 'indetifica que auxiliar son usados para acumular cuenta corriente en cotabilidad';


/***********************************F-SCP-RAC-CONTA-0-11/02/2016****************************************/





/***********************************I-SCP-RAC-CONTA-0-22/02/2016****************************************/


--------------- SQL ---------------

CREATE TABLE conta.ttipo_doc_compra_venta (
  id_tipo_doc_compra_venta SERIAL NOT NULL,
  codigo VARCHAR(5),
  nombre VARCHAR,
  tipo VARCHAR(13) DEFAULT 'compra' NOT NULL,
  obs VARCHAR,
  PRIMARY KEY(id_tipo_doc_compra_venta)
) INHERITS (pxp.tbase)
WITH (oids = false);

COMMENT ON COLUMN conta.ttipo_doc_compra_venta.tipo
IS 'es para compra o venta';


--------------- SQL ---------------

ALTER TABLE conta.tdoc_compra_venta
  ADD COLUMN id_tipo_doc_compra_venta INTEGER;

COMMENT ON COLUMN conta.tdoc_compra_venta.id_tipo_doc_compra_venta
IS 'dato para el reporte LCD de impuestos';

/***********************************F-SCP-RAC-CONTA-0-22/02/2016****************************************/






/***********************************I-SCP-RAC-CONTA-0-21/03/2016****************************************/


ALTER TABLE conta.tbanca_compra_venta
  ADD COLUMN saldo NUMERIC(10,2);


ALTER TABLE conta.tbanca_compra_venta
  ADD COLUMN resolucion VARCHAR(255);
  
  ALTER TABLE conta.tbanca_compra_venta
  ADD COLUMN tramite_cuota VARCHAR(255);
  
  
  
  ALTER TABLE conta.tbanca_compra_venta
  ADD COLUMN id_proceso_wf INTEGER;
  
/***********************************F-SCP-RAC-CONTA-0-21/03/2016****************************************/


/***********************************I-SCP-RAC-CONTA-0-05/04/2016****************************************/


--------------- SQL ---------------

ALTER TABLE conta.tplantilla_comprobante
  ADD COLUMN funcion_comprobante_prevalidado TEXT;

COMMENT ON COLUMN conta.tplantilla_comprobante.funcion_comprobante_prevalidado
IS 'esta funcion se ejecuta previamente a la validacion del comprobante,  puede ser util para revertir presupuestos previamente validados';



--------------- SQL ---------------

ALTER TABLE conta.tplantilla_comprobante
  ADD COLUMN funcion_comprobante_validado_eliminado TEXT;

COMMENT ON COLUMN conta.tplantilla_comprobante.funcion_comprobante_validado_eliminado
IS 'esta funcion corre al apretar el boton eliminar de un un comprobante generado que ya a sido validado';

/***********************************F-SCP-RAC-CONTA-0-05/04/2016****************************************/


/***********************************I-SCP-RAC-CONTA-1-05/04/2016****************************************/



--------------- SQL ---------------

ALTER TABLE conta.tint_comprobante
  ADD COLUMN volcado VARCHAR(3) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN conta.tint_comprobante.volcado
IS 'indica si el comprobante tiene un volcaco';

--------------- SQL ---------------

ALTER TABLE conta.tint_comprobante
  ADD COLUMN cbte_reversion VARCHAR(4) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN conta.tint_comprobante.cbte_reversion
IS 'si o no, es un cbte de reversion, los cbtes de reversion tienen un manejo presupuestario diferente';


--------------- SQL ---------------

ALTER TABLE conta.tint_rel_devengado
  ADD COLUMN sw_reversion VARCHAR(4) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN conta.tint_rel_devengado.sw_reversion
IS 'cuando es una reversion los montos son negativos y esta bandera es marcada';




/***********************************F-SCP-RAC-CONTA-1-05/04/2016****************************************/


/***********************************I-SCP-FFP-CONTA-1-20/05/2016****************************************/

ALTER TABLE conta.tbanca_compra_venta
  ADD COLUMN retencion_cuota numeric(10,2) DEFAULT 0 NOT NULL;

  ALTER TABLE conta.tbanca_compra_venta
  ADD COLUMN multa_cuota numeric(10,2) DEFAULT 0 NOT NULL;
  
ALTER TABLE conta.tbanca_compra_venta
  ADD COLUMN estado_libro VARCHAR(255) NULL ;
  
  ALTER TABLE conta.tbanca_compra_venta
  ALTER COLUMN monto_acumulado TYPE NUMERIC(12,2);
  

/***********************************F-SCP-FFP-CONTA-1-20/05/2016****************************************/



/***********************************I-SCP-FFP-CONTA-1-24/05/2016****************************************/




--------------- SQL ---------------

ALTER TABLE conta.tint_comprobante
  ADD COLUMN id_proceso_wf INTEGER;

COMMENT ON COLUMN conta.tint_comprobante.id_proceso_wf
IS 'identifica el proceso_wf';



--------------- SQL ---------------

ALTER TABLE conta.tint_comprobante
  ADD COLUMN id_estado_wf INTEGER;


/***********************************F-SCP-FFP-CONTA-1-24/05/2016****************************************/


/***********************************I-SCP-RAC-CONTA-1-22/06/2016****************************************/

--------------- SQL ---------------

ALTER TABLE conta.tdoc_concepto
  ADD COLUMN id_partida INTEGER;

COMMENT ON COLUMN conta.tdoc_concepto.id_partida
IS 'cuando el documento compromete aca guarda la partida correspondiente';


/***********************************F-SCP-RAC-CONTA-1-22/06/2016****************************************/


/***********************************I-SCP-RAC-CONTA-0-03/08/2016****************************************/

ALTER TABLE conta.tdetalle_plantilla_comprobante
  ADD COLUMN campo_relacion_contable_cc TEXT;

COMMENT ON COLUMN conta.tdetalle_plantilla_comprobante.campo_relacion_contable_cc
IS 'sirve para parametrizar el campo de la relacion contable para obtener el centro de costo';

--------------- SQL ---------------

ALTER TABLE conta.tdetalle_plantilla_comprobante
  ADD COLUMN tipo_relacion_contable_cc VARCHAR(255);

--------------- SQL ---------------

COMMENT ON COLUMN conta.tdetalle_plantilla_comprobante.tipo_relacion_contable_cc
IS 'relacion contable par ael calculo de centro de costo';

/***********************************F-SCP-RAC-CONTA-0-03/08/2016****************************************/

/***********************************I-SCP-JRR-CONTA-0-15/08/2016****************************************/
ALTER TABLE conta.tint_comprobante
  ADD COLUMN c31 VARCHAR(200);

ALTER TABLE conta.tint_comprobante
  ADD COLUMN fecha_c31 DATE;

/***********************************F-SCP-JRR-CONTA-0-15/08/2016****************************************/

/***********************************I-SCP-RAC-CONTA-0-31/08/2016****************************************/

--------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ADD COLUMN orden NUMERIC(18,2) DEFAULT 0 NOT NULL;

COMMENT ON COLUMN conta.tint_transaccion.orden
IS 'este campo define el orden de impresion, inicialmente se copia el id, pero al ser nuemric permite mover el orden usando decimales';


/***********************************F-SCP-RAC-CONTA-0-31/08/2016****************************************/



/***********************************I-SCP-RAC-CONTA-0-03/10/2016****************************************/


CREATE TABLE conta.tcuenta_tmp (
  codigo VARCHAR,
  c1 VARCHAR,
  c2 VARCHAR,
  c3 VARCHAR,
  c4 VARCHAR,
  c5 VARCHAR,
  mov VARCHAR(10) NOT NULL,
  aux VARCHAR(16),
  nivel INTEGER,
  c6 VARCHAR,
  eeff VARCHAR(12) DEFAULT 'B'::character varying,
  saldo VARCHAR(12) DEFAULT 'D'::character varying NOT NULL,
  tipo_cuenta VARCHAR(30) DEFAULT 'activo'::character varying NOT NULL
) 
WITH (oids = false);

ALTER TABLE conta.tcuenta_tmp
  ALTER COLUMN codigo SET STATISTICS 0;

COMMENT ON TABLE conta.tcuenta_tmp
IS 'tabla para migrar desde un excel y transofrmar al formato arbol';


/***********************************F-SCP-RAC-CONTA-0-03/10/2016****************************************/



/***********************************I-SCP-RAC-CONTA-0-20/10/2016****************************************/


--------------- SQL ---------------

ALTER TABLE conta.tclase_comprobante
  ADD COLUMN tiene_apertura VARCHAR(8) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN conta.tclase_comprobante.tiene_apertura
IS 'esa calse de comprobantes admite cbte de apertura, esto es para saber si va saltar la numeracion o no';



/***********************************F-SCP-RAC-CONTA-0-20/10/2016****************************************/


/***********************************I-SCP-RAC-CONTA-0-17/11/2016****************************************/


--------------- SQL ---------------

CREATE TABLE conta.tentrega (
  id_entrega SERIAL NOT NULL,
  fecha_c31 DATE,
  c31 VARCHAR(200),
  estado VARCHAR(20) DEFAULT 'borrador' NOT NULL,
  PRIMARY KEY(id_entrega)
) INHERITS (pxp.tbase)

WITH (oids = false);

COMMENT ON COLUMN conta.tentrega.estado
IS 'borrador o finalizado';


CREATE TABLE conta.tentrega_det (
  id_entrega_det SERIAL,
  id_entrega INTEGER NOT NULL,
  id_int_comprobante INTEGER,
  CONSTRAINT tentrega_det_pkey PRIMARY KEY(id_entrega_det)
) INHERITS (pxp.tbase)

WITH (oids = false);

/***********************************F-SCP-RAC-CONTA-0-17/11/2016****************************************/


/***********************************I-SCP-RAC-CONTA-1-17/11/2016****************************************/

--------------- SQL ---------------

ALTER TABLE conta.tentrega
  ADD COLUMN obs VARCHAR;
  
  --------------- SQL ---------------

ALTER TABLE conta.tentrega
  ADD COLUMN id_tipo_relacion_comprobante INTEGER;
  
/***********************************F-SCP-RAC-CONTA-1-17/11/2016****************************************/


/***********************************I-SCP-RAC-CONTA-0-22/11/2016****************************************/



--------------- SQL ---------------

ALTER TABLE conta.tentrega
  ADD COLUMN id_depto_conta INTEGER;

COMMENT ON COLUMN conta.tentrega.id_depto_conta
IS 'indetifica el depto de contabilidad';



/***********************************F-SCP-RAC-CONTA-0-22/11/2016****************************************/


/***********************************I-SCP-RAC-CONTA-0-01/12/2016****************************************/

--------------- SQL ---------------

ALTER TABLE conta.tint_comprobante
  ADD COLUMN forma_cambio VARCHAR(20) DEFAULT 'oficial' NOT NULL;

COMMENT ON COLUMN conta.tint_comprobante.forma_cambio
IS 'oficial, compra, venta, convenido';

/***********************************F-SCP-RAC-CONTA-0-01/12/2016****************************************/


/***********************************I-SCP-RAC-CONTA-0-05/12/2016****************************************/

--------------- SQL ---------------

ALTER TABLE conta.tclase_comprobante
  ADD COLUMN movimiento VARCHAR(20) DEFAULT 'diario' NOT NULL;

COMMENT ON COLUMN conta.tclase_comprobante.movimiento
IS 'diario, ingreso o egreso';

/***********************************F-SCP-RAC-CONTA-0-05/12/2016****************************************/


/***********************************I-SCP-RAC-CONTA-0-07/12/2016****************************************/

--------------- SQL ---------------

ALTER TABLE conta.tconfig_tipo_cuenta
  ADD COLUMN movimiento VARCHAR(20) DEFAULT 'diario' NOT NULL;

COMMENT ON COLUMN conta.tconfig_tipo_cuenta.movimiento
IS 'Con que tiemo de comprobantes de mueven estan cuentas, diario, ingreso, movimiento';


/***********************************F-SCP-RAC-CONTA-0-07/12/2016****************************************/



/***********************************I-SCP-RAC-CONTA-0-19/12/2016****************************************/

--------------- SQL ---------------

ALTER TABLE conta.tresultado_plantilla
  ADD COLUMN id_tipo_relacion_comprobante INTEGER;

COMMENT ON COLUMN conta.tresultado_plantilla.id_tipo_relacion_comprobante
IS 'se utiliza cuando el periodode calculo es igual a cbte, determina el tipo de relacion con el comprobante original';


--------------- SQL ---------------

ALTER TABLE conta.tresultado_plantilla
  ADD COLUMN relacion_unica VARCHAR(6) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN conta.tresultado_plantilla.relacion_unica
IS 'si o no, solo se utiliza cuando el preiodo de calculo es giual a cbte, sirve apra validar que el comprobante origen solo tenga una relacion de este tipo y no mas';

/***********************************F-SCP-RAC-CONTA-0-19/12/2016****************************************/



/***********************************I-SCP-FFP-CONTA-0-30/12/2016****************************************/


/*
CREATE TABLE conta.tplan_pago_documento_airbp (
  id_plan_pago_documento_airbp SERIAL,
  id_plan_pago INTEGER,
  id_documento INTEGER,
  monto_fac NUMERIC(10,2),
  monto_usado NUMERIC(10,2),
  monto_disponible NUMERIC(8,2),
  usar VARCHAR(255),
  PRIMARY KEY(id_plan_pago_documento_airbp)
) INHERITS (pxp.tbase)
WITH (oids = false);*/

--ALTER TABLE conta.tplan_pago_documento_airbp ADD monto_acumulado NUMERIC(10,2) NULL;

CREATE TABLE conta.tbancarizacion_gestion (
  id_bancarizacion_gestion SERIAL,
  id_gestion INTEGER,
  estado VARCHAR(255),
  PRIMARY KEY(id_bancarizacion_gestion)
) INHERITS (pxp.tbase)
WITH (oids = false);


/***********************************F-SCP-FFP-CONTA-0-30/12/2016****************************************/

/***********************************I-SCP-GSS-CONTA-0-12/01/2017****************************************/

CREATE TABLE conta.tarchivo_airbp (
  id_archivo_airbp SERIAL NOT NULL,
  nombre_archivo VARCHAR(100),
  mes INTEGER,
  anio INTEGER,
  PRIMARY KEY(id_archivo_airbp)
) INHERITS (pxp.tbase)

WITH (oids = false);

CREATE TABLE conta.tfactura_airbp (
  id_factura_airbp SERIAL NOT NULL,
  id_doc_compra_venta INTEGER,
  punto_venta VARCHAR(10),
  tipo_cambio NUMERIC(8,2),
  id_cliente INTEGER,
  estado VARCHAR(1),
  PRIMARY KEY(id_factura_airbp)
) INHERITS (pxp.tbase)

WITH (oids = false);

CREATE TABLE conta.tfactura_airbp_concepto (
  id_factura_airbp_concepto SERIAL,
  id_factura_airbp INTEGER,
  cantidad INTEGER,
  precio_unitario NUMERIC(8,2),
  total_bs NUMERIC(8,2),
  ne VARCHAR(10),
  articulo VARCHAR(10),
  destino VARCHAR(5),
  matricula VARCHAR(10),
  PRIMARY KEY(id_factura_airbp_concepto)
) INHERITS (pxp.tbase)

WITH (oids = false);

/***********************************F-SCP-GSS-CONTA-0-12/01/2017***************************************/




/***********************************I-SCP-RAC-CONTA-0-20/02/2017****************************************/


--------------- SQL ---------------

ALTER TABLE conta.tentrega
  ADD COLUMN id_estado_wf INTEGER;
  
  --------------- SQL ---------------

ALTER TABLE conta.tentrega
  ADD COLUMN id_proceso_wf INTEGER;
  
  
/***********************************F-SCP-RAC-CONTA-0-20/02/2017****************************************/


/***********************************I-SCP-GVC-CONTA-0-04/04/2017****************************************/
CREATE UNIQUE INDEX tauxiliar_idx ON conta.tauxiliar
  USING btree ("codigo_auxiliar");

CREATE UNIQUE INDEX tauxiliar_idx1 ON conta.tauxiliar
  USING btree ("nombre_auxiliar");

/***********************************F-SCP-GVC-CONTA-0-04/04/2017****************************************/


/***********************************I-SCP-GSS-CONTA-0-10/05/2017****************************************/

CREATE TABLE conta.tarchivo_sigep (
  id_archivo_sigep SERIAL,
  nombre_archivo VARCHAR,
  extension VARCHAR,
  url VARCHAR,
  CONSTRAINT tarchivo_sigep_pkey PRIMARY KEY(id_archivo_sigep)
) INHERITS (pxp.tbase)

WITH (oids = false);

CREATE TABLE conta.tgasto_sigep (
  id_gasto_sigep SERIAL,
  gestion INTEGER,
  objeto VARCHAR(10),
  descripcion_gasto VARCHAR(150),
  fuente INTEGER,
  organismo INTEGER,
  programa INTEGER,
  proyecto INTEGER,
  actividad INTEGER,
  entidad_transferencia VARCHAR(20),
  nro_preventivo INTEGER,
  nro_devengado INTEGER,
  nro_comprometido INTEGER,
  id_archivo_sigep INTEGER,
  monto NUMERIC,
  estado VARCHAR(10),
  CONSTRAINT tgasto_sigep_pkey PRIMARY KEY(id_gasto_sigep)
) INHERITS (pxp.tbase)

WITH (oids = false);

/***********************************F-SCP-GSS-CONTA-0-10/05/2017****************************************/


/***********************************I-SCP-RAC-CONTA-0-12/05/2017****************************************/




--------------- SQL ---------------

ALTER TABLE conta.torden_trabajo
  ADD COLUMN id_orden_trabajo_fk INTEGER;

COMMENT ON COLUMN conta.torden_trabajo.id_orden_trabajo_fk
IS 'las ordene de trabajo se convierten en arbol, para poder estructurar un arbold e costos';


--------------- SQL ---------------

ALTER TABLE conta.torden_trabajo
  ADD COLUMN tipo VARCHAR(20) DEFAULT 'estadistica' NOT NULL;

COMMENT ON COLUMN conta.torden_trabajo.tipo
IS 'tipo de ordenes,   centro, pep, orden, estadistica';

--------------- SQL ---------------

ALTER TABLE conta.torden_trabajo
  ADD COLUMN movimiento VARCHAR(5) DEFAULT 'si' NOT NULL;

COMMENT ON COLUMN conta.torden_trabajo.movimiento
IS 'los nodos de movimeitnos con movimiento se usan en las diferentes transacciones en caso contrario son solo agrupadores';


--------------- SQL ---------------

ALTER TABLE conta.torden_trabajo
  ADD COLUMN codigo VARCHAR(100) DEFAULT '' NOT NULL;




/***********************************F-SCP-RAC-CONTA-0-12/05/2017****************************************/




/***********************************I-SCP-RAC-CONTA-0-15/05/2017****************************************/


CREATE TABLE conta.tsuborden (
  id_suborden SERIAL,
  codigo VARCHAR(200) NOT NULL,
  nombre VARCHAR,
  estado VARCHAR(30) DEFAULT 'vigente'::character varying NOT NULL,
  CONSTRAINT tsuborden_pkey PRIMARY KEY(id_suborden)
) INHERITS (pxp.tbase)

WITH (oids = false);

COMMENT ON COLUMN conta.tsuborden.estado
IS 'vigente o cerrada';


--------------- SQL ---------------

CREATE TABLE conta.torden_suborden (
  id_orden_suborden SERIAL NOT NULL,
  id_orden_trabajo INTEGER NOT NULL,
  id_suborden INTEGER NOT NULL,
  PRIMARY KEY(id_orden_suborden)
) INHERITS (pxp.tbase)

WITH (oids = false);
  
  
  
/***********************************F-SCP-RAC-CONTA-0-15/05/2017****************************************/



/***********************************I-SCP-RAC-CONTA-1-15/05/2017****************************************/
  
  
  --------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ADD COLUMN id_suborden INTEGER;

COMMENT ON COLUMN conta.tint_transaccion.id_suborden
IS 'agruapdor de costos del tipo suborden';


  
/***********************************F-SCP-RAC-CONTA-1-15/05/2017****************************************/


/***********************************I-SCP-RAC-CONTA-1-16/05/2017****************************************/


--------------- SQL ---------------

ALTER TABLE conta.tplantilla_comprobante
  ADD COLUMN desc_plantilla VARCHAR DEFAULT '' NOT NULL;

COMMENT ON COLUMN conta.tplantilla_comprobante.desc_plantilla
IS 'descripcion de la plantilla del comprobante, explica de que se trata';


--------------- SQL ---------------

ALTER TABLE conta.tdetalle_plantilla_comprobante
  ADD COLUMN campo_suborden VARCHAR(350);

COMMENT ON COLUMN conta.tdetalle_plantilla_comprobante.campo_suborden
IS 'para la definicion de usbordenes';


  
/***********************************F-SCP-RAC-CONTA-1-16/05/2017****************************************/



/***********************************I-SCP-FFP-CONTA-0-24/05/2017****************************************/


CREATE TABLE conta.tbancarizacion_periodo(
  id_bancarizacion_periodo SERIAL NOT NULL,
  id_periodo int4 NOT NULL,
  estado VARCHAR(255) NOT NULL,
  PRIMARY KEY (id_bancarizacion_periodo))
  INHERITS (pxp.tbase);

/***********************************F-SCP-FFP-CONTA-0-24/05/2017****************************************/



/***********************************I-SCP-RAC-CONTA-0-26/05/2017****************************************/


--Columnas olvidades de poner en archivo
--------------- SQL ---------------

ALTER TABLE conta.tdoc_compra_venta
  ADD COLUMN estacion VARCHAR(4);

COMMENT ON COLUMN conta.tdoc_compra_venta.estacion
IS 'esta es una columna propi ade boa para manejo de agencias';

--------------- SQL ---------------

ALTER TABLE conta.tdoc_compra_venta
  ADD COLUMN id_punto_venta INTEGER;

COMMENT ON COLUMN conta.tdoc_compra_venta.id_punto_venta
IS 'columna propia de boa para manejo de agencias';


--------------- SQL ---------------

ALTER TABLE conta.tdoc_compra_venta
  ADD COLUMN id_agencia INTEGER;

COMMENT ON COLUMN conta.tdoc_compra_venta.id_agencia
IS 'column apropia de boa para trabajr con agencias';

/***********************************F-SCP-RAC-CONTA-0-26/05/2017****************************************/



