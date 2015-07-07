--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_mayor_cuenta (
  p_id_cuenta integer,
  p_fecha_ini date,
  p_fecha_fin date,
  p_id_deptos varchar
)
RETURNS numeric AS
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
    v_rec_cbte_trans record;
    
    v_resp_mayor   					numeric;
    v_registros						record;
    v_sum_debe						numeric;
    v_sum_haber						numeric;
    va_id_deptos					integer[];
 
BEGIN
  	 v_nombre_funcion:='conta.f_mayor_cuenta';
	
     --iniciamos acumulador en cero
     v_resp_mayor = 0;
     
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
        raise exception 'LA cuenta con el id: % no tiene un tipo cuenta asociado',  p_id_cuenta;
     END IF;
     
     -- es una cuenta de movimiento
     IF  v_registros.sw_transaccional = 'movimiento' THEN
     
          -- sumar el debe y el haber para la cuenta
          select 
             sum(t.importe_debe_mb),
             sum(t.importe_haber_mb)
          into
             v_sum_debe,
             v_sum_haber
          from conta.tint_transaccion t
          inner join conta.tint_comprobante c on t.id_int_comprobante = c.id_int_comprobante
          where 
              t.id_cuenta = p_id_cuenta AND 
              t.estado_reg = 'activo'  AND 
              c.estado_reg = 'validado' AND
              c.fecha BETWEEN  p_fecha_ini  and p_fecha_fin AND
              c.id_depto::integer = ANY(va_id_deptos);
          
          -- si el incremento es debe 
          IF  v_registros.incremento = 'debe'   THEN
             v_resp_mayor = COALESCE(v_sum_debe,0) - COALESCE(v_sum_haber,0);
          ELSE
          --si el incremento de haber 
             v_resp_mayor = COALESCE(v_sum_haber,0) -COALESCE(v_sum_debe,0); 
          END IF;  
          -- retornamos el resultado multiplicado por el signo     
          
          raise notice 'id: % parcial % ', p_id_cuenta, v_resp_mayor;
          
          return v_resp_mayor;
         
          
     ELSE
     -- si no es una cuenta titular
        -- for, listamos los hijos de la cuenta 
         FOR v_registros in (select 
                                 c.id_cuenta
                             from conta.tcuenta c 
                             where c.id_cuenta_padre = p_id_cuenta and c.estado_reg = 'activo') LOOP
               --    llamada recursiva
               v_resp_mayor = v_resp_mayor + conta.f_mayor_cuenta(v_registros.id_cuenta, p_fecha_ini, p_fecha_fin, p_id_deptos);
         
         END LOOP;
        
         return v_resp_mayor;
         
     END IF;     
          
           
     
     return 0;
EXCEPTION
WHEN OTHERS THEN
	if (current_user like '%dblink_%') then
    	v_resp = pxp.f_obtiene_clave_valor(SQLERRM,'mensaje','','','valor');
        if v_resp = '' then        	
        	v_resp = SQLERRM;
        end if;
    	return 'error' || '#@@@#' || v_resp;        
    else
			v_resp='';
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
			v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
			v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
			raise exception '%',v_resp;
    end if;
END;
$body$
LANGUAGE 'plpgsql'
STABLE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;