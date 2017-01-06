--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_verificar_presupuesto_cbte (
  p_id_usuario integer,
  p_id_int_comprobante integer,
  p_igualar varchar = 'no'::character varying,
  p_fecha_ejecucion date = NULL::date,
  p_conexion varchar = NULL::character varying
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
    
    v_nombre_funcion 			varchar;
    v_registros_comprobante 	record;
    v_reg  						record;
    v_registros 				record;
    v_reg_par_eje				record;
    v_i 					integer;
    v_cont 					integer;
    --array para gestionar presupuesto
    va_id_presupuesto 		integer[];
    va_id_partida     		integer[];
    va_momento				INTEGER[];
    va_monto          		numeric[];
    va_temp_array           numeric[];
    va_id_moneda    		integer[];
    va_id_partida_ejecucion integer[];
    va_columna_relacion     varchar[];
    va_fk_llave             integer[];
    va_resp_ges              numeric[];
    va_fecha                 date[];
    va_id_transaccion        integer[];
    va_id_int_rel_devengado  integer[];
    
    
    v_monto_cmp  					numeric; 
    v_momento_presupeustario 		integer;
    v_momento_aux 					varchar;
    v_registros_dev 				record;
    v_aux  							varchar;
    v_monto_x_pagar  				numeric;
    v_monto_rev  					numeric;
    v_marca_reversion 				integer[];
    v_retorno 						varchar;
    v_error_presupuesto  			numeric;
    v_respuesta_verificar			record;
    va_tipo_partida   				varchar[];
    v_mensaje_error_validacion 		varchar;
    v_sw_error_validacion 			boolean;
    v_nombre_partida 				varchar;
    v_codigo_cc 					varchar;
    v_estado    					varchar;
    v_monto_previo_ejecutado   		numeric;
    v_monto_previo_revertido   		numeric;
    v_monto_previo_pagado      		numeric;
    v_resp_comp				   		varchar;
    va_resp_comp			   		varchar[];
    v_id_moneda						integer;
    v_id_moneda_base 				integer;
    v_sw_moneda_base 				varchar;
    
    v_importe_debe   				numeric;
    v_importe_haber			   		numeric;
    
   
    

BEGIN
	
	
    v_nombre_funcion:='conta.f_verificar_presupuesto_cbte';
    
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
    
    
    
    v_retorno = 'exito';
    
    select    
      ic.*,
      cl.codigo as codigo_clase_cbte,
      per.id_gestion
    into v_registros_comprobante
    from conta.tint_comprobante ic
    inner join conta.tclase_comprobante cl  on ic.id_clase_comprobante =  cl.id_clase_comprobante
    inner join param.tperiodo per on per.id_periodo = ic.id_periodo

    where ic.id_int_comprobante  =  p_id_int_comprobante;
    
    
     ---------------------------------------------------
     -- Determinar moneda de ejecucion presupeustaria
     -- Si viene de una regional y la moneda no  es dolar  (dolar ... id_moneda = 2)
     -- ejecutar moneda base
     ------------------------------------------------
     
     --determinar moneda base
     v_id_moneda_base = param.f_get_moneda_base();
     v_id_moneda = v_registros_comprobante.id_moneda;
     v_sw_moneda_base = 'no';
     
     
     IF v_registros_comprobante.vbregional = 'si' and v_registros_comprobante.id_moneda != 2 THEN
       v_id_moneda = v_id_moneda_base;
       v_sw_moneda_base = 'si';
     END IF;
    
      
     raise notice ' >>>> zzzzzzz';
     -- si el comprobante tiene efecto presupuestario'
    
    IF v_registros_comprobante.momento= 'presupuestario' THEN
   
           --recorrer todas las transacciones revisando las partidas presupuestarias
            v_i = 0;
           --Definir el momento 
            IF v_registros_comprobante.momento_comprometido = 'no'  and  v_registros_comprobante.momento_ejecutado = 'si'  and    v_registros_comprobante.momento_pagado = 'si' then
                
                v_momento_presupeustario = 4; --pagado 
                v_momento_aux='todo';
                
                   raise notice ' >>>> 0';
                
            ELSIF v_registros_comprobante.momento_comprometido = 'si'  and  v_registros_comprobante.momento_ejecutado = 'si'  and    v_registros_comprobante.momento_pagado = 'si'  THEN   
                 
                v_momento_presupeustario = 4;  --pagado  OJO verifica el mommento 
                v_momento_aux='todo';
              
            
            --RAC, aumentado 5/10/2015
            ELSIF v_registros_comprobante.momento_comprometido = 'si'  and  v_registros_comprobante.momento_ejecutado = 'si'  and    v_registros_comprobante.momento_pagado = 'no'  THEN   
                 
                v_momento_presupeustario = 3;  --ejecutado
                v_momento_aux='solo ejecutar';
                
            ELSIF v_registros_comprobante.momento_comprometido = 'no'  and  v_registros_comprobante.momento_ejecutado = 'si'  and    v_registros_comprobante.momento_pagado = 'no'  THEN   
                 
                v_momento_presupeustario = 3;  --ejecutado
                v_momento_aux='solo ejecutar';
                
            ELSIF v_registros_comprobante.momento_comprometido = 'no'  and  v_registros_comprobante.momento_ejecutado = 'no'  and    v_registros_comprobante.momento_pagado = 'si'  THEN   
                 
                v_momento_presupeustario = 4;  --pagado
                v_momento_aux='solo pagar';  
                
            ELSIF v_registros_comprobante.momento_comprometido = 'si'  and  v_registros_comprobante.momento_ejecutado = 'no'  and    v_registros_comprobante.momento_pagado = 'no' then
                raise exception 'Solo comprometer no esta implementado';
            ELSE 
                raise exception 'Combinación de momentos no contemplada';  
            END IF;
          
            v_aux = '';
           
           DROP TABLE IF EXISTS tt_check_presu;
           create temp table tt_check_presu(
                           id integer,
                           tipo_partida varchar,
                           id_presupuesto  integer,
                           id_partida  integer,
                           momento integer,
                           monto numeric,
                           id_moneda integer,
                           id_partida_ejecucion integer,
                           columna_relacion varchar,
                           fk_llave  integer,
                           id_transaccion integer,
                           momento_aux varchar,
                           fecha date,
                           id_int_rel_devengado integer,
                           estado varchar,
                           retorno varchar
                      )on commit drop;
                      
                      
              
             
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
                                     it.importe_debe_mb,
                                     it.importe_haber_mb,
                                     it.importe_gasto_mb,
                                     it.importe_recurso_mb,
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
                
                        IF v_sw_moneda_base = 'si' THEN
                            v_importe_debe = v_registros.importe_debe_mb;
                            v_importe_haber =  v_registros.importe_haber_mb;
                        ELSE
                            v_importe_debe = v_registros.importe_debe;
                            v_importe_haber =  v_registros.importe_haber;
                        END IF;
                        
                        IF    v_momento_aux='todo' or   v_momento_aux='solo ejecutar'  THEN
                          
                            -- si solo ejecutamos el presupuesto 
                            --  o (compromentemos y ejecutamos) 
                            --  o (compromentemos, ejecutamos y pagamos) 
                            
                            -- si tiene partida ejecucionde comprometido y nose correponde con la gestion
                            --  lo ponemos en null para que comprometa    
                            
                             IF v_registros.id_partida_ejecucion is not NULL THEN                                       
                                   
                                   select
                                       par.id_gestion
                                   into
                                      v_reg_par_eje
                                   from pre.tpartida_ejecucion pe
                                   inner join pre.tpartida par on par.id_partida = pe.id_partida
                                   where pe.id_partida_ejecucion = v_registros.id_partida_ejecucion;
                                   
                                    if v_reg_par_eje.id_gestion != v_registros_comprobante.id_gestion  then
                                        v_registros.id_partida_ejecucion = NULL;
                                    end if;
                                   
                                   
                                END IF;
                                
                                -- si  el comprobante tiene que comprometer
                                IF v_registros_comprobante.momento_comprometido = 'si'  then
                                  
                                      -- validamos que si tiene que comprometer la id_partida_ejecucion tiene que ser nulo
                                      IF v_registros.id_partida_ejecucion is not NULL THEN
                                         raise exception 'EL comprobante no puede estar marcada para comprometer, si ya existe un comprometido';
                                       END IF;
                                       
                                       --TODO verificar si el alcanza el presuuesto para comprometer
                                       
                                END IF; --IF comprometido  
                                
                                     
                                --si es una partida de presupuesto y no de flujo, la guardamos para comprometer
                                        
                                IF v_registros.sw_movimiento = 'presupuestaria' THEN
                                     
                                     v_monto_cmp = 0;
                                     v_i = v_i + 1;
                                     -- determinamos el monto a comprometer
                                     IF v_registros.tipo = 'gasto'  THEN
                                         v_monto_cmp  = v_importe_debe;
                                     ELSE
                                         v_monto_cmp  = v_importe_haber;
                                     END IF;
                                           
                                      
                                     --  armamos los array para enviar a presupuestos          
                                     va_tipo_partida[v_i] = v_registros.tipo;
                                     va_id_presupuesto[v_i] = v_registros.id_presupuesto;
                                     va_id_partida[v_i]= v_registros.id_partida;
                                     va_momento[v_i]	= v_momento_presupeustario;
                                     va_monto[v_i]  = v_monto_cmp;
                                     va_id_moneda[v_i]  = v_id_moneda;
                                     va_id_partida_ejecucion [v_i] = v_registros.id_partida_ejecucion ;   
                                     va_columna_relacion[v_i]= 'id_int_transaccion';
                                     va_fk_llave[v_i] = v_registros.id_int_transaccion;
                                     va_id_transaccion[v_i]= v_registros.id_int_transaccion;
                                     
                                   -- fechaejecucion presupuestaria  
                                     IF p_fecha_ejecucion is NULL THEN
                                       va_fecha[v_i]=v_registros_comprobante.fecha::date;  --, fecha del comprobante
                                     ELSE
                                      va_fecha[v_i]=p_fecha_ejecucion;  -- fecha como parametros
                                     END IF;
                                     
                                     --inserta en tabla temporal
                                     INSERT INTO tt_check_presu(
                                         id,
                                         tipo_partida,
                                         id_presupuesto,
                                         id_partida,
                                         momento,
                                         monto ,
                                         id_moneda ,
                                         id_partida_ejecucion ,
                                         columna_relacion ,
                                         fk_llave  ,
                                         id_transaccion ,
                                         momento_aux ,
                                         fecha
                                    ) 
                                    VALUES (
                                         v_i,
                                         v_registros.tipo,
                                         v_registros.id_presupuesto,
                                         v_registros.id_partida,
                                         v_momento_presupeustario,
                                         v_monto_cmp,
                                         v_id_moneda,
                                         v_registros.id_partida_ejecucion,
                                         'id_int_transaccion',
                                         v_registros.id_int_transaccion,
                                         v_registros.id_int_transaccion,
                                         v_momento_aux,
                                         va_fecha[v_i]
                                         
                                     );
                                     
                                    
                                     
                                   -------------------------------------------------------  
                                   --   si existe monto a revertir y tenememos el id_partida_ejecucion, revertimos
                                   -------------------------------------------------------
                                   
                                   IF v_registros.importe_reversion > 0 and v_registros.id_partida_ejecucion is not null THEN
                                       v_i = v_i + 1;
                                       
                                        
                                        --  armamos los array para enviar a presupuestos
                                       va_tipo_partida[v_i] = v_registros.tipo;          
                                       va_id_presupuesto[v_i] = v_registros.id_presupuesto;
                                       va_id_partida[v_i]= v_registros.id_partida;
                                       va_momento[v_i]	= 2;  --momento revertido
                                       va_monto[v_i]  = (v_registros.importe_reversion)*-1; --signo negativo para revertir
                                       va_id_moneda[v_i]  = v_id_moneda;
                                       va_id_partida_ejecucion [v_i] = v_registros.id_partida_ejecucion ;   
                                       va_columna_relacion[v_i]= 'id_int_transaccion';
                                       va_fk_llave[v_i] = v_registros.id_int_transaccion;
                                       va_id_transaccion[v_i]= v_registros.id_int_transaccion;
                                       va_fecha[v_i]=now()::date;
                                       
                                       v_marca_reversion = v_marca_reversion || v_i;
                                       
                                       
                                       --inserta en tabla temporal
                                       INSERT  INTO  tt_check_presu(
                                           id,
                                           tipo_partida,
                                           id_presupuesto,
                                           id_partida,
                                           momento,
                                           monto ,
                                           id_moneda ,
                                           id_partida_ejecucion ,
                                           columna_relacion ,
                                           fk_llave  ,
                                           id_transaccion ,
                                           momento_aux,
                                           fecha
                                      ) 
                                      VALUES (
                                         v_i,
                                         v_registros.tipo,
                                         v_registros.id_presupuesto,
                                         v_registros.id_partida,
                                         2,
                                         (v_registros.importe_reversion)*-1,
                                         v_id_moneda,
                                         v_registros.id_partida_ejecucion,
                                         'id_int_transaccion',
                                         v_registros.id_int_transaccion,
                                         v_registros.id_int_transaccion,
                                         v_momento_aux,
                                         va_fecha[v_i]
                                     );
                                      
                                   
                                   END IF;
                                             
                                             
                                  
                                        
                                END IF; -- if partida presupuestaria
                            
                          
                          ELSIF   v_momento_aux='solo pagar'  THEN
                           
                          --si es solo pagar debemos identificar las transacciones del devengado 
                           
                          --TODO verificar si existe diferencia por tipo de cambio
                          
                              v_aux = v_aux || ','||v_registros.id_int_transaccion;
                                 FOR  v_registros_dev in (
                                                          select 
                                                            ird.id_int_rel_devengado,
                                                            ird.monto_pago,
                                                            ird.monto_pago_mb, 
                                                            ird.id_int_transaccion_dev,
                                                            it.id_partida_ejecucion_rev,
                                                            it.id_partida_ejecucion_dev,
                                                            it.importe_reversion,
                                                            it.factor_reversion,
                                                            it.monto_pagado_revertido
                                                            
                                                          from  conta.tint_rel_devengado ird
                                                          inner join conta.tint_transaccion it 
                                                            on it.id_int_transaccion = ird.id_int_transaccion_dev
                                                          inner join pre.tpartida p on p.id_partida = it.id_partida 
                                                          where  ird.id_int_transaccion_pag = v_registros.id_int_transaccion
                                                                 and ird.estado_reg = 'activo'
                                                                 and p.sw_movimiento = 'presupuestaria'
                                                         ) LOOP  
                                                         
                                                 
                                                 
                                                         
                                                -- RAC 14/10/2015 
                                                -- OJO para sw a moneda base no estamos considerando las reversiones, 
                                                -- si hubieran tendriamso datos inconsistentes
                                                
                                                v_monto_x_pagar = v_registros_dev.monto_pago;
                                                IF v_sw_moneda_base = 'si' THEN
                                                  v_monto_x_pagar  = v_registros_dev.monto_pago_mb;
                                                END IF;
                                             
                                               
                                               -- revisar la reversion del devengado para ajustar el monto a pagar
                                               ----------------------------------------------------------------------------
                                               --   Obtener el factor de reversion de la transaccion de devengado      ---
                                               --   Ejeplo fue comprometido 100  se devego 87 por el IVA se revirtio 13 ---  
                                               --   presupeustariamente solo pagamos el 87                              ---
                                               ----------------------------------------------------------------------------
                                               
                                               
                                              IF  v_registros_dev.factor_reversion > 0 and v_registros_dev.id_partida_ejecucion_rev is not null   THEN
                                                
                                                    v_monto_rev = round(v_monto_x_pagar * v_registros_dev.factor_reversion,2);
                                                    
                                                    v_monto_x_pagar = v_monto_x_pagar - v_monto_rev;
                                                    
                                                    --si el monto a revertir es mayor que la diferencia de lo que sobra  puede ser un problema d redondeo
                                                    --y forzamos que iguale si la fiderencia no es mayor que 1
                                                    
                                                     IF (v_registros_dev.importe_reversion - v_registros_dev.monto_pagado_revertido) <  v_monto_rev THEN
                                                           IF (v_monto_rev - (v_registros_dev.importe_reversion - v_registros_dev.monto_pagado_revertido)) > 1 THEN
                                                           
                                                              raise exception ' La diferencia por redondeo al determinar el monto a pagar presupuestariamente es mayor a 1, (%)',(v_monto_rev - (v_registros_dev.importe_reversion - v_registros_dev.monto_pagado_revertido));
                                                           
                                                           ELSE
                                                               
                                                    
                                                               --si el factor es mayor a cero reducrie el monto a pagar en esa proporcion
                                                              v_monto_rev = v_registros_dev.importe_reversion - v_registros_dev.monto_pagado_revertido;
                                                           
                                                           END IF;
                                                           
                                                     END IF;
                                                 
                                               -- raise exception 'MONOTO %',  ;
                                              
                                              END IF;
                                               
                                              
                                               v_i = v_i + 1;         
                                               --armamos los array para enviar a presupuestos          
                                               va_id_presupuesto[v_i] = NULL; 
                                               va_id_partida[v_i]= NULL;
                                               va_momento[v_i]	= 4;--momneto pago
                                               va_monto[v_i]  = v_monto_x_pagar;
                                               va_id_moneda[v_i]  = v_id_moneda;
                                               va_id_partida_ejecucion [v_i] = v_registros_dev.id_partida_ejecucion_dev;   
                                               va_columna_relacion[v_i]= 'id_int_transaccion';
                                               va_fk_llave[v_i] = v_registros.id_int_transaccion;
                                               va_id_int_rel_devengado[v_i]= v_registros_dev.id_int_rel_devengado;
                                               va_fecha[v_i]=now()::date;  
                                               
                                               
                                               INSERT  INTO tt_check_presu(
                                                   id,
                                                   tipo_partida,
                                                   id_presupuesto,
                                                   id_partida,
                                                   momento,
                                                   monto ,
                                                   id_moneda ,
                                                   id_partida_ejecucion ,
                                                   columna_relacion ,
                                                   fk_llave  ,
                                                   id_transaccion ,
                                                   id_int_rel_devengado,
                                                   momento_aux ,
                                                   fecha
                                              ) 
                                              VALUES (
                                                   v_i,
                                                   NULL,
                                                   NULL,
                                                   NULL,
                                                   4,
                                                   v_monto_x_pagar,
                                                   v_id_moneda,
                                                   v_registros_dev.id_partida_ejecucion_dev,
                                                   'id_int_transaccion',
                                                   v_registros.id_int_transaccion,
                                                   v_registros.id_int_transaccion,
                                                   v_registros_dev.id_int_rel_devengado,
                                                   v_momento_aux,
                                                   va_fecha[v_i]
                                                   
                                               );
                                 
                                   END LOOP;
                               
                           ELSE
                               
                               raise exception 'Momento prespuestario no reconocido';
                          
                          END IF;
                          
                          
                 
               END LOOP; --end loop transacciones
               
              
               
           
            	
         
          v_sw_error_validacion = FALSE;
          v_mensaje_error_validacion = '';
          
          --recuepra el error maximo opr redondeo
         v_error_presupuesto=pxp.f_get_variable_global('error_presupuesto')::numeric;
         IF v_error_presupuesto is NULL THEN
             raise exception 'No se encontro el valor de la variable global : error_presupuesto';
         END IF;
          
        
      
         ---------------------------------------------------------------- 
         --si tenemos trasaccione y es un comprobante presupuestario
         -----------------------------------------------------------------
         IF v_i > 0 and v_registros_comprobante.momento= 'presupuestario' THEN
                    
                     IF (v_momento_aux='todo' or   v_momento_aux='solo ejecutar') and  (v_registros_comprobante.momento_comprometido = 'si' or v_registros_comprobante.sw_editable = 'si') THEN
                       --------------------------------
                       -- Si comprometemos presupeusto
                       ---------------------------------
                           FOR v_reg in (select 
                                               tipo_partida,
                                               id_presupuesto,
                                               id_partida,
                                               sum(monto)  as monto
                                        from tt_check_presu
                                        group by tipo_partida, 
                                                id_partida,
                                                id_presupuesto)  LOOP
                           
                           
                                   -- verifica si existe presupuesto
                                   -- TODO si es un cbte de regional  y diferente a dolares convertir a BS
                                   
                                   v_resp_comp =  pre.f_verificar_presupuesto_partida(
                                                                  v_reg.id_presupuesto, 
                                                                  v_reg.id_partida, 
                                                                  v_id_moneda, 
                                                                  v_reg.monto,
                                                                  'si');
                                                                  
                                   va_resp_comp = regexp_split_to_array(v_resp_comp, ',');  
                                   
                                   IF va_resp_comp[1] = 'false' THEN
                                      v_retorno = 'falla';
                                   ELSE
                                      v_retorno = 'exito';
                                   END IF;                            
                                   
                                   --si existe error recuperamos los datos del presupuesto y partida
                                   IF v_retorno = 'falla' THEN 
                                       v_sw_error_validacion = TRUE;
                                                  
                                         select
                                          p.nombre_partida
                                        into
                                          v_nombre_partida 
                                        from pre.tpartida p 
                                        where p.id_partida = v_reg.id_partida; 
                                                      
                                                      
                                                      
                                        select 
                                         cc.codigo_cc
                                        into
                                          v_codigo_cc 
                                        from pre.tpresupuesto pre
                                        inner join param.vcentro_costo cc on pre.id_centro_costo = cc.id_centro_costo
                                        where pre.id_presupuesto = v_reg.id_presupuesto;
                                                      
                                       v_mensaje_error_validacion = v_mensaje_error_validacion|| COALESCE(v_nombre_partida,'');
                                       v_mensaje_error_validacion = v_mensaje_error_validacion||'  ' || COALESCE(v_codigo_cc,'');
                                       v_mensaje_error_validacion = v_mensaje_error_validacion||' Monto: ' ||COALESCE(v_reg.monto::varchar,'0')||' y el disponible '||va_resp_comp[2]||'<br>';
                                                     
                                    END IF;
                           END LOOP;
                    
         
                      ELSEIF    v_momento_aux='todo' or   v_momento_aux='solo ejecutar'  THEN
                      ---------------------------------------------
                      --   Si ejecutamos y pagamos sin comprometer
                     -------------------------------------------------
                                  
                                    -- si  
                                    --  o (ejecutamos) 
                                    --  o (ejecutamos y pagamos)                              
                          
                                   --verificamos todos lo montos si se tiene dinero suficiendete para proseguir
                                  
                               
                                   FOR v_cont IN 1..v_i LOOP
                                   
                                             v_respuesta_verificar = pre.f_verificar_com_eje_pag(
                                                                                              va_id_partida_ejecucion[v_cont],
                                                                                              va_id_moneda[v_cont]);
                                                                                              
                                             --antes de validar el monto,  calculamos en la tabla temporal los montos previos ya ejecutados
                                              select
                                                sum(tt.monto) 
                                              into 
                                               v_monto_previo_ejecutado
                                              from tt_check_presu tt 
                                              where id < v_cont 
                                                and id_partida_ejecucion =  va_id_partida_ejecucion[v_cont]
                                                and estado = 'ejecutado';
                                                            
                                            --caculamos los montos previos revertidos    
                                            select
                                                sum(tt.monto) 
                                              into 
                                               v_monto_previo_revertido
                                              from tt_check_presu tt 
                                              where id < v_cont 
                                                and id_partida_ejecucion =  va_id_partida_ejecucion[v_cont]
                                                and estado = 'revertido';                                                 
                                   
                                   
                                             --si no es el momento de reversion (2)
                                             -- y si es una partida de gasto      
                                             IF  va_tipo_partida[v_cont]='gasto' THEN
                                             
                                                 ----------------------------
                                                 -- COMPROMETER 
                                                 ---------------------------
                                                 
                                                 IF va_momento[v_cont] = 1 THEN
                                                 
                                                         va_temp_array[v_cont] = 0;
                                                         v_estado = 'ejecutado';
                                                         
                                                         --validamso que el monto a ejecutar sea menor o igual que el faltante por comprometer
                                                          IF  va_monto[v_cont] <= va_temp_array[v_cont]  + v_error_presupuesto::numeric THEN
                                                             v_retorno = 'exito';
                                                              IF  va_monto[v_cont] > va_temp_array[v_cont] THEN
                                                                  va_monto[v_cont] = va_temp_array[v_cont];
                                                              END IF;
                                                            
                                                          ELSE
                                                             v_retorno = 'falla';
                                                             
                                                          END IF;
                                                 
                                                 
                                                 ------------------------------
                                                 --  EJECUTAR O PAGAR
                                                 ------------------------------
                                                 ELSIF va_momento[v_cont] != 2 THEN
                                                           
                                                         --calcula el saldo
                                                         va_temp_array[v_cont] = COALESCE(v_respuesta_verificar.ps_comprometido,0.00::numeric) - COALESCE(v_monto_previo_ejecutado,0.0) + COALESCE((v_monto_previo_revertido*-1), 0.0)  - COALESCE(v_respuesta_verificar.ps_ejecutado,0.00::numeric);
                                                         v_estado = 'ejecutado';
                                                         
                                                         --validamso que el monto a ejecutar sea menor o igual que el faltante por comprometer
                                                          IF  va_monto[v_cont] <= va_temp_array[v_cont]  + v_error_presupuesto::numeric THEN
                                                             v_retorno = 'exito';
                                                              IF  va_monto[v_cont] > va_temp_array[v_cont] THEN
                                                                  va_monto[v_cont] = va_temp_array[v_cont];
                                                              END IF;
                                                            
                                                          ELSE
                                                             v_retorno = 'falla';
                                                             
                                                          END IF;  
                                                  ----------------------------
                                                  -- REVERTIR
                                                  ---------------------------
                                                  ElSIF va_momento[v_cont] = 2  and va_monto[v_cont] < 0 THEN    --si es revertido el monto es negativo
                                                        
                                                        
                                                       
                                                  
                                                         -- si es el caso de reversion ..   
                                                         va_temp_array[v_cont] = COALESCE(v_respuesta_verificar.ps_comprometido,0.00::numeric) - COALESCE(v_monto_previo_ejecutado,0.0) + COALESCE((v_monto_previo_revertido*-1), 0.0) - COALESCE(v_respuesta_verificar.ps_ejecutado,0.00::numeric);
                                                         v_estado = 'revertido';
                                                          -- si el momento es 2 y el monto es menor a cero se bsca la reversion de monto
                                                          -- validamos que el monto comprometido no ejecutado sea mayor o igual que el monto que se quiere revertir
                                                      
                                                          IF  (va_monto[v_cont]*-1) <= va_temp_array[v_cont]  + v_error_presupuesto::numeric THEN
                                                             
                                                              v_retorno = 'exito';
                                                             
                                                             IF  (va_monto[v_cont]*-1) > va_temp_array[v_cont] THEN
                                                                 va_monto[v_cont] = (va_temp_array[v_cont]*-1);
                                                             END IF;
                                                          
                                                          ELSE
                                                             v_retorno = 'falla';
                                                          END IF;
                                                          
                                                          -- raise exception 'xxxx %,%,%,%,%',va_monto[v_cont],va_monto[v_cont],va_temp_array[v_cont],v_monto_previo_ejecutado,v_monto_previo_revertido; 
                                                 
                                                 
                                                  ELSE
                                                         --TODO verificacion si necesita comprometer
                                                         raise exception 'No opcion no validada';
                                                 
                                                  END IF;
                                                  
                                                  --actualicemos ele stado y valor de retorno para el registro
                                                  UPDATE tt_check_presu set
                                                     estado = v_estado,
                                                     retorno = v_retorno,
                                                     monto = va_monto[v_cont]
                                                  where id = v_cont;
                                                  
                                                  
                                                 
                                                  
                                                 --si existe error recuperamos los datos del presupuesto y partida
                                                 IF v_retorno = 'falla' THEN 
                                                     v_sw_error_validacion = TRUE;
                                                  
                                                       select
                                                        p.nombre_partida
                                                      into
                                                        v_nombre_partida 
                                                      from pre.tpartida p 
                                                      where p.id_partida = va_id_partida[v_cont]; 
                                                      
                                                      
                                                      
                                                      select 
                                                       cc.codigo_cc
                                                      into
                                                        v_codigo_cc 
                                                      from pre.tpresupuesto pre
                                                      inner join param.vcentro_costo cc on pre.id_centro_costo = cc.id_centro_costo
                                                      where pre.id_presupuesto = va_id_presupuesto[v_cont];
                                                      
                                                     v_mensaje_error_validacion = v_mensaje_error_validacion|| COALESCE(v_nombre_partida,'');
                                                     v_mensaje_error_validacion = v_mensaje_error_validacion||'  ' || COALESCE(v_codigo_cc,'');
                                                     v_mensaje_error_validacion = v_mensaje_error_validacion||' Monto: ' ||COALESCE(va_monto[v_cont]::varchar,'0')||' y el disponible '||va_temp_array[v_cont]||'<br>';
                                                     
                                                  END IF;
                                            
                                           END IF; --IF SI no son partidas de gasto
                                          
                                   END LOOP;
                                   
                                    --raise exception 'qq  xxxx  % - % - %', va_momento,va_monto,va_temp_array;
                                   
                                   --COALESCE(v_respuesta_verificar.ps_pagado,0.00::numeric)
                           
                   ELSIF  v_momento_aux = 'solo pagar'  THEN 
                          
                                --TODO, al pagar, verificar si alcanza el monto devengado
                                -- considerando diferencia diferencia por tipos de cambio
                                
                                FOR v_cont IN 1..v_i LOOP 
                                
                                      v_respuesta_verificar = pre.f_verificar_com_eje_pag(
                                                                                  va_id_partida_ejecucion[v_cont],
                                                                                  va_id_moneda[v_cont]);
                                      
                                      --antes de validar el monto,  calculamos en la tabla temporal los montos previos ya pagado
                                      select
                                        sum(tt.monto) 
                                      into 
                                       v_monto_previo_pagado
                                      from tt_check_presu tt 
                                      where id < v_cont 
                                        and id_partida_ejecucion =  va_id_partida_ejecucion[v_cont]
                                        and estado = 'pagado';
                                      
                                      v_estado = 'pagado';
                                      
                                      va_temp_array[v_cont] = COALESCE(v_respuesta_verificar.ps_ejecutado,0.00::numeric)  - COALESCE(v_monto_previo_pagado,0.0)  - COALESCE(v_respuesta_verificar.ps_pagado,0.00::numeric) ;                                           
                                      
                                      
                                      IF  va_monto[v_cont] <= va_temp_array[v_cont] + v_error_presupuesto  THEN
                                        v_retorno = 'exito';
                                        IF  va_monto[v_cont] > va_temp_array[v_cont] THEN
                                            va_monto[v_cont] = va_temp_array[v_cont];
                                        END IF;
                                        
                                      ELSE
                                          v_retorno = 'falla';
                                     
                                
                                      END IF;
                                      
                                      --actualicemos el estado y valor de retorno para el registro
                                      UPDATE tt_check_presu set
                                         estado = v_estado,
                                         retorno = v_retorno,
                                         monto =  va_monto[v_cont]
                                      where id = v_cont;
                                      
                                      IF v_retorno = 'falla' THEN 
                                          
                                          v_sw_error_validacion = TRUE;
                                          v_mensaje_error_validacion = v_mensaje_error_validacion||'al pagar el  Monto: ' ||COALESCE(va_monto[v_cont]::varchar,'0')||' y el disponible es '||va_temp_array[v_cont]||'<br>';
                                      END IF;                                           
                           
                               END LOOP;
                          
                          
                          
                          ELSE
                             
                             raise exception 'Momento presupuestario no reconocido';
                          
                          END IF; --IF SI ES   v_momento_aux='todo' or   v_momento_aux='solo ejecutar' 
           
               END IF;  --FIN IF TAMANHO es mayor a cero
               
               
               
               IF v_sw_error_validacion THEN
               
                  raise exception 'Error al verificar presupuesto segun el siguiente detalle: <br><br> % <br><br>',v_mensaje_error_validacion;
               
               END IF;
               
          
       
    
    END IF; -- fin del if de movimiento presupuestario
    
    
    return v_retorno; 

    
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