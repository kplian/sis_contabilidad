CREATE OR REPLACE FUNCTION "conta"."ft_tipo_doc_compra_venta_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_tipo_doc_compra_venta_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.ttipo_doc_compra_venta'
 AUTOR: 		 (admin)
 FECHA:	        22-02-2016 16:19:51
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
	v_id_tipo_doc_compra_venta	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_tipo_doc_compra_venta_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_TDOC_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		22-02-2016 16:19:51
	***********************************/

	if(p_transaccion='CONTA_TDOC_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.ttipo_doc_compra_venta(
			codigo,
			tipo,
			obs,
			nombre,
			estado_reg,
			id_usuario_ai,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.codigo,
			v_parametros.tipo,
			v_parametros.obs,
			v_parametros.nombre,
			'activo',
			v_parametros._id_usuario_ai,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			null,
			null
							
			
			
			)RETURNING id_tipo_doc_compra_venta into v_id_tipo_doc_compra_venta;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Doc almacenado(a) con exito (id_tipo_doc_compra_venta'||v_id_tipo_doc_compra_venta||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_doc_compra_venta',v_id_tipo_doc_compra_venta::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_TDOC_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		22-02-2016 16:19:51
	***********************************/

	elsif(p_transaccion='CONTA_TDOC_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.ttipo_doc_compra_venta set
			codigo = v_parametros.codigo,
			tipo = v_parametros.tipo,
			obs = v_parametros.obs,
			nombre = v_parametros.nombre,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_tipo_doc_compra_venta=v_parametros.id_tipo_doc_compra_venta;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Doc modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_doc_compra_venta',v_parametros.id_tipo_doc_compra_venta::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_TDOC_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		22-02-2016 16:19:51
	***********************************/

	elsif(p_transaccion='CONTA_TDOC_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.ttipo_doc_compra_venta
            where id_tipo_doc_compra_venta=v_parametros.id_tipo_doc_compra_venta;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Doc eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_doc_compra_venta',v_parametros.id_tipo_doc_compra_venta::varchar);
              
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
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;
ALTER FUNCTION "conta"."ft_tipo_doc_compra_venta_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
