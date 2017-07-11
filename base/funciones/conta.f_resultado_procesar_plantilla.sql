--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_resultado_procesar_plantilla (
  p_plantilla varchar,
  p_id_resultado_plantilla integer,
  p_desde date,
  p_hasta date,
  p_id_deptos varchar,
  p_id_gestion integer,
  p_int_comprobante integer,
  p_force_invisible boolean = false,
  p_multiple_col boolean = false
)
RETURNS boolean AS
$body$
DECLARE

    v_parametros  			record;
    v_registros 			record;
    v_nombre_funcion   		text;
    v_resp					varchar;
    v_nivel					integer;
    v_suma					numeric;
    v_mayor					numeric;
    v_id_gestion  			integer;
    v_id_cuentas			integer[];
    v_monto					numeric;
    v_monto_partida			numeric;
    v_monto_mayor			numeric[];
    v_reg_cuenta			record;
    v_visible				varchar; 
    v_nombre_variable		varchar;
    v_destino				varchar;
    v_id_cuenta				integer;
    v_force_invisible		boolean;
    v_registros_plan		record;
    v_id_prioridad			integer;
    v_columnas_formula		varchar[];


BEGIN
     
    
    v_nombre_funcion = 'conta.f_resultado_procesar_plantilla';
    
    
                        
   --revisar si tiene dependencias  y procesarlas primero
     IF p_force_invisible  THEN
         FOR v_registros in ( select 
                                  rd.*,
                                  rp.codigo  as plantilla,
                                  rp.glosa as nombre_columna 
                              from conta.tresultado_dep rd 
                              inner join conta.tresultado_plantilla rp on rp.id_resultado_plantilla = rd.id_resultado_plantilla_hijo
                              where rd.id_resultado_plantilla = p_id_resultado_plantilla 
                              order by prioridad asc ) LOOP
                        
                        
         
                      -- procesa la plantilla dependientes ... 
                      IF  not conta.f_resultado_procesar_plantilla(
                                                                  v_registros.plantilla,
                                                                  v_registros.id_resultado_plantilla_hijo, 
                                                                  p_desde, 
                                                                  p_hasta, 
                                                                  p_id_deptos,
                                                                  p_id_gestion,
                                                                  p_int_comprobante,
                                                                  TRUE,
                                                                  p_multiple_col) THEN
                                                                  
                           raise exception 'error al procesar la plantilla %', v_registros.codigo;                                       
                     END IF;
         END LOOP;
      END IF;
      
      --obtiene datos de la plantilla
      select 
          rp.codigo  as plantilla,
          rp.glosa as nombre_columna 
      into
        v_registros_plan
      from conta.tresultado_plantilla rp 
      where rp.id_resultado_plantilla = p_id_resultado_plantilla;
      
          
   -- listar el detalle de la plantilla
      v_force_invisible = p_force_invisible;
      IF p_multiple_col = true THEN
        v_force_invisible = FALSE;
      END IF; 
        
         FOR v_registros in (
                             SELECT
                               *                               
                             FROM conta.tresultado_det_plantilla rdp 
                             where rdp.id_resultado_plantilla = p_id_resultado_plantilla  order by rdp.orden asc) LOOP 
                  
                  
                  --   2.0)  determina visibilidad
                  IF v_force_invisible THEN
                     v_visible = 'no';
                  ELSE
                     v_visible = v_registros.visible;   
                  END IF;
                  
                  
                  
                  --   2.1) si el origen es balance
                  IF  v_registros.origen = 'balance' and v_registros.destino = 'reporte' THEN
                        
                        --	2.1.1)  recuperamos los datos de la cuenta 
                        v_reg_cuenta = NULL;
                        select
                          cue.id_cuenta,
                          cue.nro_cuenta,
                          cue.nombre_cuenta,
                          cue.sw_transaccional
                        into
                          v_reg_cuenta
                        from conta.tcuenta cue
                        where cue.id_gestion = p_id_gestion and cue.nro_cuenta = v_registros.codigo_cuenta ;
                        
                        IF v_reg_cuenta  is null THEN
                           raise exception 'revise su configuración, no tenemos una cuenta con el código = %',v_registros.codigo_cuenta;
                        END IF;
                        
                        --raise exception '%, %', v_registros.codigo_cuenta, p_id_gestion;
                		--   2.1.2)  calculamos el balance de la cuenta para las fechas indicadas
                         raise notice '>>>>>>>>>   %,%,%,%,%,%,%,%',p_desde,p_hasta,p_id_deptos,v_registros.incluir_cierre,v_registros.incluir_apertura,v_registros.incluir_aitb ,v_registros.signo_balance,v_registros.tipo_saldo;
                         v_monto_mayor = conta.f_mayor_cuenta(v_reg_cuenta.id_cuenta,
                        								p_desde, 
                                                        p_hasta, 
                                                        p_id_deptos, 
                                                        v_registros.incluir_cierre, 
                                                        v_registros.incluir_apertura, 
                                                        v_registros.incluir_aitb,
                                                        v_registros.signo_balance,
                                                        v_registros.tipo_saldo,
                                                        NULL,
                                                        p_int_comprobante
                                                        );
                                                        
                                                        
                        v_monto   = v_monto_mayor[1];
                        v_monto_partida   = v_monto_mayor[3];                        
                 		
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
                                incluir_apertura,
                                negrita,
                                cursiva,
                                espacio_previo,
                                incluir_aitb,
                                relacion_contable,
                                codigo_partida,
                                id_auxiliar,
                                destino,
                                orden_cbte,
                                monto_partida
                                )
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
                                v_registros.incluir_apertura,
                                v_registros.negrita,
                                v_registros.cursiva,
                                v_registros.espacio_previo,
                                v_registros.incluir_aitb,
                                v_registros.relacion_contable,
                                v_registros.codigo_partida,
                                v_registros.id_auxiliar,
                                v_registros.destino,
                                v_registros.orden_cbte,
                                v_monto_partida);
                        
                  --    2.2) si el origen es detall
                  ELSIF  v_registros.origen = 'detalle' or (v_registros.origen = 'balance' and v_registros.destino != 'reporte') THEN
                         
                        -----------------------------------------------------------------------------------
                        --   cuando es balance y el destino es un cbte, no se pueden insertar directamente las cuentas
                        --   titulares, por eso se desglosa  la cuenta hasta encontrar las cuentas de movimiento
                        --    e se insertar las trasacciones con cuenta de moviemto
                        ----------------------------------------------------------------------------------  
                  
                         
                         --   2.2.1)  recuperamos la cuenta raiz
                         select
                          cue.id_cuenta,
                          cue.nro_cuenta,
                          cue.nombre_cuenta,
                          cue.sw_transaccional
                        into
                          v_reg_cuenta
                        from conta.tcuenta cue
                        where cue.id_gestion = p_id_gestion and 
                              cue.nro_cuenta = v_registros.codigo_cuenta ;
                       
                  
                      IF v_reg_cuenta.sw_transaccional != 'movimiento' THEN  
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
                                                        v_registros.incluir_apertura, 
                                                        v_registros.incluir_aitb,
                                                        v_registros.signo_balance,
                                                        v_registros.tipo_saldo,
                                                        v_registros.origen,
                                                        p_int_comprobante) ) THEN     
                                raise exception 'Error al calcular balance del detalle en el nivel %', 0;
                            END IF;
                        
                        ELSE
                          --  si es una cuenta de movimiento
                            v_monto_mayor = conta.f_mayor_cuenta(v_reg_cuenta.id_cuenta, 
                  								 p_desde, 
                                                 p_hasta, 
                                                 p_id_deptos, 
                                                  v_registros.incluir_cierre, 
                                                  v_registros.incluir_apertura, 
                                                  v_registros.incluir_aitb,
                                                  v_registros.signo_balance,
                                                  v_registros.tipo_saldo,
                                                  NULL,
                                                  p_int_comprobante);
                                                  
                            v_monto = v_monto_mayor[1];
                            v_monto_partida = v_monto_mayor[3];                 
                       
                          --	insertamos en la tabla temporal
                          insert into temp_balancef (
                              
                              id_cuenta,
                              desc_cuenta,
                              codigo_cuenta,
                              monto,
                              id_resultado_det_plantilla,
                              monto_partida)
                          values (
                              
                              v_reg_cuenta.id_cuenta,
                              v_reg_cuenta.nombre_cuenta,
                              v_reg_cuenta.nro_cuenta,
                              v_monto,
                              v_registros.id_resultado_det_plantilla,
                              v_monto_partida); 
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
                                incluir_apertura = v_registros.incluir_apertura,
                                negrita = v_registros.negrita,
                                cursiva = v_registros.cursiva,
                                espacio_previo = v_registros.espacio_previo,
                                incluir_aitb = v_registros.incluir_aitb,
                                relacion_contable = v_registros.relacion_contable,
                                codigo_partida = v_registros.codigo_partida,
                                id_auxiliar = v_registros.id_auxiliar,
                                destino = v_registros.destino,
                                orden_cbte = v_registros.orden_cbte
                        WHERE id_resultado_det_plantilla = v_registros.id_resultado_det_plantilla;
                                   
                  
                  --    2.2) si el origen es detalle_formula (aplica la formula a los detalle de la cuenta)
                  
                  ELSIF  v_registros.origen = 'detalle_formula'  THEN
                         
                         
                         --   2.2.1)  recuperamos la cuenta raiz
                         select
                          cue.id_cuenta,
                          cue.nro_cuenta,
                          cue.nombre_cuenta,
                          cue.sw_transaccional
                        into
                          v_reg_cuenta
                        from conta.tcuenta cue
                        where cue.id_gestion = p_id_gestion and 
                              cue.nro_cuenta = v_registros.codigo_cuenta ;
                       
                  
                      IF v_reg_cuenta.sw_transaccional != 'movimiento' THEN  
                            
                            --  2.2.2) Recuperar las cuentas del nivel requerido
                            v_columnas_formula =  conta.f_recuperar_cuentas_nivel_formula(
                                                        v_reg_cuenta.id_cuenta, 
                                                        1, 
                                                        v_registros.nivel_detalle, 
                                                        v_registros.id_resultado_det_plantilla, 
                                                        v_registros.origen,
                                                        v_registros.formula,
                                                        p_plantilla,
                                                        v_registros.destino,
                                                        NULL, --p_columnas_formula 
                                                        p_int_comprobante
                                                        );
                            
                        
                        ELSE
                                            
                           
                           SELECT 
                               po_columnas_formula,
                               po_monto,
                               po_monto_partida
                           into 
                               v_columnas_formula,
                               v_monto,
                               v_monto_partida
                               
                           FROM conta.f_evaluar_resultado_detalle_formula(
                                               v_registros.formula, 
                                               p_plantilla, 
                                               v_registros.destino, 
                                               NULL, --p_columnas_formula, 
                                               v_reg_cuenta.nro_cuenta);
                                                
                                               
                          --	insertamos en la tabla temporal
                          insert into temp_balancef (
                              
                              id_cuenta,
                              desc_cuenta,
                              codigo_cuenta,
                              monto,
                              id_resultado_det_plantilla,
                              monto_partida)
                          values (
                              
                              v_reg_cuenta.id_cuenta,
                              v_reg_cuenta.nombre_cuenta,
                              v_reg_cuenta.nro_cuenta,
                              v_monto,
                              v_registros.id_resultado_det_plantilla,
                              v_monto_partida); 
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
                                incluir_apertura = v_registros.incluir_apertura,
                                negrita = v_registros.negrita,
                                cursiva = v_registros.cursiva,
                                espacio_previo = v_registros.espacio_previo,
                                incluir_aitb = v_registros.incluir_aitb,
                                relacion_contable = v_registros.relacion_contable,
                                codigo_partida = v_registros.codigo_partida,
                                id_auxiliar = v_registros.id_auxiliar,
                                destino = v_registros.destino,
                                orden_cbte = v_registros.orden_cbte
                        WHERE id_resultado_det_plantilla = v_registros.id_resultado_det_plantilla;
                  
                  
                  
                  --   2.3) si el origen es formula
	              ELSIF  v_registros.origen = 'formula' THEN
                           
                           --la formula vacia solo se admiten cuando el destino es segun balance
                           IF v_registros.formula is NULL and v_registros.destino != 'reporte' THEN
                             raise exception 'En registros de origen formula, la formula no puede ser nula o vacia';
                           END IF;
                          
                           v_nombre_variable = '';
                           
                           IF v_registros.codigo_cuenta is not null and v_registros.codigo_cuenta !='' THEN 
                              
                              select
                               cue.id_cuenta,
                               cue.nro_cuenta,
                               cue.nombre_cuenta,
                               cue.sw_transaccional
                             into
                              v_reg_cuenta
                             from conta.tcuenta cue
                             where cue.id_gestion = p_id_gestion and cue.nro_cuenta = v_registros.codigo_cuenta;
                            
                             v_nombre_variable = v_reg_cuenta.nombre_cuenta;
                             
                              IF  v_reg_cuenta.id_cuenta is NULL  and v_registros.destino in ('segun_saldo','debe','haber') THEN
                                  raise exception 'es obligatorio especificar uan cuenta cuando el destino es para un CBTE';
                              ELSIF v_registros.destino in ('segun_saldo','debe','haber') and v_reg_cuenta.sw_transaccional = 'titular' THEN
                                  raise exception 'Las formulas solo admiten cuentas de movimiento, revise %', v_registros.codigo_cuenta;    
                              END IF;
                              
                              v_id_cuenta =  v_reg_cuenta.id_cuenta;
                          
                          END IF;
                            
                          IF v_registros.nombre_variable is not null and v_registros.nombre_variable != '' THEN
                            v_nombre_variable = v_registros.nombre_variable;
                          END IF;
                          -- 2.3.1)  calculamos el monto para la formula
                          v_monto_mayor  = conta.f_evaluar_resultado_formula(v_registros.formula, p_plantilla, v_registros.destino);
                          v_monto = v_monto_mayor[1];
                          v_monto_partida = v_monto_mayor[2];
                          
                          
                          
                           
                          --2.3.1  si el destino es segun balance identifcai si va al debe o al haber (los negativos van al haber)
                          IF v_registros.destino = 'segun_saldo' THEN
                            IF v_monto > 0 THEN
                               v_destino = 'haber';
                            ELSE
                               v_destino = 'debe';
                               v_monto = v_monto *(-1);
                               v_monto_partida = v_monto_partida *(-1);
                            END IF;
                            
                          else
                             v_destino =  v_registros.destino;
                          END IF;
                         
                          
                          -- 2.3.3)  insertamos el registro en tabla temporal        
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
                                incluir_apertura,
                                negrita,
                                cursiva,
                                espacio_previo,
                                incluir_aitb,
                                relacion_contable,
                                codigo_partida,
                                id_auxiliar,
                                destino,
                                orden_cbte,
                                id_cuenta,
                                monto_partida)
                            values (
                                p_plantilla,
                                v_registros.subrayar,
                                v_registros.font_size,
                                v_registros.posicion,
                                v_registros.signo,
                                v_registros.codigo,
                                v_registros.origen,
                                v_registros.orden,
                                v_nombre_variable,
                                v_registros.montopos,
                                v_monto,
                                v_registros.id_resultado_det_plantilla,
                                NULL,
                                v_visible,
                                v_registros.incluir_cierre,
                                v_registros.incluir_apertura,
                                v_registros.negrita,
                                v_registros.cursiva,
                                v_registros.espacio_previo,
                                v_registros.incluir_aitb,
                                v_registros.relacion_contable,
                                v_registros.codigo_partida,
                                v_registros.id_auxiliar,
                                v_destino,
                                v_registros.orden_cbte,
                                v_id_cuenta,
                                v_monto_partida);
                                
                               
                  --   2.4) si el origen es sumatoria
	              ELSIF  v_registros.origen = 'sumatoria' THEN
                   
                           IF v_registros.formula is NULL THEN
                             raise exception 'En registros de origen sumatoria';
                           END IF;
                  
                          -- 2.3.1)  calculamos el monto para la formula
                            v_monto_mayor  = conta.f_evaluar_sumatoria(v_registros.formula, p_plantilla);
                            v_monto = v_monto_mayor[1];
                            v_monto_partida = v_monto_mayor[2];
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
                                incluir_apertura,
                                negrita,
                                cursiva,
                                espacio_previo,
                                incluir_aitb,
                                relacion_contable,
                                codigo_partida,
                                id_auxiliar,
                                destino,
                                orden_cbte,
                                monto_partida)
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
                                v_registros.incluir_apertura,
                                v_registros.negrita,
                                v_registros.cursiva,
                                v_registros.espacio_previo,
                                v_registros.incluir_aitb,
                                v_registros.relacion_contable,
                                v_registros.codigo_partida,
                                v_registros.id_auxiliar,
                                v_registros.destino,
                                v_registros.orden_cbte,
                                v_monto_partida);  
                                           
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
                                incluir_apertura,
                                negrita,
                                cursiva,
                                espacio_previo,
                                incluir_aitb,
                                relacion_contable,
                                codigo_partida,
                                id_auxiliar,
                                destino,
                                orden_cbte,
                                monto_partida)
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
                                v_registros.incluir_apertura,
                                v_registros.negrita,
                                v_registros.cursiva,
                                v_registros.espacio_previo,
                                v_registros.incluir_aitb,
                                v_registros.relacion_contable,
                                v_registros.codigo_partida,
                                v_registros.id_auxiliar,
                                v_registros.destino,
                                v_registros.orden_cbte,
                                0.0);
                  END IF;
          END LOOP;
        
        --recuperamos la prioridad de la plantilla
        
        select 
          id
        into 
          v_id_prioridad 
        from temp_balancef 
        where plantilla = v_registros_plan.plantilla 
        order by id asc
        offset 0 limit 1;
      
        --update el nombrede columna para la plantilla
        
        
        UPDATE  temp_balancef set
          nombre_columna = v_registros_plan.nombre_columna,
          prioridad = v_id_prioridad
        WHERE plantilla = v_registros_plan.plantilla;
        
        
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