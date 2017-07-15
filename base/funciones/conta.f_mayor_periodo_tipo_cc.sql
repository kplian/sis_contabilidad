--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_mayor_periodo_tipo_cc (
  p_id_tipo_cc integer,
  p_id_periodo integer
)
RETURNS numeric [] AS
$body$
/*
Autor: RAC - KPLIAN
Fecha: 20/05/2017
Descripcion: funcion que calcula el mayor por tipo de centor de costo
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
  	 v_nombre_funcion:='conta.f_mayor_periodo_tipo_cc';
     
     
     --iniciamos acumulador en cero
     v_resp_mayor = 0;
     v_resp_mayor_mt = 0;
     v_resp_mayor_partida = 0;
     v_resp_mayor_partida_mt  = 0;
     
     v_resp_final[1] = 0;
     v_resp_final[2] = 0;
     v_resp_final[3] = 0;
     v_resp_final[4] = 0;
     v_resp_final[5] =  0;
     v_resp_final[6] = 0;
     v_resp_final[7] = 0;
     v_resp_final[8] = 0;
     v_resp_final[9] = 0;
     v_resp_final[10] = 0;
     v_resp_final[11] = 0;
     v_resp_final[12] = 0;
     
  
     
     -- identificamos si es de movimiento o titular,  el incremento y el valor_incremento para la cuenta
     select
      c.tipo,
      c.movimiento
     into
      v_registros
     from 
     conta.torden_trabajo c
     where c.id_orden_trabajo = p_id_tipo_cc;
     
    
     
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
              inner join param.tcentro_costo cc on cc.id_centro_costo = t.id_centro_costo 
              inner join conta.tint_comprobante c on t.id_int_comprobante = c.id_int_comprobante
              where 
                  cc.id_tipo_cc = p_id_tipo_cc AND 
                  t.estado_reg = 'activo'  AND 
                  c.estado_reg = 'validado' AND
                  c.id_periodo = p_id_periodo;
                        
           
              
            --------------------------------
            --  calculo de tipo de resultado
            --------------------------------
             
            
            v_resp_mayor = COALESCE(v_sum_debe,0) - COALESCE(v_sum_haber,0);
            v_resp_mayor_mt = COALESCE(v_sum_debe_mt,0) - COALESCE(v_sum_haber_mt,0); 
            v_resp_mayor_partida = COALESCE(v_sum_gasto,0) - COALESCE(v_sum_recurso,0);
            v_resp_mayor_partida_mt = COALESCE(v_sum_gasto_mt,0) - COALESCE(v_sum_recurso_mt,0);    
             
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
                                     c.id_tipo_cc
                                 from param.ttipo_cc c 
                                 where c.id_tipo_cc_fk = p_id_tipo_cc and c.estado_reg = 'activo') LOOP
                                 
                   --    llamada recursiva
                   
                   v_resp_aux = conta.f_mayor_periodo_tipo_cc(v_registros.id_tipo_cc, p_id_periodo);
                   
                   v_resp_final[1] = v_resp_final[1] + v_resp_aux[1];               
                   v_resp_final[2] = v_resp_final[2] + v_resp_aux[2];               
                   v_resp_final[3] = v_resp_final[3] + v_resp_aux[3];               
                   v_resp_final[4]= v_resp_final[4] + v_resp_aux[4];
                   
                    --retornamos debe
                  v_resp_final[5] =  v_resp_final[5] +v_resp_aux[5];
                  v_resp_final[6] = v_resp_final[6] + v_resp_aux[6];
                  v_resp_final[7] = v_resp_final[7] + v_resp_aux[7];
                  v_resp_final[8] =  v_resp_final[8] +v_resp_aux[8];
                  --retornamos haber
                  v_resp_final[9] = v_resp_final[9] +   v_resp_aux[9];
                  v_resp_final[10] = v_resp_final[10] + v_resp_aux[10];
                  v_resp_final[11] = v_resp_final[11] + v_resp_aux[11];
                  v_resp_final[12] = v_resp_final[12] + v_resp_aux[12];
                   
                  
                   
             END LOOP;
             
            
             return v_resp_final;
             
     END IF;     
          
    
      
     
    
     
     
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