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
    
     v_rec					record;
    v_tmp_resp				boolean;
     v_registros_json		record;
     anoop					record;
     
     v_id_periodo 		 	integer;
     v_id_txt_importacion_bcv integer;
     
			    
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
         
        
       		--fechas fecha_documento y fecha_de_pago
            if (v_parametros.fecha_documento::varchar != '' and v_parametros.fecha_de_pago::varchar != '')
            then
           		 if(v_parametros.fecha_documento::date > v_parametros.fecha_de_pago)
                  then
                  v_rec = param.f_get_periodo_gestion(v_parametros.fecha_documento);
                  v_id_periodo = v_rec.po_id_periodo;
                  else
                  v_rec = param.f_get_periodo_gestion(v_parametros.fecha_de_pago);
                  v_id_periodo = v_rec.po_id_periodo;
                  end if;
            
            else
             v_id_periodo = v_parametros.id_periodo;
            end if; 
            
            
        
             
        
        
            -- recuepra el periodo de la fecha ...
            --Obtiene el periodo a partir de la fecha
        	--v_rec = param.f_get_periodo_gestion(v_parametros.fecha_documento);
            
            -- valida que period de libro de compras y ventas este abierto
            --v_tmp_resp = conta.f_revisa_periodo_compra_venta(p_id_usuario, v_parametros.id_depto_conta, v_rec.po_id_periodo);
        
        
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
			fecha_mod,
            id_contrato,
            id_proveedor,
            id_cuenta_bancaria,
            id_documento,
            periodo_servicio,
            numero_cuota
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
            v_id_periodo,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null,
            v_parametros.id_contrato,
            v_parametros.id_proveedor,
            v_parametros.id_cuenta_bancaria,
            v_parametros.id_documento,
            v_parametros.periodo_servicio,
            v_parametros.numero_cuota
							
			
			
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
        
        
        
        
        if (v_parametros.fecha_documento::varchar != '' and v_parametros.fecha_de_pago::varchar != '')
            then
            
           
           		 if(v_parametros.fecha_documento::date > v_parametros.fecha_de_pago::Date)
                  then
                  v_rec = param.f_get_periodo_gestion(v_parametros.fecha_documento);
                  v_id_periodo = v_rec.po_id_periodo;
                  else
                  v_rec = param.f_get_periodo_gestion(v_parametros.fecha_de_pago);
                  v_id_periodo = v_rec.po_id_periodo;
                  end if;
                  
                  
                  else
                  
                     select id_periodo into v_id_periodo from conta.tbanca_compra_venta 
        where id_banca_compra_venta = v_parametros.id_banca_compra_venta;
            end if; 
            
            
            
        
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
			usuario_ai = v_parametros._nombre_usuario_ai,
            id_contrato = v_parametros.id_contrato,
            id_proveedor = v_parametros.id_proveedor,
            id_cuenta_bancaria = v_parametros.id_cuenta_bancaria,
            id_documento = v_parametros.id_documento,
            id_periodo = v_id_periodo
            
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
        
        
        
        /*********************************    
 	#TRANSACCION:  'CONTA_BANCA_IMP'
 	#DESCRIPCION:	Importacion de archivo txt
 	#AUTOR:		admin	
 	#FECHA:		22-09-2015 14:36:46
	***********************************/

	elsif(p_transaccion='CONTA_BANCA_IMP')then

		begin
        
        --select * into v_registros_json from json('{"name":"depesz","password":"super simple","grades":[1,3,1,1,1,2],"skills":{"a":"b", "c":[1,2,3]}}');
        
        --raise exception '%',v_parametros.nombre_archivo;
		
         v_rec = param.f_get_periodo_gestion(v_parametros.fecha_archivo);
        
        
        if (v_parametros.fecha_archivo::date < '01/07/2015'::date)then
        
        --raise exception '%','es de la anterior version';
        
        ELSE
        
        end if;
        
        
        
        insert into conta.ttxt_importacion_bcv(
			nombre_archivo,
			id_periodo,
			estado_reg,
			id_usuario_ai,
			usuario_ai,
			fecha_reg,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.nombre_archivo,
			v_rec.po_id_periodo,
			'activo',
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			now(),
			p_id_usuario,
			null,
			null
							
			
			
			)RETURNING id_txt_importacion_bcv into v_id_txt_importacion_bcv;
        
        
        
         FOR v_registros_json in ( select * from json_populate_recordset(null::conta.json_imp_banca_compra_venta, v_parametros.arra_json::json)) LOOP
         
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
			--num_contrato,
			nit_entidad,
            id_periodo,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			id_usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_registros_json.num_cuenta_pago,
			v_registros_json.tipo_documento_pago,
			v_registros_json.num_documento,
			v_registros_json.monto_acumulado,
			'activo',
			v_registros_json.nit_ci,
			v_registros_json.importe_documento,
			v_registros_json.fecha_documento,
			v_registros_json.modalidad_transaccion,
			v_registros_json.tipo_transaccion,
			v_registros_json.autorizacion,
			v_registros_json.monto_pagado,
			v_registros_json.fecha_de_pago,
			v_registros_json.razon,
			v_parametros.tipo,
			v_registros_json.num_documento_pago,
			--v_registros_json.num_contrato,
			v_registros_json.nit_entidad,
           v_rec.po_id_periodo,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			);
        end loop;
      
          
        
			
       
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','bancarizacion eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_banca_compra_venta',10::varchar);
              
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