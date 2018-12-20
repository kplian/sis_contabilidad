CREATE OR REPLACE FUNCTION conta.f_plantilla_cierre_gasto (
  p_id_usuario integer,
  p_id_int_comprobante integer,
  p_id_gestion_cbte integer,
  p_desde date,
  p_hasta date,
  p_id_depto integer
)
RETURNS void AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.f_plantilla_cierre_gasto
 DESCRIPCION:   Funcion que devuelve conjuntos suma por centro de costos
 AUTOR: 		 (MMV)
 FECHA:	        19/12/2018
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
 ISSUE 		   FECHA   			 AUTOR				    DESCRIPCION:
  #4       20/12/2018    Miguel Mamani     Plantilla de Cierre de gasto


***************************************************************************/

DECLARE
  v_nombre_funcion   				text;
  v_resp							varchar;
  v_record_mov						record;

  v_id_centro_costo_depto			integer;
  v_sw_minimo						boolean;
  v_reg_cbte  						record;
  v_sw_actualiza					boolean;

  v_saldo_mb						numeric;
  v_saldo_mt						numeric;
  v_saldo_ma						numeric;

  v_importe_debe_ma					numeric;
  v_importe_haber_ma				numeric;
  v_importe_debe_mt					numeric;
  v_importe_haber_mt				numeric;
  v_importe_debe 					numeric;
  v_importe_haber 					numeric;
  v_sw_saldo_acredor   				boolean;
  v_id_partida						integer;


  v_total_haber   						numeric;
  v_total_debe	 						numeric;
  v_total_haber_ma   					numeric;
  v_total_debe_ma	 					numeric;
  v_total_haber_mt   					numeric;
  v_total_debe_mt	 					numeric;

  v_partida_haber						integer;
  v_id_cuenta							integer;

