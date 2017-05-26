CREATE OR REPLACE FUNCTION "conta"."ft_bancarizacion_periodo_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_bancarizacion_periodo_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tbancarizacion_periodo'
 AUTOR: 		 (favio.figueroa)
 FECHA:	        24-05-2017 16:07:40
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
	v_id_bancarizacion_periodo	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_bancarizacion_periodo_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_BANCAPER_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		favio.figueroa	
 	#FECHA:		24-05-2017 16:07:40
	***********************************/

	if(p_transaccion='CONTA_BANCAPER_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.tbancarizacion_periodo(
			id_periodo,
			estado_reg,
			estado,
			usuario_ai,
			fecha_reg,
			id_usuario_reg,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.id_periodo,
			'activo',
			v_parametros.estado,
			v_parametros._nombre_usuario_ai,
			now(),
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_bancarizacion_periodo into v_id_bancarizacion_periodo;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Bancarizacion Periodo almacenado(a) con exito (id_bancarizacion_periodo'||v_id_bancarizacion_periodo||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_bancarizacion_periodo',v_id_bancarizacion_periodo::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_BANCAPER_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		favio.figueroa	
 	#FECHA:		24-05-2017 16:07:40
	***********************************/

	elsif(p_transaccion='CONTA_BANCAPER_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.tbancarizacion_periodo set
			id_periodo = v_parametros.id_periodo,
			estado = v_parametros.estado,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_bancarizacion_periodo=v_parametros.id_bancarizacion_periodo;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Bancarizacion Periodo modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_bancarizacion_periodo',v_parametros.id_bancarizacion_periodo::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_BANCAPER_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		favio.figueroa	
 	#FECHA:		24-05-2017 16:07:40
	***********************************/

	elsif(p_transaccion='CONTA_BANCAPER_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tbancarizacion_periodo
            where id_bancarizacion_periodo=v_parametros.id_bancarizacion_periodo;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Bancarizacion Periodo eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_bancarizacion_periodo',v_parametros.id_bancarizacion_periodo::varchar);
              
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
ALTER FUNCTION "conta"."ft_bancarizacion_periodo_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
