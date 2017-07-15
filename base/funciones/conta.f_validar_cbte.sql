--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_validar_cbte (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_int_comprobante integer,
  p_igualar varchar = 'no'::character varying,
  p_origen varchar = 'pxp'::character varying,
  p_fecha_ejecucion date = NULL::date,
  p_validar_doc boolean = true
)
RETURNS varchar AS
$body$
/*
	Autor: RCM
    Fecha: 05-09-2013
    Descripción: Función que se encarga de verificar la integridad del comprobante para posteriormente validarlo.
    
    -------------------- Ediciones
    AUTOR: RAC KPLIAN
    FECHA: 2015
    DESCRIPCION   Ejecucion presupeustaria, Integracion con ENDESIS -> PXP
    
     -------------------- Ediciones
    AUTOR: RAC KPLIAN
    FECHA: 20/11/2016
    DESCRIPCION   Se invirte la migraicon de cbte PXP -> ENDESIS
    
    
   -------------------- Ediciones
    AUTOR: RAC KPLIAN
    FECHA: 22/12/2016
    DESCRIPCION   validacion de numeracion en cbtes
    
  
    -------------------- Ediciones
    AUTOR: RAC KPLIAN
    FECHA: 13/06/2017
    DESCRIPCION   validacion de documentos asocidos de compra o de venta  
    
    
    
    
*/
DECLARE

	v_debe			numeric;
    v_haber			numeric;
    v_errores 		varchar;
    v_rec_cbte 		record;
    v_registros		record;
    v_doc			varchar;
    v_codigo_clase_cbte			varchar;
    v_nro_cbte		varchar;
    v_id_periodo 	integer;
    v_filas			bigint;
    v_resp			varchar;
    v_nombre_funcion   				varchar;
    v_funcion_comprobante_validado  varchar;
    v_funcion_comprobante_prevalidado  varchar;
    v_funcion_comprobante_editado   varchar;
    v_variacion        				numeric;
    v_nombre_conexion				varchar;
    v_conexion_int_act				varchar;
    v_sincronizar					varchar;
    v_pre_integrar_presupuestos		varchar;
    v_conta_integrar_libro_bancos	varchar;
    v_resp_int_endesis 				varchar;
    v_conta_codigo_estacion			varchar;
    v_sincornizar_central			varchar;
    
    
    v_debe_mb						numeric;
    v_haber_mb						numeric;
    v_debe_mt						numeric;
    v_haber_mt						numeric;
    v_variacion_mb					numeric;
    v_variacion_mt					numeric;
    v_sw_rel						boolean;
    v_id_tipo_estado				integer;
    v_id_estado_actual 				integer;
    v_tiene_apertura				varchar;
    
    v_gasto 						numeric;
    v_recurso 						numeric;
    v_gasto_mb 						numeric;
    v_recurso_mb 					numeric;
    v_gasto_mt						numeric; 
    v_recurso_mt 					numeric;
    v_resp_val_doc					varchar[];
     

