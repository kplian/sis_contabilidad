--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_cuenta_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.f_cuenta_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tcuenta'
 AUTOR: 		Gonzalo Sarmiento Sejas
 FECHA:	        21-02-2013 15:04:03
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
	v_id_cuenta	integer;
    
    v_id_cuenta_padre integer;
    v_tipo_cuenta_pat varchar;
			    
BEGIN

    v_nombre_funcion = 'conta.f_cuenta_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_CTA_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		21-02-2013 15:04:03
	***********************************/

	if(p_transaccion='CONTA_CTA_INS')then
					
        begin
           IF v_parametros.id_cuenta_padre != 'id' and v_parametros.id_cuenta_padre != '' THEN
             v_id_cuenta_padre=v_parametros.id_cuenta_padre::integer;
           ELSE
           --verificamos que no existe una cuenta raiz para este tipo_cuenta
           
               IF(exists (select 1  
                          from conta.tcuenta  c 
                          where c.id_gestion = v_parametros.id_gestion 
                            and c.tipo_cuenta = v_parametros.tipo_cuenta
                            and c.estado_reg='activo')) THEN
                            
                    raise exception 'solo se permite una cuenta base de %',v_parametros.tipo_cuenta;        
               
           END IF;
           END IF;
        
        
        IF v_parametros.tipo_cuenta_pat = '' THEN
       		 v_tipo_cuenta_pat = NULL;
        ELSE
       		 v_tipo_cuenta_pat = v_parametros.tipo_cuenta_pat;
        
        END IF;
        
        
        
        
        
        
        
        	--Sentencia de la insercion
        	insert into conta.tcuenta(
            id_cuenta_padre,
			nombre_cuenta,
			sw_auxiliar,
			nivel_cuenta,
			tipo_cuenta,
			desc_cuenta,
			tipo_cuenta_pat,
			nro_cuenta,
			id_moneda,
			sw_transaccional,
			id_gestion,
            estado_reg,
			fecha_reg,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_id_cuenta_padre,
			v_parametros.nombre_cuenta,
			v_parametros.sw_auxiliar,
			NULL,
			v_parametros.tipo_cuenta,
			v_parametros.desc_cuenta,
			v_tipo_cuenta_pat,
			v_parametros.nro_cuenta,
			v_parametros.id_moneda,
			v_parametros.sw_transaccional,
			v_parametros.id_gestion,
            'activo',
            now(),
			p_id_usuario,
			null,
			null
							
			)RETURNING id_cuenta into v_id_cuenta;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cuenta almacenado(a) con exito (id_cuenta'||v_id_cuenta||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta',v_id_cuenta::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CTA_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		21-02-2013 15:04:03
	***********************************/

	elsif(p_transaccion='CONTA_CTA_MOD')then

		begin
           
        IF v_parametros.id_cuenta_padre != 'id' and v_parametros.id_cuenta_padre != '' THEN
             v_id_cuenta_padre=v_parametros.id_cuenta_padre::integer;
        END IF;
        
        
        IF v_parametros.tipo_cuenta_pat = ''  or v_parametros.tipo_cuenta_pat = 'null' THEN
       		 v_tipo_cuenta_pat = NULL;
        ELSE
       		 v_tipo_cuenta_pat = v_parametros.tipo_cuenta_pat;
        
        END IF;
         
        
			--Sentencia de la modificacion
			update conta.tcuenta set
			nombre_cuenta = v_parametros.nombre_cuenta,
			sw_auxiliar = v_parametros.sw_auxiliar,
			tipo_cuenta = v_parametros.tipo_cuenta,
			id_cuenta_padre = v_id_cuenta_padre,
			desc_cuenta = v_parametros.desc_cuenta,
			tipo_cuenta_pat = v_tipo_cuenta_pat,
			nro_cuenta = v_parametros.nro_cuenta,
			id_moneda = v_parametros.id_moneda,
			sw_transaccional = v_parametros.sw_transaccional,
			id_gestion = v_parametros.id_gestion,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario
			where id_cuenta=v_parametros.id_cuenta;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cuenta modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta',v_parametros.id_cuenta::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CTA_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		21-02-2013 15:04:03
	***********************************/

	elsif(p_transaccion='CONTA_CTA_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tcuenta
            where id_cuenta=v_parametros.id_cuenta;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cuenta eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta',v_parametros.id_cuenta::varchar);
              
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