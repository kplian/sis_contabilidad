CREATE OR REPLACE FUNCTION conta.f_reporte_anexo_cinco (
  p_id_planilla integer,
  p_id_gestion integer
)
RETURNS void AS
$body$
DECLARE
  v_nombre_funcion   		text;
  v_resp					varchar;
  v_record					record;
  v_periodo					record;
  v_columnas				integer;
  v_titulo					varchar;
  v_subtitulo				varchar;
  v_ultimo_periodo			integer;
  v_resultado				numeric;
BEGIN
   v_nombre_funcion = 'conta.f_reporte_anexo_cinco';

   select r.glosa,
   		  r.nombre
          into
          v_titulo,
          v_subtitulo
   from conta.tplantilla_reporte r
   where r.id_plantilla_reporte = p_id_planilla;

   select max(p.id_periodo)
   into
   v_ultimo_periodo
   from param.tperiodo p
   where p.id_gestion = p_id_gestion - 1;

   for v_record in (select 	dp.id_plantilla_det_reporte,
                                dp.order_fila,
                                dp.columna,
                                dp.origen,
                                dp.concepto,
                                dp.partida,
                                dp.nombre_columna,
                                dp.codigo_columna,
                                dp.operacion,
                                dp.formula,
                                dp.formulario,
                                dp.codigo_formulario,
                                dp.saldo_anterior,
                                dp.apertura_cb,
                                dp.cierre_cb,
                                dp.tipo_periodo
                       from conta.tplantilla_det_reporte dp
                       where dp.id_plantilla_reporte = p_id_planilla
                       order by order_fila)loop

	  if (v_record.operacion = 'periodo') then

      if exists(select 1
           			 from temp_reporte t
                     where t.id_plantilla_reporte = p_id_planilla)then

					 select max(t.orden) + 1
                     into
                     v_columnas
           			 from temp_reporte t
                     where t.codigo != '' and t.id_plantilla_reporte = p_id_planilla;
            else
                    v_columnas = 0;
            end if;
           for v_periodo in (select  	pe.id_periodo,
                                      pe.periodo
                              from param.tperiodo pe
                              where pe.id_gestion = p_id_gestion
                              order by  periodo)loop



                      insert into temp_reporte( id_plantilla_reporte,
                                                codigo,
                                                columna,
                                                titulo_columna,
                                                gestion,
                                                periodo,
                                                importe,
                                                orden,
                                                sudtitulo,
                                                titulo,
                                                glosa
                                                )values (
                                                p_id_planilla,
                                                v_record.codigo_columna,
                                                v_record.columna,
                                                v_record.nombre_columna,
                                                2018,
                                                v_periodo.periodo,
                                                0,
                                                v_columnas,
                                                v_record.columna,
                                                v_titulo,
                                                v_subtitulo);
   end loop;
    elsif v_record.operacion = 'impuestos' then
      if exists(select 1
                from temp_reporte t
                 where t.id_plantilla_reporte = p_id_planilla)then
             select max(t.orden) + 1
             into
             v_columnas
             from temp_reporte t
             where t.codigo != '' and t.id_plantilla_reporte = p_id_planilla;
      else
              v_columnas = 0;
      end if;

    	for v_periodo in (select   1::integer as periodo,
                                      de.importe
                              from conta.tdeclaraciones_juridicas de
                              inner join param.tperiodo p on p.id_periodo = de.id_periodo
                              where de.id_periodo = v_ultimo_periodo and de.codigo = '619'
                              and p.id_gestion = p_id_gestion - 1
                              and de.tipo = 'impuesto_transacciones'
                              union
                              select  p.periodo + 1 as periodo,
                                      de.importe
                              from conta.tdeclaraciones_juridicas de
                              inner join param.tperiodo p on p.id_periodo = de.id_periodo
                              where p.periodo >= 1  and p.periodo <= 3 and de.codigo = '619'
                              and de.tipo = 'impuesto_transacciones'and p.id_gestion = p_id_gestion
                              union
                              select  p.periodo,
                                      de.importe
                              from conta.tdeclaraciones_juridicas de
                              inner join param.tperiodo p on p.id_periodo = de.id_periodo
                              where  p.periodo >= 5  and p.periodo <= 12  and de.codigo = '664'
                              and de.tipo = 'impuesto_transacciones' and p.id_gestion = p_id_gestion
                              order by periodo)loop

          insert into temp_reporte( id_plantilla_reporte,
                                    codigo,
                                    columna,
                                    titulo_columna,
                                    gestion,
                                    periodo,
                                    importe,
                                    orden,
                                    sudtitulo,
                                    titulo,
                                    glosa
                                    )values (
                                    p_id_planilla,
                                    v_record.codigo_columna,
                                    v_record.columna,
                                    v_record.nombre_columna,
                                    2018,
                                    v_periodo.periodo,
                                    v_periodo.importe,
                                    v_columnas,
                                    v_record.columna,
                                    v_titulo,
          							v_subtitulo);

       end loop;

     elsif(v_record.operacion = 'resultado')then
     if exists(select 1
                from temp_reporte t
                 where t.id_plantilla_reporte = p_id_planilla)then
             select max(t.orden) + 1
             into
             v_columnas
             from temp_reporte t
             where t.codigo != '' and t.id_plantilla_reporte = p_id_planilla;
      else
              v_columnas = 0;
      end if;
     for v_periodo in (select p.periodo,
       (select	case when(sum(COALESCE(transa.importe_debe_mb,0)) - sum(COALESCE(transa.importe_haber_mb,0)))<0
        then
        (sum(COALESCE(transa.importe_debe_mb,0))::numeric - sum(COALESCE(transa.importe_haber_mb,0))::numeric)*(-1)
       else
        0
      end as importe
          from conta.tint_transaccion transa
          inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
          inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
          where icbte.estado_reg = 'validado'
                and  transa.id_cuenta in (1915)
                and extract(MONTH from icbte.fecha::date)  < p.periodo + 1
                and per.id_gestion = 2 ) as  importe
                  from conta.tint_transaccion t
        inner join conta.tint_comprobante i on i.id_int_comprobante = t.id_int_comprobante
        inner join param.tperiodo p on p.id_periodo = i.id_periodo
        where i.estado_reg = 'validado'and
        t.id_cuenta in (1915) and
        p.id_gestion = 2
        group by  p.periodo
        order by periodo )loop

          insert into temp_reporte( id_plantilla_reporte,
                                    codigo,
                                    columna,
                                    titulo_columna,
                                    gestion,
                                    periodo,
                                    importe,
                                    orden,
                                    sudtitulo,
                                    titulo,
                                    glosa
                                    )values (
                                    p_id_planilla,
                                    v_record.codigo_columna,
                                    v_record.columna,
                                    v_record.nombre_columna,
                                    2018,
                                    v_periodo.periodo,
                                    v_periodo.importe,
                                    v_columnas,
                                    v_record.columna,
                                    v_titulo,
          							v_subtitulo);

       end loop;
        elsif(v_record.operacion = 'formula')then

       v_resultado = 0;
        if exists(select 1
                       from temp_reporte t
                       where t.id_plantilla_reporte = p_id_planilla)then

                       select max(t.orden) + 1
                       into
                       v_columnas
                       from temp_reporte t
                       where t.codigo != '' and t.id_plantilla_reporte = p_id_planilla;
              else
                      v_columnas = 0;
              end if;

      for v_periodo in (select  pe.id_periodo,
      							pe.periodo,
                                pe.periodo
                              from param.tperiodo pe
                              where pe.id_gestion = p_id_gestion
                              order by  periodo) loop

      		select po_monto
             into v_resultado
             from conta.f_resultado_formula_reporte(v_record.formula,
             										p_id_planilla,
                                                    null,
                                                    v_periodo.periodo);
            insert into temp_reporte(	id_plantilla_reporte,
                                        codigo,
                                        columna,
                                        titulo_columna,
                                        gestion,
                                        periodo,
                                        importe,
                                        orden,
                                        sudtitulo,
                                        titulo,
                                        glosa
                                        )values (
                                        p_id_planilla,
                                        v_record.codigo_columna,
                                        v_record.columna,
                                        v_record.nombre_columna,
                                        2018,
                                        v_periodo.periodo,
                                        v_resultado,
                                        v_columnas,
                                        v_record.formula,
                                        v_titulo,
          								v_subtitulo
                                        );

      end loop;
	end if;
end loop;


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