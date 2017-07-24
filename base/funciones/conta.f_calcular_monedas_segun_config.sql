--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_calcular_monedas_segun_config (
  p_id_moneda integer,
  p_id_moneda_base integer,
  p_id_moneda_tri integer,
  p_id_moneda_act integer,
  p_tipo_cambio numeric,
  p_tipo_cambio_2 numeric,
  p_tipo_cambio_3 numeric,
  p_importe numeric,
  p_id_config_cambiaria integer,
  p_fecha date
)
RETURNS numeric [] AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.f_calcular_monedas_segun_config
 DESCRIPCION:   en funcion a los codigos de las moendas regresa el tipo de cambio correspondiente
                la conversion se ha pasando por moneda base, si no encuentra regresa NULL
 AUTOR: 		 (rac)  kplian
 FECHA:	        05-11-2015 12:39:12
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	Se agrega moneda de actualizacion
 AUTOR:		   RAC KPIAN	
 FECHA:		   11/07/2017		
***************************************************************************/

DECLARE


v_registros_mon_1  		record;
v_registros_mon_2       record;
v_nombre_funcion		varchar;
v_resp					varchar;
v_id_moneda_base		integer;
v_id_moneda_tri			integer;

v_id_m1					integer;
v_id_m2					integer;
v_id_m3					integer;
va_tc1 varchar[];
va_tc2 varchar[];
va_tc3 varchar[];

v_tmp1 varchar;
v_tmp2 varchar;
v_tmp3 varchar;

va_id_tc1 varchar[];
va_id_tc2 varchar[];
va_id_tc3 varchar[];
 
v_valor_mb numeric;
v_valor_mt numeric;
v_valor_ma numeric;


v_valor_debe_mt numeric;
v_valor_debe_ma numeric;
v_valor_debe_mb numeric;
v_temp_debe  numeric;

v_retorno  numeric[];

 
 



v_registros				record;

 

