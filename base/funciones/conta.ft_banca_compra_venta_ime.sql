CREATE OR REPLACE FUNCTION conta.ft_banca_compra_venta_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_banca_compra_venta_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tbanca_compra_venta'
 AUTOR: 		 (admin)
 FECHA:	        11-09-2015 14:36:46
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
	v_id_banca_compra_venta	integer;
    
    v_registros				record;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_banca_compra_venta_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_BANCA_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		11-09-2015 14:36:46
	***********************************/

	if(p_transaccion='CONTA_BANCA_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.tbanca_compra_venta(
			num_cuenta_pago,
			tipo_documento_pago,
			num_documento,
			monto_acumulado,
			estado_reg,
			nit_ci,
			importe_documento,
			fecha_documento,
			modalidad_transaccion,
			tipo_transaccion,
			autorizacion,
			monto_pagado,
			fecha_de_pago,
			razon,
			tipo,
			num_documento_pago,
			num_contrato,
			nit_entidad,
            id_periodo,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			id_usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.num_cuenta_pago,
			v_parametros.tipo_documento_pago,
			v_parametros.num_documento,
			v_parametros.monto_acumulado,
			'activo',
			v_parametros.nit_ci,
			v_parametros.importe_documento,
			v_parametros.fecha_documento,
			v_parametros.modalidad_transaccion,
			v_parametros.tipo_transaccion,
			v_parametros.autorizacion,
			v_parametros.monto_pagado,
			v_parametros.fecha_de_pago,
			v_parametros.razon,
			v_parametros.tipo,
			v_parametros.num_documento_pago,
			v_parametros.num_contrato,
			v_parametros.nit_entidad,
            v_parametros.id_periodo,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_banca_compra_venta into v_id_banca_compra_venta;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','bancarizacion almacenado(a) con exito (id_banca_compra_venta'||v_id_banca_compra_venta||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_banca_compra_venta',v_id_banca_compra_venta::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_BANCA_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		11-09-2015 14:36:46
	***********************************/

	elsif(p_transaccion='CONTA_BANCA_MOD')then

		begin
        
          --revisa si el documento no esta marcado como revisado
            select 
             dcv.revisado
            into 
              v_registros
            from conta.tbanca_compra_venta dcv where dcv.id_banca_compra_venta =v_parametros.id_banca_compra_venta;
            
            IF  v_registros.revisado = 'si' THEN
               raise exception 'los documentos revisados no peuden modificarse';
            END IF;
            
            
			--Sentencia de la modificacion
			update conta.tbanca_compra_venta set
			num_cuenta_pago = v_parametros.num_cuenta_pago,
			tipo_documento_pago = v_parametros.tipo_documento_pago,
			num_documento = v_parametros.num_documento,
			monto_acumulado = v_parametros.monto_acumulado,
			nit_ci = v_parametros.nit_ci,
			importe_documento = v_parametros.importe_documento,
			fecha_documento = v_parametros.fecha_documento,
			modalidad_transaccion = v_parametros.modalidad_transaccion,
			tipo_transaccion = v_parametros.tipo_transaccion,
			autorizacion = v_parametros.autorizacion,
			monto_pagado = v_parametros.monto_pagado,
			fecha_de_pago = v_parametros.fecha_de_pago,
			razon = v_parametros.razon,
			tipo = v_parametros.tipo,
			num_documento_pago = v_parametros.num_documento_pago,
			num_contrato = v_parametros.num_contrato,
			nit_entidad = v_parametros.nit_entidad,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_banca_compra_venta=v_parametros.id_banca_compra_venta;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','bancarizacion modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_banca_compra_venta',v_parametros.id_banca_compra_venta::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_BANCA_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		11-09-2015 14:36:46
	***********************************/

	elsif(p_transaccion='CONTA_BANCA_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tbanca_compra_venta
            where id_banca_compra_venta=v_parametros.id_banca_compra_venta;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','bancarizacion eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_banca_compra_venta',v_parametros.id_banca_compra_venta::varchar);
              
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