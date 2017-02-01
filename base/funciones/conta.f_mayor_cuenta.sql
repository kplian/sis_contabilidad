--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_mayor_cuenta (
  p_id_cuenta integer,
  p_fecha_ini date,
  p_fecha_fin date,
  p_id_deptos varchar,
  p_incluir_cierre varchar = 'no'::character varying,
  p_incluir_apertura varchar = 'todos'::character varying,
  p_incluir_aitb varchar = 'todos'::character varying,
  p_signo_balance varchar = 'defecto_cuenta'::character varying,
  p_tipo_saldo varchar = 'balance'::character varying,
  p_id_auxiliar integer = NULL::integer,
  p_id_int_comprobante_ori integer = NULL::integer,
  p_id_ot integer = NULL::integer,
  p_id_centro_costo integer = NULL::integer
)
RETURNS numeric [] AS
$body$
/*
Autor: RCM
Fecha: 18/11/2013
Descripcion: Funcion para la eliminacion de int comprobante
*/

DECLARE

	v_rec_cbte record;
    v_funcion_comprobante_eliminado varchar;
    v_resp							varchar;
    v_nombre_funcion   				varchar;
    v_rec_cbte_trans 				record;
     v_registros					record;
    
    
    v_resp_final  					numeric[];
    v_resp_aux  					numeric[];
    v_resp_mayor   					numeric;
   
    v_sum_debe						numeric;
    v_sum_haber						numeric;
    
    v_resp_mayor_mt   				numeric;
   
    v_sum_debe_mt					numeric;
    v_sum_haber_mt					numeric;
    
    
    va_id_deptos					integer[];
    va_cbte_cierre					varchar[];
    va_cbte_apertura				varchar[];
    va_cbte_aitb					varchar[];
    
    v_sum_gasto						numeric;
    v_sum_recurso					numeric;
    v_sum_gasto_mt					numeric;
    v_sum_recurso_mt				numeric;
    
    v_resp_mayor_partida				numeric;
    v_resp_mayor_partida_mt				numeric;
 
