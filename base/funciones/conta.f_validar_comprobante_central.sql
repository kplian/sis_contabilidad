--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_validar_comprobante_central (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_int_comprobante integer,
  p_conexion varchar = NULL::character varying
)
RETURNS boolean AS
$body$
/*

Autor: JRR KPLIAN (Todabia no sabe poner comentario)
Fecha:   28 septiembre  de 2015
Descripcion  


        Esta funcion corre despues de validar el cbte de la regional  (solo en comprobantes migrados con origen = central) 
        y replica el resultado a la central (por ejemplo pasa cambia el estado del plan de pagos)

  

*/


DECLARE
  
	v_nombre_funcion   		text;
	v_resp					varchar; 
    v_int_comprobante 		record;
    v_nombre_conexion  		varchar;
    v_codigo_estacion 		varchar;
    v_consulta 				varchar;
    resultado				numeric;
    v_respuesta_dblink		varchar;
    v_funcion_comprobante_validado_central	text;
    
    
BEGIN

	v_nombre_funcion = 'conta.f_validar_comprobante_central';
    
    -- Verificar que el int_comprobante no sea null
    
    if (p_id_int_comprobante is null) then
    	raise exception 'Error al validar el comprobante de la central, el campo int_comprobante esta vacio';
    end if;
    
    select c.* into v_int_comprobante
    from conta.tint_comprobante c    
    where c.id_int_comprobante = p_id_int_comprobante;
    
    if (v_int_comprobante.id_int_comprobante_origen_central is null) then
    	raise exception 'Error al validar el comprobante de la central, se llamo a la funcion para validar comprobante de la central, pero no se encontro el id_int_comprobante de la relacion';
    end if;
    
    if p_conexion is null then
     
    	select * into v_nombre_conexion from migra.f_crear_conexion();
    else
    	v_nombre_conexion = p_conexion;
    end if;
    
    --mandamos el codigo de la estacion  y el idel del cbte de la regional
    
    v_codigo_estacion = pxp.f_get_variable_global('conta_codigo_estacion');
    
    
    
    SELECT *
    FROM dblink(v_nombre_conexion, 'select 
							   	pc.funcion_comprobante_validado  	
							  	from conta.tint_comprobante c
							  	left join  conta.tplantilla_comprobante pc  on pc.id_plantilla_comprobante = c.id_plantilla_comprobante
							  	where c.id_int_comprobante = ' || v_int_comprobante.id_int_comprobante_origen_central)
    AS t1(nombre_funcion text) into v_funcion_comprobante_validado_central;   
          
    if (v_funcion_comprobante_validado_central is not null) then
    	v_consulta = 'select ' || v_funcion_comprobante_validado_central  ||'('||p_id_usuario::varchar||','||
                     COALESCE(p_id_usuario_ai::varchar,'NULL')||','||
                     COALESCE(''''||p_usuario_ai::varchar||'''','NULL')||','|| 
                     v_int_comprobante.id_int_comprobante_origen_central::varchar||', NULL, '||
                     p_id_int_comprobante::varchar||', '''||v_codigo_estacion||''','''||v_int_comprobante.nro_cbte||''')'; 
                            
        --raise exception '%',v_consulta;
        select * FROM dblink(v_nombre_conexion,
                     v_consulta,TRUE)AS t1(resp varchar)
                             into v_respuesta_dblink;
    end if;    	 
          
    
    
    
    if p_conexion is null then
    	select * into v_resp from migra.f_cerrar_conexion(v_nombre_conexion,'exito'); 
    end if;
	RETURN  TRUE;



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