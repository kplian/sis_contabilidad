CREATE OR REPLACE FUNCTION conta.ft_config_tpre_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_config_tpre_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tconfig_tpre'
 AUTOR: 		 (mguerra)
 FECHA:	        18-03-2019 16:32:29
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #54				18-03-2019 16:32:29								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tconfig_tpre'	
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_conf_pre	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_config_tpre_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_CONTC_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		mguerra	
 	#FECHA:		18-03-2019 16:32:29
	***********************************/

	if(p_transaccion='CONTA_CONTC_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.tconfig_tpre(
			id_tipo_cc,
			estado_reg,
			obs,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.id_tipo_cc,
			'activo',
			v_parametros.obs,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_conf_pre into v_id_conf_pre;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Configuracion de Tipo de Centro almacenado(a) con exito (id_conf_pre'||v_id_conf_pre||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_conf_pre',v_id_conf_pre::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CONTC_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		mguerra	
 	#FECHA:		18-03-2019 16:32:29
	***********************************/

	elsif(p_transaccion='CONTA_CONTC_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.tconfig_tpre set
			id_tipo_cc = v_parametros.id_tipo_cc,
			obs = v_parametros.obs,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_conf_pre=v_parametros.id_conf_pre;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Configuracion de Tipo de Centro modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_conf_pre',v_parametros.id_conf_pre::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CONTC_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		mguerra	
 	#FECHA:		18-03-2019 16:32:29
	***********************************/

	elsif(p_transaccion='CONTA_CONTC_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tconfig_tpre
            where id_conf_pre=v_parametros.id_conf_pre;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Configuracion de Tipo de Centro eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_conf_pre',v_parametros.id_conf_pre::varchar);
              
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