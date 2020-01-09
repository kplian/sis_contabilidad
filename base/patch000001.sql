
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


/***********************************I-SCP-RAC-CONTA-0-31/05/2017****************************************/


--------------- SQL ---------------

CREATE TABLE conta.ttipo_cc_ot (
  id_tipo_cc_ot SERIAL NOT NULL,
  id_tipo_cc INTEGER NOT NULL,
  id_orden_trabajo INTEGER NOT NULL,
  PRIMARY KEY(id_tipo_cc_ot)
) INHERITS (pxp.tbase)

WITH (oids = false);


/***********************************F-SCP-RAC-CONTA-0-31/05/2017****************************************/



/***********************************I-SCP-RAC-CONTA-0-07/06/2017****************************************/


--------------- SQL ---------------

CREATE TABLE conta.tconfig_subtipo_cuenta (
  id_config_subtipo_cuenta SERIAL NOT NULL,
  codigo VARCHAR(300),
  nombre VARCHAR(500) NOT NULL,
  descripcion VARCHAR,
  id_config_tipo_cuenta INTEGER,
  PRIMARY KEY(id_config_subtipo_cuenta)
) INHERITS (pxp.tbase)

WITH (oids = false);


--------------- SQL ---------------

ALTER TABLE conta.tcuenta
  ADD COLUMN id_config_subtipo_cuenta INTEGER;


--------------- SQL ---------------

ALTER TABLE conta.tconfig_tipo_cuenta
  RENAME COLUMN id_cofig_tipo_cuenta TO id_config_tipo_cuenta;
  
  
/***********************************F-SCP-RAC-CONTA-0-07/06/2017****************************************/


/***********************************I-SCP-RAC-CONTA-0-08/06/2017****************************************/

--------------- SQL ---------------

ALTER TABLE conta.tplantilla_comprobante
  ADD COLUMN campo_cbte_relacionado VARCHAR(350);
  
  --------------- SQL ---------------

ALTER TABLE conta.tplantilla_comprobante
  ADD COLUMN codigo_tipo_relacion VARCHAR(350);
  
/***********************************F-SCP-RAC-CONTA-0-08/06/2017****************************************/



/***********************************I-SCP-RAC-CONTA-0-22/06/2017****************************************/

--------------- SQL ---------------

CREATE TABLE conta.trango (
  id_rango SERIAL NOT NULL,
  id_tipo_cc INTEGER NOT NULL,
  id_periodo INTEGER NOT NULL,
  debe_mb NUMERIC,
  haber_mb NUMERIC,
  debe_mt NUMERIC,
  haber_mt NUMERIC(1,0),
  PRIMARY KEY(id_rango)
) INHERITS (pxp.tbase)

WITH (oids = false);

COMMENT ON TABLE conta.trango
IS 'esta tabla sirve apra generar el reporte de costos de manera rapida, necesita ser sincornizada para tener lso datos actualizados (los datos de esta tabla son solo para fines de consulta)';

/***********************************F-SCP-RAC-CONTA-0-22/06/2017****************************************/
/***********************************I-SCP-MMV-CONTA-0-28/06/2017****************************************/
CREATE TABLE conta.tanexos_actualizaciones (
  id_anexos_actualizaciones SERIAL,
  nit_proveerdor VARCHAR(255),
  nro_contrato VARCHAR(255) NOT NULL,
  nit_comisionista VARCHAR(255),
  fecha_vigente DATE,
  codigo_producto VARCHAR(255),
  descripcion_producto VARCHAR(1000),
  precio_unitario NUMERIC(10,2),
  tipo_comision VARCHAR(255),
  monto_porcentaje VARCHAR(255),
  revisado VARCHAR(10) DEFAULT 'no'::character varying,
  id_periodo INTEGER,
  id_depto_conta INTEGER,
  registro VARCHAR(255),
  tipo_anexo VARCHAR(255),
  lista_negra VARCHAR(20) DEFAULT 'no'::character varying,
  tipo_documento VARCHAR(200),
  CONSTRAINT tanexos_actualizaciones_pkey PRIMARY KEY(id_anexos_actualizaciones)
) INHERITS (pxp.tbase)

WITH (oids = false);

ALTER TABLE conta.tanexos_actualizaciones
  ALTER COLUMN id_anexos_actualizaciones SET STATISTICS 0;

ALTER TABLE conta.tanexos_actualizaciones
  ALTER COLUMN nit_proveerdor SET STATISTICS 0;

ALTER TABLE conta.tanexos_actualizaciones
  ALTER COLUMN nro_contrato SET STATISTICS 0;

ALTER TABLE conta.tanexos_actualizaciones
  ALTER COLUMN nit_comisionista SET STATISTICS 0;

ALTER TABLE conta.tanexos_actualizaciones
  ALTER COLUMN fecha_vigente SET STATISTICS 0;

ALTER TABLE conta.tanexos_actualizaciones
  ALTER COLUMN codigo_producto SET STATISTICS 0;

ALTER TABLE conta.tanexos_actualizaciones
  ALTER COLUMN precio_unitario SET STATISTICS 0;

ALTER TABLE conta.tanexos_actualizaciones
  ALTER COLUMN monto_porcentaje SET STATISTICS 0;

ALTER TABLE conta.tanexos_actualizaciones
  ALTER COLUMN id_depto_conta SET STATISTICS 0;

ALTER TABLE conta.tanexos_actualizaciones
  ALTER COLUMN tipo_anexo SET STATISTICS 0;

ALTER TABLE conta.tanexos_actualizaciones
  ALTER COLUMN lista_negra SET STATISTICS 0;

ALTER TABLE conta.tanexos_actualizaciones
  ALTER COLUMN tipo_documento SET STATISTICS 0;

  CREATE TABLE conta.tcomisionistas (
  id_comisionista SERIAL,
  nro_contrato VARCHAR(255) NOT NULL,
  codigo_producto VARCHAR(255),
  descripcion_producto VARCHAR(1000),
  cantidad_total_entregado NUMERIC(10,2),
  cantidad_total_vendido NUMERIC(10,2) DEFAULT 0,
  precio_unitario NUMERIC(10,2),
  monto_total NUMERIC(10,2),
  monto_total_comision NUMERIC(10,2),
  revisado VARCHAR(20) DEFAULT 'no'::character varying,
  id_periodo INTEGER,
  id_depto_conta INTEGER,
  registro VARCHAR(255),
  tipo_comisionista VARCHAR(255),
  lista_negra VARCHAR(20) DEFAULT 'no'::character varying,
  nit_comisionista VARCHAR(255),
  CONSTRAINT tcomisionistas_pkey PRIMARY KEY(id_comisionista)
) INHERITS (pxp.tbase)

WITH (oids = false);

ALTER TABLE conta.tcomisionistas
  ALTER COLUMN nro_contrato SET STATISTICS 0;

ALTER TABLE conta.tcomisionistas
  ALTER COLUMN codigo_producto SET STATISTICS 0;

ALTER TABLE conta.tcomisionistas
  ALTER COLUMN descripcion_producto SET STATISTICS 0;

