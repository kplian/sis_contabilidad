--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_configuracion_plantilla_reporte (
  p_nro_cuenta varchar,
  p_tipo varchar,
  p_saldo_inicial varchar,
  p_saldo_anterior varchar,
  p_id_gestion integer,
  p_periodo integer,
  p_periodo_tipo varchar
)
RETURNS numeric AS
$body$
DECLARE
   v_nombre_funcion   	text;
   v_resp    			varchar;
   v_mensaje 			varchar;
   v_id_cuenta			integer;
   v_monto				numeric;
BEGIN
  v_nombre_funcion = 'conta.f_configuracion_plantilla_reporte';
  
  	WITH RECURSIVE cuenta_rec (id_cuenta,nro_cuenta, nombre_cuenta ,id_cuenta_padre) AS (
                           	 	select 	cue.id_cuenta,
                                		cue.nro_cuenta,
                                        cue.nombre_cuenta, 
                                        cue.id_cuenta_padre
                            	from conta.tcuenta cue
                            	where cue.id_cuenta in ((select cu.id_cuenta
                                                          from conta.tcuenta cu 
                                                          where cu.nro_cuenta in (p_nro_cuenta)
                                                          and cu.id_gestion = p_id_gestion)) and cue.estado_reg = 'activo'
                          		union all
                                select 	cue2.id_cuenta,
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
                              

	IF ( p_periodo = 1 and  p_saldo_inicial = 'si')THEN             
                    select   (case
                when p_tipo = 'saldo' then
               		COALESCE(sum(tra.importe_debe_mb),0)::numeric - COALESCE(sum(tra.importe_haber_mb),0)::numeric 
               when p_tipo  = 'debe' then
               		COALESCE(sum(tra.importe_debe_mb),0)::numeric 
               when p_tipo  = 'haber' then
                	COALESCE(sum(tra.importe_haber_mb),0)::numeric 
                end::numeric ) as monto
                into
                v_monto
                from conta.tint_transaccion tra
                inner join conta.tint_comprobante icb on icb.id_int_comprobante = tra.id_int_comprobante
                inner join param.tperiodo pe on pe.id_periodo = icb.id_periodo
                where icb.estado_reg = 'validado' and  tra.id_cuenta in (v_id_cuenta)  and pe.id_gestion = p_id_gestion
                and  pe.periodo = p_periodo
                and icb.cbte_apertura = 'si';
          
      ELSE     
              if (p_periodo_tipo = 'un_mes_despues') then
              select   (case
                        when p_tipo = 'saldo' then
                            COALESCE(sum(tra.importe_debe_mb),0)::numeric - COALESCE(sum(tra.importe_haber_mb),0)::numeric 
                       when p_tipo  = 'debe' then
                            COALESCE(sum(tra.importe_debe_mb),0)::numeric 
                       when p_tipo  = 'haber' then
                            COALESCE(sum(tra.importe_haber_mb),0)::numeric 
                        end::numeric ) as monto
                        into
                        v_monto
                      from conta.tint_transaccion tra
                      inner join conta.tint_comprobante icb on icb.id_int_comprobante = tra.id_int_comprobante
                      inner join param.tperiodo pe on pe.id_periodo = icb.id_periodo
                      where icb.estado_reg = 'validado' and  tra.id_cuenta in (v_id_cuenta)  and pe.id_gestion = p_id_gestion
                      and pe.periodo < p_periodo;
                   
              else
              if (p_nro_cuenta = '2.1.3.01.001.001')then
              
                  select   (case
                        when p_tipo = 'saldo' then
                            COALESCE(sum(tra.importe_debe_mb),0)::numeric - COALESCE(sum(tra.importe_haber_mb),0)::numeric 
                       when p_tipo  = 'debe' then
                            COALESCE(sum(tra.importe_debe_mb),0)::numeric 
                       when p_tipo  = 'haber' then
                            COALESCE(sum(tra.importe_haber_mb),0)::numeric 
                        end::numeric ) as monto
                        into
                        v_monto
                      from conta.tint_transaccion tra
                      inner join conta.tint_comprobante icb on icb.id_int_comprobante = tra.id_int_comprobante
                      inner join param.tperiodo pe on pe.id_periodo = icb.id_periodo
                      where icb.estado_reg = 'validado' and  tra.id_cuenta in (v_id_cuenta)  and pe.id_gestion = p_id_gestion
                      and pe.periodo = p_periodo  and icb.cbte_apertura = 'no' and  icb.momento = 'contable';
              
              else
              
                  select   (case
                        when p_tipo = 'saldo' then
                            COALESCE(sum(tra.importe_debe_mb),0)::numeric - COALESCE(sum(tra.importe_haber_mb),0)::numeric 
                       when p_tipo  = 'debe' then
                            COALESCE(sum(tra.importe_debe_mb),0)::numeric 
                       when p_tipo  = 'haber' then
                            COALESCE(sum(tra.importe_haber_mb),0)::numeric 
                        end::numeric ) as monto
                        into
                        v_monto
                      from conta.tint_transaccion tra
                      inner join conta.tint_comprobante icb on icb.id_int_comprobante = tra.id_int_comprobante
                      inner join param.tperiodo pe on pe.id_periodo = icb.id_periodo
                      where icb.estado_reg = 'validado' and  tra.id_cuenta in (v_id_cuenta)  and pe.id_gestion = p_id_gestion
                      and pe.periodo = p_periodo  and icb.cbte_apertura = 'no' ;
          
              end if;
              end if;
	 END IF;

		RETURN v_monto;
  
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