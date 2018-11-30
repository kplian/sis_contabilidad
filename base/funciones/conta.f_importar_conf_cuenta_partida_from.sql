CREATE OR REPLACE FUNCTION conta.f_importar_conf_cuenta_partida_from (
)
RETURNS varchar AS
$body$
DECLARE


v_parametros  		record;
v_nombre_funcion   	text;
v_resp				varchar;


v_sw integer;
v_sw2 integer;
v_count integer;
v_consulta varchar;
v_registros  record;  -- PARA ALMACENAR EL CONJUNTO DE DATOS RESULTADO DEL SELECT


v_i integer;
v_nivel_inicial		integer;
va_total 			numeric[];
v_total 			numeric;
v_total_mt 			numeric;
v_tipo		        varchar;
v_incluir_cierre	varchar;
v_incluir_sinmov	varchar;
v_cont_nro_nodo		integer;
va_id_orden 		integer[];
v_nro_nodo			integer;
 

BEGIN
     
     v_nombre_funcion = 'conta."f_importar_conf_cuenta_partida_from _rc"';
     
     FOR v_registros in ( select
                             rc.id_gestion,
                             rc.id_cuenta,
                             rc.id_auxiliar,
                             rc.id_partida
                           from conta.trelacion_contable  rc
                           where rc.estado_reg = 'activo' )LOOP 
     
     
       IF v_registros.id_cuenta is not null and  v_registros.id_partida is not null THEN
       
            -- verificamos si tenemso cuenta y partidda
            
              if not exists (select 
                                 1
                              from conta.tcuenta_partida cp
                              where cp.estado_reg = 'activo' 
                                    and cp.id_cuenta = v_registros.id_cuenta   and cp.id_partida = v_registros.id_partida) THEN
            
            
                  --  relacion cuenta partida
                   INSERT INTO   conta.tcuenta_partida
                        (
                          id_usuario_reg,
                          fecha_reg,
                          estado_reg,
                          id_cuenta,
                          id_partida,
                          sw_deha,
                          se_rega
                        )
                        VALUES (
                          1,
                          now(),                        
                          'activo',
                          v_registros.id_cuenta,
                          v_registros.id_partida,
                          'debe',
                          'gasto'
                        );
                END IF; -- si no existe la relacion 
       
       END IF;
     
     
           --  relacion cuenta auxiliar
     
           IF v_registros.id_cuenta is not null and  v_registros.id_auxiliar is not null THEN
           
                    if not exists (select 
                                           1
                                        from conta.tcuenta_auxiliar ca
                                        where ca.estado_reg = 'activo' 
                                              and ca.id_cuenta = v_registros.id_cuenta   and ca.id_auxiliar = v_registros.id_auxiliar) THEN
                             
                              INSERT INTO 
                                      conta.tcuenta_auxiliar
                                    (
                                      id_usuario_reg,
                                      fecha_reg,
                                      estado_reg,
                                      id_auxiliar,
                                      id_cuenta
                                    )
                                    VALUES (
                                      1,
                                      now(),
                                      'activo',
                                      v_registros.id_auxiliar,
                                      v_registros.id_cuenta
                                    );
                         END IF;
           END IF;
     
     END LOOP;
     
     return 'exito';

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