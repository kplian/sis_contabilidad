CREATE OR REPLACE FUNCTION conta.f_inserta_relacion_contable (
  p_hstore_transaccion public.hstore,
  p_id_usuario integer
)
RETURNS varchar [] AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.f_inserta_relacion_contable
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
	v_id_relacion_contable	    integer;
    v_retorno				varchar[];
			    
BEGIN

       v_nombre_funcion = 'conta.f_inserta_relacion_contable';
  

      INSERT INTO 	conta.trelacion_contable
          (
            id_usuario_reg,           
            fecha_reg,           
            estado_reg,      
            id_tipo_relacion_contable,
            id_centro_costo,
            id_cuenta,
            id_auxiliar,
            id_partida,
            id_gestion,
            id_tabla,
            defecto
          )
          VALUES (
             p_id_usuario,          
             now(),            
            'activo',    
            (p_hstore_transaccion->'id_tipo_relacion_contable')::integer,
            (p_hstore_transaccion->'id_centro_costo')::integer,
            (p_hstore_transaccion->'id_cuenta')::integer,
            (p_hstore_transaccion->'id_auxiliar')::integer,
            (p_hstore_transaccion->'id_partida')::integer,
            (p_hstore_transaccion->'id_gestion')::integer,
            (p_hstore_transaccion->'id_tabla')::integer,
            (p_hstore_transaccion->'defecto')::varchar
          )  RETURNING id_relacion_contable into v_id_relacion_contable;
			
		   v_retorno[1] = 'exito';
           v_retorno[2] = v_id_relacion_contable::varchar;
          
            --Devuelve la respuesta
            return v_retorno;

	
	

EXCEPTION
				
	WHEN OTHERS THEN
		
        
        v_retorno[1] = 'falla';
        v_retorno[2] = SQLERRM::varchar;
        v_retorno[3] =  v_nombre_funcion;
          
        --Devuelve la respuesta
        return v_retorno;
				        
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;