CREATE OR REPLACE FUNCTION conta.f_procesar_estados_entrega (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_estado_wf integer,
  p_id_proceso_wf integer,
  p_codigo_estado varchar
)
RETURNS boolean AS
$body$
DECLARE
  v_nombre_funcion   	 	text;
    v_resp    			 	varchar;
    v_mensaje 			 	varchar;
    v_entrega		 	    record;

    v_cont 					integer = 0;
    v_record 				record;


    v_revisado				varchar;
BEGIN
  v_nombre_funcion = 'conta.f_procesar_estados_entrega';

     SELECT * into v_entrega
     FROM conta.tentrega
     where id_proceso_wf = p_id_proceso_wf;


if(p_codigo_estado in('supconta','registrado')) then
    	begin
    		update conta.tentrega set
       			id_estado_wf =  p_id_estado_wf,
      			estado = p_codigo_estado,
       			id_usuario_mod=p_id_usuario,
       			id_usuario_ai = p_id_usuario_ai,
		       	usuario_ai = p_usuario_ai,
       			fecha_mod=now()
    			where id_proceso_wf = p_id_proceso_wf;
            end;
         elsif(p_codigo_estado in ('vbconta'))then
    	begin

    		update conta.tentrega set
       			id_estado_wf =  p_id_estado_wf,
      			estado = p_codigo_estado,
       			id_usuario_mod=p_id_usuario,
       			id_usuario_ai = p_id_usuario_ai,
		       	usuario_ai = p_usuario_ai,
       			fecha_mod=now()
    		where id_proceso_wf = p_id_proceso_wf;
    	end;
   elsif(p_codigo_estado in ('finalizado')) then
    	begin
           update conta.tentrega set
       			id_estado_wf =  p_id_estado_wf,
      			estado = p_codigo_estado,
       			id_usuario_mod=p_id_usuario,
       			id_usuario_ai = p_id_usuario_ai,
		       	usuario_ai = p_usuario_ai,
       			fecha_mod=now()
    		where id_proceso_wf = p_id_proceso_wf;
    	end;
   end if;
  return true;
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