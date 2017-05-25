--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_get_variables_plantilla_comprobante (
  p_cadena text,
  p_tipo varchar
)
RETURNS varchar [] AS
$body$
/*
Autor GAYME RIMERA ROJAS (No sabe porner comentarios)
Fecha 28/06/2013
Descripcion: nose por que el gayme no puso comentarios


p_tipo = 'maestro'  |  datalle

*/

DECLARE
  v_prefijo 			varchar[];
  v_substring			varchar;
  v_substring_limpia	varchar;
  v_i					integer;
  v_res					varchar[];
  v_nombre_funcion		varchar;
  v_resp				varchar;
  v_cadena				varchar;
BEGIN
	
    v_cadena = p_cadena;
	v_nombre_funcion = 'conta.f_get_variables_plantilla_comprobante';
	v_i = 1;
  	
    
    v_prefijo = array['$tabla', '$this', '$super', '$tabla_padre'];
	
    LOOP
    	--v_substring = substring(v_cadena from '%#"#' || v_prefijo[v_i] || '#.%#$#"%' for '#' );
        
         v_substring  =  substring(v_cadena from '%#"#{' || v_prefijo[v_i] || '#.%#}#"%' for '#');
         --deja solo el nombre de la variable
         
         
        v_substring_limpia= split_part(v_substring,'{',2);
        v_substring_limpia= split_part( v_substring_limpia,'}',1);
        
        if (v_substring_limpia is null) then
        
        	if (v_i < 4) then
            	v_i = v_i + 1;
            else
            	exit;
            end if;
        
        else
        	
            if (v_prefijo[v_i] in ('$super', '$tabla_padre') and p_tipo = 'maestro' ) then
            
            	raise exception 'No se puede definir las variables $super o $tabla_padre a nivel de plantilla_comprobante, solo a nivel de detalle';
            
            end if;
            
            v_cadena = replace(v_cadena, v_substring, '----');--para no repetir la busqueda
        	v_res = array_append(v_res, v_substring_limpia); --acumula variables encontradas
            
        
        end if;        
    END LOOP;
    
    
 
    return v_res;


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
STABLE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;