CREATE OR REPLACE FUNCTION conta.f_plantilla_cierre_balance (
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
 FUNCION: 		conta.f_plantilla_cierre_balance
 DESCRIPCION:   Funcion que devuelve conjuntos suma por centro de costos
 AUTOR: 		 (MMV)
 FECHA:	        19/12/2018
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
 ISSUE 		   FECHA   			 AUTOR				    DESCRIPCION:
  #4       20/12/2018    Miguel Mamani     Plantilla de cierre de balance 


***************************************************************************/
DECLARE
	v_nombre_funcion   				text;
 	v_resp							varchar;
	v_record						record;
    v_sw_actualiza    				boolean;

    v_importe_debe					numeric;
    v_importe_haber				    numeric;
    v_saldo_mb   					numeric;

    v_reg_cbte						record;
    v_sw_minimo						boolean;
    v_partida_debe					integer;
  	v_partida_haber					integer;
  	v_id_centro_costo_depto  		integer;
  	v_record_mov					record;

    v_saldo_mt							numeric;
    v_saldo_ma							numeric;

    v_importe_debe_ma					numeric;
    v_importe_haber_ma				    numeric;
    v_importe_debe_mt					numeric;
    v_importe_haber_mt				    numeric;

    v_sw_saldo_acredor 					boolean;

    v_aux_debe		numeric;
    v_aux_heber		numeric;
   	v_id_partida    integer;
BEGIN

 	v_nombre_funcion = 'conta.f_plantilla_cierre_balance';

      select  *
              into
              v_reg_cbte
      from conta.tint_comprobante
      where id_int_comprobante = p_id_int_comprobante;

	  FOR v_record_mov in ( with basica as (select 	t.id_centro_costo,
                                                    t.id_cuenta,
                                                    COALESCE(t.id_auxiliar,0) as id_auxiliar,
                                                    /*case
                                                       when par.id_partida is not NULL then
                                                         par.id_partida
                                                        else
                                                           0
                                                        end as id_partida,*/
                                                    case
                                                       when  par.sw_movimiento = 'presupuestaria' then
                                                         par.id_partida
                                                        else
                                                           0
                                                        end as id_partida,    
                                                        
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
                                              where cb.estado_reg = 'validado'  and tc.tipo_cuenta in ('activo','patrimonio','pasivo')
                                              and pe.id_gestion = p_id_gestion_cbte and  cb.fecha::date BETWEEN p_desde and p_hasta),
                                saldo as (   select t.id_centro_costo,
                                                      t.id_cuenta,
                                                      t.id_auxiliar,
                                                      t.id_partida,
                                                      sum(COALESCE(t.importe_debe_mb,0)) as importe_debe_mb,
                                                      sum(COALESCE(t.importe_haber_mb,0)) as importe_haber_mb,
                                                      
                                                      (sum(COALESCE(t.importe_debe_mb,0)) - sum(COALESCE(t.importe_haber_mb,0))) as saldo_mb,
                                                      
                                                      sum(COALESCE(t.importe_debe_mt,0)) as importe_debe_mt,
                                                      sum(COALESCE(t.importe_haber_mt,0)) as importe_haber_mt,
                                                      
                                                      (sum(COALESCE(t.importe_debe_mt,0)) - sum(COALESCE(t.importe_haber_mt,0)) )as saldo_mt,
                                                      
                                                      sum(COALESCE(t.importe_debe_ma,0)) as importe_debe_ma,
                                                      sum(COALESCE(t.importe_haber_ma,0))as importe_haber_ma,
                                                      
                                                      (sum(COALESCE(t.importe_debe_ma,0)) - sum(COALESCE(t.importe_haber_ma,0)) ) as saldo_ma
                                                      from basica t
                                                      group by
                                                            t.id_centro_costo,
                                                            t.id_cuenta,
                                                            t.id_auxiliar,
                                                            t.id_partida)
                                                            select  t.id_centro_costo,
                                                                    t.id_cuenta,
                                                                    t.id_auxiliar,
                                                                    t.id_partida,
                                                                    t.importe_debe_mb as deudor,--MB
                                                                    t.importe_haber_mb as acreedor,
                                                                    t.importe_debe_mt,--MT
                                                                    t.importe_haber_mt,
                                                                    t.importe_debe_ma,--MA
                                                                    t.importe_haber_ma
                                                            from saldo t  )LOOP


                    v_sw_actualiza = false;
                    v_sw_saldo_acredor = false;
                    
                    v_saldo_mb  = 0;
                    v_saldo_mt = 0;
                    v_saldo_ma = 0;

                    v_aux_debe = 0;
                    v_aux_heber = 0;

                    v_aux_debe = v_record_mov.deudor + v_record_mov.importe_debe_mt + v_record_mov.importe_debe_ma;
					v_aux_heber = v_record_mov.acreedor + v_record_mov.importe_haber_mt + v_record_mov.importe_haber_ma;
                    /*
                   
                   IF ( v_record_mov.deudor = v_record_mov.acreedor ) 
                       AND  ( v_record_mov.importe_debe_mt =  v_record_mov.importe_haber_mt)  
                        AND ( v_record_mov.importe_debe_ma = v_record_mov.importe_haber_ma)  
                         THEN          
                            
                            v_sw_actualiza = false;  --SALDO ES IGUAL A CERO 

                    ELSEIF (v_record_mov.deudor < v_record_mov.acreedor  or v_record_mov.deudor =  v_record_mov.acreedor)  
                        AND (v_record_mov.importe_debe_mt < v_record_mov.importe_haber_mt or v_record_mov.importe_debe_mt =  v_record_mov.importe_haber_mt)
                      --  AND  (v_record_mov.importe_debe_ma < v_record_mov.importe_haber_ma or v_record_mov.importe_debe_ma = v_record_mov.importe_haber_ma  )  
                        THEN

                                v_sw_saldo_acredor = true;
                                v_sw_actualiza = true;
                                v_saldo_mb = v_record_mov.acreedor - v_record_mov.deudor;
                                v_saldo_ma = v_record_mov.importe_haber_ma - v_record_mov.importe_debe_ma;
                                v_saldo_mt = v_record_mov.importe_haber_mt - v_record_mov.importe_debe_mt;

                     ELSEIF (v_record_mov.deudor > v_record_mov.acreedor or v_record_mov.deudor =  v_record_mov.acreedor  )  
                       AND  (v_record_mov.importe_debe_mt > v_record_mov.importe_haber_mt or v_record_mov.importe_debe_mt =  v_record_mov.importe_haber_mt) 
                       --  AND  (v_record_mov.importe_debe_ma > v_record_mov.importe_haber_ma or v_record_mov.importe_debe_ma = v_record_mov.importe_haber_ma) 
                          THEN

                               v_sw_saldo_acredor = false;
                               v_sw_actualiza = true;
                               v_saldo_mb = v_record_mov.deudor - v_record_mov.acreedor;
                               v_saldo_ma = v_record_mov.importe_debe_ma - v_record_mov.importe_haber_ma;
                               v_saldo_mt = v_record_mov.importe_debe_mt - v_record_mov.importe_haber_mt;

                     ELSE
                        raise exception  ' %,% ,% , %, %, %  SALDOS NEGATIVOS  % , %, %, %', v_record_mov.deudor,
                                                                                             v_record_mov.acreedor, 
                                                                                              v_record_mov.importe_debe_ma, 
                                                                                              v_record_mov.importe_haber_ma, 
                                                                                              v_record_mov.importe_debe_mt ,  
                                                                                              v_record_mov.importe_haber_mt,   
                                                                                               v_record_mov.id_centro_costo , 
                                                                                               v_record_mov.id_cuenta,
                                                                                               v_record_mov.id_auxiliar,v_record_mov.id_partida
                                                                                               ;
                        --v_sw_actualiza = false;
                     END IF;*/


                   IF ( v_record_mov.deudor = v_record_mov.acreedor ) 
                       AND  ( v_record_mov.importe_debe_mt =  v_record_mov.importe_haber_mt)  
                         AND ( v_record_mov.importe_debe_ma = v_record_mov.importe_haber_ma)  
                         
                         THEN          
                            
                            v_sw_actualiza = false;  --SALDO ES IGUAL A CERO 

                    ELSEIF(v_record_mov.deudor < v_record_mov.acreedor  )    THEN

                                v_sw_saldo_acredor = true;
                                v_sw_actualiza = true;
                                v_saldo_mb = v_record_mov.acreedor - v_record_mov.deudor;
                                v_saldo_ma = v_record_mov.importe_haber_ma - v_record_mov.importe_debe_ma;
                                v_saldo_mt = v_record_mov.importe_haber_mt - v_record_mov.importe_debe_mt;

                   ELSE 

                               v_sw_saldo_acredor = false;
                               v_sw_actualiza = true;
                               v_saldo_mb = v_record_mov.deudor - v_record_mov.acreedor;
                               v_saldo_ma = v_record_mov.importe_debe_ma - v_record_mov.importe_haber_ma;
                               v_saldo_mt = v_record_mov.importe_debe_mt - v_record_mov.importe_haber_mt;

                     
                     END IF;


                    IF v_sw_actualiza THEN

                        v_importe_debe = 0;
                        v_importe_haber = 0;
                        
                        v_importe_debe_ma = 0;
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
                                    actualizacion,
                                    sw_edit
                                ) values(
                                    case
                                      when v_record_mov.id_partida = 0 then
                                          v_id_partida
                                      else
                                          v_record_mov.id_partida
                                      end,
                                    v_record_mov.id_centro_costo,
                                    'activo',
                                    v_record_mov.id_cuenta,
                                    'Asiento de Cierre de las Cuentas de Balance',
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
                                    'si',
                                    'si'
                                     );
                          

                ELSE
                  --  raise exception 'Error';
                END IF;

          END LOOP;


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
PARALLEL UNSAFE
COST 100;