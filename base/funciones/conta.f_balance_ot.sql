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
va_total 			numeric[];
v_total 			numeric;
v_total_mt 			numeric;
v_tipo		        varchar;
v_incluir_cierre	varchar;
v_incluir_sinmov	varchar;
v_cont_nro_nodo		integer;
 

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
     
      
      va_total =  conta.f_balance_ot_recursivo(
                                          v_parametros.desde, 
                                          v_parametros.hasta, 
                                          v_parametros.id_deptos,
                                          0,--nro de nodo 
                                          1,--  nivel                                           
                                          v_parametros.nivel,
                                          NULL::integer,  --  id_orden_trabajo INICIAL  
                                          v_tipo,
                                          v_incluir_cierre,
                                          v_parametros.tipo_balance);
      v_total = va_total[1];
      v_total_mt = va_total[2];
      v_cont_nro_nodo = va_total[3]; 
      
       
      raise notice '------------------------------------------------> total %', v_total;
      
      
      
      v_consulta = 'SELECT                                   
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
                                movimiento
                        FROM temp_balance_ot  ';
                        
                        
                                            
                        
       IF v_incluir_sinmov != 'no' THEN                          
          v_consulta = v_consulta|| ' WHERE (monto != 0 and monto_mt !=0) and ' ;
       END IF; 
       
       IF v_parametros.tipo_balance = 'resultado' THEN 
           v_consulta = v_consulta|| ' order by movimiento desc, codigo asc' ;
       ELSE
           v_consulta = v_consulta|| ' order by  nro_nodo';                  
       END IF;
       
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