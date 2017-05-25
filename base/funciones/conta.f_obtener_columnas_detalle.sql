--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_obtener_columnas_detalle (
  p_det_plantilla public.hstore,
  p_def_campos varchar [],
  p_tipo varchar = 'maestro'::character varying
)
RETURNS varchar [] AS
$body$
/*
Autor:  Rensi 
Fecha 1/09/2013
Descripcion:  Recupera las columnas  definidad para la tabla detalle_plantilla_comprobante


*/
DECLARE
  v_posicion		integer;
  v_res				varchar[];
  v_columna			varchar;
  v_columna_nueva 	varchar[];
  v_columnas		record;
  v_prefijo         varchar;
  v_sw_busqueda     boolean;
  
  v_record         record;
  v_nombre_funcion varchar;
  
  v_resp varchar;
  
  v_def_campos      varchar[];
  v_campo_tempo     varchar;
  v_i integer;
  v_tamano integer;
BEGIN
 	
    v_nombre_funcion = 'conta.f_obtener_columnas_detalle';
    
   -- recupera plantila comprobante
    
 
   
    
    v_prefijo = 'tabla';
    
  --LOOP
        
       
        ------------------------------
        -- Procesa campo por campo---
        ------------------------------
        
         v_def_campos = p_def_campos;
          
        --recorrer el for de campos
        
        v_tamano:=array_upper(v_def_campos,1);
       
        FOR v_i in 1..(v_tamano) loop
    
          --almacen_temporal
          v_campo_tempo = p_det_plantilla -> v_def_campos[v_i];
                 
        
         --raise exception '--> %', v_campo_tempo;
          
              LOOP
                  --resetemaos el sw de busquedas
                  v_sw_busqueda = FALSE; 
                 
                  --busca variables del prefijo especificado entre llaves ejemplo, {$tabla.id_depto}
               
                  
                  v_columna  =  substring(v_campo_tempo from '%#"#{$'||v_prefijo||'.%#}#"%' for '#'); 
                  
                  --limpia la cadena original para no repetir la bsuqueda
                  
                  v_campo_tempo = replace( v_campo_tempo, v_columna, '----');
                 
                  --deja solo el nombre de la variable
                  v_columna= split_part(v_columna,'{$'||v_prefijo||'.',2);
                  v_columna= split_part( v_columna,'}',1);
                  
                  IF(v_columna != '' and v_columna is not null )  THEN
                      v_columna_nueva = array_append(v_columna_nueva,v_columna);
                      
                       if  v_res is null or  not v_columna = ANY (v_res)then
                           v_res = array_append(v_res,v_columna);
                           v_sw_busqueda = TRUE;	
                      end if;
                  END IF;
                  
                  IF not v_sw_busqueda THEN
                 
                      exit;
                 
                 END IF;

            END LOOP;
  
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
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;