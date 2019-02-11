--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_comparar_numeric (
  p_number_1 numeric,
  p_number_2 numeric,
  p_error numeric
)
RETURNS boolean AS
$body$
/*

  *************************************************************************************************** 

    HISTORIAL DE MODIFICACIONES:
   	
 ISSUE            FECHA:		      AUTOR                 DESCRIPCION   
 #0        		25/02/2018        RCM KPLIAN            Compara dos nmeros mas menos diferencia de venta de error       

*/
DECLARE

v_nombre_funcion   varchar;
v_resp             varchar;
  
BEGIN

 v_nombre_funcion:='conta.f_comparar_numeric';
 
 IF p_number_1 = p_number_2 THEN
    
 		RETURN TRUE;   --son excatamente iguales
 
 ELSE
    --consideramso la ventana de error
    
     IF  (p_number_1  + p_error) >= p_number_2  and (p_number_1 - p_error) <= p_number_2 THEN
        /*
        
        
        1) 
          10.01 !=  10.02      vanta de error 0,02
          
          10.01 + 0.02 >=   10.02    AND  10.01 -0.02 =< 10.02
              10.03 >=  10.02 AND   9.99 <= 10.02
                  T                       T
                                T                            CORRECTO
                                
        1) 
          10.01 !=  9.9      vanta de error 0,02
          
          10.01 + 0.02 >=   9.9    AND  10.01 -0.02 =< 9.9
              10.03 >=  9.9 AND   9.99 <= 9.9
                  T                       F
                               F                            CORRECTO     , el error vanta sobre pasa lo permitido                    
                                
                                
                                
        
        */
     
        RETURN TRUE;
     ELSE
        RETURN FALSE;     
     END IF;
 
 END IF;
 
  
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