ALTER TABLE conta.tcomisionistas
  ALTER COLUMN cantidad_total_entregado SET STATISTICS 0;

ALTER TABLE conta.tcomisionistas
  ALTER COLUMN cantidad_total_vendido SET STATISTICS 0;

ALTER TABLE conta.tcomisionistas
  ALTER COLUMN precio_unitario SET STATISTICS 0;

ALTER TABLE conta.tcomisionistas
  ALTER COLUMN revisado SET STATISTICS 0;

ALTER TABLE conta.tcomisionistas
  ALTER COLUMN registro SET STATISTICS 0;

  CREATE TABLE conta.tperiodo_resolucion (
  id_periodo_resolucion SERIAL,
  id_depto INTEGER,
  id_periodo INTEGER,
  estado VARCHAR(20) DEFAULT 'abierto'::character varying NOT NULL,
  CONSTRAINT tperiodo_resolucion_pkey PRIMARY KEY(id_periodo_resolucion)
) INHERITS (pxp.tbase)

WITH (oids = false);

ALTER TABLE conta.tperiodo_resolucion
  ALTER COLUMN id_periodo_resolucion SET STATISTICS 0;

ALTER TABLE conta.tperiodo_resolucion
  ALTER COLUMN id_depto SET STATISTICS 0;

ALTER TABLE conta.tperiodo_resolucion
  ALTER COLUMN id_periodo SET STATISTICS 0;

  CREATE TABLE conta.tpersona_naturales (
  id_persona_natural SERIAL,
  codigo_cliente VARCHAR(255) NOT NULL,
  nro_documeneto VARCHAR(250) NOT NULL,
  nombre VARCHAR(500) NOT NULL,
  cantidad_producto NUMERIC(10,2) NOT NULL,
  codigo_producto VARCHAR(255) NOT NULL,
  descripcion VARCHAR(1000) NOT NULL,
  precio_unitario NUMERIC(10,2) NOT NULL,
  importe_total NUMERIC(10,2) NOT NULL,
  revisado VARCHAR(10) DEFAULT 'no'::character varying,
  id_periodo INTEGER,
  id_depto_conta INTEGER,
  registro VARCHAR(255),
  tipo_persona_natural VARCHAR(255),
  lista_negra VARCHAR(20) DEFAULT 'no'::character varying,
  tipo_documento VARCHAR(200),
  CONSTRAINT tpersona_naturales_pkey PRIMARY KEY(id_persona_natural)
) INHERITS (pxp.tbase)

WITH (oids = false);

ALTER TABLE conta.tpersona_naturales
  ALTER COLUMN id_persona_natural SET STATISTICS 0;

ALTER TABLE conta.tpersona_naturales
  ALTER COLUMN codigo_cliente SET STATISTICS 0;

ALTER TABLE conta.tpersona_naturales
  ALTER COLUMN nombre SET STATISTICS 0;

ALTER TABLE conta.tpersona_naturales
  ALTER COLUMN cantidad_producto SET STATISTICS 0;

ALTER TABLE conta.tpersona_naturales
  ALTER COLUMN codigo_producto SET STATISTICS 0;

ALTER TABLE conta.tpersona_naturales
  ALTER COLUMN descripcion SET STATISTICS 0;

ALTER TABLE conta.tpersona_naturales
  ALTER COLUMN precio_unitario SET STATISTICS 0;

ALTER TABLE conta.tpersona_naturales
  ALTER COLUMN importe_total SET STATISTICS 0;

  CREATE TABLE conta.tregimen_simplificado (
  id_simplificado SERIAL,
  codigo_cliente VARCHAR(250) NOT NULL,
  nit VARCHAR(255) NOT NULL,
  cantidad_producto NUMERIC(10,2),
  codigo_producto VARCHAR(255) NOT NULL,
  descripcion VARCHAR(1000),
  precio_unitario NUMERIC(10,2),
  importe_total NUMERIC(10,2) DEFAULT 0,
  revisado VARCHAR(10) DEFAULT 'no'::character varying,
  id_periodo INTEGER,
  id_depto_conta INTEGER,
  registro VARCHAR(255),
  tipo_regimen_simplificado VARCHAR(255),
  lista_negra VARCHAR(20) DEFAULT 'no'::character varying,
  CONSTRAINT tsimplificado_pkey PRIMARY KEY(id_simplificado)
) INHERITS (pxp.tbase)

WITH (oids = false);

ALTER TABLE conta.tregimen_simplificado
  ALTER COLUMN id_simplificado SET STATISTICS 0;

ALTER TABLE conta.tregimen_simplificado
  ALTER COLUMN codigo_cliente SET STATISTICS 0;

ALTER TABLE conta.tregimen_simplificado
  ALTER COLUMN cantidad_producto SET STATISTICS 0;

ALTER TABLE conta.tregimen_simplificado
  ALTER COLUMN codigo_producto SET STATISTICS 0;

ALTER TABLE conta.tregimen_simplificado
  ALTER COLUMN descripcion SET STATISTICS 0;

ALTER TABLE conta.tregimen_simplificado
  ALTER COLUMN precio_unitario SET STATISTICS 0;

ALTER TABLE conta.tregimen_simplificado
  ALTER COLUMN importe_total SET STATISTICS 0;

COMMENT ON COLUMN conta.tregimen_simplificado.codigo_cliente
IS 'Código del cliente asignado por el proveedor o parte numérica de la
cédula de identidad.';

COMMENT ON COLUMN conta.tregimen_simplificado.nit
IS 'Número de Identificación Tributaria del cliente RTS.';

COMMENT ON COLUMN conta.tregimen_simplificado.codigo_producto
IS 'Consignar el código único de identificación del producto.';

COMMENT ON COLUMN conta.tregimen_simplificado.descripcion
IS 'Consignar la descripción del producto vendido al cliente RTS.';

COMMENT ON COLUMN conta.tregimen_simplificado.precio_unitario
IS 'Consignar el porcentaje de descuento por producto vendido al cliente
RTS (Ejemplo: 10%, 5.5%, 0.05%). Si no corresponde, consignar el
valor 0.';
/***********************************F-SCP-MMV-CONTA-0-28/06/2017****************************************/
/***********************************I-SCP-MMV-CONTA-1-28/06/2017****************************************/
CREATE TYPE conta.json_act_anexos AS (
  nit_proveerdor VARCHAR(255),
  nro_contrato VARCHAR(255),
  nit_comisionista VARCHAR(255),
  fecha_vigente VARCHAR(255),
  codigo_producto VARCHAR(255),
  descripcion_producto VARCHAR(255),
  precio_unitario VARCHAR(255),
  tipo_comision VARCHAR(255),
  monto_porcentaje VARCHAR(255)
);
CREATE TYPE conta.json_comisionistas AS (
  nit_comisionista VARCHAR(255),
  razon_social VARCHAR(255),
  nro_contrato VARCHAR(255),
  codigo_producto VARCHAR(255),
  descripcion_producto VARCHAR(255),
  cantidad_total_entregado VARCHAR(255),
  cantidad_total_vendido VARCHAR(255),
  precio_unitario VARCHAR(255),
  monto_total VARCHAR(255),
  monto_total_comision VARCHAR(255)
);
CREATE TYPE conta.json_persona_natural AS (
  codigo_cliente VARCHAR(255),
  nro_documeneto VARCHAR(255),
  nombre VARCHAR(255),
  cantidad_producto VARCHAR(255),
  codigo_producto VARCHAR(255),
  descripcion VARCHAR(255),
  tipo_documento VARCHAR(255),
  precio_unitario VARCHAR(255),
  importe_total VARCHAR(255)
);
CREATE TYPE conta.json_regimen_simplificado AS (
  codigo_cliente VARCHAR(255),
  nit VARCHAR(255),
  cantidad_producto VARCHAR(255),
  codigo_producto VARCHAR(255),
  descripcion VARCHAR(255),
  precio_unitario VARCHAR(255),
  importe_total VARCHAR(255),
  fecha_documento VARCHAR(255)
);
/***********************************F-SCP-MMV-CONTA-1-28/06/2017****************************************/


