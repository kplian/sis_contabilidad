--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_tabla_relacion_contable_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_tabla_relacion_contable_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.ttabla_relacion_contable'
 AUTOR: 		 (admin)
 FECHA:	        16-05-2013 21:05:26
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
	v_id_tabla_relacion_contable	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_tabla_relacion_contable_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_TABRECON_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		16-05-2013 21:05:26
	***********************************/

	if(p_transaccion='CONTA_TABRECON_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.ttabla_relacion_contable(
			estado_reg,
			tabla,
			esquema,
            tabla_id,
			fecha_reg,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod,
			tabla_id_fk,
			recorrido_arbol,
            tabla_codigo_auxiliar,
            tabla_id_auxiliar,
            tabla_codigo_aplicacion
            
            
          	) values(
			'activo',
			v_parametros.tabla,
			v_parametros.esquema,
            v_parametros.tabla_id,
			now(),
			p_id_usuario,
			null,
			null,
			v_parametros.tabla_id_fk,
			v_parametros.recorrido_arbol,
            v_parametros.tabla_codigo_auxiliar,
            v_parametros.tabla_id_auxiliar	,
            v_parametros.tabla_codigo_aplicacion		
			)RETURNING id_tabla_relacion_contable into v_id_tabla_relacion_contable;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tabla Relación Contable almacenado(a) con exito (id_tabla_relacion_contable'||v_id_tabla_relacion_contable||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tabla_relacion_contable',v_id_tabla_relacion_contable::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_TABRECON_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		16-05-2013 21:05:26
	***********************************/

	elsif(p_transaccion='CONTA_TABRECON_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.ttabla_relacion_contable set
              tabla = v_parametros.tabla,
              esquema = v_parametros.esquema,
              tabla_id = v_parametros.tabla_id,
              fecha_mod = now(),
              id_usuario_mod = p_id_usuario,
              tabla_id_fk = v_parametros.tabla_id_fk,
              recorrido_arbol = v_parametros.recorrido_arbol,
              tabla_codigo_auxiliar=v_parametros.tabla_codigo_auxiliar,
              tabla_id_auxiliar=v_parametros.tabla_id_auxiliar,
              tabla_codigo_aplicacion=  v_parametros.tabla_codigo_aplicacion
            
			where id_tabla_relacion_contable=v_parametros.id_tabla_relacion_contable;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tabla Relación Contable modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tabla_relacion_contable',v_parametros.id_tabla_relacion_contable::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_TABRECON_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		16-05-2013 21:05:26
	***********************************/

	elsif(p_transaccion='CONTA_TABRECON_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.ttabla_relacion_contable
            where id_tabla_relacion_contable=v_parametros.id_tabla_relacion_contable;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tabla Relación Contable eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tabla_relacion_contable',v_parametros.id_tabla_relacion_contable::varchar);
              
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