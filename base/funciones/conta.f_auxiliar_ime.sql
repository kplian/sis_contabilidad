--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_auxiliar_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.f_auxiliar_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tauxiliar'
 AUTOR: 		Gonzalo Sarmiento Sejas
 FECHA:	        21-02-2013 20:44:52
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
	v_resp		              varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_auxiliar	          integer;
	--variables para control de codigo y nombre de auxiliar duplicado
  v_contador				      integer;
	v_valid					        varchar;
			    
BEGIN

    v_nombre_funcion = 'conta.f_auxiliar_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_AUXCTA_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		21-02-2013 20:44:52
	***********************************/

	if(p_transaccion='CONTA_AUXCTA_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.tauxiliar(
			--id_empresa,
			estado_reg,
			codigo_auxiliar,
			nombre_auxiliar,
			fecha_reg,
			id_usuario_reg,
			id_usuario_mod,
			fecha_mod,
            corriente
          	) values(
			--v_parametros.id_empresa,
			'activo',
			v_parametros.codigo_auxiliar,
			v_parametros.nombre_auxiliar,
			now(),
			p_id_usuario,
			null,
			null,
            v_parametros.corriente
							
			)RETURNING id_auxiliar into v_id_auxiliar;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Auxiliares de Cuenta almacenado(a) con exito (id_auxiliar'||v_id_auxiliar||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_auxiliar',v_id_auxiliar::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_AUXCTA_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		21-02-2013 20:44:52
	***********************************/

	elsif(p_transaccion='CONTA_AUXCTA_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.tauxiliar set
			--id_empresa = v_parametros.id_empresa,
			codigo_auxiliar = v_parametros.codigo_auxiliar,
			nombre_auxiliar = v_parametros.nombre_auxiliar,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
            corriente = v_parametros.corriente
			where id_auxiliar=v_parametros.id_auxiliar;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Auxiliares de Cuenta modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_auxiliar',v_parametros.id_auxiliar::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_AUXCTA_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		21-02-2013 20:44:52
	***********************************/

	elsif(p_transaccion='CONTA_AUXCTA_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tauxiliar
            where id_auxiliar=v_parametros.id_auxiliar;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Auxiliares de Cuenta eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_auxiliar',v_parametros.id_auxiliar::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
	/*********************************
 	#TRANSACCION:  'CONTA_COD_AUX_VAL'
 	#DESCRIPCION:	Control para que no se repita el codigo auxiliar y nombre auxiliar
 	#AUTOR:		Franklin Espinoza
 	#FECHA:		13-06-2017 10:44:52
	***********************************/

	elsif(p_transaccion='CONTA_COD_AUX_VAL')then

		begin
			select count(taux.id_auxiliar)
            INTO v_contador
            from conta.tauxiliar taux
            where    taux.codigo_auxiliar = trim(both ' ' from v_parametros.codigo_auxiliar) 
            
                 AND taux.nombre_auxiliar = trim(both ' ' from v_parametros.nombre_auxiliar) ;

            IF(v_contador>=1)THEN
        		v_valid = 'true';
            ELSE
            	v_valid = 'false';
			END IF;
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Existe el Reclamo');
            v_resp = pxp.f_agrega_clave(v_resp,'v_valid',v_valid);
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