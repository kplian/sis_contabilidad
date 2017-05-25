--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_import_tplantilla_calculo (
  p_accion varchar,
  p_desc_plantilla varchar,
  p_descripcion varchar,
  p_prioridad varchar,
  p_debe_haber varchar,
  p_tipo_importe varchar,
  p_codigo_tipo_relacion varchar,
  p_importe varchar,
  p_importe_presupuesto varchar,
  p_descuento varchar
)
RETURNS varchar AS
$body$
DECLARE
	
    v_id_plantilla_calculo		integer;
    v_id_plantilla	integer;
BEGIN
	 


    select id_plantilla into v_id_plantilla
    from param.tplantilla pm    
    where trim(lower(pm.desc_plantilla)) = trim(lower(p_desc_plantilla));
    
    
    select id_plantilla_calculo into v_id_plantilla_calculo
    from conta.tplantilla_calculo pc    
    where trim(lower(pc.descripcion)) = trim(lower(p_descripcion))
          and id_plantilla = v_id_plantilla;
    
    
    if (p_accion = 'delete') then
    	
        update conta.tplantilla_calculo set estado_reg = 'inactivo'
    	where id_plantilla_calculo = v_id_plantilla_calculo;
    
    else
        if (v_id_plantilla_calculo is null)then
        		
                insert into conta.tplantilla_calculo(
                    prioridad,
                    debe_haber,
                    tipo_importe,
                    id_plantilla,
                    codigo_tipo_relacion,
                    importe,
                    descripcion,
                    estado_reg,
                    id_usuario_reg,
                    fecha_reg,
                    fecha_mod,
                    id_usuario_mod,
                    importe_presupuesto,
                    descuento
                ) values(
                    p_prioridad::INTEGER,
                    p_debe_haber,
                    p_tipo_importe,
                    v_id_plantilla,
                    p_codigo_tipo_relacion,
                    p_importe::NUMERIC,
                    p_descripcion,
                    'activo',
                    1,
                    now(),
                    null,
                    null,
                    p_importe_presupuesto::NUMERIC,
                    p_descuento				
                );
           
                
        else            
            update conta.tplantilla_calculo set
                prioridad = p_prioridad::INTEGER,
                debe_haber = p_debe_haber,
                tipo_importe = p_tipo_importe,
                id_plantilla = v_id_plantilla,
                codigo_tipo_relacion = p_codigo_tipo_relacion,
                importe = p_importe::NUMERIC,
                descripcion = p_descripcion,
                fecha_mod = now(),
                id_usuario_mod = 1,
                importe_presupuesto =p_importe_presupuesto::NUMERIC,
                descuento = p_descuento
			where id_plantilla_calculo= v_id_plantilla_calculo;
             
              
                    	
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