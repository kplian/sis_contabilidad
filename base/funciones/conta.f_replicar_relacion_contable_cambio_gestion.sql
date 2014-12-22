--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_replicar_relacion_contable_cambio_gestion (
  p_id_relacion_contable integer,
  p_id_usuario integer
)
RETURNS varchar AS
$body$
/*
Autor: RCM  -  KPLIAN
Fecha: 09/12/2013
Descripción:Función para replicar la parametrización de todas las relaciones contable para una siguiente gestión

Procedimiento:

para replicacion de parametrizacion de las relaciones contable
1.crear nueva gestion en pxp
2.asegurarse de la migracion de cuentas, partidas y presupuestos
3.asegurarse de la migracion de cuenta_ids, partida_ids y presupuestos_ids
4.ejecutar replicacion
--------------------------
MODIFICACIONES

Autor: RAC  - KPLIAN
Fecha: 2/12/2014
Descripción: Se reformula la logica del algoritmo , para no tener errores, ahrao la funcion se llala desde la interfaces de relacion contable

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
    v_id_gestion_destino  	integer;
    v_id_gestion_origen  	integer;
    v_registros_rc 			record;
    v_registros_ges        	record;
    v_retorno				varchar[];
    v_check 				boolean;

BEGIN

	v_nombre_funcion = 'conta.f_replicar_relacion_contable_cambio_gestion';
    v_cont=0;
    v_cant_total=0;
    
    
    --  p_id_relacion_contable
    
    --  recuperar el id de la gestion actual
    
      select 
        rc.id_gestion,
        rc.id_tipo_relacion_contable,
        trc.nombre_tipo_relacion,
        tab.esquema,
        tab.tabla,
        tab.tabla_id,
        tab.id_tabla_relacion_contable
      into
       v_registros_rc
      from conta.trelacion_contable rc
      inner join conta.ttipo_relacion_contable trc on trc.id_tipo_relacion_contable = rc.id_tipo_relacion_contable 
      left join conta.ttabla_relacion_contable tab on tab.id_tabla_relacion_contable = trc.id_tabla_relacion_contable
      where rc.id_relacion_contable = p_id_relacion_contable;
      
      v_id_gestion_origen = v_registros_rc.id_gestion;
    
    --  definir id de la gestion siguiente
    
     select
     	ges.id_gestion,
     	ges.gestion,
        ges.id_empresa
     into 
     	v_registros_ges
     from 
     param.tgestion ges
     where ges.id_gestion = v_id_gestion_origen;
    
    
    
     select
     	ges.id_gestion
     into 
     	v_id_gestion_destino
     from 
     param.tgestion ges
     where       ges.gestion = v_registros_ges.gestion + 1 
             and ges.id_empresa = v_registros_ges.id_empresa 
             and ges.estado_reg = 'activo';
    

     if v_id_gestion_destino is null then
       raise exception 'La gestión destino no existe (%)', v_registros_ges.gestion + 1;
     end if;
    
    --3.Recorrer todas las Relaciones Contables de la gestión
    v_obs_gral='';
    --raise exception '%',p_id_gestion_origen;
    for v_rec in (
                  select rc.*,
    			         c.nro_cuenta || ' ' || c.nombre_cuenta as cuenta,
                         pa.codigo || ' ' || pa.nombre_partida as partida,
                         ce.codigo_cc,
                         COALESCE(tab.tabla,'--') as tabla,
                         trc.nombre_tipo_relacion 
    			  from conta.trelacion_contable rc
                   
                   inner join conta.ttipo_relacion_contable trc on trc.id_tipo_relacion_contable = rc.id_tipo_relacion_contable 
                   left join conta.tcuenta c on c.id_cuenta = rc.id_cuenta
                   left join conta.ttabla_relacion_contable tab on tab.id_tabla_relacion_contable = trc.id_tabla_relacion_contable
                   left join pre.tpartida pa on pa.id_partida = rc.id_partida
                   left join param.vcentro_costo ce on ce.id_centro_costo = rc.id_centro_costo
    			  where      rc.id_gestion = v_id_gestion_origen
                        and  ((rc.id_tipo_relacion_contable = v_registros_rc.id_tipo_relacion_contable and trc.id_tabla_relacion_contable is NULL)
                               or (tab.id_tabla_relacion_contable = v_registros_rc.id_tabla_relacion_contable and tab.id_tabla_relacion_contable is not null))
                        and  rc.estado_reg = 'activo'                 
                   
                  ) loop
    	
  
    
        v_obs='';
		v_cant_total = v_cant_total + 1;
        v_id_presupuesto = NULL;
        v_id_partida = NULL;
        v_id_cuenta = NULL;
		
        --Obtiene las siguientes IDs de las cuentas, partidas y presupuestos, basado en las tablas de equivalencias de endesis
        if v_rec.id_cuenta is not null then
        	v_id_cuenta = conta.f_get_cuenta_ids(v_rec.id_cuenta);
            if v_id_cuenta is null then
        		v_obs = v_obs || '\n- No existe Cuenta en la nueva gestión para la cuenta: '||coalesce(v_rec.cuenta,'S/C');
            else
            	--Verifica que la cuenta sea de la gestion indicada
                select id_gestion into v_id_gestion_aux from conta.tcuenta where id_cuenta = v_id_cuenta;
                if v_id_gestion_aux != v_id_gestion_destino then
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
                if v_id_gestion_aux != v_id_gestion_destino then
                    v_obs = v_obs || '\n- La gestion de la partida nueva encontrada: '||coalesce(v_rec.partida,'S/C')||', no coincide con la gestion destino';
                end if;
            end if;
        end if;
        
        
        --suponemos que el id de presupuesto siemrpe es igual al id del centor de costo
        if v_rec.id_centro_costo is not null then
        	v_id_presupuesto = pre.f_get_presupuesto_ids(v_rec.id_centro_costo);
            if v_id_presupuesto is null then
                v_obs = v_obs || '\n- No existe Presupuesto en la nueva gestión para el Presupuesto: '||coalesce(v_rec.codigo_cc,'S/C');
            else
            	select id_gestion into v_id_gestion_aux from param.tcentro_costo where id_centro_costo = v_id_presupuesto;
                if v_id_gestion_aux != v_id_gestion_destino then
                    v_obs = v_obs || '\n- La gestion del presupuesto nuevo encontrado: '||coalesce(v_rec.codigo_cc,'S/C')||', no coincide con la gestion destino';
                end if;
            end if;
        end if;
        
        
        
        if v_obs = '' then
			 
            
               v_check = true;
              -- validar que la relacion contable no se duplique en el destino
              if exists (  select 1
                            from conta.trelacion_contable rc
                            where 
                                  (id_tipo_relacion_contable = v_rec.id_tipo_relacion_contable or (id_tipo_relacion_contable is null and  v_rec.id_tipo_relacion_contable is null )) and
                                  (id_centro_costo =  v_id_presupuesto or (id_centro_costo is null and  v_id_presupuesto is null)) and
                                  (id_cuenta = v_id_cuenta  or (id_cuenta is null and v_id_cuenta is null )) and
                                  (id_auxiliar = v_rec.id_auxiliar  or ( id_auxiliar is null and v_rec.id_auxiliar is null)) and
                                  (id_partida = v_id_partida  or (id_partida is null and v_id_partida is null)) and
                                  id_gestion = v_id_gestion_destino  and
                                  (id_tabla = v_rec.id_tabla  or (id_tabla is null and v_rec.id_tabla is null)) and
                                  defecto =  v_rec.defecto  and
                                  estado_reg = 'activo' ) then
              
                v_check = FALSE;
              end if;
            
               v_rec.id_gestion = v_id_gestion_destino;
               v_rec.id_cuenta = v_id_cuenta;
               v_rec.id_partida = v_id_partida;
               v_rec.id_centro_costo = v_id_presupuesto;
            
              if v_check then
                 --si la relacion no exite la insertamos
                 v_retorno = conta.f_inserta_relacion_contable(hstore(v_rec), p_id_usuario); 
                  --validamos el retorni
                 if v_retorno[1] = 'falla' then
                     v_obs = v_obs || '\n- Error al insertar   relacion contable:   '||coalesce(v_rec.nombre_tipo_relacion,'S/C')||', CC: '||coalesce(v_rec.codigo_cc,'S/C')||', Partida: '||coalesce(v_rec.partida,'S/C')||', Cuenta: '||coalesce(v_rec.cuenta,'S/C')||' Mensaje '||COALESCE(v_retorno[2], 'NAN');
                 else
                     v_cont = v_cont + 1;
                 end if;
              else
                   --ya existe la relacion contable  
                   v_obs = v_obs || '\n-Ya existe la relacion contable:   '||coalesce(v_rec.nombre_tipo_relacion,'S/C')||', CC: '||coalesce(v_rec.codigo_cc,'S/C')||', Partida: '||coalesce(v_rec.partida,'S/C')||', Cuenta: '||coalesce(v_rec.cuenta,'S/C')||' Mensaje '||COALESCE(v_retorno[2], 'NAN');
                 
        
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