--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_gen_proc_plantilla_calculo (
  p_hstore_transaccion public.hstore,
  p_id_plantilla integer,
  p_monto numeric,
  p_id_usuario integer,
  p_id_depto_conta integer,
  p_id_gestion integer,
  p_prioridad_documento integer = 2,
  p_proc_terci varchar = 'no'::character varying,
  p_porc_monto_excento_var numeric = 0
)
RETURNS integer [] AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.f_gen_proc_plantilla_calculo
 DESCRIPCION:   esta funcion procesa la plantilla de calculo e insertar las transacciones necesarias
 AUTOR: 		 RAC KPLIAN
 FECHA:	        04-09-2013 03:51:00
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_transaccion	integer;
    
    v_registros record;
    v_record_int_tran    conta.tint_transaccion;
    v_record_rel_con  record;
    v_id_centro_costo_depto integer;
    v_monto_x_aplicar  numeric;
    v_monto_x_aplicar_pre  numeric;
    v_reg_id_int_transaccion integer;
    v_resp_doc boolean;
    v_int_resp INTEGER[];
    v_cont integer;
    v_monto_revertir numeric;
    v_factor_reversion numeric;
    
    v_sw_calcular_excento boolean;
    v_porc_monto_imponible numeric;
    v_porc_importe numeric;
    v_porc_importe_presupuesto numeric;
     v_conta_partidas				varchar;
			    
