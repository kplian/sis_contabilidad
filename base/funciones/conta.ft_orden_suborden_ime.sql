CREATE OR REPLACE FUNCTION "conta"."ft_orden_suborden_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_orden_suborden_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.torden_suborden'
 AUTOR: 		 (admin)
 FECHA:	        15-05-2017 10:36:02
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
	v_id_orden_suborden	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_orden_suborden_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_ORSUO_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		15-05-2017 10:36:02
	***********************************/

	if(p_transaccion='CONTA_ORSUO_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.torden_suborden(
			id_suborden,
			estado_reg,
			id_orden_trabajo,
			id_usuario_ai,
			id_usuario_reg,
			usuario_ai,
			fecha_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.id_suborden,
			'activo',
			v_parametros.id_orden_trabajo,
			v_parametros._id_usuario_ai,
			p_id_usuario,
			v_parametros._nombre_usuario_ai,
			now(),
			null,
			null
							
			
			
			)RETURNING id_orden_suborden into v_id_orden_suborden;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Ordenes Relacioandas almacenado(a) con exito (id_orden_suborden'||v_id_orden_suborden||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_orden_suborden',v_id_orden_suborden::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_ORSUO_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		15-05-2017 10:36:02
	***********************************/

	elsif(p_transaccion='CONTA_ORSUO_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.torden_suborden set
			id_suborden = v_parametros.id_suborden,
			id_orden_trabajo = v_parametros.id_orden_trabajo,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_orden_suborden=v_parametros.id_orden_suborden;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Ordenes Relacioandas modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_orden_suborden',v_parametros.id_orden_suborden::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_ORSUO_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		15-05-2017 10:36:02
	***********************************/

	elsif(p_transaccion='CONTA_ORSUO_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.torden_suborden
            where id_orden_suborden=v_parametros.id_orden_suborden;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Ordenes Relacioandas eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_orden_suborden',v_parametros.id_orden_suborden::varchar);
              
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
ALTER FUNCTION "conta"."ft_orden_suborden_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
