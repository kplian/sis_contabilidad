--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_resultados_gen_cbte (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS SETOF boolean AS
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
v_registros_plantilla	record;
v_str_id_deptos 		varchar;
v_id_moneda_base		integer;
v_id_subsistema_conta	integer;
v_rec 					record;
v_id_int_comprobante	integer;
v_id_gestion_cbte		integer;
v_id_partida			integer;
v_id_centro_costo_depto	integer;
v_id_cuenta				integer;
v_monto_debe			numeric;
v_monto_haber			numeric;
 

BEGIN
     
     v_nombre_funcion = 'conta.f_ressultados_gen_cbte';
     v_parametros = pxp.f_get_record(p_tabla);
    
    
    /*********************************   
     #TRANSACCION:    'CONTA_GENCBTERES_IME'
     #DESCRIPCION:    genera comprobante a partir de la plantilla de resultados
     #AUTOR:          rensi arteaga copari  kplian
     #FECHA:          27-07-2015
    ***********************************/

	IF(p_transaccion = 'CONTA_GENCBTERES_IME')then
         
    
    
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
          
          
         --  1) recuperamos la gestion para el comprobante   
         
           v_gestion =  EXTRACT(YEAR FROM  v_parametros.fecha::Date)::varchar;
            
          select 
            ges.id_gestion
          into
            v_id_gestion_cbte
          from param.tgestion ges 
          where ges.gestion::varchar  = v_gestion and ges.estado_reg = 'activo';
          
          IF v_id_gestion is NULL THEN  
          		raise exception 'No se encontro gestion para la fecha % en %', v_parametros.fecha, v_gestion;
          END IF;
          
          
          -- recupera  datos de la plantilla
          select 
            *
          into
           v_registros_plantilla
          from conta.tresultado_plantilla rp
          where rp.id_resultado_plantilla = v_parametros.id_resultado_plantilla;
          
          
         --  1) Crear una tabla temporal con los datos que se utilizaran 
         CREATE TEMPORARY TABLE temp_balancef (
                                    plantilla VARCHAR,
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
                                    id_cuenta_raiz integer,
                                    visible varchar,
                                    incluir_cierre varchar,
                                    incluir_apertura varchar,
                                    negrita varchar,
                                    cursiva varchar,
                                    espacio_previo int4,
                                    incluir_aitb varchar,
                                    relacion_contable varchar,
                                    codigo_partida varchar,
                                    id_auxiliar int4,
                                    destino  varchar,
                                    orden_cbte numeric
                                    ) ON COMMIT DROP;
             
         
         v_str_id_deptos = v_parametros.id_depto::varchar;
         
         -- 2)  busca si tiene plantillas dependientes segun prioridad   
         FOR v_registros in ( select 
                                  rd.*,
                                  rp.codigo  as plantilla 
                              from conta.tresultado_dep rd 
                              inner join conta.tresultado_plantilla rp on rp.id_resultado_plantilla = rd.id_resultado_plantilla_hijo
                              where rd.id_resultado_plantilla = v_parametros.id_resultado_plantilla 
                              order by prioridad asc ) LOOP
                
                -- procesa la plantilla dependientes ... 
                IF  not conta.f_resultado_procesar_plantilla(
                                                            v_registros.plantilla,
                                                            v_registros.id_resultado_plantilla_hijo, 
                                                            v_parametros.desde, 
                                                            v_parametros.hasta, 
                                                            v_str_id_deptos,
                                                            v_id_gestion,
                                                            true) THEN
                                                            
                     raise exception 'error al procesa la plantilla %', v_registros.codigo;                                       
               END IF;
         
         END LOOP;
         
         -- 3) Procesar plantilla principal
         IF not conta.f_resultado_procesar_plantilla(v_registros_plantilla.codigo,
                                                      v_parametros.id_resultado_plantilla, 
                                                      v_parametros.desde, 
                                                      v_parametros.hasta, 
                                                      v_str_id_deptos,
                                                      v_id_gestion,
                                                      false) THEN
             raise exception 'Error al procesar la plantilla pirncipal';                                                  
         END IF;
           
         
         raise notice 'INICIA CONSULTA....';
         -- 3) Insertar cabecera del comprobante
         
         select 
            id_subsistema
         into 
            v_id_subsistema_conta
         from segu.tsubsistema
         where codigo = 'CONTA';
         
         --Obtiene el periodo a partir de la fecha
         v_rec = param.f_get_periodo_gestion(v_parametros.fecha);
         
         --recupera moneda base .... 
         v_id_moneda_base = param.f_get_moneda_base();
         
         insert into conta.tint_comprobante(
			id_clase_comprobante,		
			id_subsistema,
			id_depto,
			id_moneda,
			id_periodo,
			tipo_cambio,			
			estado_reg,
			glosa1,
			fecha,
			id_usuario_reg,
			fecha_reg
          	) values(
			v_registros_plantilla.id_clase_comprobante,			
			v_id_subsistema_conta,
			v_parametros.id_depto,
			v_id_moneda_base,
			v_rec.po_id_periodo,
			1, --tipo de cambio para moenda base
			'borrador',
			v_registros_plantilla.glosa,
			v_parametros.fecha,
			p_id_usuario,
			now()
			
							
			)RETURNING id_int_comprobante into v_id_int_comprobante;
         
         --recuepra el centor de costo para el departamento
         
          SELECT 
            ps_id_centro_costo 
           into 
             v_id_centro_costo_depto 
         FROM conta.f_get_config_relacion_contable('CCDEPCON', -- relacion contable que almacena los centros de costo por departamento
                                                   v_id_gestion_cbte,  
                                                   v_parametros.id_depto,--p_id_depto_conta 
                                                   NULL);  --id_dento_costo
         -- 4) listar trasaccion con destino comprobante 
            
         
         FOR v_registros in (
                                SELECT                                   
                                    *
                                FROM temp_balancef 
                                where destino != 'reporte' and visible = 'si'
                                    order by orden_cbte asc, codigo_cuenta asc
                                    ) LOOP
              
         
          IF v_registros.monto > 0 THEN
                    -- recupera partida si existe
                    SELECT
                     par.id_partida
                    into 
                     v_id_partida
                    FROM pre.tpartida par 
                    WHERE par.id_gestion = v_id_gestion_cbte and par.codigo = v_registros.codigo_partida;
                    
                     -- TODO recupera relacion contable
                    
                    
                    -- si la gestion del comprobante y las de los datos es distinta, 
                    --convertir las cuentas la gestion del comprobante
                    IF v_id_gestion_cbte != v_id_gestion THEN
                       select 
                        ci.id_cuenta_dos
                       into
                        v_id_cuenta
                       from conta.tcuenta_ids ci
                       where ci.id_cuenta_uno = v_registros.id_cuenta;
                    ELSE
                      v_id_cuenta = v_registros.id_cuenta;
                    END IF;
                    
                    -- define los monto
                    
                    if v_registros.destino = 'debe' then
                       v_monto_debe = v_registros.monto;
                       v_monto_haber = 0;
                    else
                       v_monto_debe = 0;
                       v_monto_haber = v_registros.monto;
                    end if;
                  -----------------------------
                  --REGISTRO DE LA TRANSACCIÓN
                  -----------------------------
                  insert into conta.tint_transaccion(
                      id_partida,
                      id_centro_costo,
                      estado_reg,
                      id_cuenta,
                      glosa,
                      id_int_comprobante,
                      id_auxiliar,
                      importe_debe,
                      importe_haber,
                      importe_gasto,
                      importe_recurso,
                      importe_debe_mb,
                      importe_haber_mb,
                      importe_gasto_mb,
                      importe_recurso_mb,
                      id_usuario_reg,
                      fecha_reg
                  ) values(
                      v_id_partida,
                      v_id_centro_costo_depto,
                      'activo',
                      v_id_cuenta,
                      v_registros.nombre_variable,  --glosa
                      v_id_int_comprobante,
                      v_registros.id_auxiliar,
                      v_monto_debe,
                      v_monto_haber,
                      v_monto_debe,
                      v_monto_haber,
                      v_monto_debe,
                      v_monto_haber,
                      v_monto_debe,
                      v_monto_haber,
                      p_id_usuario,
                      now()
                  );
            END IF;
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