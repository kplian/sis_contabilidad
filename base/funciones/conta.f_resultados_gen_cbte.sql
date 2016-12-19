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
v_id_proceso_macro		integer;
v_codigo_proceso_macro 				varchar;
v_codigo_tipo_proceso 				varchar;
v_num_tramite 						varchar;
v_id_proceso_wf						integer;
v_id_estado_wf						integer;
v_codigo_estado   					varchar;
v_desde								date;
v_hasta								date;
v_id_int_comprobante_ori			integer;
v_registros_cbte					record;
v_monto_gasto						numeric;
v_monto_recurso						numeric;
v_id_int_comprobante_fk				integer[];
v_id_tipo_relacion_comprobante		integer;

 

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
    
          if pxp.f_existe_parametro(p_tabla,'desde')  then
          	v_desde = v_parametros.desde;
            v_hasta = v_parametros.hasta;
          end if;
          
          
          --  0) recuperamos la gestion
          
          if pxp.f_existe_parametro(p_tabla,'id_int_comprobante')  then
          	
                v_id_int_comprobante_ori = v_parametros.id_int_comprobante;
                v_id_int_comprobante_fk[1] = v_parametros.id_int_comprobante;
                select 
                  p.id_gestion,
                  c.id_proceso_wf,
                  c.id_estado_wf,
                  c.nro_tramite,
                  c.id_depto
                into
                  v_registros_cbte
                from conta.tint_comprobante c
                inner join param.tperiodo p on p.id_periodo = c.id_periodo
                where c.id_int_comprobante = v_id_int_comprobante_ori;
                
                v_id_gestion = v_registros_cbte.id_gestion;
               
            
          else
          --  0) recuperamos la gestion segun fecha inicial
              v_gestion =  EXTRACT(YEAR FROM  v_desde::Date)::varchar;
              
              select 
                ges.id_gestion
              into
                v_id_gestion
              from param.tgestion ges 
              where ges.gestion::varchar  = v_gestion and ges.estado_reg = 'activo';
              
              IF v_id_gestion is NULL THEN  
                    raise exception 'No se encontro gestion para la fecha % en %', v_desde, v_gestion;
              END IF;
          
          
          end if;
         
    
          
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
          
          
          
          -- si es un comprobante origen recuepramos el tipo de relacion del cbte
          IF v_id_int_comprobante_ori is not null THEN 
                v_id_int_comprobante_fk[1] = v_id_int_comprobante_ori;
                v_id_tipo_relacion_comprobante = v_registros_plantilla.id_tipo_relacion_comprobante;
                
                IF v_registros_plantilla.relacion_unica = 'si' THEN
                 
                     --comprobamos que el cbte origan no tenga una relacion de este tipo
                     
                     IF exists(select 
                                   1
                               from conta.tint_comprobante c 
                               where  c.id_tipo_relacion_comprobante = v_id_tipo_relacion_comprobante 
                                      and c.estado_reg  in ('borrador','validado')
                                      and v_id_int_comprobante_ori = ANY (c.id_int_comprobante_fks))  THEN
                                 
                            raise exception 'este comprobante  tiene una relación existente, revise las dependencias' ;    
                     END IF;
                END IF;
          END IF;
          
          
          
          
          
         --  1) Crear una tabla temporal con los datos que se utilizaran 
         CREATE TEMPORARY TABLE temp_balancef (
         							id SERIAL, 
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
                                    orden_cbte numeric,
                                    nombre_columna  varchar,
                                    prioridad numeric,
                                    monto_partida numeric
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
                                                            v_desde, 
                                                            v_hasta, 
                                                            v_str_id_deptos,
                                                            v_id_gestion,
                                                            v_id_int_comprobante_ori,
                                                            true) THEN
                                                            
                     raise exception 'error al procesa la plantilla %', v_registros.codigo;                                       
               END IF;
         
         END LOOP;
         
         -- 3) Procesar plantilla principal
         IF not conta.f_resultado_procesar_plantilla(v_registros_plantilla.codigo,
                                                      v_parametros.id_resultado_plantilla, 
                                                      v_desde, 
                                                      v_hasta, 
                                                      v_str_id_deptos,
                                                      v_id_gestion,
                                                      v_id_int_comprobante_ori,
                                                      false) THEN
             raise exception 'Error al procesar la plantilla principal';                                                  
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
         
         
         
         -----------------------------------------
         --   INICIA TRAMITE
         -----------------------------------------
         
          --  inicia tramite nuevo 
          v_codigo_proceso_macro = pxp.f_get_variable_global('conta_codigo_macro_wf_cbte');
          --obtener id del proceso macro
          select 
           pm.id_proceso_macro
          into
           v_id_proceso_macro
          from wf.tproceso_macro pm
          where pm.codigo = v_codigo_proceso_macro;
                     
          If v_id_proceso_macro is NULL THEN
            raise exception 'El proceso macro  de codigo % no esta configurado en el sistema WF',v_codigo_proceso_macro;  
          END IF;
                     
         --   obtener el codigo del tipo_proceso
          select   tp.codigo 
           into v_codigo_tipo_proceso
          from  wf.ttipo_proceso tp 
          where   tp.id_proceso_macro = v_id_proceso_macro
                and tp.estado_reg = 'activo' and tp.inicio = 'si';
                            
          IF v_codigo_tipo_proceso is NULL THEN
           raise exception 'No existe un proceso inicial para el proceso macro indicado % (Revise la configuración)',v_codigo_proceso_macro;
          END IF;
          
          
          ---------------------------------------------------------------------------
          -- si no viene de un comprobante continuar con el tramite original 
          --------------------------------------------------------------------------
          
          IF v_id_int_comprobante_ori is null THEN          
                          -- inciar el tramite en el sistema de WF
                          SELECT 
                             ps_num_tramite ,
                             ps_id_proceso_wf ,
                             ps_id_estado_wf ,
                             ps_codigo_estado 
                            into
                             v_num_tramite,
                             v_id_proceso_wf,
                             v_id_estado_wf,
                             v_codigo_estado   
                                          
                          FROM wf.f_inicia_tramite(
                             p_id_usuario,
                             v_parametros._id_usuario_ai,
                             v_parametros._nombre_usuario_ai,
                             v_rec.po_id_gestion, 
                             v_codigo_tipo_proceso, 
                             null,--v_parametros.id_funcionario,
                             v_parametros.id_depto,
                             'Registrado a trave de plantilla',
                             '' );        
           
          ELSE
          
               SELECT
                                     ps_id_proceso_wf,
                                     ps_id_estado_wf,
                                     ps_codigo_estado,
                                     ps_nro_tramite
                           into
                                     v_id_proceso_wf,
                                     v_id_estado_wf,
                                     v_codigo_estado,
                                     v_num_tramite
                       FROM wf.f_registra_proceso_disparado_wf(
                                    p_id_usuario,
                                    v_parametros._id_usuario_ai,
                                    v_parametros._nombre_usuario_ai,
                                    v_registros_cbte.id_estado_wf, 
                                    NULL,  --id_funcionario wf
                                    v_registros_cbte.id_depto,
                                    'Cbte generado desde plantilla',
                                    'CBTE','');
          END IF;      
                 
          IF  v_codigo_estado != 'borrador' THEN
            raise exception 'el estado inicial para cbtes debe ser borrador, revise la configuración del WF';
          END IF;
          
         
                    
         ------------------------------------
         --  registro de comprobante
         ------------------------------------
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
              fecha_reg,
              cbte_cierre,
              cbte_apertura,
              cbte_aitb,
              nro_tramite,
              id_proceso_wf,
              id_estado_wf,
              id_int_comprobante_fks,
              id_tipo_relacion_comprobante
          	) 
            values(
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
              now(),
              v_registros_plantilla.cbte_cierre,
              v_registros_plantilla.cbte_apertura,
              v_registros_plantilla.cbte_aitb,
              v_num_tramite,
              v_id_proceso_wf,
              v_id_estado_wf,
              v_id_int_comprobante_fk,
              v_id_tipo_relacion_comprobante
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
              
         
          IF v_registros.monto != 0 THEN
                    -- recupera partida si existe
                    SELECT
                     par.id_partida
                    into 
                     v_id_partida
                    FROM pre.tpartida par 
                    WHERE    par.id_gestion = v_id_gestion_cbte 
                         and par.codigo = v_registros.codigo_partida;
                    
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
                     IF v_registros.monto > 0 THEN
                        if v_registros.destino = 'debe' then
                           v_monto_debe = v_registros.monto;
                           v_monto_haber = 0;
                           v_monto_gasto = v_registros.monto_partida;
                           v_monto_recurso = 0;
                        else
                           v_monto_debe = 0;
                           v_monto_haber = v_registros.monto;
                           v_monto_gasto = 0;
                           v_monto_recurso = v_registros.monto_partida;
                        end if;
                     ELSE
                         if v_registros.destino = 'haber' then
                           v_monto_debe = v_registros.monto*(-1);
                           v_monto_haber = 0;
                           v_monto_gasto = v_registros.monto_partida*(-1);
                           v_monto_recurso = 0;
                        else
                           v_monto_debe = 0;
                           v_monto_haber = v_registros.monto*(-1);
                           v_monto_gasto = 0;
                           v_monto_recurso = v_registros.monto_partida*(-1);
                        end if;
                     
                     END IF;
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
                      v_monto_gasto,
                      v_monto_recurso,
                      v_monto_debe,
                      v_monto_haber,
                      v_monto_gasto,
                      v_monto_recurso,
                      p_id_usuario,
                      now()
                  );
            END IF;
         END LOOP;
         
         
      ----------------------------------------------------------------
      -- definir tipos de cambio 
      ----------------------------------------------------------------
    
      IF not  conta.f_act_trans_cbte_generados(v_id_int_comprobante) THEN
      	raise exception 'error al generar comprobante';
      END IF;
    
           
  

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