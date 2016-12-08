--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_balance (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS SETOF record AS
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
v_total 			numeric;
v_tipo_cuenta		varchar;
v_incluir_cierre	varchar;
v_incluir_sinmov	varchar;
 

BEGIN
     
     v_nombre_funcion = 'conta.f_balance';
     v_parametros = pxp.f_get_record(p_tabla);
    
    
    /*********************************   
     #TRANSACCION:    'CONTA_BALANCE_SEL'
     #DESCRIPCION:     Listado para el reporte del balance general
     #AUTOR:           rensi arteaga copari  kplian
     #FECHA:            12-06-2015
    ***********************************/

	IF(p_transaccion='CONTA_BALANCE_SEL')then
    
        if pxp.f_existe_parametro(p_tabla,'tipo_cuenta') then
          v_tipo_cuenta = v_parametros.tipo_cuenta;
        end if;
        
        if pxp.f_existe_parametro(p_tabla,'incluir_cierre') then
          v_incluir_cierre = v_parametros.incluir_cierre;
        end if;
        
        
        v_incluir_sinmov = 'no';
        if pxp.f_existe_parametro(p_tabla,'incluir_sinmov') then
          v_incluir_sinmov = v_parametros.incluir_sinmov;
        end if;
        
        
        -- 1) Crea una tabla temporal con los datos que se utilizaran 

        CREATE TEMPORARY TABLE temp_balancef (
                                id_cuenta integer,
                                nro_cuenta varchar,
                                nombre_cuenta varchar,
                                id_cuenta_padre integer,
                                monto numeric,
                                nivel integer,
                                tipo_cuenta varchar,
                                movimiento	varchar
                                     ) ON COMMIT DROP;
    
          
      --llamada recusiva para llenar la tabla
      v_nivel_inicial = 1;
      
  
      v_total =  conta.f_balance_recursivo(v_parametros.desde, 
                                          v_parametros.hasta, 
                                          v_parametros.id_deptos, 
                                          1, 
                                          v_parametros.nivel,
                                          NULL::integer,
                                          v_tipo_cuenta,
                                          v_incluir_cierre,
                                          v_parametros.tipo_balance);
       
      raise notice '------------------------------------------------> total %', v_total;
      
      
      
      v_consulta = 'SELECT                                   
                            id_cuenta,
                            nro_cuenta,
                            nombre_cuenta,
                            id_cuenta_padre,
                            monto,
                            nivel,
                            tipo_cuenta,
                            movimiento
                        FROM temp_balancef  ';
                        
                        
       IF v_incluir_sinmov != 'no' THEN                          
          v_consulta = v_consulta|| ' WHERE monto != 0 ' ;
       END IF; 
       
       IF v_parametros.tipo_balance = 'resultado' THEN 
           v_consulta = v_consulta|| ' order by movimiento desc, nro_cuenta asc' ;
       ELSE
           v_consulta = v_consulta|| ' order by  nro_cuenta';                  
       END IF;
       
       FOR v_registros in EXECUTE(v_consulta) LOOP
                   RETURN NEXT v_registros;
       END LOOP;
       
      

END IF;

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
COST 100 ROWS 1000;