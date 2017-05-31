CREATE OR REPLACE FUNCTION "conta"."ft_persona_naturales_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_persona_naturales_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tpersona_naturales'
 AUTOR: 		 (admin)
 FECHA:	        31-05-2017 20:17:08
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
	v_id_persona_natural	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_persona_naturales_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_PNS_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		31-05-2017 20:17:08
	***********************************/

	if(p_transaccion='CONTA_PNS_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.tpersona_naturales(
			precio_unitario,
			descripcion,
			codigo_cliente,
			capacidad,
			codigo_producto,
			estado_reg,
			nombre,
			importe_total,
			nro_identificacion,
			cantidad_producto,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.precio_unitario,
			v_parametros.descripcion,
			v_parametros.codigo_cliente,
			v_parametros.capacidad,
			v_parametros.codigo_producto,
			'activo',
			v_parametros.nombre,
			v_parametros.importe_total,
			v_parametros.nro_identificacion,
			v_parametros.cantidad_producto,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_persona_natural into v_id_persona_natural;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Persona Naturales almacenado(a) con exito (id_persona_natural'||v_id_persona_natural||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_persona_natural',v_id_persona_natural::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_PNS_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		31-05-2017 20:17:08
	***********************************/

	elsif(p_transaccion='CONTA_PNS_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.tpersona_naturales set
			precio_unitario = v_parametros.precio_unitario,
			descripcion = v_parametros.descripcion,
			codigo_cliente = v_parametros.codigo_cliente,
			capacidad = v_parametros.capacidad,
			codigo_producto = v_parametros.codigo_producto,
			nombre = v_parametros.nombre,
			importe_total = v_parametros.importe_total,
			nro_identificacion = v_parametros.nro_identificacion,
			cantidad_producto = v_parametros.cantidad_producto,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_persona_natural=v_parametros.id_persona_natural;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Persona Naturales modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_persona_natural',v_parametros.id_persona_natural::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_PNS_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		31-05-2017 20:17:08
	***********************************/

	elsif(p_transaccion='CONTA_PNS_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tpersona_naturales
            where id_persona_natural=v_parametros.id_persona_natural;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Persona Naturales eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_persona_natural',v_parametros.id_persona_natural::varchar);
              
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
ALTER FUNCTION "conta"."ft_persona_naturales_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
