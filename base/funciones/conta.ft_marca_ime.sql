CREATE OR REPLACE FUNCTION conta.ft_marca_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_marca_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tmarca'
 AUTOR: 		 (egutierrez)
 FECHA:	        10-06-2019 21:08:40
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				10-06-2019 21:08:40								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tmarca'	
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_marca	integer;
    v_codigo                varchar;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_marca_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_mar_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		egutierrez	
 	#FECHA:		10-06-2019 21:08:40
	***********************************/

	if(p_transaccion='CONTA_mar_INS')then
					
        begin
            v_codigo=REPLACE(v_parametros.codigo,' ', '');
           
        	--Sentencia de la insercion
        	insert into conta.tmarca(
			codigo,
			descripcion,
			estado_reg,
			id_usuario_reg,
			usuario_ai,
			fecha_reg,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			upper(v_codigo),
			v_parametros.descripcion,
			'activo',
			p_id_usuario,
			v_parametros._nombre_usuario_ai,
			now(),
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_marca into v_id_marca;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','marca de comprobante almacenado(a) con exito (id_marca'||v_id_marca||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_marca',v_id_marca::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_mar_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		egutierrez	
 	#FECHA:		10-06-2019 21:08:40
	***********************************/

	elsif(p_transaccion='CONTA_mar_MOD')then

		begin
            v_codigo=REPLACE(v_parametros.codigo,' ', '');
			--Sentencia de la modificacion
			update conta.tmarca set
			codigo = upper(v_codigo),
			descripcion = v_parametros.descripcion,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_marca=v_parametros.id_marca;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','marca de comprobante modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_marca',v_parametros.id_marca::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
        end;

    /*********************************    
     #TRANSACCION:  'CONTA_mar_ELI'
     #DESCRIPCION:    Eliminacion de registros
     #AUTOR:        egutierrez    
     #FECHA:        10-06-2019 21:08:40
    ***********************************/

    elsif(p_transaccion='CONTA_mar_ELI')then

        begin
            --Sentencia de la eliminacion
            delete from conta.tmarca
            where id_marca=v_parametros.id_marca;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','marca de comprobante eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_marca',v_parametros.id_marca::varchar);
              
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