--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_trig_int_transaccion_defore (
)
RETURNS trigger AS
$body$
DECLARE
  v_registros_con 	 record;
  v_registros		 record;
BEGIN
 
    
    
    NEW.orden = NEW.id_int_transaccion;

   RETURN NEW;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;