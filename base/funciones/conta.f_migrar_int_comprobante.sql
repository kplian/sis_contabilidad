CREATE OR REPLACE FUNCTION conta.f_migrar_int_comprobante (
  p_administrador integer,
  p_comprobante json,
  p_intransaccion json,
  p_id_usuario integer
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Sistema
 FUNCION:         conta.f_migrar_int_comprobante
 DESCRIPCION:   Funcion que recibe los json cuando e migra de pxp a pxp
 AUTOR:         EGS
 FECHA:            11/03/2019
 COMENTARIOS:    
***************************************************************************/



DECLARE
  
    v_nombre_funcion                           text;
    v_resp                                  varchar; 
    v_nombre_conexion                       varchar;
    v_consulta                              varchar;
    v_nombre_con                            varchar;
    v_intransaccion                         record;
    v_int_comprobante                       record;
    v_record_per_ges                        record;
    v_id_int_comprobante                    integer;
    
    --proceso wf
    v_id_proceso_macro                        integer;
    v_codigo_proceso_macro                     varchar;
    v_codigo_tipo_proceso                     varchar;
    v_id_proceso_wf                            integer;
    v_id_estado_wf                            integer;
    v_num_tramite                           varchar;
    v_codigo_estado                            varchar;
    record_wf                               record; 
    v_tamano                                integer;
    v_id_int_comprobante_temp               record;
    v_id_int_comprobante_m                  integer;
    v_id_int_comprobante_temp_m             record;
    j_comprobantes                           json;
    j_comprobante                            json;
    beneficiario                           varchar;
    v_string                                  varchar;
    v_count                                 integer;
    
    v_id_int_comprobante_fks                integer[];
    v_id_int_comprobante_new                integer;
    j_int_transacciones                      json;
    j_int_transaccion                       json;  
BEGIN

    v_nombre_funcion = 'conta.f_migrar_int_comprobante';

    --Creando tablas Temporales 
   CREATE TEMPORARY TABLE temp_tint_comprobante (
                   id serial,
                   id_int_comprobante_old integer,
                   id_int_comprobante_new integer
                  ) ON COMMIT DROP;
    
   
    
    
    j_comprobantes = p_comprobante; 
    FOR j_comprobante IN (SELECT *
                         FROM json_array_elements(j_comprobantes)) LOOP

        INSERT INTO  conta.tint_comprobante
                    (
                      id_usuario_reg,
                      id_usuario_mod,
                      --fecha_reg,
                      --fecha_mod,
                      --estado_reg,
                      id_usuario_ai,
                      usuario_ai,
                      id_clase_comprobante,
                      id_subsistema,
                      id_depto,
                      id_moneda,
                      id_periodo,
                      nro_cbte,
                      momento,
                      glosa1,
                      glosa2,
                      beneficiario,
                      tipo_cambio,
                      id_funcionario_firma1,
                      id_funcionario_firma2,
                      id_funcionario_firma3,
                      fecha,
                      nro_tramite,
                      funcion_comprobante_eliminado,
                      funcion_comprobante_validado,
                      momento_comprometido,
                      momento_ejecutado,
                      momento_pagado,
                      id_cuenta_bancaria,
                      id_cuenta_bancaria_mov,
                      nro_cheque,
                      nro_cuenta_bancaria_trans,
                      id_plantilla_comprobante,
                      manual,
                      id_int_comprobante_fks,
                      id_tipo_relacion_comprobante,
                      id_depto_libro,
                      cbte_cierre,
                      cbte_apertura,
                      cbte_aitb,
                      origen,
                      temporal,
                      id_int_comprobante_origen_central,
                      vbregional,
                      codigo_estacion_origen,
                      id_int_comprobante_origen_regional,
                      fecha_costo_ini,
                      fecha_costo_fin,
                      id_moneda_tri,
                      tipo_cambio_2,
                      sw_tipo_cambio,
                      id_config_cambiaria,
                      localidad,
                      sw_editable,
                      id_int_comprobante_bk,
                      id_ajuste,
                      volcado,
                      cbte_reversion,
                      --id_proceso_wf,
                      --id_estado_wf,
                      c31,
                      fecha_c31,
                      forma_cambio,
                      tipo_cambio_3,
                      id_moneda_act,
                      glosa_previa,
                      nro_tramite_aux,
                      documento_iva
                    )
                    VALUES (
                      (j_comprobante ->> 'id_usuario_reg')::integer,
                      (j_comprobante ->> 'id_usuario_mod')::integer,
                      --(j_comprobante ->> 'fecha_reg')::date,
                      --(j_comprobante ->> 'fecha_mod')::date,
                      --(j_comprobante ->> 'estado_reg')::varchar,
                      (j_comprobante ->> 'id_usuario_ai')::integer,
                      (j_comprobante ->> 'usuario_ai')::varchar,
                      (j_comprobante ->> 'id_clase_comprobante')::INTEGER,
                      (j_comprobante ->> 'id_subsistema')::INTEGER,
                      (j_comprobante ->> 'id_depto')::INTEGER,
                      (j_comprobante ->> 'id_moneda')::INTEGER,
                      (j_comprobante ->> 'id_periodo')::INTEGER,
                      (j_comprobante ->> 'nro_cbte')::VARCHAR,
                      (j_comprobante ->> 'momento')::VARCHAR,
                      (j_comprobante ->> 'glosa1')::VARCHAR,
                      (j_comprobante ->> 'glosa2')::VARCHAR,
                      (j_comprobante ->> 'beneficiario')::VARCHAR,
                      (j_comprobante ->> 'tipo_cambio')::NUMERIC,
                      (j_comprobante ->> 'id_funcionario_firma1')::INTEGER,
                      (j_comprobante ->> 'id_funcionario_firma2')::INTEGER,
                      (j_comprobante ->> 'id_funcionario_firma3')::INTEGER,
                      (j_comprobante ->> 'fecha')::DATE,
                      (j_comprobante ->> 'nro_tramite')::VARCHAR,
                      (j_comprobante ->> 'funcion_comprobante_eliminado')::VARCHAR,
                      (j_comprobante ->> 'funcion_comprobante_validado')::VARCHAR,
                      (j_comprobante ->> 'momento_comprometido')::VARCHAR,
                      (j_comprobante ->> 'momento_ejecutado')::VARCHAR,
                      (j_comprobante ->> 'momento_pagado')::VARCHAR,
                      (j_comprobante ->> 'id_cuenta_bancaria')::INTEGER,
                      (j_comprobante ->> 'id_cuenta_bancaria_mov')::INTEGER,
                      (j_comprobante ->> 'nro_cheque')::INTEGER,
                      (j_comprobante ->> 'nro_cuenta_bancaria_trans')::VARCHAR,
                      (j_comprobante ->> 'id_plantilla_comprobante')::INTEGER,
                      (j_comprobante ->> 'manual')::VARCHAR,
                      (j_comprobante ->> 'id_int_comprobante_fks')::INTEGER[],
                      (j_comprobante ->> 'id_tipo_relacion_comprobante')::INTEGER,
                      (j_comprobante ->> 'id_depto_libro')::INTEGER,
                      (j_comprobante ->> 'cbte_cierre')::VARCHAR,
                      (j_comprobante ->> 'cbte_apertura')::VARCHAR,
                      (j_comprobante ->> 'cbte_aitb')::VARCHAR,
                      (j_comprobante ->> 'origen')::VARCHAR,
                      (j_comprobante ->> 'temporal')::VARCHAR,
                      (j_comprobante ->> 'id_int_comprobante_origen_central')::INTEGER,
                      (j_comprobante ->> 'vbregional')::VARCHAR,
                      (j_comprobante ->> 'codigo_estacion_origen')::VARCHAR,
                      (j_comprobante ->> 'id_int_comprobante_origen_regional')::INTEGER,
                      (j_comprobante ->> 'fecha_costo_ini')::DATE,
                      (j_comprobante ->> 'fecha_costo_fin')::DATE,
                      (j_comprobante ->> 'id_moneda_tri')::INTEGER,
                      (j_comprobante ->> 'tipo_cambio_2')::NUMERIC,
                      (j_comprobante ->> 'sw_tipo_cambio')::VARCHAR,
                      (j_comprobante ->> 'id_config_cambiaria')::INTEGER,
                      (j_comprobante ->> 'localidad')::VARCHAR,
                      (j_comprobante ->> 'sw_editable')::VARCHAR,
                      (j_comprobante ->> 'id_int_comprobante_bk')::INTEGER,
                      (j_comprobante ->> 'id_ajuste')::INTEGER,
                      (j_comprobante ->> 'volcado')::VARCHAR,
                      (j_comprobante ->> 'cbte_reversion')::VARCHAR,
                      --(j_comprobante ->> 'id_proceso_wf')::INTEGER,
                      --(j_comprobante ->> 'id_estado_wf')::INTEGER,
                      (j_comprobante ->> 'c31')::VARCHAR,
                      (j_comprobante ->> 'fecha_c31')::DATE,
                      (j_comprobante ->> 'forma_cambio')::VARCHAR,
                      (j_comprobante ->> 'tipo_cambio_3')::NUMERIC,
                      (j_comprobante ->> 'id_moneda_act')::INTEGER,
                      (j_comprobante ->> 'glosa_previa')::VARCHAR,
                      (j_comprobante ->> 'nro_tramite_aux')::VARCHAR,
                      (j_comprobante ->> 'documento_iva')::VARCHAR
                    )returning id_int_comprobante into v_id_int_comprobante;
         ---Guardando y relacionando los id antiguos y nuevos           
        INSERT INTO temp_tint_comprobante(        
                   id_int_comprobante_old ,
                   id_int_comprobante_new 
                    )values(                                     
                    (j_comprobante ->> 'id_int_comprobante')::INTEGER,
                    v_id_int_comprobante
                    ); 
          ----iniciamos tramites WF para los comprobantes
                    v_record_per_ges= param.f_get_periodo_gestion((j_comprobante ->> 'fecha')::DATE);                          
                    p_id_usuario=1;            
                     v_codigo_proceso_macro = pxp.f_get_variable_global('conta_codigo_macro_wf_cbte');
                    --obtener id del proceso macro
                    select 
                     pm.id_proceso_macro
                    into
                     v_id_proceso_macro
                    from wf.tproceso_macro pm
                    where pm.codigo = v_codigo_proceso_macro;
                   
                    If v_id_proceso_macro is NULL THEN
                      raise exception 'El proceso macro  de codigo % no esta configurado en el sistema WF',v_codigo_proceso_macro;  
                    END IF;
                   
                   --   obtener el codigo del tipo_proceso
                    select   tp.codigo 
                     into v_codigo_tipo_proceso
                    from  wf.ttipo_proceso tp 
                    where   tp.id_proceso_macro = v_id_proceso_macro
                          and tp.estado_reg = 'activo' and tp.inicio = 'si';
                          
                    IF v_codigo_tipo_proceso is NULL THEN
                     raise exception 'No existe un proceso inicial para el proceso macro indicado % (Revise la configuración)',v_codigo_proceso_macro;
                    END IF;
                    SELECT
                       ps_num_tramite ,
                       ps_id_proceso_wf ,
                       ps_id_estado_wf ,
                       ps_codigo_estado
                    into
                       v_num_tramite,
                       v_id_proceso_wf,
                       v_id_estado_wf,
                       v_codigo_estado                      
                    FROM wf.f_inicia_tramite(
                       p_id_usuario,                                             
                       null,          
                       'NULL',             
                       v_record_per_ges.po_id_gestion,
                       v_codigo_tipo_proceso,                                     
                       null,                                                    
                       (j_comprobante ->> 'id_depto')::INTEGER,                                 
                       'Registro Comprobante Migrado',
                       v_codigo_proceso_macro,
                       (j_comprobante ->> 'nro_tramite')::VARCHAR);
            ---Actualizamos los comprobantes con los nuevos tramites WF
                    UPDATE conta.tint_comprobante SET
                    id_proceso_wf = v_id_proceso_wf,
                    id_estado_wf = v_id_estado_wf,
                    estado_reg = v_codigo_estado
                    WHERE id_int_comprobante = v_id_int_comprobante;
    
    END LOOP;
    
    --Atualizamos el campo id_in_comprobante_fks con los nuevos ids 
    FOR v_int_comprobante IN(
                    SELECT                        
                       id_int_comprobante_old ,
                       id_int_comprobante_new 
                    FROM temp_tint_comprobante             
                    )LOOP
                    
              ---recuperamos los comprobantes relacionados old
                    SELECT
                        cbte.id_int_comprobante_fks
                    INTO
                        v_id_int_comprobante_fks
                    FROM conta.tint_comprobante cbte
                    WHERE cbte.id_int_comprobante = v_int_comprobante.id_int_comprobante_new;
              --vaciamos el campo id_int_comprobante_fks
                update conta.tint_comprobante set 
                            id_int_comprobante_fks = null
                where id_int_comprobante = v_int_comprobante.id_int_comprobante_new; 
              
                   
               -- insertamos los nuevos id relacionados al campo id_int_comprobante_fks
                 v_tamano:=array_upper(v_id_int_comprobante_fks,1);
                 IF v_tamano is not null THEN    
                        FOR i IN 1..(v_tamano) loop
                            SELECT
                                tcbte.id_int_comprobante_new
                            INTO
                                v_id_int_comprobante_new
                            FROM temp_tint_comprobante tcbte
                            WHERE id_int_comprobante_old = v_id_int_comprobante_fks[i] ;
                             
                            update conta.tint_comprobante set 
                            id_int_comprobante_fks = array_append(id_int_comprobante_fks,v_id_int_comprobante_new) 
                            where id_int_comprobante = v_int_comprobante.id_int_comprobante_new;   
                        END LOOP;                          
                 END IF;                                                
    END LOOP;          
   /*####
        Insertamos la transsaciones de los comprobantes
   ####*/
        j_int_transacciones=p_intransaccion;
   FOR j_int_transaccion IN (SELECT *
                         FROM json_array_elements(j_int_transacciones)) LOOP
          
                        SELECT
                                tcbte.id_int_comprobante_new
                        INTO
                                v_id_int_comprobante_new
                        FROM temp_tint_comprobante tcbte
                        WHERE id_int_comprobante_old = (j_int_transaccion->>'id_int_comprobante')::INTEGER ;               
         
         INSERT INTO  conta.tint_transaccion
                      (
                        id_usuario_reg,
                        id_usuario_mod,
                        fecha_reg,
                        fecha_mod,
                        estado_reg,
                        id_usuario_ai,
                        usuario_ai,
                        id_int_comprobante,
                        id_cuenta,
                        id_auxiliar,
                        id_centro_costo,
                        id_partida,
                        id_partida_ejecucion,
                        id_int_transaccion_fk,
                        glosa,
                        importe_debe,
                        importe_haber,
                        importe_recurso,
                        importe_gasto,
                        importe_debe_mb,
                        importe_haber_mb,
                        importe_recurso_mb,
                        importe_gasto_mb,
                        id_detalle_plantilla_comprobante,
                        id_partida_ejecucion_dev,
                        importe_reversion,
                        factor_reversion,
                        monto_pagado_revertido,
                        id_partida_ejecucion_rev,
                        id_cuenta_bancaria,
                        id_cuenta_bancaria_mov,
                        nro_cheque,
                        nro_cuenta_bancaria_trans,
                        porc_monto_excento_var,
                        nombre_cheque_trans,
                        id_orden_trabajo,
                        forma_pago,
                        banco,
                        id_int_transaccion_origen,
                        id_moneda,
                        id_moneda_tri,
                        tipo_cambio,
                        tipo_cambio_2,
                        triangulacion,
                        actualizacion,
                        importe_debe_mt,
                        importe_haber_mt,
                        importe_gasto_mt,
                        importe_recurso_mt,
                        orden,
                        id_suborden,
                        tipo_cambio_3,
                        id_moneda_act,
                        importe_debe_ma,
                        importe_haber_ma,
                        importe_gasto_ma,
                        importe_recurso_ma,
                        monto_no_ejecutado,
                        monto_no_ejecutado_mb,
                        id_cuenta_bolsa,
                        id_partida_ejecucion_tmp,
                        obs_dba,
                        temp_importe_ma_aux,
                        cerrado,
                        fecha_cerrado,
                        id_int_comprobante_cierre,
                        id_origen,
                        nro_tramite,
                        forzar_comprometer,
                        id_centro_costo_ori
                      )
                      VALUES ( 
                        (j_int_transaccion ->> 'id_usuario_reg')::integer,
                        (j_int_transaccion ->> 'id_usuario_mod')::integer,
                        (j_int_transaccion ->> 'fecha_reg')::date,
                        (j_int_transaccion ->> 'fecha_mod')::date,
                        (j_int_transaccion ->> 'estado_reg')::varchar,
                        (j_int_transaccion ->> 'id_usuario_ai')::integer,
                        (j_int_transaccion ->> 'usuario_ai')::varchar,
                        v_id_int_comprobante_new,
                        (j_int_transaccion->>'id_cuenta')::INTEGER,
                        (j_int_transaccion->>'id_auxiliar')::INTEGER,
                        (j_int_transaccion->>'id_centro_costo')::INTEGER,
                        (j_int_transaccion->>'id_partida')::INTEGER,
                        (j_int_transaccion->>'id_partida_ejecucion')::INTEGER,
                        (j_int_transaccion->>'id_int_transaccion_fk')::INTEGER,
                        (j_int_transaccion->>'glosa')::VARCHAR,
                        (j_int_transaccion->>'importe_debe')::NUMERIC,
                        (j_int_transaccion->>'importe_haber')::NUMERIC,
                        (j_int_transaccion->>'importe_recurso')::NUMERIC,
                        (j_int_transaccion->>'importe_gasto')::NUMERIC,
                        (j_int_transaccion->>'importe_debe_mb')::NUMERIC,
                        (j_int_transaccion->>'importe_haber_mb')::NUMERIC,
                        (j_int_transaccion->>'importe_recurso_mb')::NUMERIC,
                        (j_int_transaccion->>'importe_gasto_mb')::NUMERIC,
                        (j_int_transaccion->>'id_detalle_plantilla_comprobante')::INTEGER,
                        (j_int_transaccion->>'id_partida_ejecucion_dev')::INTEGER,
                        (j_int_transaccion->>'importe_reversion')::NUMERIC,
                        (j_int_transaccion->>'factor_reversion')::NUMERIC,
                        (j_int_transaccion->>'monto_pagado_revertido')::NUMERIC,
                        (j_int_transaccion->>'id_partida_ejecucion_rev')::INTEGER,
                        (j_int_transaccion->>'id_cuenta_bancaria')::INTEGER,
                        (j_int_transaccion->>'id_cuenta_bancaria_mov')::INTEGER,
                        (j_int_transaccion->>'nro_cheque')::INTEGER,
                        (j_int_transaccion->>'nro_cuenta_bancaria_trans')::VARCHAR,
                        (j_int_transaccion->>'porc_monto_excento_var')::NUMERIC,
                        (j_int_transaccion->>'nombre_cheque_trans')::VARCHAR,
                        (j_int_transaccion->>'id_orden_trabajo')::INTEGER,
                        (j_int_transaccion->>'forma_pago')::VARCHAR,
                        (j_int_transaccion->>'banco')::VARCHAR,
                        (j_int_transaccion->>'id_int_transaccion_origen')::INTEGER,
                        (j_int_transaccion->>'id_moneda')::INTEGER,
                        (j_int_transaccion->>'id_moneda_tri')::INTEGER,
                        (j_int_transaccion->>'tipo_cambio')::NUMERIC,
                        (j_int_transaccion->>'tipo_cambio_2')::NUMERIC,
                        (j_int_transaccion->>'triangulacion')::VARCHAR,
                        (j_int_transaccion->>'actualizacion')::VARCHAR,
                        (j_int_transaccion->>'importe_debe_mt')::NUMERIC,
                        (j_int_transaccion->>'importe_haber_mt')::NUMERIC,
                        (j_int_transaccion->>'importe_gasto_mt')::NUMERIC,
                        (j_int_transaccion->>'importe_recurso_mt')::NUMERIC,
                        (j_int_transaccion->>'orden')::NUMERIC,
                        (j_int_transaccion->>'id_suborden')::INTEGER,
                        (j_int_transaccion->>'tipo_cambio_3')::NUMERIC,
                        (j_int_transaccion->>'id_moneda_act')::INTEGER,
                        (j_int_transaccion->>'importe_debe_ma')::NUMERIC,
                        (j_int_transaccion->>'importe_haber_ma')::NUMERIC,
                        (j_int_transaccion->>'importe_gasto_ma')::NUMERIC,
                        (j_int_transaccion->>'importe_recurso_ma')::NUMERIC,
                        (j_int_transaccion->>'monto_no_ejecutado')::NUMERIC, 
                        (j_int_transaccion->>'monto_no_ejecutado_mb')::NUMERIC,
                        (j_int_transaccion->>'id_cuenta_bolsa')::INTEGER,
                        (j_int_transaccion->>'id_partida_ejecucion_tmp')::INTEGER,
                        (j_int_transaccion->>'obs_dba')::VARCHAR,
                        (j_int_transaccion->>'temp_importe_ma_aux')::NUMERIC,
                        (j_int_transaccion->>'cerrado')::VARCHAR,
                        (j_int_transaccion->>'fecha_cerrado')::TIMESTAMP,
                        (j_int_transaccion->>'id_int_comprobante_cierre')::INTEGER,
                        (j_int_transaccion->>'id_origen')::INTEGER,
                        (j_int_transaccion->>'nro_tramite')::VARCHAR,
                        (j_int_transaccion->>'forzar_comprometer')::VARCHAR,
                        (j_int_transaccion->>'id_centro_costo_ori')::INTEGER
                      );                      
                     
   END LOOP;

              SELECT 
              json_agg(json_build_object(
              '"id_int_comprobante_old"',temp.id_int_comprobante_old,
              '"id_int_comprobante_new"',temp.id_int_comprobante_new
                )) as json
              INTO
              v_resp
              FROM temp_tint_comprobante temp;
  
 RETURN  v_resp;
/*EXCEPTION
                    
    WHEN OTHERS THEN
            v_resp='';
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
            v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
            v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
            raise exception '%',v_resp;*/
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;