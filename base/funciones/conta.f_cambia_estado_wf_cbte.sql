--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_cambia_estado_wf_cbte (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_int_comprobante integer,
  p_estado varchar,
  p_obs varchar
)
RETURNS boolean AS
$body$
DECLARE


v_parametros  		record;
v_registros 		record;
v_nombre_funcion   	text;
v_resp				varchar;
v_id_tipo_estado 	integer;
v_id_estado_actual 	integer;



BEGIN

   v_nombre_funcion = 'conta.f_cambia_estado_wf_cbte';
   
   
             select 
              cbt.id_proceso_wf,
              cbt.id_estado_wf,
              cbt.id_depto
             into
              v_registros
             from conta.tint_comprobante cbt 
             where cbt.id_int_comprobante = p_id_int_comprobante;
             
            
   
             -- obtenemos el tipo del estado anulado
            
             select 
              te.id_tipo_estado
             into
              v_id_tipo_estado
             from wf.tproceso_wf pw 
             inner join wf.ttipo_proceso tp on pw.id_tipo_proceso = tp.id_tipo_proceso
             inner join wf.ttipo_estado te on te.id_tipo_proceso = tp.id_tipo_proceso and te.codigo = p_estado               
             where pw.id_proceso_wf = v_registros.id_proceso_wf;
             
             
             
            IF v_id_tipo_estado is NULL  THEN             
                raise exception 'No se parametrizo el estado (%) para el flujo del cbte',p_estado ;
            END IF;
            
            -- pasamos el comprobante al estado solicitado
           
            v_id_estado_actual =  wf.f_registra_estado_wf(v_id_tipo_estado, 
                                                           NULL, 
                                                           v_registros.id_estado_wf, 
                                                           v_registros.id_proceso_wf,
                                                           p_id_usuario,
                                                           p_id_usuario_ai,
                                                           p_usuario_ai,
                                                           v_registros.id_depto,
                                                           p_obs);
    
    
            
           --Se guarda el número del comprobante y se cambia el estado a validado
            update conta.tint_comprobante set
               estado_reg = p_estado,
              id_estado_wf = v_id_estado_actual
            where id_int_comprobante = p_id_int_comprobante;
   
   --retorna resultado
   RETURN TRUE;


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