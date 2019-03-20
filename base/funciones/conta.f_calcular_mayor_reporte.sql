CREATE OR REPLACE FUNCTION conta.f_calcular_mayor_reporte (
  p_id_plantilla_det_reporte integer,
  p_modalidad varchar,
  p_nro_cuenta varchar,
  p_partidas varchar,
  p_id_gestion integer,
  p_id_planilla integer,
  p_codigo_columna varchar,
  p_columna varchar,
  p_nombre_columna varchar,
  p_order_fila numeric,
  p_tipo varchar,
  p_tipo_saldo varchar
)
RETURNS boolean AS
$body$
DECLARE
   v_nombre_funcion   	text;
   v_resp    			varchar;
   v_mensaje 			varchar;
   v_rasultado			boolean;
   v_record				record;
   v_cuentas			varchar[];
   v_partida			varchar[];
   v_id_cuenta			varchar;
   v_importe			numeric;
   v_periodo			record;
   v_columnas			integer;
   v_partidas_ids			text;
BEGIN

   v_nombre_funcion = 'conta.f_calcular_mayor_reporte';
   v_rasultado = false;
   v_cuentas = string_to_array(p_nro_cuenta,',');
   v_partida = string_to_array(p_partidas,',');

   select pxp.list(pa.id_partida::text)
    into v_partidas_ids
  from pre.tpartida pa
  where  pa.codigo = ANY (v_partida);



    WITH RECURSIVE cuenta_rec (	id_cuenta,nro_cuenta, nombre_cuenta ,id_cuenta_padre) AS (
                                select 	  cue.id_cuenta,
                                          cue.nro_cuenta,
                                          cue.nombre_cuenta,
                                          cue.id_cuenta_padre
                                  from conta.tcuenta cue
                                  where  cue.estado_reg = 'activo' and cue.id_cuenta in (	select cu.id_cuenta
                                  															from conta.tcuenta cu
                                                                                            where cu.nro_cuenta = ANY(v_cuentas)
                                                                                            and cu.id_gestion = p_id_gestion)
                                  union all
                                  select  cue2.id_cuenta,
                                          cue2.nro_cuenta,
                                          cue2.nombre_cuenta,
                                          cue2.id_cuenta_padre
                                  from cuenta_rec lrec
                                  inner join  conta.tcuenta cue2 ON lrec.id_cuenta = cue2.id_cuenta_padre
                                  where cue2.estado_reg = 'activo'
                            )select pxp.list(id_cuenta::varchar)
                            into
                            v_id_cuenta
                            from cuenta_rec;

   --raise exception '%',v_id_cuenta;

   if(p_tipo_saldo = 'si')then
   		v_importe = 0;
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
                                order by  periodo)loop

                  with basico as (select  t.importe_debe_mb,
                              t.importe_haber_mb,
                              t.importe_debe_mb - t.importe_haber_mb as saldo_mb
                              from conta.tint_transaccion t
                              inner join conta.tint_comprobante cb on cb.id_int_comprobante = t.id_int_comprobante
                              inner join param.tperiodo pe on pe.id_periodo = cb.id_periodo
                              where cb.estado_reg = 'validado' and pe.id_gestion = p_id_gestion and
                               t.id_cuenta::text = ANY (string_to_array(v_id_cuenta,','))and
                               case
                                        when v_partidas_ids = '' or v_partidas_ids is null then
                                  		0=0
                                        else
                                   t.id_partida::varchar = ANY (string_to_array(v_partidas_ids::varchar,','))
                                   end
                               and
                               case
                               	when v_periodo.periodo = 1 then
                                 cb.cbte_apertura = 'si' and pe.periodo = v_periodo.periodo
                               	else
                                pe.periodo < v_periodo.periodo
                               end
                            )
                    select  case
                              when p_tipo = 'debe' then
                              sum( b.importe_debe_mb )
                              when  p_tipo = 'haber' then
                              sum( b.importe_haber_mb)
                              when p_tipo = 'saldo' then
                              sum( b.saldo_mb)
                              end
                              into
                              v_importe
                    from basico b;



             insert into temp_reporte(	 id_plantilla_reporte,
                                         codigo,
                                         columna,
                                         titulo_columna,
                                         gestion,
                                         periodo,
                                         importe,
                                         orden
                                        )values (
                                         p_id_planilla,
                                         p_codigo_columna,
                                         p_columna,
                                         p_nombre_columna,
                                         2018,
                                         v_periodo.periodo,
                                         v_importe,
                                         v_columnas
                                          );
                    v_rasultado = true;
      end loop;

   else
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


   		if p_nro_cuenta = '2.1.2.01.099.001' then
        for v_record in (with  desepenio as (
                                                        select		per.id_periodo,
                                                        sum(COALESCE(transa.importe_debe_mb,0))::numeric as monto
                                                        from conta.tint_transaccion transa
                                                        inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                                                        inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
                                                        where icbte.estado_reg = 'validado'
                                                              and  transa.id_cuenta in (1881)
                                                              and  per.id_gestion = 2
                                                              and transa.cerrado in ('si','no')
                                                        group by per.id_periodo
                                                        order by id_periodo asc ),
                                             aportes as ( select per.id_periodo,
                                                                sum(COALESCE(transa.importe_debe_mb,0))::numeric as monto
                                                                from conta.tint_transaccion transa
                                                                inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                                                                inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
                                                                where icbte.estado_reg = 'validado'
                                                                      and  transa.id_cuenta in (1881)
                                                                      and  per.id_gestion = 2
                                                                      and transa.cerrado in ('si','no')
                                                                      and (icbte.glosa1::varchar ILIKE '%APORTES%'  or icbte.glosa1::varchar ILIKE '%REVERSION%')
                                                                group by per.id_periodo
                                                                order by id_periodo asc )
                                            select 	p.periodo,
                                                    en.monto - COALESCE( ap.monto,0) as saldo_mb
                                            from desepenio en
                                            inner join param.tperiodo p on p.id_periodo = en.id_periodo
                                            left join aportes ap on ap.id_periodo = en.id_periodo)loop


                                        insert into temp_reporte(   id_plantilla_reporte,
                                                                    codigo,
                                                                    columna,
                                                                    titulo_columna,
                                                                    gestion,
                                                                    periodo,
                                                                    importe,
                                                                    orden
                                                                    )values (
                                                                    p_id_planilla,
                                                                    p_codigo_columna,
                                                                    p_columna,
                                                                    p_nombre_columna,
                                                                    2018,
                                                                    v_record.periodo,
                                                                    case
                                                                    when p_tipo = 'debe' then
                                                                    v_record.saldo_mb
                                                                    when  p_tipo = 'haber' then
                                                                    v_record.saldo_mb
                                                                    when p_tipo = 'saldo' then
                                                                    	case
                                                                        	when v_record.saldo_mb < 0 then
                                                                    			-1*v_record.saldo_mb
                                                                            else
                                                                            	v_record.saldo_mb
                                                                            end
                                                                    end ,
                                                                    v_columnas
                                                                    );

                                              v_rasultado = true;


           end loop;
        else
        	for v_record in ( with basico as (  select  	t.id_cuenta,
                                                        cu.nro_cuenta,
                                                        pe.periodo,
                                                        t.importe_debe_mb,
                                                        t.importe_haber_mb,
                                                        t.importe_debe_mb - t.importe_haber_mb saldo_mb
                                                      from conta.tint_transaccion t
                                                      inner join conta.tint_comprobante cb on cb.id_int_comprobante = t.id_int_comprobante
                                                      inner join conta.tcuenta cu on cu.id_cuenta = t.id_cuenta
                                                      inner join param.tperiodo pe on pe.id_periodo = cb.id_periodo
                                                      where cb.estado_reg = 'validado' and pe.id_gestion = p_id_gestion and
                                                      t.id_cuenta::text = ANY (string_to_array(v_id_cuenta,',')) and
                                                       case
                                        when v_partidas_ids = '' or v_partidas_ids is null then
                                  		0=0
                                        else
                                   t.id_partida::varchar = ANY (string_to_array(v_partidas_ids::varchar,','))
                                   end
                               and
                                                      cb.cbte_cierre in ('no') and t.cerrado in ('si','no') and cb.cbte_apertura = 'no'
                                                      order by periodo)
                                              select pr.periodo,
                          							 COALESCE(sum(b.importe_debe_mb),0) as importe_debe_mb,
                                                     COALESCE(sum(b.importe_haber_mb),0) as importe_haber_mb,
                                                     COALESCE(sum(b.saldo_mb),0)as saldo_mb
                                                    from  param.tperiodo pr
                                                    left join basico b on b.periodo = pr.periodo
                                                    where pr.id_gestion = p_id_gestion
                                                    group by pr.periodo
                                                    order by periodo)loop


                                        insert into temp_reporte(   id_plantilla_reporte,
                                                                    codigo,
                                                                    columna,
                                                                    titulo_columna,
                                                                    gestion,
                                                                    periodo,
                                                                    importe,
                                                                    orden
                                                                    )values (
                                                                    p_id_planilla,
                                                                    p_codigo_columna,
                                                                    p_columna,
                                                                    p_nombre_columna,
                                                                    2018,
                                                                    v_record.periodo,
                                                                    case
                                                                    when p_tipo = 'debe' then
                                                                    v_record.importe_debe_mb
                                                                    when  p_tipo = 'haber' then
                                                                    v_record.importe_haber_mb
                                                                    when p_tipo = 'saldo' then
                                                                    	case
                                                                        	when v_record.saldo_mb < 0 then
                                                                    			-1*v_record.saldo_mb
                                                                            else
                                                                            	v_record.saldo_mb
                                                                            end
                                                                    end ,
                                                                    v_columnas
                                                                    );

                                              v_rasultado = true;


           end loop;
        end if;

  	end if;

		RETURN v_rasultado;

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