--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_balance_tcc (
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
va_total 			numeric[];
v_total 			numeric;
v_total_mt 			numeric;
v_tipo		        varchar;
v_incluir_cierre	varchar;
v_incluir_sinmov	varchar;
v_cont_nro_nodo		integer;
va_id_tipo_cc 		integer[];
v_nro_nodo			integer;
v_id_moneda_base	integer;
v_id_moneda_tri	integer;
 

BEGIN
     
     v_nombre_funcion = 'conta.f_balance_tcc';
     v_parametros = pxp.f_get_record(p_tabla);
    
    
    /*********************************   
     #TRANSACCION:    'CONTA_BALTCC_SEL'
     #DESCRIPCION:     Listado para el reporte del balance por tipos de centrode costo
     #AUTOR:           rensi arteaga copari  kplian
     #FECHA:            19-05-2017
    ***********************************/

	IF(p_transaccion='CONTA_BALTCC_SEL')then
    
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
        
        v_id_moneda_tri  =  param.f_get_moneda_triangulacion();
        v_id_moneda_base =  param.f_get_moneda_base();
        
        
        -- 1) Crea una tabla temporal con los datos que se utilizaran 

        CREATE TEMPORARY TABLE temp_balance_tcc (
                                id_tipo_cc integer,
                                codigo varchar,
                                descripcion varchar,
                                id_tipo_cc_fk integer,
                                monto numeric,
                                monto_mt numeric,
                                monto_debe numeric,
                                monto_mt_debe numeric,
                                monto_haber numeric,
                                monto_mt_haber numeric,
                                nivel integer,
                                tipo varchar,
                                movimiento	varchar,
                                nro_nodo	integer
                           ) ON COMMIT DROP;
    
          
      --llamada recusiva para llenar la tabla
      v_nivel_inicial = 1;
     
      IF  v_parametros.id_tipo_ccs  is not null and v_parametros.id_tipo_ccs != '' THEN
       va_id_tipo_cc = string_to_array(v_parametros.id_tipo_ccs,',')::integer[]; 
      END IF;
     
   
      
      va_total =  conta.f_balance_tcc_recursivo(
                                                  v_parametros.desde, 
                                                  v_parametros.hasta, 
                                                  v_parametros.id_deptos,
                                                  0,--nro de nodo 
                                                  1,--  nivel                                           
                                                  v_parametros.nivel,
                                                  NULL::integer,  --  id_orden_trabajo INICIAL  
                                                  v_tipo,
                                                  v_id_moneda_base,
                                                  v_id_moneda_tri,
                                                  v_incluir_cierre,
                                                  v_parametros.tipo_balance,
                                                  va_id_tipo_cc,
                                                  v_parametros.incluir_adm,
                                                  v_parametros.importe,
                                                  v_parametros.moneda
                                                  );
     
     
     
       
    
     v_total = va_total[1];
    
     v_total_mt = va_total[2];
     --  raise exception '... >>> %',va_total[3]; 
    -- v_cont_nro_nodo = va_total[3]::integer; 
     
     
      
       
      raise notice '------------------------------------------------> total %', v_total;
      
      
      
      v_consulta = 'SELECT                                   
                                id_tipo_cc ,
                                codigo ,
                                descripcion ,
                                id_tipo_cc_fk ,
                                monto::numeric ,
                                monto_mt::numeric,
                                monto_debe::numeric ,
                                monto_mt_debe::numeric,
                                monto_haber::numeric ,
                                monto_mt_haber::numeric,
                                nivel ,
                                tipo ,
                                movimiento
                        FROM temp_balance_tcc  ';
                        
                        
                                            
                       
       IF v_incluir_sinmov != 'no' THEN                          
          v_consulta = v_consulta|| ' WHERE (monto != 0 and monto_mt !=0) and nivel <= '||v_parametros.nivel::varchar;
       ELSE
          v_consulta =  v_consulta|| ' WHERE  nivel <= '||v_parametros.nivel::Varchar ;
       END IF; 
       
       
       v_consulta = v_consulta|| ' order by  nro_nodo';                  
         
       
       raise notice 'consulta.. %',v_consulta;
       
       FOR v_registros in EXECUTE(v_consulta) LOOP
                   RETURN NEXT v_registros;
       END LOOP;
       
     
       
ELSE
   raise exception  'no se encontro el códidigo  de transacción:  %',p_transaccion;      

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