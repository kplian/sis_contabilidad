--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_revisar_dependencias (
  p_id_int_comprobante integer
)
RETURNS boolean AS
$body$
/*
	Autor: RAC (KPLIAN)
    Fecha: 05-09-2013
    Descripción: Revisa las dependendencias del cbte para indicar si peude o no volcar
*/
DECLARE

	
    v_resp				varchar;
    v_nombre_funcion   	varchar;
    v_error				boolean;
    v_id_int_cbte_rel	integer[];
    v_aux				varchar;
    v_registros			record;
    v_msg_final			varchar;
    
     

BEGIN

    v_nombre_funcion:='conta.f_revisar_dependencias';
    v_msg_final = '';
    v_error = false;
    
    
    FOR v_registros in ( 
                          SELECT
                              c.id_int_comprobante,
                              c.nro_cbte,
                              rc.nombre,
                              c.volcado,
                              c.cbte_reversion 
                          FROM conta.tint_comprobante c
                          inner join conta.ttipo_relacion_comprobante rc on rc.id_tipo_relacion_comprobante = c.id_tipo_relacion_comprobante
                          WHERE  p_id_int_comprobante = ANY(c.id_int_comprobante_fks)) LOOP
                        
                      
                        
          IF   v_registros.volcado = 'no'   THEN
          
           
           
             v_aux = format('Con el Cbte %s (id:%s) , %s <BR>', COALESCE(v_registros.nro_cbte::varchar,'s/n'), v_registros.id_int_comprobante::varchar, v_registros.nombre::varchar );
             v_msg_final = v_msg_final||v_aux;
             v_error = true;
          END IF;
    
    END LOOP;
    
    
    IF v_error THEN
    
      raise exception 'Este Cbte tiene relaciones: <br> %',v_msg_final;
    END IF;
    
    
    
    return true;

EXCEPTION
WHEN OTHERS THEN
	if (current_user like '%dblink_%') then
    	v_resp = pxp.f_obtiene_clave_valor(SQLERRM,'mensaje','','','valor');
        if v_resp = '' then        	
        	v_resp = SQLERRM;
        end if;
    	return 'error' || '#@@@#' || v_resp;        
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