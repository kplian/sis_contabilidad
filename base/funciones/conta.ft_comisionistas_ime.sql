CREATE OR REPLACE FUNCTION "conta"."ft_comisionistas_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_comisionistas_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tcomisionistas'
 AUTOR: 		 (admin)
 FECHA:	        31-05-2017 20:17:02
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
	v_id_comisionista	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_comisionistas_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_CMS_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		31-05-2017 20:17:02
	***********************************/

	if(p_transaccion='CONTA_CMS_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.tcomisionistas(
			capacidad_envace,
			nit,
			codigo,
			cantidad,
			estado_reg,
			porcentaje,
			descripcion,
			documento_entrega,
			monto_total,
			nro_documento,
			razon_social,
			fecha_fin,
			fecha_ini,
			precio_unitario,
			id_usuario_reg,
			usuario_ai,
			fecha_reg,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.capacidad_envace,
			v_parametros.nit,
			v_parametros.codigo,
			v_parametros.cantidad,
			'activo',
			v_parametros.porcentaje,
			v_parametros.descripcion,
			v_parametros.documento_entrega,
			v_parametros.monto_total,
			v_parametros.nro_documento,
			v_parametros.razon_social,
			v_parametros.fecha_fin,
			v_parametros.fecha_ini,
			v_parametros.precio_unitario,
			p_id_usuario,
			v_parametros._nombre_usuario_ai,
			now(),
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_comisionista into v_id_comisionista;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Comisionistas  almacenado(a) con exito (id_comisionista'||v_id_comisionista||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_comisionista',v_id_comisionista::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CMS_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		31-05-2017 20:17:02
	***********************************/

	elsif(p_transaccion='CONTA_CMS_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.tcomisionistas set
			capacidad_envace = v_parametros.capacidad_envace,
			nit = v_parametros.nit,
			codigo = v_parametros.codigo,
			cantidad = v_parametros.cantidad,
			porcentaje = v_parametros.porcentaje,
			descripcion = v_parametros.descripcion,
			documento_entrega = v_parametros.documento_entrega,
			monto_total = v_parametros.monto_total,
			nro_documento = v_parametros.nro_documento,
			razon_social = v_parametros.razon_social,
			fecha_fin = v_parametros.fecha_fin,
			fecha_ini = v_parametros.fecha_ini,
			precio_unitario = v_parametros.precio_unitario,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_comisionista=v_parametros.id_comisionista;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Comisionistas  modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_comisionista',v_parametros.id_comisionista::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CMS_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		31-05-2017 20:17:02
	***********************************/

	elsif(p_transaccion='CONTA_CMS_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tcomisionistas
            where id_comisionista=v_parametros.id_comisionista;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Comisionistas  eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_comisionista',v_parametros.id_comisionista::varchar);
              
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
ALTER FUNCTION "conta"."ft_comisionistas_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
