CREATE OR REPLACE FUNCTION conta.f_reporte_c_detalle_auxliar (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS SETOF record AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.f_reporte_c_detalle_auxliar
 DESCRIPCION:   Funcion que devuelve conjuntos suma por centro de costos
 AUTOR: 		 (MMV)
 FECHA:	        19/12/2018
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
 ISSUE 		   FECHA   			 AUTOR				 DESCRIPCION:
  #23        27/12/2018    Miguel Mamani     		Reporte Detalle Auxiliares por Cuenta


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
BEGIN

     v_nombre_funcion = 'conta.f_reporte_c_detalle_auxliar';
       v_parametros = pxp.f_get_record(p_tabla);


    /*********************************
 	#TRANSACCION:  'CONTA_RDA_SEL'  #23
 	#DESCRIPCION:	Reporte
 	#AUTOR:		MMV
 	#FECHA:		03-05-2017
	***********************************/
   IF(p_transaccion='CONTA_RDA_SEL')then
   	BEGIN
     CREATE TEMPORARY TABLE tmp_prog (   id_auxiliar_cc integer,
                                         id_auxiliar_fk integer,
                                         codigo_aux varchar,
                                         codigo varchar,
                                         importe_debe_mb numeric,
                                         importe_haber_mb numeric,
                                         saldo_mb NUMERIC,
                                         nivel integer,
                                         sw_tipo varchar )ON COMMIT DROP;




          FOR v_record in (with basica as (select 	t.id_cuenta,
                                                    cu.nro_cuenta,
                                                    cu.nombre_cuenta,
                                                    t.id_auxiliar,
                                                    aux.codigo_auxiliar,
                                                    aux.nombre_auxiliar,
                                                    t.importe_debe_mb,
                                                    t.importe_haber_mb
                                                  from conta.tint_transaccion t
                                                    inner join conta.tint_comprobante cb on cb.id_int_comprobante = t.id_int_comprobante
                                                    left join conta.tauxiliar aux on aux.id_auxiliar = t.id_auxiliar
                                                    inner join conta.tcuenta cu on cu.id_cuenta = t.id_cuenta
                                                    inner join param.tperiodo pe on pe.id_periodo = cb.id_periodo
                                                  where cb.estado_reg = 'validado'  and cu.id_cuenta = v_parametros.id_cuenta
                                                  and pe.id_gestion = v_parametros.id_gestion and  cb.fecha::date BETWEEN v_parametros.desde and v_parametros.hasta
                                                  and (case
                                                            	when v_parametros.cbte_cierre = 'todos' then
                                                                	cb.cbte_cierre in ('no','balance','resultado')
                                                            	when v_parametros.cbte_cierre = 'balance' then
                                                            		cb.cbte_cierre in ('balance')
                                                                when v_parametros.cbte_cierre = 'resultado' then
                                                            		cb.cbte_cierre in ('resultado')
                                                              	when v_parametros.cbte_cierre = 'no' then
                                                            		cb.cbte_cierre in ('no')
                                                                end)
                            )select  t.id_auxiliar as id_auxiliar_cc,
                                     t.id_cuenta as id_auxiliar_fk,
                                     COALESCE(t.codigo_auxiliar,'') ||' ('|| COALESCE(t.nombre_auxiliar,'No Tiene Auxiliar')||')' as codigo_aux,
                                     t.codigo_auxiliar as codigo,
                                     sum(COALESCE(t.importe_debe_mb,0)) as importe_debe_mb,
                                     sum(COALESCE(t.importe_haber_mb,0)) as importe_haber_mb,
                                     sum(COALESCE(t.importe_debe_mb,0)) - sum(COALESCE(t.importe_haber_mb,0)) as saldo_mb
                                   from basica t
                                   group by
                                     t.id_auxiliar,
                                     t.id_cuenta,
                                     t.codigo_auxiliar,
                                     t.nombre_auxiliar
                                     order by t.codigo_auxiliar)LOOP

    		insert into tmp_prog ( id_auxiliar_cc,
                                   id_auxiliar_fk,
                                   codigo_aux,
                                   codigo,
                                   importe_debe_mb,
                                   importe_haber_mb,
                                   saldo_mb,
                                   nivel,
                                   sw_tipo
                                  )
                                  values(
                                   null,
                                   v_record.id_auxiliar_fk,
                                   v_record.codigo_aux,
                                   v_record.codigo,
                                   v_record.importe_debe_mb,
                                   v_record.importe_haber_mb,
                                   v_record.saldo_mb,
                                   2,
                                   'movimiento'
                                  );

          END LOOP;

          select max(tp.nivel)
          into
          v_nivel
          from tmp_prog tp;

           PERFORM conta.f_c_detalle_auxliar_recursivo(v_nivel-1);

          FOR v_registros in (select     tm.id_auxiliar_cc,
                                        tm.id_auxiliar_fk,
                                        tm.codigo_aux,
                                        sum(tm.importe_debe_mb) as importe_debe_mb,
                                        sum(tm.importe_haber_mb) as importe_haber_mb,
                                        sum(tm.saldo_mb) as saldo_mb,
                                        tm.nivel,
                                        tm.sw_tipo,
                                        tm.codigo
                           from tmp_prog tm
                           group by tm.id_auxiliar_cc,
                                    tm.id_auxiliar_fk,
                                    tm.codigo_aux,
                                    tm.nivel,
                                    tm.sw_tipo,
                                    tm.codigo
                           order by  tm.codigo , tm.nivel )LOOP
            	RETURN NEXT v_registros;
            END LOOP;

  	END;
    ELSIF(p_transaccion='CONTA_AUXN_SEL')then
      BEGIN
      	   FOR v_registros in (select 	t.id_cuenta,
                                        cu.nro_cuenta,
                                        cu.nombre_cuenta,
                                        cb.id_int_comprobante,
                                        cb.fecha,
                                        cb.nro_cbte,
                                        cb.glosa1,
                                        t.importe_debe_mb,
                                        t.importe_haber_mb,
                                        t.importe_debe_mb - t.importe_haber_mb as saldo_mb
                                      from conta.tint_transaccion t
                                        inner join conta.tint_comprobante cb on cb.id_int_comprobante = t.id_int_comprobante
                                        left join conta.tauxiliar aux on aux.id_auxiliar = t.id_auxiliar
                                        inner join conta.tcuenta cu on cu.id_cuenta = t.id_cuenta
                                        inner join param.tperiodo pe on pe.id_periodo = cb.id_periodo
                                      where cb.estado_reg = 'validado'  and cu.id_cuenta = v_parametros.id_cuenta
                                      and pe.id_gestion = v_parametros.id_gestion and  cb.fecha::date BETWEEN v_parametros.desde and v_parametros.hasta
                                      and t.id_auxiliar is null and (case
                                                            	when v_parametros.cbte_cierre = 'todos' then
                                                                	cb.cbte_cierre in ('no','balance','resultado')
                                                            	when v_parametros.cbte_cierre = 'balance' then
                                                            		cb.cbte_cierre in ('balance')
                                                                when v_parametros.cbte_cierre = 'resultado' then
                                                            		cb.cbte_cierre in ('resultado')
                                                              	when v_parametros.cbte_cierre = 'no' then
                                                            		cb.cbte_cierre in ('no')
                                                                end) )LOOP
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