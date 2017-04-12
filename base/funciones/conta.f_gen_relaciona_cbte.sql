--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_gen_relaciona_cbte (
  p_id_int_transaccion_dev integer,
  p_id_int_transaccion_pag integer
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.f_gen_relaciona_cbte
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

	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
    v_registros_pag			record;
    v_registros_dev			record;
    v_id_tipo_relacion_comprobante  integer;
	
  
			    
BEGIN

       v_nombre_funcion = 'conta.f_gen_relaciona_cbte';
        
       -- identidicar el cbte del pago
       select 
         c.id_int_comprobante_fks,
         c.id_int_comprobante
       into
         v_registros_pag
       from conta.tint_comprobante c
       inner join conta.tint_transaccion t on t.id_int_comprobante = c.id_int_comprobante
       where t.id_int_transaccion = p_id_int_transaccion_pag;
       
       
       --identifica cbte de devengado
       select 
          c.id_int_comprobante
       into 
         v_registros_dev
       from conta.tint_comprobante c
       inner join conta.tint_transaccion t on t.id_int_comprobante = c.id_int_comprobante
       where t.id_int_transaccion = p_id_int_transaccion_dev;
       
       
       select 
        trc.id_tipo_relacion_comprobante
       into
        v_id_tipo_relacion_comprobante
       from conta.ttipo_relacion_comprobante trc
       where trc.codigo = 'PAGODEV';
       
       IF v_id_tipo_relacion_comprobante is NULL THEN
       		raise exception 'No se encontro el tipo de relacion contable PAGODEV';
       END IF;
       
       --verificar si el cbte de devengado ya es parte del array
       IF v_registros_dev.id_int_comprobante = ANY(v_registros_pag.id_int_comprobante_fks)  THEN
           raise notice 'ya existe la relacion';
       ELSE
       
           update conta.tint_comprobante c set 
             id_int_comprobante_fks = array_append(id_int_comprobante_fks, v_registros_dev.id_int_comprobante),
             id_tipo_relacion_comprobante = v_id_tipo_relacion_comprobante
           where id_int_comprobante = v_registros_pag.id_int_comprobante;
        
       END IF; 
       
	  return TRUE;

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