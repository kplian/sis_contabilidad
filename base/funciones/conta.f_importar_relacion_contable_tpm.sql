--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_importar_relacion_contable_tpm (
)
RETURNS boolean AS
$body$
DECLARE
  v_tabla varchar;
  v_params VARCHAR [ ];
  v_resp varchar;

  v_registros record;
  v_registros_par record;
  v_id_tipo_estado integer;
  v_id_estado_actual integer;
  v_id_proceso_wf integer;
  v_id_estado_wf integer;
  
  v_id_cuenta  integer;
  v_id_tipo_presupeusto  integer;
  v_id_gestion integer;
  v_id_tipo_presupuesto  integer;
  v_registros_partidas   record;
  v_id_tipo_relacion_contable integer;
  v_defecto varchar;
  

BEGIN
       v_id_gestion = 2;
       v_id_tipo_relacion_contable = 1; --cuenta para ahcer compras
       v_defecto = 'no';
     

       FOR  v_registros in ( select 
                                r.codigo_cuenta,
                                r.codigo_tipo_presupuesto
                              from conta.trelacion_contable_tpm r
                              where t.migraado = 'no') LOOP
                              
                   --recuperar cuenta
                   select 
                     c.id_cuenta
                    into 
                     v_id_cuenta
                   from  conta.tcuenta c 
                   where     id_gestion =  v_id_gestion
                         and  c.nro_cuenta = v_registros.codigo_cuenta
                         and  c.estado_reg = 'activo';
                         
                    IF v_id_cuenta.id_cuenta is not  null  THEN 
                    
                         --recuperar tipo de presupeusto  
                         select 
                            tp.id_tipo_presupuesto
                           into
                             v_id_tipo_presupuesto
                         from pre.ttipo_presupuesto tp
                         where tp.codigo_alterno =  v_registros.codigo_tipo_presupuesto;
                         
                         
                         IF v_id_tipo_presupuesto  is not null THEN
                         
                                      FOR v_registros_partidas in (select  
                                                                      cp.id_concepto_ingas,
                                                                      par.id_partida
                                                                   from   pre.tconcepto_partida cp
                                                                   inner join pre.tpartida par on par.id_partida = cp.id_partida and par.estado_reg = 'activo'
                                                                   where       par.id_gestion = v_id_gestion 
                                                                          and  cp.estado_reg = 'activo')LOOP
                                                                          
                                                    --inserta relacion contable                      
                                                       INSERT INTO 
                                                                conta.trelacion_contable
                                                              (
                                                                id_usuario_reg,
                                                                fecha_reg,
                                                                estado_reg,                                                    
                                                                id_tipo_relacion_contable,                                                       
                                                                id_cuenta,
                                                                --id_auxiliar,
                                                                id_partida,
                                                                id_gestion,
                                                                id_tabla,
                                                                defecto,                                                     
                                                                id_tipo_presupuesto
                                                               
                                                              )
                                                              VALUES (
                                                                1,
                                                                 now() ,
                                                                'activo',                                                    
                                                                v_id_tipo_relacion_contable,                                                       
                                                                v_id_cuenta,
                                                                --id_auxiliar,
                                                                v_registros_partidas.id_partida,
                                                                v_id_gestion,
                                                                v_registros_partidas.id_concepto_ingas,--id_tabla,
                                                                v_defecto,                                                     
                                                                v_id_tipo_presupuesto
                                                              ); 
                                                              
                                                               raise notice 'insertado concepto % partida %',v_registros_partidas.id_concepto_ingas,v_registros_partidas.id_partida;                   
                                                                                                                                
                                                                                            
                                      END LOOP;
                                       
                                        --recuperar partida  
                                        update conta.trelacion_contable_tpm r set
                                           r.migrado = 'si'
                                        where      r.codigo_cuenta = v_registros.codigo_cuenta   
                                              and  r.codigo_tipo_presupuesto  =  v_registros.codigo_tipo_presupuesto;  
                         
                         
                           ELSE
                                   update conta.trelacion_contable_tpm r set 
                                     r.migrado = 'no',
                                     obs = 'no se encontro el tipo de presupeusto  '||v_registros.codigo_tipo_presupuesto
                                  where      r.codigo_cuenta = v_registros.codigo_cuenta   
                                        and  r.codigo_tipo_presupuesto  =  v_registros.codigo_tipo_presupuesto;
                         
                         END IF;
                    
                    
                   
                 ELSE
                   
                          update conta.trelacion_contable_tpm r set
                             r.migrado = 'no',
                             obs = 'no se encontro la cuenta '||v_registros.codigo_cuenta
                          where      r.codigo_cuenta = v_registros.codigo_cuenta   
                                and  r.codigo_tipo_presupuesto  =  v_registros.codigo_tipo_presupuesto;    
                   
               END IF;
                  
                      
       
   END LOOP;
   return true;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;