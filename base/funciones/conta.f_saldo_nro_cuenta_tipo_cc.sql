--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_saldo_nro_cuenta_tipo_cc (
  p_nro_cuenta varchar,
  p_id_tipo_cc integer,
  p_tipo_saldo varchar = 'balance'::character varying,
  p_id_int_comprobante integer = 0,
  out ps_saldo_mb numeric,
  out ps_saldo_mt numeric,
  out ps_saldo_ma numeric
)
RETURNS SETOF record AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuestos
 FUNCION: 		conta.f_saldo_nro_cuenta_tipo_cc
 DESCRIPCION:   Esta funcion cacula el saldo de una cuenta para un tipode centro de costo determinado en cbtes validados en diferentes gestion, o para un cbte especifico

                   
 AUTOR: 		Rensi Aarteaga Copari
 FECHA:	        31-10-2017
 COMENTARIOS:	
 ***************************************************************************************************   
    
    HISTORIAL DE MODIFICACIONES:
   	
 ISSUE            FECHA:		      AUTOR                 DESCRIPCION
   
 #0        		31-10-2017        RAC KPLIAN        Esta funcion cacula el saldo de una cuenta para un tipode centro de costo determinado en cbtes validados en diferentes gestion, o para un cbte especifico
 

***************************************************************************************************/




DECLARE
  verificado  					record;
  v_consulta 					varchar;
  v_conexion 					varchar;
  v_resp						varchar;
  v_nombre_funcion  			varchar;
 
 
 
 
  v_id_moneda					integer;
 
  v_registros					record;
  v_gestion						integer;
  v_cbte_cierre 				varchar;
  v_cbte_apertura				varchar;
  v_cbte_aitb 					varchar;
  
  v_resp_mayor_mb				numeric;
  v_resp_mayor_mt 				numeric;
  v_resp_mayor_ma 				numeric;
  
   v_sum_debe					numeric;
   v_sum_haber					numeric;
   v_sum_debe_mt				numeric;
   v_sum_haber_mt				numeric;
   v_sum_debe_ma				numeric;
   v_sum_haber_ma				numeric;
   
   
   va_cbte_cierre				varchar[];
   va_cbte_apertura				varchar[];
   va_cbte_aitb					varchar[];
   v_registros_cta				record;
  
  
