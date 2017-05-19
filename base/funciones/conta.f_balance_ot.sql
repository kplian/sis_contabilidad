--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_balance_ot (
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
v_tipo		        varchar;
v_incluir_cierre	varchar;
v_incluir_sinmov	varchar;
 

BEGIN
     
     v_nombre_funcion = 'conta.f_balance_ot';
     v_parametros = pxp.f_get_record(p_tabla);
    
    
    /*********************************   
     #TRANSACCION:    'CONTA_BALOT_SEL'
     #DESCRIPCION:     Listado para el reporte del balance de las arbolde de ordenes de costo
     #AUTOR:           rensi arteaga copari  kplian
     #FECHA:            19-05-2017
    ***********************************/

	IF(p_transaccion='CONTA_BALOT_SEL')then
    
        if pxp.f_existe_parametro(p_tabla,'tipo') then
          v_tipo = v_parametros.tipo;
        end if;
        
        if pxp.f_existe_parametro(p_tabla,'incluir_cierre') then
          v_incluir_cierre = v_parametros.incluir_cierre;
        end if;
        
        
        v_incluir_sinmov = 'no';
        if pxp.f_existe_parametro(p_tabla,'incluir_sinmov') then
          v_incluir_sinmov = v_parametros.incluir_sinmov;
        end if;
        
        
        -- 1) Crea una tabla temporal con los datos que se utilizaran 

        CREATE TEMPORARY TABLE temp_balance_ot (
                                id_orden_trabajo integer,
                                codigo varchar,
                                desc_orden varchar,
                                id_orden_trabajo_fk integer,
                                monto numeric,
                                monto_mt numeric,
                                nivel integer,
                                tipo varchar,
                                movimiento	varchar
                           ) ON COMMIT DROP;
    
          
      --llamada recusiva para llenar la tabla
      v_nivel_inicial = 1;
      
  
      v_total =  conta.f_balance_recursivo_ot(
                                          v_parametros.desde, 
                                          v_parametros.hasta, 
                                          v_parametros.id_deptos, 
                                          1, 
                                          v_parametros.nivel,
                                          NULL::integer,
                                          v_tipo,
                                          v_incluir_cierre,
                                          v_parametros.tipo_balance);
       
      raise notice '------------------------------------------------> total %', v_total;
      
      
      
      v_consulta = 'SELECT                                   
                               id_orden_trabajo ,
                                codigo ,
                                desc_orden ,
                                id_orden_trabajo_fk ,
                                monto ,
                                monto_mt
                                nivel ,
                                tipo ,
                                movimiento	
                        FROM temp_balance_ot  ';
                        
                        
       IF v_incluir_sinmov != 'no' THEN                          
          v_consulta = v_consulta|| ' WHERE (monto != 0 and monto_mt !=0) and ' ;
       END IF; 
       
       IF v_parametros.tipo_balance = 'resultado' THEN 
           v_consulta = v_consulta|| ' order by movimiento desc, codigo asc' ;
       ELSE
           v_consulta = v_consulta|| ' order by  codigo';                  
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