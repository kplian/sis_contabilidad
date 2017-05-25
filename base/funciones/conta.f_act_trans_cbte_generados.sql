--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_act_trans_cbte_generados (
  p_id_int_comprobante integer,
  p_estacion varchar = 'Local'::character varying
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_config_cambiaria_ime
 DESCRIPCION:   en funcion a los codigos de las moendas regresa el tipo de cambio correspondiente
                la conversion se ha pasando por moneda base, si no encuentra regresa NULL
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


v_nombre_funcion		varchar;
v_resp					varchar;


v_id_moneda_base		integer;
v_id_moneda_tri			integer;
v_registros_cbte		record;
v_registros_config		record;
v_registros				record;
v_registros_rel 		record;
v_tipo_cambio 			numeric;
v_total_monto_pago		numeric;
v_tipo_cambio_rel_1 	numeric;
v_tipo_cambio_rel_2		numeric;
v_glosa_tran 			varchar;
v_sw_tipo_cambio 		varchar;
v_parcial 				numeric;
v_glosa 				varchar;


 

BEGIN

   v_nombre_funcion = 'conta.f_act_trans_cbte_generados';
   
   select 
     *
   INTO
     v_registros_cbte
   FROM conta.tint_comprobante cbte
   where cbte.id_int_comprobante = p_id_int_comprobante;
    
    -------------------------------------------------------
    --recupera configuracion activa, y tipos de cambio
    ------------------------------------------------------
         
   -- raise exception 'localidad %',  v_registros_cbte.localidad;
    
         SELECT  
           po_id_config_cambiaria ,
           po_valor_tc1 ,
           po_valor_tc2 ,
           po_tc1 ,
           po_tc2 
         into
          v_registros_config
         FROM conta.f_get_tipo_cambio_segu_config(v_registros_cbte.id_moneda, 
                                                  v_registros_cbte.fecha,
                                                  v_registros_cbte.localidad,
                                                  'si');
               
    
        v_id_moneda_base = param.f_get_moneda_base();
        v_id_moneda_tri  = param.f_get_moneda_triangulacion();
     
   
       v_tipo_cambio = v_registros_cbte.tipo_cambio;
     
       IF v_tipo_cambio is NULL THEN
         v_tipo_cambio = v_registros_config.po_valor_tc1;
       END IF;
       
       IF  v_tipo_cambio is NULL THEN
         raise exception 'no tenemos tipo de cambio % para la fecha % en la estación %',v_registros_config.po_tc1 , v_registros_cbte.fecha, p_estacion;
       END IF;
       
       
       IF  v_registros_config.po_valor_tc2 is NULL THEN
         raise exception 'no tenemos tipo de cambio % para la fecha % en la estación %',v_registros_config.po_tc2 , v_registros_cbte.fecha, p_estacion;
       END IF;
       
       
       update conta.tint_comprobante cbt set
         tipo_cambio = v_tipo_cambio,
         tipo_cambio_2 = v_registros_config.po_valor_tc2,
         id_moneda_tri = v_id_moneda_tri,
         id_config_cambiaria = v_registros_config.po_id_config_cambiaria
       where cbt.id_int_comprobante = p_id_int_comprobante;
      
      
       
       
       FOR  v_registros in (
                           select 
                             * 
                           from conta.tint_transaccion it
                           where it.id_int_comprobante = p_id_int_comprobante)LOOP
      
                    
       
          --  si tiene relacion con un devengado calcular tipo de cambio ponderado para la trasacción
           select 
               sum(r.monto_pago)
           into
              v_total_monto_pago
           from conta.tint_rel_devengado r 
           inner join conta.tint_transaccion it on it.id_int_transaccion = r.id_int_transaccion_dev and it.estado_reg = 'activo'
           where r.id_int_transaccion_pag = v_registros.id_int_transaccion and r.estado_reg = 'activo';
           
           
         v_total_monto_pago = 0;
         v_tipo_cambio_rel_1 = 0;
         v_tipo_cambio_rel_2 = 0;
         v_glosa_tran = '';
        
         v_sw_tipo_cambio = 'no';                          
          
            IF v_total_monto_pago > 0  THEN
            
                  v_glosa_tran = 'TC: ';
                  FOR v_registros_rel in (
                                              select 
                                                 it.tipo_cambio,
                                                  it.tipo_cambio_2,
                                                  r.monto_pago,
                                                  cb.id_int_comprobante,
                                                  cb.nro_cbte
                                             from conta.tint_rel_devengado r 
                                             inner join conta.tint_transaccion it on it.id_int_transaccion = r.id_int_transaccion_dev and it.estado_reg = 'activo'
                                             inner join conta.tint_comprobante cb on cb.id_int_comprobante = it.id_int_comprobante
                                             where r.id_int_transaccion_pag = v_registros.id_int_transaccion and r.estado_reg = 'activo' ) LOOP
                  
                  
                   
                   v_parcial = (v_registros_rel.monto_pago/v_total_monto_pago)*v_registros_rel.tipo_cambio;
                   v_tipo_cambio_rel_1 = v_tipo_cambio_rel_1 + v_parcial;
                   
                   
                   v_parcial = (v_registros_rel.monto_pago/v_total_monto_pago)*v_registros_rel.tipo_cambio_2;
                   v_tipo_cambio_rel_2 = v_tipo_cambio_rel_2 + v_parcial;	
                   
                   v_glosa_tran =  v_glosa_tran|| '('||v_registros_rel.nro_cbte||'  '||v_registros_config.po_tc1 ||':'||v_registros_rel.tipo_cambio::varchar;
                   v_glosa_tran =  v_glosa_tran||' '||v_registros_config.po_tc2 ||':'||v_registros_rel.tipo_cambio::varchar||')';
                     
                  END  LOOP;
                
                  IF v_tipo_cambio_rel_1 != v_tipo_cambio  or   v_tipo_cambio_rel_2 != v_registros_config.po_valor_tc2 THEN
                    v_sw_tipo_cambio = 'si';
                  END IF;
            ELSE
            
                  -- si no toma los valores de tipos de la cabecera
                  v_tipo_cambio_rel_1 = v_tipo_cambio;
                  v_tipo_cambio_rel_2 = v_registros_config.po_valor_tc2;
                
            
            END IF;
          -- determina tipos de cambio en las transacciones (incluidas las que tienen dependecia en devengado pago)
          
        
        
           
           update conta.tint_transaccion t set
             tipo_cambio =   v_tipo_cambio_rel_1,
             tipo_cambio_2 = v_tipo_cambio_rel_2,
             id_moneda_tri = v_id_moneda_tri,
             id_moneda =  v_registros_cbte.id_moneda::integer,
             glosa = trim(glosa ||' '||v_glosa_tran),
             importe_debe = COALESCE(importe_debe,0),
             importe_haber = COALESCE(importe_haber,0)
          where t.id_int_transaccion = v_registros.id_int_transaccion;
          
          -- calcular  equivalencias para todas las trasacciones en moneda base y de triangulacion
          
           PERFORM  conta.f_calcular_monedas_transaccion(v_registros.id_int_transaccion);
      
      END LOOP;
      
      -- si el tipo de cambio de alguna transaccion varia con respecto a la cabacera la marcamos
      IF v_sw_tipo_cambio = 'si' THEN
         update conta.tint_comprobante cbt set
           cbt.sw_tipo_cambio = 'si'
         where cbt.id_int_comprobante = p_id_int_comprobante;
      END IF;
  
  
   
    return true;


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