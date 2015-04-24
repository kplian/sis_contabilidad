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

/***********************************I-DEP-RCM-CONTA-0-13/12/2013*****************************************/

CREATE TRIGGER tr_trelacion_contable
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON conta.trelacion_contable FOR EACH ROW 
  		EXECUTE PROCEDURE conta.f_tri_trelacion_contable();

  		
/***********************************F-DEP-RCM-CONTA-0-13/12/2013*****************************************/

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
select pxp.f_insert_tprocedimiento_gui ('CONTA_CAX_INS', 'CTA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CAX_MOD', 'CTA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CAX_ELI', 'CTA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CAX_SEL', 'CTA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DOCUME_SEL', 'CCBT', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CCOM_INS', 'CCBT', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CCOM_MOD', 'CCBT', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CCOM_ELI', 'CCBT', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CCOM_SEL', 'CCBT', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_TABRECON_INS', 'RELCON', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_TABRECON_MOD', 'RELCON', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_TABRECON_ELI', 'RELCON', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_TABRECON_SEL', 'RELCON', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_SUBSIS_SEL', 'RELCON', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CATCMB_SEL', 'RELCON', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_TIPRELCO_INS', 'RELCON.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_TIPRELCO_MOD', 'RELCON.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_TIPRELCO_ELI', 'RELCON.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_TIPRELCO_SEL', 'RELCON.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CATCMB_SEL', 'RELCON.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_SUBSIS_SEL', 'RELCON.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PACATI_SEL', 'RELCON.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_INS', 'RELCON.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_MOD', 'RELCON.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_ELI', 'RELCON.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_SEL', 'RELCON.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CATCMB_SEL', 'RELCON.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_SUBSIS_SEL', 'RELCON.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PACATI_SEL', 'RELCON.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_INS', 'RELCON.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_MOD', 'RELCON.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_ELI', 'RELCON.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_SEL', 'RELCON.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CATCMB_SEL', 'RELCON.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_SEL', 'PROVCUEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_ARB_SEL', 'PROVCUEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROVEE_INS', 'PROVCUEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROVEE_MOD', 'PROVCUEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROVEE_ELI', 'PROVCUEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROVEE_SEL', 'PROVCUEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'PROVCUEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'PROVCUEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'PROVCUEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_TIPRELCO_SEL', 'PROVCUEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_RELCON_INS', 'PROVCUEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_RELCON_MOD', 'PROVCUEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_RELCON_ELI', 'PROVCUEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_RELCON_SEL', 'PROVCUEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GES_SEL', 'PROVCUEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CEC_SEL', 'PROVCUEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'PROVCUEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOMFU_SEL', 'PROVCUEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CCFILDEP_SEL', 'PROVCUEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'PROVCUEN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'PROVCUEN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'PROVCUEN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'PROVCUEN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'PROVCUEN.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'PROVCUEN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'PROVCUEN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'PROVCUEN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'PROVCUEN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'PROVCUEN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'PROVCUEN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'PROVCUEN.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'PROVCUEN.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'PROVCUEN.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'PROVCUEN.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_TIPRELCO_INS', 'RELCONGEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_TIPRELCO_MOD', 'RELCONGEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_TIPRELCO_ELI', 'RELCONGEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_TIPRELCO_SEL', 'RELCONGEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CATCMB_SEL', 'RELCONGEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_RELCON_INS', 'RELCONGEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_RELCON_MOD', 'RELCONGEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_RELCON_ELI', 'RELCONGEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_RELCON_SEL', 'RELCONGEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GES_SEL', 'RELCONGEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CEC_SEL', 'RELCONGEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'RELCONGEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOMFU_SEL', 'RELCONGEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CCFILDEP_SEL', 'RELCONGEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_SUBSIS_SEL', 'RELCONGEN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PACATI_SEL', 'RELCONGEN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_INS', 'RELCONGEN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_MOD', 'RELCONGEN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_ELI', 'RELCONGEN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_SEL', 'RELCONGEN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CATCMB_SEL', 'RELCONGEN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIG_INS', 'CONGASCUE', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIG_MOD', 'CONGASCUE', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIG_ELI', 'CONGASCUE', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIG_SEL', 'CONGASCUE', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPP_SEL', 'CONGASCUE', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CATCMB_SEL', 'CONGASCUE', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_TIPRELCO_SEL', 'CONGASCUE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_RELCON_INS', 'CONGASCUE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_RELCON_MOD', 'CONGASCUE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_RELCON_ELI', 'CONGASCUE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_RELCON_SEL', 'CONGASCUE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GES_SEL', 'CONGASCUE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CEC_SEL', 'CONGASCUE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'CONGASCUE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOMFU_SEL', 'CONGASCUE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CCFILDEP_SEL', 'CONGASCUE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_SUBSIS_SEL', 'CONGASCUE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PACATI_SEL', 'CONGASCUE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_INS', 'CONGASCUE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_MOD', 'CONGASCUE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_ELI', 'CONGASCUE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_SEL', 'CONGASCUE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CATCMB_SEL', 'CONGASCUE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_TIPRELCO_SEL', 'CMPB.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_INS', 'RELCCCB', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_MOD', 'RELCCCB', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_ELI', 'RELCCCB', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_SEL', 'RELCCCB', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'RELCCCB', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'RELCCCB', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_TIPRELCO_SEL', 'RELCCCB.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_RELCON_INS', 'RELCCCB.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_RELCON_MOD', 'RELCCCB.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_RELCON_ELI', 'RELCCCB.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_RELCON_SEL', 'RELCCCB.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GES_SEL', 'RELCCCB.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CEC_SEL', 'RELCCCB.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'RELCCCB.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOMFU_SEL', 'RELCCCB.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CCFILDEP_SEL', 'RELCCCB.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CHQ_INS', 'RELCCCB.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CHQ_MOD', 'RELCCCB.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CHQ_ELI', 'RELCCCB.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CHQ_SEL', 'RELCCCB.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'RELCCCB.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'RELCCCB.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'RELCCCB.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'RELCCCB.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'RELCCCB.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'RELCCCB.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'RELCCCB.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'RELCCCB.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'RELCCCB.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'RELCCCB.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'RELCCCB.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPFILUSU_SEL', 'CBTE.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CCOM_SEL', 'CBTE.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'CBTE.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_INCBTE_INS', 'CBTE.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_INCBTE_MOD', 'CBTE.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_INCBTE_ELI', 'CBTE.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_INCBTE_SEL', 'CBTE.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_INCBTE_VAL', 'CBTE.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_OBTTCB_GET', 'CBTE.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CABCBT_SEL', 'CBTE.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_DETCBT_SEL', 'CBTE.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CATCMB_SEL', 'CBTE.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_SEL', 'CBTE.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'CBTE.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_INTRANSA_INS', 'CBTE.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_INTRANSA_MOD', 'CBTE.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_INTRANSA_ELI', 'CBTE.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_INTRANSA_SEL', 'CBTE.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GETGES_ELI', 'CBTE.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CEC_SEL', 'CBTE.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'CBTE.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOMFU_SEL', 'CBTE.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CCFILDEP_SEL', 'CBTE.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_SUBSIS_SEL', 'CBTE.1.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PACATI_SEL', 'CBTE.1.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_INS', 'CBTE.1.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_MOD', 'CBTE.1.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_ELI', 'CBTE.1.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_SEL', 'CBTE.1.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CATCMB_SEL', 'CBTE.1.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_INS', 'CBTE.1.1.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_MOD', 'CBTE.1.1.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_ELI', 'CBTE.1.1.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_SEL', 'CBTE.1.1.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'CBTE.1.1.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'CBTE.1.1.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'CBTE.1.1.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_INS', 'CBTE.1.1.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_MOD', 'CBTE.1.1.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_ELI', 'CBTE.1.1.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_SEL', 'CBTE.1.1.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'CBTE.1.1.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'CBTE.1.1.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'CBTE.1.1.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'CBTE.1.1.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'CBTE.1.1.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'CBTE.1.1.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'CBTE.1.1.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'CBTE.1.1.3.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'CBTE.1.1.3.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'CBTE.1.1.3.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'CBTE.1.1.3.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'CBTE.1.1.3.1.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'CBTE.1.1.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'CBTE.1.1.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'CBTE.1.1.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'CBTE.1.1.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_SUBSIS_SEL', 'DEPTCON', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPPTO_INS', 'DEPTCON', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPPTO_MOD', 'DEPTCON', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPPTO_ELI', 'DEPTCON', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPPTO_SEL', 'DEPTCON', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSUCOMB_SEL', 'DEPTCON', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPFILUSU_SEL', 'DEPTCON', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPFILEPUO_SEL', 'DEPTCON', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_TIPRELCO_SEL', 'DEPTCON.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_RELCON_INS', 'DEPTCON.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_RELCON_MOD', 'DEPTCON.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_RELCON_ELI', 'DEPTCON.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_RELCON_SEL', 'DEPTCON.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GES_SEL', 'DEPTCON.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CEC_SEL', 'DEPTCON.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'DEPTCON.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOMFU_SEL', 'DEPTCON.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CCFILDEP_SEL', 'DEPTCON.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_USUARI_SEL', 'DEPTCON.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSU_INS', 'DEPTCON.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSU_MOD', 'DEPTCON.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSU_ELI', 'DEPTCON.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSU_SEL', 'DEPTCON.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'DEPTCON.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'DEPTCON.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_CLASIF_SEL', 'DEPTCON.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_ROL_SEL', 'DEPTCON.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_USUARI_INS', 'DEPTCON.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_USUARI_MOD', 'DEPTCON.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_USUARI_ELI', 'DEPTCON.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_USUARI_SEL', 'DEPTCON.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'DEPTCON.2.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'DEPTCON.2.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'DEPTCON.2.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'DEPTCON.2.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'DEPTCON.2.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_ROL_SEL', 'DEPTCON.2.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_USUROL_INS', 'DEPTCON.2.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_USUROL_MOD', 'DEPTCON.2.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_USUROL_ELI', 'DEPTCON.2.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_USUROL_SEL', 'DEPTCON.2.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GRU_SEL', 'DEPTCON.2.1.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SG_UEP_INS', 'DEPTCON.2.1.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SG_UEP_MOD', 'DEPTCON.2.1.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SG_UEP_ELI', 'DEPTCON.2.1.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SG_UEP_SEL', 'DEPTCON.2.1.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUO_INS', 'DEPTCON.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUO_MOD', 'DEPTCON.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUO_ELI', 'DEPTCON.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUO_SEL', 'DEPTCON.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_UO_SEL', 'DEPTCON.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_INIUOARB_SEL', 'DEPTCON.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEEP_INS', 'DEPTCON.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEEP_MOD', 'DEPTCON.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEEP_ELI', 'DEPTCON.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEEP_SEL', 'DEPTCON.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_FRPP_SEL', 'DEPTCON.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DUE_INS', 'DEPTCON.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DUE_MOD', 'DEPTCON.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DUE_ELI', 'DEPTCON.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DUE_SEL', 'DEPTCON.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_UO_SEL', 'DEPTCON.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_INIUOARB_SEL', 'DEPTCON.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_FRPP_SEL', 'DEPTCON.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DOCUME_SEL', 'DEPTCON.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_FIR_INS', 'DEPTCON.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_FIR_MOD', 'DEPTCON.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_FIR_ELI', 'DEPTCON.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_FIR_SEL', 'DEPTCON.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'DEPTCON.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PLT_INS', 'PLADOC', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PLT_MOD', 'PLADOC', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PLT_ELI', 'PLADOC', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PLT_SEL', 'PLADOC', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_TIPRELCO_SEL', 'PLADOC.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_PLACAL_INS', 'PLADOC.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_PLACAL_MOD', 'PLADOC.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_GETDEC_IME', 'PLADOC.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_PLACAL_SEL', 'PLADOC.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CATCMB_SEL', 'PLADOC.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_SUBSIS_SEL', 'PLADOC.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PACATI_SEL', 'PLADOC.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_INS', 'PLADOC.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_MOD', 'PLADOC.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_ELI', 'PLADOC.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_SEL', 'PLADOC.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CATCMB_SEL', 'PLADOC.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PESU_INS', 'CONPER', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PESU_MOD', 'CONPER', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PESU_ELI', 'CONPER', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PESU_SEL', 'CONPER', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SWESTPE_MOD', 'CONPER', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPFILUSU_SEL', 'CBTE.1.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CCOM_SEL', 'CBTE.1.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'CBTE.1.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CBTE_INS', 'CBTE.1.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CBTE_MOD', 'CBTE.1.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CBTE_ELI', 'CBTE.1.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CBTE_SEL', 'CBTE.1.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CATCMB_SEL', 'CBTE.1.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_SEL', 'CBTE.1.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'CBTE.1.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_TRANSA_SEL', 'CBTE.1.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GETGES_ELI', 'CBTE.1.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'CBTE.1.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CEC_SEL', 'CBTE.1.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'CBTE.1.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOMFU_SEL', 'CBTE.1.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CCFILDEP_SEL', 'CBTE.1.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_SUBSIS_SEL', 'CBTE.1.3.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PACATI_SEL', 'CBTE.1.3.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_INS', 'CBTE.1.3.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_MOD', 'CBTE.1.3.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_ELI', 'CBTE.1.3.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_SEL', 'CBTE.1.3.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CATCMB_SEL', 'CBTE.1.3.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_INS', 'CBTE.1.3.1.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_MOD', 'CBTE.1.3.1.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_ELI', 'CBTE.1.3.1.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_SEL', 'CBTE.1.3.1.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'CBTE.1.3.1.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'CBTE.1.3.1.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'CBTE.1.3.1.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_INS', 'CBTE.1.3.1.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_MOD', 'CBTE.1.3.1.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_ELI', 'CBTE.1.3.1.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_SEL', 'CBTE.1.3.1.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'CBTE.1.3.1.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'CBTE.1.3.1.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'CBTE.1.3.1.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'CBTE.1.3.1.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'CBTE.1.3.1.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'CBTE.1.3.1.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'CBTE.1.3.1.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'CBTE.1.3.1.3.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'CBTE.1.3.1.3.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'CBTE.1.3.1.3.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'CBTE.1.3.1.3.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'CBTE.1.3.1.3.1.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'CBTE.1.3.1.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'CBTE.1.3.1.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'CBTE.1.3.1.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'CBTE.1.3.1.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_SWEST_MOD', 'ALMCUE', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPPTO_SEL', 'ALMCUE', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSUCOMB_SEL', 'ALMCUE', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPFILUSU_SEL', 'ALMCUE', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPFILEPUO_SEL', 'ALMCUE', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ALM_INS', 'ALMCUE', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ALM_MOD', 'ALMCUE', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ALM_ELI', 'ALMCUE', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ALM_SEL', 'ALMCUE', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_TIPRELCO_SEL', 'ALMCUE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_RELCON_INS', 'ALMCUE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_RELCON_MOD', 'ALMCUE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_RELCON_ELI', 'ALMCUE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_RELCON_SEL', 'ALMCUE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GES_SEL', 'ALMCUE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CEC_SEL', 'ALMCUE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'ALMCUE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOMFU_SEL', 'ALMCUE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CCFILDEP_SEL', 'ALMCUE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_USUARI_SEL', 'ALMCUE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ALMUSR_INS', 'ALMCUE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ALMUSR_MOD', 'ALMCUE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ALMUSR_ELI', 'ALMCUE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ALMUSR_SEL', 'ALMCUE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'ALMCUE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_MEVAL_SEL', 'ALMCUE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ALMITEM_INS', 'ALMCUE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ALMITEM_MOD', 'ALMCUE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ALMITEM_ELI', 'ALMCUE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ALMITEM_SEL', 'ALMCUE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ALM_CLA_ARB_SEL', 'ALMCUE.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ARB_SEL', 'ALMCUE.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITMSRCHARB_SEL', 'ALMCUE.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITMALM_SEL', 'ALMCUE.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ALMGES_INS', 'ALMCUE.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ALMGES_MOD', 'ALMCUE.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ALMGES_ELI', 'ALMCUE.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ALMGES_SEL', 'ALMCUE.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ACCGES_INS', 'ALMCUE.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GES_SEL', 'ALMCUE.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_AGLOG_INS', 'ALMCUE.6.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_AGLOG_MOD', 'ALMCUE.6.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_AGLOG_ELI', 'ALMCUE.6.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_AGLOG_SEL', 'ALMCUE.6.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GETGES_ELI', 'ALMCUE.6.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_MOVREPORT_SEL', 'ALMCUE.6.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_MOVTIP_SEL', 'ALMCUE.6.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ALM_SEL', 'ALMCUE.6.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_FUNCIOCAR_SEL', 'ALMCUE.6.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'ALMCUE.6.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_MOV_SEL', 'ALMCUE.6.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPPTO_SEL', 'ALMCUE.6.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSUCOMB_SEL', 'ALMCUE.6.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPFILUSU_SEL', 'ALMCUE.6.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPFILEPUO_SEL', 'ALMCUE.6.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_MOV_INS', 'ALMCUE.6.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_MOV_MOD', 'ALMCUE.6.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_MOV_ELI', 'ALMCUE.6.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_MOVCNL_MOD', 'ALMCUE.6.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_MOVREV_MOD', 'ALMCUE.6.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_MOVFIN_MOD', 'ALMCUE.6.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_SIGEST_SEL', 'ALMCUE.6.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_FUNTIPES_SEL', 'ALMCUE.6.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_MOVPRE_REV', 'ALMCUE.6.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CATCMB_SEL', 'ALMCUE.6.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'ALMCUE.6.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'ALMCUE.6.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIG_SEL', 'ALMCUE.6.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPP_SEL', 'ALMCUE.6.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_MOVDET_INS', 'ALMCUE.6.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_MOVDET_MOD', 'ALMCUE.6.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_MOVDET_ELI', 'ALMCUE.6.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_MOVDET_SEL', 'ALMCUE.6.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ALM_CLA_ARB_SEL', 'ALMCUE.6.2.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ARB_SEL', 'ALMCUE.6.2.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITMSRCHARB_SEL', 'ALMCUE.6.2.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_DETVAL_SEL', 'ALMCUE.6.2.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_ALARM_INS', 'ALMCUE.6.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_ALARM_MOD', 'ALMCUE.6.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_ALARM_ELI', 'ALMCUE.6.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_ALARMCOR_SEL', 'ALMCUE.6.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_ALARM_SEL', 'ALMCUE.6.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_CLA_INS', 'CLACUE', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_CLA_MOD', 'CLACUE', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_CLA_ELI', 'CLACUE', 'no');
select pxp.f_insert_tprocedimiento_gui ('ALM_CLA_ARB_SEL', 'CLACUE', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ARB_SEL', 'CLACUE', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_CLADD_MOD', 'CLACUE', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ESTCLA_MOD', 'CLACUE', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_TIPRELCO_SEL', 'CLACUE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_RELCON_INS', 'CLACUE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_RELCON_MOD', 'CLACUE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_RELCON_ELI', 'CLACUE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_RELCON_SEL', 'CLACUE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GES_SEL', 'CLACUE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CEC_SEL', 'CLACUE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'CLACUE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOMFU_SEL', 'CLACUE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CCFILDEP_SEL', 'CLACUE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEM_INS', 'CLACUE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEM_MOD', 'CLACUE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEM_ELI', 'CLACUE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEM_SEL', 'CLACUE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'CLACUE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITMALM_SEL', 'CLACUE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_GENCODE_MOD', 'CLACUE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_UME_SEL', 'CLACUE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'CLACUE.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITMREE_INS', 'CLACUE.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITMREE_MOD', 'CLACUE.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITMREE_ELI', 'CLACUE.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITMREE_SEL', 'CLACUE.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ALM_CLA_ARB_SEL', 'CLACUE.2.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ARB_SEL', 'CLACUE.2.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITMSRCHARB_SEL', 'CLACUE.2.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITMALM_SEL', 'CLACUE.2.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITMARCH_INS', 'CLACUE.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITMARCH_MOD', 'CLACUE.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITMARCH_ELI', 'CLACUE.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITMARCH_SEL', 'CLACUE.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_UPARCH_MOD', 'CLACUE.2.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_UME_INS', 'CLACUE.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_UME_MOD', 'CLACUE.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_UME_ELI', 'CLACUE.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_UME_SEL', 'CLACUE.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CATCMB_SEL', 'CLACUE.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_SUBSIS_SEL', 'CLACUE.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PACATI_SEL', 'CLACUE.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_INS', 'CLACUE.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_MOD', 'CLACUE.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_ELI', 'CLACUE.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_SEL', 'CLACUE.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CATCMB_SEL', 'CLACUE.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GES_SEL', 'RERELCON', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_EMP_SEL', 'RERELCON', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GES_INS', 'RERELCON', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GES_MOD', 'RERELCON', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GES_ELI', 'RERELCON', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PERSUB_SIN', 'RERELCON', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CATCMB_SEL', 'RERELCON', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'RERELCON', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PER_INS', 'RERELCON.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PER_MOD', 'RERELCON.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PER_ELI', 'RERELCON.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PER_SEL', 'RERELCON.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PESU_INS', 'RERELCON.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PESU_MOD', 'RERELCON.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PESU_ELI', 'RERELCON.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PESU_SEL', 'RERELCON.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SWESTPE_MOD', 'RERELCON.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_SUBSIS_SEL', 'RERELCON.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PACATI_SEL', 'RERELCON.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_INS', 'RERELCON.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_MOD', 'RERELCON.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_ELI', 'RERELCON.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_SEL', 'RERELCON.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CATCMB_SEL', 'RERELCON.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_PAR_SEL', 'CONGASCUE', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CTA_SEL', 'CONGASCUE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_AUXCTA_SEL', 'CONGASCUE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_PAR_SEL', 'PROVCUEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CTA_SEL', 'PROVCUEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_AUXCTA_SEL', 'PROVCUEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'PROVCUEN.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'CBTE.1.1.3.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_LISTUSU_SEG', 'DEPTCON.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_LISTUSU_SEG', 'DEPTCON.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_PLACAL_ELI', 'PLADOC.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'CBTE.1.3.1.3.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_LISTUSU_SEG', 'ALMCUE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_AGMOV_GET', 'ALMCUE.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_MOVREPORT_SEL', 'ALMCUE.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_SEL', 'ALMCUE.6.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITMALM_SEL', 'ALMCUE.6.2.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_INS', 'ALMCUE.6.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_MOD', 'ALMCUE.6.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_ELI', 'ALMCUE.6.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_SEL', 'ALMCUE.6.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'ALMCUE.6.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'ALMCUE.6.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'ALMCUE.6.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_INS', 'ALMCUE.6.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_MOD', 'ALMCUE.6.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_ELI', 'ALMCUE.6.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_SEL', 'ALMCUE.6.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'ALMCUE.6.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'ALMCUE.6.2.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'ALMCUE.6.2.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'ALMCUE.6.2.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'ALMCUE.6.2.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'ALMCUE.6.2.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'ALMCUE.6.2.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'ALMCUE.6.2.3.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'ALMCUE.6.2.3.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'ALMCUE.6.2.3.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'ALMCUE.6.2.3.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'ALMCUE.6.2.3.1.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'ALMCUE.6.2.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'ALMCUE.6.2.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'ALMCUE.6.2.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'ALMCUE.6.2.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'ALMCUE.6.2.3.2.1', 'no');
select pxp.f_insert_tgui_rol ('CONGASCUE', 'CONTA- Relación Contable Concepto Gasto');
select pxp.f_insert_tgui_rol ('RELACON', 'CONTA- Relación Contable Concepto Gasto');
select pxp.f_insert_tgui_rol ('CONTA', 'CONTA- Relación Contable Concepto Gasto');
select pxp.f_insert_tgui_rol ('SISTEMA', 'CONTA- Relación Contable Concepto Gasto');
select pxp.f_insert_tgui_rol ('CONGASCUE.2', 'CONTA- Relación Contable Concepto Gasto');
select pxp.f_insert_tgui_rol ('CONGASCUE.1', 'CONTA- Relación Contable Concepto Gasto');
select pxp.f_insert_tgui_rol ('PROVCUEN', 'CONTA - Relacion Proveedor - Cuenta Contable');
select pxp.f_insert_tgui_rol ('RELACON', 'CONTA - Relacion Proveedor - Cuenta Contable');
select pxp.f_insert_tgui_rol ('CONTA', 'CONTA - Relacion Proveedor - Cuenta Contable');
select pxp.f_insert_tgui_rol ('SISTEMA', 'CONTA - Relacion Proveedor - Cuenta Contable');
select pxp.f_insert_tgui_rol ('PROVCUEN.1', 'CONTA - Relacion Proveedor - Cuenta Contable');
select pxp.f_insert_tgui_rol ('PROVCUEN.2', 'CONTA - Relacion Proveedor - Cuenta Contable');
select pxp.f_insert_tgui_rol ('PROVCUEN.2.1', 'CONTA - Relacion Proveedor - Cuenta Contable');
select pxp.f_insert_tgui_rol ('PROVCUEN.3', 'CONTA - Relacion Proveedor - Cuenta Contable');
select pxp.f_insert_tgui_rol ('PROVCUEN.3.1', 'CONTA - Relacion Proveedor - Cuenta Contable');
select pxp.f_insert_tgui_rol ('RELACON', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('CONTA', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('SISTEMA', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('PROVCUEN', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('PROVCUEN.1', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('PROVCUEN.2', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('PROVCUEN.2.1', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('PROVCUEN.3', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('PROVCUEN.3.1', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('PROVCUEN.3.1.1', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('RELCONGEN', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('RELCONGEN.2', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('RELCONGEN.1', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('CONGASCUE', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('CONGASCUE.2', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('CONGASCUE.1', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('RELCCCB', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('RELCCCB.1', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('RELCCCB.2', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('RELCCCB.3', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('RELCCCB.3.1', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('RELCCCB.3.1.1', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('DEPTCON', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('DEPTCON.1', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('DEPTCON.2', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('DEPTCON.2.1', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('DEPTCON.2.1.1', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('DEPTCON.2.1.1.1', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('DEPTCON.2.1.2', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('DEPTCON.2.1.3', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('DEPTCON.3', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('DEPTCON.4', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('DEPTCON.5', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('DEPTCON.6', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('DEPTCON.7', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('ALMCUE', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('ALMCUE.1', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('ALMCUE.2', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('ALMCUE.3', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('ALMCUE.3.1', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('ALMCUE.3.1.1', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('ALMCUE.4', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('ALMCUE.5', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('ALMCUE.6', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('ALMCUE.6.2', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('ALMCUE.6.2.1', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('ALMCUE.6.2.1.2', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('ALMCUE.6.2.1.1', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('ALMCUE.6.2.1.1.1', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('ALMCUE.6.2.2', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('ALMCUE.6.2.3', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('ALMCUE.6.2.3.2', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('ALMCUE.6.2.3.2.1', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('ALMCUE.6.2.3.1', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('ALMCUE.6.2.3.1.1', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('ALMCUE.6.2.3.1.1.1', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('ALMCUE.6.2.3.1.1.1.1', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('ALMCUE.6.1', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('CLACUE', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('CLACUE.2', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('CLACUE.2.1', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('CLACUE.2.1.1', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('CLACUE.2.1.1.1', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('CLACUE.2.2', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('CLACUE.2.2.1', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('CLACUE.2.3', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('CLACUE.2.3.1', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('CLACUE.1', 'CONTA - Relacion cuenta Bancaria');
select pxp.f_insert_tgui_rol ('DEPTCON', 'CONTA - Relaciones contables ELACIONES CONTABLES');
select pxp.f_insert_tgui_rol ('RELACON', 'CONTA - Relaciones contables ELACIONES CONTABLES');
select pxp.f_insert_tgui_rol ('CONTA', 'CONTA - Relaciones contables ELACIONES CONTABLES');
select pxp.f_insert_tgui_rol ('SISTEMA', 'CONTA - Relaciones contables ELACIONES CONTABLES');
select pxp.f_insert_tgui_rol ('DEPTCON.1', 'CONTA - Relaciones contables ELACIONES CONTABLES');
select pxp.f_insert_tgui_rol ('DEPTCON.2', 'CONTA - Relaciones contables ELACIONES CONTABLES');
select pxp.f_insert_tgui_rol ('DEPTCON.2.1', 'CONTA - Relaciones contables ELACIONES CONTABLES');
select pxp.f_insert_tgui_rol ('DEPTCON.2.1.1', 'CONTA - Relaciones contables ELACIONES CONTABLES');
select pxp.f_insert_tgui_rol ('DEPTCON.2.1.1.1', 'CONTA - Relaciones contables ELACIONES CONTABLES');
select pxp.f_insert_tgui_rol ('DEPTCON.2.1.2', 'CONTA - Relaciones contables ELACIONES CONTABLES');
select pxp.f_insert_tgui_rol ('DEPTCON.2.1.3', 'CONTA - Relaciones contables ELACIONES CONTABLES');
select pxp.f_insert_tgui_rol ('DEPTCON.3', 'CONTA - Relaciones contables ELACIONES CONTABLES');
select pxp.f_insert_tgui_rol ('DEPTCON.4', 'CONTA - Relaciones contables ELACIONES CONTABLES');
select pxp.f_insert_tgui_rol ('DEPTCON.5', 'CONTA - Relaciones contables ELACIONES CONTABLES');
select pxp.f_insert_tgui_rol ('DEPTCON.6', 'CONTA - Relaciones contables ELACIONES CONTABLES');
select pxp.f_insert_tgui_rol ('DEPTCON.7', 'CONTA - Relaciones contables ELACIONES CONTABLES');
select pxp.f_insert_tgui_rol ('RELCONGEN', 'CONTA - Relaciones contables ELACIONES CONTABLES');
select pxp.f_insert_tgui_rol ('RELCONGEN.2', 'CONTA - Relaciones contables ELACIONES CONTABLES');
select pxp.f_insert_tgui_rol ('RELCONGEN.1', 'CONTA - Relaciones contables ELACIONES CONTABLES');
select pxp.f_insert_tgui_rol ('CONGASCUE', 'CONTA - Relaciones contables ELACIONES CONTABLES');
select pxp.f_insert_tgui_rol ('CONGASCUE.2', 'CONTA - Relaciones contables ELACIONES CONTABLES');
select pxp.f_insert_tgui_rol ('CONGASCUE.1', 'CONTA - Relaciones contables ELACIONES CONTABLES');
select pxp.f_insert_tgui_rol ('PROVCUEN', 'CONTA - Relaciones contables ELACIONES CONTABLES');
select pxp.f_insert_tgui_rol ('PROVCUEN.1', 'CONTA - Relaciones contables ELACIONES CONTABLES');
select pxp.f_insert_tgui_rol ('PROVCUEN.2', 'CONTA - Relaciones contables ELACIONES CONTABLES');
select pxp.f_insert_tgui_rol ('PROVCUEN.2.1', 'CONTA - Relaciones contables ELACIONES CONTABLES');
select pxp.f_insert_tgui_rol ('PROVCUEN.3', 'CONTA - Relaciones contables ELACIONES CONTABLES');
select pxp.f_insert_tgui_rol ('PROVCUEN.3.1', 'CONTA - Relaciones contables ELACIONES CONTABLES');
select pxp.f_insert_tgui_rol ('PROVCUEN.3.1.1', 'CONTA - Relaciones contables ELACIONES CONTABLES');
select pxp.f_insert_tgui_rol ('PLADOC', 'CONTA - Plantilla de Documentos');
select pxp.f_insert_tgui_rol ('DEFRECONCAR', 'CONTA - Plantilla de Documentos');
select pxp.f_insert_tgui_rol ('CONTA', 'CONTA - Plantilla de Documentos');
select pxp.f_insert_tgui_rol ('SISTEMA', 'CONTA - Plantilla de Documentos');
select pxp.f_insert_tgui_rol ('PLADOC.1', 'CONTA - Plantilla de Documentos');
select pxp.f_insert_tgui_rol ('PLADOC.1.1', 'CONTA - Plantilla de Documentos');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CONIG_INS', 'CONGASCUE');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CONIG_MOD', 'CONGASCUE');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CONIG_ELI', 'CONGASCUE');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CONIG_SEL', 'CONGASCUE');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CONIGPP_SEL', 'CONGASCUE');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CATCMB_SEL', 'CONGASCUE');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'SEG_SUBSIS_SEL', 'CONGASCUE.2');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_PACATI_SEL', 'CONGASCUE.2');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CAT_INS', 'CONGASCUE.2');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CAT_MOD', 'CONGASCUE.2');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CAT_ELI', 'CONGASCUE.2');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CAT_SEL', 'CONGASCUE.2');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CATCMB_SEL', 'CONGASCUE.2');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'CONTA_TIPRELCO_SEL', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'CONTA_RELCON_INS', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'CONTA_RELCON_MOD', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'CONTA_RELCON_ELI', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'CONTA_RELCON_SEL', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_GES_SEL', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CEC_SEL', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CECCOM_SEL', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CECCOMFU_SEL', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('Relación Contable Concepto Gasto', 'PM_CCFILDEP_SEL', 'CONGASCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA- Relación Contable Concepto Gasto', 'PM_CONIG_INS', 'CONGASCUE');
select pxp.f_insert_trol_procedimiento_gui ('CONTA- Relación Contable Concepto Gasto', 'PM_CONIG_MOD', 'CONGASCUE');
select pxp.f_insert_trol_procedimiento_gui ('CONTA- Relación Contable Concepto Gasto', 'PM_CONIG_ELI', 'CONGASCUE');
select pxp.f_insert_trol_procedimiento_gui ('CONTA- Relación Contable Concepto Gasto', 'PM_CONIG_SEL', 'CONGASCUE');
select pxp.f_insert_trol_procedimiento_gui ('CONTA- Relación Contable Concepto Gasto', 'PM_CONIGPP_SEL', 'CONGASCUE');
select pxp.f_insert_trol_procedimiento_gui ('CONTA- Relación Contable Concepto Gasto', 'PM_CATCMB_SEL', 'CONGASCUE');
select pxp.f_insert_trol_procedimiento_gui ('CONTA- Relación Contable Concepto Gasto', 'PRE_PAR_SEL', 'CONGASCUE');
select pxp.f_insert_trol_procedimiento_gui ('CONTA- Relación Contable Concepto Gasto', 'SEG_SUBSIS_SEL', 'CONGASCUE.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA- Relación Contable Concepto Gasto', 'PM_PACATI_SEL', 'CONGASCUE.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA- Relación Contable Concepto Gasto', 'PM_CAT_INS', 'CONGASCUE.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA- Relación Contable Concepto Gasto', 'PM_CAT_MOD', 'CONGASCUE.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA- Relación Contable Concepto Gasto', 'PM_CAT_ELI', 'CONGASCUE.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA- Relación Contable Concepto Gasto', 'PM_CAT_SEL', 'CONGASCUE.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA- Relación Contable Concepto Gasto', 'PM_CATCMB_SEL', 'CONGASCUE.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA- Relación Contable Concepto Gasto', 'CONTA_TIPRELCO_SEL', 'CONGASCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA- Relación Contable Concepto Gasto', 'CONTA_RELCON_INS', 'CONGASCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA- Relación Contable Concepto Gasto', 'CONTA_RELCON_MOD', 'CONGASCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA- Relación Contable Concepto Gasto', 'CONTA_RELCON_ELI', 'CONGASCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA- Relación Contable Concepto Gasto', 'CONTA_RELCON_SEL', 'CONGASCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA- Relación Contable Concepto Gasto', 'PM_GES_SEL', 'CONGASCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA- Relación Contable Concepto Gasto', 'PM_CEC_SEL', 'CONGASCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA- Relación Contable Concepto Gasto', 'PM_CECCOM_SEL', 'CONGASCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA- Relación Contable Concepto Gasto', 'PM_CECCOMFU_SEL', 'CONGASCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA- Relación Contable Concepto Gasto', 'PM_CCFILDEP_SEL', 'CONGASCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA- Relación Contable Concepto Gasto', 'CONTA_CTA_SEL', 'CONGASCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA- Relación Contable Concepto Gasto', 'CONTA_AUXCTA_SEL', 'CONGASCUE.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'CONTA_RELCON_INS', 'RELCONGEN.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'CONTA_RELCON_MOD', 'RELCONGEN.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'CONTA_RELCON_ELI', 'RELCONGEN.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'CONTA_RELCON_SEL', 'RELCONGEN.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'PM_GES_SEL', 'RELCONGEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'PM_LUG_SEL', 'PROVCUEN');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'PM_LUG_ARB_SEL', 'PROVCUEN');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'ADQ_PROVEE_INS', 'PROVCUEN');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'ADQ_PROVEE_MOD', 'PROVCUEN');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'ADQ_PROVEE_ELI', 'PROVCUEN');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'ADQ_PROVEE_SEL', 'PROVCUEN');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'SEG_PERSON_SEL', 'PROVCUEN');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'SEG_PERSONMIN_SEL', 'PROVCUEN');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'PM_INSTIT_SEL', 'PROVCUEN');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'CONTA_TIPRELCO_SEL', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'CONTA_RELCON_INS', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'CONTA_RELCON_MOD', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'CONTA_RELCON_ELI', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'CONTA_RELCON_SEL', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'PM_GES_SEL', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'PM_CEC_SEL', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'PM_CECCOM_SEL', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'PM_CECCOMFU_SEL', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'PM_CCFILDEP_SEL', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'SEG_PERSON_INS', 'PROVCUEN.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'SEG_PERSON_MOD', 'PROVCUEN.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'SEG_PERSON_ELI', 'PROVCUEN.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'SEG_PERSONMIN_SEL', 'PROVCUEN.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'SEG_UPFOTOPER_MOD', 'PROVCUEN.2.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'PM_INSTIT_INS', 'PROVCUEN.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'PM_INSTIT_MOD', 'PROVCUEN.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'PM_INSTIT_ELI', 'PROVCUEN.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'PM_INSTIT_SEL', 'PROVCUEN.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'SEG_PERSON_SEL', 'PROVCUEN.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'SEG_PERSONMIN_SEL', 'PROVCUEN.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'SEG_PERSON_INS', 'PROVCUEN.3.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'SEG_PERSON_MOD', 'PROVCUEN.3.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'SEG_PERSON_ELI', 'PROVCUEN.3.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'SEG_PERSONMIN_SEL', 'PROVCUEN.3.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'PRE_PAR_SEL', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'CONTA_CTA_SEL', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion Proveedor - Cuenta Contable', 'CONTA_AUXCTA_SEL', 'PROVCUEN.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_MONEDA_SEL', 'RELCCCB');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_INSTIT_SEL', 'RELCCCB');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CTABAN_INS', 'RELCCCB');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CTABAN_MOD', 'RELCCCB');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CTABAN_ELI', 'RELCCCB');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CTABAN_SEL', 'RELCCCB');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_TIPRELCO_SEL', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_INS', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_MOD', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_ELI', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_SEL', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_GES_SEL', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CEC_SEL', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CECCOM_SEL', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CECCOMFU_SEL', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CCFILDEP_SEL', 'RELCCCB.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CHQ_SEL', 'RELCCCB.2');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CHQ_INS', 'RELCCCB.2');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CHQ_MOD', 'RELCCCB.2');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CHQ_ELI', 'RELCCCB.2');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSONMIN_SEL', 'RELCCCB.3');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_SEL', 'RELCCCB.3');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_INSTIT_INS', 'RELCCCB.3');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_INSTIT_MOD', 'RELCCCB.3');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_INSTIT_ELI', 'RELCCCB.3');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_INSTIT_SEL', 'RELCCCB.3');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSONMIN_SEL', 'RELCCCB.3.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_ELI', 'RELCCCB.3.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_MOD', 'RELCCCB.3.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_INS', 'RELCCCB.3.1');
select pxp.f_delete_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_UPFOTOPER_MOD', 'RELCCCB.3.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_LUG_SEL', 'PROVCUEN');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_LUG_ARB_SEL', 'PROVCUEN');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'ADQ_PROVEE_INS', 'PROVCUEN');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'ADQ_PROVEE_MOD', 'PROVCUEN');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'ADQ_PROVEE_ELI', 'PROVCUEN');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'ADQ_PROVEE_SEL', 'PROVCUEN');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_SEL', 'PROVCUEN');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSONMIN_SEL', 'PROVCUEN');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_INSTIT_SEL', 'PROVCUEN');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_TIPRELCO_SEL', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_INS', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_MOD', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_ELI', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_SEL', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_GES_SEL', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CEC_SEL', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CECCOM_SEL', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CECCOMFU_SEL', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CCFILDEP_SEL', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PRE_PAR_SEL', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_CTA_SEL', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_AUXCTA_SEL', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSONMIN_SEL', 'PROVCUEN.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_ELI', 'PROVCUEN.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_MOD', 'PROVCUEN.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_INS', 'PROVCUEN.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_UPFOTOPER_MOD', 'PROVCUEN.2.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSONMIN_SEL', 'PROVCUEN.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_SEL', 'PROVCUEN.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_INSTIT_INS', 'PROVCUEN.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_INSTIT_MOD', 'PROVCUEN.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_INSTIT_ELI', 'PROVCUEN.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_INSTIT_SEL', 'PROVCUEN.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSONMIN_SEL', 'PROVCUEN.3.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_ELI', 'PROVCUEN.3.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_MOD', 'PROVCUEN.3.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_INS', 'PROVCUEN.3.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_UPFOTOPER_MOD', 'PROVCUEN.3.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CATCMB_SEL', 'RELCONGEN');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_TIPRELCO_INS', 'RELCONGEN');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_TIPRELCO_MOD', 'RELCONGEN');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_TIPRELCO_ELI', 'RELCONGEN');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_TIPRELCO_SEL', 'RELCONGEN');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_SUBSIS_SEL', 'RELCONGEN.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_PACATI_SEL', 'RELCONGEN.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CAT_SEL', 'RELCONGEN.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CATCMB_SEL', 'RELCONGEN.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CAT_INS', 'RELCONGEN.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CAT_MOD', 'RELCONGEN.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CAT_ELI', 'RELCONGEN.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_INS', 'RELCONGEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_MOD', 'RELCONGEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_ELI', 'RELCONGEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_SEL', 'RELCONGEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_GES_SEL', 'RELCONGEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CEC_SEL', 'RELCONGEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CECCOM_SEL', 'RELCONGEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CECCOMFU_SEL', 'RELCONGEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CCFILDEP_SEL', 'RELCONGEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CATCMB_SEL', 'CONGASCUE');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CONIG_SEL', 'CONGASCUE');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CONIG_INS', 'CONGASCUE');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CONIG_MOD', 'CONGASCUE');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CONIG_ELI', 'CONGASCUE');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PRE_PAR_SEL', 'CONGASCUE');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CONIGPP_SEL', 'CONGASCUE');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_SUBSIS_SEL', 'CONGASCUE.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_PACATI_SEL', 'CONGASCUE.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CAT_SEL', 'CONGASCUE.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CATCMB_SEL', 'CONGASCUE.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CAT_INS', 'CONGASCUE.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CAT_MOD', 'CONGASCUE.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CAT_ELI', 'CONGASCUE.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_TIPRELCO_SEL', 'CONGASCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_INS', 'CONGASCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_MOD', 'CONGASCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_ELI', 'CONGASCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_SEL', 'CONGASCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_GES_SEL', 'CONGASCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CEC_SEL', 'CONGASCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CECCOM_SEL', 'CONGASCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CECCOMFU_SEL', 'CONGASCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CCFILDEP_SEL', 'CONGASCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_CTA_SEL', 'CONGASCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_AUXCTA_SEL', 'CONGASCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_MONEDA_SEL', 'RELCCCB');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_INSTIT_SEL', 'RELCCCB');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CTABAN_INS', 'RELCCCB');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CTABAN_MOD', 'RELCCCB');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CTABAN_ELI', 'RELCCCB');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CTABAN_SEL', 'RELCCCB');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_TIPRELCO_SEL', 'RELCCCB.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_INS', 'RELCCCB.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_MOD', 'RELCCCB.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_ELI', 'RELCCCB.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_SEL', 'RELCCCB.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_GES_SEL', 'RELCCCB.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CEC_SEL', 'RELCCCB.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CECCOM_SEL', 'RELCCCB.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CECCOMFU_SEL', 'RELCCCB.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CCFILDEP_SEL', 'RELCCCB.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CHQ_SEL', 'RELCCCB.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CHQ_INS', 'RELCCCB.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CHQ_MOD', 'RELCCCB.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'TES_CHQ_ELI', 'RELCCCB.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSONMIN_SEL', 'RELCCCB.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_SEL', 'RELCCCB.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_INSTIT_INS', 'RELCCCB.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_INSTIT_MOD', 'RELCCCB.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_INSTIT_ELI', 'RELCCCB.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_INSTIT_SEL', 'RELCCCB.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSONMIN_SEL', 'RELCCCB.3.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_ELI', 'RELCCCB.3.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_MOD', 'RELCCCB.3.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_INS', 'RELCCCB.3.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_UPFOTOPER_MOD', 'RELCCCB.3.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_SUBSIS_SEL', 'DEPTCON');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_DEPPTO_INS', 'DEPTCON');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_DEPPTO_MOD', 'DEPTCON');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_DEPPTO_ELI', 'DEPTCON');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_DEPPTO_SEL', 'DEPTCON');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_DEPUSUCOMB_SEL', 'DEPTCON');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_DEPFILUSU_SEL', 'DEPTCON');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_DEPFILEPUO_SEL', 'DEPTCON');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_TIPRELCO_SEL', 'DEPTCON.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_INS', 'DEPTCON.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_MOD', 'DEPTCON.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_ELI', 'DEPTCON.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_SEL', 'DEPTCON.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_GES_SEL', 'DEPTCON.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CEC_SEL', 'DEPTCON.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CECCOM_SEL', 'DEPTCON.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CECCOMFU_SEL', 'DEPTCON.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CCFILDEP_SEL', 'DEPTCON.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_USUARI_SEL', 'DEPTCON.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_DEPUSU_SEL', 'DEPTCON.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_DEPUSU_INS', 'DEPTCON.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_DEPUSU_MOD', 'DEPTCON.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_DEPUSU_ELI', 'DEPTCON.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_LISTUSU_SEG', 'DEPTCON.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_SEL', 'DEPTCON.2.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSONMIN_SEL', 'DEPTCON.2.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_CLASIF_SEL', 'DEPTCON.2.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_ROL_SEL', 'DEPTCON.2.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_USUARI_INS', 'DEPTCON.2.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_USUARI_MOD', 'DEPTCON.2.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_USUARI_ELI', 'DEPTCON.2.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_USUARI_SEL', 'DEPTCON.2.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_LISTUSU_SEG', 'DEPTCON.2.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSONMIN_SEL', 'DEPTCON.2.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_ELI', 'DEPTCON.2.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_MOD', 'DEPTCON.2.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_INS', 'DEPTCON.2.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_UPFOTOPER_MOD', 'DEPTCON.2.1.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_USUROL_SEL', 'DEPTCON.2.1.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_USUROL_ELI', 'DEPTCON.2.1.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_USUROL_MOD', 'DEPTCON.2.1.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_USUROL_INS', 'DEPTCON.2.1.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_ROL_SEL', 'DEPTCON.2.1.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_GRU_SEL', 'DEPTCON.2.1.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SG_UEP_SEL', 'DEPTCON.2.1.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SG_UEP_INS', 'DEPTCON.2.1.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SG_UEP_MOD', 'DEPTCON.2.1.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SG_UEP_ELI', 'DEPTCON.2.1.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_DEPUO_SEL', 'DEPTCON.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_DEPUO_INS', 'DEPTCON.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_DEPUO_MOD', 'DEPTCON.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_DEPUO_ELI', 'DEPTCON.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'RH_UO_SEL', 'DEPTCON.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'RH_INIUOARB_SEL', 'DEPTCON.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_FRPP_SEL', 'DEPTCON.4');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_DEEP_INS', 'DEPTCON.4');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_DEEP_MOD', 'DEPTCON.4');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_DEEP_ELI', 'DEPTCON.4');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_DEEP_SEL', 'DEPTCON.4');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_FRPP_SEL', 'DEPTCON.5');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'RH_UO_SEL', 'DEPTCON.5');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'RH_INIUOARB_SEL', 'DEPTCON.5');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_DUE_INS', 'DEPTCON.5');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_DUE_MOD', 'DEPTCON.5');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_DUE_ELI', 'DEPTCON.5');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_DUE_SEL', 'DEPTCON.5');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_DOCUME_SEL', 'DEPTCON.6');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'RH_FUNCIOCAR_SEL', 'DEPTCON.6');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_FIR_INS', 'DEPTCON.6');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_FIR_MOD', 'DEPTCON.6');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_FIR_ELI', 'DEPTCON.6');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_FIR_SEL', 'DEPTCON.6');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_SWEST_MOD', 'ALMCUE');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_DEPPTO_SEL', 'ALMCUE');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_DEPUSUCOMB_SEL', 'ALMCUE');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_DEPFILUSU_SEL', 'ALMCUE');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_DEPFILEPUO_SEL', 'ALMCUE');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ALM_INS', 'ALMCUE');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ALM_MOD', 'ALMCUE');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ALM_ELI', 'ALMCUE');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ALM_SEL', 'ALMCUE');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_TIPRELCO_SEL', 'ALMCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_INS', 'ALMCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_MOD', 'ALMCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_ELI', 'ALMCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_SEL', 'ALMCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_GES_SEL', 'ALMCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CEC_SEL', 'ALMCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CECCOM_SEL', 'ALMCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CECCOMFU_SEL', 'ALMCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CCFILDEP_SEL', 'ALMCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_USUARI_SEL', 'ALMCUE.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ALMUSR_ELI', 'ALMCUE.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ALMUSR_MOD', 'ALMCUE.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ALMUSR_INS', 'ALMCUE.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ALMUSR_SEL', 'ALMCUE.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_LISTUSU_SEG', 'ALMCUE.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ALMITEM_SEL', 'ALMCUE.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ALMITEM_ELI', 'ALMCUE.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ALMITEM_MOD', 'ALMCUE.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ALMITEM_INS', 'ALMCUE.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ITEMNOTBASE_SEL', 'ALMCUE.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_MEVAL_SEL', 'ALMCUE.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'ALM_CLA_ARB_SEL', 'ALMCUE.3.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ARB_SEL', 'ALMCUE.3.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ITMSRCHARB_SEL', 'ALMCUE.3.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ITMALM_SEL', 'ALMCUE.3.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_GES_SEL', 'ALMCUE.6');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_MOVREPORT_SEL', 'ALMCUE.6');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ALMGES_SEL', 'ALMCUE.6');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ALMGES_INS', 'ALMCUE.6');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ALMGES_MOD', 'ALMCUE.6');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ALMGES_ELI', 'ALMCUE.6');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ACCGES_INS', 'ALMCUE.6');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_AGMOV_GET', 'ALMCUE.6');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_GETGES_ELI', 'ALMCUE.6.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_MOVREPORT_SEL', 'ALMCUE.6.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_MOVTIP_SEL', 'ALMCUE.6.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ALM_SEL', 'ALMCUE.6.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_FUNCIOCAR_SEL', 'ALMCUE.6.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_PROVEEV_SEL', 'ALMCUE.6.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_MOV_SEL', 'ALMCUE.6.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_DEPPTO_SEL', 'ALMCUE.6.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_DEPUSUCOMB_SEL', 'ALMCUE.6.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_DEPFILUSU_SEL', 'ALMCUE.6.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_DEPFILEPUO_SEL', 'ALMCUE.6.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_MOV_INS', 'ALMCUE.6.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_MOV_MOD', 'ALMCUE.6.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_MOV_ELI', 'ALMCUE.6.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_MOVCNL_MOD', 'ALMCUE.6.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_MOVREV_MOD', 'ALMCUE.6.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_MOVFIN_MOD', 'ALMCUE.6.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'WF_SIGEST_SEL', 'ALMCUE.6.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'WF_FUNTIPES_SEL', 'ALMCUE.6.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_MOVPRE_REV', 'ALMCUE.6.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CATCMB_SEL', 'ALMCUE.6.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'RH_FUNCIOCAR_SEL', 'ALMCUE.6.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'RH_FUNCIO_SEL', 'ALMCUE.6.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CONIG_SEL', 'ALMCUE.6.2.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ITEMNOTBASE_SEL', 'ALMCUE.6.2.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_MOVDET_INS', 'ALMCUE.6.2.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_MOVDET_MOD', 'ALMCUE.6.2.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_MOVDET_ELI', 'ALMCUE.6.2.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_MOVDET_SEL', 'ALMCUE.6.2.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CONIGPP_SEL', 'ALMCUE.6.2.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_DETVAL_SEL', 'ALMCUE.6.2.1.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'ALM_CLA_ARB_SEL', 'ALMCUE.6.2.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ARB_SEL', 'ALMCUE.6.2.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ITMSRCHARB_SEL', 'ALMCUE.6.2.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ITMALM_SEL', 'ALMCUE.6.2.1.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_ALARM_INS', 'ALMCUE.6.2.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_ALARM_MOD', 'ALMCUE.6.2.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_ALARM_ELI', 'ALMCUE.6.2.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_ALARMCOR_SEL', 'ALMCUE.6.2.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_ALARM_SEL', 'ALMCUE.6.2.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSONMIN_SEL', 'ALMCUE.6.2.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_SEL', 'ALMCUE.6.2.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'RH_FUNCIOCAR_SEL', 'ALMCUE.6.2.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'RH_FUNCIO_SEL', 'ALMCUE.6.2.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'RH_FUNCIO_ELI', 'ALMCUE.6.2.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'RH_FUNCIO_MOD', 'ALMCUE.6.2.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'RH_FUNCIO_INS', 'ALMCUE.6.2.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSONMIN_SEL', 'ALMCUE.6.2.3.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_ELI', 'ALMCUE.6.2.3.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_MOD', 'ALMCUE.6.2.3.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_INS', 'ALMCUE.6.2.3.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_UPFOTOPER_MOD', 'ALMCUE.6.2.3.2.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_INSTIT_SEL', 'ALMCUE.6.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'OR_FUNCUE_SEL', 'ALMCUE.6.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'OR_FUNCUE_INS', 'ALMCUE.6.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'OR_FUNCUE_MOD', 'ALMCUE.6.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'OR_FUNCUE_ELI', 'ALMCUE.6.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSONMIN_SEL', 'ALMCUE.6.2.3.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_SEL', 'ALMCUE.6.2.3.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_INSTIT_INS', 'ALMCUE.6.2.3.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_INSTIT_MOD', 'ALMCUE.6.2.3.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_INSTIT_ELI', 'ALMCUE.6.2.3.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_INSTIT_SEL', 'ALMCUE.6.2.3.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSONMIN_SEL', 'ALMCUE.6.2.3.1.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_ELI', 'ALMCUE.6.2.3.1.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_MOD', 'ALMCUE.6.2.3.1.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_PERSON_INS', 'ALMCUE.6.2.3.1.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_UPFOTOPER_MOD', 'ALMCUE.6.2.3.1.1.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_AGLOG_SEL', 'ALMCUE.6.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_AGLOG_INS', 'ALMCUE.6.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_AGLOG_MOD', 'ALMCUE.6.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_AGLOG_ELI', 'ALMCUE.6.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'ALM_CLA_ARB_SEL', 'CLACUE');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_CLA_ELI', 'CLACUE');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_CLA_MOD', 'CLACUE');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_CLA_INS', 'CLACUE');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ARB_SEL', 'CLACUE');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ESTCLA_MOD', 'CLACUE');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_CLADD_MOD', 'CLACUE');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_UME_SEL', 'CLACUE.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ITEM_ELI', 'CLACUE.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ITEM_MOD', 'CLACUE.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ITEM_INS', 'CLACUE.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ITEMNOTBASE_SEL', 'CLACUE.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ITEM_SEL', 'CLACUE.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_GENCODE_MOD', 'CLACUE.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ITMALM_SEL', 'CLACUE.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ITEMNOTBASE_SEL', 'CLACUE.2.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ITMREE_INS', 'CLACUE.2.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ITMREE_MOD', 'CLACUE.2.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ITMREE_ELI', 'CLACUE.2.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ITMREE_SEL', 'CLACUE.2.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'ALM_CLA_ARB_SEL', 'CLACUE.2.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ARB_SEL', 'CLACUE.2.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ITMSRCHARB_SEL', 'CLACUE.2.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ITMALM_SEL', 'CLACUE.2.1.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ITMARCH_SEL', 'CLACUE.2.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ITMARCH_INS', 'CLACUE.2.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ITMARCH_MOD', 'CLACUE.2.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_ITMARCH_ELI', 'CLACUE.2.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SAL_UPARCH_MOD', 'CLACUE.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_UME_SEL', 'CLACUE.2.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_UME_INS', 'CLACUE.2.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_UME_MOD', 'CLACUE.2.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_UME_ELI', 'CLACUE.2.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CATCMB_SEL', 'CLACUE.2.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'SEG_SUBSIS_SEL', 'CLACUE.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_PACATI_SEL', 'CLACUE.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CAT_SEL', 'CLACUE.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CATCMB_SEL', 'CLACUE.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CAT_INS', 'CLACUE.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CAT_MOD', 'CLACUE.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CAT_ELI', 'CLACUE.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_TIPRELCO_SEL', 'CLACUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_INS', 'CLACUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_MOD', 'CLACUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_ELI', 'CLACUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'CONTA_RELCON_SEL', 'CLACUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_GES_SEL', 'CLACUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CEC_SEL', 'CLACUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CECCOM_SEL', 'CLACUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CECCOMFU_SEL', 'CLACUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relacion cuenta Bancaria', 'PM_CCFILDEP_SEL', 'CLACUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_SUBSIS_SEL', 'DEPTCON');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_DEPPTO_INS', 'DEPTCON');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_DEPPTO_MOD', 'DEPTCON');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_DEPPTO_ELI', 'DEPTCON');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_DEPPTO_SEL', 'DEPTCON');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_DEPUSUCOMB_SEL', 'DEPTCON');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_DEPFILUSU_SEL', 'DEPTCON');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_DEPFILEPUO_SEL', 'DEPTCON');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'CONTA_TIPRELCO_SEL', 'DEPTCON.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'CONTA_RELCON_INS', 'DEPTCON.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'CONTA_RELCON_MOD', 'DEPTCON.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'CONTA_RELCON_ELI', 'DEPTCON.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'CONTA_RELCON_SEL', 'DEPTCON.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_GES_SEL', 'DEPTCON.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_CEC_SEL', 'DEPTCON.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_CECCOM_SEL', 'DEPTCON.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_CECCOMFU_SEL', 'DEPTCON.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_CCFILDEP_SEL', 'DEPTCON.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_USUARI_SEL', 'DEPTCON.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_DEPUSU_SEL', 'DEPTCON.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_DEPUSU_INS', 'DEPTCON.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_DEPUSU_MOD', 'DEPTCON.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_DEPUSU_ELI', 'DEPTCON.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_LISTUSU_SEG', 'DEPTCON.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_PERSON_SEL', 'DEPTCON.2.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_PERSONMIN_SEL', 'DEPTCON.2.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_CLASIF_SEL', 'DEPTCON.2.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_ROL_SEL', 'DEPTCON.2.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_USUARI_INS', 'DEPTCON.2.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_USUARI_MOD', 'DEPTCON.2.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_USUARI_ELI', 'DEPTCON.2.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_USUARI_SEL', 'DEPTCON.2.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_LISTUSU_SEG', 'DEPTCON.2.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_PERSONMIN_SEL', 'DEPTCON.2.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_PERSON_ELI', 'DEPTCON.2.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_PERSON_MOD', 'DEPTCON.2.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_PERSON_INS', 'DEPTCON.2.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_UPFOTOPER_MOD', 'DEPTCON.2.1.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_USUROL_SEL', 'DEPTCON.2.1.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_USUROL_ELI', 'DEPTCON.2.1.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_USUROL_MOD', 'DEPTCON.2.1.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_USUROL_INS', 'DEPTCON.2.1.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_ROL_SEL', 'DEPTCON.2.1.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_GRU_SEL', 'DEPTCON.2.1.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SG_UEP_SEL', 'DEPTCON.2.1.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SG_UEP_INS', 'DEPTCON.2.1.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SG_UEP_MOD', 'DEPTCON.2.1.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SG_UEP_ELI', 'DEPTCON.2.1.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_DEPUO_SEL', 'DEPTCON.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_DEPUO_INS', 'DEPTCON.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_DEPUO_MOD', 'DEPTCON.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_DEPUO_ELI', 'DEPTCON.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'RH_UO_SEL', 'DEPTCON.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'RH_INIUOARB_SEL', 'DEPTCON.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_FRPP_SEL', 'DEPTCON.4');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_DEEP_INS', 'DEPTCON.4');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_DEEP_MOD', 'DEPTCON.4');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_DEEP_ELI', 'DEPTCON.4');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_DEEP_SEL', 'DEPTCON.4');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_FRPP_SEL', 'DEPTCON.5');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'RH_UO_SEL', 'DEPTCON.5');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'RH_INIUOARB_SEL', 'DEPTCON.5');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_DUE_INS', 'DEPTCON.5');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_DUE_MOD', 'DEPTCON.5');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_DUE_ELI', 'DEPTCON.5');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_DUE_SEL', 'DEPTCON.5');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_DOCUME_SEL', 'DEPTCON.6');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'RH_FUNCIOCAR_SEL', 'DEPTCON.6');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_FIR_INS', 'DEPTCON.6');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_FIR_MOD', 'DEPTCON.6');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_FIR_ELI', 'DEPTCON.6');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_FIR_SEL', 'DEPTCON.6');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_CATCMB_SEL', 'RELCONGEN');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'CONTA_TIPRELCO_INS', 'RELCONGEN');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'CONTA_TIPRELCO_MOD', 'RELCONGEN');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'CONTA_TIPRELCO_ELI', 'RELCONGEN');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'CONTA_TIPRELCO_SEL', 'RELCONGEN');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_SUBSIS_SEL', 'RELCONGEN.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_PACATI_SEL', 'RELCONGEN.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_CAT_SEL', 'RELCONGEN.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_CATCMB_SEL', 'RELCONGEN.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_CAT_INS', 'RELCONGEN.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_CAT_MOD', 'RELCONGEN.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_CAT_ELI', 'RELCONGEN.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'CONTA_RELCON_INS', 'RELCONGEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'CONTA_RELCON_MOD', 'RELCONGEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'CONTA_RELCON_ELI', 'RELCONGEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'CONTA_RELCON_SEL', 'RELCONGEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_GES_SEL', 'RELCONGEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_CEC_SEL', 'RELCONGEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_CECCOM_SEL', 'RELCONGEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_CECCOMFU_SEL', 'RELCONGEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_CCFILDEP_SEL', 'RELCONGEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_CATCMB_SEL', 'CONGASCUE');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_CONIG_SEL', 'CONGASCUE');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_CONIG_INS', 'CONGASCUE');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_CONIG_MOD', 'CONGASCUE');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_CONIG_ELI', 'CONGASCUE');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PRE_PAR_SEL', 'CONGASCUE');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_CONIGPP_SEL', 'CONGASCUE');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_SUBSIS_SEL', 'CONGASCUE.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_PACATI_SEL', 'CONGASCUE.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_CAT_SEL', 'CONGASCUE.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_CATCMB_SEL', 'CONGASCUE.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_CAT_INS', 'CONGASCUE.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_CAT_MOD', 'CONGASCUE.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_CAT_ELI', 'CONGASCUE.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'CONTA_TIPRELCO_SEL', 'CONGASCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'CONTA_RELCON_INS', 'CONGASCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'CONTA_RELCON_MOD', 'CONGASCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'CONTA_RELCON_ELI', 'CONGASCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'CONTA_RELCON_SEL', 'CONGASCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_GES_SEL', 'CONGASCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_CEC_SEL', 'CONGASCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_CECCOM_SEL', 'CONGASCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_CECCOMFU_SEL', 'CONGASCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_CCFILDEP_SEL', 'CONGASCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'CONTA_CTA_SEL', 'CONGASCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'CONTA_AUXCTA_SEL', 'CONGASCUE.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_LUG_SEL', 'PROVCUEN');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_LUG_ARB_SEL', 'PROVCUEN');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'ADQ_PROVEE_INS', 'PROVCUEN');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'ADQ_PROVEE_MOD', 'PROVCUEN');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'ADQ_PROVEE_ELI', 'PROVCUEN');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'ADQ_PROVEE_SEL', 'PROVCUEN');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_PERSON_SEL', 'PROVCUEN');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_PERSONMIN_SEL', 'PROVCUEN');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_INSTIT_SEL', 'PROVCUEN');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'CONTA_TIPRELCO_SEL', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'CONTA_RELCON_INS', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'CONTA_RELCON_MOD', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'CONTA_RELCON_ELI', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'CONTA_RELCON_SEL', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_GES_SEL', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_CEC_SEL', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_CECCOM_SEL', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_CECCOMFU_SEL', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_CCFILDEP_SEL', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PRE_PAR_SEL', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'CONTA_CTA_SEL', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'CONTA_AUXCTA_SEL', 'PROVCUEN.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_PERSONMIN_SEL', 'PROVCUEN.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_PERSON_ELI', 'PROVCUEN.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_PERSON_MOD', 'PROVCUEN.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_PERSON_INS', 'PROVCUEN.2');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_UPFOTOPER_MOD', 'PROVCUEN.2.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_PERSONMIN_SEL', 'PROVCUEN.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_PERSON_SEL', 'PROVCUEN.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_INSTIT_INS', 'PROVCUEN.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_INSTIT_MOD', 'PROVCUEN.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_INSTIT_ELI', 'PROVCUEN.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'PM_INSTIT_SEL', 'PROVCUEN.3');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_PERSONMIN_SEL', 'PROVCUEN.3.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_PERSON_ELI', 'PROVCUEN.3.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_PERSON_MOD', 'PROVCUEN.3.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_PERSON_INS', 'PROVCUEN.3.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Relaciones contables ELACIONES CONTABLES', 'SEG_UPFOTOPER_MOD', 'PROVCUEN.3.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Plantilla de Documentos', 'PM_PLT_SEL', 'PLADOC');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Plantilla de Documentos', 'PM_PLT_INS', 'PLADOC');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Plantilla de Documentos', 'PM_PLT_MOD', 'PLADOC');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Plantilla de Documentos', 'PM_PLT_ELI', 'PLADOC');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Plantilla de Documentos', 'PM_CATCMB_SEL', 'PLADOC.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Plantilla de Documentos', 'CONTA_PLACAL_SEL', 'PLADOC.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Plantilla de Documentos', 'CONTA_TIPRELCO_SEL', 'PLADOC.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Plantilla de Documentos', 'CONTA_PLACAL_INS', 'PLADOC.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Plantilla de Documentos', 'CONTA_PLACAL_MOD', 'PLADOC.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Plantilla de Documentos', 'CONTA_PLACAL_ELI', 'PLADOC.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Plantilla de Documentos', 'CONTA_GETDEC_IME', 'PLADOC.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Plantilla de Documentos', 'SEG_SUBSIS_SEL', 'PLADOC.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Plantilla de Documentos', 'PM_PACATI_SEL', 'PLADOC.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Plantilla de Documentos', 'PM_CAT_SEL', 'PLADOC.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Plantilla de Documentos', 'PM_CATCMB_SEL', 'PLADOC.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Plantilla de Documentos', 'PM_CAT_INS', 'PLADOC.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Plantilla de Documentos', 'PM_CAT_MOD', 'PLADOC.1.1');
select pxp.f_insert_trol_procedimiento_gui ('CONTA - Plantilla de Documentos', 'PM_CAT_ELI', 'PLADOC.1.1');

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

