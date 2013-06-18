/***********************************I-DEP-GSS-CONTA-48-20/02/2013*****************************************/

--tabla tcuenta

ALTER TABLE conta.tcuenta
  ADD CONSTRAINT fk_tcuenta__id_empresa FOREIGN KEY (id_empresa)
    REFERENCES param.tempresa(id_empresa)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.tcuenta
  ADD CONSTRAINT fk_tcuenta__id_cuenta_padre FOREIGN KEY (id_cuenta_padre)
    REFERENCES conta.tcuenta(id_cuenta)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;    

--tabla tauxiliar

ALTER TABLE conta.tauxiliar
  ADD CONSTRAINT fk_tauxiliar__id_empresa FOREIGN KEY (id_empresa)
    REFERENCES param.tempresa(id_empresa)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

    
/***********************************F-DEP-GSS-CONTA-48-20/02/2013*****************************************/

/****************************************I-DEP-JRR-CONTA-0-15/05/2013************************************************/
ALTER TABLE conta.tipo_relacion_contable
  ADD CONSTRAINT fk_tipo_relacion_contable__id_tabla_relacion_contable FOREIGN KEY (id_tabla_relacion_contable)
    REFERENCES conta.tabla_relacion_contable(id_tabla_relacion_contable)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE conta.relacion_contable
  ADD CONSTRAINT fk_relacion_contable__id_auxiliar FOREIGN KEY (id_auxiliar)
    REFERENCES conta.tauxiliar(id_auxiliar)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE conta.relacion_contable
  ADD CONSTRAINT fk_relacion_contable__id_centro_costo FOREIGN KEY (id_centro_costo)
    REFERENCES param.tcentro_costo(id_centro_costo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.relacion_contable
  ADD CONSTRAINT fk_relacion_contable__id_cuenta FOREIGN KEY (id_cuenta)
    REFERENCES conta.tcuenta(id_cuenta)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.relacion_contable
  ADD CONSTRAINT fk_relacion_contable__id_gestion FOREIGN KEY (id_gestion)
    REFERENCES param.tgestion(id_gestion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.relacion_contable
  ADD CONSTRAINT fk_relacion_contable__id_partida FOREIGN KEY (id_partida)
    REFERENCES pre.tpartida(id_partida)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.relacion_contable
  ADD CONSTRAINT fk_relacion_contable__id_tipo_relacion_contable FOREIGN KEY (id_tipo_relacion_contable)
    REFERENCES conta.tipo_relacion_contable(id_tipo_relacion_contable)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
/****************************************F-DEP-JRR-CONTA-0-15/05/2013************************************************/

/***********************************I-DEP-GSS-CONTA-9-07/06/2013*****************************************/

ALTER TABLE conta.tdetalle_plantilla_comprobante
  ADD CONSTRAINT fk_tdetalle_plantilla_comprobante__id_plantilla_comprobante FOREIGN KEY (id_plantilla_comprobante)
    REFERENCES conta.tplantilla_comprobante(id_plantilla_comprobante)
	ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

/***********************************F-DEP-GSS-CONTA-9-07/06/2013*****************************************/

/***********************************I-DEP-GSS-CONTA-9-18/06/2013*****************************************/

ALTER TABLE conta.tinter_comprobante
  ADD CONSTRAINT fk_tinter_comprobante__id_depto FOREIGN KEY (id_depto)
    REFERENCES param.tdepto(id_depto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.tinter_comprobante
  ADD CONSTRAINT fk_tinter_comprobante__id_clase_cbte FOREIGN KEY (id_clase_cbte)
    REFERENCES conta.tclase_comprobante(id_clase_comprobante)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE conta.tinter_comprobante
  ADD CONSTRAINT fk_tinter_comprobante__fk_comprobante FOREIGN KEY (fk_comprobante)
    REFERENCES conta.tinter_comprobante(id_comprobante)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE conta.tinter_comprobante
  ADD CONSTRAINT fk_tinter_comprobante__id_periodo_subsis FOREIGN KEY (id_periodo_subsis)
    REFERENCES param.tperiodo_subsistema(id_periodo_subsistema)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE conta.tinter_comprobante
  ADD CONSTRAINT fk_tinter_comprobante__id_subsistema FOREIGN KEY (id_subsistema)
    REFERENCES segu.tsubsistema(id_subsistema)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE conta.tinter_comprobante
  ADD CONSTRAINT fk_tinter_comprobante__id_usuario FOREIGN KEY (id_usuario)
    REFERENCES segu.tusuario(id_usuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.tinter_comprobante
  ADD CONSTRAINT fk_tinter_comprobante__id_moneda FOREIGN KEY (id_moneda)
    REFERENCES param.tmoneda(id_moneda)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
/***********************************F-DEP-GSS-CONTA-9-18/06/2013*****************************************/