/***********************************I-SCP-RAC-CONTA-1-05/07/2017****************************************/
ALTER TABLE conta.trango
  ADD COLUMN memoria NUMERIC;  
--------------- SQL ---------------
ALTER TABLE conta.trango
  ADD COLUMN formulado NUMERIC;
--------------- SQL ---------------
ALTER TABLE conta.trango
  ADD COLUMN comprometido NUMERIC;

ALTER TABLE conta.trango
  ADD COLUMN ejecutado NUMERIC; 

ALTER TABLE conta.trango
  ADD COLUMN id_partida INTEGER;  
  
/***********************************F-SCP-RAC-CONTA-1-05/07/2017****************************************/


/***********************************I-SCP-RAC-CONTA-1-11/07/2017****************************************/

--------------- SQL ---------------

ALTER TABLE conta.tconfig_cambiaria
  ADD COLUMN ope_3 VARCHAR DEFAULT '{MB}->{MA}' NOT NULL;
  
--------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ADD COLUMN tipo_cambio_3 NUMERIC;

COMMENT ON COLUMN conta.tint_transaccion.tipo_cambio_3
IS 'tipo de cambio para la segtercera unda operación';

--------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ADD COLUMN id_moneda_act INTEGER;

COMMENT ON COLUMN conta.tint_transaccion.id_moneda_act
IS 'identifica la moneda de actualizacion';

--------------- SQL ---------------

ALTER TABLE conta.tint_comprobante
  ADD COLUMN tipo_cambio_3 NUMERIC;

COMMENT ON COLUMN conta.tint_comprobante.tipo_cambio_3
IS 'tipo de cambio para la tercera operacion'; 


--------------- SQL ---------------

ALTER TABLE conta.tint_comprobante
  ADD COLUMN id_moneda_act INTEGER;

COMMENT ON COLUMN conta.tint_comprobante.id_moneda_act
IS 'identifica la moneda de actualizacion'; 

--------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ADD COLUMN importe_debe_ma NUMERIC;
  
--------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ADD COLUMN importe_haber_ma NUMERIC;
  
--------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ADD COLUMN importe_gasto_ma NUMERIC;
      

--------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ADD COLUMN importe_recurso_ma NUMERIC;


--------------- SQL ---------------

ALTER TABLE conta.tint_rel_devengado
  ADD COLUMN monto_pago_ma NUMERIC;
    
--------------- SQL ---------------

ALTER TABLE conta.tcuenta
  ADD COLUMN tipo_act VARCHAR(15) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN conta.tcuenta.tipo_act
IS 'no, conta, activos,  defien si la cuetna contable  se actualiza, i actuaiza define si viene el calculo en el sistema de contabilidad o en el sistema de activos fijos';


--------------- SQL ---------------

ALTER TABLE conta.tresultado_plantilla
  ADD COLUMN nombre_func VARCHAR;

COMMENT ON COLUMN conta.tresultado_plantilla.nombre_func
IS 'si es null la logica de la plantilla sale de resutlado detalle,  si se define, esta función debe contener lalogica para generar el cbte'; 


/***********************************F-SCP-RAC-CONTA-1-11/07/2017****************************************/


/***********************************I-SCP-RAC-CONTA-1-25/07/2017****************************************/



ALTER TABLE conta.trango
  ALTER COLUMN haber_mt TYPE NUMERIC;


/***********************************F-SCP-RAC-CONTA-1-25/07/2017****************************************/
  
  


/***********************************I-SCP-RAC-CONTA-1-26/07/2017****************************************/
  
--------------- SQL ---------------

CREATE TABLE conta.ttipo_estado_cuenta (
  id_tipo_estado_cuenta SERIAL NOT NULL,
  nombre VARCHAR NOT NULL,
  codigo VARCHAR(50) NOT NULL UNIQUE,
  tabla VARCHAR(300),
  columna_id_tabla VARCHAR(100),
  columna_codigo_aux VARCHAR(100),
  PRIMARY KEY(id_tipo_estado_cuenta)
) INHERITS (pxp.tbase)

WITH (oids = false);

COMMENT ON COLUMN conta.ttipo_estado_cuenta.tabla
IS 'tabla para consulta de columnas';

COMMENT ON COLUMN conta.ttipo_estado_cuenta.columna_id_tabla
IS 'nombre de la columnas primari key de la tabla especificada';

COMMENT ON COLUMN conta.ttipo_estado_cuenta.columna_codigo_aux
IS 'nombre de la columnas codigo auxuliar, (que nos permite unir los datos de tabla con auxiliares contables)'; 
  

--------------- SQL ---------------

CREATE TABLE conta.ttipo_estado_columna (
  id_tipo_estado_columna SERIAL NOT NULL,
  codigo VARCHAR(100) NOT NULL UNIQUE,
  nombre VARCHAR NOT NULL,
  origen VARCHAR(40) DEFAULT 'contabilidad' NOT NULL,
  id_config_subtipo_cuenta INTEGER,
  nombre_funcion VARCHAR,
  link_int_det VARCHAR,
  PRIMARY KEY(id_tipo_estado_columna)
) INHERITS (pxp.tbase)

WITH (oids = false);

COMMENT ON COLUMN conta.ttipo_estado_columna.origen
IS 'origen de calculo de la columas, contabilidad o funcion';

COMMENT ON COLUMN conta.ttipo_estado_columna.id_config_subtipo_cuenta
IS 'si el origen es contabilidad debe especifica el id_subtipo_Cuenta para realizar el mayor';

COMMENT ON COLUMN conta.ttipo_estado_columna.nombre_funcion
IS 'si el origen es funcion, aca va el nombre de la funcion que realizara el calculo de columna';

COMMENT ON COLUMN conta.ttipo_estado_columna.link_int_det
IS 'ur de la interface que mostra el detalle de la composicion del calculo(para la columnas de origen funcion),... para origen contabilidad mostrara la interface de mayor contable';


