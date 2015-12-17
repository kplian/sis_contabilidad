--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_recuperar_cuentas_nivel (
  p_id_cuenta integer,
  p_nivel_ini integer,
  p_nivel_final integer,
  p_id_resultado_det_plantilla integer,
  p_desde date,
  p_hasta date,
  p_id_deptos varchar,
  p_incluir_cierre varchar,
  p_incluir_apertura varchar,
  p_incluir_aitb varchar,
  p_signo_balance varchar,
  p_tipo_balance varchar,
  p_origen varchar
)
RETURNS boolean AS
$body$
DECLARE


v_parametros  		record;
v_registros 		record;
v_nombre_funcion   	text;
v_resp				varchar;
v_nivel				integer;
v_suma				numeric;
v_mayor				numeric;
va_mayor			numeric[];
v_id_gestion  		integer;
v_id_cuentas		integer[];
v_monto				numeric;
 

BEGIN



    v_nombre_funcion = 'conta.f_recuperar_cuentas_nivel';
    
    IF (p_nivel_ini = p_nivel_final and p_origen != 'balance') THEN
       
        FOR v_registros in (
                     select 
                        cue.id_cuenta,
                        cue.nro_cuenta,
                        cue.nombre_cuenta
                     from conta.tcuenta cue 
                     where cue.id_cuenta_padre = p_id_cuenta and cue.estado_reg = 'activo') LOOP
                     
                  --calculamos el balance de la cuenta para las fechas indicadas
                   va_mayor = conta.f_mayor_cuenta(v_registros.id_cuenta, 
                  								 p_desde, 
                                                 p_hasta, 
                                                 p_id_deptos, 
                                                 p_incluir_cierre, 
                                                 p_incluir_apertura, 
                                                 p_incluir_aitb,
                                                 p_signo_balance,
                                                 p_tipo_balance);
                 		
                  v_monto  =  va_mayor[1];
                  
                  --	insertamos en la tabla temporal
                  insert into temp_balancef (
                          
                          id_cuenta,
                          desc_cuenta,
                          codigo_cuenta,
                          monto,
                          id_resultado_det_plantilla)
                      values (
                          
                          v_registros.id_cuenta,
                          v_registros.nombre_cuenta,
                          v_registros.nro_cuenta,
                          v_monto,
                          p_id_resultado_det_plantilla);          
       
       END LOOP;
    
    ELSE
    
    
       FOR v_registros in (
                     select 
                        cue.id_cuenta,
                        cue.nro_cuenta,
                        cue.nombre_cuenta,
                        cue.desc_cuenta,
                        cue.sw_transaccional
                     from conta.tcuenta cue 
                     where 
                          cue.id_cuenta_padre = p_id_cuenta   
                         and cue.estado_reg = 'activo') LOOP
                     
               --si viene de un balance verificamos si la cuenta es de moviemitno y calculamos el mayor
               IF p_origen = 'balance'  THEN
               
             
                
                     IF  v_registros.sw_transaccional = 'movimiento'  THEN
                         
                          va_mayor = conta.f_mayor_cuenta(v_registros.id_cuenta, 
                  								 p_desde, 
                                                 p_hasta, 
                                                 p_id_deptos, 
                                                 p_incluir_cierre, 
                                                 p_incluir_apertura, 
                                                 p_incluir_aitb,
                                                 p_signo_balance,
                                                 p_tipo_balance);
                                                 
                          v_monto =  va_mayor[1];
                       
                          --	insertamos en la tabla temporal
                          insert into temp_balancef (
                              
                              id_cuenta,
                              desc_cuenta,
                              codigo_cuenta,
                              monto,
                              id_resultado_det_plantilla)
                          values (
                              
                              v_registros.id_cuenta,
                              v_registros.nombre_cuenta,
                              v_registros.nro_cuenta,
                              v_monto,
                              p_id_resultado_det_plantilla); 
                     
                     END IF;
               
                     
                      
               
               END IF;
               
               
               
               
               IF ( not conta.f_recuperar_cuentas_nivel(
                							v_registros.id_cuenta, 
                                            p_nivel_ini + 1, 
                                            p_nivel_final, 
                                            p_id_resultado_det_plantilla, 
                                            p_desde, 
                                            p_hasta, 
                                            p_id_deptos,
                                            p_incluir_cierre,
                                            p_incluir_apertura,
                                            p_incluir_aitb,
                                            p_signo_balance,
                                            p_tipo_balance,
                                            p_origen) ) THEN     
                  raise exception 'Error al calcular balance del detalle en el nivel %', p_nivel_ini;
               END IF;
       END LOOP;  
    
    END IF;
    
   
    RETURN TRUE;


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