BEGIN
  	 v_nombre_funcion:='conta.f_mayor_cuenta';
     
     
     va_cbte_cierre[1] = 'no';
     
     if p_incluir_cierre = 'todos' then
        va_cbte_cierre[2] = 'balance';
        va_cbte_cierre[3] = 'resultado';
     elsif p_incluir_cierre = 'balance' then
        va_cbte_cierre[2] = 'balance';
     ELSIF p_incluir_cierre = 'resultado' then
        va_cbte_cierre[2] = 'resultado';
     end if;
     IF p_incluir_cierre = 'solo_cierre' THEN
         
         --sobreexribe la posicion uno ... 
         va_cbte_cierre[1] = 'resultado';
         va_cbte_cierre[2] = 'balance';
     
     END IF;
     
     --comprobante de apertura
     IF p_incluir_apertura = 'todos' THEN
       va_cbte_apertura[1] = 'si';
       va_cbte_apertura[2] = 'no';
     ELSIF  p_incluir_apertura = 'solo_apertura' THEN
        va_cbte_apertura[1] = 'si';
     ELSIF  p_incluir_apertura = 'no' THEN
        va_cbte_apertura[1] = 'no';
     END IF;
     
     IF p_incluir_aitb = 'todos' THEN
       va_cbte_aitb[1] = 'si';
       va_cbte_aitb[2] = 'no';
     ELSIF  p_incluir_aitb = 'solo_aitb' THEN
        va_cbte_aitb[1] = 'si';
     ELSIF  p_incluir_aitb = 'no' THEN
        va_cbte_aitb[1] = 'no';
     END IF;
     
   
	
     --iniciamos acumulador en cero
     v_resp_mayor = 0;
     v_resp_mayor_mt = 0;
     
     va_id_deptos = string_to_array(p_id_deptos,',')::INTEGER[];
     
     -- identificamos si es de momiento o titular,  el incremento y el valor_incremento para la cuenta
     select
      c.tipo_cuenta,
      c.eeff,
      c.valor_incremento,
      c.sw_transaccional,
      ctc.incremento,
      ctc.id_cofig_tipo_cuenta
     into
      v_registros
     from 
     conta.tcuenta c
     inner join conta.tconfig_tipo_cuenta ctc on ctc.tipo_cuenta = c.tipo_cuenta
     where c.id_cuenta = p_id_cuenta;
     
     -- verificamos la cuenta
     IF   v_registros.id_cofig_tipo_cuenta is NULL THEN
        raise exception 'La cuenta con el id: % no tiene un tipo cuenta asociado',  p_id_cuenta;
     END IF;
     
     -- es una cuenta de movimiento
     IF  v_registros.sw_transaccional = 'movimiento' THEN
     
          -- sumar el debe y el haber para la cuenta
          select 
             sum(t.importe_debe_mb),
             sum(t.importe_haber_mb),
             sum(t.importe_debe_mt),
             sum(t.importe_haber_mt),
             sum(t.importe_gasto_mb),
             sum(t.importe_recurso_mb),
             sum(t.importe_gasto_mt),
             sum(t.importe_recurso_mt)
          into
             v_sum_debe,
             v_sum_haber,
             v_sum_debe_mt,
             v_sum_haber_mt,
             v_sum_gasto,
             v_sum_recurso,
             v_sum_gasto_mt,
             v_sum_recurso_mt
          from conta.tint_transaccion t
          inner join conta.tint_comprobante c on t.id_int_comprobante = c.id_int_comprobante
          where 
              t.id_cuenta = p_id_cuenta AND 
              t.estado_reg = 'activo'  AND 
              c.estado_reg = 'validado' AND
              c.cbte_cierre = ANY(va_cbte_cierre) AND
              c.cbte_apertura = ANY(va_cbte_apertura) AND
              c.cbte_aitb = ANY(va_cbte_aitb) AND
              (
                CASE  WHEN p_id_int_comprobante_ori is NULL  THEN
              				c.fecha BETWEEN  p_fecha_ini  and p_fecha_fin 
                      ELSE
                            c.id_int_comprobante = p_id_int_comprobante_ori
                      END
              ) AND
              c.id_depto::integer = ANY(va_id_deptos) AND 
              (CASE WHEN p_id_auxiliar is NULL  THEN  
                         0=0 
                    ELSE
                       t.id_auxiliar = p_id_auxiliar 
                    END) AND 
              (CASE WHEN p_id_ot is NULL  THEN  
                         0=0 
                    ELSE
                       t.id_orden_trabajo = p_id_ot 
                    END) AND 
              (CASE WHEN p_id_centro_costo is NULL  THEN  
                         0=0 
                    ELSE
                       t.id_centro_costo = p_id_centro_costo 
                    END);
                    
       
          
        --------------------------------
        --  calculo de tipo de resultado
        --------------------------------
          IF  p_tipo_saldo = 'balance' THEN
            
                IF p_signo_balance = 'defecto_cuenta'  THEN
                    -- si el incremento es debe 
                    IF  v_registros.incremento = 'debe'   THEN
                       v_resp_mayor = COALESCE(v_sum_debe,0) - COALESCE(v_sum_haber,0);
                       v_resp_mayor_mt = COALESCE(v_sum_debe_mt,0) - COALESCE(v_sum_haber_mt,0);
                       
                       v_resp_mayor_partida = COALESCE(v_sum_gasto,0) - COALESCE(v_sum_recurso,0);
                       v_resp_mayor_partida_mt = COALESCE(v_sum_gasto_mt,0) - COALESCE(v_sum_recurso_mt,0);
                    ELSE
                    --si el incremento de haber 
                       v_resp_mayor = COALESCE(v_sum_haber,0) - COALESCE(v_sum_debe,0); 
                       v_resp_mayor_mt = COALESCE(v_sum_haber_mt,0) - COALESCE(v_sum_debe_mt,0); 
                       
                       v_resp_mayor_partida = COALESCE(v_sum_recurso,0) - COALESCE(v_sum_gasto,0); 
                       v_resp_mayor_partida_mt = COALESCE(v_sum_recurso_mt,0) - COALESCE(v_sum_gasto_mt,0); 
                    END IF;  
                   
              
                ELSIF   p_signo_balance = 'deudor' THEN
                  --forzar saldo deudor
                  v_resp_mayor = COALESCE(v_sum_debe,0) - COALESCE(v_sum_haber,0);
                  v_resp_mayor_mt = COALESCE(v_sum_debe_mt,0) - COALESCE(v_sum_haber_mt,0); 
                  
                  v_resp_mayor_partida = COALESCE(v_sum_gasto,0) - COALESCE(v_sum_recurso,0);
                  v_resp_mayor_partida_mt = COALESCE(v_sum_gasto_mt,0) - COALESCE(v_sum_recurso_mt,0);    
                ELSE
                  --forzar saldo acredor 
                  v_resp_mayor = COALESCE(v_sum_haber,0) - COALESCE(v_sum_debe,0);
                  v_resp_mayor_mt = COALESCE(v_sum_haber_mt,0) - COALESCE(v_sum_debe_mt,0);
                  
                  v_resp_mayor_partida = COALESCE(v_sum_recurso,0) - COALESCE(v_sum_gasto,0);
                  v_resp_mayor_partida_mt = COALESCE(v_sum_recurso_mt,0) - COALESCE(v_sum_gasto_mt,0);
                END IF;
                
               
                -- raise exception 'bal %, %, %,--- % ,%', v_resp_mayor, p_signo_balance, p_tipo_saldo,  COALESCE(v_sum_debe,0),  COALESCE(v_sum_debe,0);
         
          ELSEIF  p_tipo_saldo = 'deudor' THEN
                v_resp_mayor = COALESCE(v_sum_debe,0);
                v_resp_mayor_mt = COALESCE(v_sum_debe_mt,0);
                
                v_resp_mayor_partida = COALESCE(v_sum_gasto,0);
                v_resp_mayor_partida_mt = COALESCE(v_sum_gasto_mt,0);
          ELSEIF  p_tipo_saldo = 'acreedor' THEN
               v_resp_mayor = COALESCE(v_sum_haber,0);
               v_resp_mayor_mt = COALESCE(v_sum_haber_mt,0);
               
               v_resp_mayor_partida = COALESCE(v_sum_recurso,0);
               v_resp_mayor_partida_mt = COALESCE(v_sum_recurso_mt,0);
          END IF; 
          -- retornamos el resultado 
          v_resp_final[1] = v_resp_mayor;
          v_resp_final[2] = v_resp_mayor_mt;
          
          v_resp_final[3] = v_resp_mayor_partida;
          v_resp_final[4] = v_resp_mayor_partida_mt;
          
          
          raise notice '##################  RESULTADO BASICO %, %',v_resp_mayor,p_id_cuenta;
        
          return v_resp_final;  
          
          
     ELSE
     -- si no es una cuenta titular
        -- for, listamos los hijos de la cuenta 
         FOR v_registros in (select 
                                 c.id_cuenta
                             from conta.tcuenta c 
                             where c.id_cuenta_padre = p_id_cuenta and c.estado_reg = 'activo') LOOP
               --    llamada recursiva
               
               v_resp_aux = conta.f_mayor_cuenta(v_registros.id_cuenta, 
               									 p_fecha_ini, 
                                                 p_fecha_fin, 
                                                 p_id_deptos, 
                                                 p_incluir_cierre,
                                                 p_incluir_apertura,
                                                 p_incluir_aitb, 
                                                 p_signo_balance, 
                                                 p_tipo_saldo,
                                                 p_id_int_comprobante_ori);
               
         
               raise notice 'XXXXXXXXXXXXXX parametros   %,%,%,%,%,%,%,%,%,%',v_registros.id_cuenta,p_fecha_ini,p_fecha_fin,
               													p_id_deptos, 
                                                                 p_incluir_cierre,
                                                                 p_incluir_apertura,
                                                                 p_incluir_aitb, 
                                                                 p_signo_balance, 
                                                                 p_tipo_saldo,
                                                                 p_id_int_comprobante_ori;
                        
               raise notice '>>>>>>> % regresa maryo = %',v_registros.id_cuenta, v_resp_mayor;
               v_resp_mayor = v_resp_mayor + v_resp_aux[1];               
               v_resp_mayor_mt = v_resp_mayor_mt + v_resp_aux[2];               
               v_resp_mayor_partida = v_resp_mayor_partida + v_resp_aux[3];               
               v_resp_mayor_partida_mt= v_resp_mayor_partida_mt + v_resp_aux[4];
               
         END LOOP;
         
         v_resp_final[1] = v_resp_mayor;
         v_resp_final[2] = v_resp_mayor_mt;
         v_resp_final[3] = v_resp_mayor_partida;
         v_resp_final[4] = v_resp_mayor_partida_mt;
        
         return v_resp_final;
         
     END IF;     
          
     v_resp_final[1] = 0;
     v_resp_final[2] = 0;
     v_resp_final[3] = 0;
     v_resp_final[4] = 0;     
     
     return v_resp_final;
     
     
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