BEGIN

  	 v_nombre_funcion = 'conta.f_calcular_monedas_segun_config';
   
   
     select 
      cc.ope_1,
      cc.ope_2,
      cc.ope_3
     into 
      v_registros
     from conta.tconfig_cambiaria cc 
     where cc.id_config_cambiaria = p_id_config_cambiaria;
   
  
   -----------------
   --  operacion 1
   -----------------
       va_tc1 = regexp_split_to_array(v_registros.ope_1, '->');
               
       v_tmp1 = replace(v_registros.ope_1, '{M}', p_id_moneda::varchar);
       v_tmp1 = replace(v_tmp1, '{MB}',p_id_moneda_base::Varchar);
       v_tmp1 = replace(v_tmp1, '{MT}',p_id_moneda_tri::varchar);
       v_tmp1 = replace(v_tmp1, '{MA}',p_id_moneda_act::varchar);
                 
       -- desglosa los id
       va_id_tc1 = regexp_split_to_array(v_tmp1, '->');   
                 
                 
     -- el valor inicial siempre es la moneda transaccional con el tipo de cambio 1
                    
     IF va_tc1[2] = '{MT}'  THEN
       v_valor_debe_mt =  param.f_convertir_moneda (va_id_tc1[1]::integer, va_id_tc1[2]::integer,   p_importe, p_fecha,'CUS',50, p_tipo_cambio, 'no');
     ELSIF va_tc1[2] = '{MA}'  THEN
      v_valor_debe_ma =  param.f_convertir_moneda (va_id_tc1[1]::integer, va_id_tc1[2]::integer,   p_importe, p_fecha,'CUS',50, p_tipo_cambio, 'no');
     ELSIF va_tc1[2] = '{MB}'  THEN
        v_valor_debe_mb =  param.f_convertir_moneda (va_id_tc1[1]::integer, va_id_tc1[2]::integer,   p_importe, p_fecha,'CUS',50, p_tipo_cambio, 'no');
     END IF;
                
    -----------------
    -- operacion 2
    -----------------
                
     va_tc2 = regexp_split_to_array(v_registros.ope_2, '->');
                
     v_tmp2 = replace(v_registros.ope_2, '{M}', p_id_moneda::varchar);
     v_tmp2 = replace(v_tmp2, '{MB}',p_id_moneda_base::varchar);
     v_tmp2 = replace(v_tmp2, '{MT}',p_id_moneda_tri::varchar);
     v_tmp3 = replace(v_tmp2, '{MA}',p_id_moneda_act::varchar);
                 
                 
      -- define el valor  inicial
                  
     IF va_tc2[1] = '{M}' THEN
        v_temp_debe =  p_importe;
     ELSEIF va_tc2[1] = '{MA}' THEN
        v_temp_debe =   v_valor_debe_ma;
     ELSEIF va_tc2[1] = '{MT}' THEN
        v_temp_debe =  v_valor_debe_mt;
     ELSEIF va_tc2[1] = '{MB}' THEN
        v_temp_debe =  v_valor_debe_mb;   
     END IF;
                 
    --desglosa los id
     va_id_tc2 = regexp_split_to_array(v_tmp2, '->');   
                    
     IF va_tc2[2] = '{MT}'  THEN
       v_valor_debe_mt =   param.f_convertir_moneda (va_id_tc2[1]::integer, va_id_tc2[2]::integer,   v_temp_debe, p_fecha,'CUS',50, p_tipo_cambio_2, 'no');
     ELSEIF va_tc2[2] = '{MA}'  THEN
        v_valor_debe_ma =   param.f_convertir_moneda (va_id_tc2[1]::integer, va_id_tc2[2]::integer,   v_temp_debe,p_fecha,'CUS',50, p_tipo_cambio_2, 'no');
     ELSEIF va_tc2[2] = '{MB}'  THEN
       v_valor_debe_mb =   param.f_convertir_moneda (va_id_tc2[1]::integer, va_id_tc2[2]::integer,   v_temp_debe,p_fecha,'CUS',50, p_tipo_cambio_2, 'no');
     END IF;
     
     
    -----------------
    -- operacion 3
    -----------------
                
     va_tc3 = regexp_split_to_array(v_registros.ope_3, '->');
                
     v_tmp3 = replace(v_registros.ope_3, '{M}', p_id_moneda::varchar);
     v_tmp3 = replace(v_tmp3, '{MB}',p_id_moneda_base::varchar);
     v_tmp3 = replace(v_tmp3, '{MT}',p_id_moneda_tri::varchar);
     v_tmp3 = replace(v_tmp3, '{MA}',p_id_moneda_act::varchar);
                 
                 
      -- define el valor  inicial
                  
     IF va_tc3[1] = '{M}' THEN
        v_temp_debe =  p_importe;
     ELSEIF va_tc3[1] = '{MB}' THEN
        v_temp_debe =   v_valor_debe_mb;
     ELSEIF va_tc3[1] = '{MT}' THEN 
        v_temp_debe =  v_valor_debe_mt;
     ELSEIF va_tc3[1] = '{MA}' THEN 
        v_temp_debe =  v_valor_debe_ma;   
     END IF;
                 
    --desglosa los id
     va_id_tc3 = regexp_split_to_array(v_tmp3, '->');   
                    
     IF va_tc3[2] = '{MT}'  THEN
       v_valor_debe_mt =   param.f_convertir_moneda (va_id_tc3[1]::integer, va_id_tc3[2]::integer,   v_temp_debe, p_fecha,'CUS',50, p_tipo_cambio_3, 'no');
     ELSEIF va_tc3[2] = '{MA}'  THEN
        v_valor_debe_ma =   param.f_convertir_moneda (va_id_tc3[1]::integer, va_id_tc3[2]::integer,   v_temp_debe,p_fecha,'CUS',50, p_tipo_cambio_3, 'no');
     ELSEIF va_tc3[2] = '{MB}'  THEN
       v_valor_debe_mb =   param.f_convertir_moneda (va_id_tc3[1]::integer, va_id_tc3[2]::integer,   v_temp_debe,p_fecha,'CUS',50, p_tipo_cambio_3, 'no');
     END IF;
            
      
      v_retorno[1] = v_valor_debe_mb;
      v_retorno[2] = v_valor_debe_mt;
      v_retorno[3] = v_valor_debe_ma;
    
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
STABLE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;