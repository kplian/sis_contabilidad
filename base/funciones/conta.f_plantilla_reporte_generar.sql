CREATE OR REPLACE FUNCTION conta.f_plantilla_reporte_generar (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS SETOF record AS
$body$
DECLARE
  	v_consulta 			varchar;
    v_parametros  		record;
	v_nombre_funcion   	text;
    v_resp				varchar;
    v_gestion			integer;
    v_record			record;
    v_registros 		record;
BEGIN
 v_nombre_funcion = 'conta.f_plantilla_reporte_generar';
  v_parametros = pxp.f_get_record(p_tabla);


    /*********************************
     #TRANSACCION:    'CONTA_ANRES_SEL'
     #DESCRIPCION:    Generar reportes
     #AUTOR:          MMV
     #FECHA:          08-07-2015
    ***********************************/

	IF(p_transaccion = 'CONTA_ANRES_SEL')then

 	 --  1) Crear una tabla temporal con los datos que se utilizaran
       CREATE TEMPORARY TABLE temp_reporte(	  id serial,
                                              id_plantilla_reporte integer,
                                              codigo varchar,
                                              orden numeric,
                                              columna varchar,
                                              titulo_columna varchar,
                                              sudtitulo varchar,
                                              origen  varchar,
                                              gestion integer,
                                              periodo integer,
                                              importe numeric,
                                              titulo  varchar,
                                              glosa	  varchar
                                              ) ON COMMIT DROP;

        select gestion
        into v_gestion
        from param.tgestion
        where id_gestion = v_parametros.id_gestion;


	select  pr.id_plantilla_reporte,
    		pr.codigo,
            pr.nombre,
            pr.modalidad,
            pr.nombre_func
            into
            v_record
    from conta.tplantilla_reporte pr
    where pr.id_plantilla_reporte = v_parametros.id_plantilla_reporte;


  if v_record.nombre_func != '' then
      EXECUTE ( 'select conta.' ||v_record.nombre_func ||
                    		'('||v_parametros.id_plantilla_reporte::integer||',
                    		'||v_parametros.id_gestion::integer||')');
  else
  		if  not conta.f_resultado_planilla_reporte( v_parametros.id_plantilla_reporte,
                                                 	v_parametros.id_gestion,
                                                 	v_record.modalidad) THEN
           raise exception 'error al procesa la plantilla %', v_record.nombre;
     	end if;
  end if;

    FOR v_registros in (select 	id,
                                codigo,
                                orden,
                                columna,
                                titulo_columna,
                                sudtitulo,
                                gestion,
                                periodo,
                                importe,
                                titulo,
                                glosa
                                from temp_reporte
                                where codigo != ''
                                order by orden, periodo)LOOP
    		RETURN NEXT v_registros;
    END LOOP;

 END IF;


EXCEPTION
	WHEN OTHERS THEN
        v_resp='';
        v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
        v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
        v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
        RAISE EXCEPTION '%',v_resp;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100 ROWS 1000;