--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_calcular_monto_nro_cuenta (
  p_nro_cuenta varchar,
  p_id_gestion integer,
  p_tipo varchar,
  p_partida varchar
)
RETURNS numeric AS
$body$
DECLARE
v_nombre_funcion		varchar;
v_resp					varchar;
v_monto 				numeric;
v_cuentas				varchar;
v_array			 		varchar [];
v_array_patida			varchar [];
v_partidas_ids			text;

BEGIN
v_nombre_funcion = 'conta.f_calcular_monto_nro_cuenta';

    v_array_patida = string_to_array(p_partida::varchar,',');  
          WITH RECURSIVE cuenta_rec (id_cuenta,nro_cuenta, nombre_cuenta ,id_cuenta_padre) AS (
                            SELECT cue.id_cuenta,cue.nro_cuenta,cue.nombre_cuenta, cue.id_cuenta_padre
                            FROM conta.tcuenta cue
                            WHERE cue.id_cuenta in ((select cu.id_cuenta
                                                    from conta.tcuenta cu 
                                                    where cu.nro_cuenta = ANY (string_to_array(p_nro_cuenta,','))
                                                    and cu.id_gestion = p_id_gestion )) and cue.estado_reg = 'activo'
                          UNION ALL
                            SELECT cue2.id_cuenta,cue2.nro_cuenta, cue2.nombre_cuenta, cue2.id_cuenta_padre
                            FROM cuenta_rec lrec 
                            INNER JOIN conta.tcuenta cue2 ON lrec.id_cuenta = cue2.id_cuenta_padre
                            where cue2.estado_reg = 'activo'
                          )select pxp.list(id_cuenta::varchar)
                          into
                          v_cuentas
                          from cuenta_rec;
          
                        v_array = string_to_array(v_cuentas,',');
                        
                        
                        
                        select pxp.list(pa.id_partida::text) 
                            into v_partidas_ids
                          from pre.tpartida pa
                          where pa.id_gestion = p_id_gestion and pa.codigo = ANY (v_array_patida);
          
           select (case
                      when p_tipo = 'saldo'then
                     COALESCE(sum(transa.importe_debe_mb),0)::numeric - COALESCE(sum(transa.importe_haber_mb),0)::numeric 
                     when p_tipo = 'debe'then
                     COALESCE(sum(transa.importe_debe_mb),0)::numeric 
                     when p_tipo = 'haber'then
                      COALESCE(sum(transa.importe_haber_mb),0)::numeric 
                      end::numeric ) as monto
                      into
                      v_monto
                     from conta.tint_transaccion transa
                     inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                     inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
                     where  icbte.estado_reg = 'validado' and
                            transa.id_cuenta::varchar = ANY (v_array) and
                            per.id_gestion = p_id_gestion and
                           (icbte.fecha::date BETWEEN '%01/01/2018%'::date and '%30/04/2018%'::date)and case
                                        when v_partidas_ids = '' or v_partidas_ids is null then
                                  		0=0
                                        else
                                   transa.id_partida::varchar = ANY (string_to_array(v_partidas_ids::varchar,','))
                                   end;

      return v_monto;
      
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
STABLE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;