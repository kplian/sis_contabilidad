--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_gestionar_presupuesto_cbte_pxp (
  p_id_usuario integer,
  p_id_int_comprobante integer,
  p_igualar varchar = 'no'::character varying,
  p_fecha_ejecucion date = NULL::date,
  p_conexion varchar = NULL::character varying
)
RETURNS varchar AS
$body$
/*
	Autor: RAC (KPLIAN)
    Fecha: 06-04-2016
    Descripción: 
     Nueva funcion para gestion de presupuesto simplicada, toma ventaja de que el presupuesto se ejecuta 
     directamente en pxp y no depende del deblink
*/
DECLARE
  
  v_registros_comprobante 			record;
  v_nombre_funcion					varchar;
  v_resp							varchar;
  v_retorno 						varchar;
  v_id_moneda_base					integer;
  v_id_moneda_tri					integer;
  v_id_moneda						integer;
  v_sw_moneda_base					varchar;
  v_momento_presupeustario			varchar;
  v_momento_aux						varchar;
  v_error_presupuesto				numeric;
  v_registros						record;
  v_importe_debe 					numeric;
  v_importe_haber 					numeric;
  v_monto_cmp 						numeric;
  v_respuesta_verificar				record;
  v_resp_ges						numeric[];
  v_importe_debe_mb 				numeric;
  v_importe_haber_mb 				numeric;
  v_monto_cmp_mb					numeric;
  v_sw_error						boolean;
  v_mensaje_error					varchar;
  v_tmp								varchar;
  v_codico_cc						varchar;
  v_registros_dev					record;
  v_monto_x_pagar					numeric;
  v_monto_x_pagar_mb				numeric;
  v_ano_1  							integer;
  v_ano_2  							integer;
  v_monto_rev						numeric;
  v_monto_rev_mb					numeric;
  
  v_importe_gasto 					numeric;
  v_importe_recurso 					numeric;
  v_importe_gasto_mb 				numeric;
  v_importe_recurso_mb 				numeric;
  v_reg_par_eje						record;
  
    
