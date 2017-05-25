CREATE OR REPLACE FUNCTION conta.ft_factura_airbp_concepto_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_factura_airbp_concepto_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tfactura_airbp_concepto'
 AUTOR: 		 (gsarmiento)
 FECHA:	        12-01-2017 21:46:08
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
	v_id_factura_airbp_concepto	integer;

BEGIN

    v_nombre_funcion = 'conta.ft_factura_airbp_concepto_ime';
    v_parametros = pxp.f_get_record(p_tabla);
raise notice 'otro';
	/*********************************
 	#TRANSACCION:  'CONTA_FCAIRBP_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		gsarmiento
 	#FECHA:		12-01-2017 21:46:08
	***********************************/

	if(p_transaccion='CONTA_FCAIRBP_INS')then

        begin
        	raise notice 'funcion';
        	--Sentencia de la insercion
        	insert into conta.tfactura_airbp_concepto(
			id_factura_airbp,
			cantidad,
			total_bs,
			precio_unitario,
			ne,
			estado_reg,
			destino,
			matricula,
			articulo,
			id_usuario_ai,
			id_usuario_reg,
			usuario_ai,
			fecha_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.id_factura_airbp,
			v_parametros.cantidad_concepto,
			v_parametros.total_bs,
			v_parametros.precio_unitario,
			v_parametros.ne,
			'activo',
			v_parametros.destino,
			v_parametros.matricula,
			v_parametros.articulo,
			v_parametros._id_usuario_ai,
			p_id_usuario,
			v_parametros._nombre_usuario_ai,
			now(),
			null,
			null



			)RETURNING id_factura_airbp_concepto into v_id_factura_airbp_concepto;
			raise notice 'llega';
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Concepto almacenado(a) con exito (id_factura_airbp_concepto'||v_id_factura_airbp_concepto||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_factura_airbp_concepto',v_id_factura_airbp_concepto::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'CONTA_FCAIRBP_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		gsarmiento
 	#FECHA:		12-01-2017 21:46:08
	***********************************/

	elsif(p_transaccion='CONTA_FCAIRBP_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.tfactura_airbp_concepto set
			id_factura_airbp = v_parametros.id_factura_airbp,
			cantidad = v_parametros.cantidad,
			total_bs = v_parametros.total_bs,
			precio_unitario = v_parametros.precio_unitario,
			ne = v_parametros.ne,
			destino = v_parametros.destino,
			matricula = v_parametros.matricula,
			articulo = v_parametros.articulo,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_factura_airbp_concepto=v_parametros.id_factura_airbp_concepto;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Concepto modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_factura_airbp_concepto',v_parametros.id_factura_airbp_concepto::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'CONTA_FCAIRBP_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		gsarmiento
 	#FECHA:		12-01-2017 21:46:08
	***********************************/

	elsif(p_transaccion='CONTA_FCAIRBP_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tfactura_airbp_concepto
            where id_factura_airbp_concepto=v_parametros.id_factura_airbp_concepto;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Concepto eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_factura_airbp_concepto',v_parametros.id_factura_airbp_concepto::varchar);

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