BEGIN

  v_nombre_funcion = 'conta.f_saldo_nro_cuenta_tipo_cc';
  
     --por defecto no incluye comprobantes de cierres 
     v_cbte_cierre = 'no';
     --por defecto no incluye comprobantes de paertura
     v_cbte_apertura = 'no';
     --por defecto no cinluye comprobantes de aitb
     v_cbte_aitb = 'no';
     
     
	
     --iniciamos acumulador en cero
     v_resp_mayor_mb = 0;
     v_resp_mayor_mt = 0;
     v_resp_mayor_ma = 0;
     
     
     va_cbte_cierre[1] = 'no';
     
     if v_cbte_cierre = 'todos' then
        va_cbte_cierre[2] = 'balance';
        va_cbte_cierre[3] = 'resultado';
     elsif v_cbte_cierre = 'balance' then
        va_cbte_cierre[2] = 'balance';
     ELSIF v_cbte_cierre = 'resultado' then
        va_cbte_cierre[2] = 'resultado';
     end if;
     
     IF v_cbte_cierre = 'solo_cierre' THEN
         --sobreexribe la posicion uno ... 
         va_cbte_cierre[1] = 'resultado';
         va_cbte_cierre[2] = 'balance';
     END IF;
     
     --comprobante de apertura
     IF v_cbte_apertura = 'todos' THEN
       va_cbte_apertura[1] = 'si';
       va_cbte_apertura[2] = 'no';
     ELSIF  v_cbte_apertura = 'solo_apertura' THEN
        va_cbte_apertura[1] = 'si';
     ELSIF  v_cbte_apertura = 'no' THEN
        va_cbte_apertura[1] = 'no';
     END IF;
     
     IF v_cbte_aitb = 'todos' THEN
       va_cbte_aitb[1] = 'si';
       va_cbte_aitb[2] = 'no';
     ELSIF  v_cbte_aitb = 'solo_aitb' THEN
        va_cbte_aitb[1] = 'si';
     ELSIF  v_cbte_aitb = 'no' THEN
        va_cbte_aitb[1] = 'no';
     END IF;
    
     
     
     -- identificamos si es de movimiento o titular,  el incremento y el valor_incremento para la cuenta
     select
      c.tipo,
      c.movimiento
     into
      v_registros
     from 
     param.ttipo_cc c
     where c.id_tipo_cc = p_id_tipo_cc;
     
     --recupera datos de la cuenta
    select
      c.tipo_cuenta,
      c.eeff,
      c.valor_incremento,
      c.sw_transaccional,
      ctc.incremento,
      ctc.id_config_tipo_cuenta
     into
      v_registros_cta
     from 
     conta.tcuenta c
     inner join conta.tconfig_tipo_cuenta ctc on ctc.tipo_cuenta = c.tipo_cuenta
     where c.nro_cuenta = p_nro_cuenta
     LIMIT 1 OFFSET 0; 
     
     
     
     -- es una cuenta de movimiento
     IF  v_registros.movimiento = 'no' THEN
        raise exception 'Solo se admite apra tipos de centro de movimeinto';           
     END IF; 
     
      -- sumar el debe y el haber para la cuenta
      select 
         sum(t.importe_debe_mb),
         sum(t.importe_haber_mb),
         sum(t.importe_debe_mt),
         sum(t.importe_haber_mt),
         sum(t.importe_debe_ma),
         sum(t.importe_haber_ma)
       
      into
         v_sum_debe,
         v_sum_haber,
         v_sum_debe_mt,
         v_sum_haber_mt,
         v_sum_debe_ma,
         v_sum_haber_ma
      from conta.tint_transaccion t
      inner join param.tcentro_costo cc on cc.id_centro_costo = t.id_centro_costo
      inner join conta.tint_comprobante c on t.id_int_comprobante = c.id_int_comprobante
      inner join conta.tcuenta cue on cue.id_cuenta = t.id_cuenta
      where 
          cc.id_tipo_cc = p_id_tipo_cc AND 
          t.estado_reg = 'activo'  AND 
          c.estado_reg = 'validado' AND
          c.cbte_cierre = ANY(va_cbte_cierre) AND
          c.cbte_apertura = ANY(va_cbte_apertura) AND
          c.cbte_aitb = ANY(va_cbte_aitb) and 
         (case 
             when  p_id_int_comprobante != 0  then
                 c.id_int_comprobante = p_id_int_comprobante
             else
                0 = 0
          end)  AND   
          cue.nro_cuenta = p_nro_cuenta; --filtra simrpe por nro de cuenta
                    
       
          
    --------------------------------
    --  calculo de tipo de resultado
    --------------------------------
      IF  p_tipo_saldo = 'balance' THEN
      
          --revisar el tipo de saldo de la cuenta
          IF  v_registros_cta.incremento = 'debe'   THEN          
               v_resp_mayor_mb = COALESCE(v_sum_debe,0) - COALESCE(v_sum_haber,0);
               v_resp_mayor_mt = COALESCE(v_sum_debe_mt,0) - COALESCE(v_sum_haber_mt,0);
               v_resp_mayor_ma = COALESCE(v_sum_debe_ma,0) - COALESCE(v_sum_haber_ma,0);
            ELSE
               --si el incremento de haber 
               v_resp_mayor_mb = COALESCE(v_sum_haber,0) - COALESCE(v_sum_debe,0); 
               v_resp_mayor_mt = COALESCE(v_sum_haber_mt,0) - COALESCE(v_sum_debe_mt,0);
               v_resp_mayor_ma = COALESCE(v_sum_haber_ma,0) - COALESCE(v_sum_debe_ma,0);
            END IF;
          
     ELSEIF  p_tipo_saldo = 'deudor' THEN
                
            v_resp_mayor_mb = COALESCE(v_sum_debe,0);
            v_resp_mayor_mt = COALESCE(v_sum_debe_mt,0);
            v_resp_mayor_ma = COALESCE(v_sum_debe_ma,0);               
                
     ELSEIF  p_tipo_saldo = 'acreedor' THEN
               
           v_resp_mayor_mb = COALESCE(v_sum_haber,0);
           v_resp_mayor_mt = COALESCE(v_sum_haber_mt,0);
           v_resp_mayor_ma = COALESCE(v_sum_haber_ma,0);              
     ELSE
        raise exception 'tipo de saldo  no considerado %', p_tipo_saldo;
               
     END IF; 
        
     
     ps_saldo_ma = v_resp_mayor_ma;
     ps_saldo_mb = v_resp_mayor_mb;
     ps_saldo_mt = v_resp_mayor_mt;
  

  
  return NEXT;
  return;


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
COST 100 ROWS 1000;