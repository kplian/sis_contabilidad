CREATE OR REPLACE FUNCTION conta.f_tri_trelacion_contable ()
RETURNS trigger AS
$BODY$

DECLARE
		 
	g_registros record;
	v_consulta varchar;
	v_res_cone  varchar;
	v_cadena_cnx varchar;
	v_cadena_con varchar;
	resp boolean;
	
	v_tabla varchar;
	v_usr varchar;
	v_id_uo integer;
		
BEGIN

	--Verificar si la relacion contable corresponde a: tconcepto_ingas, tcuenta_bancaria
	select tbl.tabla
	into v_tabla
	from conta.trelacion_contable rc
	inner join conta.ttipo_relacion_contable trc on trc.id_tipo_relacion_contable = rc.id_tipo_relacion_contable
	inner join conta.ttabla_relacion_contable tbl on tbl.id_tabla_relacion_contable = trc.id_tabla_relacion_contable
	where rc.id_relacion_contable = COALESCE(NEW.id_relacion_contable,OLD.id_relacion_contable)
	and tbl.tabla in ('tconcepto_ingas','tcuenta_bancaria');
	
	if v_tabla is not null then
	
		--Obtener unidad organizacional
		select id_uo into v_id_uo
		from param.tcentro_costo
		where id_centro_costo = NEW.id_centro_costo;
	
		IF TG_OP = 'INSERT' THEN
		
			--Obtener usuario
			select cuenta into v_usr
			from segu.tusuario
			where id_usuario = NEW.id_usuario_reg;
		
			if v_tabla = 'tconcepto_ingas' then
				
				v_consulta = 'INSERT INTO presto.tpr_concepto_cta (
							  id_concepto_cta,
							  id_concepto_ingas,
							  id_cuenta,
							  id_unidad_organizacional,
							  id_auxiliar,
							  id_presupuesto,
							  usuario_reg,
							  fecha_reg
							) VALUES ('||
							  NEW.id_relacion_contable||','||
							  NEW.id_tabla||','||
							  NEW.id_cuenta||','||
							  v_id_uo||','||
							  NEW.id_auxiliar||','||
							  NEW.id_centro_costo||','''||
							  v_usr||''','''||
							  now()||'')';
				
			elsif v_tabla = 'tcuenta_bancaria' then
			
				v_consulta = 'INSERT INTO tesoro.tts_cuenta_bancaria_cuenta(
							  id_cuenta_bancaria_cuenta,
							  id_cuenta_bancaria,
							  id_cuenta,
							  id_auxiliar,
							  id_parametro,
							  id_usuario_reg,
							  fecha_reg
							) 
							VALUES (
							  NEW.id_relacion_contable||','||
							  NEW.id_tabla||','||
							  NEW.id_cuenta||','||
							  NEW.id_auxiliar||','||
							  :id_parametro,
							  :id_usuario_reg,
							  :fecha_reg
							);';
							
			end if;
		
		   
			v_consulta = 'SELECT migracion.f_trans_tts_cuenta_bancaria_tts_cuenta_bancaria (
			  				'''||TG_OP::varchar||''','||COALESCE(NEW.id_cuenta_bancaria::varchar,'NULL')||','||COALESCE(NEW.id_auxiliar::varchar,'NULL')||','||COALESCE(NEW.id_cuenta::varchar,'NULL')||','||COALESCE(NEW.id_institucion::varchar,'NULL')||','||COALESCE(NEW.id_parametro::varchar,'NULL')||','||COALESCE(NEW.estado_cuenta::varchar,'NULL')||','||COALESCE(NEW.nro_cheque::varchar,'NULL')||','||COALESCE(''''||NEW.nro_cuenta_banco::varchar||'''','NULL')||') as res';				  
		
		ELSIF TG_OP ='UPDATE' THEN
		
			--Obtener usuario
			select cuenta into v_usr
			from segu.tusuario
			where id_usuario = NEW.id_usuario_mod;
		
			if v_tabla = 'tconcepto_ingas' then
			
			elsif v_tabla = 'tcuenta_bancaria' then
			
			end if;
		
		ELSE 
		
			if v_tabla = 'tconcepto_ingas' then
			
			elsif v_tabla = 'tcuenta_bancaria' then
			
			end if;
		
		
		
			v_consulta = ' SELECT migracion.f_trans_tts_cuenta_bancaria_tts_cuenta_bancaria (
			             '''||TG_OP::varchar||''','||OLD.id_cuenta_bancaria||',NULL,NULL,NULL,NULL,NULL,NULL,NULL) as res';
			       
		END IF;
			   --------------------------------------
			   -- PARA PROBAR SI FUNCIONA LA FUNCION DE TRANFROMACION, HABILITAR EXECUTE
			   ------------------------------------------
			     --EXECUTE (v_consulta);
			   
			   
			    INSERT INTO 
			                      migracion.tmig_migracion
			                    (
			                      verificado,
			                      consulta,
			                      operacion
			                    ) 
			                    VALUES (
			                      'no',
			                       v_consulta,
			                       TG_OP::varchar
			                       
			                    );
	
	end if; 
		
	
		
		  RETURN NULL;
		
		END;
		$BODY$LANGUAGE 'plpgsql'
		VOLATILE
		CALLED ON NULL INPUT
		SECURITY INVOKER;