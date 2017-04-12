CREATE OR REPLACE FUNCTION conta.ft_config_banca_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_config_banca_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tconfig_banca'
 AUTOR: 		 (admin)
 FECHA:	        11-09-2015 16:51:13
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
	v_id_config_banca	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_config_banca_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_CONFBA_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		11-09-2015 16:51:13
	***********************************/

	if(p_transaccion='CONTA_CONFBA_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.tconfig_banca(
			tipo,
			estado_reg,
			descripcion,
			digito,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.tipo,
			'activo',
			v_parametros.descripcion,
			v_parametros.digito,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_config_banca into v_id_config_banca;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','configuracion bancaria almacenado(a) con exito (id_config_banca'||v_id_config_banca||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_config_banca',v_id_config_banca::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CONFBA_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		11-09-2015 16:51:13
	***********************************/

	elsif(p_transaccion='CONTA_CONFBA_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.tconfig_banca set
			tipo = v_parametros.tipo,
			descripcion = v_parametros.descripcion,
			digito = v_parametros.digito,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_config_banca=v_parametros.id_config_banca;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','configuracion bancaria modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_config_banca',v_parametros.id_config_banca::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CONFBA_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		11-09-2015 16:51:13
	***********************************/

	elsif(p_transaccion='CONTA_CONFBA_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tconfig_banca
            where id_config_banca=v_parametros.id_config_banca;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','configuracion bancaria eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_config_banca',v_parametros.id_config_banca::varchar);
              
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