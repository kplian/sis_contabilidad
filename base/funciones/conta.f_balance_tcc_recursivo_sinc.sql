--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_balance_tcc_recursivo_sinc (
  pa_id_periodo integer [],
  pa_id_gestion integer [],
  p_id_tipo_cc_fk integer,
  p_id_usuario integer
)
RETURNS varchar AS
$body$
DECLARE


v_parametros  		record;
v_registros 		record;
v_nombre_funcion   	text;
v_resp				varchar;
v_nivel				integer;
va_mayor			numeric[];
v_id_gestion  		integer;
va_tipo_cuenta		varchar[];
v_gestion 			integer;
v_sw_force			boolean;

va_suma				numeric[];
va_tipo				varchar[];
v_cont_nro_nodo		integer;
v_mayor				numeric;
v_mayor_mt			numeric;
v_mayor_debe				numeric;
v_mayor_mt_debe				numeric;
v_mayor_haber				numeric;
v_mayor_mt_haber			numeric;
v_suma						numeric;
v_suma_mt					numeric;
v_suma_debe					numeric;
v_suma_mt_debe				numeric;
v_suma_haber				numeric;
v_suma_mt_haber				numeric;
v_registros_aux				record;
v_registros_periodo			record;
v_registros_rango			record;
v_id_rango					integer;
v_ind						integer;
v_reg_partida				record;
v_memoria					numeric;
v_formulado					numeric;
v_comprometido				numeric;
v_ejecutado					numeric;
v_reg_pe					record;
 

