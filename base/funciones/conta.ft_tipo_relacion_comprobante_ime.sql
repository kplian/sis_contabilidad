CREATE OR REPLACE FUNCTION "conta"."ft_tipo_relacion_comprobante_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_tipo_relacion_comprobante_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.ttipo_relacion_comprobante'
 AUTOR: 		 (admin)
 FECHA:	        17-12-2014 19:29:44
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
	v_id_tipo_relacion_comprobante	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_tipo_relacion_comprobante_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_TRC_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		17-12-2014 19:29:44
	***********************************/

	if(p_transaccion='CONTA_TRC_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.ttipo_relacion_comprobante(
			estado_reg,
			nombre,
			codigo,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.nombre,
			v_parametros.codigo,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_tipo_relacion_comprobante into v_id_tipo_relacion_comprobante;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipos de Relaciones entre Comprobantes  almacenado(a) con exito (id_tipo_relacion_comprobante'||v_id_tipo_relacion_comprobante||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_relacion_comprobante',v_id_tipo_relacion_comprobante::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_TRC_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		17-12-2014 19:29:44
	***********************************/

	elsif(p_transaccion='CONTA_TRC_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.ttipo_relacion_comprobante set
			nombre = v_parametros.nombre,
			codigo = v_parametros.codigo,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_tipo_relacion_comprobante=v_parametros.id_tipo_relacion_comprobante;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipos de Relaciones entre Comprobantes  modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_relacion_comprobante',v_parametros.id_tipo_relacion_comprobante::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_TRC_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		17-12-2014 19:29:44
	***********************************/

	elsif(p_transaccion='CONTA_TRC_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.ttipo_relacion_comprobante
            where id_tipo_relacion_comprobante=v_parametros.id_tipo_relacion_comprobante;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipos de Relaciones entre Comprobantes  eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_relacion_comprobante',v_parametros.id_tipo_relacion_comprobante::varchar);
              
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
ALTER FUNCTION "conta"."ft_tipo_relacion_comprobante_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