CREATE TRIGGER f_trig_insert_int_trans_val
  AFTER INSERT OR UPDATE 
  ON conta.tint_transaccion FOR EACH ROW 
  EXECUTE PROCEDURE conta.f_insert_int_trans_val();


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


/***********************************I-DEP-RAC-CONTA-0-16/04/2015*****************************************/



--------------- SQL ---------------

CREATE OR REPLACE VIEW tes.vcomp_devtesprov_plan_pago(
    id_plan_pago,
    id_proveedor,
    desc_proveedor,
    id_moneda,
    id_depto_conta,
    numero,
    fecha_actual,
    estado,
    monto_ejecutar_total_mb,
    monto_ejecutar_total_mo,
    monto,
    monto_mb,
    monto_retgar_mb,
    monto_retgar_mo,
    monto_no_pagado,
    monto_no_pagado_mb,
    otros_descuentos,
    otros_descuentos_mb,
    id_plantilla,
    id_cuenta_bancaria,
    id_cuenta_bancaria_mov,
    nro_cheque,
    nro_cuenta_bancaria,
    num_tramite,
    tipo,
    id_gestion_cuentas,
    id_int_comprobante,
    liquido_pagable,
    liquido_pagable_mb,
    nombre_pago,
    porc_monto_excento_var,
    obs_pp,
    descuento_anticipo,
    descuento_inter_serv,
    tipo_obligacion,
    id_categoria_compra,
    codigo_categoria,
    nombre_categoria,
    id_proceso_wf,
    forma_pago,
    monto_ajuste_ag,
    monto_ajuste_siguiente_pago,
    monto_anticipo,
    tipo_cambio_conv)
