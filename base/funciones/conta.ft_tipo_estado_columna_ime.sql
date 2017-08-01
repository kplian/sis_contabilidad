--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_tipo_estado_columna_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_tipo_estado_columna_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.ttipo_estado_columna'
 AUTOR: 		 (admin)
 FECHA:	        26-07-2017 21:49:56
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
	v_id_tipo_estado_columna	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_tipo_estado_columna_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_TECC_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		26-07-2017 21:49:56
	***********************************/

	if(p_transaccion='CONTA_TECC_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.ttipo_estado_columna(
                codigo,
                link_int_det,
                origen,
                id_config_subtipo_cuenta,
                nombre,
                nombre_funcion,
                estado_reg,
                id_usuario_ai,
                fecha_reg,
                usuario_ai,
                id_usuario_reg,
                fecha_mod,
                id_usuario_mod,
                prioridad,
                id_tipo_estado_cuenta,
                descripcion,
                nombre_clase,
                parametros_det 
                
          	) values(
                v_parametros.codigo,
                v_parametros.link_int_det,
                v_parametros.origen,
                v_parametros.id_config_subtipo_cuenta,
                v_parametros.nombre,
                v_parametros.nombre_funcion,
                'activo',
                v_parametros._id_usuario_ai,
                now(),
                v_parametros._nombre_usuario_ai,
                p_id_usuario,
                null,
                null,
                v_parametros.prioridad,
                v_parametros.id_tipo_estado_cuenta,
                v_parametros.descripcion,
                v_parametros.nombre_clase,
                v_parametros.parametros_det 
							
			
			
			)RETURNING id_tipo_estado_columna into v_id_tipo_estado_columna;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Columnas del Tipo de Estado de Cuentas almacenado(a) con exito (id_tipo_estado_columna'||v_id_tipo_estado_columna||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_estado_columna',v_id_tipo_estado_columna::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_TECC_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		26-07-2017 21:49:56
	***********************************/

	elsif(p_transaccion='CONTA_TECC_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.ttipo_estado_columna set
                codigo = v_parametros.codigo,
                link_int_det = v_parametros.link_int_det,
                origen = v_parametros.origen,
                id_config_subtipo_cuenta = v_parametros.id_config_subtipo_cuenta,
                nombre = v_parametros.nombre,
                nombre_funcion = v_parametros.nombre_funcion,
                fecha_mod = now(),
                id_usuario_mod = p_id_usuario,
                id_usuario_ai = v_parametros._id_usuario_ai,
                usuario_ai = v_parametros._nombre_usuario_ai,
                prioridad = v_parametros.prioridad,
                id_tipo_estado_cuenta = v_parametros.id_tipo_estado_cuenta,
                descripcion = v_parametros.descripcion,
                nombre_clase = v_parametros.nombre_clase,
                parametros_det  = v_parametros.parametros_det 
			where id_tipo_estado_columna=v_parametros.id_tipo_estado_columna;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Columnas del Tipo de Estado de Cuentas modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_estado_columna',v_parametros.id_tipo_estado_columna::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_TECC_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		26-07-2017 21:49:56
	***********************************/

	elsif(p_transaccion='CONTA_TECC_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.ttipo_estado_columna
            where id_tipo_estado_columna=v_parametros.id_tipo_estado_columna;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Columnas del Tipo de Estado de Cuentas eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_estado_columna',v_parametros.id_tipo_estado_columna::varchar);
              
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