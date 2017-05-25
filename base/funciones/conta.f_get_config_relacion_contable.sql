--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_get_config_relacion_contable (
  p_codigo varchar,
  p_id_gestion integer,
  p_id_tabla integer = NULL::integer,
  p_id_centro_costo integer = NULL::integer,
  p_mensaje_error varchar = NULL::character varying,
  out ps_id_cuenta integer,
  out ps_id_auxiliar integer,
  out ps_id_partida integer,
  out ps_id_centro_costo integer,
  out ps_nombre_tipo_relacion varchar
)
RETURNS SETOF record AS
$body$
/*
Autor Rensi Arteaga Copari
Fecha 01/07/2013
Descripcion: recupera la la parametrizacion de la relacion contable indicada

ejmplo


 SELECT 
              ps_id_partida ,
              ps_id_cuenta,
              ps_id_auxiliar
            into 
              v_id_partida,
              v_id_cuenta, 
              v_id_auxiliar
          FROM conta.f_get_config_relacion_contable('CUECOMP', v_id_gestion, v_parametros.id_concepto_ingas, v_parametros.id_centro_costo);
          
        
MODIFICACIONES
##############################33
Autor: RCM
Fcha: 26/10/2013
Descripción: Se amplia la funcionalidad para poder obtener la configuración de relaciones contables de tipo arbol de abajo-arriba o arriba-abajo
##################################33
Autor: RAC
Fcha: 26/02/2014
Descripción:  ... 
##################################
Autor: RAC
Fcha: 18/07/2014
Descripción:  Se agregan las opcion de que la relacion contables por tabla tegan el manejo de auxiliar dinamico 
##################################

*/
DECLARE

	v_nombre_funcion varchar;
	v_resp varchar;
	v_registros record;
	v_gestion	varchar;
    v_rec	record;
    v_sw_arb boolean;
    v_sql varchar;
    v_sql1 varchar;
    va_sql varchar[];
	v_sql_arbol varchar;
    v_rec_arbol record;    
    v_rec_rel record;
    v_consulta_auxiliar   varchar;
    v_codigo_auxiliar     varchar;
    v_relacion_tabla      BOOLEAN;

