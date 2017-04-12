--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_gen_transaccion_from_plantilla (
  p_super public.hstore,
  p_tabla_padre public.hstore,
  p_reg_det_plantilla public.hstore,
  p_plantilla_comprobante public.hstore,
  p_id_tabla_padre_valor integer,
  p_id_int_comprobante integer,
  p_id_usuario integer,
  p_reg_tabla public.hstore,
  p_def_campos varchar [],
  p_tamano integer
)
RETURNS varchar AS
$body$
/*
Autor:  Rensi Arteaga Copari
Fecha 27/08/2013
Descripcion:    
   Esta funcion evalua un detalle de trasaccion especifico e inserta 
   las trasacciones generadas en int_trasaccion y hace una llamada recursiva para procesar transacciones secundarias asociadas



*/


  
DECLARE
	v_this					conta.tdetalle_plantilla_comprobante;
    v_this_hstore		    hstore;
    v_record_int_tran       conta.tint_transaccion;
    v_tabla					record;
    v_nombre_funcion        text;
    v_plantilla_det			record;        
    v_resp 					varchar;
    v_consulta				varchar;
    v_posicion				integer;
    v_columnas				varchar;
    v_columna_requerida		varchar;
    v_valor					varchar;
    
     v_id_int_comprobante    	integer;
    
     v_consulta_tab  			varchar;
    
     v_def_campos      			varchar[];
     v_campo_tempo     			varchar;
     v_i 						integer;
     v_tamano 					integer;
     
     
     v_record_rel_con 				record;
     v_reg_id_int_transaccion 		integer;
     v_resp_doc 					integer[];
     v_id_centro_costo_depto 		integer;
     v_sum_debe 					numeric;
     v_sum_haber 					numeric;
     v_registros_aux   				record;
     v_consulta_aux 				varchar;
     v_factor_aux  					numeric;
     v_descuento_debe  				numeric;
     v_descuento_haber  			numeric;
     v_id_int_transaccion_pagado  	integer;
     v_conta_partidas				varchar;
