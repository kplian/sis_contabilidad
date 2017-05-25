--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_import_tplantilla_comprobante (
  p_accion varchar,
  p_codigo varchar,
  p_funcion_comprobante_eliminado varchar,
  p_id_tabla varchar,
  p_campo_subsistema varchar,
  p_campo_descripcion varchar,
  p_funcion_comprobante_validado varchar,
  p_campo_fecha varchar,
  p_estado_reg varchar,
  p_campo_acreedor varchar,
  p_campo_depto varchar,
  p_momento_presupuestario varchar,
  p_campo_fk_comprobante varchar,
  p_tabla_origen varchar,
  p_clase_comprobante varchar,
  p_campo_moneda varchar,
  p_campo_gestion_relacion varchar,
  p_otros_campos varchar,
  p_momento_comprometido varchar,
  p_momento_ejecutado varchar,
  p_momento_pagado varchar,
  p_campo_id_cuenta_bancaria varchar,
  p_campo_id_cuenta_bancaria_mov varchar,
  p_campo_nro_cheque varchar,
  p_campo_nro_cuenta_bancaria_trans varchar,
  p_campo_nro_tramite varchar,
  p_campo_tipo_cambio varchar,
  p_campo_depto_libro varchar,
  p_campo_fecha_costo_ini varchar,
  p_campo_fecha_costo_fin varchar,
  p_funcion_comprobante_editado varchar,
  p_desc_plantilla varchar = ''::character varying
)
RETURNS varchar AS
$body$
DECLARE
	v_id_plantilla_comprobante		integer;
BEGIN
	    
    
    select id_plantilla_comprobante into v_id_plantilla_comprobante
    from conta.tplantilla_comprobante plt    
    where trim(lower(plt.codigo)) = trim(lower(p_codigo));
    
   
    if (p_accion = 'delete') then
    	
        update conta.tplantilla_comprobante set estado_reg = 'inactivo'
    	where id_plantilla_comprobante = v_id_plantilla_comprobante;
        
    else
        if (v_id_plantilla_comprobante is null)then
            --Sentencia de la insercion
             insert into conta.tplantilla_comprobante(
                codigo,
                funcion_comprobante_eliminado,
                id_tabla,
                campo_subsistema,
                campo_descripcion,
                funcion_comprobante_validado,
                campo_fecha,
                estado_reg,
                campo_acreedor,
                campo_depto,
                momento_presupuestario,
                campo_fk_comprobante,
                tabla_origen,
                clase_comprobante,
                campo_moneda,
                id_usuario_reg,
                fecha_reg,
                id_usuario_mod,
                fecha_mod,
                campo_gestion_relacion	,
                otros_campos, 
                momento_comprometido,
                momento_ejecutado,
                momento_pagado,
                campo_id_cuenta_bancaria,
                campo_id_cuenta_bancaria_mov,
                campo_nro_cheque,
                campo_nro_cuenta_bancaria_trans,
                campo_nro_tramite,
                campo_tipo_cambio,
                campo_depto_libro,
                campo_fecha_costo_ini,
                campo_fecha_costo_fin,
                funcion_comprobante_editado,
                desc_plantilla
             
          	) values(
                p_codigo,
                p_funcion_comprobante_eliminado,
                p_id_tabla,
                p_campo_subsistema,
                p_campo_descripcion,
                p_funcion_comprobante_validado,
                p_campo_fecha,
                'activo',
                p_campo_acreedor,
                p_campo_depto,
                p_momento_presupuestario,
                p_campo_fk_comprobante,
                p_tabla_origen,
                p_clase_comprobante,
                p_campo_moneda,
                1,
                now(),
                null,
                null,
                p_campo_gestion_relacion,
                p_otros_campos ,
                p_momento_comprometido,
                p_momento_ejecutado,
                p_momento_pagado,
                p_campo_id_cuenta_bancaria,
                p_campo_id_cuenta_bancaria_mov,
                p_campo_nro_cheque,
                p_campo_nro_cuenta_bancaria_trans,
                p_campo_nro_tramite,
                p_campo_tipo_cambio,
                p_campo_depto_libro,
                p_campo_fecha_costo_ini,
                p_campo_fecha_costo_fin,
                p_funcion_comprobante_editado,
                p_desc_plantilla
							
			);
              
        else            
            update conta.tplantilla_comprobante set
                codigo=p_codigo,
                funcion_comprobante_eliminado = p_funcion_comprobante_eliminado,
                id_tabla = p_id_tabla,
                campo_subsistema = p_campo_subsistema,
                campo_descripcion = p_campo_descripcion,
                funcion_comprobante_validado = p_funcion_comprobante_validado,
                campo_fecha = p_campo_fecha,
                campo_acreedor = p_campo_acreedor,
                campo_depto = p_campo_depto,
                momento_presupuestario = p_momento_presupuestario,
                campo_fk_comprobante = p_campo_fk_comprobante,
                tabla_origen = p_tabla_origen,
                clase_comprobante = p_clase_comprobante,
                campo_moneda = p_campo_moneda,
                id_usuario_mod = 1,
                fecha_mod = now(),
                campo_gestion_relacion=p_campo_gestion_relacion,
                otros_campos=p_otros_campos,
                momento_comprometido=p_momento_comprometido,
                momento_ejecutado=p_momento_ejecutado,
                momento_pagado=p_momento_pagado,
                campo_id_cuenta_bancaria=p_campo_id_cuenta_bancaria,
                campo_id_cuenta_bancaria_mov=p_campo_id_cuenta_bancaria_mov,
                campo_nro_cheque = p_campo_nro_cheque,
                campo_nro_cuenta_bancaria_trans= p_campo_nro_cuenta_bancaria_trans,
                campo_nro_tramite= p_campo_nro_tramite,
                campo_tipo_cambio = p_campo_tipo_cambio,
                campo_depto_libro = p_campo_depto_libro,
                campo_fecha_costo_ini = p_campo_fecha_costo_ini,
                campo_fecha_costo_fin = p_campo_fecha_costo_fin,
                funcion_comprobante_editado = p_funcion_comprobante_editado,
                desc_plantilla = p_desc_plantilla
			where id_plantilla_comprobante  = v_id_plantilla_comprobante;      	
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