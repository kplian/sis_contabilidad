-- FUNCTION: conta.f_gen_proc_plantilla_calculo(hstore, integer, numeric, integer, integer, integer, character varying, integer, character varying, numeric, character varying, integer)

-- DROP FUNCTION conta.f_gen_proc_plantilla_calculo(hstore, integer, numeric, integer, integer, integer, character varying, integer, character varying, numeric, character varying, integer);

CREATE OR REPLACE FUNCTION conta.f_gen_proc_plantilla_calculo(
	p_hstore_transaccion hstore,
	p_id_plantilla integer,
	p_monto numeric,
	p_id_usuario integer,
	p_id_depto_conta integer,
	p_id_gestion integer,
	p_incluir_desc_doc character varying,
	p_prioridad_documento integer DEFAULT 2,
	p_proc_terci character varying DEFAULT 'no'::character varying,
	p_porc_monto_excento_var numeric DEFAULT 0,
	p_procesar_prioridad_principal character varying DEFAULT 'si'::character varying,
	p_id_taza_impuesto integer DEFAULT NULL::integer
    ,p_insertar_prioridad_principal varchar DEFAULT 'si'
    )
    RETURNS integer[]
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.f_gen_proc_plantilla_calculo
 DESCRIPCION:   aplica la logica de plantilla de calculo al detalle las trasaccion contables de la plantilla de cbte segun configuracion  
 AUTOR: 		 RAC KPLIAN
 FECHA:	        04-09-2013 03:51:00
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	Ajuste par aconsiderar nuevas variables usar_cc_original, imputar_excento
 AUTOR:	    	RAC	 
 FECHA:		    05/01/2018
 
 HISTORIAL DE MODIFICACIONES:
   	
 ISSUE            FECHA:		      AUTOR                 DESCRIPCION
 #0             04/09/2013      RAC                        Creación  
 #0        		05/01/2018      Rensi Arteaga Copari       Ajuste par aconsiderar nuevas variables usar_cc_original, imputar_excento
 #98       		20/08/2018      Rensi Arteaga Copari       Feu adicionado un nnuevo tipo de aplicacion de excento para permitir la facturas de combustible
 #13            03/01/2018      RAC KPLIAN                 PRocesa la opcion resetear partida ejecucion de las plantillas de calculo
 #21            10/01/2019      RArteaga                   Considerar configuracion apra aplicacar o no descuentos,  incluir_desc_doc 
 #30  ETR       05/02/2019      RArtega                    Se adciona campo para almacenar los centro de costo original en plantillas secundaias para facilitar reportes
 #42  ETR       01/04/2019      calvarez                   correción de gerenación de comprobantes
 #66  ETR       24/07/2019      RArteaga                   adicionar el campo p_id_taza_impuesto
*************************************************************************************************************************************************/

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
    v_porc_importe_presupuesto      numeric;
    v_conta_partidas				varchar;
    v_registros_rest                record;
    v_reg_taza_imp                 record;  -- #66
    v_porc_prin                     numeric; -- #66
    v_porc_secu                     numeric; -- #66
    v_porc_prin_pre                 numeric; -- #66
    v_porc_secu_pre                 numeric; -- #66      
	v_sw_aux						varchar;	    