--------------- SQL ---------------
ALTER TABLE conta.ttipo_estado_columna
  ADD COLUMN id_tipo_estado_cuenta INTEGER NOT NULL;
  
-------------- SQL ---------------

ALTER TABLE conta.ttipo_estado_columna
  ADD COLUMN prioridad NUMERIC DEFAULT 1 NOT NULL;

COMMENT ON COLUMN conta.ttipo_estado_columna.prioridad
IS 'Prioridad con la que se muestra la columna en los resultados';

/***********************************F-SCP-RAC-CONTA-1-26/07/2017****************************************/
  
  
  
/***********************************I-SCP-RAC-CONTA-1-29/07/2017****************************************/
 
ALTER TABLE conta.ttipo_estado_columna
  ADD COLUMN descripcion VARCHAR;

--------------- SQL ---------------

ALTER TABLE conta.ttipo_estado_columna
  ADD COLUMN nombre_clase VARCHAR(300);

COMMENT ON COLUMN conta.ttipo_estado_columna.nombre_clase
IS 'nombre de la clase que se ejecuta para msotrar el detalle';

--------------- SQL ---------------

ALTER TABLE conta.ttipo_estado_columna
  ADD COLUMN parametros_det VARCHAR DEFAULT '{}' NOT NULL;

COMMENT ON COLUMN conta.ttipo_estado_columna.parametros_det
IS 'JSON con los parametros que se mandan al a la interface de datalle';

 
/***********************************F-SCP-RAC-CONTA-1-29/07/2017****************************************/
  
  
/***********************************I-SCP-RAC-CONTA-1-08/09/2017****************************************/
  
 
CREATE TABLE conta.ttipo_cc_cuenta (
  id_tipo_cc_cuenta SERIAL NOT NULL,
  id_tipo_cc INTEGER,
  nro_cuenta VARCHAR,
  id_auxiliar INTEGER,
  obs VARCHAR,
  PRIMARY KEY(id_tipo_cc_cuenta)
) INHERITS (pxp.tbase)

WITH (oids = false);


/***********************************F-SCP-RAC-CONTA-1-08/09/2017****************************************/


/***********************************I-SCP-RAC-CONTA-1-01/09/2017****************************************/

--------------- SQL ---------------

ALTER TABLE conta.ttabla_relacion_contable
  ADD COLUMN tabla_codigo_aplicacion VARCHAR(100);

COMMENT ON COLUMN conta.ttabla_relacion_contable.tabla_codigo_aplicacion
IS 'define la columna en la tabla que se usara para determianr la aplicacion';


--------------- SQL ---------------

ALTER TABLE conta.ttipo_relacion_contable
  ADD COLUMN tiene_aplicacion VARCHAR(10) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN conta.ttipo_relacion_contable.tiene_aplicacion
IS 'indica si aplica o no un concepto de aplicacion';


--------------- SQL ---------------

ALTER TABLE conta.ttipo_relacion_contable
  ADD COLUMN tiene_moneda VARCHAR(6) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN conta.ttipo_relacion_contable.tiene_moneda
IS 'si considera o no la moneda del cbte para definir la relacion contable';


--------------- SQL ---------------

ALTER TABLE conta.ttipo_relacion_contable
  ADD COLUMN tiene_tipo_centro VARCHAR(10) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN conta.ttipo_relacion_contable.tiene_tipo_centro
IS 'si considera el tipo de centro de costo si es inversion o gasto';


--------------- SQL ---------------

ALTER TABLE conta.ttipo_relacion_contable
  ADD COLUMN codigo_aplicacion_catalogo VARCHAR(300);

COMMENT ON COLUMN conta.ttipo_relacion_contable.codigo_aplicacion_catalogo
IS 'si tiene aplicacion es encesario definir el codigo de tipo catalogo para la configuracion de relaciones contable';


--------------- SQL ---------------

ALTER TABLE conta.trelacion_contable
  ADD COLUMN id_moneda INTEGER;

COMMENT ON COLUMN conta.trelacion_contable.id_moneda
IS 'identifica la moenda para la relacion contable';


--------------- SQL ---------------

ALTER TABLE conta.trelacion_contable
  ADD COLUMN id_tipo_presupuesto INTEGER;

COMMENT ON COLUMN conta.trelacion_contable.id_tipo_presupuesto
IS 'identifica el tipod e presupuesto, se aplica si fue configurado el tiene_tipo_centro en el tipo de relacion contable';



--------------- SQL ---------------

ALTER TABLE conta.trelacion_contable
  ADD COLUMN codigo_aplicacion VARCHAR(200);

COMMENT ON COLUMN conta.trelacion_contable.codigo_aplicacion
IS 'se llena con el catalogo configurado en el tipo de relacion contable,  es el valor de la aplicacion';


--------------- SQL ---------------

COMMENT ON TABLE conta.trelacion_contable
IS 'esta tabla permite configurar cuenta partida y  auxioar para diferentes conceptos, 
centralizando la parametrizacion en un unico lugar y facilitar la generacion de comprobantes';

/***********************************F-SCP-RAC-CONTA-1-01/09/2017****************************************/



  
 
 
 
/***********************************I-SCP-RAC-CONTA-1-13/09/2017****************************************/
  

ALTER TABLE conta.tdoc_compra_venta
  ADD COLUMN nro_tramite VARCHAR;

COMMENT ON COLUMN conta.tdoc_compra_venta.nro_tramite
IS 'identifica el nro de tramite donde fue generada la factura';


/***********************************F-SCP-RAC-CONTA-1-13/09/2017****************************************/
 

/***********************************I-SCP-RAC-CONTA-1-05/01/2018****************************************/
  

--------------- SQL ---------------

ALTER TABLE conta.tdoc_compra_venta
  ADD COLUMN sw_pgs VARCHAR(4) DEFAULT 'no' NOT NULL;

--------------- SQL ---------------

COMMENT ON COLUMN conta.tdoc_compra_venta.sw_pgs
IS 'indetifica si es una factura registrada por pago simple valores, no,  reg, proc';


--------------- SQL ---------------

ALTER TABLE conta.tdoc_compra_venta
  ADD COLUMN id_funcionario INTEGER; 

COMMENT ON COLUMN conta.tdoc_compra_venta.id_funcionario
IS 'registor auxiliar de apsajes, util para compra de boletos aereos donde es necesario indicar quien esta viajando';


--------------- SQL ---------------

ALTER TABLE conta.tplantilla_calculo
  ADD COLUMN sw_registro VARCHAR(5) DEFAULT 'si' NOT NULL;

COMMENT ON COLUMN conta.tplantilla_calculo.sw_registro
IS 'Si registra el resultado en una trasaccion,  en caso contrario ,no, sirve como calculo auxiliar porejmplo en polizas de importación';




/***********************************F-SCP-RAC-CONTA-1-05/01/2018****************************************/
  
  
  


/***********************************I-SCP-RAC-CONTA-1-25/01/2018****************************************/

--------------- SQL ---------------

ALTER TABLE conta.tplantilla_calculo
  ADD COLUMN sw_restar VARCHAR(8) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN conta.tplantilla_calculo.sw_restar
