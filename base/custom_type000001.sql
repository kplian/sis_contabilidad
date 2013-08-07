
/***********************************I-TYP-RAC-CONTA-0-21/08/2013****************************************/

CREATE TYPE conta.maestro_comprobante AS (
  columna_descripcion VARCHAR(255),
  columna_subsistema VARCHAR(40),
  columna_fecha DATE,
  columna_moneda INTEGER,
  columna_acreedor VARCHAR(255),
  columna_fk_comprobante INTEGER,
  columna_depto INTEGER,
  columna_prueba VARCHAR(255)
);


/***********************************F-TYP-RAC-CONTA-0-21/08/2013****************************************/
