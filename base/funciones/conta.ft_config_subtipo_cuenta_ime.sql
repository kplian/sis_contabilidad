CREATE OR REPLACE FUNCTION "conta"."ft_config_subtipo_cuenta_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_config_subtipo_cuenta_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tconfig_subtipo_cuenta'
 AUTOR: 		 (admin)
 FECHA:	        07-06-2017 19:52:43
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
	v_id_config_subtipo_cuenta	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_config_subtipo_cuenta_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_CST_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		07-06-2017 19:52:43
	***********************************/

	if(p_transaccion='CONTA_CST_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.tconfig_subtipo_cuenta(
			estado_reg,
			descripcion,
			nombre,
			id_config_tipo_cuenta,
			codigo,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			id_usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.descripcion,
			v_parametros.nombre,
			v_parametros.id_config_tipo_cuenta,
			v_parametros.codigo,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_config_subtipo_cuenta into v_id_config_subtipo_cuenta;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Subtipo almacenado(a) con exito (id_config_subtipo_cuenta'||v_id_config_subtipo_cuenta||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_config_subtipo_cuenta',v_id_config_subtipo_cuenta::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CST_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		07-06-2017 19:52:43
	***********************************/

	elsif(p_transaccion='CONTA_CST_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.tconfig_subtipo_cuenta set
			descripcion = v_parametros.descripcion,
			nombre = v_parametros.nombre,
			id_config_tipo_cuenta = v_parametros.id_config_tipo_cuenta,
			codigo = v_parametros.codigo,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_config_subtipo_cuenta=v_parametros.id_config_subtipo_cuenta;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Subtipo modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_config_subtipo_cuenta',v_parametros.id_config_subtipo_cuenta::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CST_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		07-06-2017 19:52:43
	***********************************/

	elsif(p_transaccion='CONTA_CST_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tconfig_subtipo_cuenta
            where id_config_subtipo_cuenta=v_parametros.id_config_subtipo_cuenta;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Subtipo eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_config_subtipo_cuenta',v_parametros.id_config_subtipo_cuenta::varchar);
              
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
ALTER FUNCTION "conta"."ft_config_subtipo_cuenta_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