BEGIN
   

    v_nombre_funcion:='conta.f_gestionar_presupuesto_cbte_pxp';
    v_retorno = 'exito';
    v_sw_error = false; --iniciamos sin errores
    v_mensaje_error = '';
    
   
    -- recupera datos del comprobante
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
      ic.cbte_reversion,
      per.id_gestion,
      ic.id_int_comprobante_fks
    into v_registros_comprobante
    from conta.tint_comprobante ic
    inner join conta.tclase_comprobante cl  on ic.id_clase_comprobante =  cl.id_clase_comprobante
    inner join param.tperiodo per on per.id_periodo = ic.id_periodo
    where ic.id_int_comprobante  =  p_id_int_comprobante;
    
    
     ---------------------------------------------------
     -- Determinar moneda de ejecucion presupuestaria
     -- Si viene de una regional y la moneda no  es la moenda de triangulación 
     -- ejecutar moneda base
     ------------------------------------------------
     
     -- determinar moneda base
     v_id_moneda_base = param.f_get_moneda_base();
     v_id_moneda_tri = param.f_get_moneda_triangulacion();
     v_id_moneda = v_registros_comprobante.id_moneda;
     v_sw_moneda_base = 'no';

     IF v_registros_comprobante.vbregional = 'si' and v_registros_comprobante.id_moneda != v_id_moneda_tri THEN
       v_id_moneda = v_id_moneda_base;
       v_sw_moneda_base = 'si';
     END IF;
     
     -- determina la fecha de ejecucion presupuestaria
     IF p_fecha_ejecucion is NULL THEN
       p_fecha_ejecucion = v_registros_comprobante.fecha::date;  --, fecha del comprobante
     END IF;

     
     IF v_registros_comprobante.momento = 'presupuestario' THEN
    
             --recuepra el error maximo por  redondeo
             v_error_presupuesto =  pxp.f_get_variable_global('error_presupuesto')::numeric;
            
             IF v_error_presupuesto is NULL THEN
                raise exception 'No se encontro el valor de la variable global : error_presupuesto';
             END IF;
            
             -- definir lso momentos presupuestarios
             IF v_registros_comprobante.momento_ejecutado = 'si'  and    v_registros_comprobante.momento_pagado = 'si' then
                    v_momento_presupeustario = 'pagado'; --pagado 
                    v_momento_aux='todo';
             ELSIF  v_registros_comprobante.momento_ejecutado = 'si'  and    v_registros_comprobante.momento_pagado = 'no'  THEN   
                    v_momento_presupeustario = 'ejecutado';  --ejecutado
                    v_momento_aux='solo ejecutar';
             ELSIF v_registros_comprobante.momento_ejecutado = 'no'  and    v_registros_comprobante.momento_pagado = 'si'  THEN   
                    v_momento_presupeustario = 'pagado';  --pagado
                    v_momento_aux='solo pagar';  
             ELSIF v_registros_comprobante.momento_comprometido = 'si'  and  v_registros_comprobante.momento_ejecutado = 'no'  and    v_registros_comprobante.momento_pagado = 'no' then
                    raise exception 'Solo comprometer no esta implmentado';
             ELSE 
                    raise exception 'Combinacion de momentos no contemplada';  
             END IF;
             
           
            --listado de las transacciones con partidas presupuestaria
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
                                     it.factor_reversion,
                                     par.codigo as codigo_partida,
                                     it.actualizacion
                                  from conta.tint_transaccion it
                                  inner join pre.tpartida par on par.id_partida = it.id_partida
                                  inner join pre.tpresupuesto pr on pr.id_centro_costo = 
                                  it.id_centro_costo
                                  where it.id_int_comprobante = p_id_int_comprobante
                                        and it.estado_reg = 'activo' )  LOOP
     		
                           
                           --selecciona la moneda de trabajo
                         IF v_sw_moneda_base = 'si' THEN
                              v_importe_gasto = v_registros.importe_gasto_mb;
                              v_importe_recurso =  v_registros.importe_recurso_mb;
                         ELSE
                              v_importe_gasto = v_registros.importe_gasto;
                              v_importe_recurso =  v_registros.importe_recurso;
                         END IF; 
                  
                         v_importe_gasto_mb = v_registros.importe_gasto_mb;
                         v_importe_recurso_mb =  v_registros.importe_recurso_mb;
                         
                       
            
                      
                          IF    v_momento_aux = 'todo' or   v_momento_aux='solo ejecutar'  THEN
                          
                                -- si solo ejecutamos el presupuesto 
                                --  o (compromentemos y ejecutamos) 
                                --  o (compromentemos, ejecutamos y pagamos)     
                                
                                -- si tiene partida ejecucion de comprometido y nose corresponde con la gestion
                                --  lo ponemos en null para que comprometa
                                
                                --  es para devegar planes de pago que quedaron pendientes de una  gestion anterior
                                
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
                                        update conta.tint_transaccion set 
                                           id_partida_ejecucion = NULL
                                        where id_int_transaccion = v_registros.id_int_transaccion;
                                    end if;
                                   
                                END IF;
                                
                                
                                -- si  el comprobante tiene que comprometer
                                IF v_registros_comprobante.momento_comprometido = 'si' and v_registros_comprobante.cbte_reversion = 'no'  then
                                      -- validamos que si tiene que comprometer la id_partida_ejecucion tiene que ser nulo
                                       IF v_registros.id_partida_ejecucion is not NULL THEN                                       
                                           raise exception 'El comprobante no puede estar marcado para comprometer, si ya existe un comprometido';
                                       END IF;
                                       
                                END IF; --IF comprometido 
                                
                                
                                  
           
                                
                                -- solo procesamos si es una partida presupuestaria y no de flujo
                                IF v_registros.sw_movimiento = 'presupuestaria' THEN
                                       
                                         v_monto_cmp = 0;
                                         
                                         ---  revisar si esto esta bien
                                         IF v_registros_comprobante.momento_comprometido = 'no' THEN
                                                -- solo permite comprometer partidas de actulizacion (transaccion que igualan el comprobante)
                                               IF v_registros.id_partida_ejecucion is null  and v_registros.actualizacion = 'no'  THEN                                       
                                                   raise exception 'El comprobante  no esta marcado para comprometer, y no tiene un origen comprometido';
                                                END IF; 
                                         END IF;
                                         
                                       
                                         
                                         IF v_registros.tipo = 'gasto'  THEN
                                             -- importe debe ejecucion
                                             IF v_importe_gasto > 0  or v_importe_gasto_mb > 0 THEN
                                                 v_monto_cmp  = v_importe_gasto;
                                                 v_monto_cmp_mb = v_importe_gasto_mb;                                                                                           
                                             END IF;
                                             --importe haber es reversion, multiplicar por -1
                                             IF v_importe_recurso > 0 or v_importe_recurso_mb > 0 THEN
                                                 v_monto_cmp  = v_importe_recurso * (-1);
                                                 v_monto_cmp_mb = v_importe_recurso_mb * (-1);
                                             END IF;
                                            
                                         ELSE
                                             IF v_importe_recurso > 0 or v_importe_recurso_mb > 0 THEN
                                               v_monto_cmp  = v_importe_recurso;
                                               v_monto_cmp_mb = v_importe_recurso_mb;                                           
                                             END IF;
                                             
                                             --importe debe es reversion, multiplicar por -1
                                             
                                             IF v_importe_gasto > 0 or v_importe_gasto_mb > 0 THEN
                                                 v_monto_cmp  = v_importe_gasto * (-1);
                                                 v_monto_cmp_mb = v_importe_gasto_mb * (-1);                                              
                                             END IF;
                                         END IF;
                                           
                                       -- raise exception 'entra.. % --  %',v_monto_cmp, v_monto_cmp_mb;
                                
           
                              
                                        -- llamamos a la funcion de ejecucion
                                        v_resp_ges = pre.f_gestionar_presupuesto_v2(
                                                                                    p_id_usuario, 
                                                                                    NULL,  --tipo de cambio,  ya mandamos la moneda convertida 
                                                                                    v_registros.id_presupuesto, 
                                                                                    v_registros.id_partida, 
                                                                                    v_id_moneda, 
                                                                                    v_monto_cmp,
                                                                                    v_monto_cmp_mb, 
                                                                                    p_fecha_ejecucion, 
                                                                                    v_momento_presupeustario, 
                                                                                    v_registros.id_partida_ejecucion, 
                                                                                    'id_int_transaccion', 
                                                                                    v_registros.id_int_transaccion,--p_fk_llave, 
                                                                                    v_registros_comprobante.nro_tramite, 
                                                                                    p_id_int_comprobante, 
                                                                                    v_registros_comprobante.momento_comprometido, 
                                                                                    v_registros_comprobante.momento_ejecutado, 
                                                                                    v_registros_comprobante.momento_pagado);
                                                            
                                         ------------------------------------
                                         --  ACUMULAR ERRORES
                                         -----------------------------------
                                         
                                         --  analizamos respuesta y retornamos error
                                         IF v_resp_ges[1] = 0 THEN
                                           
                                                 --  recuperamos datos del presupuesto
                                                 v_mensaje_error = v_mensaje_error|| conta.f_armar_error_presupuesto(v_resp_ges, 
                                                                                               v_registros.id_presupuesto, 
                                                                                               v_registros.codigo_partida, 
                                                                                               v_id_moneda, 
                                                                                               v_id_moneda_base, 
                                                                                               v_momento_presupeustario, 
                                                                                               v_monto_cmp_mb);
                                                 v_sw_error = true;
                                                 
                                          ELSE
                                                   -- sino se tiene error almacenamos el id de la aprtida ejecucion
                                                   IF v_registros.id_partida_ejecucion is  NULL THEN 
                                                        update conta.tint_transaccion it set
                                                           id_partida_ejecucion = v_resp_ges[2],
                                                           id_partida_ejecucion_dev = v_resp_ges[2],  
                                                           fecha_mod = now(),
                                                           id_usuario_mod = p_id_usuario
                                                        where it.id_int_transaccion  =  v_registros.id_int_transaccion;
                                                   ELSE
                                                       update conta.tint_transaccion it set
                                                           id_partida_ejecucion_dev = v_resp_ges[2],
                                                           fecha_mod = now(),
                                                           id_usuario_mod = p_id_usuario
                                                        where it.id_int_transaccion  =  v_registros.id_int_transaccion;
                                                   END IF; 
                                                  
                                          END IF; --fin id de error
                                       
                                       
                                         -------------------------------------------------------------------------------------  
                                         --   si existe un factor a revertir y tenememos el id_partida_ejecucion, revertimos
                                         -------------------------------------------------------------------------------------
                                         
                                         IF  v_registros.factor_reversion > 0 and v_registros.id_partida_ejecucion is not null THEN
                                         
                                                   /*  regla de 3 para calcular  el monto a revertir en moneda base
                                                    *      200 -> 0.87
                                                    *      X   -> 0.13
                                                    */
                                                   
                                                  IF v_sw_moneda_base = 'si' THEN
                                                      --si forzamos el calculo en moenda base
                                                      -- calcular el monto a revertir segun factor por regla de tres en moneda base
                                                      v_monto_cmp_mb = (v_monto_cmp * v_registros.factor_reversion)/(1 - v_registros.factor_reversion);
                                                      v_monto_cmp = v_monto_cmp_mb;
                                                  ELSEIF  v_registros_comprobante.id_moneda = v_id_moneda_base THEN
                                                       -- si la transaccion ya fue calculada en moneda
                                                       v_monto_cmp = v_registros.importe_reversion;
                                                       v_monto_cmp_mb  = v_registros.importe_reversion;
                                                  ELSE  
                                                        --calculo en loa moenda original de la transaccion
                                                        v_monto_cmp = v_registros.importe_reversion;
                                                        v_monto_cmp_mb = (v_monto_cmp_mb * v_registros.factor_reversion)/(1 - v_registros.factor_reversion);
                                                  END IF;
                                                  
                                                   -- llamar a la funcion para revertir el comprometido
                                                 
                                                   v_resp_ges = pre.f_gestionar_presupuesto_v2(
                                                                                            p_id_usuario, 
                                                                                            NULL,  --tipo de cambio,  ya mandamos la moneda convertida 
                                                                                            v_registros.id_presupuesto, 
                                                                                            v_registros.id_partida, 
                                                                                            v_id_moneda, 
                                                                                            v_monto_cmp*(-1),
                                                                                            v_monto_cmp_mb*(-1), 
                                                                                            p_fecha_ejecucion, 
                                                                                            'comprometido', 
                                                                                            v_registros.id_partida_ejecucion, 
                                                                                            'id_int_transaccion', 
                                                                                            v_registros.id_int_transaccion,--p_fk_llave, 
                                                                                            v_registros_comprobante.nro_tramite, 
                                                                                            p_id_int_comprobante, 
                                                                                            v_registros_comprobante.momento_comprometido, 
                                                                                            v_registros_comprobante.momento_ejecutado, 
                                                                                            v_registros_comprobante.momento_pagado);
                                                                                            
                                                                                            
                                                     --  analizamos respuesta y retornamos error
                                                   IF v_resp_ges[1] = 0 THEN
                                                   
                                                         --  recuperamos datos del presupuesto
                                                         v_mensaje_error = v_mensaje_error || conta.f_armar_error_presupuesto(v_resp_ges, 
                                                                                               v_registros.id_presupuesto, 
                                                                                               v_registros.codigo_partida, 
                                                                                               v_id_moneda, 
                                                                                               v_id_moneda_base, 
                                                                                               v_momento_presupeustario, 
                                                                                               v_monto_cmp_mb);
                                                         v_sw_error = true;
                                                         
                                                  ELSE
                                                  
                                                      update conta.tint_transaccion it set
                                                         id_partida_ejecucion_rev = v_resp_ges[2],   --partida de reversion
                                                         fecha_mod = now(),
                                                         id_usuario_mod = p_id_usuario
                                                      where it.id_int_transaccion  =   v_registros.id_int_transaccion;
                                                     
                                                  
                                                  END IF; --fin id de error                                        
                                         
                                       END IF; --if la transacion tiene reversion
                                
                                
                                 END IF;  --fin if es partida presupuestaria
                                 
                          
                          ELSIF  v_momento_aux='solo pagar'  THEN
                                
                                 --  RAC 29/12/2016
                                 --  para los comprobantes de pago verificar que el devenga tenga gestion 
                                 --  menor o igual a la gestion del pago
                                 
                                 IF exists ( select 1
                                             from conta.tint_comprobante ic
                                             inner join param.tperiodo per on per.id_periodo = ic.id_periodo
                                             where ic.id_int_comprobante = ANY(v_registros_comprobante.id_int_comprobante_fks)
                                                   and per.id_gestion > v_registros_comprobante.id_gestion) THEN
                                       raise exception 'No puede pagar, por que la fecha de pago no es coherente con la fecha del devengado';
                                 END IF;
                          
                         
                                 -- si es solo pagar debemos identificar las transacciones del devengado 
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
                                                                    it.id_partida_ejecucion_rev,
                                                                    p.codigo as codigo_partida,
                                                                    it.id_centro_costo as id_presupuesto,
                                                                    p.id_partida,
                                                                    ic.nro_tramite
                                                                    
                                                                  from  conta.tint_rel_devengado ird
                                                                  inner join conta.tint_transaccion it  on it.id_int_transaccion = ird.id_int_transaccion_dev
                                                                  inner join pre.tpartida p on p.id_partida = it.id_partida 
                                                                  
                                                                  inner join conta.tint_comprobante ic on ic.id_int_comprobante = it.id_int_comprobante
                                                                  where  ird.id_int_transaccion_pag = v_registros.id_int_transaccion
                                                                         and ird.estado_reg = 'activo'
                                                                         and p.sw_movimiento = 'presupuestaria'
                                                                 ) LOOP
                                                                 
                                                                 
                                               IF v_sw_moneda_base = 'si' THEN
                                                 v_monto_x_pagar = v_registros_dev.monto_pago_mb;
                                                 v_monto_x_pagar_mb = v_registros_dev.monto_pago_mb;
                                               ELSE
                                                 v_monto_x_pagar = v_registros_dev.monto_pago;
                                                 v_monto_x_pagar_mb = v_registros_dev.monto_pago_mb;
                                               END IF;
                                               
                                               
                                               -----------------------------------------------------------------------------
                                               --   Obtener el factor de reversion de la transaccion de devengado        ---
                                               --   Ejemplo fue comprometido 100  se devego 87 por el IVA se revirtio 13 ---  
                                               --   presupeustariamente solo pagamos el 87                               ---
                                               -----------------------------------------------------------------------------
                                              IF  v_registros_dev.factor_reversion > 0 and v_registros_dev.id_partida_ejecucion_rev is not null   THEN
                                              
                                                    v_monto_rev =  COALESCE(round(v_monto_x_pagar * v_registros_dev.factor_reversion,2), 0);
                                                    v_monto_rev_mb =  COALESCE(round(v_monto_x_pagar_mb * v_registros_dev.factor_reversion,2), 0);
                                                    v_monto_x_pagar = v_monto_x_pagar -v_monto_rev;
                                                    v_monto_x_pagar_mb = v_monto_x_pagar_mb - v_monto_rev_mb;
                                                    
                                                    --  actualizamos el monto no pagado
                                                    UPDATE conta.tint_transaccion it SET
                                                      monto_pagado_revertido = monto_pagado_revertido + v_monto_rev
                                                    WHERE it.id_int_transaccion = v_registros_dev.id_int_transaccion_dev;
                                                  
                                              END IF; -- fin if factor de reversion
                                              
                                               --si la el año de pago es mayor que el año del devengado , el pago va con fecha de 31 de diciembre del año del devengado
                                               v_ano_1 =  EXTRACT(YEAR FROM  p_fecha_ejecucion::date);
                                               v_ano_2 =  EXTRACT(YEAR FROM  v_registros_dev.fecha::date);
                                               
                                               IF  v_ano_1  >  v_ano_2 THEN
                                                  p_fecha_ejecucion = ('31-12-'|| v_ano_2::varchar)::date;
                                               END IF;
                                               
                                               
                                               
                                               -- llamamos a la funcion de ejecucion
                                               v_resp_ges = pre.f_gestionar_presupuesto_v2(
                                                                                    p_id_usuario, 
                                                                                    NULL,  --tipo de cambio,  ya mandamos la moneda convertida 
                                                                                    v_registros_dev.id_presupuesto, 
                                                                                    v_registros_dev.id_partida, 
                                                                                    v_id_moneda, 
                                                                                    v_monto_x_pagar,
                                                                                    v_monto_x_pagar_mb, 
                                                                                    p_fecha_ejecucion, 
                                                                                    v_momento_presupeustario, 
                                                                                    v_registros_dev.id_partida_ejecucion_dev, 
                                                                                    'id_int_rel_devengado', 
                                                                                    v_registros_dev.id_int_rel_devengado,--p_fk_llave, 
                                                                                    v_registros_dev.nro_tramite,   --nro de tramite del devengado
                                                                                    p_id_int_comprobante, 
                                                                                    v_registros_comprobante.momento_comprometido, 
                                                                                    v_registros_comprobante.momento_ejecutado, 
                                                                                    v_registros_comprobante.momento_pagado);
                                               
                                               
                                               --  analizamos respuesta y retornamos error
                                               IF v_resp_ges[1] = 0 THEN
                                                   
                                                         --  recuperamos datos del presupuesto
                                                         v_mensaje_error = v_mensaje_error || conta.f_armar_error_presupuesto(v_resp_ges, 
                                                                                               v_registros_dev.id_presupuesto, 
                                                                                               v_registros_dev.codigo_partida, 
                                                                                               v_id_moneda, 
                                                                                               v_id_moneda_base, 
                                                                                               v_momento_presupeustario, 
                                                                                               v_monto_x_pagar_mb);
                                                         v_sw_error = true;
                                                         
                                                ELSE
                                                  
                                                      
                                                      update conta.tint_rel_devengado rd set
                                                         id_partida_ejecucion_pag = v_resp_ges[2],  --partida ejecucion del pagado
                                                         fecha_mod = now(),
                                                         id_usuario_mod = p_id_usuario
                                                      where rd.id_int_rel_devengado  =  v_registros_dev.id_int_rel_devengado;
                                                     
                                                  
                                                END IF; --fin id de error   
                                               
                                           
                                 
                                 END LOOP;
                          
                                 
                                
                         END IF; -- fin if todo o solo ejecutar, solo pagar
                                  
            
            END LOOP;
            
            
            ---------------------------------------------
            --  CONTROL DE ERRORES
            --  si un atransaccion no se pudo ejecutar
            --  se realiza rollback  y reterona el mensaje
            -------------------------------------------
            
            IF v_sw_error THEN
               raise exception 'Error al procesar presupuesto: %', v_mensaje_error;
            END IF;
            
     
     
     END IF; -- fin del IF , si es cbte presupuestario
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