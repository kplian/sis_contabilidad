CREATE OR REPLACE FUNCTION conta.ft_periodo_resolucion_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_periodo_resolucion_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tperiodo_resolucion'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        27-06-2017 21:35:54
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_periodo_resolucion	integer;
    v_registros 			record;
    v_fecha_fin				date;
    v_estado				varchar;

BEGIN

    v_nombre_funcion = 'conta.ft_periodo_resolucion_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'CONTA_PRN_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		27-06-2017 21:35:54
	***********************************/

	if(p_transaccion='CONTA_PRN_INS')then
    begin
    --Sentencia de la insercion
    for v_registros in (
    select p.id_periodo
    from param.tperiodo p
    where p.estado_reg = 'activo'
    and p.id_periodo not in (
    select r.id_periodo
    from conta.tperiodo_resolucion r
    inner join param.tperiodo pe on pe.id_periodo = r.id_periodo
    where r.id_depto = v_parametros.id_depto
    and pe.id_gestion = v_parametros.id_gestion
    and p.id_gestion = v_parametros.id_gestion
    ))loop
    insert into conta.tperiodo_resolucion(
			estado_reg,
			estado,
			id_periodo,
			id_depto,
            id_usuario_reg,
            fecha_reg
          	) values(
			'activo',
			'abierto',
			v_registros.id_periodo,
			v_parametros.id_depto,
            p_id_usuario,
    		now()
			);
	end loop;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Periodo Resolucion almacenado(a) con exito (id_periodo_resolucion'||v_id_periodo_resolucion||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_periodo_resolucion',v_id_periodo_resolucion::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'CONTA_PRN_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		27-06-2017 21:35:54
	***********************************/

	elsif(p_transaccion='CONTA_PRN_MOD')then

		begin

            select
            per.fecha_fin
            into
            v_fecha_fin
            from conta.tperiodo_resolucion pr
            inner join param.tperiodo per on per.id_periodo = pr.id_periodo
            where pr.id_periodo_resolucion = v_parametros.id_periodo_resolucion;
        	--todo para abrir el perido revisar que el periodo de conta del periodo correspondiente este cerrado

            IF not param.f_periodo_subsistema_abierto(v_fecha_fin, 'CONTA') THEN
              raise exception 'El periodo se encuentra cerrado en contabilidad';
            END IF;

            IF v_parametros.tipo = 'cerrar' THEN
             v_estado = 'cerrado';
            ELSE
             v_estado = 'abierto';
            END IF;

            update conta.tperiodo_resolucion pcv set
              estado = v_estado
            where pcv.id_periodo_resolucion = v_parametros.id_periodo_resolucion;


			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Periodo Resolucion modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_periodo_resolucion',v_parametros.id_periodo_resolucion::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	else

    	raise exception 'Transaccion inexistente: %',p_transaccion;

	end if;

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