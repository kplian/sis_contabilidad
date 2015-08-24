--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_doc_compra_venta_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_doc_compra_venta_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tdoc_compra_venta'
 AUTOR: 		 (admin)
 FECHA:	        18-08-2015 15:57:09
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
	v_id_doc_compra_venta	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_doc_compra_venta_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_DCV_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		18-08-2015 15:57:09
	***********************************/

	if(p_transaccion='CONTA_DCV_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.tdoc_compra_venta(
			
			
			tipo,
			importe_excento,
			id_plantilla,
			fecha,
			nro_documento,
			nit,
			importe_ice,
			nro_autorizacion,
			importe_iva,
			importe_descuento,
			importe_doc,
			sw_contabilizar,
			
			estado,
			id_depto_conta,
			
			obs,
			estado_reg,
			codigo_control,
			importe_it,
			razon_social,
			id_usuario_ai,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
            manual
          	) values(
			
			v_parametros.tipo,
			v_parametros.importe_excento,
			v_parametros.id_plantilla,
			v_parametros.fecha,
			v_parametros.nro_documento,
			v_parametros.nit,
			v_parametros.importe_ice,
			v_parametros.nro_autorizacion,
			v_parametros.importe_iva,
			v_parametros.importe_descuento,
			v_parametros.importe_doc,
			'si', --sw_contabilizar,
		
			'registrado', --estado
			v_parametros.id_depto_conta,
			
			v_parametros.obs,
			'activo',
			v_parametros.codigo_control,
			v_parametros.importe_it,
			v_parametros.razon_social,
			v_parametros._id_usuario_ai,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
            'si'
							
			
			
			)RETURNING id_doc_compra_venta into v_id_doc_compra_venta;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Documentos Compra/Venta almacenado(a) con exito (id_doc_compra_venta'||v_id_doc_compra_venta||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_doc_compra_venta',v_id_doc_compra_venta::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_DCV_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		18-08-2015 15:57:09
	***********************************/

	elsif(p_transaccion='CONTA_DCV_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.tdoc_compra_venta set
			revisado = v_parametros.revisado,
			movil = v_parametros.movil,
			tipo = v_parametros.tipo,
			importe_excento = v_parametros.importe_excento,
			id_plantilla = v_parametros.id_plantilla,
			fecha = v_parametros.fecha,
			nro_documento = v_parametros.nro_documento,
			nit = v_parametros.nit,
			importe_ice = v_parametros.importe_ice,
			nro_autorizacion = v_parametros.nro_autorizacion,
			importe_iva = v_parametros.importe_iva,
			importe_descuento = v_parametros.importe_descuento,
			importe_doc = v_parametros.importe_doc,
			sw_contabilizar = v_parametros.sw_contabilizar,
			tabla_origen = v_parametros.tabla_origen,
			estado = v_parametros.estado,
			id_depto_conta = v_parametros.id_depto_conta,
			id_origen = v_parametros.id_origen,
			obs = v_parametros.obs,
			codigo_control = v_parametros.codigo_control,
			importe_it = v_parametros.importe_it,
			razon_social = v_parametros.razon_social,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_doc_compra_venta=v_parametros.id_doc_compra_venta;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Documentos Compra/Venta modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_doc_compra_venta',v_parametros.id_doc_compra_venta::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_DCV_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		18-08-2015 15:57:09
	***********************************/

	elsif(p_transaccion='CONTA_DCV_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tdoc_compra_venta
            where id_doc_compra_venta=v_parametros.id_doc_compra_venta;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Documentos Compra/Venta eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_doc_compra_venta',v_parametros.id_doc_compra_venta::varchar);
              
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