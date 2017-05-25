--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_suborden_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_suborden_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tsuborden'
 AUTOR: 		 (admin)
 FECHA:	        15-05-2017 09:57:38
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
	v_id_suborden			integer;
    v_registros				record;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_suborden_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_SUO_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		15-05-2017 09:57:38
	***********************************/

	if(p_transaccion='CONTA_SUO_INS')then
					
        begin
           
           IF EXISTS(
              select 
               1
              from conta.tsuborden suo 
              where suo.codigo = upper(v_parametros.codigo) 
                    and suo.estado_reg = 'activo') THEN                  
               raise exception 'ya existe otra suborden con el código %',v_parametros.codigo;      
            END IF;  
        
        	--Sentencia de la insercion
        	insert into conta.tsuborden(
                estado_reg,
                estado,
                nombre,
                codigo,
                id_usuario_reg,
                fecha_reg,
                usuario_ai,
                id_usuario_ai,
                id_usuario_mod,
                fecha_mod
          	) values(
                'activo',
                v_parametros.estado,
                v_parametros.nombre,
                upper(v_parametros.codigo),
                p_id_usuario,
                now(),
                v_parametros._nombre_usuario_ai,
                v_parametros._id_usuario_ai,
                null,
                null
							
			
			
			)RETURNING id_suborden into v_id_suborden;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Sub Orden almacenado(a) con exito (id_suborden'||v_id_suborden||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_suborden',v_id_suborden::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_SUO_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		15-05-2017 09:57:38
	***********************************/

	elsif(p_transaccion='CONTA_SUO_MOD')then

		begin
        
            IF EXISTS(
              select 
               1
              from conta.tsuborden suo 
              where suo.codigo = upper(v_parametros.codigo) 
                    and suo.estado_reg = 'activo'
                    and suo.id_suborden != v_parametros.id_suborden ) THEN                  
               raise exception 'ya existe otra suborden con el código %',v_parametros.codigo;      
            END IF; 
			--Sentencia de la modificacion
			update conta.tsuborden set
                estado = v_parametros.estado,
                nombre = v_parametros.nombre,
                codigo = upper(v_parametros.codigo),
                id_usuario_mod = p_id_usuario,
                fecha_mod = now(),
                id_usuario_ai = v_parametros._id_usuario_ai,
                usuario_ai = v_parametros._nombre_usuario_ai
			where id_suborden=v_parametros.id_suborden;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Sub Orden modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_suborden',v_parametros.id_suborden::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_SUO_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		15-05-2017 09:57:38
	***********************************/

	elsif(p_transaccion='CONTA_SUO_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tsuborden
            where id_suborden=v_parametros.id_suborden;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Sub Orden eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_suborden',v_parametros.id_suborden::varchar);
              
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