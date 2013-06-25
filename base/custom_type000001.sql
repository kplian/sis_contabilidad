/***********************************I-TYP-GSS-CONTA-9-17/06/2013****************************************/

CREATE TYPE conta.maestro_comprobante AS (
  columna_descripcion VARCHAR(255),
  columna_subsistema INTEGER,
  columna_fecha DATE,
  columna_moneda INTEGER,
  columna_acreedor INTEGER,
  columna_fk_comprobante INTEGER,
  columna_depto VARCHAR(255),
  columna_prueba VARCHAR(255)
);

/***********************************F-TYP-GSS-CONTA-9-17/06/2013****************************************/