--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_balance_recursivo (
  p_desde date,
  p_hasta date,
  p_id_deptos varchar,
  p_nivel_ini integer,
  p_nivel_final integer,
  p_id_cuenta_padre integer
)
RETURNS numeric AS
$body$
DECLARE


v_parametros  		record;
v_registros 		record;
v_nombre_funcion   	text;
v_resp				varchar;
v_nivel				integer;
v_suma				numeric;
v_mayor				numeric;
v_id_gestion  		integer;
 

BEGIN



    v_nombre_funcion = 'conta.f_balance_recursivo';
    -- 0) inicia suma
    v_suma = 0;
    
     --recupera datos de la cuenta padre
     IF p_id_cuenta_padre is not null THEN
       select
         cue.tipo_cuenta,
         cue.sw_transaccional
       into
         v_registros
       from conta.tcuenta cue
       where cue.id_cuenta_padre = p_id_cuenta_padre;
       
       IF v_registros.sw_transaccional = 'movimiento' THEN
            -- caculamos el mayor
            v_mayor =  conta.f_mayor_cuenta(p_id_cuenta_padre, p_desde, p_hasta, p_id_deptos);
            return v_mayor;
       END IF; 
        
     END IF;
    
    
    --1) IF   si el nivel inicial es igual al nivel final calculamo el mayor de la cuenta
           
       IF p_nivel_ini  = p_nivel_final  THEN  
         
       
          if p_id_cuenta_padre is not NULL THEN
             -- FOR listamos la cuentas hijos
              FOR  v_registros in (select
                                     c.id_cuenta,
                                     c.nro_cuenta,
                                     c.nombre_cuenta,
                                     c.nivel_cuenta,
                                     c.id_cuenta_padre,
                                     c.tipo_cuenta
                                   from conta.tcuenta c
                                   where c.id_cuenta_padre = p_id_cuenta_padre 
                                         and c.estado_reg = 'activo' and 'balance' = ANY(c.eeff)
                                    )   LOOP
                   
                   -- caculamos el mayor
                    v_mayor = conta.f_mayor_cuenta(v_registros.id_cuenta, p_desde, p_hasta, p_id_deptos);
                   
                   -- insetamos en tabla temporal 
                    insert  into temp_balancef (
                                    id_cuenta,
                                    nro_cuenta,
                                    nombre_cuenta,
                                    id_cuenta_padre,
                                    monto,
                                    nivel,
                                    tipo_cuenta)
                                  VALUES(
                                   v_registros.id_cuenta,
                                   v_registros.nro_cuenta,
                                   v_registros.nombre_cuenta,
                                   v_registros.id_cuenta_padre,
                                   v_mayor,
                                   p_nivel_ini,
                                   v_registros.tipo_cuenta );
                    
                    
                 
                   -- incrementamos suma
                   v_suma = v_suma + COALESCE(v_mayor,0);
                
                END LOOP;
             ELSE
             
                   select 
                     ges.id_gestion
                   into
                    v_id_gestion  
                   from param.tgestion ges
                   WHERE ges.gestion = (SELECT EXTRACT(YEAR FROM now()::Date))::integer  and ges.estado_reg = 'activo';
                 -- FOR listamos la cuentas hijos
                  FOR  v_registros in (select
                                         c.id_cuenta,
                                         c.nro_cuenta,
                                         c.nombre_cuenta,
                                         c.nivel_cuenta,
                                         c.id_cuenta_padre.
                                         c.tipo_cuenta
                                       from conta.tcuenta c  
                                        where c.id_cuenta_padre is NULL 
                                        and c.estado_reg = 'activo' and 'balance' = ANY(c.eeff)
                                        and c.id_gestion = v_id_gestion and c.estado_reg = 'activo' )   LOOP
                       
                       -- caculamos el mayor
                        v_mayor = conta.f_mayor_cuenta(v_registros.id_cuenta, p_desde, p_hasta, p_id_deptos);
                       
                       -- insetamos en tabla temporal 
                        insert  into temp_balancef (
                                        id_cuenta,
                                        nro_cuenta,
                                        nombre_cuenta,
                                        id_cuenta_padre,
                                        monto,
                                        nivel,
                                        tipo_cuenta)
                                      VALUES(
                                       v_registros.id_cuenta,
                                       v_registros.nro_cuenta,
                                       v_registros.nombre_cuenta,
                                       v_registros.id_cuenta_padre,
                                       v_mayor,
                                       p_nivel_ini,
                                       v_registros.tipo_cuenta );
                        
                        
                     
                       -- incrementamos suma
                       v_suma = v_suma + COALESCE(v_mayor,0);
                    
                    END LOOP;
             
             
             
             END IF;
       ELSEIF  p_nivel_ini = 1   THEN
       
    --2) ELSIF, si el nivel inicial es 0 identificamos la cuentas de la gestion
    
           -- incremetmaos el nivel
           v_nivel = p_nivel_ini +1;
           
           -- obtiene la gestion de la fecha inicial
           
           select 
             ges.id_gestion
           into
            v_id_gestion  
           from param.tgestion ges
           WHERE ges.gestion = (SELECT EXTRACT(YEAR FROM now()::Date))::integer  and ges.estado_reg = 'activo';
           
           -- FOR listado de cuenta basicas de la gestion 
           FOR  v_registros in (
                              select c.id_cuenta,
                                 c.nro_cuenta,
                                 c.nombre_cuenta,
                                 c.nivel_cuenta,
                                 c.id_cuenta_padre,
                                 c.tipo_cuenta
                                from conta.tcuenta c  
                                where c.id_cuenta_padre is NULL and c.id_gestion = v_id_gestion 
                                and c.estado_reg = 'activo' and 'balance' = ANY(c.eeff))   LOOP
                
                 -- llamada recursiva del balance general
           
                  v_mayor = conta.f_balance_recursivo(p_desde, p_hasta, p_id_deptos, v_nivel, p_nivel_final, v_registros.id_cuenta);
                 
                 -- insetamos en tabla temporal 
                    insert  into temp_balancef (
                                  id_cuenta,
                                  nro_cuenta,
                                  nombre_cuenta,
                                  id_cuenta_padre,
                                  monto,
                                  nivel,
                                  tipo_cuenta)
                                VALUES(
                                 v_registros.id_cuenta,
                                 v_registros.nro_cuenta,
                                 v_registros.nombre_cuenta,
                                 v_registros.id_cuenta_padre,
                                 v_mayor,
                                 p_nivel_ini,
                                 v_registros.tipo_cuenta );
                                 
                                 
               -- incrementamos suma
               v_suma = v_suma + COALESCE(v_mayor,0);
               
           END LOOP;
       ELSE         
    --3) ELSE , si tenemos una cueta padre
    
           --incremetamos el nivel
            v_nivel = p_nivel_ini +1;
           -- FOR listado de cuenta  hijos para el padre indicado
           FOR  v_registros in (
                              select c.id_cuenta,
                                 c.nro_cuenta,
                                 c.nombre_cuenta,
                                 c.nivel_cuenta,
                                 c.id_cuenta_padre,
                                 c.tipo_cuenta
                                from conta.tcuenta c  
                                where     c.id_cuenta_padre = p_id_cuenta_padre  
                                      and c.estado_reg = 'activo' and 'balance' = ANY(c.eeff) )   LOOP
                
                -- llamada recursiva del balance general
                v_mayor = conta.f_balance_recursivo(p_desde, p_hasta, p_id_deptos, v_nivel, p_nivel_final, v_registros.id_cuenta);
                 
                -- insetamos en tabla temporal 
                insert  into temp_balancef (
                                  id_cuenta,
                                  nro_cuenta,
                                  nombre_cuenta,
                                  id_cuenta_padre,
                                  monto,
                                  nivel,
                                  tipo_cuenta)
                                VALUES(
                                 v_registros.id_cuenta,
                                 v_registros.nro_cuenta,
                                 v_registros.nombre_cuenta,
                                 v_registros.id_cuenta_padre,
                                 v_mayor,
                                 p_nivel_ini,
                                 v_registros.tipo_cuenta );
                -- incrementamos suma
                v_suma = v_suma + COALESCE(v_mayor,0);
              END LOOP;
       END IF;
          
   --reronarmos la suma del balance ...
   
   RETURN v_suma;


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