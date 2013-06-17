CREATE OR REPLACE FUNCTION conta.f_obtener_columnas (
  p_codigo varchar
)
RETURNS varchar [] AS
$body$
DECLARE
  v_posicion		integer;
  v_res				varchar[];
  v_columna			varchar;
  v_columna_nueva 	varchar[];
  v_columnas		record;
BEGIN
 	select campo_subsistema, campo_depto, campo_acreedor,
     campo_descripcion, campo_fk_comprobante, campo_moneda,
      campo_fecha into v_columnas
    from conta.tplantilla_comprobante
    where codigo=p_codigo;
    
  	if(position('$tabla.' in v_columnas.campo_subsistema)!=0) then
      v_posicion=position('$tabla.' in v_columnas.campo_subsistema);
      v_columna=substring(v_columnas.campo_subsistema,v_posicion+7);
      v_res = array_append(v_res,v_columna);
	end if;
    if(position('$tabla.' in v_columnas.campo_depto)!=0) then
      v_posicion=position('$tabla.' in v_columnas.campo_depto);
      v_columna=substring(v_columnas.campo_depto,v_posicion+7);
	  v_columna_nueva = array_append(v_columna_nueva,v_columna);
      if(v_res @> v_columna_nueva)!='t' then
          v_res = array_append(v_res,v_columna);
      end if;
	end if;
	if(position('$tabla.' in v_columnas.campo_acreedor)!=0) then
      v_posicion=position('$tabla.' in v_columnas.campo_acreedor);
      v_columna=substring(v_columnas.campo_acreedor,v_posicion+7);     
	  v_columna_nueva = array_append(v_columna_nueva,v_columna);
      if(v_res @> v_columna_nueva)!='t' then
          v_res = array_append(v_res,v_columna);
      end if;
    end if;
	if(position('$tabla.' in v_columnas.campo_descripcion)!=0) then  
      v_posicion=position('$tabla.' in v_columnas.campo_descripcion);
      v_columna=substring(v_columnas.campo_descripcion,v_posicion+7);
      v_columna_nueva = array_append(v_columna_nueva,v_columna);
      if(v_res @> v_columna_nueva)!='t' then
          v_res = array_append(v_res,v_columna);
      end if;
	end if;
	if(position('$tabla.' in v_columnas.campo_fk_comprobante)!=0) then
      v_posicion=position('$tabla.' in v_columnas.campo_fk_comprobante);
      v_columna=substring(v_columnas.campo_fk_comprobante,v_posicion+7);
	  v_columna_nueva = array_append(v_columna_nueva,v_columna);
      if(v_res @> v_columna_nueva)!='t' then
          v_res = array_append(v_res,v_columna);
      end if;
	end if;
	if(position('$tabla.' in v_columnas.campo_moneda)!=0) then
      v_posicion=position('$tabla.' in v_columnas.campo_moneda);
      v_columna=substring(v_columnas.campo_moneda,v_posicion+7);
      v_columna_nueva = array_append(v_columna_nueva,v_columna);
      if(v_res @> v_columna_nueva)!='t' then
          v_res = array_append(v_res,v_columna);
      end if;
    end if; 
	if(position('$tabla.' in v_columnas.campo_fecha)!=0) then
      v_posicion=position('$tabla.' in v_columnas.campo_fecha);
      v_columna=substring(v_columnas.campo_fecha,v_posicion+7);
      v_columna_nueva = array_append(v_columna_nueva,v_columna);
      if(v_res @> v_columna_nueva)!='t' then
          v_res = array_append(v_res,v_columna);
      end if;
    end if;	
    return v_res;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;