BEGIN



    v_nombre_funcion = 'conta.f_balance_tcc_recursivo_sinc';
    -- 0) inicia suma
    v_suma = 0;    
    v_sw_force = FALSE;
    
   
                
    -- FOR listado de cuenta basicas de la gestion 
    FOR  v_registros in (
                        select    
                                   c.id_tipo_cc,
                                   c.codigo,
                                   c.descripcion,                                         
                                   c.id_tipo_cc_fk,
                                   c.tipo,
                                   c.movimiento
                          from param.ttipo_cc c  
                          where   CASE 
                                     WHEN p_id_tipo_cc_fk is null THEN
                                     
                                        c.id_tipo_cc_fk is null
                                    ELSE
                                    
                                        c.id_tipo_cc_fk = p_id_tipo_cc_fk 
                                    END  
                                and c.estado_reg = 'activo'
                                      
                          )   LOOP
                  
                 -- llamada recursiva del balance general
                 IF  v_registros.movimiento = 'si' THEN
                     
                    /*FOR v_reg_partida IN (  select 
                                                 DISTINCT par.id_partida,
                                                par.sw_movimiento  
                                            from pre.tpartida par
                                            where 
                                                      par.sw_transaccional = 'movimiento'
                                                  and par.estado_reg = 'activo'
                                                  and par.id_gestion =ANY(pa_id_gestion)) LOOP */
                      
                               FOR v_ind IN array_lower(pa_id_periodo, 1) .. array_upper(pa_id_periodo, 1)    LOOP
                             
                                   
                                   
                                       va_mayor = conta.f_mayor_periodo_tipo_cc(v_registros.id_tipo_cc, pa_id_periodo[v_ind]);
                                       raise notice '>> %',va_mayor;
                                     
                                       v_mayor = va_mayor[1];
                                       v_mayor_mt = va_mayor[2];
                                       v_mayor_debe = va_mayor[5];
                                       v_mayor_mt_debe = va_mayor[6];
                                       v_mayor_haber = va_mayor[9];
                                       v_mayor_mt_haber = va_mayor[10];
                                       
                                      -- buscamos  si el rango existe para el periodo y id_tipo_cc
                                      v_id_rango = NULL;
                                      
                                      select 
                                          ran.id_rango
                                      into
                                         v_id_rango
                                      from conta.trango ran
                                      where 	ran.id_tipo_cc = v_registros.id_tipo_cc 
                                            and ran.id_periodo = pa_id_periodo[v_ind];
                                            
                                            
                                      v_formulado = 0;
                                      v_ejecutado = 0;
                                      v_comprometido = 0;       
                                       
                                      --IF 0=1  THEN     
                                      --IF v_reg_partida.sw_movimiento = 'presupuestaria'  THEN
                                          --recuperar  el balance de las memorias de calculo
                                          v_memoria =  pre.f_balance_memoria(v_registros.id_tipo_cc, pa_id_periodo[v_ind]);
                                          --recuperar el balance partida ejecucion
                                          
                                          SELECT 
                                             * 
                                          into
                                             v_reg_pe 
                                          FROM pre.f_balance_presupuesto(v_registros.id_tipo_cc, pa_id_periodo[v_ind]);
                                          
                                          v_formulado = COALESCE(v_reg_pe.ps_formulado,0);
                                          v_ejecutado = COALESCE(v_reg_pe.ps_ejecutado,0);
                                          v_comprometido = COALESCE(v_reg_pe.ps_comprometido,0); 
                                      
                                      
                                      -- END IF;   
                                      
                                      IF v_id_rango is null THEN
                                          
                                              -- inserta
                                              INSERT INTO 
                                                  conta.trango
                                                (
                                                  id_usuario_reg,                                         
                                                  fecha_reg,                                         
                                                  estado_reg,                                         
                                                  id_tipo_cc,
                                                  id_periodo,
                                                  debe_mb,
                                                  haber_mb,
                                                  debe_mt,
                                                  haber_mt,
                                                  memoria,
                                                  formulado,
                                                  comprometido,
                                                  ejecutado
                                                )
                                                VALUES (
                                                  p_id_usuario,                                         
                                                  now(),                                         
                                                  'activo',                                         
                                                  v_registros.id_tipo_cc,
                                                  pa_id_periodo[v_ind],
                                                  COALESCE(v_mayor_debe,0),
                                                  COALESCE(v_mayor_haber,0),
                                                  COALESCE(v_mayor_mt_debe,0),
                                                  COALESCE(v_mayor_mt_haber,0),
                                                  COALESCE(v_memoria,0),
                                                  v_formulado,
                                                  v_comprometido,
                                                  v_ejecutado
                                                );
                                                
                                      ELSE
                                            --modifica
                                            UPDATE conta.trango  SET 
                                              id_usuario_mod = p_id_usuario,
                                              fecha_mod = now(),
                                              debe_mb = COALESCE(v_mayor_debe,0),
                                              haber_mb = COALESCE(v_mayor_haber,0),
                                              debe_mt = COALESCE(v_mayor_mt_debe,0),
                                              haber_mt = COALESCE(v_mayor_mt_haber,0),
                                              memoria = COALESCE(v_memoria,0),
                                              formulado = v_formulado,
                                              comprometido = v_comprometido,
                                              ejecutado = v_ejecutado
                                            WHERE 
                                              id_rango = v_id_rango;
                                              
                                      END IF;
                           
                     END LOOP; --for periodo
                     
                     
                                    
                 ELSE
                             
                      v_resp = conta.f_balance_tcc_recursivo_sinc(pa_id_periodo,
                      											  pa_id_gestion,
                      											  v_registros.id_tipo_cc,
                                                                  p_id_usuario);
                                               
                      
                     
                                                  
                                  -- sumamos los hijos para cada periodo
                                  FOR v_ind IN array_lower(pa_id_periodo, 1) .. array_upper(pa_id_periodo, 1)    LOOP
                      
                                               
                                        select
                                           sum(ran.debe_mb) as debe_mb,
                                           sum(ran.haber_mb) as haber_mb,
                                           sum(ran.debe_mt) as debe_mt,
                                           sum(ran.haber_mt) as haber_mt,
                                           sum(ran.memoria) as memoria,
                                           sum(ran.formulado) as formulado,
                                           sum(ran.comprometido) as comprometido,
                                           sum(ran.ejecutado) as ejecutado
                                        into
                                          v_registros_rango
                                        from param.ttipo_cc tcc
                                        inner join conta.trango ran on ran.id_tipo_cc = tcc.id_tipo_cc
                                        where     tcc.id_tipo_cc_fk = v_registros.id_tipo_cc 
                                              and ran.id_periodo = pa_id_periodo[v_ind]; 
                                              
                                       
                                       -- buscamos  si el rango existe para el periodo y id_tipo_cc
                                          v_id_rango = NULL;
                                          
                                          select 
                                              ran.id_rango
                                          into
                                             v_id_rango
                                          from conta.trango ran
                                          where    ran.id_tipo_cc = v_registros.id_tipo_cc 
                                               and ran.id_periodo = pa_id_periodo[v_ind];
                                          
                                          
                                          IF v_id_rango is null THEN
                                              
                                                  -- inserta
                                                  INSERT INTO 
                                                      conta.trango
                                                    (
                                                      id_usuario_reg,                                         
                                                      fecha_reg,                                         
                                                      estado_reg,                                         
                                                      id_tipo_cc,
                                                      id_periodo,
                                                      debe_mb,
                                                      haber_mb,
                                                      debe_mt,
                                                      haber_mt,
                                                      memoria,
                                                      formulado,
                                                      comprometido,
                                                      ejecutado
                                                    )
                                                    VALUES (
                                                      p_id_usuario,                                         
                                                      now(),                                         
                                                      'activo',                                         
                                                      v_registros.id_tipo_cc,
                                                      pa_id_periodo[v_ind],
                                                      COALESCE(v_registros_rango.debe_mb,0) ,
                                                      COALESCE(v_registros_rango.haber_mb,0) ,
                                                      COALESCE(v_registros_rango.debe_mt,0) ,
                                                      COALESCE(v_registros_rango.haber_mt,0) ,
                                                      COALESCE(v_registros_rango.memoria,0),
                                                      COALESCE(v_registros_rango.formulado,0),
                                                      COALESCE(v_registros_rango.comprometido,0),
                                                      COALESCE(v_registros_rango.ejecutado,0)
                                                    );
                                          ELSE
                                                --modifica
                                                UPDATE conta.trango  SET 
                                                  id_usuario_mod = p_id_usuario,
                                                  fecha_mod = now(),
                                                  debe_mb = COALESCE(v_registros_rango.debe_mb,0),
                                                  haber_mb = COALESCE(v_registros_rango.haber_mb,0),
                                                  debe_mt = COALESCE(v_registros_rango.debe_mt,0),
                                                  haber_mt = COALESCE(v_registros_rango.haber_mt,0),
                                                  memoria = COALESCE(v_registros_rango.memoria,0),
                                                  formulado = COALESCE(v_registros_rango.formulado,0),
                                                  comprometido = COALESCE(v_registros_rango.comprometido,0),
                                                  ejecutado =  COALESCE(v_registros_rango.ejecutado,0)
                                                WHERE 
                                                  id_rango = v_id_rango;
                                          END IF;        
                                                                               
                      END LOOP;    --for periodos                                 
                     
                                                           
                 END IF;
                  
    END LOOP;
   
   
   RETURN 'exito';


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