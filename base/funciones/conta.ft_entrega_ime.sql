CREATE OR REPLACE FUNCTION "conta"."ft_entrega_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_entrega_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tentrega'
 AUTOR: 		 (admin)
 FECHA:	        17-11-2016 19:50:19
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
	v_id_entrega	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_entrega_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_ENT_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		17-11-2016 19:50:19
	***********************************/

	if(p_transaccion='CONTA_ENT_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.tentrega(
			fecha_c31,
			c31,
			estado,
			estado_reg,
			id_usuario_ai,
			usuario_ai,
			fecha_reg,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.fecha_c31,
			v_parametros.c31,
			v_parametros.estado,
			'activo',
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			now(),
			p_id_usuario,
			null,
			null
							
			
			
			)RETURNING id_entrega into v_id_entrega;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Entrega almacenado(a) con exito (id_entrega'||v_id_entrega||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_entrega',v_id_entrega::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_ENT_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		17-11-2016 19:50:19
	***********************************/

	elsif(p_transaccion='CONTA_ENT_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.tentrega set
			fecha_c31 = v_parametros.fecha_c31,
			c31 = v_parametros.c31,
			estado = v_parametros.estado,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_entrega=v_parametros.id_entrega;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Entrega modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_entrega',v_parametros.id_entrega::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_ENT_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		17-11-2016 19:50:19
	***********************************/

	elsif(p_transaccion='CONTA_ENT_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tentrega
            where id_entrega=v_parametros.id_entrega;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Entrega eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_entrega',v_parametros.id_entrega::varchar);
              
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
ALTER FUNCTION "conta"."ft_entrega_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
