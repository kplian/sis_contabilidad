--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_ges_cbte_eliminacion_doc_compra_venta (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_int_comprobante integer,
  p_conexion varchar = NULL::character varying
)
RETURNS boolean AS
$body$
/*

Autor: RAC KPLIANF
Fecha:   16 febrero  de 2016 
Descripcion  esta funcion quita la relacion con los documentos de LCV cuando el cbte se elimina

*/


DECLARE
  
	v_nombre_funcion   	text;
	v_resp				varchar;   
    v_registros 		record;
    
    
    
BEGIN

	v_nombre_funcion = 'conta.f_ges_cbte_eliminacion_doc_compra_venta';
    
    
    FOR v_registros in (select * 
                        from conta.tdoc_compra_venta dcv
                        where dcv.id_int_comprobante = p_id_int_comprobante) LOOP
             
             update conta.tdoc_compra_venta  set
                id_int_comprobante = NULL
             where id_doc_compra_venta = v_registros.id_doc_compra_venta;
               
	END LOOP;
      
    
  
RETURN  TRUE;



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