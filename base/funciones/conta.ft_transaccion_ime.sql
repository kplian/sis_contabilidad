CREATE OR REPLACE FUNCTION "conta"."ft_transaccion_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_transaccion_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.ttransaccion'
 AUTOR: 		 (admin)
 FECHA:	        22-07-2013 03:51:00
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
	v_id_transaccion	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_transaccion_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_CONTRA_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		22-07-2013 03:51:00
	***********************************/

	if(p_transaccion='CONTA_CONTRA_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.ttransaccion(
			id_comprobante,
			id_cuenta,
			id_auxiliar,
			id_centro_costo,
			id_partida,
			id_transaccion_fk,
			id_partida_ejecucion,
			estado_reg,
			descripcion,
			fecha_reg,
			id_usuario_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.id_comprobante,
			v_parametros.id_cuenta,
			v_parametros.id_auxiliar,
			v_parametros.id_centro_costo,
			v_parametros.id_partida,
			v_parametros.id_transaccion_fk,
			v_parametros.id_partida_ejecucion,
			'activo',
			v_parametros.descripcion,
			now(),
			p_id_usuario,
			null,
			null
							
			)RETURNING id_transaccion into v_id_transaccion;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Transacciones almacenado(a) con exito (id_transaccion'||v_id_transaccion||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_transaccion',v_id_transaccion::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CONTRA_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		22-07-2013 03:51:00
	***********************************/

	elsif(p_transaccion='CONTA_CONTRA_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.ttransaccion set
			id_comprobante = v_parametros.id_comprobante,
			id_cuenta = v_parametros.id_cuenta,
			id_auxiliar = v_parametros.id_auxiliar,
			id_centro_costo = v_parametros.id_centro_costo,
			id_partida = v_parametros.id_partida,
			id_transaccion_fk = v_parametros.id_transaccion_fk,
			id_partida_ejecucion = v_parametros.id_partida_ejecucion,
			descripcion = v_parametros.descripcion,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now()
			where id_transaccion=v_parametros.id_transaccion;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Transacciones modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_transaccion',v_parametros.id_transaccion::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CONTRA_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		22-07-2013 03:51:00
	***********************************/

	elsif(p_transaccion='CONTA_CONTRA_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.ttransaccion
            where id_transaccion=v_parametros.id_transaccion;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Transacciones eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_transaccion',v_parametros.id_transaccion::varchar);
              
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
ALTER FUNCTION "conta"."ft_transaccion_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
