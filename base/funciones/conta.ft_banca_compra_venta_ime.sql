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
     
     
     
     v_record_plan_pago_pxp 	record;
     v_consulta varchar;
     v_host varchar;
      v_rec2 record;
      v_rec_periodo_seleccionado record;
      v_modalidad_de_transaccion	integer;
      v_tipo_transaccion 			integer;
      v_numero_de_contrato			varchar;
      v_tipo_documento_pago			integer;
      v_doc_id						varchar;
      
      v_periodo						record;
      
      v_saldo						numeric;
      v_monto_contrato				numeric;
      v_monto_acumulado				numeric;
      
      v_numero_tramite_y_cuota	varchar;
      v_consulta_sigma	varchar;
      
      v_fecha_libro_o_entrega date;
      v_nro_cheque_o_sigma varchar;
     
     
     
			    
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
            numero_cuota,
            id_depto_conta
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
            v_parametros.numero_cuota,
            v_parametros.id_depto_conta
							
			
			
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
            
            
            v_monto_contrato = v_parametros.monto_contrato;
            v_monto_acumulado = v_parametros.monto_acumulado;
            
            v_saldo =  v_monto_contrato - v_monto_acumulado;
            
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
            id_periodo = v_id_periodo,
            saldo = v_saldo
            
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
 	#TRANSACCION:  'CONTA_BANCA_ELITO'
 	#DESCRIPCION:	ELIMINA TODOS LOS REGISTROS
 	#AUTOR:		admin	
 	#FECHA:		11-09-2015 14:36:46
	***********************************/

	elsif(p_transaccion='CONTA_BANCA_ELITO')then

		begin
			--Sentencia de la eliminacion
			TRUNCATE TABLE conta.tbanca_compra_venta;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','bancarizacion eliminado(a)'); 
            --v_resp = pxp.f_agrega_clave(v_resp,'id_banca_compra_venta',v_parametros.id_banca_compra_venta::varchar);
              
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
        
        
     /*********************************    
 	#TRANSACCION:  'CONTA_BANCA_AUT'
 	#DESCRIPCION:	Inserccion de registros automatico desde endesis y pxp
 	#AUTOR:		ffigueroa	
 	#FECHA:		18-03-2016 14:36:46
	***********************************/

	elsif(p_transaccion='CONTA_BANCA_AUT')then

		begin
        
        --raise exception '%',v_parametros.id_depto_conta;
        
			
        select fecha_ini,fecha_fin,
         param.f_literal_periodo(id_periodo) as periodo into v_periodo
        from param.tperiodo
        where id_periodo = v_parametros.id_periodo;
         
      
        v_host:='dbname=dbendesis host=192.168.100.30 user=ende_pxp password=ende_pxp';
    
    
    --creacion de tabla temporal del endesis 
    
    v_consulta:= ' WITH tabla_temporal_documentos AS (
              SELECT * FROM dblink('''||v_host||''',
          ''select tctcomp.id_int_comprobante,
          tctdoc.razon_social,
          tctdoc.id_documento,
          docval.importe_total,
          docval.id_moneda,
          tctdoc.nro_documento,
          tctdoc.nro_autorizacion,
          tctdoc.fecha_documento,
          tctdoc.nro_nit
          from sci.tct_comprobante tctcomp
          inner join sci.tct_transaccion tcttra on tcttra.id_comprobante = tctcomp.id_comprobante
          inner join sci.tct_documento tctdoc on tctdoc.id_transaccion = tcttra.id_transaccion
          inner join sci.tct_documento_valor docval on docval.id_documento = tctdoc.id_documento
          where   docval.id_moneda = 1
           ''
                   ) AS d (id_int_comprobante integer,
                   razon_social varchar(500),
                    id_documento integer,
                    importe_total numeric(10,2),
                    id_moneda INTEGER,
                    nro_documento bigint,
                    nro_autorizacion VARCHAR(20),
                    fecha_documento date,
                    nro_nit varchar(30) )
              )';
              
              v_consulta := v_consulta ||',tabla_temporal_sigma AS (
              SELECT * FROM dblink('''||v_host||''',
          ''select tctcomp.id_int_comprobante,
          tctcomp.id_comprobante,
          entre.comprobante_c31,
          entre.fecha_entrega
          from sci.tct_comprobante tctcomp
          inner join sci.tct_entrega_comprobante entrecom on entrecom.id_comprobante = tctcomp.id_comprobante
          inner join sci.tct_entrega entre on entre.id_entrega = entrecom.id_entrega
          
           ''
                   ) AS d (
                   id_int_comprobante integer,
                    id_comprobante integer,
                    comprobante_c31 VARCHAR(20),
                    fecha_entrega date )
              )';
    
              
    v_consulta:= v_consulta || 'select pg_pagado.id_plan_pago,
      pg_devengado.id_plan_pago,
      libro.comprobante_sigma,
      libro.id_libro_bancos,
      libro.tipo,
      doc.id_documento,
      doc.razon_social,
      doc.fecha_documento,
      doc.nro_documento,
       doc.nro_autorizacion,
      doc.importe_total,
      doc.nro_nit,
      plantilla.tipo_informe,
      plantilla.tipo_plantilla,
      pg_devengado.fecha_dev,
      pg_pagado.fecha_pag,
      pg_devengado.fecha_costo_ini,
      pg_devengado.fecha_costo_fin,
      libro.fecha as fecha_pago,
      cuenta.id_cuenta_bancaria,
      cuenta.denominacion,
      cuenta.nro_cuenta,
      
      provee.id_proveedor,
      contra.numero as numero_contrato,
      contra.id_contrato,
      contra.monto as monto_contrato,
      contra.bancarizacion,
      obliga.num_tramite,
      pg_devengado.nro_cuota,
       pg_pagado.forma_pago,
      sigma.comprobante_c31,
      sigma.fecha_entrega,
      pg_pagado.id_cuenta_bancaria as id_cuenta_bancaria_plan_pago,
      libro.nro_cheque

