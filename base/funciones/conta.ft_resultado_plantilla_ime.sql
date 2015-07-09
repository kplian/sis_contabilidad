CREATE OR REPLACE FUNCTION "conta"."ft_resultado_plantilla_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_resultado_plantilla_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tresultado_plantilla'
 AUTOR: 		 (admin)
 FECHA:	        08-07-2015 13:12:43
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
	v_id_resultado_plantilla	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_resultado_plantilla_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_RESPLAN_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		08-07-2015 13:12:43
	***********************************/

	if(p_transaccion='CONTA_RESPLAN_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.tresultado_plantilla(
			codigo,
			estado_reg,
			nombre,
			id_usuario_reg,
			usuario_ai,
			fecha_reg,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.codigo,
			'activo',
			v_parametros.nombre,
			p_id_usuario,
			v_parametros._nombre_usuario_ai,
			now(),
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_resultado_plantilla into v_id_resultado_plantilla;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Plantilla de Resultados almacenado(a) con exito (id_resultado_plantilla'||v_id_resultado_plantilla||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_resultado_plantilla',v_id_resultado_plantilla::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_RESPLAN_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		08-07-2015 13:12:43
	***********************************/

	elsif(p_transaccion='CONTA_RESPLAN_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.tresultado_plantilla set
			codigo = v_parametros.codigo,
			nombre = v_parametros.nombre,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_resultado_plantilla=v_parametros.id_resultado_plantilla;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Plantilla de Resultados modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_resultado_plantilla',v_parametros.id_resultado_plantilla::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_RESPLAN_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		08-07-2015 13:12:43
	***********************************/

	elsif(p_transaccion='CONTA_RESPLAN_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tresultado_plantilla
            where id_resultado_plantilla=v_parametros.id_resultado_plantilla;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Plantilla de Resultados eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_resultado_plantilla',v_parametros.id_resultado_plantilla::varchar);
              
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
ALTER FUNCTION "conta"."ft_resultado_plantilla_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
