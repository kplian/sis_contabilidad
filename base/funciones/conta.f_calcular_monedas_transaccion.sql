--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_calcular_monedas_transaccion (
  p_id_int_transaccion integer
)
RETURNS void AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.f_calcular_monedas_transaccion
 DESCRIPCION:   en funcion a los codigos de las moendas regresa el tipo de cambio correspondiente
                la conversion  ha pasando por moneda base, si no encuentra regresa NULL
 AUTOR: 		 (rac)  kplian
 FECHA:	        05-11-2015 12:39:12
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE


v_registros_mon_1  		record;
v_registros_mon_2       record;
v_nombre_funcion		varchar;
v_resp					varchar;
v_id_moneda_base		integer;
v_id_moneda_tri			integer;
v_id_moneda_act			integer;
v_id_m1					integer;
v_id_m2					integer;
va_tc1 					varchar[];
va_tc2 					varchar[];
v_tmp1 					varchar;
v_tmp2 					varchar;
va_id_tc1 				varchar[];
va_id_tc2 				varchar[];
v_valor_mb 				numeric;
v_valor_mt 				numeric;
v_valor_debe_mt 		numeric;
v_valor_haber_mt 		numeric;
v_valor_debe_mb 		numeric;
v_valor_haber_mb 		numeric; 
v_temp_debe  			numeric;
v_temp_haber  			numeric; 
va_montos 				numeric[];
v_registros				record;
v_registros_rel			record;
v_valor_gasto_mt 		numeric;
v_valor_recurso_mt 		numeric;
v_valor_gasto_mb 		numeric;
v_valor_recurso_mb 		numeric; 
v_valor_debe_ma			numeric;
v_valor_haber_ma		numeric;
v_valor_gasto_ma		numeric;
v_valor_recurso_ma		numeric;
v_monto_pago_mb			numeric;
v_reg_tc				record;
v_ajustar_tipo_cambio_cbte_rel		varchar;
v_sw_tmp 				boolean;
v_tipo_cambio_2			numeric;
v_tipo_cambio			numeric;

 