from tes.tplan_pago pg_pagado
inner join tes.tplan_pago pg_devengado on pg_devengado.id_plan_pago = pg_pagado.id_plan_pago_fk
inner join param.tplantilla plantilla  on plantilla.id_plantilla = pg_devengado.id_plantilla

left join tabla_temporal_sigma sigma on sigma.id_int_comprobante = pg_pagado.id_int_comprobante
left join tes.tts_libro_bancos libro on libro.id_int_comprobante = pg_pagado.id_int_comprobante
left join tes.tcuenta_bancaria cuenta on cuenta.id_cuenta_bancaria = pg_pagado.id_cuenta_bancaria

inner join tes.tobligacion_pago obliga on obliga.id_obligacion_pago = pg_pagado.id_obligacion_pago
left join leg.tcontrato contra on contra.id_contrato = obliga.id_contrato

inner join param.tproveedor provee on provee.id_proveedor = obliga.id_proveedor

inner join tabla_temporal_documentos doc on doc.id_int_comprobante = pg_devengado.id_int_comprobante
 

where pg_pagado.estado=''pagado'' and pg_devengado.estado = ''devengado''
and (libro.tipo=''cheque'' or  pg_pagado.forma_pago = ''transferencia'')
and ( pg_pagado.forma_pago = ''transferencia'' or pg_pagado.forma_pago=''cheque'')
 and plantilla.tipo_informe in (''lcv'',''retenciones'')
