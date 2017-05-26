CREATE OR REPLACE FUNCTION "conta"."ft_archivo_airbp_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_archivo_airbp_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tarchivo_airbp'
 AUTOR: 		 (gsarmiento)
 FECHA:	        12-01-2017 21:44:52
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
	v_id_archivo_airbp	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_archivo_airbp_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_AIRBP_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		gsarmiento	
 	#FECHA:		12-01-2017 21:44:52
	***********************************/

	if(p_transaccion='CONTA_AIRBP_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.tarchivo_airbp(
			nombre_archivo,
			anio,
			mes,
			estado_reg,
			id_usuario_ai,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.nombre_archivo,
			v_parametros.anio,
			v_parametros.mes,
			'activo',
			v_parametros._id_usuario_ai,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_archivo_airbp into v_id_archivo_airbp;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Archivo AIR BP almacenado(a) con exito (id_archivo_airbp'||v_id_archivo_airbp||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_archivo_airbp',v_id_archivo_airbp::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_AIRBP_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		gsarmiento	
 	#FECHA:		12-01-2017 21:44:52
	***********************************/

	elsif(p_transaccion='CONTA_AIRBP_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.tarchivo_airbp set
			nombre_archivo = v_parametros.nombre_archivo,
			anio = v_parametros.anio,
			mes = v_parametros.mes,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_archivo_airbp=v_parametros.id_archivo_airbp;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Archivo AIR BP modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_archivo_airbp',v_parametros.id_archivo_airbp::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_AIRBP_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		gsarmiento	
 	#FECHA:		12-01-2017 21:44:52
	***********************************/

	elsif(p_transaccion='CONTA_AIRBP_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tarchivo_airbp
            where id_archivo_airbp=v_parametros.id_archivo_airbp;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Archivo AIR BP eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_archivo_airbp',v_parametros.id_archivo_airbp::varchar);
              
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
ALTER FUNCTION "conta"."ft_archivo_airbp_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
