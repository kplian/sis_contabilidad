CREATE OR REPLACE FUNCTION conta.f_get_cuenta_ids (
  p_id_cuenta integer,
  p_tipo varchar = 'siguiente'::character varying
)
RETURNS integer AS
$body$
/*
Autor: RCM
Fecha: 09/12/2013
Descripción: Función que devuelve el id_cuenta equivalente anterior o siguiente de la tabla conta.tcuenta_ids
*/

DECLARE

	v_id_cuenta integer;

BEGIN

	if p_id_cuenta is null then
    	return null;
    end if;
	--1.Verificación de existencia de cuenta
    if not exists(select 1 from conta.tcuenta
    			where id_cuenta = p_id_cuenta) then
    	raise exception 'Cuenta inexistente';
    end if;
    
    --Se verifica si se busca la cuenta anterior o la siguiente
    if p_tipo = 'siguiente' then
    	--Obtiene la cuenta de la siguiente gestión
        select c.id_cuenta_dos
        into v_id_cuenta
        from conta.tcuenta_ids c
        where c.id_cuenta_uno = p_id_cuenta;
    else
    	--Obtiene la cuenta anterior
        select c.id_cuenta_uno
        into v_id_cuenta
        from conta.tcuenta_ids c
        where c.id_cuenta_dos = p_id_cuenta;
    end if;
    
    return v_id_cuenta;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;