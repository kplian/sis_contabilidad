CREATE OR REPLACE FUNCTION conta.f_bancarizacion_automatico (
)
RETURNS text AS
$body$
/**************************************************************************
 SISTEMA:		CONTA
 FUNCION: 		conta.f_bancarizacion_automatico
 DESCRIPCION:   Genera desde el plan de pago autumatico para ver que se bancariza
 AUTOR: 		 (ffigueroa)
 FECHA:	        16-03-2016 14:58:35
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/


DECLARE

    v_resp		            varchar;
	v_nombre_funcion        text;
    v_id_dosi_correlativo  integer;
    v_nro_siguiente integer;
    
    v_record_plan_pago_pxp 	record;
     v_consulta varchar;
     v_host varchar;
      v_rec					record;
      v_rec2 record;
      v_modalidad_de_transaccion	integer;
      
     

BEGIN
	v_nombre_funcion = 'conta.f_bancarizacion_automatico';


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
    
              
    v_consulta:= v_consulta || 'select pg_pagado.id_plan_pago,
      pg_devengado.id_plan_pago,
      libro.comprobante_sigma,
      libro.id_libro_bancos,
      libro.tipo,
      doc.razon_social,
      doc.fecha_documento,
      doc.nro_documento,
       doc.nro_autorizacion,
      doc.importe_total,
      doc.nro_nit,
      plantilla.tipo_informe,
      pg_devengado.fecha_dev,
      pg_pagado.fecha_pag,
      pg_devengado.fecha_costo_ini,
      pg_devengado.fecha_costo_fin,
      libro.fecha as fecha_pago,
      cuenta.id_cuenta_bancaria,
      cuenta.denominacion,
      cuenta.nro_cuenta
     
from tes.tplan_pago pg_devengado
inner join tes.tplan_pago pg_pagado on pg_pagado.id_plan_pago_fk = pg_devengado.id_plan_pago
inner join param.tplantilla plantilla  on plantilla.id_plantilla = pg_devengado.id_plantilla
inner join tes.tts_libro_bancos libro on libro.id_int_comprobante = pg_pagado.id_int_comprobante
inner join tes.tcuenta_bancaria cuenta on cuenta.id_cuenta_bancaria = libro.id_cuenta_bancaria
inner join tabla_temporal_documentos doc on doc.id_int_comprobante = pg_devengado.id_int_comprobante

where pg_pagado.estado=''pagado'' and pg_devengado.estado = ''devengado''
and libro.tipo=''cheque'' and plantilla.tipo_informe in (''lcv'',''retenciones'')
                          and doc.importe_total > 50000
    ';
    
    
    --execute v_consulta into v_record_plan_pago_pxp;
    --raise exception '%',v_record_plan_pago_pxp.concepto_tran;
   
         FOR v_record_plan_pago_pxp in execute v_consulta LOOP
         
         --raise exception '%',v_record_plan_pago_pxp.razon_social;
         
          v_rec = param.f_get_periodo_gestion(v_record_plan_pago_pxp.fecha_documento);
          v_rec2 = param.f_get_periodo_gestion(v_record_plan_pago_pxp.fecha_pago);
          raise exception '%',v_rec.po_id_periodo;
          
          --me fijo si la fecha de factura es igual a la del pago
         if v_rec.po_id_periodo < v_rec2.po_id_periodo --fecha factura es antes que la del pago
         THEN
         --es credito
         v_modalidad_de_transaccion = 2;
         else
         --es al contado
         v_modalidad_de_transaccion = 1;
         end if;
         
         
         --Sentencia de la insercion
        	/*insert into conta.tbanca_compra_venta(
			num_cuenta_pago
			tipo_documento_pago, --todo
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
            numero_cuota
          	) values(
			v_record_plan_pago_pxp.nro_cuenta,
			1,
			v_record_plan_pago_pxp.nro_documento,
			0,
			'activo',
			v_record_plan_pago_pxp.nro_nit,
			v_record_plan_pago_pxp.importe_total,
			v_record_plan_pago_pxp.fecha_documento,
			v_modalidad_de_transaccion,
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
							
			
			
			)RETURNING id_banca_compra_venta into v_id_banca_compra_venta;*/
         
         end LOOP;




    

    
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