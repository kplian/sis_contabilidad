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


   
