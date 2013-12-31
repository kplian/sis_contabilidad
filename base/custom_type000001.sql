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