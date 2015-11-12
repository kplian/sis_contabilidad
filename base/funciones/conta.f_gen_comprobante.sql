--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_gen_comprobante (
  p_id_tabla_valor integer,
  p_codigo varchar,
  p_id_usuario integer = NULL::integer,
  p_id_usuario_ai integer = NULL::integer,
  p_usuario_ai varchar = NULL::character varying,
  p_conexion varchar = NULL::character varying,
  p_sincronizar_internacional boolean = false
)
RETURNS integer AS
$body$
/*
Autor inicial GAYME RIMERA ROJAS (No sabe porner comentarios)
Fecha 28/06/2013
Descripcion: nose por que el gayme no puso comentarios


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
    v_glosa 		varchar;
  
BEGIN

    v_nombre_funcion:='conta.f_gen_comprobante';
    
    --recupero el record de la plantilla con el codigo (parametro) dado
    
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
                        'campo_fecha_costo_fin'];
    
    v_tamano:=array_upper(v_def_campos,1);
    
   
	--obtener la columnas que se consultaran  para la tabla  ( los nombre de variables con prefijo $tabla)
    
    --v_columnas=conta.f_obtener_columnas(p_codigo)::varchar;
    
    v_columnas=conta.f_obtener_columnas_detalle(hstore(v_plantilla),v_def_campos)::varchar;
	v_columnas=replace(v_columnas,'{','');
	v_columnas=replace(v_columnas,'}','');
    v_consulta = 'select '||v_columnas ||
            ' from '||v_plantilla.tabla_origen|| ' where '
            ||v_plantilla.tabla_origen||'.'||v_plantilla.id_tabla||'='||p_id_tabla_valor||'';
      
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

    v_resp:=v_this;
    
    
    
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
    
  
    
         Select  id_clase_comprobante  into   v_id_clase_comprobante 
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
    
    --  genera tabla intermedia de comrobante
    
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
      --nro_cbte,
      momento,
      momento_comprometido,
      momento_ejecutado,
      momento_pagado,
      id_plantilla_comprobante,
      glosa1,
      --glosa2,
      beneficiario,
      tipo_cambio,
      --id_funcionario_firma1,
      --id_funcionario_firma2,
      --id_funcionario_firma3,
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
      localidad
             
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
      --:nro_cbte,
      v_plantilla.momento_presupuestario, -- contable, o presupuestario
      v_plantilla.momento_comprometido,
      v_plantilla.momento_ejecutado,
      v_plantilla.momento_pagado,
      v_plantilla.id_plantilla_comprobante,
      v_this.columna_descripcion,
      --:glosa2,
      v_this.columna_acreedor,
      v_tipo_cambio,
      --:id_funcionario_firma1,
      --:id_funcionario_firma2,
      --:id_funcionario_firma3,
      v_this.columna_fecha,
      v_plantilla.funcion_comprobante_validado,
      v_plantilla.funcion_comprobante_eliminado,
      v_this.columna_id_cuenta_bancaria, 
      v_this.columna_id_cuenta_bancaria_mov, 
      v_this.columna_nro_cheque, 
      v_this.columna_nro_cuenta_bancaria_trans,
      v_this.columna_nro_tramite,
      p_id_usuario_ai,
      p_usuario_ai,
      v_temporal,
      v_this.columna_fecha_costo_ini,
      v_this.columna_fecha_costo_fin,
      v_localidad
      
    )RETURNING id_int_comprobante into v_id_int_comprobante;
    
    
    raise notice '=====> AL INSERTAR  v_id_int_comprobante= %',  v_id_int_comprobante;
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
     
         --recupera configuracion activa
         SELECT  
           po_id_config_cambiaria ,
           po_valor_tc1 ,
           po_valor_tc2 ,
           po_tc1 ,
           po_tc2 
         into
          v_registros_config
         FROM conta.f_get_tipo_cambio_segu_config(v_this.columna_moneda::integer, 
                                                  v_this.columna_fecha,
                                                  v_localidad,
                                                  'si');
               
    
        v_id_moneda_base = param.f_get_moneda_base();
        v_id_moneda_tri  = param.f_get_moneda_triangulacion();
     
     
       IF v_tipo_cambio is NULL THEN
         v_tipo_cambio = v_registros_config.po_valor_tc1;
       END IF;
       
       IF  v_registros_config.po_valor_tc1 is NULL THEN
         raise exception 'no tenemos tipo de cambio % para la fecha %',v_registros_config.po_tc1 , v_this.columna_fecha;
       END IF;
       
       
       IF  v_registros_config.po_valor_tc2 is NULL THEN
         raise exception 'no tenemos tipo de cambio % para la fecha %',v_registros_config.po_tc2 , v_this.columna_fecha;
       END IF;
       
       
       update conta.tint_comprobante cbt set
         tipo_cambio = v_tipo_cambio,
         tipo_cambio_2 = v_registros_config.po_valor_tc2,
         id_moneda_tri = v_id_moneda_tri,
         id_config_cambiaria = v_registros_config.po_id_config_cambiaria
       where cbt.id_int_comprobante = v_id_int_comprobante;
      
      
       
       
       FOR  v_registros in (
                           select 
                             * 
                           from conta.tint_transaccion it
                           where it.id_int_comprobante = v_id_int_comprobante)LOOP
      
          
       
          --  si tiene relacion con un devengado calcular tipo de cambio ponderado para la trasacción
           select 
               sum(r.monto_pago)
           into
              v_total_monto_pago
           from conta.tint_rel_devengado r 
           inner join conta.tint_transaccion it on it.id_int_transaccion = r.id_int_transaccion_dev and it.estado_reg = 'activo'
           where r.id_int_transaccion_pag = v_registros.id_int_transaccion and r.estado_reg = 'activo';
           
           
         v_total_monto_pago = 0;
         v_tipo_cambio_rel_1 = 0;
         v_tipo_cambio_rel_2 = 0;
         v_glosa_tran = '';
        
         v_sw_tipo_cambio = 'no';                          
          
            IF v_total_monto_pago > 0  THEN
            
                  v_glosa_tran = 'TC: ';
                  FOR v_registros_rel in (
                                              select 
                                                 it.tipo_cambio,
                                                  it.tipo_cambio_2,
                                                  r.monto_pago,
                                                  cb.id_int_comprobante,
                                                  cb.nro_cbte
                                             from conta.tint_rel_devengado r 
                                             inner join conta.tint_transaccion it on it.id_int_transaccion = r.id_int_transaccion_dev and it.estado_reg = 'activo'
                                             inner join conta.tint_comprobante cb on cb.id_int_comprobante = it.id_int_comprobante
                                             where r.id_int_transaccion_pag = v_registros.id_int_transaccion and r.estado_reg = 'activo' ) LOOP
                  
                  
                   
                   v_parcial = (v_registros_rel.monto_pago/v_total_monto_pago)*v_registros_rel.tipo_cambio;
                   v_tipo_cambio_rel_1 = v_tipo_cambio_rel_1 + v_parcial;
                   
                   
                   v_parcial = (v_registros_rel.monto_pago/v_total_monto_pago)*v_registros_rel.tipo_cambio_2;
                   v_tipo_cambio_rel_2 = v_tipo_cambio_rel_2 + v_parcial;	
                   
                   v_glosa =  v_glosa|| '('||v_registros_rel.nro_cbte||'  '||v_registros_config.po_tc1 ||':'||v_registros_rel.tipo_cambio::varchar;
                   v_glosa =  v_glosa||' '||v_registros_config.po_tc2 ||':'||v_registros_rel.tipo_cambio::varchar||')';
                     
                  END  LOOP;
                
                  IF v_tipo_cambio_rel_1 != v_tipo_cambio  or   v_tipo_cambio_rel_2 != v_registros_config.po_valor_tc2 THEN
                    v_sw_tipo_cambio = 'si';
                  END IF;
            ELSE
            
                  -- si no toma los valores de tipos de la cabecera
                  v_tipo_cambio_rel_1 = v_tipo_cambio;
                  v_tipo_cambio_rel_2 = v_registros_config.po_valor_tc2;
                
            
            END IF;
          -- determina tipos de cambio en las transacciones (incluidas las que tienen dependecia en devengado pago)
          
         -- raise exception '%',v_this.columna_moneda;
         
         IF v_tipo_cambio_rel_1 is null or v_tipo_cambio_rel_2 is null or v_id_moneda_tri is null or v_this.columna_moneda is null THEN
           raise exception 't1,t2,it,id .. %,%,%,%',v_tipo_cambio_rel_1, v_tipo_cambio_rel_2, v_id_moneda_tri ,v_this.columna_monedais ;
         END IF;
           
           
           update conta.tint_transaccion t set
             tipo_cambio =   v_tipo_cambio_rel_1,
             tipo_cambio_2 = v_tipo_cambio_rel_2,
             id_moneda_tri = v_id_moneda_tri,
             id_moneda =  v_this.columna_moneda::integer,
             glosa = trim(glosa ||' '||v_glosa),
             importe_debe = COALESCE(importe_debe,0),
             importe_haber = COALESCE(importe_haber,0)
          where t.id_int_transaccion = v_registros.id_int_transaccion;
          
          -- calcular  equivalencias para todas las trasacciones en moneda base y de triangulacion
          
           PERFORM  conta.f_calcular_monedas_transaccion(v_registros.id_int_transaccion);
      
      END LOOP;
      
      -- si el tipo de cambio de alguna transaccion varia con respecto a la cabacera la marcamos
      IF v_sw_tipo_cambio = 'si' THEN
         update conta.tint_comprobante cbt set
           cbt.sw_tipo_cambio = 'si'
         where cbt.id_int_comprobante = v_id_int_comprobante;
      END IF;
    
    END IF;
    
    -- migracion de comprobante endesis  DBLINK
    v_sincronizar = pxp.f_get_variable_global('sincronizar');
    
        
    --Si la sincronizacion esta habilitada
    IF(v_sincronizar = 'true')THEN
  	 	
        -- si sincroniza locamente con endesis
         IF(not p_sincronizar_internacional)THEN
           v_resp_int_endesis =  migra.f_migrar_cbte_endesis(v_id_int_comprobante, p_conexion);
        
         ELSE
         --   TODO si es necesario migrar a contabilidad internacional ....
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