--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_obtener_columnas (
  p_codigo varchar
)
RETURNS varchar [] AS
$body$
/*
Autor Original GAYME RIMERA ROJAS (No sabe porner comentarios)
Fecha 28/06/2013
Descripcion: nose por que el gayme no puso comentarios



Autor:  Rensi 
Fecha 20/08/2013
Descripcion: Resctrucuturacion de toda la funcion. 
             Sirve para recuperar todos los nombre de las variables  tipo $tabla configuradas en la plantilla del comprobante  


*/
DECLARE
  v_posicion		integer;
  v_res				varchar[];
  v_columna			varchar;
  v_columna_nueva 	varchar[];
  v_columnas		record;
  v_prefijo         varchar;
  v_sw_busqueda     boolean;
BEGIN
 	
    
   -- recupera plantila comprobante
    select 
      campo_subsistema, 
      campo_depto, 
      campo_acreedor,
      campo_descripcion, 
      campo_fk_comprobante, 
      campo_moneda,
      campo_fecha 
    into 
      v_columnas
    from conta.tplantilla_comprobante
    where codigo=p_codigo;
    
    raise notice 'v_columnas  %',v_columnas;
    
    
    v_prefijo = 'tabla';
    
   LOOP
        
         v_sw_busqueda = FALSE;  --resetemaos el sw de busqeudas
        
        --busca variables del prefijo especificado entre llaves ejemplo, {$tabla.id_depto}
        v_columna  =  substring(v_columnas.campo_subsistema from '%#"#{$'||v_prefijo||'.%#}#"%' for '#'); 
        --limpia la cadena original para no repetir la bsuqueda
        v_columnas.campo_subsistema = replace( v_columnas.campo_subsistema, v_columna, '----');
       
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
        
        
        
        -- v_columnas.campo_depto
        
        v_columna  =  substring(v_columnas.campo_depto from '%#"#{$'||v_prefijo||'.%#}#"%' for '#'); 
        v_columnas.campo_depto = replace( v_columnas.campo_depto, v_columna, '----');
       
        v_columna= split_part(v_columna,'{$'||v_prefijo||'.',2);
        v_columna= split_part( v_columna,'}',1);
        
         IF(v_columna != '' and v_columna is not null )  THEN
            v_columna_nueva = array_append(v_columna_nueva,v_columna);
            
             if v_res is null or  not v_columna = ANY (v_res)then
                 v_res = array_append(v_res,v_columna);
                 v_sw_busqueda = TRUE;
            			
            end if;
 		END IF;
        
        
        -- v_columnas.campo_acreedor
        
        v_columna  =  substring(v_columnas.campo_acreedor from '%#"#{$'||v_prefijo||'.%#}#"%' for '#'); 
         v_columnas.campo_acreedor = replace( v_columnas.campo_acreedor, v_columna, '----');
       
        v_columna= split_part(v_columna,'{$'||v_prefijo||'.',2);
        v_columna= split_part( v_columna,'}',1);
        
         IF(v_columna != '' and v_columna is not null )  THEN
            v_columna_nueva = array_append(v_columna_nueva,v_columna);
            
             if v_res is null or  not v_columna = ANY (v_res)then
                 v_res = array_append(v_res,v_columna);
                 v_sw_busqueda = TRUE;
            			
            end if;
 		END IF;
        
        
         -- v_columnas.campo_descripcion
        
        v_columna  =  substring(v_columnas.campo_descripcion from '%#"#{$'||v_prefijo||'.%#}#"%' for '#'); 
        v_columnas.campo_descripcion = replace( v_columnas.campo_descripcion, v_columna, '----');
        v_columna= split_part(v_columna,'{$'||v_prefijo||'.',2);
        v_columna= split_part( v_columna,'}',1);
        
         IF(v_columna != '' and v_columna is not null )  THEN
            v_columna_nueva = array_append(v_columna_nueva,v_columna);
            
             if v_res is null or  not v_columna = ANY (v_res)then
                 v_res = array_append(v_res,v_columna);
                 v_sw_busqueda = TRUE;
            			
            end if;
 		END IF;
        
       -- v_columnas.campo_fk_comprobante
        
        v_columna  =  substring(v_columnas.campo_fk_comprobante from '%#"#{$'||v_prefijo||'.%#}#"%' for '#'); 
        v_columnas.campo_fk_comprobante = replace( v_columnas.campo_fk_comprobante, v_columna, '----');
        v_columna= split_part(v_columna,'{$'||v_prefijo||'.',2);
        v_columna= split_part( v_columna,'}',1);
        
         IF(v_columna != '' and v_columna is not null )  THEN
            v_columna_nueva = array_append(v_columna_nueva,v_columna);
            
             if v_res is null or  not v_columna = ANY (v_res)then
                 v_res = array_append(v_res,v_columna);
            	 v_sw_busqueda = TRUE;		
            end if;
 		END IF;
        
        -- v_columnas.campo_moneda
        
        v_columna  =  substring(v_columnas.campo_moneda from '%#"#{$'||v_prefijo||'.%#}#"%' for '#'); 
        v_columnas.campo_moneda = replace( v_columnas.campo_moneda, v_columna, '----');
        v_columna= split_part(v_columna,'{$'||v_prefijo||'.',2);
        v_columna= split_part( v_columna,'}',1);
        
         IF(v_columna != '' and v_columna is not null )  THEN
            v_columna_nueva = array_append(v_columna_nueva,v_columna);
            
             if v_res is null or  not v_columna = ANY (v_res)then
                 v_res = array_append(v_res,v_columna);
            	 v_sw_busqueda = TRUE;		
            end if;
 		END IF;
        
        -- v_columnas.campo_fecha
        
        v_columna  =  substring(v_columnas.campo_fecha from '%#"#{$'||v_prefijo||'.%#}#"%' for '#'); 
        v_columnas.campo_fecha = replace( v_columnas.campo_fecha, v_columna, '----');
        v_columna= split_part(v_columna,'{$'||v_prefijo||'.',2);
        v_columna= split_part( v_columna,'}',1);
        
         IF(v_columna != '' and v_columna is not null )  THEN
            v_columna_nueva = array_append(v_columna_nueva,v_columna);
            
             if v_res is null or  not v_columna = ANY (v_res)then
                 v_res = array_append(v_res,v_columna);
            	 v_sw_busqueda = TRUE;		
            end if;
 		END IF;
        
        raise notice 'v_sw_busqueda  %',v_sw_busqueda;

       IF not v_sw_busqueda THEN
       
       		exit;
       
       END IF;

    END LOOP;
        
    raise notice 'v_res  %',v_res;
        
    return v_res;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;