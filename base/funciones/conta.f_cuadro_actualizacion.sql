CREATE OR REPLACE FUNCTION conta.f_cuadro_actualizacion (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS SETOF record AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.f_cuadro_actualizacion
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tcuenta'
 AUTOR: 		MMV
 FECHA:	        28/01/2018	
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
	ISSUE			FECHA 				AUTHOR 						DESCRIPCION
    #  28	     	17/12/2018			Kplian MMV							Reporte cuadro de actualización

***************************************************************************/
DECLARE
v_parametros  				record;
v_nombre_funcion   			text;
v_resp						varchar;
v_consulta					varchar;
v_registros  				record;
va_total 					numeric[];
v_record					record;
v_id_gestion				integer;
va_tipo_cuenta				varchar[];
va_mayor					numeric[];
va_debe						numeric[];
va_haber					numeric[];
v_id_moneda_base			integer;
v_id_moneda_act				integer;
v_actualizado_mb            numeric;
v_tipo_cambio				numeric;
BEGIN

     v_nombre_funcion = 'conta.f_balance';
     v_parametros = pxp.f_get_record(p_tabla);


    /*********************************
     #TRANSACCION:    'CONTA_RUA_SEL'
     #DESCRIPCION:     Listado para el reporte del balance general
     #AUTOR:           MMV
     #FECHA:            12-06-2015
    ***********************************/

	IF(p_transaccion='CONTA_RUA_SEL')then

    	v_actualizado_mb = 0;
        v_tipo_cambio = 0;
        v_id_moneda_base = param.f_get_moneda_base();

        if v_parametros.tipo_moneda = 'MA' then
              v_id_moneda_act  = param.f_get_moneda_actualizacion();
         else
               v_id_moneda_act = 2;
       	end if;


        -- 1) Crea una tabla temporal con los datos que se utilizaran

        CREATE TEMPORARY TABLE temp_cuadro (  id_cuenta integer,
                                              nro_cuenta varchar,
                                              nombre_cuenta varchar,
                                              id_cuenta_padre integer,
                                              debe_ma numeric,
                                              haber_ma numeric,
                                              saldo_ma numeric,
                                              importe_mb numeric,
                                              saldo_mayor numeric,
                                              saldo_actulizacion numeric,
                                              nivel integer,
                                              tipo_cuenta varchar,
                                              movimiento varchar ) ON COMMIT DROP;

        -- 2) Obtener la gestion y tipo de cuenta
    	select  ges.id_gestion into v_id_gestion
        from param.tgestion ges
        where ges.gestion = (select extract(year from v_parametros.hasta::Date))::integer  and ges.estado_reg = 'activo';

        va_tipo_cuenta = string_to_array(v_parametros.tipo_cuenta,',');
        -- 3) Recorrer los darso
        for v_record in (select  c.id_cuenta,
                                 c.nro_cuenta,
                                 c.nombre_cuenta,
                                 c.tipo_cuenta,
                                 c.sw_transaccional
                                from conta.tcuenta c
                                inner join conta.tconfig_tipo_cuenta cc on cc.tipo_cuenta = c.tipo_cuenta
                                where c.estado_reg = 'activo' and c.id_gestion = v_id_gestion
                                and c.tipo_cuenta = ANY(va_tipo_cuenta) and c.sw_transaccional = 'movimiento'
                                order by nro_cuenta)loop

                       va_debe = conta.f_mayor_cuenta(  v_record.id_cuenta,
                                                        v_parametros.desde,
                                                        v_parametros.hasta,
                                                        null, --todos los deptos p_id_depto::varchar,,
                                                        'si',
                                                       'todos',          --  p_incluir_cierre
                                                       'todos',          --  p_incluir_aitb,
                                                       'defecto_cuenta', -- p_signo_balance,
                                                       'deudor', --  p_tipo_saldo,
                                                        null,--p_id_auxiliar,
                                                        null,--p_id_int_comprobante_ori,
                                                        null,--id_ot
                                                        null -- p_id_centro_costo);
                                                       );
                      va_haber = conta.f_mayor_cuenta(	v_record.id_cuenta,
                                                        v_parametros.desde,
                                                        v_parametros.hasta,
                                                        null, --todos los deptos p_id_depto::varchar,,
                                                        'si',
                                                       'todos',          --  p_incluir_cierre
                                                       'todos',          --  p_incluir_aitb,
                                                       'defecto_cuenta', -- p_signo_balance,
                                                       'acreedor', --  p_tipo_saldo,
                                                        null,--p_id_auxiliar,
                                                        null,--p_id_int_comprobante_ori,
                                                        null,--id_ot
                                                        null -- p_id_centro_costo);
                                                      	);
                      va_mayor = conta.f_mayor_cuenta( 	v_record.id_cuenta,
                      									v_parametros.desde,
                                                        v_parametros.hasta,
                                                        null,--p_id_deptos,
                                                        'si');

                    v_actualizado_mb = param.f_convertir_moneda ( v_id_moneda_act,
                                                                  v_id_moneda_base,
                                                                  va_mayor[2],
                                                                  v_parametros.fecha_moneda, 'O',2, 1, 'no');

                  insert  into temp_cuadro (
                                  id_cuenta,
                                  nro_cuenta,
                                  nombre_cuenta,
                                  id_cuenta_padre,
                                  debe_ma,
                                  haber_ma,
                                  saldo_ma,
                                  importe_mb,
                                  saldo_mayor,
                                  saldo_actulizacion,
                                  nivel,
                                  tipo_cuenta,
                                  movimiento)
                                VALUES(
                                 v_record.id_cuenta,
                                 v_record.nro_cuenta,
                                 v_record.nombre_cuenta,
                                 null,
                                 va_mayor[3],
                                 va_mayor[4],
                                 va_mayor[2],
                                 v_actualizado_mb,
                                 va_mayor[1],
                                 v_actualizado_mb - va_mayor[1],
                                 0,
                                 v_record.tipo_cuenta,
                                 'movimiento' );

        end loop;

    	     select  tc.oficial
                  into
        		 v_tipo_cambio
        from param.ttipo_cambio tc
        where   tc.id_moneda=v_id_moneda_act and
                tc.fecha = v_parametros.fecha_moneda;

      v_consulta = 'select  id_cuenta,
                            nro_cuenta,
                            nombre_cuenta,
                            id_cuenta_padre,
                            debe_ma,
                            haber_ma,
                            saldo_ma,
                            importe_mb,
                            saldo_mayor,
                            saldo_actulizacion,
                            nivel,
                            tipo_cuenta,
                            movimiento,'
                            ||v_tipo_cambio||'::numeric as tipo_cambio
                      		from temp_cuadro
                            order by  nro_cuenta';


       for v_registros in execute(v_consulta) loop
                   return next v_registros;
       end loop;
       
      

END IF;

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
COST 100 ROWS 1000;