and (libro.estado in (''cobrado'',''entregado'') or libro.estado is null )
and ((doc.fecha_documento >= '''||v_periodo.fecha_ini||'''::date and doc.fecha_documento <='''||v_periodo.fecha_fin||'''::date)
or (libro.fecha >= '''||v_periodo.fecha_ini||'''::date and libro.fecha <='''||v_periodo.fecha_fin||'''::date)
or (sigma.fecha_entrega >= '''||v_periodo.fecha_ini||'''::date and sigma.fecha_entrega <='''||v_periodo.fecha_fin||'''::date)
)and (doc.importe_total >= 50000 or contra.bancarizacion = ''si'') and pg_devengado.id_depto_conta = '||v_parametros.id_depto_conta||'
    ';
    
   
    FOR v_record_plan_pago_pxp in execute v_consulta LOOP
         
    v_monto_acumulado = 0;
    v_saldo = 0;
    v_monto_contrato = 0;
    
    --vemos si es transferencia o cheque dependiendo de eso entra la feccha
    if v_record_plan_pago_pxp.forma_pago = 'cheque'
    then
     v_fecha_libro_o_entrega = v_record_plan_pago_pxp.fecha_pago;
     v_nro_cheque_o_sigma = v_record_plan_pago_pxp.nro_cheque;
     elsif v_record_plan_pago_pxp.forma_pago = 'transferencia'
     then
      v_fecha_libro_o_entrega = v_record_plan_pago_pxp.fecha_entrega;
      v_nro_cheque_o_sigma = v_record_plan_pago_pxp.comprobante_c31;
    end if;
    
    --si cualquiera de las fecha es mayor al periodo seleccinado no se registra
    --si las dos fechas son menores a la del periodo entonces se registra
    
    IF(v_record_plan_pago_pxp.fecha_documento::date <= v_periodo.fecha_fin::date 
    	and v_fecha_libro_o_entrega::date <=v_periodo.fecha_fin::date
        )
    then
    
    
     --raise exception '%',v_record_plan_pago_pxp;
         
         IF EXISTS (SELECT  0 FROM conta.tbanca_compra_venta
         			 where id_documento = v_record_plan_pago_pxp.id_documento )
        THEN
          --existe ya un registro con esta documentacion asi que no se registra
          
          
         ELSE
         
         
         v_rec = param.f_get_periodo_gestion(v_record_plan_pago_pxp.fecha_documento);
          v_rec2 = param.f_get_periodo_gestion(v_fecha_libro_o_entrega);
		
 
         --todo aca validar de mejor forma
          --me fijo si la fecha de factura es igual a la del pago
         if v_rec.po_id_periodo < v_rec2.po_id_periodo --fecha factura es antes que la del pago
         THEN
         --es credito
         v_modalidad_de_transaccion = 2;
         else
         --es al contado
         v_modalidad_de_transaccion = 1;
         end if;
         
         --vemos si es factura o retencion
         if v_record_plan_pago_pxp.tipo_informe = 'lcv'
         THEN
         v_tipo_transaccion = 1;
         ELSIF v_record_plan_pago_pxp.tipo_informe = 'retenciones'
         then
         v_tipo_transaccion = 2;
         end if;
         
         --vemos el tipo de documento de pago segun la cuenta bancaria 
         if v_record_plan_pago_pxp.id_cuenta_bancaria_plan_pago = 61 
         then
         v_tipo_documento_pago = 4;--es transeferencia de fondos
         else
         v_tipo_documento_pago = 1;--es cheque de cualquier naturaleza
         end if;
         
         --si es bancarizacion por contrato tomamos en cuanta el saldo y el monto acumulado
         if v_record_plan_pago_pxp.bancarizacion = 'si'
         then
         
           /*el monto acumulado se por primera vez se debe ingresar manualmente en el campo
           ya que asi podremos tomar encuenta datos anteriores 
           ya que el sistema no cuenta con datos anteriores al 2015.*/
         
         	v_monto_contrato = v_record_plan_pago_pxp.monto_contrato;
           
            --obtenemos el ultimo registro bancarizado del id_contrato
            select monto_acumulado into v_monto_acumulado
            from conta.tbanca_compra_venta
            where id_contrato = v_record_plan_pago_pxp.id_contrato
            order by id_banca_compra_venta desc limit 1;
            
            if(v_monto_acumulado is null)
            then
            v_monto_acumulado = 0;
            end if;
            
            
            
            v_monto_acumulado = v_monto_acumulado + v_record_plan_pago_pxp.importe_total;
            
            
             
            v_saldo = v_monto_contrato  - v_monto_acumulado;
            
            
            
            
         end if;
         
         --vemos si tiene contrato
         /*if v_record_plan_pago_pxp.id_contrato is not null
         then
         
         select numero into v_numero_de_contrato from leg.tcontrato
         where id_contrato = v_record_plan_pago_pxp.id_contrato;
         
    
         end if;*/
         
         --sacamos el nit de la entidad financiera segun el contrato
         select inst.doc_id 
         into v_doc_id
         from tes.tcuenta_bancaria ctaban
         inner join param.tinstitucion inst on inst.id_institucion = ctaban.id_institucion
         where ctaban.id_cuenta_bancaria = v_record_plan_pago_pxp.id_cuenta_bancaria; 
         
         
         
         --obtenemos el numero de traminte concatenado con la cuota
         v_numero_tramite_y_cuota = v_record_plan_pago_pxp.num_tramite::varchar||'('||v_record_plan_pago_pxp.nro_cuota::VARCHAR||')';
       
       
         --Sentencia de la insercion
        	insert into conta.tbanca_compra_venta(
			num_cuenta_pago,
			tipo_documento_pago,
			num_documento,
			monto_acumulado, --todo
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
            numero_cuota,
            tramite_cuota,
            saldo,
            id_depto_conta
          	) values(
			v_record_plan_pago_pxp.nro_cuenta,
			v_tipo_documento_pago,
			v_record_plan_pago_pxp.nro_documento,
			v_monto_acumulado,
			'activo',
			v_record_plan_pago_pxp.nro_nit,
			v_record_plan_pago_pxp.importe_total,
			v_record_plan_pago_pxp.fecha_documento,
			v_modalidad_de_transaccion,
			v_tipo_transaccion,
			v_record_plan_pago_pxp.nro_autorizacion::numeric,
			v_record_plan_pago_pxp.importe_total,
			v_fecha_libro_o_entrega,
			v_record_plan_pago_pxp.razon_social,
			'Compras',
			v_nro_cheque_o_sigma,
			v_record_plan_pago_pxp.numero_contrato,
			v_doc_id::numeric,
            v_parametros.id_periodo,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null,
            v_record_plan_pago_pxp.id_contrato,
            v_record_plan_pago_pxp.id_proveedor,
            v_record_plan_pago_pxp.id_cuenta_bancaria_plan_pago,
            v_record_plan_pago_pxp.id_documento,
            v_periodo.periodo,
            v_record_plan_pago_pxp.nro_cuota,
           v_numero_tramite_y_cuota,
           v_saldo,
           v_parametros.id_depto_conta
							
			
			
			);
         
          
        END IF;
    
    end IF;

    
        
        
        
         
         
          
         
         end LOOP;
         
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','bancarizacion insertado para el periodo (a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_periodo',v_parametros.id_periodo::varchar);
              
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