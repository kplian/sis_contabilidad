CREATE OR REPLACE FUNCTION conta.f_import_ttipo_relacion_contable (
  p_accion varchar,
  p_codigo_tipo_relacion varchar,
  p_codigo_tabla varchar,
  p_nombre_tipo_relacion varchar,
  p_estado_reg varchar,
  p_tiene_centro_costo varchar,
  p_tiene_partida varchar,
  p_tiene_auxiliar varchar,
  p_partida_tipo varchar,
  p_partida_rubro varchar,
  p_tiene_aplicacion varchar,
  p_tiene_moneda varchar,
  p_tiene_tipo_centro varchar,
  p_codigo_aplicacion_catalogo varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Contabilidad
 FUNCION: 		conta.f_import_ttipo_relacion_contable
 DESCRIPCION:   funcion para insertar la exportacion de columnas de la plantilla archivo excel
 AUTOR: 		EGS
 FECHA:	        03/01/2019
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
 ISSUE		    FECHA    		AUTOR			DESCRIPCION

***************************************************************************/

DECLARE
	
	
    v_id_tabla_relacion_contable		integer;
    v_id_tipo_relacion_contable		integer;
    v_codigo							varchar;
BEGIN
	 


    select id_tabla_relacion_contable into v_id_tabla_relacion_contable
    from conta.ttabla_relacion_contable pc    
    where trim(lower(pc.codigo)) = trim(lower(p_codigo_tabla));
    
    
    select id_tipo_relacion_contable into v_id_tipo_relacion_contable
    from conta.ttipo_relacion_contable dpc    
    where trim(lower(dpc.codigo_tipo_relacion)) = trim(lower(p_codigo_tipo_relacion));
    
    
    if (p_accion = 'delete') then
    	
        update conta.ttipo_relacion_contable set estado_reg = 'inactivo'
    	where id_tipo_relacion_contable = v_id_tipo_relacion_contable;
    
    else
        if (v_id_tipo_relacion_contable is null )then
        		
        	--Sentencia de la insercion
        	insert into conta.ttipo_relacion_contable(
                      estado_reg,
                      nombre_tipo_relacion,
                      tiene_centro_costo,
                      codigo_tipo_relacion,
                      id_tabla_relacion_contable,
                      fecha_reg,
                      id_usuario_reg,
                      fecha_mod,
                      id_usuario_mod,
                      tiene_partida,
                      tiene_auxiliar,
                      partida_tipo,
                      partida_rubro,
                      tiene_aplicacion,
                      tiene_moneda,
                      tiene_tipo_centro,
                      codigo_aplicacion_catalogo
                      
          	) values(
            
                      'activo',
                      p_nombre_tipo_relacion,
                      p_tiene_centro_costo,
                      p_codigo_tipo_relacion,
                      v_id_tabla_relacion_contable,
                      now(),
                      '1',
                      null,
                      null,
                      p_tiene_partida,
                      p_tiene_auxiliar,
                      p_partida_tipo,
                      p_partida_rubro,
                      p_tiene_aplicacion,
                      p_tiene_moneda,
                      p_tiene_tipo_centro,
                      p_codigo_aplicacion_catalogo	
                      			
			);
           
                
        else            
       			--Sentencia de la modificacion
				update conta.ttipo_relacion_contable set
            
                  nombre_tipo_relacion = p_nombre_tipo_relacion,
                  tiene_centro_costo = p_tiene_centro_costo,
                  tiene_partida = p_tiene_partida,
                  tiene_auxiliar = p_tiene_auxiliar,
                  codigo_tipo_relacion = p_codigo_tipo_relacion,
                  id_tabla_relacion_contable = v_id_tabla_relacion_contable,
                  fecha_mod = now(),
                  id_usuario_mod = '1',
                  partida_tipo = p_partida_tipo,
                  partida_rubro =p_partida_rubro,
                  tiene_aplicacion = p_tiene_aplicacion,
                  tiene_moneda =  p_tiene_moneda,
                  tiene_tipo_centro = p_tiene_tipo_centro,
                  codigo_aplicacion_catalogo = p_codigo_aplicacion_catalogo
                  
			where id_tipo_relacion_contable = v_id_tipo_relacion_contable;
         
                    	
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
