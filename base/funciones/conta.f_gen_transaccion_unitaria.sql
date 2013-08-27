--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_gen_transaccion_unitaria (
  p_super public.hstore,
  p_tabla_padre public.hstore,
  p_reg_det_plantilla public.hstore,
  p_plantilla_comprobante public.hstore,
  p_id_tabla_padre_valor integer,
  p_id_usuario integer = NULL::integer
)
RETURNS varchar AS
$body$
/*
Autor:  Rensi Arteaga Copari
Fecha 27/08/2013
Descripcion:    
   Esta funcion evalua un detalle de trasaccion especifico e inserta 
   las trasacciones generadas en int_trasaccion



*/


DECLARE
	v_this					conta.maestro_comprobante;
    v_tabla					record;
    v_nombre_funcion        text;
    v_plantilla_det				record;        
    v_resp 					varchar;
    v_consulta				varchar;
    v_posicion				integer;
    v_columnas				varchar;
    v_columna_requerida		varchar;
    r 						record;  --  esta variable no se usa
    v_valor					varchar;
    
    v_id_int_comprobante    integer;
BEGIN
	
    v_nombre_funcion:='conta.f_gen_transaccion_unitaria';
    
   
    -------------------------------------------------------
    --TODO interface de detalle_transaccion
        --   Combo para relaciones contables, solo se almacena codigo para no depender de id
        --   combo aplicar documento si, no
        --   falta un campo para la glosa de la transaccion en interfaz
        --    "    "   "   en tabla 
        
   
   --TODO agregar en la tabla detalle plantilla  e interfaz un 
   --  campo para guardar  el nombre de la llave foranea
   
   -- TODO por ultimmos analizar el movimiento presupuestario
   
   --------------------------------------------------------- 
    
    --  recupero el record de la plantilla con el codigo (parametro) dado
     --   p_reg_det_plantilla


    -- obtener la columnas que se consultaran  para la tabla  ( los nombre de variables con prefijo $tabla)
   
     
   --IF si el registro tiene la tabla detalle distinto de NULL y la bandera secundaria esta desactivada
      
      --  FOR, para todos los cada registro que satisfaga la consulta de la tabla detalle
         -- WHERE    p_reg_det_plantilla.id_tabla =  p_id_tabla_padre_valor
     
           --   obtner los valores para cada registro que satisfaga la consulta de la tabla detalle
     
           --      obtener la definicion de las variablles y los valores
           
           --      IF procesar relacion contable si existe
                        -- los utiliza solo si no remplaza los valores de los campos del detalle de plantilla
           
           --      ELSE,   los valores de cuenta , auxiliar y partida salen directamente del detalle de plantilla  
               
           --      IF procesar la transaccion secundaria si existe
                   -- obtiene el record de la transaccion secundaria
                   -- llamada recursica  a esta misma funcion con la bnadera activada
           
           --      IF procesar documento
                   --TODO analizar la plantilla de endesis
                   
                   /*
                   TODO
                    -  Crear un tipo de relacion contable para
                       la taba  ejercicio
                       
                   
                   
                   */
                   
                   
                   
   
  -- ELSE
        -- Si el campo tabla detalle es igual null,  se genera una sola transaccion 
        
        --  si existe una columna que haga referencia a la tabla da error
        
        --inserta los valores en la tabla intermedia de transaccion
  
   
       
    
    return v_resp;
    
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