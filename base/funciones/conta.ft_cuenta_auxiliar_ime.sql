CREATE OR REPLACE FUNCTION conta.ft_cuenta_auxiliar_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_cuenta_auxiliar_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tcuenta_auxiliar'
 AUTOR: 		 (admin)
 FECHA:	        11-07-2013 20:37:00
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
	v_id_cuenta_auxiliar	integer;

BEGIN

    v_nombre_funcion = 'conta.ft_cuenta_auxiliar_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'CONTA_CAX_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin
 	#FECHA:		11-07-2013 20:37:00
	***********************************/

	if(p_transaccion='CONTA_CAX_INS')then

        begin

        	IF EXISTS (select 1 from conta.tcuenta_auxiliar
            		where id_auxiliar=v_parametros.id_auxiliar
                    and id_cuenta=v_parametros.id_cuenta) THEN
            	raise exception 'El auxiliar ya se encuentra relacionado a la cuenta';
            END IF;

        	--Sentencia de la insercion
        	insert into conta.tcuenta_auxiliar(
			estado_reg,
			id_auxiliar,
			id_cuenta,
			id_usuario_reg,
			fecha_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.id_auxiliar,
			v_parametros.id_cuenta,
			p_id_usuario,
			now(),
			null,
			null

			)RETURNING id_cuenta_auxiliar into v_id_cuenta_auxiliar;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cuenta - Auxiliar almacenado(a) con exito (id_cuenta_auxiliar'||v_id_cuenta_auxiliar||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta_auxiliar',v_id_cuenta_auxiliar::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'CONTA_CAX_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin
 	#FECHA:		11-07-2013 20:37:00
	***********************************/

	elsif(p_transaccion='CONTA_CAX_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.tcuenta_auxiliar set
			id_auxiliar = v_parametros.id_auxiliar,
			id_cuenta = v_parametros.id_cuenta,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now()
			where id_cuenta_auxiliar=v_parametros.id_cuenta_auxiliar;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cuenta - Auxiliar modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta_auxiliar',v_parametros.id_cuenta_auxiliar::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'CONTA_CAX_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin
 	#FECHA:		11-07-2013 20:37:00
	***********************************/

	elsif(p_transaccion='CONTA_CAX_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tcuenta_auxiliar
            where id_cuenta_auxiliar=v_parametros.id_cuenta_auxiliar;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cuenta - Auxiliar eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta_auxiliar',v_parametros.id_cuenta_auxiliar::varchar);

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