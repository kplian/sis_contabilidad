--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_validar_comprobante_central (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_int_comprobante integer,
  p_conexion varchar = NULL::character varying
)
RETURNS boolean AS
$body$
/*

Autor: JRR KPLIAN (Todabia no sabe poner comentario)
Fecha:   28 septiembre  de 2015
Descripcion  


        Esta funcion corre despues de validar el cbte de la regional  (solo en comprobantes migrados con origen = central) 
        y replica el resultado a la central (por ejemplo pasa cambia el estado del plan de pagos)

  

*/


DECLARE
  
	v_nombre_funcion			   		text;
	v_resp								varchar; 
    v_int_comprobante			 		record;
    v_nombre_conexion			  		varchar;
    v_codigo_estacion			 		varchar;
    v_consulta			 				varchar;
    resultado							numeric;
    v_respuesta_dblink					varchar;
    v_funcion_comprobante_validado_central	text;
    v_registros_tran					record;
    v_resp_dblink_tra_rel				record;
    v_resp_dblink_tra			       record;
   
    
    
BEGIN

	v_nombre_funcion = 'conta.f_validar_comprobante_central';
    
    -- Verificar que el int_comprobante no sea null
    
    if (p_id_int_comprobante is null) then
    	raise exception 'Error al validar el comprobante de la central, el campo int_comprobante esta vacio';
    end if;
    
    select
        c.* 
    into
       v_int_comprobante
    from conta.tint_comprobante c    
    where c.id_int_comprobante = p_id_int_comprobante;
    
    
   
    
    if (v_int_comprobante.id_int_comprobante_origen_central is null) then
    	raise exception 'Error al validar el comprobante de la central, se llamo a la funcion para validar comprobante de la central, pero no se encontro el id_int_comprobante de la relacion';
    end if;
    
    if p_conexion is null then
     
    	select * into v_nombre_conexion from migra.f_crear_conexion();
    else
    	v_nombre_conexion = p_conexion;
    end if;
    
    
    
    --mandamos el codigo de la estacion  y el idel del cbte de la regional
    
    v_codigo_estacion = pxp.f_get_variable_global('conta_codigo_estacion');
    
    
    --------------------------------------
    --modicar localidad del cbte original
    -------------------------------------
     
    v_consulta = 'update conta.tint_comprobante set 
    				sw_tipo_cambio = '''||v_int_comprobante.sw_tipo_cambio||''',
                    localidad = ''internacional'' ,
                    sw_editable = ''no'' ,
                    tipo_cambio = '||v_int_comprobante.tipo_cambio_2::varchar||'
                  where id_int_comprobante = '||v_int_comprobante.id_int_comprobante_origen_central::varchar; 
                            
   
   PERFORM  dblink(v_nombre_conexion,v_consulta, true);
                            
  
    -----------------------------------------------------------------------------------
    -- actulizar TC1 , moneda de triangulacón y transacciones faltantes en la central
    -----------------------------------------------------------------------------------
    
    FOR  v_registros_tran in (
                               select 
                                     * 
                               from conta.tint_transaccion c 
                               where c.id_int_comprobante = p_id_int_comprobante and
                                     c.estado_reg = 'activo' )LOOP
    
                v_consulta = 'select 1::integer as contador from conta.tint_transaccion where id_int_transaccion = '||v_registros_tran.id_int_transaccion_origen::varchar ;
                
                select * FROM dblink(v_nombre_conexion, v_consulta,TRUE)AS t1(contador integer) into v_resp_dblink_tra;
              
               -- si la transaccion exite en el destino
               IF v_resp_dblink_tra.contador = 1 THEN
                   
                   v_consulta = 'update conta.tint_transaccion set
                                   id_moneda_tri =  '||COALESCE(v_registros_tran.id_moneda_tri::varchar,'NULL')||',
                                   tipo_cambio  =  '||COALESCE(v_registros_tran.tipo_cambio_2::varchar,'NULL')||',
                                   id_moneda  =  '||COALESCE(v_registros_tran.id_moneda::varchar,'NULL')||',
                                   importe_debe =  '||COALESCE(v_registros_tran.importe_debe::varchar,'NULL')||',
                                   importe_haber =  '||COALESCE(v_registros_tran.importe_haber::varchar,'NULL')||',
                                   importe_gasto =  '||COALESCE(v_registros_tran.importe_gasto::varchar,'NULL')||',
                                   importe_recurso =  '||COALESCE(v_registros_tran.importe_recurso::varchar,'NULL')||',
                                   importe_debe_mt =  '||COALESCE(v_registros_tran.importe_debe_mt::varchar,'NULL')||',
                                   importe_haber_mt =  '||COALESCE(v_registros_tran.importe_haber_mt::varchar,'NULL')||',
                                   importe_gasto_mt =  '||COALESCE(v_registros_tran.importe_gasto_mt::varchar,'NULL')||',
                                   importe_recurso_mt =  '||COALESCE(v_registros_tran.importe_recurso_mt::varchar,'NULL')||',
                                   id_partida =  '||COALESCE(v_registros_tran.id_partida::varchar,'NULL')||',
                                   id_orden_trabajo =  '||COALESCE(v_registros_tran.id_orden_trabajo::varchar,'NULL')||',
                                   id_cuenta =  '||COALESCE(v_registros_tran.id_cuenta::varchar,'NULL')||',
                                   id_centro_costo =  '||COALESCE(v_registros_tran.id_centro_costo::varchar,'NULL')||',
                                   id_auxiliar =  '||COALESCE(v_registros_tran.id_auxiliar::varchar,'NULL')||'
                                   
                                 where id_int_transaccion = '||v_registros_tran.id_int_transaccion_origen::varchar ;
                  
                   
                   PERFORM dblink(v_nombre_conexion,v_consulta, true);
                            
               ELSE --si no existe en al central
                  
                   -- insertar trasacciones solo si tienen valor para M o MT (no se considera si solo tiene valor en MB)
                   IF  v_registros_tran.importe_debe_mt > 0 or v_registros_tran.importe_haber_mt > 0 THEN
                   
                            
                            --insertar la trasaccion
                             v_consulta= 'INSERT INTO 
                                                    conta.tint_transaccion
                                                  (
                                                    id_usuario_reg,
                                                    id_usuario_mod,
                                                    fecha_reg,
                                                    fecha_mod,
                                                    estado_reg,
                                                    id_usuario_ai,
                                                    usuario_ai,
                                                   
                                                    id_int_comprobante,
                                                    id_cuenta,
                                                    id_auxiliar,
                                                    id_centro_costo,
                                                    id_partida,
                                                    id_partida_ejecucion,
                                                    id_int_transaccion_fk,
                                                    glosa,
                                                    tipo_cambio,
                                                    id_moneda,
                                                    id_moenda_tri,
                                                    importe_debe,
                                                    importe_haber,
                                                    importe_recurso,
                                                    importe_gasto,
                                                    
                                                    importe_debe_mt,
                                                    importe_haber_mt,
                                                    importe_recurso_mt,
                                                    importe_gasto_mt,
                                                   
                                                    id_detalle_plantilla_comprobante,
                                                    id_partida_ejecucion_dev,
                                                    importe_reversion,
                                                    monto_pagado_revertido,
                                                    id_partida_ejecucion_rev,
                                                    id_cuenta_bancaria,
                                                    id_cuenta_bancaria_mov,
                                                    nro_cheque,
                                                    nro_cuenta_bancaria_trans,
                                                    porc_monto_excento_var,
                                                    nombre_cheque_trans,
                                                    factor_reversion,
                                                    id_orden_trabajo,
                                                    forma_pago,
                                                    banco,
                                                    id_int_transaccion_origen
                                                  )
                                                  VALUES ('||
                                                     COALESCE(v_registros_tran.id_usuario_reg::varchar,'NULL')||','||
                                                     COALESCE(v_registros_tran.id_usuario_mod::varchar,'NULL')||','||
                                                     COALESCE(''''||v_registros_tran.fecha_reg::varchar||'''','NULL')||','||
                                                     COALESCE(''''||v_registros_tran.fecha_mod::varchar||'''','NULL')||','||
                                                     COALESCE(''''||v_registros_tran.estado_reg::varchar||'''','NULL')||','||
                                                     COALESCE(v_registros_tran.id_usuario_ai::varchar,'NULL')||','||
                                                     COALESCE(''''||v_registros_tran.usuario_ai::varchar||'''','NULL')||','||
                                                   
                                                     COALESCE(v_int_comprobante.id_int_comprobante_origen_central::varchar,'NULL')||','||
                                                     COALESCE(v_registros_tran.id_cuenta::varchar,'NULL')||','||
                                                     COALESCE(v_registros_tran.id_auxiliar::varchar,'NULL')||','||
                                                     COALESCE(v_registros_tran.id_centro_costo::varchar,'NULL')||','||
                                                     COALESCE(v_registros_tran.id_partida::varchar,'NULL')||','||
                                                     COALESCE(v_registros_tran.id_partida_ejecucion::varchar,'NULL')||','||
                                                     COALESCE(v_registros_tran.id_int_transaccion_fk::varchar,'NULL')||','||
                                                     COALESCE(''''||v_registros_tran.glosa::varchar||'''','NULL')||','||
                                                     
                                                     COALESCE(v_registros_tran.tipo_cambio_2::varchar,'NULL')||','||
                                                     COALESCE(v_registros_tran.id_moneda::varchar,'NULL')||','||
                                                     COALESCE(v_registros_tran.id_moneda_tri::varchar,'NULL')||','||
                                                     
                                                     
                                                     COALESCE(v_registros_tran.importe_debe::varchar,'NULL')||','||
                                                     COALESCE(v_registros_tran.importe_haber::varchar,'NULL')||','||
                                                     COALESCE(v_registros_tran.importe_recurso::varchar,'NULL')||','||
                                                     COALESCE(v_registros_tran.importe_gasto::varchar,'NULL')||','||
                                                     
                                                     COALESCE(v_registros_tran.importe_debe_mt::varchar,'NULL')||','||
                                                     COALESCE(v_registros_tran.importe_haber_mt::varchar,'NULL')||','||
                                                     COALESCE(v_registros_tran.importe_recurso_mt::varchar,'NULL')||','||
                                                     COALESCE(v_registros_tran.importe_gasto_mt::varchar,'NULL')||','||
                                                    
                                                     COALESCE(v_registros_tran.id_detalle_plantilla_comprobante::varchar,'NULL')||','||
                                                     COALESCE(v_registros_tran.id_partida_ejecucion_dev::varchar,'NULL')||','||
                                                     COALESCE(v_registros_tran.importe_reversion::varchar,'NULL')||','||
                                                     COALESCE(v_registros_tran.monto_pagado_revertido::varchar,'NULL')||','||
                                                     COALESCE(v_registros_tran.id_partida_ejecucion_rev::varchar,'NULL')||','||
                                                     COALESCE(v_registros_tran.id_cuenta_bancaria::varchar,'NULL')||','||
                                                     COALESCE(v_registros_tran.id_cuenta_bancaria_mov::varchar,'NULL')||','||
                                                     COALESCE(v_registros_tran.nro_cheque::varchar,'NULL')||','||
                                                     COALESCE(''''||v_registros_tran.nro_cuenta_bancaria_trans::varchar||'''','NULL')||','||
                                                     COALESCE(v_registros_tran.porc_monto_excento_var::varchar,'NULL')||','||
                                                     COALESCE(''''||v_registros_tran.nombre_cheque_trans::varchar||'''','NULL')||','||
                                                     COALESCE(v_registros_tran.factor_reversion::varchar,'NULL')||','||
                                                     COALESCE(v_registros_tran.id_orden_trabajo::varchar,'NULL')||','||
                                                     COALESCE(''''||v_registros_tran.forma_pago::varchar||'''','NULL')||','||
                                                     COALESCE(''''||v_registros_tran.banco::varchar||'''','NULL')||','||
                                                     COALESCE(v_registros_tran.id_int_transaccion::varchar,'NULL')||') RETURNING id_int_transaccion'; 
                                                     
                              
                              SELECT * FROM  dblink(v_nombre_conexion,v_consulta, true) AS (id_int_transaccion integer) into v_resp_dblink_tra;
                            
                             -- actualizar en trasaccion enla regional
                             
                             update conta.tint_transaccion t set
                               id_int_transaccion_origen = v_resp_dblink_tra.id_int_transaccion
                             where id_int_transaccion = v_registros_tran.id_int_transaccion;
                   
                   
                   END IF;
                   
               END IF;    
                     
    END LOOP;
    
    
    --------------------------------------------------------------------------------------
    --  llamada a la funcion que calcula la equivalencia en moenda base en la central
    ---------------------------------------------------------------------------------------
     
     
        v_consulta = 'SELECT * FROM conta.f_act_trans_cbte_generados('||v_int_comprobante.id_int_comprobante_origen_central::varchar||',''Central'')'; 
                            
        SELECT * FROM dblink(v_nombre_conexion,v_consulta,TRUE)AS t1(resp boolean) into v_resp_dblink_tra;
      
      --actulizar transacciones
      
     
    -----------------------------------------------------------------
    --  llamada a la funcion que cambia el estado del plan de pagos
    -----------------------------------------------------------------
    
    
    SELECT *
    FROM dblink(v_nombre_conexion, 'select 
							   	pc.funcion_comprobante_validado  	
							  	from conta.tint_comprobante c
							  	left join  conta.tplantilla_comprobante pc  on pc.id_plantilla_comprobante = c.id_plantilla_comprobante
							  	where c.id_int_comprobante = ' || v_int_comprobante.id_int_comprobante_origen_central)
    AS t1(nombre_funcion text) into v_funcion_comprobante_validado_central;  
    
     
          
    if (v_funcion_comprobante_validado_central is not null) then
    	v_consulta = 'select ' || v_funcion_comprobante_validado_central  ||'('||p_id_usuario::varchar||','||
                     COALESCE(p_id_usuario_ai::varchar,'NULL')||','||
                     COALESCE(''''||p_usuario_ai::varchar||'''','NULL')||','|| 
                     v_int_comprobante.id_int_comprobante_origen_central::varchar||', NULL, '||
                     p_id_int_comprobante::varchar||', '''||v_codigo_estacion||''','''||v_int_comprobante.nro_cbte||''')'; 
                            
        --raise exception '%',v_consulta;
        select * FROM dblink(v_nombre_conexion,
                     v_consulta,TRUE)AS t1(resp varchar)
                             into v_respuesta_dblink;
    end if;    	 
          
    
    
    
    
    if p_conexion is null then
    	select * into v_resp from migra.f_cerrar_conexion(v_nombre_conexion,'exito'); 
    end if;
	RETURN  TRUE;



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