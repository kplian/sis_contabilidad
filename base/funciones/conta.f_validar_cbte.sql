--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_validar_cbte (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_int_comprobante integer,
  p_igualar varchar = 'no'::character varying,
  p_origen varchar = 'pxp'::character varying,
  p_fecha_ejecucion date = NULL::date
)
RETURNS varchar AS
$body$
/*
	Autor: RCM
    Fecha: 05-09-2013
    Descripción: Función que se encarga de verificar la integridad del comprobante para posteriormente validarlo.
*/
DECLARE

	v_debe			numeric;
    v_haber			numeric;
    v_errores 		varchar;
    v_rec_cbte 		record;
    v_doc			varchar;
    v_nro_cbte		varchar;
    v_id_periodo 	integer;
    v_filas			bigint;
    v_resp			varchar;
    v_nombre_funcion   varchar;
    v_funcion_comprobante_validado  varchar;
    v_variacion         numeric;
     

BEGIN

 

     v_nombre_funcion:='conta.f_validar_cbte';
    --raise exception 'Error al Validar Comprobante: comprobante no está en Borrador o en Edición';	
	v_errores = '';
    
    
     --si el origen es endesis confiamos en las validaciones
    if p_origen  = 'endesis' then
    
          --si el comprobante viene de endesis y tenemso fecha de ejecucion actualizamos la fecha del comprobante intermedio
         IF p_fecha_ejecucion is NULL THEN
         
              update conta.tint_comprobante set
                fecha = p_fecha_ejecucion
              where id_int_comprobante = p_id_int_comprobante;
         
         END IF;
    
    end if;
	
	
    
    
    --1. Verificar existencia del comprobante
    if not exists(select 1 from conta.tint_comprobante
    			where id_int_comprobante = p_id_int_comprobante
                and estado_reg in ('borrador')) then
    	raise exception 'Error al Validar Comprobante: comprobante no está en Borrador o en Edición';
    end if;
    	
    --2. Obtención de datos del comprobante
    select * 
	into v_rec_cbte
    from conta.tint_comprobante
    where id_int_comprobante = p_id_int_comprobante;
    
    --Verificación de existencia de al menos 2 transacciones
    select coalesce(count(id_int_transaccion),0)
    into v_filas
    from conta.tint_transaccion
    where id_int_comprobante = p_id_int_comprobante;
    
    if v_filas < 2 then
    	raise exception 'Validación no realizada: el comprobante debe tener al menos dos transacciones';
    end if;
    
    --3. Verifica igualdad del debe y del haber
    select sum(tra.importe_debe), sum(tra.importe_haber)
    into v_debe, v_haber
    from conta.tint_transaccion tra
    where tra.id_int_comprobante = p_id_int_comprobante;
    
    v_variacion = v_debe - v_haber;
    
   -- raise exception 'variacion %', v_variacion ;
    
    if v_debe < v_haber then
       v_variacion = v_haber - v_debe;
    elsif v_debe > v_haber then
       v_variacion = v_debe - v_haber;
    end if;
    
    --si el origen es endesis confiamos en las validaciones
    if p_origen != 'endesis' then
        
        if p_igualar = 'no' and  v_variacion != 0  then
             
             v_errores = 'El comprobante no iguala: Diferencia '||v_haber-v_debe;
       
        else
         
              -- TODO obtener la ventana de error de las variables globales
              if  v_variacion  > 0.3 then
                 v_errores = 'No podemos igualar un comprobante con una variación mayor a: '||v_haber-v_debe;
              else
              
              IF v_variacion != 0 THEN
                 -- TODO --  funcion que agerga  transacciones de diferencia por redondeo 
                  v_errores = 'no implementado';
              
              ELSE 
              
               raise exception 'No se pueden validar comprobantes desde PXP en BOA';
              
              END IF;
          
          
          end if;
        end if;
        
       
     
     end if;
    
  
    --4. Verificación de igualdad del gasto y recurso
    
    
    --5. Ejecución del presupuesto si corresponde
    
   
    --6. Numeración del comprobante
    if v_errores = '' then
    	--Obtiene el documento para la numeración
        select doc.codigo
        into v_doc
        from conta.tclase_comprobante ccbte
        inner join param.tdocumento doc
        on doc.id_documento = ccbte.id_documento
        where ccbte.id_clase_comprobante = v_rec_cbte.id_clase_comprobante;
        
        --Se obtiene el periodo
        select po_id_periodo 
        into v_id_periodo
        from param.f_get_periodo_gestion(v_rec_cbte.fecha);
        
      
        
        --Obtención del número de comprobante
        v_nro_cbte =  param.f_obtener_correlativo(
                   v_doc, 
                   v_id_periodo,-- par_id, 
                   NULL, --id_uo 
                   v_rec_cbte.id_depto,    -- id_depto
                   p_id_usuario, 
                   'CONTA', 
                   NULL);
	
    	
        --Se guarda el número del comprobante y se cambia el estado a validado
        update conta.tint_comprobante set
        nro_cbte = v_nro_cbte,
        estado_reg = 'validado'
        where id_int_comprobante = p_id_int_comprobante;
        
        --7. Replicación del comprobante hacia las estructuras destino
        v_resp = conta.f_replicar_cbte(p_id_usuario,p_id_int_comprobante);
        
        
      
        
       -- 8 si viene de una plantilla de comprobante busca la funcion de validacion configurada
       
       IF v_rec_cbte.id_plantilla_comprobante is not null THEN
       
          select 
           pc.funcion_comprobante_validado
          into v_funcion_comprobante_validado 
          from conta.tplantilla_comprobante pc  
          where pc.id_plantilla_comprobante = v_rec_cbte.id_plantilla_comprobante;
          
          
          -- raise exception 'validar comprobante pxp %',v_funcion_comprobante_validado ;
        	 
          EXECUTE ( 'select ' || v_funcion_comprobante_validado  ||'('||p_id_usuario::varchar||','||COALESCE(p_id_usuario_ai::varchar,'NULL')||','||COALESCE(''''||p_usuario_ai::varchar||'''','NULL')||','|| p_id_int_comprobante::varchar||')');
                             
		          
       
       
       END IF;
       
      
       
        
       
        --9. Valifacion presupuestaria del comprobante
        
       
        v_resp =  conta.f_gestionar_presupuesto_cbte(p_id_usuario,p_id_int_comprobante,'no',p_fecha_ejecucion);
       
    
    
        
    else
    	
    	raise exception 'Validación no realizada: %', v_errores;
    end if;
    
    --8. Respuesta
    return 'Comprobante validado';

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