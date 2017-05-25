CREATE OR REPLACE FUNCTION conta.ft_archivo_sigep_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_archivo_sigep_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tarchivo_sigep'
 AUTOR: 		 (gsarmiento)
 FECHA:	        10-05-2017 15:38:14
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
	v_id_archivo_sigep	integer;

BEGIN

    v_nombre_funcion = 'conta.ft_archivo_sigep_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'CONTA_ARCSGP_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		gsarmiento
 	#FECHA:		10-05-2017 15:38:14
	***********************************/

	if(p_transaccion='CONTA_ARCSGP_INS')then

        begin
        	--Sentencia de la insercion
        	insert into conta.tarchivo_sigep(
			nombre_archivo,
			estado_reg,
			url,
			extension,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.nombre_archivo,
			'activo',
			v_parametros.url,
			v_parametros.extension,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			v_parametros._id_usuario_ai,
			null,
			null
			)RETURNING id_archivo_sigep into v_id_archivo_sigep;

            UPDATE conta.tgasto_sigep
            SET id_archivo_sigep = v_id_archivo_sigep
            WHERE id_archivo_sigep IS NULL;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Archivo Sigep almacenado(a) con exito (id_archivo_sigep'||v_id_archivo_sigep||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_archivo_sigep',v_id_archivo_sigep::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'CONTA_ARCSGP_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		gsarmiento
 	#FECHA:		10-05-2017 15:38:14
	***********************************/

	elsif(p_transaccion='CONTA_ARCSGP_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.tarchivo_sigep set
			nombre_archivo = v_parametros.nombre_archivo,
			url = v_parametros.url,
			extension = v_parametros.extension,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_archivo_sigep=v_parametros.id_archivo_sigep;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Archivo Sigep modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_archivo_sigep',v_parametros.id_archivo_sigep::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'CONTA_ARCSGP_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		gsarmiento
 	#FECHA:		10-05-2017 15:38:14
	***********************************/

	elsif(p_transaccion='CONTA_ARCSGP_ELI')then

		begin

            delete from conta.tgasto_sigep
            where id_archivo_sigep=v_parametros.id_archivo_sigep;

			--Sentencia de la eliminacion
			delete from conta.tarchivo_sigep
            where id_archivo_sigep=v_parametros.id_archivo_sigep;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Archivo Sigep eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_archivo_sigep',v_parametros.id_archivo_sigep::varchar);

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