AS
  SELECT pp.id_plan_pago,
         op.id_proveedor,
         p.desc_proveedor,
         op.id_moneda,
         op.id_depto_conta,
         op.numero,
         now() AS fecha_actual,
         pp.estado,
         pp.monto_ejecutar_total_mb,
         pp.monto_ejecutar_total_mo,
         pp.monto,
         pp.monto_mb,
         pp.monto_retgar_mb,
         pp.monto_retgar_mo,
         pp.monto_no_pagado,
         pp.monto_no_pagado_mb,
         pp.otros_descuentos,
         pp.otros_descuentos_mb,
         pp.id_plantilla,
         pp.id_cuenta_bancaria,
         pp.id_cuenta_bancaria_mov,
         pp.nro_cheque,
         pp.nro_cuenta_bancaria,
         op.num_tramite,
         pp.tipo,
         op.id_gestion AS id_gestion_cuentas,
         pp.id_int_comprobante,
         pp.liquido_pagable,
         pp.liquido_pagable_mb,
         pp.nombre_pago,
         pp.porc_monto_excento_var,
         ((COALESCE(op.numero, ''::character varying)::text || ' '::text) ||
           COALESCE(pp.obs_monto_no_pagado, ''::text))::character varying AS
           obs_pp,
         pp.descuento_anticipo,
         pp.descuento_inter_serv,
         op.tipo_obligacion,
         op.id_categoria_compra,
         COALESCE(cac.codigo, ''::character varying) AS codigo_categoria,
         COALESCE(cac.nombre, ''::character varying) AS nombre_categoria,
         pp.id_proceso_wf,
         pp.forma_pago,
         pp.monto_ajuste_ag,
         pp.monto_ajuste_siguiente_pago,
         pp.monto_anticipo,
         op.tipo_cambio_conv,
         pp.id_depto_lb as id_depto_libro
  FROM tes.tplan_pago pp
       JOIN tes.tobligacion_pago op ON pp.id_obligacion_pago =
         op.id_obligacion_pago
       JOIN param.vproveedor p ON p.id_proveedor = op.id_proveedor
       LEFT JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra =
         op.id_categoria_compra;
         
/***********************************F-DEP-RAC-CONTA-0-16/04/2015*****************************************/
