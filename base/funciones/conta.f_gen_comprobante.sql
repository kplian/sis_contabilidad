--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_gen_comprobante (
  p_id_tabla_valor integer,
  p_codigo varchar,
  p_id_usuario integer = NULL::integer
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
    v_nombre_funcion        text;
    v_plantilla				record;        
    v_resp 					varchar;
    v_consulta				varchar;
    v_posicion				integer;
    v_columnas				varchar;
    v_columna_requerida		varchar;
    r 						record;  --  esta variable no se usa
    v_valor					varchar;
    
    v_id_int_comprobante    integer;
    resp_det varchar;
    
    
    ------------
    
    v_def_campos      varchar[];
    v_campo_tempo     varchar;
    v_i integer;
    v_tamano integer;
    v_rec_periodo record;
    v_id_subsistema integer;
    v_id_clase_comprobante integer;
  
BEGIN
	
    v_nombre_funcion:='conta.f_gen_comprobante';
    
    --recupero el record de la plantilla con el codigo (parametro) dado
    
    select * into v_plantilla
	from conta.tplantilla_comprobante cbte
	where cbte.codigo=p_codigo;
    
    
    v_def_campos = ARRAY['campo_depto','campo_acreedor','campo_descripcion','campo_gestion_relacion','campo_fk_comprobante','campo_moneda','campo_fecha','otros_campos'];
    
    v_tamano:=array_upper(v_def_campos,1);
    
   
	--obtener la columnas que se consultaran  para la tabla  ( los nombre de variables con prefijo $tabla)
    
    --v_columnas=conta.f_obtener_columnas(p_codigo)::varchar;
    
    v_columnas=conta.f_obtener_columnas_detalle(hstore(v_plantilla),v_def_campos)::varchar;
	v_columnas=replace(v_columnas,'{','');
	v_columnas=replace(v_columnas,'}','');
    
    
   
    
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
    
    
    
  
    
   
    if (v_plantilla.campo_depto!='' AND v_plantilla.campo_depto is not null) then
    	
        v_this.columna_depto = conta.f_get_columna(	'maestro', 
        										v_plantilla.campo_depto::text, 
                                                hstore(v_this), 
                                                hstore(v_tabla));
	end if;
    
    --guardo acreedor
    if (v_plantilla.campo_acreedor!='' AND v_plantilla.campo_acreedor is not null) then
    	v_this.columna_acreedor = conta.f_get_columna(	'maestro', 
        										v_plantilla.campo_acreedor::text, 
                                                hstore(v_this), 
                                                hstore(v_tabla));           
	end if;
    
    --guardo descripcion--
    if (v_plantilla.campo_descripcion!='' AND v_plantilla.campo_descripcion is not null) then
    	v_this.columna_descripcion = conta.f_get_columna(	'maestro', 
        										v_plantilla.campo_descripcion::text, 
                                                hstore(v_this), 
                                                hstore(v_tabla)); 
      
	end if;    

    --guardo moneda--
    if (v_plantilla.campo_moneda!='' AND v_plantilla.campo_moneda is not null) then
    	v_this.columna_moneda = conta.f_get_columna(	'maestro', 
        										v_plantilla.campo_moneda::text, 
                                                hstore(v_this), 
                                                hstore(v_tabla))::integer; 
	end if;    
    
    --guardo fecha
    if (v_plantilla.campo_fecha!='' AND v_plantilla.campo_fecha is not null) then
    	v_this.columna_fecha = conta.f_get_columna(	'maestro', 
        										v_plantilla.campo_fecha::text, 
                                                hstore(v_this), 
                                                hstore(v_tabla));   
	end if; 
    
    
      --guardo fecha
    if (v_plantilla.campo_gestion_relacion!='' AND v_plantilla.campo_gestion_relacion is not null) then
    	
       /*raise notice '??????  %, %',v_plantilla.campo_gestion_relacion,
                                                conta.f_get_columna('maestro', 
        										v_plantilla.campo_gestion_relacion::text, 
                                                hstore(v_this), 
                                                hstore(v_tabla));*/
        
        v_this.columna_gestion = conta.f_get_columna('maestro', 
        										v_plantilla.campo_gestion_relacion::text, 
                                                hstore(v_this), 
                                                hstore(v_tabla))::integer;   
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
    
    
    
    
    --  genera tabla intermedia de comrobante
    
   INSERT INTO 
      conta.tint_comprobante
    (
      id_usuario_reg,
    
      fecha_reg,
     
      estado_reg,
     
      id_clase_comprobante,
      id_int_comprobante_fk,
      id_subsistema,
      id_depto,
      id_moneda,
      id_periodo,
      --nro_cbte,
      --momento,
      glosa1,
      --glosa2,
      beneficiario,
      --tipo_cambio,
      --id_funcionario_firma1,
      --id_funcionario_firma2,
      --id_funcionario_firma3,
      fecha,
      funcion_comprobante_validado,
      funcion_comprobante_eliminado
      
    ) 
    VALUES (
      p_id_usuario,
      now(),
     'activo',
      v_id_clase_comprobante, --TODO agregar a la interface de plantilla
      NULL,
      v_id_subsistema, --TODO agregar a la interface de plantilla,
      v_this.columna_depto::integer,
      v_this.columna_moneda::integer,
      v_rec_periodo.po_id_periodo,
      --:nro_cbte,
      --:momento,
      v_this.columna_descripcion,
      --:glosa2,
      v_this.columna_acreedor,
      --:tipo_cambio,
      --:id_funcionario_firma1,
      --:id_funcionario_firma2,
      --:id_funcionario_firma3,
      v_this.columna_fecha,
      v_plantilla.funcion_comprobante_validado,
      v_plantilla.funcion_comprobante_eliminado
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