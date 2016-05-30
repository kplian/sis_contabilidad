CREATE OR REPLACE FUNCTION conta.f_get_id_int_comprobante_dev (
  p_id_int_comprobante_pago integer
)
RETURNS integer AS
$body$
/**************************************************************************
 SISTEMA:		Sistema Contabilidad
 FUNCION: 		conta.f_get_id_int_comprobante_dev
 DESCRIPCION:   Funcion que devuelve el id_int_comprobante del devengado
 AUTOR: 		 (gsarmiento)
 FECHA:	        13-05-2016
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE
  v_nombre_funcion			varchar;
  v_id_int_comprobante		integer;
  v_nro_sol_pago			varchar;
  v_resp					varchar;
BEGIN
  v_nombre_funcion:='f_get_id_int_comprobante_dev';
  
  select dev.id_int_comprobante, pag.nro_sol_pago into v_id_int_comprobante, v_nro_sol_pago
  from tes.tplan_pago pag
  inner join tes.tplan_pago dev on dev.id_plan_pago=pag.id_plan_pago_fk 
  where pag.id_int_comprobante=p_id_int_comprobante_pago;
  
  /*
  IF v_id_int_comprobante IS NULL THEN
  	raise exception 'No existe un comprobante de devengado relacionado al comprobante de pago %, del tramite %', p_id_int_comprobante_pago, v_nro_sol_pago; 
  END IF;
  */
  return v_id_int_comprobante;
  
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