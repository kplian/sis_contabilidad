--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_backup_int_comprobante (
  p_id_int_comprobante integer
)
RETURNS integer AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_config_cambiaria_ime
 DESCRIPCION:   Funcion para generar la copia del comprobante especificado
 AUTOR: 		 (rac)  kplian
 FECHA:	        27-11-2015 12:39:12
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE


v_nombre_funcion			varchar;
v_resp						varchar;
v_id_int_comprobante_bk		integer;
v_registros_cbte			record;
v_registros					record;
v_registros_rel				record;
v_id_int_transaccion_bk		integer;



 

BEGIN

   v_nombre_funcion = 'conta.f_backup_int_comprobante';
   
   select 
     *
   INTO
     v_registros_cbte
   FROM conta.tint_comprobante cbte
   where cbte.id_int_comprobante = p_id_int_comprobante;
   
    INSERT INTO 
                  conta.tint_comprobante_bk
                (
                  id_usuario_reg,
                  id_usuario_mod,
                  fecha_reg,
                  fecha_mod,
                  estado_reg,
                  id_usuario_ai,
                  usuario_ai,                 
                  id_int_comprobante,
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
                  localidad
                )
                VALUES (
                  v_registros_cbte.id_usuario_reg,
                  v_registros_cbte.id_usuario_mod,
                  v_registros_cbte.fecha_reg,
                  v_registros_cbte.fecha_mod,
                  v_registros_cbte.estado_reg,
                  v_registros_cbte.id_usuario_ai,
                  v_registros_cbte.usuario_ai,                 
                  v_registros_cbte.id_int_comprobante,
                  v_registros_cbte.id_clase_comprobante,
                  v_registros_cbte.id_subsistema,
                  v_registros_cbte.id_depto,
                  v_registros_cbte.id_moneda,
                  v_registros_cbte.id_periodo,
                  v_registros_cbte.nro_cbte,
                  v_registros_cbte.momento,
                  v_registros_cbte.glosa1,
                  v_registros_cbte.glosa2,
                  v_registros_cbte.beneficiario,
                  v_registros_cbte.tipo_cambio,
                  v_registros_cbte.id_funcionario_firma1,
                  v_registros_cbte.id_funcionario_firma2,
                  v_registros_cbte.id_funcionario_firma3,
                  v_registros_cbte.fecha,
                  v_registros_cbte.nro_tramite,
                  v_registros_cbte.funcion_comprobante_eliminado,
                  v_registros_cbte.funcion_comprobante_validado,
                  v_registros_cbte.momento_comprometido,
                  v_registros_cbte.momento_ejecutado,
                  v_registros_cbte.momento_pagado,
                  v_registros_cbte.id_cuenta_bancaria,
                  v_registros_cbte.id_cuenta_bancaria_mov,
                  v_registros_cbte.nro_cheque,
                  v_registros_cbte.nro_cuenta_bancaria_trans,
                  v_registros_cbte.id_plantilla_comprobante,
                  v_registros_cbte.manual,
                  v_registros_cbte.id_int_comprobante_fks,
                  v_registros_cbte.id_tipo_relacion_comprobante,
                  v_registros_cbte.id_depto_libro,
                  v_registros_cbte.cbte_cierre,
                  v_registros_cbte.cbte_apertura,
                  v_registros_cbte.cbte_aitb,
                  v_registros_cbte.origen,
                  v_registros_cbte.temporal,
                  v_registros_cbte.id_int_comprobante_origen_central,
                  v_registros_cbte.vbregional,
                  v_registros_cbte.codigo_estacion_origen,
                  v_registros_cbte.id_int_comprobante_origen_regional,
                  v_registros_cbte.fecha_costo_ini,
                  v_registros_cbte.fecha_costo_fin,
                  v_registros_cbte.id_moneda_tri,
                  v_registros_cbte.tipo_cambio_2,
                  v_registros_cbte.sw_tipo_cambio,
                  v_registros_cbte.id_config_cambiaria,
                  v_registros_cbte.localidad
                ) RETURNING id_int_comprobante into  v_id_int_comprobante_bk;   
       
   
   
   FOR  v_registros in (
                           select 
                             * 
                           from conta.tint_transaccion it
                           where it.id_int_comprobante = p_id_int_comprobante)LOOP
      
             
   
         INSERT INTO 
                  conta.tint_transaccion_bk
                (
                  id_usuario_reg,
                  id_usuario_mod,
                  fecha_reg,
                  fecha_mod,
                  estado_reg,
                  id_usuario_ai,
                  usuario_ai,
                 
                  id_int_transaccion,
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
                  monto_pagado_revertido,
                  id_partida_ejecucion_rev,
                  id_cuenta_bancaria,
                  id_cuenta_bancaria_mov,
                  nro_cheque,
                  nro_cuenta_bancaria_trans,
                  porc_monto_excento_var,
                  nombre_cheque_trans,
                  factor_reversion,
                  id_orden_trabajo,
                  forma_pago,
                  banco,
                  id_int_transaccion_origen,
                  id_moneda,
                  id_moneda_tri,
                  tipo_cambio,
                  tipo_cambio_2,
                  actualizacion,
                  triangulacion,
                  importe_debe_mt,
                  importe_haber_mt,
                  importe_gasto_mt,
                  importe_recurso_mt,
                  id_int_comprobante_bk
                )
                VALUES (
                  v_registros.id_usuario_reg,
                  v_registros.id_usuario_mod,
                  v_registros.fecha_reg,
                  v_registros.fecha_mod,
                  v_registros.estado_reg,
                  v_registros.id_usuario_ai,
                  v_registros.usuario_ai,
                  v_registros.id_int_transaccion,
                  v_registros.id_int_comprobante,
                  v_registros.id_cuenta,
                  v_registros.id_auxiliar,
                  v_registros.id_centro_costo,
                  v_registros.id_partida,
                  v_registros.id_partida_ejecucion,
                  v_registros.id_int_transaccion_fk,
                  v_registros.glosa,
                  v_registros.importe_debe,
                  v_registros.importe_haber,
                  v_registros.importe_recurso,
                  v_registros.importe_gasto,
                  v_registros.importe_debe_mb,
                  v_registros.importe_haber_mb,
                  v_registros.importe_recurso_mb,
                  v_registros.importe_gasto_mb,
                  v_registros.id_detalle_plantilla_comprobante,
                  v_registros.id_partida_ejecucion_dev,
                  v_registros.importe_reversion,
                  v_registros.monto_pagado_revertido,
                  v_registros.id_partida_ejecucion_rev,
                  v_registros.id_cuenta_bancaria,
                  v_registros.id_cuenta_bancaria_mov,
                  v_registros.nro_cheque,
                  v_registros.nro_cuenta_bancaria_trans,
                  v_registros.porc_monto_excento_var,
                  v_registros.nombre_cheque_trans,
                  v_registros.factor_reversion,
                  v_registros.id_orden_trabajo,
                  v_registros.forma_pago,
                  v_registros.banco,
                  v_registros.id_int_transaccion_origen,
                  v_registros.id_moneda,
                  v_registros.id_moneda_tri,
                  v_registros.tipo_cambio,
                  v_registros.tipo_cambio_2,
                  v_registros.actualizacion,
                  v_registros.triangulacion,
                  v_registros.importe_debe_mt,
                  v_registros.importe_haber_mt,
                  v_registros.importe_gasto_mt,
                  v_registros.importe_recurso_mt,
                  v_id_int_comprobante_bk
                )RETURNING id_int_transaccion into  v_id_int_transaccion_bk;
      
               --relaciones de devegnado pago .....
               v_registros_rel = NULL; 
        
               FOR  v_registros_rel in (
                                   select 
                                     * 
                                   from conta.tint_rel_devengado r
                                   where r.id_int_transaccion_dev = v_registros.id_int_transaccion)LOOP
                                   
                             INSERT INTO 
                                          conta.tint_rel_devengado_bk
                                        (
                                          id_usuario_reg,
                                          id_usuario_mod,
                                          fecha_reg,
                                          fecha_mod,
                                          estado_reg,
                                          id_usuario_ai,
                                          usuario_ai,                                
                                          id_int_rel_devengado,
                                          id_int_transaccion_dev,
                                          id_int_transaccion_pag,
                                          id_int_transaccion_bk_dev,
                                          id_int_transaccion_bk_pag,
                                          monto_pago,
                                          id_partida_ejecucion_pag,
                                          monto_pago_mb,
                                          monto_pago_mt
                                        )
                                        VALUES (
                                          v_registros_rel.id_usuario_reg,
                                          v_registros_rel.id_usuario_mod,
                                          v_registros_rel.fecha_reg,
                                          v_registros_rel.fecha_mod,
                                          v_registros_rel.estado_reg,
                                          v_registros_rel.id_usuario_ai,
                                          v_registros_rel.usuario_ai,                                
                                          v_registros_rel.id_int_rel_devengado,
                                          v_registros_rel.id_int_transaccion_dev,
                                          v_registros_rel.id_int_transaccion_pag,
                                          v_id_int_transaccion_bk, --v_registros_rel.id_int_transaccion_bk_dev,
                                          NULL,--.id_int_transaccion_bk_pag,
                                          v_registros_rel.monto_pago,
                                          v_registros_rel.id_partida_ejecucion_pag,
                                          v_registros_rel.monto_pago_mb,
                                          v_registros_rel.monto_pago_mt
                                        );      
                END LOOP;
                
                
                v_registros_rel = NULL;
                
                FOR  v_registros_rel in (
                                   select 
                                     * 
                                   from conta.tint_rel_devengado r
                                   where r.id_int_transaccion_pag = v_registros.id_int_transaccion)LOOP
                                   
                             INSERT INTO 
                                          conta.tint_rel_devengado_bk
                                        (
                                          id_usuario_reg,
                                          id_usuario_mod,
                                          fecha_reg,
                                          fecha_mod,
                                          estado_reg,
                                          id_usuario_ai,
                                          usuario_ai,                                
                                          id_int_rel_devengado,
                                          id_int_transaccion_dev,
                                          id_int_transaccion_pag,
                                          id_int_transaccion_bk_dev,
                                          id_int_transaccion_bk_pag,
                                          monto_pago,
                                          id_partida_ejecucion_pag,
                                          monto_pago_mb,
                                          monto_pago_mt
                                        )
                                        VALUES (
                                          v_registros_rel.id_usuario_reg,
                                          v_registros_rel.id_usuario_mod,
                                          v_registros_rel.fecha_reg,
                                          v_registros_rel.fecha_mod,
                                          v_registros_rel.estado_reg,
                                          v_registros_rel.id_usuario_ai,
                                          v_registros_rel.usuario_ai,                                
                                          v_registros_rel.id_int_rel_devengado,
                                          v_registros_rel.id_int_transaccion_dev,
                                          v_registros_rel.id_int_transaccion_pag,
                                          NULL, --v_registros_rel.id_int_transaccion_bk_dev,
                                          v_id_int_transaccion_bk,--.id_int_transaccion_bk_pag,
                                          v_registros_rel.monto_pago,
                                          v_registros_rel.id_partida_ejecucion_pag,
                                          v_registros_rel.monto_pago_mb,
                                          v_registros_rel.monto_pago_mt
                                        );      
                END LOOP;                    
                  
      
   END LOOP;
      
     
   
   return v_id_int_comprobante_bk;


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