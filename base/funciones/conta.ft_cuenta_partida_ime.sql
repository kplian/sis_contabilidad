CREATE OR REPLACE FUNCTION "conta"."ft_cuenta_partida_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_cuenta_partida_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tcuenta_partida'
 AUTOR: 		 (admin)
 FECHA:	        04-05-2017 10:19:16
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
	v_id_cuenta_partida	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_cuenta_partida_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_CUPA_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		04-05-2017 10:19:16
	***********************************/

	if(p_transaccion='CONTA_CUPA_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.tcuenta_partida(
			estado_reg,
			sw_deha,
			id_partida,
			se_rega,
			id_cuenta,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			id_usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.sw_deha,
			v_parametros.id_partida,
			v_parametros.se_rega,
			v_parametros.id_cuenta,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_cuenta_partida into v_id_cuenta_partida;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cuenta Partida almacenado(a) con exito (id_cuenta_partida'||v_id_cuenta_partida||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta_partida',v_id_cuenta_partida::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CUPA_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		04-05-2017 10:19:16
	***********************************/

	elsif(p_transaccion='CONTA_CUPA_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.tcuenta_partida set
			sw_deha = v_parametros.sw_deha,
			id_partida = v_parametros.id_partida,
			se_rega = v_parametros.se_rega,
			id_cuenta = v_parametros.id_cuenta,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_cuenta_partida=v_parametros.id_cuenta_partida;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cuenta Partida modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta_partida',v_parametros.id_cuenta_partida::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CUPA_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		04-05-2017 10:19:16
	***********************************/

	elsif(p_transaccion='CONTA_CUPA_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tcuenta_partida
            where id_cuenta_partida=v_parametros.id_cuenta_partida;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cuenta Partida eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta_partida',v_parametros.id_cuenta_partida::varchar);
              
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
ALTER FUNCTION "conta"."ft_cuenta_partida_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
