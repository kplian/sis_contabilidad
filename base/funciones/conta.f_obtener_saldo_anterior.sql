--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_obtener_saldo_anterior (
  p_id_cuenta integer,
  p_id_gestion integer,
  p_mes integer
)
RETURNS numeric AS
$body$
DECLARE
    v_nombre_funcion   	text;
    v_resp    			varchar;
    v_mensaje 			varchar;
    v_record		record;
BEGIN
	 v_nombre_funcion = 'conta.f_obtener_saldo_anterior';

select    COALESCE(sum(transa.importe_debe_mb),0)::numeric - COALESCE(sum(transa.importe_haber_mb),0)::numeric as saldo_mb
		into 
        v_record
          from conta.tint_transaccion transa
          inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
          inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
		  where icbte.estado_reg = 'validado' and 
          transa.id_cuenta in (p_id_cuenta) and 
          extract(MONTH from icbte.fecha::date) < p_mes and 
          per.id_gestion = p_id_gestion;

	return v_record.saldo_mb;

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