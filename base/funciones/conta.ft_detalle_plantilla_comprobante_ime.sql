--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_detalle_plantilla_comprobante_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
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
        
            --verifica que el codigo no se repita para esta transacción
            
            if EXISTS(select 1 from conta.tdetalle_plantilla_comprobante c
                               where     trim(lower(c.codigo)) =  trim(lower(v_parametros.codigo)) 
                                      and c.estado_reg = 'activo' 
                                      and  c.id_plantilla_comprobante = v_parametros.id_plantilla_comprobante) THEN
                
               raise exception 'Este código ya existe en esta plantilla: %', v_parametros.codigo;  
                                 
            END IF;
        
        
        
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
                id_usuario_mod,           
                primaria, 
                otros_campos, 
                nom_fk_tabla_maestro, 
                campo_partida_ejecucion , 
                descripcion , 
                campo_monto_pres , 
                id_detalle_plantilla_fk , 
                forma_calculo_monto, 
                func_act_transaccion, 
                campo_id_tabla_detalle, 
                rel_dev_pago, 
                campo_trasaccion_dev,
                campo_id_cuenta_bancaria,
                campo_id_cuenta_bancaria_mov,
                campo_nro_cheque,
                campo_nro_cuenta_bancaria_trans,
                campo_porc_monto_excento_var,
                campo_nombre_cheque_trans,
                prioridad_documento,
                campo_orden_trabajo,
                campo_forma_pago,
                codigo,
                tipo_relacion_contable_cc,
                campo_relacion_contable_cc,
                campo_suborden
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
                null,                
                v_parametros.primaria, 
                v_parametros.otros_campos, 
                v_parametros.nom_fk_tabla_maestro, 
                v_parametros.campo_partida_ejecucion , 
                v_parametros.descripcion , 
                v_parametros.campo_monto_pres , 
                v_parametros.id_detalle_plantilla_fk , 
                v_parametros.forma_calculo_monto, 
                v_parametros.func_act_transaccion, 
                v_parametros.campo_id_tabla_detalle, 
                v_parametros.rel_dev_pago, 
                v_parametros.campo_trasaccion_dev,
                v_parametros.campo_id_cuenta_bancaria,
                v_parametros.campo_id_cuenta_bancaria_mov,
                v_parametros.campo_nro_cheque ,
                v_parametros.campo_nro_cuenta_bancaria_trans,
                v_parametros.campo_porc_monto_excento_var,
                v_parametros.campo_nombre_cheque_trans,
                v_parametros.prioridad_documento,
                v_parametros.campo_orden_trabajo,
                v_parametros.campo_forma_pago,
                v_parametros.codigo,
                v_parametros.tipo_relacion_contable_cc,
                v_parametros.campo_relacion_contable_cc,
                v_parametros.campo_suborden
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
            
            --verifica que el código no se repita para esta transacción
            
            IF EXISTS(select 1 from conta.tdetalle_plantilla_comprobante c
                               where       c.codigo =  v_parametros.codigo 
                                      and  c.estado_reg = 'activo' 
                                      and  c.id_plantilla_comprobante = v_parametros.id_plantilla_comprobante
                                      and  c.id_detalle_plantilla_comprobante != v_parametros.id_detalle_plantilla_comprobante) THEN
                
               raise exception 'Este código ya existe en esta plantilla: %', v_parametros.codigo;  
                                 
            END IF;
        
        
        
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
                id_usuario_mod = p_id_usuario,            
                primaria = v_parametros.primaria, 
                otros_campos = v_parametros.otros_campos, 
                nom_fk_tabla_maestro = v_parametros.nom_fk_tabla_maestro, 
                campo_partida_ejecucion = v_parametros.campo_partida_ejecucion , 
                descripcion = v_parametros.descripcion , 
                campo_monto_pres = v_parametros.campo_monto_pres , 
                id_detalle_plantilla_fk = v_parametros.id_detalle_plantilla_fk , 
                forma_calculo_monto = v_parametros.forma_calculo_monto, 
                func_act_transaccion = v_parametros.func_act_transaccion, 
                campo_id_tabla_detalle = v_parametros.campo_id_tabla_detalle, 
                rel_dev_pago = v_parametros.rel_dev_pago, 
                campo_trasaccion_dev = v_parametros.campo_trasaccion_dev,
                campo_id_cuenta_bancaria = v_parametros.campo_id_cuenta_bancaria,
                campo_id_cuenta_bancaria_mov = v_parametros.campo_id_cuenta_bancaria_mov,
                campo_nro_cheque = v_parametros.campo_nro_cheque,
                campo_nro_cuenta_bancaria_trans=v_parametros.campo_nro_cuenta_bancaria_trans,
                campo_porc_monto_excento_var=v_parametros.campo_porc_monto_excento_var,
                campo_nombre_cheque_trans = v_parametros.campo_nombre_cheque_trans,
                prioridad_documento = v_parametros.prioridad_documento,
                campo_orden_trabajo = v_parametros.campo_orden_trabajo,
                campo_forma_pago = v_parametros.campo_forma_pago,
                codigo = v_parametros.codigo,
                tipo_relacion_contable_cc = v_parametros.tipo_relacion_contable_cc,
                campo_relacion_contable_cc = v_parametros.campo_relacion_contable_cc,
                campo_suborden = v_parametros.campo_suborden
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
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;