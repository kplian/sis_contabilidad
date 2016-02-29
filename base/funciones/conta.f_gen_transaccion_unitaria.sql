--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_gen_transaccion_unitaria (
  p_super public.hstore,
  p_tabla_padre public.hstore,
  p_reg_det_plantilla public.hstore,
  p_plantilla_comprobante public.hstore,
  p_id_tabla_padre_valor integer,
  p_id_int_comprobante integer,
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
	v_this					conta.tdetalle_plantilla_comprobante;
    v_this_hstore		    hstore;
    v_record_int_tran       conta.tint_transaccion;
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
    
    v_consulta_tab  varchar;
    
     v_def_campos      varchar[];
     v_campo_tempo     varchar;
     v_i integer;
     v_tamano integer;
     
     
     v_record_rel_con record;
     v_reg_id_int_transaccion integer;
     v_resp_doc boolean;
BEGIN
	
    v_nombre_funcion:='conta.f_gen_transaccion_unitaria';
    
   
    -------------------------------------------------------
    --TODO interface de detalle_transaccion
        --   Combo para relaciones contables, solo se almacena codigo para no depender de id
        --   combo aplicar documento si, no in text
       
    --  interface maestro comprobante agregar un campo para otras columnas    
   
   --TODO agregar en la tabla detalle plantilla  e interfaz un 
   --  campo para guardar  el nombre de la llave foranea
   
   -- TODO por ultimmos analizar el movimiento presupuestario
   
   --------------------------------------------------------- 
    
   
    v_def_campos = ARRAY['campo_monto',
    					'campo_cuenta',
                        'campo_auxiliar',
                        'campo_partida',
                        'campo_centro_costo',
                        'campo_orden_trabajo',
                        'campo_partida_ejecucion',
                        'campo_relacion_contable',
                        'campo_relacion_contable_cc',
                        'campo_documento',
                        'otros_campos',
                        'campo_monto_pres',
                        'campo_id_tabla_detalle',
                        'campo_trasaccion_dev',
                        'campo_concepto_transaccion',
                        'campo_id_cuenta_bancaria',
                        'campo_id_cuenta_bancaria_mov',
                        'campo_nro_cheque',
                        'campo_nro_cuenta_bancaria_trans',
                        'campo_porc_monto_excento_var',
                        'campo_nombre_cheque_trans',
                        'campo_forma_pago'];
    v_tamano:=array_upper(v_def_campos,1);
         
  
   
   IF (p_reg_det_plantilla->'tabla_detalle')!=''  and (p_reg_det_plantilla->'tabla_detalle') !='NULL' THEN
   
    
    
          -- obtener la columnas que se consultaran  para la tabla  ( los nombre de variables con prefijo $tabla)
          
          v_columnas=conta.f_obtener_columnas_detalle(p_reg_det_plantilla,v_def_campos,'detalle')::varchar;
      	  
          v_columnas=replace(v_columnas,'{','');
      	  v_columnas=replace(v_columnas,'}','');
          
          
         
         
   
         IF (p_reg_det_plantilla->'nom_fk_tabla_maestro') = '' or (p_reg_det_plantilla->'nom_fk_tabla_maestro') = 'NULL' THEN
         
           raise exception 'En el detalle de plantilla el campo nom_fk_tabla_maestro no puede ser vacio si hace referencia a una tabla_detalle';
           
         END IF;
         
         
          
        --prepara la consulta de la tabla detalle
        
         v_consulta_tab ='select '||v_columnas ||
                        ' from '|| (p_reg_det_plantilla->'tabla_detalle')||' where '
                        ||(p_reg_det_plantilla->'tabla_detalle')||'.'||(p_reg_det_plantilla->'nom_fk_tabla_maestro')||'='||COALESCE(p_id_tabla_padre_valor,0);
         
       
       
        --  FOR, para todos los cada registro que satisfaga la consulta de la tabla detalle
        --   procesamos los valores
        FOR v_tabla in EXECUTE(v_consulta_tab) LOOP
             
              
              v_resp = conta.f_gen_transaccion_from_plantilla(
                                              p_super,    --p_super
                                              p_tabla_padre, --p_tabla_padre
                                              p_reg_det_plantilla,--p_reg_det_plantilla
                                              p_plantilla_comprobante, --p_plantilla_comprobante
                                              p_id_tabla_padre_valor,
                                              p_id_int_comprobante,
                                              p_id_usuario,
                                              hstore(v_tabla),
                                              v_def_campos,
                                              v_tamano
                                              );
                                              
                                              
             
          
       END LOOP;



 --IF si el registro tiene la tabla detalle distinto de NULL y la bandera secundaria esta desactivada

 ELSE
 
 
        --  Si el campo tabla detalle es igual null,  se genera una sola transaccion 
        
         v_resp = conta.f_gen_transaccion_from_plantilla(
                                              p_super,    --p_super
                                              p_tabla_padre, --p_tabla_padre
                                              p_reg_det_plantilla,--p_reg_det_plantilla
                                              p_plantilla_comprobante, --p_plantilla_comprobante
                                              p_id_tabla_padre_valor,
                                              p_id_int_comprobante,
                                              p_id_usuario,
                                              NULL,--v_tabla
                                              v_def_campos,
                                              v_tamano
                                              );
        

 
 END IF;
     

  
   
      
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