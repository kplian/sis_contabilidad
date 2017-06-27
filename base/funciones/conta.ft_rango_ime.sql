CREATE OR REPLACE FUNCTION "conta"."ft_rango_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_rango_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.trango'
 AUTOR: 		 (admin)
 FECHA:	        22-06-2017 21:30:05
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
	v_id_rango	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_rango_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_RAN_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		22-06-2017 21:30:05
	***********************************/

	if(p_transaccion='CONTA_RAN_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.trango(
			id_periodo,
			haber_mb,
			debe_mb,
			debe_mt,
			estado_reg,
			id_tipo_cc,
			haber_mt,
			id_usuario_ai,
			usuario_ai,
			fecha_reg,
			id_usuario_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.id_periodo,
			v_parametros.haber_mb,
			v_parametros.debe_mb,
			v_parametros.debe_mt,
			'activo',
			v_parametros.id_tipo_cc,
			v_parametros.haber_mt,
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			now(),
			p_id_usuario,
			null,
			null
							
			
			
			)RETURNING id_rango into v_id_rango;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Rangos de Costo almacenado(a) con exito (id_rango'||v_id_rango||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_rango',v_id_rango::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_RAN_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		22-06-2017 21:30:05
	***********************************/

	elsif(p_transaccion='CONTA_RAN_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.trango set
			id_periodo = v_parametros.id_periodo,
			haber_mb = v_parametros.haber_mb,
			debe_mb = v_parametros.debe_mb,
			debe_mt = v_parametros.debe_mt,
			id_tipo_cc = v_parametros.id_tipo_cc,
			haber_mt = v_parametros.haber_mt,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_rango=v_parametros.id_rango;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Rangos de Costo modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_rango',v_parametros.id_rango::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_RAN_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		22-06-2017 21:30:05
	***********************************/

	elsif(p_transaccion='CONTA_RAN_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.trango
            where id_rango=v_parametros.id_rango;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Rangos de Costo eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_rango',v_parametros.id_rango::varchar);
              
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
ALTER FUNCTION "conta"."ft_rango_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
