CREATE OR REPLACE FUNCTION conta.f_resultado_formula_reporte (
  p_formula varchar,
  p_id_plantilla integer,
  p_columnas_formula varchar [],
  out po_columnas_formula varchar [],
  out po_monto numeric,
  p_periodo integer
)
RETURNS record AS
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
v_formula_evaluado	varchar;
v_formula_evaluado_partida	varchar;
v_columna			varchar;
v_columna_nueva     varchar[];
v_sw_busqueda		boolean;
v_i					integer;
v_k					integer;
va_variables		varchar[];
v_monto_haber		numeric;
v_monto_debe		numeric;
v_monto_partida			numeric;


BEGIN

v_nombre_funcion = 'conta.f_evaluar_resultado_detalle_formula';

         v_tmp_formula = p_formula;
         v_formula_evaluado = p_formula;
         v_formula_evaluado_partida = p_formula;


         --  para evitar recalculos
         IF p_columnas_formula is NULL THEN

               IF  p_formula != '' and p_formula is not null THEN
                          LOOP
                                --resetemaos el sw de busquedas
                                v_sw_busqueda = FALSE;
                                -- buscar palabras clave en la plantilla
                                v_columna  =  substring(v_tmp_formula from '%#"#{%#}#"%' for '#');

                             --    raise notice '**************  1  %', v_columna;

                                --limpia la cadena original para no repetir la bsuqueda
                                v_tmp_formula = replace( v_tmp_formula, v_columna, '----');
                                --deja solo el nombre de la variable
                                v_columna= split_part(v_columna,'{',2);
                                v_columna= split_part( v_columna,'}',1);

                             --   raise notice '**************  2  %', v_columna;

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

             ELSE
                v_columna_nueva =  p_columnas_formula;

             END IF;



             v_k = array_upper(v_columna_nueva, 1);
          --   raise notice 'antes del for al evaluar formula ... %',v_k;

             po_columnas_formula = v_columna_nueva;  --variable de salida



             FOR v_i IN 1.. COALESCE(v_k,0)  LOOP

                   --------------------------------------------------
                   -- RECUERA LOS VALORES DE LAS VARIABLES
                   -------------------------------------------------
                   va_variables[1] = NULL;
                   va_variables[2] = NULL;
                   va_variables[1] = split_part(v_columna_nueva[v_i], '.', 1);
                   va_variables[2] = split_part(v_columna_nueva[v_i], '.', 2);


                   IF va_variables[2] is NULL or va_variables[2]  = '' THEN

             		select COALESCE(tre.importe,0)
                         into
                         v_monto
                        from temp_reporte tre
                        where tre.id_plantilla_reporte = p_id_plantilla
                        and tre.columna = va_variables[1]
                        and periodo = p_periodo;

                   END IF;

                   --------------------------------------------
                   --  REMPLAZA VALROES DE LAS VARIABLES
                   --------------------------------------------
                   v_formula_evaluado = replace(v_formula_evaluado, '{'||v_columna_nueva[v_i]||'}', v_monto::varchar);

             END LOOP;

           --  raise notice '*********************************  FORMULA % ',v_formula_evaluado;


             ---------------------
             --  EVALUA FORMULA
             ---------------------
             IF v_formula_evaluado is not NULL THEN
                execute ('SELECT '||v_formula_evaluado) into v_monto;
             END IF;



           --retorna resultado
           po_monto =  v_monto;

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