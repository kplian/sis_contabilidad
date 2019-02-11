--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_config_tipo_cuenta_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.f_config_tipo_cuenta_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tconfig_tipo_cuenta'
 AUTOR: 		 (admin)
 FECHA:	        26-02-2013 19:19:24
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
	v_id_config_tipo_cuenta	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.f_config_tipo_cuenta_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_CTC_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		26-02-2013 19:19:24
	***********************************/

	if(p_transaccion='CONTA_CTC_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.tconfig_tipo_cuenta(
              nro_base,
              tipo_cuenta,
              estado_reg,
              id_usuario_reg,
              fecha_reg,
              fecha_mod,
              id_usuario_mod,
              incremento,
              eeff,
              movimiento
          	) 
            values(
              v_parametros.nro_base,
              v_parametros.tipo_cuenta,
              'activo',
              p_id_usuario,
              now(),
              null,
              null,
              v_parametros.incremento,
              string_to_array(v_parametros.eeff,',')::varchar[],
              v_parametros.movimiento							
			)RETURNING id_config_tipo_cuenta into v_id_config_tipo_cuenta;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Config. Tipo Cuenta almacenado(a) con exito (id_cofig_tipo_cuenta'||v_id_cofig_tipo_cuenta||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_config_tipo_cuenta',v_id_config_tipo_cuenta::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CTC_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		26-02-2013 19:19:24
	***********************************/

	elsif(p_transaccion='CONTA_CTC_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.tconfig_tipo_cuenta set
              nro_base = v_parametros.nro_base,
              tipo_cuenta = v_parametros.tipo_cuenta,
              fecha_mod = now(),
              id_usuario_mod = p_id_usuario,
              incremento = v_parametros.incremento,
              eeff = string_to_array(v_parametros.eeff,',')::varchar[],
              movimiento = v_parametros.movimiento
			where id_config_tipo_cuenta=v_parametros.id_config_tipo_cuenta;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Config. Tipo Cuenta modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cofig_tipo_cuenta',v_parametros.id_config_tipo_cuenta::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CTC_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		26-02-2013 19:19:24
	***********************************/

	elsif(p_transaccion='CONTA_CTC_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tconfig_tipo_cuenta
            where id_config_tipo_cuenta=v_parametros.id_config_tipo_cuenta;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Config. Tipo Cuenta eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_config_tipo_cuenta',v_parametros.id_config_tipo_cuenta::varchar);
              
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