BEGIN

    v_nombre_funcion = 'conta.f_gen_proc_plantilla_calculo';
    
    v_monto_revertir = 0;
    v_factor_reversion = 0;
    p_porc_monto_excento_var = COALESCE(p_porc_monto_excento_var,0);
    
    --RAC 11/02/2014, agrega la capacidad de calcular si el documento utiliza el monto excento
    v_sw_calcular_excento  = TRUE;
    if p_porc_monto_excento_var >= 0 THEN
       v_porc_monto_imponible = 1.00 - p_porc_monto_excento_var;
    END IF;
    
    
    IF v_porc_monto_imponible  < 0 THEN
       raise exception 'el porcentaje de excento  no peude ser menor a cero, revise la configuracion del excento en la plantilla de comprobante,  el campo excento debe ser porcentual entre 0 y 1';
    END IF;
  

   IF p_id_plantilla is NULL THEN
      raise exception 'no se encontro ningun id para la plantila de calculo';
   END IF;
   
   
     
     
    v_cont = 1;
     -- FOR obtener las plantillas calculos del documento(id_plantlla)
     FOR v_registros in ( 
                          SELECT  pc.id_plantilla_calculo,
                                  pc.debe_haber,
                                  pc.codigo_tipo_relacion,
                                  pc.tipo_importe,
                                  pc.importe,
                                  pc.prioridad,
                                  pc.descripcion,
                                  pc.importe_presupuesto,
                                  plan.sw_monto_excento
                          FROM  conta.tplantilla_calculo pc 
                          inner join param.tplantilla plan on plan.id_plantilla = pc.id_plantilla
                          WHERE pc.estado_reg = 'activo' and
                                pc.id_plantilla = p_id_plantilla
                           order by pc.prioridad ) LOOP
                           
          --confirma  si es necesario el monto excento             
          IF v_registros.sw_monto_excento = 'no'  and v_sw_calcular_excento THEN
              v_sw_calcular_excento = FALSE;   
          END IF; 
          
                     
                           
     
        --IF es registro primario o secundario  
        
        IF  p_proc_terci = 'si' or (v_registros.prioridad <= p_prioridad_documento )   THEN  -- p_prioridad_documento  por defecto tiene el valor de dos
        
             --  crea un record del tipo de la transaccion  
                
              v_record_int_tran = populate_record(null::conta.tint_transaccion,p_hstore_transaccion);
             
             --  obtine valor o porcentajes aplicado
               IF v_registros.tipo_importe = 'porcentaje' THEN
               
               
               
               
                   IF v_sw_calcular_excento  THEN
                      
                      
                        -- si se considera el porcentaje de monto imponible 
                        --multiplicamos los factores para obtener un nuevo valor
                        v_porc_importe = v_porc_monto_imponible * v_registros.importe; 
                        v_porc_importe_presupuesto = v_porc_monto_imponible * v_registros.importe_presupuesto;
                        
                        
                       --si es una trasaccion primeria (priorida =1 )se suma el porcentaje del monto no imponible
                       IF v_registros.prioridad = 1 THEN
                             v_porc_importe = v_porc_importe + p_porc_monto_excento_var;
                             v_porc_importe_presupuesto = v_porc_importe_presupuesto + p_porc_monto_excento_var;
                       END IF;
                       
                     
                         
                     
                      
                   ELSE
                   
                     v_porc_importe = v_registros.importe; 
                     v_porc_importe_presupuesto = v_registros.importe_presupuesto;
                   
                   END IF; 
                   
                                
               
                  v_monto_x_aplicar = (p_monto * v_porc_importe)::numeric;
                  v_monto_x_aplicar_pre = (p_monto * v_porc_importe_presupuesto)::numeric;
                  
                  v_monto_revertir = p_monto - v_monto_x_aplicar_pre;
                  v_factor_reversion  = 1 - v_porc_importe_presupuesto; 
                  
               
               ELSE
               
                  v_monto_x_aplicar = v_registros.importe::numeric;
                  v_monto_x_aplicar_pre = v_registros.importe_presupuesto::numeric;
               END IF;
               
               
              --  IF  p_id_plantilla =  25  THEN
              --      raise exception '% ,  %    ', v_monto_x_aplicar, v_monto_revertir;
              -- END IF; 
               
               
               --  acomoda en el debe o haber 
               --  acomoda la ejecucion presupuestaria
               
               IF v_registros.debe_haber = 'debe' THEN
               
                  v_record_int_tran.importe_debe = v_monto_x_aplicar;
                  v_record_int_tran.importe_gasto =  v_monto_x_aplicar_pre;
                  v_record_int_tran.importe_haber = 0;
                  v_record_int_tran.importe_recurso = 0;
                  
               ELSE
               
                  v_record_int_tran.importe_debe = 0;
                  v_record_int_tran.importe_gasto =  0;
                  v_record_int_tran.importe_haber = v_monto_x_aplicar;
                  v_record_int_tran.importe_recurso = v_monto_x_aplicar_pre;
               
               END IF;
               
               v_record_int_tran.importe_reversion = v_monto_revertir;
               v_record_int_tran.factor_reversion = v_factor_reversion;
               
               
               -- si no es una trasaccion primaria obtener centro de costo del departamento
               
               IF v_registros.prioridad > 1 THEN
               
               -- obtener centro de consto del depto contable  CCDEPCON
              
               --  TODO , obtener replicar el centro de costo ???
                  
                  v_record_int_tran.glosa = v_registros.descripcion;
                  
                  --raise notice ')))))))))))))) p_id_gestion = %, p_id_depto_conta = % ',p_id_gestion,p_id_depto_conta ;
                  
                  SELECT 
                      ps_id_centro_costo 
                     into 
                       v_id_centro_costo_depto 
                   FROM conta.f_get_config_relacion_contable('CCDEPCON', -- relacion contable que almacena los centros de costo por departamento
                   										     p_id_gestion, 
                                                             p_id_depto_conta, --id_tabla
                                                             NULL);  --id_dento_costo
               
                  v_record_int_tran.id_centro_costo = v_id_centro_costo_depto;
              
               END IF;
               --  aplicar relacion contable si existe
               
               
               
               
               IF  v_registros.codigo_tipo_relacion != '' and v_registros.codigo_tipo_relacion is not null THEN
               
                  
               		SELECT 
                      * 
                     into 
                       v_record_rel_con 
                    FROM conta.f_get_config_relacion_contable(v_registros.codigo_tipo_relacion, 
                   										     p_id_gestion, 
                                                             NULL, --id_tabla
                                                             v_record_int_tran.id_centro_costo);  --id_dento_costo
                                                             
                                                             
                    -- si la relacion contable tiene centro de costo unico, .... 
                    -- OJO podria tener algun BUG
                    if v_record_rel_con.ps_id_centro_costo is not null THEN
                       v_record_int_tran.id_centro_costo = v_record_rel_con.ps_id_centro_costo;
                    END IF;
                    
                    
                    IF(v_record_rel_con.ps_id_cuenta is NULL) THEN
                       raise exception 'Revisar la ps_id_cuenta para la relacion contable:  % (%)',  v_record_rel_con.ps_nombre_tipo_relacion,v_registros.codigo_tipo_relacion;
                    END IF;
                    
                    v_conta_partidas = pxp.f_get_variable_global('conta_partidas');
                    
                    IF v_conta_partidas = 'si' THEN                    
                      IF(v_record_rel_con.ps_id_partida is NULL) THEN
                        raise exception 'Revisar la partida para la relacion contable:  % (%)',  v_record_rel_con.ps_nombre_tipo_relacion,v_registros.codigo_tipo_relacion;
                      END IF;
                    END IF;
                    
                    
                  
                    
                    
                    --replanza las cuenta, partida y auxiliar obtenidos 
                 
                     v_record_int_tran.id_cuenta = v_record_rel_con.ps_id_cuenta;
                     v_record_int_tran.id_partida = v_record_rel_con.ps_id_partida;
                     v_record_int_tran.id_auxiliar = v_record_rel_con.ps_id_auxiliar;
                    
               
               END IF;
              
               --inserta transaccion en tabla
               v_reg_id_int_transaccion = conta.f_gen_inser_transaccion(hstore(v_record_int_tran), p_id_usuario);
               
                v_int_resp[v_cont] = v_reg_id_int_transaccion;
                v_cont = v_cont + 1;
            
            
           END IF;
    
		   
        
        END LOOP;    
            return v_int_resp;

	
	 --Devuelve la respuesta

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