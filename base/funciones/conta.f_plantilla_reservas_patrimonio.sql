--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_plantilla_reservas_patrimonio (
  p_id_usuario integer,
  p_id_int_comprobante integer,
  p_id_gestion_cbte integer,
  p_desde date,
  p_hasta date,
  p_id_depto integer
)
RETURNS void AS
$body$
/**************************************************************************
 SISTEMA:		Tesoreria
 FUNCION: 		conta.f_plantilla_reservas_patrimonio
 DESCRIPCION:   Plantilla de cbte para generar actuliza de reservas de Patrimonio
 AUTOR: 		Rensi Arteaga Copari
 FECHA:	        16/03/2018
 COMENTARIOS:
***************************************************************************
 
    HISTORIAL DE MODIFICACIONES:
   	
 ISSUE            FECHA:		      AUTOR                 DESCRIPCION   
 #0		          16/03/2018        RAC					   Creación
***************************************************************************/
                   
DECLARE
 v_nombre_funcion   			text;
 v_resp							varchar;
 v_total_haber   				numeric;
 v_total_debe	 				numeric;
 v_resp_deudor  				numeric[];
 v_resp_acreedor  				numeric[];
 v_registros					record;
 v_reg_cbte						record;
 v_sw_saldo_acredor               boolean;
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
 v_record_rel_con 				record;
 v_sw_minimo					boolean; 
 v_record_rel					record;
 
 v_suma_acreedor_ajuste_ma         numeric;
 v_suma_deudor_ajuste_ma           numeric;
 v_suma_acreedor_ajuste_mb         numeric;
 v_suma_deudor_ajuste_mb           numeric;
 v_glosa_ajuste                    varchar;
 
 v_record_rel_debe				record;
 v_record_rel_haber				record;
 v_sw_suma_extra                varchar;
 v_saldo_tmp_cuenta_ma          numeric;
 v_saldo_tmp_cuenta_mb    numeric;
 
  
