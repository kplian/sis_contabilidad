--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_gestionar_presupuesto_cbte (
  p_id_usuario integer,
  p_id_int_comprobante integer,
  p_igualar varchar = 'no'::character varying
)
RETURNS varchar AS
$body$
/*
	Autor: RAC
    Fecha: 17-10-2013
    Descripción: Gestionar presupuesto comprobante.
*/
DECLARE

	v_debe			numeric;
    v_haber			numeric;
    v_errores 		varchar;
    v_rec_cbte 		record;
    v_doc			varchar;
    v_nro_cbte		varchar;
    v_id_periodo 	integer;
    v_filas			bigint;
    v_resp			varchar;
    
    v_nombre_funcion varchar;
    v_registros_comprobante record;
    v_registros record;
    
    v_i 					integer;
    v_cont 					integer;
    --array para gestionar presupuesto
    va_id_presupuesto 		integer[];
    va_id_partida     		integer[];
    va_momento				INTEGER[];
    va_monto          		numeric[];
    va_id_moneda    		integer[];
    va_id_partida_ejecucion integer[];
    va_columna_relacion     varchar[];
    va_fk_llave             integer[];
    va_resp_ges              numeric[];
    va_fecha                 date[];
    va_id_transaccion        integer[];
    va_id_int_rel_devengado  integer[];
    
    
    v_monto_cmp  numeric; 
    
    v_momento_presupeustario integer;
    v_momento_aux varchar;
    v_registros_dev record;
    
    v_aux  varchar;
    
    v_monto_x_pagar  numeric;
    v_monto_rev  numeric;
    
    v_marca_reversion integer[];
    