IS 'Para usar en pasajes con exceto internacionales donde el sabsa debe restar al valor proginal al final de los calculos (difenrete de descontar)';



/***********************************F-SCP-RAC-CONTA-1-27/01/2018****************************************/
  
  



/***********************************I-SCP-RAC-CONTA-1-25/01/2018****************************************/


ALTER TABLE conta.tint_transaccion
  ADD COLUMN monto_no_ejecutado NUMERIC DEFAULT 0 NOT NULL;

COMMENT ON COLUMN conta.tint_transaccion.monto_no_ejecutado
IS 'monto que no se va aejcutar , en la monada de la trasaccion';



--------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ADD COLUMN monto_no_ejecutado_mb NUMERIC DEFAULT 0 NOT NULL;

COMMENT ON COLUMN conta.tint_transaccion.monto_no_ejecutado_mb
IS 'monto a no ejecutar en moneda base';





/***********************************F-SCP-RAC-CONTA-1-27/01/2018****************************************/




/***********************************I-SCP-RAC-CONTA-1-03/02/2018****************************************/




--------------- SQL ---------------

CREATE TABLE conta.trelacion_contable_tpm (
  codigo_tipo_presupuesto VARCHAR,
  codigo_cuenta VARCHAR,
  migrado VARCHAR DEFAULT 'no' NOT NULL,
  obs VARCHAR(1)
) 
WITH (oids = false);



/***********************************F-SCP-RAC-CONTA-1-03/02/2018****************************************/


/***********************************I-SCP-RAC-CONTA-1-11/04/2018****************************************/


ALTER TABLE conta.tresultado_det_plantilla
  ADD COLUMN id_tipo_cc INTEGER;

COMMENT ON COLUMN conta.tresultado_det_plantilla.id_tipo_cc
IS 'opcional en el caso de reportes, para obtener un mayor consirando el tipo de centro de costos';


--------------- SQL ---------------

ALTER TABLE conta.tresultado_plantilla
  ADD COLUMN visible_menu VARCHAR(2) DEFAULT 'si' NOT NULL;

COMMENT ON COLUMN conta.tresultado_plantilla.visible_menu
IS 'si es un reporte, es visible o no en el menu';


--------------- SQL ---------------

ALTER TABLE conta.tresultado_det_plantilla
  ADD COLUMN salta_hoja VARCHAR(3) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN conta.tresultado_det_plantilla.salta_hoja
IS 'esta opcion indica si antes tenemso que cambiar de hoja';



/***********************************F-SCP-RAC-CONTA-1-03/02/2018****************************************/




/***********************************I-SCP-RAC-CONTA-1-25/04/2018****************************************/



ALTER TABLE conta.tplantilla_comprobante
  ADD COLUMN campo_tipo_cambio_2 VARCHAR(350);

COMMENT ON COLUMN conta.tplantilla_comprobante.campo_tipo_cambio_2
IS 'necesaio para cuando queremos tipod e cambio covenido';



ALTER TABLE conta.tplantilla_comprobante
  ADD COLUMN campo_tipo_cambio_3 VARCHAR(350);

COMMENT ON COLUMN conta.tplantilla_comprobante.campo_tipo_cambio_3
IS 'necesario cuando queremos tipo de cambio covenido';


--------------- SQL ---------------

ALTER TABLE conta.tplantilla_comprobante
  ADD COLUMN campo_id_config_cambiaria VARCHAR(350);

COMMENT ON COLUMN conta.tplantilla_comprobante.campo_id_config_cambiaria
IS 'necesario cuando queremso tipo de cambio convenido';





/***********************************F-SCP-RAC-CONTA-1-25/04/2018****************************************/




/***********************************I-SCP-RAC-CONTA-1-08/05/2018****************************************/


ALTER TABLE conta.tdoc_compra_venta
  ADD COLUMN codigo_aplicacion VARCHAR(200);

COMMENT ON COLUMN conta.tdoc_compra_venta.codigo_aplicacion
IS 'codigo del catalogo  con la finlaidad del documento, tuli para relacioens contables';


--------------- SQL ---------------

ALTER TABLE conta.tdetalle_plantilla_comprobante
  ADD COLUMN campo_codigo_aplicacion_rc VARCHAR(350);

COMMENT ON COLUMN conta.tdetalle_plantilla_comprobante.campo_codigo_aplicacion_rc
IS 'codigo de aplicaicon para relaciones contable';


ALTER TABLE conta.tdoc_compra_venta
  ADD COLUMN id_doc_compra_venta_fk BIGINT;

COMMENT ON COLUMN conta.tdoc_compra_venta.id_doc_compra_venta_fk
IS 'referencia para notas de credito y debito';

ALTER TABLE conta.tresultado_plantilla
  ADD COLUMN visible VARCHAR(50) DEFAULT 'si' NOT NULL;  

ALTER TABLE conta.tint_comprobante
  ADD COLUMN glosa_previa VARCHAR DEFAULT '' NOT NULL;

COMMENT ON COLUMN conta.tint_comprobante.glosa_previa
IS 'para almacenar como respaldo glosas modificadas';

--------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ADD COLUMN cerrado VARCHAR(10) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN conta.tint_transaccion.cerrado
IS 'este campo serviria para identificar las trasacciones de tipo cobro o cuenta por pagar que ya fueron cerradas';

ALTER TABLE conta.tint_transaccion
  ADD COLUMN id_int_comprobante_cierre INTEGER;

COMMENT ON COLUMN conta.tint_transaccion.id_int_comprobante_cierre
IS 'identifica el comrpobante con que fue cerrado , solo tenemso este dato cuando el cierre es automatico, cuadno se valida algun cbte';


--------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ADD COLUMN fecha_cerrado TIMESTAMP WITHOUT TIME ZONE;

COMMENT ON COLUMN conta.tint_transaccion.fecha_cerrado
IS 'fecah en la que ce cierran las trasacciones de cobros o cuentas por pagar';



create index idx_id_int_comprobante_fks on conta.tint_comprobante using GIN (id_int_comprobante_fks);


CREATE INDEX idx_id_int_comprobante_fks1 on conta.tint_comprobante ((id_int_comprobante_fks[1]));

--------------- SQL ---------------

ALTER TABLE conta.tdoc_compra_venta
  ADD COLUMN id_contrato INTEGER;

COMMENT ON COLUMN conta.tdoc_compra_venta.id_contrato
IS 'hace referencia al contrato de ventas en facturas de venta util para bancarizar ventas';

 --------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ADD COLUMN id_origen INTEGER;

COMMENT ON COLUMN conta.tint_transaccion.id_origen
IS 'hace referencia al id usardo por el generador de cbte para crear esta trasaccion';




/***********************************F-SCP-RAC-CONTA-1-08/05/2018****************************************/

/***********************************I-SCP-EGS-CONTA-1-30/08/2018****************************************/
ALTER TABLE conta.tauxiliar
ADD COLUMN aplicacion VARCHAR(50);

