--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_recuperar_cuentas_nivel_formula (
  p_id_cuenta integer,
  p_nivel_ini integer,
  p_nivel_final integer,
  p_id_resultado_det_plantilla integer,
  p_origen varchar,
  p_formula varchar,
  p_plantilla varchar,
  p_destino varchar,
  p_columnas_formula varchar [],
  p_int_comprobante integer
)
RETURNS varchar [] AS
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
v_columnas_formula	varchar[];
v_monto_partida		numeric;
 

BEGIN



    v_nombre_funcion = 'conta.f_recuperar_cuentas_nivel_formula';
    
    IF (p_nivel_ini = p_nivel_final) THEN
       
        FOR v_registros in (
                     select 
                        cue.id_cuenta,
                        cue.nro_cuenta,
                        cue.nombre_cuenta
                     from conta.tcuenta cue 
                     where cue.id_cuenta_padre = p_id_cuenta and cue.estado_reg = 'activo') LOOP
                     
                  
                                                 
                 --calculamos la formula para el nivel deseado                             
                 SELECT 
                     po_columnas_formula,
                     po_monto,
                     po_monto_partida
                 into 
                     v_columnas_formula,
                     v_monto,
                     v_monto_partida
                     
                 FROM conta.f_evaluar_resultado_detalle_formula(
                                     p_formula, 
                                     p_plantilla, 
                                     p_destino, 
                                     p_columnas_formula, 
                                     v_registros.nro_cuenta,
                                     p_int_comprobante);                               
                 		
                  p_columnas_formula = v_columnas_formula;
                  
                  --	insertamos en la tabla temporal
                  insert into temp_balancef (
                          
                          id_cuenta,
                          desc_cuenta,
                          codigo_cuenta,
                          monto,
                          id_resultado_det_plantilla,
                          monto_partida)
                      values (
                          
                          v_registros.id_cuenta,
                          v_registros.nombre_cuenta,
                          v_registros.nro_cuenta,
                          v_monto,
                          p_id_resultado_det_plantilla,
                          v_monto_partida);          
       
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
                     
             
                
                     IF  v_registros.sw_transaccional = 'movimiento'  THEN
                         
                          SELECT 
                               po_columnas_formula,
                               po_monto,
                               po_monto_partida
                               
                           into 
                               v_columnas_formula,
                               v_monto,
                               v_monto_partida
                               
                           FROM conta.f_evaluar_resultado_detalle_formula(
                                               p_formula, 
                                               p_plantilla, 
                                               p_destino, 
                                               p_columnas_formula, 
                                               v_registros.nro_cuenta); 
                                                 
                          p_columnas_formula = v_columnas_formula;
                       
                          --	insertamos en la tabla temporal
                          insert into temp_balancef (
                              
                              id_cuenta,
                              desc_cuenta,
                              codigo_cuenta,
                              monto,
                              id_resultado_det_plantilla,
                              monto_partida)
                          values (
                              
                              v_registros.id_cuenta,
                              v_registros.nombre_cuenta,
                              v_registros.nro_cuenta,
                              v_monto,
                              p_id_resultado_det_plantilla,
                              v_monto_partida); 
                     
                     ELSE
                     
                         v_columnas_formula =  conta.f_recuperar_cuentas_nivel_formula(
                                                        v_registros.id_cuenta, 
                                                        p_nivel_ini + 1, 
                                                        p_nivel_final, 
                                                        p_id_resultado_det_plantilla, 
                                                        p_origen,
                                                        p_formula,
                                                        p_plantilla,
                                                        p_destino,
                                                        p_columnas_formula,
                                                        p_int_comprobante
                                                        );
                                                        
                                                         
                                                        
                    
                       p_columnas_formula = v_columnas_formula;
                     
                 END IF;
              
       END LOOP;  
    
    END IF;
    
   
   return p_columnas_formula;

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