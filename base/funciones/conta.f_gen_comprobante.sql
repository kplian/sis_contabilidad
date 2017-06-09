--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_gen_comprobante (
  p_id_tabla_valor integer,
  p_codigo varchar,
  p_id_estado_wf integer,
  p_id_usuario integer = NULL::integer,
  p_id_usuario_ai integer = NULL::integer,
  p_usuario_ai varchar = NULL::character varying,
  p_conexion varchar = NULL::character varying,
  p_sincronizar_internacional boolean = false
)
RETURNS integer AS
$body$
/*
Autor inicial GAYRRINCHA ARTEAGA COPARI (No sabe porner comentarios)
Fecha 28/06/2013
Descripcion: nose por que el gayrrincha no puso comentarios


Autor:  Rensi Arteaga Copari
Fecha 21/08/2013
Descripcion:   Esta funciona inicia la generacion de comprobantes contables,  
               apartir de una plantilla predefinida





*/


DECLARE
	v_this					conta.maestro_comprobante;
    v_tabla					record;
    v_registros_cc			record;
    v_nombre_funcion        text;
    v_plantilla				record;        
    v_resp 					varchar;
    v_consulta				varchar;
    v_posicion				integer;
    v_columnas				varchar;
    v_columna_requerida		varchar;
   -- r 						record;  --  esta variable no se usa
    v_registros_config      record;
    v_valor					varchar;
    
    v_id_int_comprobante    integer;
    resp_det varchar;
    
    
    ------------
    
    v_def_campos      		varchar[];
    v_campo_tempo     		varchar;
    v_i 					integer;
    v_tamano 				integer;
    v_rec_periodo record;
    v_id_subsistema 		integer;
    v_id_clase_comprobante 	integer;
    v_sincronizar 			varchar;
    v_resp_int_endesis 		varchar;
    v_tipo_cambio			numeric;
    v_temporal				varchar;
    v_localidad				varchar;
    
    v_id_moneda_base 		integer;
    v_id_moneda_tri 		integer;
    
    v_total_monto_pago      numeric;
    
    v_factor 				numeric;
    v_parcial 				numeric;
    v_tipo_cambio_rel_2		numeric;
    v_tipo_cambio_rel_1		numeric;
    v_glosa_tran 			varchar; 
    v_sw_tipo_cambio 		varchar;
    v_registros 			record;
    v_registros_rel 		record;
    v_glosa 					varchar;
    v_codigo_proceso_macro   	varchar;
    v_id_proceso_macro			integer;
    v_codigo_tipo_proceso		varchar;
    v_num_tramite				varchar;
   
    v_id_proceso_wf				integer;
    v_id_estado_wf				integer;
    v_codigo_estado   			varchar;
    v_clcbt_desc  				varchar;
    v_gestion_fecha				integer;
    v_gestion_aux				integer;
    v_id_tipo_relacion_comprobante	integer;
  
