--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_armar_filtro_relacion_contable (
  p_tiene_centro_costo varchar,
  p_tiene_aplicacion varchar,
  p_sw_ca boolean,
  p_id_tabla varchar,
  p_aplicacion varchar,
  p_tiene_moneda varchar,
  p_id_moneda varchar,
  p_id_centro_costo varchar
)
RETURNS varchar [] AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.f_armar_filtro_relacion_contable
 DESCRIPCION:   Contruye el filtro considerando criterior de prioridad para obtener las relaciones contables
 AUTOR: 		 (rac)  kplian
 FECHA:	        06/09/2017
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE



v_nombre_funcion		varchar;
v_resp					varchar;
v_registros				record;
va_sql					varchar[];
v_id_tipo_presupuesto	integer;


 

BEGIN

  	  v_nombre_funcion = 'conta.f_armar_filtro_relacion_contable';
      
     
      
       if p_tiene_centro_costo = 'no' then
          
              if p_tiene_aplicacion = 'si' and p_sw_ca  then
              
                      va_sql[1] = ' and rc.id_centro_costo is NULL
                                    and rc.id_tabla = ' || p_id_tabla ||'
                                    and rc.codigo_aplicacion = ''' ||p_aplicacion||''' ';
                                  
                      
                      va_sql[2] = ' and rc.id_centro_costo is NULL
                                    and rc.id_tabla = ' || p_id_tabla ||'
                                    and rc.codigo_aplicacion is null '; 
                                  
                      va_sql[3] = ' and rc.id_centro_costo is NULL
                                    and rc.id_tabla is NULL
                                    and rc.codigo_aplicacion = ''' ||p_aplicacion||''' 
                                    and rc.defecto = ''si''';                       
                      
                      va_sql[4] = ' and rc.id_centro_costo is NULL
                                    and rc.id_tabla is NULL
                                    and rc.codigo_aplicacion is null
                                    and rc.defecto = ''si''';
                              
                elseif p_tiene_moneda = 'si' and p_id_moneda is not null then              
                  
                   
                     
                      va_sql[1] = ' and rc.id_centro_costo is NULL
                                    and rc.id_tabla = ' || p_id_tabla||'
                                    and rc.id_moneda = '||p_id_moneda;
                      
                      va_sql[2] = ' and rc.id_centro_costo is NULL
                                    and rc.id_tabla = ' || p_id_tabla||'
                                    and rc.id_moneda is null';
                                  
                                  
                      va_sql[3] = ' and rc.id_centro_costo is NULL
                                    and rc.id_tabla is NULL
                                    and rc.id_moneda = '||p_id_moneda||'
                                    and rc.defecto = ''si''';            
                      
                      va_sql[4] = ' and rc.id_centro_costo is NULL
                                    and rc.id_tabla is NULL
                                    and rc.id_moneda is null 
                                    and rc.defecto = ''si''';            
                      
                  
               else
                    
                     
               
                      va_sql[1] = ' and rc.id_centro_costo is NULL
                                  and rc.id_tabla = ' || p_id_tabla;
                      
                      va_sql[2] = ' and rc.id_centro_costo is NULL
                                  and rc.id_tabla is NULL
                                  and rc.defecto = ''si''';
               
               end if;
          
          elsif p_tiene_centro_costo = 'si' then
          
                 if p_tiene_aplicacion = 'si' and p_sw_ca  then
                 
                 
                  
                      va_sql[1] = ' and rc.id_centro_costo = ' || p_id_centro_costo ||'
                                    and rc.id_tabla = ' || p_id_tabla||'
                                    and rc.codigo_aplicacion = ''' ||p_aplicacion||''' ';
                                    
                      va_sql[2] = ' and rc.id_centro_costo = ' || p_id_centro_costo ||'
                                    and rc.id_tabla = ' || p_id_tabla||'
                                    and rc.codigo_aplicacion is null ';               
                                    
                      va_sql[3] = ' and rc.id_centro_costo = ' || p_id_centro_costo ||'
                                    and rc.id_tabla is NULL
                                    and rc.codigo_aplicacion = ''' ||p_aplicacion||''' 
                                    and rc.defecto = ''si'''; 
                  
                      va_sql[4] = ' and rc.id_centro_costo = ' || p_id_centro_costo ||'
                                    and rc.id_tabla is NULL
                                    and rc.codigo_aplicacion is null
                                    and rc.defecto = ''si''';
                 
                 elseif p_tiene_moneda = 'si' and p_id_moneda is not null then 
                 
                      
                      va_sql[1] = ' and rc.id_centro_costo = ' || p_id_centro_costo ||'
                                    and rc.id_tabla = ' || p_id_tabla||'
                                    and rc.id_moneda = '||p_id_moneda;
                      
                      va_sql[2] = ' and rc.id_centro_costo = ' || p_id_centro_costo ||'
                                    and rc.id_tabla = ' || p_id_tabla||'
                                    and rc.id_moneda is null';
                                  
                                  
                      va_sql[3] = ' and rc.id_centro_costo = ' || p_id_centro_costo ||'
                                    and rc.id_tabla is NULL
                                    and rc.id_moneda = '||p_id_moneda||'
                                    and rc.defecto = ''si''';            
                      
                      va_sql[4] = ' and rc.id_centro_costo = ' || p_id_centro_costo ||'
                                    and rc.id_tabla is NULL
                                    and rc.id_moneda is null 
                                    and rc.defecto = ''si''';  
                 
                  
                 
                 else  
                 
                     va_sql[1] = ' and rc.id_centro_costo = ' || p_id_centro_costo ||'
                                   and rc.id_tabla = ' || p_id_tabla;
                  
                     va_sql[2] = ' and rc.id_centro_costo = ' || p_id_centro_costo ||'
                                   and rc.id_tabla is NULL
                                   and rc.defecto = ''si''';
                 
                 end if;
               
          
          	  
                    
          elsif p_tiene_centro_costo = 'si-general' and p_id_centro_costo is not null then
          
                  
                  
                  --recuperamos el tipo del presupuesto
                  SELECT
                     tp.id_tipo_presupuesto
                    into
                      v_id_tipo_presupuesto
                  FROM  pre.tpresupuesto pr
                  join  pre.ttipo_presupuesto tp on tp.codigo = pr.tipo_pres 
                  WHERE  pr.id_presupuesto = p_id_centro_costo::integer;
                  
                  
                   if p_tiene_aplicacion = 'si' and p_sw_ca  then
                       
                       -- primero buscamos para el valor especifico de la tabla con aplicacion
                      
                        va_sql[1] = ' and rc.codigo_aplicacion = ''' ||p_aplicacion||''' 
                                      and rc.id_centro_costo = ' || p_id_centro_costo ||'
                                      and rc.id_tipo_presupuesto is NULL
                                      and rc.id_tabla = ' || p_id_tabla;
                                  
                        
                        va_sql[2] = ' and rc.codigo_aplicacion is null  
                                      and rc.id_centro_costo = ' || p_id_centro_costo ||'
                                      and rc.id_tipo_presupuesto is NULL
                                      and rc.id_tabla = ' || p_id_tabla;          
                        
                        va_sql[3] = ' and rc.codigo_aplicacion = ''' ||p_aplicacion||''' 
                                      and rc.id_centro_costo is NULL
                                      and rc.id_tipo_presupuesto = ' || v_id_tipo_presupuesto ||'
                                      and rc.id_tabla = ' || p_id_tabla; 
                        
                        va_sql[4] = ' and rc.codigo_aplicacion is null  
                                      and rc.id_centro_costo is NULL
                                      and rc.id_tipo_presupuesto = ' || v_id_tipo_presupuesto ||'
                                      and rc.id_tabla = ' || p_id_tabla;              
                                                 
                        
                        va_sql[5] = ' and rc.codigo_aplicacion = ''' ||p_aplicacion||''' 
                                      and rc.id_centro_costo is NULL
                                      and rc.id_tipo_presupuesto is NULL
                                      and rc.id_tabla = ' || p_id_tabla;
                                      
                                      
                         va_sql[6] = ' and rc.codigo_aplicacion is null  
                                       and rc.id_centro_costo is NULL
                                       and rc.id_tipo_presupuesto is NULL
                                       and rc.id_tabla = ' || p_id_tabla;              
                                      
                       -- buscamos despues valores por defecto sin aplicacion
                        
                        va_sql[7] = ' and rc.codigo_aplicacion = ''' ||p_aplicacion||'''
                                      and rc.id_centro_costo = ' || p_id_centro_costo ||'
                                      and rc.id_tipo_presupuesto is NULL
                                      and rc.id_tabla is NULL 
                                      and rc.defecto = ''si''';
                                      
                        va_sql[8] = ' and rc.codigo_aplicacion is null
                                      and rc.id_centro_costo = ' || p_id_centro_costo ||'
                                      and rc.id_tipo_presupuesto is NULL
                                      and rc.id_tabla is NULL 
                                      and rc.defecto = ''si''';              
                                    
                        va_sql[9] = ' and rc.codigo_aplicacion = ''' ||p_aplicacion||'''
                                      and rc.id_centro_costo is NULL
                                      and rc.id_tipo_presupuesto = ' || v_id_tipo_presupuesto ||'
                                      and rc.id_tabla = is NULL 
                                      and rc.defecto = ''si''';            
                        
                        va_sql[10] = ' and rc.codigo_aplicacion is null
                                      and rc.id_centro_costo is NULL
                                      and rc.id_tipo_presupuesto = ' || v_id_tipo_presupuesto ||'
                                      and rc.id_tabla = is NULL 
                                      and rc.defecto = ''si''';
                                      
                                      
                        va_sql[11] = ' and rc.codigo_aplicacion = ''' ||p_aplicacion||'''
                                      and rc.id_centro_costo is NULL
                                      and rc.id_tipo_presupuesto is NULL
                                      and rc.id_tabla is NULL 
                                      and rc.defecto = ''si''';
                                      
                        va_sql[12] = ' and rc.codigo_aplicacion is null
                                      and rc.id_centro_costo is NULL
                                      and rc.id_tipo_presupuesto is NULL
                                      and rc.id_tabla is NULL 
                                      and rc.defecto = ''si''';
                                      
                      
                   
                   elseif p_tiene_moneda = 'si' and p_id_moneda is not null then  
                   
                   -- primero buscamos para el valor especifico de la tabla con MONEDA
                      
                        va_sql[1] = ' and rc.id_moneda = '||p_id_moneda ||'
                                      and rc.id_centro_costo = ' || p_id_centro_costo ||'
                                      and rc.id_tipo_presupuesto is NULL
                                      and rc.id_tabla = ' || p_id_tabla;
                                  
                        
                        va_sql[2] = ' and rc.id_moneda is null   
                                      and rc.id_centro_costo = ' || p_id_centro_costo ||'
                                      and rc.id_tipo_presupuesto is NULL
                                      and rc.id_tabla = ' || p_id_tabla;          
                        
                        va_sql[3] = ' and rc.id_moneda = '||p_id_moneda ||' 
                                      and rc.id_centro_costo is NULL
                                      and rc.id_tipo_presupuesto = ' || v_id_tipo_presupuesto ||'
                                      and rc.id_tabla = ' || p_id_tabla; 
                        
                        va_sql[4] = ' and rc.id_moneda is null   
                                      and rc.id_centro_costo is NULL
                                      and rc.id_tipo_presupuesto = ' || v_id_tipo_presupuesto ||'
                                      and rc.id_tabla = ' || p_id_tabla;              
                                                 
                        
                        va_sql[5] = ' and rc.id_moneda = '||p_id_moneda ||'
                                      and rc.id_centro_costo is NULL
                                      and rc.id_tipo_presupuesto is NULL
                                      and rc.id_tabla = ' || p_id_tabla;
                                      
                                      
                         va_sql[6] = ' and rc.id_moneda is null   
                                       and rc.id_centro_costo is NULL
                                       and rc.id_tipo_presupuesto is NULL
                                       and rc.id_tabla = ' || p_id_tabla;              
                                      
                       -- buscamos despues valores por defecto sin MONEDA
                        
                        va_sql[7] = ' and rc.id_moneda = '||p_id_moneda ||'
                                      and rc.id_centro_costo = ' || p_id_centro_costo ||'
                                      and rc.id_tipo_presupuesto is NULL
                                      and rc.id_tabla is NULL 
                                      and rc.defecto = ''si''';
                                      
                        va_sql[8] = ' and rc.id_moneda is null 
                                      and rc.id_centro_costo = ' || p_id_centro_costo ||'
                                      and rc.id_tipo_presupuesto is NULL
                                      and rc.id_tabla is NULL 
                                      and rc.defecto = ''si''';              
                                    
                        va_sql[9] = ' and rc.id_moneda = '||p_id_moneda ||'
                                      and rc.id_centro_costo is NULL
                                      and rc.id_tipo_presupuesto = ' || v_id_tipo_presupuesto ||'
                                      and rc.id_tabla  is NULL 
                                      and rc.defecto = ''si''';            
                        
                        va_sql[10] = 'and rc.id_moneda is null 
                                      and rc.id_centro_costo is NULL
                                      and rc.id_tipo_presupuesto = ' || v_id_tipo_presupuesto ||'
                                      and rc.id_tabla  is NULL 
                                      and rc.defecto = ''si''';
                                      
                                      
                        va_sql[11] = 'and rc.id_moneda = '||p_id_moneda ||'
                                      and rc.id_centro_costo is NULL
                                      and rc.id_tipo_presupuesto is NULL
                                      and rc.id_tabla is NULL 
                                      and rc.defecto = ''si''';
                                      
                        va_sql[12] = 'and rc.id_moneda is null 
                                      and rc.id_centro_costo is NULL
                                      and rc.id_tipo_presupuesto is NULL
                                      and rc.id_tabla is NULL 
                                      and rc.defecto = ''si''';
                   else 
                   
                       -- primero buscamos para el valor especifico de la tabla
                      
                        va_sql[1] = ' and rc.id_centro_costo = ' || p_id_centro_costo ||'
                                      and rc.id_tipo_presupuesto is NULL
                                      and rc.id_tabla = ' || p_id_tabla;
                                  
                                  
                        va_sql[2] = ' and rc.id_centro_costo is NULL
                                      and rc.id_tipo_presupuesto = ' || v_id_tipo_presupuesto ||'
                                      and rc.id_tabla = ' || p_id_tabla;            
                        
                        va_sql[3] = ' and rc.id_centro_costo is NULL
                                      and rc.id_tipo_presupuesto is NULL
                                      and rc.id_tabla = ' || p_id_tabla;
                                      
                                      
                       -- buscamos despues valores por defecto
                        
                        va_sql[4] = ' and rc.id_centro_costo = ' || p_id_centro_costo ||'
                                      and rc.id_tipo_presupuesto is NULL
                                      and rc.id_tabla is NULL 
                                      and rc.defecto = ''si''';
                                    
                        va_sql[5] = ' and rc.id_centro_costo is NULL
                                      and rc.id_tipo_presupuesto = ' || v_id_tipo_presupuesto ||'
                                      and rc.id_tabla  is NULL 
                                      and rc.defecto = ''si''';            
                        
                        va_sql[6] = ' and rc.id_centro_costo is NULL
                                      and rc.id_tipo_presupuesto is NULL
                                      and rc.id_tabla is NULL 
                                      and rc.defecto = ''si''';
                   
                   end if;
              
              
           elsif p_tiene_centro_costo = 'si-general' and p_id_centro_costo is null then
          
                  
                   if p_tiene_aplicacion = 'si' and p_sw_ca  then
                       
                       -- primero buscamos para el valor especifico de la tabla con aplicacion
                      
                        va_sql[1] = ' and rc.codigo_aplicacion = ''' ||p_aplicacion||''' 
                                      and rc.id_centro_costo = ' || p_id_centro_costo ||'
                                      and rc.id_tipo_presupuesto is NULL
                                      and rc.id_tabla = ' || p_id_tabla;
                                  
                        
                        va_sql[2] = ' and rc.codigo_aplicacion is null  
                                      and rc.id_centro_costo = ' || p_id_centro_costo ||'
                                      and rc.id_tipo_presupuesto is NULL
                                      and rc.id_tabla = ' || p_id_tabla;          
                        
                         
                                                
                        
                        va_sql[3] = ' and rc.codigo_aplicacion = ''' ||p_aplicacion||''' 
                                      and rc.id_centro_costo is NULL
                                      and rc.id_tipo_presupuesto is NULL
                                      and rc.id_tabla = ' || p_id_tabla;
                                      
                                      
                         va_sql[4] = ' and rc.codigo_aplicacion is null  
                                       and rc.id_centro_costo is NULL
                                       and rc.id_tipo_presupuesto is NULL
                                       and rc.id_tabla = ' || p_id_tabla;              
                                      
                       -- buscamos despues valores por defecto sin aplicacion
                        
                        va_sql[5] = ' and rc.codigo_aplicacion = ''' ||p_aplicacion||'''
                                      and rc.id_centro_costo = ' || p_id_centro_costo ||'
                                      and rc.id_tipo_presupuesto is NULL
                                      and rc.id_tabla is NULL 
                                      and rc.defecto = ''si''';
                                      
                        va_sql[6] = ' and rc.codigo_aplicacion is null
                                      and rc.id_centro_costo = ' || p_id_centro_costo ||'
                                      and rc.id_tipo_presupuesto is NULL
                                      and rc.id_tabla is NULL 
                                      and rc.defecto = ''si''';              
                                    
                                   
                                      
                        va_sql[7] = ' and rc.codigo_aplicacion = ''' ||p_aplicacion||'''
                                      and rc.id_centro_costo is NULL
                                      and rc.id_tipo_presupuesto is NULL
                                      and rc.id_tabla is NULL 
                                      and rc.defecto = ''si''';
                                      
                        va_sql[8] = ' and rc.codigo_aplicacion is null
                                      and rc.id_centro_costo is NULL
                                      and rc.id_tipo_presupuesto is NULL
                                      and rc.id_tabla is NULL 
                                      and rc.defecto = ''si''';
                                      
                      
                   
                   elseif p_tiene_moneda = 'si' and p_id_moneda is not null then  
                   
                   -- primero buscamos para el valor especifico de la tabla con MONEDA
                      
                        va_sql[1] = ' and rc.id_moneda = '||p_id_moneda ||'
                                      and rc.id_centro_costo = ' || p_id_centro_costo ||'
                                      and rc.id_tipo_presupuesto is NULL
                                      and rc.id_tabla = ' || p_id_tabla;
                                  
                        
                        va_sql[2] = ' and rc.id_moneda is null   
                                      and rc.id_centro_costo = ' || p_id_centro_costo ||'
                                      and rc.id_tipo_presupuesto is NULL
                                      and rc.id_tabla = ' || p_id_tabla;          
                        
                       
                                
                                                 
                        
                        va_sql[3] = ' and rc.id_moneda = '||p_id_moneda ||'
                                      and rc.id_centro_costo is NULL
                                      and rc.id_tipo_presupuesto is NULL
                                      and rc.id_tabla = ' || p_id_tabla;
                                      
                                      
                         va_sql[4] = ' and rc.id_moneda is null   
                                       and rc.id_centro_costo is NULL
                                       and rc.id_tipo_presupuesto is NULL
                                       and rc.id_tabla = ' || p_id_tabla;              
                                      
                       -- buscamos despues valores por defecto sin MONEDA
                        
                        va_sql[5] = ' and rc.id_moneda = '||p_id_moneda ||'
                                      and rc.id_centro_costo = ' || p_id_centro_costo ||'
                                      and rc.id_tipo_presupuesto is NULL
                                      and rc.id_tabla is NULL 
                                      and rc.defecto = ''si''';
                                      
                        va_sql[6] = ' and rc.id_moneda is null 
                                      and rc.id_centro_costo = ' || p_id_centro_costo ||'
                                      and rc.id_tipo_presupuesto is NULL
                                      and rc.id_tabla is NULL 
                                      and rc.defecto = ''si''';              
                                    
                                                           
                                      
                        va_sql[7] = 'and rc.id_moneda = '||p_id_moneda ||'
                                      and rc.id_centro_costo is NULL
                                      and rc.id_tipo_presupuesto is NULL
                                      and rc.id_tabla is NULL 
                                      and rc.defecto = ''si''';
                                      
                        va_sql[8] = 'and rc.id_moneda is null 
                                      and rc.id_centro_costo is NULL
                                      and rc.id_tipo_presupuesto is NULL
                                      and rc.id_tabla is NULL 
                                      and rc.defecto = ''si''';
                   else 
                   
                       -- primero buscamos para el valor especifico de la tabla
                      
                        va_sql[1] = ' and rc.id_centro_costo = ' || p_id_centro_costo ||'
                                      and rc.id_tipo_presupuesto is NULL
                                      and rc.id_tabla = ' || p_id_tabla;
                                  
                      
                        va_sql[2] = ' and rc.id_centro_costo is NULL
                                      and rc.id_tipo_presupuesto is NULL
                                      and rc.id_tabla = ' || p_id_tabla;
                                      
                                      
                       -- buscamos despues valores por defecto
                        
                        va_sql[3] = ' and rc.id_centro_costo = ' || p_id_centro_costo ||'
                                      and rc.id_tipo_presupuesto is NULL
                                      and rc.id_tabla is NULL 
                                      and rc.defecto = ''si''';
                                    
                                
                        
                        va_sql[4] = ' and rc.id_centro_costo is NULL
                                      and rc.id_tipo_presupuesto is NULL
                                      and rc.id_tabla is NULL 
                                      and rc.defecto = ''si''';
                   
                   end if;
              
              
                  
                 
          
          --si unico sirve para recuperar el centro de costo a partir del dato de la tabla
          
          elsif p_tiene_centro_costo = 'si-unico' then
          
          	 
                 va_sql[1] = ' and rc.id_tabla = ' || p_id_tabla;
                               
                 
                 va_sql[2] = ' and rc.id_tabla is NULL
                              and rc.defecto = ''si''';              
          
          end if;
      
           
    
      return va_sql;


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