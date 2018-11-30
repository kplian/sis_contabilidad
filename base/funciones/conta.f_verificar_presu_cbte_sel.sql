--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_verificar_presu_cbte_sel (
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
v_pre_verificar_categoria   varchar;
v_pre_verificar_tipo_cc   	varchar;
v_control_partida   		varchar;
 

BEGIN
     
     v_nombre_funcion = 'conta.f_verificar_presu_cbte_sel';
     v_parametros = pxp.f_get_record(p_tabla);
    
    
    /*********************************   
     #TRANSACCION:    'CONTA_VERPRES_SEL'
     #DESCRIPCION:     Listado para verificar presupesuto de comprobante en estado borrador sin presupeusto comprometido
     #AUTOR:           rensi arteaga copari  kplian
     #FECHA:           31-08-2017
    ***********************************/

	IF(p_transaccion='CONTA_VERPRES_SEL')then
    
        v_id_moneda_base =  param.f_get_moneda_base();
        
        v_pre_verificar_categoria = pxp.f_get_variable_global('pre_verificar_categoria');
        v_pre_verificar_tipo_cc = pxp.f_get_variable_global('pre_verificar_tipo_cc');
        v_control_partida = 'si'; --por defeto controlamos los monstos por partidas
        
      
        
        
      FOR v_registros in (
                         Select 
                            ver.id_ver,
                            ver.control_partida,
                            ver.id_par,
                            ver.id_agrupador,
                            ver.importe_debe,
                            ver.importe_haber,
                            ver.movimiento,
                            ver.id_presupuestos[1] as id_presupuesto,
                            ver.tipo_cambio,
                            ver.monto_mb,
                            ver.verificacion[1] as verificacion,
                            ver.verificacion[2]::numeric as saldo,
                            part.codigo as codigo_partida,
                            part.nombre_partida,
                            pcc.desc_tipo_presupuesto,
                            pcc.descripcion
                            
                            

                        from ( 
                                 Select
                                  row_number() over() as id_ver, 
                                  control_partida,
                                  id_par,
                                  id_agrupador,
                                  id_presupuestos,
                                  importe_debe,
                                  importe_haber,
                                  param.f_convertir_moneda (
                                                             
                                                             id_moneda, 
                                                             v_id_moneda_base,
                                                             CASE  when movimiento = 'gasto' then (importe_debe-importe_haber)
                                                             ELSE  (importe_haber - importe_debe)
                                                             END, 
                                                             fecha,
                                                             'CUS',50, 
                                                             tipo_cambio, 'no') as monto_mb,
                                  movimiento,
                                  tipo_cambio,
                                  
                                  
                                pre.f_verificar_presupuesto_individual(
                                                    null, 
                                                    null, 
                                                    id_presupuestos[1], 
                                                    id_par, 
                                                    param.f_convertir_moneda (
                                                             
                                                             id_moneda, 
                                                             v_id_moneda_base,
                                                             CASE  when movimiento = 'gasto' then (importe_debe-importe_haber)
                                                             ELSE  (importe_haber - importe_debe)
                                                             END, 
                                                             fecha,
                                                             'CUS',50, 
                                                             tipo_cambio, 'no'), 
                                                     CASE  when movimiento = 'gasto' then (importe_debe-importe_haber)
                                                     ELSE  (importe_haber - importe_debe)
                                                     END, 
                                                    'comprometido') as verificacion

                                from ( SELECT tcc.control_partida,
                                             CASE
                                                 WHEN v_pre_verificar_tipo_cc = 'si' and tcc.control_partida::text = 'no' THEN
                                                    0
                                                ELSE 
                                                   it.id_partida
                                             END AS id_par,
                                             CASE
                                               WHEN v_pre_verificar_categoria = 'si' THEN 
                                                   p.id_categoria_prog
                                               WHEN v_pre_verificar_tipo_cc = 'si' THEN 
                                                  cc.id_tipo_cc
                                               ELSE it.id_centro_costo 
                                             END AS id_agrupador,
                                             sum(it.importe_debe) AS importe_debe,
                                             sum(it.importe_haber) AS importe_haber,
                                             
                                             tp.movimiento,
                                             pxp.aggarray(p.id_presupuesto) AS id_presupuestos,
                                             avg(it.tipo_cambio) as tipo_cambio,
                                             cbte.fecha,
                                             cbte.id_moneda
                                      FROM conta.tint_transaccion it
                                           JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante = it.id_int_comprobante
                                           JOIN pre.tpresupuesto p ON p.id_presupuesto = it.id_centro_costo
                                           JOIN param.tcentro_costo cc ON cc.id_centro_costo = it.id_centro_costo
                                           JOIN pre.ttipo_presupuesto tp ON tp.codigo::text = p.tipo_pres::text
                                           JOIN pre.tpartida par ON par.id_partida = it.id_partida
                                           JOIN param.vtipo_cc_techo tcc ON tcc.id_tipo_cc = cc.id_tipo_cc
                                      WHERE it.id_int_comprobante = v_parametros.id_int_comprobante  AND
                                            tp.movimiento <> 'administrativo' AND
                                            par.sw_movimiento = 'presupuestaria' and
                                            it.id_partida_ejecucion  is null
                                       group by  id_par, 
                                                id_agrupador  ,    
                                                tcc.control_partida,
                                                tp.movimiento,
                                                cbte.fecha,
                                                cbte.id_moneda) xx)  ver
                left join pre.tpartida part on  ver.id_par = part.id_partida
                inner join pre.vpresupuesto_cc pcc on pcc.id_presupuesto = ver.id_presupuestos[1] ) LOOP
                 
                
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