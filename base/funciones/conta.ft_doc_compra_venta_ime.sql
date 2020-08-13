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
 AUTOR: 		RAC KPLIAN
 FECHA:	        18-08-2015 15:57:09
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 ISSUE            FECHA:		      AUTOR               DESCRIPCION
 #0				   18-08-2015        RAC KPLIAN 		Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tdoc_compra_venta'
 #14,   BOA		   18/10/2017		 RAC KPLIAN		Al validar comprobantes vamos actualizar e nro de tramite en doc_compra_venta si estan relacionados en las trasacciones CONTA_DCV_INS y CONTA_ADDCBTE_IME
 #0     ETR        05/01/2018        RAC PLIAN		Registor opcion de sw_pgs e id_funcionario para pagos simplificados 
 #87    ETR        25/02/2018        RAC KPLIAN       Considerar fechas dsitintas en las valdiacion de DUI's
 #88    ETR        23/06/2018        RAC  KPLIAN      Solucionar Bug que permite editar fecha con diferente periodo
 #1999  ETR        19/07/2018        RAC  KPLIAN      Relacionar facturas NCD
 #2000  ETR        03/10/2018        RAC  KPLIAN      Para la isnercion y edicion se añade opcionalmente el parametro codigo_aplicacion 
 #12    ETR        12/10/2018        RAC  KPLIAN      Se añade  pametro para isnertar el id_doc_compra_venta_fk para notas de credito
 #112			  17/04/2020		manuel guerra     reportes de autorizacion de pasajes y registro de pasajeros
 #113			  29/04/2020		manuel guerra     modificacion de nro_tramite
 #116			  06/05/2020		manuel guerra     modificacion de campo
 #117			  08/05/2020		manuel guerra	  agregar campo de nota de debito 
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
  v_id_proveedor			integer;
  v_id_cliente			integer;
  v_id_tipo_doc_compra_venta integer;
  v_codigo_estado			varchar;
  v_estado_rendicion		varchar;
  v_id_int_comprobante		integer;
  v_tipo_informe			varchar;
  v_razon_social			varchar;
  v_nit						varchar;
  v_id_moneda				integer;
  v_nomeda					varchar;
  v_nro_tramite				varchar;
  v_reg_periodo				record;
  v_id_funcionario			integer;
  v_sw_pgs					varchar;
  v_reg_plantilla			record;
  
  v_registros_ncd   		record;   -- #1999
  v_suma_otros_creditos     numeric;  -- #1999
  v_codigo_aplicacion       varchar;  -- #2000 
  v_id_contrato             integer;  -- #2000 
  v_id_doc_compra_venta_fk  integer;  -- #123
  v_nota_venta_agencia	    varchar;  -- #114	

