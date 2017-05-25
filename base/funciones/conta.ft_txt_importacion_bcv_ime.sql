CREATE OR REPLACE FUNCTION conta.ft_txt_importacion_bcv_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_txt_importacion_bcv_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.ttxt_importacion_bcv'
 AUTOR: 		 (admin)
 FECHA:	        03-12-2015 16:57:22
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
	v_id_txt_importacion_bcv	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_txt_importacion_bcv_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_imptxt_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		03-12-2015 16:57:22
	***********************************/

	if(p_transaccion='CONTA_imptxt_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.ttxt_importacion_bcv(
			nombre_archivo,
			id_periodo,
			estado_reg,
			id_usuario_ai,
			usuario_ai,
			fecha_reg,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.nombre_archivo,
			v_parametros.id_periodo,
			'activo',
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			now(),
			p_id_usuario,
			null,
			null
							
			
			
			)RETURNING id_txt_importacion_bcv into v_id_txt_importacion_bcv;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','importacion txt bcv almacenado(a) con exito (id_txt_importacion_bcv'||v_id_txt_importacion_bcv||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_txt_importacion_bcv',v_id_txt_importacion_bcv::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_imptxt_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		03-12-2015 16:57:22
	***********************************/

	elsif(p_transaccion='CONTA_imptxt_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.ttxt_importacion_bcv set
			nombre_archivo = v_parametros.nombre_archivo,
			id_periodo = v_parametros.id_periodo,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_txt_importacion_bcv=v_parametros.id_txt_importacion_bcv;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','importacion txt bcv modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_txt_importacion_bcv',v_parametros.id_txt_importacion_bcv::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_imptxt_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		03-12-2015 16:57:22
	***********************************/

	elsif(p_transaccion='CONTA_imptxt_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.ttxt_importacion_bcv
            where id_txt_importacion_bcv=v_parametros.id_txt_importacion_bcv;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','importacion txt bcv eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_txt_importacion_bcv',v_parametros.id_txt_importacion_bcv::varchar);
              
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