--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_import_tresultado_det_plantilla (
  p_accion varchar,
  p_orden varchar,
  p_font_size varchar,
  p_formula varchar,
  p_subrayar varchar,
  p_codigo varchar,
  p_montopos varchar,
  p_nombre_variable varchar,
  p_posicion varchar,
  p_estado_reg varchar,
  p_nivel_detalle varchar,
  p_origen varchar,
  p_signo varchar,
  p_codigo_cuenta varchar,
  p_visible varchar,
  p_incluir_apertura varchar,
  p_incluir_cierre varchar,
  p_desc_cuenta varchar,
  p_negrita varchar,
  p_cursiva varchar,
  p_espacio_previo varchar,
  p_incluir_aitb varchar,
  p_tipo_saldo varchar,
  p_signo_balance varchar,
  p_relacion_contable varchar,
  p_codigo_partida varchar,
  p_destino varchar,
  p_orden_cbte varchar,
  p_codigo_auxiliar varchar,
  p_codigo_resultado_plantilla varchar
)
RETURNS varchar AS
$body$
DECLARE
	
   v_id_resultado_plantilla		integer;
   v_id_resultado_det_plantilla	integer;
   v_id_auxiliar	integer;
    
   v_id_detalle_plantilla_comprobante_fk	integer;
BEGIN
	 
    
    select plt.id_resultado_plantilla into v_id_resultado_plantilla
    from conta.tresultado_plantilla plt    
    where trim(lower(plt.codigo)) = trim(lower(p_codigo_resultado_plantilla));
    
    select plt.id_resultado_det_plantilla into v_id_resultado_det_plantilla
    from conta.tresultado_det_plantilla plt    
    where trim(lower(plt.codigo)) = trim(lower(p_codigo)) 
          and plt.id_resultado_plantilla =  v_id_resultado_plantilla;
          
    select plt.id_auxiliar into v_id_auxiliar
    from conta.tauxiliar plt    
    where trim(lower(plt.codigo_auxiliar)) = trim(lower(p_codigo_auxiliar));
          
    
    if (p_accion = 'delete') then
    	
        update conta.tresultado_det_plantilla r set estado_reg = 'inactivo'
    	where r.id_resultado_det_plantilla = v_id_resultado_det_plantilla;
    
    else
        if (v_id_resultado_det_plantilla is null)then
        		
                  --  Sentencia de la insercion
                  insert into conta.tresultado_det_plantilla(
                    orden,
                    font_size,
                    formula,
                    subrayar,
                    codigo,
                    montopos,
                    nombre_variable,
                    posicion,
                    estado_reg,
                    nivel_detalle,
                    origen,
                    signo,
                    codigo_cuenta,
                    
                    fecha_reg,
                    id_usuario_reg,
                   
                    id_resultado_plantilla,
                    visible,
                    incluir_cierre,
                    incluir_apertura,
                    negrita,
                    cursiva,
                    espacio_previo,
                    incluir_aitb,
                    tipo_saldo,
                    signo_balance,
                    relacion_contable,
                    codigo_partida,
                    id_auxiliar,
                    destino,
                    orden_cbte
               ) values(
                    p_orden::numeric,
                    p_font_size,
                    p_formula,
                    p_subrayar,
                    p_codigo,
                    p_montopos::integer,
                    p_nombre_variable,
                    p_posicion,
                    'activo',
                    p_nivel_detalle::integer,
                    p_origen,
                    p_signo,
                    p_codigo_cuenta,                    
                    now(),
                    1,                   
                    v_id_resultado_plantilla,
                    p_visible,
                    p_incluir_cierre,
                    p_incluir_apertura,
                    p_negrita,
                    p_cursiva,
                    p_espacio_previo::integer,
                    p_incluir_aitb,
                    p_tipo_saldo,
                    p_signo_balance,
                    p_relacion_contable,
                    p_codigo_partida,
                    v_id_auxiliar,
                    p_destino,
                    p_orden_cbte::numeric
                  );
           
                
        else            
            
             update conta.tresultado_det_plantilla set
              orden =  p_orden::numeric,
              font_size =p_font_size,
              formula = p_formula,
              subrayar = p_subrayar,
              codigo = p_codigo,
              montopos = p_montopos::integer,
              nombre_variable = p_nombre_variable,
              posicion = p_posicion,
              nivel_detalle =  p_nivel_detalle::integer,
              origen = p_origen,
              signo = p_signo,
              codigo_cuenta = p_codigo_cuenta,
              id_usuario_mod = 1,
              fecha_mod = now(),
              id_resultado_plantilla = v_id_resultado_plantilla,
              visible = p_visible,
              incluir_cierre = p_incluir_cierre,
              incluir_apertura = p_incluir_apertura,
              negrita = p_negrita,
              cursiva = p_cursiva,
              espacio_previo =  p_espacio_previo::integer,
              incluir_aitb = p_incluir_aitb,
              tipo_saldo  = p_tipo_saldo,
              signo_balance = p_signo_balance,
              relacion_contable = p_relacion_contable,
              codigo_partida = p_codigo_partida,
              id_auxiliar = v_id_auxiliar,
              destino = p_destino,
              orden_cbte =  p_orden_cbte::numeric
			where id_resultado_det_plantilla = v_id_resultado_det_plantilla;
              
                    	
        end if;
    
	end if; 
    
    ALTER TABLE wf.ttipo_proceso ENABLE TRIGGER USER;   
    return 'exito';
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;