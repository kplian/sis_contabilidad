--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_balance_tcc_sinc (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
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
va_id_periodo		integer[];
va_id_gestion		integer[];
 

BEGIN
     
     v_nombre_funcion = 'conta.f_balance_tcc';
     v_parametros = pxp.f_get_record(p_tabla);
    
    
    /*********************************   
     #TRANSACCION:    'CONTA_SINCRAN_IME'
     #DESCRIPCION:    sincroniza la tabla de rango segun el rango de fechas especificado
     #AUTOR:           rensi arteaga copari  kplian
     #FECHA:            20-06-2017
    ***********************************/

	IF(p_transaccion='CONTA_SINCRAN_IME')then
    
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
            
            select 
             pxp.aggarray(per.id_periodo)
            into
             va_id_periodo
            from param.tperiodo per
            where   v_parametros.desde BETWEEN per.fecha_ini and per.fecha_fin 
                OR v_parametros.hasta BETWEEN per.fecha_ini and per.fecha_fin
                OR per.fecha_fin BETWEEN v_parametros.desde and v_parametros.hasta;
                
                
             select 
                 pxp.aggarray (DISTINCT per.id_gestion::varchar)
               into
                  va_id_gestion 
             from param.tperiodo per
             where per.id_periodo = ANY(va_id_periodo);
          
            
          
           v_resp =  conta.f_balance_tcc_recursivo_sinc(va_id_periodo,
           												va_id_gestion,
                                                        NULL::integer,  --  id_tipo_cc INICIAL  
                                                        p_id_usuario);
         
          
         
           
          return 'exito';
       
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
COST 100;