--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_tipo_estado_cuenta_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_tipo_estado_cuenta_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.ttipo_estado_cuenta'
 AUTOR: 		 (admin)
 FECHA:	        26-07-2017 21:48:36
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
	v_id_tipo_estado_cuenta	integer;
    v_registros				record;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_tipo_estado_cuenta_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_TEC_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		26-07-2017 21:48:36
	***********************************/

	if(p_transaccion='CONTA_TEC_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.ttipo_estado_cuenta(
              codigo,
              estado_reg,
              columna_codigo_aux,
              columna_id_tabla,
              tabla,
              nombre,
              usuario_ai,
              fecha_reg,
              id_usuario_reg,
              id_usuario_ai,
              id_usuario_mod,
              fecha_mod
          	) values(
              v_parametros.codigo,
              'activo',
              v_parametros.columna_codigo_aux,
              v_parametros.columna_id_tabla,
              v_parametros.tabla,
              v_parametros.nombre,
              v_parametros._nombre_usuario_ai,
              now(),
              p_id_usuario,
              v_parametros._id_usuario_ai,
              null,
              null
							
			
			
			)RETURNING id_tipo_estado_cuenta into v_id_tipo_estado_cuenta;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Estado de Cuentas almacenado(a) con exito (id_tipo_estado_cuenta'||v_id_tipo_estado_cuenta||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_estado_cuenta',v_id_tipo_estado_cuenta::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_TEC_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		26-07-2017 21:48:36
	***********************************/

	elsif(p_transaccion='CONTA_TEC_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.ttipo_estado_cuenta set
			codigo = v_parametros.codigo,
			columna_codigo_aux = v_parametros.columna_codigo_aux,
			columna_id_tabla = v_parametros.columna_id_tabla,
			tabla = v_parametros.tabla,
			nombre = v_parametros.nombre,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_tipo_estado_cuenta=v_parametros.id_tipo_estado_cuenta;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Estado de Cuentas modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_estado_cuenta',v_parametros.id_tipo_estado_cuenta::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;
       --------------   
      
     /*********************************    
 	#TRANSACCION:  'CONTA_TEC_GET'
 	#DESCRIPCION:	Recupera los datos de la tipo estado de cuenta 
 	#AUTOR:		manu	
 	#FECHA:		10-10-2017 16:03:19
	***********************************/

	elsif(p_transaccion='CONTA_TEC_GET')then
		begin
			--Sentencia de la    eliminacion		
            select b.nombre,b.codigo,b.id_tipo_estado_cuenta,b.tabla
            into v_registros
            from conta.ttipo_estado_cuenta b               
            where b.estado_reg='activo' and b.id_tipo_estado_cuenta= v_parametros.id_tipo_estado_cuenta;
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Dato recuperada(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'nombre',v_registros.nombre::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'codigo',v_registros.codigo::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_estado_cuenta',v_registros.id_tipo_estado_cuenta::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'tabla',v_registros.tabla::varchar);                        
            --Devuelve la respuesta
            return v_resp;
		end; 
    
    ---------------------  

	/*********************************    
 	#TRANSACCION:  'CONTA_TEC_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		26-07-2017 21:48:36
	***********************************/

	elsif(p_transaccion='CONTA_TEC_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.ttipo_estado_cuenta
            where id_tipo_estado_cuenta=v_parametros.id_tipo_estado_cuenta;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Estado de Cuentas eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_estado_cuenta',v_parametros.id_tipo_estado_cuenta::varchar);
              
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