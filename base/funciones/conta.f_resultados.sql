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
v_registros_plantilla	record;
 

BEGIN
     
     v_nombre_funcion = 'conta.f_resultados';
     v_parametros = pxp.f_get_record(p_tabla);
    
    
    /*********************************   
     #TRANSACCION:    'CONTA_RESUTADO_SEL'
     #DESCRIPCION:    Listado para el reporte del resultados
     #AUTOR:          rensi arteaga copari  kplian
     #FECHA:          08-07-2015
    ***********************************/

	IF(p_transaccion = 'CONTA_RESUTADO_SEL')then
         
    
    
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
          
          select 
            rp.codigo,
            rp.nombre
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
                                espacio_previo int4
                                ) ON COMMIT DROP;
         
         
         -- 2)  busca si tiene plantillas dependientes segun prioridad   
         FOR v_registros in ( select 
                                  rd.*,
                                  rp.codigo  as plantilla 
                              from conta.tresultado_dep rd 
                              inner join conta.tresultado_plantilla rp on rp.id_resultado_plantilla = rd.id_resultado_plantilla_hijo
                              where rd.id_resultado_plantilla = v_parametros.id_resultado_plantilla 
                              order by prioridad asc ) LOOP
                
                --procesa la plantilla dependientes ... 
                IF  not conta.f_resultado_procesar_plantilla(
                                                            v_registros.plantilla,
                                                            v_registros.id_resultado_plantilla_hijo, 
                                                            v_parametros.desde, 
                                                            v_parametros.hasta, 
                                                            v_parametros.id_deptos,
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
                                                      v_parametros.id_deptos,
                                                      v_id_gestion,
                                                      false) THEN
             raise exception 'Error al procesar la plantilla pirncipal';                                                  
          END IF;
           
         
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
                                    id_cuenta_raiz,
                                    visible,
                                    incluir_cierre,
                                    incluir_apertura,
                                    negrita,
                                    cursiva,
                                    espacio_previo
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