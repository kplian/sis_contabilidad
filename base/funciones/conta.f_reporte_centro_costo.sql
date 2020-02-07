--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_reporte_centro_costo (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS SETOF record AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.f_reporte_centro_costo
 DESCRIPCION:   Funcion que devuelve conjuntos suma por centro de costos
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
 ISSUE 		   FECHA   			 AUTOR				 DESCRIPCION:
  #2        20/12/2018    Miguel Mamani     		Reporte Proyectos
  #10       02/01/2019    Miguel Mamani     		Nuevo parámetro tipo de moneda para el reporte detalle Auxiliares por Cuenta
  #64  ETR  15/07/2019          MMV                 Incluir importe formulado reporte proyectos
  #104      7/2/2020	 Manuel Guerra				ordenacion por cod_partida en reporte de tcc
***************************************************************************/


DECLARE
v_parametros  		record;
v_nombre_funcion   	text;
v_resp				varchar;
v_record            record;
v_tipo_cc			varchar;
v_registros			record;
v_nivel				integer;
v_cuentas			varchar;
v_id_moneda_base	integer;
v_id_moneda_act		integer;
BEGIN

     v_nombre_funcion = 'conta.f_reporte_centro_costo';
       v_parametros = pxp.f_get_record(p_tabla);


    /*********************************
 	#TRANSACCION:  'CONTA_CCR_SEL'
 	#DESCRIPCION:	Reporte
 	#AUTOR:		MMV
 	#FECHA:		03-05-2017
	***********************************/
   IF(p_transaccion='CONTA_CCR_SEL')then
   	BEGIN
    v_id_moneda_base = param.f_get_moneda_base();
	v_id_moneda_act  = param.f_get_moneda_actualizacion();

     CREATE TEMPORARY TABLE tmp_prog (   id_tipo_cc integer,
                                         id_tipo_cc_fk integer,
                                         codigo_tcc varchar,
                                         codigo varchar,
                                         importe_debe_mb numeric,
                                         importe_haber_mb numeric,
                                         saldo_mb numeric,
                                         importe_debe_mt numeric, --#10
                                         importe_haber_mt numeric, --#10
                                         saldo_mt numeric, --#10
                                         importe_debe_ma numeric, --#10
                                         importe_haber_ma numeric, --#10
                                         saldo_ma numeric, --#10
                                         nivel integer,
                                         sw_tipo varchar,
                                         importe_formulado numeric --#64
                                         )ON COMMIT DROP;
       --raise EXCEPTION 'v_parametros.id_cuenta %',v_parametros.id_cuenta;

    WITH RECURSIVE tipo_cc_rec (id_tipo_cc, id_tipo_cc_fk) AS (
                        SELECT tcc.id_tipo_cc, tcc.id_tipo_cc_fk
                        FROM param.ttipo_cc tcc
                        WHERE tcc.id_tipo_cc = v_parametros.id_tipo_cc and tcc.estado_reg = 'activo'
                      UNION ALL
                        SELECT tcc2.id_tipo_cc, tcc2.id_tipo_cc_fk
                        FROM tipo_cc_rec lrec
                        INNER JOIN param.ttipo_cc tcc2 ON lrec.id_tipo_cc = tcc2.id_tipo_cc_fk
                        where tcc2.estado_reg = 'activo'
                      )
                    SELECT pxp.list(id_tipo_cc::varchar)
                    into v_tipo_cc
                    FROM tipo_cc_rec;


     WITH RECURSIVE cuenta_rec (id_cuenta,nro_cuenta, nombre_cuenta ,id_cuenta_padre) AS (
                            SELECT cue.id_cuenta,cue.nro_cuenta,cue.nombre_cuenta, cue.id_cuenta_padre
                            FROM conta.tcuenta cue
                            WHERE cue.id_cuenta = v_parametros.id_cuenta and cue.estado_reg = 'activo'
                          UNION ALL
                            SELECT cue2.id_cuenta,cue2.nro_cuenta, cue2.nombre_cuenta, cue2.id_cuenta_padre
                            FROM cuenta_rec lrec
                            INNER JOIN conta.tcuenta cue2 ON lrec.id_cuenta = cue2.id_cuenta_padre
                            where cue2.estado_reg = 'activo'
                          )select pxp.list(id_cuenta::varchar)
                          into
                          v_cuentas
                          from cuenta_rec;

          FOR v_record in (with partida as (select  pa.id_partida as id_tipo_cc,
                                                      cc.id_tipo_cc as id_tipo_cc_fk,
                                                      cc.codigo_cc as codigo,
                                                      pa.codigo||' '|| pa.nombre_partida as codigo_tcc,
                                                      t.importe_debe_mb,
                                                      t.importe_haber_mb,
                                                      t.importe_debe_mt, --#10
                                                      t.importe_haber_mt, --#10
                                                      t.importe_debe_ma, --#10
                                                      t.importe_haber_ma, --#10
                                                      0::numeric as importe_formulado  --#64
                                                      from conta.tint_transaccion t
                                                      inner join conta.tint_comprobante cb on cb.id_int_comprobante = t.id_int_comprobante
                                                      inner join pre.tpartida pa on pa.id_partida = t.id_partida
                                                      inner join param.tperiodo pe on pe.id_periodo = cb.id_periodo
                                                      inner join param.vcentro_costo cc on cc.id_centro_costo = t.id_centro_costo
                                                      where cb.estado_reg = 'validado' and  cc.id_tipo_cc::text = ANY (string_to_array(v_tipo_cc,','))
                                                      and pe.id_gestion = v_parametros.id_gestion and  cb.fecha::date BETWEEN v_parametros.desde and v_parametros.hasta
                                                      and case
                                                      		when  v_parametros.id_cuenta is null then
                                                            0 = 0
                                                            else
                                                          	t.id_cuenta::text = ANY (string_to_array(v_cuentas,','))
                                                         	end
                                                            and
                                                            (case
                                                            	when v_parametros.cbte_cierre = 'todos' then
                                                                	cb.cbte_cierre in ('no','balance','resultado')
                                                            	when v_parametros.cbte_cierre = 'balance' then
                                                            		cb.cbte_cierre in ('balance')
                                                                when v_parametros.cbte_cierre = 'resultado' then
                                                            		cb.cbte_cierre in ('resultado')
                                                              	when v_parametros.cbte_cierre = 'no' then
                                                            		cb.cbte_cierre in ('no')
                                                                end)
                                                                and
                                                                (case
                                                            		when  v_parametros.id_centro_costo is null then
                                                                    0 = 0
                                                                    else
                                                                    cc.id_centro_costo = v_parametros.id_centro_costo
                                                                    end)
        union all  --#64

        select   pa.id_partida as id_tipo_cc,
    			 cc.id_tipo_cc as id_tipo_cc_fk,
                 cc.codigo_cc as codigo,
                 pa.codigo||' '|| pa.nombre_partida as codigo_tcc,
        		 0::numeric as importe_debe_mb,
                 0::numeric as importe_haber_mb,
                 0::numeric as importe_debe_mt,
                 0::numeric as importe_haber_mt,
                 0::numeric as importe_debe_ma,
                 0::numeric as importe_haber_ma,
                 prpa.importe_aprobado as importe_formulado
                 from pre.tpresup_partida prpa
                 inner join param.vcentro_costo cc on cc.id_centro_costo = prpa.id_centro_costo
                 inner join pre.tpartida pa on pa.id_partida = prpa.id_partida
                 where (case
                      when  v_parametros.id_centro_costo is null then
                      0 = 0
                      else
                      prpa.id_centro_costo = v_parametros.id_centro_costo
                      end) and pa.id_gestion = v_parametros.id_gestion and cc.id_tipo_cc::text = ANY (string_to_array(v_tipo_cc,',')))
                                                    select p.id_tipo_cc,
                                                           p.id_tipo_cc_fk,
                                                           p.codigo_tcc,
                                                           p.codigo,
                                                          sum(p.importe_debe_mb) as importe_debe_mb,
                                                          sum(p.importe_haber_mb) as importe_haber_mb,
                                                          sum(p.importe_debe_mb) - sum(p.importe_haber_mb) as saldo_mb,
                                                          sum(COALESCE(p.importe_debe_mt,0)) as importe_debe_mt, --#10
                                                          sum(COALESCE(p.importe_haber_mt,0)) as importe_haber_mt, --#10
                                                          sum(COALESCE(p.importe_debe_mt,0)) - sum(COALESCE(p.importe_haber_mt,0)) as saldo_mt, --#10
                                                          sum(COALESCE(p.importe_debe_ma,0)) as importe_debe_ma, --#10
                                                          sum(COALESCE(p.importe_haber_ma,0)) as importe_haber_ma, --#10
                                                          sum(COALESCE(p.importe_debe_ma,0)) - sum(COALESCE(p.importe_haber_ma,0)) as saldo_ma,    --#10
                                                          sum(COALESCE(p.importe_formulado,0)) as importe_formulado
                                                    from partida p
                                                    group by p.id_tipo_cc,
                                                             p.id_tipo_cc_fk,
                                                             p.codigo_tcc,
                                                             p.codigo)LOOP --#64


    		insert into tmp_prog ( id_tipo_cc,
                                   id_tipo_cc_fk,
                                   codigo_tcc,
                                   codigo,
                                   importe_debe_mb,
                                   importe_haber_mb,
                                   saldo_mb,
                                   importe_debe_mt, --#10
                                   importe_haber_mt, --#10
                                   saldo_mt, --#10
                                   importe_debe_ma, --#10
                                   importe_haber_ma, --#10
                                   saldo_ma, --#10
                                   nivel,
                                   sw_tipo,
                                   importe_formulado --#64
                                  )
                                  values(
                                   null,
                                   v_record.id_tipo_cc_fk,
                                   v_record.codigo_tcc,
                                   v_record.codigo,
                                   v_record.importe_debe_mb,
                                   v_record.importe_haber_mb,
                                   v_record.saldo_mb,
                                   v_record.importe_debe_mt, --#10
                                   v_record.importe_haber_mt, --#10
                                   v_record.saldo_mt, --#10
                                   v_record.importe_debe_ma, --#10
                                   v_record.importe_haber_ma, --#10
                                   v_record.saldo_ma, --#10
                                   4,
                                   'movimiento',
                                   v_record.importe_formulado --#64
                                  );

          END LOOP;

          select max(tp.nivel)
          into
          v_nivel
          from tmp_prog tp;

           PERFORM conta.f_reporte_tcc_recursivo(v_nivel-1);

          FOR v_registros in (select    tm.id_tipo_cc,
                                        tm.id_tipo_cc_fk,
                                        tm.codigo_tcc,
                                        case
                                             when v_parametros.tipo_moneda = 'MB' then
                                                    sum(tm.importe_debe_mb)
                                             when v_parametros.tipo_moneda = 'MT' then
                                                    sum(tm.importe_debe_mt)
                                             when v_parametros.tipo_moneda = 'MA' then
                                                    sum(tm.importe_debe_ma)
                                         end as importe_debe_mb, --#10
          								case
                                             when v_parametros.tipo_moneda = 'MB' then
                                                    sum(tm.importe_haber_mb)
                                             when v_parametros.tipo_moneda = 'MT' then
                                                    sum(tm.importe_haber_mt)
                                             when v_parametros.tipo_moneda = 'MA' then
                                                    sum(tm.importe_haber_mt)
                                         end as importe_haber_mb, --#10
                                         case
                                             when v_parametros.tipo_moneda = 'MB' then
                                                    sum(tm.saldo_mb)
                                             when v_parametros.tipo_moneda = 'MT' then
                                                    sum(tm.saldo_mt)
                                             when v_parametros.tipo_moneda = 'MA' then
                                                    sum(tm.saldo_ma)
                                         end as saldo_mb, --#10
                                        tm.nivel,
                                        tm.sw_tipo,
                                        tm.codigo,
                                        case--#64
                                             when v_parametros.tipo_moneda = 'MB' then
                                        			sum(tm.importe_formulado)
                                             when v_parametros.tipo_moneda = 'MT' then

                                                  param.f_convertir_moneda (v_id_moneda_base,
                                                                            2 ,
                                                                             sum(tm.importe_formulado),
                                                                             now()::date, 'O',2, 1, 'no')
                                             when v_parametros.tipo_moneda = 'MA' then
                                            -- 1
                                                  param.f_convertir_moneda ( v_id_moneda_base,
                                                                             v_id_moneda_act,
                                                                             sum(tm.importe_formulado),
                                                                             now()::date, 'O',2, 1, 'no')
                                         end as importe_formulado--#64
                           from tmp_prog tm
                           group by tm.id_tipo_cc,
                                    tm.id_tipo_cc_fk,
                                    tm.codigo_tcc,
                                    tm.nivel,
                                    tm.sw_tipo,
                                    tm.codigo
                           order by  tm.codigo , tm.nivel,tm.codigo_tcc )LOOP --#104
            	RETURN NEXT v_registros;
            END LOOP;

  	END;
   	ELSE

    	raise exception 'Transaccion inexistente: %',p_transaccion;

	END IF;
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
COST 100 ROWS 1000;