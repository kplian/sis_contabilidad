CREATE OR REPLACE FUNCTION "conta"."ft_detalle_plantilla_comprobante_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_detalle_plantilla_comprobante_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tdetalle_plantilla_comprobante'
 AUTOR: 		 (admin)
 FECHA:	        10-06-2013 14:51:03
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
	v_id_detalle_plantilla_comprobante	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_detalle_plantilla_comprobante_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_CMPBDET_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		10-06-2013 14:51:03
	***********************************/

	if(p_transaccion='CONTA_CMPBDET_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.tdetalle_plantilla_comprobante(
			id_plantilla_comprobante,
			debe_haber,
			agrupar,
			es_relacion_contable,
			tabla_detalle,
			campo_partida,
			campo_concepto_transaccion,
			tipo_relacion_contable,
			campo_cuenta,
			campo_monto,
			campo_relacion_contable,
			campo_documento,
			aplicar_documento,
			campo_centro_costo,
			campo_auxiliar,
			campo_fecha,
			estado_reg,
			fecha_reg,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.id_plantilla_comprobante,
			v_parametros.debe_haber,
			v_parametros.agrupar,
			v_parametros.es_relacion_contable,
			v_parametros.tabla_detalle,
			v_parametros.campo_partida,
			v_parametros.campo_concepto_transaccion,
			v_parametros.tipo_relacion_contable,
			v_parametros.campo_cuenta,
			v_parametros.campo_monto,
			v_parametros.campo_relacion_contable,
			v_parametros.campo_documento,
			v_parametros.aplicar_documento,
			v_parametros.campo_centro_costo,
			v_parametros.campo_auxiliar,
			v_parametros.campo_fecha,
			'activo',
			now(),
			p_id_usuario,
			null,
			null
							
			)RETURNING id_detalle_plantilla_comprobante into v_id_detalle_plantilla_comprobante;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalla Comprobante almacenado(a) con exito (id_detalle_plantilla_comprobante'||v_id_detalle_plantilla_comprobante||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_detalle_plantilla_comprobante',v_id_detalle_plantilla_comprobante::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CMPBDET_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		10-06-2013 14:51:03
	***********************************/

	elsif(p_transaccion='CONTA_CMPBDET_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.tdetalle_plantilla_comprobante set
			id_plantilla_comprobante = v_parametros.id_plantilla_comprobante,
			debe_haber = v_parametros.debe_haber,
			agrupar = v_parametros.agrupar,
			es_relacion_contable = v_parametros.es_relacion_contable,
			tabla_detalle = v_parametros.tabla_detalle,
			campo_partida = v_parametros.campo_partida,
			campo_concepto_transaccion = v_parametros.campo_concepto_transaccion,
			tipo_relacion_contable = v_parametros.tipo_relacion_contable,
			campo_cuenta = v_parametros.campo_cuenta,
			campo_monto = v_parametros.campo_monto,
			campo_relacion_contable = v_parametros.campo_relacion_contable,
			campo_documento = v_parametros.campo_documento,
			aplicar_documento = v_parametros.aplicar_documento,
			campo_centro_costo = v_parametros.campo_centro_costo,
			campo_auxiliar = v_parametros.campo_auxiliar,
			campo_fecha = v_parametros.campo_fecha,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario
			where id_detalle_plantilla_comprobante=v_parametros.id_detalle_plantilla_comprobante;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalla Comprobante modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_detalle_plantilla_comprobante',v_parametros.id_detalle_plantilla_comprobante::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CMPBDET_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		10-06-2013 14:51:03
	***********************************/

	elsif(p_transaccion='CONTA_CMPBDET_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tdetalle_plantilla_comprobante
            where id_detalle_plantilla_comprobante=v_parametros.id_detalle_plantilla_comprobante;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalla Comprobante eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_detalle_plantilla_comprobante',v_parametros.id_detalle_plantilla_comprobante::varchar);
              
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
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;
ALTER FUNCTION "conta"."ft_detalle_plantilla_comprobante_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