BEGIN

   v_nombre_funcion = 'conta.f_calcular_monedas_transaccion';
   
    v_id_moneda_base = param.f_get_moneda_base();
    v_id_moneda_tri  = param.f_get_moneda_triangulacion();
    v_id_moneda_act  = param.f_get_moneda_actualizacion();
   
  
   
    --1) obtener datos de la transaccion tipos de cambios y  monedas de transaccion, base y de triangulacion
    
       select 
        it.*,
        c.id_config_cambiaria,
        cc.ope_1,
        cc.ope_2,
        cc.ope_3,
        c.localidad,
        c.fecha,
        c.sw_editable,
        c.cbte_aitb,
        c.id_int_comprobante_fks,
        cue.id_cuenta,
        cue.nro_cuenta,
        it.tipo_cambio,
        it.tipo_cambio_2,
        it.tipo_cambio_3,
        c.id_moneda
       into 
        v_registros
       from conta.tint_transaccion it 
       inner join conta.tint_comprobante c on c.id_int_comprobante = it.id_int_comprobante
       inner join conta.tconfig_cambiaria cc on cc.id_config_cambiaria = c.id_config_cambiaria
       inner join conta.tcuenta cue on cue.id_cuenta = it.id_cuenta
       where it.id_int_transaccion = p_id_int_transaccion;
       
      ---------------------------------- 
      --   Si el comprobante tiene relacioanes identifica el tipo de cambio original
      --   para el caso por ejemplo de ventas y devegados donde et tipo de cambio varia 
      --   RAC 29/08/2017
      --  
      ---------------------------------
      v_sw_tmp = false;
      
      v_ajustar_tipo_cambio_cbte_rel = pxp.f_get_variable_global('conta_ajustar_tipo_cambio_cbte_rel');
      
      IF v_ajustar_tipo_cambio_cbte_rel = 'si' THEN
          
          IF v_registros.id_int_comprobante_fks is not null THEN
             
                 --verificamos si el  comprobante relacionado tiene la misma cuenta con otros tipo de cambio   
                 
                 select
                     avg(ito.tipo_cambio)   as tipo_cambio,
                     avg(ito.tipo_cambio_2)   as tipo_cambio_2,
                     avg(ito.tipo_cambio_3)   as tipo_cambio_3
                   into
                     v_reg_tc 
                 from conta.tint_transaccion ito
                 inner join conta.tint_comprobante co on co.id_int_comprobante = ito.id_int_comprobante
                 inner join conta.tcuenta cue on cue.id_cuenta = ito.id_cuenta
                 where 
                     ito.id_int_comprobante = ANY(v_registros.id_int_comprobante_fks)
                     and ito.estado_reg = 'activo'
                     and cue.nro_cuenta = v_registros.nro_cuenta
                     and  co.id_moneda = v_registros.id_moneda;
             
                 -- solo si encuentra una trasaccion equivalente en el cbte relacionado recuperamso el tipo de cambio 
                 -- de la trasaccion original, com peudne ser varias transaccion usamos el promedio aritmetico
                 IF v_reg_tc is not null THEN
                 
                       IF v_reg_tc.tipo_cambio !=   v_registros.tipo_cambio   THEN                 
                          v_tipo_cambio = v_reg_tc.tipo_cambio;
                          v_registros.tipo_cambio = v_reg_tc.tipo_cambio; --modificamos el tc del consulta original
                          v_sw_tmp  =true;
                       ELSE
                          v_tipo_cambio =v_registros.tipo_cambio_2;     
                       END IF;
                       
                       IF v_reg_tc.tipo_cambio_2 !=   v_registros.tipo_cambio_2   THEN
                          v_tipo_cambio_2 =v_reg_tc.tipo_cambio_2;
                          v_registros.tipo_cambio_2 =v_reg_tc.tipo_cambio_2;  --modificamos el tc del consulta original
                          v_sw_tmp  =true;
                       ELSE
                          v_tipo_cambio_2 =v_registros.tipo_cambio_2; 
                       END IF;
                       
                       update conta.tint_transaccion set
                          
                          tipo_cambio = v_tipo_cambio,
                          tipo_cambio_2 = v_tipo_cambio_2
                       
                        where id_int_transaccion = p_id_int_transaccion;
                       
                       
                       IF v_sw_tmp  THEN
                          update conta.tint_comprobante set
                            sw_tipo_cambio = 'si'
                          where id_int_comprobante =  v_registros.id_int_comprobante;
                       END IF;
                       
                  END IF;
             
          END IF;
      END IF; 
       
      
       
     --si no tenemos moneda  de la transaccion mostramos el error
    
     IF v_registros.importe_debe is NULL or  v_registros.importe_haber is NULL  THEN
       raise exception 'esta transaccion no tiene importe transaccional o es cero';
     END IF;
    
    -- si no tenemos  tipo de cambio lanzamos un error
      IF v_registros.tipo_cambio is NULL or v_registros.tipo_cambio_2 is NULL or v_registros.tipo_cambio_3 is NULL THEN      
        raise exception 'No tenemos tipo de cambio registrado en el comprobante';        
      END IF;
      
    
    
    --2) IF ... si la transaccion es de ajuste  no se hacen cambios (actualizacion = si)
    
    
    
     IF v_registros.actualizacion = 'no' THEN
    
    
            va_montos[1] = 0;
            va_montos[2] = 0;
            va_montos[3] = 0;
            
            -- 2.1) IF ...  si la localidad es nacional,
            
            IF v_registros.localidad = 'nacional' THEN
              
              --------------------------------------------------------------------------
              --calcula los valor  en moneda base y triangulacion segun configuracion
              ------------------------------------------------------------------------
              va_montos  = conta.f_calcular_monedas_segun_config(v_registros.id_moneda, v_id_moneda_base, v_id_moneda_tri, v_id_moneda_act, v_registros.tipo_cambio, v_registros.tipo_cambio_2,v_registros.tipo_cambio_3, v_registros.importe_debe, v_registros.id_config_cambiaria, v_registros.fecha);
              v_valor_debe_mb = va_montos[1];
              v_valor_debe_mt = va_montos[2];
              v_valor_debe_ma = va_montos[3];
              
              va_montos  = conta.f_calcular_monedas_segun_config(v_registros.id_moneda, v_id_moneda_base, v_id_moneda_tri, v_id_moneda_act, v_registros.tipo_cambio, v_registros.tipo_cambio_2,v_registros.tipo_cambio_3, v_registros.importe_haber, v_registros.id_config_cambiaria, v_registros.fecha);
              v_valor_haber_mb = va_montos[1];
              v_valor_haber_mt = va_montos[2];
              v_valor_haber_ma = va_montos[3];
              
              --calcular los mosntos presupeustarios
              
              va_montos  = conta.f_calcular_monedas_segun_config(v_registros.id_moneda, v_id_moneda_base, v_id_moneda_tri, v_id_moneda_act, v_registros.tipo_cambio, v_registros.tipo_cambio_2,v_registros.tipo_cambio_3, v_registros.importe_gasto, v_registros.id_config_cambiaria, v_registros.fecha);
              v_valor_gasto_mb = va_montos[1];
              v_valor_gasto_mt = va_montos[2];
              v_valor_gasto_ma = va_montos[3];
              
              va_montos  = conta.f_calcular_monedas_segun_config(v_registros.id_moneda, v_id_moneda_base, v_id_moneda_tri, v_id_moneda_act, v_registros.tipo_cambio, v_registros.tipo_cambio_2,v_registros.tipo_cambio_3, v_registros.importe_recurso, v_registros.id_config_cambiaria, v_registros.fecha);
              v_valor_recurso_mb = va_montos[1];
              v_valor_recurso_mt = va_montos[2];
              v_valor_recurso_ma = va_montos[3];
             
              -- modificar valores en la transaccion
    
              update conta.tint_transaccion t set
                importe_debe_mb = v_valor_debe_mb,
                importe_haber_mb = v_valor_haber_mb,                
                importe_gasto_mb = v_valor_gasto_mb,
                importe_recurso_mb = v_valor_recurso_mb,                                
                importe_debe_mt = v_valor_debe_mt,
                importe_haber_mt = v_valor_haber_mt,                
                importe_gasto_mt = v_valor_gasto_mt,
                importe_recurso_mt = v_valor_recurso_mt,                 
                importe_debe_ma = v_valor_debe_ma,
                importe_haber_ma = v_valor_haber_ma,                
                importe_gasto_ma = v_valor_gasto_ma,
                importe_recurso_ma = v_valor_recurso_ma               
              where id_int_transaccion = p_id_int_transaccion;
           
     
             -- Si es comprobante de pago, revisamos si tienen relaciones con pagos 
             -- listado de las transacciones del comprobante
             FOR v_registros_rel in (
                                      select 
                                         r.monto_pago, 
                                         r.monto_pago_mb,
                                         r.monto_pago_mt,
                                         r.monto_pago_ma,
                                         r.id_int_rel_devengado,
                                         it.id_moneda,
                                         it.id_moneda_tri,
                                         it.id_moneda_act,
                                         it.tipo_cambio,
                                         it.tipo_cambio_2,
                                         it.tipo_cambio_3
                                     from conta.tint_rel_devengado r 
                                     inner join conta.tint_transaccion it on it.id_int_transaccion = r.id_int_transaccion_pag
                                     where r.id_int_transaccion_pag = v_registros.id_int_transaccion and r.estado_reg = 'activo' ) LOOP
             
                   
             
                   va_montos  = conta.f_calcular_monedas_segun_config(v_registros_rel.id_moneda, 
                                                                      v_id_moneda_base, 
                                                                      v_id_moneda_tri,
                                                                      v_id_moneda_act, 
                                                                      v_registros_rel.tipo_cambio, 
                                                                      v_registros_rel.tipo_cambio_2,
                                                                      v_registros_rel.tipo_cambio_3, 
                                                                      v_registros_rel.monto_pago, 
                                                                      v_registros.id_config_cambiaria, 
                                                                      v_registros.fecha);
              
                   
                   update conta.tint_rel_devengado r set
                     monto_pago_mb =  va_montos[1],
                     monto_pago_mt =  va_montos[2],
                     monto_pago_ma =  va_montos[3]
                   where r.id_int_rel_devengado = v_registros_rel.id_int_rel_devengado;
                     
                
             END LOOP;
           
           
           ELSE
             --  2.3) ELSE...  si es internacional
             --   si es extranjero triangulamos la moneda base
             
               
             --  OJO OJO OJO OJO OJO OJO
             --  OJO RAC 11/07/2017 no estoy seguro si el tipo de cambio que entra en esta funcion es correcto
               
              --si es un comprobante con edición habilitada (calculamos moenda de triangulacion)
              IF v_registros.sw_editable = 'si' THEN
                   
                   v_valor_debe_mt =  param.f_convertir_moneda (v_registros.id_moneda, v_id_moneda_tri,   v_registros.importe_debe, v_registros.fecha,'CUS',50, v_registros.tipo_cambio, 'no');
                   v_valor_haber_mt =  param.f_convertir_moneda (v_registros.id_moneda, v_id_moneda_tri,   v_registros.importe_haber, v_registros.fecha,'CUS',50, v_registros.tipo_cambio, 'no');
                   v_valor_gasto_mt =  param.f_convertir_moneda (v_registros.id_moneda, v_id_moneda_tri,   v_registros.importe_gasto, v_registros.fecha,'CUS',50, v_registros.tipo_cambio, 'no');
                   v_valor_recurso_mt =  param.f_convertir_moneda(v_registros.id_moneda, v_id_moneda_tri,   v_registros.importe_recurso, v_registros.fecha,'CUS',50, v_registros.tipo_cambio, 'no');
                   
                   v_registros.importe_debe_mt = v_valor_debe_mt;
                   v_registros.importe_haber_mt = v_valor_haber_mt;
                   v_registros.importe_gasto_mt = v_valor_gasto_mt;
                   v_registros.importe_recurso_mt = v_valor_recurso_mt;
                   
                   
                   --modificamos transaccion 
                   update conta.tint_transaccion t set
                    importe_debe_mt = v_valor_debe_mt,
                    importe_haber_mt = v_valor_haber_mt,
                    importe_gasto_mt = v_valor_gasto_mt,
                    importe_recurso_mt = v_valor_recurso_mt
                   where id_int_transaccion = p_id_int_transaccion;
              
              END IF;
               
              --  si no tenemos moneda de triangulacion msotramor el error
              IF   v_registros.importe_debe_mt is null and v_registros.importe_haber_mt is null  THEN
                raise exception 'No tenemos moneda de triangulacion,  para la triangulación es obligatorio para transacciones internacionales';
              END IF; 
           
             
           
               v_valor_debe_mb =   param.f_convertir_moneda (v_id_moneda_tri, v_id_moneda_base,    v_registros.importe_debe_mt,  v_registros.fecha, 'CUS',50, v_registros.tipo_cambio_2, 'no');
               v_valor_haber_mb =  param.f_convertir_moneda (v_id_moneda_tri, v_id_moneda_base,    v_registros.importe_haber_mt, v_registros.fecha, 'CUS',50, v_registros.tipo_cambio_2, 'no');
               v_valor_gasto_mb =   param.f_convertir_moneda (v_id_moneda_tri, v_id_moneda_base,    v_registros.importe_gasto_mt,  v_registros.fecha, 'CUS',50, v_registros.tipo_cambio_2, 'no');
               v_valor_recurso_mb =  param.f_convertir_moneda (v_id_moneda_tri, v_id_moneda_base,    v_registros.importe_recurso_mt, v_registros.fecha, 'CUS',50, v_registros.tipo_cambio_2, 'no');
               
               v_valor_debe_ma =   param.f_convertir_moneda (v_id_moneda_base, v_id_moneda_act,   v_valor_debe_mb,  v_registros.fecha, 'CUS',50, v_registros.tipo_cambio_3, 'no');
               v_valor_haber_ma =  param.f_convertir_moneda (v_id_moneda_base, v_id_moneda_act,    v_valor_haber_mb, v_registros.fecha, 'CUS',50, v_registros.tipo_cambio_3, 'no');
               v_valor_gasto_ma =   param.f_convertir_moneda (v_id_moneda_base, v_id_moneda_act,    v_valor_gasto_mb,  v_registros.fecha, 'CUS',50, v_registros.tipo_cambio_3, 'no');
               v_valor_recurso_ma =  param.f_convertir_moneda (v_id_moneda_base, v_id_moneda_act,    v_valor_recurso_mb, v_registros.fecha, 'CUS',50, v_registros.tipo_cambio_3, 'no');
                   
               
               
              -- modificar valores en la transaccion
    
              update conta.tint_transaccion t set
                importe_debe_mb = v_valor_debe_mb,
                importe_haber_mb = v_valor_haber_mb,
                importe_gasto_mb = v_valor_gasto_mb,
                importe_recurso_mb = v_valor_recurso_mb,
                importe_debe_ma = v_valor_debe_ma,
                importe_haber_ma = v_valor_haber_ma,
                importe_gasto_ma = v_valor_gasto_ma,
                importe_recurso_ma = v_valor_recurso_ma
              where id_int_transaccion = p_id_int_transaccion;
              
              
              -- Si es comprobante de pago, revisamos si tienen relaciones con pagos 
              -- listado de las transacciones del comprobante
              FOR v_registros_rel in (
                                      select 
                                         r.monto_pago, 
                                         r.monto_pago_mb,
                                         r.monto_pago_mt,
                                         r.monto_pago_ma,
                                         r.id_int_rel_devengado,
                                         it.id_moneda,
                                         it.id_moneda_tri,
                                         it.id_moneda_act,
                                         it.tipo_cambio,
                                         it.tipo_cambio_2,
                                         it.tipo_cambio_3
                                     from conta.tint_rel_devengado r 
                                     inner join conta.tint_transaccion it on it.id_int_transaccion = r.id_int_transaccion_pag
                                     where r.id_int_transaccion_pag = v_registros.id_int_transaccion and r.estado_reg = 'activo' ) LOOP
             
                   
                    IF v_registros_rel.monto_pago_mt is null  THEN                 
                       raise exception 'no existe valor  para la moneda de triangulacion en la relacion devengado pago';
                    END IF;
                   
                    v_monto_pago_mb  =   param.f_convertir_moneda (v_id_moneda_tri, 
                                                                  v_id_moneda_base,    
                                                                  v_registros_rel.monto_pago_mt,  
                                                                  v_registros.fecha, 'CUS',50, v_registros.tipo_cambio_2, 'no');
                   
                    update conta.tint_rel_devengado r set
                     monto_pago_mb  =   v_monto_pago_mb,
                     monto_pago_ma  =   param.f_convertir_moneda (v_id_moneda_base, 
                                                                  v_id_moneda_act,    
                                                                  v_monto_pago_mb,  
                                                                  v_registros.fecha, 'CUS',50, v_registros.tipo_cambio_3, 'no')
                    where r.id_int_rel_devengado = v_registros_rel.id_int_rel_devengado;
                    
                  
                     
                
             END LOOP;
           END IF;
     ELSE
     
       --si es un comprobante de AITB
       IF  v_registros.cbte_aitb  ='si' THEN
       
         ---  si es un comrpobane de aitb solo tendra importe en moenda base
         --   y no es encesario actulizar ninguno otra moneda  ni de triangulacion ni de actualizacion
       
       
       ELSE
         
          --las transacciones que son actualizacion y no son de cbte de aitb
          --son trasacciones que igual el cbte,  para que se mantega equilibrado en moneda baso o moneda de triagulacion
          
          
       
         -- si no es un comprobant ede AITB
         -- registramos moneda de actualizacion en funcion a la moneda base
         v_valor_debe_ma =   param.f_convertir_moneda (v_id_moneda_base, v_id_moneda_act,   v_registros.importe_debe_mb,  v_registros.fecha, 'CUS',50, v_registros.tipo_cambio_3, 'no');
         v_valor_haber_ma =  param.f_convertir_moneda (v_id_moneda_base, v_id_moneda_act,    v_registros.importe_haber_mb, v_registros.fecha, 'CUS',50, v_registros.tipo_cambio_3, 'no');
         v_valor_gasto_ma =   param.f_convertir_moneda (v_id_moneda_base, v_id_moneda_act,    v_registros.importe_gasto_mb,  v_registros.fecha, 'CUS',50, v_registros.tipo_cambio_3, 'no');
         v_valor_recurso_ma =  param.f_convertir_moneda (v_id_moneda_base, v_id_moneda_act,    v_registros.importe_recurso_mb, v_registros.fecha, 'CUS',50, v_registros.tipo_cambio_3, 'no');
         
         update conta.tint_transaccion t set
                importe_debe_ma = v_valor_debe_ma,
                importe_haber_ma = v_valor_haber_ma,
                importe_gasto_ma = v_valor_gasto_ma,
                importe_recurso_ma = v_valor_recurso_ma
         where id_int_transaccion = p_id_int_transaccion;
       
       
       END IF;
     
     
     END IF; -- IF actualizacion
         

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