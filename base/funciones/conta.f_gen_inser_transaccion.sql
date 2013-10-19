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
	v_id_transaccion	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.f_gen_inser_transaccion';
  
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
          importe_debe_mb,
          importe_haber_mb,
          importe_recurso_mb,
          importe_gasto_mb,
          id_detalle_plantilla_comprobante,
          importe_reversion,
          factor_reversion
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
          (p_hstore_transaccion->'importe_debe')::numeric,
          (p_hstore_transaccion->'importe_haber')::numeric,
          (p_hstore_transaccion->'importe_recurso')::numeric,
          (p_hstore_transaccion->'importe_gasto')::numeric,
          (p_hstore_transaccion->'importe_debe_mb')::numeric,
          (p_hstore_transaccion->'importe_haber_mb')::numeric,
          (p_hstore_transaccion->'importe_recurso_mb')::numeric,
          (p_hstore_transaccion->'importe_gasto_mb')::numeric,
          (p_hstore_transaccion->'id_detalle_plantilla_comprobante')::integer,
          COALESCE((p_hstore_transaccion->'importe_reversion')::numeric,0),
          COALESCE((p_hstore_transaccion->'factor_reversion')::numeric,0)
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