BEGIN

  v_nombre_funcion = 'conta.ft_doc_compra_venta_ime';
  v_parametros = pxp.f_get_record(p_tabla);

  /*********************************
   #TRANSACCION:  'CONTA_DCV_INS'
   #DESCRIPCION:	Insercion de registros
   #AUTOR:		admin
   #FECHA:		18-08-2015 15:57:09
 
     ISSUE            FECHA:		      AUTOR               DESCRIPCION
    #87  ETR        25/02/2018        RAC KPLIAN       Considerar fechas dsitintas en las valdiacion de DUI's
   
  ***********************************/

  if(p_transaccion='CONTA_DCV_INS')then

    begin

      --  calcula valores pode defecto para el tipo de doc compra venta
	  IF v_parametros.id_moneda is null THEN
          raise EXCEPTION 'Es necesario indicar la Moneda del documento, revise los datos.';
      END IF;

      IF v_parametros.tipo = 'compra' THEN
            -- paracompras por defecto es
            -- Compras para mercado interno con destino a actividades gravadas
            select
              td.id_tipo_doc_compra_venta
            into
              v_id_tipo_doc_compra_venta
            from conta.ttipo_doc_compra_venta td
            where td.codigo = '1';

      ELSE
            -- para ventas por defecto es
            -- facturas valida
            select
              td.id_tipo_doc_compra_venta
            into
              v_id_tipo_doc_compra_venta
            from conta.ttipo_doc_compra_venta td
            where td.codigo = 'V';

      END IF;

	  IF v_parametros.id_moneda is null THEN
          raise EXCEPTION 'Es necesario indicar la Moneda del documento, revise los datos.';
      END IF;

      -- recuepra el periodo de la fecha ...
      --Obtiene el periodo a partir de la fecha
      v_rec = param.f_get_periodo_gestion(v_parametros.fecha);

	  select tipo_informe into v_tipo_informe
      from param.tplantilla
      where id_plantilla = v_parametros.id_plantilla;

      IF v_tipo_informe = 'lcv' THEN
      	  -- valida que periodO de libro de compras y ventas este abierto
      	  v_tmp_resp = conta.f_revisa_periodo_compra_venta(p_id_usuario, v_parametros.id_depto_conta, v_rec.po_id_periodo);
	  END IF;

      
      IF v_parametros.importe_pendiente > 0 or v_parametros.importe_anticipo > 0 or v_parametros.importe_retgar > 0 THEN

        IF v_parametros.id_auxiliar is null THEN
          raise EXCEPTION 'Es necesario indicar una cuenta corriente, revise los datos.';
        END IF;

      END IF;


      if (pxp.f_existe_parametro(p_tabla,'id_int_comprobante')) then
          v_id_int_comprobante = v_parametros.id_int_comprobante;          
          --#14,  se recupera el nro_tramite del comprobante si es que existe
          select
             c.nro_tramite
          into
             v_nro_tramite
          from conta.tint_comprobante c
          where c.id_int_comprobante = v_id_int_comprobante;
      end if;
      
      
      if (pxp.f_existe_parametro(p_tabla,'nro_tramite')) and v_nro_tramite is null then
          v_nro_tramite=v_parametros.nro_tramite;
      end if;
           
      --RAC 05/01/2018 nuevos para emtros para registro de pagos simplificados 
      if (pxp.f_existe_parametro(p_tabla,'id_funcionario')) then
          v_id_funcionario = v_parametros.id_funcionario;
      end if;
      
      
      if (pxp.f_existe_parametro(p_tabla,'sw_pgs')) then
          v_sw_pgs = v_parametros.sw_pgs;
      else
         v_sw_pgs = 'no';
      end if;      
      --FIN RAC
      
      --# 2000, valida el campo codigo de aplicacion
      if (pxp.f_existe_parametro(p_tabla,'codigo_aplicacion')) then
          v_codigo_aplicacion = v_parametros.codigo_aplicacion;     
      end if; 
      
      if (pxp.f_existe_parametro(p_tabla,'id_contrato')) then
          v_id_contrato = v_parametros.id_contrato;     
      end if;
      
      --#123 
       if (pxp.f_existe_parametro(p_tabla,'id_doc_compra_venta_fk')) then
          v_id_doc_compra_venta_fk = v_parametros.id_doc_compra_venta_fk;     
      end if; 
     
      
      
      ----------------------------------------------------------------------------------------------------------
      --validar que no exista un documento con el mismo nro_autorizacion, nro_factura , y nit y razon social
      ---------------------------------------------------------------------------------------------------------
       
       --recupera parametrizacion de la plantilla
        select
           p.id_plantilla,
           p.tipo_informe,
           p.tipo_plantilla,
           p.tipo,
           p.desc_plantilla,
           p.sw_nro_dui ,
           p.sw_ic
        into
           v_reg_plantilla
        from param.tplantilla p 
        where p.id_plantilla = v_parametros.id_plantilla;


      --PARA COMPRAS
      IF v_parametros.tipo = 'compra' THEN
      
      
             --#87  valdiar segun tipo de documento
             IF v_reg_plantilla.sw_nro_dui = 'si'  THEN
                     --#87 validacion para otros documetnos que no tiene NRO DE DUI
                      IF EXISTS(
                              select
                                1
                              from conta.tdoc_compra_venta dcv
                              inner join param.tplantilla pla on pla.id_plantilla=dcv.id_plantilla
                              where         dcv.estado_reg = 'activo'
                                       and  to_char(dcv.fecha, 'YYYY-MM') = to_char(v_parametros.fecha, 'YYYY-MM') 
                                       --and  dcv.nit = v_parametros.nit   --#87 OJO pienso que el nro de nit no interesa, si da problema descomentar esta linea 
                                       and  dcv.nro_autorizacion = v_parametros.nro_autorizacion
                                       and  dcv.nro_documento = v_parametros.nro_documento
                                       and  dcv.nro_dui = v_parametros.nro_dui
                                       and  pla.sw_nro_dui = 'si'
                                       and  pla.tipo_informe='lcv') then

                                 raise exception 'Ya existe una DUI registrada con el mismo nro,  nit y nro de autorizacion para el periodo';

                       END IF;
             
             
             ELSE
                      --#87 validacion para otros documetnos que no tiene NRO DE DUI
                      IF EXISTS(select
                                1
                              from conta.tdoc_compra_venta dcv
                              inner join param.tplantilla pla on pla.id_plantilla=dcv.id_plantilla
                              where         dcv.estado_reg = 'activo' 
                                       and  dcv.nit = v_parametros.nit
                                       and  dcv.nro_autorizacion = v_parametros.nro_autorizacion
                                       and  dcv.nro_documento = v_parametros.nro_documento
                                       and  pla.sw_nro_dui = 'no'
                                       and  pla.tipo_informe='lcv') then

                                 raise exception 'Ya existe un documento registrado con el mismo nro,  nit y nro de autorizacion';

                       END IF;

             
             END IF;
           
            -- chequear si el proveedor esta registrado
            v_id_proveedor = param.f_check_proveedor(p_id_usuario, v_parametros.nit, upper(trim(v_parametros.razon_social)));

      ELSE
        --TODO  chequear que la factura de venta no este duplicada

        -- chequear el el cliente esta registrado
        v_id_cliente = vef.f_check_cliente(p_id_usuario, v_parametros.nit, upper(trim(v_parametros.razon_social)));
          IF EXISTS(
                    select
                      1
                    from conta.tdoc_compra_venta dcv
                    inner join param.tplantilla pla on pla.id_plantilla=dcv.id_plantilla
                    where         dcv.estado_reg = 'activo'
                             and  to_char(dcv.fecha, 'YYYY-MM') = to_char(v_parametros.fecha, 'YYYY-MM') 
                             and  dcv.nit = v_parametros.nit   --#87 OJO pienso que el nro de nit no interesa, si da problema descomentar esta linea 
                             and  dcv.nro_autorizacion = v_parametros.nro_autorizacion
                             and  dcv.nro_documento = v_parametros.nro_documento
                             and  pla.tipo_informe='lcv') then

                       raise exception 'Ya existe una Factura registrada con el mismo nro,  nit y nro de autorizacion para el periodo';

             END IF;
      END IF;


      --si tiene habilitado el ic copiamos el monto excento
      -- OJO considerar que todos los calculos con el monto excento ya estaran
      -- considerando el ice, par ano hacer mayores cambios

      v_importe_ice = NULL;
      IF v_reg_plantilla.sw_ic = 'si' then
        v_importe_ice = v_parametros.importe_excento;
      END IF;
	  --#117
	  if (pxp.f_existe_parametro(p_tabla,'nota_debito_agencia')) then
          v_nota_venta_agencia = v_parametros.nota_debito_agencia;     
      end if; 	

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
        id_moneda,
        importe_pendiente,
        importe_anticipo,
        importe_retgar,
        importe_neto,
        id_proveedor,
        id_cliente,
        id_auxiliar,
        id_tipo_doc_compra_venta,
        id_int_comprobante,
        nro_tramite,
        id_funcionario,
        sw_pgs,
        codigo_aplicacion,      --#1999
        id_contrato,            --#2000
        id_doc_compra_venta_fk,  --#123
        nota_debito_agencia --#116

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
        upper(COALESCE(v_parametros.codigo_control,'0')),
        v_parametros.importe_it,
        upper(trim(v_parametros.razon_social)),
        v_parametros._id_usuario_ai,
        p_id_usuario,
        now(),
        v_parametros._nombre_usuario_ai,
        'si',
        v_rec.po_id_periodo,
        v_parametros.nro_dui,
        v_parametros.id_moneda,
        COALESCE(v_parametros.importe_pendiente,0),
        COALESCE(v_parametros.importe_anticipo,0),
        COALESCE(v_parametros.importe_retgar,0),
        v_parametros.importe_neto,
        v_id_proveedor,
        v_id_cliente,
        v_parametros.id_auxiliar,
        v_id_tipo_doc_compra_venta,
        v_id_int_comprobante,
        v_nro_tramite,
        v_id_funcionario,
        v_sw_pgs,
        v_codigo_aplicacion,      --#1999
        v_id_contrato,            --#2000
        v_id_doc_compra_venta_fk,  --#123
        v_nota_venta_agencia  		--#117
      )RETURNING id_doc_compra_venta into v_id_doc_compra_venta;

      if (pxp.f_existe_parametro(p_tabla,'id_origen')) then
        update conta.tdoc_compra_venta
        set id_origen = v_parametros.id_origen,
          tabla_origen = v_parametros.tabla_origen
        where id_doc_compra_venta = v_id_doc_compra_venta;
      end if;

      if (pxp.f_existe_parametro(p_tabla,'id_tipo_compra_venta')) then
        if(v_parametros.id_tipo_compra_venta is not null) then

          update conta.tdoc_compra_venta
          set id_tipo_doc_compra_venta = v_parametros.id_tipo_compra_venta
          where id_doc_compra_venta = v_id_doc_compra_venta;
        end if;
      end if;

	  if (pxp.f_existe_parametro(p_tabla,'estacion')) then
        if(v_parametros.estacion is not null) then

          update conta.tdoc_compra_venta
          set estacion = v_parametros.estacion
          where id_doc_compra_venta = v_id_doc_compra_venta;
        end if;
      end if;

      if (pxp.f_existe_parametro(p_tabla,'id_agencia')) then
        if(v_parametros.id_agencia is not null) then

          update conta.tdoc_compra_venta
          set id_agencia = v_parametros.id_agencia
          where id_doc_compra_venta = v_id_doc_compra_venta;
        end if;
      end if;
	  
      --Definicion de la respuesta
      v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Documentos Compra/Venta almacenado(a) con exito (id_doc_compra_venta'||v_id_doc_compra_venta||')');
      v_resp = pxp.f_agrega_clave(v_resp,'id_doc_compra_venta',v_id_doc_compra_venta::varchar);

      --Devuelve la respuesta
      return v_resp;

    end;

  /*********************************
   #TRANSACCION:  'CONTA_DCVCAJ_INS'
   #DESCRIPCION:	Insercion de registros
   #AUTOR:		Gonzalo Sarmiento
   #FECHA:		09-02-2017
  ***********************************/

  elsif(p_transaccion='CONTA_DCVCAJ_INS')then

    begin

      --  calcula valores pode defecto para el tipo de doc compra venta

      IF v_parametros.tipo = 'compra' THEN
        -- paracompras por defecto es
        -- Compras para mercado interno con destino a actividades gravadas
        select
          td.id_tipo_doc_compra_venta
        into
          v_id_tipo_doc_compra_venta
        from conta.ttipo_doc_compra_venta td
        where td.codigo = '1';

      ELSE
        -- para ventas por defecto es
        -- facturas valida
        select
          td.id_tipo_doc_compra_venta
        into
          v_id_tipo_doc_compra_venta
        from conta.ttipo_doc_compra_venta td
        where td.codigo = 'V';

      END IF;

      IF v_parametros.id_moneda is null THEN
          raise EXCEPTION 'Es necesario indicar la Moneda del documento, revise los datos.';
      END IF;

      -- recuepra el periodo de la fecha ...
      --Obtiene el periodo a partir de la fecha
      v_rec = param.f_get_periodo_gestion(v_parametros.fecha);

	  select tipo_informe into v_tipo_informe
      from param.tplantilla
      where id_plantilla = v_parametros.id_plantilla;

      IF v_tipo_informe = 'lcv' THEN
      	  -- valida que period de libro de compras y ventas este abierto
      	  v_tmp_resp = conta.f_revisa_periodo_compra_venta(p_id_usuario, v_parametros.id_depto_conta, v_rec.po_id_periodo);
	  END IF;

      --TODO
      --validar que no exsita un documento con el mismo nro y misma razon social  ...?
      --validar que no exista un documento con el mismo nro_autorizacion, nro_factura , y nit y razon social



      IF v_parametros.importe_pendiente > 0 or v_parametros.importe_anticipo > 0 or v_parametros.importe_retgar > 0 THEN

        IF v_parametros.id_auxiliar is null THEN
          raise EXCEPTION 'Es necesario indicar una cuenta corriente, revise los datos.';
        END IF;

      END IF;

      if (pxp.f_existe_parametro(p_tabla,'id_int_comprobante')) then
          v_id_int_comprobante = v_parametros.id_int_comprobante;
      end if;

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
                  inner join param.tplantilla pla on pla.id_plantilla=dcv.id_plantilla
                  where    dcv.estado_reg = 'activo' and  dcv.nit = v_parametros.nit
                           and dcv.nro_autorizacion = v_parametros.nro_autorizacion
                           and dcv.nro_documento = v_parametros.nro_documento
                           and dcv.nro_dui = v_parametros.nro_dui
                           and pla.tipo_informe='lcv') then

          raise exception 'Ya existe un documento registrado con el mismo nro,  nit y nro autorizacion';

        END IF;

        -- chequear si el proveedor esta registrado
        v_id_proveedor = param.f_check_proveedor(p_id_usuario, v_parametros.nit, upper(trim(v_parametros.razon_social)));

      ELSE
        --TODO  chequear que la factura de venta no este duplicada

        -- chequear el el cliente esta registrado
        v_id_cliente = vef.f_check_cliente(p_id_usuario, v_parametros.nit, upper(trim(v_parametros.razon_social)));
      END IF;

      --si tiene habilitado el ic copiamos el monto excento
      -- OJO considerar que todos los calculos con el monto excento ya estaran
      -- considerando el ice, par ano hacer mayores cambios

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
        id_moneda,
        importe_pendiente,
        importe_anticipo,
        importe_retgar,
        importe_neto,
        id_proveedor,
        id_cliente,
        id_auxiliar,
        id_tipo_doc_compra_venta,
        id_int_comprobante,
        estacion
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
        upper(COALESCE(v_parametros.codigo_control,'0')),
        v_parametros.importe_it,
        upper(trim(v_parametros.razon_social)),
        v_parametros._id_usuario_ai,
        p_id_usuario,
        now(),
        v_parametros._nombre_usuario_ai,
        'si',
        v_rec.po_id_periodo,
        v_parametros.nro_dui,
        v_parametros.id_moneda,
        COALESCE(v_parametros.importe_pendiente,0),
        COALESCE(v_parametros.importe_anticipo,0),
        COALESCE(v_parametros.importe_retgar,0),
        v_parametros.importe_neto,
        v_id_proveedor,
        v_id_cliente,
        v_parametros.id_auxiliar,
        v_id_tipo_doc_compra_venta,
        v_id_int_comprobante,
        v_parametros.estacion
      )RETURNING id_doc_compra_venta into v_id_doc_compra_venta;

      if (pxp.f_existe_parametro(p_tabla,'id_origen')) then
        update conta.tdoc_compra_venta
        set id_origen = v_parametros.id_origen,
          tabla_origen = v_parametros.tabla_origen
        where id_doc_compra_venta = v_id_doc_compra_venta;
      end if;

      if (pxp.f_existe_parametro(p_tabla,'id_tipo_compra_venta')) then
        if(v_parametros.id_tipo_compra_venta is not null) then

          update conta.tdoc_compra_venta
          set id_tipo_doc_compra_venta = v_parametros.id_tipo_compra_venta
          where id_doc_compra_venta = v_id_doc_compra_venta;
        end if;
      end if;

      if (pxp.f_existe_parametro(p_tabla,'estacion')) then
        if(v_parametros.estacion is not null) then

          update conta.tdoc_compra_venta
          set estacion = v_parametros.estacion
          where id_doc_compra_venta = v_id_doc_compra_venta;
        end if;
      end if;

      if (pxp.f_existe_parametro(p_tabla,'id_agencia')) then
        if(v_parametros.id_agencia is not null) then

          update conta.tdoc_compra_venta
          set id_agencia = v_parametros.id_agencia
          where id_doc_compra_venta = v_id_doc_compra_venta;
        end if;
      end if;

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
   
   HISTORIAL  DE CAMBIOS
       ISSUE            FECHA:		      AUTOR               DESCRIPCION
    #87  ETR        25/02/2018        RAC KPLIAN       Considerar fechas dsitintas en las valdiacion de DUI's   
    #88  ETR        23/06/2018        RAC  KPLIAN      Solucionar Bug que permite editar fecha con diferente periodo
    #2000  ETR        03/10/2018        RAC KPLIAN       modifica opcionalmente l codigo de aplicacion
  ***********************************/

  elsif(p_transaccion='CONTA_DCV_MOD')then

    begin

    /*  03/11/2016 se comenta ---TODO ojo pensar en alguna alternativa no intrusiva

      select COALESCE(cd.estado,efe.estado) into v_estado_rendicion
      from conta.tdoc_compra_venta d
        left join cd.trendicion_det ren on ren.id_doc_compra_venta = d.id_doc_compra_venta
        left join cd.tcuenta_doc cd on cd.id_cuenta_doc =  ren.id_cuenta_doc_rendicion
        left join tes.tsolicitud_rendicion_det det on det.id_documento_respaldo=d.id_doc_compra_venta
        left join tes.tsolicitud_efectivo efe on efe.id_solicitud_efectivo=det.id_solicitud_efectivo
      where d.id_doc_compra_venta =v_parametros.id_doc_compra_venta;

       -- recuepra el periodo de la fecha ...
      --Obtiene el periodo a partir de la fecha
      v_rec = param.f_get_periodo_gestion(v_parametros.fecha);

      IF v_estado_rendicion NOT IN ('vbrendicion', 'revision') or v_estado_rendicion IS NULL THEN
        -- valida que period de libro de compras y ventas este abierto
        v_tmp_resp = conta.f_revisa_periodo_compra_venta(p_id_usuario, v_parametros.id_depto_conta, v_rec.po_id_periodo);
      END IF;

      */

       
      --#87  recupera parametrizacion de la plantilla
        select
           p.id_plantilla,
           p.tipo_informe,
           p.tipo_plantilla,
           p.tipo,
           p.desc_plantilla,
           p.sw_nro_dui ,
           p.sw_ic
        into
           v_reg_plantilla
        from param.tplantilla p 
        where p.id_plantilla = v_parametros.id_plantilla;
        
        v_tipo_informe = v_reg_plantilla.tipo_informe;   --#87   

        v_rec = param.f_get_periodo_gestion(v_parametros.fecha);
       
      
      --revisa si el documento no esta marcado como revisado
      select
        dcv.revisado,
        dcv.id_int_comprobante,
        dcv.id_origen,
        dcv.tabla_origen,
        dcv.fecha,
        dcv.id_periodo
      into
        v_registros
      from conta.tdoc_compra_venta dcv where dcv.id_doc_compra_venta =v_parametros.id_doc_compra_venta;

	  v_rec = param.f_get_periodo_gestion(v_parametros.fecha);
      
      
      
      IF v_rec.po_id_periodo != v_registros.id_periodo THEN
        --Habilita la modificación de periodo temporalmente solo para Oruro
      	if v_parametros.id_depto_conta <> 38 then
      		raise exception 'No puede usar  una fecha de otro periodo'; --#101 
      	end if;
        --rcm raise exception 'No puede usar  una fecha de otro periodo'; --#101 
      END IF;
      
      
      
     -- raise exception 'Periodos  %=%',v_rec.po_id_periodo, v_registros.id_periodo;
      
	  -- valida que period de libro de compras y ventas este abierto para la antigua fecha
      IF v_tipo_informe in ('lcv' , 'retenciones') THEN
	      v_tmp_resp = conta.f_revisa_periodo_compra_venta(p_id_usuario, v_parametros.id_depto_conta, v_rec.po_id_periodo);
	  END IF;

      IF  v_registros.revisado = 'si' THEN
        IF v_estado_rendicion NOT IN ('vbrendicion','revision') or v_estado_rendicion IS NULL THEN
          raise exception 'los documentos revisados no pueden modificarse';
        END IF;
      END IF;
      
      
      IF v_parametros.tipo = 'compra' THEN
      
            --#87  valdiar segun tipo de documento
             IF v_reg_plantilla.sw_nro_dui = 'si'  THEN
                     --#87 validacion para otros documetnos que no tiene NRO DE DUI
                      IF EXISTS(
                              select
                                1
                              from conta.tdoc_compra_venta dcv
                              inner join param.tplantilla pla on pla.id_plantilla=dcv.id_plantilla
                              where         dcv.estado_reg = 'activo'
                                       and  to_char(dcv.fecha, 'YYYY-MM') = to_char(v_parametros.fecha, 'YYYY-MM') 
                                       --and  dcv.nit = v_parametros.nit   --#87 OJO pienso que el nro de nit no interesa, si da problema descomentar esta linea 
                                       and  dcv.nro_autorizacion = v_parametros.nro_autorizacion
                                       and  dcv.nro_documento = v_parametros.nro_documento
                                       and  dcv.nro_dui = v_parametros.nro_dui
                                       and  pla.sw_nro_dui = 'si'
                                       and  pla.tipo_informe='lcv'
                                       and  dcv.id_doc_compra_venta != v_parametros.id_doc_compra_venta
                                       
                                       ) then

                                 raise exception 'Ya existe una DUI registrada con el mismo nro,  nit y nro de autorizacion para el periodo';

                       END IF;
             
             
             ELSE
                      --#87 validacion para otros documetnos que no tiene NRO DE DUI
                      IF EXISTS(select
                                1
                              from conta.tdoc_compra_venta dcv
                              inner join param.tplantilla pla on pla.id_plantilla=dcv.id_plantilla
                              where         dcv.estado_reg = 'activo' 
                                       and  dcv.nit = v_parametros.nit
                                       and  dcv.nro_autorizacion = v_parametros.nro_autorizacion
                                       and  dcv.nro_documento = v_parametros.nro_documento
                                       and  pla.sw_nro_dui = 'no'
                                       and  pla.tipo_informe='lcv'
                                       and  dcv.id_doc_compra_venta != v_parametros.id_doc_compra_venta) then

                                 raise exception 'Ya existe un documento registrado con el mismo nro,  nit y nro de autorizacion';

                       END IF;

             
             END IF;
      
      
      
        -- chequear si el proveedor esta registrado
        v_id_proveedor = param.f_check_proveedor(p_id_usuario, v_parametros.nit, upper(trim(v_parametros.razon_social)));

      ELSE
        --TODO  chequear que la factura de venta no este duplicada
        -- chequear el el cliente esta registrado
        v_id_cliente = vef.f_check_cliente(p_id_usuario, v_parametros.nit, upper(trim(v_parametros.razon_social)));
        IF EXISTS(
                    select
                      1
                    from conta.tdoc_compra_venta dcv
                    inner join param.tplantilla pla on pla.id_plantilla=dcv.id_plantilla
                    where         dcv.estado_reg = 'activo'
                             and  to_char(dcv.fecha, 'YYYY-MM') = to_char(v_parametros.fecha, 'YYYY-MM') 
                             and  dcv.nit = v_parametros.nit   --#87 OJO pienso que el nro de nit no interesa, si da problema descomentar esta linea 
                             and  dcv.nro_autorizacion = v_parametros.nro_autorizacion
                             and  dcv.nro_documento = v_parametros.nro_documento
                             and  pla.tipo_informe='lcv'
                             and  dcv.id_doc_compra_venta != v_parametros.id_doc_compra_venta) then

                       raise exception 'Ya existe una Factura registrada con el mismo nro,  nit y nro de autorizacion para el periodo';

             END IF;
      END IF;


      if (pxp.f_existe_parametro(p_tabla,'id_int_comprobante')) then
          v_id_int_comprobante = v_parametros.id_int_comprobante;
      end if;

      IF v_id_int_comprobante is null THEN
        v_id_int_comprobante = v_registros.id_int_comprobante;
      END IF;

      
      --si tiene habilitado el ic copiamos el monto excento
      v_importe_ice = NULL;
      IF v_reg_plantilla.sw_ic = 'si' then
        v_importe_ice = v_parametros.importe_excento;
      END IF;

      IF v_parametros.importe_pendiente > 0 or v_parametros.importe_anticipo > 0 or v_parametros.importe_retgar > 0 THEN

        IF v_parametros.id_auxiliar is null THEN
          raise EXCEPTION 'es necesario indicar una cuenta corriente';
        END IF;

      END IF;
      
      
      --RAC 05/01/2018 nuevos para emtros para registro de pagos simplificados 
      if (pxp.f_existe_parametro(p_tabla,'id_funcionario')) then
          v_id_funcionario = v_parametros.id_funcionario;
      end if;
      
      
      if (pxp.f_existe_parametro(p_tabla,'sw_pgs')) then
          v_sw_pgs = v_parametros.sw_pgs;
      else
         v_sw_pgs = 'no';
      end if;
      
      --FIN RAC
      
      --# 2000, valida el campo codigo de aplicacion
      if (pxp.f_existe_parametro(p_tabla,'codigo_aplicacion')) then
          v_codigo_aplicacion = v_parametros.codigo_aplicacion;     
      end if; 
      
      if (pxp.f_existe_parametro(p_tabla,'id_contrato')) then
          v_id_contrato = v_parametros.id_contrato;     
      end if;
      --#113
      if (pxp.f_existe_parametro(p_tabla,'nro_tramite')) then
          v_nro_tramite = v_parametros.nro_tramite;     
      end if;
	  --#117
      if (pxp.f_existe_parametro(p_tabla,'nota_debito_agencia')) then
          v_nota_venta_agencia = v_parametros.nota_debito_agencia;     
      end if; 
      --Sentencia de la modificacion
      update conta.tdoc_compra_venta set
        tipo = v_parametros.tipo,
        importe_excento = v_parametros.importe_excento,
        id_plantilla = v_parametros.id_plantilla,
        fecha = v_parametros.fecha,
        nro_documento = v_parametros.nro_documento,
        nit = v_parametros.nit,
        importe_ice = v_importe_ice,
        nro_autorizacion =  upper(COALESCE(v_parametros.nro_autorizacion,'0')),
        importe_iva = v_parametros.importe_iva,
        importe_descuento = v_parametros.importe_descuento,
        importe_descuento_ley = v_parametros.importe_descuento_ley,
        importe_pago_liquido = v_parametros.importe_pago_liquido,
        importe_doc = v_parametros.importe_doc,
        id_depto_conta = v_parametros.id_depto_conta,
        obs = v_parametros.obs,
        codigo_control =  upper(COALESCE(v_parametros.codigo_control,'0')),
        importe_it = v_parametros.importe_it,
        razon_social = upper(trim(v_parametros.razon_social)),
        id_periodo = v_rec.po_id_periodo,
        nro_dui = v_parametros.nro_dui,
        id_moneda = v_parametros.id_moneda,
        importe_pendiente = COALESCE(v_parametros.importe_pendiente,0),
        importe_anticipo = COALESCE(v_parametros.importe_anticipo,0),
        importe_retgar = COALESCE(v_parametros.importe_retgar,0),
        importe_neto = v_parametros.importe_neto,
        id_proveedor = v_id_proveedor,
        id_cliente = v_id_cliente,
        id_auxiliar = v_parametros.id_auxiliar,
        id_int_comprobante = v_id_int_comprobante,
        id_funcionario = v_id_funcionario,
        sw_pgs = v_sw_pgs,
        codigo_aplicacion = v_codigo_aplicacion,
        id_contrato = v_id_contrato,
        nota_debito_agencia = v_nota_venta_agencia,--#116
        nro_tramite = v_nro_tramite      --#113
      where id_doc_compra_venta=v_parametros.id_doc_compra_venta;

      if (pxp.f_existe_parametro(p_tabla,'id_tipo_compra_venta')) then
        if(v_parametros.id_tipo_compra_venta is not null) then

          update conta.tdoc_compra_venta
          set id_tipo_doc_compra_venta = v_parametros.id_tipo_compra_venta
          where id_doc_compra_venta = v_parametros.id_doc_compra_venta;
        end if;
      end if;

	  if (pxp.f_existe_parametro(p_tabla,'estacion')) then
        if(v_parametros.estacion is not null) then

          update conta.tdoc_compra_venta
          set estacion = v_parametros.estacion
          where id_doc_compra_venta = v_parametros.id_doc_compra_venta;
        end if;
      end if;

      if (pxp.f_existe_parametro(p_tabla,'id_agencia')) then
        if(v_parametros.id_agencia is not null) then

          update conta.tdoc_compra_venta
          set id_agencia = v_parametros.id_agencia
          where id_doc_compra_venta = v_parametros.id_doc_compra_venta;
        end if;
      end if;

      --Definicion de la respuesta
      v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Documentos Compra/Venta modificado(a)');
      v_resp = pxp.f_agrega_clave(v_resp,'id_doc_compra_venta',v_parametros.id_doc_compra_venta::varchar);

      --Devuelve la respuesta
      return v_resp;

    end;

  /*********************************
   #TRANSACCION:  'CONTA_DCVCAJ_MOD'
   #DESCRIPCION:	Modificacion de registros
   #AUTOR:		Gonzalo Sarmiento
   #FECHA:		09-02-2017
  ***********************************/

  elsif(p_transaccion='CONTA_DCVCAJ_MOD')then

    begin

       v_rec = param.f_get_periodo_gestion(v_parametros.fecha);

      -- 13/01/2017
      --TODO RAC, me parece buena idea  que al cerrar el periodo revise que no existan documentos pendientes  antes de cerrar
      -- valida que period de libro de compras y ventas este abierto para la nueva fecha

      select tipo_informe into v_tipo_informe
      from param.tplantilla
      where id_plantilla = v_parametros.id_plantilla;

      IF v_tipo_informe = 'lcv' THEN
	      v_tmp_resp = conta.f_revisa_periodo_compra_venta(p_id_usuario, v_parametros.id_depto_conta, v_rec.po_id_periodo);
	  END IF;

      -- recuepra el periodo de la fecha ...
      --Obtiene el periodo a partir de la fecha
      /*
      v_rec = param.f_get_periodo_gestion(v_parametros.fecha);

      v_tmp_resp = conta.f_revisa_periodo_compra_venta(p_id_usuario, v_parametros.id_depto_conta, v_rec.po_id_periodo);
	  */

      --revisa si el documento no esta marcado como revisado
      select
        dcv.revisado,
        dcv.id_int_comprobante,
        dcv.id_origen,
        dcv.tabla_origen,
        dcv.fecha
      into
        v_registros
      from conta.tdoc_compra_venta dcv where dcv.id_doc_compra_venta =v_parametros.id_doc_compra_venta;

      IF  v_registros.revisado = 'si' THEN
        IF v_estado_rendicion NOT IN ('vbrendicion','revision') or v_estado_rendicion IS NULL THEN
          raise exception 'los documentos revisados no pueden modificarse';
        END IF;
      END IF;

      v_rec = param.f_get_periodo_gestion(v_registros.fecha);
	  -- valida que period de libro de compras y ventas este abierto para la antigua fecha
      IF v_tipo_informe = 'lcv' THEN
	      v_tmp_resp = conta.f_revisa_periodo_compra_venta(p_id_usuario, v_parametros.id_depto_conta, v_rec.po_id_periodo);
	  END IF;

      IF v_parametros.tipo = 'compra' THEN
        -- chequear si el proveedor esta registrado
        v_id_proveedor = param.f_check_proveedor(p_id_usuario, v_parametros.nit, upper(trim(v_parametros.razon_social)));

      ELSE
        --TODO  chequear que la factura de venta no este duplicada
        -- chequear el el cliente esta registrado
        v_id_cliente = vef.f_check_cliente(p_id_usuario, v_parametros.nit, upper(trim(v_parametros.razon_social)));
      END IF;

      if (pxp.f_existe_parametro(p_tabla,'id_int_comprobante')) then
          v_id_int_comprobante = v_parametros.id_int_comprobante;
      end if;

      IF v_id_int_comprobante is null THEN
        v_id_int_comprobante = v_registros.id_int_comprobante;
      END IF;

      -- recupera parametrizacion de la plantilla
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

      IF v_parametros.importe_pendiente > 0 or v_parametros.importe_anticipo > 0 or v_parametros.importe_retgar > 0 THEN

        IF v_parametros.id_auxiliar is null THEN
          raise EXCEPTION 'es necesario indicar una cuenta corriente';
        END IF;

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
        nro_autorizacion =  upper(COALESCE(v_parametros.nro_autorizacion,'0')),
        importe_iva = v_parametros.importe_iva,
        importe_descuento = v_parametros.importe_descuento,
        importe_descuento_ley = v_parametros.importe_descuento_ley,
        importe_pago_liquido = v_parametros.importe_pago_liquido,
        importe_doc = v_parametros.importe_doc,
        id_depto_conta = v_parametros.id_depto_conta,
        obs = v_parametros.obs,
        codigo_control =  upper(COALESCE(v_parametros.codigo_control,'0')),
        importe_it = v_parametros.importe_it,
        razon_social = upper(trim(v_parametros.razon_social)),
        id_periodo = v_rec.po_id_periodo,
        nro_dui = v_parametros.nro_dui,
        id_moneda = v_parametros.id_moneda,
        importe_pendiente = COALESCE(v_parametros.importe_pendiente,0),
        importe_anticipo = COALESCE(v_parametros.importe_anticipo,0),
        importe_retgar = COALESCE(v_parametros.importe_retgar,0),
        importe_neto = v_parametros.importe_neto,
        id_proveedor = v_id_proveedor,
        id_cliente = v_id_cliente,
        id_auxiliar = v_parametros.id_auxiliar,
        id_int_comprobante = v_id_int_comprobante,
        estacion = v_parametros.estacion
      where id_doc_compra_venta=v_parametros.id_doc_compra_venta;

      if (pxp.f_existe_parametro(p_tabla,'id_tipo_compra_venta')) then
        if(v_parametros.id_tipo_compra_venta is not null) then

          update conta.tdoc_compra_venta
          set id_tipo_doc_compra_venta = v_parametros.id_tipo_compra_venta
          where id_doc_compra_venta = v_parametros.id_doc_compra_venta;
        end if;
      end if;

      if (pxp.f_existe_parametro(p_tabla,'estacion')) then
        if(v_parametros.estacion is not null) then

          update conta.tdoc_compra_venta
          set estacion = v_parametros.estacion
          where id_doc_compra_venta = v_id_doc_compra_venta;
        end if;
      end if;

      if (pxp.f_existe_parametro(p_tabla,'id_agencia')) then
        if(v_parametros.id_agencia is not null) then

          update conta.tdoc_compra_venta
          set id_agencia = v_parametros.id_agencia
          where id_doc_compra_venta = v_id_doc_compra_venta;
        end if;
      end if;

      --Definicion de la respuesta
      v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Documentos Compra/Venta modificado(a)');
      v_resp = pxp.f_agrega_clave(v_resp,'id_doc_compra_venta',v_parametros.id_doc_compra_venta::varchar);

      --Devuelve la respuesta
      return v_resp;

    end;

  /*********************************
   #TRANSACCION:  'CONTA_DCVBASIC_MOD'
   #DESCRIPCION:	Modificacion basica de documento de compra venta
   #AUTOR:		admin
   #FECHA:		18-08-2015 15:57:09
  ***********************************/

  elsif(p_transaccion='CONTA_DCVBASIC_MOD')then

    begin

      select tcv.codigo into v_codigo_estado
      from conta.ttipo_doc_compra_venta tcv
      where tcv.id_tipo_doc_compra_venta = v_parametros.id_tipo_doc_compra_venta;

      /*Cambiar lso valores a 0 si es una anulacion*/

      if (v_codigo_estado = 'A') then
        update conta.tdoc_compra_venta set
          importe_iva = 0,
          importe_excento = 0,
          importe_descuento = 0,
          importe_descuento_ley = 0,
          importe_pago_liquido = 0,
          importe_doc = 0,
          importe_it = 0,
          importe_pendiente = 0,
          importe_anticipo = 0,
          importe_retgar = 0,
          importe_neto = 0
        where id_doc_compra_venta=v_parametros.id_doc_compra_venta;
      end if;

      --Sentencia de la modificacion
      update conta.tdoc_compra_venta set
        id_tipo_doc_compra_venta = v_parametros.id_tipo_doc_compra_venta
      where id_doc_compra_venta=v_parametros.id_doc_compra_venta;

      --Definicion de la respuesta
      v_resp = pxp.f_agrega_clave(v_resp,'mensaje','estado del documento modificado');
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
        dcv.revisado,
        dcv.id_int_comprobante,
        dcv.tabla_origen,
        dcv.id_origen,
        dcv.id_depto_conta,
        dcv.fecha,
        dcv.id_plantilla
      into
        v_registros
      from conta.tdoc_compra_venta dcv where dcv.id_doc_compra_venta =v_parametros.id_doc_compra_venta;

      IF  v_registros.revisado = 'si' THEN
        raise exception 'los documentos revisados no pueden eliminarse';
      END IF;

      -- revisar si el archivo es manual o no

      IF v_registros.id_origen is not null THEN
        raise exception 'Solo puede eliminar los documentos insertados manualmente';
      END IF;



      --validar si el periodo de conta esta cerrado o abierto
      -- recuepra el periodo de la fecha ...
      --Obtiene el periodo a partir de la fecha
      v_rec = param.f_get_periodo_gestion(v_registros.fecha);

	  select tipo_informe into v_tipo_informe
      from param.tplantilla
      where id_plantilla = v_registros.id_plantilla;

      -- valida que period de libro de compras y ventas este abierto
      IF v_tipo_informe = 'lcv' THEN
      	 v_tmp_resp = conta.f_revisa_periodo_compra_venta(p_id_usuario, v_registros.id_depto_conta, v_rec.po_id_periodo);
	  END IF;


      --validar que no tenga un comprobante asociado

      IF  v_registros.id_int_comprobante is not NULL THEN
        raise exception 'No puede elimiar por que el documento esta acociado al cbte id(%), primero quite esta relacion', v_registros.id_int_comprobante;
      END IF;


      --Sentencia de la eliminacion
      delete from conta.tdoc_concepto
      where id_doc_compra_venta=v_parametros.id_doc_compra_venta;


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

      IF COALESCE(v_sum_total,0) !=  COALESCE(v_registros.importe_doc,0)  THEN
        raise exception 'el total del documento no iguala con el total detallado de conceptos';
      END IF;


      --Definicion de la respuesta
      v_resp = pxp.f_agrega_clave(v_resp,'mensaje','cuadra el documento insertado');
      v_resp = pxp.f_agrega_clave(v_resp,'sum_total',v_sum_total::varchar);

      --Devuelve la respuesta
      return v_resp;

    end;

  /*********************************
   #TRANSACCION:  'CONTA_QUITCBTE_ELI'
   #DESCRIPCION:	quita el comprobante del documento
   #AUTOR:		admin
   #FECHA:		25-09-2015 15:57:09
  ***********************************/

  elsif(p_transaccion='CONTA_QUITCBTE_ELI')then

    begin


      update conta.tdoc_compra_venta  set
        id_int_comprobante = NULL
      where id_doc_compra_venta=v_parametros.id_doc_compra_venta;



      --Definicion de la respuesta
      v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se retiro el cbte del documento '||v_parametros.id_doc_compra_venta);
      v_resp = pxp.f_agrega_clave(v_resp,'id_doc_compra_venta',v_parametros.id_doc_compra_venta::varchar);

      --Devuelve la respuesta
      return v_resp;

    end;
  /*********************************
 #TRANSACCION:  'CONTA_ADDCBTE_IME'
 #DESCRIPCION:	adiciona un documento al comprobante
 #AUTOR:		RAC
 #FECHA:		25-09-2015 15:57:09
***********************************/

  elsif(p_transaccion='CONTA_ADDCBTE_IME')then

    begin

      -- validamos que el documento no tenga otro comprobante

      IF not EXISTS(select
                      1
                    from conta.tdoc_compra_venta dcv
                    where dcv.id_doc_compra_venta = v_parametros.id_doc_compra_venta and dcv.id_int_comprobante is null) THEN

        raise exception 'El documento no existe o ya tiene un cbte relacionado';
      END IF;
      
      --#14, recupera nro de tramite del cbte
      
      select
         cbte.nro_tramite
      into
        v_nro_tramite
      from conta.tint_comprobante cbte
      where cbte.id_int_comprobante = v_parametros.id_int_comprobante;

      update conta.tdoc_compra_venta d  set
        id_int_comprobante =  v_parametros.id_int_comprobante,
        nro_tramite =   v_nro_tramite
      where id_doc_compra_venta = v_parametros.id_doc_compra_venta;



      --Definicion de la respuesta
      v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se adiciono el cbte del documento '||v_parametros.id_doc_compra_venta ||' cbte '||v_parametros.id_int_comprobante);
      v_resp = pxp.f_agrega_clave(v_resp,'id_doc_compra_venta',v_parametros.id_doc_compra_venta::varchar);

      --Devuelve la respuesta
      return v_resp;

    end;
