--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_plantilla_apertura_cuenta_sin_partidas (
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
 FUNCION: 		conta.f_plantilla_apertura_cuenta_sin_partidas
 DESCRIPCION:   Funcion que devuelve conjuntos suma por centro de costos
 AUTOR: 		 (RAC)
 FECHA:	        04/02/2020
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
 ISSUE 		   FECHA   			 AUTOR				    DESCRIPCION:
 #100  ETR	  04/02/2020		  RAC				Creación , Refactorizacion de algoritmo de cierre y apertura contable para no incluir  partidas presupuestarias.


***************************************************************************/
DECLARE
	v_nombre_funcion   					text;
 	v_resp								varchar;
    v_record_mov						record;

    v_sw_actualiza						boolean;
    v_sw_minimo							boolean;
    v_sw_saldo_acredor					boolean;
    v_id_centro_costo_depto             integer;

    v_importe_debe						numeric;
    v_importe_haber				    	numeric;
    v_saldo_mb   						numeric;
    v_saldo_mt							numeric;
    v_saldo_ma							numeric;

    v_importe_debe_ma					numeric;
    v_importe_haber_ma				    numeric;
    v_importe_debe_mt					numeric;
    v_importe_haber_mt				    numeric;
    v_aux_debe							numeric;
    v_aux_heber							numeric;
    v_id_partida                        integer;
    v_reg_cbte 							record;
    v_id_cuenta_sg						integer;
    v_id_partida_sg						integer;
    v_id_centro_costo_sg				integer;
    v_saldo_aux                         numeric;
    v_id_gestion_previa                 integer;
    v_id_partida_debe                   integer;
    v_id_partida_haber                  integer;
    v_error                             boolean;
    v_tmp                               varchar;

BEGIN

       v_nombre_funcion = 'conta.f_plantilla_apertura_cuenta_sin_partidas';
       v_tmp = '';

 	   select  *
              into
              v_reg_cbte
      from conta.tint_comprobante
      where id_int_comprobante = p_id_int_comprobante;
      
      -- recuperar gestion previa
      select 
      ges_prev.id_gestion 
      into 
      v_id_gestion_previa  
      from param.tgestion ges
      inner join  param.tgestion ges_prev on ges_prev.gestion = ges.gestion - 1
      where ges.id_gestion =  p_id_gestion_cbte;
      
      
      --recupera partidas de flujo
      select  ps_id_partida  into  v_id_partida_debe
      from conta.f_get_config_relacion_contable( 'APER-DEBE',
                                                  p_id_gestion_cbte,
                                                  null,  --campo_relacion_contable
                                                  null);
                            

      select  ps_id_partida into  v_id_partida_haber
      from conta.f_get_config_relacion_contable( 'APER-HABER',
                                                  p_id_gestion_cbte,
                                                  NULL,  --campo_relacion_contable
                                                  NULL);
                           
                                      

      --Consulta para totalizar las cuentas 
      FOR v_record_mov in (with basica as (select  t.id_centro_costo,
                                                    t.id_cuenta,
                                                    cu.nro_cuenta,
                                                    COALESCE(t.id_auxiliar,0) as id_auxiliar,                                                    
                                                    t.importe_debe_mb,
                                                    t.importe_haber_mb,
                                                    t.importe_debe_mt,
                                                    t.importe_haber_mt,
                                                    t.importe_debe_ma,
                                                    t.importe_haber_ma
                                              from conta.tint_transaccion t
                                              inner join conta.tint_comprobante cb on cb.id_int_comprobante = t.id_int_comprobante
                                            
                                              inner join conta.tcuenta cu on cu.id_cuenta = t.id_cuenta
                                              inner join conta.tconfig_subtipo_cuenta su on su.id_config_subtipo_cuenta = cu.id_config_subtipo_cuenta
                                              inner join conta.tconfig_tipo_cuenta tc on tc.id_config_tipo_cuenta = su.id_config_tipo_cuenta
                                              inner join param.tperiodo pe on pe.id_periodo = cb.id_periodo
                                              where cb.estado_reg = 'validado' and tc.tipo_cuenta in ('activo','patrimonio','pasivo')
                                              and pe.id_gestion = v_id_gestion_previa and cb.cbte_cierre <> 'balance'
                                              )select t.id_centro_costo,
                                                      t.id_cuenta,
                                                      t.nro_cuenta,
                                                      t.id_auxiliar,
                                                      0  as id_partida,
                                                      sum(COALESCE(t.importe_debe_mb,0)) as deudor,
                                                      sum(COALESCE(t.importe_haber_mb,0)) as acreedor,
                                                      sum(COALESCE(t.importe_debe_mt,0)) as importe_debe_mt,
                                                      sum(COALESCE(t.importe_haber_mt,0)) as importe_haber_mt,
                                                      sum(COALESCE(t.importe_debe_ma,0)) as importe_debe_ma,
                                                      sum(COALESCE(t.importe_haber_ma,0)) as importe_haber_ma
                                                      from basica t
                                                      group by
                                                            t.id_centro_costo,
                                                            t.id_cuenta,
                                                            t.id_auxiliar,
                                                            t.nro_cuenta
                                                      order by t.nro_cuenta)LOOP


                    v_sw_actualiza = false;
                    v_sw_saldo_acredor = false;

                    v_saldo_mb  = 0;
                    v_saldo_mt = 0;
                    v_saldo_ma = 0;

                    v_aux_debe = 0;
                    v_aux_heber = 0;

                     v_aux_debe = v_record_mov.deudor + v_record_mov.importe_debe_mt + v_record_mov.importe_debe_ma;
					v_aux_heber = v_record_mov.acreedor + v_record_mov.importe_haber_mt + v_record_mov.importe_haber_ma;

                   
                   -- si moneda base y doalres es igual a cero, ignora si tiene saldo en UFV
                   IF   v_record_mov.deudor = v_record_mov.acreedor   AND  v_record_mov.importe_debe_mt =  v_record_mov.importe_haber_mt  THEN
                          
                            v_sw_actualiza = false;  --SALDO ES IGUAL A CERO

                   ELSE
                         
                        IF v_record_mov.deudor = v_record_mov.acreedor THEN
                     
                          --Si saldo en bolivianos es cero pero tenemos saldo en dolares
                               
                             IF(v_record_mov.importe_debe_mt < v_record_mov.importe_haber_mt  )    THEN

                                              v_sw_saldo_acredor = false;
                                              v_sw_actualiza = true;
                                              v_saldo_mb = 0;
                                              v_saldo_ma = v_record_mov.importe_haber_ma - v_record_mov.importe_debe_ma;
                                              v_saldo_mt = v_record_mov.importe_haber_mt - v_record_mov.importe_debe_mt;

                             ELSE

                                             v_sw_saldo_acredor = true;
                                             v_sw_actualiza = true;
                                             v_saldo_mb = 0;
                                             v_saldo_ma = v_record_mov.importe_debe_ma - v_record_mov.importe_haber_ma;
                                             v_saldo_mt = v_record_mov.importe_debe_mt - v_record_mov.importe_haber_mt;


                             END IF;
                        
                        
                        ELSE   
                               IF(v_record_mov.deudor < v_record_mov.acreedor  )    THEN

                                              v_sw_saldo_acredor = false;
                                              v_sw_actualiza = true;
                                              v_saldo_mb = v_record_mov.acreedor - v_record_mov.deudor;
                                              v_saldo_ma = v_record_mov.importe_haber_ma - v_record_mov.importe_debe_ma;
                                              v_saldo_mt = v_record_mov.importe_haber_mt - v_record_mov.importe_debe_mt;

                               ELSE

                                             v_sw_saldo_acredor = true;
                                             v_sw_actualiza = true;
                                             v_saldo_mb = v_record_mov.deudor - v_record_mov.acreedor;
                                             v_saldo_ma = v_record_mov.importe_debe_ma - v_record_mov.importe_haber_ma;
                                             v_saldo_mt = v_record_mov.importe_debe_mt - v_record_mov.importe_haber_mt;


                               END IF;
                           END IF;
                    END IF;





                   IF v_sw_actualiza THEN

                            v_importe_debe = 0;
                            v_importe_haber = 0;
                            v_importe_debe_ma= 0;
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
                          ELSE


                                    v_importe_haber = v_saldo_mb;
                                    v_importe_debe 	= 0;

                                    v_importe_haber_ma  = v_saldo_ma;
                                    v_importe_debe_ma	= 0;

                                    v_importe_haber_mt 	= v_saldo_mt;
                                    v_importe_debe_mt 	= 0;


                         END IF;
                         
                         --------------------------------------------------
                         --  recupera cuentas para la siguiente gestion
                         -------------------------------------------------

                         IF(v_record_mov.id_cuenta <> 0)THEN
                               IF(NOT EXISTS (select 1
                                              from conta.tcuenta_ids id
                                              where id.id_cuenta_uno = v_record_mov.id_cuenta))THEN


                                       v_error = true;
                                       v_tmp =  v_tmp||format('<BR> NO HAY UN REPLICACION DE LA CUENTA %s',(select cu.nro_cuenta ||' - '||cu.nombre_cuenta
                                                                                                    from conta.tcuenta cu
                                                                                                     where cu.id_cuenta = v_record_mov.id_cuenta)::varchar);
                               ELSE

                                      select id.id_cuenta_dos
                                              into
                                              v_id_cuenta_sg
                                      from conta.tcuenta_ids id
                                      where id.id_cuenta_uno = v_record_mov.id_cuenta;
                               END IF;
                         END IF;
                        
                        -----------------------------------------------------------
                        --  recupera centro de costos para la siguiente gestion
                        -----------------------------------------------------------
                       
                        IF(v_record_mov.id_centro_costo <> 0)THEN
                            IF(NOT EXISTS (select 1
                                    from pre.tpresupuesto_ids ipe
                                    where ipe.id_presupuesto_uno = v_record_mov.id_centro_costo))THEN

                                   v_error = true;
                                   v_tmp =  v_tmp||format( '<BR> NO HAY UN REPLICACION DEL CENTRO COSTO %s id (%s) saldos (BS %s, USD %s, UFV %s)',(select pres.descripcion
                                                                                                              from pre.tpresupuesto pres
                                                                                                              where pres.id_presupuesto = v_record_mov.id_centro_costo)::varchar,
                                                                                                              v_record_mov.id_centro_costo::varchar ,v_saldo_mb , v_saldo_mt, round(v_saldo_ma,2));
                             ELSE

                                    select ipe.id_presupuesto_dos
                                    into
                                            v_id_centro_costo_sg
                                    from pre.tpresupuesto_ids ipe
                                    where ipe.id_presupuesto_uno = v_record_mov.id_centro_costo;

                             END IF;
                       END IF;

                    
                      ----------------------
                      -- define  partida
                      ----------------------

                      IF  v_record_mov.id_partida = 0 THEN
                            IF v_sw_saldo_acredor THEN
                               v_id_partida = v_id_partida_debe;
                             ELSE
                               v_id_partida = v_id_partida_haber;
                             END IF;
                      END IF;
                      
                      ----------------------------------------------------------
                      -- Insertta la transaccion en el cbte de apertura
                      ----------------------------------------------------------
                     IF not v_error THEN 
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
                                        ) values (                                        
                                             v_id_partida,
                                             v_id_centro_costo_sg,
                                            'activo',
                                             v_id_cuenta_sg,
                                            'Asiento de Apertura',
                                             p_id_int_comprobante,
                                             case
                                              when v_record_mov.id_auxiliar = 0 then
                                                  null
                                              else
                                                  v_record_mov.id_auxiliar
                                              end,
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
                         END IF;
                     END IF;
                END IF;
    END LOOP;
    
    IF v_error THEN
       raise exception 'Para continuar solucione lo siguient:  %',v_tmp;  
    END IF;

     IF not v_sw_minimo THEN
       raise exception 'No se actualizo ninguna cuenta';
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
COST 100;