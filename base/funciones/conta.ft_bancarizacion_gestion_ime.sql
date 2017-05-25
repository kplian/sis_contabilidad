CREATE OR REPLACE FUNCTION "conta"."ft_bancarizacion_gestion_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_bancarizacion_gestion_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tbancarizacion_gestion'
 AUTOR: 		 (admin)
 FECHA:	        09-02-2017 20:12:18
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
	v_id_bancarizacion_gestion	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_bancarizacion_gestion_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_BANGES_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		09-02-2017 20:12:18
	***********************************/

	if(p_transaccion='CONTA_BANGES_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.tbancarizacion_gestion(
			estado_reg,
			estado,
			id_gestion,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.estado,
			v_parametros.id_gestion,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_bancarizacion_gestion into v_id_bancarizacion_gestion;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Bancarizacion Gestion almacenado(a) con exito (id_bancarizacion_gestion'||v_id_bancarizacion_gestion||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_bancarizacion_gestion',v_id_bancarizacion_gestion::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_BANGES_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		09-02-2017 20:12:18
	***********************************/

	elsif(p_transaccion='CONTA_BANGES_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.tbancarizacion_gestion set
			estado = v_parametros.estado,
			id_gestion = v_parametros.id_gestion,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_bancarizacion_gestion=v_parametros.id_bancarizacion_gestion;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Bancarizacion Gestion modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_bancarizacion_gestion',v_parametros.id_bancarizacion_gestion::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_BANGES_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		09-02-2017 20:12:18
	***********************************/

	elsif(p_transaccion='CONTA_BANGES_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tbancarizacion_gestion
            where id_bancarizacion_gestion=v_parametros.id_bancarizacion_gestion;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Bancarizacion Gestion eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_bancarizacion_gestion',v_parametros.id_bancarizacion_gestion::varchar);
              
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
ALTER FUNCTION "conta"."ft_bancarizacion_gestion_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
