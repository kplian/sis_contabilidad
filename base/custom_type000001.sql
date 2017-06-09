/***********************************I-TYP-GSS-CONTA-9-17/06/2013****************************************/
CREATE TYPE conta.maestro_comprobante AS (
  columna_descripcion VARCHAR(255),
  columna_subsistema VARCHAR(40),
  columna_fecha DATE,
  columna_moneda INTEGER,
  columna_acreedor VARCHAR(255),
  columna_fk_comprobante INTEGER,
  columna_depto INTEGER,
  columna_glosa TEXT
);

ALTER TYPE conta.maestro_comprobante
  ADD ATTRIBUTE columna_gestion INTEGER;

/***********************************F-TYP-GSS-CONTA-9-17/06/2013****************************************/

/***********************************I-TYP-RCM-CONTA-0-16/12/2013****************************************/
DROP TYPE conta.maestro_comprobante;

CREATE TYPE conta.maestro_comprobante AS (
  columna_descripcion VARCHAR(255),
  columna_subsistema VARCHAR(40),
  columna_fecha DATE,
  columna_moneda INTEGER,
  columna_acreedor VARCHAR(255),
  columna_fk_comprobante INTEGER,
  columna_depto INTEGER,
  columna_glosa TEXT,
  columna_gestion INTEGER,
  columna_id_cuenta_bancaria INTEGER,
  columna_id_cuenta_bancaria_mov INTEGER,
  columna_nro_cheque INTEGER
);

ALTER TYPE conta.maestro_comprobante
  OWNER TO postgres;
/***********************************F-TYP-RCM-CONTA-0-16/12/2013****************************************/



/***********************************I-TYP-RAC-CONTA-0-08/02/2014****************************************/


ALTER TYPE conta.maestro_comprobante
  ADD ATTRIBUTE columna_nro_tramite VARCHAR(255),
  ADD ATTRIBUTE columna_nro_cuenta_bancaria_trans VARCHAR(255);
  

/***********************************F-TYP-RAC-CONTA-0-08/02/2014****************************************/


/***********************************I-TYP-RAC-CONTA-0-24/09/2014****************************************/

--------------- SQL ---------------

ALTER TYPE conta.maestro_comprobante
  ALTER ATTRIBUTE columna_descripcion TYPE VARCHAR(1000),
  ALTER ATTRIBUTE columna_acreedor TYPE VARCHAR(500),
  ALTER ATTRIBUTE columna_nro_tramite TYPE VARCHAR(500),
  ALTER ATTRIBUTE columna_nro_cuenta_bancaria_trans TYPE VARCHAR(500);

/***********************************F-TYP-RAC-CONTA-0-24/09/2014****************************************/



/***********************************I-TYP-RAC-CONTA-0-31/03/2015****************************************/

  --------------- SQL ---------------

ALTER TYPE conta.maestro_comprobante
  ADD ATTRIBUTE columna_tipo_cambio NUMERIC(14,8);
  
/***********************************F-TYP-RAC-CONTA-0-31/03/2015****************************************/


/***********************************I-TYP-RAC-CONTA-0-16/04/2015****************************************/

--------------- SQL ---------------

ALTER TYPE conta.maestro_comprobante
  ADD ATTRIBUTE columna_libro_banco INTEGER;
  
/***********************************F-TYP-RAC-CONTA-0-16/04/2015****************************************/





/***********************************I-TYP-FFP-CONTA-0-22/09/2015****************************************/

CREATE TYPE conta.banca_compra_venta AS (
  modalidad_transaccion INTEGER ,
  fecha_documento  DATE,
  tipo_transaccion INTEGER ,
  nit_ci  VARCHAR(255),
  razon VARCHAR(255) ,
  num_documento VARCHAR(255),
  num_contrato  VARCHAR(255),
  importe_documento NUMERIC(10,2),
  autorizacion  INTEGER,
  num_cuenta_pago VARCHAR(255) ,
  monto_pagado NUMERIC(10,2) ,
  monto_acumulado NUMERIC(10,2) ,
  nit_entidad  NUMERIC,
  num_documento_pago VARCHAR(255) ,
  tipo_documento_pago INTEGER ,
  fecha_de_pago DATE 
);

/***********************************F-TYP-FFP-CONTA-0-22/09/2015****************************************/



/***********************************I-TYP-RAC-CONTA-0-14/10/2015****************************************/

ALTER TYPE conta.maestro_comprobante
  ADD ATTRIBUTE columna_fecha_costo_ini DATE,
  ADD ATTRIBUTE columna_fecha_costo_fin DATE;
  
/***********************************F-TYP-RAC-CONTA-0-14/10/2015****************************************/



/***********************************I-TYP-RAC-CONTA-0-09/06/2017****************************************/

ALTER TYPE conta.maestro_comprobante
  ADD ATTRIBUTE columna_cbte_relacionado VARCHAR;

/***********************************F-TYP-RAC-CONTA-0-09/06/2017****************************************/




