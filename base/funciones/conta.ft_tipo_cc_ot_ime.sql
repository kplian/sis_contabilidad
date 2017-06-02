--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_tipo_cc_ot_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_tipo_cc_ot_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.ttipo_cc_ot'
 AUTOR: 		 (admin)
 FECHA:	        31-05-2017 22:07:39
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
	v_id_tipo_cc_ot	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_tipo_cc_ot_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_FTO_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		31-05-2017 22:07:39
	***********************************/

	if(p_transaccion='CONTA_FTO_INS')then
					
        begin
            
            --verificar que las relaciones sean unicas
        
        	--Sentencia de la insercion
        	insert into conta.ttipo_cc_ot(
                id_orden_trabajo,
                estado_reg,
                id_tipo_cc,
                id_usuario_ai,
                id_usuario_reg,
                usuario_ai,
                fecha_reg,
                id_usuario_mod,
                fecha_mod
          	) values(
                v_parametros.id_orden_trabajo,
                'activo',
                v_parametros.id_tipo_cc,
                v_parametros._id_usuario_ai,
                p_id_usuario,
                v_parametros._nombre_usuario_ai,
                now(),
                null,
                null
							
			
			
			)RETURNING id_tipo_cc_ot into v_id_tipo_cc_ot;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Filtro TCC almacenado(a) con exito (id_tipo_cc_ot'||v_id_tipo_cc_ot||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_cc_ot',v_id_tipo_cc_ot::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_FTO_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		31-05-2017 22:07:39
	***********************************/

	elsif(p_transaccion='CONTA_FTO_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.ttipo_cc_ot set
			id_orden_trabajo = v_parametros.id_orden_trabajo,
			id_tipo_cc = v_parametros.id_tipo_cc,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_tipo_cc_ot=v_parametros.id_tipo_cc_ot;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Filtro TCC modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_cc_ot',v_parametros.id_tipo_cc_ot::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_FTO_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		31-05-2017 22:07:39
	***********************************/

	elsif(p_transaccion='CONTA_FTO_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.ttipo_cc_ot
            where id_tipo_cc_ot=v_parametros.id_tipo_cc_ot;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Filtro TCC eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_cc_ot',v_parametros.id_tipo_cc_ot::varchar);
              
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
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;