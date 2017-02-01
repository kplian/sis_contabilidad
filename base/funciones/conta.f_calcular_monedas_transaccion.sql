--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_calcular_monedas_transaccion (
  p_id_int_transaccion integer
)
RETURNS void AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_config_cambiaria_ime
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

 

BEGIN

   v_nombre_funcion = 'conta.f_calcular_monedas_transaccion';
   
    v_id_moneda_base = param.f_get_moneda_base();
    v_id_moneda_tri  = param.f_get_moneda_triangulacion();
   
  
   
    --1) obtener datos de la transaccion tipos de cambios y  monedas de transaccion, base y de triangulacion
    
       select 
        it.*,
        c.id_config_cambiaria,
        cc.ope_1,
        cc.ope_2,
        c.localidad,
        c.fecha,
        c.sw_editable
       into 
        v_registros
       from conta.tint_transaccion it 
       inner join conta.tint_comprobante c on c.id_int_comprobante = it.id_int_comprobante
       inner join conta.tconfig_cambiaria cc on cc.id_config_cambiaria = c.id_config_cambiaria
       where it.id_int_transaccion = p_id_int_transaccion;
       
      
       
     --si no tenemos moneda  de la transaccion mostramos el error
    
     IF v_registros.importe_debe is NULL or  v_registros.importe_haber is NULL  THEN
       raise exception 'esta transaccion no tiene importe transaccional o es cero';
     END IF;
    
    -- si no tenemos  tipo de cambio lanzamos un error
      IF v_registros.tipo_cambio is NULL or v_registros.tipo_cambio_2 is NULL THEN      
        raise exception 'No tenemos tipo de cambio registrado en el comprobante';        
      END IF;
    
    --2) IF ... si la transaccion es de ajuste  no se hacen cambios (actualizacion = si)
    
    
    
     IF v_registros.actualizacion = 'no' THEN
    
    
            va_montos[1] = 0;
            va_montos[2] = 0;
            
            -- 2.1) IF ...  si la localidad es nacional,
            
            IF v_registros.localidad = 'nacional' THEN
              
              --------------------------------------------------------------------------
              --calcula los valor  en moneda base y triangulacion segun configuracion
              ------------------------------------------------------------------------
              va_montos  = conta.f_calcular_monedas_segun_config(v_registros.id_moneda, v_id_moneda_base, v_id_moneda_tri, v_registros.tipo_cambio, v_registros.tipo_cambio_2, v_registros.importe_debe, v_registros.id_config_cambiaria, v_registros.fecha);
              v_valor_debe_mb = va_montos[1];
              v_valor_debe_mt = va_montos[2];
              
              va_montos  = conta.f_calcular_monedas_segun_config(v_registros.id_moneda, v_id_moneda_base, v_id_moneda_tri, v_registros.tipo_cambio, v_registros.tipo_cambio_2, v_registros.importe_haber, v_registros.id_config_cambiaria, v_registros.fecha);
              v_valor_haber_mb = va_montos[1];
              v_valor_haber_mt = va_montos[2];
              
              --calcular los mosntos presupeustarios
              
              va_montos  = conta.f_calcular_monedas_segun_config(v_registros.id_moneda, v_id_moneda_base, v_id_moneda_tri, v_registros.tipo_cambio, v_registros.tipo_cambio_2, v_registros.importe_gasto, v_registros.id_config_cambiaria, v_registros.fecha);
              v_valor_gasto_mb = va_montos[1];
              v_valor_gasto_mt = va_montos[2];
              
              va_montos  = conta.f_calcular_monedas_segun_config(v_registros.id_moneda, v_id_moneda_base, v_id_moneda_tri, v_registros.tipo_cambio, v_registros.tipo_cambio_2, v_registros.importe_recurso, v_registros.id_config_cambiaria, v_registros.fecha);
              v_valor_recurso_mb = va_montos[1];
              v_valor_recurso_mt = va_montos[2];
             
              -- modificar valores en la transaccion
    
              update conta.tint_transaccion t set
                importe_debe_mb = v_valor_debe_mb,
                importe_haber_mb = v_valor_haber_mb,                
                importe_gasto_mb = v_valor_gasto_mb,
                importe_recurso_mb = v_valor_recurso_mb,                
                importe_debe_mt = v_valor_debe_mt,
                importe_haber_mt = v_valor_haber_mt,                
                importe_gasto_mt = v_valor_gasto_mt,
                importe_recurso_mt = v_valor_recurso_mt                
              where id_int_transaccion = p_id_int_transaccion;
           
     
             -- Si es comprobante de pago, revisamos si tienen relaciones con pagos 
             -- listado de las transacciones del comprobante
             FOR v_registros_rel in (
                                      select 
                                         r.monto_pago, 
                                         r.monto_pago_mb,
                                         r.monto_pago_mt,
                                         r.id_int_rel_devengado,
                                         it.id_moneda,
                                         it.id_moneda_tri,
                                         it.tipo_cambio,
                                         it.tipo_cambio_2
                                     from conta.tint_rel_devengado r 
                                     inner join conta.tint_transaccion it on it.id_int_transaccion = r.id_int_transaccion_pag
                                     where r.id_int_transaccion_pag = v_registros.id_int_transaccion and r.estado_reg = 'activo' ) LOOP
             
                   
             
                   va_montos  = conta.f_calcular_monedas_segun_config(v_registros_rel.id_moneda, 
                                                                      v_id_moneda_base, 
                                                                      v_id_moneda_tri, 
                                                                      v_registros_rel.tipo_cambio, 
                                                                      v_registros_rel.tipo_cambio_2, 
                                                                      v_registros_rel.monto_pago, 
                                                                      v_registros.id_config_cambiaria, 
                                                                      v_registros.fecha);
              
                   
                   update conta.tint_rel_devengado r set
                     monto_pago_mb =  va_montos[1],
                     monto_pago_mt =  va_montos[2]
                   where r.id_int_rel_devengado = v_registros_rel.id_int_rel_devengado;
                     
                
             END LOOP;
           
           
           ELSE
             --  2.3) ELSE...  si es internacional
             --   si es extranjera triangulamos la moneda base  
               
              --si es un comprobante con edición habilitada (calculamos moenda de triangulacion)
              IF v_registros.sw_editable = 'si' THEN
                   
                   v_valor_debe_mt =  param.f_convertir_moneda (v_registros.id_moneda, v_id_moneda_tri,   v_registros.importe_debe, v_registros.fecha,'CUS',50, v_registros.tipo_cambio, 'no');
                   v_valor_haber_mt =  param.f_convertir_moneda (v_registros.id_moneda, v_id_moneda_tri,   v_registros.importe_haber, v_registros.fecha,'CUS',50, v_registros.tipo_cambio, 'no');
                   
                   v_registros.importe_debe_mt = v_valor_debe_mt;
                   v_registros.importe_haber_mt = v_valor_haber_mt;
                   
                   v_valor_gasto_mt =  param.f_convertir_moneda (v_registros.id_moneda, v_id_moneda_tri,   v_registros.importe_gasto, v_registros.fecha,'CUS',50, v_registros.tipo_cambio, 'no');
                   v_valor_recurso_mt =  param.f_convertir_moneda(v_registros.id_moneda, v_id_moneda_tri,   v_registros.importe_recurso, v_registros.fecha,'CUS',50, v_registros.tipo_cambio, 'no');
                   
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
                raise exception 'No tenemos moneda de triangulacion para la triangulación, es obligatorio para transacciones internacionales';
              END IF; 
           
             
           
               v_valor_debe_mb =   param.f_convertir_moneda (v_id_moneda_tri, v_id_moneda_base,    v_registros.importe_debe_mt,  v_registros.fecha, 'CUS',50, v_registros.tipo_cambio_2, 'no');
               v_valor_haber_mb =  param.f_convertir_moneda (v_id_moneda_tri, v_id_moneda_base,    v_registros.importe_haber_mt, v_registros.fecha, 'CUS',50, v_registros.tipo_cambio_2, 'no');
               
               v_valor_gasto_mb =   param.f_convertir_moneda (v_id_moneda_tri, v_id_moneda_base,    v_registros.importe_gasto_mt,  v_registros.fecha, 'CUS',50, v_registros.tipo_cambio_2, 'no');
               v_valor_recurso_mb =  param.f_convertir_moneda (v_id_moneda_tri, v_id_moneda_base,    v_registros.importe_recurso_mt, v_registros.fecha, 'CUS',50, v_registros.tipo_cambio_2, 'no');
                 
               
               
              -- modificar valores en la transaccion
    
              update conta.tint_transaccion t set
                importe_debe_mb = v_valor_debe_mb,
                importe_haber_mb = v_valor_haber_mb,
                importe_gasto_mb = v_valor_gasto_mb,
                importe_recurso_mb = v_valor_recurso_mb
              where id_int_transaccion = p_id_int_transaccion;
              
              
              -- Si es comprobante de pago, revisamos si tienen relaciones con pagos 
              -- listado de las transacciones del comprobante
              FOR v_registros_rel in (
                                      select 
                                         r.monto_pago, 
                                         r.monto_pago_mb,
                                         r.monto_pago_mt,
                                         r.id_int_rel_devengado,
                                         it.id_moneda,
                                         it.id_moneda_tri,
                                         it.tipo_cambio,
                                         it.tipo_cambio_2
                                     from conta.tint_rel_devengado r 
                                     inner join conta.tint_transaccion it on it.id_int_transaccion = r.id_int_transaccion_pag
                                     where r.id_int_transaccion_pag = v_registros.id_int_transaccion and r.estado_reg = 'activo' ) LOOP
             
                   
                    IF v_registros_rel.monto_pago_mt is null  THEN                 
                       raise exception 'no existe valor  para la moneda de triangulacion en la relacion devengado pago';
                    END IF;
                   
                   update conta.tint_rel_devengado r set
                     monto_pago_mb  =   param.f_convertir_moneda (v_id_moneda_tri, 
                                                                  v_id_moneda_base,    
                                                                  v_registros_rel.monto_pago_mt,  
                                                                  v_registros.fecha, 'CUS',50, v_registros.tipo_cambio_2, 'no')
                  where r.id_int_rel_devengado = v_registros_rel.id_int_rel_devengado;
                     
                
             END LOOP;
           
           
           END IF;
       
      
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
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;