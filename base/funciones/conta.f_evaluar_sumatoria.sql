--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_evaluar_sumatoria (
  p_formula varchar,
  p_plantilla varchar
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
v_formula_evaluado	varchar;
v_columna			varchar;
v_columna_nueva     varchar[];
v_sw_busqueda		boolean;
v_i					integer;
v_k					integer;
va_variables		varchar[];
v_monto_partida				numeric;
va_retrono			numeric[];
 

BEGIN

   v_nombre_funcion = 'conta.f_evaluar_sumatoria';
   
   --si la formula es nula o blanca sumamos todo los de esta plantilla
   
   IF p_formula is NULL or p_formula = '' THEN
   
         select 
          sum(monto),
          sum(monto_partida)
         into
          v_monto,
          v_monto_partida
         from temp_balancef
         where plantilla = p_plantilla;
   ELSE
     --obtenemos el inicio y fin de la formula
     va_variables[1] = NULL;
     va_variables[2] = NULL;
     va_variables[1] = split_part(p_formula, '-', 1);
     va_variables[2] = split_part(p_formula, '-', 2);
     
     
     if p_plantilla is null or p_plantilla = '' THEN
       raise exception 'en sumatoria la formula son del tipo 1-2,   inico y fin, revise % en la plantilla %', p_formula, p_plantilla;
     end if;
     
     select 
      sum(monto),
      sum(monto_partida)
     into
      v_monto,
      v_monto_partida
     from temp_balancef
     where plantilla = p_plantilla  and orden >= (trim(va_variables[1]))::int4 and orden <= (trim(va_variables[2]))::int4;
     
   END IF;
   
   
   
   va_retrono[1] =  v_monto;
   va_retrono[2] =  v_monto_partida;
   
   --retorna resultado
   RETURN va_retrono;


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