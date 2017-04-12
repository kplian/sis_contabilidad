--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_plantilla_comprobante_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_plantilla_comprobante_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tplantilla_comprobante'
 AUTOR: 		 (admin)
 FECHA:	        10-06-2013 14:40:00
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
	v_id_plantilla_comprobante	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_plantilla_comprobante_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_CMPB_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		10-06-2013 14:40:00
	***********************************/

	if(p_transaccion='CONTA_CMPB_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.tplantilla_comprobante(
                codigo,
                funcion_comprobante_eliminado,
                id_tabla,
                campo_subsistema,
                campo_descripcion,
                funcion_comprobante_validado,
                campo_fecha,
                estado_reg,
                campo_acreedor,
                campo_depto,
                momento_presupuestario,
                campo_fk_comprobante,
                tabla_origen,
                clase_comprobante,
                campo_moneda,
                id_usuario_reg,
                fecha_reg,
                id_usuario_mod,
                fecha_mod,
                campo_gestion_relacion	,
                otros_campos, 
                momento_comprometido,
                momento_ejecutado,
                momento_pagado,
                campo_id_cuenta_bancaria,
                campo_id_cuenta_bancaria_mov,
                campo_nro_cheque,
                campo_nro_cuenta_bancaria_trans,
                campo_nro_tramite,
                campo_tipo_cambio,
                campo_depto_libro,
                campo_fecha_costo_ini,
                campo_fecha_costo_fin,
                funcion_comprobante_editado,
                funcion_comprobante_prevalidado,
                funcion_comprobante_validado_eliminado
             
          	) values(
                v_parametros.codigo,
                v_parametros.funcion_comprobante_eliminado,
                v_parametros.id_tabla,
                v_parametros.campo_subsistema,
                v_parametros.campo_descripcion,
                v_parametros.funcion_comprobante_validado,
                v_parametros.campo_fecha,
                'activo',
                v_parametros.campo_acreedor,
                v_parametros.campo_depto,
                v_parametros.momento_presupuestario,
                v_parametros.campo_fk_comprobante,
                v_parametros.tabla_origen,
                v_parametros.clase_comprobante,
                v_parametros.campo_moneda,
                p_id_usuario,
                now(),
                null,
                null,
                v_parametros.campo_gestion_relacion,
                v_parametros.otros_campos ,
                v_parametros.momento_comprometido,
                v_parametros.momento_ejecutado,
                v_parametros.momento_pagado,
                v_parametros.campo_id_cuenta_bancaria,
                v_parametros.campo_id_cuenta_bancaria_mov,
                v_parametros.campo_nro_cheque,
                v_parametros.campo_nro_cuenta_bancaria_trans,
                v_parametros.campo_nro_tramite,
                v_parametros.campo_tipo_cambio,
                v_parametros.campo_depto_libro,
                v_parametros.campo_fecha_costo_ini,
                v_parametros.campo_fecha_costo_fin,
                v_parametros.funcion_comprobante_editado,
                v_parametros.funcion_comprobante_prevalidado,
                v_parametros.funcion_comprobante_validado_eliminado
							
			)RETURNING id_plantilla_comprobante into v_id_plantilla_comprobante;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Comprobante almacenado(a) con exito (id_plantilla_comprobante'||v_id_plantilla_comprobante||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_plantilla_comprobante',v_id_plantilla_comprobante::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CMPB_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		10-06-2013 14:40:00
	***********************************/

	elsif(p_transaccion='CONTA_CMPB_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.tplantilla_comprobante set
              codigo=v_parametros.codigo,
              funcion_comprobante_eliminado = v_parametros.funcion_comprobante_eliminado,
              id_tabla = v_parametros.id_tabla,
              campo_subsistema = v_parametros.campo_subsistema,
              campo_descripcion = v_parametros.campo_descripcion,
              funcion_comprobante_validado = v_parametros.funcion_comprobante_validado,
              campo_fecha = v_parametros.campo_fecha,
              campo_acreedor = v_parametros.campo_acreedor,
              campo_depto = v_parametros.campo_depto,
              momento_presupuestario = v_parametros.momento_presupuestario,
              campo_fk_comprobante = v_parametros.campo_fk_comprobante,
              tabla_origen = v_parametros.tabla_origen,
              clase_comprobante = v_parametros.clase_comprobante,
              campo_moneda = v_parametros.campo_moneda,
              id_usuario_mod = p_id_usuario,
              fecha_mod = now(),
              campo_gestion_relacion=v_parametros.campo_gestion_relacion,
              otros_campos=v_parametros.otros_campos,
              momento_comprometido=v_parametros.momento_comprometido,
              momento_ejecutado=v_parametros.momento_ejecutado,
              momento_pagado=v_parametros.momento_pagado,
              campo_id_cuenta_bancaria=v_parametros.campo_id_cuenta_bancaria,
              campo_id_cuenta_bancaria_mov=v_parametros.campo_id_cuenta_bancaria_mov,
              campo_nro_cheque = v_parametros.campo_nro_cheque,
              campo_nro_cuenta_bancaria_trans= v_parametros.campo_nro_cuenta_bancaria_trans,
              campo_nro_tramite= v_parametros.campo_nro_tramite,
              campo_tipo_cambio = v_parametros.campo_tipo_cambio,
              campo_depto_libro = v_parametros.campo_depto_libro,
              campo_fecha_costo_ini = v_parametros.campo_fecha_costo_ini,
              campo_fecha_costo_fin = v_parametros.campo_fecha_costo_fin,
              funcion_comprobante_editado = v_parametros.funcion_comprobante_editado,
              funcion_comprobante_prevalidado = v_parametros.funcion_comprobante_prevalidado,
              funcion_comprobante_validado_eliminado =v_parametros.funcion_comprobante_validado_eliminado
			where id_plantilla_comprobante=v_parametros.id_plantilla_comprobante;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Comprobante modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_plantilla_comprobante',v_parametros.id_plantilla_comprobante::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CMPB_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		10-06-2013 14:40:00
	***********************************/

	elsif(p_transaccion='CONTA_CMPB_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tplantilla_comprobante
            where id_plantilla_comprobante=v_parametros.id_plantilla_comprobante;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Comprobante eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_plantilla_comprobante',v_parametros.id_plantilla_comprobante::varchar);
              
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