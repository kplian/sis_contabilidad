--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_act_cbte_wf (
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_config_cambiaria_ime
 DESCRIPCION:   en funcion a los codigos de las moendas regresa el tipo de cambio correspondiente
                la conversion se ha pasando por moneda base, si no encuentra regresa NULL
 AUTOR: 		 (rac)  kplian
 FECHA:	        05-11-2015 12:39:12
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE


v_nombre_funcion		varchar;
v_resp					varchar;


v_id_moneda_base		integer;
v_id_moneda_tri			integer;
v_registros_cbte		record;
v_registros_config		record;
v_registros				record;
v_registros_rel 		record;
v_tipo_cambio 			numeric;
v_total_monto_pago		numeric;
v_tipo_cambio_rel_1 	numeric;
v_tipo_cambio_rel_2		numeric;
v_glosa_tran 			varchar;
v_sw_tipo_cambio 		varchar;
v_parcial 				numeric;
v_glosa 				varchar;
v_num_tramite				varchar;
v_id_proceso_wf				integer;
v_id_estado_wf				integer;
v_codigo_estado 			varchar;
v_codigo_proceso_macro 		varchar;
v_id_proceso_macro			integer;
v_codigo_tipo_proceso 		varchar;
v_id_tipo_estado_validado	integer;
v_id_estado_actual			integer;


 

BEGIN

   	v_nombre_funcion = 'conta.f_act_cbte_wf';
   
   --  inicia tramite nuevo 
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
    
    
    select 
    te.id_tipo_estado
   into
    v_id_tipo_estado_validado
   from wf.tproceso_wf pw 
   inner join wf.ttipo_proceso tp on pw.id_tipo_proceso = tp.id_tipo_proceso
   inner join wf.ttipo_estado te on te.id_tipo_proceso = tp.id_tipo_proceso and te.codigo = 'validado'
   where tp.codigo = v_codigo_tipo_proceso
         and  tp.id_proceso_macro = v_id_proceso_macro;
   
   
   FOR v_registros in (select
                         ic.id_int_comprobante,
                         ic.nro_tramite,
                         ic.fecha,
                         ic.id_periodo,
                         pe.id_gestion,
                         ic.id_depto,
                         ic.estado_reg
                       from conta.tint_comprobante ic
                       inner join param.tperiodo pe on pe.id_periodo = ic.id_periodo
                       where ic.id_estado_wf is null and  ic.estado_reg = 'borrador'
                              -- ic.id_int_comprobante in (19800)
                       
                       ) LOOP
                       
          
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
                 1,
                 NULL,
                 NULL,
                 v_registros.id_gestion, 
                 v_codigo_tipo_proceso, 
                 null,--v_parametros.id_funcionario,
                 v_registros.id_depto,
                 'Regularizacion de WF para el cbte',
                 '' ); 
                 
                 raise notice 'v_registros.nro_tramite...  %',v_registros.nro_tramite;
          
                 IF v_registros.nro_tramite is null or  v_registros.nro_tramite = '' THEN
                   v_num_tramite = v_num_tramite;
                 ELSE
                   v_num_tramite =  v_registros.nro_tramite;
                 END IF;
                 
                
                 IF  v_registros.estado_reg = 'validado' THEN
                 
                    v_id_estado_actual =  wf.f_registra_estado_wf(v_id_tipo_estado_validado, 
                                                           NULL, 
                                                           v_id_estado_wf, 
                                                           v_id_proceso_wf,
                                                           1,
                                                           null,
                                                           null,
                                                           v_registros.id_depto,
                                                           'regularización del WF en cbte');
                    
                    v_id_estado_wf = v_id_estado_wf;
                     
                 END IF;
                
                
               update conta.tint_comprobante ic set
                    nro_tramite = v_num_tramite,
                    id_proceso_wf = v_id_proceso_wf,
                    id_estado_wf = v_id_estado_wf
               where ic.id_int_comprobante = v_registros.id_int_comprobante; 
              
              
                
   
   
   END LOOP;
                       
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