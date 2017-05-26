--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_get_columna (
  p_tipo varchar,
  p_cadena text,
  p_this public.hstore,
  p_tabla public.hstore,
  p_super public.hstore = NULL::hstore,
  p_tabla_padre public.hstore = NULL::hstore
)
RETURNS varchar AS
$body$
 	/*
Autor GAYME RIMERA ROJAS (No sabe poner comentarios)
Fecha 28/06/2013
Descripcion: nose por que el gayme no puso comentarios


Autor:  Rensi Arteaga Copari
Fecha 21/08/2013
Descripcion:   Esta funcion ejecuta la formula de la columna definida en la plantilla
              




  p_tipo varchar,          --   'maestro'  |  datalle
  p_cadena text,           --   cadena a ser evaluada
  p_this public.hstore,    --   datos ya procesados del formulario
  p_tabla public.hstore,   --   datos de la tabla
  
  
  
  p_super public.hstore = NULL::hstore,
  p_tabla_padre public.hstore = NULL::hstore

  ejemplo
  
  v_this.columna_subsistema = conta.f_get_columna('maestro', 
                                                  v_plantilla.campo_subsistema::text, 
                                                  hstore(v_this), 
                                                  hstore(v_tabla));


*/

DECLARE
  
  v_variables			varchar[];
  v_cadena				text;
  v_nombre_funcion      text;
  v_es_select			integer;
  v_resp				varchar;
  v_variable			varchar;
  v_i					integer;
  
BEGIN
  
  
  v_nombre_funcion = 'conta.f_get_columna';
  
  v_cadena = trim(lower(p_cadena));
  
  -- busca si es una consulta   'Si tiene el select por delante'
  
  v_es_select = position('select' in v_cadena);
 
  
  -- get variables plantilla
  v_variables = conta.f_get_variables_plantilla_comprobante(p_cadena, p_tipo);
  
  if (v_variables is null and v_es_select != 1) then
  	
    -- si no es select  y no hay variables devuelve directamente el valor de la cedena , que es un valor constante
   
    return p_cadena;
  
  end if;
  
  
  --Si no es  consulta (select)  devolver el valor directamente
  IF (v_es_select != 1)then
  
  	   v_variable = replace(split_part(v_variables[1], '.', 2), '$', '');
  	
      if (position('$this' in v_variables[1]) = 1)then
      	
          return p_this-> v_variable::varchar;
      
      elsif (position('$tabla_padre' in v_variables[1]) = 1) then
      	
          return p_tabla_padre-> v_variable::varchar;
      
      elsif (position('$super' in v_variables[1]) = 1) then
      	
          return p_super-> v_variable::varchar;
      
      else
          return p_tabla-> v_variable::varchar;
         
      
      end if;
  
  
  
  ELSE
  
 
   -- raise exception '------ %', v_variables;
  --si es select reemplazar los valores de la cadena por los de los records, ejecutar la consulta y devolver el resultado
  
  
    v_i = 1;
  	WHILE (v_i <= array_length(v_variables, 1)) LOOP
    	-- raise exception '------ %', v_variables[v_i];
        v_variable = replace(split_part(v_variables[v_i], '.', 2), '$', '');
        
        if (position('$this' in v_variables[v_i]) = 1)then
        	
            v_cadena = replace(v_cadena,'{'||v_variables[v_i]||'}', p_this-> v_variable);
        
        elsif (position('$tabla_padre' in v_variables[v_i]) = 1)then
        	
           v_cadena = replace(v_cadena, '{'||v_variables[v_i]||'}', p_tabla_padre-> v_variable);
        
        elsif (position('$super' in v_variables[v_i]) = 1)then
        	
            v_cadena = replace(v_cadena, '{'||v_variables[v_i]||'}', p_super-> v_variable);
        
        else
        	
              v_cadena = replace(v_cadena, '{'||v_variables[v_i]||'}', p_tabla-> v_variable);
       
        end if;
        
        v_i = v_i + 1;
            
    END LOOP;
    
  	execute v_cadena into v_resp;
    return v_resp;
    
    
  end if;
  
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
