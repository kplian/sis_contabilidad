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
    v_plantilla_det				record;        
    v_resp 					varchar;
    v_consulta				varchar;
    v_posicion				integer;
    v_columnas				varchar;
    v_columna_requerida		varchar;
    r 						record;  --  esta variable no se usa
    v_valor					varchar;
    
    v_id_int_comprobante    integer;
    
    v_consulta_tab  varchar;
    
     v_def_campos      varchar[];
     v_campo_tempo     varchar;
     v_i integer;
     v_tamano integer;
     
     
     v_record_rel_con record;
     v_reg_id_int_transaccion integer;
     v_resp_doc boolean;
     v_id_centro_costo_depto integer;
     v_sum_debe numeric;
     v_sum_haber numeric;
BEGIN
	
    v_nombre_funcion:='conta.f_gen_transaccion_from_plantilla';
    
     ----------------------------------------------------------------------------------------------
     --      obtener la definicion de las variablles y los valores segun la plantilla del detalle
     -----------------------------------------------------------------------------------------------      
             v_this_hstore = hstore(v_this);
             
             FOR v_i in 1..(p_tamano) loop
    
                  --evalua la columna
                 if (p_reg_det_plantilla->p_def_campos[v_i] !='' AND p_reg_det_plantilla->p_def_campos[v_i]!='NULL' AND (p_reg_det_plantilla->p_def_campos[v_i]) is not NULL) then
      	
                       v_campo_tempo = conta.f_get_columna('datalle', 
                                                              p_reg_det_plantilla->p_def_campos[v_i]::text, 
                                                              hstore(v_this), 
                                                              p_reg_tabla,
                                                              p_super,
                                                              p_tabla_padre
                                                              );
                                                              
                      v_this_hstore = v_this_hstore || (p_def_campos[v_i] => v_campo_tempo);
                  
                  end if;
           
             END LOOP;
             
           -----------------------------------------------------------------------  
           -- si no tiene centro_costo lo obtiene a partir del depto de conta---
           ----------------------------------------------------------------------
           
            IF v_this_hstore ->'campo_centro_costo' ='' or v_this_hstore ->'campo_centro_costo'='NULL' or (v_this_hstore ->'campo_centro_costo') is NULL THEN 
               
                   SELECT 
                      ps_id_centro_costo 
                     into 
                       v_id_centro_costo_depto 
                   FROM conta.f_get_config_relacion_contable('CCDEPCON', -- relacion contable que almacena los centros de costo por departamento
                                                             (p_super->'columna_gestion')::integer,  
                                                             (p_super->'columna_depto')::integer,--p_id_depto_conta 
                                                             NULL);  --id_dento_costo
                                                                 
                   v_this_hstore = v_this_hstore || ('campo_centro_costo' => v_id_centro_costo_depto::varchar);
              
              END IF;
           
             
           ------------------------------------------------- 
           --   IF procesar relacion contable si existe
           ---------------------------------------------
           IF (p_reg_det_plantilla -> 'es_relacion_contable')  = 'si' THEN
           
                    SELECT 
                      * 
                     into 
                       v_record_rel_con 
                     FROM conta.f_get_config_relacion_contable((p_reg_det_plantilla -> 'tipo_relacion_contable')::varchar, 
                                                              (p_super->'columna_gestion')::integer, 
                                                              (v_this_hstore -> 'campo_relacion_contable')::integer, 
                                                              (v_this_hstore -> 'campo_centro_costo')::integer);
                                                                  
                    -- utiliza la relacion contable solo si no remplaza los valores de los campos del detalle de plantilla 
                    
                    IF v_this_hstore ->'campo_cuenta' ='' or v_this_hstore ->'campo_cuenta'='NULL' or (v_this_hstore ->'campo_cuenta') is NULL THEN 
                         
                         v_this_hstore = v_this_hstore || ('campo_cuenta' => v_record_rel_con.ps_id_cuenta::varchar);
                    
                    END IF;
                    
                    IF v_this_hstore ->'campo_partida' ='' or v_this_hstore ->'campo_partida'='NULL' or (v_this_hstore ->'campo_partida') is NULL THEN 
                         
                         v_this_hstore = v_this_hstore || ('campo_partida' => v_record_rel_con.ps_id_partida::varchar);
                    
                    END IF;
                    
                    IF v_this_hstore ->'campo_auxiliar' ='' or v_this_hstore ->'campo_auxiliar'='NULL' or (v_this_hstore ->'campo_auxiliar') is NULL THEN 
                         
                         v_this_hstore = v_this_hstore || ('campo_auxiliar' => v_record_rel_con.ps_id_auxiliar::varchar);
                    
                    END IF;          
                
          END IF;
           
          
          ------------------------------------
          --Validaciones de cuenta y partida 
          ------------------------------------
          
           --validar si existe cuenta
            IF v_this_hstore ->'campo_cuenta' ='' or v_this_hstore ->'campo_cuenta'='NULL' or (v_this_hstore ->'campo_cuenta') is NULL THEN 
                
                  raise exception 'No se encontro una cuenta contable para la transaccion: %',p_reg_det_plantilla ->'descripcion';
                    
            END IF;
            
            --validar si existe  partida 
            IF v_this_hstore ->'campo_partida' ='' or v_this_hstore ->'campo_partida'='NULL' or (v_this_hstore ->'campo_partida') is NULL THEN 
                
                  raise exception 'No se encontro una partida  para la transaccion: %',p_reg_det_plantilla ->'descripcion';
                    
            END IF;
            
          --------------------------------------------------  
          --tranforma el hstore a record de int_transaccion
          --------------------------------------------------
          v_record_int_tran.id_cuenta =   (v_this_hstore -> 'campo_cuenta')::integer;
          v_record_int_tran.id_partida =   (v_this_hstore -> 'campo_partida')::integer;
          v_record_int_tran.id_auxiliar =   (v_this_hstore -> 'campo_auxiliar')::integer;
          v_record_int_tran.id_centro_costo =   (v_this_hstore -> 'campo_centro_costo')::integer;
          v_record_int_tran.id_partida_ejecucion = (v_this_hstore -> 'campo_partida_ejecucion')::integer;
          v_record_int_tran.glosa = (v_this_hstore -> 'descripcion')::varchar;
          v_record_int_tran.id_int_comprobante = p_id_int_comprobante;
          v_record_int_tran.id_usuario_reg = p_id_usuario;
          v_record_int_tran.id_detalle_plantilla_comprobante = (p_reg_det_plantilla->'id_detalle_plantilla_comprobante')::integer;
          
         
          
          ------------------------------------------------------------------
          --Proceso el monto y lo ubica en el debe o haber, gasto o recurso
          ------------------------------------------------------------------
           IF (p_reg_det_plantilla -> 'forma_calculo_monto') = 'simple' THEN
              
              
                IF (p_reg_det_plantilla -> 'debe_haber') = 'debe' THEN
                
                   v_record_int_tran.importe_debe = (v_this_hstore -> 'campo_monto')::numeric;
                   v_record_int_tran.importe_gasto = (v_this_hstore -> 'campo_monto_pres')::numeric;
                    v_record_int_tran.importe_haber = 0::numeric;
                   v_record_int_tran.importe_recurso = 0::numeric;
                
                ELSE
                
                   v_record_int_tran.importe_debe = 0;
                   v_record_int_tran.importe_gasto = 0;
                   v_record_int_tran.importe_haber = (v_this_hstore -> 'campo_monto')::numeric;
                   v_record_int_tran.importe_recurso = (v_this_hstore -> 'campo_monto_pres')::numeric;
                
                END IF;
          
          ELSEIF (p_reg_det_plantilla -> 'forma_calculo_monto') = 'diferencia' THEN
              
              --TODO, analizar la forma de calculo de los montos
              
              Select  
                sum(COALESCE(it.importe_debe,0)),sum(COALESCE(it.importe_haber,0))
              into
                v_sum_debe, v_sum_haber
              from conta.tint_transaccion  it 
               where it.id_detalle_plantilla_comprobante = (p_reg_det_plantilla -> 'id_detalle_plantilla_fk')::integer
                     and it.id_int_comprobante = p_id_int_comprobante;
                         
                
                         
              IF  (p_reg_det_plantilla -> 'debe_haber') = 'haber' THEN
              
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
          
         
         ELSEIF (p_reg_det_plantilla -> 'forma_calculo_monto') = 'descuento' THEN
          
          
          
          
        
        
        ELSE
          
            raise exception 'Forma de calculo de monto no reconocida,  %', (p_reg_det_plantilla -> 'forma_calculo_monto'); 
          
          END IF;
         
          ------------------------------------------
          -- IF , se  aplica el documento si esta activo --
          ------------------------------------------
           
           IF (p_reg_det_plantilla -> 'aplicar_documento') = 'si' THEN
           
               --TODO, validar que exista una plantilla de documento     
           
                --inserta las trasaccion asociadas al documento
                
                v_resp_doc =  conta.f_gen_proc_plantilla_calculo(
                                            hstore(v_record_int_tran), 
                                            (v_this_hstore->'campo_documento')::integer,--p_id_plantilla, 
                                            (v_this_hstore -> 'campo_monto')::numeric, 
                                            p_id_usuario,
                                            (p_super->'columna_depto')::integer,--p_id_depto_conta 
                                            (p_super->'columna_gestion')::integer, 
                                            'no');
                 
           
           ELSE
               --inserta transaccion en tabla solo si tiene un monto maor a cero y dintinto de NULL
               
                IF COALESCE(v_record_int_tran.importe_debe,0) > 0 or COALESCE(v_record_int_tran.importe_haber,0) > 0 THEN
               
                	v_reg_id_int_transaccion = conta.f_gen_inser_transaccion(hstore(v_record_int_tran), p_id_usuario);
                
                END IF;
                
           END IF;
           
           /*           
           -------------------------------------------------------
           --   IF procesar la transacciones secundarias si existen
           ------------------------------------------------------
           FOR v_plantilla_det in (
                          Select * 
                            from conta.tdetalle_plantilla_comprobante dpc 
                            where  dpc.id_plantilla_comprobante =  
                                   (p_plantilla_comprobante->'id_plantilla_comprobante')::integer  and
                                   dpc.primaria = 'no'  and dpc.estado_reg='activo' 
                                   and dpc.id_detalle_plantilla_fk = (p_reg_det_plantilla->'id_detalle_plantilla_comprobante')::integer) LOOP
                                   
                   -- obtiene el record de la transaccion secundaria
                   -- llamada recursica  a esta misma funcion con la bandera  activada 
          
                            v_resp = conta.f_gen_transaccion_unitaria(
                                              p_super, --p_super
                                              p_tabla_padre,--p_tabla_padre
                                              hstore(v_plantilla_det),--p_reg_det_plantilla
                                              p_plantilla_comprobante,--p_plantilla_comprobante
                                              p_id_tabla_padre_valor,--p_id_tabla_padre_valor
                                              p_id_int_comprobante,--p_id_int_comprobante
                                              p_id_usuario--p_id_usuario
                                              );
                                              
                                           
           
           
           END LOOP;*/
                   
   
       
    
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