CREATE TABLE conta.tdesglose_ingreso_caja (
  id_int_comprobante INTEGER NOT NULL,
  id_int_transaccion INTEGER,
  nro_cuenta_errada VARCHAR(100),
  id_cuenta_errada INTEGER,
  id_cuenta_requerida INTEGER,
  id_partida_errada INTEGER,
  id_partida_requerida INTEGER,
  id_auxiliar_errado INTEGER,
  id_auxiliar_requerido INTEGER,
  importe_debe_mb NUMERIC(18,2),
  importe_haber_mb NUMERIC(18,2)
) 
WITH (oids = false);

ALTER TABLE conta.tcuenta
  ADD COLUMN act_cbte_apertura VARCHAR(20) DEFAULT 'todos'::character varying NOT NULL;

COMMENT ON COLUMN conta.tcuenta.act_cbte_apertura
IS 'al actualizar incluir el cbte de apertura, todos, no, solo_apertura,';

ALTER TABLE conta.tcuenta
  ADD COLUMN cuenta_actualizacion VARCHAR(20);

CREATE TABLE conta.tdeclaraciones_juridicas (
  id_usuario_reg INTEGER,
  id_usuario_mod INTEGER,
  fecha_reg TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
  fecha_mod TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
  estado_reg VARCHAR(10) DEFAULT 'activo'::character varying,
  id_usuario_ai INTEGER,
  usuario_ai VARCHAR(300),
  id_declaracion_juridica SERIAL,
  tipo VARCHAR(100),
  id_periodo INTEGER,
  id_gestion INTEGER,
  codigo VARCHAR(20),
  descripcion TEXT,
  importe NUMERIC(20,0),
  fila INTEGER,
  estado VARCHAR(20) DEFAULT 'no validado'::character varying
) INHERITS (pxp.tbase)

WITH (oids = false);

ALTER TABLE conta.tdeclaraciones_juridicas
  ALTER COLUMN tipo SET STATISTICS 0;

ALTER TABLE conta.tdeclaraciones_juridicas
  ALTER COLUMN id_gestion SET STATISTICS 0;

ALTER TABLE conta.tdeclaraciones_juridicas
  ALTER COLUMN codigo SET STATISTICS 0;

ALTER TABLE conta.tdeclaraciones_juridicas
  ALTER COLUMN importe SET STATISTICS 0;


CREATE TABLE conta.tdetalle_det_reporte_aux (
  id_usuario_reg INTEGER,
  id_usuario_mod INTEGER,
  fecha_reg TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
  fecha_mod TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
  estado_reg VARCHAR(10) DEFAULT 'activo'::character varying,
  id_usuario_ai INTEGER,
  usuario_ai VARCHAR(300),
  id_detalle_det_reporte_aux SERIAL,
  concepto TEXT,
  partida TEXT,
  origen VARCHAR(50),
  orden_fila INTEGER,
  id_plantilla_reporte INTEGER
) INHERITS (pxp.tbase)

WITH (oids = false);


ALTER TABLE conta.tplantilla_calculo
  ADD COLUMN usar_cc_original VARCHAR(8) DEFAULT 'no'::character varying NOT NULL;

COMMENT ON COLUMN conta.tplantilla_calculo.usar_cc_original
IS 'permite configurar si usar el centro de costo original , en caso contrario permite usar el adminsitrativo';


ALTER TABLE conta.tplantilla_calculo
  ADD COLUMN imputar_excento VARCHAR(8) DEFAULT 'no'::character varying NOT NULL;

COMMENT ON COLUMN conta.tplantilla_calculo.imputar_excento
IS 'si es prioridad 1 no se suma el excento, si es prioriad 2 e monto es el excento';


CREATE TABLE conta.tplantilla_det_reporte (
  id_usuario_reg INTEGER,
  id_usuario_mod INTEGER,
  fecha_reg TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
  fecha_mod TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
  estado_reg VARCHAR(10) DEFAULT 'activo'::character varying,
  id_usuario_ai INTEGER,
  usuario_ai VARCHAR(300),
  id_plantilla_det_reporte SERIAL,
  id_plantilla_reporte INTEGER,
  codigo_columna VARCHAR(100),
  columna VARCHAR(100),
  origen VARCHAR(200),
  concepto TEXT,
  partida VARCHAR(1000),
  nombre_columna TEXT,
  saldo_inical VARCHAR(5),
  formulario VARCHAR(50),
  codigo_formulario TEXT,
  order_fila INTEGER,
  saldo_anterior VARCHAR(50),
  calculo VARCHAR(10),
  concepto2 TEXT,
  partida2 TEXT,
  operacion VARCHAR(50),
  periodo VARCHAR(80),
  origen2 VARCHAR(50),
  tipo VARCHAR(50),
  formula VARCHAR(50),
  tipo_aux VARCHAR(20),
  tipo_detalle VARCHAR(10) DEFAULT 'si'::character varying,
  glosa TEXT
) INHERITS (pxp.tbase)

WITH (oids = false);


CREATE TABLE conta.tplantilla_reporte (
  id_usuario_reg INTEGER,
  id_usuario_mod INTEGER,
  fecha_reg TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
  fecha_mod TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
  estado_reg VARCHAR(10) DEFAULT 'activo'::character varying,
  id_usuario_ai INTEGER,
  usuario_ai VARCHAR(300),
  id_plantilla_reporte SERIAL,
  tipo VARCHAR(100),
  nombre VARCHAR(100),
  modalidad VARCHAR(100),
  glosa TEXT
) INHERITS (pxp.tbase)

WITH (oids = false);



ALTER TABLE conta.ttipo_estado_columna
  ADD COLUMN clase VARCHAR(300);

COMMENT ON COLUMN conta.ttipo_estado_columna.clase
IS 'nombre de la clase que se ejecuta para msotrar el detalle';


COMMENT ON COLUMN conta.ttipo_relacion_contable.tiene_moneda
IS 'sii considera o no la moneda del cbte para definir la relacion contable';


COMMENT ON TABLE conta.trelacion_contable
IS 'esta tabla permite configurar cuenta partida y  auxioar para diferentes conceptos (tabla relacion contable), 
centralizando la parametrizacion en un unico lugar y facilitar la generacion de comprobantes';



COMMENT ON COLUMN conta.trelacion_contable.id_moneda
IS 'identifica la moenda para la relacion contabile';



ALTER TABLE conta.tint_transaccion
  ADD COLUMN monto_no_ejecutado NUMERIC DEFAULT 0 NOT NULL;

COMMENT ON COLUMN conta.tint_transaccion.monto_no_ejecutado
IS 'monto que no se va aejcutar , en la monada de la trasaccion';


ALTER TABLE conta.tint_transaccion
  ADD COLUMN monto_no_ejecutado_mb NUMERIC DEFAULT 0 NOT NULL;

COMMENT ON COLUMN conta.tint_transaccion.monto_no_ejecutado_mb
IS 'monto a no ejecutar en moneda base';



ALTER TABLE conta.tint_transaccion
  ADD COLUMN id_cuenta_bolsa INTEGER;

