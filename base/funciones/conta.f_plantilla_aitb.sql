--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_plantilla_aitb (
  p_id_usuario integer,
  p_id_int_comprobante integer,
  p_id_gestion_cbte integer,
  p_desde date,
  p_hasta date,
  p_id_depto integer
)
RETURNS void AS
$body$
DECLARE
 v_nombre_funcion   			text;
 v_resp							varchar;
 v_total_haber   				numeric;
 v_total_debe	 				numeric;
 v_resp_deudor  				numeric[];
 v_resp_acreedor  				numeric[];
 v_registros					record;
 v_reg_cbte						record;
 sw_saldo_acredor               boolean;
 v_sw_actualiza              	boolean;
 v_saldo_ma   					numeric;
 v_saldo_mb   					numeric;
 v_id_moneda_base				integer;
 v_id_moneda_act				integer;
 v_aux_actualizado_mb			numeric;
 v_diferencia					numeric;
 v_total_dif					numeric;
 v_diferencia_positiva			boolean;
 v_importe_haber				numeric;
 v_importe_debe					numeric;
 
 v_ajuste_debe					numeric;
 v_ajuste_haber					numeric;
 v_id_centro_costo_depto		integer;
 v_id_cuenta					integer;
 v_id_partida					integer;
 
  
BEGIN
  
    v_nombre_funcion = 'conta.f_plantilla_aitb';    
    v_total_haber = 0;
    v_total_debe = 0;
    v_ajuste_debe = 0;
    v_ajuste_haber = 0;
    
    v_id_moneda_base = param.f_get_moneda_base();
    v_id_moneda_act  = param.f_get_moneda_actualizacion();
  
    select
      *
    into
      v_reg_cbte
    from conta.tint_comprobante c
    where c.id_int_comprobante = p_id_int_comprobante;
    
    -- 1) FOR listar todas las cuentas que actualizan desde contabilidad de la gestion
    
    FOR v_registros in (
    					select 
                            c.id_cuenta,
                            c.tipo_act
                        from conta.tcuenta c 
                        where c.id_gestion = p_id_gestion_cbte
                              and c.sw_transaccional = 'movimiento'
                              and c.estado_reg = 'activo' 
                              and c.tipo_act = 'conta' )LOOP
                              
                   
        --   mayor deudor  de la cuenta
        v_resp_deudor = NULL;
        v_resp_acreedor = NULL;
      
        v_resp_deudor = conta.f_mayor_cuenta(v_registros.id_cuenta, 
                                           p_desde, 
        								   p_hasta, 
                                           p_id_depto::varchar, 
                                           'si',
                                           'todos',          --  p_incluir_cierre
                                           'todos',          --  p_incluir_aitb, 
                                           'defecto_cuenta', -- p_signo_balance, 
                                           'deudor', --  p_tipo_saldo,
                                            null,--p_id_int_comprobante_ori,
                                            NULL,--id_ot
                                            null -- p_id_centro_costo
                                           );
          
        --mayor acredor                                 
         v_resp_acreedor = conta.f_mayor_cuenta(v_registros.id_cuenta, 
                                           p_desde, 
        								   p_hasta, 
                                           p_id_depto::varchar, 
                                           'si',
                                           'todos',          --  p_incluir_cierre
                                           'todos',          --  p_incluir_aitb, 
                                           'defecto_cuenta', -- p_signo_balance, 
                                           'acreedor', --  p_tipo_saldo,
                                            null,--p_id_int_comprobante_ori,
                                            NULL,--id_ot
                                            null -- p_id_centro_costo
                                           ); 
                                           
          v_sw_actualiza = false;
          v_diferencia_positiva = false;                                                                 
                                                         
         IF v_resp_acreedor[5]  >  v_resp_deudor[5]  THEN
           sw_saldo_acredor = true;
           v_sw_actualiza = true;
           v_saldo_ma = v_resp_acreedor[5] - v_resp_deudor[5];
           v_saldo_mb = v_resp_acreedor[5] - v_resp_deudor[5];
         
         ELSEIF  v_resp_acreedor[5]  <  v_resp_deudor[5]  THEN
           sw_saldo_acredor = true;
           v_sw_actualiza = true;
           v_saldo_ma = v_resp_deudor[5] - v_resp_acreedor[5];
           v_saldo_mb = v_resp_deudor[5] - v_resp_acreedor[5];
         
         ELSE
           raise notice 'no es necesario actualizar  esta cuenta % por que su saldo es cero', v_registros.id_cuenta;
           v_sw_actualiza = false;
         END IF; 
         
        
        
        IF  v_sw_actualiza THEN                                           
        
              ------------------------------------------------------------
              -- determinar diferencia por inflación  (perdida o ganacia)
              ------------------------------------------------------------
                
              --covertir Moneda de actulizacion a moenda base
              
              v_aux_actualizado_mb = param.f_convertir_moneda (v_id_moneda_act, 
                                        v_id_moneda_base,    
                                        v_saldo_ma,  
                                        v_reg_cbte.fecha, 'O',2, 1, 'no');
              
             
             --determinar la diferencia
               IF v_aux_actualizado_mb  > v_saldo_mb THEN
               
                  v_diferencia  =  v_aux_actualizado_mb - v_saldo_mb;
                  v_diferencia_positiva = true;
                  v_sw_actualiza = true;
                   
               ELSEIF v_saldo_mb > v_aux_actualizado_mb THEN
               
                  v_diferencia  =  v_aux_actualizado_mb - v_saldo_mb;
                  v_diferencia_positiva = false;
                  v_sw_actualiza = true;
                  
               ELSE
                  v_sw_actualiza = false;   
               END IF;
                
              ------------------------------------
              --  insertar trasacción de ajuste
              ------------------------------------
              
              v_importe_debe = 0;
              v_importe_haber = 0;
              
              IF v_sw_actualiza THEN
                  
                  
                  --  segun el tipo y el signo determinamos si va al debe o al haber 
                  IF sw_saldo_acredor THEN
                     IF v_diferencia_positiva THEN
                        v_importe_haber = v_diferencia;
                        v_importe_debe = 0;
                     ELSE
                        v_importe_haber = 0;
                        v_importe_debe = v_diferencia;
                     
                     END IF;
                  ELSE
                     IF v_diferencia_positiva THEN
                        v_importe_haber = 0;
                        v_importe_debe = v_diferencia;
                     ELSE
                        v_importe_haber = v_diferencia;
                        v_importe_debe = 0;
                     END IF;
                  END IF;
                  
                  -- acumular el total de perdida o ganacia 
                  
                  v_total_haber = v_total_haber + v_importe_haber; 
                  v_total_debe = v_total_debe + v_importe_debe;
                  
                  
                  --  determinar el centro de costos donde se carga la perdida o ganancia
                  
                  --  determinar la partida  y cuenta
                  
                  --  insertar transaccion de actualización para la cuenta, 
                  
                  insert into conta.tint_transaccion(
                              id_partida,
                              id_centro_costo,
                              estado_reg,
                              id_cuenta,
                              glosa,
                              id_int_comprobante,
                              id_auxiliar,
                              importe_debe,
                              importe_haber,
                              importe_gasto,
                              importe_recurso,
                              importe_debe_mb,
                              importe_haber_mb,
                              importe_gasto_mb,
                              importe_recurso_mb,
                              
                              importe_debe_mt,
                              importe_haber_mt,
                              importe_gasto_mt,
                              importe_recurso_mt,
                              
                              importe_debe_ma,
                              importe_haber_ma,
                              importe_gasto_ma,
                              importe_recurso_ma,
                              
                              id_usuario_reg,
                              fecha_reg,
                              actualizacion
                          ) values(
                              v_id_partida,
                              v_id_centro_costo_depto,
                              'activo',
                              v_id_cuenta,
                              'Ajsute por actualización de moneda',  --glosa
                              p_id_int_comprobante,
                              NULL,--v_registros.id_auxiliar,
                              v_importe_debe,
                              v_importe_haber,
                              v_importe_debe,
                              v_importe_haber,
                              v_importe_debe,
                              v_importe_haber,
                              v_importe_debe,
                              v_importe_haber,
                              0,0,0,0, --MT
                              0,0,0,0, --MA
                              p_id_usuario,
                              now(),
                              'si'
                          );
                  
                  
               END IF;
         END IF;                     
    END LOOP; --END LOOP lista
    
      -------------------------------------- 
      --  insertar transaccion de AJUSTE
      --------------------------------------
      
      
      -- determinar el centro de costo del depto
      
      --v_id_centro_costo_depto
      
      
      -- determinar la relacion contable para el ajuste (cuenta , partida)
      
      -- v_id_cuenta
      --v_id_partida
         
      
      
      
      -- determinar si es perida o ganancia asi sabemos si va al debe o al haber 
      IF v_total_haber > v_total_debe THEN
         --ajuste al debe
         v_ajuste_debe =  v_total_haber - v_total_debe;
         v_ajuste_haber = 0;
      ELSE
         -- ajuste al haber
          v_ajuste_haber =  v_total_debe  - v_total_haber ;
          v_ajuste_debe = 0;
         
      END IF;
      
       --inserta trasaccion
      
              insert into conta.tint_transaccion(
                  id_partida,
                  id_centro_costo,
                  estado_reg,
                  id_cuenta,
                  glosa,
                  id_int_comprobante,
                  id_auxiliar,
                  importe_debe,
                  importe_haber,
                  importe_gasto,
                  importe_recurso,
                  importe_debe_mb,
                  importe_haber_mb,
                  importe_gasto_mb,
                  importe_recurso_mb,
                  
                  importe_debe_mt,
                  importe_haber_mt,
                  importe_gasto_mt,
                  importe_recurso_mt,
                  
                  importe_debe_ma,
                  importe_haber_ma,
                  importe_gasto_ma,
                  importe_recurso_ma,
                  
                  id_usuario_reg,
                  fecha_reg,
                  actualizacion
              ) values(
                  v_id_partida,
                  v_id_centro_costo_depto,
                  'activo',
                  v_id_cuenta,
                  'Ajsute por actualización de moneda',  --glosa
                  p_id_int_comprobante,
                  NULL,--v_registros.id_auxiliar,
                  
                  v_ajuste_debe,
                  v_ajuste_haber,
                  v_ajuste_debe,
                  v_ajuste_haber,
                  
                  v_ajuste_debe,
                  v_ajuste_haber,
                  v_ajuste_debe,
                  v_ajuste_haber,
                  0,0,0,0, --MT
                  0,0,0,0, --MA
                  p_id_usuario,
                  now(),
                  'si'
              );
        
      
         
             
    
    
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