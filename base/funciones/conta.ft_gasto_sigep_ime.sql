CREATE OR REPLACE FUNCTION conta.ft_gasto_sigep_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_gasto_sigep_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tgasto_sigep'
 AUTOR: 		 (gsarmiento)
 FECHA:	        08-05-2017 20:06:08
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
	v_id_gasto_sigep	integer;

BEGIN

    v_nombre_funcion = 'conta.ft_gasto_sigep_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'CONTA_GTSG_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		gsarmiento
 	#FECHA:		08-05-2017 20:06:08
	***********************************/

	if(p_transaccion='CONTA_GTSG_INS')then

        begin

            --Sentencia de la insercion
            insert into conta.tgasto_sigep(
            programa,
            gestion,
            actividad,
            nro_preventivo,
            nro_comprometido,
            nro_devengado,
            proyecto,
            organismo,
            estado_reg,
            estado,
            descripcion_gasto,
            entidad_transferencia,
			fuente,
			objeto,
			monto,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.programa,
			v_parametros.gestion,
			v_parametros.actividad,
			v_parametros.nro_preventivo,
            v_parametros.nro_comprometido,
			v_parametros.nro_devengado,
			v_parametros.proyecto,
			v_parametros.organismo,
			'activo',
			v_parametros.estado,
			v_parametros.descripcion_gasto,
			v_parametros.entidad_transferencia,
			v_parametros.fuente,
			v_parametros.objeto,
			v_parametros.monto,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null
			)RETURNING id_gasto_sigep into v_id_gasto_sigep;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Gasto Sigep almacenado(a) con exito (id_gasto_sigep'||v_id_gasto_sigep||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_gasto_sigep',v_id_gasto_sigep::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'CONTA_GTSG_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		gsarmiento
 	#FECHA:		08-05-2017 20:06:08
	***********************************/

	elsif(p_transaccion='CONTA_GTSG_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.tgasto_sigep set
			programa = v_parametros.programa,
			gestion = v_parametros.gestion,
			actividad = v_parametros.actividad,
			nro_comprobante = v_parametros.nro_comprobante,
            nro_devengado = v_parametros.nro_devengado,
			proyecto = v_parametros.proyecto,
			organismo = v_parametros.organismo,
			estado = v_parametros.estado,
			descripcion_gasto = v_parametros.descripcion_gasto,
			entidad_transferencia = v_parametros.entidad_transferencia,
			nro_preventivo = v_parametros.nro_preventivo,
			fuente = v_parametros.fuente,
			objeto = v_parametros.objeto,
			monto = v_parametros.monto,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_gasto_sigep=v_parametros.id_gasto_sigep;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Gasto Sigep modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_gasto_sigep',v_parametros.id_gasto_sigep::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'CONTA_GTSG_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		gsarmiento
 	#FECHA:		08-05-2017 20:06:08
	***********************************/

	elsif(p_transaccion='CONTA_GTSG_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tgasto_sigep
            where id_gasto_sigep=v_parametros.id_gasto_sigep;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Gasto Sigep eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_gasto_sigep',v_parametros.id_gasto_sigep::varchar);

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