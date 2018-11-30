CREATE OR REPLACE FUNCTION "conta"."ft_tipo_cc_cuenta_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_tipo_cc_cuenta_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.ttipo_cc_cuenta'
 AUTOR: 		 (admin)
 FECHA:	        08-09-2017 19:16:00
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
	v_id_tipo_cc_cuenta	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_tipo_cc_cuenta_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_TCAU_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		08-09-2017 19:16:00
	***********************************/

	if(p_transaccion='CONTA_TCAU_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.ttipo_cc_cuenta(
			estado_reg,
			obs,
			nro_cuenta,
			id_auxiliar,
			id_tipo_cc,
			usuario_ai,
			fecha_reg,
			id_usuario_reg,
			id_usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.obs,
			v_parametros.nro_cuenta,
			v_parametros.id_auxiliar,
			v_parametros.id_tipo_cc,
			v_parametros._nombre_usuario_ai,
			now(),
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_tipo_cc_cuenta into v_id_tipo_cc_cuenta;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Configuración Filtros almacenado(a) con exito (id_tipo_cc_cuenta'||v_id_tipo_cc_cuenta||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_cc_cuenta',v_id_tipo_cc_cuenta::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_TCAU_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		08-09-2017 19:16:00
	***********************************/

	elsif(p_transaccion='CONTA_TCAU_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.ttipo_cc_cuenta set
			obs = v_parametros.obs,
			nro_cuenta = v_parametros.nro_cuenta,
			id_auxiliar = v_parametros.id_auxiliar,
			id_tipo_cc = v_parametros.id_tipo_cc,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_tipo_cc_cuenta=v_parametros.id_tipo_cc_cuenta;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Configuración Filtros modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_cc_cuenta',v_parametros.id_tipo_cc_cuenta::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_TCAU_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		08-09-2017 19:16:00
	***********************************/

	elsif(p_transaccion='CONTA_TCAU_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.ttipo_cc_cuenta
            where id_tipo_cc_cuenta=v_parametros.id_tipo_cc_cuenta;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Configuración Filtros eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_cc_cuenta',v_parametros.id_tipo_cc_cuenta::varchar);
              
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
ALTER FUNCTION "conta"."ft_tipo_cc_cuenta_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