BEGIN


          

    
    v_nombre_funcion:='conta.f_get_config_relacion_contable';
    
     ps_id_cuenta = NULL;
     ps_id_auxiliar=NULL;
     ps_id_partida=NULL;
     v_relacion_tabla = FALSE;
    
    
    --1)  recuperamos el tipo de relacion
    
    SELECT 
      trc.id_tipo_relacion_contable,
      trc.id_tabla_relacion_contable,
      trc.tiene_centro_costo,
      trc.nombre_tipo_relacion
    into 
      v_registros  
    from conta.ttipo_relacion_contable trc 
    where trc.codigo_tipo_relacion = p_codigo 
      and trc.estado_reg = 'activo'; 
      
      
     ps_nombre_tipo_relacion =  v_registros.nombre_tipo_relacion;
      

    
       
      IF   v_registros.id_tipo_relacion_contable is null THEN
      
        raise exception 'El codigo: %, no existe',p_codigo;
      
      END IF;
      
	--2) Se obtienen datos de la relacion contable tabla
    if exists(select 1
              from conta.ttipo_relacion_contable trel
              inner join conta.ttabla_relacion_contable ttab
              on ttab.id_tabla_relacion_contable = trel.id_tabla_relacion_contable
              where trel.id_tipo_relacion_contable = v_registros.id_tipo_relacion_contable
              and (ttab.tabla_id_fk is not null and ttab.tabla_id_fk!='')) then
    	--Enciende la bandera de relacióncontable tipo arbol
    	v_sw_arb = true;
        
    
    
    else
    	--Apaga la bandera de relacióncontable tipo arbol
    	v_sw_arb = false;
    end if;
    
    
    
    
    
     
    

     IF p_id_centro_costo is NULL  and v_registros.tiene_centro_costo != 'si-unico' and  v_registros.tiene_centro_costo != 'no'THEN
                
         raise exception 'El tipooo de relacion relacion contable indica que necesita  centro de costo: % (%)',v_registros.nombre_tipo_relacion,p_codigo;
              
     END IF;
    
   --  preguntamos si el tipo de relacion necesita o no necesita tabla de configuracion

  
   IF  v_registros.id_tabla_relacion_contable is NULL THEN
       --  si no necesita, obtiene el valor para la gestion indica 
       
               IF   v_registros.tiene_centro_costo = 'no' THEN 
                 
                     select
                        rc.id_cuenta,
                        rc.id_auxiliar,
                        rc.id_partida,
                        rc.id_centro_costo
                     into
                        ps_id_cuenta,
                        ps_id_auxiliar,
                        ps_id_partida,
                        ps_id_centro_costo
                     from conta.trelacion_contable rc 
                     where  
                        rc.id_tipo_relacion_contable =  v_registros.id_tipo_relacion_contable
                        and rc.id_gestion = p_id_gestion
                        and rc.estado_reg = 'activo'
                        and rc.id_centro_costo is NULL
                        LIMIT 1  OFFSET 0;
                
              ELSEIF v_registros.tiene_centro_costo = 'si' THEN
                    
                     select
                        rc.id_cuenta,
                        rc.id_auxiliar,
                        rc.id_partida,
                        rc.id_centro_costo
                     into
                        ps_id_cuenta,
                        ps_id_auxiliar,
                        ps_id_partida,
                        ps_id_centro_costo
                     from conta.trelacion_contable rc 
                     where  
                        rc.id_tipo_relacion_contable=  v_registros.id_tipo_relacion_contable
                        and rc.id_gestion = p_id_gestion
                        and rc.estado_reg = 'activo'
                        and rc.id_centro_costo = p_id_centro_costo
                        LIMIT 1  OFFSET 0;
                
                
             ELSEIF v_registros.tiene_centro_costo = 'si-general' THEN
                
           
                  
                  -- es caso de ser si general primero buscamos una configuracion con centro de costos
                  -- si no la encontramos buscamos una general, sin centro de costo (la especifica prevalece sobre la general)
                  
                     select
                        rc.id_cuenta,
                        rc.id_auxiliar,
                        rc.id_partida,
                        rc.id_centro_costo
                     into
                        ps_id_cuenta,
                        ps_id_auxiliar,
                        ps_id_partida,
                        ps_id_centro_costo
                     from conta.trelacion_contable rc 
                     where  
                        rc.id_tipo_relacion_contable=  v_registros.id_tipo_relacion_contable
                        and rc.id_gestion = p_id_gestion
                        and rc.estado_reg = 'activo'
                        and rc.id_centro_costo = p_id_centro_costo
                        LIMIT 1  OFFSET 0;
                  
           
                     IF ps_id_cuenta is NULL THEN
                     --buscamos una configuracion general sin centro de costo
                           select
                              rc.id_cuenta,
                              rc.id_auxiliar,
                              rc.id_partida,
                              rc.id_centro_costo
                           into
                              ps_id_cuenta,
                              ps_id_auxiliar,
                              ps_id_partida,
                              ps_id_centro_costo
                           from conta.trelacion_contable rc 
                           where  
                              rc.id_tipo_relacion_contable =  v_registros.id_tipo_relacion_contable
                              and rc.id_gestion = p_id_gestion
                              and rc.estado_reg = 'activo'
                              and rc.id_centro_costo is NULL
                              LIMIT 1  OFFSET 0;
                      END IF;
                      
                 ELSEIF v_registros.tiene_centro_costo = 'si-unico' THEN 
                 
                    select
                        rc.id_cuenta,
                        rc.id_auxiliar,
                        rc.id_partida,
                        rc.id_centro_costo
                     into
                        ps_id_cuenta,
                        ps_id_auxiliar,
                        ps_id_partida,
                        ps_id_centro_costo
                     from conta.trelacion_contable rc 
                     where  
                        rc.id_tipo_relacion_contable=  v_registros.id_tipo_relacion_contable
                        and rc.id_gestion = p_id_gestion
                        and rc.estado_reg = 'activo'
                        LIMIT 1  OFFSET 0;  
                        
                      IF ps_id_centro_costo  is NULL THEN
                        raise exception 'No se encontro la relación contable %, %',p_codigo, v_registros.nombre_tipo_relacion;
                      END IF;
                  
                      
                 ELSE
                
                   raise exception 'valor para la variable  "tiene_centro_costo" desconocido %',v_registros.tiene_centro_costo;
                
                END IF; 
  ----------------------------------------------------- 
  --  si la tabla de relacion contable es no nula 
  --  tiene varias segun  la tabla
  --------------------------------------------------
   ELSE
              
         --si necesita tabla de configuracion el parametros p_tabla y p_id_tabla no pueden ser nulos
          IF p_id_tabla is NULL THEN
            raise exception 'Para este tipo de relacion contable (%) se necesita indicar la tabla y el id para busquedas',p_codigo;
          END IF;
          
          
          IF p_id_gestion IS NULL THEN
          	raise exception 'No existe el parametro id_gestion';
          END IF;
         
         
          --Consulta general
          v_sql = 'select
                   rc.id_cuenta,
                   rc.id_auxiliar,
                   rc.id_partida,
                   rc.id_centro_costo
                   from conta.trelacion_contable rc 
                   where rc.id_tipo_relacion_contable = ' || v_registros.id_tipo_relacion_contable || '
                   and rc.id_gestion = ' || p_id_gestion || '
                   and rc.estado_reg = ''activo''';

          if v_registros.tiene_centro_costo = 'no' then
          
          	  va_sql[1] = ' and rc.id_centro_costo is NULL
              			  and rc.id_tabla = ' || p_id_tabla;
              
              va_sql[2] = ' and rc.id_centro_costo is NULL
                          and rc.id_tabla is NULL
                          and rc.defecto = ''si''';
          
          elsif v_registros.tiene_centro_costo = 'si' then
          
          	  va_sql[1] = ' and rc.id_centro_costo = ' || p_id_centro_costo ||'
                      	  and rc.id_tabla = ' || p_id_tabla;
              
              va_sql[2] = ' and rc.id_centro_costo = ' || p_id_centro_costo ||'
                          and rc.id_tabla is NULL
                          and rc.defecto = ''si''';
                    
          elsif v_registros.tiene_centro_costo = 'si-general' then
          
          	  va_sql[1] = ' and rc.id_centro_costo = ' || p_id_centro_costo ||'
              			  and rc.id_tabla = ' || p_id_tabla;
              
              va_sql[2] = ' and rc.id_centro_costo is NULL
                          and rc.id_tabla = ' || p_id_tabla;
              
              va_sql[3] = ' and rc.id_centro_costo = ' || p_id_centro_costo ||'
                          and rc.id_tabla is NULL 
                          and rc.defecto = ''si''';
              
              va_sql[4] = ' and rc.id_centro_costo is NULL
                          and rc.id_tabla is NULL 
                          and rc.defecto = ''si''';
          
          --si unico sirce para recuperar el centro de costo a partir del dato de la tabla
          
          elsif v_registros.tiene_centro_costo = 'si-unico' then
          
          	 
             va_sql[1] = ' and rc.id_tabla = ' || p_id_tabla;
                           
             
             va_sql[2] = ' and rc.id_tabla is NULL
                          and rc.defecto = ''si''';              
          
          end if;
          --    raise exception 'CON: %',v_sql || va_sql[1] || ' limit 1 offset 0';
          
          --Obtiene datos de larelación contable de tipo árbol
        
        select
        lower(ttab.esquema) || '.' || lower(ttab.tabla) as tabla,
        ttab.tabla_id, 
        ttab.tabla_id_fk, 
        ttab.recorrido_arbol,
        ttab.tabla_codigo_auxiliar,
        ttab.tabla_id_auxiliar,
        trel.tiene_auxiliar
        into v_rec
        from conta.ttipo_relacion_contable trel
        inner join conta.ttabla_relacion_contable ttab
        on ttab.id_tabla_relacion_contable = trel.id_tabla_relacion_contable
        where trel.id_tipo_relacion_contable = v_registros.id_tipo_relacion_contable;
        
        
          -----------------------------------------
          --Ejecuta la consulta  ripo ARBOL --RCM
          ----------------------------------------------
          if v_sw_arb then
          
         
          
                    v_sql_arbol = 'WITH RECURSIVE t(id,id_fk,n) AS (
                                  SELECT l.'|| v_rec.tabla_id || ',l.'|| v_rec.tabla_id_fk ||',1
                                  FROM ' || v_rec.tabla || ' l
                                  WHERE l.' || v_rec.tabla_id || '= ' || p_id_tabla || '
                                  UNION ALL
                                  SELECT l.' || v_rec.tabla_id || ',l.' || v_rec.tabla_id_fk || ',n+1
                                  FROM ' || v_rec.tabla ||' l, t
                                  WHERE l.' || v_rec.tabla_id || ' = t.id_fk
                              )
                              SELECT *
                              FROM t
                              ORDER BY n '||coalesce(v_rec.recorrido_arbol,'asc');
                    
                    
                     
                    	
                    --Recorre el arbol en la dirección especificada y salta a la primera ocurrencia
                    for v_rec_arbol in execute(v_sql_arbol) loop
                    	
                    
                        --Define las condiciones por el centro de costo
                        if v_registros.tiene_centro_costo = 'no' then
                
                            va_sql[1] = ' and rc.id_centro_costo is NULL
                                        and rc.id_tabla = ' || v_rec_arbol.id;
                            va_sql[2] = ' and rc.id_centro_costo is NULL
                                        and rc.id_tabla is NULL
                                        and rc.defecto = ''si''';
                        
                        elsif v_registros.tiene_centro_costo = 'si' then
                        
                            va_sql[1] = ' and rc.id_centro_costo = ' || p_id_centro_costo ||'
                                        and rc.id_tabla = ' || v_rec_arbol.id;
                            va_sql[2] = ' and rc.id_centro_costo = ' || p_id_centro_costo ||'
                                        and rc.id_tabla is NULL
                                        and rc.defecto = ''si''';
                                  
                        elsif v_registros.tiene_centro_costo = 'si-general' then
                        
                            va_sql[1] = ' and rc.id_centro_costo = ' || p_id_centro_costo ||'
                                        and rc.id_tabla = ' || v_rec_arbol.id;
                            va_sql[2] = ' and rc.id_centro_costo is NULL
                                        and rc.id_tabla = ' || v_rec_arbol.id;
                            va_sql[3] = ' and rc.id_centro_costo = ' || p_id_centro_costo ||'
                                        and rc.id_tabla is NULL 
                                        and rc.defecto = ''si''';
                            va_sql[4] = ' and rc.id_centro_costo is NULL
                                        and rc.id_tabla is NULL 
                                        and rc.defecto = ''si''';
                        
                        elsif v_registros.tiene_centro_costo = 'si-unico' then
                        
                            va_sql[1] = ' and rc.id_tabla = ' || v_rec_arbol.id;
                        
                        end if;
                        
                       
                        
                        --Recorre el array de condiciones para encontrar cuenta, partida y auxiliar en en el nivel del árbol
                        for i in 1..array_upper(va_sql,1) loop
                            v_sql1 = v_sql || va_sql[i] || ' limit 1 offset 0';
                            --raise notice '==================>>>>>>>>>>>>>>>>>>>>>>>>>%  %',i,v_sql1;
                            if p_codigo = 'SALALM' and v_rec_arbol.id = 1 then
                              raise notice '###########################%  %  %',v_rec_arbol.id,p_id_centro_costo,p_id_centro_costo;
                            end if;
                            for v_rec_rel in execute(v_sql1) loop
                                ps_id_cuenta = v_rec_rel.id_cuenta;
                                ps_id_auxiliar = v_rec_rel.id_auxiliar;
                                ps_id_partida = v_rec_rel.id_partida;
                                ps_id_centro_costo = v_rec_rel.id_centro_costo;
                            end loop;
                            
                            if ps_id_cuenta is not null then
                                --Salir del for
                                exit;
                            end if;		
                            
                        end loop;
                        
                        if ps_id_cuenta is not null then
                                --Salir del for
                                return next;
                        end if;
                        
                       
                    
                    
                    end loop;
                    
                    
                    
                    if ps_id_cuenta is null then
                        
                        select gestion into v_gestion
                        from param.tgestion
                        where id_Gestion = p_id_gestion;
                        
                        raise exception '% (% - %) No se encuentra Cuenta para la Gestión % (tiene_centro_costo = %) - Centro de costo: %',COALESCE(p_mensaje_error,''),p_codigo,v_registros.nombre_tipo_relacion,v_gestion,v_registros.tiene_centro_costo,COALESCE(p_id_centro_costo,'0');
                    end if;		
          
          
              
        ---------------------------------------------       
        --si la relacion contable no es un arbol
        -----------------------------------------------
        else

                  for i in 1..array_upper(va_sql,1) loop
                      v_sql1 = v_sql || va_sql[i] || ' limit 1 offset 0';
        		  	  
                      for v_rec_rel in execute(v_sql1) loop
                          ps_id_cuenta = v_rec_rel.id_cuenta;
                          ps_id_auxiliar = v_rec_rel.id_auxiliar;
                          ps_id_partida = v_rec_rel.id_partida;
                          ps_id_centro_costo = v_rec_rel.id_centro_costo;
                      end loop;
                      
                      if ps_id_cuenta is not null then
                          --Salir del for
                          exit;
                      end if;		
                      
                  end loop;

              --si la relacion contable es para encontrat departamentos
              --  no es obigatorio que regreuna cuenta contable
                 IF v_registros.tiene_centro_costo != 'si-unico' THEN

                        if ps_id_cuenta is null then
                        
                              select gestion into v_gestion
                              from param.tgestion
                              where id_gestion = p_id_gestion;
                              raise exception '% (% - %) No se encuentra Cuenta para la Gestión % (tiene_centro_costo = %) - Centro de costo: %',COALESCE(p_mensaje_error,''), p_codigo,v_registros.nombre_tipo_relacion,v_gestion,v_registros.tiene_centro_costo,COALESCE(p_id_centro_costo,'0');
                        end if;
                  
                 ELSE
                 
                        if ps_id_centro_costo is null then
                   
                           select gestion into v_gestion
                           from param.tgestion
                           where id_gestion = p_id_gestion;
                       	 
                           raise exception '% (% - %) No se encuentra Centro de costo para  la Gestión % (tiene_centro_costo = %) - Centro de costo: %',COALESCE(p_mensaje_error,''),p_codigo,v_registros.nombre_tipo_relacion,v_gestion,v_registros.tiene_centro_costo,COALESCE(p_id_centro_costo,'0');
                        
                        end if;
                 
                 END IF;
              
          end if;
          /*
          IF p_codigo = 'PAGOANT' THEN
              raise exception 'bbbbbbb';
          END IF;*/
    
          
          --si es de auxiliar dinamico accedemos a la tabla	
          IF v_rec.tiene_auxiliar = 'dinamico' and ps_id_auxiliar  is NULL  THEN
               
                      
                      IF v_rec.tabla_codigo_auxiliar is not null and v_rec.tabla_codigo_auxiliar != '' THEN
                           --si no dan un codigo buscamos el id auxiliar usandolo como forenckey 
                            
                            v_consulta_auxiliar = 'select 
                                                   tt.'||v_rec.tabla_codigo_auxiliar||' as codigo_auxiliar,
                                                   aux.id_auxiliar as id_auxiliar
                                                 from '||v_rec.tabla||' tt
                                                 inner join conta.tauxiliar aux on aux.codigo_auxiliar = tt.'||v_rec.tabla_codigo_auxiliar||'
                                                 where   tt.'||v_rec.tabla_id||' = '||p_id_tabla::varchar;
                       
              
          
                      ELSE
               
                         IF v_rec.tabla_id_auxiliar is not NULL and  TRIM(v_rec.tabla_id_auxiliar) !='' THEN
                          
                              v_consulta_auxiliar = 'select 
                                                       tt.'||v_rec.tabla_id_auxiliar ||' as id_auxiliar
                                                     from '||v_rec.tabla||' tt
                                                     where   tt.'||v_rec.tabla_id||' = '||p_id_tabla::varchar;
                          ELSE
                             
                              raise exception 'Falta parametros para la configuracion de auxiliar dinamico de la tabla %',v_rec.tabla;
                          
                          END IF;
                            
                      END IF;
                        
                        --raise exception 'bbbbbbb    %',v_consulta_auxiliar;
                    
                         for v_rec_rel in execute(v_consulta_auxiliar) loop
                                    v_codigo_auxiliar = v_rec_rel.codigo_auxiliar;
                                    ps_id_auxiliar = v_rec_rel.id_auxiliar;
                         end loop;
                         
                         
                       IF v_rec_rel.id_auxiliar is NULL THEN             
                           raise exception '%  La relacion (%) no tiene configurado un  auxiliar',COALESCE(p_mensaje_error,''),v_rec.tabla;
                       END IF;  
                     
                          
                     
           END IF;
         	
   END IF;
   

return NEXT;
return;

   
EXCEPTION
	WHEN OTHERS THEN 
			v_resp='';
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM||' - '||COALESCE(p_codigo,'-')::text);
			v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
			v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
			raise exception '%',v_resp;
END;
$body$
LANGUAGE 'plpgsql'
STABLE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100 ROWS 1;