COMMENT ON COLUMN conta.tint_transaccion.id_cuenta_bolsa
IS 'cuenta temporal';


ALTER TABLE conta.tint_transaccion
  ADD COLUMN id_partida_ejecucion_tmp INTEGER;

COMMENT ON COLUMN conta.tint_transaccion.id_partida_ejecucion_tmp
IS 'partida ejecucion del comprometido, que se almacena temporalmente para operaciones manaules auxiliares';

ALTER TABLE conta.tint_transaccion
  ADD COLUMN temp_importe_ma_aux NUMERIC;

COMMENT ON COLUMN conta.tint_transaccion.temp_importe_ma_aux
IS 'temporal para salver error de cbte cruzados';


ALTER TABLE conta.tint_transaccion
  ADD COLUMN nro_tramite VARCHAR(70);

COMMENT ON COLUMN conta.tint_transaccion.nro_tramite
IS 'Los nro de tramtie de copian de la cabecera al validar el cbte,  solo los cbte de cierre y apetura tiene una logica diferente por que acumulan el valor para un nro de tramite en especifico, esto queire decir que el cbte de apertura tendra transaccion con diferentes nro de tramite';


ALTER TABLE conta.tdoc_compra_venta
  ADD COLUMN fecha_doc_bk DATE;


ALTER TABLE conta.tdoc_compra_venta
  ADD COLUMN num_tra_bk VARCHAR;


ALTER TABLE conta.tdoc_concepto
  ADD COLUMN id_partida_ejecucion INTEGER;


/***********************************F-SCP-EGS-CONTA-1-30/08/2018****************************************/


/***********************************I-SCP-CAP-CONTA-0-06/12/2018****************************************/

ALTER TABLE conta.tdeclaraciones_juridicas
  ADD CONSTRAINT tdeclaraciones_juridicas_pkey 
    PRIMARY KEY (id_declaracion_juridica) NOT DEFERRABLE;

ALTER TABLE conta.tdesglose_ingreso_caja
  ADD CONSTRAINT tdesglose_ingreso_caja_pkey 
    PRIMARY KEY (id_int_comprobante) NOT DEFERRABLE;

ALTER TABLE conta.tdetalle_det_reporte_aux
  ADD CONSTRAINT tdetalle_det_reporte_aux_pkey 
    PRIMARY KEY (id_detalle_det_reporte_aux) NOT DEFERRABLE;

ALTER TABLE conta.tplantilla_det_reporte
  ADD CONSTRAINT tplantilla_det_reporte_pkey 
    PRIMARY KEY (id_plantilla_det_reporte) NOT DEFERRABLE;

ALTER TABLE conta.tplantilla_reporte
  ADD CONSTRAINT tplantilla_reporte_pkey 
    PRIMARY KEY (id_plantilla_reporte) NOT DEFERRABLE;


/***********************************F-SCP-CAP-CONTA-0-06/12/2018****************************************/


/***********************************I-SCP-EGS-CONTA-0-18/12/2018****************************************/
ALTER TABLE conta.tcuenta
  ADD COLUMN ex_auxiliar VARCHAR DEFAULT 'no' NOT NULL;
  
/***********************************F-SCP-EGS-CONTA-0-18/12/2018****************************************/



/***********************************I-SCP-EGS-CONTA-7-27/12/2018****************************************/

--------------- SQL ---------------

ALTER TABLE conta.tint_comprobante
  ADD COLUMN nro_tramite_aux VARCHAR(70);

COMMENT ON COLUMN conta.tint_comprobante.nro_tramite_aux
IS 'nro de tramtie euxiliar que peude ser modificado para calculo de reportes';


update conta.tint_comprobante s set
  nro_tramite_aux = nro_tramite
where s.estado_reg = 'validado';


/***********************************F-SCP-EGS-CONTA-7-27/12/2018****************************************/


/***********************************I-SCP-RAC-CONTA-13-27/12/2018****************************************/

--------------- SQL ---------------

ALTER TABLE conta.tplantilla_calculo
  ADD COLUMN reset_partida_eje VARCHAR(2) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN conta.tplantilla_calculo.reset_partida_eje
IS 'incica si resetemao o no la partida ejecucion,  al generar la trasaccion, por defecto no, sirve para facturas  que necesitan lelvar ejejcucion a otro centro de costo';


--------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ADD COLUMN forzar_comprometer VARCHAR DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN conta.tint_transaccion.forzar_comprometer
IS 'este valor sobre escribe el valor de comprometer de la cabecera del comprobante';

/***********************************F-SCP-RAC-CONTA-13-27/12/2018****************************************/
/***********************************I-SCP-EGS-CONTA-8-04/01/2019****************************************/
ALTER TABLE conta.ttabla_relacion_contable
  ADD COLUMN codigo VARCHAR;
COMMENT ON COLUMN conta.ttabla_relacion_contable.codigo
IS 'codigo identificador';
/***********************************F-SCP-EGS-CONTA-8-04/01/2019****************************************/




/***********************************I-SCP-RAC-CONTA-21-10/01/2019****************************************/

ALTER TABLE conta.tdetalle_plantilla_comprobante
  ADD COLUMN incluir_desc_doc VARCHAR(10) DEFAULT 'todos' NOT NULL;

COMMENT ON COLUMN conta.tdetalle_plantilla_comprobante.incluir_desc_doc
IS '(todos, decuento, no_descuento), este campo indica si vamos a procesadar los descuento para las registros secundario deldocuemento, lso incluimos  todos, o solo los que descuento es igual a si, o  los descuentos igual a no.  EJEMPLO sirve para llevar lso descuentos de servicios o iue be al comprobante de pago, pero permite dejar el via en el cobte de diario';

/***********************************F-SCP-RAC-CONTA-21-10/01/2019****************************************/




/***********************************I-SCP-RAC-CONTA-30-05/02/2019****************************************/
--------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ADD COLUMN id_centro_costo_ori INTEGER;

COMMENT ON COLUMN conta.tint_transaccion.id_centro_costo_ori
IS 'cuando usamos plantilla se generar trasaccionales adicionales, que peuden varias el cc segun configuracion, en este campo almanceamos el original para fines de reportes';

/***********************************F-SCP-RAC-CONTA-30-05/02/2019****************************************/

/***********************************I-SCP-MMV-CONTA-33-08/02/2019****************************************/
ALTER TABLE conta.tint_comprobante
  ADD COLUMN documento_iva VARCHAR(4);

ALTER TABLE conta.tint_comprobante
  ALTER COLUMN documento_iva SET DEFAULT 'si';
/***********************************F-SCP-MMV-CONTA-33-08/02/2019****************************************/


/***********************************I-SCP-EGS-CONTA-09-28/03/2019****************************************/

ALTER TABLE conta.tdetalle_plantilla_comprobante
  ALTER COLUMN incluir_desc_doc TYPE VARCHAR(15) COLLATE pg_catalog."default";

