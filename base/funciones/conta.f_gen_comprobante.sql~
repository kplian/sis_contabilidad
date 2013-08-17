CREATE OR REPLACE FUNCTION conta.f_gen_comprobante (
  p_id_tabla integer,
  p_codigo varchar
)
RETURNS varchar AS
$body$
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
    r 						record;
    v_valor					varchar;
BEGIN
	v_nombre_funcion:='conta.f_gen_comprobante';
    
    --recupero el record de la plantilla con el codigo (parametro) dado
    
    select * into v_plantilla
	from conta.tplantilla_comprobante cbte
	where cbte.codigo=p_codigo;

	v_columnas=conta.f_obtener_columnas(p_codigo)::varchar;
	v_columnas=replace(v_columnas,'{','');
	v_columnas=replace(v_columnas,'}','');
    
    execute	'select '||v_columnas ||
            ' from '||v_plantilla.tabla_origen|| ' where '
            ||v_plantilla.tabla_origen||'.'||v_plantilla.id_tabla||'='||p_id_tabla||'' into v_tabla;
    
	--guardo subsistema
    if (v_plantilla.campo_subsistema!='' AND v_plantilla.campo_subsistema is not null) then
    	v_this.campo_subsistema = conta.f_get_columna('maestro', 
           											v_plantilla.campo_subsistema::text, 
                                                    hstore(v_this), 
                                                    hstore(v_tabla));
	end if;    
    
    --guardo depto
    if (v_plantilla.campo_depto!='' AND v_plantilla.campo_depto is not null) then
    	v_this.campo_depto = conta.f_get_columna(	'maestro', 
        										v_plantilla.campo_depto::text, 
                                                hstore(v_this), 
                                                hstore(v_tabla));
	end if;
    
    --guardo acreedor
    if (v_plantilla.campo_acreedor!='' AND v_plantilla.campo_acreedor is not null) then
    	v_this.campo_acreedor = conta.f_get_columna(	'maestro', 
        										v_plantilla.campo_acreedor::text, 
                                                hstore(v_this), 
                                                hstore(v_tabla));           
	end if;
    
    --guardo descripcion--
    if (v_plantilla.campo_descripcion!='' AND v_plantilla.campo_descripcion is not null) then
    	v_this.campo_descripcion = conta.f_get_columna(	'maestro', 
        										v_plantilla.campo_descripcion::text, 
                                                hstore(v_this), 
                                                hstore(v_tabla)); 
      
	end if;    

    --guardo moneda--
    if (v_plantilla.campo_moneda!='' AND v_plantilla.campo_moneda is not null) then
    	v_this.campo_moneda = conta.f_get_columna(	'maestro', 
        										v_plantilla.campo_moneda::text, 
                                                hstore(v_this), 
                                                hstore(v_tabla)); 
	end if;    
    
    --guardo fecha
    if (v_plantilla.campo_fecha!='' AND v_plantilla.campo_fecha is not null) then
    	v_this.campo_fecha = conta.f_get_columna(	'maestro', 
        										v_plantilla.campo_fecha::text, 
                                                hstore(v_this), 
                                                hstore(v_tabla));   
	end if;    

	v_resp:=v_this;
    
    return v_resp;
    
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