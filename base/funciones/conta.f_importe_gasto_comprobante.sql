CREATE OR REPLACE FUNCTION conta.f_importe_gasto_comprobante (
  p_id_int_comprobante integer
)
RETURNS numeric AS
$body$
DECLARE
v_importe_comprobante	numeric;
BEGIN
  select sum((tra.importe_gasto /(1 - tra.factor_reversion)))::numeric into v_importe_comprobante
from conta.tint_transaccion tra
where tra.id_int_comprobante=p_id_int_comprobante
and tra.id_partida_ejecucion_dev is not null;

return v_importe_comprobante;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;