BEGIN

    v_nombre_funcion = 'conta.f_gen_proc_plantilla_calculo';
    v_sw_aux:='si';
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
                                  plan.sw_monto_excento,
                                  pc.imputar_excento,
                                  pc.usar_cc_original,
                                  pc.sw_registro,
                                  pc.reset_partida_eje,
                                  pc.descuento  -- #21
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
              
                     -- #21 revisar configuracion de descuentos      
                     --  AND p_procesar_prioridad_principal = 'si'
                     IF     p_incluir_desc_doc = 'todos' 
                        OR  (v_registros.prioridad = 1)
                        OR  (p_incluir_desc_doc = 'descuento'  AND  v_registros.descuento = 'si' )
                        OR  (p_incluir_desc_doc = 'no_descuento' AND v_registros.descuento = 'no' )        THEN    
                           
                           --  crea un record del tipo de la transaccion  

                            v_record_int_tran = populate_record(null::conta.tint_transaccion,p_hstore_transaccion);
                           
                           --  obtine valor o porcentajes aplicado
                             IF v_registros.tipo_importe = 'porcentaje' THEN
                             
                                 IF v_sw_calcular_excento  THEN
                                    
                                    
                                      -- si se considera el porcentaje de monto imponible 
                                      -- multiplicamos los factores para obtener un nuevo valor
                                      v_porc_importe = v_porc_monto_imponible * v_registros.importe; 
                                      v_porc_importe_presupuesto = v_porc_monto_imponible * v_registros.importe_presupuesto;
                                      
                                      
                                     -- si es una trasaccion primeria (priorida =1 )se suma el porcentaje del monto no imponible
                                     -- si imputar_excento, es si,  el importe  lo retira del prioridad 1 y lo imputa a la propiedad 2 que este marcada
                                     
                                     IF v_registros.prioridad = 1  and   v_registros.imputar_excento = 'no' THEN
                                           v_porc_importe = v_porc_importe + p_porc_monto_excento_var;
                                           v_porc_importe_presupuesto = v_porc_importe_presupuesto + p_porc_monto_excento_var;
                                     END IF;
                                     
                                     
                                     --es la transaccion primaria menos el monto excento
                                     IF v_registros.prioridad = 1  and   v_registros.imputar_excento = 'si' THEN
                                           v_porc_importe = v_porc_importe ;
                                           v_porc_importe_presupuesto = v_porc_importe_presupuesto;
                                     END IF;
                                     
                                     --#98 20/08/2018... si es te tipo nada  solo deja el porcetaje configurado sin considerar el excento
                                     IF v_registros.prioridad = 1  and   v_registros.imputar_excento = 'nada' THEN
                                           v_porc_importe = v_registros.importe ;
                                           v_porc_importe_presupuesto = v_registros.importe_presupuesto;
                                     END IF;
                                     
                                     --#98  multiplica por el porcentaje configurado en la plantilla..... osea aplica en este porcentaje el excento apra la trasaccion
                                     IF v_registros.prioridad = 2  and   v_registros.imputar_excento = 'si' THEN
                                           v_porc_importe =  p_porc_monto_excento_var* v_registros.importe;
                                           v_porc_importe_presupuesto =  p_porc_monto_excento_var* v_registros.importe_presupuesto;
                                     END IF;
                                     
                                     --FIN RAC 05/01/2017
                                     
                                    
                                 
                                 ELSE
                                 
                                   v_porc_importe = v_registros.importe; 
                                   v_porc_importe_presupuesto = v_registros.importe_presupuesto;
                                 
                                 END IF; 
                                
                                              
                                if v_registros.prioridad > 1 or (v_registros.prioridad = 1 and p_procesar_prioridad_principal = 'si') then

                                  v_monto_x_aplicar = (p_monto * v_porc_importe)::numeric;
                                  v_monto_x_aplicar_pre = (p_monto * v_porc_importe_presupuesto)::numeric;
                                else
                                  v_monto_x_aplicar = (p_monto)::numeric;
                                  v_monto_x_aplicar_pre = (p_monto)::numeric;
                                end if;
                                
                                v_monto_revertir = p_monto - v_monto_x_aplicar_pre;
                                v_factor_reversion  = 1 - v_porc_importe_presupuesto; 

                             ELSEIF v_registros.tipo_importe = 'taza' THEN  -- #66  considera montos calculado por taza
                             
                                   IF p_id_taza_impuesto is NULL THEN
                                      raise exception 'el documento esta configurado para usar taza pero  no se obtuvo ningun resultado del detalle plantilla de cbte';
                                   END IF;
                                   
                                   --recuperar configuracion de taza
                                   SELECT ti.factor_impuesto, ti.tipo, ti.factor_impuesto_pre
                                   INTO
                                   v_reg_taza_imp
                                   FROM param.ttaza_impuesto ti
                                   WHERE ti.id_taza_impuesto = p_id_taza_impuesto;
                                   
                                   IF v_reg_taza_imp.tipo = 'nominal' THEN  --taza nominal es la forma de calculo de impuesto de Bolivia                                     
                                       --definir los porcentajes para contabilidad
                                       v_porc_secu = v_reg_taza_imp.factor_impuesto;
                                       v_porc_prin = 1 - v_reg_taza_imp.factor_impuesto;
                                       --definir los porcetajes para presupuestos
                                       v_porc_secu_pre = v_reg_taza_imp.factor_impuesto_pre;
                                       v_porc_prin_pre = 1 - v_reg_taza_imp.factor_impuesto_pre;
                                       
                                   
                                   ELSE  --  taza efectiva es la forma de calculo de impuesto de argetina                                       
                                       v_porc_secu =  v_reg_taza_imp.factor_impuesto / (1 + v_reg_taza_imp.factor_impuesto);                                       
                                       v_porc_prin = 1  - v_porc_secu;                                       
                                       v_porc_secu_pre =  v_reg_taza_imp.factor_impuesto_pre / (1 + v_reg_taza_imp.factor_impuesto_pre);                                       
                                       v_porc_prin_pre = 1  - v_porc_secu_pre;
                                   
                                   END IF;
                                   
                                   
                                   IF v_registros.prioridad = 1 THEN
                                   
                                      IF p_procesar_prioridad_principal = 'si' THEN
                                        v_monto_x_aplicar = (p_monto * v_porc_prin)::numeric;
                                        v_monto_x_aplicar_pre = (p_monto * v_porc_prin_pre)::numeric;
                                      ELSE
                                        v_monto_x_aplicar = (p_monto)::numeric;
                                        v_monto_x_aplicar_pre = (p_monto)::numeric;
                                      END IF;
                                         
                                   ELSE
                                       v_monto_x_aplicar = (p_monto * v_porc_secu)::numeric;
                                       v_monto_x_aplicar_pre = (p_monto * v_porc_secu_pre)::numeric;
                                   END IF;
                                   
                                   
                                  v_monto_revertir = p_monto - v_monto_x_aplicar_pre;
                                  v_factor_reversion  = 1 - v_porc_importe_presupuesto; 
                             
                             ELSE --#66 fin
                             
                                v_monto_x_aplicar = v_registros.importe::numeric;
                                v_monto_x_aplicar_pre = v_registros.importe_presupuesto::numeric;
                             END IF;

                                                     
                              IF v_registros.sw_registro = 'si'  THEN
                             
                                   -- si es prorirdad 1 y tiene alguna trasaccion de mauor priodidad del tipo restar
                                   IF v_registros.prioridad  =  1 THEN
                                      
                                           FOR v_registros_rest in (  
                                              SELECT  
                                                      pc.tipo_importe,
                                                      sum(pc.importe) as importe,
                                                      sum(pc.importe_presupuesto) as importe_presupuesto
                                              FROM  conta.tplantilla_calculo pc 
                                              inner join param.tplantilla plan on plan.id_plantilla = pc.id_plantilla
                                              WHERE pc.estado_reg = 'activo' and
                                                    pc.id_plantilla = p_id_plantilla 
                                                    and pc.sw_restar = 'si'  
                                              GROUP BY  pc.tipo_importe) LOOP
                                              
                                                     IF v_registros_rest.tipo_importe = 'porcentaje' THEN                                           
                                                        v_monto_x_aplicar = v_monto_x_aplicar - (v_monto_x_aplicar* COALESCE(v_registros_rest.importe,0));
                                                        v_monto_x_aplicar_pre = v_monto_x_aplicar_pre - (v_monto_x_aplicar* COALESCE(v_registros_rest.importe_presupuesto,0));
                                                        
                                                     ELSE
                                                        v_monto_x_aplicar = v_monto_x_aplicar - COALESCE(v_registros_rest.importe,0);
                                                        v_monto_x_aplicar_pre = v_monto_x_aplicar_pre - COALESCE(v_registros_rest.importe_presupuesto,0);
                                                     END IF;
                                              
                                              END LOOP;
                                   
                                   END IF;
                             
                             END IF;
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

                             --#30 salva el centro de costo original antes de una posible modificacion
                             v_record_int_tran.id_centro_costo_ori = v_record_int_tran.id_centro_costo;
                             
                             
                             -- si no es una trasaccion primaria obtener centro de costo del departamento
                             --RAC 05/01/2018, se considera si para este transaccion requiere el Centro de Costo original
                             IF v_registros.prioridad > 1 and v_registros.usar_cc_original = 'no' THEN --RAC 05/01/2018, se adiciona  usar_cc_original = 'no'
                             
                             -- obtener centro de consto del depto contable  CCDEPCON
                            
                             --  TODO , obtener replicar el centro de costo ???
                                
                                v_record_int_tran.glosa = v_registros.descripcion;
                                                                
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
                                     raise exception 'Revisar la ps_id_cuenta para la relacion contable:  % (%) ID(%)',  v_record_rel_con.ps_nombre_tipo_relacion,v_registros.codigo_tipo_relacion, v_record_int_tran.id_centro_costo;
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
                             

                             ELSEIF v_registros.prioridad > 1 AND v_registros.tipo_importe = 'taza' AND p_id_taza_impuesto IS NOT NULL THEN  
                               -- #66 si es prioridad > 1 y si no existe codigo de relacion contable pero tenemos taza tratamos de recuperar el codigo de relacion contable para la taza     
                                  SELECT 
                                    * 
                                  INTO 
                                    v_record_rel_con 
                                  FROM conta.f_get_config_relacion_contable('TAZAIMP', 
                                                                          p_id_gestion, 
                                                                          p_id_taza_impuesto, --id_tabla
                                                                          v_record_int_tran.id_centro_costo);  --id_dento_costo
                                
                                  -- si la relacion contable tiene centro de costo unico, .... 
                                  -- OJO podria tener algun BUG
                                  IF v_record_rel_con.ps_id_centro_costo is not null THEN
                                     v_record_int_tran.id_centro_costo = v_record_rel_con.ps_id_centro_costo;
                                  END IF;
                                  
                                  
                                  IF(v_record_rel_con.ps_id_cuenta is NULL) THEN
                                     raise exception 'Revisar la configuracion de cuenta de la relacion contable TAZAIMP del tipo de taza impuesto   ID(%)',p_id_taza_impuesto ;
                                  END IF;
                                  
                                  v_conta_partidas = pxp.f_get_variable_global('conta_partidas');
                                  
                                  IF v_conta_partidas = 'si' THEN                    
                                    IF(v_record_rel_con.ps_id_partida is NULL) THEN
                                      raise exception 'Revisar la configuracion de partida de la relacion contable TAZAIMP del tipo de taza impuesto   ID(%)',p_id_taza_impuesto ;
                                    END IF;
                                  END IF;
                                  
                                  
                                  --replanza las cuenta, partida y auxiliar obtenidos 
                               
                                  v_record_int_tran.id_cuenta = v_record_rel_con.ps_id_cuenta;
                                  v_record_int_tran.id_partida = v_record_rel_con.ps_id_partida;
                                  v_record_int_tran.id_auxiliar = v_record_rel_con.ps_id_auxiliar;
                                                              
                             END IF;
                           
                           v_sw_aux:='si'; --mzm
                           if p_insertar_prioridad_principal='no' and  v_registros.prioridad=1
                            then
                             	v_sw_aux:='no';
                           
                           end if;  
                             
                             IF v_registros.sw_registro = 'si' and v_sw_aux='si' THEN --mzm
                             
                                --#13  si esta habilitado se resetea el campo partida ejejcucion
                                IF v_registros.reset_partida_eje  = 'si' THEN
                                     v_record_int_tran.id_partida_ejecucion = NULL;                        
                                END IF;
                             
                               --inserta transaccion en tabla
                               v_reg_id_int_transaccion = conta.f_gen_inser_transaccion(hstore(v_record_int_tran), p_id_usuario);
                               
                                --#13  si la partida ejecucion fue reseteada necesitamos  forzar el compromiso,.... forzar_comprometer
                                IF v_registros.reset_partida_eje  = 'si' THEN                        
                                     UPDATE conta.tint_transaccion t SET
                                        forzar_comprometer = 'si'
                                     WHERE t.id_int_transaccion = v_reg_id_int_transaccion;                                                   
                                END IF;
                             
                               v_int_resp[v_cont] = v_reg_id_int_transaccion;
                               v_cont = v_cont + 1;
                             else ---MZM
                               v_int_resp[v_cont] = 0;
                               v_cont = v_cont + 1;
                             END IF;
                            
                       
                        END IF; --fin revision de configuracion de descuentos
                  
                 END IF;  --fin prioridad
    
		   
        
        END LOOP;    
        
       
        
	   --Devuelve la respuesta    
       return v_int_resp;

	

EXCEPTION
				
	WHEN OTHERS THEN
		v_resp='';
		v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
		v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
		v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
		raise exception '%',v_resp;
				        
END;
$BODY$;