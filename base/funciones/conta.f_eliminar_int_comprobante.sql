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
 
BEGIN
  
	select * 
    into v_rec_cbte
    from conta.tint_comprobante
    where id_int_comprobante = p_id_int_comprobante;
        
    --Sentencia de la eliminacion
    delete from conta.tint_comprobante
    where id_int_comprobante=p_id_int_comprobante;
            
            
    -- si viene de una plantilla de comprobante busca la funcion de validacion configurada
     IF v_rec_cbte.id_plantilla_comprobante is not null THEN
             
        select 
        pc.funcion_comprobante_eliminado
        into v_funcion_comprobante_eliminado
        from conta.tplantilla_comprobante pc  
        where pc.id_plantilla_comprobante = v_rec_cbte.id_plantilla_comprobante;
                
                
        EXECUTE ( 'select ' || v_funcion_comprobante_eliminado  ||'('||p_id_usuario::varchar||','|| p_id_int_comprobante::varchar||')');
                                   
     END IF;
     
     return 'Comprobante eliminado';


END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;