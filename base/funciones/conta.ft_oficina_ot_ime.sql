CREATE OR REPLACE FUNCTION "conta"."ft_oficina_ot_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_oficina_ot_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.toficina_ot'
 AUTOR: 		 (jrivera)
 FECHA:	        09-10-2015 18:48:40
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
	v_id_oficina_ot	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_oficina_ot_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_OFOT_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		jrivera	
 	#FECHA:		09-10-2015 18:48:40
	***********************************/

	if(p_transaccion='CONTA_OFOT_INS')then
		if (exists(select 1
					from conta.toficina_ot
					where id_oficina = v_parametros.id_oficina and estado_reg = 'activo')) then
			raise exception 'Esta oficina ya tiene asignada una ot';
		end if;
					
        begin
        	--Sentencia de la insercion
        	insert into conta.toficina_ot(
			id_oficina,
			id_orden_trabajo,
			estado_reg,
			usuario_ai,
			fecha_reg,
			id_usuario_reg,
			id_usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.id_oficina,
			v_parametros.id_orden_trabajo,
			'activo',
			v_parametros._nombre_usuario_ai,
			now(),
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_oficina_ot into v_id_oficina_ot;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Ot por Oficina almacenado(a) con exito (id_oficina_ot'||v_id_oficina_ot||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_oficina_ot',v_id_oficina_ot::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_OFOT_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		jrivera	
 	#FECHA:		09-10-2015 18:48:40
	***********************************/

	elsif(p_transaccion='CONTA_OFOT_MOD')then

		begin
			if (exists(select 1
					from conta.toficina_ot
					where id_oficina = v_parametros.id_oficina and estado_reg = 'activo'
					and id_oficina_ot != v_parametros.id_oficina_ot)) then
				raise exception 'Esta oficina ya tiene asignada una ot';
			end if;
		
			--Sentencia de la modificacion
			update conta.toficina_ot set
			id_oficina = v_parametros.id_oficina,
			id_orden_trabajo = v_parametros.id_orden_trabajo,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_oficina_ot=v_parametros.id_oficina_ot;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Ot por Oficina modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_oficina_ot',v_parametros.id_oficina_ot::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_OFOT_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		jrivera	
 	#FECHA:		09-10-2015 18:48:40
	***********************************/

	elsif(p_transaccion='CONTA_OFOT_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.toficina_ot
            where id_oficina_ot=v_parametros.id_oficina_ot;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Ot por Oficina eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_oficina_ot',v_parametros.id_oficina_ot::varchar);
              
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
ALTER FUNCTION "conta"."ft_oficina_ot_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