ALTER TABLE conta.tdetalle_plantilla_comprobante
  ALTER COLUMN incluir_desc_doc SET DEFAULT 'todos'::character varying;
 /***********************************F-SCP-MMV-CONTA-09-28/03/2019****************************************/


 /***********************************I-SCP-EGS-CONTA-10-02/04/2019****************************************/
ALTER TABLE conta.tdetalle_plantilla_comprobante
  ADD COLUMN procesar_prioridad_principal VARCHAR(2) DEFAULT 'si'::character varying NOT NULL;

COMMENT ON COLUMN conta.tdetalle_plantilla_comprobante.procesar_prioridad_principal
IS 'Evalua el la plantilla de documento con priridad 1. valores:si/no';
 /***********************************F-SCP-EGS-CONTA-10-02/04/2019****************************************/

/***********************************I-SCP-JRR-CONTA-0-24/01/2019****************************************/


CREATE TABLE conta.tmigra_cuenta(
  nro_cuenta VARCHAR(20),   
  nombre_cuenta VARCHAR(200), 
  id_moneda int4,
  tipo_cuenta VARCHAR(30), 
  sw_transaccional VARCHAR(10),   
  sw_auxiliar VARCHAR(2), 
  valor_incremento VARCHAR(10)
   );
   
 CREATE TABLE conta.tmigra_auxiliar(
  codigo_auxiliar VARCHAR(20),   
  nombre_auxiliar VARCHAR(200)
   );

/***********************************F-SCP-JRR-CONTA-0-24/01/2019****************************************/
/***********************************I-SCP-JRR-CONTA-0-20/03/2019****************************************/

ALTER TABLE conta.tmigra_cuenta
  ADD COLUMN sub_tipo_cuenta INTEGER;

/***********************************F-SCP-JRR-CONTA-0-20/03/2019****************************************/
/***********************************I-SCP-EGS-CONTA-0-17/05/2019****************************************/
ALTER TABLE conta.tint_comprobante
  ADD COLUMN id_int_comprobante_migrado INTEGER;

COMMENT ON COLUMN conta.tint_comprobante.id_int_comprobante_migrado
IS 'El nuevo id el cual se genero al hacer la migracion a la nueva Bd(etasa)';
/***********************************F-SCP-EGS-CONTA-0-17/05/2019****************************************/

/***********************************I-SCP-EGS-CONTA-11-29/05/2019****************************************/
CREATE TABLE conta.tconfig_tpre (
  id_conf_pre SERIAL,
  id_tipo_cc INTEGER,
  obs VARCHAR(100),
  CONSTRAINT tconfig_tpre_id_tcc_key UNIQUE(id_tipo_cc),
  CONSTRAINT tconfig_tpre_pkey PRIMARY KEY(id_conf_pre)
) INHERITS (pxp.tbase)

WITH (oids = false);
/***********************************F-SCP-EGS-CONTA-11-29/05/2019****************************************/

/***********************************I-SCP-EGS-CONTA-12-05/06/2019****************************************/
CREATE TABLE conta.tconfig_auxiliar (
  id_config_auxiliar SERIAL,
  id_auxiliar INTEGER,
  descripcion VARCHAR,
  CONSTRAINT tconfig_auxiliar_id_auxiliar_key UNIQUE(id_auxiliar),
  CONSTRAINT tconfig_auxiliar_pkey PRIMARY KEY(id_config_auxiliar),
  CONSTRAINT tconfig_auxiliar_fk FOREIGN KEY (id_auxiliar)
    REFERENCES conta.tauxiliar(id_auxiliar)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) INHERITS (pxp.tbase)

WITH (oids = false);

/***********************************F-SCP-EGS-CONTA-12-05/06/2019****************************************/
/***********************************I-SCP-EGS-CONTA-13-06/06/2019****************************************/

ALTER TABLE conta.tplantilla_comprobante
  ADD UNIQUE (codigo);

/***********************************F-SCP-EGS-CONTA-13-06/06/2019****************************************/

/***********************************I-SCP-EGS-CONTA-14-11/06/2019****************************************/
CREATE TABLE conta.tmarca (
  id_marca SERIAL,
  descripcion VARCHAR,
  codigo VARCHAR,
  CONSTRAINT tconfig_marca_codigo_key UNIQUE(codigo),
  CONSTRAINT tmarca_pkey PRIMARY KEY(id_marca)
) INHERITS (pxp.tbase)

WITH (oids = false);

CREATE TABLE conta.tcbte_marca (
  id_cbte_marca SERIAL,
  id_int_comprobante INTEGER,
  id_marca INTEGER,
  CONSTRAINT tcbte_marca_pkey PRIMARY KEY(id_cbte_marca),
  CONSTRAINT fk_tcbte_marca__id_int_comprobante FOREIGN KEY (id_int_comprobante)
    REFERENCES conta.tint_comprobante(id_int_comprobante)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk_tcbte_marca__id_marca FOREIGN KEY (id_marca)
    REFERENCES conta.tmarca(id_marca)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) INHERITS (pxp.tbase)

WITH (oids = false);

ALTER TABLE conta.tcbte_marca
  ALTER COLUMN id_cbte_marca SET STATISTICS 0;

ALTER TABLE conta.tcbte_marca
  ALTER COLUMN id_int_comprobante SET STATISTICS 0;

ALTER TABLE conta.tcbte_marca
  ALTER COLUMN id_marca SET STATISTICS 0;
/***********************************F-SCP-EGS-CONTA-14-11/06/2019****************************************/




/***********************************I-SCP-RAC-CONTA-66-24/07/2019****************************************/

--------------- SQL ---------------

ALTER TABLE conta.tdetalle_plantilla_comprobante
  ADD COLUMN campo_id_taza_impuesto VARCHAR(350);

COMMENT ON COLUMN conta.tdetalle_plantilla_comprobante.campo_id_taza_impuesto
IS 'define el campo id_taza_impuesto para documentos con impuestos variable. (caso facturas de argentina)';


/***********************************F-SCP-RAC-CONTA-66-24/07/2019****************************************/

/***********************************I-SCP-JUAN-CONTA-0-11/12/2019****************************************/
ALTER TABLE conta.tconfig_cambiaria
  ADD COLUMN id_monedas INTEGER [];
/***********************************F-SCP-JUAN-CONTA-0-11/12/2019****************************************/



/***********************************I-SCP-RAC-CONTA-78-11/12/2019****************************************/
ALTER TABLE conta.ttipo_relacion_comprobante
  ADD COLUMN filtrar_moneda VARCHAR(2) DEFAULT 'si' NOT NULL;

COMMENT ON COLUMN conta.ttipo_relacion_comprobante.filtrar_moneda
IS 'si o no, permite filtar el los comprobnates relacion con la misma moneda';
/***********************************F-SCP-RAC-CONTA-78-11/12/2019****************************************/


/***********************************I-SCP-JUAN-CONTA-01-03/01/2020****************************************/
ALTER TABLE conta.tresultado_det_plantilla --#82
  ADD COLUMN observacion VARCHAR; --#82
/***********************************F-SCP-JUAN-CONTA-01-03/01/2020****************************************/
