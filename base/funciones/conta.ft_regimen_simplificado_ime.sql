CREATE OR REPLACE FUNCTION "conta"."ft_regimen_simplificado_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_regimen_simplificado_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tregimen_simplificado'
 AUTOR: 		 (admin)
 FECHA:	        31-05-2017 20:17:05
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
	v_id_simplificado	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_regimen_simplificado_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_RSO_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		31-05-2017 20:17:05
	***********************************/

	if(p_transaccion='CONTA_RSO_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.tregimen_simplificado(
			precio_unitario,
			descripcion,
			codigo_cliente,
			cantidad_bonificado,
			codigo_producto,
			estado_reg,
			descripcion_bonificado,
			importe_bonificado,
			nombre,
			descuento,
			cantidad_bonificacion,
			cantidad_producto,
			nit,
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
			v_parametros.cantidad_bonificado,
			v_parametros.codigo_producto,
			'activo',
			v_parametros.descripcion_bonificado,
			v_parametros.importe_bonificado,
			v_parametros.nombre,
			v_parametros.descuento,
			v_parametros.cantidad_bonificacion,
			v_parametros.cantidad_producto,
			v_parametros.nit,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_simplificado into v_id_simplificado;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Regimen Simplificado  almacenado(a) con exito (id_simplificado'||v_id_simplificado||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_simplificado',v_id_simplificado::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_RSO_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		31-05-2017 20:17:05
	***********************************/

	elsif(p_transaccion='CONTA_RSO_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.tregimen_simplificado set
			precio_unitario = v_parametros.precio_unitario,
			descripcion = v_parametros.descripcion,
			codigo_cliente = v_parametros.codigo_cliente,
			cantidad_bonificado = v_parametros.cantidad_bonificado,
			codigo_producto = v_parametros.codigo_producto,
			descripcion_bonificado = v_parametros.descripcion_bonificado,
			importe_bonificado = v_parametros.importe_bonificado,
			nombre = v_parametros.nombre,
			descuento = v_parametros.descuento,
			cantidad_bonificacion = v_parametros.cantidad_bonificacion,
			cantidad_producto = v_parametros.cantidad_producto,
			nit = v_parametros.nit,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_simplificado=v_parametros.id_simplificado;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Regimen Simplificado  modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_simplificado',v_parametros.id_simplificado::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_RSO_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		31-05-2017 20:17:05
	***********************************/

	elsif(p_transaccion='CONTA_RSO_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tregimen_simplificado
            where id_simplificado=v_parametros.id_simplificado;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Regimen Simplificado  eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_simplificado',v_parametros.id_simplificado::varchar);
              
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
ALTER FUNCTION "conta"."ft_regimen_simplificado_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
