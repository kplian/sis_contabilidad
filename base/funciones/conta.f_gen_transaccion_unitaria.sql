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
	v_this					conta.tdetalle_plantilla_comprobante;
    v_this_hstore		    hstore;
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
    
   
    v_def_campos = ARRAY['campo_monto','campo_cuenta','campo_auxiliar','campo_partida','campo_centro_costo','campo_relacion_contable','campo_documento','otros_campos'];
    v_tamano:=array_upper(v_def_campos,1);
         
   
   IF p_reg_det_plantilla->'tabla_detalle'!=''  and p_reg_det_plantilla->'tabla_detalle' !='NULL' THEN
    
          -- obtener la columnas que se consultaran  para la tabla  ( los nombre de variables con prefijo $tabla)
          
          v_columnas=conta.f_obtener_columnas_detalle(p_reg_det_plantilla,v_def_campos,'detalle')::varchar;
      	  
          v_columnas=replace(v_columnas,'{','');
      	  v_columnas=replace(v_columnas,'}','');
         
   
         IF p_reg_det_plantilla->'nom_fk_tabla_maestro' ='' or p_reg_det_plantilla->'nom_fk_tabla_maestro' ='NULL' THEN
         
           raise exception 'En el detalle de plantilla el campo nom_fk_tabla_maestro no puede ser vacio si hace referencia a una tabla_detalle';
           
         END IF;
          
        --prepara la consulta de la tabla detalle
        
         v_consulta_tab ='select '||v_columnas ||
                        ' from '|| (p_reg_det_plantilla->'tabla_detalle')|| ' where '
                        ||(p_reg_det_plantilla->'tabla_detalle')||'.'||(p_reg_det_plantilla->'nom_fk_tabla_maestro')||'='||COALESCE(p_id_tabla_padre_valor,0);
         
       
        
        --  FOR, para todos los cada registro que satisfaga la consulta de la tabla detalle
        --   obtner los valores para cada registro que satisfaga la consulta de la tabla detalle
        FOR v_tabla in EXECUTE(v_consulta_tab) LOOP
       
           --      obtener la definicion de las variablles y los valores
           
           
             v_this_hstore = hstore(v_this);
             
             FOR v_i in 1..(v_tamano) loop
    
                  --evalua la columna
                 if (p_reg_det_plantilla->v_def_campos[v_i] !='' AND p_reg_det_plantilla->v_def_campos[v_i]!='NULL' AND (p_reg_det_plantilla->v_def_campos[v_i]) is not NULL) then
      	
                       v_campo_tempo = conta.f_get_columna('datalle', 
                                                              p_reg_det_plantilla->v_def_campos[v_i]::text, 
                                                              hstore(v_this), 
                                                              hstore(v_tabla),
                                                              p_super,
                                                              p_tabla_padre
                                                              );
                                                              
                      v_this_hstore = v_this_hstore || (v_def_campos[v_i] => v_campo_tempo);
                  
                  end if;
           
             END LOOP;
             
           --      IF procesar relacion contable si existe
           
           IF p_reg_det_plantilla -> 'es_relacion_contable'  = 'si' THEN
           
                SELECT 
                  * 
                 into 
                   v_record_rel_con 
               FROM conta.f_get_config_relacion_contable((p_reg_det_plantilla -> 'tipo_relacion_contable')::varchar, 
                                                          (p_super->'columna_gestion')::integer, 
                                                          (v_this_hstore -> 'campo_relacion_contable')::integer, 
                                                          (v_this_hstore -> 'campo_centro_costo')::integer);
                                                              
              
                raise notice '*****  REL CON % , %', v_record_rel_con, v_this_hstore ->'campo_cuenta';
                
                -- los utiliza solo si no remplaza los valores de los campos del detalle de plantilla 
                
                IF v_this_hstore ->'campo_cuenta' ='' or v_this_hstore ->'campo_cuenta'='NULL' or (v_this_hstore ->'campo_cuenta') is NULL THEN 
                     
                     v_this_hstore = v_this_hstore || ('campo_cuenta' => v_record_rel_con.ps_id_cuenta::varchar);
                
                END IF;
                
                IF v_this_hstore ->'campo_partida' ='' or v_this_hstore ->'campo_partida'='NULL' or (v_this_hstore ->'campo_partida') is NULL THEN 
                     
                     v_this_hstore = v_this_hstore || ('campo_partida' => v_record_rel_con.ps_id_partida::varchar);
                
                END IF;
                
                IF v_this_hstore ->'campo_auxiliar' ='' or v_this_hstore ->'campo_auxiliar'='NULL' or (v_this_hstore ->'campo_auxiliar') is NULL THEN 
                     
                     v_this_hstore = v_this_hstore || ('campo_auxiliar' => v_record_rel_con.ps_id_auxiliar::varchar);
                
                END IF;
                
                
           
           
           END IF;
           
           
           --validar si existe cuenta, partida y auxiliar
           
           
            IF v_this_hstore ->'campo_cuenta' ='' or v_this_hstore ->'campo_cuenta'='NULL' or (v_this_hstore ->'campo_cuenta') is NULL THEN 
                
                  raise exception 'No se encontro una contable para la plantilla detalle del comprobante';
                    
            END IF;
           
             raise notice '&===========> %',v_this_hstore;
          
           
                      
           --      IF procesar documento
                   --TODO analizar la plantilla de endesis
                   
                   
          
           --      IF procesar la transaccion secundaria si existe
                   -- obtiene el record de la transaccion secundaria
                   -- llamada recursica  a esta misma funcion con la bnadera activada        
                   
           
        
        
        END LOOP;
  



 ELSE
 
        --  Si el campo tabla detalle es igual null,  se genera una sola transaccion 
        
        --  si existe una columna que haga referencia a la tabla da error
        
        --  inserta los valores en la tabla intermedia de transaccion
 
 
 
 
 END IF;
     
 
  
   --IF si el registro tiene la tabla detalle distinto de NULL y la bandera secundaria esta desactivada
      
      
                   
                   
                   
   
  -- ELSE
        
  
   
       
    
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