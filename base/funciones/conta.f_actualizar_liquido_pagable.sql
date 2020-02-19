create or replace function conta.f_actualizar_liquido_pagable() returns trigger
    language plpgsql
as
$$

DECLARE
    v_monto_total        DECIMAL;
    v_id_int_comprobante INTEGER;
    v_resp               VARCHAR;
    v_record             RECORD;
BEGIN

    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
        v_record = NEW;
    ELSEIF TG_OP = 'DELETE' THEN
        v_record = OLD;
    end if;

    SELECT sum(transa.importe_haber)
    into v_monto_total
    FROM conta.tint_transaccion transa
             left join pre.tpartida par on par.id_partida = transa.id_partida
    where id_int_comprobante = v_record.id_int_comprobante
      and par.codigo in ('21100');

    UPDATE conta.tint_comprobante cbte
    SET liquido_pagable = v_monto_total
    where cbte.id_int_comprobante = v_record.id_int_comprobante;

    return v_record;
EXCEPTION

    WHEN OTHERS
        THEN
            v_resp = '';
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', SQLERRM);
            v_resp = pxp.f_agrega_clave(v_resp, 'codigo_error', SQLSTATE);
            RAISE EXCEPTION '%', v_resp;
END;
$$;

alter function conta.f_actualizar_liquido_pagable() owner to postgres;

