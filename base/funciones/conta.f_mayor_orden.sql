--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_mayor_orden (
  p_id_orden_trabajo integer,
  p_fecha_ini date,
  p_fecha_fin date,
  p_id_deptos varchar,
  p_incluir_cierre varchar = 'no'::character varying,
  p_incluir_apertura varchar = 'todos'::character varying,
  p_incluir_aitb varchar = 'todos'::character varying,
  p_signo_balance varchar = 'defecto_cuenta'::character varying,
  p_tipo_saldo varchar = 'balance'::character varying,
  p_id_auxiliar integer = NULL::integer,
  p_id_centro_costo integer = NULL::integer
)
RETURNS numeric [] AS
$body$
/*
Autor: RAC - KPLIAN
Fecha: 20/05/2017
Descripcion: funcion que calcula el mayor por orden de trabajo
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
  	 v_nombre_funcion:='conta.f_mayor_orden';
     
     
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
     
     -- identificamos si es de movimiento o titular,  el incremento y el valor_incremento para la cuenta
     select
      c.tipo,
      c.movimiento
     into
      v_registros
     from 
     conta.torden_trabajo c
     where c.id_orden_trabajo = p_id_orden_trabajo;
     
    
     
     -- es una cuenta de movimiento
     IF  v_registros.movimiento = 'si' THEN
     
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
              t.id_orden_trabajo = p_id_orden_trabajo AND 
              t.estado_reg = 'activo'  AND 
              c.estado_reg = 'validado' AND
              c.cbte_cierre = ANY(va_cbte_cierre) AND
              c.cbte_apertura = ANY(va_cbte_apertura) AND
              c.cbte_aitb = ANY(va_cbte_aitb) AND              
              c.id_depto::integer = ANY(va_id_deptos) AND 
              c.fecha BETWEEN  p_fecha_ini  and p_fecha_fin AND
              
              (CASE WHEN p_id_auxiliar is NULL  THEN  
                         0=0 
                    ELSE
                       t.id_auxiliar = p_id_auxiliar 
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
            
               --forzar saldo deudor
               v_resp_mayor = COALESCE(v_sum_debe,0) - COALESCE(v_sum_haber,0);
               v_resp_mayor_mt = COALESCE(v_sum_debe_mt,0) - COALESCE(v_sum_haber_mt,0); 
               v_resp_mayor_partida = COALESCE(v_sum_gasto,0) - COALESCE(v_sum_recurso,0);
               v_resp_mayor_partida_mt = COALESCE(v_sum_gasto_mt,0) - COALESCE(v_sum_recurso_mt,0);    
         
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
          --retornamos debe
          v_resp_final[5] = COALESCE(v_sum_debe,0);
          v_resp_final[6] = COALESCE(v_sum_debe_mt,0);
          v_resp_final[7] = COALESCE(v_sum_gasto,0);
          v_resp_final[8] = COALESCE(v_sum_gasto_mt,0);
          --retornamos haber
          v_resp_final[9] = COALESCE(v_sum_haber,0);
          v_resp_final[10] = COALESCE(v_sum_haber_mt,0);
          v_resp_final[11] = COALESCE(v_sum_recurso,0);
          v_resp_final[12] = COALESCE(v_sum_recurso_mt,0);
          
          raise notice '##################  RESULTADO BASICO %',v_resp_mayor;
        
          return v_resp_final;  
          
          
     ELSE
     -- si no,  es una cuenta titular
        -- for, listamos los hijos de la cuenta 
         FOR v_registros in (select 
                                 c.id_orden_trabajo
                             from conta.torden_trabajo c 
                             where c.id_orden_trabajo_fk = p_id_orden_trabajo and c.estado_reg = 'activo') LOOP
               --    llamada recursiva
               
               v_resp_aux = conta.f_mayor_orden(v_registros.id_orden_trabajo, 
               									 p_fecha_ini, 
                                                 p_fecha_fin, 
                                                 p_id_deptos, 
                                                 p_incluir_cierre,
                                                 p_incluir_apertura,
                                                 p_incluir_aitb, 
                                                 p_signo_balance, 
                                                 p_tipo_saldo);
         
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
     
     raise notice 'f_maryo_orden %',v_resp_final;    
     
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