--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_actualizacion_gastos (
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
	v_nombre_funcion   				text;
 	v_resp							varchar;
	v_record						record;
    
    v_total_haber   				numeric;
	v_total_debe	 				numeric;
    v_ajuste_debe					numeric;
    v_ajuste_haber				    numeric;
    
   	v_id_moneda_base				integer;
    v_id_moneda_act					integer;
    v_multiple_col 					boolean;
    v_gestion    					varchar;
    v_id_gestion					integer;
    v_incluir_sinmov    			varchar;
    v_registros_plantilla			record;
    v_reg_cbte						record;
    v_registros						record;
	v_id_centro_costo_depto			integer;
    v_sw_minimo						boolean;
    
    v_resp_deudor  					numeric[];
 	v_resp_acreedor  				numeric[];
    
    v_sw_actualiza    				boolean;
    v_diferencia_positiva 			boolean;  
    v_sw_saldo_acredor 				boolean;
    v_saldo_ma   					numeric;
 	v_saldo_mb   					numeric;
    v_aux_actualizado_mb			numeric;
    
	v_importe_debe 					numeric;
    v_importe_haber 				numeric;
    v_diferencia					numeric;
    v_record_rel					record;
    v_record_rel_con				record;
    v_prue							varchar;
    v_id_cuenta_actualizacion		integer;
    v_ayuda_haber   				numeric;
    
BEGIN

 	v_nombre_funcion = 'conta.f_actualizacion_gastos';

    v_total_haber 	= 0;
    v_total_debe 	= 0;
    v_ajuste_debe 	= 0;
    v_ajuste_haber 	= 0;
    
    v_id_moneda_base = param.f_get_moneda_base();
    v_id_moneda_act  = param.f_get_moneda_actualizacion();
    v_gestion =  EXTRACT(YEAR FROM  p_desde::date)::varchar;
    
    
    
   	---se obtiene la fecha de comprobante seleccion
    select  *
    		into 
            v_reg_cbte
    from conta.tint_comprobante 
    where id_int_comprobante = p_id_int_comprobante;


	--ojo aun no se como se maneja esto
	   
     SELECT 
      ps_id_centro_costo 
      into 
       v_id_centro_costo_depto 
     FROM conta.f_get_config_relacion_contable('CCDEPCON', -- relacion contable que almacena los centros de costo por departamento
                                       p_id_gestion_cbte,  
                                       p_id_depto,--p_id_depto_conta 
                                       NULL);  --id_dento_costo
    
    --validacion para tomar la fecha inicio
    
     v_sw_minimo = false;
     
    IF not exists (select
                        1
                    from param.tgestion ges
                    where ges.id_gestion = p_id_gestion_cbte
                          and ges.fecha_ini = p_desde ) THEN
         raise exception 'El calculo siempre debe comenzar desde el primer dia del año';
     END IF;
     
     
    FOR  v_registros IN (select   c.id_cuenta,
                                  c.nro_cuenta,
                                  c.cuenta_actualizacion
                          from conta.tcuenta c
                          where c.estado_reg = 'activo'       
                          and c.tipo_cuenta = 'gasto'
                          and c.tipo_act = 'gasto'
                          and c.id_gestion = p_id_gestion_cbte
                          and c.cuenta_actualizacion is not null
                          order by nro_cuenta	)LOOP
        v_resp_deudor = NULL;
        v_resp_acreedor = NULL;
        ----Debe
           v_resp_deudor = conta.f_mayor_cuenta(v_registros.id_cuenta, 
                                           p_desde, 
        								   p_hasta, 
                                            NULL, --todos los deptos p_id_depto::varchar, , 
                                           'si',
                                           'todos',          --  p_incluir_cierre
                                           'todos',          --  p_incluir_aitb, 
                                           'defecto_cuenta', -- p_signo_balance, 
                                           'deudor', --  p_tipo_saldo,
                                            null,--p_id_auxiliar,
                                            null,--p_id_int_comprobante_ori,
                                            null,--id_ot
                                            null -- p_id_centro_costo
                                           );
          
        ----Haber                              
         v_resp_acreedor = conta.f_mayor_cuenta(v_registros.id_cuenta, 
                                           p_desde, 
        								   p_hasta, 
                                           NULL, --todos los deptos p_id_depto::varchar, , 
                                           'si',
                                           'todos',          --  p_incluir_cierre
                                           'todos',          --  p_incluir_aitb, 
                                           'defecto_cuenta', -- p_signo_balance, 
                                           'acreedor', --  p_tipo_saldo,
                                            null,--p_id_auxiliar,
                                            null,--p_id_int_comprobante_ori,
                                            null,--id_ot
                                            null -- p_id_centro_costo
                                           ); 
                                           
          v_sw_actualiza = false;
          v_diferencia_positiva = true;  
          v_sw_saldo_acredor = false;
          v_aux_actualizado_mb = 0;
          v_saldo_mb  = 0; --bs
          v_saldo_ma  = 0; --ufv  
          
         
          ---calculamos la diferencia
          
          if v_resp_acreedor[5] > v_resp_deudor[5] then
          
          	  v_sw_actualiza = true;
              v_sw_saldo_acredor = true;
              v_saldo_ma = v_resp_acreedor[5] - v_resp_deudor[5];
              v_saldo_mb = v_resp_acreedor[1] - v_resp_deudor[1];
              
  	 	  elsif  v_resp_deudor[5] > v_resp_acreedor[5]  then
          
            	v_sw_actualiza = true;
                v_sw_saldo_acredor = false;
              	v_saldo_ma = v_resp_deudor[5] - v_resp_acreedor[5];
              	v_saldo_mb = v_resp_deudor[1] - v_resp_acreedor[1];
          else
          
          raise notice 'Paso algo malo no se puede realizar la actualizacion';
          
          v_sw_actualiza = false;	
                
          end if;
   
          if v_sw_actualiza then
               --- raise exception 'v_reg_cbte.fecha --> %',v_reg_cbte.fecha;
                v_aux_actualizado_mb = param.f_convertir_moneda (v_id_moneda_act, 
                                                                  v_id_moneda_base,    
                                                                  v_saldo_ma,  
                                                                  v_reg_cbte.fecha, 'O',2, 1, 'no');
                                                         
               if v_aux_actualizado_mb > v_saldo_mb then
               	
                    v_diferencia = v_aux_actualizado_mb - v_saldo_mb;
                    v_diferencia_positiva = true;
                    v_sw_actualiza = true;
                  
               elsif v_saldo_mb  > v_aux_actualizado_mb then
               		v_diferencia = v_saldo_mb - v_aux_actualizado_mb ;   
                	v_diferencia_positiva = false;
                  	v_sw_actualiza = true;
                    
               else
          
          			raise notice 'Paso algo malo no se puede realizar la actualizacion';
            		v_sw_actualiza = false;	
               
               end if;                                                    
            
                v_importe_debe = 0;
              	v_importe_haber = 0;
                                                          
               if v_sw_actualiza then
                
                      IF v_sw_saldo_acredor THEN
                         IF v_diferencia_positiva THEN
                            v_importe_haber = 0;
                            v_importe_debe = v_diferencia;
                         ELSE
                            v_importe_haber = 0;
                            v_importe_debe = v_diferencia;
                         
                         END IF;
                      ELSE
                         IF v_diferencia_positiva THEN
                            v_importe_haber = 0;
                            v_importe_debe = v_diferencia;
                         ELSE
                            v_importe_haber = 0;
                            v_importe_debe = v_diferencia;
                         END IF;
                      END IF;
               
               
                
                  v_total_haber = v_total_haber + v_importe_haber; 
                  v_total_debe = v_total_debe + v_importe_debe;
              
               select cu.id_cuenta
               into 
               v_id_cuenta_actualizacion
               from conta.tcuenta cu
               where cu.nro_cuenta = v_registros.cuenta_actualizacion  
               and cu.id_gestion = p_id_gestion_cbte;
            
               
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
                              null,   --partida de flujo
                              v_id_centro_costo_depto, --centr de costo del depto contable
                              'activo',
                              v_id_cuenta_actualizacion, --la misma cuenta sobre la que hicimos el mayor
                              'prueba actualizacion mmv',  --glosa
                              p_id_int_comprobante,
                              NULL,--v_registros.id_auxiliar,
                              v_importe_debe,
                              v_importe_haber,
                              0,
                              0,
                              0,
                              0,
                              0,
                              0,
                              0,0,0,0, --MT
                              0,0,0,0, --MA
                              p_id_usuario,
                              now(),
                              'si'
                          );
                          
                          v_sw_minimo = true;
                  
                  
               else 
               raise exception 'Algo salio mal :( ---> %',v_registros.id_cuenta;
               end if ;                                  
                                                          
          else
          
          raise exception 'Salio algo mal cuenta --> %',v_registros.id_cuenta;
          
          end if;
    
    END LOOP;

  	IF not v_sw_minimo THEN
       raise exception 'No se actualizo ninguna cuenta';
    END IF;
  

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
                              null,   --partida de flujo
                              v_id_centro_costo_depto, --centr de costo del depto contable
                              'activo',
                              1758, --la misma cuenta sobre la que hicimos el mayor
                              'prueba actualizacion mmv',  --glosa
                              p_id_int_comprobante,
                              NULL,--v_registros.id_auxiliar,
                              0,
                              v_total_debe,
                              0,
                              0,
                              0,
                              0,
                              0,
                              0,
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