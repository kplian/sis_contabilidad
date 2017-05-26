CREATE OR REPLACE FUNCTION "conta"."ft_int_trans_val_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_int_trans_val_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tint_trans_val'
 AUTOR: 		 (admin)
 FECHA:	        01-09-2013 18:04:55
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
	v_id_int_trans_val	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_int_trans_val_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_TRAVAL_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		01-09-2013 18:04:55
	***********************************/

	if(p_transaccion='CONTA_TRAVAL_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.tint_trans_val(
			importe_haber,
			importe_gasto,
			importe_recurso,
			estado_reg,
			id_moneda,
			id_int_transaccion,
			importe_debe,
			id_usuario_reg,
			fecha_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.importe_haber,
			v_parametros.importe_gasto,
			v_parametros.importe_recurso,
			'activo',
			v_parametros.id_moneda,
			v_parametros.id_int_transaccion,
			v_parametros.importe_debe,
			p_id_usuario,
			now(),
			null,
			null
							
			)RETURNING id_int_trans_val into v_id_int_trans_val;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Transacción Valor almacenado(a) con exito (id_int_trans_val'||v_id_int_trans_val||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_int_trans_val',v_id_int_trans_val::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_TRAVAL_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		01-09-2013 18:04:55
	***********************************/

	elsif(p_transaccion='CONTA_TRAVAL_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.tint_trans_val set
			importe_haber = v_parametros.importe_haber,
			importe_gasto = v_parametros.importe_gasto,
			importe_recurso = v_parametros.importe_recurso,
			id_moneda = v_parametros.id_moneda,
			id_int_transaccion = v_parametros.id_int_transaccion,
			importe_debe = v_parametros.importe_debe,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now()
			where id_int_trans_val=v_parametros.id_int_trans_val;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Transacción Valor modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_int_trans_val',v_parametros.id_int_trans_val::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_TRAVAL_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		01-09-2013 18:04:55
	***********************************/

	elsif(p_transaccion='CONTA_TRAVAL_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tint_trans_val
            where id_int_trans_val=v_parametros.id_int_trans_val;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Transacción Valor eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_int_trans_val',v_parametros.id_int_trans_val::varchar);
              
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
ALTER FUNCTION "conta"."ft_int_trans_val_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
