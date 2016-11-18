CREATE OR REPLACE FUNCTION "conta"."ft_entrega_det_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_entrega_det_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tentrega_det'
 AUTOR: 		 (admin)
 FECHA:	        17-11-2016 19:50:46
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
	v_id_entrega_det	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_entrega_det_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_END_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		17-11-2016 19:50:46
	***********************************/

	if(p_transaccion='CONTA_END_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.tentrega_det(
			estado_reg,
			id_int_comprobante,
			id_entrega,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.id_int_comprobante,
			v_parametros.id_entrega,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_entrega_det into v_id_entrega_det;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Entrega Detalle almacenado(a) con exito (id_entrega_det'||v_id_entrega_det||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_entrega_det',v_id_entrega_det::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_END_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		17-11-2016 19:50:46
	***********************************/

	elsif(p_transaccion='CONTA_END_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.tentrega_det set
			id_int_comprobante = v_parametros.id_int_comprobante,
			id_entrega = v_parametros.id_entrega,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_entrega_det=v_parametros.id_entrega_det;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Entrega Detalle modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_entrega_det',v_parametros.id_entrega_det::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_END_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		17-11-2016 19:50:46
	***********************************/

	elsif(p_transaccion='CONTA_END_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tentrega_det
            where id_entrega_det=v_parametros.id_entrega_det;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Entrega Detalle eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_entrega_det',v_parametros.id_entrega_det::varchar);
              
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
ALTER FUNCTION "conta"."ft_entrega_det_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
