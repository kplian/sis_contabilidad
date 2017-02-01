--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_evaluar_resultado_formula (
  p_formula varchar,
  p_plantilla varchar,
  p_destino varchar
)
RETURNS numeric [] AS
$body$
DECLARE


v_parametros  		record;
v_registros 		record;
v_nombre_funcion   	text;
v_resp				varchar;
v_nivel				integer;
v_monto				numeric;
v_mayor				numeric;
v_id_gestion  		integer;
v_tmp_formula		varchar;
v_formula_evaluado				varchar;
v_formula_evaluado_partida		varchar;
v_columna						varchar;
v_columna_nueva     			varchar[];
v_sw_busqueda					boolean;
v_i								integer;
v_k								integer;
va_variables					varchar[];
v_monto_haber					numeric;
v_monto_debe					numeric;
v_monto_partida					numeric;
v_monto_recurso					numeric;
v_monto_gasto					numeric;
v_monto_retorno					numeric[];

 

BEGIN

   v_nombre_funcion = 'conta.f_evaluar_resultado_formula';
   v_tmp_formula = p_formula;
   v_formula_evaluado = p_formula;
   v_formula_evaluado_partida = p_formula;
   
   raise notice '----------> Evaluando la formula: %', p_formula;
   ------------------------------------------------------------------------
   --  RECUPERAMOS LOS NOMBRES DE LAS PALABRAS CLAVE DE LA FORMULA 
   -------------------------------------------------------------------------
   IF p_destino != 'segun_saldo' THEN
    
        IF  p_formula != '' and p_formula is not null THEN
            LOOP
                  --resetemaos el sw de busquedas
                  v_sw_busqueda = FALSE; 
                  -- buscar palabras clave en la plantilla            
                  v_columna  =  substring(v_tmp_formula from '%#"#{%#}#"%' for '#');
                  
                   raise notice '**************  1  %', v_columna;
                    
                  --limpia la cadena original para no repetir la bsuqueda
                  v_tmp_formula = replace( v_tmp_formula, v_columna, '----');
                  --deja solo el nombre de la variable
                  v_columna= split_part(v_columna,'{',2);
                  v_columna= split_part( v_columna,'}',1);
                   
                  raise notice '**************  2  %', v_columna;
                               
                  IF(v_columna != '' and v_columna is not null )  THEN
                     v_columna_nueva = array_append(v_columna_nueva,v_columna);
                     --marcamos la bancera para seguir buscando
                     v_sw_busqueda = TRUE;	
                  END IF;
                  --si no se agrego nada mas tenemos la busqueda
                  IF not v_sw_busqueda THEN
                      exit;
                 END IF;
    		
            
            
            
            END LOOP;
       END IF;             
       
       v_k = array_upper(v_columna_nueva, 1);
       raise notice 'antes del for al evaluar formula ... %',v_k;          
       FOR v_i IN 1.. COALESCE(v_k,0)  LOOP
             
             --------------------------------------------------
             -- RECUERA LOS VALORES DE LAS VARIABLES
             -------------------------------------------------
             va_variables[1] = NULL;
             va_variables[2] = NULL;
             va_variables[1] = split_part(v_columna_nueva[v_i], '.', 1);
             va_variables[2] = split_part(v_columna_nueva[v_i], '.', 2);
             
             IF va_variables[2] is NULL or va_variables[2]  = '' THEN
                 -- si la variable no contiene el caracters especial "."
                 SELECT 
                   sum(COALESCE(monto,0)),
                   sum(COALESCE(monto_partida,0))
                   
                 into
                   v_monto,
                   v_monto_partida
                 FROM  temp_balancef
                 WHERE  codigo =  va_variables[1]  and lower(plantilla) = lower(p_plantilla);
             ELSE
                
                 --raise exception '... %' , 
                -- si la variable no contiene el caracters especial ".", buscamos en la plantilla correspondiente
                 SELECT 
                   sum(COALESCE(monto,0))
                 into
                   v_monto
                 FROM  temp_balancef
                 WHERE  codigo = va_variables[2]  and lower(plantilla) = lower(va_variables[1]);
             END IF;
             --------------------------------------------
             --  REMPLAZA VALROES DE LAS VARIABLES
             --------------------------------------------
             v_formula_evaluado = replace(v_formula_evaluado, '{'||v_columna_nueva[v_i]||'}', v_monto::varchar);
             v_formula_evaluado_partida = replace(v_formula_evaluado_partida, '{'||v_columna_nueva[v_i]||'}', v_monto_partida::varchar);
                                
       END LOOP;
       
       raise notice '*********************************  FORMULA % ',v_formula_evaluado;
       
       ---------------------
       --  EVALUA FORMULA
       ---------------------
       IF v_formula_evaluado is not NULL THEN
          execute ('SELECT '||v_formula_evaluado) into v_monto;
       END IF;
       
       IF v_formula_evaluado is not NULL THEN
          execute ('SELECT '||v_formula_evaluado_partida) into v_monto_partida;
       END IF;
       
       v_monto_retorno[1] = v_monto;
       v_monto_retorno[2] = v_monto_partida;
   
   
   ELSE
     ------------------------------------------------------------------------
     -- Si la formula es segun saldo, hacemos los balances del debe y el haber
     ------------------------------------------------------------------------
         SELECT 
           sum(COALESCE(monto,0)),
           sum(COALESCE(monto_partida,0))
         into
           v_monto_debe,
           v_monto_gasto
         FROM  temp_balancef
         WHERE  destino = 'debe'  
                and lower(plantilla) = lower(p_plantilla);
   
         SELECT 
           sum(COALESCE(monto,0)),
           sum(COALESCE(monto_partida,0))
         into
           v_monto_haber,
           v_monto_recurso
         FROM  temp_balancef
         WHERE  destino = 'haber'  
                and lower(plantilla) = lower(p_plantilla);
   
        IF  v_monto_debe > v_monto_haber  THEN
             v_monto_retorno[1]= v_monto_debe - v_monto_haber;
             v_monto_retorno[2]= v_monto_gasto - v_monto_recurso;
        ELSE
             v_monto_retorno[1]= (v_monto_haber - v_monto_debe)*(-1);
             v_monto_retorno[2]= (v_monto_recurso - v_monto_gasto)*(-1);
        END IF;
        
   
   END IF;
   
   --retorna resultado
   RETURN v_monto_retorno;


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