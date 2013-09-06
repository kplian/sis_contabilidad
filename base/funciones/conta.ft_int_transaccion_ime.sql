CREATE OR REPLACE FUNCTION "conta"."ft_int_transaccion_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_int_transaccion_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tint_transaccion'
 AUTOR: 		 (admin)
 FECHA:	        01-09-2013 18:10:12
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
	v_id_int_transaccion	integer;
 
BEGIN

    v_nombre_funcion = 'conta.ft_int_transaccion_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_INTRANSA_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		01-09-2013 18:10:12
	***********************************/

	if(p_transaccion='CONTA_INTRANSA_INS')then
					
        begin
        	---------------
        	--VALIDACIONES
        	---------------

        
        	-----------------------------
        	--REGISTRO DE LA TRANSACCIÓN
        	-----------------------------
        	insert into conta.tint_transaccion(
			id_partida,
			id_centro_costo,
			id_partida_ejecucion,
			estado_reg,
			id_int_transaccion_fk,
			id_cuenta,
			glosa,
			id_int_comprobante,
			id_auxiliar,
			importe_debe,
			importe_haber,
			importe_gasto,
			importe_recurso,
			id_usuario_reg,
			fecha_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.id_partida,
			v_parametros.id_centro_costo,
			v_parametros.id_partida_ejecucion,
			'activo',
			v_parametros.id_int_transaccion_fk,
			v_parametros.id_cuenta,
			v_parametros.glosa,
			v_parametros.id_int_comprobante,
			v_parametros.id_auxiliar,
			v_parametros.importe_debe,
			v_parametros.importe_haber,
			v_parametros.importe_gasto,
			v_parametros.importe_recurso,
			p_id_usuario,
			now(),
			null,
			null
			)RETURNING id_int_transaccion into v_id_int_transaccion;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Transacción almacenado(a) con exito (id_int_transaccion'||v_id_int_transaccion||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_int_transaccion',v_id_int_transaccion::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_INTRANSA_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		01-09-2013 18:10:12
	***********************************/

	elsif(p_transaccion='CONTA_INTRANSA_MOD')then

		begin
			---------------
        	--VALIDACIONES
        	---------------
        	--VerIfica el estado
        	if not exists(select 1 from conta.tint_transaccion tra
			        	inner join conta.tint_comprobante cbte
			        	on cbte.id_int_comprobante = tra.id_int_comprobante
			        	where tra.id_int_transaccion = v_parametros.id_int_transaccion
        				and cbte.estado_reg = 'borrador') then
        		raise exception 'Modificación no realizada: el comprobante no está en estado Borrador';
        	end if;
		
			--------------------------------
			--MODIFICACION DE LA TRANSACCION
			--------------------------------
			update conta.tint_transaccion set
			id_partida = v_parametros.id_partida,
			id_centro_costo = v_parametros.id_centro_costo,
			id_partida_ejecucion = v_parametros.id_partida_ejecucion,
			id_int_transaccion_fk = v_parametros.id_int_transaccion_fk,
			id_cuenta = v_parametros.id_cuenta,
			glosa = v_parametros.glosa,
			id_int_comprobante = v_parametros.id_int_comprobante,
			id_auxiliar = v_parametros.id_auxiliar,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			importe_debe = v_parametros.importe_debe,
			importe_haber = v_parametros.importe_haber,
			importe_gasto = v_parametros.importe_gasto,
			importe_recurso = v_parametros.importe_recurso
			where id_int_transaccion=v_parametros.id_int_transaccion;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Transacción modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_int_transaccion',v_parametros.id_int_transaccion::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_INTRANSA_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		01-09-2013 18:10:12
	***********************************/

	elsif(p_transaccion='CONTA_INTRANSA_ELI')then

		begin
		
			---------------
        	--VALIDACIONES
        	---------------
        	--VerIfica el estado, solamente puede eliminarse cuando esté en estao borrador
        	if not exists(select 1 from conta.tint_transaccion tra
			        	inner join conta.tint_comprobante cbte
			        	on cbte.id_int_comprobante = tra.id_int_comprobante
			        	where tra.id_int_transaccion = v_parametros.id_int_transaccion
        				and cbte.estado_reg = 'borrador') then
        		raise exception 'Eliminación no realizada: el comprobante no está en estado Borrador';
        	end if;

            --------------------------
			--ELIMINACIÓN TRANSACCIÓN 
			--------------------------
			delete from conta.tint_transaccion
            where id_int_transaccion=v_parametros.id_int_transaccion;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Transacción eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_int_transaccion',v_parametros.id_int_transaccion::varchar);
              
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
ALTER FUNCTION "conta"."ft_int_transaccion_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
