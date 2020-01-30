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
ALTER TABLE conta.ttipo_relacion_contable
  ADD CONSTRAINT fk_ttipo_relacion_contable__id_tabla_relacion_contable FOREIGN KEY (id_tabla_relacion_contable)
    REFERENCES conta.ttabla_relacion_contable(id_tabla_relacion_contable)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE conta.trelacion_contable
  ADD CONSTRAINT fk_trelacion_contable__id_auxiliar FOREIGN KEY (id_auxiliar)
    REFERENCES conta.tauxiliar(id_auxiliar)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE conta.trelacion_contable
  ADD CONSTRAINT fk_trelacion_contable__id_centro_costo FOREIGN KEY (id_centro_costo)
    REFERENCES param.tcentro_costo(id_centro_costo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.trelacion_contable
  ADD CONSTRAINT fk_trelacion_contable__id_cuenta FOREIGN KEY (id_cuenta)
    REFERENCES conta.tcuenta(id_cuenta)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.trelacion_contable
  ADD CONSTRAINT fk_trelacion_contable__id_gestion FOREIGN KEY (id_gestion)
    REFERENCES param.tgestion(id_gestion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.trelacion_contable
  ADD CONSTRAINT fk_trelacion_contable__id_partida FOREIGN KEY (id_partida)
    REFERENCES pre.tpartida(id_partida)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.trelacion_contable
  ADD CONSTRAINT fk_trelacion_contable__id_tipo_relacion_contable FOREIGN KEY (id_tipo_relacion_contable)
    REFERENCES conta.ttipo_relacion_contable(id_tipo_relacion_contable)
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


/***********************************I-DEP-RCM-CONTA-0-21/07/2013*****************************************/
ALTER TABLE conta.tcomprobante
  ADD CONSTRAINT fk_tcomprobante__id_clase_comprobante FOREIGN KEY (id_clase_comprobante)
    REFERENCES conta.tclase_comprobante(id_clase_comprobante)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.tcomprobante
  ADD CONSTRAINT fk_tcomprobante__id_comprobante_fk FOREIGN KEY (id_comprobante_fk)
    REFERENCES conta.tcomprobante(id_comprobante)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.tcomprobante
  ADD CONSTRAINT fk_tcomprobante__id_subsistema FOREIGN KEY (id_subsistema)
    REFERENCES segu.tsubsistema(id_subsistema)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.tcomprobante
  ADD CONSTRAINT fk_tcomprobante__id_depto FOREIGN KEY (id_depto)
    REFERENCES param.tdepto(id_depto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.tcomprobante
  ADD CONSTRAINT fk_tcomprobante__id_moneda FOREIGN KEY (id_moneda)
    REFERENCES param.tmoneda(id_moneda)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.tcomprobante
  ADD CONSTRAINT fk_tcomprobante__id_periodo FOREIGN KEY (id_periodo)
    REFERENCES param.tperiodo(id_periodo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.tcomprobante
  ADD CONSTRAINT fk_tcomprobante__id_funcionario_firma1 FOREIGN KEY (id_funcionario_firma1)
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.tcomprobante
  ADD CONSTRAINT fk_tcomprobante__id_funcionario_firma2 FOREIGN KEY (id_funcionario_firma2)
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.tcomprobante
  ADD CONSTRAINT fk_tcomprobante__id_funcionario_firma3 FOREIGN KEY (id_funcionario_firma3)
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.ttransaccion
  ADD CONSTRAINT fk_ttransaccion__id_comprobante FOREIGN KEY (id_comprobante)
    REFERENCES conta.tcomprobante(id_comprobante)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.ttransaccion
  ADD CONSTRAINT fk_ttransaccion__id_cuenta FOREIGN KEY (id_cuenta)
    REFERENCES conta.tcuenta(id_cuenta)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.ttransaccion
  ADD CONSTRAINT fk_ttransaccion__id_auxiliar FOREIGN KEY (id_auxiliar)
    REFERENCES conta.tauxiliar(id_auxiliar)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.ttransaccion
  ADD CONSTRAINT fk_ttransaccion__id_centro_costo FOREIGN KEY (id_centro_costo)
    REFERENCES param.tcentro_costo(id_centro_costo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.ttransaccion
  ADD CONSTRAINT fk_ttransaccion__id_partida FOREIGN KEY (id_partida)
    REFERENCES pre.tpartida(id_partida)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
/*ALTER TABLE conta.ttransaccion
  ADD CONSTRAINT fk_ttransaccion__id_partida_ejecucion FOREIGN KEY (id_partida_ejecucion)
    REFERENCES pre.tpartida_ejecucion(id_partida_ejecucion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;*/
    
ALTER TABLE conta.ttransaccion
  ADD CONSTRAINT fk_ttransaccion__id_transaccion_fk FOREIGN KEY (id_transaccion_fk)
    REFERENCES conta.ttransaccion(id_transaccion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.ttrans_val
  ADD CONSTRAINT fk_ttrans_val__id_transaccion FOREIGN KEY (id_transaccion)
    REFERENCES conta.ttransaccion(id_transaccion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE conta.ttrans_val
  ADD CONSTRAINT fk_ttrans_val__id_moneda FOREIGN KEY (id_moneda)
    REFERENCES param.tmoneda(id_moneda)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
/***********************************F-DEP-RCM-CONTA-0-21/07/2013*****************************************/

/***********************************I-DEP-RCM-CONTA-18-29/08/2013*****************************************/
ALTER TABLE conta.tint_comprobante
  ADD CONSTRAINT fk_tcomprobante__id_clase_comprobante FOREIGN KEY (id_clase_comprobante)
    REFERENCES conta.tclase_comprobante(id_clase_comprobante)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.tint_comprobante
  ADD CONSTRAINT fk_tcomprobante__id_int_comprobante_fk FOREIGN KEY (id_int_comprobante_fk)
    REFERENCES conta.tint_comprobante(id_int_comprobante)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.tint_comprobante
  ADD CONSTRAINT fk_tcomprobante__id_subsistema FOREIGN KEY (id_subsistema)
    REFERENCES segu.tsubsistema(id_subsistema)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.tint_comprobante
  ADD CONSTRAINT fk_tcomprobante__id_depto FOREIGN KEY (id_depto)
    REFERENCES param.tdepto(id_depto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.tint_comprobante
  ADD CONSTRAINT fk_tcomprobante__id_moneda FOREIGN KEY (id_moneda)
    REFERENCES param.tmoneda(id_moneda)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.tint_comprobante
  ADD CONSTRAINT fk_tcomprobante__id_periodo FOREIGN KEY (id_periodo)
    REFERENCES param.tperiodo(id_periodo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.tint_comprobante
  ADD CONSTRAINT fk_tcomprobante__id_funcionario_firma1 FOREIGN KEY (id_funcionario_firma1)
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.tint_comprobante
  ADD CONSTRAINT fk_tcomprobante__id_funcionario_firma2 FOREIGN KEY (id_funcionario_firma2)
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.tint_comprobante
  ADD CONSTRAINT fk_tcomprobante__id_funcionario_firma3 FOREIGN KEY (id_funcionario_firma3)
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.tplantilla_calculo
  ADD CONSTRAINT fk_tplantilla_calculo__id_plantilla FOREIGN KEY (id_plantilla)
    REFERENCES param.tplantilla(id_plantilla)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.tcomprobante
  ADD CONSTRAINT fk_tcomprobante__id_int_comprobante FOREIGN KEY (id_int_comprobante)
    REFERENCES conta.tint_comprobante(id_int_comprobante)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.ttransaccion
  ADD CONSTRAINT fk_ttransaccion__id_int_transaccion FOREIGN KEY (id_int_transaccion)
    REFERENCES conta.tint_transaccion(id_int_transaccion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

/***********************************F-DEP-RCM-CONTA-18-29/08/2013*****************************************/

/***********************************I-DEP-RCM-CONTA-0-21/10/2013*****************************************/

ALTER TABLE conta.tint_transaccion
  ADD CONSTRAINT fk_tint_transaccion__id_int_comprobante FOREIGN KEY (id_int_comprobante)
    REFERENCES conta.tint_comprobante(id_int_comprobante)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.tint_transaccion
  ADD CONSTRAINT fk_tint_transaccion__id_cuenta FOREIGN KEY (id_cuenta)
    REFERENCES conta.tcuenta(id_cuenta)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.tint_transaccion
  ADD CONSTRAINT fk_tint_transaccion__id_auxiliar FOREIGN KEY (id_auxiliar)
    REFERENCES conta.tauxiliar(id_auxiliar)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.tint_transaccion
  ADD CONSTRAINT fk_tint_transaccion__id_centro_costo FOREIGN KEY (id_centro_costo)
    REFERENCES param.tcentro_costo(id_centro_costo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.tint_transaccion
  ADD CONSTRAINT fk_tint_transaccion__id_partida FOREIGN KEY (id_partida)
    REFERENCES pre.tpartida(id_partida)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE conta.tint_transaccion
  ADD CONSTRAINT fk_tint_transaccion__id_int_transaccion_fk FOREIGN KEY (id_int_transaccion_fk)
    REFERENCES conta.tint_transaccion(id_int_transaccion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

/***********************************F-DEP-RCM-CONTA-0-21/10/2013*****************************************/


/***********************************I-DEP-JRR-CONTA-0-24/04/2014*****************************************/

select pxp.f_insert_testructura_gui ('CTA.1', 'CTA');
select pxp.f_insert_testructura_gui ('RELCON.1', 'RELCON');
select pxp.f_insert_testructura_gui ('RELCON.2', 'RELCON');
select pxp.f_insert_testructura_gui ('RELCON.1.1', 'RELCON.1');
select pxp.f_insert_testructura_gui ('PROVCUEN.1', 'PROVCUEN');
select pxp.f_insert_testructura_gui ('PROVCUEN.2', 'PROVCUEN');
select pxp.f_insert_testructura_gui ('PROVCUEN.3', 'PROVCUEN');
select pxp.f_insert_testructura_gui ('PROVCUEN.2.1', 'PROVCUEN.2');
select pxp.f_insert_testructura_gui ('PROVCUEN.3.1', 'PROVCUEN.3');
select pxp.f_insert_testructura_gui ('RELCONGEN.1', 'RELCONGEN');
select pxp.f_insert_testructura_gui ('RELCONGEN.2', 'RELCONGEN');
select pxp.f_insert_testructura_gui ('CONGASCUE.1', 'CONGASCUE');
select pxp.f_insert_testructura_gui ('CONGASCUE.2', 'CONGASCUE');
select pxp.f_insert_testructura_gui ('RELCCCB.1', 'RELCCCB');
select pxp.f_insert_testructura_gui ('RELCCCB.2', 'RELCCCB');
select pxp.f_insert_testructura_gui ('RELCCCB.3', 'RELCCCB');
select pxp.f_insert_testructura_gui ('RELCCCB.3.1', 'RELCCCB.3');
select pxp.f_insert_testructura_gui ('RELCCCB.3.1.1', 'RELCCCB.3.1');
select pxp.f_insert_testructura_gui ('CBTE.1.1.1', 'CBTE.1.1');
select pxp.f_insert_testructura_gui ('CBTE.1.1.2', 'CBTE.1.1');
select pxp.f_insert_testructura_gui ('CBTE.1.1.3', 'CBTE.1.1');
select pxp.f_insert_testructura_gui ('CBTE.1.1.3.1', 'CBTE.1.1.3');
select pxp.f_insert_testructura_gui ('CBTE.1.1.3.2', 'CBTE.1.1.3');
select pxp.f_insert_testructura_gui ('CBTE.1.1.3.1.1', 'CBTE.1.1.3.1');
select pxp.f_insert_testructura_gui ('CBTE.1.1.3.1.1.1', 'CBTE.1.1.3.1.1');
select pxp.f_insert_testructura_gui ('CBTE.1.1.3.1.1.1.1', 'CBTE.1.1.3.1.1.1');
select pxp.f_insert_testructura_gui ('DEPTCON.1', 'DEPTCON');
select pxp.f_insert_testructura_gui ('DEPTCON.2', 'DEPTCON');
select pxp.f_insert_testructura_gui ('DEPTCON.3', 'DEPTCON');
select pxp.f_insert_testructura_gui ('DEPTCON.4', 'DEPTCON');
select pxp.f_insert_testructura_gui ('DEPTCON.5', 'DEPTCON');
select pxp.f_insert_testructura_gui ('DEPTCON.6', 'DEPTCON');
select pxp.f_insert_testructura_gui ('DEPTCON.7', 'DEPTCON');
select pxp.f_insert_testructura_gui ('DEPTCON.2.1', 'DEPTCON.2');
select pxp.f_insert_testructura_gui ('DEPTCON.2.1.1', 'DEPTCON.2.1');
select pxp.f_insert_testructura_gui ('DEPTCON.2.1.2', 'DEPTCON.2.1');
select pxp.f_insert_testructura_gui ('DEPTCON.2.1.3', 'DEPTCON.2.1');
select pxp.f_insert_testructura_gui ('DEPTCON.2.1.1.1', 'DEPTCON.2.1.1');
select pxp.f_insert_testructura_gui ('PLADOC.1', 'PLADOC');
select pxp.f_insert_testructura_gui ('PLADOC.1.1', 'PLADOC.1');
select pxp.f_insert_testructura_gui ('CBTE.1.3.1.1', 'CBTE.1.3.1');
select pxp.f_insert_testructura_gui ('CBTE.1.3.1.2', 'CBTE.1.3.1');
select pxp.f_insert_testructura_gui ('CBTE.1.3.1.3', 'CBTE.1.3.1');
select pxp.f_insert_testructura_gui ('CBTE.1.3.1.3.1', 'CBTE.1.3.1.3');
select pxp.f_insert_testructura_gui ('CBTE.1.3.1.3.2', 'CBTE.1.3.1.3');
select pxp.f_insert_testructura_gui ('CBTE.1.3.1.3.1.1', 'CBTE.1.3.1.3.1');
select pxp.f_insert_testructura_gui ('CBTE.1.3.1.3.1.1.1', 'CBTE.1.3.1.3.1.1');
select pxp.f_insert_testructura_gui ('CBTE.1.3.1.3.1.1.1.1', 'CBTE.1.3.1.3.1.1.1');
select pxp.f_insert_testructura_gui ('ALMCUE.1', 'ALMCUE');
select pxp.f_insert_testructura_gui ('ALMCUE.2', 'ALMCUE');
select pxp.f_insert_testructura_gui ('ALMCUE.3', 'ALMCUE');
select pxp.f_insert_testructura_gui ('ALMCUE.4', 'ALMCUE');
select pxp.f_insert_testructura_gui ('ALMCUE.5', 'ALMCUE');
select pxp.f_insert_testructura_gui ('ALMCUE.6', 'ALMCUE');
select pxp.f_insert_testructura_gui ('ALMCUE.3.1', 'ALMCUE.3');
select pxp.f_insert_testructura_gui ('ALMCUE.3.1.1', 'ALMCUE.3.1');
select pxp.f_insert_testructura_gui ('ALMCUE.6.1', 'ALMCUE.6');
select pxp.f_insert_testructura_gui ('ALMCUE.6.2', 'ALMCUE.6');
select pxp.f_insert_testructura_gui ('ALMCUE.6.2.1', 'ALMCUE.6.2');
select pxp.f_insert_testructura_gui ('ALMCUE.6.2.2', 'ALMCUE.6.2');
select pxp.f_insert_testructura_gui ('ALMCUE.6.2.1.1', 'ALMCUE.6.2.1');
select pxp.f_insert_testructura_gui ('ALMCUE.6.2.1.2', 'ALMCUE.6.2.1');
select pxp.f_insert_testructura_gui ('CLACUE.1', 'CLACUE');
select pxp.f_insert_testructura_gui ('CLACUE.2', 'CLACUE');
select pxp.f_insert_testructura_gui ('CLACUE.2.1', 'CLACUE.2');
select pxp.f_insert_testructura_gui ('CLACUE.2.2', 'CLACUE.2');
select pxp.f_insert_testructura_gui ('CLACUE.2.3', 'CLACUE.2');
select pxp.f_insert_testructura_gui ('CLACUE.2.1.1', 'CLACUE.2.1');
select pxp.f_insert_testructura_gui ('CLACUE.2.1.1.1', 'CLACUE.2.1.1');
select pxp.f_insert_testructura_gui ('CLACUE.2.2.1', 'CLACUE.2.2');
select pxp.f_insert_testructura_gui ('CLACUE.2.3.1', 'CLACUE.2.3');
select pxp.f_insert_testructura_gui ('RERELCON.1', 'RERELCON');
select pxp.f_insert_testructura_gui ('RERELCON.2', 'RERELCON');
select pxp.f_insert_testructura_gui ('RERELCON.1.1', 'RERELCON.1');
select pxp.f_insert_testructura_gui ('PROVCUEN.3.1.1', 'PROVCUEN.3.1');
select pxp.f_insert_testructura_gui ('CBTE.1.1.3.2.1', 'CBTE.1.1.3.2');
select pxp.f_insert_testructura_gui ('CBTE.1.3.1.3.2.1', 'CBTE.1.3.1.3.2');
select pxp.f_insert_testructura_gui ('ALMCUE.6.2.3', 'ALMCUE.6.2');
select pxp.f_insert_testructura_gui ('ALMCUE.6.2.1.1.1', 'ALMCUE.6.2.1.1');
select pxp.f_insert_testructura_gui ('ALMCUE.6.2.3.1', 'ALMCUE.6.2.3');
select pxp.f_insert_testructura_gui ('ALMCUE.6.2.3.2', 'ALMCUE.6.2.3');
select pxp.f_insert_testructura_gui ('ALMCUE.6.2.3.1.1', 'ALMCUE.6.2.3.1');
select pxp.f_insert_testructura_gui ('ALMCUE.6.2.3.1.1.1', 'ALMCUE.6.2.3.1.1');
select pxp.f_insert_testructura_gui ('ALMCUE.6.2.3.1.1.1.1', 'ALMCUE.6.2.3.1.1.1');
select pxp.f_insert_testructura_gui ('ALMCUE.6.2.3.2.1', 'ALMCUE.6.2.3.2');

/***********************************F-DEP-JRR-CONTA-0-24/04/2014*****************************************/




/***********************************I-DEP-RAC-CONTA-0-27/06/2014*****************************************/




--------------- SQL ---------------

ALTER TABLE conta.tint_rel_devengado
  ADD CONSTRAINT tint_rel_devengado__id_int_transaccion_pag FOREIGN KEY (id_int_transaccion_pag)
    REFERENCES conta.tint_transaccion(id_int_transaccion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--------------- SQL ---------------

ALTER TABLE conta.tint_rel_devengado
  ADD CONSTRAINT tint_rel_devengado_int_transaccion_dev FOREIGN KEY (id_int_transaccion_dev)
    REFERENCES conta.tint_transaccion(id_int_transaccion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


update conta.tplantilla_calculo c set
codigo_tipo_relacion = NULL
where codigo_tipo_relacion = '';

CREATE UNIQUE INDEX ttipo_relacion_contable_codigo_tipo_relacion_key ON conta.ttipo_relacion_contable
(codigo_tipo_relacion);

ALTER TABLE conta.tplantilla_calculo
  ADD CONSTRAINT tplantilla_calculo_coodigo_tipo_relacion FOREIGN KEY (codigo_tipo_relacion)
    REFERENCES conta.ttipo_relacion_contable(codigo_tipo_relacion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;   
   
    
/***********************************F-DEP-RAC-CONTA-0-27/06/2014*****************************************/


/***********************************I-DEP-RAC-CONTA-0-02/07/2014*****************************************/

--------------- SQL ---------------

-- object recreation
ALTER TABLE conta.tint_rel_devengado
  DROP CONSTRAINT tint_rel_devengado__id_int_transaccion_pag RESTRICT;

ALTER TABLE conta.tint_rel_devengado
  ADD CONSTRAINT tint_rel_devengado__id_int_transaccion_pag FOREIGN KEY (id_int_transaccion_pag)
    REFERENCES conta.tint_transaccion(id_int_transaccion)
    MATCH FULL
    ON DELETE CASCADE
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

/***********************************F-DEP-RAC-CONTA-0-02/07/2014*****************************************/


/***********************************I-DEP-RAC-CONTA-0-04/08/2014*****************************************/



--------------- SQL ---------------

ALTER TABLE conta.ttransaccion
  ADD CONSTRAINT fk_ttransaccion__id_orden_trabajo FOREIGN KEY (id_orden_trabajo)
    REFERENCES conta.torden_trabajo(id_orden_trabajo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


--------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ADD CONSTRAINT fk_tint_transaccion__if_orden_trabajo FOREIGN KEY (id_orden_trabajo)
    REFERENCES conta.torden_trabajo(id_orden_trabajo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
/***********************************F-DEP-RAC-CONTA-0-04/08/2014*****************************************/



/***********************************I-DEP-RAC-CONTA-0-09/08/2014*****************************************/


CREATE OR REPLACE VIEW conta.vorden_trabajo(
    id_orden_trabajo,
    estado_reg,
    fecha_final,
    fecha_inicio,
    desc_orden,
    motivo_orden,
    fecha_reg,
    id_usuario_reg,
    id_usuario_mod,
    fecha_mod,
    usr_reg,
    usr_mod,
    id_grupo_ots)
AS
  SELECT odt.id_orden_trabajo,
         odt.estado_reg,
         odt.fecha_final,
         odt.fecha_inicio,
         odt.desc_orden,
         odt.motivo_orden,
         odt.fecha_reg,
         odt.id_usuario_reg,
         odt.id_usuario_mod,
         odt.fecha_mod,
         usu1.cuenta AS usr_reg,
         usu2.cuenta AS usr_mod,
         pxp.aggarray(god.id_grupo_ot) AS id_grupo_ots
  FROM conta.torden_trabajo odt
       JOIN segu.tusuario usu1 ON usu1.id_usuario = odt.id_usuario_reg
       LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = odt.id_usuario_mod
       LEFT JOIN conta.tgrupo_ot_det god ON god.id_orden_trabajo =
         odt.id_orden_trabajo AND god.estado_reg::text = 'activo'::text
  WHERE odt.estado_reg::text = 'activo'::text
  GROUP BY odt.id_orden_trabajo,
           odt.estado_reg,
           odt.fecha_final,
           odt.fecha_inicio,
           odt.desc_orden,
           odt.motivo_orden,
           odt.fecha_reg,
           odt.id_usuario_reg,
           odt.id_usuario_mod,
           odt.fecha_mod,
           usu1.cuenta,
           usu2.cuenta;

/***********************************F-DEP-RAC-CONTA-0-09/08/2014*****************************************/



/***********************************I-DEP-RAC-CONTA-0-11/12/2014*****************************************/
--------------- SQL ---------------
/*  RAC 14/07/"017 este triguer esta en desuso
CREATE TRIGGER f_trig_insert_int_trans_val
  AFTER INSERT OR UPDATE 
  ON conta.tint_transaccion FOR EACH ROW 
  EXECUTE PROCEDURE conta.f_insert_int_trans_val();*/


CREATE TRIGGER f_trig_insert_trans_val
  AFTER INSERT OR UPDATE 
  ON conta.ttransaccion FOR EACH ROW 
  EXECUTE PROCEDURE conta.f_insert_trans_val();
  
  
/***********************************F-DEP-RAC-CONTA-0-11/12/2014*****************************************/

/***********************************I-DEP-RAC-CONTA-0-17/12/2014*****************************************/

--------------- SQL ---------------

ALTER TABLE conta.tint_comprobante
  DROP CONSTRAINT fk_tcomprobante__id_int_comprobante_fk RESTRICT;
  
--------------- SQL ---------------

ALTER TABLE conta.tint_comprobante
  DROP COLUMN id_int_comprobante_fk;
  
/***********************************F-DEP-RAC-CONTA-0-17/12/2014*****************************************/






/***********************************I-DEP-RAC-CONTA-0-30/12/2014*****************************************/

CREATE VIEW conta.vint_comprobante (
    id_int_comprobante,
    id_clase_comprobante,
    id_subsistema,
    id_depto,
    id_moneda,
    id_periodo,
    id_funcionario_firma1,
    id_funcionario_firma2,
    id_funcionario_firma3,
    tipo_cambio,
    beneficiario,
    nro_cbte,
    estado_reg,
    glosa1,
    fecha,
    glosa2,
    nro_tramite,
    momento,
    id_usuario_reg,
    fecha_reg,
    id_usuario_mod,
    fecha_mod,
    usr_reg,
    usr_mod,
    desc_clase_comprobante,
    desc_subsistema,
    desc_depto,
    desc_moneda,
    desc_firma1,
    desc_firma2,
    desc_firma3,
    momento_comprometido,
    momento_ejecutado,
    momento_pagado,
    manual,
    id_int_comprobante_fks,
    id_tipo_relacion_comprobante,
    desc_tipo_relacion_comprobante)
AS
SELECT incbte.id_int_comprobante,
    incbte.id_clase_comprobante,
    incbte.id_subsistema,
    incbte.id_depto,
    incbte.id_moneda,
    incbte.id_periodo,
    incbte.id_funcionario_firma1,
    incbte.id_funcionario_firma2,
    incbte.id_funcionario_firma3,
    incbte.tipo_cambio,
    incbte.beneficiario,
    incbte.nro_cbte,
    incbte.estado_reg,
    incbte.glosa1,
    incbte.fecha,
    incbte.glosa2,
    incbte.nro_tramite,
    incbte.momento,
    incbte.id_usuario_reg,
    incbte.fecha_reg,
    incbte.id_usuario_mod,
    incbte.fecha_mod,
    usu1.cuenta AS usr_reg,
    usu2.cuenta AS usr_mod,
    ccbte.descripcion AS desc_clase_comprobante,
    sis.nombre AS desc_subsistema,
    (dpto.codigo::text || '-'::text) || dpto.nombre::text AS desc_depto,
    (mon.codigo::text || '-'::text) || mon.moneda::text AS desc_moneda,
    fir1.desc_funcionario2 AS desc_firma1,
    fir2.desc_funcionario2 AS desc_firma2,
    fir3.desc_funcionario2 AS desc_firma3,
    pxp.f_iif(incbte.momento_comprometido::text = 'si'::text, 'true'::character
        varying, 'false'::character varying) AS momento_comprometido,
    pxp.f_iif(incbte.momento_ejecutado::text = 'si'::text, 'true'::character
        varying, 'false'::character varying) AS momento_ejecutado,
    pxp.f_iif(incbte.momento_pagado::text = 'si'::text, 'true'::character
        varying, 'false'::character varying) AS momento_pagado,
    incbte.manual,
    array_to_string(incbte.id_int_comprobante_fks, ','::text) AS id_int_comprobante_fks,
    incbte.id_tipo_relacion_comprobante,
    trc.nombre AS desc_tipo_relacion_comprobante
FROM conta.tint_comprobante incbte
   JOIN segu.tusuario usu1 ON usu1.id_usuario = incbte.id_usuario_reg
   LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = incbte.id_usuario_mod
   JOIN conta.tclase_comprobante ccbte ON ccbte.id_clase_comprobante =
       incbte.id_clase_comprobante
   JOIN segu.tsubsistema sis ON sis.id_subsistema = incbte.id_subsistema
   JOIN param.tdepto dpto ON dpto.id_depto = incbte.id_depto
   JOIN param.tmoneda mon ON mon.id_moneda = incbte.id_moneda
   LEFT JOIN orga.vfuncionario fir1 ON fir1.id_funcionario =
       incbte.id_funcionario_firma1
   LEFT JOIN orga.vfuncionario fir2 ON fir2.id_funcionario =
       incbte.id_funcionario_firma2
   LEFT JOIN orga.vfuncionario fir3 ON fir3.id_funcionario =
       incbte.id_funcionario_firma3
   LEFT JOIN conta.ttipo_relacion_comprobante trc ON
       trc.id_tipo_relacion_comprobante = incbte.id_tipo_relacion_comprobante;
   
/***********************************F-DEP-RAC-CONTA-0-30/12/2014*****************************************/




/***********************************I-DEP-RAC-CONTA-0-21/05/2015*****************************************/
CREATE OR REPLACE VIEW conta.vint_comprobante(
    id_int_comprobante,
    id_clase_comprobante,
    id_subsistema,
    id_depto,
    id_moneda,
    id_periodo,
    id_funcionario_firma1,
    id_funcionario_firma2,
    id_funcionario_firma3,
    tipo_cambio,
    beneficiario,
    nro_cbte,
    estado_reg,
    glosa1,
    fecha,
    glosa2,
    nro_tramite,
    momento,
    id_usuario_reg,
    fecha_reg,
    id_usuario_mod,
    fecha_mod,
    usr_reg,
    usr_mod,
    desc_clase_comprobante,
    desc_subsistema,
    desc_depto,
    desc_moneda,
    desc_firma1,
    desc_firma2,
    desc_firma3,
    momento_comprometido,
    momento_ejecutado,
    momento_pagado,
    manual,
    id_int_comprobante_fks,
    id_tipo_relacion_comprobante,
    desc_tipo_relacion_comprobante,
    codigo_depto)
AS
  SELECT incbte.id_int_comprobante,
         incbte.id_clase_comprobante,
         incbte.id_subsistema,
         incbte.id_depto,
         incbte.id_moneda,
         incbte.id_periodo,
         incbte.id_funcionario_firma1,
         incbte.id_funcionario_firma2,
         incbte.id_funcionario_firma3,
         incbte.tipo_cambio,
         incbte.beneficiario,
         incbte.nro_cbte,
         incbte.estado_reg,
         incbte.glosa1,
         incbte.fecha,
         incbte.glosa2,
         incbte.nro_tramite,
         incbte.momento,
         incbte.id_usuario_reg,
         incbte.fecha_reg,
         incbte.id_usuario_mod,
         incbte.fecha_mod,
         usu1.cuenta AS usr_reg,
         usu2.cuenta AS usr_mod,
         ccbte.descripcion AS desc_clase_comprobante,
         sis.nombre AS desc_subsistema,
         (dpto.codigo::text || '-'::text) || dpto.nombre::text AS desc_depto,
         mon.codigo::text AS desc_moneda,
         fir1.desc_funcionario2 AS desc_firma1,
         fir2.desc_funcionario2 AS desc_firma2,
         fir3.desc_funcionario2 AS desc_firma3,
         pxp.f_iif(incbte.momento_comprometido::text = 'si'::text, 'true'::
           character varying, 'false'::character varying) AS
           momento_comprometido,
         pxp.f_iif(incbte.momento_ejecutado::text = 'si'::text, 'true'::
           character varying, 'false'::character varying) AS momento_ejecutado,
         pxp.f_iif(incbte.momento_pagado::text = 'si'::text, 'true'::character
           varying, 'false'::character varying) AS momento_pagado,
         incbte.manual,
         array_to_string(incbte.id_int_comprobante_fks, ','::text) AS
           id_int_comprobante_fks,
         incbte.id_tipo_relacion_comprobante,
         trc.nombre AS desc_tipo_relacion_comprobante,
         dpto.codigo AS codigo_depto
  FROM conta.tint_comprobante incbte
       JOIN segu.tusuario usu1 ON usu1.id_usuario = incbte.id_usuario_reg
       LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = incbte.id_usuario_mod
       JOIN conta.tclase_comprobante ccbte ON ccbte.id_clase_comprobante =
         incbte.id_clase_comprobante
       JOIN segu.tsubsistema sis ON sis.id_subsistema = incbte.id_subsistema
       JOIN param.tdepto dpto ON dpto.id_depto = incbte.id_depto
       JOIN param.tmoneda mon ON mon.id_moneda = incbte.id_moneda
       LEFT JOIN orga.vfuncionario fir1 ON fir1.id_funcionario =
         incbte.id_funcionario_firma1
       LEFT JOIN orga.vfuncionario fir2 ON fir2.id_funcionario =
         incbte.id_funcionario_firma2
       LEFT JOIN orga.vfuncionario fir3 ON fir3.id_funcionario =
         incbte.id_funcionario_firma3
       LEFT JOIN conta.ttipo_relacion_comprobante trc ON
         trc.id_tipo_relacion_comprobante = incbte.id_tipo_relacion_comprobante;

         
/***********************************F-DEP-RAC-CONTA-0-21/05/2015*****************************************/




/***********************************I-DEP-RAC-CONTA-0-05/08/2015*****************************************/



--------------- SQL ---------------

 -- object recreation
DROP VIEW conta.vint_comprobante;

CREATE VIEW conta.vint_comprobante
AS
  SELECT incbte.id_int_comprobante,
         incbte.id_clase_comprobante,
         incbte.id_subsistema,
         incbte.id_depto,
         incbte.id_moneda,
         incbte.id_periodo,
         incbte.id_funcionario_firma1,
         incbte.id_funcionario_firma2,
         incbte.id_funcionario_firma3,
         incbte.tipo_cambio,
         incbte.beneficiario,
         incbte.nro_cbte,
         incbte.estado_reg,
         incbte.glosa1,
         incbte.fecha,
         incbte.glosa2,
         incbte.nro_tramite,
         incbte.momento,
         incbte.id_usuario_reg,
         incbte.fecha_reg,
         incbte.id_usuario_mod,
         incbte.fecha_mod,
         usu1.cuenta AS usr_reg,
         usu2.cuenta AS usr_mod,
         ccbte.descripcion AS desc_clase_comprobante,
         sis.nombre AS desc_subsistema,
         (dpto.codigo::text || '-'::text) || dpto.nombre::text AS desc_depto,
         mon.codigo::text AS desc_moneda,
         fir1.desc_funcionario2 AS desc_firma1,
         fir2.desc_funcionario2 AS desc_firma2,
         fir3.desc_funcionario2 AS desc_firma3,
         pxp.f_iif(incbte.momento_comprometido::text = 'si'::text, 'true'::
           character varying, 'false'::character varying) AS
           momento_comprometido,
         pxp.f_iif(incbte.momento_ejecutado::text = 'si'::text, 'true'::
           character varying, 'false'::character varying) AS momento_ejecutado,
         pxp.f_iif(incbte.momento_pagado::text = 'si'::text, 'true'::character
           varying, 'false'::character varying) AS momento_pagado,
         incbte.manual,
         array_to_string(incbte.id_int_comprobante_fks, ','::text) AS
           id_int_comprobante_fks,
         incbte.id_tipo_relacion_comprobante,
         trc.nombre AS desc_tipo_relacion_comprobante,
         dpto.codigo AS codigo_depto,
          incbte.cbte_cierre,
          incbte.cbte_apertura,
          incbte.cbte_aitb
  FROM conta.tint_comprobante incbte
       JOIN segu.tusuario usu1 ON usu1.id_usuario = incbte.id_usuario_reg
       LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = incbte.id_usuario_mod
       JOIN conta.tclase_comprobante ccbte ON ccbte.id_clase_comprobante =
         incbte.id_clase_comprobante
       JOIN segu.tsubsistema sis ON sis.id_subsistema = incbte.id_subsistema
       JOIN param.tdepto dpto ON dpto.id_depto = incbte.id_depto
       JOIN param.tmoneda mon ON mon.id_moneda = incbte.id_moneda
       LEFT JOIN orga.vfuncionario fir1 ON fir1.id_funcionario =
         incbte.id_funcionario_firma1
       LEFT JOIN orga.vfuncionario fir2 ON fir2.id_funcionario =
         incbte.id_funcionario_firma2
       LEFT JOIN orga.vfuncionario fir3 ON fir3.id_funcionario =
         incbte.id_funcionario_firma3
       LEFT JOIN conta.ttipo_relacion_comprobante trc ON
         trc.id_tipo_relacion_comprobante = incbte.id_tipo_relacion_comprobante;

ALTER TABLE conta.vint_comprobante
  OWNER TO postgres;
  
/***********************************F-DEP-RAC-CONTA-0-05/08/2015*****************************************/




/***********************************I-DEP-FFP-CONTA-0-16/09/2015*****************************************/

select pxp.f_insert_testructura_gui ('banca', 'CONTA');
select pxp.f_insert_testructura_gui ('CONFBA', 'banca');
select pxp.f_insert_testructura_gui ('BACO', 'banca');
select pxp.f_insert_testructura_gui ('BAVE', 'banca');

/***********************************F-DEP-FFP-CONTA-0-16/09/2015*****************************************/




/***********************************I-DEP-FFP-CONTA-0-24/09/2015*****************************************/


CREATE VIEW conta.vagrupador
AS
  SELECT agr.id_agrupador,
         agr.id_depto_conta,
         agr.fecha_cbte,
         agr.id_moneda,
         agr.tipo,
         agr.incluir_rev,
         agr.id_gestion
  FROM conta.tagrupador agr;


--------------- SQL ---------------

CREATE VIEW conta.vdoc_compra_venta_det
AS
  SELECT ad.id_agrupador_doc,
         dcv.id_moneda,
         dcv.id_int_comprobante,
         dcv.id_plantilla,
         dcv.importe_doc,
         dcv.importe_excento,
         COALESCE(dcv.importe_excento, 0::numeric) + COALESCE(dcv.importe_ice, 0
           ::numeric) AS importe_total_excento,
         dcv.importe_descuento,
         dcv.importe_descuento_ley,
         dcv.importe_ice,
         dcv.importe_it,
         dcv.importe_iva,
         dcv.importe_pago_liquido,
         dcv.nro_documento,
         dcv.nro_dui,
         dcv.nro_autorizacion,
         dcv.razon_social,
         dcv.revisado,
         dcv.manual,
         dcv.obs,
         dcv.nit,
         dcv.fecha,
         dcv.codigo_control,
         dcv.sw_contabilizar,
         dcv.tipo,
         ad.id_agrupador,
         ad.id_doc_compra_venta,
         dco.id_concepto_ingas,
         dco.id_centro_costo,
         dco.id_orden_trabajo,
         dco.precio_total,
         dco.id_doc_concepto,
         cig.desc_ingas,
         dcv.razon_social || ' - ' || cig.desc_ingas ||' ( ' || dco.descripcion || ' ) Nro Doc: '|| COALESCE(dcv.nro_documento) AS descripcion
  FROM conta.tagrupador_doc ad
       JOIN conta.tdoc_compra_venta dcv ON ad.id_doc_compra_venta =
         dcv.id_doc_compra_venta
       JOIN conta.tdoc_concepto dco ON dco.id_doc_compra_venta =
         dcv.id_doc_compra_venta
       JOIN param.tconcepto_ingas cig ON cig.id_concepto_ingas =
         dco.id_concepto_ingas;


/***********************************F-DEP-FFP-CONTA-0-24/09/2015*****************************************/

/***********************************I-DEP-FFP-CONTA-0-29/09/2015*****************************************/

CREATE OR REPLACE VIEW conta.vint_comprobante(
    id_int_comprobante,
    id_clase_comprobante,
    id_subsistema,
    id_depto,
    id_moneda,
    id_periodo,
    id_funcionario_firma1,
    id_funcionario_firma2,
    id_funcionario_firma3,
    tipo_cambio,
    beneficiario,
    nro_cbte,
    estado_reg,
    glosa1,
    fecha,
    glosa2,
    nro_tramite,
    momento,
    id_usuario_reg,
    fecha_reg,
    id_usuario_mod,
    fecha_mod,
    usr_reg,
    usr_mod,
    desc_clase_comprobante,
    desc_subsistema,
    desc_depto,
    desc_moneda,
    desc_firma1,
    desc_firma2,
    desc_firma3,
    momento_comprometido,
    momento_ejecutado,
    momento_pagado,
    manual,
    id_int_comprobante_fks,
    id_tipo_relacion_comprobante,
    desc_tipo_relacion_comprobante,
    codigo_depto,
    cbte_cierre,
    cbte_apertura,
    cbte_aitb,
    temporal,
    vbregional)
AS
  SELECT incbte.id_int_comprobante,
         incbte.id_clase_comprobante,
         incbte.id_subsistema,
         incbte.id_depto,
         incbte.id_moneda,
         incbte.id_periodo,
         incbte.id_funcionario_firma1,
         incbte.id_funcionario_firma2,
         incbte.id_funcionario_firma3,
         incbte.tipo_cambio,
         incbte.beneficiario,
         incbte.nro_cbte,
         incbte.estado_reg,
         incbte.glosa1,
         incbte.fecha,
         incbte.glosa2,
         incbte.nro_tramite,
         incbte.momento,
         incbte.id_usuario_reg,
         incbte.fecha_reg,
         incbte.id_usuario_mod,
         incbte.fecha_mod,
         usu1.cuenta AS usr_reg,
         usu2.cuenta AS usr_mod,
         ccbte.descripcion AS desc_clase_comprobante,
         sis.nombre AS desc_subsistema,
         (dpto.codigo::text || '-'::text) || dpto.nombre::text AS desc_depto,
         mon.codigo::text AS desc_moneda,
         fir1.desc_funcionario2 AS desc_firma1,
         fir2.desc_funcionario2 AS desc_firma2,
         fir3.desc_funcionario2 AS desc_firma3,
         pxp.f_iif(incbte.momento_comprometido::text = 'si'::text, 'true'::
           character varying, 'false'::character varying) AS
           momento_comprometido,
         pxp.f_iif(incbte.momento_ejecutado::text = 'si'::text, 'true'::
           character varying, 'false'::character varying) AS momento_ejecutado,
         pxp.f_iif(incbte.momento_pagado::text = 'si'::text, 'true'::character
           varying, 'false'::character varying) AS momento_pagado,
         incbte.manual,
         array_to_string(incbte.id_int_comprobante_fks, ','::text) AS
           id_int_comprobante_fks,
         incbte.id_tipo_relacion_comprobante,
         trc.nombre AS desc_tipo_relacion_comprobante,
         dpto.codigo AS codigo_depto,
         incbte.cbte_cierre,
         incbte.cbte_apertura,
         incbte.cbte_aitb,
         incbte.temporal,
         incbte.vbregional
  FROM conta.tint_comprobante incbte
       JOIN segu.tusuario usu1 ON usu1.id_usuario = incbte.id_usuario_reg
       LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = incbte.id_usuario_mod
       JOIN conta.tclase_comprobante ccbte ON ccbte.id_clase_comprobante =
         incbte.id_clase_comprobante
       JOIN segu.tsubsistema sis ON sis.id_subsistema = incbte.id_subsistema
       JOIN param.tdepto dpto ON dpto.id_depto = incbte.id_depto
       JOIN param.tmoneda mon ON mon.id_moneda = incbte.id_moneda
       LEFT JOIN orga.vfuncionario fir1 ON fir1.id_funcionario =
         incbte.id_funcionario_firma1
       LEFT JOIN orga.vfuncionario fir2 ON fir2.id_funcionario =
         incbte.id_funcionario_firma2
       LEFT JOIN orga.vfuncionario fir3 ON fir3.id_funcionario =
         incbte.id_funcionario_firma3
       LEFT JOIN conta.ttipo_relacion_comprobante trc ON
         trc.id_tipo_relacion_comprobante = incbte.id_tipo_relacion_comprobante;
/***********************************F-DEP-FFP-CONTA-0-29/09/2015*****************************************/


/***********************************I-DEP-RAC-CONTA-0-09/10/2015*****************************************/


CREATE OR REPLACE VIEW conta.vint_transaccion(
    id_int_transaccion,
    id_partida,
    id_centro_costo,
    id_partida_ejecucion,
    estado_reg,
    id_int_transaccion_fk,
    id_cuenta,
    glosa,
    id_int_comprobante,
    id_auxiliar,
    id_usuario_reg,
    fecha_reg,
    id_usuario_mod,
    fecha_mod,
    desc_partida,
    desc_centro_costo,
    desc_cuenta,
    desc_auxiliar,
    tipo_partida,
    id_orden_trabajo,
    desc_orden,
    importe_debe,
    importe_haber,
    importe_gasto,
    importe_recurso,
    importe_debe_mb,
    importe_haber_mb,
    importe_gasto_mb,
    importe_recurso_mb,
    banco,
    forma_pago,
    nombre_cheque_trans,
    nro_cuenta_bancaria_trans,
    nro_cheque)
AS
  SELECT transa.id_int_transaccion,
         transa.id_partida,
         transa.id_centro_costo,
         transa.id_partida_ejecucion,
         transa.estado_reg,
         transa.id_int_transaccion_fk,
         transa.id_cuenta,
         transa.glosa,
         transa.id_int_comprobante,
         transa.id_auxiliar,
         transa.id_usuario_reg,
         transa.fecha_reg,
         transa.id_usuario_mod,
         transa.fecha_mod,
         CASE par.sw_movimiento
           WHEN 'flujo'::text THEN (('(F) '::text || par.codigo::text) || ' - '
             ::text) || par.nombre_partida::text
           ELSE (par.codigo::text || ' - '::text) || par.nombre_partida::text
         END AS desc_partida,
         cc.codigo_cc AS desc_centro_costo,
         (cue.nro_cuenta::text || ' - '::text) || cue.nombre_cuenta::text AS
           desc_cuenta,
         (aux.codigo_auxiliar::text || ' - '::text) || aux.nombre_auxiliar::text
           AS desc_auxiliar,
         par.sw_movimiento AS tipo_partida,
         ot.id_orden_trabajo,
         ot.desc_orden,
         transa.importe_debe,
         transa.importe_haber,
         transa.importe_gasto,
         transa.importe_recurso,
         transa.importe_debe_mb,
         transa.importe_haber_mb,
         transa.importe_gasto_mb,
         transa.importe_recurso_mb,
         transa.banco,
         transa.forma_pago,
         transa.nombre_cheque_trans,
         transa.nro_cuenta_bancaria_trans,
         transa.nro_cheque
  FROM conta.tint_transaccion transa
       JOIN conta.tcuenta cue ON cue.id_cuenta = transa.id_cuenta
       LEFT JOIN pre.tpartida par ON par.id_partida = transa.id_partida
       LEFT JOIN param.vcentro_costo cc ON cc.id_centro_costo =
         transa.id_centro_costo
       LEFT JOIN conta.tauxiliar aux ON aux.id_auxiliar = transa.id_auxiliar
       LEFT JOIN conta.torden_trabajo ot ON ot.id_orden_trabajo =
         transa.id_orden_trabajo;

CREATE OR REPLACE VIEW conta.vint_rel_devengado(
    id_int_rel_devengado,
    id_int_transaccion_pag,
    id_int_transaccion_dev,
    monto_pago,
    id_partida_ejecucion_pag,
    monto_pago_mb,
    estado_reg,
    id_usuario_ai,
    fecha_reg,
    usuario_ai,
    id_usuario_reg,
    fecha_mod,
    id_usuario_mod,
    usr_reg,
    usr_mod,
    nro_cbte_dev,
    desc_cuenta_dev,
    desc_partida_dev,
    desc_centro_costo_dev,
    desc_orden_dev,
    importe_debe_dev,
    desc_cuenta_pag,
    desc_partida_pag,
    desc_centro_costo_pag,
    desc_orden_pag,
    importe_debe_pag,
    id_cuenta_dev,
    id_orden_trabajo_dev,
    id_auxiliar_dev,
    id_centro_costo_dev,
    id_cuenta_pag,
    id_orden_trabajo_pag,
    id_auxiliar_pag,
    id_centro_costo_pag,
    id_int_comprobante_pago,
    id_int_comprobante_dev,
    tipo_partida_dev,
    tipo_partida_pag,
    desc_auxiliar_dev,
    desc_auxiliar_pag)
AS
  SELECT rde.id_int_rel_devengado,
         rde.id_int_transaccion_pag,
         rde.id_int_transaccion_dev,
         rde.monto_pago,
         rde.id_partida_ejecucion_pag,
         rde.monto_pago_mb,
         rde.estado_reg,
         rde.id_usuario_ai,
         rde.fecha_reg,
         rde.usuario_ai,
         rde.id_usuario_reg,
         rde.fecha_mod,
         rde.id_usuario_mod,
         usu1.cuenta AS usr_reg,
         usu2.cuenta AS usr_mod,
         cd.nro_cbte AS nro_cbte_dev,
         td.desc_cuenta AS desc_cuenta_dev,
         td.desc_partida AS desc_partida_dev,
         td.desc_centro_costo AS desc_centro_costo_dev,
         td.desc_orden AS desc_orden_dev,
         td.importe_debe AS importe_debe_dev,
         tp.desc_cuenta AS desc_cuenta_pag,
         tp.desc_partida AS desc_partida_pag,
         tp.desc_centro_costo AS desc_centro_costo_pag,
         tp.desc_orden AS desc_orden_pag,
         tp.importe_debe AS importe_debe_pag,
         td.id_cuenta AS id_cuenta_dev,
         td.id_orden_trabajo AS id_orden_trabajo_dev,
         td.id_auxiliar AS id_auxiliar_dev,
         td.id_centro_costo AS id_centro_costo_dev,
         tp.id_cuenta AS id_cuenta_pag,
         tp.id_orden_trabajo AS id_orden_trabajo_pag,
         tp.id_auxiliar AS id_auxiliar_pag,
         tp.id_centro_costo AS id_centro_costo_pag,
         tp.id_int_comprobante AS id_int_comprobante_pago,
         td.id_int_comprobante AS id_int_comprobante_dev,
         td.tipo_partida AS tipo_partida_dev,
         tp.tipo_partida AS tipo_partida_pag,
         td.desc_auxiliar AS desc_auxiliar_dev,
         tp.desc_auxiliar AS desc_auxiliar_pag
  FROM conta.tint_rel_devengado rde
       JOIN conta.vint_transaccion tp ON tp.id_int_transaccion =
         rde.id_int_transaccion_pag
       JOIN conta.vint_transaccion td ON td.id_int_transaccion =
         rde.id_int_transaccion_dev
       JOIN conta.tint_comprobante cd ON cd.id_int_comprobante =
         tp.id_int_comprobante
       JOIN segu.tusuario usu1 ON usu1.id_usuario = rde.id_usuario_reg
       LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = rde.id_usuario_mod;
 

/***********************************F-DEP-RAC-CONTA-0-09/10/2015*****************************************/

/***********************************I-DEP-JRR-CONTA-0-09/10/2015****************************************/

ALTER TABLE conta.toficina_ot
  ADD CONSTRAINT fk_toficina_ot__if_oficina FOREIGN KEY (id_oficina)
    REFERENCES orga.toficina(id_oficina)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


ALTER TABLE conta.toficina_ot
  ADD CONSTRAINT fk_toficina_ot__if_orden_trabajo FOREIGN KEY (id_orden_trabajo)
    REFERENCES conta.torden_trabajo(id_orden_trabajo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

/***********************************F-DEP-JRR-CONTA-0-09/10/2015****************************************/



/***********************************I-DEP-RAC-CONTA-0-14/10/2015****************************************/

CREATE OR REPLACE VIEW conta.vint_comprobante (
    id_int_comprobante,
    id_clase_comprobante,
    id_subsistema,
    id_depto,
    id_moneda,
    id_periodo,
    id_funcionario_firma1,
    id_funcionario_firma2,
    id_funcionario_firma3,
    tipo_cambio,
    beneficiario,
    nro_cbte,
    estado_reg,
    glosa1,
    fecha,
    glosa2,
    nro_tramite,
    momento,
    id_usuario_reg,
    fecha_reg,
    id_usuario_mod,
    fecha_mod,
    usr_reg,
    usr_mod,
    desc_clase_comprobante,
    desc_subsistema,
    desc_depto,
    desc_moneda,
    desc_firma1,
    desc_firma2,
    desc_firma3,
    momento_comprometido,
    momento_ejecutado,
    momento_pagado,
    manual,
    id_int_comprobante_fks,
    id_tipo_relacion_comprobante,
    desc_tipo_relacion_comprobante,
    codigo_depto,
    cbte_cierre,
    cbte_apertura,
    cbte_aitb,
    temporal,
    vbregional,
    fecha_costo_ini,
    fecha_costo_fin)
AS
 SELECT incbte.id_int_comprobante,
    incbte.id_clase_comprobante,
    incbte.id_subsistema,
    incbte.id_depto,
    incbte.id_moneda,
    incbte.id_periodo,
    incbte.id_funcionario_firma1,
    incbte.id_funcionario_firma2,
    incbte.id_funcionario_firma3,
    incbte.tipo_cambio,
    incbte.beneficiario,
    incbte.nro_cbte,
    incbte.estado_reg,
    incbte.glosa1,
    incbte.fecha,
    incbte.glosa2,
    incbte.nro_tramite,
    incbte.momento,
    incbte.id_usuario_reg,
    incbte.fecha_reg,
    incbte.id_usuario_mod,
    incbte.fecha_mod,
    usu1.cuenta AS usr_reg,
    usu2.cuenta AS usr_mod,
    ccbte.descripcion AS desc_clase_comprobante,
    sis.nombre AS desc_subsistema,
    (dpto.codigo::text || '-'::text) || dpto.nombre::text AS desc_depto,
    mon.codigo::text AS desc_moneda,
    fir1.desc_funcionario2 AS desc_firma1,
    fir2.desc_funcionario2 AS desc_firma2,
    fir3.desc_funcionario2 AS desc_firma3,
    pxp.f_iif(incbte.momento_comprometido::text = 'si'::text, 'true'::character varying, 'false'::character varying) AS momento_comprometido,
    pxp.f_iif(incbte.momento_ejecutado::text = 'si'::text, 'true'::character varying, 'false'::character varying) AS momento_ejecutado,
    pxp.f_iif(incbte.momento_pagado::text = 'si'::text, 'true'::character varying, 'false'::character varying) AS momento_pagado,
    incbte.manual,
    array_to_string(incbte.id_int_comprobante_fks, ','::text) AS id_int_comprobante_fks,
    incbte.id_tipo_relacion_comprobante,
    trc.nombre AS desc_tipo_relacion_comprobante,
    dpto.codigo AS codigo_depto,
    incbte.cbte_cierre,
    incbte.cbte_apertura,
    incbte.cbte_aitb,
    incbte.temporal,
    incbte.vbregional,
    incbte.fecha_costo_ini,
    incbte.fecha_costo_fin
   FROM conta.tint_comprobante incbte
   JOIN segu.tusuario usu1 ON usu1.id_usuario = incbte.id_usuario_reg
   LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = incbte.id_usuario_mod
   JOIN conta.tclase_comprobante ccbte ON ccbte.id_clase_comprobante = incbte.id_clase_comprobante
   JOIN segu.tsubsistema sis ON sis.id_subsistema = incbte.id_subsistema
   JOIN param.tdepto dpto ON dpto.id_depto = incbte.id_depto
   JOIN param.tmoneda mon ON mon.id_moneda = incbte.id_moneda
   LEFT JOIN orga.vfuncionario fir1 ON fir1.id_funcionario = incbte.id_funcionario_firma1
   LEFT JOIN orga.vfuncionario fir2 ON fir2.id_funcionario = incbte.id_funcionario_firma2
   LEFT JOIN orga.vfuncionario fir3 ON fir3.id_funcionario = incbte.id_funcionario_firma3
   LEFT JOIN conta.ttipo_relacion_comprobante trc ON trc.id_tipo_relacion_comprobante = incbte.id_tipo_relacion_comprobante;


/***********************************F-DEP-RAC-CONTA-0-14/10/2015****************************************/


/***********************************I-DEP-RAC-CONTA-0-03/11/2015****************************************/

CREATE OR REPLACE VIEW conta.vint_comprobante(
    id_int_comprobante,
    id_clase_comprobante,
    id_subsistema,
    id_depto,
    id_moneda,
    id_periodo,
    id_funcionario_firma1,
    id_funcionario_firma2,
    id_funcionario_firma3,
    tipo_cambio,
    beneficiario,
    nro_cbte,
    estado_reg,
    glosa1,
    fecha,
    glosa2,
    nro_tramite,
    momento,
    id_usuario_reg,
    fecha_reg,
    id_usuario_mod,
    fecha_mod,
    usr_reg,
    usr_mod,
    desc_clase_comprobante,
    desc_subsistema,
    desc_depto,
    desc_moneda,
    desc_firma1,
    desc_firma2,
    desc_firma3,
    momento_comprometido,
    momento_ejecutado,
    momento_pagado,
    manual,
    id_int_comprobante_fks,
    id_tipo_relacion_comprobante,
    desc_tipo_relacion_comprobante,
    codigo_depto,
    cbte_cierre,
    cbte_apertura,
    cbte_aitb,
    temporal,
    vbregional,
    fecha_costo_ini,
    fecha_costo_fin,
    tipo_cambio_2,
    id_moneda_tri,
    sw_tipo_cambio,
    id_config_cambiaria,
    ope_1,
    ope_2,
    desc_moneda_tri,
    origen,
    localidad)
AS
  SELECT incbte.id_int_comprobante,
         incbte.id_clase_comprobante,
         incbte.id_subsistema,
         incbte.id_depto,
         incbte.id_moneda,
         incbte.id_periodo,
         incbte.id_funcionario_firma1,
         incbte.id_funcionario_firma2,
         incbte.id_funcionario_firma3,
         incbte.tipo_cambio,
         incbte.beneficiario,
         incbte.nro_cbte,
         incbte.estado_reg,
         incbte.glosa1,
         incbte.fecha,
         incbte.glosa2,
         incbte.nro_tramite,
         incbte.momento,
         incbte.id_usuario_reg,
         incbte.fecha_reg,
         incbte.id_usuario_mod,
         incbte.fecha_mod,
         usu1.cuenta AS usr_reg,
         usu2.cuenta AS usr_mod,
         ccbte.descripcion AS desc_clase_comprobante,
         sis.nombre AS desc_subsistema,
         (dpto.codigo::text || '-'::text) || dpto.nombre::text AS desc_depto,
         mon.codigo::text AS desc_moneda,
         fir1.desc_funcionario2 AS desc_firma1,
         fir2.desc_funcionario2 AS desc_firma2,
         fir3.desc_funcionario2 AS desc_firma3,
         pxp.f_iif(incbte.momento_comprometido::text = 'si'::text, 'true'::
           character varying, 'false'::character varying) AS
           momento_comprometido,
         pxp.f_iif(incbte.momento_ejecutado::text = 'si'::text, 'true'::
           character varying, 'false'::character varying) AS momento_ejecutado,
         pxp.f_iif(incbte.momento_pagado::text = 'si'::text, 'true'::character
           varying, 'false'::character varying) AS momento_pagado,
         incbte.manual,
         array_to_string(incbte.id_int_comprobante_fks, ','::text) AS
           id_int_comprobante_fks,
         incbte.id_tipo_relacion_comprobante,
         trc.nombre AS desc_tipo_relacion_comprobante,
         dpto.codigo AS codigo_depto,
         incbte.cbte_cierre,
         incbte.cbte_apertura,
         incbte.cbte_aitb,
         incbte.temporal,
         incbte.vbregional,
         incbte.fecha_costo_ini,
         incbte.fecha_costo_fin,
         incbte.tipo_cambio_2,
         incbte.id_moneda_tri,
         incbte.sw_tipo_cambio,
         incbte.id_config_cambiaria,
         ccam.ope_1,
         ccam.ope_2,
         mont.codigo::text AS desc_moneda_tri,
         incbte.origen,
         incbte.localidad
  FROM conta.tint_comprobante incbte
       JOIN segu.tusuario usu1 ON usu1.id_usuario = incbte.id_usuario_reg
       JOIN conta.tclase_comprobante ccbte ON ccbte.id_clase_comprobante =
         incbte.id_clase_comprobante
       JOIN segu.tsubsistema sis ON sis.id_subsistema = incbte.id_subsistema
       JOIN param.tdepto dpto ON dpto.id_depto = incbte.id_depto
       JOIN param.tmoneda mon ON mon.id_moneda = incbte.id_moneda
       JOIN param.tmoneda mont ON mont.id_moneda = incbte.id_moneda_tri
       JOIN conta.tconfig_cambiaria ccam ON ccam.id_config_cambiaria =
         incbte.id_config_cambiaria
       LEFT JOIN orga.vfuncionario fir1 ON fir1.id_funcionario =
         incbte.id_funcionario_firma1
       LEFT JOIN orga.vfuncionario fir2 ON fir2.id_funcionario =
         incbte.id_funcionario_firma2
       LEFT JOIN orga.vfuncionario fir3 ON fir3.id_funcionario =
         incbte.id_funcionario_firma3
       LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = incbte.id_usuario_mod
       LEFT JOIN conta.ttipo_relacion_comprobante trc ON
         trc.id_tipo_relacion_comprobante = incbte.id_tipo_relacion_comprobante;
/***********************************F-DEP-RAC-CONTA-0-03/11/2015****************************************/




/***********************************I-DEP-RAC-CONTA-0-30/11/2015****************************************/


CREATE OR REPLACE VIEW conta.vint_comprobante(
    id_int_comprobante,
    id_clase_comprobante,
    id_subsistema,
    id_depto,
    id_moneda,
    id_periodo,
    id_funcionario_firma1,
    id_funcionario_firma2,
    id_funcionario_firma3,
    tipo_cambio,
    beneficiario,
    nro_cbte,
    estado_reg,
    glosa1,
    fecha,
    glosa2,
    nro_tramite,
    momento,
    id_usuario_reg,
    fecha_reg,
    id_usuario_mod,
    fecha_mod,
    usr_reg,
    usr_mod,
    desc_clase_comprobante,
    desc_subsistema,
    desc_depto,
    desc_moneda,
    desc_firma1,
    desc_firma2,
    desc_firma3,
    momento_comprometido,
    momento_ejecutado,
    momento_pagado,
    manual,
    id_int_comprobante_fks,
    id_tipo_relacion_comprobante,
    desc_tipo_relacion_comprobante,
    codigo_depto,
    cbte_cierre,
    cbte_apertura,
    cbte_aitb,
    temporal,
    vbregional,
    fecha_costo_ini,
    fecha_costo_fin,
    tipo_cambio_2,
    id_moneda_tri,
    sw_tipo_cambio,
    id_config_cambiaria,
    ope_1,
    ope_2,
    desc_moneda_tri,
    origen,
    localidad,
    sw_editable)
AS
  SELECT incbte.id_int_comprobante,
         incbte.id_clase_comprobante,
         incbte.id_subsistema,
         incbte.id_depto,
         incbte.id_moneda,
         incbte.id_periodo,
         incbte.id_funcionario_firma1,
         incbte.id_funcionario_firma2,
         incbte.id_funcionario_firma3,
         incbte.tipo_cambio,
         incbte.beneficiario,
         incbte.nro_cbte,
         incbte.estado_reg,
         incbte.glosa1,
         incbte.fecha,
         incbte.glosa2,
         incbte.nro_tramite,
         incbte.momento,
         incbte.id_usuario_reg,
         incbte.fecha_reg,
         incbte.id_usuario_mod,
         incbte.fecha_mod,
         usu1.cuenta AS usr_reg,
         usu2.cuenta AS usr_mod,
         ccbte.descripcion AS desc_clase_comprobante,
         sis.nombre AS desc_subsistema,
         (dpto.codigo::text || '-'::text) || dpto.nombre::text AS desc_depto,
         mon.codigo::text AS desc_moneda,
         fir1.desc_funcionario2 AS desc_firma1,
         fir2.desc_funcionario2 AS desc_firma2,
         fir3.desc_funcionario2 AS desc_firma3,
         pxp.f_iif(incbte.momento_comprometido::text = 'si'::text, 'true'::
           character varying, 'false'::character varying) AS
           momento_comprometido,
         pxp.f_iif(incbte.momento_ejecutado::text = 'si'::text, 'true'::
           character varying, 'false'::character varying) AS momento_ejecutado,
         pxp.f_iif(incbte.momento_pagado::text = 'si'::text, 'true'::character
           varying, 'false'::character varying) AS momento_pagado,
         incbte.manual,
         array_to_string(incbte.id_int_comprobante_fks, ','::text) AS
           id_int_comprobante_fks,
         incbte.id_tipo_relacion_comprobante,
         trc.nombre AS desc_tipo_relacion_comprobante,
         dpto.codigo AS codigo_depto,
         incbte.cbte_cierre,
         incbte.cbte_apertura,
         incbte.cbte_aitb,
         incbte.temporal,
         incbte.vbregional,
         incbte.fecha_costo_ini,
         incbte.fecha_costo_fin,
         incbte.tipo_cambio_2,
         incbte.id_moneda_tri,
         incbte.sw_tipo_cambio,
         incbte.id_config_cambiaria,
         ccam.ope_1,
         ccam.ope_2,
         mont.codigo::text AS desc_moneda_tri,
         incbte.origen,
         incbte.localidad,
         incbte.sw_editable
  FROM conta.tint_comprobante incbte
       JOIN segu.tusuario usu1 ON usu1.id_usuario = incbte.id_usuario_reg
       JOIN conta.tclase_comprobante ccbte ON ccbte.id_clase_comprobante =
         incbte.id_clase_comprobante
       JOIN segu.tsubsistema sis ON sis.id_subsistema = incbte.id_subsistema
       JOIN param.tdepto dpto ON dpto.id_depto = incbte.id_depto
       JOIN param.tmoneda mon ON mon.id_moneda = incbte.id_moneda
       JOIN param.tmoneda mont ON mont.id_moneda = incbte.id_moneda_tri
       JOIN conta.tconfig_cambiaria ccam ON ccam.id_config_cambiaria =
         incbte.id_config_cambiaria
       LEFT JOIN orga.vfuncionario fir1 ON fir1.id_funcionario =
         incbte.id_funcionario_firma1
       LEFT JOIN orga.vfuncionario fir2 ON fir2.id_funcionario =
         incbte.id_funcionario_firma2
       LEFT JOIN orga.vfuncionario fir3 ON fir3.id_funcionario =
         incbte.id_funcionario_firma3
       LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = incbte.id_usuario_mod
       LEFT JOIN conta.ttipo_relacion_comprobante trc ON
         trc.id_tipo_relacion_comprobante = incbte.id_tipo_relacion_comprobante;

/***********************************F-DEP-RAC-CONTA-0-30/11/2015****************************************/



/***********************************I-DEP-RAC-CONTA-0-12/01/2016****************************************/

select pxp.f_insert_testructura_gui ('CONTA', 'SISTEMA');
select pxp.f_delete_testructura_gui ('CTA', 'CONTA');
select pxp.f_delete_testructura_gui ('AUXCTA', 'CONTA');
select pxp.f_delete_testructura_gui ('ODT', 'CONTA');
select pxp.f_delete_testructura_gui ('CTIP', 'CONTA');
select pxp.f_delete_testructura_gui ('CCBT', 'CONTA');
select pxp.f_insert_testructura_gui ('RELCON', 'DEFRECONCAR');
select pxp.f_delete_testructura_gui ('RELACON', 'CONTA');
select pxp.f_insert_testructura_gui ('PROVCUEN', 'RELACON');
select pxp.f_insert_testructura_gui ('DEFRECONCAR', 'CONTA');
select pxp.f_insert_testructura_gui ('RELCONGEN', 'RELACON');
select pxp.f_insert_testructura_gui ('CONGASCUE', 'RELACON');
select pxp.f_delete_testructura_gui ('CMPB', 'CONTA');
select pxp.f_insert_testructura_gui ('CMPB.1', 'CMPB');
select pxp.f_insert_testructura_gui ('RELCCCB', 'RELACON');
select pxp.f_insert_testructura_gui ('CBTE.1', 'CONTA');
select pxp.f_insert_testructura_gui ('CBTE.1.1', 'CBTE.1');
select pxp.f_insert_testructura_gui ('DEPTCON', 'RELACON');
select pxp.f_delete_testructura_gui ('PLADOC', 'DEFRECONCAR');
select pxp.f_delete_testructura_gui ('CONPER', 'CONTA');
select pxp.f_insert_testructura_gui ('CBTE.1.3', 'CONTA');
select pxp.f_insert_testructura_gui ('CBTE.1.3.1', 'CBTE.1.3');
select pxp.f_insert_testructura_gui ('ALMCUE', 'RELACON');
select pxp.f_insert_testructura_gui ('CLACUE', 'RELACON');
select pxp.f_delete_testructura_gui ('RERELCON', 'CONTA');
select pxp.f_insert_testructura_gui ('LIBMAY', 'CBTE.1.3');
select pxp.f_insert_testructura_gui ('LIBVEN', 'CBTE.1');
select pxp.f_insert_testructura_gui ('DOC', 'CBTE.1');
select pxp.f_insert_testructura_gui ('banca', 'CONTA');
select pxp.f_insert_testructura_gui ('CONFBA', 'banca');
select pxp.f_insert_testructura_gui ('BACO', 'banca');
select pxp.f_insert_testructura_gui ('BAVE', 'banca');
select pxp.f_insert_testructura_gui ('CNOM', 'CONTA');
select pxp.f_insert_testructura_gui ('CTIP', 'CNOM');
select pxp.f_insert_testructura_gui ('CTA', 'CNOM');
select pxp.f_insert_testructura_gui ('RERELCON', 'DEFRECONCAR');
select pxp.f_insert_testructura_gui ('AUXCTA', 'CNOM');
select pxp.f_delete_testructura_gui ('ODT', 'CNOM');
select pxp.f_delete_testructura_gui ('ODT', 'CTIP');
select pxp.f_delete_testructura_gui ('ODT', 'CNOM');
select pxp.f_delete_testructura_gui ('CBONF', 'CONTA');
select pxp.f_delete_testructura_gui ('CONPER', 'CBONF');
select pxp.f_delete_testructura_gui ('CMPB', 'CBONF');
select pxp.f_delete_testructura_gui ('CCBT', 'CBONF');
select pxp.f_delete_testructura_gui ('PLADOC', 'CBONF');
select pxp.f_insert_testructura_gui ('RELACON', 'DEFRECONCAR');
select pxp.f_insert_testructura_gui ('REPCON', 'CONTA');
select pxp.f_insert_testructura_gui ('BALCON', 'REPCON');
select pxp.f_insert_testructura_gui ('REPRES', 'REPCON');
select pxp.f_insert_testructura_gui ('BALGEN', 'REPCON');
select pxp.f_insert_testructura_gui ('CONF', 'CONTA');
select pxp.f_insert_testructura_gui ('PLANRES', 'CONF');
select pxp.f_insert_testructura_gui ('PCV', 'CONF');
select pxp.f_insert_testructura_gui ('TRECOM', 'CONF');
select pxp.f_insert_testructura_gui ('PLADOC', 'CONF');
select pxp.f_insert_testructura_gui ('CCBT', 'CONF');
select pxp.f_insert_testructura_gui ('CMPB', 'CONF');
select pxp.f_insert_testructura_gui ('CONPER', 'CONF');
select pxp.f_insert_testructura_gui ('CFCA', 'CONF');
select pxp.f_insert_testructura_gui ('ODT', 'CNOM');

/***********************************F-DEP-RAC-CONTA-0-12/01/2016****************************************/


/***********************************I-DEP-RAC-CONTA-0-12/02/2016****************************************/

--------------- SQL ---------------

CREATE OR REPLACE VIEW conta.vdoc_compra_venta_det(
    id_agrupador_doc,
    id_moneda,
    id_int_comprobante,
    id_plantilla,
    importe_doc,
    importe_excento,
    importe_total_excento,
    importe_descuento,
    importe_descuento_ley,
    importe_ice,
    importe_it,
    importe_iva,
    importe_pago_liquido,
    nro_documento,
    nro_dui,
    nro_autorizacion,
    razon_social,
    revisado,
    manual,
    obs,
    nit,
    fecha,
    codigo_control,
    sw_contabilizar,
    tipo,
    id_agrupador,
    id_doc_compra_venta,
    id_concepto_ingas,
    id_centro_costo,
    id_orden_trabajo,
    precio_total,
    id_doc_concepto,
    desc_ingas,
    descripcion)
AS
  SELECT ad.id_agrupador_doc,
         dcv.id_moneda,
         dcv.id_int_comprobante,
         dcv.id_plantilla,
         dcv.importe_doc,
         dcv.importe_excento,
         COALESCE(dcv.importe_excento, 0::numeric) + COALESCE(dcv.importe_ice, 0
           ::numeric) AS importe_total_excento,
         dcv.importe_descuento,
         dcv.importe_descuento_ley,
         dcv.importe_ice,
         dcv.importe_it,
         dcv.importe_iva,
         dcv.importe_pago_liquido,
         dcv.nro_documento,
         dcv.nro_dui,
         dcv.nro_autorizacion,
         dcv.razon_social,
         dcv.revisado,
         dcv.manual,
         dcv.obs,
         dcv.nit,
         dcv.fecha,
         dcv.codigo_control,
         dcv.sw_contabilizar,
         dcv.tipo,
         ad.id_agrupador,
         ad.id_doc_compra_venta,
         dco.id_concepto_ingas,
         dco.id_centro_costo,
         dco.id_orden_trabajo,
         dco.precio_total,
         dco.id_doc_concepto,
         cig.desc_ingas,
         (((((dcv.razon_social::text || ' - '::text) || cig.desc_ingas::text) ||
           ' ( '::text) || dco.descripcion) || ' ) Nro Doc: '::text) || COALESCE
           (dcv.nro_documento)::text AS descripcion,
         dcv.importe_neto,
         dcv.importe_anticipo,
         dcv.importe_pendiente,
         dcv.importe_retgar,
         dco.precio_total_final
  FROM conta.tagrupador_doc ad
       JOIN conta.tdoc_compra_venta dcv ON ad.id_doc_compra_venta =
         dcv.id_doc_compra_venta
       JOIN conta.tdoc_concepto dco ON dco.id_doc_compra_venta =
         dcv.id_doc_compra_venta
       JOIN param.tconcepto_ingas cig ON cig.id_concepto_ingas =
         dco.id_concepto_ingas;


CREATE OR REPLACE VIEW conta.vdoc_compra_venta(
    id_agrupador_doc,
    id_moneda,
    id_int_comprobante,
    id_plantilla,
    importe_doc,
    importe_excento,
    importe_total_excento,
    importe_descuento,
    importe_descuento_ley,
    importe_ice,
    importe_it,
    importe_iva,
    importe_pago_liquido,
    nro_documento,
    nro_dui,
    nro_autorizacion,
    razon_social,
    revisado,
    manual,
    obs,
    nit,
    fecha,
    codigo_control,
    sw_contabilizar,
    tipo,
    id_agrupador,
    id_doc_compra_venta,
    descripcion,
    importe_neto,
    importe_anticipo,
    importe_pendiente,
    importe_retgar,
    id_auxiliar)
AS
  SELECT ad.id_agrupador_doc,
         dcv.id_moneda,
         dcv.id_int_comprobante,
         dcv.id_plantilla,
         dcv.importe_doc,
         dcv.importe_excento,
         COALESCE(dcv.importe_excento, 0::numeric) + COALESCE(dcv.importe_ice, 0
           ::numeric) AS importe_total_excento,
         dcv.importe_descuento,
         dcv.importe_descuento_ley,
         dcv.importe_ice,
         dcv.importe_it,
         dcv.importe_iva,
         dcv.importe_pago_liquido,
         dcv.nro_documento,
         dcv.nro_dui,
         dcv.nro_autorizacion,
         dcv.razon_social,
         dcv.revisado,
         dcv.manual,
         dcv.obs,
         dcv.nit,
         dcv.fecha,
         dcv.codigo_control,
         dcv.sw_contabilizar,
         dcv.tipo,
         ad.id_agrupador,
         ad.id_doc_compra_venta,
         (((dcv.razon_social::text || ' - '::text) || ' ( '::text) ||
           ' ) Nro Doc: '::text) || COALESCE(dcv.nro_documento)::text AS
           descripcion,
         dcv.importe_neto,
         dcv.importe_anticipo,
         dcv.importe_pendiente,
         dcv.importe_retgar,
         dcv.id_auxiliar
  FROM conta.tagrupador_doc ad
       JOIN conta.tdoc_compra_venta dcv ON ad.id_doc_compra_venta =
         dcv.id_doc_compra_venta;
/***********************************F-DEP-RAC-CONTA-0-12/02/2016****************************************/


/***********************************I-DEP-RAC-CONTA-0-23/02/2016****************************************/


CREATE OR REPLACE VIEW conta.vlcv(
    id_doc_compra_venta,
    tipo,
    fecha,
    nit,
    razon_social,
    nro_documento,
    nro_dui,
    nro_autorizacion,
    importe_doc,
    total_excento,
    sujeto_cf,
    importe_descuento,
    subtotal,
    credito_fiscal,
    importe_iva,
    codigo_control,
    tipo_doc,
    id_plantilla,
    id_moneda,
    codigo_moneda,
    id_periodo,
    id_gestion,
    periodo,
    gestion,
    id_depto_conta,
    importe_ice,
    venta_gravada_cero,
    subtotal_venta,
    sujeto_df)
AS
  SELECT dcv.id_doc_compra_venta,
         dcv.tipo,
         dcv.fecha,
         dcv.nit,
         dcv.razon_social,
         dcv.nro_documento,
         pxp.f_iif(COALESCE(dcv.nro_dui, '0'::character varying)::text = ''::
           text, '0'::character varying, COALESCE(dcv.nro_dui, '0'::character
           varying)) AS nro_dui,
         dcv.nro_autorizacion,
         dcv.importe_doc,
         round(COALESCE(dcv.importe_ice, 0::numeric) + COALESCE(
           dcv.importe_excento, 0::numeric), 2) AS total_excento,
         round(COALESCE(dcv.importe_doc, 0::numeric) - COALESCE(dcv.importe_ice,
           0::numeric) - COALESCE(dcv.importe_excento, 0::numeric), 2) AS
           sujeto_cf,
         round(COALESCE(dcv.importe_descuento, 0.0), 2) AS importe_descuento,
         round(COALESCE(dcv.importe_doc, 0::numeric) - COALESCE(dcv.importe_ice,
           0::numeric) - COALESCE(dcv.importe_excento, 0::numeric) - COALESCE(
           dcv.importe_descuento, 0::numeric), 2) AS subtotal,
         round(0.13 *(COALESCE(dcv.importe_doc, 0::numeric) - COALESCE(
           dcv.importe_ice, 0::numeric) - COALESCE(dcv.importe_excento, 0::
           numeric) - COALESCE(dcv.importe_descuento, 0::numeric)), 2) AS
           credito_fiscal,
         round(COALESCE(dcv.importe_iva, 0::numeric), 2) AS importe_iva,
         dcv.codigo_control,
         tdcv.codigo AS tipo_doc,
         pla.id_plantilla,
         dcv.id_moneda,
         mon.codigo AS codigo_moneda,
         dcv.id_periodo,
         per.id_gestion,
         per.periodo,
         ges.gestion,
         dcv.id_depto_conta,
         round(COALESCE(dcv.importe_ice, 0::numeric), 2) AS importe_ice,
         0.00 AS venta_gravada_cero,
         round(COALESCE(dcv.importe_doc, 0::numeric) - COALESCE(dcv.importe_ice,
           0::numeric) - COALESCE(dcv.importe_excento, 0::numeric), 2) AS
           subtotal_venta,
         round(COALESCE(dcv.importe_doc, 0::numeric) - COALESCE(dcv.importe_ice,
           0::numeric) - COALESCE(dcv.importe_excento, 0::numeric) - COALESCE(
           dcv.importe_descuento, 0::numeric), 2) AS sujeto_df
  FROM conta.tdoc_compra_venta dcv
       JOIN param.tplantilla pla ON pla.id_plantilla = dcv.id_plantilla
       JOIN param.tperiodo per ON per.id_periodo = dcv.id_periodo
       JOIN param.tgestion ges ON ges.id_gestion = per.id_gestion
       JOIN param.tmoneda mon ON mon.id_moneda = dcv.id_moneda
       JOIN conta.ttipo_doc_compra_venta tdcv ON tdcv.id_tipo_doc_compra_venta =
         dcv.id_tipo_doc_compra_venta
  WHERE pla.tipo_informe::text = 'lcv'::text;
  
/***********************************F-DEP-RAC-CONTA-0-23/02/2016****************************************/



/***********************************I-DEP-RAC-CONTA-0-26/02/2016****************************************/


--------------- SQL ---------------

 -- object recreation
DROP VIEW conta.vlcv;

CREATE VIEW conta.vlcv
AS
  SELECT dcv.id_doc_compra_venta,
         dcv.tipo,
         dcv.fecha,
         dcv.nit,
         dcv.razon_social,
         dcv.nro_documento,
         pxp.f_iif(COALESCE(dcv.nro_dui, '0'::character varying)::text = ''::
           text, '0'::character varying, COALESCE(dcv.nro_dui, '0'::character
           varying)) AS nro_dui,
         dcv.nro_autorizacion,
         dcv.importe_doc,
         round(COALESCE(dcv.importe_ice, 0::numeric) + COALESCE(
           dcv.importe_excento, 0::numeric), 2) AS total_excento,
         round(COALESCE(dcv.importe_doc, 0::numeric) - COALESCE(dcv.importe_ice,
           0::numeric) - COALESCE(dcv.importe_excento, 0::numeric), 2) AS
           sujeto_cf,
         round(COALESCE(dcv.importe_descuento, 0.0), 2) AS importe_descuento,
         round(COALESCE(dcv.importe_doc, 0::numeric) - COALESCE(dcv.importe_ice,
           0::numeric) - COALESCE(dcv.importe_excento, 0::numeric) - COALESCE(
           dcv.importe_descuento, 0::numeric), 2) AS subtotal,
         round(0.13 *(COALESCE(dcv.importe_doc, 0::numeric) - COALESCE(
           dcv.importe_ice, 0::numeric) - COALESCE(dcv.importe_excento, 0::
           numeric) - COALESCE(dcv.importe_descuento, 0::numeric)), 2) AS
           credito_fiscal,
         round(COALESCE(dcv.importe_iva, 0::numeric), 2) AS importe_iva,
         dcv.codigo_control,
         tdcv.codigo AS tipo_doc,
         pla.id_plantilla,
         dcv.id_moneda,
         mon.codigo AS codigo_moneda,
         dcv.id_periodo,
         per.id_gestion,
         per.periodo,
         ges.gestion,
         dcv.id_depto_conta,
         round(COALESCE(dcv.importe_ice, 0::numeric), 2) AS importe_ice,
         0.00 AS venta_gravada_cero,
         round(COALESCE(dcv.importe_doc, 0::numeric) - COALESCE(dcv.importe_ice,
           0::numeric) - COALESCE(dcv.importe_excento, 0::numeric), 2) AS
           subtotal_venta,
         round(COALESCE(dcv.importe_doc, 0::numeric) - COALESCE(dcv.importe_ice,
           0::numeric) - COALESCE(dcv.importe_excento, 0::numeric) - COALESCE(
           dcv.importe_descuento, 0::numeric), 2) AS sujeto_df,
         round(COALESCE(dcv.importe_excento, 0::numeric), 2) AS importe_excento
  FROM conta.tdoc_compra_venta dcv
       JOIN param.tplantilla pla ON pla.id_plantilla = dcv.id_plantilla
       JOIN param.tperiodo per ON per.id_periodo = dcv.id_periodo
       JOIN param.tgestion ges ON ges.id_gestion = per.id_gestion
       JOIN param.tmoneda mon ON mon.id_moneda = dcv.id_moneda
       JOIN conta.ttipo_doc_compra_venta tdcv ON tdcv.id_tipo_doc_compra_venta =
         dcv.id_tipo_doc_compra_venta
  WHERE pla.tipo_informe::text = 'lcv'::text;
  

/***********************************F-DEP-RAC-CONTA-0-26/02/2016****************************************/


/***********************************I-DEP-RAC-CONTA-0-08/04/2016****************************************/


CREATE OR REPLACE VIEW conta.vint_comprobante (
    id_int_comprobante,
    id_clase_comprobante,
    id_subsistema,
    id_depto,
    id_moneda,
    id_periodo,
    id_funcionario_firma1,
    id_funcionario_firma2,
    id_funcionario_firma3,
    tipo_cambio,
    beneficiario,
    nro_cbte,
    estado_reg,
    glosa1,
    fecha,
    glosa2,
    nro_tramite,
    momento,
    id_usuario_reg,
    fecha_reg,
    id_usuario_mod,
    fecha_mod,
    usr_reg,
    usr_mod,
    desc_clase_comprobante,
    desc_subsistema,
    desc_depto,
    desc_moneda,
    desc_firma1,
    desc_firma2,
    desc_firma3,
    momento_comprometido,
    momento_ejecutado,
    momento_pagado,
    manual,
    id_int_comprobante_fks,
    id_tipo_relacion_comprobante,
    desc_tipo_relacion_comprobante,
    codigo_depto,
    cbte_cierre,
    cbte_apertura,
    cbte_aitb,
    temporal,
    vbregional,
    fecha_costo_ini,
    fecha_costo_fin,
    tipo_cambio_2,
    id_moneda_tri,
    sw_tipo_cambio,
    id_config_cambiaria,
    ope_1,
    ope_2,
    desc_moneda_tri,
    origen,
    localidad,
    sw_editable,
    cbte_reversion,
    volcado)
AS
 SELECT incbte.id_int_comprobante,
    incbte.id_clase_comprobante,
    incbte.id_subsistema,
    incbte.id_depto,
    incbte.id_moneda,
    incbte.id_periodo,
    incbte.id_funcionario_firma1,
    incbte.id_funcionario_firma2,
    incbte.id_funcionario_firma3,
    incbte.tipo_cambio,
    incbte.beneficiario,
    incbte.nro_cbte,
    incbte.estado_reg,
    incbte.glosa1,
    incbte.fecha,
    incbte.glosa2,
    incbte.nro_tramite,
    incbte.momento,
    incbte.id_usuario_reg,
    incbte.fecha_reg,
    incbte.id_usuario_mod,
    incbte.fecha_mod,
    usu1.cuenta AS usr_reg,
    usu2.cuenta AS usr_mod,
    ccbte.descripcion AS desc_clase_comprobante,
    sis.nombre AS desc_subsistema,
    (dpto.codigo::text || '-'::text) || dpto.nombre::text AS desc_depto,
    mon.codigo::text AS desc_moneda,
    fir1.desc_funcionario2 AS desc_firma1,
    fir2.desc_funcionario2 AS desc_firma2,
    fir3.desc_funcionario2 AS desc_firma3,
    pxp.f_iif(incbte.momento_comprometido::text = 'si'::text, 'true'::character varying, 'false'::character varying) AS momento_comprometido,
    pxp.f_iif(incbte.momento_ejecutado::text = 'si'::text, 'true'::character varying, 'false'::character varying) AS momento_ejecutado,
    pxp.f_iif(incbte.momento_pagado::text = 'si'::text, 'true'::character varying, 'false'::character varying) AS momento_pagado,
    incbte.manual,
    array_to_string(incbte.id_int_comprobante_fks, ','::text) AS id_int_comprobante_fks,
    incbte.id_tipo_relacion_comprobante,
    trc.nombre AS desc_tipo_relacion_comprobante,
    dpto.codigo AS codigo_depto,
    incbte.cbte_cierre,
    incbte.cbte_apertura,
    incbte.cbte_aitb,
    incbte.temporal,
    incbte.vbregional,
    incbte.fecha_costo_ini,
    incbte.fecha_costo_fin,
    incbte.tipo_cambio_2,
    incbte.id_moneda_tri,
    incbte.sw_tipo_cambio,
    incbte.id_config_cambiaria,
    ccam.ope_1,
    ccam.ope_2,
    mont.codigo::text AS desc_moneda_tri,
    incbte.origen,
    incbte.localidad,
    incbte.sw_editable,
    incbte.cbte_reversion,
    incbte.volcado
   FROM conta.tint_comprobante incbte
   JOIN segu.tusuario usu1 ON usu1.id_usuario = incbte.id_usuario_reg
   JOIN conta.tclase_comprobante ccbte ON ccbte.id_clase_comprobante = incbte.id_clase_comprobante
   JOIN segu.tsubsistema sis ON sis.id_subsistema = incbte.id_subsistema
   JOIN param.tdepto dpto ON dpto.id_depto = incbte.id_depto
   JOIN param.tmoneda mon ON mon.id_moneda = incbte.id_moneda
   JOIN param.tmoneda mont ON mont.id_moneda = incbte.id_moneda_tri
   JOIN conta.tconfig_cambiaria ccam ON ccam.id_config_cambiaria = incbte.id_config_cambiaria
   LEFT JOIN orga.vfuncionario fir1 ON fir1.id_funcionario = incbte.id_funcionario_firma1
   LEFT JOIN orga.vfuncionario fir2 ON fir2.id_funcionario = incbte.id_funcionario_firma2
   LEFT JOIN orga.vfuncionario fir3 ON fir3.id_funcionario = incbte.id_funcionario_firma3
   LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = incbte.id_usuario_mod
   LEFT JOIN conta.ttipo_relacion_comprobante trc ON trc.id_tipo_relacion_comprobante = incbte.id_tipo_relacion_comprobante;


/***********************************F-DEP-RAC-CONTA-0-08/04/2016****************************************/


/***********************************I-DEP-RAC-CONTA-0-20/05/2016****************************************/


CREATE OR REPLACE VIEW conta.vdoc_compra_venta_det(
    id_agrupador_doc,
    id_moneda,
    id_int_comprobante,
    id_plantilla,
    importe_doc,
    importe_excento,
    importe_total_excento,
    importe_descuento,
    importe_descuento_ley,
    importe_ice,
    importe_it,
    importe_iva,
    importe_pago_liquido,
    nro_documento,
    nro_dui,
    nro_autorizacion,
    razon_social,
    revisado,
    manual,
    obs,
    nit,
    fecha,
    codigo_control,
    sw_contabilizar,
    tipo,
    id_agrupador,
    id_doc_compra_venta,
    id_concepto_ingas,
    id_centro_costo,
    id_orden_trabajo,
    precio_total,
    id_doc_concepto,
    desc_ingas,
    descripcion,
    importe_neto,
    importe_anticipo,
    importe_pendiente,
    importe_retgar,
    precio_total_final,
    porc_monto_excento_var)
AS
  SELECT ad.id_agrupador_doc,
         dcv.id_moneda,
         dcv.id_int_comprobante,
         dcv.id_plantilla,
         dcv.importe_doc,
         dcv.importe_excento,
         COALESCE(dcv.importe_excento, 0::numeric) + COALESCE(dcv.importe_ice, 0
           ::numeric) AS importe_total_excento,
         dcv.importe_descuento,
         dcv.importe_descuento_ley,
         dcv.importe_ice,
         dcv.importe_it,
         dcv.importe_iva,
         dcv.importe_pago_liquido,
         dcv.nro_documento,
         dcv.nro_dui,
         dcv.nro_autorizacion,
         dcv.razon_social,
         dcv.revisado,
         dcv.manual,
         dcv.obs,
         dcv.nit,
         dcv.fecha,
         dcv.codigo_control,
         dcv.sw_contabilizar,
         dcv.tipo,
         ad.id_agrupador,
         ad.id_doc_compra_venta,
         dco.id_concepto_ingas,
         dco.id_centro_costo,
         dco.id_orden_trabajo,
         dco.precio_total,
         dco.id_doc_concepto,
         cig.desc_ingas,
         (((((dcv.razon_social::text || ' - '::text) || cig.desc_ingas::text) ||
           ' ( '::text) || dco.descripcion) || ' ) Nro Doc: '::text) || COALESCE
           (dcv.nro_documento)::text AS descripcion,
         dcv.importe_neto,
         dcv.importe_anticipo,
         dcv.importe_pendiente,
         dcv.importe_retgar,
         dco.precio_total_final,
         (COALESCE(dcv.importe_excento, 0::numeric) + COALESCE(dcv.importe_ice,
           0::numeric)) / dcv.importe_neto AS porc_monto_excento_var
  FROM conta.tagrupador_doc ad
       JOIN conta.tdoc_compra_venta dcv ON ad.id_doc_compra_venta =
         dcv.id_doc_compra_venta
       JOIN conta.tdoc_concepto dco ON dco.id_doc_compra_venta =
         dcv.id_doc_compra_venta
       JOIN param.tconcepto_ingas cig ON cig.id_concepto_ingas =
         dco.id_concepto_ingas;

/***********************************F-DEP-RAC-CONTA-0-20/05/2016****************************************/


/***********************************I-DEP-RAC-CONTA-0-25/05/2016****************************************/

CREATE OR REPLACE VIEW conta.vint_comprobante(
    id_int_comprobante,
    id_clase_comprobante,
    id_subsistema,
    id_depto,
    id_moneda,
    id_periodo,
    id_funcionario_firma1,
    id_funcionario_firma2,
    id_funcionario_firma3,
    tipo_cambio,
    beneficiario,
    nro_cbte,
    estado_reg,
    glosa1,
    fecha,
    glosa2,
    nro_tramite,
    momento,
    id_usuario_reg,
    fecha_reg,
    id_usuario_mod,
    fecha_mod,
    usr_reg,
    usr_mod,
    desc_clase_comprobante,
    desc_subsistema,
    desc_depto,
    desc_moneda,
    desc_firma1,
    desc_firma2,
    desc_firma3,
    momento_comprometido,
    momento_ejecutado,
    momento_pagado,
    manual,
    id_int_comprobante_fks,
    id_tipo_relacion_comprobante,
    desc_tipo_relacion_comprobante,
    codigo_depto,
    cbte_cierre,
    cbte_apertura,
    cbte_aitb,
    temporal,
    vbregional,
    fecha_costo_ini,
    fecha_costo_fin,
    tipo_cambio_2,
    id_moneda_tri,
    sw_tipo_cambio,
    id_config_cambiaria,
    ope_1,
    ope_2,
    desc_moneda_tri,
    origen,
    localidad,
    sw_editable,
    cbte_reversion,
    volcado,
    id_proceso_wf,
    id_estado_wf)
AS
  SELECT incbte.id_int_comprobante,
         incbte.id_clase_comprobante,
         incbte.id_subsistema,
         incbte.id_depto,
         incbte.id_moneda,
         incbte.id_periodo,
         incbte.id_funcionario_firma1,
         incbte.id_funcionario_firma2,
         incbte.id_funcionario_firma3,
         incbte.tipo_cambio,
         incbte.beneficiario,
         incbte.nro_cbte,
         incbte.estado_reg,
         incbte.glosa1,
         incbte.fecha,
         incbte.glosa2,
         incbte.nro_tramite,
         incbte.momento,
         incbte.id_usuario_reg,
         incbte.fecha_reg,
         incbte.id_usuario_mod,
         incbte.fecha_mod,
         usu1.cuenta AS usr_reg,
         usu2.cuenta AS usr_mod,
         ccbte.descripcion AS desc_clase_comprobante,
         sis.nombre AS desc_subsistema,
         (dpto.codigo::text || '-'::text) || dpto.nombre::text AS desc_depto,
         mon.codigo::text AS desc_moneda,
         fir1.desc_funcionario2 AS desc_firma1,
         fir2.desc_funcionario2 AS desc_firma2,
         fir3.desc_funcionario2 AS desc_firma3,
         pxp.f_iif(incbte.momento_comprometido::text = 'si'::text, 'true'::
           character varying, 'false'::character varying) AS
           momento_comprometido,
         pxp.f_iif(incbte.momento_ejecutado::text = 'si'::text, 'true'::
           character varying, 'false'::character varying) AS momento_ejecutado,
         pxp.f_iif(incbte.momento_pagado::text = 'si'::text, 'true'::character
           varying, 'false'::character varying) AS momento_pagado,
         incbte.manual,
         array_to_string(incbte.id_int_comprobante_fks, ','::text) AS
           id_int_comprobante_fks,
         incbte.id_tipo_relacion_comprobante,
         trc.nombre AS desc_tipo_relacion_comprobante,
         dpto.codigo AS codigo_depto,
         incbte.cbte_cierre,
         incbte.cbte_apertura,
         incbte.cbte_aitb,
         incbte.temporal,
         incbte.vbregional,
         incbte.fecha_costo_ini,
         incbte.fecha_costo_fin,
         incbte.tipo_cambio_2,
         incbte.id_moneda_tri,
         incbte.sw_tipo_cambio,
         incbte.id_config_cambiaria,
         ccam.ope_1,
         ccam.ope_2,
         mont.codigo::text AS desc_moneda_tri,
         incbte.origen,
         incbte.localidad,
         incbte.sw_editable,
         incbte.cbte_reversion,
         incbte.volcado,
         incbte.id_proceso_wf,
         incbte.id_estado_wf
  FROM conta.tint_comprobante incbte
       JOIN segu.tusuario usu1 ON usu1.id_usuario = incbte.id_usuario_reg
       JOIN conta.tclase_comprobante ccbte ON ccbte.id_clase_comprobante =
         incbte.id_clase_comprobante
       JOIN segu.tsubsistema sis ON sis.id_subsistema = incbte.id_subsistema
       JOIN param.tdepto dpto ON dpto.id_depto = incbte.id_depto
       JOIN param.tmoneda mon ON mon.id_moneda = incbte.id_moneda
       JOIN param.tmoneda mont ON mont.id_moneda = incbte.id_moneda_tri
       JOIN conta.tconfig_cambiaria ccam ON ccam.id_config_cambiaria =
         incbte.id_config_cambiaria
       LEFT JOIN orga.vfuncionario fir1 ON fir1.id_funcionario =
         incbte.id_funcionario_firma1
       LEFT JOIN orga.vfuncionario fir2 ON fir2.id_funcionario =
         incbte.id_funcionario_firma2
       LEFT JOIN orga.vfuncionario fir3 ON fir3.id_funcionario =
         incbte.id_funcionario_firma3
       LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = incbte.id_usuario_mod
       LEFT JOIN conta.ttipo_relacion_comprobante trc ON
         trc.id_tipo_relacion_comprobante = incbte.id_tipo_relacion_comprobante;

/***********************************F-DEP-RAC-CONTA-0-25/05/2016****************************************/

/**********************************I-DEP-RAC-CONTA-0-11/07/2016****************************************/

DROP VIEW conta.vint_rel_devengado;


CREATE OR REPLACE VIEW conta.vint_rel_devengado( 
    id_int_rel_devengado,
    id_int_transaccion_pag,
    id_int_transaccion_dev,
    monto_pago,
    id_partida_ejecucion_pag,
    monto_pago_mb,
    estado_reg,
    id_usuario_ai,
    fecha_reg,
    usuario_ai,
    id_usuario_reg,
    fecha_mod,
    id_usuario_mod,
    usr_reg,
    usr_mod,
    nro_cbte_dev,
    desc_cuenta_dev,
    desc_partida_dev,
    desc_centro_costo_dev,
    desc_orden_dev,
    importe_debe_dev,
    importe_haber_dev,
    desc_cuenta_pag,
    desc_partida_pag,
    desc_centro_costo_pag,
    desc_orden_pag,
    importe_debe_pag,
    importe_haber_pag,
    id_cuenta_dev,
    id_orden_trabajo_dev,
    id_auxiliar_dev,
    id_centro_costo_dev,
    id_cuenta_pag,
    id_orden_trabajo_pag,
    id_auxiliar_pag,
    id_centro_costo_pag,
    id_int_comprobante_pago,
    id_int_comprobante_dev,
    tipo_partida_dev,
    tipo_partida_pag,
    desc_auxiliar_dev,
    desc_auxiliar_pag)
AS
  SELECT rde.id_int_rel_devengado,
         rde.id_int_transaccion_pag,
         rde.id_int_transaccion_dev,
         rde.monto_pago,
         rde.id_partida_ejecucion_pag,
         rde.monto_pago_mb,
         rde.estado_reg,
         rde.id_usuario_ai,
         rde.fecha_reg,
         rde.usuario_ai,
         rde.id_usuario_reg,
         rde.fecha_mod,
         rde.id_usuario_mod,
         usu1.cuenta AS usr_reg,
         usu2.cuenta AS usr_mod,
         cd.nro_cbte AS nro_cbte_dev,
         td.desc_cuenta AS desc_cuenta_dev,
         td.desc_partida AS desc_partida_dev,
         td.desc_centro_costo AS desc_centro_costo_dev,
         td.desc_orden AS desc_orden_dev,
         td.importe_debe AS importe_debe_dev,
         td.importe_haber AS importe_haber_dev,
         tp.desc_cuenta AS desc_cuenta_pag,
         tp.desc_partida AS desc_partida_pag,
         tp.desc_centro_costo AS desc_centro_costo_pag,
         tp.desc_orden AS desc_orden_pag,
         tp.importe_debe AS importe_debe_pag,
         tp.importe_haber AS importe_haber_pag,
         td.id_cuenta AS id_cuenta_dev,
         td.id_orden_trabajo AS id_orden_trabajo_dev,
         td.id_auxiliar AS id_auxiliar_dev,
         td.id_centro_costo AS id_centro_costo_dev,
         tp.id_cuenta AS id_cuenta_pag,
         tp.id_orden_trabajo AS id_orden_trabajo_pag,
         tp.id_auxiliar AS id_auxiliar_pag,
         tp.id_centro_costo AS id_centro_costo_pag,
         tp.id_int_comprobante AS id_int_comprobante_pago,
         td.id_int_comprobante AS id_int_comprobante_dev,
         td.tipo_partida AS tipo_partida_dev,
         tp.tipo_partida AS tipo_partida_pag,
         td.desc_auxiliar AS desc_auxiliar_dev,
         tp.desc_auxiliar AS desc_auxiliar_pag
  FROM conta.tint_rel_devengado rde
       JOIN conta.vint_transaccion tp ON tp.id_int_transaccion =
         rde.id_int_transaccion_pag
       JOIN conta.vint_transaccion td ON td.id_int_transaccion =
         rde.id_int_transaccion_dev
       JOIN conta.tint_comprobante cd ON cd.id_int_comprobante =
         tp.id_int_comprobante
       JOIN segu.tusuario usu1 ON usu1.id_usuario = rde.id_usuario_reg
       LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = rde.id_usuario_mod;

/**********************************F-DEP-RAC-CONTA-0-11/07/2016****************************************/



/**********************************I-DEP-GSS-CONTA-0-18/08/2016****************************************/


 -- object recreation
DROP VIEW conta.vlcv;

CREATE VIEW conta.vlcv

AS

  SELECT dcv.id_doc_compra_venta,
         dcv.tipo,
         dcv.fecha,
         dcv.nit,
         dcv.razon_social,
         dcv.nro_documento,
         pxp.f_iif(COALESCE(dcv.nro_dui, '0' ::character varying) ::text = ''
           ::text, '0' ::character varying, COALESCE(dcv.nro_dui, '0'
           ::character varying)) AS nro_dui,
         dcv.nro_autorizacion,
         dcv.importe_doc,
         round(COALESCE(dcv.importe_ice, 0::numeric) + COALESCE(
           dcv.importe_excento, 0::numeric), 2) AS total_excento,
         round(COALESCE(dcv.importe_doc, 0::numeric) - COALESCE(dcv.importe_ice,
           0::numeric) - COALESCE(dcv.importe_excento, 0::numeric) - COALESCE(
           dcv.importe_descuento, 0::numeric), 2) AS sujeto_cf,
         round(COALESCE(dcv.importe_descuento, 0.0), 2) AS importe_descuento,
         round(COALESCE(dcv.importe_doc, 0::numeric) - COALESCE(dcv.importe_ice,
           0::numeric) - COALESCE(dcv.importe_excento, 0::numeric), 2) AS
           subtotal,
         round(0.13 *(COALESCE(dcv.importe_doc, 0::numeric) - COALESCE(
           dcv.importe_ice, 0::numeric) - COALESCE(dcv.importe_excento,
           0::numeric) - COALESCE(dcv.importe_descuento, 0::numeric)), 2) AS
           credito_fiscal,
         round(COALESCE(dcv.importe_iva, 0::numeric), 2) AS importe_iva,
         dcv.codigo_control,
         tdcv.codigo AS tipo_doc,
         pla.id_plantilla,
         pla.tipo_informe,
         dcv.id_moneda,
         mon.codigo AS codigo_moneda,
         dcv.id_periodo,
         per.id_gestion,
         per.periodo,
         ges.gestion,
         dcv.id_depto_conta,
         round(COALESCE(dcv.importe_ice, 0::numeric), 2) AS importe_ice,
         0.00 AS venta_gravada_cero,
         round(COALESCE(dcv.importe_doc, 0::numeric) - COALESCE(dcv.importe_ice,
           0::numeric) - COALESCE(dcv.importe_excento, 0::numeric), 2) AS
           subtotal_venta,
         round(COALESCE(dcv.importe_doc, 0::numeric) - COALESCE(dcv.importe_ice,
           0::numeric) - COALESCE(dcv.importe_excento, 0::numeric) - COALESCE(
           dcv.importe_descuento, 0::numeric), 2) AS sujeto_df,
         round(COALESCE(dcv.importe_excento, 0::numeric), 2) AS importe_excento
  FROM conta.tdoc_compra_venta dcv
       JOIN param.tplantilla pla ON pla.id_plantilla = dcv.id_plantilla
       JOIN param.tperiodo per ON per.id_periodo = dcv.id_periodo
       JOIN param.tgestion ges ON ges.id_gestion = per.id_gestion
       JOIN param.tmoneda mon ON mon.id_moneda = dcv.id_moneda
       JOIN conta.ttipo_doc_compra_venta tdcv ON tdcv.id_tipo_doc_compra_venta =
         dcv.id_tipo_doc_compra_venta
  WHERE pla.tipo_informe::text = 'lcv' ::text;


/**********************************F-DEP-GSS-CONTA-0-18/08/2016****************************************/



  
 
/**********************************I-DEP-RAC-CONTA-0-31/08/2016****************************************/

CREATE TRIGGER f_trig_int_transaccion_defore
  BEFORE INSERT 
  ON conta.tint_transaccion FOR EACH ROW 
  EXECUTE PROCEDURE conta.f_trig_int_transaccion_defore();


/**********************************F-DEP-RAC-CONTA-0-31/08/2016****************************************/




/**********************************I-DEP-RAC-CONTA-0-17/11/2016****************************************/


DROP VIEW conta.vint_comprobante;

CREATE VIEW conta.vint_comprobante
AS
  SELECT incbte.id_int_comprobante,
         incbte.id_clase_comprobante,
         incbte.id_subsistema,
         incbte.id_depto,
         incbte.id_moneda,
         incbte.id_periodo,
         incbte.id_funcionario_firma1,
         incbte.id_funcionario_firma2,
         incbte.id_funcionario_firma3,
         incbte.tipo_cambio,
         incbte.beneficiario,
         incbte.nro_cbte,
         incbte.estado_reg,
         incbte.glosa1,
         incbte.fecha,
         incbte.glosa2,
         incbte.nro_tramite,
         incbte.momento,
         incbte.id_usuario_reg,
         incbte.fecha_reg,
         incbte.id_usuario_mod,
         incbte.fecha_mod,
         usu1.cuenta AS usr_reg,
         usu2.cuenta AS usr_mod,
         ccbte.descripcion AS desc_clase_comprobante,
         sis.nombre AS desc_subsistema,
         (dpto.codigo::text || '-'::text) || dpto.nombre::text AS desc_depto,
         mon.codigo::text AS desc_moneda,
         fir1.desc_funcionario2 AS desc_firma1,
         fir2.desc_funcionario2 AS desc_firma2,
         fir3.desc_funcionario2 AS desc_firma3,
         pxp.f_iif(incbte.momento_comprometido::text = 'si'::text, 'true'::
           character varying, 'false'::character varying) AS
           momento_comprometido,
         pxp.f_iif(incbte.momento_ejecutado::text = 'si'::text, 'true'::
           character varying, 'false'::character varying) AS momento_ejecutado,
         pxp.f_iif(incbte.momento_pagado::text = 'si'::text, 'true'::character
           varying, 'false'::character varying) AS momento_pagado,
         incbte.manual,
         array_to_string(incbte.id_int_comprobante_fks, ','::text) AS
           id_int_comprobante_fks,
         incbte.id_tipo_relacion_comprobante,
         trc.nombre AS desc_tipo_relacion_comprobante,
         dpto.codigo AS codigo_depto,
         incbte.cbte_cierre,
         incbte.cbte_apertura,
         incbte.cbte_aitb,
         incbte.temporal,
         incbte.vbregional,
         incbte.fecha_costo_ini,
         incbte.fecha_costo_fin,
         incbte.tipo_cambio_2,
         incbte.id_moneda_tri,
         incbte.sw_tipo_cambio,
         incbte.id_config_cambiaria,
         ccam.ope_1,
         ccam.ope_2,
         mont.codigo::text AS desc_moneda_tri,
         incbte.origen,
         incbte.localidad,
         incbte.sw_editable,
         incbte.cbte_reversion,
         incbte.volcado,
         incbte.id_proceso_wf,
         incbte.id_estado_wf,
         incbte.fecha_c31,
         incbte.c31,
         per.id_gestion,
         per.periodo
  FROM conta.tint_comprobante incbte
       JOIN segu.tusuario usu1 ON usu1.id_usuario = incbte.id_usuario_reg
       JOIN param.tperiodo per ON per.id_periodo = incbte.id_periodo
       JOIN conta.tclase_comprobante ccbte ON ccbte.id_clase_comprobante =
         incbte.id_clase_comprobante
       JOIN segu.tsubsistema sis ON sis.id_subsistema = incbte.id_subsistema
       JOIN param.tdepto dpto ON dpto.id_depto = incbte.id_depto
       JOIN param.tmoneda mon ON mon.id_moneda = incbte.id_moneda
       JOIN param.tmoneda mont ON mont.id_moneda = incbte.id_moneda_tri
       JOIN conta.tconfig_cambiaria ccam ON ccam.id_config_cambiaria =
         incbte.id_config_cambiaria
       LEFT JOIN orga.vfuncionario fir1 ON fir1.id_funcionario =
         incbte.id_funcionario_firma1
       LEFT JOIN orga.vfuncionario fir2 ON fir2.id_funcionario =
         incbte.id_funcionario_firma2
       LEFT JOIN orga.vfuncionario fir3 ON fir3.id_funcionario =
         incbte.id_funcionario_firma3
       LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = incbte.id_usuario_mod
       LEFT JOIN conta.ttipo_relacion_comprobante trc ON
         trc.id_tipo_relacion_comprobante = incbte.id_tipo_relacion_comprobante;


/**********************************F-DEP-RAC-CONTA-0-17/11/2016****************************************/


/**********************************I-DEP-RAC-CONTA-0-21/11/2016****************************************/



--------------- SQL ---------------

ALTER TABLE conta.tint_comprobante
  ADD CONSTRAINT tint_comprobante_fk FOREIGN KEY (id_clase_comprobante)
    REFERENCES conta.tclase_comprobante(id_clase_comprobante)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    

--------------- SQL ---------------

CREATE UNIQUE INDEX ttipo_relacion_comprobante_idx ON conta.ttipo_relacion_comprobante
  USING btree (codigo);
  
  
--------------- SQL ---------------

ALTER TABLE conta.tint_comprobante
  ADD CONSTRAINT tint_comprobante_fk1 FOREIGN KEY (id_tipo_relacion_comprobante)
    REFERENCES conta.ttipo_relacion_comprobante(id_tipo_relacion_comprobante)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE; 



ALTER TABLE conta.tentrega
  ADD CONSTRAINT tentrega_fk FOREIGN KEY (id_tipo_relacion_comprobante)
    REFERENCES conta.ttipo_relacion_comprobante(id_tipo_relacion_comprobante)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    

/**********************************F-DEP-RAC-CONTA-0-21/11/2016****************************************/

 
/**********************************I-DEP-RAC-CONTA-0-23/11/2016****************************************/

       
    
CREATE VIEW conta.ventrega (
    id_entrega,
    estado,
    c31,
    id_depto_conta,
    fecha_c31,
    codigo,
    nombre_partida,
    importe_debe_mb,
    importe_haber_mb,
    importe_debe_mb_completo,
    importe_haber_mb_completo,
    importe_gasto_mb,
    importe_recurso_mb,
    factor_reversion,
    codigo_cc,
    codigo_categoria,
    codigo_cg,
    nombre_cg,
    beneficiario,
    glosa1,
    id_int_comprobante,
    id_int_comprobante_dev,
    id_cuenta_bancaria)
AS
SELECT ent.id_entrega,
            ent.estado,
            ent.c31,
            ent.id_depto_conta,
            ent.fecha_c31,
            par.codigo,
            par.nombre_partida,
            trd.importe_debe_mb,
            trd.importe_haber_mb,
                CASE
                    WHEN trd.factor_reversion > 0::numeric THEN
                        trd.importe_debe_mb / (1::numeric - trd.factor_reversion)
                    ELSE trd.importe_debe_mb
                END AS importe_debe_mb_completo,
                CASE
                    WHEN trd.factor_reversion > 0::numeric THEN
                        trd.importe_haber_mb / (1::numeric - trd.factor_reversion)
                    ELSE trd.importe_haber_mb
                END AS importe_haber_mb_completo,
            trd.importe_gasto_mb,
            trd.importe_recurso_mb,
            trd.factor_reversion,
            pr.codigo_cc,
            cp.codigo_categoria,
            cg.codigo AS codigo_cg,
            cg.nombre AS nombre_cg,
            cbt.beneficiario,
            cbt.glosa1,
            cbt.id_int_comprobante,
            trd.id_int_comprobante AS id_int_comprobante_dev,
            trp.id_cuenta_bancaria
FROM conta.tentrega ent
      JOIN conta.tentrega_det ed ON ed.id_entrega = ent.id_entrega
   JOIN conta.tint_comprobante cbt ON cbt.id_int_comprobante = ed.id_int_comprobante
   JOIN conta.tint_transaccion trp ON trp.id_int_comprobante = cbt.id_int_comprobante
   JOIN conta.tint_rel_devengado rel ON rel.id_int_transaccion_pag =
       trp.id_int_transaccion
   JOIN conta.tint_transaccion trd ON trd.id_int_transaccion =
       rel.id_int_transaccion_dev
   JOIN pre.tpartida par ON par.id_partida = trd.id_partida
   JOIN pre.vpresupuesto_cc pr ON pr.id_centro_costo = trd.id_centro_costo
   JOIN pre.vcategoria_programatica cp ON cp.id_categoria_programatica =
       pr.id_categoria_prog
   LEFT JOIN pre.tclase_gasto_partida cgp ON cgp.id_partida = par.id_partida
   LEFT JOIN pre.tclase_gasto cg ON cg.id_clase_gasto = cgp.id_clase_gasto
WHERE par.sw_movimiento::text = 'presupuestaria'::text
UNION
SELECT ent.id_entrega,
            ent.estado,
            ent.c31,
            ent.id_depto_conta,
            ent.fecha_c31,
            par.codigo,
            par.nombre_partida,
            trp.importe_debe_mb,
            trp.importe_haber_mb,
                CASE
                    WHEN trp.factor_reversion > 0::numeric THEN
                        trp.importe_debe_mb / (1::numeric - trp.factor_reversion)
                    ELSE trp.importe_debe_mb
                END AS importe_debe_mb_completo,
                CASE
                    WHEN trp.factor_reversion > 0::numeric THEN
                        trp.importe_haber_mb / (1::numeric - trp.factor_reversion)
                    ELSE trp.importe_haber_mb
                END AS importe_haber_mb_completo,
            trp.importe_gasto_mb,
            trp.importe_recurso_mb,
            trp.factor_reversion,
            pr.codigo_cc,
            cp.codigo_categoria,
            cg.codigo AS codigo_cg,
            cg.nombre AS nombre_cg,
            cbt.beneficiario,
            cbt.glosa1,
            cbt.id_int_comprobante,
            trp.id_int_comprobante AS id_int_comprobante_dev,
            trp.id_cuenta_bancaria
FROM conta.tentrega ent
      JOIN conta.tentrega_det ed ON ed.id_entrega = ent.id_entrega
   JOIN conta.tint_comprobante cbt ON cbt.id_int_comprobante = ed.id_int_comprobante
   JOIN conta.tint_transaccion trp ON trp.id_int_comprobante = cbt.id_int_comprobante
   JOIN pre.tpartida par ON par.id_partida = trp.id_partida
   JOIN pre.vpresupuesto_cc pr ON pr.id_centro_costo = trp.id_centro_costo
   JOIN pre.vcategoria_programatica cp ON cp.id_categoria_programatica =
       pr.id_categoria_prog
   LEFT JOIN pre.tclase_gasto_partida cgp ON cgp.id_partida = par.id_partida
   LEFT JOIN pre.tclase_gasto cg ON cg.id_clase_gasto = cgp.id_clase_gasto
WHERE par.sw_movimiento::text = 'presupuestaria'::text;

 /**********************************F-DEP-RAC-CONTA-0-23/11/2016****************************************/

    
/**********************************I-DEP-RAC-CONTA-0-29/11/2016****************************************/
  
  
DROP VIEW conta.vint_rel_devengado;

CREATE VIEW conta.vint_rel_devengado
AS
  SELECT rde.id_int_rel_devengado,
         rde.id_int_transaccion_pag,
         rde.id_int_transaccion_dev,
         rde.monto_pago,
         rde.id_partida_ejecucion_pag,
         rde.monto_pago_mb,
         rde.estado_reg,
         rde.id_usuario_ai,
         rde.fecha_reg,
         rde.usuario_ai,
         rde.id_usuario_reg,
         rde.fecha_mod,
         rde.id_usuario_mod,
         usu1.cuenta AS usr_reg,
         usu2.cuenta AS usr_mod,
         cd.nro_cbte AS nro_cbte_dev,
         td.desc_cuenta AS desc_cuenta_dev,
         td.desc_partida AS desc_partida_dev,
         td.desc_centro_costo AS desc_centro_costo_dev,
         td.desc_orden AS desc_orden_dev,
         td.importe_debe AS importe_debe_dev,
         td.importe_haber AS importe_haber_dev,
         tp.desc_cuenta AS desc_cuenta_pag,
         tp.desc_partida AS desc_partida_pag,
         tp.desc_centro_costo AS desc_centro_costo_pag,
         tp.desc_orden AS desc_orden_pag,
         tp.importe_debe AS importe_debe_pag,
         tp.importe_haber AS importe_haber_pag,
         td.id_cuenta AS id_cuenta_dev,
         td.id_orden_trabajo AS id_orden_trabajo_dev,
         td.id_auxiliar AS id_auxiliar_dev,
         td.id_centro_costo AS id_centro_costo_dev,
         tp.id_cuenta AS id_cuenta_pag,
         tp.id_orden_trabajo AS id_orden_trabajo_pag,
         tp.id_auxiliar AS id_auxiliar_pag,
         tp.id_centro_costo AS id_centro_costo_pag,
         tp.id_int_comprobante AS id_int_comprobante_pago,
         td.id_int_comprobante AS id_int_comprobante_dev,
         td.tipo_partida AS tipo_partida_dev,
         tp.tipo_partida AS tipo_partida_pag,
         td.desc_auxiliar AS desc_auxiliar_dev,
         tp.desc_auxiliar AS desc_auxiliar_pag,
         
         tp.importe_gasto AS importe_gasto_pag,
         tp.importe_recurso AS importe_recurso_pag,
         td.importe_gasto AS importe_gasto_dev,
         td.importe_recurso AS importe_recurso_dev
  FROM conta.tint_rel_devengado rde
       JOIN conta.vint_transaccion tp ON tp.id_int_transaccion =
         rde.id_int_transaccion_pag
       JOIN conta.vint_transaccion td ON td.id_int_transaccion =
         rde.id_int_transaccion_dev
       JOIN conta.tint_comprobante cd ON cd.id_int_comprobante =
         tp.id_int_comprobante
       JOIN segu.tusuario usu1 ON usu1.id_usuario = rde.id_usuario_reg
       LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = rde.id_usuario_mod;
    
/**********************************F-DEP-RAC-CONTA-0-29/11/2016****************************************/
  
  
  
/**********************************I-DEP-RAC-CONTA-0-01/12/2016****************************************/
   
  --------------- SQL ---------------

 -- object recreation
DROP VIEW conta.vint_comprobante;

CREATE VIEW conta.vint_comprobante
AS
  SELECT incbte.id_int_comprobante,
         incbte.id_clase_comprobante,
         incbte.id_subsistema,
         incbte.id_depto,
         incbte.id_moneda,
         incbte.id_periodo,
         incbte.id_funcionario_firma1,
         incbte.id_funcionario_firma2,
         incbte.id_funcionario_firma3,
         incbte.tipo_cambio,
         incbte.beneficiario,
         incbte.nro_cbte,
         incbte.estado_reg,
         incbte.glosa1,
         incbte.fecha,
         incbte.glosa2,
         incbte.nro_tramite,
         incbte.momento,
         incbte.id_usuario_reg,
         incbte.fecha_reg,
         incbte.id_usuario_mod,
         incbte.fecha_mod,
         usu1.cuenta AS usr_reg,
         usu2.cuenta AS usr_mod,
         ccbte.descripcion AS desc_clase_comprobante,
         sis.nombre AS desc_subsistema,
         (dpto.codigo::text || '-'::text) || dpto.nombre::text AS desc_depto,
         mon.codigo::text AS desc_moneda,
         fir1.desc_funcionario2 AS desc_firma1,
         fir2.desc_funcionario2 AS desc_firma2,
         fir3.desc_funcionario2 AS desc_firma3,
         pxp.f_iif(incbte.momento_comprometido::text = 'si'::text, 'true'::
           character varying, 'false'::character varying) AS
           momento_comprometido,
         pxp.f_iif(incbte.momento_ejecutado::text = 'si'::text, 'true'::
           character varying, 'false'::character varying) AS momento_ejecutado,
         pxp.f_iif(incbte.momento_pagado::text = 'si'::text, 'true'::character
           varying, 'false'::character varying) AS momento_pagado,
         incbte.manual,
         array_to_string(incbte.id_int_comprobante_fks, ','::text) AS
           id_int_comprobante_fks,
         incbte.id_tipo_relacion_comprobante,
         trc.nombre AS desc_tipo_relacion_comprobante,
         dpto.codigo AS codigo_depto,
         incbte.cbte_cierre,
         incbte.cbte_apertura,
         incbte.cbte_aitb,
         incbte.temporal,
         incbte.vbregional,
         incbte.fecha_costo_ini,
         incbte.fecha_costo_fin,
         incbte.tipo_cambio_2,
         incbte.id_moneda_tri,
         incbte.sw_tipo_cambio,
         incbte.id_config_cambiaria,
         ccam.ope_1,
         ccam.ope_2,
         mont.codigo::text AS desc_moneda_tri,
         incbte.origen,
         incbte.localidad,
         incbte.sw_editable,
         incbte.cbte_reversion,
         incbte.volcado,
         incbte.id_proceso_wf,
         incbte.id_estado_wf,
         incbte.fecha_c31,
         incbte.c31,
         per.id_gestion,
         per.periodo,
         incbte.forma_cambio
  FROM conta.tint_comprobante incbte
       JOIN segu.tusuario usu1 ON usu1.id_usuario = incbte.id_usuario_reg
       JOIN param.tperiodo per ON per.id_periodo = incbte.id_periodo
       JOIN conta.tclase_comprobante ccbte ON ccbte.id_clase_comprobante =
         incbte.id_clase_comprobante
       JOIN segu.tsubsistema sis ON sis.id_subsistema = incbte.id_subsistema
       JOIN param.tdepto dpto ON dpto.id_depto = incbte.id_depto
       JOIN param.tmoneda mon ON mon.id_moneda = incbte.id_moneda
       JOIN param.tmoneda mont ON mont.id_moneda = incbte.id_moneda_tri
       JOIN conta.tconfig_cambiaria ccam ON ccam.id_config_cambiaria =
         incbte.id_config_cambiaria
       LEFT JOIN orga.vfuncionario fir1 ON fir1.id_funcionario =
         incbte.id_funcionario_firma1
       LEFT JOIN orga.vfuncionario fir2 ON fir2.id_funcionario =
         incbte.id_funcionario_firma2
       LEFT JOIN orga.vfuncionario fir3 ON fir3.id_funcionario =
         incbte.id_funcionario_firma3
       LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = incbte.id_usuario_mod
       LEFT JOIN conta.ttipo_relacion_comprobante trc ON
         trc.id_tipo_relacion_comprobante = incbte.id_tipo_relacion_comprobante;

ALTER TABLE conta.vint_comprobante
  OWNER TO postgres;

  
/**********************************F-DEP-RAC-CONTA-0-01/12/2016****************************************/
  
  

/**********************************I-DEP-RAC-CONTA-0-22/12/2016****************************************/
  
   
CREATE OR REPLACE VIEW conta.vlcv(
    id_doc_compra_venta,
    tipo,
    fecha,
    nit,
    razon_social,
    nro_documento,
    nro_dui,
    nro_autorizacion,
    importe_doc,
    total_excento,
    sujeto_cf,
    importe_descuento,
    subtotal,
    credito_fiscal,
    importe_iva,
    codigo_control,
    tipo_doc,
    id_plantilla,
    tipo_informe,
    id_moneda,
    codigo_moneda,
    id_periodo,
    id_gestion,
    periodo,
    gestion,
    id_depto_conta,
    importe_ice,
    venta_gravada_cero,
    subtotal_venta,
    sujeto_df,
    importe_excento,
    id_usuario_reg)
AS
  SELECT dcv.id_doc_compra_venta,
         dcv.tipo,
         dcv.fecha,
         dcv.nit,
         dcv.razon_social,
         dcv.nro_documento,
         pxp.f_iif(COALESCE(dcv.nro_dui, '0'::character varying)::text = ''::
           text, '0'::character varying, COALESCE(dcv.nro_dui, '0'::character
           varying)) AS nro_dui,
         dcv.nro_autorizacion,
         dcv.importe_doc,
         round(COALESCE(dcv.importe_excento, 0::numeric), 2) AS total_excento,
         round(COALESCE(dcv.importe_doc, 0::numeric) - COALESCE(
           dcv.importe_excento, 0::numeric) - COALESCE(dcv.importe_descuento, 0
           ::numeric), 2) AS sujeto_cf,
         round(COALESCE(dcv.importe_descuento, 0.0), 2) AS importe_descuento,
         round(COALESCE(dcv.importe_doc, 0::numeric) - COALESCE(
           dcv.importe_excento, 0::numeric), 2) AS subtotal,
         round(0.13 *(COALESCE(dcv.importe_doc, 0::numeric) - COALESCE(
           dcv.importe_excento, 0::numeric) - COALESCE(dcv.importe_descuento, 0
           ::numeric)), 2) AS credito_fiscal,
         round(COALESCE(dcv.importe_iva, 0::numeric), 2) AS importe_iva,
         dcv.codigo_control,
         tdcv.codigo AS tipo_doc,
         pla.id_plantilla,
         pla.tipo_informe,
         dcv.id_moneda,
         mon.codigo AS codigo_moneda,
         dcv.id_periodo,
         per.id_gestion,
         per.periodo,
         ges.gestion,
         dcv.id_depto_conta,
         round(COALESCE(dcv.importe_ice, 0::numeric), 2) AS importe_ice,
         0.00 AS venta_gravada_cero,
         round(COALESCE(dcv.importe_doc, 0::numeric) - COALESCE(dcv.importe_ice,
           0::numeric) - COALESCE(dcv.importe_excento, 0::numeric), 2) AS
           subtotal_venta,
         round(COALESCE(dcv.importe_doc, 0::numeric) - COALESCE(dcv.importe_ice,
           0::numeric) - COALESCE(dcv.importe_excento, 0::numeric) - COALESCE(
           dcv.importe_descuento, 0::numeric), 2) AS sujeto_df,
         round(COALESCE(dcv.importe_excento, 0::numeric), 2) AS importe_excento,
         dcv.id_usuario_reg
  FROM conta.tdoc_compra_venta dcv
       JOIN param.tplantilla pla ON pla.id_plantilla = dcv.id_plantilla
       JOIN param.tperiodo per ON per.id_periodo = dcv.id_periodo
       JOIN param.tgestion ges ON ges.id_gestion = per.id_gestion
       JOIN param.tmoneda mon ON mon.id_moneda = dcv.id_moneda
       JOIN conta.ttipo_doc_compra_venta tdcv ON tdcv.id_tipo_doc_compra_venta =
         dcv.id_tipo_doc_compra_venta
  WHERE pla.tipo_informe::text = 'lcv'::text;
  
    
/**********************************F-DEP-RAC-CONTA-0-22/12/2016****************************************/




/**********************************I-DEP-RAC-CONTA-0-12/01/2017****************************************/

ALTER TABLE conta.tfactura_airbp
  ADD CONSTRAINT fk_tfactura_airbp__id_doc_compra_venta FOREIGN KEY (id_doc_compra_venta)
    REFERENCES conta.tdoc_compra_venta(id_doc_compra_venta)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE conta.tfactura_airbp_concepto
  ADD CONSTRAINT fk_tfactura_airbp_concepto__id_factura_airbp FOREIGN KEY (id_factura_airbp)
    REFERENCES conta.tfactura_airbp(id_factura_airbp)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

/**********************************F-DEP-RAC-CONTA-0-12/01/2017****************************************/
    
    
/***********************************I-DEP-MMV-CONTA-0-27/01/2017****************************************/

CREATE VIEW conta.ventrega_depto as (
select
                            ent.id_entrega,
                            ent.fecha_c31,
                            ent.c31,
                            ent.estado,
                            ent.estado_reg,
                            ent.id_usuario_ai,
                            ent.usuario_ai,
                            ent.fecha_reg,
                            ent.id_usuario_reg,
                            ent.fecha_mod,
                            ent.id_usuario_mod,
                            ent.id_depto_conta,
                            ent.id_estado_wf,
                            ent.id_proceso_wf,
                            de.prioridad
						from conta.tentrega ent
                        inner join param.tdepto de on de.id_depto = ent.id_depto_conta);

/***********************************F-DEP-MMV-CONTA-0-27/01/2017****************************************/

 
/**********************************I-DEP-JRR-CONTA-0-02/05/2017****************************************/

ALTER TABLE orga.tcargo_centro_costo
  ADD CONSTRAINT fk_tcargo_centro_costo__id_ot FOREIGN KEY (id_ot)
    REFERENCES conta.torden_trabajo(id_orden_trabajo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE orga.tcargo_presupuesto
  ADD CONSTRAINT fk_tcargo_presupuesto__id_ot FOREIGN KEY (id_ot)
  REFERENCES conta.torden_trabajo(id_orden_trabajo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
 
/**********************************F-DEP-JRR-CONTA-0-02/05/2017****************************************/
   
/**********************************I-DEP-GSS-CONTA-0-10/05/2017****************************************/

 
ALTER TABLE conta.tgasto_sigep
  ADD CONSTRAINT fk_tgasto_sigep__id_archivo_sigep FOREIGN KEY (id_archivo_sigep)
    REFERENCES conta.tarchivo_sigep(id_archivo_sigep)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

/**********************************F-DEP-GSS-CONTA-0-10/05/2017****************************************/ 
 
  
    
/**********************************I-DEP-RAC-CONTA-0-12/05/2017****************************************/


CREATE OR REPLACE VIEW conta.vorden_trabajo(
    id_orden_trabajo,
    estado_reg,
    fecha_final,
    fecha_inicio,
    desc_orden,
    motivo_orden,
    fecha_reg,
    id_usuario_reg,
    id_usuario_mod,
    fecha_mod,
    usr_reg,
    usr_mod,
    id_grupo_ots,
    id_orden_trabajo_fk,
    tipo,
    movimiento,
    codigo,
    descripcion)
AS
  SELECT odt.id_orden_trabajo,
         odt.estado_reg,
         odt.fecha_final,
         odt.fecha_inicio,
         odt.desc_orden,
         odt.motivo_orden,
         odt.fecha_reg,
         odt.id_usuario_reg,
         odt.id_usuario_mod,
         odt.fecha_mod,
         usu1.cuenta AS usr_reg,
         usu2.cuenta AS usr_mod,
         pxp.aggarray(god.id_grupo_ot) AS id_grupo_ots,
         odt.id_orden_trabajo_fk,
         odt.tipo,
         odt.movimiento,
         odt.codigo,
         (COALESCE(odt.codigo, ''::character varying)::text || ' '::text) ||
           odt.desc_orden::text AS descripcion
  FROM conta.torden_trabajo odt
       JOIN segu.tusuario usu1 ON usu1.id_usuario = odt.id_usuario_reg
       LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = odt.id_usuario_mod
       LEFT JOIN conta.tgrupo_ot_det god ON god.id_orden_trabajo =
         odt.id_orden_trabajo AND god.estado_reg::text = 'activo'::text
  WHERE odt.estado_reg::text = 'activo'::text
  GROUP BY odt.id_orden_trabajo,
           odt.estado_reg,
           odt.fecha_final,
           odt.fecha_inicio,
           odt.desc_orden,
           odt.motivo_orden,
           odt.fecha_reg,
           odt.id_usuario_reg,
           odt.id_usuario_mod,
           odt.fecha_mod,
           usu1.cuenta,
           usu2.cuenta;
           
       
 --------------- SQL ---------------

ALTER TABLE conta.torden_trabajo
  ADD CONSTRAINT torden_trabajo_fk FOREIGN KEY (id_orden_trabajo_fk)
    REFERENCES conta.torden_trabajo(id_orden_trabajo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE; 
   
/**********************************F-DEP-RAC-CONTA-0-12/05/2017****************************************/



/**********************************I-DEP-RAC-CONTA-0-15/05/2017****************************************/

--------------- SQL ---------------

ALTER TABLE conta.tint_transaccion
  ADD CONSTRAINT tint_transaccion__id_suborden_fk FOREIGN KEY (id_suborden)
    REFERENCES conta.tsuborden(id_suborden)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
    
    --------------- SQL ---------------

ALTER TABLE conta.torden_suborden
  ADD CONSTRAINT torden_suborden__id_suborden_fk FOREIGN KEY (id_suborden)
    REFERENCES conta.tsuborden(id_suborden)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
    
--------------- SQL ---------------

ALTER TABLE conta.torden_suborden
  ADD CONSTRAINT torden_suborden__id_orden_trabajo_fk FOREIGN KEY (id_orden_trabajo)
    REFERENCES conta.torden_trabajo(id_orden_trabajo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
    
        


/**********************************F-DEP-RAC-CONTA-0-15/05/2017****************************************/



/**********************************I-DEP-RAC-CONTA-0-31/05/2017****************************************/


CREATE OR REPLACE VIEW conta.vorden_trabajo(
    id_orden_trabajo,
    estado_reg,
    fecha_final,
    fecha_inicio,
    desc_orden,
    motivo_orden,
    fecha_reg,
    id_usuario_reg,
    id_usuario_mod,
    fecha_mod,
    usr_reg,
    usr_mod,
    id_grupo_ots,
    id_orden_trabajo_fk,
    tipo,
    movimiento,
    codigo,
    descripcion,
    desc_otp)
AS
  SELECT odt.id_orden_trabajo,
         odt.estado_reg,
         odt.fecha_final,
         odt.fecha_inicio,
         odt.desc_orden,
         odt.motivo_orden,
         odt.fecha_reg,
         odt.id_usuario_reg,
         odt.id_usuario_mod,
         odt.fecha_mod,
         usu1.cuenta AS usr_reg,
         usu2.cuenta AS usr_mod,
         pxp.aggarray(god.id_grupo_ot) AS id_grupo_ots,
         odt.id_orden_trabajo_fk,
         odt.tipo,
         odt.movimiento,
         odt.codigo,
         (COALESCE(odt.codigo, ''::character varying)::text || ' '::text) ||
           odt.desc_orden::text AS descripcion,
         ((otp.codigo::text || ' '::text) || otp.desc_orden::text)::character
           varying AS desc_otp
  FROM conta.torden_trabajo odt
       JOIN segu.tusuario usu1 ON usu1.id_usuario = odt.id_usuario_reg
       LEFT JOIN conta.torden_trabajo otp ON otp.id_orden_trabajo =
         odt.id_orden_trabajo_fk
       LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = odt.id_usuario_mod
       LEFT JOIN conta.tgrupo_ot_det god ON god.id_orden_trabajo =
         odt.id_orden_trabajo AND god.estado_reg::text = 'activo'::text
  WHERE odt.estado_reg::text = 'activo'::text
  GROUP BY odt.id_orden_trabajo,
           odt.estado_reg,
           odt.fecha_final,
           odt.fecha_inicio,
           odt.desc_orden,
           odt.motivo_orden,
           odt.fecha_reg,
           odt.id_usuario_reg,
           odt.id_usuario_mod,
           odt.fecha_mod,
           usu1.cuenta,
           usu2.cuenta,
           otp.codigo,
           otp.desc_orden;


--------------- SQL ---------------

ALTER TABLE conta.ttipo_cc_ot
  ADD CONSTRAINT ttipo_cc_ot_fk FOREIGN KEY (id_tipo_cc)
    REFERENCES param.ttipo_cc(id_tipo_cc)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--------------- SQL ---------------

ALTER TABLE conta.ttipo_cc_ot
  ADD CONSTRAINT ttipo_cc_ot_fk1 FOREIGN KEY (id_orden_trabajo)
    REFERENCES conta.torden_trabajo(id_orden_trabajo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;    
    
/**********************************F-DEP-RAC-CONTA-0-31/05/2017****************************************/


/**********************************I-DEP-RAC-CONTA-0-05/06/2017****************************************/
CREATE OR REPLACE VIEW conta.vot_arb(
    ids,
    id_orden_trabajo,
    id_orden_trabajo_fk,
    desc_orden,
    codigo,
    movimiento)
AS
WITH RECURSIVE ordenes_costos(
    ids,
    id_orden_trabajo,
    id_orden_trabajo_fk,
    desc_orden,
    codigo,
    movimiento) AS(
  SELECT ARRAY [ c_1.id_orden_trabajo ] AS "array",
         c_1.id_orden_trabajo,
         c_1.id_orden_trabajo_fk,
         c_1.desc_orden,
         c_1.codigo,
         c_1.movimiento
  FROM conta.torden_trabajo c_1
  WHERE c_1.id_orden_trabajo_fk IS NULL AND
        c_1.estado_reg::text = 'activo'::text
  UNION
  SELECT pc.ids || c2.id_orden_trabajo,
         c2.id_orden_trabajo,
         c2.id_orden_trabajo_fk,
         c2.desc_orden,
         c2.codigo,
         c2.movimiento
  FROM conta.torden_trabajo c2,
       ordenes_costos pc
  WHERE c2.id_orden_trabajo_fk = pc.id_orden_trabajo AND
        c2.estado_reg::text = 'activo'::text)
      SELECT c.ids,
             c.id_orden_trabajo,
             c.id_orden_trabajo_fk,
             c.desc_orden,
             c.codigo,
             c.movimiento
      FROM ordenes_costos c;
      
/**********************************F-DEP-RAC-CONTA-0-05/06/2017****************************************/


/**********************************I-DEP-RAC-CONTA-0-09/06/2017****************************************/

CREATE OR REPLACE VIEW conta.ventrega(
    id_entrega,
    estado,
    c31,
    id_depto_conta,
    fecha_c31,
    codigo,
    nombre_partida,
    importe_debe_mb,
    importe_haber_mb,
    importe_debe_mb_completo,
    importe_haber_mb_completo,
    importe_gasto_mb,
    importe_recurso_mb,
    factor_reversion,
    codigo_cc,
    codigo_categoria,
    codigo_cg,
    nombre_cg,
    beneficiario,
    glosa1,
    id_int_comprobante,
    id_int_comprobante_dev,
    id_cuenta_bancaria)
AS
  SELECT ent.id_entrega,
         ent.estado,
         ent.c31,
         ent.id_depto_conta,
         ent.fecha_c31,
         par.codigo,
         par.nombre_partida,
         trd.importe_debe_mb,
         trd.importe_haber_mb,
         CASE
           WHEN trd.factor_reversion > 0::numeric THEN trd.importe_debe_mb /(1::
             numeric - trd.factor_reversion)
           ELSE trd.importe_debe_mb
         END AS importe_debe_mb_completo,
         CASE
           WHEN trd.factor_reversion > 0::numeric THEN trd.importe_haber_mb /(1
             ::numeric - trd.factor_reversion)
           ELSE trd.importe_haber_mb
         END AS importe_haber_mb_completo,
         trd.importe_gasto_mb,
         trd.importe_recurso_mb,
         trd.factor_reversion,
         pr.codigo_cc,
         cp.codigo_categoria,
         cg.codigo AS codigo_cg,
         cg.nombre AS nombre_cg,
         cbt.beneficiario,
         cbt.glosa1,
         cbt.id_int_comprobante,
         trd.id_int_comprobante AS id_int_comprobante_dev,
         NULL::integer AS id_cuenta_bancaria
  FROM conta.tentrega ent
       JOIN conta.tentrega_det ed ON ed.id_entrega = ent.id_entrega
       JOIN conta.tint_comprobante cbt ON cbt.id_int_comprobante =
         ed.id_int_comprobante
       JOIN conta.tint_comprobante c1 ON c1.id_int_comprobante = ANY (
         cbt.id_int_comprobante_fks)
       JOIN conta.ttipo_relacion_comprobante tip ON
         tip.id_tipo_relacion_comprobante = cbt.id_tipo_relacion_comprobante AND
         (tip.codigo::text = ANY (ARRAY [ 'PAGODEV'::text, 'AJUSTE'::text ]))
       JOIN conta.tint_transaccion trd ON trd.id_int_comprobante =
         c1.id_int_comprobante
       JOIN pre.tpartida par ON par.id_partida = trd.id_partida
       JOIN pre.vpresupuesto_cc pr ON pr.id_centro_costo = trd.id_centro_costo
       JOIN pre.vcategoria_programatica cp ON cp.id_categoria_programatica =
         pr.id_categoria_prog
       LEFT JOIN pre.tclase_gasto_partida cgp ON cgp.id_partida = par.id_partida
       LEFT JOIN pre.tclase_gasto cg ON cg.id_clase_gasto = cgp.id_clase_gasto
  WHERE par.sw_movimiento::text = 'presupuestaria'::text
  UNION ALL
  SELECT ent.id_entrega,
         ent.estado,
         ent.c31,
         ent.id_depto_conta,
         ent.fecha_c31,
         par.codigo,
         par.nombre_partida,
         trp.importe_debe_mb,
         trp.importe_haber_mb,
         CASE
           WHEN trp.factor_reversion > 0::numeric THEN trp.importe_debe_mb /(1::
             numeric - trp.factor_reversion)
           ELSE trp.importe_debe_mb
         END AS importe_debe_mb_completo,
         CASE
           WHEN trp.factor_reversion > 0::numeric THEN trp.importe_haber_mb /(1
             ::numeric - trp.factor_reversion)
           ELSE trp.importe_haber_mb
         END AS importe_haber_mb_completo,
         trp.importe_gasto_mb,
         trp.importe_recurso_mb,
         trp.factor_reversion,
         pr.codigo_cc,
         cp.codigo_categoria,
         cg.codigo AS codigo_cg,
         cg.nombre AS nombre_cg,
         cbt.beneficiario,
         cbt.glosa1,
         cbt.id_int_comprobante,
         trp.id_int_comprobante AS id_int_comprobante_dev,
         trp.id_cuenta_bancaria
  FROM conta.tentrega ent
       JOIN conta.tentrega_det ed ON ed.id_entrega = ent.id_entrega
       JOIN conta.tint_comprobante cbt ON cbt.id_int_comprobante =
         ed.id_int_comprobante
       JOIN conta.tint_transaccion trp ON trp.id_int_comprobante =
         cbt.id_int_comprobante
       JOIN pre.tpartida par ON par.id_partida = trp.id_partida
       JOIN pre.vpresupuesto_cc pr ON pr.id_centro_costo = trp.id_centro_costo
       JOIN pre.vcategoria_programatica cp ON cp.id_categoria_programatica =
         pr.id_categoria_prog
       LEFT JOIN pre.tclase_gasto_partida cgp ON cgp.id_partida = par.id_partida
       LEFT JOIN pre.tclase_gasto cg ON cg.id_clase_gasto = cgp.id_clase_gasto
  WHERE par.sw_movimiento::text = 'presupuestaria'::text;
  
/**********************************F-DEP-RAC-CONTA-0-09/06/2017****************************************/

/**********************************I-DEP-GSS-CONTA-0-04/07/2017****************************************/
DROP VIEW conta.ventrega;
CREATE OR REPLACE VIEW conta.ventrega (
    id_entrega,
    estado,
    c31,
    id_depto_conta,
    fecha_c31,
    codigo,
    nombre_partida,
    importe_debe_mb,
    importe_haber_mb,
    importe_debe_mb_completo,
    importe_haber_mb_completo,
    importe_gasto_mb,
    importe_recurso_mb,
    factor_reversion,
    codigo_cc,
    codigo_categoria,
    codigo_cg,
    nombre_cg,
    beneficiario,
    glosa1,
    id_int_comprobante,
    id_int_comprobante_dev)
AS
 SELECT ent.id_entrega,
    ent.estado,
    ent.c31,
    ent.id_depto_conta,
    ent.fecha_c31,
    par.codigo,
    par.nombre_partida,
    trd.importe_debe_mb,
    trd.importe_haber_mb,
        CASE
            WHEN trd.factor_reversion > 0::numeric THEN trd.importe_debe_mb / (1::numeric - trd.factor_reversion)
            ELSE trd.importe_debe_mb
        END AS importe_debe_mb_completo,
        CASE
            WHEN trd.factor_reversion > 0::numeric THEN trd.importe_haber_mb / (1::numeric - trd.factor_reversion)
            ELSE trd.importe_haber_mb
        END AS importe_haber_mb_completo,
    trd.importe_gasto_mb,
    trd.importe_recurso_mb,
    trd.factor_reversion,
    pr.codigo_cc,
    cp.codigo_categoria,
    cg.codigo AS codigo_cg,
    cg.nombre AS nombre_cg,
    cbt.beneficiario,
    cbt.glosa1,
    cbt.id_int_comprobante,
    trd.id_int_comprobante AS id_int_comprobante_dev
   FROM conta.tentrega ent
     JOIN conta.tentrega_det ed ON ed.id_entrega = ent.id_entrega
     JOIN conta.tint_comprobante cbt ON cbt.id_int_comprobante = ed.id_int_comprobante
     JOIN tes.tplan_pago pg ON pg.id_int_comprobante = cbt.id_int_comprobante
     JOIN tes.tplan_pago dev ON dev.id_plan_pago = pg.id_plan_pago_fk
     JOIN conta.tint_transaccion trd ON trd.id_int_comprobante = dev.id_int_comprobante
     JOIN pre.tpartida par ON par.id_partida = trd.id_partida
     JOIN pre.vpresupuesto_cc pr ON pr.id_centro_costo = trd.id_centro_costo
     JOIN pre.vcategoria_programatica cp ON cp.id_categoria_programatica = pr.id_categoria_prog
     LEFT JOIN pre.tclase_gasto_partida cgp ON cgp.id_partida = par.id_partida
     LEFT JOIN pre.tclase_gasto cg ON cg.id_clase_gasto = cgp.id_clase_gasto
  WHERE par.sw_movimiento::text = 'presupuestaria'::text
UNION ALL
 SELECT ent.id_entrega,
    ent.estado,
    ent.c31,
    ent.id_depto_conta,
    ent.fecha_c31,
    par.codigo,
    par.nombre_partida,
    trp.importe_debe_mb,
    trp.importe_haber_mb,
        CASE
            WHEN trp.factor_reversion > 0::numeric THEN trp.importe_debe_mb / (1::numeric - trp.factor_reversion)
            ELSE trp.importe_debe_mb
        END AS importe_debe_mb_completo,
        CASE
            WHEN trp.factor_reversion > 0::numeric THEN trp.importe_haber_mb / (1::numeric - trp.factor_reversion)
            ELSE trp.importe_haber_mb
        END AS importe_haber_mb_completo,
    trp.importe_gasto_mb,
    trp.importe_recurso_mb,
    trp.factor_reversion,
    pr.codigo_cc,
    cp.codigo_categoria,
    cg.codigo AS codigo_cg,
    cg.nombre AS nombre_cg,
    cbt.beneficiario,
    cbt.glosa1,
    cbt.id_int_comprobante,
    trp.id_int_comprobante AS id_int_comprobante_dev
   FROM conta.tentrega ent
     JOIN conta.tentrega_det ed ON ed.id_entrega = ent.id_entrega
     JOIN conta.tint_comprobante cbt ON cbt.id_int_comprobante = ed.id_int_comprobante
     JOIN conta.tint_transaccion trp ON trp.id_int_comprobante = cbt.id_int_comprobante
     JOIN pre.tpartida par ON par.id_partida = trp.id_partida
     JOIN pre.vpresupuesto_cc pr ON pr.id_centro_costo = trp.id_centro_costo
     JOIN pre.vcategoria_programatica cp ON cp.id_categoria_programatica = pr.id_categoria_prog
     LEFT JOIN pre.tclase_gasto_partida cgp ON cgp.id_partida = par.id_partida
     LEFT JOIN pre.tclase_gasto cg ON cg.id_clase_gasto = cgp.id_clase_gasto
  WHERE par.sw_movimiento::text = 'presupuestaria'::text;

/**********************************F-DEP-GSS-CONTA-0-04/07/2017****************************************/



/**********************************I-DEP-RAC-CONTA-0-10/07/2017****************************************/

 SELECT "int".importe_debe_mb,
         "int".importe_haber_mb,
         "int".importe_debe_mt,
         "int".importe_haber_mt,
         COALESCE(ot.id_orden_trabajo, 0) AS id_orden_trabajo,
         COALESCE(ot.codigo, 'S/O'::character varying) AS codigo_ot,
         COALESCE(ot.desc_orden, 'No tiene una orden asignada'::character
           varying) AS desc_orden,
         tcc.id_tipo_cc,
         tcc.ids,
         cbt.id_int_comprobante,
         par.codigo AS codigo_partida,
         "int".id_int_transaccion,
         "int".id_cuenta,
         "int".id_auxiliar,
         cbt.fecha,
         cbt.id_periodo,
         par.sw_movimiento,
         par.nombre_partida AS descripcion_partida,
         par.id_partida
  FROM conta.tint_transaccion "int"
       JOIN conta.tint_comprobante cbt ON cbt.id_int_comprobante =
         "int".id_int_comprobante
       JOIN param.tcentro_costo cc ON cc.id_centro_costo = "int".id_centro_costo
       JOIN param.vtipo_cc_raiz tcc ON tcc.id_tipo_cc = cc.id_tipo_cc
       LEFT JOIN conta.torden_trabajo ot ON "int".id_orden_trabajo =
         ot.id_orden_trabajo
       LEFT JOIN pre.tpartida par ON par.id_partida = "int".id_partida
  WHERE cbt.estado_reg::text = 'validado'::text;
/**********************************F-DEP-RAC-CONTA-0-10/07/2017****************************************/



/**********************************I-DEP-RAC-CONTA-0-11/07/2017****************************************/


    CREATE OR REPLACE VIEW conta.vint_comprobante 
    AS
  SELECT incbte.id_int_comprobante,
         incbte.id_clase_comprobante,
         incbte.id_subsistema,
         incbte.id_depto,
         incbte.id_moneda,
         incbte.id_periodo,
         incbte.id_funcionario_firma1,
         incbte.id_funcionario_firma2,
         incbte.id_funcionario_firma3,
         incbte.tipo_cambio,
         incbte.beneficiario,
         incbte.nro_cbte,
         incbte.estado_reg,
         incbte.glosa1,
         incbte.fecha,
         incbte.glosa2,
         incbte.nro_tramite,
         incbte.momento,
         incbte.id_usuario_reg,
         incbte.fecha_reg,
         incbte.id_usuario_mod,
         incbte.fecha_mod,
         usu1.cuenta AS usr_reg,
         usu2.cuenta AS usr_mod,
         ccbte.descripcion AS desc_clase_comprobante,
         sis.nombre AS desc_subsistema,
         (dpto.codigo::text || '-'::text) || dpto.nombre::text AS desc_depto,
         mon.codigo::text AS desc_moneda,
         fir1.desc_funcionario2 AS desc_firma1,
         fir2.desc_funcionario2 AS desc_firma2,
         fir3.desc_funcionario2 AS desc_firma3,
         pxp.f_iif(incbte.momento_comprometido::text = 'si'::text, 'true'::
           character varying, 'false'::character varying) AS
           momento_comprometido,
         pxp.f_iif(incbte.momento_ejecutado::text = 'si'::text, 'true'::
           character varying, 'false'::character varying) AS momento_ejecutado,
         pxp.f_iif(incbte.momento_pagado::text = 'si'::text, 'true'::character
           varying, 'false'::character varying) AS momento_pagado,
         incbte.manual,
         array_to_string(incbte.id_int_comprobante_fks, ','::text) AS
           id_int_comprobante_fks,
         incbte.id_tipo_relacion_comprobante,
         trc.nombre AS desc_tipo_relacion_comprobante,
         dpto.codigo AS codigo_depto,
         incbte.cbte_cierre,
         incbte.cbte_apertura,
         incbte.cbte_aitb,
         incbte.temporal,
         incbte.vbregional,
         incbte.fecha_costo_ini,
         incbte.fecha_costo_fin,
         incbte.tipo_cambio_2,
         incbte.id_moneda_tri,
         incbte.sw_tipo_cambio,
         incbte.id_config_cambiaria,
         ccam.ope_1,
         ccam.ope_2,
         mont.codigo::text AS desc_moneda_tri,
         incbte.origen,
         incbte.localidad,
         incbte.sw_editable,
         incbte.cbte_reversion,
         incbte.volcado,
         incbte.id_proceso_wf,
         incbte.id_estado_wf,
         incbte.fecha_c31,
         incbte.c31,
         per.id_gestion,
         per.periodo,
         incbte.forma_cambio,
         ccam.ope_3,
         incbte.id_moneda_act,
         incbte.tipo_cambio_3
  FROM conta.tint_comprobante incbte
       JOIN segu.tusuario usu1 ON usu1.id_usuario = incbte.id_usuario_reg
       JOIN param.tperiodo per ON per.id_periodo = incbte.id_periodo
       JOIN conta.tclase_comprobante ccbte ON ccbte.id_clase_comprobante =
         incbte.id_clase_comprobante
       JOIN segu.tsubsistema sis ON sis.id_subsistema = incbte.id_subsistema
       JOIN param.tdepto dpto ON dpto.id_depto = incbte.id_depto
       JOIN param.tmoneda mon ON mon.id_moneda = incbte.id_moneda
       JOIN param.tmoneda mont ON mont.id_moneda = incbte.id_moneda_tri
       JOIN param.tmoneda mona ON mona.id_moneda = incbte.id_moneda_act
       JOIN conta.tconfig_cambiaria ccam ON ccam.id_config_cambiaria =
         incbte.id_config_cambiaria
       LEFT JOIN orga.vfuncionario fir1 ON fir1.id_funcionario =
         incbte.id_funcionario_firma1
       LEFT JOIN orga.vfuncionario fir2 ON fir2.id_funcionario =
         incbte.id_funcionario_firma2
       LEFT JOIN orga.vfuncionario fir3 ON fir3.id_funcionario =
         incbte.id_funcionario_firma3
       LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = incbte.id_usuario_mod
       LEFT JOIN conta.ttipo_relacion_comprobante trc ON
         trc.id_tipo_relacion_comprobante = incbte.id_tipo_relacion_comprobante;

/**********************************F-DEP-RAC-CONTA-0-11/07/2017****************************************/



/**********************************I-DEP-RAC-CONTA-0-19/07/2017****************************************/



CREATE OR REPLACE VIEW conta.vint_transaccion_analisis
AS
  SELECT "int".importe_debe_mb,
         "int".importe_haber_mb,
         "int".importe_debe_mt,
         "int".importe_haber_mt,
         "int".importe_debe_ma,
         "int".importe_haber_ma,
         COALESCE(ot.id_orden_trabajo, 0) AS id_orden_trabajo,
         COALESCE(ot.codigo, 'S/O'::character varying) AS codigo_ot,
         COALESCE(ot.desc_orden, 'No tiene una orden asignada'::character
           varying) AS desc_orden,
         tcc.id_tipo_cc,
         tcc.ids,
         cbt.id_int_comprobante,
         par.codigo AS codigo_partida,
         "int".id_int_transaccion,
         "int".id_cuenta,
         "int".id_auxiliar,
         cbt.fecha,
         cbt.id_periodo,
         par.sw_movimiento,
         par.nombre_partida AS descripcion_partida,
         par.id_partida
  FROM conta.tint_transaccion "int"
       JOIN conta.tint_comprobante cbt ON cbt.id_int_comprobante =
         "int".id_int_comprobante
       JOIN param.tcentro_costo cc ON cc.id_centro_costo = "int".id_centro_costo
       JOIN param.vtipo_cc_raiz tcc ON tcc.id_tipo_cc = cc.id_tipo_cc
       LEFT JOIN conta.torden_trabajo ot ON "int".id_orden_trabajo =
         ot.id_orden_trabajo
       LEFT JOIN pre.tpartida par ON par.id_partida = "int".id_partida
 WHERE cbt.estado_reg = 'validado';
 
   



/**********************************F-DEP-RAC-CONTA-0-19/07/2017****************************************/



/**********************************I-DEP-RAC-CONTA-0-21/07/2017****************************************/



--------------- SQL ---------------

ALTER TABLE conta.tcuenta_auxiliar
  ADD CONSTRAINT tcuenta_auxiliar_fk FOREIGN KEY (id_auxiliar)
    REFERENCES conta.tauxiliar(id_auxiliar)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


/**********************************F-DEP-RAC-CONTA-0-21/07/2017****************************************/



/**********************************I-DEP-RAC-CONTA-0-29/08/2017****************************************/
--------------- SQL ---------------

CREATE OR REPLACE VIEW conta.vint_transaccion_analisis
AS
  SELECT "int".importe_debe_mb,
         "int".importe_haber_mb,
         "int".importe_debe_mt,
         "int".importe_haber_mt,
         "int".importe_debe_ma,
         "int".importe_haber_ma,
         COALESCE(ot.id_orden_trabajo, 0) AS id_orden_trabajo,
         COALESCE(ot.codigo, 'S/O'::character varying) AS codigo_ot,
         COALESCE(ot.desc_orden, 'No tiene una orden asignada'::character
           varying) AS desc_orden,
         tcc.id_tipo_cc,
         tcc.ids,
         cbt.id_int_comprobante,
         COALESCE(par.codigo, 'S/P'::varchar(30)) AS codigo_partida,
         "int".id_int_transaccion,
         "int".id_cuenta,
         "int".id_auxiliar,
         cbt.fecha,
         cbt.id_periodo,
         par.sw_movimiento,
         COALESCE(par.nombre_partida, 'No tiene una partida asignada'::character
           (1)::character varying(150)) AS descripcion_partida,
         COALESCE(par.id_partida, 0) AS id_partida,
         cue.nro_cuenta AS codigo_cuenta,
         cue.nombre_cuenta AS descripcion_cuenta,
         cue.tipo_cuenta
  FROM conta.tint_transaccion "int"
       JOIN conta.tint_comprobante cbt ON cbt.id_int_comprobante =
         "int".id_int_comprobante
       JOIN param.tcentro_costo cc ON cc.id_centro_costo = "int".id_centro_costo
       JOIN param.vtipo_cc_raiz tcc ON tcc.id_tipo_cc = cc.id_tipo_cc
       JOIN conta.tcuenta cue ON cue.id_cuenta = "int".id_cuenta
       LEFT JOIN conta.torden_trabajo ot ON "int".id_orden_trabajo =
         ot.id_orden_trabajo
       LEFT JOIN pre.tpartida par ON par.id_partida = "int".id_partida
  WHERE cbt.estado_reg::text = 'validado'::text;

/**********************************F-DEP-RAC-CONTA-0-29/08/2017****************************************/


/**********************************I-DEP-MANU-CONTA-0-25/09/2017****************************************/
select pxp.f_insert_testructura_gui ('REPRET', 'REPCON');
 
CREATE OR REPLACE VIEW conta.vretencion(
    id_doc_compra_venta,
    obs,
    tipo,
    fecha,
    nit,
    razon_social,
    nro_documento,
    nro_autorizacion,
    importe_doc,
    codigo_control,
    tipo_doc,
    id_plantilla,
    tipo_informe,
    id_moneda,
    codigo_moneda,
    id_periodo,
    id_gestion,
    periodo,
    gestion,
    id_depto_conta,
    id_usuario_reg,
    descripcion,
    importe_presupuesto,
    importe,
    importe_descuento_ley,
    desc_plantilla)
AS
  SELECT dcv.id_doc_compra_venta,
         dcv.obs,
         dcv.tipo,
         dcv.fecha,
         dcv.nit,
         dcv.razon_social,
         dcv.nro_documento,
         dcv.nro_autorizacion,
         dcv.importe_doc,
         dcv.codigo_control,
         tdcv.codigo AS tipo_doc,
         pla.id_plantilla,
         pla.tipo_informe,
         dcv.id_moneda,
         mon.codigo AS codigo_moneda,
         dcv.id_periodo,
         per.id_gestion,
         per.periodo,
         ges.gestion,
         dcv.id_depto_conta,
         dcv.id_usuario_reg,
         pc.descripcion,
         pc.importe_presupuesto,
         pc.importe,
         dcv.importe_descuento_ley,
         pla.desc_plantilla
  FROM conta.tdoc_compra_venta dcv
       JOIN param.tplantilla pla ON pla.id_plantilla = dcv.id_plantilla
       JOIN conta.tplantilla_calculo pc ON dcv.id_plantilla = pc.id_plantilla
       JOIN param.tperiodo per ON per.id_periodo = dcv.id_periodo
       JOIN param.tgestion ges ON ges.id_gestion = per.id_gestion
       JOIN param.tmoneda mon ON mon.id_moneda = dcv.id_moneda
       JOIN conta.ttipo_doc_compra_venta tdcv ON tdcv.id_tipo_doc_compra_venta =
         dcv.id_tipo_doc_compra_venta
  WHERE pla.tipo_informe::text = 'retenciones'::text and
        pc.descuento::text = 'si'::text;
/**********************************F-DEP-MANU-CONTA-0-25/09/2017****************************************/



/**********************************I-DEP-MANU-CONTA-0-18/10/2017****************************************/
CREATE OR REPLACE VIEW conta.vretencion (
    id_doc_compra_venta,
    obs,
    tipo,
    fecha,
    nit,
    razon_social,
    nro_documento,
    nro_autorizacion,
    importe_doc,
    codigo_control,
    tipo_doc,
    id_plantilla,
    tipo_informe,
    id_moneda,
    codigo_moneda,
    id_periodo,
    id_gestion,
    periodo,
    gestion,
    id_depto_conta,
    id_usuario_reg,
    descripcion,
    importe_presupuesto,
    importe,
    importe_descuento_ley,
    desc_plantilla,
    nro_tramite)
AS
 SELECT dcv.id_doc_compra_venta,
    dcv.obs,
    dcv.tipo,
    dcv.fecha,
    dcv.nit,
    dcv.razon_social,
    dcv.nro_documento,
    dcv.nro_autorizacion,
    dcv.importe_doc,
    dcv.codigo_control,
    tdcv.codigo AS tipo_doc,
    pla.id_plantilla,
    pla.tipo_informe,
    dcv.id_moneda,
    mon.codigo AS codigo_moneda,
    dcv.id_periodo,
    per.id_gestion,
    per.periodo,
    ges.gestion,
    dcv.id_depto_conta,
    dcv.id_usuario_reg,
    pc.descripcion,
    pc.importe_presupuesto,
    pc.importe,
    dcv.importe_descuento_ley,
    pla.desc_plantilla, 
    dcv.nro_tramite 
   FROM conta.tdoc_compra_venta dcv
     JOIN param.tplantilla pla ON pla.id_plantilla = dcv.id_plantilla
     JOIN conta.tplantilla_calculo pc ON dcv.id_plantilla = pc.id_plantilla
     JOIN param.tperiodo per ON per.id_periodo = dcv.id_periodo
     JOIN param.tgestion ges ON ges.id_gestion = per.id_gestion
     JOIN param.tmoneda mon ON mon.id_moneda = dcv.id_moneda
     JOIN conta.ttipo_doc_compra_venta tdcv ON tdcv.id_tipo_doc_compra_venta = dcv.id_tipo_doc_compra_venta
  WHERE pla.tipo_informe::text = 'retenciones'::text AND pc.descuento::text = 'si'::text;
/**********************************F-DEP-MANU-CONTA-0-18/10/2017****************************************/



/**********************************I-DEP-RAC-CONTA-0-29/01/2018****************************************/


--------------- SQL ---------------

CREATE VIEW conta.vdoc_compra_venta_proveedor 
AS 

SELECT ad.id_agrupador_doc,
         dcv.id_moneda,
         dcv.id_int_comprobante,
         dcv.id_plantilla,
         dcv.importe_doc,
         dcv.importe_excento,
         COALESCE(dcv.importe_excento, 0::numeric) + COALESCE(dcv.importe_ice, 0
           ::numeric) AS importe_total_excento,
         dcv.importe_descuento,
         dcv.importe_descuento_ley,
         dcv.importe_ice,
         dcv.importe_it,
         dcv.importe_iva,
         dcv.importe_pago_liquido,
         dcv.nro_documento,
         dcv.nro_dui,
         dcv.nro_autorizacion,
         dcv.razon_social,
         dcv.revisado,
         dcv.manual,
         dcv.obs,
         dcv.nit,
         dcv.fecha,
         dcv.codigo_control,
         dcv.sw_contabilizar,
         dcv.tipo,
         ad.id_agrupador,
         ad.id_doc_compra_venta,
         (((dcv.razon_social::text || ' - '::text) || ' ( '::text) ||
           ' ) Nro Doc: '::text) || COALESCE(dcv.nro_documento)::text AS
           descripcion,
         dcv.importe_neto,
         dcv.importe_anticipo,
         dcv.importe_pendiente,
         dcv.importe_retgar,
         dcv.id_auxiliar,
         pro.id_proveedor
  FROM conta.tagrupador_doc ad
  JOIN conta.tdoc_compra_venta dcv ON ad.id_doc_compra_venta =  dcv.id_doc_compra_venta
  LEFT  JOIN conta.tauxiliar aux on aux.id_auxiliar = dcv.id_auxiliar
       left JOIN param.tproveedor pro on pro.codigo = aux.codigo_auxiliar
 ;


/**********************************F-DEP-RAC-CONTA-0-29/01/2018****************************************/


/**********************************I-DEP-RAC-CONTA-0-03/02/2018****************************************/

CREATE TRIGGER tdoc_compra_venta_tr
  BEFORE UPDATE OR DELETE 
  ON conta.tdoc_compra_venta
  
FOR EACH ROW 
  EXECUTE PROCEDURE conta.f_trig_doc_compra_venta();
  
/**********************************F-DEP-RAC-CONTA-0-03/02/2018****************************************/

/**********************************I-DEP-RCM-CONTA-0-03/02/2018****************************************/  
ALTER TABLE conta.tdoc_concepto
  ADD CONSTRAINT fk_tdoc_concepto__id_doc_compra_venta FOREIGN KEY (id_doc_compra_venta)
    REFERENCES conta.tdoc_compra_venta(id_doc_compra_venta)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
/**********************************F-DEP-RCM-CONTA-0-03/02/2018****************************************/  


/**********************************I-DEP-MANU-CONTA-0-16/02/2018****************************************/  
CREATE OR REPLACE VIEW conta.vretencion (
    id_doc_compra_venta,
    obs,
    tipo,
    fecha,
    nit,
    razon_social,
    nro_documento,
    nro_autorizacion,
    importe_doc,
    codigo_control,
    tipo_doc,
    id_plantilla,
    tipo_informe,
    id_moneda,
    codigo_moneda,
    id_periodo,
    id_gestion,
    periodo,
    gestion,
    id_depto_conta,
    id_usuario_reg,
    descripcion,
    importe_presupuesto,
    importe,
    importe_descuento_ley,
    desc_plantilla,
    nro_tramite,
    id_int_comprobante,
    nro_cbte)
AS
SELECT dcv.id_doc_compra_venta,
    dcv.obs,
    dcv.tipo,
    dcv.fecha,
    dcv.nit,
    dcv.razon_social,
    dcv.nro_documento,
    dcv.nro_autorizacion,
    dcv.importe_doc,
    dcv.codigo_control,
    tdcv.codigo AS tipo_doc,
    pla.id_plantilla,
    pla.tipo_informe,
    dcv.id_moneda,
    mon.codigo AS codigo_moneda,
    dcv.id_periodo,
    per.id_gestion,
    per.periodo,
    ges.gestion,
    dcv.id_depto_conta,
    dcv.id_usuario_reg,
    pc.descripcion,
    pc.importe_presupuesto,
    pc.importe,
    dcv.importe_descuento_ley,
    pla.desc_plantilla,
    dcv.nro_tramite,
    dcv.id_int_comprobante,
    t.nro_cbte
FROM conta.tdoc_compra_venta dcv
     JOIN param.tplantilla pla ON pla.id_plantilla = dcv.id_plantilla
     JOIN conta.tplantilla_calculo pc ON dcv.id_plantilla = pc.id_plantilla
     JOIN param.tperiodo per ON per.id_periodo = dcv.id_periodo
     JOIN param.tgestion ges ON ges.id_gestion = per.id_gestion
     JOIN param.tmoneda mon ON mon.id_moneda = dcv.id_moneda
     JOIN conta.ttipo_doc_compra_venta tdcv ON tdcv.id_tipo_doc_compra_venta =
         dcv.id_tipo_doc_compra_venta
     JOIN conta.tint_comprobante t ON t.id_int_comprobante = dcv.id_int_comprobante
WHERE pla.tipo_informe::text = 'retenciones'::text AND pc.descuento::text = 'si'::text;
/**********************************F-DEP-MANU-CONTA-0-16/02/2018****************************************/ 


/**********************************I-DEP-MANU-CONTA-0-24/03/2018****************************************/ 



CREATE OR REPLACE VIEW conta.vlcv(
    id_doc_compra_venta,
    tipo,
    fecha,
    nit,
    razon_social,
    nro_documento,
    nro_dui,
    nro_autorizacion,
    importe_doc,
    total_excento,
    sujeto_cf,
    importe_descuento,
    subtotal,
    credito_fiscal,
    importe_iva,
    codigo_control,
    tipo_doc,
    id_plantilla,
    tipo_informe,
    id_moneda,
    codigo_moneda,
    id_periodo,
    id_gestion,
    periodo,
    gestion,
    id_depto_conta,
    importe_ice,
    venta_gravada_cero,
    subtotal_venta,
    sujeto_df,
    importe_excento,
    id_usuario_reg,
    nro_cbte,
    tipo_cambio,
    id_int_comprobante,
    id_usuario_comprobante,
    id_tipo_doc_compra_venta)
AS
  SELECT dcv.id_doc_compra_venta,
         dcv.tipo,
         dcv.fecha,
         dcv.nit,
         dcv.razon_social,
         dcv.nro_documento,
         pxp.f_iif(COALESCE(dcv.nro_dui, '0'::character varying)::text = ''::
           text, '0'::character varying, COALESCE(dcv.nro_dui, '0'::character
           varying)) AS nro_dui,
         dcv.nro_autorizacion,
         dcv.importe_doc,
         round(COALESCE(dcv.importe_excento, 0::numeric), 2) AS total_excento,
         round(COALESCE(dcv.importe_doc, 0::numeric) - COALESCE(
           dcv.importe_excento, 0::numeric) - COALESCE(dcv.importe_descuento, 0
           ::numeric), 2) AS sujeto_cf,
         round(COALESCE(dcv.importe_descuento, 0.0), 2) AS importe_descuento,
         round(COALESCE(dcv.importe_doc, 0::numeric) - COALESCE(
           dcv.importe_excento, 0::numeric), 2) AS subtotal,
         round(0.13 *(COALESCE(dcv.importe_doc, 0::numeric) - COALESCE(
           dcv.importe_excento, 0::numeric) - COALESCE(dcv.importe_descuento, 0
           ::numeric)), 2) AS credito_fiscal,
         round(COALESCE(dcv.importe_iva, 0::numeric), 2) AS importe_iva,
         dcv.codigo_control,
         tdcv.codigo AS tipo_doc,
         pla.id_plantilla,
         pla.tipo_informe,
         dcv.id_moneda,
         mon.codigo AS codigo_moneda,
         dcv.id_periodo,
         per.id_gestion,
         per.periodo,
         ges.gestion,
         dcv.id_depto_conta,
         round(COALESCE(dcv.importe_ice, 0::numeric), 2) AS importe_ice,
         0.00 AS venta_gravada_cero,
         round(COALESCE(dcv.importe_doc, 0::numeric) - COALESCE(dcv.importe_ice,
           0::numeric) - COALESCE(dcv.importe_excento, 0::numeric), 2) AS
           subtotal_venta,
         round(COALESCE(dcv.importe_doc, 0::numeric) - COALESCE(dcv.importe_ice,
           0::numeric) - COALESCE(dcv.importe_excento, 0::numeric) - COALESCE(
           dcv.importe_descuento, 0::numeric), 2) AS sujeto_df,
         round(COALESCE(dcv.importe_excento, 0::numeric), 2) AS importe_excento,
         dcv.id_usuario_reg,
         comp.nro_cbte,
         comp.tipo_cambio,
         comp.id_int_comprobante,
         comp.id_usuario_reg AS id_usuario_comprobante,
         tdcv.id_tipo_doc_compra_venta
  FROM conta.tdoc_compra_venta dcv
       JOIN param.tplantilla pla ON pla.id_plantilla = dcv.id_plantilla
       JOIN param.tperiodo per ON per.id_periodo = dcv.id_periodo
       JOIN param.tgestion ges ON ges.id_gestion = per.id_gestion
       JOIN param.tmoneda mon ON mon.id_moneda = dcv.id_moneda
       JOIN conta.ttipo_doc_compra_venta tdcv ON tdcv.id_tipo_doc_compra_venta =
         dcv.id_tipo_doc_compra_venta
       LEFT JOIN conta.tint_comprobante comp ON comp.id_int_comprobante =
         dcv.id_int_comprobante;
         
 
/**********************************F-DEP-MANU-CONTA-0-24/03/2018****************************************/ 



/**********************************I-DEP-RAC-CONTA-0-09/05/2018****************************************/ 



CREATE OR REPLACE VIEW conta.vdoc_compra_venta_proveedor(
    id_agrupador_doc,
    id_moneda,
    id_int_comprobante,
    id_plantilla,
    importe_doc,
    importe_excento,
    importe_total_excento,
    importe_descuento,
    importe_descuento_ley,
    importe_ice,
    importe_it,
    importe_iva,
    importe_pago_liquido,
    nro_documento,
    nro_dui,
    nro_autorizacion,
    razon_social,
    revisado,
    manual,
    obs,
    nit,
    fecha,
    codigo_control,
    sw_contabilizar,
    tipo,
    id_agrupador,
    id_doc_compra_venta,
    descripcion,
    importe_neto,
    importe_anticipo,
    importe_pendiente,
    importe_retgar,
    id_auxiliar,
    id_proveedor,
    codigo_aplicacion)
AS
  SELECT ad.id_agrupador_doc,
         dcv.id_moneda,
         dcv.id_int_comprobante,
         dcv.id_plantilla,
         dcv.importe_doc,
         dcv.importe_excento,
         COALESCE(dcv.importe_excento, 0::numeric) + COALESCE(dcv.importe_ice, 0
           ::numeric) AS importe_total_excento,
         dcv.importe_descuento,
         dcv.importe_descuento_ley,
         dcv.importe_ice,
         dcv.importe_it,
         dcv.importe_iva,
         dcv.importe_pago_liquido,
         dcv.nro_documento,
         dcv.nro_dui,
         dcv.nro_autorizacion,
         dcv.razon_social,
         dcv.revisado,
         dcv.manual,
         dcv.obs,
         dcv.nit,
         dcv.fecha,
         dcv.codigo_control,
         dcv.sw_contabilizar,
         dcv.tipo,
         ad.id_agrupador,
         ad.id_doc_compra_venta,
         (((dcv.razon_social::text || ' - '::text) || ' ( '::text) ||
           ' ) Nro Doc: '::text) || COALESCE(dcv.nro_documento)::text AS
           descripcion,
         dcv.importe_neto,
         dcv.importe_anticipo,
         dcv.importe_pendiente,
         dcv.importe_retgar,
         dcv.id_auxiliar,
         pro.id_proveedor,
         dcv.codigo_aplicacion
  FROM conta.tagrupador_doc ad
       JOIN conta.tdoc_compra_venta dcv ON ad.id_doc_compra_venta =
         dcv.id_doc_compra_venta
       LEFT JOIN conta.tauxiliar aux ON aux.id_auxiliar = dcv.id_auxiliar
       LEFT JOIN param.tproveedor pro ON pro.codigo::text = aux.codigo_auxiliar
         ::text;
         
         
 CREATE OR REPLACE VIEW conta.vcbte_raiz(
    id_int_comprobante,
    ids,
    nro_tramite,
    nro_cbte,
    estado_reg,
    id_estado_wf,
    fecha,
    id_periodo,
    id_clase_comprobante,
    beneficiario)
AS
WITH RECURSIVE cbte_raiz AS(
  SELECT ARRAY [ c_1.id_int_comprobante ] AS ids,
         c_1.id_int_comprobante,
         c_1.id_int_comprobante_fks,
         c_1.glosa1,
         c_1.nro_tramite,
         c_1.nro_cbte,
         c_1.id_proceso_wf,
         c_1.estado_reg,
         c_1.id_estado_wf
  FROM conta.tint_comprobante c_1
  WHERE c_1.id_int_comprobante_fks [ 1 ] IS NULL
  UNION
  SELECT pc.ids || c2.id_int_comprobante AS ids,
         c2.id_int_comprobante,
         c2.id_int_comprobante_fks,
         c2.glosa1,
         c2.nro_tramite,
         c2.nro_cbte,
         c2.id_proceso_wf,
         c2.estado_reg,
         c2.id_estado_wf
  FROM conta.tint_comprobante c2,
       cbte_raiz pc
  WHERE c2.id_int_comprobante_fks @> ARRAY [ pc.id_int_comprobante ])
      SELECT cl.id_int_comprobante,
             c.ids,
             c.nro_tramite,
             c.nro_cbte,
             c.estado_reg,
             c.id_estado_wf,
             cl.fecha,
             cl.id_periodo,
             cl.id_clase_comprobante,
             cl.beneficiario
      FROM cbte_raiz c
           JOIN conta.tint_comprobante cl ON cl.id_int_comprobante = c.ids [ 1 ]
             ;        


/**********************************F-DEP-RAC-CONTA-0-09/05/2018****************************************/ 


/**********************************I-DEP-RAC-CONTA-0-01/12/2018****************************************/ 
DROP VIEW conta.vretencion;
DROP VIEW conta.vlcv;
DROP VIEW conta.vint_transaccion_analisis;

CREATE OR REPLACE VIEW conta.v_doc_venta_det (
    nro_documento,
    nit,
    nro_autorizacion,
    importe_doc,
    razon_social,
    id_concepto_ingas,
    desc_ingas,
    id_partida,
    codgio_partida,
    nombre_partida,
    id_centro_costo,
    tipo_cc_codigo,
    descripcion,
    id_doc_compra_venta,
    id_int_comprobante,
    id_partida_ejecucion_doc)
AS
 SELECT cv.nro_documento,
    cv.nit,
    cv.nro_autorizacion,
    cv.importe_doc,
    cv.razon_social,
    dc.id_concepto_ingas,
    ci.desc_ingas,
    dc.id_partida,
    p.codigo AS codgio_partida,
    p.nombre_partida,
    dc.id_centro_costo,
    tc.codigo AS tipo_cc_codigo,
    tc.descripcion,
    cv.id_doc_compra_venta,
    cv.id_int_comprobante,
    dc.id_partida_ejecucion AS id_partida_ejecucion_doc
   FROM conta.tdoc_compra_venta cv
     JOIN conta.tdoc_concepto dc ON cv.id_doc_compra_venta = dc.id_doc_compra_venta
     JOIN pre.tpartida p ON dc.id_partida = p.id_partida
     JOIN param.tconcepto_ingas ci ON ci.id_concepto_ingas = dc.id_concepto_ingas
     JOIN param.tcentro_costo cc ON dc.id_centro_costo = cc.id_centro_costo
     JOIN param.ttipo_cc tc ON tc.id_tipo_cc = cc.id_tipo_cc
  WHERE cv.tipo::text = 'venta'::text
  ORDER BY cv.nro_documento;

CREATE OR REPLACE VIEW conta.vcbte_con_descuentos_ley (
    id_int_comprobante,
    fecha,
    id_moneda,
    estado_reg,
    descuentos_ley)
AS
 SELECT c.id_int_comprobante,
    c.fecha,
    c.id_moneda,
    c.estado_reg,
    sum(t.importe_haber) AS descuentos_ley
   FROM conta.tint_comprobante c
     JOIN conta.tint_transaccion t ON c.id_int_comprobante = t.id_int_comprobante
     JOIN conta.tcuenta cu ON cu.id_cuenta = t.id_cuenta
  WHERE cu.nro_cuenta::text = ANY (ARRAY['2.1.3.02.003.003'::character varying::text, '2.1.3.02.005.001'::character varying::text, '2.1.3.02.004.001'::character varying::text, '2.1.3.02.003.002'::character varying::text])
  GROUP BY c.id_int_comprobante, c.fecha, c.id_moneda, c.estado_reg;

CREATE OR REPLACE VIEW conta.vdoc_descuentos_verificacion (
    id_int_comprobante,
    id_moneda,
    list,
    importe_descuento_ley)
AS
 SELECT dcv.id_int_comprobante,
    dcv.id_moneda,
    pxp.list(dcv.id_doc_compra_venta::character varying::text) AS list,
    sum(dcv.importe_descuento_ley) AS importe_descuento_ley
   FROM conta.tdoc_compra_venta dcv
  GROUP BY dcv.id_int_comprobante, dcv.id_moneda;

CREATE OR REPLACE VIEW conta.vint_transaccion_analisis (
    importe_debe_mb,
    importe_haber_mb,
    importe_debe_mt,
    importe_haber_mt,
    importe_debe_ma,
    importe_haber_ma,
    id_orden_trabajo,
    codigo_ot,
    desc_orden,
    id_tipo_cc,
    ids,
    id_int_comprobante,
    codigo_partida,
    id_int_transaccion,
    id_cuenta,
    id_auxiliar,
    fecha,
    id_periodo,
    sw_movimiento,
    descripcion_partida,
    id_partida,
    codigo_cuenta,
    descripcion_cuenta,
    tipo_cuenta)
AS
 SELECT "int".importe_debe_mb,
    "int".importe_haber_mb,
    "int".importe_debe_mt,
    "int".importe_haber_mt,
    "int".importe_debe_ma,
    "int".importe_haber_ma,
    COALESCE(ot.id_orden_trabajo, 0) AS id_orden_trabajo,
    COALESCE(ot.codigo, 'S/O'::character varying) AS codigo_ot,
    COALESCE(ot.desc_orden, 'No tiene una orden asignada'::character varying) AS desc_orden,
    tcc.id_tipo_cc,
    tcc.ids,
    cbt.id_int_comprobante,
    COALESCE(par.codigo, 'S/P'::character varying) AS codigo_partida,
    "int".id_int_transaccion,
    "int".id_cuenta,
    "int".id_auxiliar,
    cbt.fecha,
    cbt.id_periodo,
    par.sw_movimiento,
    COALESCE(par.nombre_partida, 'No tiene una partida asignada'::character(1)::character varying) AS descripcion_partida,
    COALESCE(par.id_partida, 0) AS id_partida,
    cue.nro_cuenta AS codigo_cuenta,
    cue.nombre_cuenta AS descripcion_cuenta,
    cue.tipo_cuenta
   FROM conta.tint_transaccion "int"
     JOIN conta.tint_comprobante cbt ON cbt.id_int_comprobante = "int".id_int_comprobante
     JOIN param.tcentro_costo cc ON cc.id_centro_costo = "int".id_centro_costo
     JOIN param.vtipo_cc_raiz tcc ON tcc.id_tipo_cc = cc.id_tipo_cc
     JOIN conta.tcuenta cue ON cue.id_cuenta = "int".id_cuenta
     LEFT JOIN conta.torden_trabajo ot ON "int".id_orden_trabajo = ot.id_orden_trabajo
     LEFT JOIN pre.tpartida par ON par.id_partida = "int".id_partida
  WHERE cbt.estado_reg::text = 'validado'::text;

CREATE OR REPLACE VIEW conta.vlcv (
    id_doc_compra_venta,
    tipo,
    fecha,
    nit,
    razon_social,
    nro_documento,
    nro_dui,
    nro_autorizacion,
    importe_doc,
    total_excento,
    sujeto_cf,
    importe_descuento,
    subtotal,
    credito_fiscal,
    importe_iva,
    codigo_control,
    tipo_doc,
    id_plantilla,
    tipo_informe,
    id_moneda,
    codigo_moneda,
    id_periodo,
    id_gestion,
    periodo,
    gestion,
    id_depto_conta,
    importe_ice,
    venta_gravada_cero,
    subtotal_venta,
    sujeto_df,
    importe_excento,
    id_usuario_reg,
    nro_cbte,
    tipo_cambio,
    id_int_comprobante,
    id_usuario_comprobante,
    id_tipo_doc_compra_venta,
    nombre,
    volcado)
AS
 SELECT dcv.id_doc_compra_venta,
    dcv.tipo,
    dcv.fecha,
    dcv.nit,
    dcv.razon_social,
    dcv.nro_documento,
    pxp.f_iif(COALESCE(dcv.nro_dui, '0'::character varying)::text = ''::text, '0'::character varying, COALESCE(dcv.nro_dui, '0'::character varying)) AS nro_dui,
    dcv.nro_autorizacion,
    dcv.importe_doc,
    round(COALESCE(dcv.importe_excento, 0::numeric), 2) AS total_excento,
    round(COALESCE(dcv.importe_doc, 0::numeric) - COALESCE(dcv.importe_excento, 0::numeric) - COALESCE(dcv.importe_descuento, 0::numeric), 2) AS sujeto_cf,
    round(COALESCE(dcv.importe_descuento, 0.0), 2) AS importe_descuento,
    round(COALESCE(dcv.importe_doc, 0::numeric) - COALESCE(dcv.importe_excento, 0::numeric), 2) AS subtotal,
    round(0.13 * (COALESCE(dcv.importe_doc, 0::numeric) - COALESCE(dcv.importe_excento, 0::numeric) - COALESCE(dcv.importe_descuento, 0::numeric)), 2) AS credito_fiscal,
    round(COALESCE(dcv.importe_iva, 0::numeric), 2) AS importe_iva,
    dcv.codigo_control,
    tdcv.codigo AS tipo_doc,
    pla.id_plantilla,
    pla.tipo_informe,
    dcv.id_moneda,
    mon.codigo AS codigo_moneda,
    dcv.id_periodo,
    per.id_gestion,
    per.periodo,
    ges.gestion,
    dcv.id_depto_conta,
    round(COALESCE(dcv.importe_ice, 0::numeric), 2) AS importe_ice,
    0.00 AS venta_gravada_cero,
    round(COALESCE(dcv.importe_doc, 0::numeric) - COALESCE(dcv.importe_ice, 0::numeric) - COALESCE(dcv.importe_excento, 0::numeric), 2) AS subtotal_venta,
    round(COALESCE(dcv.importe_doc, 0::numeric) - COALESCE(dcv.importe_ice, 0::numeric) - COALESCE(dcv.importe_excento, 0::numeric) - COALESCE(dcv.importe_descuento, 0::numeric), 2) AS sujeto_df,
    round(COALESCE(dcv.importe_excento, 0::numeric), 2) AS importe_excento,
    dcv.id_usuario_reg,
    comp.nro_cbte,
        CASE
            WHEN mon.id_moneda = 1 THEN 1::numeric
            ELSE comp.tipo_cambio
        END AS tipo_cambio,
    comp.id_int_comprobante,
    comp.id_usuario_reg AS id_usuario_comprobante,
    tdcv.id_tipo_doc_compra_venta,
    tdcv.nombre,
    comp.volcado
   FROM conta.tdoc_compra_venta dcv
     JOIN param.tplantilla pla ON pla.id_plantilla = dcv.id_plantilla
     JOIN param.tperiodo per ON per.id_periodo = dcv.id_periodo
     JOIN param.tgestion ges ON ges.id_gestion = per.id_gestion
     JOIN param.tmoneda mon ON mon.id_moneda = dcv.id_moneda
     JOIN conta.ttipo_doc_compra_venta tdcv ON tdcv.id_tipo_doc_compra_venta = dcv.id_tipo_doc_compra_venta
     LEFT JOIN conta.tint_comprobante comp ON comp.id_int_comprobante = dcv.id_int_comprobante;

CREATE OR REPLACE VIEW conta.vlibro_bancos (
    id_int_comprobante,
    debe,
    haber,
    fecha,
    nro_comprobante,
    id_cuenta_bancaria)
AS
 SELECT lb.id_int_comprobante,
        CASE
            WHEN lb.importe_deposito = 0::numeric THEN NULL::text
            ELSE to_char(lb.importe_deposito, '999G999G999D99'::text)
        END AS debe,
        CASE
            WHEN lb.importe_cheque = 0::numeric AND lb.estado::text <> 'anulado'::text THEN NULL::text
            ELSE to_char(lb.importe_cheque, '999G999G999D99'::text)
        END AS haber,
    to_char(lb.fecha::timestamp with time zone, 'dd/mm/yyyy'::text) AS fecha,
    lb.nro_comprobante,
    lb.id_cuenta_bancaria
   FROM tes.tts_libro_bancos lb
     LEFT JOIN tes.tts_libro_bancos lbp ON lbp.id_libro_bancos = lb.id_libro_bancos_fk
     LEFT JOIN conta.tint_comprobante a ON a.id_int_comprobante = lb.id_int_comprobante
     JOIN tes.tcuenta_bancaria k ON k.id_cuenta_bancaria = lb.id_cuenta_bancaria
  WHERE
        CASE
            WHEN 'Todos'::text = 'Todos'::text THEN lb.estado::text = ANY (ARRAY['impreso'::character varying, 'entregado'::character varying, 'cobrado'::character varying, 'anulado'::character varying, 'reingresado'::character varying, 'depositado'::character varying, 'transferido'::character varying, 'sigep_swift'::character varying]::text[])
            WHEN 'Todos'::text = 'impreso y entregado'::text THEN lb.estado::text = ANY (ARRAY['impreso'::character varying, 'entregado'::character varying]::text[])
            ELSE lb.estado::text = 'Todos'::text
        END AND
        CASE
            WHEN 'Todos'::text = 'Todos'::text THEN lb.tipo::text = ANY (ARRAY['cheque'::character varying, 'deposito'::character varying, 'debito_automatico'::character varying, 'transferencia_carta'::character varying]::text[])
            WHEN 'Todos'::text = 'transferencia_interna'::text THEN lb.tipo::text = ANY (ARRAY['transf_interna_debe'::character varying, 'transf_interna_haber'::character varying]::text[])
            ELSE lb.tipo::text = 'Todos'::text
        END AND
        CASE
            WHEN 0 = 0 THEN 0 = 0
            ELSE lb.id_finalidad = 0
        END
  ORDER BY lb.fecha;

CREATE OR REPLACE VIEW conta.vlibro_compras (
    id_int_comprobante,
    credito_fiscal,
    id_periodo,
    nro_cbte,
    cuenta,
    id_moneda,
    tipo_cambio)
AS
 SELECT comp.id_int_comprobante,
        CASE
            WHEN dcv.id_moneda = 1 THEN sum(0.13 * (COALESCE(round(dcv.importe_doc, 2), 0::numeric) - COALESCE(round(dcv.importe_excento, 2), 0::numeric) - COALESCE(round(dcv.importe_descuento, 2), 0::numeric)))
            ELSE sum(0.13 * (COALESCE(round(dcv.importe_doc, 2), 0::numeric) - COALESCE(round(dcv.importe_excento, 2), 0::numeric) - COALESCE(round(dcv.importe_descuento, 2), 0::numeric))) * comp.tipo_cambio
        END AS credito_fiscal,
    dcv.id_periodo,
    comp.nro_cbte,
    usu.cuenta,
    dcv.id_moneda,
        CASE
            WHEN dcv.id_moneda = 1 THEN 1::numeric
            ELSE comp.tipo_cambio
        END AS tipo_cambio
   FROM conta.tdoc_compra_venta dcv
     JOIN conta.ttipo_doc_compra_venta tdcv ON tdcv.id_tipo_doc_compra_venta = dcv.id_tipo_doc_compra_venta
     JOIN param.tplantilla p ON p.id_plantilla = dcv.id_plantilla
     LEFT JOIN conta.tint_comprobante comp ON comp.id_int_comprobante = dcv.id_int_comprobante AND comp.nro_cbte IS NOT NULL
     LEFT JOIN segu.tusuario usu ON usu.id_usuario = comp.id_usuario_reg
  WHERE p.tipo_informe::text = 'lcv'::text AND dcv.tipo::text = 'compra'::text AND comp.nro_cbte IS NOT NULL
  GROUP BY comp.id_int_comprobante, dcv.id_periodo, comp.nro_cbte, usu.cuenta, comp.tipo_cambio, dcv.id_moneda;

CREATE OR REPLACE VIEW conta.vlibro_mayor_banco (
    id_int_comprobante,
    fecha,
    nro_cbte,
    importe_debe_mb,
    importe_haber_mb,
    glosa1,
    tipo_cambio,
    moneda,
    id_periodo,
    cbte_reversion,
    volcado,
    id_cuenta,
    id_gestion)
AS
 WITH RECURSIVE cbtrevertidos(id_int_comprobante, fecha, nro_cbte, importe_debe_mb, importe_haber_mb, glosa1, tipo_cambio, moneda, id_periodo, cbte_reversion, volcado, id_cuenta) AS (
         SELECT icbte_1.id_int_comprobante,
            icbte_1.fecha,
            icbte_1.nro_cbte,
            COALESCE(transa_1.importe_debe_mb, 0::numeric) AS importe_debe_mb,
            COALESCE(transa_1.importe_haber_mb, 0::numeric) AS importe_haber_mb,
            icbte_1.glosa1,
            icbte_1.tipo_cambio,
            m_1.moneda,
            per_1.id_periodo,
            icbte_1.cbte_reversion,
            icbte_1.volcado,
            cue_1.id_cuenta
           FROM conta.tint_transaccion transa_1
             JOIN conta.tint_comprobante icbte_1 ON icbte_1.id_int_comprobante = transa_1.id_int_comprobante AND icbte_1.cbte_reversion::text = 'si'::text
             JOIN param.tmoneda m_1 ON m_1.id_moneda = transa_1.id_moneda
             JOIN param.tperiodo per_1 ON per_1.id_periodo = icbte_1.id_periodo
             JOIN segu.tusuario usu1_1 ON usu1_1.id_usuario = transa_1.id_usuario_reg
             JOIN conta.tcuenta cue_1 ON cue_1.id_cuenta = transa_1.id_cuenta
          WHERE icbte_1.estado_reg::text = 'validado'::text
          ORDER BY icbte_1.id_int_comprobante, transa_1.fecha_reg
        )
 SELECT icbte.id_int_comprobante,
    icbte.fecha,
    icbte.nro_cbte,
    COALESCE(transa.importe_debe_mb, 0::numeric) - COALESCE(( SELECT rev.importe_haber_mb
           FROM cbtrevertidos rev
          WHERE rev.glosa1::text ~~ (('%'::text || icbte.nro_cbte::text) || '%'::text) AND rev.nro_cbte::text = icbte.nro_cbte::text), 0::numeric) AS importe_debe_mb,
    COALESCE(transa.importe_haber_mb, 0::numeric) - COALESCE(( SELECT rev.importe_debe_mb
           FROM cbtrevertidos rev
          WHERE rev.glosa1::text ~~ (('%'::text || icbte.nro_cbte::text) || '%'::text) AND rev.nro_cbte::text = icbte.nro_cbte::text), 0::numeric) AS importe_haber_mb,
    icbte.glosa1,
    icbte.tipo_cambio,
    m.moneda,
    per.id_periodo,
    icbte.cbte_reversion,
    icbte.volcado,
    transa.id_cuenta,
    per.id_gestion
   FROM conta.tint_transaccion transa
     JOIN conta.tint_comprobante icbte ON icbte.id_int_comprobante = transa.id_int_comprobante AND (icbte.volcado::text = 'si'::text OR icbte.volcado::text = 'no'::text)
     JOIN param.tmoneda m ON m.id_moneda = transa.id_moneda
     JOIN param.tperiodo per ON per.id_periodo = icbte.id_periodo
     JOIN segu.tusuario usu1 ON usu1.id_usuario = transa.id_usuario_reg
     JOIN conta.tcuenta cue ON cue.id_cuenta = transa.id_cuenta
  WHERE icbte.estado_reg::text = 'validado'::text AND 0 = 0 AND 0 = 0
  ORDER BY icbte.id_int_comprobante, transa.fecha_reg;

CREATE OR REPLACE VIEW conta.vlibro_mayor_iva_credito_fiscal (
    id_int_comprobante,
    importe_debe_mb,
    importe_haber_mb,
    nro_cbte,
    fecha,
    id_gestion,
    id_cuenta,
    id_periodo,
    cbte_reversion,
    volcado,
    glosa1,
    id_int_comprobante_fks)
AS
 WITH RECURSIVE cbtrevertidos(id_int_comprobante, importe_debe_mb, importe_haber_mb, nro_cbte, fecha, id_gestion, id_cuenta, id_periodo, cbte_reversion, volcado) AS (
         SELECT transa.id_int_comprobante,
            sum(COALESCE(round(transa.importe_debe_mb, 2), 0::numeric)) AS importe_debe_mb,
            sum(COALESCE(round(transa.importe_haber_mb, 2), 0::numeric)) AS importe_haber_mb,
            icbte.nro_cbte,
            icbte.fecha,
            per.id_gestion,
            transa.id_cuenta,
            per.id_periodo,
            icbte.cbte_reversion,
            icbte.volcado,
            icbte.glosa1,
            icbte.id_int_comprobante_fks
           FROM conta.tint_transaccion transa
             JOIN conta.tint_comprobante icbte ON icbte.id_int_comprobante = transa.id_int_comprobante AND icbte.glosa1::text !~~* '%LIQUIDACIÓN DE IMPUESTOS%'::text AND icbte.estado_reg::text = 'validado'::text AND icbte.cbte_reversion::text = 'si'::text
             JOIN param.tperiodo per ON per.id_periodo = icbte.id_periodo
             JOIN conta.tcuenta cue ON cue.id_cuenta = transa.id_cuenta
             JOIN conta.tconfig_subtipo_cuenta cst ON cst.id_config_subtipo_cuenta = cue.id_config_subtipo_cuenta AND cst.nombre::text = 'IVA-CF'::text
             JOIN conta.tauxiliar aux ON aux.id_auxiliar = transa.id_auxiliar
             JOIN param.tmoneda m ON m.id_moneda = transa.id_moneda
          GROUP BY transa.id_int_comprobante, icbte.nro_cbte, icbte.fecha, per.id_gestion, transa.id_cuenta, per.id_periodo, icbte.cbte_reversion, icbte.volcado, icbte.glosa1, icbte.id_int_comprobante_fks
        )
 SELECT transa.id_int_comprobante,
        CASE
            WHEN sum(COALESCE(round(transa.importe_debe_mb, 2), 0::numeric)) = COALESCE(( SELECT sum(rev.importe_haber_mb) AS sum
               FROM cbtrevertidos rev
              WHERE rev.glosa1::text ~~ (('%'::text || icbte.nro_cbte::text) || '%'::text) OR regexp_replace(regexp_replace(rev.id_int_comprobante_fks::character varying::text, '{'::text, ''::text), '}'::text, ''::text)::character varying::integer = icbte.id_int_comprobante), 0::numeric) THEN 0::numeric
            ELSE sum(COALESCE(round(transa.importe_debe_mb, 2), 0::numeric)) - COALESCE(( SELECT sum(rev.importe_haber_mb) AS sum
               FROM cbtrevertidos rev
              WHERE rev.glosa1::text ~~ (('%'::text || icbte.nro_cbte::text) || '%'::text) OR regexp_replace(regexp_replace(rev.id_int_comprobante_fks::character varying::text, '{'::text, ''::text), '}'::text, ''::text)::character varying::integer = icbte.id_int_comprobante), 0::numeric)
        END AS importe_debe_mb,
    sum(COALESCE(round(transa.importe_haber_mb, 2), 0::numeric)) - COALESCE(( SELECT sum(rev.importe_haber_mb) AS sum
           FROM cbtrevertidos rev
          WHERE rev.glosa1::text ~~ (('%'::text || icbte.nro_cbte::text) || '%'::text) OR regexp_replace(regexp_replace(rev.id_int_comprobante_fks::character varying::text, '{'::text, ''::text), '}'::text, ''::text)::character varying::integer = icbte.id_int_comprobante), 0::numeric) AS importe_haber_mb,
    icbte.nro_cbte,
    icbte.fecha,
    per.id_gestion,
    transa.id_cuenta,
    per.id_periodo,
    icbte.cbte_reversion,
    icbte.volcado,
    icbte.glosa1,
    icbte.id_int_comprobante_fks
   FROM conta.tint_transaccion transa
     JOIN conta.tint_comprobante icbte ON icbte.id_int_comprobante = transa.id_int_comprobante AND icbte.glosa1::text !~~* '%LIQUIDACIÓN DE IMPUESTOS%'::text AND icbte.estado_reg::text = 'validado'::text AND (icbte.volcado::text = 'si'::text OR icbte.volcado::text = 'no'::text) AND icbte.cbte_reversion::text = 'no'::text
     JOIN param.tperiodo per ON per.id_periodo = icbte.id_periodo
     JOIN conta.tcuenta cue ON cue.id_cuenta = transa.id_cuenta
     JOIN conta.tconfig_subtipo_cuenta cst ON cst.id_config_subtipo_cuenta = cue.id_config_subtipo_cuenta AND cst.nombre::text = 'IVA-CF'::text
     JOIN conta.tauxiliar aux ON aux.id_auxiliar = transa.id_auxiliar
     JOIN param.tmoneda m ON m.id_moneda = transa.id_moneda
     LEFT JOIN cbtrevertidos revert ON icbte.id_int_comprobante = revert.id_int_comprobante AND revert.importe_debe_mb > 0::numeric
  GROUP BY transa.id_int_comprobante, icbte.nro_cbte, icbte.fecha, per.id_gestion, transa.id_cuenta, per.id_periodo, icbte.cbte_reversion, icbte.volcado, icbte.glosa1, revert.id_int_comprobante, revert.importe_debe_mb, icbte.id_int_comprobante_fks, icbte.id_int_comprobante
 HAVING revert.importe_debe_mb <> 0::numeric OR revert.importe_debe_mb IS NULL
UNION
 SELECT revert.id_int_comprobante,
    sum(revert.importe_debe_mb) AS importe_debe_mb,
    sum(revert.importe_haber_mb) AS importe_haber_mb,
    revert.nro_cbte,
    revert.fecha,
    revert.id_gestion,
    revert.id_cuenta,
    revert.id_periodo,
    revert.cbte_reversion,
    revert.volcado,
    revert.glosa1,
    icbte.id_int_comprobante_fks
   FROM conta.tint_transaccion transa
     JOIN conta.tint_comprobante icbte ON icbte.id_int_comprobante = transa.id_int_comprobante AND icbte.glosa1::text !~~* '%LIQUIDACIÓN DE IMPUESTOS%'::text AND icbte.estado_reg::text = 'validado'::text AND (icbte.volcado::text = 'si'::text OR icbte.volcado::text = 'no'::text) AND icbte.cbte_reversion::text = 'no'::text
     JOIN param.tperiodo per ON per.id_periodo = icbte.id_periodo
     JOIN conta.tcuenta cue ON cue.id_cuenta = transa.id_cuenta
     JOIN conta.tauxiliar aux ON aux.id_auxiliar = transa.id_auxiliar
     JOIN param.tmoneda m ON m.id_moneda = transa.id_moneda
     RIGHT JOIN cbtrevertidos revert ON icbte.id_int_comprobante = revert.id_int_comprobante AND revert.importe_debe_mb > 0::numeric
  GROUP BY revert.id_int_comprobante, revert.importe_debe_mb, revert.nro_cbte, revert.fecha, revert.id_gestion, revert.id_cuenta, revert.id_periodo, revert.cbte_reversion, revert.volcado, revert.glosa1, icbte.id_int_comprobante_fks
 HAVING revert.importe_debe_mb <> 0::numeric OR revert.importe_debe_mb IS NULL;


CREATE OR REPLACE VIEW conta.vretencion (
    id_doc_compra_venta,
    obs,
    tipo,
    fecha,
    nit,
    razon_social,
    nro_documento,
    nro_autorizacion,
    importe_doc,
    codigo_control,
    tipo_doc,
    id_plantilla,
    tipo_informe,
    id_moneda,
    codigo_moneda,
    id_periodo,
    id_gestion,
    periodo,
    gestion,
    id_depto_conta,
    id_usuario_reg,
    descripcion,
    importe_presupuesto,
    importe,
    importe_descuento_ley,
    desc_plantilla,
    nro_tramite,
    id_int_comprobante,
    nro_cbte,
    tipo_cambio,
    usr_mod)
AS
 SELECT dcv.id_doc_compra_venta,
    dcv.obs,
    dcv.tipo,
    dcv.fecha,
    dcv.nit,
    dcv.razon_social,
    dcv.nro_documento,
    dcv.nro_autorizacion,
    dcv.importe_doc,
    dcv.codigo_control,
    tdcv.codigo AS tipo_doc,
    pla.id_plantilla,
    pla.tipo_informe,
    dcv.id_moneda,
    mon.codigo AS codigo_moneda,
    dcv.id_periodo,
    per.id_gestion,
    per.periodo,
    ges.gestion,
    dcv.id_depto_conta,
    dcv.id_usuario_reg,
    pc.descripcion,
    pc.importe_presupuesto,
    pc.importe,
    dcv.importe_descuento_ley,
    pla.desc_plantilla,
    dcv.nro_tramite,
    dcv.id_int_comprobante,
    t.nro_cbte,
    t.tipo_cambio,
    usu2.cuenta AS usr_mod
   FROM conta.tdoc_compra_venta dcv
     JOIN param.tplantilla pla ON pla.id_plantilla = dcv.id_plantilla
     JOIN conta.tplantilla_calculo pc ON dcv.id_plantilla = pc.id_plantilla
     JOIN param.tperiodo per ON per.id_periodo = dcv.id_periodo
     JOIN param.tgestion ges ON ges.id_gestion = per.id_gestion
     JOIN param.tmoneda mon ON mon.id_moneda = dcv.id_moneda
     JOIN conta.ttipo_doc_compra_venta tdcv ON tdcv.id_tipo_doc_compra_venta = dcv.id_tipo_doc_compra_venta
     JOIN conta.tint_comprobante t ON t.id_int_comprobante = dcv.id_int_comprobante
     LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = dcv.id_usuario_reg
  WHERE pla.tipo_informe::text = 'retenciones'::text AND pc.descuento::text = 'si'::text;






/**********************************F-DEP-RAC-CONTA-0-01/12/2018****************************************/ 




         


/**********************************I-DEP-CAP-CONTA-0-04/12/2018****************************************/

DROP VIEW conta.vint_transaccion_analisis;

CREATE OR REPLACE VIEW conta.vint_transaccion_analisis (
    importe_debe_mb,
    importe_haber_mb,
    importe_debe_mt,
    importe_haber_mt,
    importe_debe_ma,
    importe_haber_ma,
    id_orden_trabajo,
    codigo_ot,
    desc_orden,
    id_tipo_cc,
    ids,
    id_int_comprobante,
    codigo_partida,
    id_int_transaccion,
    id_cuenta,
    id_auxiliar,
    fecha,
    id_periodo,
    sw_movimiento,
    descripcion_partida,
    id_partida,
    codigo_cuenta,
    descripcion_cuenta,
    tipo_cuenta)
AS
 SELECT "int".importe_debe_mb,
    "int".importe_haber_mb,
    "int".importe_debe_mt,
    "int".importe_haber_mt,
    "int".importe_debe_ma,
    "int".importe_haber_ma,
    COALESCE(ot.id_orden_trabajo, 0) AS id_orden_trabajo,
    COALESCE(ot.codigo, 'S/O'::character varying) AS codigo_ot,
    COALESCE(ot.desc_orden, 'No tiene una orden asignada'::character varying) AS desc_orden,
    tcc.id_tipo_cc,
    tcc.ids,
    cbt.id_int_comprobante,
    COALESCE(par.codigo, 'S/P'::character varying) AS codigo_partida,
    "int".id_int_transaccion,
    "int".id_cuenta,
    "int".id_auxiliar,
    cbt.fecha,
    cbt.id_periodo,
    par.sw_movimiento,
    COALESCE(par.nombre_partida, 'No tiene una partida asignada'::character(1)::character varying) AS descripcion_partida,
    COALESCE(par.id_partida, 0) AS id_partida,
    cue.nro_cuenta AS codigo_cuenta,
    cue.nombre_cuenta AS descripcion_cuenta,
    cue.tipo_cuenta
   FROM conta.tint_transaccion "int"
     JOIN conta.tint_comprobante cbt ON cbt.id_int_comprobante = "int".id_int_comprobante
     JOIN param.tcentro_costo cc ON cc.id_centro_costo = "int".id_centro_costo
     JOIN param.vtipo_cc_raiz tcc ON tcc.id_tipo_cc = cc.id_tipo_cc
     JOIN conta.tcuenta cue ON cue.id_cuenta = "int".id_cuenta
     LEFT JOIN conta.torden_trabajo ot ON "int".id_orden_trabajo = ot.id_orden_trabajo
     LEFT JOIN pre.tpartida par ON par.id_partida = "int".id_partida
  WHERE cbt.estado_reg::text = 'validado'::text;

  
DROP VIEW conta.vlibro_bancos;

CREATE OR REPLACE VIEW conta.vlibro_bancos (
    id_int_comprobante,
    debe,
    haber,
    fecha,
    nro_comprobante,
    id_cuenta_bancaria)
AS
 SELECT lb.id_int_comprobante,
        CASE
            WHEN lb.importe_deposito = 0::numeric THEN NULL::text
            ELSE to_char(lb.importe_deposito, '999G999G999D99'::text)
        END AS debe,
        CASE
            WHEN lb.importe_cheque = 0::numeric AND lb.estado::text <> 'anulado'::text THEN NULL::text
            ELSE to_char(lb.importe_cheque, '999G999G999D99'::text)
        END AS haber,
    to_char(lb.fecha::timestamp with time zone, 'dd/mm/yyyy'::text) AS fecha,
    lb.nro_comprobante,
    lb.id_cuenta_bancaria
   FROM tes.tts_libro_bancos lb
     LEFT JOIN tes.tts_libro_bancos lbp ON lbp.id_libro_bancos = lb.id_libro_bancos_fk
     LEFT JOIN conta.tint_comprobante a ON a.id_int_comprobante = lb.id_int_comprobante
     JOIN tes.tcuenta_bancaria k ON k.id_cuenta_bancaria = lb.id_cuenta_bancaria
  WHERE
        CASE
            WHEN 'Todos'::text = 'Todos'::text THEN lb.estado::text = ANY (ARRAY['impreso'::character varying, 'entregado'::character varying, 'cobrado'::character varying, 'anulado'::character varying, 'reingresado'::character varying, 'depositado'::character varying, 'transferido'::character varying, 'sigep_swift'::character varying]::text[])
            WHEN 'Todos'::text = 'impreso y entregado'::text THEN lb.estado::text = ANY (ARRAY['impreso'::character varying, 'entregado'::character varying]::text[])
            ELSE lb.estado::text = 'Todos'::text
        END AND
        CASE
            WHEN 'Todos'::text = 'Todos'::text THEN lb.tipo::text = ANY (ARRAY['cheque'::character varying, 'deposito'::character varying, 'debito_automatico'::character varying, 'transferencia_carta'::character varying]::text[])
            WHEN 'Todos'::text = 'transferencia_interna'::text THEN lb.tipo::text = ANY (ARRAY['transf_interna_debe'::character varying, 'transf_interna_haber'::character varying]::text[])
            ELSE lb.tipo::text = 'Todos'::text
        END AND
        CASE
            WHEN 0 = 0 THEN 0 = 0
            ELSE lb.id_finalidad = 0
        END
  ORDER BY lb.fecha;



CREATE TRIGGER tr_trelacion_contable
  AFTER INSERT OR UPDATE OR DELETE 
  ON conta.trelacion_contable
  
FOR EACH ROW 
  EXECUTE PROCEDURE conta.f_tri_trelacion_contable();

ALTER TABLE conta.trelacion_contable
  DISABLE TRIGGER tr_trelacion_contable;

/**********************************F-DEP-CAP-CONTA-0-04/12/2018****************************************/




/**********************************I-DEP-MGM-CONTA-7-27/12/2018****************************************/


CREATE OR REPLACE VIEW conta.vint_comprobante (
    id_int_comprobante,
    id_clase_comprobante,
    id_subsistema,
    id_depto,
    id_moneda,
    id_periodo,
    id_funcionario_firma1,
    id_funcionario_firma2,
    id_funcionario_firma3,
    tipo_cambio,
    beneficiario,
    nro_cbte,
    estado_reg,
    glosa1,
    fecha,
    glosa2,
    nro_tramite,
    momento,
    id_usuario_reg,
    fecha_reg,
    id_usuario_mod,
    fecha_mod,
    usr_reg,
    usr_mod,
    desc_clase_comprobante,
    desc_subsistema,
    desc_depto,
    desc_moneda,
    desc_firma1,
    desc_firma2,
    desc_firma3,
    momento_comprometido,
    momento_ejecutado,
    momento_pagado,
    manual,
    id_int_comprobante_fks,
    id_tipo_relacion_comprobante,
    desc_tipo_relacion_comprobante,
    codigo_depto,
    cbte_cierre,
    cbte_apertura,
    cbte_aitb,
    temporal,
    vbregional,
    fecha_costo_ini,
    fecha_costo_fin,
    tipo_cambio_2,
    id_moneda_tri,
    sw_tipo_cambio,
    id_config_cambiaria,
    ope_1,
    ope_2,
    desc_moneda_tri,
    origen,
    localidad,
    sw_editable,
    cbte_reversion,
    volcado,
    id_proceso_wf,
    id_estado_wf,
    fecha_c31,
    c31,
    id_gestion,
    periodo,
    forma_cambio,
    ope_3,
    id_moneda_act,
    tipo_cambio_3,
    nro_tramite_aux)
AS
SELECT incbte.id_int_comprobante,
    incbte.id_clase_comprobante,
    incbte.id_subsistema,
    incbte.id_depto,
    incbte.id_moneda,
    incbte.id_periodo,
    incbte.id_funcionario_firma1,
    incbte.id_funcionario_firma2,
    incbte.id_funcionario_firma3,
    incbte.tipo_cambio,
    incbte.beneficiario,
    incbte.nro_cbte,
    incbte.estado_reg,
    incbte.glosa1,
    incbte.fecha,
    incbte.glosa2,
    incbte.nro_tramite,
    incbte.momento,
    incbte.id_usuario_reg,
    incbte.fecha_reg,
    incbte.id_usuario_mod,
    incbte.fecha_mod,
    usu1.cuenta AS usr_reg,
    usu2.cuenta AS usr_mod,
    ccbte.descripcion AS desc_clase_comprobante,
    sis.nombre AS desc_subsistema,
    (dpto.codigo::text || '-'::text) || dpto.nombre::text AS desc_depto,
    mon.codigo::text AS desc_moneda,
    fir1.desc_funcionario2 AS desc_firma1,
    fir2.desc_funcionario2 AS desc_firma2,
    fir3.desc_funcionario2 AS desc_firma3,
    pxp.f_iif(incbte.momento_comprometido::text = 'si'::text, 'true'::character
        varying, 'false'::character varying) AS momento_comprometido,
    pxp.f_iif(incbte.momento_ejecutado::text = 'si'::text, 'true'::character
        varying, 'false'::character varying) AS momento_ejecutado,
    pxp.f_iif(incbte.momento_pagado::text = 'si'::text, 'true'::character
        varying, 'false'::character varying) AS momento_pagado,
    incbte.manual,
    array_to_string(incbte.id_int_comprobante_fks, ','::text) AS id_int_comprobante_fks,
    incbte.id_tipo_relacion_comprobante,
    trc.nombre AS desc_tipo_relacion_comprobante,
    dpto.codigo AS codigo_depto,
    incbte.cbte_cierre,
    incbte.cbte_apertura,
    incbte.cbte_aitb,
    incbte.temporal,
    incbte.vbregional,
    incbte.fecha_costo_ini,
    incbte.fecha_costo_fin,
    incbte.tipo_cambio_2,
    incbte.id_moneda_tri,
    incbte.sw_tipo_cambio,
    incbte.id_config_cambiaria,
    ccam.ope_1,
    ccam.ope_2,
    mont.codigo::text AS desc_moneda_tri,
    incbte.origen,
    incbte.localidad,
    incbte.sw_editable,
    incbte.cbte_reversion,
    incbte.volcado,
    incbte.id_proceso_wf,
    incbte.id_estado_wf,
    incbte.fecha_c31,
    incbte.c31,
    per.id_gestion,
    per.periodo,
    incbte.forma_cambio,
    ccam.ope_3,
    incbte.id_moneda_act,
    incbte.tipo_cambio_3,
    incbte.nro_tramite_aux
FROM conta.tint_comprobante incbte
     JOIN segu.tusuario usu1 ON usu1.id_usuario = incbte.id_usuario_reg
     JOIN param.tperiodo per ON per.id_periodo = incbte.id_periodo
     JOIN conta.tclase_comprobante ccbte ON ccbte.id_clase_comprobante =
         incbte.id_clase_comprobante
     JOIN segu.tsubsistema sis ON sis.id_subsistema = incbte.id_subsistema
     JOIN param.tdepto dpto ON dpto.id_depto = incbte.id_depto
     JOIN param.tmoneda mon ON mon.id_moneda = incbte.id_moneda
     JOIN param.tmoneda mont ON mont.id_moneda = incbte.id_moneda_tri
     JOIN param.tmoneda mona ON mona.id_moneda = incbte.id_moneda_act
     JOIN conta.tconfig_cambiaria ccam ON ccam.id_config_cambiaria =
         incbte.id_config_cambiaria
     LEFT JOIN orga.vfuncionario fir1 ON fir1.id_funcionario =
         incbte.id_funcionario_firma1
     LEFT JOIN orga.vfuncionario fir2 ON fir2.id_funcionario =
         incbte.id_funcionario_firma2
     LEFT JOIN orga.vfuncionario fir3 ON fir3.id_funcionario =
         incbte.id_funcionario_firma3
     LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = incbte.id_usuario_mod
     LEFT JOIN conta.ttipo_relacion_comprobante trc ON
         trc.id_tipo_relacion_comprobante = incbte.id_tipo_relacion_comprobante;
         
/**********************************F-DEP-MGM-CONTA-7-27/12/2018****************************************/

/**********************************I-DEP-MMV-CONTA-32-08/02/2018****************************************/
CREATE OR REPLACE VIEW conta.vint_comprobante(
    id_int_comprobante,
    id_clase_comprobante,
    id_subsistema,
    id_depto,
    id_moneda,
    id_periodo,
    id_funcionario_firma1,
    id_funcionario_firma2,
    id_funcionario_firma3,
    tipo_cambio,
    beneficiario,
    nro_cbte,
    estado_reg,
    glosa1,
    fecha,
    glosa2,
    nro_tramite,
    momento,
    id_usuario_reg,
    fecha_reg,
    id_usuario_mod,
    fecha_mod,
    usr_reg,
    usr_mod,
    desc_clase_comprobante,
    desc_subsistema,
    desc_depto,
    desc_moneda,
    desc_firma1,
    desc_firma2,
    desc_firma3,
    momento_comprometido,
    momento_ejecutado,
    momento_pagado,
    manual,
    id_int_comprobante_fks,
    id_tipo_relacion_comprobante,
    desc_tipo_relacion_comprobante,
    codigo_depto,
    cbte_cierre,
    cbte_apertura,
    cbte_aitb,
    temporal,
    vbregional,
    fecha_costo_ini,
    fecha_costo_fin,
    tipo_cambio_2,
    id_moneda_tri,
    sw_tipo_cambio,
    id_config_cambiaria,
    ope_1,
    ope_2,
    desc_moneda_tri,
    origen,
    localidad,
    sw_editable,
    cbte_reversion,
    volcado,
    id_proceso_wf,
    id_estado_wf,
    fecha_c31,
    c31,
    id_gestion,
    periodo,
    forma_cambio,
    ope_3,
    id_moneda_act,
    tipo_cambio_3,
    nro_tramite_aux,
    documento_iva)
AS
  SELECT incbte.id_int_comprobante,
         incbte.id_clase_comprobante,
         incbte.id_subsistema,
         incbte.id_depto,
         incbte.id_moneda,
         incbte.id_periodo,
         incbte.id_funcionario_firma1,
         incbte.id_funcionario_firma2,
         incbte.id_funcionario_firma3,
         incbte.tipo_cambio,
         incbte.beneficiario,
         incbte.nro_cbte,
         incbte.estado_reg,
         incbte.glosa1,
         incbte.fecha,
         incbte.glosa2,
         incbte.nro_tramite,
         incbte.momento,
         incbte.id_usuario_reg,
         incbte.fecha_reg,
         incbte.id_usuario_mod,
         incbte.fecha_mod,
         usu1.cuenta AS usr_reg,
         usu2.cuenta AS usr_mod,
         ccbte.descripcion AS desc_clase_comprobante,
         sis.nombre AS desc_subsistema,
         (dpto.codigo::text || '-'::text) || dpto.nombre::text AS desc_depto,
         mon.codigo::text AS desc_moneda,
         fir1.desc_funcionario2 AS desc_firma1,
         fir2.desc_funcionario2 AS desc_firma2,
         fir3.desc_funcionario2 AS desc_firma3,
         pxp.f_iif(incbte.momento_comprometido::text = 'si'::text, 'true'::
           character varying, 'false'::character varying) AS
           momento_comprometido,
         pxp.f_iif(incbte.momento_ejecutado::text = 'si'::text, 'true'::
           character varying, 'false'::character varying) AS momento_ejecutado,
         pxp.f_iif(incbte.momento_pagado::text = 'si'::text, 'true'::character
           varying, 'false'::character varying) AS momento_pagado,
         incbte.manual,
         array_to_string(incbte.id_int_comprobante_fks, ','::text) AS
           id_int_comprobante_fks,
         incbte.id_tipo_relacion_comprobante,
         trc.nombre AS desc_tipo_relacion_comprobante,
         dpto.codigo AS codigo_depto,
         incbte.cbte_cierre,
         incbte.cbte_apertura,
         incbte.cbte_aitb,
         incbte.temporal,
         incbte.vbregional,
         incbte.fecha_costo_ini,
         incbte.fecha_costo_fin,
         incbte.tipo_cambio_2,
         incbte.id_moneda_tri,
         incbte.sw_tipo_cambio,
         incbte.id_config_cambiaria,
         ccam.ope_1,
         ccam.ope_2,
         mont.codigo::text AS desc_moneda_tri,
         incbte.origen,
         incbte.localidad,
         incbte.sw_editable,
         incbte.cbte_reversion,
         incbte.volcado,
         incbte.id_proceso_wf,
         incbte.id_estado_wf,
         incbte.fecha_c31,
         incbte.c31,
         per.id_gestion,
         per.periodo,
         incbte.forma_cambio,
         ccam.ope_3,
         incbte.id_moneda_act,
         incbte.tipo_cambio_3,
         incbte.nro_tramite_aux,
         incbte.documento_iva
  FROM conta.tint_comprobante incbte
       JOIN segu.tusuario usu1 ON usu1.id_usuario = incbte.id_usuario_reg
       JOIN param.tperiodo per ON per.id_periodo = incbte.id_periodo
       JOIN conta.tclase_comprobante ccbte ON ccbte.id_clase_comprobante =
         incbte.id_clase_comprobante
       JOIN segu.tsubsistema sis ON sis.id_subsistema = incbte.id_subsistema
       JOIN param.tdepto dpto ON dpto.id_depto = incbte.id_depto
       JOIN param.tmoneda mon ON mon.id_moneda = incbte.id_moneda
       JOIN param.tmoneda mont ON mont.id_moneda = incbte.id_moneda_tri
       JOIN param.tmoneda mona ON mona.id_moneda = incbte.id_moneda_act
       JOIN conta.tconfig_cambiaria ccam ON ccam.id_config_cambiaria =
         incbte.id_config_cambiaria
       LEFT JOIN orga.vfuncionario fir1 ON fir1.id_funcionario =
         incbte.id_funcionario_firma1
       LEFT JOIN orga.vfuncionario fir2 ON fir2.id_funcionario =
         incbte.id_funcionario_firma2
       LEFT JOIN orga.vfuncionario fir3 ON fir3.id_funcionario =
         incbte.id_funcionario_firma3
       LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = incbte.id_usuario_mod
       LEFT JOIN conta.ttipo_relacion_comprobante trc ON
         trc.id_tipo_relacion_comprobante = incbte.id_tipo_relacion_comprobante;
/**********************************F-DEP-MMV-CONTA-32-08/02/2018****************************************/

/**********************************I-DEP-EGS-CONTA-01-17/05/2019****************************************/
CREATE OR REPLACE VIEW conta.vint_comprobante(
    id_int_comprobante,
    id_clase_comprobante,
    id_subsistema,
    id_depto,
    id_moneda,
    id_periodo,
    id_funcionario_firma1,
    id_funcionario_firma2,
    id_funcionario_firma3,
    tipo_cambio,
    beneficiario,
    nro_cbte,
    estado_reg,
    glosa1,
    fecha,
    glosa2,
    nro_tramite,
    momento,
    id_usuario_reg,
    fecha_reg,
    id_usuario_mod,
    fecha_mod,
    usr_reg,
    usr_mod,
    desc_clase_comprobante,
    desc_subsistema,
    desc_depto,
    desc_moneda,
    desc_firma1,
    desc_firma2,
    desc_firma3,
    momento_comprometido,
    momento_ejecutado,
    momento_pagado,
    manual,
    id_int_comprobante_fks,
    id_tipo_relacion_comprobante,
    desc_tipo_relacion_comprobante,
    codigo_depto,
    cbte_cierre,
    cbte_apertura,
    cbte_aitb,
    temporal,
    vbregional,
    fecha_costo_ini,
    fecha_costo_fin,
    tipo_cambio_2,
    id_moneda_tri,
    sw_tipo_cambio,
    id_config_cambiaria,
    ope_1,
    ope_2,
    desc_moneda_tri,
    origen,
    localidad,
    sw_editable,
    cbte_reversion,
    volcado,
    id_proceso_wf,
    id_estado_wf,
    fecha_c31,
    c31,
    id_gestion,
    periodo,
    forma_cambio,
    ope_3,
    id_moneda_act,
    tipo_cambio_3,
    nro_tramite_aux,
    documento_iva,
    id_int_comprobante_migrado)
AS
  SELECT incbte.id_int_comprobante,
         incbte.id_clase_comprobante,
         incbte.id_subsistema,
         incbte.id_depto,
         incbte.id_moneda,
         incbte.id_periodo,
         incbte.id_funcionario_firma1,
         incbte.id_funcionario_firma2,
         incbte.id_funcionario_firma3,
         incbte.tipo_cambio,
         incbte.beneficiario,
         incbte.nro_cbte,
         incbte.estado_reg,
         incbte.glosa1,
         incbte.fecha,
         incbte.glosa2,
         incbte.nro_tramite,
         incbte.momento,
         incbte.id_usuario_reg,
         incbte.fecha_reg,
         incbte.id_usuario_mod,
         incbte.fecha_mod,
         usu1.cuenta AS usr_reg,
         usu2.cuenta AS usr_mod,
         ccbte.descripcion AS desc_clase_comprobante,
         sis.nombre AS desc_subsistema,
         (dpto.codigo::text || '-'::text) || dpto.nombre::text AS desc_depto,
         mon.codigo::text AS desc_moneda,
         fir1.desc_funcionario2 AS desc_firma1,
         fir2.desc_funcionario2 AS desc_firma2,
         fir3.desc_funcionario2 AS desc_firma3,
         pxp.f_iif(incbte.momento_comprometido::text = 'si'::text, 'true'::
           character varying, 'false'::character varying) AS
           momento_comprometido,
         pxp.f_iif(incbte.momento_ejecutado::text = 'si'::text, 'true'::
           character varying, 'false'::character varying) AS momento_ejecutado,
         pxp.f_iif(incbte.momento_pagado::text = 'si'::text, 'true'::character
           varying, 'false'::character varying) AS momento_pagado,
         incbte.manual,
         array_to_string(incbte.id_int_comprobante_fks, ','::text) AS
           id_int_comprobante_fks,
         incbte.id_tipo_relacion_comprobante,
         trc.nombre AS desc_tipo_relacion_comprobante,
         dpto.codigo AS codigo_depto,
         incbte.cbte_cierre,
         incbte.cbte_apertura,
         incbte.cbte_aitb,
         incbte.temporal,
         incbte.vbregional,
         incbte.fecha_costo_ini,
         incbte.fecha_costo_fin,
         incbte.tipo_cambio_2,
         incbte.id_moneda_tri,
         incbte.sw_tipo_cambio,
         incbte.id_config_cambiaria,
         ccam.ope_1,
         ccam.ope_2,
         mont.codigo::text AS desc_moneda_tri,
         incbte.origen,
         incbte.localidad,
         incbte.sw_editable,
         incbte.cbte_reversion,
         incbte.volcado,
         incbte.id_proceso_wf,
         incbte.id_estado_wf,
         incbte.fecha_c31,
         incbte.c31,
         per.id_gestion,
         per.periodo,
         incbte.forma_cambio,
         ccam.ope_3,
         incbte.id_moneda_act,
         incbte.tipo_cambio_3,
         incbte.nro_tramite_aux,
         incbte.documento_iva,
         incbte.id_int_comprobante_migrado
  FROM conta.tint_comprobante incbte
       JOIN segu.tusuario usu1 ON usu1.id_usuario = incbte.id_usuario_reg
       JOIN param.tperiodo per ON per.id_periodo = incbte.id_periodo
       JOIN conta.tclase_comprobante ccbte ON ccbte.id_clase_comprobante =
         incbte.id_clase_comprobante
       JOIN segu.tsubsistema sis ON sis.id_subsistema = incbte.id_subsistema
       JOIN param.tdepto dpto ON dpto.id_depto = incbte.id_depto
       JOIN param.tmoneda mon ON mon.id_moneda = incbte.id_moneda
       JOIN param.tmoneda mont ON mont.id_moneda = incbte.id_moneda_tri
       JOIN param.tmoneda mona ON mona.id_moneda = incbte.id_moneda_act
       JOIN conta.tconfig_cambiaria ccam ON ccam.id_config_cambiaria =
         incbte.id_config_cambiaria
       LEFT JOIN orga.vfuncionario fir1 ON fir1.id_funcionario =
         incbte.id_funcionario_firma1
       LEFT JOIN orga.vfuncionario fir2 ON fir2.id_funcionario =
         incbte.id_funcionario_firma2
       LEFT JOIN orga.vfuncionario fir3 ON fir3.id_funcionario =
         incbte.id_funcionario_firma3
       LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = incbte.id_usuario_mod
       LEFT JOIN conta.ttipo_relacion_comprobante trc ON
         trc.id_tipo_relacion_comprobante = incbte.id_tipo_relacion_comprobante;
/**********************************F-DEP-EGS-CONTA-01-17/05/2019****************************************/
/**********************************I-DEP-EGS-CONTA-02-05/06/2019****************************************/
select pxp.f_insert_testructura_gui ('CFGETASA', 'CONF');
select pxp.f_insert_testructura_gui ('CTP', 'CFGETASA');
select pxp.f_insert_testructura_gui ('CFGAUX', 'CFGETASA');

/**********************************F-DEP-EGS-CONTA-02-05/06/2019****************************************/
/**********************************I-DEP-EGS-CONTA-03-11/06/2019****************************************/
select pxp.f_insert_testructura_gui ('cbtemarca', 'CONF');
/**********************************F-DEP-EGS-CONTA-03-11/06/2019****************************************/


/**********************************I-DEP-MANU-CONTA-01-30/10/2019****************************************/
select pxp.f_insert_testructura_gui ('VBVER', 'CBTE.1');
/**********************************F-DEP-MANU-CONTA-01-30/10/2019****************************************/



