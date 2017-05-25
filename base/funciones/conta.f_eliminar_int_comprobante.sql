--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_eliminar_int_comprobante (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_int_comprobante integer,
  p_borrado_manual varchar = 'no'::character varying
)
RETURNS varchar AS
$body$
/*
Autor: RCM
Fecha: 18/11/2013
Descripcion: Funcion para la eliminacion de int comprobante
*/

DECLARE

	v_rec_cbte 							record;
    v_funcion_comprobante_eliminado 	varchar;
    v_resp								varchar;
    v_nombre_funcion   					varchar;
    v_rec_cbte_trans 					record;
    v_conexion							varchar;
    v_sql								varchar;
    v_pre_integrar_presupuestos			varchar;
 
BEGIN
  	
    v_nombre_funcion := 'conta.f_eliminar_int_comprobante';
    v_pre_integrar_presupuestos = pxp.f_get_variable_global('pre_integrar_presupuestos');
	
    select * 
    into v_rec_cbte
    from conta.tint_comprobante
    where id_int_comprobante = p_id_int_comprobante;
        
    --------------------------------------
    -- Si el comprobante esta en borrador
    --------------------------------------
    
    
    IF   v_rec_cbte.estado_reg = 'borrador'  THEN
    
              --borrar documentos WF relacionados
              
              delete from wf.tdocumento_wf wf 
              where wf.id_proceso_wf = v_rec_cbte.id_proceso_wf;
                  
    
               -- verifica que no tenga numero, solo si no es un cbte migrado de la regional
               IF  v_rec_cbte.nro_cbte is not null and   v_rec_cbte.nro_cbte != '' and v_rec_cbte.vbregional != 'si' THEN
                    raise exception 'No puede eliminar cbtes  que ya fueron validados, para no perder la numeración';
               END IF; 
               
               
               
               IF  v_rec_cbte.temporal = 'no'  THEN 
               
                   -- llevar a estado de WF eliminado ...
                   PERFORM conta.f_cambia_estado_wf_cbte(p_id_usuario, p_id_usuario_ai, p_usuario_ai, 
                                                         p_id_int_comprobante, 
                                                         'eliminado', 
                                                          'Cbte eliminado');
               END IF;
                
                
                
                
                
                -- si viene de una plantilla de comprobante busca la funcion de validacion configurada
                 IF v_rec_cbte.id_plantilla_comprobante is not null THEN
                             
                    select 
                    pc.funcion_comprobante_eliminado
                    into v_funcion_comprobante_eliminado
                    from conta.tplantilla_comprobante pc  
                    where pc.id_plantilla_comprobante = v_rec_cbte.id_plantilla_comprobante;
                                
                                
                    EXECUTE ( 'select ' || v_funcion_comprobante_eliminado  ||'('||p_id_usuario::varchar||','||COALESCE(p_id_usuario_ai::varchar,'NULL')||','||COALESCE(''''||p_usuario_ai::varchar||'''','NULL')||','|| p_id_int_comprobante::varchar||')');
                 ELSE                              
                    --si no se tiene una plantilla de comprobante buscamos una funciona de eliminacion  en el cbte
                        
                    IF v_rec_cbte.funcion_comprobante_eliminado  is not NULL  THEN  
                       EXECUTE ( 'select ' || v_rec_cbte.funcion_comprobante_eliminado  ||'('||p_id_usuario::varchar||','||COALESCE(p_id_usuario_ai::varchar,'NULL')||','||COALESCE(''''||p_usuario_ai::varchar||'''','NULL')||','|| p_id_int_comprobante::varchar||')');
                    END IF;
                     
                 END IF;       
   
              -- si es un cbte de reversion reseta la bandera en el original 
              
              
              IF v_rec_cbte.cbte_reversion = 'si' THEN
                 update conta.tint_comprobante set
                    volcado = 'no'
                 where id_int_comprobante =ANY( v_rec_cbte.id_int_comprobante_fks);
              END IF;
    
             
    
              IF v_rec_cbte.vbregional = 'no'  and v_rec_cbte.temporal = 'no'   THEN    
                      
                      --delete transacciones del comprobante intermedio
                      delete from conta.tint_transaccion
                      where id_int_comprobante=p_id_int_comprobante;
                      
                       --se borran las transacciones
                      delete from conta.tint_comprobante
                      where id_int_comprobante=p_id_int_comprobante;
                      
             ELSE   
              
                      -- si el comprobante solo fue originado en la regional internacional
                     IF  v_rec_cbte.temporal = 'no'  THEN 
                          -- eliminamos el cbte en la central
                          delete from conta.tint_transaccion
                          where id_int_comprobante=p_id_int_comprobante;
                          
                          -- Sentencia de la eliminacion
                          delete from conta.tint_comprobante
                          where id_int_comprobante=p_id_int_comprobante;
                          
                          
                     ELSE
                          -- cambio el estado de la bandera de vbregional a no
                          update   conta.tint_comprobante set
                            vbregional = 'no'
                          where id_int_comprobante =    p_id_int_comprobante;
                          
                     END IF;
                     
                     
                     --si es un cbte validao en la regioanl ...
                     IF v_rec_cbte.vbregional = 'si' THEN
                           -----------------------------------------------------------------
                           -- retrocedemos a borrador el cbte de la regional internacional
                           ----------------------------------------------------------------
                           
                           IF  v_rec_cbte.id_int_comprobante_origen_regional is null THEN
                              raise exception 'No se tiene identificado el cbte de la regional internacional';
                           END IF;
                           --prepara consulta
                           v_sql:=  'select conta.f_eliminar_int_comprobante('||
                                             coalesce(p_id_usuario::varchar,'null')||','||
                                             coalesce(p_id_usuario_ai::varchar,'null')||','||
                                             coalesce(''''||p_usuario_ai||'''','null')||','||
                                             coalesce(v_rec_cbte.id_int_comprobante_origen_regional::varchar,'null')||')';
                          
                          
                           -- llamda deblink de la funciona eliminar en la estacion desctino
                           v_conexion =  migra.f_crear_conexion(NULL,'tes.testacion', v_rec_cbte.codigo_estacion_origen);
             
                         
                          IF v_conexion is null or v_conexion = '' THEN
                            raise exception 'No se pudo conectar con la base de datos destino';
                          END IF;
                          
                          -- Ejecuta la fucion que recibe el CBTE en la estacion destino .....
                          perform * from dblink(v_conexion, v_sql, true) as (respuesta varchar);
                          
                          select * into v_resp from migra.f_cerrar_conexion(v_conexion,'exito');
                   END IF;
             
             END IF;
      ELSE
         
         
         
           ------------------------------------------
           -- Si el comprobante  NO esta en borrador
           ------------------------------------------
           
         
           -- validar que no sea un cbte migrado
           IF p_borrado_manual = 'si' and v_rec_cbte.id_int_comprobante_origen_central is not null THEN
              raise exception 'No puede borrar cbtes manual transferidos a la central, solcite en central la eliminación';
           END IF;
         
         
         
           
           --TODO validar que solo un usuario autorizado pueda eliminar comprobantes
          
            -- validar que el periodo contable no este cerrado
           IF not param.f_periodo_subsistema_abierto(v_rec_cbte.fecha::date, 'CONTA') THEN
              raise exception 'El periodo se encuentra cerrado en contabilidad para la fecha:  %',v_rec_cbte.fecha;
           END IF;
          
          -- si viene de una plantilla de comprobante busca la funcion de validacion configurada
           IF v_rec_cbte.id_plantilla_comprobante is not null THEN
                             
              select 
              pc.funcion_comprobante_eliminado
              into v_funcion_comprobante_eliminado
              from conta.tplantilla_comprobante pc  
              where pc.id_plantilla_comprobante = v_rec_cbte.id_plantilla_comprobante;
                                
                                
              EXECUTE ( 'select ' || v_funcion_comprobante_eliminado  ||'('||p_id_usuario::varchar||','||COALESCE(p_id_usuario_ai::varchar,'NULL')||','||COALESCE(''''||p_usuario_ai::varchar||'''','NULL')||','|| p_id_int_comprobante::varchar||')');
           ELSE                              
              --si no se tiene una plantilla de comprobante buscamos una funciona de eliminacion  en el cbte
                        
              IF v_rec_cbte.funcion_comprobante_eliminado  is not NULL  THEN  
                 EXECUTE ( 'select ' || v_rec_cbte.funcion_comprobante_eliminado  ||'('||p_id_usuario::varchar||','||COALESCE(p_id_usuario_ai::varchar,'NULL')||','||COALESCE(''''||p_usuario_ai::varchar||'''','NULL')||','|| p_id_int_comprobante::varchar||')');
              END IF;
                     
           END IF;
          
         
        
          
          -- si se integra con presupeustos, y tiene presupeusto es encesario revertir
          IF v_pre_integrar_presupuestos = 'true'  THEN 
              --  TODO (si tiene presupuesto comprometido REVERTIR, retroceder los planes de pagos)
               raise exception 'no se programo la lógica para eliminar comprobantes validados que tienen presupeusto';
         
          ELSE
            
             --TODO  retroceder ele stado del WF a borrador
             
             
            update conta.tint_comprobante  set
               estado_reg = 'borrador'
            where id_int_comprobante = p_id_int_comprobante;
            
            -- llevar a estado de WF eliminado ...
            PERFORM conta.f_cambia_estado_wf_cbte(p_id_usuario, p_id_usuario_ai, p_usuario_ai, 
                                                  p_id_int_comprobante, 
                                                  'borrador', 
                                                  'devuelto a borrador');
         
         END IF; 
      
      END IF;
    
    
     
     return 'Comprobante eliminado';
EXCEPTION
WHEN OTHERS THEN
	if (current_user like '%dblink_%') then
    	v_resp = pxp.f_obtiene_clave_valor(SQLERRM,'mensaje','','','valor');
        if v_resp = '' then        	
        	v_resp = SQLERRM;
        end if;
    	return 'error' || '#@@@#' || v_resp;        
    else
			v_resp='';
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
			v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
			v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
			raise exception '%',v_resp;
    end if;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;