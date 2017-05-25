--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_inicia_tramite_wf_cbte (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_int_comprobante integer,
  p_id_gestion integer,
  p_id_depto integer
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

v_codigo_tipo_proceso 	varchar;
v_codigo_proceso_macro  varchar;
v_id_proceso_macro		integer;
v_num_tramite			varchar;
v_id_proceso_wf			integer;
v_id_estado_wf			integer;
v_codigo_estado 		varchar;



 

BEGIN

     v_nombre_funcion = 'conta.f_inicia_tramite_wf_cbte';
   
      ------------------------------
      --  inicia tramite nuevo 
      ----------------------------
      v_codigo_proceso_macro = pxp.f_get_variable_global('conta_codigo_macro_wf_cbte');
      
      --obtener id del proceso macro
      select 
       pm.id_proceso_macro
      into
       v_id_proceso_macro
      from wf.tproceso_macro pm
      where pm.codigo = v_codigo_proceso_macro;
                   
      If v_id_proceso_macro is NULL THEN
        raise exception 'El proceso macro  de codigo % no esta configurado en el sistema WF',v_codigo_proceso_macro;  
      END IF;
                   
     --   obtener el codigo del tipo_proceso
      select   tp.codigo 
       into v_codigo_tipo_proceso
      from  wf.ttipo_proceso tp 
      where   tp.id_proceso_macro = v_id_proceso_macro
            and tp.estado_reg = 'activo' and tp.inicio = 'si';
                          
      IF v_codigo_tipo_proceso is NULL THEN
       raise exception 'No existe un proceso inicial para el proceso macro indicado % (Revise la configuración)',v_codigo_proceso_macro;
      END IF;
      
    
       
                  
    -- inciar el tramite en el sistema de WF
      SELECT 
         ps_num_tramite ,
         ps_id_proceso_wf ,
         ps_id_estado_wf ,
         ps_codigo_estado 
        into
         v_num_tramite,
         v_id_proceso_wf,
         v_id_estado_wf,
         v_codigo_estado   
                        
      FROM wf.f_inicia_tramite(
         p_id_usuario,
         v_parametros._id_usuario_ai,
         v_parametros._nombre_usuario_ai,
         p_id_gestion, 
         v_codigo_tipo_proceso, 
         null,--v_parametros.id_funcionario,
         p_id_depto,
         'Registro de Cbte migrado',
         '' );        
               
               
      IF  v_codigo_estado != 'borrador' THEN
        raise exception 'el estado inicial para cbtes debe ser borrador, revise la configuración del WF';
      END IF;
      
      
      update  conta.tint_comprobante c set
        c.id_estado_wf = v_id_estado_wf,
        c.id_proceso_wf = v_id_proceso_wf,
        c.nro_tramite = v_num_tramite
      where c.id_int_comprobante = p_id_int_comprobante;
          
   
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