BEGIN
v_nombre_funcion = 'conta.f_plantilla_cierre_gasto';


    select  *
    		into
            v_reg_cbte
    from conta.tint_comprobante
    where id_int_comprobante = p_id_int_comprobante;


 	select
      ps_id_centro_costo
      into
       v_id_centro_costo_depto
     from conta.f_get_config_relacion_contable('CCDEPCON', -- relacion contable que almacena los centros de costo por departamento
                                       p_id_gestion_cbte,
                                       p_id_depto,--p_id_depto_conta
                                       NULL);  --id_dento_costo
   -- v_sw_minimo= false;

      v_total_haber = 0;
      v_total_debe	= 0;
      v_total_haber_ma = 0;
      v_total_debe_ma	= 0;
      v_total_haber_mt = 0;
      v_total_debe_mt	= 0;


     FOR v_record_mov in (with basica as (select 	t.id_cuenta,
                                                    t.importe_debe_mb,
                                                    t.importe_haber_mb,
                                                    t.importe_debe_mt,
                                                    t.importe_haber_mt,
                                                    t.importe_debe_ma,
                                                    t.importe_haber_ma
                                              from conta.tint_transaccion t
                                              inner join conta.tint_comprobante cb on cb.id_int_comprobante = t.id_int_comprobante
                                              inner join  pre.tpartida par on par.id_partida = t.id_partida
                                              inner join conta.tcuenta cu on cu.id_cuenta = t.id_cuenta
                                              inner join conta.tconfig_subtipo_cuenta su on su.id_config_subtipo_cuenta = cu.id_config_subtipo_cuenta
                                              inner join conta.tconfig_tipo_cuenta tc on tc.id_config_tipo_cuenta = su.id_config_tipo_cuenta
                                              inner join param.tperiodo pe on pe.id_periodo = cb.id_periodo
                                              where cb.estado_reg = 'validado'  and tc.tipo_cuenta in ('gasto')
                                              and pe.id_gestion = p_id_gestion_cbte and  cb.fecha::date BETWEEN p_desde and p_hasta
                                              )select t.id_cuenta,
                                                      sum(t.importe_debe_mb) as deudor,
                                                      sum(t.importe_haber_mb) as acreedor,
                                                      sum(t.importe_debe_mt) as importe_debe_mt,
                                                      sum(t.importe_haber_mt) as importe_haber_mt,
                                                      sum(t.importe_debe_ma) as importe_debe_ma,
                                                      sum(t.importe_haber_ma) as importe_haber_ma
                                                      from basica t
                                                      group by t.id_cuenta)LOOP


                    v_sw_actualiza = false;
                    v_sw_saldo_acredor = false;
                    v_saldo_mb  = 0;

                     IF v_record_mov.acreedor > v_record_mov.deudor  THEN

                                v_sw_saldo_acredor = true;
                                v_sw_actualiza = true;
                                v_saldo_mb = v_record_mov.acreedor - v_record_mov.deudor;
                                v_saldo_ma = v_record_mov.importe_haber_ma - v_record_mov.importe_debe_ma;
                                v_saldo_mt = v_record_mov.importe_haber_mt - v_record_mov.importe_debe_mt;

                     ELSEIF v_record_mov.deudor > v_record_mov.acreedor THEN

                               v_sw_saldo_acredor = false;
                               v_sw_actualiza = true;
                               v_saldo_mb = v_record_mov.deudor - v_record_mov.acreedor;
                               v_saldo_ma = v_record_mov.importe_debe_ma - v_record_mov.importe_haber_ma;
                               v_saldo_mt = v_record_mov.importe_debe_mt - v_record_mov.importe_haber_mt;

                     ELSEIF  v_record_mov.deudor = v_record_mov.acreedor THEN
                               v_sw_saldo_acredor = true;
                               v_sw_actualiza = true;
                               v_saldo_mb = 0;
                               v_saldo_ma = 0;
                               v_saldo_mt = 0;

                     ELSE
                         v_sw_actualiza = false;
                     END IF;



                    IF v_sw_actualiza THEN

                        v_importe_debe = 0;
                        v_importe_haber = 0;
                        v_importe_debe_ma	= 0;
                        v_importe_haber_ma = 0;
                        v_importe_debe_mt = 0;
                        v_importe_haber_mt = 0;

                        IF v_sw_saldo_acredor THEN

                                v_importe_haber = 0;
                                v_importe_debe = v_saldo_mb;

                                v_importe_haber_ma  = 0;
                                v_importe_debe_ma	= v_saldo_ma;

                                v_importe_haber_mt 	= 0;
                                v_importe_debe_mt 	= v_saldo_mt;



                                select  ps_id_partida
                                    into
                                    v_id_partida
                                  from conta.f_get_config_relacion_contable( 'CIER-DEBE',
                                                                               p_id_gestion_cbte,
                                                                               null,  --campo_relacion_contable
                                                                               null);

                                --  raise exception ''

                        ELSE
                                v_importe_haber = v_saldo_mb;
                                v_importe_debe 	= 0;

                                v_importe_haber_ma  = v_saldo_ma;
                                v_importe_debe_ma	= 0;

                                v_importe_haber_mt 	= v_saldo_mt;
                                v_importe_debe_mt 	= 0;


                             select  ps_id_partida
                                    into
                                    v_id_partida
                                    from conta.f_get_config_relacion_contable( 'CIER-HABER',
                                                                               p_id_gestion_cbte,
                                                                               NULL,  --campo_relacion_contable
                                                                               NULL);
                        END IF;

                        v_total_debe = v_total_debe + v_importe_haber;
                        v_total_haber = v_total_haber + v_importe_debe;

                      	v_total_debe_ma  = v_total_debe_ma + v_importe_haber_ma;
                      	v_total_haber_ma  = v_total_haber_ma + v_importe_debe_ma;

                      	v_total_debe_mt  = v_total_debe_mt + v_importe_haber_mt;
                       	v_total_haber_mt  = v_total_haber_mt + v_importe_debe_mt;

                  IF v_saldo_mb != 0  or  v_saldo_ma != 0 or v_saldo_mt != 0 THEN




                        insert into conta.tint_transaccion(
                                    id_partida,
                                    id_centro_costo,
                                    estado_reg,
                                    id_cuenta,
                                    glosa,
                                    id_int_comprobante,
                                    id_auxiliar,
                                    importe_debe,
                                    importe_haber,
                                    importe_gasto,
                                    importe_recurso,
                                    importe_debe_mb,
                                    importe_haber_mb,
                                    importe_gasto_mb,
                                    importe_recurso_mb,
                                    importe_debe_mt,
                                    importe_haber_mt,
                                    importe_gasto_mt,
                                    importe_recurso_mt,
                                    importe_debe_ma,
                                    importe_haber_ma,
                                    importe_gasto_ma,
                                    importe_recurso_ma,
                                    id_usuario_reg,
                                    fecha_reg,
                                    actualizacion
                                ) values(
                                    v_id_partida,
                                    v_id_centro_costo_depto,
                                    'activo',
                                    v_record_mov.id_cuenta,
                                    'Asiento de Cierre de las Cuentas de Gasto ',
                                    p_id_int_comprobante,
                                    null,
                                    v_importe_debe,
                                    v_importe_haber,
                                    v_importe_debe,
                                    v_importe_haber,
                                    v_importe_debe,
                                    v_importe_haber,
                                    v_importe_debe,
                                    v_importe_haber,
                                    v_importe_debe_mt,
                                    v_importe_haber_mt,
                                    v_importe_debe_mt,
                                    v_importe_haber_mt, --MT
                                    v_importe_debe_ma,
                                    v_importe_haber_ma,
                                    v_importe_debe_ma,
                                    v_importe_haber_ma, --MA
                                    p_id_usuario,
                                    now(),
                                    'si' );

                                    v_sw_minimo = true;
                          END IF;

                ELSE
                   raise exception 'Algo salio mal con la cuenta ';
                END IF;

          END LOOP;

        IF not v_sw_minimo THEN
           raise exception 'No se actualizo ninguna cuenta';
        END IF;

    SELECT  ps_id_partida
              into
              v_partida_haber
              FROM conta.f_get_config_relacion_contable( 'CIER-HABER',
                                                         p_id_gestion_cbte,
                                                         NULL,  --campo_relacion_contable
                                                         NULL);

                                IF v_partida_haber is null THEN
                                   raise exception 'No se encontro relacion contable CIER-HABER';
                                END IF;

              select c.id_cuenta
              into
              v_id_cuenta
              from conta.tcuenta c
              where c.nro_cuenta = '3.1.3.02.001.001' and c.id_gestion = p_id_gestion_cbte;

   insert into conta.tint_transaccion(
                                        id_partida,
                                        id_centro_costo,
                                        estado_reg,
                                        id_cuenta,
                                        glosa,
                                        id_int_comprobante,
                                        id_auxiliar,
                                        importe_debe,
                                        importe_haber,
                                        importe_gasto,
                                        importe_recurso,
                                        importe_debe_mb,
                                        importe_haber_mb,
                                        importe_gasto_mb,
                                        importe_recurso_mb,
                                        importe_debe_mt,
                                        importe_haber_mt,
                                        importe_gasto_mt,
                                        importe_recurso_mt,
                                        importe_debe_ma,
                                        importe_haber_ma,
                                        importe_gasto_ma,
                                        importe_recurso_ma,
                                        id_usuario_reg,
                                        fecha_reg,
                                        actualizacion
                                    ) values(
                                        v_partida_haber,   --partida de flujo
                                        v_id_centro_costo_depto, -- v_id_centro_costo_depto, --centr de costo del depto contable
                                        'activo',
                                        v_id_cuenta, --la misma cuenta sobre la que hicimos el mayor
                                        'Asiento de cierre de las cuentas de Gasto',  --glosa
                                        p_id_int_comprobante,
                                        NULL,--v_registros.id_auxiliar,
                                        v_total_debe,
                                        v_total_haber,
                                        v_total_debe,
                                        v_total_haber,
                                        v_total_debe,
                                        v_total_haber,
                                        v_total_debe,
                                        v_total_haber,
                                        v_total_debe_mt,v_total_haber_mt,v_total_debe_mt,v_total_haber_mt, --MT
                                        v_total_debe_ma,v_total_haber_ma,v_total_debe_ma,v_total_haber_ma,--MA
                                        p_id_usuario,
                                        now(),
                                        'si'
                                    );


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