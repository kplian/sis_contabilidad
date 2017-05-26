--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_gen_inser_rel_devengado (
  p_id_usuario integer,
  p_id_trans_dev integer,
  p_id_trans_pag integer,
  p_monto numeric,
  p_id_int_comprobante integer
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.f_gen_inser_rel_devengado
 DESCRIPCION:   Funcion que inserta transacciones a partir de un hstore
 AUTOR: 		 RAC
 FECHA:	        04-09-2013 03:51:00
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_transaccion	    integer;
    
    v_importe_mb 			numeric;
    
    v_registros 			record;
    v_registros_con 		record;
    v_id_moneda_base		integer;
    
    
    v_importe_debe_mb  		numeric;
    v_importe_haber_mb 		numeric;
    v_importe_recurso_mb 	numeric;
    v_importe_gasto_mb		numeric;
  
			    
BEGIN

       v_nombre_funcion = 'conta.f_gen_inser_rel_devengado';
        
       
           select 
            c.fecha,
            c.tipo_cambio,
            c.id_moneda
          into
           v_registros_con
          from conta.tint_comprobante  c
          where c.id_int_comprobante = p_id_int_comprobante;
          
         
       ----------------------------
       --CALCULA LA MONEDA BASE 
       ---------------------------
          -- Obtener la moneda base
          v_id_moneda_base = param.f_get_moneda_base();
          v_importe_mb  =  p_monto;
       
          
          -- si la moneda es distinto de la moneda base, calculamos segun tipo de cambio
          IF v_id_moneda_base != v_registros_con.id_moneda  THEN
             
               IF  v_registros_con.tipo_cambio is not  NULL THEN
                 --si es la moenda base   base utilizamos el tipo de cambio del comprobante, ...solicitamos C  (CUSTOM)
                 v_importe_mb  = param.f_convertir_moneda (v_registros_con.id_moneda, v_id_moneda_base, v_importe_mb, v_registros_con.fecha,'CUS',2, v_registros_con.tipo_cambio);
                           
              ELSE
                 --si no tenemso tipo de cambio convenido .....
                 v_importe_mb  = param.f_convertir_moneda (v_registros_con.id_moneda, v_id_moneda_base, v_importe_mb, v_registros_con.fecha,'O',2);
              END IF;
           
          END IF;
          
        --inserta trasaccion
        
        INSERT INTO conta.tint_rel_devengado
            (
              id_usuario_reg,
              fecha_reg,
              estado_reg,
              id_int_transaccion_dev,
              id_int_transaccion_pag,
              monto_pago,
              monto_pago_mb
            ) 
            VALUES (
              p_id_usuario,
              now(),
              'activo',
              p_id_trans_dev,
              p_id_trans_pag,
              p_monto,
              v_importe_mb
            );
			
     RETURN TRUE;

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