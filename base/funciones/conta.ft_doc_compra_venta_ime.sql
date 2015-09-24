--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_doc_compra_venta_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_doc_compra_venta_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tdoc_compra_venta'
 AUTOR: 		 (admin)
 FECHA:	        18-08-2015 15:57:09
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
    v_registros				record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_doc_compra_venta	integer;
    v_rec					record;
    v_tmp_resp				boolean;
    v_importe_ice			numeric;
    v_revisado				varchar;
    v_sum_total				numeric;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_doc_compra_venta_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_DCV_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		18-08-2015 15:57:09
	***********************************/

	if(p_transaccion='CONTA_DCV_INS')then
					
        begin
        
           
            
            
            -- recuepra el periodo de la fecha ...
            --Obtiene el periodo a partir de la fecha
        	v_rec = param.f_get_periodo_gestion(v_parametros.fecha);
            
            -- valida que period de libro de compras y ventas este abierto
            v_tmp_resp = conta.f_revisa_periodo_compra_venta(p_id_usuario, v_parametros.id_depto_conta, v_rec.po_id_periodo);
              
            --validar que no exitas una documento con el mismo nro y misma razon social  ...?
            --validar que no exista un documentos con el mismo nro_autorizacion, nro_factura , y nit y razon social
            
            
            
            
           
        
        
            --recupera parametrizacion de la plantilla     
            select 
             *
            into 
             v_registros
            from param.tplantilla pla 
            where pla.id_plantilla = v_parametros.id_plantilla;
            
            --PARA COMPRAS
            IF v_parametros.tipo = 'compra' THEN
                
                IF EXISTS(select 
                 1 
                from conta.tdoc_compra_venta dcv
                where    dcv.estado_reg = 'activo' and  dcv.nit = v_parametros.nit 
                     and dcv.nro_autorizacion = v_parametros.nro_autorizacion
                     and dcv.nro_documento = v_parametros.nro_documento
                     and dcv.nro_dui = v_parametros.nro_dui
                     and dcv.fecha = v_parametros.fecha
                     and dcv.id_plantilla = v_parametros.id_plantilla
                     and dcv.razon_social = upper(trim(v_parametros.razon_social))) then
                     
                     raise exception 'Ya existe un documento registrado con el mismo nro,  razon social y fecha';
                     
                END IF;
            END IF; 
            
            
            --si tiene habilitado el ic copiamos el monto excento
            v_importe_ice = NULL;
            IF v_registros.sw_ic = 'si' then
              v_importe_ice = v_parametros.importe_excento;
            END IF;
           
            
            --Sentencia de la insercion
        	insert into conta.tdoc_compra_venta(
              tipo,
              importe_excento,
              id_plantilla,
              fecha,
              nro_documento,
              nit,
              importe_ice,
              nro_autorizacion,
              importe_iva,
              importe_descuento,
              importe_descuento_ley,
              importe_pago_liquido,
              importe_doc,
              sw_contabilizar,
              estado,
              id_depto_conta,  			
              obs,
              estado_reg,
              codigo_control,
              importe_it,
              razon_social,
              id_usuario_ai,
              id_usuario_reg,
              fecha_reg,
              usuario_ai,
              manual,
              id_periodo,
              nro_dui,
              id_moneda
          	) values(
              v_parametros.tipo,
              v_parametros.importe_excento,
              v_parametros.id_plantilla,
              v_parametros.fecha,
              v_parametros.nro_documento,
              v_parametros.nit,
              v_importe_ice,
              v_parametros.nro_autorizacion,
              v_parametros.importe_iva,
              v_parametros.importe_descuento,
              v_parametros.importe_descuento_ley,
              v_parametros.importe_pago_liquido,
              v_parametros.importe_doc,
              'si', --sw_contabilizar,  		
              'registrado', --estado
              v_parametros.id_depto_conta,  			
              v_parametros.obs,
              'activo',
              v_parametros.codigo_control,
              v_parametros.importe_it,
              upper(trim(v_parametros.razon_social)),
              v_parametros._id_usuario_ai,
              p_id_usuario,
              now(),
              v_parametros._nombre_usuario_ai,
              'si',
              v_rec.po_id_periodo,
              v_parametros.nro_dui,
              v_parametros.id_moneda
			)RETURNING id_doc_compra_venta into v_id_doc_compra_venta;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Documentos Compra/Venta almacenado(a) con exito (id_doc_compra_venta'||v_id_doc_compra_venta||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_doc_compra_venta',v_id_doc_compra_venta::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_DCV_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		18-08-2015 15:57:09
	***********************************/

	elsif(p_transaccion='CONTA_DCV_MOD')then

		begin
        
        
        
           
        
            -- recuepra el periodo de la fecha ...
            --Obtiene el periodo a partir de la fecha
        	v_rec = param.f_get_periodo_gestion(v_parametros.fecha);
            
            -- valida que period de libro de compras y ventas este abierto
            v_tmp_resp = conta.f_revisa_periodo_compra_venta(p_id_usuario, v_parametros.id_depto_conta, v_rec.po_id_periodo);
              
             --revisa si el documento no esta marcado como revisado
            select 
             dcv.revisado
            into 
              v_registros
            from conta.tdoc_compra_venta dcv where dcv.id_doc_compra_venta =v_parametros.id_doc_compra_venta;
            
            IF  v_registros.revisado = 'si' THEN
               raise exception 'los documentos revisados no peuden modificarse';
            END IF;
            
             --recupera parametrizacion de la plantilla     
            select 
             *
            into 
             v_registros
            from param.tplantilla pla 
            where pla.id_plantilla = v_parametros.id_plantilla;
            
            --si tiene habilitado el ic copiamos el monto excento
            v_importe_ice = NULL;
            IF v_registros.sw_ic = 'si' then
              v_importe_ice = v_parametros.importe_excento;
            END IF;
        
        
			--Sentencia de la modificacion
			update conta.tdoc_compra_venta set			
			  tipo = v_parametros.tipo,
              importe_excento = v_parametros.importe_excento,
              id_plantilla = v_parametros.id_plantilla,
              fecha = v_parametros.fecha,
              nro_documento = v_parametros.nro_documento,
              nit = v_parametros.nit,
              importe_ice = v_importe_ice,
              nro_autorizacion = v_parametros.nro_autorizacion,
              importe_iva = v_parametros.importe_iva,
              importe_descuento = v_parametros.importe_descuento,
              importe_descuento_ley = v_parametros.importe_descuento_ley,
              importe_pago_liquido = v_parametros.importe_pago_liquido,
              importe_doc = v_parametros.importe_doc,
              id_depto_conta = v_parametros.id_depto_conta,  			
              obs = v_parametros.obs,
              codigo_control = v_parametros.codigo_control,
              importe_it = v_parametros.importe_it,
              razon_social = upper(trim(v_parametros.razon_social)),
              id_periodo = v_rec.po_id_periodo,
              nro_dui = v_parametros.nro_dui,
              id_moneda = v_parametros.id_moneda
			where id_doc_compra_venta=v_parametros.id_doc_compra_venta;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Documentos Compra/Venta modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_doc_compra_venta',v_parametros.id_doc_compra_venta::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_DCV_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		18-08-2015 15:57:09
	***********************************/

	elsif(p_transaccion='CONTA_DCV_ELI')then

		begin
        
             --revisa si el documento no esta marcado como revisado
            select 
             dcv.revisado
            into 
              v_registros
            from conta.tdoc_compra_venta dcv where dcv.id_doc_compra_venta =v_parametros.id_doc_compra_venta;
            
            IF  v_registros.revisado = 'si' THEN
               raise exception 'los documentos revisados no peuden modificarse';
            END IF;
            
            --TODO revisar si el archivo es manual o no
            -- revisar si tiene conceptos de gasto
            
        
        
        
			--Sentencia de la eliminacion
			delete from conta.tdoc_compra_venta
            where id_doc_compra_venta=v_parametros.id_doc_compra_venta;
            
            
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Documentos Compra/Venta eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_doc_compra_venta',v_parametros.id_doc_compra_venta::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
   /*********************************    
 	#TRANSACCION:  'CONTA_CAMREV_IME'
 	#DESCRIPCION:	Cambia el estao de la revisón del documento de compra o venta
 	#AUTOR:		admin	
 	#FECHA:		09-09-2015 15:57:09
	***********************************/

	elsif(p_transaccion='CONTA_CAMREV_IME')then

		begin
			
            
            select 
             dcv.revisado
            into 
              v_registros
            from conta.tdoc_compra_venta dcv where dcv.id_doc_compra_venta =v_parametros.id_doc_compra_venta;
            
            
            IF  v_registros.revisado = 'si' THEN
             v_revisado = 'no';
            ELSE
             v_revisado = 'si';
            END IF;
            
            
            update conta.tdoc_compra_venta set			
			  revisado = v_revisado
            where id_doc_compra_venta=v_parametros.id_doc_compra_venta;
            
            
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','cambio del documento a revisado '||v_revisado|| ' id: '||v_parametros.id_doc_compra_venta); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_doc_compra_venta',v_parametros.id_doc_compra_venta::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
    
    
    /*********************************    
 	#TRANSACCION:  'CONTA_CHKDOCSUM_IME'
 	#DESCRIPCION:	verifica si el detalle del documento cuadra con el total
 	#AUTOR:		admin	
 	#FECHA:		09-09-2015 15:57:09
	***********************************/

	elsif(p_transaccion='CONTA_CHKDOCSUM_IME')then

		begin
			
            
            select 
             dcv.importe_doc
            into 
              v_registros
            from conta.tdoc_compra_venta dcv where dcv.id_doc_compra_venta =v_parametros.id_doc_compra_venta;
            
            
            select
              sum (dc.precio_total)
            into
             v_sum_total
            from conta.tdoc_concepto dc
            where dc.id_doc_compra_venta = v_parametros.id_doc_compra_venta;
            
            IF v_sum_total != v_registros.importe_doc  THEN
               raise exception 'el total del documento no iguala con el total detallado de conceptos';
            END IF;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','cuadra el documento insertado'); 
            v_resp = pxp.f_agrega_clave(v_resp,'sum_total',v_sum_total::varchar);
              
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