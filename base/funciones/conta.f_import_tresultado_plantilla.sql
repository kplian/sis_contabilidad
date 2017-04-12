--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_import_tresultado_plantilla (
  p_accion varchar,
  p_codigo varchar,
  p_estado_reg varchar,
  p_nombre varchar,
  p_tipo varchar,
  p_cbte_aitb varchar,
  p_cbte_apertura varchar,
  p_cbte_cierre varchar,
  p_periodo_calculo varchar,
  p_glosa varchar,
  p_codigo_clase_comprobante varchar,
  p_id_resultado_plantilla_hijo varchar,
  p_relacion_unica varchar = 'no'::character varying,
  p_codigo_tipo_relacion_comprobante varchar = ''::character varying
)
RETURNS varchar AS
$body$
DECLARE
	v_id_resultado_plantilla		integer;
    v_id_clase_comprobante		    integer;
    v_id_tipo_relacion_comprobante  integer;
BEGIN
	    
    
    select plt.id_resultado_plantilla into v_id_resultado_plantilla
    from conta.tresultado_plantilla plt    
    where trim(lower(plt.codigo)) = trim(lower(p_codigo));
    
    select plt.id_clase_comprobante into v_id_clase_comprobante
    from conta.tclase_comprobante  plt    
    where trim(lower(plt.codigo)) = trim(lower(p_codigo_clase_comprobante));
    
    select trc.id_tipo_relacion_comprobante into v_id_tipo_relacion_comprobante
    from conta.ttipo_relacion_comprobante  trc    
    where trim(lower(trc.codigo)) = trim(lower(p_codigo_tipo_relacion_comprobante));
    
   
    if (p_accion = 'delete') then
    	
        update conta.tresultado_plantilla set estado_reg = 'inactivo'
    	where id_resultado_plantilla = v_id_resultado_plantilla;
        
    else
        if (v_id_resultado_plantilla is null)then
            
                          insert into conta.tresultado_plantilla(
                                codigo,
                                estado_reg,
                                nombre,
                                id_usuario_reg,
                                fecha_reg,
                                tipo,
                                cbte_aitb,
                                cbte_apertura,
                                cbte_cierre,
                                periodo_calculo,
                                id_clase_comprobante,
                                glosa,
                                relacion_unica,
                                id_tipo_relacion_comprobante
                          ) values(
                                 p_codigo,
                                'activo',
                                 p_nombre,
                                 1,
                                 now(),
                                 p_tipo,
                                 p_cbte_aitb,
                                 p_cbte_apertura,
                                 p_cbte_cierre,
                                 p_periodo_calculo,
                                 v_id_clase_comprobante,
                                 p_glosa,
                                 p_relacion_unica,
                                 v_id_tipo_relacion_comprobante);
             
        else            
            
            update conta.tresultado_plantilla set
                codigo = p_codigo,
                nombre = p_nombre,
                fecha_mod = now(),
                id_usuario_mod = 1,             
                tipo = p_tipo,
                cbte_aitb = p_cbte_aitb,
                cbte_apertura = p_cbte_apertura,
                cbte_cierre = p_cbte_cierre,
                periodo_calculo = p_periodo_calculo,
                id_clase_comprobante = v_id_clase_comprobante,
                glosa = p_glosa,
                relacion_unica = p_relacion_unica,
                id_tipo_relacion_comprobante = v_id_tipo_relacion_comprobante
			where id_resultado_plantilla = v_id_resultado_plantilla;
            	
        end if;
    
	end if;   
    return 'exito';
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;