BEGIN

    v_nombre_funcion:='conta.f_gen_comprobante';
    
    --recupero el record de la plantilla con el codigo (parametro) dado
    
    IF p_codigo is null THEN
      raise exception 'El codigo de plantilla del cbte no puede ser nulo';
    END IF; 
    
    select * into v_plantilla
	from conta.tplantilla_comprobante cbte
	where cbte.codigo=p_codigo;
    
    if v_plantilla is null then
    	raise exception 'Revisar la configuracion para la plantilla de comprobante con codigo %', p_codigo;
    end if;
    
    --define los campos que se recuperarn de la plantilla
    v_def_campos = ARRAY['campo_depto',
    					'campo_acreedor',
                        'campo_descripcion',
                        'campo_gestion_relacion',
                        'campo_fk_comprobante',
                        'campo_moneda',
                        'campo_fecha','otros_campos',
                        'campo_id_cuenta_bancaria',
                        'campo_id_cuenta_bancaria_mov',
                        'campo_nro_cheque',
                        'campo_nro_tramite',
                        'campo_nro_cuenta_bancaria_trans',
                        'campo_tipo_cambio',
                        'campo_depto_libro',
                        'campo_fecha_costo_ini',
                        'campo_fecha_costo_fin',
                        'campo_cbte_relacionado'];
    
    v_tamano:=array_upper(v_def_campos,1);
    
   
	--obtener la columnas que se consultaran  para la tabla  ( los nombre de variables con prefijo $tabla)
    
    --v_columnas=conta.f_obtener_columnas(p_codigo)::varchar;
    
    v_columnas=conta.f_obtener_columnas_detalle(hstore(v_plantilla),v_def_campos)::varchar;
	v_columnas=replace(v_columnas,'{','');
	v_columnas=replace(v_columnas,'}','');
    v_consulta = 'select '||v_columnas ||
            ' from '||v_plantilla.tabla_origen|| ' where '
            ||v_plantilla.tabla_origen||'.'||v_plantilla.id_tabla||'='||p_id_tabla_valor||'';
            
            
            
     IF v_plantilla.id_tabla is null or v_plantilla.id_tabla = '' THEN
        raise exception 'defina un id para la tabla en la plantilla de comprobante';
     END IF; 
     
     IF v_plantilla.tabla_origen is null or v_plantilla.tabla_origen = '' THEN
        raise exception 'defina el nombre de la tabla origen de datos en la plantilla de comprobante';
     END IF; 
     
     
    -- raise exception 'llega .. % , % , % -',p_codigo, v_plantilla.tabla_origen,p_id_tabla_valor ;

 execute	'select '||v_columnas ||
            ' from '||v_plantilla.tabla_origen|| ' where '
            ||v_plantilla.tabla_origen||'.'||v_plantilla.id_tabla||'='||p_id_tabla_valor||'' into v_tabla;
            
            
      
   
    ----------------------------------------------------------
    --  OBTIENE LOS VALORES,  THIS   (tipo de dato agrupador)     
    ----------------------------------------------------------
    
	--  guardo subsistema  
    
    
    if ( v_plantilla.campo_subsistema != ''  AND  v_plantilla.campo_subsistema is not null ) then
    	
        v_this.columna_subsistema = conta.f_get_columna('maestro', 
                                                                  v_plantilla.campo_subsistema::text, 
                                                                  hstore(v_this), 
                                                                  hstore(v_tabla));
	end if;    
    
    --guardo depto
    
   
    if (v_plantilla.campo_depto != '' AND v_plantilla.campo_depto is not null) then
    	
        v_this.columna_depto = conta.f_get_columna(	'maestro', 
        										v_plantilla.campo_depto::text, 
                                                hstore(v_this), 
                                                hstore(v_tabla));
	end if;
    
    if (v_plantilla.campo_depto_libro != '' AND v_plantilla.campo_depto_libro is not null) then
    	
        v_this.columna_libro_banco = conta.f_get_columna(	'maestro', 
        										v_plantilla.campo_depto_libro::text, 
                                                hstore(v_this), 
                                                hstore(v_tabla));
	end if;
    
    
    
    
    --guardo acreedor
    if (v_plantilla.campo_acreedor != '' AND v_plantilla.campo_acreedor is not null) then
    	v_this.columna_acreedor = conta.f_get_columna(	'maestro', 
        										v_plantilla.campo_acreedor::text, 
                                                hstore(v_this), 
                                                hstore(v_tabla));           
	end if;
    
    --guardo descripcion--
    if (v_plantilla.campo_descripcion != '' AND v_plantilla.campo_descripcion is not null) then
    	v_this.columna_descripcion = conta.f_get_columna(	'maestro', 
        										v_plantilla.campo_descripcion::text, 
                                                hstore(v_this), 
                                                hstore(v_tabla)); 
      
	end if;    

    --guardo moneda--
    if (v_plantilla.campo_moneda != '' AND v_plantilla.campo_moneda is not null) then
    	v_this.columna_moneda = conta.f_get_columna(	'maestro', 
        										v_plantilla.campo_moneda::text, 
                                                hstore(v_this), 
                                                hstore(v_tabla))::integer; 
	end if;    
    
    --guardo fecha
    if (v_plantilla.campo_fecha != '' AND v_plantilla.campo_fecha is not null) then
    	v_this.columna_fecha = conta.f_get_columna(	'maestro', 
        										v_plantilla.campo_fecha::text, 
                                                hstore(v_this), 
                                                hstore(v_tabla));   
	end if; 
    
    --guardo campo_fecha_costo_ini
    if (v_plantilla.campo_fecha_costo_ini != '' AND v_plantilla.campo_fecha_costo_ini is not null) then
    	v_this.columna_fecha_costo_ini = conta.f_get_columna(	'maestro', 
        										v_plantilla.campo_fecha_costo_ini::text, 
                                                hstore(v_this), 
                                                hstore(v_tabla));   
	end if;
    
    --guardo campo_fecha_costo_fin
    if (v_plantilla.campo_fecha_costo_fin != '' AND v_plantilla.campo_fecha_costo_fin is not null) then
    	v_this.columna_fecha_costo_fin = conta.f_get_columna(	'maestro', 
        										v_plantilla.campo_fecha_costo_fin::text, 
                                                hstore(v_this), 
                                                hstore(v_tabla));   
	end if;
    
 
    
    
    
    
    
    
      --guardo gestion_relacion
    if (v_plantilla.campo_gestion_relacion != '' AND v_plantilla.campo_gestion_relacion is not null) then
    	
       
        
        v_this.columna_gestion = conta.f_get_columna('maestro', 
        										v_plantilla.campo_gestion_relacion::text, 
                                                hstore(v_this), 
                                                hstore(v_tabla))::integer;   
	end if;   
    
    --RCM: guardar id_cuenta_bancaria
    if ( v_plantilla.campo_id_cuenta_bancaria != ''  AND  v_plantilla.campo_id_cuenta_bancaria is not null ) then
        v_this.columna_id_cuenta_bancaria = conta.f_get_columna('maestro', 
                                                                  v_plantilla.campo_id_cuenta_bancaria::text, 
                                                                  hstore(v_this), 
                                                                  hstore(v_tabla));
	end if;    

    --RCM: guardar id_cuenta_bancaria_mov
    if ( v_plantilla.campo_id_cuenta_bancaria_mov != ''  AND  v_plantilla.campo_id_cuenta_bancaria_mov is not null ) then
        v_this.columna_id_cuenta_bancaria_mov = conta.f_get_columna('maestro', 
                                                                  v_plantilla.campo_id_cuenta_bancaria_mov::text, 
                                                                  hstore(v_this), 
                                                                  hstore(v_tabla));
	end if;
    
     --JRR: guardar campo_nro_cheque
    if ( v_plantilla.campo_nro_cheque != ''  AND  v_plantilla.campo_nro_cheque is not null ) then
        v_this.columna_nro_cheque = conta.f_get_columna('maestro', 
                                                                  v_plantilla.campo_nro_cheque::text, 
                                                                  hstore(v_this), 
                                                                  hstore(v_tabla));
	end if;
    
     --RCM: guardar campo_nro_tramite
    if ( v_plantilla.campo_nro_tramite != ''  AND  v_plantilla.campo_nro_tramite is not null ) then
        v_this.columna_nro_tramite = conta.f_get_columna('maestro', 
                                                                  v_plantilla.campo_nro_tramite::text, 
                                                                  hstore(v_this), 
                                                                  hstore(v_tabla));
        
	end if;
    
     --RCM: guardar campo_nro_cuenta_bancaria_trans
    if ( v_plantilla.campo_nro_cuenta_bancaria_trans != ''  AND  v_plantilla.campo_nro_cuenta_bancaria_trans is not null ) then
        v_this.columna_nro_cuenta_bancaria_trans = conta.f_get_columna('maestro', 
                                                                  v_plantilla.campo_nro_cuenta_bancaria_trans::text, 
                                                                  hstore(v_this), 
                                                                  hstore(v_tabla));
	end if;
    
    
    --RAC: guardar campo_tipo_cambio
    if ( v_plantilla.campo_tipo_cambio != ''  AND  v_plantilla.campo_tipo_cambio is not null ) then
        v_this.columna_tipo_cambio = conta.f_get_columna('maestro', 
                                                                  v_plantilla.campo_tipo_cambio::text, 
                                                                  hstore(v_this), 
                                                                  hstore(v_tabla))::numeric;
	end if;
    
    
    --RAC: guardar id_cuenta_bancaria_mov
    if ( v_plantilla.campo_cbte_relacionado != ''  AND  v_plantilla.campo_cbte_relacionado is not null ) then
        v_this.columna_cbte_relacionado = conta.f_get_columna('maestro', 
                                                                  v_plantilla.campo_cbte_relacionado::text, 
                                                                  hstore(v_this), 
                                                                  hstore(v_tabla))::Varchar;
	end if;
    
    

    v_resp:=v_this;
    
    -- RAC 23/23/2016 
    --forzamos que la fecha se quede en los limites de la gestion    
    v_gestion_fecha =  date_part('year', v_this.columna_fecha);
    
    select 
      g.gestion
     into
      v_gestion_aux
    from param.tgestion g
    where g.id_gestion = v_this.columna_gestion;
    
    
    if v_gestion_fecha < v_gestion_aux then
       -- forzamos  1ro de enero
       v_this.columna_fecha = (v_gestion_aux||'-01-01')::date;   
    elseif v_gestion_fecha > v_gestion_aux then
      -- forzamos 31 de diciembre
      v_this.columna_fecha = (v_gestion_aux||'-12-31')::date;
    end if;
    
    
    
    --obtener el periodo a partir de la fecha
    
      v_rec_periodo = param.f_get_periodo_gestion(v_this.columna_fecha);
    
    
    --  obtener id_subsistema
    
         Select  id_subsistema  into   v_id_subsistema 
         from  segu.tsubsistema sub 
         where sub.estado_reg = 'activo' 
            and sub.codigo =  v_this.columna_subsistema;
            
          IF v_id_subsistema is null THEN
          
               raise exception 'No existe un subsistema con el codigo %',v_this.columna_subsistema;   
          
          END IF;  
    
    --  obtener id clase comprobante
    
  
    
         Select  
           cl.id_clase_comprobante ,
           cl.descripcion 
         into   
           v_id_clase_comprobante,
           v_clcbt_desc
         from  conta.tclase_comprobante cl 
         where cl.estado_reg = 'activo' 
            and cl.codigo =  v_plantilla.clase_comprobante::varchar;
            
          IF v_id_clase_comprobante is null THEN
          
               raise exception 'No existe un comprobante de la clase codigo : %',v_plantilla.clase_comprobante;   
          
          END IF;
    
    
    
    
    --calcular el tipo de cambio segun fecha y moneda del comprobante
    IF v_this.columna_tipo_cambio is NULL THEN
        v_tipo_cambio =   param.f_get_tipo_cambio( v_this.columna_moneda::integer, v_this.columna_fecha::date, 'O');
    ELSE
        v_tipo_cambio = v_this.columna_tipo_cambio;
    END IF;
    
    --deterinar si es temporal
    v_temporal = 'no';
    v_localidad = 'nacional';
    
    IF p_sincronizar_internacional THEN
      v_temporal = 'si';
      v_localidad = 'internacional';
    END IF;
    
    
    ----------------------
    --  GESTION DEL WF
    --   v_this.columna_nro_tramite 
    ---------------------
  
    -- si el id_proceso_Wf es nulo  iniciamos tramite
    IF p_id_estado_wf is null THEN
    
    
                    IF  v_this.columna_nro_tramite is not NULL and  v_this.columna_nro_tramite != '' THEN
                       raise exception 'Si viene de untra mite necesita especifica el id_proceso_wf en la función  generación del cbte';
                    END IF;
    
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
                       p_id_usuario_ai,
                       p_usuario_ai,
                       v_rec_periodo.po_id_gestion, 
                       v_codigo_tipo_proceso, 
                       null,--v_parametros.id_funcionario,
                       v_this.columna_depto::integer,
                       'Registro de Cbte Automático',
                       '' );        
               
               
                    IF  v_codigo_estado != 'borrador' THEN
                      raise exception 'el estado inicial para cbtes debe ser borrador, revise la configuración del WF';
                    END IF;
      
         
    
    ELSE
        -- si no disparamos proceso de wf
         
            -----------------------------------
            -- dispara el comprobante
            ----------------------------------
          
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
                          p_id_usuario_ai,
                          p_usuario_ai,
                          p_id_estado_wf, 
                          NULL,  --id_funcionario wf
                          v_this.columna_depto::integer,
                          'Registro de Cbte Automático',
                          'CBTE','');
                          
                         
    
    END IF;
    
    ------------------------
    --  INSERTA CBTE
    ------------------------
    
    IF  v_id_proceso_wf is null THEN
      raise exception 'Todo comprobante tiene que tener un proceso wf';
    END IF;
    
    
    --recupera el tipo de relacion si es que existe
    IF v_plantilla.codigo_tipo_relacion is not null and  v_plantilla.codigo_tipo_relacion != ''   THEN
       
       select 
          c.id_tipo_relacion_comprobante
       into
          v_id_tipo_relacion_comprobante         
       from conta.ttipo_relacion_comprobante c
       where upper(c.codigo) = upper(v_plantilla.codigo_tipo_relacion); 
       
       IF v_id_tipo_relacion_comprobante is null THEN
         raise exception 'Revise sus plantilla el codigo de relación cbte % no existe', upper(v_plantilla.codigo_tipo_relacion) ;
       END IF;
       
    END IF;
    
    
    
    
   INSERT INTO 
      conta.tint_comprobante
    (
      id_usuario_reg,
      fecha_reg,
      estado_reg,
      id_clase_comprobante,
      id_subsistema,
      id_depto,
      id_depto_libro,
      id_moneda,
      id_periodo,
      momento,
      momento_comprometido,
      momento_ejecutado,
      momento_pagado,
      id_plantilla_comprobante,
      glosa1,
      beneficiario,
      tipo_cambio,
      fecha,
      funcion_comprobante_validado,
      funcion_comprobante_eliminado,
      id_cuenta_bancaria, 
      id_cuenta_bancaria_mov, 
      nro_cheque, 
      nro_cuenta_bancaria_trans,
      nro_tramite,
      id_usuario_ai,
      usuario_ai,
      temporal,
      fecha_costo_ini,
      fecha_costo_fin,
      localidad,
      sw_editable,
      id_proceso_wf,
      id_estado_wf,
      id_int_comprobante_fks,
      id_tipo_relacion_comprobante
             
    ) 
    VALUES (
      p_id_usuario,
      now(),
     'borrador',
      v_id_clase_comprobante, --TODO agregar a la interface de plantilla
      v_id_subsistema, --TODO agregar a la interface de plantilla,
      v_this.columna_depto::integer,
      v_this.columna_libro_banco::integer,
      v_this.columna_moneda::integer,
      v_rec_periodo.po_id_periodo,
      v_plantilla.momento_presupuestario, -- contable, o presupuestario
      v_plantilla.momento_comprometido,
      v_plantilla.momento_ejecutado,
      v_plantilla.momento_pagado,
      v_plantilla.id_plantilla_comprobante,
      v_this.columna_descripcion,
      v_this.columna_acreedor,
      v_tipo_cambio,
      v_this.columna_fecha,
      v_plantilla.funcion_comprobante_validado,
      v_plantilla.funcion_comprobante_eliminado,
      v_this.columna_id_cuenta_bancaria, 
      v_this.columna_id_cuenta_bancaria_mov, 
      v_this.columna_nro_cheque, 
      v_this.columna_nro_cuenta_bancaria_trans,
      v_num_tramite, --v_this.columna_nro_tramite,  ya no se considera el nro de tramite de generador
      p_id_usuario_ai,
      p_usuario_ai,
      v_temporal,
      v_this.columna_fecha_costo_ini,
      v_this.columna_fecha_costo_fin,
      v_localidad,
      'no',
      v_id_proceso_wf,
      v_id_estado_wf,
      (string_to_array(v_this.columna_cbte_relacionado,','))::integer[],
      v_id_tipo_relacion_comprobante
      
    )RETURNING id_int_comprobante into v_id_int_comprobante;
    
    
                     
    update wf.tproceso_wf p set
      descripcion = descripcion||' ('||v_clcbt_desc||' id:'||v_id_int_comprobante::varchar||')'
    where p.id_proceso_wf = v_id_proceso_wf;
    
     
    
    -- genera transacciones del comprobante
    
    resp_det =  conta.f_gen_transaccion(hstore(v_this), 
                            hstore(v_tabla),
                            hstore(v_plantilla),
                            p_id_tabla_valor,
                            v_id_int_comprobante,
                            p_id_usuario
                           );
    
    
    
    
    -- procesar las trasaaciones (con diversos propositos, ejm validar  cuentas bancarias)
    IF not conta.f_int_trans_procesar(v_id_int_comprobante) THEN
      raise exception 'Error al procesar transacciones';
    END IF;
    
    ----------------------------------------------------------------
    -- definir tipos de cambio para comprobantes no temporales
    ----------------------------------------------------------------
     IF   v_temporal = 'no' THEN
         IF not  conta.f_act_trans_cbte_generados(v_id_int_comprobante) THEN
           raise exception 'error al generar comprobante';
         END IF;
     END IF;
     
     
    ----------------------------------------------------------------------
    --   Si la gestion de la fecha no correponde con la gestion del pago
    --   se tiene que actualizar las cuentas, centros de costos y partidas
    -----------------------------------------------------------------------
    
   
     IF v_this.columna_gestion !=  v_rec_periodo.po_id_gestion THEN
         
         IF not  conta.f_act_gestion_transaccion(
                          v_id_int_comprobante, 
                          v_rec_periodo.po_id_gestion, 
                          v_this.columna_gestion::integer) THEN
                          
                 raise exception 'error al actulizar gestion';         
          END IF;
        
      
     END IF;
    
    ------------------------------------------------------------
    -- migracion de comprobante a endesis o regionales  DBLINK
    ------------------------------------------------------------
    
    v_sincronizar = pxp.f_get_variable_global('sincronizar');
    
    -- ver el problema de conexion en estaciones internacionales para tener roollback
     
    --Si la sincronizacion esta habilitada
    IF (v_sincronizar = 'true') THEN  	 	
         -- si sincroniza localmente con endesis
         IF(p_sincronizar_internacional)THEN
           v_resp_int_endesis =  migra.f_migrar_cbte_a_regionales(v_id_int_comprobante, p_id_tabla_valor);
         END IF;
    
    END IF;
   
     
   
    
    return v_id_int_comprobante;
    
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