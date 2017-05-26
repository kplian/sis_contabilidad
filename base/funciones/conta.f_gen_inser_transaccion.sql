--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_gen_inser_transaccion (
  p_hstore_transaccion public.hstore,
  p_id_usuario integer
)
RETURNS integer AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.f_gen_inser_transaccion
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
    
    v_importe_debe 			numeric;
    v_importe_haber 		numeric;
    v_importe_recurso 		numeric;
    v_importe_gasto 		numeric;
    v_registros 			record;
    v_registros_con 		record;
    v_id_moneda_base		integer;
    
    
    v_importe_debe_mb  		numeric;
    v_importe_haber_mb 		numeric;
    v_importe_recurso_mb 	numeric;
    v_importe_gasto_mb		numeric;
  
			    
BEGIN

       v_nombre_funcion = 'conta.f_gen_inser_transaccion';
        
      
          
         
       ----------------------------
       --CALCULA LA MONEDA BASE 
       ---------------------------
          
          
          
          --pordefecto solo copiamos
          v_importe_debe  =  (p_hstore_transaccion->'importe_debe')::numeric;
          v_importe_haber 	= (p_hstore_transaccion->'importe_haber')::numeric;
          v_importe_recurso = (p_hstore_transaccion->'importe_recurso')::numeric;
          v_importe_gasto	= (p_hstore_transaccion->'importe_gasto')::numeric;
          
         
       
       --inserta trasaccion
        INSERT INTO 
          conta.tint_transaccion
        (
          id_usuario_reg,
          fecha_reg,
          estado_reg,
          id_int_comprobante,
          id_cuenta,
          id_auxiliar,
          id_centro_costo,
          id_partida,
          id_partida_ejecucion,
          id_int_transaccion_fk,
          glosa,
          importe_debe,
          importe_haber,
          importe_recurso,
          importe_gasto,
          
          id_detalle_plantilla_comprobante,
          importe_reversion,
          factor_reversion,
          id_cuenta_bancaria, 
          id_cuenta_bancaria_mov, 
          nro_cheque, 
          nro_cuenta_bancaria_trans, 
          porc_monto_excento_var,
          nombre_cheque_trans,
          id_orden_trabajo,
          forma_pago,
          id_suborden
         ) 
        VALUES (
          (p_hstore_transaccion->'id_usuario_reg')::integer,
          now(),
          'activo',
          (p_hstore_transaccion->'id_int_comprobante')::integer,
          (p_hstore_transaccion->'id_cuenta')::integer,
          (p_hstore_transaccion->'id_auxiliar')::integer,
          (p_hstore_transaccion->'id_centro_costo')::integer,
          (p_hstore_transaccion->'id_partida')::integer,
          (p_hstore_transaccion->'id_partida_ejecucion')::integer,
          (p_hstore_transaccion->'id_int_transaccion_fk')::integer,
          (p_hstore_transaccion->'glosa')::varchar,
          v_importe_debe,
          v_importe_haber,
          v_importe_recurso,
          v_importe_gasto,
         
          (p_hstore_transaccion->'id_detalle_plantilla_comprobante')::integer,
          COALESCE((p_hstore_transaccion->'importe_reversion')::numeric,0),
          COALESCE((p_hstore_transaccion->'factor_reversion')::numeric,0),
          (p_hstore_transaccion->'id_cuenta_bancaria')::integer,
          (p_hstore_transaccion->'id_cuenta_bancaria_mov')::integer,
          (p_hstore_transaccion->'nro_cheque')::integer,
          (p_hstore_transaccion->'nro_cuenta_bancaria_trans')::varchar,
          COALESCE((p_hstore_transaccion->'porc_monto_excento_var')::numeric,0),
          (p_hstore_transaccion->'nombre_cheque_trans')::varchar,
          (p_hstore_transaccion->'id_orden_trabajo')::integer,
          (p_hstore_transaccion->'forma_pago')::varchar,
          (p_hstore_transaccion->'id_suborden')::integer
          
          
        ) RETURNING id_int_transaccion into v_id_transaccion;
			
        
			
      --Devuelve la respuesta
      return v_id_transaccion;

	
	

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