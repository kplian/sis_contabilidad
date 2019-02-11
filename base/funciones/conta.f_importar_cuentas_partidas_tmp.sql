--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_importar_cuentas_partidas_tmp (
)
RETURNS boolean AS
$body$
DECLARE
  v_tabla varchar;
  v_params VARCHAR [ ];
  v_resp varchar;

  v_registros record;
  v_registros_par record;
  v_id_tipo_estado integer;
  v_id_estado_actual integer;
  v_id_proceso_wf integer;
  v_id_estado_wf integer;

BEGIN

  for v_registros in (
  select c.id_cuenta
  from conta.tcuenta c
  where c.id_gestion=2 and c.sw_transaccional='movimiento')
  LOOP
  
    v_tabla = pxp.f_crear_parametro(ARRAY['estado_reg','sw_deha','id_partida','se_rega','id_cuenta','_nombre_usuario_ai','_id_usuario_ai'],
      ARRAY[''::varchar,--estado_reg
      'debe'::varchar,--sw_deha
      1121::varchar,--id_partida
      'recurso'::varchar,--se_rega
      v_registros.id_cuenta::varchar,--id_cuenta
      ''::varchar,
      ''::varchar
      ],
      ARRAY['varchar','varchar','int4','varchar','int4','varchar','int4']
    );
    --Insertamos el registro
    v_resp = conta.ft_cuenta_partida_ime(1, 1, v_tabla, 'CONTA_CUPA_INS');
    
    v_tabla = pxp.f_crear_parametro(ARRAY['estado_reg','sw_deha','id_partida','se_rega','id_cuenta','_nombre_usuario_ai','_id_usuario_ai'],
      ARRAY[''::varchar,--estado_reg
      'debe'::varchar,--sw_deha
      1122::varchar,--id_partida
      'recurso'::varchar,--se_rega
      v_registros.id_cuenta::varchar,--id_cuenta
      ''::varchar,
      ''::varchar
      ],
      ARRAY['varchar','varchar','int4','varchar','int4','varchar','int4']
    );
    --Insertamos el registro
    v_resp = conta.ft_cuenta_partida_ime(1, 1, v_tabla, 'CONTA_CUPA_INS');

  END LOOP;
  raise exception 'revisar la gestión de la consulta';
  return true;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;