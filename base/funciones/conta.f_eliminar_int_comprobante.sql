--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_eliminar_int_comprobante (
  p_id_usuario integer,
  p_id_int_comprobante integer
)
RETURNS varchar AS
$body$
/*
Autor: RCM
Fecha: 18/11/2013
Descripcion: Funcion para la eliminacion de int comprobante
*/

DECLARE

	v_rec_cbte record;
    v_funcion_comprobante_eliminado varchar;
    v_resp			varchar;
    v_nombre_funcion   varchar;
    v_rec_cbte_trans record;
 
BEGIN
  	v_nombre_funcion:='conta.f_eliminar_int_comprobante';
	select * 
    into v_rec_cbte
    from conta.tint_comprobante
    where id_int_comprobante = p_id_int_comprobante;
        
    
              
    -- si viene de una plantilla de comprobante busca la funcion de validacion configurada
     IF v_rec_cbte.id_plantilla_comprobante is not null THEN
             
        select 
        pc.funcion_comprobante_eliminado
        into v_funcion_comprobante_eliminado
        from conta.tplantilla_comprobante pc  
        where pc.id_plantilla_comprobante = v_rec_cbte.id_plantilla_comprobante;
                
                
        EXECUTE ( 'select ' || v_funcion_comprobante_eliminado  ||'('||p_id_usuario::varchar||','|| p_id_int_comprobante::varchar||')');
                                   
     END IF;
     
    
    
    --delete transacciones del comprobante intermedio
    delete from conta.tint_transaccion
    where id_int_comprobante=p_id_int_comprobante;
    
     --Sentencia de la eliminacion
    delete from conta.tint_comprobante
    where id_int_comprobante=p_id_int_comprobante;
     
     return 'Comprobante eliminado';
EXCEPTION
WHEN OTHERS THEN
	if (current_user like '%dblink_%') then
    	return 'error' || '#@@@#'|| SQLERRM;
    else
			v_resp='';
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
			v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
			v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
			raise exception '%',v_resp;
    end if;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;