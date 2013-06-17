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
        if(position('$tabla.' in v_plantilla.campo_subsistema)=1)then
        	v_columna_requerida=substring(v_plantilla.campo_subsistema,8);
            FOR r IN SELECT (each(hstore(v_tabla))).* 
            LOOP
            	if r.key=v_columna_requerida then
                	v_valor=r.value;
                end if; 
            END LOOP; 
            v_this.columna_subsistema=v_valor;
            
          else
          	v_posicion=position('$tabla.' in v_plantilla.campo_subsistema);
			v_columna_requerida=substring(v_plantilla.campo_subsistema,v_posicion+7);
            v_consulta=substring(v_plantilla.campo_subsistema,1,v_posicion-1);            
            v_consulta:=replace(v_consulta,'$tabla',v_plantilla.tabla_origen);
            FOR r IN SELECT (each(hstore(v_tabla))).* 
            LOOP
            	if r.key=v_columna_requerida then
                	v_valor=r.value;
                end if; 
            END LOOP;
            v_consulta:=concat(v_consulta,v_valor);
            execute v_consulta into v_this.columna_subsistema;
        end if;
	end if;    
    
    --guardo depto
    if (v_plantilla.campo_depto!='' AND v_plantilla.campo_depto is not null) then
      if(position('$tabla.' in v_plantilla.campo_depto)=1)then
        v_columna_requerida=substring(v_plantilla.campo_depto,8);
        FOR r IN SELECT (each(hstore(v_tabla))).* 
        LOOP
            if r.key=v_columna_requerida then
                v_valor=r.value;
            end if; 
        END LOOP; 
        v_this.columna_depto=v_valor;
        
      elsif(position('$this.' in v_plantilla.campo_depto)=1)then
      	v_columna_requerida=substring(v_plantilla.campo_depto,7);
        FOR r IN SELECT (each(hstore(v_this))).* 
            LOOP
            	if r.key=v_columna_requerida then
                	v_valor=r.value;
                end if; 
            END LOOP;
        	v_this.columna_depto=v_valor;
      
      elsif(position('$tabla.' in v_plantilla.campo_depto)!=0)then
        v_posicion=position('$tabla.' in v_plantilla.campo_depto);
        v_columna_requerida=substring(v_plantilla.campo_depto,v_posicion+7);
        v_consulta=substring(v_plantilla.campo_depto,1,v_posicion-1);            
        v_consulta:=replace(v_consulta,'$tabla',v_plantilla.tabla_origen);
        FOR r IN SELECT (each(hstore(v_tabla))).* 
        LOOP
            if r.key=v_columna_requerida then
                v_valor=r.value;
            end if; 
        END LOOP;
        v_consulta:=concat(v_consulta,v_valor);
          execute v_consulta into v_this.columna_depto;
      elsif(v_posicion=position('$this.' in v_plantilla.campo_depto)!=0) then
        v_posicion=position('$this.' in v_plantilla.campo_depto);
        v_columna_requerida=substring(v_plantilla.campo_depto,v_posicion+6);
        v_consulta=substring(v_plantilla.campo_depto,1,v_posicion-1);            
        v_consulta:=replace(v_consulta,'$tabla',v_plantilla.tabla_origen);
        FOR r IN SELECT (each(hstore(v_this))).* 
        LOOP
            if r.key=v_columna_requerida then
                v_valor=r.value;
            end if; 
        END LOOP;
        v_consulta:=concat(v_consulta,v_valor);
        execute v_consulta into v_this.columna_depto;
      end if;
	end if;
    
    --guardo acreedor
    if (v_plantilla.campo_acreedor!='' AND v_plantilla.campo_acreedor is not null) then
        if(position('$tabla.' in v_plantilla.campo_acreedor)=1)then
        	v_columna_requerida=substring(v_plantilla.campo_acreedor,8);
            FOR r IN SELECT (each(hstore(v_tabla))).* 
            LOOP
            	if r.key=v_columna_requerida then
                	v_valor=r.value;
                end if; 
            END LOOP; 
            v_this.columna_acreedor=v_valor;
            
        elsif(position('$this.' in v_plantilla.campo_acreedor)=1)then
      	v_columna_requerida=substring(v_plantilla.campo_acreedor,7);
        FOR r IN SELECT (each(hstore(v_this))).* 
            LOOP
            	if r.key=v_columna_requerida then
                	v_valor=r.value;
                end if; 
            END LOOP;
        	v_this.columna_acreedor=v_valor;   
            
        elsif(position('$tabla.' in v_plantilla.campo_acreedor)!=0)then
          	v_posicion=position('$tabla.' in v_plantilla.campo_acreedor);
			v_columna_requerida=substring(v_plantilla.campo_acreedor,v_posicion+7);
            v_consulta=substring(v_plantilla.campo_acreedor,1,v_posicion-1);            
            v_consulta:=replace(v_consulta,'$tabla',v_plantilla.tabla_origen);
            FOR r IN SELECT (each(hstore(v_tabla))).* 
            LOOP
            	if r.key=v_columna_requerida then
                	v_valor=r.value;
                end if; 
            END LOOP;
            v_consulta:=concat(v_consulta,v_valor);
            execute v_consulta into v_this.columna_acreedor;
        
        elsif(v_posicion=position('$this.' in v_plantilla.campo_acreedor)!=0) then
            v_posicion=position('$this.' in v_plantilla.campo_acreedor);
            v_columna_requerida=substring(v_plantilla.campo_acreedor,v_posicion+6);
            v_consulta=substring(v_plantilla.campo_acreedor,1,v_posicion-1);            
            v_consulta:=replace(v_consulta,'$tabla',v_plantilla.tabla_origen);
            FOR r IN SELECT (each(hstore(v_this))).* 
            LOOP
                if r.key=v_columna_requerida then
                    v_valor=r.value;
                end if; 
            END LOOP;
            v_consulta:=concat(v_consulta,v_valor);
            execute v_consulta into v_this.columna_acreedor;
        end if;                
	end if;
    
    --guardo descripcion--
    if (v_plantilla.campo_descripcion!='' AND v_plantilla.campo_descripcion is not null) then
      if(position('$tabla.' in v_plantilla.campo_descripcion)=1)then
        	v_columna_requerida=substring(v_plantilla.campo_descripcion,8);
            FOR r IN SELECT (each(hstore(v_tabla))).* 
            LOOP
            	if r.key=v_columna_requerida then
                	v_valor=r.value;
                end if; 
            END LOOP; 
            v_this.columna_descripcion=v_valor;
            
      elsif(position('$this.' in v_plantilla.campo_descripcion)=1)then
      	v_columna_requerida=substring(v_plantilla.campo_descripcion,7);
        FOR r IN SELECT (each(hstore(v_this))).* 
            LOOP
            	if r.key=v_columna_requerida then
                	v_valor=r.value;
                end if; 
            END LOOP;
        	v_this.columna_descripcion=v_valor;   
            
      elsif(position('$tabla.' in v_plantilla.campo_descripcion)!=0)then
        v_posicion=position('$tabla.' in v_plantilla.campo_descripcion);
        v_columna_requerida=substring(v_plantilla.campo_descripcion,v_posicion+7);
        v_consulta=substring(v_plantilla.campo_descripcion,1,v_posicion-1);            
        v_consulta:=replace(v_consulta,'$tabla',v_plantilla.tabla_origen);
        FOR r IN SELECT (each(hstore(v_tabla))).* 
        LOOP
            if r.key=v_columna_requerida then
                v_valor=r.value;
            end if; 
        END LOOP;
        v_consulta:=concat(v_consulta,v_valor);
        execute v_consulta into v_this.columna_descripcion;
        
      elsif(v_posicion=position('$this.' in v_plantilla.campo_descripcion)!=0) then
        v_posicion=position('$this.' in v_plantilla.campo_descripcion);
        v_columna_requerida=substring(v_plantilla.campo_descripcion,v_posicion+6);
        v_consulta=substring(v_plantilla.campo_descripcion,1,v_posicion-1);            
        v_consulta:=replace(v_consulta,'$tabla',v_plantilla.tabla_origen);
        FOR r IN SELECT (each(hstore(v_this))).* 
        LOOP
            if r.key=v_columna_requerida then
                v_valor=r.value;
            end if; 
        END LOOP;
        v_consulta:=concat(v_consulta,v_valor);
        execute v_consulta into v_this.columna_descripcion;
      end if;   
	end if;    

    --guardo moneda--
    if (v_plantilla.campo_moneda!='' AND v_plantilla.campo_moneda is not null) then
      if(position('$tabla.' in v_plantilla.campo_moneda)=1)then
        	v_columna_requerida=substring(v_plantilla.campo_moneda,8);
            FOR r IN SELECT (each(hstore(v_tabla))).* 
            LOOP
            	if r.key=v_columna_requerida then
                	v_valor=r.value;
                end if; 
            END LOOP; 
            v_this.columna_moneda=v_valor;
            
      elsif(position('$this.' in v_plantilla.campo_moneda)=1)then
      	v_columna_requerida=substring(v_plantilla.campo_moneda,7);
        FOR r IN SELECT (each(hstore(v_this))).* 
            LOOP
            	if r.key=v_columna_requerida then
                	v_valor=r.value;
                end if; 
            END LOOP;
        	v_this.columna_moneda=v_valor; 
                  
      elsif(position('$tabla.' in v_plantilla.campo_moneda)!=0)then
        v_posicion=position('$tabla.' in v_plantilla.campo_moneda);
        v_columna_requerida=substring(v_plantilla.campo_moneda,v_posicion+7);
        v_consulta=substring(v_plantilla.campo_moneda,1,v_posicion-1);            
        v_consulta:=replace(v_consulta,'$tabla',v_plantilla.tabla_origen);
        FOR r IN SELECT (each(hstore(v_tabla))).* 
        LOOP
            if r.key=v_columna_requerida then
                v_valor=r.value;
            end if; 
        END LOOP;
        v_consulta:=concat(v_consulta,v_valor);
        execute v_consulta into v_this.columna_moneda;
        
      elsif(v_posicion=position('$this.' in v_plantilla.campo_moneda)!=0) then
        v_posicion=position('$this.' in v_plantilla.campo_moneda);
        v_columna_requerida=substring(v_plantilla.campo_moneda,v_posicion+6);
        v_consulta=substring(v_plantilla.campo_moneda,1,v_posicion-1);            
        v_consulta:=replace(v_consulta,'$tabla',v_plantilla.tabla_origen);
        FOR r IN SELECT (each(hstore(v_this))).* 
        LOOP
            if r.key=v_columna_requerida then
                v_valor=r.value;
            end if; 
        END LOOP;
        v_consulta:=concat(v_consulta,v_valor);
        execute v_consulta into v_this.columna_moneda;
      
      end if; 
	end if;    
    
    --guardo fecha
    if (v_plantilla.campo_fecha!='' AND v_plantilla.campo_fecha is not null) then
      if(position('$tabla.' in v_plantilla.campo_fecha)=1)then
        	v_columna_requerida=substring(v_plantilla.campo_fecha,8);
            FOR r IN SELECT (each(hstore(v_tabla))).* 
            LOOP
            	if r.key=v_columna_requerida then
                	v_valor=r.value;
                end if; 
            END LOOP; 
            v_this.columna_fecha=v_valor;
            
      elsif(position('$this.' in v_plantilla.campo_fecha)=1)then
      	v_columna_requerida=substring(v_plantilla.campo_fecha,7);
        FOR r IN SELECT (each(hstore(v_this))).* 
            LOOP
            	if r.key=v_columna_requerida then
                	v_valor=r.value;
                end if; 
            END LOOP;
        	v_this.columna_fecha=v_valor;      
            
      elsif(position('$tabla.' in v_plantilla.campo_fecha)!=0)then
        v_posicion=position('$tabla.' in v_plantilla.campo_fecha);
        v_columna_requerida=substring(v_plantilla.campo_fecha,v_posicion+7);
        v_consulta=substring(v_plantilla.campo_fecha,1,v_posicion-1);            
        v_consulta:=replace(v_consulta,'$tabla',v_plantilla.tabla_origen);
        FOR r IN SELECT (each(hstore(v_tabla))).* 
        LOOP
            if r.key=v_columna_requerida then
                v_valor=r.value;
            end if; 
        END LOOP;
        v_consulta:=concat(v_consulta,v_valor);
        execute v_consulta into v_this.columna_fecha;
      
      elsif(v_posicion=position('$this.' in v_plantilla.campo_fecha)!=0) then
        v_posicion=position('$this.' in v_plantilla.campo_fecha);
        v_columna_requerida=substring(v_plantilla.campo_fecha,v_posicion+6);
        v_consulta=substring(v_plantilla.campo_fecha,1,v_posicion-1);            
        v_consulta:=replace(v_consulta,'$tabla',v_plantilla.tabla_origen);
        FOR r IN SELECT (each(hstore(v_this))).* 
        LOOP
            if r.key=v_columna_requerida then
                v_valor=r.value;
            end if; 
        END LOOP;
        v_consulta:=concat(v_consulta,v_valor);
        execute v_consulta into v_this.columna_fecha;
        
      end if; 
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