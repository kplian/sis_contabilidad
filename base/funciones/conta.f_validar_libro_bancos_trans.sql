--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_validar_libro_bancos_trans (
  p_id_int_transaccion integer,
  p_operacion varchar
)
RETURNS boolean AS
$body$
/*
	Autor: RAC
    Fecha: 25-03-2020
    Descripción: esta funciona vlaida si la trasaccion es de banco que no tenga un cheque relacionado
 
  ***************************************************************************************************   
    

    HISTORIAL DE MODIFICACIONES:
   	
 ISSUE            FECHA:		      AUTOR                 DESCRIPCION
   
 #110        		25-03-2020        RAC KPLIAN        creacion

*/
DECLARE

	
    v_nombre_funcion   				varchar;
    v_resp			                varchar;
    v_registros                     record;
    v_reg_basicos                   record;    
    v_conta_integrar_libro_bancos   varchar; 
    v_conta_generar_lb_manual_oc    varchar;
    v_contador                      integer;
    v_valor                         varchar;
   

BEGIN

  v_nombre_funcion:='conta.f_validar_libro_bancos_trans';
  
  
  --ver si tiene libro de bancos ....
  v_conta_integrar_libro_bancos = pxp.f_get_variable_global('conta_integrar_libro_bancos');
  v_conta_generar_lb_manual_oc =  pxp.f_get_variable_global('conta_generar_lb_manual_oc');
  
  select 
      cbt.id_int_comprobante,
      dep.prioridad,
      dep.id_depto,
      cc.codigo,
      pla.codigo as codigo_plantilla,
      it.importe_haber,
      it.banco,
      it.forma_pago
  into v_registros
  from conta.tint_transaccion it
  join conta.tint_comprobante cbt on  cbt.id_int_comprobante = it.id_int_comprobante
  join param.tdepto dep on dep.id_depto = cbt.id_depto
  join conta.tclase_comprobante cc on cc.id_clase_comprobante = cbt.id_clase_comprobante
  left join conta.tplantilla_comprobante pla on pla.id_plantilla_comprobante=cbt.id_plantilla_comprobante        
  where it.id_int_transaccion = p_id_int_transaccion;
  
  
  v_valor = param.f_get_depto_param( v_registros.id_depto, 'ENTREGA');
  
 -- verificar si la trasaccion es de una cuenta contable  de bancos  
  
 --si es un cbte de pago ...
 IF upper(v_registros.codigo) in ('PAGO','PAGOCON','INGRESO','INGRESOCON') THEN
                   
      IF v_registros.banco = 'si'  THEN

             
             IF (v_conta_integrar_libro_bancos = 'si' AND v_valor='NO') OR (v_conta_integrar_libro_bancos='si' AND v_registros.codigo_plantilla in ('SOLFONDAV', 'REPOCAJA','CD-DEVREP-SALDOS')) THEN
                                   
                  --#108 genera  registros en LB solo si la generacion manual esta desactiva y si no es un depto de contabilidad central (prioridad 0)
                  IF v_conta_generar_lb_manual_oc = 'si' OR v_registros.prioridad = 0  THEN                      
                     
                      -- los comprobante pueden ser o de salida o de ingeso  o de ingeso y egreso en el caso de trapasos 
                      v_contador := 0;
                      IF v_registros.importe_haber > 0 THEN
                         -- verifica salida de bancos
                         SELECT count(lb.id_libro_bancos) into v_contador
                         FROM tes.tts_libro_bancos lb
                         WHERE     lb.id_int_comprobante = v_registros.id_int_comprobante 
                               and lb.tipo in ('cheque', 'debito_automatico', 'transferencia_carta');
                      
                      ELSE
                         --verifica ingreso a bancos
                          SELECT count(lb.id_libro_bancos) into v_contador
                          FROM tes.tts_libro_bancos lb
                          WHERE     lb.id_int_comprobante = v_registros.id_int_comprobante 
                                and lb.tipo in ('deposito');
                      
                      END IF;
                      
                      IF v_contador > 0 THEN
                         raise exception 'La transacción  tiene relacionada % registros en libro de bancos, no puede %.  Elimine el registro en libro de bancos primero', v_contador, p_operacion;
                      END IF;
                                    
                  END IF;
             END IF;
      END IF;
  END IF;
    
  
  return true;

EXCEPTION
WHEN OTHERS THEN
	
			v_resp='';
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
			v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
			v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
			raise exception '%',v_resp;
   
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
PARALLEL UNSAFE
COST 100;