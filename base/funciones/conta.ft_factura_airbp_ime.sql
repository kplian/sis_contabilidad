CREATE OR REPLACE FUNCTION conta.ft_factura_airbp_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_factura_airbp_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tfactura_airbp'
 AUTOR: 		 (gsarmiento)
 FECHA:	        12-01-2017 21:45:40
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
	v_id_factura_airbp	integer;

BEGIN

    v_nombre_funcion = 'conta.ft_factura_airbp_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'CONTA_FAIRBP_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		gsarmiento
 	#FECHA:		12-01-2017 21:45:40
	***********************************/

	if(p_transaccion='CONTA_FAIRBP_INS')then

        begin
        	--Sentencia de la insercion
        	insert into conta.tfactura_airbp(
			id_doc_compra_venta,
			tipo_cambio,
			punto_venta,
			id_cliente,
			estado,
			estado_reg,
			id_usuario_ai,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.id_doc_compra_venta,
			v_parametros.tipo_cambio,
			v_parametros.punto_venta,
			v_parametros.id_cliente,
			v_parametros.estado,
			'activo',
			v_parametros._id_usuario_ai,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			null,
			null



			)RETURNING id_factura_airbp into v_id_factura_airbp;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Factura almacenado(a) con exito (id_factura_airbp'||v_id_factura_airbp||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_factura_airbp',v_id_factura_airbp::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'CONTA_FAIRBP_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		gsarmiento
 	#FECHA:		12-01-2017 21:45:40
	***********************************/

	elsif(p_transaccion='CONTA_FAIRBP_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.tfactura_airbp set
			id_doc_compra_venta = v_parametros.id_doc_compra_venta,
			tipo_cambio = v_parametros.tipo_cambio,
			punto_venta = v_parametros.punto_venta,
			id_cliente = v_parametros.id_cliente,
			estado = v_parametros.estado,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_factura_airbp=v_parametros.id_factura_airbp;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Factura modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_factura_airbp',v_parametros.id_factura_airbp::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'CONTA_FAIRBP_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		gsarmiento
 	#FECHA:		12-01-2017 21:45:40
	***********************************/

	elsif(p_transaccion='CONTA_FAIRBP_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tfactura_airbp
            where id_factura_airbp=v_parametros.id_factura_airbp;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Factura eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_factura_airbp',v_parametros.id_factura_airbp::varchar);

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