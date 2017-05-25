--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_balance_ot_recursivo (
  p_desde date,
  p_hasta date,
  p_id_deptos varchar,
  p_nro_nodo numeric,
  p_nivel_ini integer,
  p_nivel_final integer,
  p_id_orden_trabajo_fk integer,
  p_tipo varchar,
  p_incluir_cierre varchar = 'no'::character varying,
  p_tipo_balance varchar = 'general'::character varying
)
RETURNS numeric [] AS
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
v_mayor_mt_debe			numeric;
v_mayor_haber				numeric;
v_mayor_mt_haber			numeric;

v_suma				numeric;
v_suma_mt			numeric;
v_suma_debe				numeric;
v_suma_mt_debe			numeric;
v_suma_haber				numeric;
v_suma_mt_haber			numeric;
 

BEGIN



    v_nombre_funcion = 'conta.f_balance_ot_recursivo';
    -- 0) inicia suma
    v_suma = 0;
    
    v_sw_force = FALSE;
    va_tipo = string_to_array(p_tipo,',');
    v_cont_nro_nodo = p_nro_nodo ;
    
     --recupera datos de la cuenta padre
     IF p_id_orden_trabajo_fk is not null THEN
       
             select
               ot.tipo,
               ot.movimiento,
               ot.codigo
             into
               v_registros
             from conta.torden_trabajo ot 
             where ot.id_orden_trabajo_fk = p_id_orden_trabajo_fk;
             
             IF v_registros.movimiento = 'si' THEN
                  v_sw_force = true;
             END IF; 
        
     END IF;
     
     --arma array de tipos de cuenta
     va_tipo_cuenta = string_to_array(p_tipo,',');
     
     
     
     v_gestion = (SELECT EXTRACT(YEAR FROM now()::Date))::integer;
    
    --1) IF   si el nivel inicial es igual al nivel final calculamo el mayor de la cuenta, o es uan orden de movimmiento
    
          
       IF p_nivel_ini  = p_nivel_final  or v_sw_force THEN  
         
       
         	 if p_id_orden_trabajo_fk is not NULL THEN
             
                       -- FOR listamos la cuentas hijos
                        FOR  v_registros in (select
                                               c.id_orden_trabajo,
                                               c.codigo,
                                               c.desc_orden,                                        
                                               c.id_orden_trabajo_fk,
                                               c.tipo,
                                               c.movimiento
                                             from conta.torden_trabajo c
                                             where c.id_orden_trabajo_fk = p_id_orden_trabajo_fk 
                                                   and c.estado_reg = 'activo'
                                                   and c.tipo =ANY(va_tipo) 
                                                  
                                              )   LOOP
                             
                             -- caculamos el mayor
                              va_mayor = conta.f_mayor_orden(v_registros.id_orden_trabajo, p_desde, p_hasta, p_id_deptos, p_incluir_cierre);
                              v_mayor = va_mayor[1];
                              v_mayor_mt = va_mayor[2];
                              v_mayor_debe = va_mayor[5];
                              v_mayor_mt_debe = va_mayor[6];
                              v_mayor_haber = va_mayor[9];
                              v_mayor_mt_haber = va_mayor[10];
                              
                              
                              
                            
                             -- insetamos en tabla temporal 
                              insert  into temp_balance_ot (
                                              id_orden_trabajo ,
                                              codigo ,
                                              desc_orden ,
                                              id_orden_trabajo_fk ,
                                              monto ,
                                              monto_mt,
                                              monto_debe ,
                                              monto_mt_debe,
                                              monto_haber ,
                                              monto_mt_haber,
                                              nivel ,
                                              tipo ,
                                              movimiento,
                                              nro_nodo	)
                                            VALUES(
                                             v_registros.id_orden_trabajo,
                                             v_registros.codigo,
                                             v_registros.desc_orden,
                                             v_registros.id_orden_trabajo_fk,
                                             v_mayor,
                                             v_mayor_mt,
                                             v_mayor_debe ,
                                             v_mayor_mt_debe,
                                             v_mayor_haber,
                                             v_mayor_mt_haber,
                                             p_nivel_ini,
                                             v_registros.tipo,
                                             v_registros.movimiento,
                                             v_cont_nro_nodo );
                              
                              
                           
                             -- incrementamos suma
                             v_suma = v_suma + COALESCE(v_mayor,0);
                             v_suma_mt = v_suma_mt + COALESCE(v_mayor_mt,0);
                             v_cont_nro_nodo = v_cont_nro_nodo +1;
                          
                          END LOOP;
             ELSE
                 
                      
      
                      
                     -- FOR listamos la cuentas hijos
                      FOR  v_registros in (select
                      
                                         c.id_orden_trabajo,
                                         c.codigo,
                                         c.desc_orden,                                     
                                         c.id_orden_trabajo_fk,
                                         c.tipo,
                                         c.movimiento
                                        from conta.torden_trabajo c 
                                            where c.id_orden_trabajo_fk is NULL 
                                            and c.estado_reg = 'activo'
                                            and c.tipo =ANY(va_tipo)  )   LOOP
                           
                           -- caculamos el mayor
                              va_mayor = conta.f_mayor_orden(v_registros.id_orden_trabajo, p_desde, p_hasta, p_id_deptos, p_incluir_cierre);
                              v_mayor = va_mayor[1];
                              v_mayor_mt = va_mayor[2];
                            
                            
                              v_mayor = va_mayor[1];
                              v_mayor_mt = va_mayor[2];
                              v_mayor_debe = va_mayor[5];
                              v_mayor_mt_debe = va_mayor[6];
                              v_mayor_haber = va_mayor[9];
                              v_mayor_mt_haber = va_mayor[10];
                              
                              
                       
                                 
                                 -- insetamos en tabla temporal 
                                  insert  into temp_balance_ot (
                                                   id_orden_trabajo ,
                                                    codigo ,
                                                    desc_orden ,
                                                    id_orden_trabajo_fk ,
                                                    monto ,
                                                    monto_mt,
                                                    monto_debe ,
                                                    monto_mt_debe,
                                                    monto_haber ,
                                                    monto_mt_haber,
                                                    nivel ,
                                                    tipo ,
                                                    movimiento,
                                                    nro_nodo
                                                  
                                                  )
                                                VALUES(
                                                   	v_registros.id_orden_trabajo,
                                                   	v_registros.codigo,
                                                   	v_registros.desc_orden,
                                                   	v_registros.id_orden_trabajo_fk,
                                                   	v_mayor,
                                                   	v_mayor_mt,
                                                   	v_mayor_debe ,
                                               		v_mayor_mt_debe,
                                               		v_mayor_haber,
                                               		v_mayor_mt_haber,
                                                  	p_nivel_ini,
                                                   	v_registros.tipo,
                                                   	v_registros.movimiento,
                                                   	v_cont_nro_nodo );
                                  
                                  
                               
                                 -- incrementamos suma
                                 v_suma = v_suma + COALESCE(v_mayor,0);
                                 v_suma_mt = v_suma_mt + COALESCE(v_mayor_mt,0);
                                 v_cont_nro_nodo = v_cont_nro_nodo +1;
                        
                        END LOOP;
             
              END IF;
              
              
       ELSEIF  p_nivel_ini = 1   THEN
       
       --2) ELSIF, si el nivel inicial es 0 identificamos las orden inicila raiz
          
                 -- incremetmaos el nivel
                 v_nivel = p_nivel_ini +1;
                
               
                 
                 -- FOR listado de cuenta basicas de la gestion 
                 FOR  v_registros in (
                                    select    
                                               c.id_orden_trabajo,
                                               c.codigo,
                                               c.desc_orden,                                         
                                               c.id_orden_trabajo_fk,
                                               c.tipo,
                                               c.movimiento
                                      from conta.torden_trabajo c  
                                      where     c.id_orden_trabajo_fk is NULL 
                                            and c.estado_reg = 'activo'
                                            and c.tipo =ANY(va_tipo)  
                                      
                                      )   LOOP
                            -- llamada recursiva del balance general
                             
                             IF  v_registros.movimiento = 'si' THEN
                                 va_mayor = conta.f_mayor_orden(v_registros.id_orden_trabajo, p_desde, p_hasta, p_id_deptos, p_incluir_cierre);
                                 
                                
                                 
                                    
                             ELSE
                             
                                 va_mayor = conta.f_balance_ot_recursivo(
                                                           p_desde, 
                                                           p_hasta, 
                                                           p_id_deptos, 
                                                           v_cont_nro_nodo + 1,
                                                           v_nivel, 
                                                           p_nivel_final, 
                                                           v_registros.id_orden_trabajo,
                                                           p_tipo,
                                                           p_incluir_cierre,
                                                           p_tipo_balance);
                                                           
                             END IF;
                             
                       
                              
                                                       
                               
                                 
                                 v_mayor = va_mayor[2];
                                 v_mayor_mt = va_mayor[3];
                                 v_mayor_debe = va_mayor[4];
                                 v_mayor_mt_debe = va_mayor[5];
                                 v_mayor_haber = va_mayor[6];
                                 v_mayor_mt_haber = va_mayor[7]; 
                                                  
                             
                       
                             -- insetamos en tabla temporal 
                                insert  into temp_balance_ot (
                                                      id_orden_trabajo ,
                                                      codigo ,
                                                      desc_orden ,
                                                      id_orden_trabajo_fk ,
                                                      monto ,
                                                      monto_mt,
                                                      monto_debe ,
                                                      monto_mt_debe,
                                                      monto_haber ,
                                                      monto_mt_haber,
                                                      nivel ,
                                                      tipo ,
                                                      movimiento,
                                                      nro_nodo)
                                            VALUES(
                                                     v_registros.id_orden_trabajo,
                                                     v_registros.codigo,
                                                     v_registros.desc_orden,
                                                     v_registros.id_orden_trabajo_fk,
                                                     v_mayor,
                                                     v_mayor_mt,
                                                     v_mayor_debe ,
                                               		 v_mayor_mt_debe,
                                               		 v_mayor_haber,
                                               		 v_mayor_mt_haber,
                                                     p_nivel_ini,
                                                     v_registros.tipo,
                                                     v_registros.movimiento,
                                                     v_cont_nro_nodo );
                                             
                                             
                           -- incrementamos suma
                            v_suma = v_suma + COALESCE(v_mayor,0);
                            v_suma_mt = v_suma_mt + COALESCE(v_mayor_mt,0);
                            
                            v_suma_debe = v_suma + COALESCE(v_mayor_debe,0);
                            v_suma_mt_debe = v_suma_mt + COALESCE(v_mayor_mt_debe,0);
                            v_suma_haber = v_suma + COALESCE(v_mayor_haber,0);
                            v_suma_mt_haber = v_suma_mt + COALESCE(v_mayor_mt_haber,0);
                           
                           IF  v_registros.movimiento != 'si' THEN
                             v_cont_nro_nodo  = va_mayor[1];                              
                           END IF;
                           v_cont_nro_nodo = v_cont_nro_nodo +1;
                     
                 END LOOP;
       ELSE         
    --3) ELSE , si tenemos una cueta padre
    
           --incremetamos el nivel
            v_nivel = p_nivel_ini +1;
           -- FOR listado de cuenta  hijos para el padre indicado
           FOR  v_registros in (
                              select 
                                         c.id_orden_trabajo,
                                         c.codigo,
                                         c.desc_orden,
                                         --c.nivel_cuenta,
                                         c.id_orden_trabajo_fk,
                                         c.tipo,
                                         c.movimiento
                                from conta.torden_trabajo c    
                                where     c.id_orden_trabajo_fk = p_id_orden_trabajo_fk  
                                       and c.estado_reg = 'activo' 
                                        and c.tipo =ANY(va_tipo)  
                               )   LOOP
                
                    -- llamada recursiva del balance general
                    va_mayor = conta.f_balance_ot_recursivo(
                                          p_desde, 
                                          p_hasta, 
                                          p_id_deptos,
                                          v_cont_nro_nodo + 1 , 
                                          v_nivel, 
                                          p_nivel_final, 
                                          v_registros.id_orden_trabajo,
                                          p_tipo,
                                          p_incluir_cierre,
                                          p_tipo_balance);
                    
                     v_mayor = va_mayor[2];
                     v_mayor_mt = va_mayor[3];
                     v_mayor_debe = va_mayor[4];
                     v_mayor_mt_debe = va_mayor[5];
                     v_mayor_haber = va_mayor[6];
                     v_mayor_mt_haber = va_mayor[7]; 
                       
                     
                    -- insetamos en tabla temporal 
                    insert  into temp_balance_ot (
                                              id_orden_trabajo ,
                                              codigo ,
                                              desc_orden ,
                                              id_orden_trabajo_fk ,
                                              monto ,
                                              monto_mt,
                                              monto_debe ,
                                              monto_mt_debe,
                                              monto_haber ,
                                              monto_mt_haber,
                                              nivel ,
                                              tipo ,
                                              movimiento,
                                              nro_nodo)
                                    VALUES(
                                             v_registros.id_orden_trabajo,
                                             v_registros.codigo,
                                             v_registros.desc_orden,
                                             v_registros.id_orden_trabajo_fk,
                                             v_mayor,
                                             v_mayor_mt,
                                             v_mayor_debe ,
                                             v_mayor_mt_debe,
                                             v_mayor_haber,
                                             v_mayor_mt_haber,
                                             p_nivel_ini,
                                             v_registros.tipo,
                                             v_registros.movimiento,
                                             v_cont_nro_nodo );
                    -- incrementamos suma
                    v_suma = v_suma + COALESCE(v_mayor,0);
                    v_suma_mt = v_suma_mt + COALESCE(v_mayor_mt,0);
                    v_suma_debe = v_suma + COALESCE(v_mayor_debe,0);
                    v_suma_mt_debe = v_suma_mt + COALESCE(v_mayor_mt_debe,0);
                    v_suma_haber = v_suma + COALESCE(v_mayor_haber,0);
                    v_suma_mt_haber = v_suma_mt + COALESCE(v_mayor_mt_haber,0);
                    
                    v_cont_nro_nodo  = va_mayor[1]; 
                    v_cont_nro_nodo = v_cont_nro_nodo + 1;
              END LOOP;
       END IF;
          
   --reronarmos la suma del balance ...
   
   va_suma[1] = v_cont_nro_nodo;
   va_suma[2] = COALESCE(v_suma,0); 
   va_suma[3] =  COALESCE(v_suma_mt,0);
   va_suma[4] = COALESCE(v_suma_debe,0); 
   va_suma[5] =  COALESCE(v_suma_mt_debe,0);
   va_suma[6] = COALESCE(v_suma_haber,0); 
   va_suma[7] =  COALESCE(v_suma_mt_haber,0);
  
    
   RETURN va_suma;


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