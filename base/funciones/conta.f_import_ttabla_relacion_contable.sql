CREATE OR REPLACE FUNCTION conta.f_import_ttabla_relacion_contable (
  p_accion varchar,
  p_codigo varchar,
  p_estado_reg varchar,
  p_tabla varchar,
  p_esquema varchar,
  p_tabla_id varchar,
  p_tabla_id_fk varchar,
  p_recorrido_arbol varchar,
  p_tabla_codigo_auxiliar varchar,
  p_tabla_id_auxiliar varchar,
  p_tabla_codigo_aplicacion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:	    Sistema Contabilidad
 FUNCION: 		conta.
 DESCRIPCION:   funcion para insertar la exportacion de plantilla
 AUTOR: 		EGS
 FECHA:	        03/01/2019
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
 ISSUE		    FECHA    		AUTOR			DESCRIPCION

***************************************************************************/


DECLARE
	v_id_tabla_relacion_contable		integer;
BEGIN
	    
    
    select plt.id_tabla_relacion_contable into v_id_tabla_relacion_contable
    from conta.ttabla_relacion_contable plt    
    where trim(lower(plt.codigo)) = trim(lower(p_codigo));

    
    -- RAISE Exception 'v_id_plantilla_archivo_excel %',v_id_plantilla_archivo_excel;
    if (p_accion = 'delete') then
    	
        update conta.ttabla_relacion_contable set estado_reg = 'inactivo'
    	where id_tabla_relacion_contable = v_id_tabla_relacion_contable;
        
    else
        if (v_id_tabla_relacion_contable is null)then
            --Sentencia de la insercion        
                  insert into conta.ttabla_relacion_contable(
                    estado_reg,
                    tabla,
                    esquema,
                    tabla_id,
                    fecha_reg,
                    id_usuario_reg,
                    fecha_mod,
                    id_usuario_mod,
                    tabla_id_fk,
                    recorrido_arbol,
                    tabla_codigo_auxiliar,
                    tabla_id_auxiliar,
                    tabla_codigo_aplicacion,
                    codigo
            
                    ) values(
                    'activo',
                    p_tabla,
                    p_esquema,
                    p_tabla_id,
                    now(),
                    '1',
                    null,
                    null,
                    p_tabla_id_fk,
                    p_recorrido_arbol,
                    p_tabla_codigo_auxiliar,
                    p_tabla_id_auxiliar	,
                    p_tabla_codigo_aplicacion,
                    p_codigo		
                    ); 
        else            
            	--Sentencia de la modificacion
           
           update conta.ttabla_relacion_contable set
              tabla = p_tabla,
              esquema = p_esquema,
              tabla_id = p_tabla_id,
              fecha_mod = now(),
              id_usuario_mod = '1',
              tabla_id_fk = p_tabla_id_fk,
              recorrido_arbol = p_recorrido_arbol,
              tabla_codigo_auxiliar=p_tabla_codigo_auxiliar,
              tabla_id_auxiliar=p_tabla_id_auxiliar,
              tabla_codigo_aplicacion=  p_tabla_codigo_aplicacion,
              codigo =  p_codigo            
			where id_tabla_relacion_contable = v_id_tabla_relacion_contable;
            
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
