--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_eliminar_comprobante_central (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_int_comprobante integer,
  p_conexion varchar = NULL::character varying
)
RETURNS boolean AS
$body$
/*
Autor: RAC KPLIAN
Fecha:   6 junio de 2013
Descripcion  Esta funcion retrocede el estado de los planes de pago cuando los comprobantes son eliminados
  
*/


DECLARE
  
	v_nombre_funcion   	text;
	v_resp				varchar; 
    
    v_int_comprobante 		record;
    
    v_nombre_conexion  varchar;
    
    
    v_consulta varchar;
    resultado	numeric;
    v_respuesta_dblink	varchar;
    
    
BEGIN

	v_nombre_funcion = 'conta.f_eliminar_comprobante_central';
    
    -- Verificar que el int_comprobante no sea null
    
    if (p_id_int_comprobante is null) then
    	raise exception 'Error al eliminar el comprobante de la central, el campo int_comprobante esta vacio';
    end if;
    
    select c.* into v_int_comprobante
    from conta.tint_comprobante c
    where c.id_int_comprobante = p_id_int_comprobante;
    
    --solo retrocede el plan de pagos en la central si el comprobante esta en borrador
    IF v_int_comprobante.estado_reg = 'borrador' then
    
      if (v_int_comprobante.id_int_comprobante_origen_central is null) then
          raise exception 'Error al eliminar el comprobante de la central, se llamo a la funcion para eliminar comprobante de la central, pero no se encontro el id_int_comprobante de la relacion';
      end if;
      
      if p_conexion is null then
          select * into v_nombre_conexion from migra.f_crear_conexion();
      else
          v_nombre_conexion = p_conexion;
      end if;
      
      v_consulta = 'SELECT *
                   FROM conta.f_eliminar_int_comprobante(' || 
                              coalesce(p_id_usuario::varchar, 'NULL') || ',' || 
                              coalesce(p_id_usuario_ai::varchar, 'NULL') || ',' ||
                              coalesce( '''' || p_usuario_ai || '''', 'NULL') || ',' || 
                              coalesce( v_int_comprobante.id_int_comprobante_origen_central::varchar, 'NULL') || ')'; 
                              
      --raise exception '%',v_consulta;
      select * FROM dblink(v_nombre_conexion,
                   v_consulta,TRUE)AS t1(resp varchar)
                           into v_respuesta_dblink;
      
      if p_conexion is null then
          select * into v_resp from migra.f_cerrar_conexion(v_nombre_conexion,'exito'); 
      end if; 
    END IF;
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