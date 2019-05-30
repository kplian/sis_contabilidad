CREATE OR REPLACE FUNCTION conta.f_migrar_validar_centro_costo (
  p_id_int_comprobante integer,
  p_id_usuario integer
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:       Sistema de Contabilidad
 FUNCION:       conta.f_validar_centro_costo
 DESCRIPCION:   Verifica si un comprobante tiene por lo menos un centro de costo asociado a un tipo cc
                registrado en la tabla conta.tconfig_tpre . si tiene registrado un centro de costo 
                el comprobante es migrado junto a todos los comprobantes _relacionados por numero de tramite.                
 AUTOR:         (EGS)  EndeETR
 FECHA:         29/05/2019           
 COMENTARIOS:    
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 ISSUE      FECHA:         AUTOR:            DESCRIPCION:    
 #55        29/05/2019      EGS              Creacion            
         
***************************************************************************/

DECLARE
  
    v_nombre_funcion                           text;
    v_resp                                  varchar; 
    v_consulta                              varchar;
    v_centros_costo_valido                  record;
    v_existe                                BOOLEAN;
    v_int_trassaccion                       record;    
BEGIN

  v_nombre_funcion = 'conta.f_migrar_validar_centro_costo_migracion';
     v_existe = false;
     FOR    v_int_trassaccion IN (
     --recuperamos los centros de costo de las transacciones del comprobante
        SELECT  
            intra.id_centro_costo
        FROM  conta.tint_transaccion intra  
        WHERE intra.id_int_comprobante = p_id_int_comprobante
     )LOOP                 
               FOR  v_centros_costo_valido in  (
                    --recuperamos los centros de costos validos en la configuracion
                            select tpr.id_tipo_cc,
                                   tcc.codigo,
                                   cec.id_centro_costo,
                                   cec.id_gestion
                            from conta.tconfig_tpre tpr
                            left join param.ttipo_cc tcc on tcc.id_tipo_cc = tpr.id_tipo_cc
                            left join param.tcentro_costo cec on cec.id_tipo_cc = tpr.id_tipo_cc
                            where tcc.movimiento = 'si'
                            Order By tpr.id_tipo_cc,cec.id_centro_costo,cec.id_gestion )LOOP
                            --comparamos los centro de costo del comprobante contra los validos
                            IF v_int_trassaccion.id_centro_costo = v_centros_costo_valido.id_centro_costo  THEN
                                v_existe = true; 
                            END IF;                                                     
                    END LOOP;
         END LOOP; 
            --si existe un centro de costo valido en el comprobante se migra junto a todos los comprobantes
            -- con el mismo numero de tramite   
            IF v_existe = true THEN
                v_resp = conta.f_migrar_armar_int_comprobante(NULL,p_id_int_comprobante,'si',null);
            ELSE 
                v_resp = 'No se Proceso o no existen Centro de Costo validos en el comprobante';
            END IF;

    RETURN  v_resp;
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