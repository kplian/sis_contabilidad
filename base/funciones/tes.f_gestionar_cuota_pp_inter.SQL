--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_gestionar_cuota_pp_inter (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_int_comprobante integer,
  p_conexion varchar = NULL::character varying,
  p_id_cbte_regional integer = NULL::integer,
  p_codigo_estacion_origen varchar = NULL::character varying
)
RETURNS boolean AS
$body$
/*

Autor: RAC KPLIAN
Fecha:   27 junio de 2015
Descripcion  Cuando el comprobante internaciones validado:
               -  cambia de estado el plan de pagos
               -  cambiar las banderas del comprobante temporal
               -  migra el cbte temporal a endesis
    

*/


DECLARE

	v_nombre_funcion   	text;
	v_resp				varchar;
    
    
    v_registros 		record;
    
    v_id_estado_actual  integer;
    
    
    va_id_tipo_estado integer[];
    va_codigo_estado varchar[];
    va_disparador    varchar[];
    va_regla         varchar[]; 
    va_prioridad     integer[];
    
    v_tipo_sol   varchar;
    v_sincronizar 	varchar;
    v_resp_int_endesis 	varchaR;
    
    v_nro_cuota numeric;
    
     v_id_proceso_wf integer;
     v_id_estado_wf integer;
     v_codigo_estado varchar;
     v_id_plan_pago integer;
     v_verficacion  boolean;
     v_verficacion2  varchar[];
     
     v_id_tipo_estado  integer;
     v_codigo_proceso_llave_wf   varchar;
	 --gonzalo
     v_id_finalidad		integer;
     v_respuesta_libro_bancos varchar;
    
BEGIN


  

	v_nombre_funcion = 'tes.f_gestionar_cuota_pp_inter';
    
    
    
    -- 1) con el id_comprobante identificar el plan de pago
   
      select 
      pp.id_plan_pago,
      pp.id_estado_wf,
      pp.id_proceso_wf,
      pp.tipo,
      pp.estado,
      pp.id_plan_pago_fk,
      pp.id_obligacion_pago,
      pp.nro_cuota,
      pp.id_plantilla,
      pp.monto_ejecutar_total_mo,
      pp.monto_no_pagado,
      pp.liquido_pagable,
     
      op.id_depto ,
      op.pago_variable,
      pp.id_cuenta_bancaria ,
      pp.nombre_pago,
      pp.forma_pago,
      pp.tipo_cambio,
      pp.tipo_pago,
      pp.fecha_tentativa,
      pp.otros_descuentos,
      pp.monto_retgar_mo,
      
      pp.descuento_ley,
      pp.obs_descuentos_ley,
      pp.porc_descuento_ley,
      op.id_depto_conta,
      pp.id_cuenta_bancaria_mov,
      pp.nro_cheque,
      pp.nro_cuenta_bancaria,
      op.numero,
      pp.obs_descuentos_anticipo,
      pp.obs_descuentos_ley,
      pp.obs_monto_no_pagado,
      pp.obs_otros_descuentos,
      tpp.codigo_plantilla_comprobante,
      pp.descuento_inter_serv,             --descuento por intercambio de servicios
      pp.obs_descuento_inter_serv,
      pp.porc_monto_retgar,
      pp.descuento_anticipo,
      pp.monto_anticipo,
	  pp.id_depto_lb,
      pp.id_depto_conta,
	  dpc.prioridad as prioridad_conta,
      dpl.prioridad as prioridad_libro,
      c.temporal
      into
      v_registros
      from  tes.tplan_pago pp
      inner join tes.tobligacion_pago  op on op.id_obligacion_pago = pp.id_obligacion_pago and op.estado_reg = 'activo'
      inner join tes.ttipo_plan_pago tpp on tpp.codigo = pp.tipo and tpp.estado_reg = 'activo'
      inner join conta.tint_comprobante  c on c.id_int_comprobante = pp.id_int_comprobante 
	  left join param.tdepto dpc on dpc.id_depto=pp.id_depto_conta
	  left join param.tdepto dpl on dpl.id_depto=pp.id_depto_lb
      where  pp.id_int_comprobante = p_id_int_comprobante; 
    
    
    --2) Validar que tenga un plan de pago
    
    
     IF  v_registros.id_plan_pago is NULL  THEN
     
        raise exception 'El comprobante no esta relacionado con nigun plan de pagos';
     
     END IF;
    
    
    
          --------------------------------------------------------
          ---  cambiar el estado de la cuota                 -----
          --------------------------------------------------------
        
        
          -- obtiene el siguiente estado del flujo 
               SELECT 
                   *
                into
                  va_id_tipo_estado,
                  va_codigo_estado,
                  va_disparador,
                  va_regla,
                  va_prioridad
              
              FROM wf.f_obtener_estado_wf(v_registros.id_proceso_wf, v_registros.id_estado_wf,NULL,'siguiente');
              
              
              --raise exception '--  % ,  % ,% ',v_id_proceso_wf,v_id_estado_wf,va_codigo_estado;
              
              
              IF va_codigo_estado[2] is not null THEN
              
               raise exception 'El proceso de WF esta mal parametrizado,  solo admite un estado siguiente para el estado: %', v_registros.estado;
              
              END IF;
              
               IF va_codigo_estado[1] is  null THEN
              
               raise exception 'El proceso de WF esta mal parametrizado, no se encuentra el estado siguiente,  para el estado: %', v_registros.estado;           
              END IF;
              
              
            
              
              -- estado siguiente
               v_id_estado_actual =  wf.f_registra_estado_wf(va_id_tipo_estado[1], 
                                                             NULL, 
                                                             v_registros.id_estado_wf, 
                                                             v_registros.id_proceso_wf,
                                                             p_id_usuario,
                                                             p_id_usuario_ai, -- id_usuario_ai
                                                             p_usuario_ai, -- usuario_ai
                                                             v_registros.id_depto,
                                                             'Comprobante con tpp codigo:('||v_registros.tipo||') fue validado');
              
              -- actualiza estado en la solicitud
            
              update tes.tplan_pago pp  set 
                   id_estado_wf =  v_id_estado_actual,
                   estado = va_codigo_estado[1],
                   id_usuario_mod=p_id_usuario,
                   fecha_mod=now(),
                   fecha_dev = now(),
                   fecha_pag = now(),
                   id_usuario_ai = p_id_usuario_ai,
                   usuario_ai = p_usuario_ai
                 where id_plan_pago  = v_registros.id_plan_pago; 
             
          
          
             ----------------------------------------
             --  Actuliza las bandera de cbte temporal
             ------------------------------------------
              
              UPDATE  conta.tint_comprobante a  SET 
                    vbregional = 'si',
                    id_int_comprobante_origen_central = p_id_cbte_regional,
                    codigo_estacion_origen =  p_codigo_estacion_origen  
              WHERE  id_int_comprobante = p_id_int_comprobante ;
              
              
              
              ------------------------------------
              --  TODO, valida cambios en el cbte
              ------------------------------------
         
     
               --todo
          
			  --------------------------------------
              --  Migra el comprobante a ENDESIS
              -------------------------------------
              --Si la sincronizacion esta habilitada
              v_sincronizar = pxp.f_get_variable_global('sincronizar');
              IF(v_sincronizar='true')THEN
            	   -- si sincroniza locamente con endesis
                   v_resp_int_endesis =  migra.f_migrar_cbte_endesis(p_id_int_comprobante, p_conexion);
              END IF;
              

  
RETURN  TRUE;



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
COST 100;