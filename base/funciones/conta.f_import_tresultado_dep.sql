--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_import_tresultado_dep (
  p_accion varchar,
  p_codigo_resultado_plantilla_padre varchar,
  p_obs varchar,
  p_prioridad varchar,
  p_estado_reg varchar,
  p_codigo_resultado_plantilla varchar
)
RETURNS varchar AS
$body$
DECLARE
	
   v_id_resultado_plantilla				integer;
   v_id_resultado_plantilla_padre		integer;
   v_id_resultado_dep					integer;
   
BEGIN
	 
    select plt.id_resultado_plantilla into v_id_resultado_plantilla_padre
    from conta.tresultado_plantilla plt    
    where trim(lower(plt.codigo)) = trim(lower(p_codigo_resultado_plantilla_padre));
    
    
    select plt.id_resultado_plantilla into v_id_resultado_plantilla
    from conta.tresultado_plantilla plt    
    where trim(lower(plt.codigo)) = trim(lower(p_codigo_resultado_plantilla));
    
    select plt.id_resultado_dep into v_id_resultado_dep
    from conta.tresultado_dep plt    
    where plt.id_resultado_plantilla_hijo  = v_id_resultado_plantilla 
          and plt.id_resultado_plantilla =  v_id_resultado_plantilla_padre;
          
    
    if (p_accion = 'delete') then
    	
        update conta.tresultado_dep r set estado_reg = 'inactivo'
    	where r.id_resultado_det_plantilla = v_id_resultado_det_plantilla;
    
    else
        if (v_id_resultado_dep is null)then
        
        --Sentencia de la insercion
        	insert into conta.tresultado_dep(
                id_resultado_plantilla,
                id_resultado_plantilla_hijo,
                obs,
                prioridad,
                estado_reg,
                fecha_reg,
                id_usuario_reg
              ) values(
                v_id_resultado_plantilla_padre,
                v_id_resultado_plantilla,
                p_obs,
                p_prioridad::numeric,
                'activo',
                now(),
                1
			);
        		
                
        else 
        
           --Sentencia de la modificacion
			update conta.tresultado_dep set
              id_resultado_plantilla = v_id_resultado_plantilla_padre,
              id_resultado_plantilla_hijo = v_id_resultado_plantilla,
              obs = p_obs,
              prioridad = p_prioridad::numeric,
              fecha_mod = now(),
              id_usuario_mod = 1             
			where id_resultado_dep = v_id_resultado_dep;          
                    	
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