--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_import_tplantilla (
  p_accion varchar,
  p_desc_plantilla varchar,
  p_sw_tesoro varchar,
  p_sw_compro varchar,
  p_nro_linea varchar,
  p_tipo varchar,
  p_sw_monto_excento varchar,
  p_sw_descuento varchar,
  p_sw_autorizacion varchar,
  p_sw_codigo_control varchar,
  p_tipo_plantilla varchar,
  p_sw_nro_dui varchar,
  p_sw_ic varchar,
  p_tipo_excento varchar,
  p_valor_excento varchar,
  p_tipo_informe varchar
)
RETURNS varchar AS
$body$
DECLARE
	v_id_plantilla		integer;
BEGIN
	    
    select id_plantilla into v_id_plantilla
    from param.tplantilla plt    
    where trim(lower(plt.desc_plantilla)) = trim(lower(p_desc_plantilla));
    
   
    if (p_accion = 'delete') then
    	
        update param.tplantilla set estado_reg = 'inactivo'
    	where id_plantilla = v_id_plantilla;
        
    else
        if (v_id_plantilla is null)then
            --Sentencia de la insercion
              insert into param.tplantilla(
                  estado_reg,
                  desc_plantilla,
                  sw_tesoro,
                  sw_compro,
                  nro_linea,
                  tipo,
                  fecha_reg,
                  id_usuario_reg,
                  fecha_mod,
                  id_usuario_mod,
                  sw_monto_excento,
                  sw_descuento ,
                  sw_autorizacion,
                  sw_codigo_control,
                  tipo_plantilla,
                  sw_nro_dui,
                  sw_ic,
                  tipo_excento,
                  valor_excento,
                  tipo_informe
              ) values(
                  'activo',
                  p_desc_plantilla,
                  p_sw_tesoro,
                  p_sw_compro,
                  p_nro_linea::NUMERIC,
                  p_tipo::NUMERIC,
                  now(),
                  1,
                  null,
                  null,
                  p_sw_monto_excento,
                  p_sw_descuento ,
                  p_sw_autorizacion,
                  p_sw_codigo_control,
                  p_tipo_plantilla,
                  p_sw_nro_dui,
                  p_sw_ic,
                  p_tipo_excento,
                  p_valor_excento::numeric,
                  p_tipo_informe
  							
              );
              
        else            
            update param.tplantilla set
                desc_plantilla = p_desc_plantilla,
                sw_tesoro = p_sw_tesoro,
                sw_compro = p_sw_compro,
                nro_linea = p_nro_linea::NUMERIC,
                tipo = p_tipo::NUMERIC,
                fecha_mod = now(),
                id_usuario_mod = 1,
                sw_monto_excento = p_sw_monto_excento,
                sw_descuento=p_sw_descuento,
                sw_autorizacion=p_sw_autorizacion,
                sw_codigo_control=p_sw_codigo_control,
                tipo_plantilla=p_tipo_plantilla, 
                sw_nro_dui = p_sw_nro_dui,
                sw_ic = p_sw_ic,
                tipo_excento = p_tipo_excento,
                valor_excento =   p_valor_excento::numeric,
                tipo_informe =  p_tipo_informe
			where id_plantilla=v_id_plantilla;       	
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