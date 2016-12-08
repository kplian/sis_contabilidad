--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_clase_comprobante_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_clase_comprobante_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tclase_comprobante'
 AUTOR: 		 (admin)
 FECHA:	        27-05-2013 16:07:00
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
	v_id_clase_comprobante	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_clase_comprobante_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_CCOM_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		27-05-2013 16:07:00
	***********************************/

	if(p_transaccion='CONTA_CCOM_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.tclase_comprobante(
                id_documento,
                tipo_comprobante,
                descripcion,
                estado_reg,
                id_usuario_reg,
                fecha_reg,
                fecha_mod,
                id_usuario_mod,
                codigo,
                momento_comprometido,
                momento_ejecutado,
                momento_pagado,
                tiene_apertura,
                movimiento
          	) values(
              v_parametros.id_documento,
              v_parametros.tipo_comprobante,
              v_parametros.descripcion,
              'activo',
              p_id_usuario,
              now(),
              null,
              null,
              v_parametros.codigo,
              v_parametros.momento_comprometido,
              v_parametros.momento_ejecutado,
              v_parametros.momento_pagado,
              v_parametros.tiene_apertura,
              v_parametros.movimiento
							
			)RETURNING id_clase_comprobante into v_id_clase_comprobante;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Clase Comprobante almacenado(a) con exito (id_clase_comprobante'||v_id_clase_comprobante||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_clase_comprobante',v_id_clase_comprobante::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CCOM_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		27-05-2013 16:07:00
	***********************************/

	elsif(p_transaccion='CONTA_CCOM_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.tclase_comprobante set
                id_documento = v_parametros.id_documento,
                tipo_comprobante = v_parametros.tipo_comprobante,
                descripcion = v_parametros.descripcion,
                fecha_mod = now(),
                id_usuario_mod = p_id_usuario,
                codigo = v_parametros.codigo,
                momento_comprometido = v_parametros.momento_comprometido,
                momento_ejecutado = v_parametros.momento_ejecutado,
                momento_pagado = v_parametros.momento_pagado,
                tiene_apertura = v_parametros.tiene_apertura,
                movimiento = v_parametros.movimiento
			where id_clase_comprobante=v_parametros.id_clase_comprobante;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Clase Comprobante modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_clase_comprobante',v_parametros.id_clase_comprobante::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CCOM_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		27-05-2013 16:07:00
	***********************************/

	elsif(p_transaccion='CONTA_CCOM_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tclase_comprobante
            where id_clase_comprobante=v_parametros.id_clase_comprobante;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Clase Comprobante eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_clase_comprobante',v_parametros.id_clase_comprobante::varchar);
              
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