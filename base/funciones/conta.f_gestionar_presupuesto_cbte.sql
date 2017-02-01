--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_gestionar_presupuesto_cbte (
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
    va_nro_tramite    		varchar[];
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
    
    v_retorno varchar;
    v_error_presupuesto  numeric;
    v_respuesta_verificar	record;
    va_tipo_partida   varchar[];
    
    v_mensaje_error_validacion varchar;
    v_sw_error_validacion boolean;
    
    v_nombre_partida  varchar;
    v_codigo_cc varchar;
    
    v_monto_previo_ejecutado numeric;
    v_monto_previo_pagado    numeric;
    v_monto_previo_revertido numeric;
    
    v_ano_1  integer;
    v_ano_2  integer;
    
    --gonzalo
    v_id_finalidad		integer;
    v_estado_cbte_pago	varchar;
    v_respuesta_libro_bancos varchar;
    v_prioridad_conta		integer;
    v_prioridad_libro		integer;
    v_id_moneda				integer;
    v_id_moneda_base		integer;
    v_sw_moneda_base		varchar;
    v_importe_debe 			numeric;
    v_importe_haber 			numeric;
    v_importe_debe_mb			numeric;
    v_importe_haber_mb 			numeric;
    v_monto_cmp_mb 			numeric;
    va_monto_mb 			numeric[];
    v_monto_previo_ejecutado_mb	numeric;
    v_monto_previo_revertido_mb	numeric;

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
    
    v_retorno = 'exito';
    
    select    
      ic.momento,
      ic.id_clase_comprobante,
      cl.codigo as codigo_clase_cbte,
      ic.momento,
      ic.momento_comprometido,
      ic.momento_ejecutado,
      ic.momento_pagado,
      ic.estado_reg,
      ic.id_moneda,
      ic.fecha,
      ic.vbregional,
      ic.temporal,
      ic.nro_tramite,
      ic.cbte_reversion
    into v_registros_comprobante
    from conta.tint_comprobante ic
    inner join conta.tclase_comprobante cl  on ic.id_clase_comprobante =  cl.id_clase_comprobante
    where ic.id_int_comprobante  =  p_id_int_comprobante;
    
     ---------------------------------------------------
     -- Determinar moneda de ejcucion presupeustaria
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
    
      
     
     -- si el comprobante tiene efecto presupuestario'
   
    IF v_registros_comprobante.momento = 'presupuestario' THEN
    
            --recuepra el error maximo por  redondeo
            v_error_presupuesto=pxp.f_get_variable_global('error_presupuesto')::numeric;
            IF v_error_presupuesto is NULL THEN
             raise exception 'No se encontro el valor de la variable global : error_presupuesto';
            END IF;
    
   
           --recorrer todas las transacciones revisando las partidas presupuestarias
            v_i = 0;
           --Definir el momento 
           IF v_registros_comprobante.momento_comprometido = 'no'  and  v_registros_comprobante.momento_ejecutado = 'si'  and    v_registros_comprobante.momento_pagado = 'si' then
                
                 v_momento_presupeustario = 4; --pagado 
                 v_momento_aux='todo';
                
           ELSIF v_registros_comprobante.momento_comprometido = 'si'  and  v_registros_comprobante.momento_ejecutado = 'si'  and    v_registros_comprobante.momento_pagado = 'si'  THEN   
                 
                  v_momento_presupeustario = 4;  --pagado  OJO verifica el mommento 
                  v_momento_aux='todo';
                 
                    raise notice ' >>>> 1';
            
              --RAC, aumentado 5/10/2015
    	   ELSIF v_registros_comprobante.momento_comprometido = 'si'  and  v_registros_comprobante.momento_ejecutado = 'si'  and    v_registros_comprobante.momento_pagado = 'no'  THEN   
                 
                  v_momento_presupeustario = 3;  --ejecutado
                  v_momento_aux='solo ejecutar';
                 
                    raise notice ' >>>> 1';      
                
                
           ELSIF v_registros_comprobante.momento_comprometido = 'no'  and  v_registros_comprobante.momento_ejecutado = 'si'  and    v_registros_comprobante.momento_pagado = 'no'  THEN   
                 
                v_momento_presupeustario = 3;  --ejecutado
                v_momento_aux='solo ejecutar';
                
           ELSIF v_registros_comprobante.momento_comprometido = 'no'  and  v_registros_comprobante.momento_ejecutado = 'no'  and    v_registros_comprobante.momento_pagado = 'si'  THEN   
                 
                v_momento_presupeustario = 4;  --pagado
                v_momento_aux='solo pagar';  
                
           ELSIF v_registros_comprobante.momento_comprometido = 'si'  and  v_registros_comprobante.momento_ejecutado = 'no'  and    v_registros_comprobante.momento_pagado = 'no' then
              
              raise exception 'Solo comprometer no esta implmentado';
              
           ELSE 
            
             raise exception 'Combinacion de momentos no contemplada';  
       
       
           END IF;
            
            
          v_aux = '';
          
          --crea tabla temporal para almacenar los que seran ejecutados  
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
                   
                 
                   
                   
                   
                   IF    v_momento_aux = 'todo' or   v_momento_aux='solo ejecutar'  THEN
                          
                            -- si solo ejecutamos el presupuesto 
                            --  o (compromentemos y ejecutamos) 
                            --  o (compromentemos, ejecutamos y pagamos)     
                                
                                 
                                
                                     
                                --si es una partida de presupuesto y no de flujo, la guardamos para comprometer
                                        
                                IF v_registros.sw_movimiento = 'presupuestaria' THEN
                                
                                
                                      -- si  el comprobante tiene que comprometer
                                      IF v_registros_comprobante.momento_comprometido = 'si'  then                                  
                                            -- validamos que si tiene que comprometer la id_partida_ejecucion tiene que ser nulo                                      
                                             IF v_registros.id_partida_ejecucion is not NULL THEN                                       
                                                 raise exception 'EL comprobante no puede estar marcada para comprometer, si ya existe un comprometido';
                                             END IF;
                                      ELSE  
                                          --RAC 02/12/2016...   
                                          IF v_registros.id_partida_ejecucion is  NULL THEN                                       
                                                 raise exception 'El comprobante esta marcado  para no comprometer, y no tiene un origen comprometido, id %',v_registros.id_partida;
                                          END IF;      
                                      END IF; --IF comprometido 
                                     
                                     v_monto_cmp = 0;
                                     v_i = v_i + 1;
                                     -- determinamos el monto a comprometer
                                     
                                     IF v_registros.tipo = 'gasto'  THEN
                                         -- importe debe ejecucion
                                         IF v_importe_debe > 0 THEN
                                             v_monto_cmp  = v_importe_debe;                                            
                                         END IF;
                                         --importe haber es reversion, multiplicar por -1
                                         IF v_importe_haber > 0 THEN
                                             v_monto_cmp  = v_importe_haber * (-1);
                                         END IF;
                                     ELSE
                                         IF v_importe_haber > 0 THEN
                                           v_monto_cmp  = v_importe_haber;                                           
                                         END IF;
                                         --importe debe es reversion, multiplicar por -1
                                         IF v_importe_debe > 0 THEN
                                             v_monto_cmp  = v_importe_debe * (-1);                                             
                                         END IF;
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
                                     va_nro_tramite[v_i]= v_registros_comprobante.nro_tramite;
                                     
                                     -- fechaejecucion presupuestaria  
                                     IF p_fecha_ejecucion is NULL THEN
                                       va_fecha[v_i]=v_registros_comprobante.fecha::date;  --, fecha del comprobante
                                     ELSE
                                      va_fecha[v_i]=p_fecha_ejecucion;  -- fecha como parametros
                                     END IF;
                                     
                                     --chequeamos si el presupuesto alcanza, 
                                     --si no alcanza,  pero la diferencia es minima ajustamos el monto a ejecutar
                                     v_respuesta_verificar = pre.f_verificar_com_eje_pag(
                                                                                  va_id_partida_ejecucion[v_i],
                                                                                  va_id_moneda[v_i]);
                                                                                  
                                    
                                    v_monto_previo_ejecutado = 0;
                                    v_monto_previo_revertido = 0;
                                                                                  
                                    -- antes de validar el monto,  calculamos en la tabla temporal los montos previos ya ejecutados
                                    select
                                      sum(tt.monto)
                                    into 
                                     v_monto_previo_ejecutado
                                    from tt_check_presu tt 
                                    where id < v_i 
                                      and id_partida_ejecucion =  va_id_partida_ejecucion[v_i]
                                      and estado = 'ejecutado';
                                                            
                                  -- caculamos los montos previos revertidos    
                                  select
                                      sum(tt.monto)
                                    into 
                                     v_monto_previo_revertido
                                    from tt_check_presu tt 
                                    where id < v_i 
                                      and id_partida_ejecucion =  va_id_partida_ejecucion[v_i]
                                      and estado = 'revertido';                                              
                                                                                  
                                                                                  
                                    IF  va_monto[v_i] <= (COALESCE(v_respuesta_verificar.ps_comprometido,0.00::numeric) - COALESCE(v_monto_previo_ejecutado,0.0) + COALESCE((v_monto_previo_revertido*-1), 0.0) - COALESCE(v_respuesta_verificar.ps_ejecutado,0.00::numeric) + v_error_presupuesto) THEN
                                        
                                         IF  va_monto[v_i] > (COALESCE(v_respuesta_verificar.ps_comprometido,0.00::numeric) - COALESCE(v_monto_previo_ejecutado,0.0) + COALESCE((v_monto_previo_revertido*-1), 0.0) - COALESCE(v_respuesta_verificar.ps_ejecutado,0.00::numeric)) THEN
                                      
                                             va_monto[v_i] = COALESCE(v_respuesta_verificar.ps_comprometido,0.00::numeric) - COALESCE(v_monto_previo_ejecutado,0.0) + COALESCE((v_monto_previo_revertido*-1), 0.0) - COALESCE(v_respuesta_verificar.ps_ejecutado,0.00::numeric);
                                      
                                         END IF;
                                      
                                    END IF;
                                    
                                    ----------------------------------------------------
                                    --insertamos el nuevo valor en la tabla temporal
                                    ----------------------------------------------------
                                    
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
                                         fecha,
                                         estado
                                    ) 
                                    VALUES (
                                         v_i,
                                         va_tipo_partida[v_i],
                                         va_id_presupuesto[v_i],
                                         va_id_partida[v_i],
                                         va_momento[v_i],
                                         va_monto[v_i] ,
                                        
                                         va_id_moneda[v_i] ,
                                         va_id_partida_ejecucion[v_i] ,
                                         va_columna_relacion[v_i] ,
                                         va_fk_llave[v_i]  ,
                                         va_id_transaccion[v_i] ,
                                         v_momento_aux ,
                                         va_fecha[v_i],
                                         'ejecutado'
                                         
                                     );
                                
                                
                                
                                   -------------------------------------------------------------------------------  
                                   --   si existe monto a revertir y tenememos el id_partida_ejecucion, revertimos
                                   -----------------------------------------------------------------------------
                                   
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
                                                   va_columna_relacion[v_i] = 'id_int_transaccion';
                                                   va_fk_llave[v_i] = v_registros.id_int_transaccion;
                                                   va_id_transaccion[v_i] = v_registros.id_int_transaccion;
                                                   va_nro_tramite[v_i]= v_registros_comprobante.nro_tramite;

                                                   
                                                   -- fechaejecucion presupuestaria  
                                                   IF p_fecha_ejecucion is NULL THEN
                                                     va_fecha[v_i]=v_registros_comprobante.fecha::date;  --, fecha del comprobante
                                                   ELSE
                                                    va_fecha[v_i]=p_fecha_ejecucion;  -- fecha como parametros
                                                   END IF;
                                                   
                                                   v_marca_reversion = v_marca_reversion || v_i;
                                                   
                                                   
                                                   --chequeamos si el presupuesto alcanza para revertir, 
                                                   --si no,  pero la diferencia es minima ajustamos el monto a ejecutar
                                                   v_respuesta_verificar = pre.f_verificar_com_eje_pag(
                                                                                              va_id_partida_ejecucion[v_i],
                                                                                              va_id_moneda[v_i]);
                                                                                              
                                                   v_monto_previo_ejecutado = 0;
                                                   v_monto_previo_revertido = 0;
                                                   --antes de validar el monto,  calculamos en la tabla temporal los montos previos ya ejecutados
                                                    select
                                                      sum(tt.monto) 
                                                    into 
                                                     v_monto_previo_ejecutado
                                                    from tt_check_presu tt 
                                                    where id < v_i 
                                                      and id_partida_ejecucion =  va_id_partida_ejecucion[v_i]
                                                     and estado = 'ejecutado';
                                                                            
                                                  --caculamos los montos previos revertidos    
                                                  select
                                                      sum(tt.monto) 
                                                    into 
                                                     v_monto_previo_revertido
                                                    from tt_check_presu tt 
                                                    where id < v_i 
                                                      and id_partida_ejecucion =  va_id_partida_ejecucion[v_i]
                                                      and estado = 'revertido';                                           
                                                  
                                                 
                                                  --como esta revirtiendo tenemos que considerar el monto que ejecutamso en el anterior paso  -va_monto[v_i -1]                                         
                                                  
                                                  IF  (va_monto[v_i]*-1) <= (COALESCE(v_respuesta_verificar.ps_comprometido,0.00::numeric) - COALESCE(v_monto_previo_ejecutado,0.0) + COALESCE((v_monto_previo_revertido*-1), 0.0) -COALESCE(v_respuesta_verificar.ps_ejecutado,0.00::numeric) + v_error_presupuesto) THEN
                                                    
                                                     IF  (va_monto[v_i]*-1) > (COALESCE(v_respuesta_verificar.ps_comprometido,0.00::numeric) - COALESCE(v_monto_previo_ejecutado,0.0) + COALESCE((v_monto_previo_revertido*-1), 0.0) - COALESCE(v_respuesta_verificar.ps_ejecutado,0.00::numeric)) THEN
                                                  
                                                         va_monto[v_i] = (COALESCE(v_respuesta_verificar.ps_comprometido,0.00::numeric) - COALESCE(v_monto_previo_ejecutado,0.0) + COALESCE((v_monto_previo_revertido*-1), 0.0) - COALESCE(v_respuesta_verificar.ps_ejecutado,0.00::numeric))*-1;
                                                  
                                                     END IF;
                                                  
                                                 END IF;
                                                
                                                 --insertamos el nuevo valor en la tabla temporal
                                        
                                                INSERT INTO tt_check_presu(
                                                     id,
                                                     tipo_partida,
                                                     id_presupuesto,
                                                     id_partida,
                                                     momento,
                                                     monto,                                                   
                                                     id_moneda ,
                                                     id_partida_ejecucion ,
                                                     columna_relacion ,
                                                     fk_llave  ,
                                                     id_transaccion ,
                                                     momento_aux ,
                                                     fecha,
                                                     estado
                                                ) 
                                                VALUES (
                                                     v_i,
                                                     va_tipo_partida[v_i],
                                                     va_id_presupuesto[v_i],
                                                     va_id_partida[v_i],
                                                     va_momento[v_i],
                                                     va_monto[v_i] ,                                                    
                                                     va_id_moneda[v_i] ,
                                                     va_id_partida_ejecucion[v_i] ,
                                                     va_columna_relacion[v_i] ,
                                                     va_fk_llave[v_i]  ,
                                                     va_id_transaccion[v_i] ,
                                                     v_momento_aux ,
                                                     va_fecha[v_i],
                                                     'revertido'
                                                 );
                                                  
                                       END IF;
                                             
                                END IF; -- if partida presupuestaria
                            
                  ELSIF   v_momento_aux='solo pagar'  THEN
                           
                                --si es solo pagar debemos identificar las transacciones del devengado 
                           
                          
                                v_aux = v_aux || ','||v_registros.id_int_transaccion;
                          
                                FOR  v_registros_dev in (
                                                          select 
                                                            ird.id_int_rel_devengado,
                                                            ird.monto_pago,
                                                            ird.monto_pago_mb,
                                                            ird.id_int_transaccion_dev,
                                                            it.id_partida_ejecucion_dev,
                                                            it.importe_reversion,
                                                            it.factor_reversion,
                                                            it.monto_pagado_revertido,
                                                            ic.fecha,
                                                            it.id_partida_ejecucion_rev
                                                            
                                                          from  conta.tint_rel_devengado ird
                                                          inner join conta.tint_transaccion it 
                                                            on it.id_int_transaccion = ird.id_int_transaccion_dev
                                                          inner join pre.tpartida p on p.id_partida = it.id_partida 
                                                          
                                                          inner join conta.tint_comprobante ic on ic.id_int_comprobante = it.id_int_comprobante
                                                          where  ird.id_int_transaccion_pag = v_registros.id_int_transaccion
                                                                 and ird.estado_reg = 'activo'
                                                                 and p.sw_movimiento = 'presupuestaria'
                                                         ) LOOP  
                                                         
                                              
                                              IF v_sw_moneda_base = 'si' THEN
                                                 v_monto_x_pagar = v_registros_dev.monto_pago_mb;
                                               ELSE
                                                 v_monto_x_pagar = v_registros_dev.monto_pago;
                                               END IF; 
                                             
                                               -- revisar la reversion del devengado para ajustar el monto a pagar
                                               
                                               -----------------------------------------------------------------------------
                                               --   Obtener el factor de reversion de la transaccion de devengado        ---
                                               --   Ejemplo fue comprometido 100  se devego 87 por el IVA se revirtio 13 ---  
                                               --   presupeustariamente solo pagamos el 87                               ---
                                               -----------------------------------------------------------------------------
                                               
                                              IF  v_registros_dev.factor_reversion > 0 and v_registros_dev.id_partida_ejecucion_rev is not null   THEN
                                                
                                                    v_monto_rev =  COALESCE(round(v_monto_x_pagar * v_registros_dev.factor_reversion,2), 0);
                                                    
                                                    v_monto_x_pagar = v_monto_x_pagar -v_monto_rev;
                                                    
                                                    
                                                    --si el monto a revertir es mayor que la diferencia de lo que sobra  puede ser un problema d redondeo
                                                    --y forzamos que iguale si la fiderencia no es mayor que 1
                                                    
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
                                               va_id_moneda[v_i]  = v_id_moneda;
                                               va_id_partida_ejecucion [v_i] = v_registros_dev.id_partida_ejecucion_dev;   
                                               va_columna_relacion[v_i]= 'id_int_transaccion';
                                               va_fk_llave[v_i] = v_registros.id_int_transaccion;
                                               va_id_int_rel_devengado[v_i]= v_registros_dev.id_int_rel_devengado;
                                               va_nro_tramite[v_i]= v_registros_comprobante.nro_tramite;

                                               -- fecha pago presupuestaria  
                                               
                                               
                                               
                                               IF p_fecha_ejecucion is NULL THEN
                                                 va_fecha[v_i]=v_registros_comprobante.fecha::date;  --, fecha del comprobante
                                               ELSE
                                                va_fecha[v_i]=p_fecha_ejecucion;  -- fecha como parametros
                                               END IF; 
                                               
                                               --si la el año de pago es mayor que el año del devengado , el pago va con fecha de 31 de diciembre del año del devengado
                                               v_ano_1 =  EXTRACT(YEAR FROM  va_fecha[v_i]::date);
                                               v_ano_2 =  EXTRACT(YEAR FROM  v_registros_dev.fecha::date);
                                               
                                               IF  v_ano_1  >  v_ano_2 THEN
                                                 va_fecha[v_i] = ('31-12-'|| v_ano_2::varchar)::date;
                                               END IF;
                                               
                                               
                                               -- chequeamos si el presupuesto devengado si alcanza para pagar, 
                                               -- si no,  pero la diferencia es minima pagamos   el monto disponible
                                                v_respuesta_verificar = pre.f_verificar_com_eje_pag(va_id_partida_ejecucion[v_i],va_id_moneda[v_i]);
                                                                                          
                                               
                                                v_monto_previo_pagado = 0;                                        
                                               
                                               --antes de validar el monto,  calculamos en la tabla temporal los montos previos ya pagado
                                                select
                                                  sum(tt.monto) 
                                                into 
                                                 v_monto_previo_pagado
                                                from tt_check_presu tt 
                                                where id < v_cont 
                                                  and id_partida_ejecucion =  va_id_partida_ejecucion[v_i]
                                                  and estado = 'pagado';
                                                                                          
                                              
                                              IF  (va_monto[v_i]) <= (COALESCE(v_respuesta_verificar.ps_ejecutado,0.00::numeric) - COALESCE(v_monto_previo_pagado,0.0) - COALESCE(v_respuesta_verificar.ps_pagado,0.00::numeric) + v_error_presupuesto) THEN
                                                
                                                 IF  (va_monto[v_i]) > (COALESCE(v_respuesta_verificar.ps_ejecutado,0.00::numeric) - COALESCE(v_monto_previo_pagado,0.0)- COALESCE(v_respuesta_verificar.ps_pagado,0.00::numeric)) THEN
                                              
                                                     va_monto[v_i] = (COALESCE(v_respuesta_verificar.ps_ejecutado,0.00::numeric) - COALESCE(v_monto_previo_pagado,0.0) - COALESCE(v_respuesta_verificar.ps_pagado,0.00::numeric));
                                              
                                                 END IF;
                                              
                                             END IF;
                                             
                                             --insertamos el nuevo valor en la tabla temporal
                                        
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
                                                     fecha,
                                                     estado
                                                ) 
                                                VALUES (
                                                     v_i,
                                                     va_tipo_partida[v_i],
                                                     va_id_presupuesto[v_i],
                                                     va_id_partida[v_i],
                                                     va_momento[v_i],
                                                     va_monto[v_i] ,
                                                     va_id_moneda[v_i] ,
                                                     va_id_partida_ejecucion[v_i] ,
                                                     va_columna_relacion[v_i] ,
                                                     va_fk_llave[v_i]  ,
                                                     va_id_transaccion[v_i] ,
                                                     v_momento_aux ,
                                                     va_fecha[v_i],
                                                    'pagado'
                                                 );   
                                               
                                                                                          
                                              
                                              
                                             
                                 
                                   END LOOP;
                               
                          ELSE
                               
                               raise exception 'Momento prespuestario no reconocido';
                          
                          END IF;
                          
                          
                 
               END LOOP; --end loop transacciones
               
             
             
             --raise exception '%, %', va_monto, va_id_moneda;
               
              -- llamar a la funcion de gestion presupuestaria incremeto presupuestario
                   
               IF v_i > 0 THEN 
                 
                           va_resp_ges =  pre.f_gestionar_presupuesto(p_id_usuario,
                                                                      NULL, --tipo cambio
                                                                      va_id_presupuesto, 
                                                                      va_id_partida, 
                                                                      va_id_moneda, 
                                                                      va_monto, 
                                                                      va_fecha, --p_fecha
                                                                      va_momento, 
                                                                      va_id_partida_ejecucion,--  p_id_partida_ejecucion 
                                                                      va_columna_relacion, 
                                                                      va_fk_llave,
                                                                      va_nro_tramite,
                                                                      p_id_int_comprobante,
                                                                      p_conexion,
                                                                      v_registros_comprobante.momento_comprometido,
                                                                      v_registros_comprobante.momento_ejecutado,
                                                                      v_registros_comprobante.momento_pagado 
                                                                    );
                          
                                
               END IF;
                 
                 --actualiza el los id en las transacciones
                 
               IF  v_momento_aux='todo' or   v_momento_aux='solo ejecutar'  THEN
                    
                         --actualizacion de los id_partida_ejecucion en las transacciones
                         
                          FOR v_cont IN 1..v_i LOOP
                             
                             
                              
                              	 
                                    --verificamos que no sea un trasaccion de reversion
                                    IF  (v_cont  =  ANY(v_marca_reversion)) THEN
                                      
                                      
                                         update conta.tint_transaccion it set
                                           id_partida_ejecucion_rev = va_resp_ges[v_cont],   --partida de reversion
                                           fecha_mod = now(),
                                           id_usuario_mod = p_id_usuario
                                        where it.id_int_transaccion  =  va_id_transaccion[v_cont];
                                    
                                    ELSE
                                      
                                     		IF v_momento_aux='solo ejecutar' THEN
                                                  update conta.tint_transaccion it set
                                                     id_partida_ejecucion_dev = va_resp_ges[v_cont],    --partida de devengado
                                                     fecha_mod = now(),
                                                     id_usuario_mod = p_id_usuario
                                                  where it.id_int_transaccion  =  va_id_transaccion[v_cont]; 
                                                  
                                             ELSE
                                                update conta.tint_transaccion it set
                                                   id_partida_ejecucion = va_resp_ges[v_cont],   --id_partida_ejecucion del devengado o comprometido segun tipo de comprobante)
                                                   fecha_mod = now(),
                                                   id_usuario_mod = p_id_usuario
                                                where it.id_int_transaccion  =  va_id_transaccion[v_cont];
                                            END IF;
                                     END IF;
                             
                        END LOOP;
                  
             ELSIF   v_momento_aux='solo pagar'  THEN
                  
                       FOR v_cont IN 1..v_i LOOP
                             
                                  update conta.tint_rel_devengado rd set
                                     id_partida_ejecucion_pag = va_resp_ges[v_cont],  --partida ejecucion del pagado
                                     fecha_mod = now(),
                                     id_usuario_mod = p_id_usuario
                                  where rd.id_int_rel_devengado  =  va_id_int_rel_devengado[v_cont];
                              
                       END LOOP;
                		
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