BEGIN
  
    v_nombre_funcion = 'conta.f_plantilla_reservas_patrimonio';    
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
    
    -- determinar el centro de costo del depto
     SELECT 
      ps_id_centro_costo 
      into 
       v_id_centro_costo_depto 
     FROM conta.f_get_config_relacion_contable('CCDEPCON', -- relacion contable que almacena los centros de costo por departamento
                                               p_id_gestion_cbte,  
                                               p_id_depto,--p_id_depto_conta 
                                               NULL);  --id_dento_costo
    
    
    v_sw_minimo = false;
    
     -- validar que la fecha inicial sea el primer dia del año  
    IF not exists (select
                        1
                    from param.tgestion ges
                    where ges.id_gestion = p_id_gestion_cbte
                          and ges.fecha_ini = p_desde ) THEN
      
         raise exception 'El calculo Actulización de Patrimonio siempre debe comenzar desde el primer dia del año';
                        
     END IF;
    
    -- 1) FOR listar todas las cuentas que actualizan desde contabilidad de la gestion  
    
    v_suma_acreedor_ajuste_ma =  0;
    v_suma_deudor_ajuste_ma = 0;
    v_suma_acreedor_ajuste_mb =  0;
    v_suma_deudor_ajuste_mb = 0;
    v_glosa_ajuste = '';
    
    
    --recupera cuenta de ajuste
    ----------------------------------------------------------------------------------------
    --  OJO LA CUENTA PARAMETRIZADA EN AJT_CAPPAT_DEBE y AJT_CAPPAT_HAB debe ser la misma
    ------------------------------------------------------------------------------------------
    
    SELECT 
    * 
    into 
    v_record_rel_debe
    FROM conta.f_get_config_relacion_contable( 'AJT_RESPAT_DEBE', 
                                               p_id_gestion_cbte, 
                                               NULL,  --campo_relacion_contable
                                               NULL);
                                               
                                               
     SELECT 
       * 
    into 
        v_record_rel_haber 
    FROM conta.f_get_config_relacion_contable( 'AJT_RESPAT_HAB', 
                                               p_id_gestion_cbte, 
                                               NULL,  --campo_relacion_contable
                                               NULL); 
                                               
     IF v_record_rel_haber.ps_id_cuenta  != v_record_rel_debe.ps_id_cuenta  THEN
         raise exception 'las cuentas parametrizadas para las relaciones AJT_RESPAT_HAB y  AJT_RESPAT_DEBE deben ser la misma'; 
     END IF;  
     
                                           
                                                                                        
    -----------------------------------------------------
    --  RECORRE la cuenta parametrizadaz para capital
    -------------------------------------------------------
    
    v_sw_suma_extra = 'si';
    
    FOR v_registros in (
    					select 
                            c.id_cuenta,
                            c.tipo_act,
                            c.nombre_cuenta,
                            c.act_cbte_apertura              --TODO identificar si incluimos balance de apertura...     
                        from conta.tcuenta c 
                        where c.id_gestion = p_id_gestion_cbte
                              and c.sw_transaccional = 'movimiento'
                              and c.estado_reg = 'activo' 
                              and c.tipo_act = 'reservas' )LOOP   --RESERVAS DE PATRIMONIO
                              
                              
                 IF   v_record_rel_haber.ps_id_cuenta = v_registros.id_cuenta   THEN
                    v_sw_suma_extra = 'no';
                 END IF;                     
                           
                --   mayor deudor  de la cuenta
                v_resp_deudor = conta.f_mayor_cuenta(v_registros.id_cuenta, 
                                                   p_desde, 
                                                   p_hasta, 
                                                    NULL, --todos los deptos p_id_depto::varchar, , 
                                                   'si',             --  p_incluir_cierre
                                                   v_registros.act_cbte_apertura,          --  p_incluir_apertura 
                                                   'todos',          --  p_incluir_aitb, 
                                                   'defecto_cuenta', --  p_signo_balance, 
                                                   'deudor', --  p_tipo_saldo,
                                                    null,--p_id_auxiliar,
                                                    null,--p_id_int_comprobante_ori,
                                                    NULL,--id_ot
                                                    null -- p_id_centro_costo
                                                   );
                  
                --mayor acredor                                 
                 v_resp_acreedor = conta.f_mayor_cuenta(v_registros.id_cuenta, 
                                                   p_desde, 
                                                   p_hasta, 
                                                   NULL, --todos los deptos p_id_depto::varchar, , 
                                                   'si',             --  p_incluir_cierre
                                                    v_registros.act_cbte_apertura,          --  p_incluir_apertura 
                                                   'todos',          --  p_incluir_aitb, 
                                                   'defecto_cuenta', -- p_signo_balance, 
                                                   'acreedor', --  p_tipo_saldo,
                                                    null,--p_id_auxiliar,
                                                    null,--p_id_int_comprobante_ori,
                                                    NULL,--id_ot
                                                    null -- p_id_centro_costo
                                                   );
                                                   
                   IF  COALESCE(v_resp_acreedor[5],0) >  COALESCE(v_resp_deudor[5],0) THEN
                      v_saldo_tmp_cuenta_ma = COALESCE(v_resp_acreedor[5],0) - COALESCE(v_resp_deudor[5],0);
                      v_saldo_tmp_cuenta_mb = COALESCE(v_resp_acreedor[1],0) - COALESCE(v_resp_deudor[1],0);
                   ELSE
                      v_saldo_tmp_cuenta_ma = COALESCE(v_resp_deudor[5],0) - COALESCE(v_resp_acreedor[5],0);
                      v_saldo_tmp_cuenta_mb = COALESCE(v_resp_deudor[1],0) - COALESCE(v_resp_acreedor[1],0);
                   END IF; 
                   
                   v_saldo_tmp_cuenta_ma = round(v_saldo_tmp_cuenta_ma, 2); 
                   v_saldo_tmp_cuenta_mb = round(v_saldo_tmp_cuenta_mb, 2);                              
                                                 
                                                   
                  IF v_glosa_ajuste = '' THEN
                    v_glosa_ajuste = COALESCE(v_registros.nombre_cuenta) || '  (UFV: '||v_saldo_tmp_cuenta_ma::varchar||' - BS: '||v_saldo_tmp_cuenta_mb::varchar||' )' ;
                  ELSE
                    v_glosa_ajuste = v_glosa_ajuste ||', '|| COALESCE(v_registros.nombre_cuenta)|| '  (UFV: '||v_saldo_tmp_cuenta_ma::varchar||' - BS: '||v_saldo_tmp_cuenta_mb::varchar||')' ;
                  END IF;                                 
                 
                      
                  v_suma_acreedor_ajuste_ma =  v_suma_acreedor_ajuste_ma  + COALESCE(v_resp_acreedor[5],0);
                  v_suma_deudor_ajuste_ma = v_suma_deudor_ajuste_ma +  COALESCE(v_resp_deudor[5],0);
                  v_suma_acreedor_ajuste_mb =  v_suma_acreedor_ajuste_mb  + COALESCE(v_resp_acreedor[1],0);
                  v_suma_deudor_ajuste_mb = v_suma_deudor_ajuste_mb +  COALESCE(v_resp_deudor[1],0);
                  
                
                                   
      END LOOP; --END LOOP lista
      
      -------------------------------------------------------------------------------------------------
      --  si tenemso necsidad de una suma extra solo consideramos el mayor sin balance de apertura
      --  OJO, se piensa que al ser una cuenta especial el ajsute delsaldo incial se considera en otro proceso 
      --   por ejemplo  actulizacion de reservas  donde se actulia la cuenta de ajsutes de capital
      -----------------------------------------------------------------------------------------------
      
      
      v_resp_deudor = conta.f_mayor_cuenta( v_record_rel_haber.ps_id_cuenta, 
                                                   p_desde, 
                                                   p_hasta, 
                                                    NULL, --todos los deptos p_id_depto::varchar, , 
                                                   'si',             --  p_incluir_cierre
                                                   'no',          --  p_incluir_apertura                   --NO CONSIDERA BALANCE DE APERTURA
                                                   'todos',          --  p_incluir_aitb, 
                                                   'defecto_cuenta', --  p_signo_balance, 
                                                   'deudor', --  p_tipo_saldo,
                                                    null,--p_id_auxiliar,
                                                    null,--p_id_int_comprobante_ori,
                                                    NULL,--id_ot
                                                    null -- p_id_centro_costo
                                                   );
                  
       --mayor acredor                                 
       v_resp_acreedor = conta.f_mayor_cuenta( v_record_rel_haber.ps_id_cuenta, 
                                                   p_desde, 
                                                   p_hasta, 
                                                   NULL, --todos los deptos p_id_depto::varchar, , 
                                                   'si',             --  p_incluir_cierre
                                                   'no',          --  p_incluir_apertura             --NO CONSIDERA BALANCE DE APERTURA
                                                   'todos',          --  p_incluir_aitb, 
                                                   'defecto_cuenta', -- p_signo_balance, 
                                                   'acreedor', --  p_tipo_saldo,
                                                    null,--p_id_auxiliar,
                                                    null,--p_id_int_comprobante_ori,
                                                    NULL,--id_ot
                                                    null -- p_id_centro_costo
                                                   );
                                                   
         IF  COALESCE(v_resp_acreedor[5],0) >  COALESCE(v_resp_deudor[5],0) THEN
                 v_saldo_tmp_cuenta_ma = COALESCE(v_resp_acreedor[5],0) - COALESCE(v_resp_deudor[5],0);
                 v_saldo_tmp_cuenta_mb = COALESCE(v_resp_acreedor[1],0) - COALESCE(v_resp_deudor[1],0);
         ELSE
                v_saldo_tmp_cuenta_ma = COALESCE(v_resp_deudor[5],0) - COALESCE(v_resp_acreedor[5],0);
                v_saldo_tmp_cuenta_mb = COALESCE(v_resp_deudor[1],0) - COALESCE(v_resp_acreedor[1],0);
         END IF; 
             
         v_saldo_tmp_cuenta_ma = round(v_saldo_tmp_cuenta_ma, 2); 
         v_saldo_tmp_cuenta_mb = round(v_saldo_tmp_cuenta_mb, 2);                                      
                                                   
                                                   
         v_glosa_ajuste = v_glosa_ajuste ||', MENOS AJUSTE ACUMULADO en '|| COALESCE(v_registros.nombre_cuenta)|| '  (UFV: '||v_saldo_tmp_cuenta_ma::varchar||' - BS: '||v_saldo_tmp_cuenta_mb::varchar||')' ;                                  
                                              
         v_suma_acreedor_ajuste_ma =  v_suma_acreedor_ajuste_ma  - COALESCE(v_resp_acreedor[5],0);
         v_suma_deudor_ajuste_ma = v_suma_deudor_ajuste_ma -  COALESCE(v_resp_deudor[5],0);
         v_suma_acreedor_ajuste_mb =  v_suma_acreedor_ajuste_mb  - COALESCE(v_resp_acreedor[1],0);
         v_suma_deudor_ajuste_mb = v_suma_deudor_ajuste_mb -  COALESCE(v_resp_deudor[1],0);
      
     
    
    
    ---------------------------------------------------------------------------
    --  CALCULO DEL MONTO A ACTUALIZAR
    ---------------------------------------------------------------------------
    
      v_sw_actualiza = false;
      v_diferencia_positiva = TRUE;  
      v_sw_saldo_acredor = false;
      v_aux_actualizado_mb = 0;
      v_saldo_mb  = 0;
      v_saldo_ma  = 0; 
    
     IF v_suma_acreedor_ajuste_ma  >  v_suma_deudor_ajuste_ma  THEN
                 
         v_sw_saldo_acredor = true;
         v_sw_actualiza = true;
         v_saldo_ma = v_suma_acreedor_ajuste_ma - v_suma_deudor_ajuste_ma;
         v_saldo_mb = v_suma_acreedor_ajuste_mb - v_suma_deudor_ajuste_mb;
                 
     ELSEIF   v_suma_deudor_ajuste_ma > v_suma_acreedor_ajuste_ma   THEN
                 
         v_sw_saldo_acredor = false;
         v_sw_actualiza = true;
         v_saldo_ma = v_suma_deudor_ajuste_ma - v_suma_acreedor_ajuste_ma;
         v_saldo_mb = v_suma_deudor_ajuste_mb - v_suma_acreedor_ajuste_mb;
                 
     ELSE
         raise notice 'no es necesario actualizar  esta cuenta % por que su saldo es cero', v_registros.id_cuenta;
         v_sw_actualiza = false;
     END IF; 
    
     IF  v_sw_actualiza THEN                                           
                
                      ------------------------------------------------------------
                      -- determinar diferencia por inflación  (perdida o ganacia)
                      ------------------------------------------------------------
                        
                      --covertir Moneda de actulizacion a moenda base
                     -- raise exception '--- %, %, UFV %, fecha % , BS  %', v_id_moneda_act, v_id_moneda_base, v_saldo_ma, v_reg_cbte.fecha, v_saldo_mb;
                      
                     
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
                       
                          v_diferencia  =  v_saldo_mb - v_aux_actualizado_mb;
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
                          IF v_sw_saldo_acredor THEN
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
                          -- vamos usar el centro de costo del mismo depto contable
                         
                          --  determinar si es perida o ganancia asi sabemos si va al debe o al haber 
                         IF v_importe_debe  > v_importe_haber THEN
                              --  determinar la partida,  (la  cuenta es la misma del mayor)
                             SELECT 
                              * 
                              into 
                              v_record_rel
                              FROM conta.f_get_config_relacion_contable( 'AJT_RESPAT_DEBE', 
                                                                         p_id_gestion_cbte, 
                                                                         NULL,  --campo_relacion_contable
                                                                         NULL);
                                                                         
                              IF v_record_rel.ps_id_partida is null THEN
                                 raise exception 'No se encontro relacion contable AJT_RESPAT_DEBE';
                              END IF;                                            
                                                                         
                         ELSE
                            --  determinar la partida,  (la  cuenta es la misma del mayor)
                            SELECT 
                                 * 
                              into 
                                  v_record_rel 
                              FROM conta.f_get_config_relacion_contable( 'AJT_RESPAT_HAB', 
                                                                         p_id_gestion_cbte, 
                                                                         NULL,  --campo_relacion_contable
                                                                         NULL);
                                                                         
                              IF v_record_rel.ps_id_partida is null THEN
                                 raise exception 'No se encontro relacion contable AJT_RESPAT_HAB';
                              END IF;                                             
                             
                         END IF;
                         
                          
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
                                      v_record_rel.ps_id_partida,   --partida de flujo
                                      v_id_centro_costo_depto, --centr de costo del depto contable
                                      'activo',
                                      v_record_rel.ps_id_cuenta, --cuenta de ajuste
                                      'Ajsute por actualización de reservas de las cuentas:  '|| COALESCE(v_glosa_ajuste,'NN') ,  --glosa
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
                                  
                                  v_sw_minimo = true;
                          
             ELSE
                raise exception 'El tipo de cambio no ha variado no necesita ser actualizado ';   
             END IF;
       ELSE
          raise exception 'No existe saldo para ser actulizado';      
       END IF; 
    
    
    
    IF not v_sw_minimo THEN
       raise exception 'No se actualizo ninguna cuenta';
    END IF;
    
      ----------------------------------------------- 
      --  insertar transaccion de AJUSTE de AITB
      -------------------------------------------------
      
      -- determinar si es perida o ganancia asi sabemos si va al debe o al haber 
     IF v_total_haber > v_total_debe THEN
         --ajuste al debe
         v_ajuste_debe =  v_total_haber - v_total_debe;
         v_ajuste_haber = 0;
         
         -- determinar la relacion contable para el ajuste (cuenta , partida)
          SELECT 
            * 
          into 
            v_record_rel_con 
          FROM conta.f_get_config_relacion_contable( 'GASTO_RESPAT', 
                                                     p_id_gestion_cbte, 
                                                     NULL,  --campo_relacion_contable
                                                     NULL);
                                                     
          IF v_record_rel.ps_id_cuenta is null THEN
             raise exception 'No se encontro relacion contable GASTO_RESPAT';
          END IF;                                             
                                                     
     ELSE
         -- ajuste al haber
          v_ajuste_haber =  v_total_debe  - v_total_haber ;
          v_ajuste_debe = 0;
          
          -- determinar la relacion contable para el ajuste (cuenta , partida)
          SELECT 
             * 
          into 
              v_record_rel_con 
          FROM conta.f_get_config_relacion_contable( 'RECURSO_RESPAT', 
                                                     p_id_gestion_cbte, 
                                                     NULL,  --campo_relacion_contable
                                                     NULL);
                                                     
          IF v_record_rel.ps_id_cuenta is null THEN
             raise exception 'No se encontro relacion contable RECURSO_RESPAT';
          END IF;                                             
                                                     
         
     END IF;
     
     
      
     --  inserta trasaccion de ajuste
      
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
                  v_record_rel_con.ps_id_partida,
                  v_id_centro_costo_depto,
                  'activo',
                  v_record_rel_con.ps_id_cuenta,
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
        
      
         
            -- raise exception 'termina..';
    
    
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