BEGIN

 

    v_nombre_funcion:='conta.f_validar_cbte';
    v_pre_integrar_presupuestos = pxp.f_get_variable_global('pre_integrar_presupuestos');
    v_conta_codigo_estacion = pxp.f_get_variable_global('conta_codigo_estacion');
    v_sincornizar_central = pxp.f_get_variable_global('sincronizar_central');
    v_sincronizar = pxp.f_get_variable_global('sincronizar');
    --raise exception 'Error al Validar Comprobante: comprobante no está en Borrador o en Edición';	
	v_errores = '';
    
    
    -- Obtención de datos del comprobante
    select 
        c.*, 
        c.temporal,
        c.vbregional,
        c.tipo_cambio,
        c.id_moneda,
        p.id_gestion ,
        c.id_int_comprobante_origen_central,
        c.origen,
        c.sw_editable,
        c.nro_cbte,
        c.codigo_estacion_origen,
        c.localidad,
        c.id_ajuste,
        c.cbte_reversion,
        c.id_proceso_wf,
        c.nro_tramite,
        c.id_estado_wf,
        c.estado_reg,
        c.id_depto,
        c.id_clase_comprobante,
        c.fecha,
        c.id_periodo,
        cc.id_documento   --documento con que se genera la numeracion
        
	  into 
        v_rec_cbte
    from conta.tint_comprobante c
    inner join conta.tclase_comprobante cc on cc.id_clase_comprobante = c.id_clase_comprobante
    inner join param.tperiodo p on p.id_periodo = c.id_periodo
    where id_int_comprobante = p_id_int_comprobante;
    
    ------------------------------------------------------------------------------------------
    --  Verifica si los cbte de diario cuadran con los dosc/fact/recibos/invoices registrados
    -------------------------------------------------------------------------------------------
    
     v_resp_val_doc =  conta.f_validar_cbte_docs(p_id_int_comprobante, p_validar_doc);
     
     IF v_resp_val_doc[1] = 'FALSE' THEN
       return v_resp_val_doc[2];       
     END IF;
    
   
     --Obtiene el documento para la numeración
    select 
       doc.codigo,
       ccbte.codigo,
       ccbte.tiene_apertura
    into 
      v_doc,
      v_codigo_clase_cbte,
      v_tiene_apertura
    from conta.tclase_comprobante ccbte
    inner join param.tdocumento doc
    on doc.id_documento = ccbte.id_documento
    where ccbte.id_clase_comprobante = v_rec_cbte.id_clase_comprobante;
   
    
    --  si  es un comprobante que se migrara a la central, abrimos conexion  (
    --  esto quiere decir que estamos en una regional internacional y se migrara al pxp central
    if v_sincornizar_central = 'true' then
    
          --si el comprobante viene de endesis y tenemso fecha de ejecucion actualizamos la fecha del comprobante intermedio
         IF p_fecha_ejecucion is NOT NULL THEN
         
              update conta.tint_comprobante set
                fecha = p_fecha_ejecucion
              where id_int_comprobante = p_id_int_comprobante;
         
         END IF;
    end if;
    
    
    -- TODO revisar cuando abrir conexion ....
    --abrimo conexion dblink
    IF v_conta_codigo_estacion != 'CENTRAL'  or v_sincronizar = 'true' THEN
        select * into v_nombre_conexion from migra.f_crear_conexion(); 
    END IF;
     
    
	
    -- si es un comprobante editado internacionales , abrimos una segunda conexion 
    -- TODO,...para que ???
  
    IF v_rec_cbte.sw_editable = 'si' and  v_rec_cbte.vbregional = 'si' and  v_conta_codigo_estacion = 'CENTRAL' and v_rec_cbte.localidad != 'nacional'  THEN
         v_conexion_int_act = migra.f_crear_conexion(NULL,'tes.testacion', v_rec_cbte.codigo_estacion_origen);
    END IF;
    
    
    
    --validar que el periodo al que se agregara este abierto
    IF not param.f_periodo_subsistema_abierto(v_rec_cbte.fecha::date, 'CONTA') THEN
        raise exception 'El periodo se encuentra cerrado en contabilidad para la fecha:  %',v_rec_cbte.fecha;
    END IF;
    
    
    --Verificación de existencia de al menos 2 transacciones
    select coalesce(count(id_int_transaccion),0)
    into v_filas
    from conta.tint_transaccion
    where id_int_comprobante = p_id_int_comprobante;
    
    if v_filas < 2 then
    	raise exception 'Validación no realizada: el comprobante debe tener al menos dos transacciones';
    end if;
    
    
    --se ejecuta funcion de prevalidacion si existe
    IF v_rec_cbte.id_plantilla_comprobante is not null THEN
           
                select 
                 pc.funcion_comprobante_prevalidado
                into v_funcion_comprobante_prevalidado 
                from conta.tplantilla_comprobante pc  
                where pc.id_plantilla_comprobante = v_rec_cbte.id_plantilla_comprobante;
                
                IF  v_funcion_comprobante_prevalidado is not null and v_funcion_comprobante_prevalidado != '' THEN
                   EXECUTE ( 'select ' || v_funcion_comprobante_prevalidado  ||'('||p_id_usuario::varchar||','||COALESCE(p_id_usuario_ai::varchar,'NULL')||','||COALESCE(''''||p_usuario_ai::varchar||'''','NULL')||','|| p_id_int_comprobante::varchar||', '||COALESCE('''' || v_nombre_conexion || '''','NULL')||')');
                END IF;                    
    END IF;
    
    
    --------------------------------------------------------------------------
    --  Verificar igualdad entre todas las monedas
    --  transaccional, base y triangulacion 
    --  detectar diferencia por redondedo o por diferencia de cambio
    --------------------------------------------------------------------------
    
    --3. Verifica igualdad del debe y del haber
    select 
         sum(tra.importe_debe), 
         sum(tra.importe_haber),
         sum(tra.importe_debe_mb), 
         sum(tra.importe_haber_mb),
         sum(tra.importe_debe_mt), 
         sum(tra.importe_haber_mt),
         sum(tra.importe_gasto), 
         sum(tra.importe_recurso),
         sum(tra.importe_gasto_mb), 
         sum(tra.importe_recurso_mb),
         sum(tra.importe_gasto_mt), 
         sum(tra.importe_recurso_mt)
    into 
       v_debe, 
       v_haber,
       v_debe_mb, 
       v_haber_mb,
       v_debe_mt, 
       v_haber_mt,
       v_gasto, 
       v_recurso,
       v_gasto_mb, 
       v_recurso_mb,
       v_gasto_mt, 
       v_recurso_mt
    from conta.tint_transaccion tra
    where tra.id_int_comprobante = p_id_int_comprobante;
    
 
    if v_debe < v_haber then
       v_variacion = v_haber - v_debe;
    elsif v_debe > v_haber then
       v_variacion = v_debe - v_haber;
    end if;
    
    if v_debe_mb < v_haber_mb then
       v_variacion_mb = v_haber_mb - v_debe_mb;
    elsif v_debe_mb > v_haber_mb then
       v_variacion_mb =  v_debe_mb - v_haber_mb;
    end if;
    
     if v_debe_mt < v_haber_mt then
       v_variacion_mt = v_haber_mt - v_debe_mt;
    elsif v_debe_mt > v_haber_mt then
       v_variacion_mt = v_debe_mt -  v_haber_mt;
    end if;
    
    
    if  v_variacion != 0  then
         v_errores = 'El comprobante no iguala: Diferencia '||v_variacion::varchar;
    end if;
            
    if  v_variacion_mb != 0  then
         v_errores = 'El comprobante no iguala en moneda base: Diferencia '||v_variacion_mb::varchar;
    end if;
            
    if  v_variacion_mt != 0  then
        v_errores = 'El comprobante no iguala en moneda de triangulación: Diferencia  '||v_variacion_mt::varchar;
    end if;
    
    --verifica los monstos presupuestarios
    
    if v_gasto < v_recurso then
       v_variacion = v_recurso - v_gasto;
    elsif v_gasto > v_recurso then
       v_variacion = v_gasto - v_recurso;
    end if;
    
    if v_gasto_mb < v_recurso_mb then
       v_variacion_mb = v_recurso_mb - v_gasto_mb;
    elsif v_gasto_mb > v_recurso_mb then
       v_variacion_mb =  v_gasto_mb - v_recurso_mb;
    end if;
    
     if v_gasto_mt < v_recurso_mt then
       v_variacion_mt = v_recurso_mt - v_gasto_mt;
    elsif v_gasto_mt > v_recurso_mt then
       v_variacion_mt = v_gasto_mt -  v_recurso_mt;
    end if;
    
    
    if  v_variacion != 0  then
         v_errores = 'El comprobante no iguala presupuestariamente: Diferencia '||v_variacion::varchar;
    end if;
            
    if  v_variacion_mb != 0  then
         v_errores = 'El comprobante no iguala presupuestariamente en moneda base: Diferencia '||v_variacion_mb::varchar;
    end if;
            
    if  v_variacion_mt != 0  then
        v_errores = 'El comprobante no iguala presupuestariamente en moneda de triangulación: Diferencia  '||v_variacion_mt::varchar;
    end if;
                  
    
    ---------------------------------------------------------------------------------------------------------
    --  Llamar a funcion de comprobante editado, 
    --  es la pirmera vez que se valida solo si no tenemos numero de cbte
    --  (por ejm esta llamada se usa en tesorera para revertir el presupuesto comprometido originamente)
    ---------------------------------------------------------------------------------------------------------
    
   
    IF   v_rec_cbte.sw_editable = 'si' and  (v_rec_cbte.nro_cbte is null or v_rec_cbte.nro_cbte = '' )   THEN
          
          IF v_rec_cbte.id_plantilla_comprobante is not null THEN
          
                --obtener configuracion de la plantillasi existe 
                select 
                  pc.funcion_comprobante_editado
                into 
                  v_funcion_comprobante_editado 
                from conta.tplantilla_comprobante pc  
                where pc.id_plantilla_comprobante = v_rec_cbte.id_plantilla_comprobante; 
               
              IF v_funcion_comprobante_editado is not null and v_funcion_comprobante_editado != '' THEN 
                  EXECUTE ( 'select ' ||v_funcion_comprobante_editado  ||'('||p_id_usuario::varchar||','||COALESCE(p_id_usuario_ai::varchar,'NULL')||','||COALESCE(''''||p_usuario_ai::varchar||'''','NULL')||','|| p_id_int_comprobante::varchar||', '||COALESCE('''' || v_nombre_conexion || '''','NULL')||')');
              END IF; 
                                        
         END IF;
    
    END IF;
    
    ------------------------------------------------------------------------------------------------
    --  Validacion presupuestaria del comprobante no se ejecuta solo verifica 
    --  si el dinero comprometido o devengado es suficiente para proseguir con la transaccion
    -----------------------------------------------------------------------------------------------
    
     --solo verifica en cbte que no son de reversion
     
     -- RAC 19/06/2017
     -- ESTA VALIDACION ERA NECESARIA EN ENDESIS
     -- al separar el sistema de presupuesto ya no es necesaria
     
    -- IF v_pre_integrar_presupuestos = 'true' and  v_rec_cbte.cbte_reversion ='no'   THEN          
    --  	v_resp =  conta.f_verificar_presupuesto_cbte(p_id_usuario,p_id_int_comprobante,'no',p_fecha_ejecucion,v_nombre_conexion);
    -- END IF;
     
       
     
     
     
     
  
   
    --6. Numeración del comprobante
    if v_errores = '' then
    	
           
            
            --Se obtiene el periodo
            select po_id_periodo 
            into v_id_periodo
            from param.f_get_periodo_gestion(v_rec_cbte.fecha);
           
           -----------------------------------------
           --  Validaciones de cbte de apertura
           -----------------------------------------
           IF  v_rec_cbte.cbte_apertura = 'si'  THEN
               --si es comprobnate de apertura , validamos que no  exista otro ya validado para  la gestion y departamento
            
               IF  EXISTS (select 1 from conta.tint_comprobante c 
                           inner join param.tperiodo p on p.id_periodo = c.id_periodo
                           where     c.id_depto = v_rec_cbte.id_depto 
                                 and c.cbte_apertura = 'si' 
                                 and c.estado_reg = 'validado' and p.id_gestion = v_rec_cbte.id_gestion)  THEN
                                 
                    raise exception 'ya existe un comprobante de apertura validado para este departamento en esta gestion';
               END IF;
               
               --valida que sea el primer dia del mes
               IF to_char(v_rec_cbte.fecha::date, 'DD-MM')::varchar != '01-01' THEN
                  raise exception 'El comprobante de apertura debe ser del primero de enero';
               END IF;
               
               --el comprobante de apertura solo puede ser un comprobante de diaraio
               IF v_codigo_clase_cbte != 'DIARIO' THEN
                 raise exception 'El comprobante de paertura solo puede ser del tipo DIARIO (CDIR) no %', v_codigo_clase_cbte;
               END IF;
               
               
            END IF;
            
            
           --valida cbte de apertura
           
           IF v_tiene_apertura = 'no' and  v_rec_cbte.cbte_apertura = 'si' THEN
               raise exception 'Esta clase de cbte no permite registros de apertura';           
           END IF;
            
            
           ---------------------------------------------------
           --  OBTENCION DE LA NUMERACION DEL CBTE
           --    considera que cada clase de comprobante puede 
           --    terner diferentes o los mismo documentos
           --    encargados de generar la numeracion
           ----------------------------------------------------- 
            
           --  Obtención del número de comprobante, si no tiene un numero asignado
           IF  v_rec_cbte.nro_cbte is null or v_rec_cbte.nro_cbte  = '' THEN
           
           
                --  validamos que la numeracion sea coherente con la fecha y correlativo
                 IF  v_rec_cbte.cbte_apertura = 'no' then
                      IF exists (select
                                        1
                                  from conta.tint_comprobante c
                                  inner join conta.tclase_comprobante cc on cc.id_clase_comprobante = c.id_clase_comprobante
                                  where c.id_depto = v_rec_cbte.id_depto
                                        --and c.id_clase_comprobante = v_rec_cbte.id_clase_comprobante
                                        and  cc.id_documento = v_rec_cbte.id_documento
                                        and c.id_periodo = v_rec_cbte.id_periodo
                                        and c.fecha > v_rec_cbte.fecha
                                        and (c.nro_cbte is not null or v_rec_cbte.nro_cbte  != '') ) THEN
                        
                                raise exception 'Existen comprobantes validados con fecha superior al % para este periodo, cambie la fecha', v_rec_cbte.fecha;
                       END IF;
                 else
                   -- si un comprobante de apertura  
                   if   to_char(v_rec_cbte.fecha::date, 'MM')::varchar != '01'  then
                        raise exception 'los cbte de apertura debe ser de enero';
                   end if;
                   
                    if   to_char(v_rec_cbte.fecha::date, 'DD')::integer  > 5  then
                        raise exception 'los cbte de apertura deben estar en los primeros 5 dias del año ';
                   end if;  
                   
                   -- 
                 end if;
               
             
                -- Si no es un cbte de apertura (pero su clase de cbte admite cbte de apertura) 
                -- y estamos en enero fuerza el saltar inicio (dejar el primer numero para el cbte de apertura)
                
                IF  v_tiene_apertura = 'si' and v_rec_cbte.cbte_apertura = 'no' and   to_char(v_rec_cbte.fecha::date, 'MM')::varchar = '01'  THEN
                     
                
                       v_nro_cbte =  param.f_obtener_correlativo(
                                 v_doc, 
                                 v_id_periodo,-- par_id, 
                                 NULL, --id_uo 
                                 v_rec_cbte.id_depto,    -- id_depto
                                 p_id_usuario, 
                                 'CONTA', 
                                 NULL,
                                 0,
                                 0,
                                 'no_aplica',
                                 0,
                                 'no_aplica',
                                 1,
                                 'si',  --par_saltar_inicio
                                 'no');
                
                ELSEIF v_rec_cbte.cbte_apertura = 'no' THEN
                    --si no es un comprobante de apertura y no es enero genera la nmeracion normalmente
                   v_nro_cbte =  param.f_obtener_correlativo(
                                 v_doc, 
                                 v_id_periodo,-- par_id, 
                                 NULL, --id_uo 
                                 v_rec_cbte.id_depto,    -- id_depto
                                 p_id_usuario, 
                                 'CONTA', 
                                 NULL);
                
                
                 ELSEIF v_rec_cbte.cbte_apertura = 'si' THEN
                   --si es un comprobante de inicio fuerza a optener el primer numero
                    v_nro_cbte =  param.f_obtener_correlativo(
                               v_doc, 
                               v_id_periodo,-- par_id, 
                               NULL, --id_uo 
                               v_rec_cbte.id_depto,    -- id_depto
                               p_id_usuario, 
                               'CONTA', 
                               NULL,
                               0,
                               0,
                               'no_aplica',
                               0,
                               'no_aplica',
                               1,
                               'no',  --par_saltar_inicio
                               'si'); --par_forzar_inicio
                   
                ELSE
                  raise exception 'tipo de cbte no previsto';
                END IF;
                
           ELSE
              v_nro_cbte = v_rec_cbte.nro_cbte; 
           END IF;
           
          -----------------------------------------------------
          -- Llevar e estado de WF del cbte a validado
          --   
          -------------------------------------------------------
          
           -- llevar a cbte al estado validado ...
            PERFORM conta.f_cambia_estado_wf_cbte(p_id_usuario, p_id_usuario_ai, p_usuario_ai, 
                                                  p_id_int_comprobante, 
                                                  'validado', 
                                                  'Cbte validado');
    
    
           
           --Se guarda el número del comprobante 
            update conta.tint_comprobante set
              nro_cbte = v_nro_cbte
            where id_int_comprobante = p_id_int_comprobante;
          
          
          ----------------------------------------------------------------------
          --  Si es solo un cbte de pago  validar la relacion con el devengado
          ----------------------------------------------------------------------
          --TODO analizar el caso de cbte de pago que se revierten
          --TODO analizar, cosnidera todas las transcciones que afecten bancos
           
          IF v_rec_cbte.sw_editable = 'si' and v_rec_cbte.momento_comprometido = 'no'  and  v_rec_cbte.momento_ejecutado = 'no'  and    v_rec_cbte.momento_pagado = 'si'  THEN   
             v_sw_rel = TRUE;
             FOR v_registros in  (
                                       select 
                                            itp.id_int_transaccion,
                                            itp.importe_gasto as importe_gasto_pag,
                                            itp.importe_recurso as importe_recurso_pag,
                                            sum(itd.importe_gasto) as importe_gasto_dev,
                                            sum(itd.importe_recurso) as importe_recurso_dev,
                                            sum(rd.monto_pago ) as total
                                       from conta.tint_rel_devengado rd
                                       inner join conta.tint_transaccion itp on rd.id_int_transaccion_pag = itp.id_int_transaccion
                                       inner join conta.tint_transaccion itd on rd.id_int_transaccion_dev = itd.id_int_transaccion
                                       where itp.id_int_comprobante = v_rec_cbte.id_int_comprobante
                                       group by  
                                            itp.id_int_transaccion,
                                            itp.importe_gasto ,
                                            itp.importe_recurso ) LOOP
                                            
                                         
                                  --validacion de  pago o  reversión de pago segun el signo
              					  
                                  IF v_registros.total > 0 THEN
                                  
                                      IF v_registros.total < v_registros.importe_gasto_pag and v_registros.importe_recurso_pag = 0   THEN
                                        raise exception 'a) El monto devengado (%) no es suficiente para realizar el pago (%), verifique la relación devengado pago',v_registros.total,v_registros.importe_gasto_pag;
                                      END IF;
                                      
                                      IF v_registros.total < v_registros.importe_recurso_pag and v_registros.importe_gasto_pag = 0   THEN
                                        raise exception 'b) El monto devengado (%) no es suficiente para realizar el pago (%), verifique la relación devengado pago',v_registros.total,v_registros.importe_recurso_pag;
                                      END IF;
                                 
             					  ELSEIF v_registros.total < 0 THEN
                                   
                                   --Si es una transaccion de reversion ...
                                   
                                      IF (v_registros.total*-1) < v_registros.importe_gasto_pag and v_registros.importe_recurso_pag = 0   THEN
                                        raise exception 'a) El monto relacionado/devengado (%) no es suficiente para realizar la reversion (%), verifique la relación devengado -  pago',(v_registros.total*-1),v_registros.importe_gasto_pag;
                                      END IF;
                                      
                                      IF (v_registros.total*-1) < v_registros.importe_gasto_pag and v_registros.importe_recurso_pag = 0   THEN
                                        raise exception 'b) El monto relacioando/devengado (%) no es suficiente para realizar la reversion (%), verifique la relación devengado - pago',(v_registros.total*-1),v_registros.importe_recurso_pag;
                                      END IF;
                                  END IF;
                                  v_sw_rel = FALSE;
                                  
             
                END LOOP;
                
                IF v_sw_rel   THEN
                   raise exception 'El Cbte es de pago presupuestario pero tiene relación con un devengado';
                END IF;
                
          END IF;
          
          
           
         ---------------------------------------------------------------------------------------- 
         -- si viene de una plantilla de comprobante busca la funcion de validacion configurada
         ----------------------------------------------------------------------------------------
           
         IF v_rec_cbte.id_plantilla_comprobante is not null  THEN
           
                select 
                 pc.funcion_comprobante_validado
                into v_funcion_comprobante_validado 
                from conta.tplantilla_comprobante pc  
                where pc.id_plantilla_comprobante = v_rec_cbte.id_plantilla_comprobante;
                
                
                -- raise exception 'llega % ---', v_funcion_comprobante_validado;
                
                -- raise exception 'validar comprobante pxp %',v_funcion_comprobante_validado ;
              	 IF  v_funcion_comprobante_validado is not null and v_funcion_comprobante_validado != '' THEN
                    EXECUTE ( 'select ' || v_funcion_comprobante_validado  ||'('||p_id_usuario::varchar||','||COALESCE(p_id_usuario_ai::varchar,'NULL')||','||COALESCE(''''||p_usuario_ai::varchar||'''','NULL')||','|| p_id_int_comprobante::varchar||', '||COALESCE('''' || v_nombre_conexion || '''','NULL')||')');
                end IF;                   
          ELSE
                -- si no tenemos plantilla de comprobante revisamos la funcin directamente	          
                IF v_rec_cbte.funcion_comprobante_validado is not NULL and v_rec_cbte.funcion_comprobante_validado != '' THEN
                   EXECUTE ( 'select ' || v_rec_cbte.funcion_comprobante_validado  ||'('||p_id_usuario::varchar||','||COALESCE(p_id_usuario_ai::varchar,'NULL')||','||COALESCE(''''||p_usuario_ai::varchar||'''','NULL')||','|| p_id_int_comprobante::varchar||', '||COALESCE('''' || v_nombre_conexion || '''','NULL')||')');
                END IF;
           
         END IF;
           
         
          
         --------------------------------------------------
         -- Validaciones sobre el cbte y sus transacciones
         ----------------------------------------------------
         IF not conta.f_int_trans_validar(p_id_usuario,p_id_int_comprobante) THEN
              raise exception 'error al realizar validaciones en el combrobante';
         END IF; 
            
            -- raise exception 'pasa .. '; 
          
         ---------------------------------------------------------------------------------------
         -- SI estamos en una regional internacional y  el comprobante es propio de la estacion
         -- migramos a contabilidad central
         --------------------------------------------------------------------------------------- 
         IF v_conta_codigo_estacion != 'CENTRAL' and v_rec_cbte.origen is NULL THEN
             v_resp =  migra.f_migrar_cbte_a_central(p_id_int_comprobante, v_nombre_conexion);
         END IF;
         
         
         
         ---------------------------------------------------------------------------
         --  Si estamos en la CENTRAL y el comprobante es  internacional  debemos  actualizar las modificaciones
         --  que pudieran haber sido realizadas al cbte en la estación regioanl
         ----------------------------------------------------------------------------
         
          IF  v_rec_cbte.sw_editable = 'si' and  v_rec_cbte.vbregional = 'si' and  v_conta_codigo_estacion = 'CENTRAL' and v_rec_cbte.localidad != 'nacional'  THEN
             v_resp =  migra.f_migrar_act_cbte_a_regional(p_id_int_comprobante, p_id_usuario ,v_conexion_int_act);
          END IF;
         
         
         ---------------------------------------------------------------------------------------------------
         --  SI el comprobante se valida en central (v_sincronizar = 'true' solo la central debe tener esta variable) 
         --  y  la sincronizacion esta habilitada  migramos el cbte a ENDESIS
         --  si la moneda  no es dolares debemos convertir a Bolivianos
         --  TODO ...para que revisa si no es ajuste ..???? ...no migre lso cbtes de ajuste?
         ----------------------------------------------------------------------------------------------------
         
       
         IF (v_sincronizar = 'true'   and  v_rec_cbte.id_ajuste is null and  v_rec_cbte.fecha <= '31/12/2016'::Date)THEN
             -- si sincroniza locamente con endesis, 
             -- marcando la bandera que proviene de regional internacional  (TODO ver para que es esta bandera ????)
             
             v_resp_int_endesis =  migra.f_migrar_cbte_endesis(p_id_int_comprobante, v_nombre_conexion, 'si');
         
         END IF;
         
         
          
         -----------------------------------------------------------------------------------------------
         --  Valifacion presupuestaria del comprobante  (ejecutamos el devengado o ejecutamos el pago)
         --  si es de una regional internacional y es moneda diferente de dolares convertimos a Bolivianos
         ------------------------------------------------------------------------------------------------
       --raise exception 'lelga %',v_rec_cbte.fecha;
         IF v_pre_integrar_presupuestos = 'true' THEN  --en las regionales internacionales la sincro de presupeustos esta deshabilitada
         
             IF v_sincronizar = 'true' and  v_rec_cbte.fecha <= '31/12/2016'::Date THEN
               
                v_resp =  conta.f_gestionar_presupuesto_cbte(p_id_usuario,p_id_int_comprobante,'no',p_fecha_ejecucion, v_nombre_conexion);
             
             ELSE
            
                v_resp =  conta.f_gestionar_presupuesto_cbte_pxp(p_id_usuario, p_id_int_comprobante, 'no', p_fecha_ejecucion, v_nombre_conexion);
             END IF;
         END IF;
         
        
       
         -------------------------------------------------- 
         --10.cerrar conexiones dblink si es que existe 
         -------------------------------------------------
         
         --cerrar la conexion de actulizacion (que puede ser paralela a la de jecucion de presupesutos)  central -> regional
         if  v_conexion_int_act is not null then
              select * into v_resp from migra.f_cerrar_conexion(v_conexion_int_act,'exito'); 
         end if;
         
         --cerrar la conexion comun (central-> endesis,  regional -> central)
         if  v_nombre_conexion is not null then
              select * into v_resp from migra.f_cerrar_conexion(v_nombre_conexion,'exito'); 
         end if;
        
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