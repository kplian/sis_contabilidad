CREATE OR REPLACE FUNCTION conta.f_tri_trelacion_contable (
)
RETURNS trigger AS
$body$
DECLARE
		 
	g_registros record;
	v_consulta varchar;
	v_res_cone  varchar;
	v_cadena_cnx varchar;
	v_cadena_con varchar;
	v_resp varchar;

	v_tabla varchar;
	v_id_uo integer;
	v_nro_cuenta varchar;
	v_codigo_trel varchar;

		
BEGIN

	--funcion para obtener cadena de conexion
	v_cadena_cnx =  migra.f_obtener_cadena_conexion();

	--Verificar si la relacion contable corresponde a: tconcepto_ingas, tcuenta_bancaria
	select tbl.tabla, trc.codigo_tipo_relacion
	into v_tabla, v_codigo_trel
	from conta.ttipo_relacion_contable trc
	inner join conta.ttabla_relacion_contable tbl on tbl.id_tabla_relacion_contable = trc.id_tabla_relacion_contable
	where trc.id_tipo_relacion_contable = NEW.id_tipo_relacion_contable
	and tbl.tabla in ('tconcepto_ingas','tcuenta_bancaria');
	
	if v_tabla is not null then
	
		if TG_OP IN ('INSERT','UPDATE') then

			if v_tabla = 'tconcepto_ingas' and v_codigo_trel = 'CUECOMP' then
			
				--Obtener unidad organizacional
				select id_uo into v_id_uo
				from param.tcentro_costo
				where id_centro_costo = NEW.id_centro_costo;

				v_consulta = 'select migracion.f_mig_relacion_contable__tpr_concepto_cta('''||
								TG_OP ||''',' ||
                                COALESCE(NEW.id_relacion_contable::varchar,'NULL')||','||
                                COALESCE(NEW.id_tabla::varchar,'NULL')||','||
                                COALESCE(NEW.id_cuenta::varchar,'NULL')||','||
                                COALESCE(v_id_uo::varchar,'NULL')||','||
                                COALESCE(NEW.id_auxiliar::varchar,'NULL')||','||
                                COALESCE(NEW.id_centro_costo::varchar,'NULL')||')';
				
			elsif v_tabla = 'tcuenta_bancaria' and v_codigo_trel = 'CUEBANCEGRE' then
			
				--Obtener nro cuenta bancaria
				select nro_cuenta
				into v_nro_cuenta
				from tes.tcuenta_bancaria
				where id_cuenta_bancaria = NEW.id_tabla;
				
				v_consulta = 'select migracion.f_mig_relacion_contable__tts_cuenta_bancaria('''||
								TG_OP ||''',' ||
								COALESCE(NEW.id_relacion_contable::varchar,'NULL')||','||  
								COALESCE(NEW.id_tabla::varchar,'NULL')||','||
								COALESCE(NEW.id_cuenta::varchar,'NULL')||','||
								COALESCE(NEW.id_auxiliar::varchar,'NULL')||','||
								COALESCE(NEW.id_centro_costo::varchar,'NULL')||','||
								COALESCE(NEW.id_gestion::varchar,'NULL')||','||
								COALESCE(''''||v_nro_cuenta::varchar||'''','NULL')||')';

			end if;
	
		
		else  --DELETE
		
			if v_tabla = 'tconcepto_ingas' and v_codigo_trel = 'CUECOMP' then
			
				v_consulta = 'select migracion.f_mig_relacion_contable__tpr_concepto_cta('''||
								TG_OP ||''',' ||
								OLD.id_relacion_contable||',NULL,NULL,NULL,NULL,NULL)';
			
			elsif v_tabla = 'tcuenta_bancaria' and v_codigo_trel = 'CUEBANCEGRE' then
			
				v_consulta = 'select migracion.f_mig_relacion_contable__tts_cuenta_bancaria_cuenta('''||
								TG_OP ||''',' ||
								OLD.id_relacion_contable||',NULL,NULL,NULL,NULL,NULL,NULL)';
			
			end if;
		

			       
		END IF;

		--Abre una conexion con dblink para ejecutar la consulta
        v_resp =  (SELECT dblink_connect(v_cadena_cnx));
			            
		if (v_resp!='OK') THEN
			--Error al abrir la conexión  
			raise exception 'FALLA CONEXION A LA BASE DE DATOS CON DBLINK';
		else
			PERFORM * FROM dblink(v_consulta,true) AS (resp varchar);
		    v_res_cone=(select dblink_disconnect());
		end if;

	end if; 
		
  RETURN NULL;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;