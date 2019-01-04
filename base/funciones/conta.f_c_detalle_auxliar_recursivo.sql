CREATE OR REPLACE FUNCTION conta.f_c_detalle_auxliar_recursivo (
  p_nivel integer
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.f_c_detalle_auxliar_recursivo
 DESCRIPCION:   Funcion que devuelve conjuntos suma recursiva
 AUTOR: 		 (MMV)
 FECHA:	        19/12/2018
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
 ISSUE 		   FECHA   			 AUTOR				 DESCRIPCION:
 #23        27/12/2018    Miguel Mamani     		Reporte Detalle Auxiliares por Cuenta


***************************************************************************/
DECLARE

v_registros 				record;
v_nombre_funcion   			text;
v_resp						varchar;
v_sw_force					boolean;
v_id_tipo_cc_fk_abuelo 		integer;

BEGIN

    v_nombre_funcion = 'conta.f_c_detalle_auxliar_recursivo';

    --raise notice 'lamada recursiva.........................';
    v_sw_force = false;  --para criterio de parada
    v_id_tipo_cc_fk_abuelo = null;
    FOR  v_registros in (select  tm.id_auxiliar_fk,
                                 cu.id_cuenta_padre as id_tipo_aux_fk_abuelo,
                                 cu.nro_cuenta ||' ('||cu.nombre_cuenta||')' as codigo_aux_abuelo,
                                 cu.nro_cuenta,
                                 sum(tm.importe_debe_mb) as importe_debe_mb,
                                 sum(tm.importe_haber_mb) as importe_haber_mb,
                                 (sum(tm.importe_debe_mb) - sum(tm.importe_haber_mb)) as saldo_mb
                         from tmp_prog tm
                         inner join conta.tcuenta cu on cu.id_cuenta = tm.id_auxiliar_fk
                         where case
                                     when p_nivel = 1 then
                                    	tm.nivel  = p_nivel + 1
                         	    end
                         group by  tm.id_auxiliar_fk,
                                   cu.id_cuenta_padre,
                                   cu.nro_cuenta,
                                   cu.nombre_cuenta)LOOP

  insert into tmp_prog ( id_auxiliar_cc,
                         id_auxiliar_fk,
                         codigo_aux,
                         codigo,
                         importe_debe_mb,
                         importe_haber_mb,
                         saldo_mb,
                         nivel,
                         sw_tipo
                           )
                           values (
                           v_registros.id_auxiliar_fk,
                           v_registros.id_tipo_aux_fk_abuelo,
                           v_registros.codigo_aux_abuelo,
                           v_registros.nro_cuenta,
                           v_registros.importe_debe_mb,
                           v_registros.importe_haber_mb,
                           v_registros.saldo_mb,
                           p_nivel,
                           'titulo'
                           );
      v_sw_force = true;

   END LOOP;
   -- si tenemos mas datos para procesar hacemos la llamada recursiva
    IF v_sw_force THEN
      if p_nivel > 0 then
         PERFORM conta.f_c_detalle_auxliar_recursivo( p_nivel -1);
      end if;

    END IF;

    RETURN TRUE;

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