BEGIN
	
    v_nombre_funcion:='conta.f_gen_transaccion_from_plantilla';
    
    
    
     /*******************************************************************************************
     --      obtener la definicion de las variablles y los valores segun la plantilla del detalle
     *********************************************************************************************/      
             v_this_hstore = hstore(v_this);
             
             FOR v_i in 1..(p_tamano) loop
             
               
                  --evalua la columna
                 if ((p_reg_det_plantilla->p_def_campos[v_i]) !='' AND (p_reg_det_plantilla->p_def_campos[v_i])!='NULL' AND (p_reg_det_plantilla->p_def_campos[v_i]) is not NULL) then
      	
                       v_campo_tempo = conta.f_get_columna('datalle', 
                                                              (p_reg_det_plantilla->p_def_campos[v_i])::text, 
                                                              hstore(v_this), 
                                                              p_reg_tabla,
                                                              p_super,
                                                              p_tabla_padre
                                                              );
                                                              
                     
                                           
                       v_this_hstore = v_this_hstore || hstore(p_def_campos[v_i],v_campo_tempo);
                  
                  end if;
                  
               
           
             END LOOP;
             
          
     /********************************************************
     *  Si la plantilla es del tipo relacion devengado pago
     * 
     *********************************************************/
    
    
      IF (p_reg_det_plantilla->'rel_dev_pago') = 'si'  THEN
      
               IF COALESCE((v_this_hstore -> 'campo_monto')::numeric,0) > 0  THEN
                  -- raise exception '>>  %, %, % >>',p_reg_det_plantilla->'id_detalle_plantilla_fk',p_id_int_comprobante,v_this_hstore ->'campo_trasaccion_dev';
                 
                     --obtener trasaccion pagado  (Puede ser uno mismo pago para varios devengados)
                     
                     --raise exception 'DTI PRUEBA ... >> %', p_reg_det_plantilla->'id_detalle_plantilla_fk';
                     
                     select  
                       t.id_int_transaccion
                     into
                       v_id_int_transaccion_pagado
                     from   conta.tint_transaccion t
                     where  
                            t.id_detalle_plantilla_comprobante = (p_reg_det_plantilla->'id_detalle_plantilla_fk')::integer
                        and t.id_int_comprobante = p_id_int_comprobante 
                        limit 1 OFFSET 0; 
                     
                    
                  
                      --validar que no sean lalves nulas
                      IF v_id_int_transaccion_pagado is NULL THEN
                         raise exception 'no existe una trasaccion de referencia para el pago, (ESto es para relacion el devengado con el pagado, puede que la trasaccion de referencia tenga valor cero y no se este creando)';
                      END IF;
                      
                      --validar que no sean llaves  nulas
                     
                      IF (v_this_hstore ->'campo_trasaccion_dev') = '' or (v_this_hstore ->'campo_trasaccion_dev')='NULL' or (v_this_hstore ->'campo_trasaccion_dev') is NULL THEN
                      
                         raise exception 'no existe una trasaccion de referencia para el devengado revisa el campo de la plantilla, campo_trasaccion_dev para la plantilla: %',(p_reg_det_plantilla ->'descripcion');
                       
                      END IF;
                      
                      
                      --  insertar rel_dev_pago
                      IF not  conta.f_gen_inser_rel_devengado(p_id_usuario, 
                                                              (v_this_hstore -> 'campo_trasaccion_dev')::integer, 
                                                              v_id_int_transaccion_pagado, 
                                                              (v_this_hstore -> 'campo_monto')::numeric, 
                                                              p_id_int_comprobante) THEN
                           raise exception 'error';                                   
                      END IF;
                        
                       
                        
                   
                END IF;
                -- RAC 08/10/2015
                -- Almacenar el  tipo de relacion entre cbte de devengado y cbte de pago (... si no existe!)
                IF not   conta.f_gen_relaciona_cbte((v_this_hstore -> 'campo_trasaccion_dev')::integer, v_id_int_transaccion_pagado) THEN
                  raise exception 'error'; 
                END IF;
                
      
      
      ELSE
      -- si no es una relacion devengado pago procesa la plantilla normalmente
           
      
           
      
           --si el monto es cero saltamos el proceso, ya que no se generan transacciones
           
           IF COALESCE((v_this_hstore -> 'campo_monto')::numeric,0) > 0 or (p_reg_det_plantilla->'forma_calculo_monto') = 'diferencia' THEN
           
           
                  
                      /*********************************************************************************************************************  
                       -- si no tiene centro_costo lo obtiene a partir del depto de conta O del relacion contable configurada
                      ****************************************************************************************************************/
                       
                        IF (v_this_hstore->'campo_centro_costo') ='' or (v_this_hstore->'campo_centro_costo'='NULL') or (v_this_hstore->'campo_centro_costo') is NULL THEN 
                           
                             
                               
                               IF (v_this_hstore->'campo_relacion_contable_cc') ='' or (v_this_hstore->'campo_relacion_contable_cc'='NULL') or (v_this_hstore->'campo_relacion_contable_cc') is NULL THEN 
                                    
                                    /******************************************************************  
                                      -- si no tiene centro_costo lo obtiene a partir del depto de conta---
                                    *********************************************************************/
                                    
                                     SELECT 
                                        ps_id_centro_costo 
                                     into 
                                         v_id_centro_costo_depto 
                                     FROM conta.f_get_config_relacion_contable('CCDEPCON', -- relacion contable que almacena los centros de costo por departamento
                                                                         (p_super->'columna_gestion')::integer,  
                                                                         (p_super->'columna_depto')::integer,--p_id_depto_conta 
                                                                         NULL);  --id_dento_costo
                                                                             
                                     v_this_hstore = v_this_hstore || hstore('campo_centro_costo', v_id_centro_costo_depto::varchar);
                                
                                
                                ELSE
                                
                                    --raise exception '%, %,%',(v_this_hstore->'campo_relacion_contable_cc'),(p_super->'columna_gestion'),(p_reg_det_plantilla->'tipo_relacion_contable_cc');
                               
                                     SELECT 
                                        ps_id_centro_costo 
                                     into 
                                         v_id_centro_costo_depto 
                                     FROM conta.f_get_config_relacion_contable((p_reg_det_plantilla->'tipo_relacion_contable_cc')::varchar, -- relacion contable que almacena los centros de costo por departamento
                                                                         (p_super->'columna_gestion')::integer,  
                                                                         (v_this_hstore->'campo_relacion_contable_cc')::integer, 
                                                                         NULL);  --id_dento_costo
                                                                             
                                     v_this_hstore = v_this_hstore || hstore('campo_centro_costo', v_id_centro_costo_depto::varchar);
                                
                                
                                
                                
                                END IF; 
                                
                                
                               
                               
                              
                          
                          END IF;
                       
                        
                       /******************************************* 
                       --   IF procesar relacion contable si existe
                       *********************************************/
                       IF (p_reg_det_plantilla->'es_relacion_contable')  = 'si' THEN
                       
                                SELECT 
                                  * 
                                 into 
                                   v_record_rel_con 
                                 FROM conta.f_get_config_relacion_contable((p_reg_det_plantilla->'tipo_relacion_contable')::varchar, 
                                                                          (p_super->'columna_gestion')::integer, 
                                                                          (v_this_hstore->'campo_relacion_contable')::integer, 
                                                                          (v_this_hstore->'campo_centro_costo')::integer);
                                                                              
                                -- utiliza la relacion contable solo si no remplaza los valores de los campos del detalle de plantilla 
                                
                                IF (v_this_hstore->'campo_cuenta') ='' or (v_this_hstore->'campo_cuenta')='NULL' or (v_this_hstore->'campo_cuenta') is NULL THEN 
                                     
                                     v_this_hstore = v_this_hstore || hstore('campo_cuenta', v_record_rel_con.ps_id_cuenta::varchar);
                                
                                END IF;
                                
                                IF (v_this_hstore->'campo_partida') ='' or (v_this_hstore->'campo_partida') = 'NULL' or (v_this_hstore->'campo_partida') is NULL THEN 
                                     
                                     v_this_hstore = v_this_hstore || hstore('campo_partida' ,v_record_rel_con.ps_id_partida::varchar);
                                
                                END IF;
                                
                                IF (v_this_hstore->'campo_auxiliar') ='' or (v_this_hstore->'campo_auxiliar') = 'NULL' or (v_this_hstore->'campo_auxiliar') is NULL THEN 
                                     
                                     v_this_hstore = v_this_hstore || hstore('campo_auxiliar', v_record_rel_con.ps_id_auxiliar::varchar);
                                
                                END IF;          
                            
                      END IF;
                      
                     
                    
                      
                      /********************************
                      --Validaciones de cuenta y partida 
                      ***********************************/
                      
                       --validar si existe cuenta
                        IF (v_this_hstore->'campo_cuenta') = '' or (v_this_hstore->'campo_cuenta') = 'NULL' or (v_this_hstore->'campo_cuenta') is NULL THEN 
                            
                              raise exception 'No se encontro una cuenta contable para la transaccion: %', (p_reg_det_plantilla->'descripcion');
                                
                        END IF;
                        
                        
                        
                        
                        v_conta_partidas = pxp.f_get_variable_global('conta_partidas');
                        
                        IF v_conta_partidas = 'si' THEN
                          --validar si existe  partida 
                          IF (v_this_hstore->'campo_partida') = '' or (v_this_hstore->'campo_partida') = 'NULL' or (v_this_hstore->'campo_partida') is NULL THEN 
                               raise exception 'No se encontro una partida  para la transaccion: %',(p_reg_det_plantilla->'descripcion');
                          END IF;
                        END IF;
                        
                      /************************************************  
                      --tranforma el hstore a record de int_transaccion
                      *************************************************/
                      
                     --  IF v_this_hstore ->'campo_orden_trabajo' != '' THEN
                     --     raise exception  ',xx %', v_this_hstore ->'campo_orden_trabajo';
                     --  END IF;
                      
                      
                      
                      v_record_int_tran.id_cuenta =   (v_this_hstore->'campo_cuenta')::integer;
                      v_record_int_tran.id_partida =   (v_this_hstore->'campo_partida')::integer;
                      v_record_int_tran.id_auxiliar =   (v_this_hstore->'campo_auxiliar')::integer;
                      v_record_int_tran.id_centro_costo =   (v_this_hstore->'campo_centro_costo')::integer;
                      v_record_int_tran.id_orden_trabajo =   (v_this_hstore->'campo_orden_trabajo')::integer;
                      v_record_int_tran.id_partida_ejecucion = (v_this_hstore->'campo_partida_ejecucion')::integer;
                      v_record_int_tran.glosa = (v_this_hstore->'campo_concepto_transaccion')::varchar;
                      v_record_int_tran.id_int_comprobante = p_id_int_comprobante;
                      v_record_int_tran.id_usuario_reg = p_id_usuario;
                      v_record_int_tran.id_detalle_plantilla_comprobante = (p_reg_det_plantilla->'id_detalle_plantilla_comprobante')::integer;
                      
                     
                      v_record_int_tran.id_cuenta_bancaria = (v_this_hstore->'campo_id_cuenta_bancaria')::integer;
                      v_record_int_tran.id_cuenta_bancaria_mov = (v_this_hstore->'campo_id_cuenta_bancaria_mov')::integer;
                      v_record_int_tran.nro_cheque = (v_this_hstore->'campo_nro_cheque')::integer;
                      v_record_int_tran.nro_cuenta_bancaria_trans = (v_this_hstore->'campo_nro_cuenta_bancaria_trans')::varchar;
                      v_record_int_tran.porc_monto_excento_var = (v_this_hstore->'campo_porc_monto_excento_var')::varchar;
                      v_record_int_tran.nombre_cheque_trans = (v_this_hstore->'campo_nombre_cheque_trans')::varchar;
                      v_record_int_tran.forma_pago = (v_this_hstore->'campo_forma_pago')::varchar;
                      
                     raise notice '>>>>>>>>>>>>>>>>>>   glosa %',(v_this_hstore->'campo_concepto_transaccion');
                      
                      /****************************************************************
                      --Proceso el monto y lo ubica en el debe o haber, gasto o recurso
                      *******************************************************************/
                      
                       -----------------------
                       --  CALCULO SIMPLE
                       -----------------------
                       
                   
                       
                       IF (p_reg_det_plantilla->'forma_calculo_monto') = 'simple' THEN
                       
                          
                            
                              IF (p_reg_det_plantilla->'debe_haber') = 'debe' THEN
                              
                                 v_record_int_tran.importe_debe = (v_this_hstore->'campo_monto')::numeric;
                                 v_record_int_tran.importe_gasto = (v_this_hstore->'campo_monto_pres')::numeric;
                                  v_record_int_tran.importe_haber = 0::numeric;
                                 v_record_int_tran.importe_recurso = 0::numeric;
                              
                              ELSE
                              
                                 v_record_int_tran.importe_debe = 0;
                                 v_record_int_tran.importe_gasto = 0;
                                 v_record_int_tran.importe_haber = (v_this_hstore->'campo_monto')::numeric;
                                 v_record_int_tran.importe_recurso = (v_this_hstore->'campo_monto_pres')::numeric;
                              
                              END IF;
                            
                      
                      ELSEIF (p_reg_det_plantilla->'forma_calculo_monto') = 'diferencia' THEN
                      
                           --------------------------
                           --  CALCULO DIFERENCIA
                           -----------------------------
                           
                              IF (p_reg_det_plantilla->'id_detalle_plantilla_fk') is NULL  THEN
                              
                                raise exception 'Es tipo de calculo "diferencia" necesita una columna base de referencia';
                              
                              END IF;
                           
                              
                              -- analizar la forma de calculo de los montos
                              
                              Select  
                                sum(COALESCE(it.importe_debe,0)),sum(COALESCE(it.importe_haber,0))
                              into
                                v_sum_debe, v_sum_haber
                              from conta.tint_transaccion  it 
                               where it.id_detalle_plantilla_comprobante = (p_reg_det_plantilla->'id_detalle_plantilla_fk')::integer
                                     and it.id_int_comprobante = p_id_int_comprobante;
                                         
                                
                                         
                              IF  (p_reg_det_plantilla->'debe_haber') = 'haber'  THEN
                              
                                   v_record_int_tran.importe_debe = 0;
                                   v_record_int_tran.importe_gasto = 0;
                                   v_record_int_tran.importe_haber =   v_sum_debe - v_sum_haber;
                                   v_record_int_tran.importe_recurso =  v_sum_debe - v_sum_haber;
                                
                              
                              ELSE
                                  
                                  v_record_int_tran.importe_debe =  v_sum_haber - v_sum_debe;
                                  v_record_int_tran.importe_gasto = v_sum_haber - v_sum_debe;
                                  v_record_int_tran.importe_haber =  0;
                                  v_record_int_tran.importe_recurso = 0;
                              
                              
                              END IF;
                      
                   
                     
                    ELSEIF (p_reg_det_plantilla->'forma_calculo_monto') = 'descuento' or (p_reg_det_plantilla->'forma_calculo_monto') = 'incremento'THEN
                      
                         
                           --------------------------
                           --  CALCULO DESCUENTO
                           --------------------------
                           
                           IF (p_reg_det_plantilla->'id_detalle_plantilla_fk') is NULL  THEN
                              
                                raise exception 'Es tipo de calculo "descuento" necesita una columna base de referencia';
                              
                              END IF;
                              
                            
                           
                           --el decuento solo se aplica si el monto a descontar es mayor a cero
                           
                           IF   COALESCE((v_this_hstore->'campo_monto')::numeric , 0) > 0 THEN 
                          
                                 Select  
                                  sum(COALESCE(it.importe_debe,0)),sum(COALESCE(it.importe_haber,0))
                                into
                                  v_sum_debe, v_sum_haber
                                from conta.tint_transaccion  it 
                                 where it.id_detalle_plantilla_comprobante = (p_reg_det_plantilla->'id_detalle_plantilla_fk')::integer
                                       and it.id_int_comprobante = p_id_int_comprobante;
                                
                                
                                --validamos que el decuento solo se aplique al dbe o al haber
                                
                                IF v_sum_debe > 0 and v_sum_haber > 0   THEN
                                
                                   raise exception 'La plantilla de "%" solo puede afectar a debe o al haber pero no ambos',(p_reg_det_plantilla->'forma_calculo_monto');
                                
                                END IF;
                                
                                v_consulta_aux =  'Select  
                                                      it.id_int_transaccion,
                                                      it.importe_debe,
                                                      it.importe_haber
                                                 
                                                  from conta.tint_transaccion  it 
                                                   where it.id_detalle_plantilla_comprobante ='|| (p_reg_det_plantilla->'id_detalle_plantilla_fk')||'
                                                         and it.id_int_comprobante = '||p_id_int_comprobante::varchar;
                                
                                
                                --calcula el factor de prorrateo del decuento
                                
                                IF  v_sum_debe > 0 THEN
                                   
                                   v_factor_aux =  (v_this_hstore->'campo_monto')::numeric  / v_sum_debe;
                                
                                ELSE
                                
                                   v_factor_aux =  (v_this_hstore->'campo_monto')::numeric  / v_sum_haber;
                                
                                END IF;
                                
                                
                              
                                FOR v_registros_aux in execute(v_consulta_aux) LOOP
                                    
                                
                                    --calcula descuento
                                    v_descuento_debe = COALESCE(v_registros_aux.importe_debe,0) * v_factor_aux;
                                    v_descuento_haber = COALESCE(v_registros_aux.importe_haber,0) * v_factor_aux;
                                    
                                    
                                    IF (p_reg_det_plantilla->'forma_calculo_monto') = 'descuento' THEN
                                    --
                                        update   conta.tint_transaccion it  set
                                           importe_gasto = importe_debe - v_descuento_debe,
                                           importe_debe = importe_debe - v_descuento_debe,
                                           importe_recurso = importe_haber - v_descuento_haber,
                                           importe_haber = importe_haber - v_descuento_haber 
                                        where it.id_int_transaccion = v_registros_aux.id_int_transaccion;
                                        
                                        
                                   ELSEIF (p_reg_det_plantilla->'forma_calculo_monto') = 'incremento' THEN
                                   
                                       update   conta.tint_transaccion it  set
                                           importe_gasto = importe_debe + v_descuento_debe,
                                           importe_debe = importe_debe + v_descuento_debe,
                                           importe_recurso = importe_haber + v_descuento_haber,
                                           importe_haber = importe_haber + v_descuento_haber 
                                        where it.id_int_transaccion = v_registros_aux.id_int_transaccion;
                                   
                                   
                                   
                                   END IF;
                                    
                                    
                                    
                                
                                END LOOP;
                            
                            END IF;
                            
                            IF  (p_reg_det_plantilla->'debe_haber') = 'haber' THEN
                              
                                   v_record_int_tran.importe_debe = 0;
                                   v_record_int_tran.importe_gasto = 0;
                                   v_record_int_tran.importe_haber =  (v_this_hstore->'campo_monto')::numeric ;
                                   v_record_int_tran.importe_recurso = (v_this_hstore->'campo_monto')::numeric;
                                
                              
                              ELSE
                                  
                                  v_record_int_tran.importe_debe =  (v_this_hstore->'campo_monto')::numeric ;
                                  v_record_int_tran.importe_gasto = (v_this_hstore->'campo_monto')::numeric ;
                                  v_record_int_tran.importe_haber =  0;
                                  v_record_int_tran.importe_recurso = 0;
                              
                              
                              END IF; 
                       
                 
                       
                      
                       
                    
                  ELSE
                      
                        raise exception 'Forma de calculo de monto no reconocida,  %', (p_reg_det_plantilla->'forma_calculo_monto'); 
                      
                  END IF;  --FIN FOMRA DE CALCULO DEL MONTO
                  
                
              
              --  raise exception '%...%', v_record_int_tran.importe_debe,v_record_int_tran.importe_haber;
                
                     
                      /**********************************************
                      -- IF , se  aplica el documento si esta activo --
                     *************************************************/
                       
                       IF (p_reg_det_plantilla->'aplicar_documento') = 'si' THEN
                       
                      
                       
                           --TODO, validar que exista una plantilla de documento     
                         
                           --inserta las trasaccion asociadas al documento
                           IF COALESCE(v_record_int_tran.importe_debe,0) > 0 or COALESCE(v_record_int_tran.importe_haber,0) > 0 THEN
                               
                           
                         
                                 v_resp_doc =  conta.f_gen_proc_plantilla_calculo(
                                                            hstore(v_record_int_tran), 
                                                            (v_this_hstore->'campo_documento')::integer,--p_id_plantilla, 
                                                            (v_this_hstore->'campo_monto')::numeric, 
                                                            p_id_usuario,
                                                            (p_super->'columna_depto')::integer,--p_id_depto_conta 
                                                            (p_super->'columna_gestion')::integer, 
                                                            (p_reg_det_plantilla->'prioridad_documento')::integer,
                                                            'no',
                                                            (v_this_hstore->'campo_porc_monto_excento_var')::numeric 
                                                            );
                                 
                             	 IF(v_resp_doc is null)THEN
                                 	raise exception 'Error en procesar la pantilla de calculo, revisar la configuracion de la plantilla de calculo';
                                 END IF;
                                 
                                  --si tiene funcion de actualizacion,  envia el id de la trasaccion generada para que se almacene 
                                  
                                  IF (p_reg_det_plantilla->'func_act_transaccion') != ''  THEN
                                       
                                        
                                        IF ((v_this_hstore->'campo_id_tabla_detalle') is NULL) or (v_this_hstore->'campo_id_tabla_detalle')= ''   THEN
                                        
                                           raise exception 'El campo_id_tabla_detalle para la funcion de actualizacion no puede ser nulo ni vacio (%)',(p_reg_det_plantilla->'func_act_transaccion');
                                        
                                        
                                        END IF;
                                        
                                        raise notice  ' >>> actualiza transaccion .. %,%',(p_reg_det_plantilla->'func_act_transaccion'),(v_this_hstore->'campo_id_tabla_detalle');
                               
                                        
                                        EXECUTE ( 'select ' || (p_reg_det_plantilla->'func_act_transaccion')  ||'('||v_resp_doc[1]::varchar||' ,'||(v_this_hstore->'campo_id_tabla_detalle') ||' )');
                                     
                                  END If;
                                  
                                   
                           
                           
                           
                           END IF;
                       ELSE
                       
                      
                            
                           --inserta transaccion en tabla solo si tiene un monto maor a cero y dintinto de NULL
                           
                              IF COALESCE(v_record_int_tran.importe_debe,0) > 0 or COALESCE(v_record_int_tran.importe_haber,0) > 0 THEN
                             		raise notice  ' >>> gen inserta transaccion ..';
                      		 
                                   
                              
                                     v_reg_id_int_transaccion = conta.f_gen_inser_transaccion(hstore(v_record_int_tran), p_id_usuario);
                                
                                  
                                    --si tiene funcion de actualizacion,  envia el id de la trasaccion generada para que se almacene 
                                      IF (p_reg_det_plantilla->'func_act_transaccion') <> '' and  (p_reg_det_plantilla->'func_act_transaccion') is not null  THEN
                                    	 IF ((v_this_hstore->'campo_id_tabla_detalle') is NULL) or (v_this_hstore->'campo_id_tabla_detalle')= ''   THEN
                                            raise exception 'El campo_id_tabla_detalle para la funcion de actualizacion no puede ser nulo ni vacio (%)',(p_reg_det_plantilla->'func_act_transaccion');
                                         END IF;     
                                         EXECUTE  'select ' || (p_reg_det_plantilla->'func_act_transaccion')  ||'('||v_reg_id_int_transaccion::varchar||' ,'||(v_this_hstore->'campo_id_tabla_detalle') ||' )';
                                    
                                     END If;
                                    
                                 
                              
                              END IF;
                            
                            
                            
                       END IF;--FIN  APLICA DOCUMENTOS
              
             
              
              END IF; -- FIN MONTO CERO
           
        END IF; --FIN RELACION DVENGADO PAGO     
       
   
    return v_resp;
    
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