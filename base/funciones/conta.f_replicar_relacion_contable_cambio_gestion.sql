CREATE OR REPLACE FUNCTION conta.f_replicar_relacion_contable_cambio_gestion (
  p_id_gestion_origen integer,
  p_id_gestion_destino integer
)
RETURNS varchar AS
$body$
/*
Autor: RCM
Fecha: 09/12/2013
Descripción:Función para replicar la parametrización de todas las relaciones contable para una siguiente gestión

Procedimiento:

para replicacion de parametrizacion de las relaciones contable
1.crear nueva gestion en pxp
2.asegurarse de la migracion de cuentas, partidas y presupuestos
3.asegurarse de la migracion de cuenta_ids, partida_ids y presupuestos_ids
4.ejecutar replicacion

*/

DECLARE

    v_id_cuenta integer;
    v_id_partida integer;
    v_id_presupuesto integer;
    v_obs text;
    v_rec record;
    v_id_gestion_aux integer;
    v_resp varchar;
    v_nombre_funcion varchar;
    v_cont integer;
    v_cant_total integer;
    v_obs_gral varchar;

BEGIN

	v_nombre_funcion = 'conta.f_replicar_relacion_contable_cambio_gestion';
    v_cont=0;
    v_cant_total=0;

	--1.Verificación de existencia de la gestión de origen
    if not exists(select 1 from param.tgestion
    			where id_gestion = p_id_gestion_origen) then
    	raise exception 'Gestión origen inexistente';
    end if;
    
    --2.Verificación de existencia de la gestión de origen
    if not exists(select 1 from param.tgestion
    			where id_gestion = p_id_gestion_destino) then
    	raise exception 'Gestión destino inexistente';
    end if;
    
    if p_id_gestion_origen = p_id_gestion_destino then
    	raise exception 'La gestiones origen y destino son iguales. Nada que hacer.';
    end if;
    
    --3.Recorrer todas las Relaciones Contables de la gestión
    v_obs_gral='';
    --raise exception '%',p_id_gestion_origen;
    for v_rec in (select rc.*,
    			c.nro_cuenta || ' ' || c.nombre_cuenta as cuenta,
                pa.codigo || ' ' || pa.nombre_partida as partida,
                ce.codigo_cc
    			from conta.trelacion_contable rc
                inner join conta.tcuenta c on c.id_cuenta = rc.id_cuenta
                left join pre.tpartida pa on pa.id_partida = rc.id_partida
                left join param.vcentro_costo ce on ce.id_centro_costo = rc.id_centro_costo
    			where rc.id_gestion = p_id_gestion_origen) loop
    	v_obs='';
		v_cant_total = v_cant_total + 1;
		--Obtiene las siguientes IDs de las cuentas, partidas y presupuestos, basado en las tablas de equivalencias de endesis
        if v_rec.id_cuenta is not null then
        	v_id_cuenta = conta.f_get_cuenta_ids(v_rec.id_cuenta);
            if v_id_cuenta is null then
        		v_obs = v_obs || '\n- No existe Cuenta en la nueva gestión para la cuenta: '||coalesce(v_rec.cuenta,'S/C');
            else
            	--Verifica que la cuenta sea de la gestion indicada
                select id_gestion into v_id_gestion_aux from conta.tcuenta where id_cuenta = v_id_cuenta;
                if v_id_gestion_aux != p_id_gestion_destino then
                    v_obs = v_obs || '\n- La gestion de la cuenta nueva encontrada: '||coalesce(v_rec.cuenta,'S/C')||', no coincide con la gestion destino';
                end if;
        	end if;
        end if;
        
        if v_rec.id_partida is not null then
        	v_id_partida = pre.f_get_partida_ids(v_rec.id_partida);
            if v_id_partida is null then
                v_obs = v_obs || '\n- No existe Partida en la nueva gestión para la partida: '||coalesce(v_rec.partida,'S/C');
            else
            	select id_gestion into v_id_gestion_aux from pre.tpartida where id_partida = v_id_partida;
                if v_id_gestion_aux != p_id_gestion_destino then
                    v_obs = v_obs || '\n- La gestion de la partida nueva encontrada: '||coalesce(v_rec.partida,'S/C')||', no coincide con la gestion destino';
                end if;
            end if;
        end if;
        
        if v_rec.id_centro_costo is not null then
        	v_id_presupuesto = param.f_get_presupuesto_ids(v_rec.id_centro_costo);
            if v_id_presupuesto is null then
                v_obs = v_obs || '\n- No existe Presupuesto en la nueva gestión para el Presupuesto: '||coalesce(v_rec.codigo_cc,'S/C');
            else
            	select id_gestion into v_id_gestion_aux from param.tcentro_costo where id_centro_costo = v_id_presupuesto;
                if v_id_gestion_aux != p_id_gestion_destino then
                    v_obs = v_obs || '\n- La gestion del presupuesto nuevo encontrado: '||coalesce(v_rec.codigo_cc,'S/C')||', no coincide con la gestion destino';
                end if;
            end if;
        end if;
        
        if v_obs = '' then
			v_cont = v_cont + 1; 
            if not exists(select 1 from conta.trelacion_contable
                        where id_tipo_relacion_contable = v_rec.id_tipo_relacion_contable
                        and id_cuenta = v_id_cuenta
                        and id_gestion = p_id_gestion_destino) then

                insert into conta.trelacion_contable(
                  id_usuario_reg,
                  fecha_reg,
                  estado_reg,
                  id_tipo_relacion_contable,
                  id_centro_costo,
                  id_cuenta,
                  id_auxiliar,
                  id_partida,
                  id_gestion,
                  id_tabla,
                  defecto
                ) 
                VALUES (
                  1,
                  now(),
                  'activo',
                  v_rec.id_tipo_relacion_contable,
                  v_id_presupuesto,
                  v_id_cuenta,
                  v_rec.id_auxiliar,
                  v_id_partida,
                  p_id_gestion_destino,
                  v_rec.id_tabla,
                  v_rec.defecto
                );
            end if;
        end if;
        
        v_obs_gral = v_obs_gral || v_obs;

    end loop;
    
    if v_obs_gral = '' then
    	v_obs_gral = 'Relación contable replicada con exito (total registros: '||v_cant_total::varchar||')';
    else 
    	v_obs_gral = 'Se replicaron: '||v_cont::varchar||' de '||v_cant_total::varchar||' Relaciones contables, y se tuvieron las siguientes observaciones: '||v_obs_gral;
    end if;
    
    return v_obs_gral;
    
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