/*********************************
 #TRANSACCION:  'CONTA_RAZONXNIT_GET'
 #DESCRIPCION:	recuperar razon social nit
 #AUTOR:		MMV
 #FECHA:		19-04-2017
***********************************/

  elsif(p_transaccion='CONTA_RAZONXNIT_GET')then

    begin
    
        --obtener gestion en funcion de la fecha
        
        select 
           per.id_gestion,
           per.id_periodo,
           per.periodo
         into
           v_reg_periodo
        from  param.tperiodo per
        where  v_parametros.fecha BETWEEN per.fecha_ini and per.fecha_fin
               and per.estado_reg = 'activo';
           
        IF v_reg_periodo is null THEN
           raise exception  'No se encontro periodo para la fecha %',v_parametros.fecha; 
        END IF;    
            
        
        --raise EXCEPTION 'esta llegando  %',v_parametros.nit;
        select
            DISTINCT(dcv.nit),
            dcv.razon_social,
            m.id_moneda,
            m.moneda
            into
            v_nit,
            v_razon_social,
            v_id_moneda,
            v_nomeda
            from conta.tdoc_compra_venta dcv
            inner join param.tmoneda m on m.id_moneda = dcv.id_moneda
            where dcv.nit != '' and dcv.nit like ''||COALESCE(v_parametros.nit,'-')||'%';
          --Definicion de la respuesta
          v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Transaccion Exitosa');
          v_resp = pxp.f_agrega_clave(v_resp,'razon_social',v_razon_social::varchar);
          v_resp = pxp.f_agrega_clave(v_resp,'id_nomeda',v_id_moneda::varchar);
          v_resp = pxp.f_agrega_clave(v_resp,'moneda',v_nomeda::varchar);
          v_resp = pxp.f_agrega_clave(v_resp,'id_gestion',v_reg_periodo.id_gestion::varchar);
          v_resp = pxp.f_agrega_clave(v_resp,'id_periodo',v_reg_periodo.id_periodo::varchar);
          v_resp = pxp.f_agrega_clave(v_resp,'periodo',v_reg_periodo.periodo::varchar);
          --Devuelve la respuesta
      return v_resp;

    end;
    
   /*********************************
   #TRANSACCION:  'CONTA_EDITAPLI_MOD'
   #DESCRIPCION:	Edita la aplicacion del documento
   #AUTOR:		rac
   #FECHA:		08/05/2018
  ***********************************/

  elsif(p_transaccion='CONTA_EDITAPLI_MOD')then

        begin

                select 
                   tcv.id_int_comprobante ,
                   tcv.id_doc_compra_venta
                into v_registros
                from conta.tdoc_compra_venta tcv
                where tcv.id_doc_compra_venta = v_parametros.id_doc_compra_venta;

                /*Cambiar lso valores a 0 si es una anulacion*/

                 -- if v_registros.id_int_comprobante is null  then
                if  0 = 0 then
               
                    --Sentencia de la modificacion
                    update conta.tdoc_compra_venta set
                      codigo_aplicacion  =  v_parametros.codigo_aplicacion
                    where id_doc_compra_venta = v_parametros.id_doc_compra_venta;

                    --Definicion de la respuesta
                    v_resp = pxp.f_agrega_clave(v_resp,'mensaje','fue modificada la aplicacion del documento');
                    v_resp = pxp.f_agrega_clave(v_resp,'id_doc_compra_venta',v_parametros.id_doc_compra_venta::varchar);

                    --Devuelve la respuesta
                    return v_resp;
                else    
                        raise exception 'Solo puede modificar la aplicación a documentos sin comprobante';
                end if;  



        end;
        
  /*********************************
   #TRANSACCION:  'CONTA_RELFACNCD_IME'
   #DESCRIPCION:   ISSUE 1999 ,  relaciona facturas a documentos del tipo notas de credito y debito
   #AUTOR:		rac
   #FECHA:		08/07/2018
  ***********************************/

  elsif(p_transaccion='CONTA_RELFACNCD_IME')then

        begin
        
            select 
               dcv.nit,
               dcv.importe_doc,
               dcv.id_moneda,
               dcv.fecha,
               dcv.id_moneda
            into
              v_registros_ncd
            from conta.tdoc_compra_venta dcv 
            where dcv.id_doc_compra_venta = v_parametros.id_doc_compra_venta;
         
            select 
               dcv.nit,
               dcv.id_moneda,
               dcv.importe_doc,
               dcv.fecha,
               dcv.id_moneda
            into
              v_registros
            from conta.tdoc_compra_venta dcv 
            where dcv.id_doc_compra_venta = v_parametros.id_doc_compra_venta_fk;
            
            IF v_registros.nit != v_registros_ncd.nit  THEN
               raise exception 'El nit no se correponde con la factura deberia ser: % ', v_registros_ncd.nit;
            END IF;
               
            
             IF v_registros.fecha > v_registros_ncd.fecha  THEN
               raise exception 'la fecha de la factura asociada debe ser menor o igual a: % ', v_registros_ncd.fecha;
            END IF;
            
            IF v_registros.id_moneda != v_registros_ncd.id_moneda  THEN
               raise exception 'tiene que ser de la misma moneda';
            END IF;
            
            --revisamos que el importe no supera el 90%
            --lsitamos si tiene otra nostas de credito debito
            select 
               sum(dcv.importe_doc) into v_suma_otros_creditos
            from conta.tdoc_compra_venta dcv 
            where       dcv.id_doc_compra_venta_fk = v_parametros.id_doc_compra_venta_fk   
                   AND  dcv.id_doc_compra_venta != v_parametros.id_doc_compra_venta
                   AND  dcv.estado_reg = 'activo';
                   
                   
             IF   ( COALESCE(v_suma_otros_creditos,0) + v_registros_ncd.importe_doc ) >  (v_registros.importe_doc * 0.9)   THEN
                     raise exception 'El monto total sobrepasa el 90 porciento del documento original';
             END IF;      
            
            --raise exception 'llega.... % , %',v_parametros.id_doc_compra_venta_fk, v_parametros.id_doc_compra_venta;
        
            UPDATE conta.tdoc_compra_venta dcv set
              id_doc_compra_venta_fk = v_parametros.id_doc_compra_venta_fk
            WHERE dcv.id_doc_compra_venta = v_parametros.id_doc_compra_venta;
            
            
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','factura NCD relacionada : ID '||v_parametros.id_doc_compra_venta::varchar||'  id FK'||v_parametros.id_doc_compra_venta_fk::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'id_doc_compra_venta',v_parametros.id_doc_compra_venta::varchar);

            --Devuelve la respuesta
            return v_resp;

            
        end;
    /*********************************
   #TRANSACCION:  'CONTA_GETFACNCD_IME'
   #DESCRIPCION:   ISSUE 1999 ,  recupera datos de la factura relacionada
   #AUTOR:		rac
   #FECHA:		23/07/2018
  ***********************************/

  elsif(p_transaccion='CONTA_GETFACNCD_IME')then

        begin
        
            select 
               dcv.nit,
               dcv.importe_doc,
               dcv.nro_documento,
               dcv.razon_social,
               dcv.id_moneda,
               dcv.fecha,
               dcv.nro_autorizacion
            into
              v_registros_ncd
            from conta.tdoc_compra_venta dcv 
            where dcv.id_doc_compra_venta = v_parametros.id_doc_compra_venta_fk;
         
            
            
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','factura NCD relacionada : ID '||v_parametros.id_doc_compra_venta::varchar||'  id FK'||v_parametros.id_doc_compra_venta_fk::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'id_doc_compra_venta',v_parametros.id_doc_compra_venta::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'id_doc_compra_venta_fk',v_parametros.id_doc_compra_venta_fk::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'nit',v_registros_ncd.nit::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'importe_doc',v_registros_ncd.importe_doc::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'razon_social',v_registros_ncd.razon_social::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'fecha',v_registros_ncd.fecha::varchar);            
            v_resp = pxp.f_agrega_clave(v_resp,'nro_documento',v_registros_ncd.nro_documento::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'nro_autorizacion',v_registros_ncd.nro_autorizacion::varchar);

            --Devuelve la respuesta
            return v_resp;

            
        end;        
     /*********************************
   #TRANSACCION:  'CONTA_FACONT_IME'
   #DESCRIPCION:   Relacionar contrato con factura
   #AUTOR:		MMV
   #FECHA:		28/09/2018
  ***********************************/
  elsif(p_transaccion='CONTA_FACONT_IME')then

	begin
    --- raise exception 'contrato % doc %',v_parametros.id_contrato,v_parametros.id_doc_compra_venta;
        update conta.tdoc_compra_venta  set
        id_contrato = v_parametros.id_contrato
        where id_doc_compra_venta = v_parametros.id_doc_compra_venta;  
        
      --Definicion de la respuesta
      v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Documentos Compra/Venta modificado(a)');
      v_resp = pxp.f_agrega_clave(v_resp,'id_doc_compra_venta',v_parametros.id_doc_compra_venta::varchar);
      
      --Devuelve la respuesta
            return v_resp;

            
        end;      
    /*********************************
   #TRANSACCION:  'CONTA_FACQUI_IME'
   #DESCRIPCION:   Quitar relacion factura con contrato
   #AUTOR:		MMV
   #FECHA:		28/09/2018
  ***********************************/
  elsif(p_transaccion='CONTA_FACQUI_IME')then

	begin
     
        update conta.tdoc_compra_venta  set
        id_contrato = null
        where id_doc_compra_venta = v_parametros.id_doc_compra_venta;  
        
      --Definicion de la respuesta
      v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Documentos Compra/Venta modificado(a)');
      v_resp = pxp.f_agrega_clave(v_resp,'id_doc_compra_venta',v_parametros.id_doc_compra_venta::varchar);
      
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
PARALLEL UNSAFE
COST 100;