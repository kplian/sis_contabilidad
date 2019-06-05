CREATE OR REPLACE FUNCTION conta.f_etasa (
  p_id_int_comprobante integer,
  p_id_usuario integer
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:       Sistema de Contabilidad
 FUNCION:       conta.f_validar_centro_costo
 DESCRIPCION:   Verifica si un comprobante tiene por lo menos un centro de costo
                registrado en la tabla conta.tconfig_tpre y auxiliar en conta.tconfig_auxiliar . si tiene registrado un centro de costo 
                el comprobante es migrado junto a todos los comprobantes _relacionados.                
 AUTOR:         (EGS)  EndeETR
 FECHA:         18/03/2019            
 COMENTARIOS:    
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:    
 AUTOR:            
 FECHA:        
***************************************************************************/

DECLARE
  
    v_nombre_funcion                           text;
    v_resp                                  varchar; 
    v_consulta                              varchar;
    v_centros_costo_valido                  record;
    v_existe                                BOOLEAN;
    v_int_trassaccion                       record;
    v_id_centros                            varchar; 
    v_id                                    integer;
    v_migrar                                varchar;
    v_auxiliar_valido                       record;
    
    v_id_auxiliares                         varchar;   
BEGIN

  v_nombre_funcion = 'conta.f_etasa';
  v_migrar = 'no';
    IF v_migrar = 'si' THEN
            v_id_centros = '';
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
                        v_id_centros =  v_id_centros||v_centros_costo_valido.id_centro_costo::varchar||',';                                              
             END LOOP;
         v_id_centros = SUBSTRING (v_id_centros,1,length(v_id_centros) - 1);

         --recuperamos los comprobantes validados con los centros de costo configurados y validados
         FOR    v_int_trassaccion IN EXECUTE (
            'SELECT  
                DISTINCT(intra.id_int_comprobante)
            FROM  conta.tint_transaccion intra
            LEFT JOIN conta.tint_comprobante cbte on cbte.id_int_comprobante = intra.id_int_comprobante 
            WHERE cbte.id_int_comprobante_migrado is null and cbte.estado_reg = ''validado'' and  intra.id_centro_costo in ('||v_id_centros||')'
         )LOOP
              
                v_id = v_int_trassaccion.id_int_comprobante ;               
                v_resp = conta.f_migrar_armar_int_comprobante(NULL,v_int_trassaccion.id_int_comprobante,'si',null);

         END LOOP;                 
         v_id_auxiliares ='';
           FOR  v_auxiliar_valido in  (
                        --recuperamos los auxiliares validos en la configuracion
                                    SELECT 
                                        cfgaux.id_auxiliar
                                    FROM conta.tconfig_auxiliar cfgaux
                                     )LOOP
                 v_id_auxiliares =  v_id_auxiliares||v_auxiliar_valido.id_auxiliar::varchar||',';                                              
           END LOOP;
         v_id_auxiliares = SUBSTRING (v_id_auxiliares,1,length(v_id_auxiliares) - 1);
         --RAISE EXCEPTION 'v_id_auxiliares %',v_id_auxiliares;
         --recuperamos los comprobantes validados con los centros de costo configurados y validados
         FOR    v_int_trassaccion IN EXECUTE (
            'SELECT  
                DISTINCT(intra.id_int_comprobante)
            FROM  conta.tint_transaccion intra
            LEFT JOIN conta.tint_comprobante cbte on cbte.id_int_comprobante = intra.id_int_comprobante 
            WHERE cbte.id_int_comprobante_migrado is null and cbte.estado_reg = ''validado'' and  intra.id_auxiliar in ('||v_id_auxiliares||')'
         )LOOP
                v_id = v_int_trassaccion.id_int_comprobante ;               
                v_resp = conta.f_migrar_armar_int_comprobante(NULL,v_int_trassaccion.id_int_comprobante,'si',null);

         END LOOP; 
                  
    END IF;
    RETURN  v_resp;
    EXCEPTION                
    WHEN OTHERS THEN
            v_resp='';
            v_resp = pxp.f_agrega_clave(v_resp,'comprobante',v_id::varchar);
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