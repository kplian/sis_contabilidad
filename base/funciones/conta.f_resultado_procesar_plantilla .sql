--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_resultado_procesar_plantilla (
  p_plantilla varchar,
  p_id_resultado_plantilla integer,
  p_desde date,
  p_hasta date,
  p_id_deptos varchar,
  p_id_gestion integer,
  p_force_invisible boolean = false
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
v_id_gestion  		integer;
v_id_cuentas		integer[];
v_monto				numeric;
v_reg_cuenta		record;
v_visible			varchar; 

BEGIN
     
    
    v_nombre_funcion = 'conta.f_resultado_procesar_plantilla';
    
   -- listar el detalle de la plantilla
         
         FOR v_registros in (
                             SELECT
                               *                               
                             FROM conta.tresultado_det_plantilla rdp 
                             where rdp.id_resultado_plantilla = p_id_resultado_plantilla  order by rdp.orden asc) LOOP 
                  
                  
                  --   2.0)  determna visibilidad
                  IF p_force_invisible THEN
                     v_visible = 'no';
                  ELSE
                     v_visible = v_registros.visible;   
                  END IF;
                  
                  
                  
                  --   2.1) si el origen es balance
                  IF  v_registros.origen = 'balance' THEN
                        --	2.1.1)  recuperamos los datos de la cuenta 
                        select
                          cue.id_cuenta,
                          cue.nro_cuenta,
                          cue.nombre_cuenta
                        into
                          v_reg_cuenta
                        from conta.tcuenta cue
                        where cue.id_gestion = p_id_gestion and cue.nro_cuenta = v_registros.codigo_cuenta ;
                        
                        --raise exception '%, %', v_registros.codigo_cuenta, p_id_gestion;
                		--   2.1.2)  calculamos el balance de la cuenta para las fechas indicadas
                        v_monto = conta.f_mayor_cuenta(v_reg_cuenta.id_cuenta, p_desde, p_hasta, p_id_deptos, v_registros.incluir_cierre, v_registros.incluir_apertura);
                 		
                        --	 2.1.3)  insertamos en la tabla temporal
                        insert into temp_balancef (
                                plantilla,
                                subrayar,
                                font_size,
                                posicion,
                                signo,
                                id_cuenta,
                                desc_cuenta,
                                codigo_cuenta,
                                codigo,
                                origen,
                                orden,
                                nombre_variable,
                                montopos,
                                monto,
                                id_resultado_det_plantilla,
                                id_cuenta_raiz,
                                visible,
                                incluir_cierre,
                                incluir_apertura)
                            values (
                                p_plantilla,
                                v_registros.subrayar,
                                v_registros.font_size,
                                v_registros.posicion,
                                v_registros.signo,
                                v_reg_cuenta.id_cuenta,
                                v_reg_cuenta.nombre_cuenta,
                                v_reg_cuenta.nro_cuenta,
                                v_registros.codigo,
                                v_registros.origen,
                                v_registros.orden,
                                v_registros.nombre_variable,
                                v_registros.montopos,
                                v_monto,
                                v_registros.id_resultado_det_plantilla,
                                NULL,
                                v_visible,
                                v_registros.incluir_cierre,
                                v_registros.incluir_apertura);
                        
                  --    2.2) si el origen es detall
                  ELSIF  v_registros.origen = 'detalle' THEN
                         --   2.2.1)  recuperamos la cuenta raiz
                         select
                          cue.id_cuenta,
                          cue.nro_cuenta,
                          cue.nombre_cuenta
                        into
                          v_reg_cuenta
                        from conta.tcuenta cue
                        where cue.id_gestion = p_id_gestion and 
                              cue.nro_cuenta = v_registros.codigo_cuenta ;
                       
                        --  2.2.2) Recuperar las cuentas del nivel requerido
                        IF ( not conta.f_recuperar_cuentas_nivel(
                                                    v_reg_cuenta.id_cuenta, 
                                                    1, 
                                                    v_registros.nivel_detalle, 
                                                    v_registros.id_resultado_det_plantilla, 
                                                    p_desde, 
                                                    p_hasta, 
                                                    p_id_deptos, 
                                                    v_registros.incluir_cierre, 
                                                    v_registros.incluir_apertura ) ) THEN     
                            raise exception 'Error al calcular balance del detalle en el nivel %', 0;
                        END IF;
                        
                        --  2.2.3)  modificamos los registors de la tabla temporal comunes
                        UPDATE temp_balancef  set
                                plantilla = p_plantilla,
                                subrayar = v_registros.subrayar,
                                font_size = v_registros.font_size,
                                posicion = v_registros.posicion,
                                signo = v_registros.signo,
                                codigo = v_registros.codigo,
                                origen = v_registros.origen,
                                orden = v_registros.orden,
                                montopos = v_registros.montopos,
                                id_cuenta_raiz = v_reg_cuenta.id_cuenta,
                                visible = v_visible,
                                incluir_cierre = v_registros.incluir_cierre,
                                incluir_apertura = v_registros.incluir_apertura
                        WHERE id_resultado_det_plantilla = v_registros.id_resultado_det_plantilla;
                                   
                  --   2.3) si el origen es formula
	              ELSIF  v_registros.origen = 'formula' THEN
                   
                           IF v_registros.formula is NULL THEN
                             raise exception 'En registros de origen formula, la formula no peude ser nula o vacia';
                           END IF;
                  
                          -- 2.3.1)  calculamos el monto para la formula
                           v_monto = conta.f_evaluar_resultado_formula(v_registros.formula, p_plantilla);
                          -- 2.3.2)  insertamos el registro en tabla temporal        
                          insert into temp_balancef (
                                plantilla,
                                subrayar,
                                font_size,
                                posicion,
                                signo,
                                codigo,
                                origen,
                                orden,
                                nombre_variable,
                                montopos,
                                monto,
                                id_resultado_det_plantilla,
                                id_cuenta_raiz,
                                visible,
                                incluir_cierre,
                                incluir_apertura)
                            values (
                                p_plantilla,
                                v_registros.subrayar,
                                v_registros.font_size,
                                v_registros.posicion,
                                v_registros.signo,
                                v_registros.codigo,
                                v_registros.origen,
                                v_registros.orden,
                                v_registros.nombre_variable,
                                v_registros.montopos,
                                v_monto,
                                v_registros.id_resultado_det_plantilla,
                                NULL,
                                v_visible,
                                v_registros.incluir_cierre,
                                v_registros.incluir_apertura);
                                
                   --   2.4) si el origen es titulo
	               ELSEIF  v_registros.origen = 'titulo' THEN
                       -- 2.4.1) insertamos un registros para el titulo
                       insert into temp_balancef (
                                plantilla,
                                subrayar,
                                font_size,
                                posicion,
                                signo,
                                codigo,
                                origen,
                                orden,
                                nombre_variable,
                                montopos,
                                monto,
                                id_resultado_det_plantilla,
                                id_cuenta_raiz,
                                visible,
                                incluir_cierre,
                                incluir_apertura)
                            values (
                                p_plantilla,
                                v_registros.subrayar,
                                v_registros.font_size,
                                v_registros.posicion,
                                v_registros.signo,
                                v_registros.codigo,
                                v_registros.origen,
                                v_registros.orden,
                                v_registros.nombre_variable,
                                v_registros.montopos,
                                0.0,
                                v_registros.id_resultado_det_plantilla,
                                NULL,
                                v_visible,
                                v_registros.incluir_cierre,
                                v_registros.incluir_apertura);
                  END IF;
          END LOOP;
    
   
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
STABLE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;