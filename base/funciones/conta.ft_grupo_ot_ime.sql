CREATE OR REPLACE FUNCTION "conta"."ft_grupo_ot_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_grupo_ot_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tgrupo_ot'
 AUTOR: 		 (admin)
 FECHA:	        06-10-2014 14:11:14
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
	v_id_grupo_ot	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_grupo_ot_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_GOT_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		06-10-2014 14:11:14
	***********************************/

	if(p_transaccion='CONTA_GOT_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.tgrupo_ot(
			descripcion,
			estado_reg,
			id_usuario_ai,
			id_usuario_reg,
			usuario_ai,
			fecha_reg,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.descripcion,
			'activo',
			v_parametros._id_usuario_ai,
			p_id_usuario,
			v_parametros._nombre_usuario_ai,
			now(),
			null,
			null
							
			
			
			)RETURNING id_grupo_ot into v_id_grupo_ot;
			
			if (pxp.f_get_variable_global('sincronizar') = 'true') then
                	                    
                    select * FROM dblink(migra.f_obtener_cadena_conexion(), 
                        'SELECT * 
                        FROM sci.f_tct_grupo_ot_iud(' || p_id_usuario || ',''' ||
                        		pxp.f_get_variable_global('sincroniza_ip') || ''',''Sincronizacion'',''CT_GRPOT_INS'',NULL,' || v_id_grupo_ot || ',' ||
                                coalesce ('''' || v_parametros.descripcion::text || '''', 'NULL') || ',' || p_id_usuario||
                                ')',TRUE)AS t1(resp varchar)
                                into v_resp; 
            end if;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Grupo Ot almacenado(a) con exito (id_grupo_ot'||v_id_grupo_ot||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_grupo_ot',v_id_grupo_ot::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_GOT_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		06-10-2014 14:11:14
	***********************************/

	elsif(p_transaccion='CONTA_GOT_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.tgrupo_ot set
			descripcion = v_parametros.descripcion,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_grupo_ot=v_parametros.id_grupo_ot;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Grupo Ot modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_grupo_ot',v_parametros.id_grupo_ot::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_GOT_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		06-10-2014 14:11:14
	***********************************/

	elsif(p_transaccion='CONTA_GOT_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tgrupo_ot
            where id_grupo_ot=v_parametros.id_grupo_ot;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Grupo Ot eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_grupo_ot',v_parametros.id_grupo_ot::varchar);
              
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
ALTER FUNCTION "conta"."ft_grupo_ot_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
