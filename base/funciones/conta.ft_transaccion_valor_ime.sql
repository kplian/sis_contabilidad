CREATE OR REPLACE FUNCTION "conta"."ft_transaccion_valor_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_transaccion_valor_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.ttransaccion_valor'
 AUTOR: 		 (admin)
 FECHA:	        22-07-2013 03:57:28
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
	v_id_transaccion_valor	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_transaccion_valor_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_CONTVA_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		22-07-2013 03:57:28
	***********************************/

	if(p_transaccion='CONTA_CONTVA_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.ttransaccion_valor(
			id_transaccion,
			id_moneda,
			importe_debe,
			estado_reg,
			importe_gasto,
			importe_haber,
			importe_recurso,
			fecha_reg,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.id_transaccion,
			v_parametros.id_moneda,
			v_parametros.importe_debe,
			'activo',
			v_parametros.importe_gasto,
			v_parametros.importe_haber,
			v_parametros.importe_recurso,
			now(),
			p_id_usuario,
			null,
			null
							
			)RETURNING id_transaccion_valor into v_id_transaccion_valor;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Transacción Valor almacenado(a) con exito (id_transaccion_valor'||v_id_transaccion_valor||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_transaccion_valor',v_id_transaccion_valor::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CONTVA_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		22-07-2013 03:57:28
	***********************************/

	elsif(p_transaccion='CONTA_CONTVA_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.ttransaccion_valor set
			id_transaccion = v_parametros.id_transaccion,
			id_moneda = v_parametros.id_moneda,
			importe_debe = v_parametros.importe_debe,
			importe_gasto = v_parametros.importe_gasto,
			importe_haber = v_parametros.importe_haber,
			importe_recurso = v_parametros.importe_recurso,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario
			where id_transaccion_valor=v_parametros.id_transaccion_valor;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Transacción Valor modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_transaccion_valor',v_parametros.id_transaccion_valor::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CONTVA_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		22-07-2013 03:57:28
	***********************************/

	elsif(p_transaccion='CONTA_CONTVA_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.ttransaccion_valor
            where id_transaccion_valor=v_parametros.id_transaccion_valor;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Transacción Valor eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_transaccion_valor',v_parametros.id_transaccion_valor::varchar);
              
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
ALTER FUNCTION "conta"."ft_transaccion_valor_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
