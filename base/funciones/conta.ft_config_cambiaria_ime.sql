--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_config_cambiaria_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_config_cambiaria_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tconfig_cambiaria'
 AUTOR: 		 (admin)
 FECHA:	        04-11-2015 12:39:12
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
    v_registros    	        record;
    v_registros_cc			record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_config_cambiaria	integer;
    
    v_m  					record;
    v_mb  					record;
    v_mt  					record;
    v_id_moneda_base 		integer;
    v_id_moneda_tri 		integer; 
    v_tc1 					varchar;
    v_tc2 					varchar;
    va_tc1 					varchar[];
    va_tc2 					varchar[];
    v_valor_tc1				numeric;
    v_valor_tc2				numeric;
    v_forma_cambio			varchar;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_config_cambiaria_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_CNFC_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		04-11-2015 12:39:12
	***********************************/

	if(p_transaccion='CONTA_CNFC_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.tconfig_cambiaria(
              fecha_habilitado,
              origen,
              habilitado,
              estado_reg,
              ope_2,
              ope_1,
              obs,
              id_usuario_reg,
              fecha_reg,
              usuario_ai,
              id_usuario_ai,
              fecha_mod,
              id_usuario_mod
          	) values(
              now(),
              v_parametros.origen,
              v_parametros.habilitado,
              'activo',
              v_parametros.ope_2,
              v_parametros.ope_1,
              v_parametros.obs,
              p_id_usuario,
              now(),
              v_parametros._nombre_usuario_ai,
              v_parametros._id_usuario_ai,
              null,
              null
							
			
			
			)RETURNING id_config_cambiaria into v_id_config_cambiaria;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Configuración Cambiaria almacenado(a) con exito (id_config_cambiaria'||v_id_config_cambiaria||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_config_cambiaria',v_id_config_cambiaria::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CNFC_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		04-11-2015 12:39:12
	***********************************/

	elsif(p_transaccion='CONTA_CNFC_MOD')then

		begin
			
            select 
              *
            into 
              v_registros
            from conta.tconfig_cambiaria
            where id_config_cambiaria=v_parametros.id_config_cambiaria;
        
            
            --Sentencia de la modificacion
			update conta.tconfig_cambiaria set
              origen = v_parametros.origen,
              habilitado = v_parametros.habilitado,
              ope_2 = v_parametros.ope_2,
              ope_1 = v_parametros.ope_1,
              obs = v_parametros.obs,
              fecha_mod = now(),
              id_usuario_mod = p_id_usuario,
              id_usuario_ai = v_parametros._id_usuario_ai,
              usuario_ai = v_parametros._nombre_usuario_ai
			where id_config_cambiaria=v_parametros.id_config_cambiaria;
            
            -- si varia la habilitacion se modifica la fecha
            If v_registros.habilitado != v_parametros.habilitado THEN
              update conta.tconfig_cambiaria set
              fecha_habilitado = now()
              where id_config_cambiaria=v_parametros.id_config_cambiaria;
            END IF; 
              
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Configuración Cambiaria modificada)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_config_cambiaria',v_parametros.id_config_cambiaria::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CNFC_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		04-11-2015 12:39:12
	***********************************/

	elsif(p_transaccion='CONTA_CNFC_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tconfig_cambiaria
            where id_config_cambiaria=v_parametros.id_config_cambiaria;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Configuración Cambiaria eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_config_cambiaria',v_parametros.id_config_cambiaria::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
    
    /*********************************    
 	#TRANSACCION:  'CONTA_GETCFIG_IME'
 	#DESCRIPCION:	recupera configuracion cambiaria y  y sus valores
 	#AUTOR:		rac (kplian)	
 	#FECHA:		04-11-2015 12:39:12
	***********************************/

	elsif(p_transaccion='CONTA_GETCFIG_IME')then

		begin
		
            
              
              IF v_parametros.forma_cambio in ('convenido','oficial') THEN
                v_forma_cambio = 'O';
              ELSEIF v_parametros.forma_cambio in ('compra') THEN
               v_forma_cambio = 'C';
              ELSE
                v_forma_cambio = 'V';
              END IF;
              
              
             SELECT  
               po_id_config_cambiaria ,
               po_valor_tc1 ,
               po_valor_tc2 ,
               po_tc1 ,
               po_tc2 
             into
              v_registros_cc
             FROM conta.f_get_tipo_cambio_segu_config(v_parametros.id_moneda, v_parametros.fecha,v_parametros.localidad,v_parametros.sw_valores, v_forma_cambio);
             
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','recupera configuracion'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_config_cambiaria',v_registros_cc.po_id_config_cambiaria::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'v_valor_tc1',v_registros_cc.po_valor_tc1::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'v_valor_tc2',v_registros_cc.po_valor_tc2::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'v_tc1',v_registros_cc.po_tc1::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'v_tc2',v_registros_cc.po_tc2::varchar);
              
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