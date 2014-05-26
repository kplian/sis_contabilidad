--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_comprobante_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_comprobante_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tcomprobante'
 AUTOR: 		 (admin)
 FECHA:	        13-07-2013 01:56:48
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
	v_id_comprobante	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_comprobante_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_CBTE_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		13-07-2013 01:56:48
	***********************************/

	if(p_transaccion='CONTA_CBTE_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.tcomprobante(
			estado_reg,
			id_periodo,
			momento,
			tipo_cambio,
			beneficiario,
			id_depto,
			glosa2,
			id_moneda,
			glosa1,
			id_clase_comprobante,
			id_subsistema,
			nro_cbte,
			id_comprobante_fk,
			id_usuario_reg,
			fecha_reg,
			id_usuario_mod,
			fecha_mod,
			fecha,
            id_usuario_ai,
            usuario_ai
          	) values(
			'activo',
			v_parametros.id_periodo,
			v_parametros.momento,
			v_parametros.tipo_cambio,
			v_parametros.beneficiario,
			v_parametros.id_depto,
			v_parametros.glosa2,
			v_parametros.id_moneda,
			v_parametros.glosa1,
			v_parametros.id_clase_comprobante,
			v_parametros.id_subsistema,
			v_parametros.nro_cbte,
			v_parametros.id_comprobante_fk,
			p_id_usuario,
			now(),
			null,
			null,
			v_parametros.fecha,
            v_parametros._id_usuario_ai,
            v_parametros._nombre_usuario_ai
            			
			)RETURNING id_comprobante into v_id_comprobante;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Comprobante almacenado(a) con exito (id_comprobante'||v_id_comprobante||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_comprobante',v_id_comprobante::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CBTE_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		13-07-2013 01:56:48
	***********************************/

	elsif(p_transaccion='CONTA_CBTE_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.tcomprobante set
			id_funcionario_firma2 = v_parametros.id_funcionario_firma2,
			id_periodo = v_parametros.id_periodo,
			momento = v_parametros.momento,
			tipo_cambio = v_parametros.tipo_cambio,
			id_funcionario_firma1 = v_parametros.id_funcionario_firma1,
			beneficiario = v_parametros.beneficiario,
			id_depto = v_parametros.id_depto,
			glosa2 = v_parametros.glosa2,
			id_moneda = v_parametros.id_moneda,
			id_funcionario_firma3 = v_parametros.id_funcionario_firma3,
			glosa1 = v_parametros.glosa1,
			id_clase_comprobante = v_parametros.id_clase_comprobante,
			id_subsistema = v_parametros.id_subsistema,
			nro_cbte = v_parametros.nro_cbte,
			id_comprobante_fk = v_parametros.id_comprobante_fk,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			fecha = v_parametros.fecha,
            id_usuario_ai = v_parametros._id_usuario_ai,
            usuario_ai = v_parametros._nombre_usuario_ai
			where id_comprobante=v_parametros.id_comprobante;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Comprobante modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_comprobante',v_parametros.id_comprobante::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CBTE_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		13-07-2013 01:56:48
	***********************************/

	elsif(p_transaccion='CONTA_CBTE_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tcomprobante
            where id_comprobante=v_parametros.id_comprobante;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Comprobante eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_comprobante',v_parametros.id_comprobante::varchar);
              
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