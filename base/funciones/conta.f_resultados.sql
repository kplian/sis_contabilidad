--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_resultados (
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


v_i 				integer;
v_nivel_inicial		integer;
v_total 			numeric;
v_id_gestion		integer;
v_gestion    		varchar;
v_reg_cuenta		record;	
v_monto 			numeric;
va_id_cuenta		INTEGER[];
 

BEGIN
     
     v_nombre_funcion = 'conta.f_resultados';
     v_parametros = pxp.f_get_record(p_tabla);
    
    
    /*********************************   
     #TRANSACCION:    'CONTA_RESUTADO_SEL'
     #DESCRIPCION:     Listado para el reporte del resultados
     #AUTOR:           rensi arteaga copari  kplian
     #FECHA:            08-07-2015
    ***********************************/

	IF(p_transaccion='CONTA_RESUTADO_SEL')then
         
         --  0) recuperamos la gestion segun fecha inicial   
         
         v_gestion =  EXTRACT(YEAR FROM  v_parametros.desde::Date)::varchar;
            
          select 
            ges.id_gestion
          into
            v_id_gestion
          from param.tgestion ges 
          where ges.gestion::varchar  = v_gestion and ges.estado_reg = 'activo';
          
          IF v_id_gestion is NULL THEN  
          		raise exception 'No se encontro gestion para la fecha % en %', v_parametros.desde, v_gestion;
          END IF;
         --  1) Crear una tabla temporal con los datos que se utilizaran 
         CREATE TEMPORARY TABLE temp_balancef (
         						subrayar VARCHAR(3) DEFAULT 'si'::character varying,
                                font_size VARCHAR DEFAULT 10,
                                posicion VARCHAR DEFAULT 'left'::character varying,
                                signo VARCHAR(15) DEFAULT '+'::character varying,
                                id_cuenta integer,
                                desc_cuenta varchar,
                                codigo_cuenta varchar,
                                codigo VARCHAR,
                                origen varchar,
                                orden INTEGER,
                                nombre_variable VARCHAR,
                                montopos INTEGER,
                                monto numeric,
                                id_resultado_det_plantilla INTEGER,
                                id_cuenta_raiz integer) ON COMMIT DROP;
            
         
         raise notice ' ----------->   id plantilla %', v_parametros.id_resultado_plantilla;
     
         -- 2) listar el detalle de la plantilla
         
         FOR v_registros in (
                             SELECT
                               *                               
                             FROM conta.tresultado_det_plantilla rdp 
                             where rdp.id_resultado_plantilla = v_parametros.id_resultado_plantilla  order by rdp.orden asc) LOOP 
                  
                  raise notice '--->  %', v_registros.origen;
                  --   2.0)  ...
                  --   2.1) si el origen es balance
                  IF  v_registros.origen = 'balance' THEN
                        --	2.1.1)  recuperamos los datos de la cuenta 
                        select
                          cue.id_cuenta,
                          cue.nro_cuenta,
                          cue.nombre_cuenta
                        into
                          v_reg_cuenta
                        from conta.tcuenta cue
                        where cue.id_gestion = v_id_gestion and cue.nro_cuenta = v_registros.codigo_cuenta ;
                        
                 
                		--   2.1.2)  calculamos el balance de la cuenta para las fechas indicadas
                        v_monto = conta.f_mayor_cuenta(v_reg_cuenta.id_cuenta, v_parametros.desde, v_parametros.hasta, v_parametros.id_deptos);
                 		
                        --	 2.1.3)  insertamos en la tabla temporal
                        insert into temp_balancef (
                                subrayar,
                                font_size,
                                posicion,
                                signo,
                                id_cuenta,
                                desc_cuenta,
                                codigo_cuenta,
                                codigo,
                                origen,
                                orden,
                                nombre_variable,
                                montopos,
                                monto,
                                id_resultado_det_plantilla,
                                id_cuenta_raiz)
                            values (
                                v_registros.subrayar,
                                v_registros.font_size,
                                v_registros.posicion,
                                v_registros.signo,
                                v_reg_cuenta.id_cuenta,
                                v_reg_cuenta.nombre_cuenta,
                                v_reg_cuenta.nro_cuenta,
                                v_registros.codigo,
                                v_registros.origen,
                                v_registros.orden,
                                v_registros.nombre_variable,
                                v_registros.montopos,
                                v_monto,
                                v_registros.id_resultado_det_plantilla,
                                NULL);
                        
                  --    2.2) si el origen es detall
                  ELSIF  v_registros.origen = 'detalle' THEN
                         --   2.2.1)  recuperamos la cuenta raiz
                         select
                          cue.id_cuenta,
                          cue.nro_cuenta,
                          cue.nombre_cuenta
                        into
                          v_reg_cuenta
                        from conta.tcuenta cue
                        where cue.id_gestion = v_id_gestion and cue.nro_cuenta = v_registros.codigo_cuenta ;
                       
                        --  2.2.2) Recuperar las cuentas del nivel requerido
                        IF ( not conta.f_recuperar_cuentas_nivel(v_reg_cuenta.id_cuenta, 1, v_registros.nivel_detalle, v_registros.id_resultado_det_plantilla, v_parametros.desde, v_parametros.hasta, v_parametros.id_deptos) ) THEN     
                            raise exception 'Error al calcular balance del detalle en el nivel %', 0;
                        END IF;
                        
                        --  2.2.3)  modificamos los registors de la tabla temporal comunes
                        UPDATE temp_balancef  set
                                subrayar = v_registros.subrayar,
                                font_size = v_registros.font_size,
                                posicion = v_registros.posicion,
                                signo = v_registros.signo,
                                codigo = v_registros.codigo,
                                origen = v_registros.origen,
                                orden = v_registros.orden,
                                montopos = v_registros.montopos,
                                id_cuenta_raiz = v_reg_cuenta.id_cuenta
                        WHERE id_resultado_det_plantilla = v_registros.id_resultado_det_plantilla;
                                   
                  --   2.3) si el origen es formula
	              ELSIF  v_registros.origen = 'formula' THEN
                   
                           IF v_registros.formula is NULL THEN
                             raise exception 'En registros de origen formula, la formula no peude ser nula o vacia';
                           END IF;
                  
                          -- 2.3.1)  calculamos el monto para la formula
                           v_monto = conta.f_evaluar_resultado_formula(v_registros.formula);
                          -- 2.3.2)  insertamos el registro en tabla temporal        
                          insert into temp_balancef (
                                subrayar,
                                font_size,
                                posicion,
                                signo,
                                codigo,
                                origen,
                                orden,
                                nombre_variable,
                                montopos,
                                monto,
                                id_resultado_det_plantilla,
                                id_cuenta_raiz)
                            values (
                                v_registros.subrayar,
                                v_registros.font_size,
                                v_registros.posicion,
                                v_registros.signo,
                                v_registros.codigo,
                                v_registros.origen,
                                v_registros.orden,
                                v_registros.nombre_variable,
                                v_registros.montopos,
                                v_monto,
                                v_registros.id_resultado_det_plantilla,
                                NULL);
                                
                   --   2.4) si el origen es titulo
	               ELSEIF  v_registros.origen = 'titulo' THEN
                       -- 2.4.1) insertamos un registros para el titulo
                       insert into temp_balancef (
                                subrayar,
                                font_size,
                                posicion,
                                signo,
                                codigo,
                                origen,
                                orden,
                                nombre_variable,
                                montopos,
                                monto,
                                id_resultado_det_plantilla,
                                id_cuenta_raiz)
                            values (
                                v_registros.subrayar,
                                v_registros.font_size,
                                v_registros.posicion,
                                v_registros.signo,
                                v_registros.codigo,
                                v_registros.origen,
                                v_registros.orden,
                                v_registros.nombre_variable,
                                v_registros.montopos,
                                0.0,
                                v_registros.id_resultado_det_plantilla,
                                NULL);
                  END IF;
          END LOOP;
         
         raise notice 'INICIA CONSULTA....';
         -- 3) retorno de resultados
         FOR v_registros in (SELECT                                   
                                    subrayar,
                                    font_size,
                                    posicion,
                                    signo,
                                    id_cuenta,
                                    desc_cuenta,
                                    codigo_cuenta,
                                    codigo,
                                    origen,
                                    orden,
                                    nombre_variable,
                                    montopos,
                                    monto,
                                    id_resultado_det_plantilla,
                                    id_cuenta_raiz
                                FROM temp_balancef 
                                    order by orden asc, codigo_cuenta asc) LOOP
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