BEGIN
	
	
    v_nombre_funcion:='conta.f_gestionar_precupuesto_cbte';
    
    /*
    codigo_clase_cbtr
        PAGO
        DIARIO
        CAJA
     
    momento:
          contable
          presupuestario
         
          
             
    
    
    */
    -- revisar el tipo de comrpobante y su estado
    
     raise notice ' >>>> yyyyyyyyyyyyy';
    
    
    select    
      ic.momento,
      ic.id_clase_comprobante,
      cl.codigo as codigo_clase_cbte,
      ic.momento,
      ic.momento_comprometido,
      ic.momento_ejecutado,
      ic.momento_pagado,
      ic.estado_reg,
      ic.id_moneda
    into v_registros_comprobante
    from conta.tint_comprobante ic
    inner join conta.tclase_comprobante cl  on ic.id_clase_comprobante =  cl.id_clase_comprobante
    where ic.id_int_comprobante  =  p_id_int_comprobante;
    
      
     raise notice ' >>>> zzzzzzz';
     -- si el comprobante tiene efecto presupouestario'
    
    IF v_registros_comprobante.momento= 'presupuestario' THEN
   
        --rrecorrer todas las transacciones revisando las partidas presupuestarias
        
      v_i = 0;
      
       --Definir el momento 
       
        raise notice ' >>>> xxx';
               
            IF v_registros_comprobante.momento_comprometido = 'si'  and  v_registros_comprobante.momento_ejecutado = 'si'  and    v_registros_comprobante.momento_pagado = 'si' then
                
                v_momento_presupeustario = 4; --pagado 
                v_momento_aux='todo';
                
                   raise notice ' >>>> 0';
                
            ELSIF v_registros_comprobante.momento_comprometido = 'si'  and  v_registros_comprobante.momento_ejecutado = 'si'  and    v_registros_comprobante.momento_pagado = 'no'  THEN   
                 
                v_momento_presupeustario = 3;  --ejecutado
                 v_momento_aux='todo';
                 
                    raise notice ' >>>> 1';
             
       
            ELSIF v_registros_comprobante.momento_comprometido = 'no'  and  v_registros_comprobante.momento_ejecutado = 'si'  and    v_registros_comprobante.momento_pagado = 'no'  THEN   
                 
                v_momento_presupeustario = 3;  --ejecutado
                v_momento_aux='solo ejecutar';
                
                   raise notice ' >>>> 2';
                
            ELSIF v_registros_comprobante.momento_comprometido = 'no'  and  v_registros_comprobante.momento_ejecutado = 'no'  and    v_registros_comprobante.momento_pagado = 'si'  THEN   
                 
                v_momento_presupeustario = 4;  --pagado
                v_momento_aux='solo pagar';  
                
                   raise notice ' >>>> 3';   
           
            
            ELSIF v_registros_comprobante.momento_comprometido = 'si'  and  v_registros_comprobante.momento_ejecutado = 'no'  and    v_registros_comprobante.momento_pagado = 'no' then
              
              raise exception 'Solo comprometer no esta implmentado';
              
            ELSE 
            
             raise exception 'Combinacion de momentos no contemplada';  
       
       
            END IF;
          
             raise notice ' >>>> 4';
      
      
     v_aux = '';
    
 
             
             FOR v_registros in (
                                  select
                                     it.id_int_transaccion,
                                     it.id_partida,
                                     it.id_partida_ejecucion,
                                     it.id_partida_ejecucion_dev,
                                     it.importe_debe,
                                     it.importe_haber,
                                     it.importe_gasto,
                                     it.importe_recurso,
                                     it.id_centro_costo,
                                     par.sw_movimiento,  --  presupuestaria o  flujo
                                     par.sw_transaccional,  --titular o movimiento
                                     par.tipo,                -- recurso o gasto
                                     pr.id_presupuesto,
                                     it.importe_reversion,
                                     it.factor_reversion
                                  from conta.tint_transaccion it
                                  inner join pre.tpartida par on par.id_partida = it.id_partida
                                  inner join pre.tpresupuesto pr on pr.id_centro_costo = it.id_centro_costo
                                  where it.id_int_comprobante = p_id_int_comprobante
                                        and it.estado_reg = 'activo'       )  LOOP
                
                     
                        
                        IF    v_momento_aux='todo' or   v_momento_aux='solo ejecutar'  THEN
                          
                            -- si solo ejecutamos el presupuesto 
                            --  o (compromentemos y ejecutamos) 
                            --  o (compromentemos, ejecutamos y pagamos)     
                                
                                -- si  el comprobante tiene que comprometer
                                IF v_registros_comprobante.momento_comprometido = 'si'  then
                                  
                                      -- validamos que si tiene que comprometer la id_partida_ejecucion tiene que ser nulo
                                      
                                       IF v_registros.id_partida_ejecucion is not NULL THEN
                                       
                                           raise exception 'EL comprobante no puede estar marcada para comprometer, si ya existe un comprometido';
                                       
                                       END IF;
                                       
                                END IF; --IF comprometido  
                                
                                     
                                --si es una partida de presupuesto y no de flujo, la guardamos para comprometer
                                        
                                IF v_registros.sw_movimiento = 'presupuestaria' THEN
                                     
                                     v_monto_cmp = 0;
                                     v_i = v_i + 1;
                                     -- determinamos el monto a comprometer
                                     IF v_registros.tipo = 'gasto'  THEN
                                         v_monto_cmp  = v_registros.importe_debe;
                                     ELSE
                                         v_monto_cmp  = v_registros.importe_haber;
                                     END IF;
                                           
                                      
                                     --  armamos los array para enviar a presupuestos          
                                    
                                     va_id_presupuesto[v_i] = v_registros.id_presupuesto;
                                     va_id_partida[v_i]= v_registros.id_partida;
                                     va_momento[v_i]	= v_momento_presupeustario;
                                     va_monto[v_i]  = v_monto_cmp;
                                     va_id_moneda[v_i]  = v_registros_comprobante.id_moneda;
                                     va_id_partida_ejecucion [v_i] = v_registros.id_partida_ejecucion ;   
                                     va_columna_relacion[v_i]= 'id_int_transaccion';
                                     va_fk_llave[v_i] = v_registros.id_int_transaccion;
                                     va_id_transaccion[v_i]= v_registros.id_int_transaccion;
                                     va_fecha[v_i]=now()::date;  --OJO, talves sea necesario utilizar la fecha del comprobante
                                     
                                   -------------------------------------------------------  
                                   --   si existe monto a revertir y tenememos el id_partida_ejecucion, revertimos
                                   -------------------------------------------------------
                                   
                                   IF v_registros.importe_reversion > 0 and v_registros.id_partida_ejecucion is not null THEN
                                       v_i = v_i + 1;
                                       
                                        
                                        --  armamos los array para enviar a presupuestos          
                                       va_id_presupuesto[v_i] = v_registros.id_presupuesto;
                                       va_id_partida[v_i]= v_registros.id_partida;
                                       va_momento[v_i]	= 2;  --momento revertido
                                       va_monto[v_i]  = (v_registros.importe_reversion)*-1; --signo negativo para revertir
                                       va_id_moneda[v_i]  = v_registros_comprobante.id_moneda;
                                       va_id_partida_ejecucion [v_i] = v_registros.id_partida_ejecucion ;   
                                       va_columna_relacion[v_i]= 'id_int_transaccion';
                                       va_fk_llave[v_i] = v_registros.id_int_transaccion;
                                       va_id_transaccion[v_i]= v_registros.id_int_transaccion;
                                       va_fecha[v_i]=now()::date;
                                       
                                       v_marca_reversion = v_marca_reversion || v_i;
                                      
                                   
                                   END IF;
                                             
                                             
                                  
                                        
                                END IF; -- if partida presupuestaria
                            
                          
                          ELSIF   v_momento_aux='solo pagar'  THEN
                           
                          --si es solo pagar debemos identificar las transacciones del devengado 
                           
                          
                           v_aux = v_aux || ','||v_registros.id_int_transaccion;
                           
                                 FOR  v_registros_dev in (
                                                          select 
                                                            ird.id_int_rel_devengado,
                                                            ird.monto_pago,
                                                            ird.id_int_transaccion_dev,
                                                            it.id_partida_ejecucion_dev,
                                                            it.importe_reversion,
                                                            it.factor_reversion,
                                                            it.monto_pagado_revertido
                                                            
                                                          from  conta.tint_rel_devengado ird
                                                          inner join conta.tint_transaccion it 
                                                            on it.id_int_transaccion = ird.id_int_transaccion_dev
                                                          where  ird.id_int_transaccion_pag = v_registros.id_int_transaccion
                                                                 and ird.estado_reg = 'activo'
                                                         ) LOOP  
                                                         
                                              
                                               
                                              v_monto_x_pagar = v_registros_dev.monto_pago;
                                               -- revisar la reversion del devengado para ajustar el monto a pagar
                                              IF  v_registros_dev.factor_reversion > 0   THEN
                                                
                                                    v_monto_rev = round(v_monto_x_pagar * v_registros_dev.factor_reversion,2);
                                                    
                                                    v_monto_x_pagar = v_monto_x_pagar - v_monto_rev;
                                                    
                                                    
                                                    --si el monto a revertir es mayor que la diferencia de lo que sobra  puede ser un problema d redondeo
                                                    --y forzamos queiguale si la fiderencia no es mayor que 1
                                                    
                                                     IF (v_registros_dev.importe_reversion - v_registros_dev.monto_pagado_revertido) <  v_monto_rev THEN
                                                    
                                                           IF (v_monto_rev - (v_registros_dev.importe_reversion - v_registros_dev.monto_pagado_revertido)) > 1 THEN
                                                           
                                                              raise exception ' La diferencia por redondeo al determinar el monto a pagar presupuestariamente es mayor a 1, (%)',(v_monto_rev - (importe_reversion - monto_pagado_revertido));
                                                           
                                                           ELSE
                                                              
                                                              v_monto_rev = v_registros_dev.importe_reversion - v_registros_dev.monto_pagado_revertido;
                                                           
                                                           END IF;
                                                           
                                                           --actualizamos el monto no pagado
                                                           UPDATE conta.tint_transaccion it SET
                                                            monto_pagado_revertido = monto_pagado_revertido + v_monto_rev
                                                           WHERE it.id_int_transaccion = v_registros_dev.id_int_transaccion_dev;
                                                           
                                                    
                                                     END IF;
                                                 
                                               -- raise exception 'MONOTO %',  ;
                                              
                                              END IF;
                                               
                                               
                                               --obtener el factor de reversion de la transaccion de devengado
                                               
                                               --si el factor es mayor a cero reducrie el monto a pagar en esa proporcion
                                               
                                               v_i = v_i + 1;         
                                               --armamos los array para enviar a presupuestos          
                                               va_id_presupuesto[v_i] = NULL; 
                                               va_id_partida[v_i]= NULL;
                                               va_momento[v_i]	= 4;--momneto pago
                                               va_monto[v_i]  = v_monto_x_pagar;
                                               va_id_moneda[v_i]  = v_registros_comprobante.id_moneda;
                                               va_id_partida_ejecucion [v_i] = v_registros_dev.id_partida_ejecucion_dev;   
                                               va_columna_relacion[v_i]= 'id_int_transaccion';
                                               va_fk_llave[v_i] = v_registros.id_int_transaccion;
                                               va_id_int_rel_devengado[v_i]= v_registros_dev.id_int_rel_devengado;
                                               va_fecha[v_i]=now()::date;                           
                                 
                                 
                                               
                                                --raise exception 'xx % % %',v_i,va_fk_llave,va_momento ;
                                 
                                   END LOOP;
                               
                               
                             
              
                          ELSE
                               
                               raise exception 'Momento prespuestario no reconocido';
                          
                          END IF;
                          
                          
                 
               END LOOP; --end loop transacciones
               
              
               
              -- raise exception 'SOLO PAGAR %, %',v_i, v_aux;
            	
              -- llamar a la funcion de gestion presupuestaria incremeto presupuestario
          
               
             IF v_i > 0 THEN 
             
                       
                       
             
                                
                        va_resp_ges =  pre.f_gestionar_presupuesto(va_id_presupuesto, 
                                                                   va_id_partida, 
                                                                   va_id_moneda, 
                                                                   va_monto, 
                                                                   va_fecha, --p_fecha
                                                                   va_momento, 
                                                                   va_id_partida_ejecucion,--  p_id_partida_ejecucion 
                                                                   va_columna_relacion, 
                                                                   va_fk_llave);
                            
             END IF;
             
              
              
             
           
             --actualiza el los id en las transacciones
                
              IF    v_momento_aux='todo' or   v_momento_aux='solo ejecutar'  THEN
                
                     --actualizacion de los id_partida_ejecucion en las transacciones
                     
                      FOR v_cont IN 1..v_i LOOP
                         
                          IF v_momento_aux='solo ejecutar' THEN
                          
                          --raise exception 'v_marca_reversion %',v_marca_reversion;
                          	 
                                  --verificamos que no sea un trasaccion de reversion
                                  IF  (v_cont  =  ANY(v_marca_reversion)) THEN
                                  
                                  
                                       update conta.tint_transaccion it set
                                         id_partida_ejecucion_rev = va_resp_ges[v_cont],
                                         fecha_mod = now(),
                                         id_usuario_mod = p_id_usuario
                                      where it.id_int_transaccion  =  va_id_transaccion[v_cont];
                                
                                  ELSE
                                  
                                      update conta.tint_transaccion it set
                                         id_partida_ejecucion_dev = va_resp_ges[v_cont],
                                         fecha_mod = now(),
                                         id_usuario_mod = p_id_usuario
                                      where it.id_int_transaccion  =  va_id_transaccion[v_cont]; 
                                  
                                    
                                    
                                  END IF;
                          ELSE    
                            
                              update conta.tint_transaccion it set
                                 id_partida_ejecucion = va_resp_ges[v_cont],
                                 fecha_mod = now(),
                                 id_usuario_mod = p_id_usuario
                              where it.id_int_transaccion  =  va_id_transaccion[v_cont];
                          
                          END IF;
                         
                           
                     END LOOP;
              
           
              ELSIF   v_momento_aux='solo pagar'  THEN
              
                   FOR v_cont IN 1..v_i LOOP
                         
                              update conta.tint_rel_devengado rd set
                                 id_partida_ejecucion_pag = va_resp_ges[v_cont],
                                 fecha_mod = now(),
                                 id_usuario_mod = p_id_usuario
                              where rd.id_int_rel_devengado  =  va_id_int_rel_devengado[v_cont];
                          
                   END LOOP;
              
             END IF; 
       
       
    
    END IF;
    
    
   return 'exito'; 

    
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