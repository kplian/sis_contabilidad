CREATE OR REPLACE FUNCTION "conta"."ft_config_auxiliar_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_config_auxiliar_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tconfig_auxiliar'
 AUTOR: 		 (egutierrez)
 FECHA:	        05-06-2019 15:37:13
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				05-06-2019 15:37:13								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tconfig_auxiliar'	
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_config_auxiliar	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_config_auxiliar_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_cfga_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		egutierrez	
 	#FECHA:		05-06-2019 15:37:13
	***********************************/

	if(p_transaccion='CONTA_cfga_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.tconfig_auxiliar(
			id_auxiliar,
			descripcion,
			estado_reg,
			id_usuario_ai,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.id_auxiliar,
			v_parametros.descripcion,
			'activo',
			v_parametros._id_usuario_ai,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_config_auxiliar into v_id_config_auxiliar;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Config. Auxiliar Etasa almacenado(a) con exito (id_config_auxiliar'||v_id_config_auxiliar||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_config_auxiliar',v_id_config_auxiliar::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_cfga_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		egutierrez	
 	#FECHA:		05-06-2019 15:37:13
	***********************************/

	elsif(p_transaccion='CONTA_cfga_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.tconfig_auxiliar set
			id_auxiliar = v_parametros.id_auxiliar,
			descripcion = v_parametros.descripcion,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_config_auxiliar=v_parametros.id_config_auxiliar;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Config. Auxiliar Etasa modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_config_auxiliar',v_parametros.id_config_auxiliar::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_cfga_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		egutierrez	
 	#FECHA:		05-06-2019 15:37:13
	***********************************/

	elsif(p_transaccion='CONTA_cfga_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tconfig_auxiliar
            where id_config_auxiliar=v_parametros.id_config_auxiliar;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Config. Auxiliar Etasa eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_config_auxiliar',v_parametros.id_config_auxiliar::varchar);
              
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
ALTER FUNCTION "conta"."ft_config_auxiliar_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
