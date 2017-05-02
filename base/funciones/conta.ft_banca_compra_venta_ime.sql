CREATE OR REPLACE FUNCTION conta.ft_banca_compra_venta_ime(p_administrador int4, p_id_usuario int4, p_tabla varchar, p_transaccion varchar)
  RETURNS varchar
AS
$BODY$
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

  v_nro_requerimiento                             INTEGER;
  v_parametros                                    RECORD;
  v_id_requerimiento                              INTEGER;
  v_resp                                          VARCHAR;
  v_nombre_funcion                                TEXT;
  v_mensaje_error                                 TEXT;
  v_id_banca_compra_venta                         INTEGER;

  v_registros                                     RECORD;

  v_rec                                           RECORD;
  v_tmp_resp                                      BOOLEAN;
  v_registros_json                                RECORD;
  anoop                                           RECORD;

  v_id_periodo                                    INTEGER;
  v_id_txt_importacion_bcv                        INTEGER;


  v_record_plan_pago_pxp                          RECORD;
  v_consulta                                      VARCHAR;
  v_host                                          VARCHAR;
  v_rec2                                          RECORD;
  v_rec_periodo_seleccionado                      RECORD;
  v_modalidad_de_transaccion                      INTEGER;
  v_tipo_transaccion                              INTEGER;
  v_numero_de_contrato                            VARCHAR;
  v_tipo_documento_pago                           INTEGER;
  v_doc_id                                        VARCHAR;

  v_periodo                                       RECORD;

  v_saldo                                         NUMERIC;
  v_monto_contrato                                NUMERIC;
  v_monto_acumulado                               NUMERIC;
  v_monto_acumulado_aux                           NUMERIC;

  v_numero_tramite_y_cuota                        VARCHAR;
  v_consulta_sigma                                VARCHAR;

  v_fecha_libro_o_entrega                         DATE;
  v_nro_cheque_o_sigma                            VARCHAR;
  v_resolucion                                    VARCHAR;

  v_porciento_en_relacion_a_monto_total_plan_pago NUMERIC;
  v_monto_cuota_en_relacion_al_pago_total         NUMERIC;
  v_monto_pagado                                  NUMERIC;
  v_monto_pagado_para_acumular                    NUMERIC;
  v_retencion_cuota                               NUMERIC;

  v_multa_porcentaje                              NUMERIC;
  v_multa_cuota                                   NUMERIC;
  v_intercambio_de_servicio_porcentaje            NUMERIC;
  v_intercambio_de_servicio_cuota                 NUMERIC;

  v_numeros_de_tramites                           VARCHAR;

  v_record_retencion_original                     RECORD;

  v_id_obligacion_pago    INTEGER;


  v_banca RECORD;
  v_estado_gestion VARCHAR;


BEGIN

  v_nombre_funcion = 'conta.ft_banca_compra_venta_ime';
  v_parametros = pxp.f_get_record(p_tabla);

  /*********************************
   #TRANSACCION: 'CONTA_BANCA_INS'
   #DESCRIPCION:	Insercion de registros
   #AUTOR:		admin
   #FECHA:		11-09-2015 14:36:46
  ***********************************/

  IF (p_transaccion='CONTA_BANCA_INS')
  THEN

    BEGIN

      --verificamos la gestion si esta abierta
      select banges.estado into v_estado_gestion from conta.tbancarizacion_gestion banges
        INNER JOIN param.tgestion ges on ges.id_gestion = banges.id_gestion
        inner join param.tperiodo per on per.id_gestion = ges.id_gestion
      where per.id_periodo = v_parametros.id_periodo;

      IF v_estado_gestion = 'Bloqueado' THEN
        RAISE EXCEPTION '%','GESTION BLOQUEADA';
      END IF;







      --fechas fecha_documento y fecha_de_pago
      IF (v_parametros.fecha_documento :: VARCHAR != '' AND v_parametros.fecha_de_pago :: VARCHAR != '')
      THEN
        IF (v_parametros.fecha_documento :: DATE > v_parametros.fecha_de_pago)
        THEN
          v_rec = param.f_get_periodo_gestion(v_parametros.fecha_documento);
          v_id_periodo = v_rec.po_id_periodo;
        ELSE
          v_rec = param.f_get_periodo_gestion(v_parametros.fecha_de_pago);
          v_id_periodo = v_rec.po_id_periodo;
        END IF;

      ELSE
        v_id_periodo = v_parametros.id_periodo;
      END IF;



      -- recuepra el periodo de la fecha ...
      --Obtiene el periodo a partir de la fecha
      --v_rec = param.f_get_periodo_gestion(v_parametros.fecha_documento);

      -- valida que period de libro de compras y ventas este abierto
      --v_tmp_resp = conta.f_revisa_periodo_compra_venta(p_id_usuario, v_parametros.id_depto_conta, v_rec.po_id_periodo);


      --Sentencia de la insercion
      INSERT INTO conta.tbanca_compra_venta (
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
        id_depto_conta,
        tramite_cuota
      ) VALUES (
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
        NULL,
        NULL,
        v_parametros.id_contrato,
        v_parametros.id_proveedor,
        v_parametros.id_cuenta_bancaria,
        v_parametros.id_documento,
        v_parametros.periodo_servicio,
        v_parametros.numero_cuota,
        v_parametros.id_depto_conta,
        v_parametros.tramite_cuota


      )
      RETURNING id_banca_compra_venta
        INTO v_id_banca_compra_venta;

      --Definicion de la respuesta
      v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'bancarizacion almacenado(a) con exito (id_banca_compra_venta' ||
                                                     v_id_banca_compra_venta || ')');
      v_resp = pxp.f_agrega_clave(v_resp, 'id_banca_compra_venta', v_id_banca_compra_venta :: VARCHAR);

      --Devuelve la respuesta
      RETURN v_resp;

    END;

    /*********************************
     #TRANSACCION: 'CONTA_BANCA_MOD'
     #DESCRIPCION:	Modificacion de registros
     #AUTOR:		admin
     #FECHA:		11-09-2015 14:36:46
    ***********************************/

  ELSIF (p_transaccion='CONTA_BANCA_MOD')
    THEN

      BEGIN




        IF (v_parametros.fecha_documento :: VARCHAR != '' AND v_parametros.fecha_de_pago :: VARCHAR != '')
        THEN


          IF (v_parametros.fecha_documento :: DATE > v_parametros.fecha_de_pago :: DATE)


          THEN
            v_rec = param.f_get_periodo_gestion(v_parametros.fecha_documento);
            v_id_periodo = v_rec.po_id_periodo;
          ELSE
            v_rec = param.f_get_periodo_gestion(v_parametros.fecha_de_pago);
            v_id_periodo = v_rec.po_id_periodo;
          END IF;


          SELECT resolucion
          INTO v_resolucion
          FROM conta.tbanca_compra_venta
          WHERE id_banca_compra_venta = v_parametros.id_banca_compra_venta;

          --si la resolucion es antigua solo tomamos en cuenta la fecha de pago
          IF (v_resolucion = '10-0011-11')
          THEN

            v_rec = param.f_get_periodo_gestion(v_parametros.fecha_de_pago);
            v_id_periodo = v_rec.po_id_periodo;


          ELSE

            /*SELECT
              id_periodo,
              resolucion
            INTO v_id_periodo, v_resolucion
            FROM conta.tbanca_compra_venta
            WHERE id_banca_compra_venta = v_parametros.id_banca_compra_venta;*/


          END IF;

        END IF;



        --verificamos la gestion si esta abierta
        select banges.estado into v_estado_gestion from conta.tbancarizacion_gestion banges
          INNER JOIN param.tgestion ges on ges.id_gestion = banges.id_gestion
          inner join param.tperiodo per on per.id_gestion = ges.id_gestion
        where per.id_periodo = v_id_periodo;
        IF v_estado_gestion = 'Bloqueado' THEN
          RAISE EXCEPTION '%','GESTION BLOQUEADA';
        END IF;
        ----------------------------


        --revisa si el documento no esta marcado como revisado
        SELECT dcv.revisado
        INTO
          v_registros
        FROM conta.tbanca_compra_venta dcv
        WHERE dcv.id_banca_compra_venta = v_parametros.id_banca_compra_venta;

        IF v_registros.revisado = 'si'
        THEN
          RAISE EXCEPTION 'los documentos revisados no peuden modificarse';
        END IF;



         v_monto_contrato = v_parametros.monto_contrato;
        v_monto_acumulado = v_parametros.monto_acumulado;

        SELECT banca.id_contrato,contrato.tipo_monto
        into v_banca
        from conta.tbanca_compra_venta banca
        LEFT JOIN leg.tcontrato contrato on contrato.id_contrato = banca.id_contrato
        where banca.id_banca_compra_venta = v_parametros.id_banca_compra_venta;


        IF v_banca.tipo_monto = 'abierto' THEN
           v_monto_contrato = v_parametros.importe_documento::NUMERIC;
        END IF;

     -- RAISE EXCEPTION '%',v_banca;




        v_saldo = v_monto_contrato - v_monto_acumulado;




        --Sentencia de la modificacion
        UPDATE conta.tbanca_compra_venta
        SET
          num_cuenta_pago       = v_parametros.num_cuenta_pago,
          tipo_documento_pago   = v_parametros.tipo_documento_pago,
          num_documento         = v_parametros.num_documento,
          monto_acumulado       = v_parametros.monto_acumulado,
          nit_ci                = v_parametros.nit_ci,
          importe_documento     = v_parametros.importe_documento,
          fecha_documento       = v_parametros.fecha_documento,
          modalidad_transaccion = v_parametros.modalidad_transaccion,
          tipo_transaccion      = v_parametros.tipo_transaccion,
          autorizacion          = v_parametros.autorizacion,
          monto_pagado          = v_parametros.monto_pagado,
          fecha_de_pago         = v_parametros.fecha_de_pago,
          razon                 = v_parametros.razon,
          tipo                  = v_parametros.tipo,
          num_documento_pago    = v_parametros.num_documento_pago,
          num_contrato          = v_parametros.num_contrato,
          nit_entidad           = v_parametros.nit_entidad,
          id_usuario_mod        = p_id_usuario,
          fecha_mod             = now(),
          id_usuario_ai         = v_parametros._id_usuario_ai,
          usuario_ai            = v_parametros._nombre_usuario_ai,
          id_contrato           = v_parametros.id_contrato,
          id_proveedor          = v_parametros.id_proveedor,
          id_cuenta_bancaria    = v_parametros.id_cuenta_bancaria,
          id_documento          = v_parametros.id_documento,
          id_periodo            = v_id_periodo,
          saldo                 = v_saldo,
          tramite_cuota         = v_parametros.tramite_cuota,
          periodo_servicio      = v_parametros.periodo_servicio

        WHERE id_banca_compra_venta = v_parametros.id_banca_compra_venta;

        --Definicion de la respuesta
        v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'bancarizacion modificado(a)');
        v_resp = pxp.f_agrega_clave(v_resp, 'id_banca_compra_venta', v_parametros.id_banca_compra_venta :: VARCHAR);

        --Devuelve la respuesta
        RETURN v_resp;

      END;

      /*********************************
       #TRANSACCION: 'CONTA_BANCA_ELI'
       #DESCRIPCION:	Eliminacion de registros
       #AUTOR:		admin
       #FECHA:		11-09-2015 14:36:46
      ***********************************/

  ELSIF (p_transaccion='CONTA_BANCA_ELI')
    THEN

      BEGIN


        select * into v_rec from conta.tbanca_compra_venta where id_banca_compra_venta = v_parametros.id_banca_compra_venta;
        --verificamos la gestion si esta abierta
        select banges.estado into v_estado_gestion from conta.tbancarizacion_gestion banges
          INNER JOIN param.tgestion ges on ges.id_gestion = banges.id_gestion
          inner join param.tperiodo per on per.id_gestion = ges.id_gestion
        where per.id_periodo = v_rec.id_periodo;
        IF v_estado_gestion = 'Bloqueado' THEN
          RAISE EXCEPTION '%','GESTION BLOQUEADA';
        END IF;



        IF v_rec.revisado = 'si' THEN
          RAISE EXCEPTION '%','NO PUEDES ELIMINAR UN REGISTRO REVISADO';
        END IF;
        ----------------------------

        --Sentencia de la eliminacion
        DELETE FROM conta.tbanca_compra_venta
        WHERE id_banca_compra_venta = v_parametros.id_banca_compra_venta;

        --Definicion de la respuesta
        v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'bancarizacion eliminado(a)');
        v_resp = pxp.f_agrega_clave(v_resp, 'id_banca_compra_venta', v_parametros.id_banca_compra_venta :: VARCHAR);

        --Devuelve la respuesta
        RETURN v_resp;

      END;

      /*********************************
     #TRANSACCION: 'CONTA_BANCA_ELITO'
     #DESCRIPCION:	ELIMINA TODOS LOS REGISTROS
     #AUTOR:		admin
     #FECHA:		11-09-2015 14:36:46
    ***********************************/

  ELSIF (p_transaccion='CONTA_BANCA_ELITO')
    THEN

      BEGIN
        --Sentencia de la eliminacion


        --verificamos la gestion si esta abierta
        select banges.estado into v_estado_gestion from conta.tbancarizacion_gestion banges
          INNER JOIN param.tgestion ges on ges.id_gestion = banges.id_gestion
          inner join param.tperiodo per on per.id_gestion = ges.id_gestion
        where per.id_periodo =  v_parametros.id_periodo;
        IF v_estado_gestion = 'Bloqueado' THEN
          RAISE EXCEPTION '%','GESTION BLOQUEADA';
        END IF;



        DELETE FROM conta.tbanca_compra_venta ban
        WHERE ban.id_periodo = v_parametros.id_periodo
              AND ban.id_depto_conta = v_parametros.id_depto_conta
              AND ban.tipo = v_parametros.tipo
              AND ban.revisado = 'no'
              AND ban.lista_negra = 'no';

        --Definicion de la respuesta
        v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'bancarizacion eliminado(a)');
        --v_resp = pxp.f_agrega_clave(v_resp,'id_banca_compra_venta',v_parametros.id_banca_compra_venta::varchar);

        --Devuelve la respuesta
        RETURN v_resp;

      END;

      /*********************************
 #TRANSACCION: 'CONTA_BANCA_IMP'
 #DESCRIPCION:	Importacion de archivo txt
 #AUTOR:		admin
 #FECHA:		22-09-2015 14:36:46
***********************************/

  ELSIF (p_transaccion='CONTA_BANCA_IMP')
    THEN

      BEGIN





        --select * into v_registros_json from json('{"name":"depesz","password":"super simple","grades":[1,3,1,1,1,2],"skills":{"a":"b", "c":[1,2,3]}}');

        --raise exception '%',v_parametros.nombre_archivo;

        v_rec = param.f_get_periodo_gestion(v_parametros.fecha_archivo);


        IF (v_parametros.fecha_archivo :: DATE < '01/07/2015' :: DATE)
        THEN

        --raise exception '%','es de la anterior version';

        ELSE

        END IF;


        INSERT INTO conta.ttxt_importacion_bcv (
          nombre_archivo,
          id_periodo,
          estado_reg,
          id_usuario_ai,
          usuario_ai,
          fecha_reg,
          id_usuario_reg,
          fecha_mod,
          id_usuario_mod
        ) VALUES (
          v_parametros.nombre_archivo,
          v_rec.po_id_periodo,
          'activo',
          v_parametros._id_usuario_ai,
          v_parametros._nombre_usuario_ai,
          now(),
          p_id_usuario,
          NULL,
          NULL


        )
        RETURNING id_txt_importacion_bcv
          INTO v_id_txt_importacion_bcv;




        FOR v_registros_json IN (SELECT *
                                 FROM json_populate_recordset(NULL :: conta.json_imp_banca_compra_venta_dos,
                                                              v_parametros.arra_json :: JSON)) LOOP

          IF v_registros_json.fecha_documento::DATE >= v_registros_json.fecha_de_pago::DATE THEN
            v_rec = param.f_get_periodo_gestion(v_registros_json.fecha_documento::DATE);
            ELSE
              v_rec = param.f_get_periodo_gestion(v_registros_json.fecha_de_pago::DATE);

          END IF;


          --verificamos la gestion si esta abierta
          select banges.estado into v_estado_gestion from conta.tbancarizacion_gestion banges
            INNER JOIN param.tgestion ges on ges.id_gestion = banges.id_gestion
            inner join param.tperiodo per on per.id_gestion = ges.id_gestion
          where per.id_periodo =   v_rec.po_id_periodo;
          IF v_estado_gestion = 'Bloqueado' THEN
            RAISE EXCEPTION '%','GESTION BLOQUEADA';
          END IF;


          --solo va para un registro de un excel despues comentar
          v_saldo = v_registros_json.importe_documento::numeric - v_registros_json.monto_acumulado::numeric;


          INSERT INTO conta.tbanca_compra_venta (
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
            fecha_mod,
            registro,
            id_depto_conta,
            id_proveedor,
            id_cuenta_bancaria,
            resolucion,
            revisado,
            tramite_cuota,
            num_contrato,
            saldo
          ) VALUES (
            v_registros_json.num_cuenta_pago,
            v_registros_json.tipo_documento_pago::numeric,
            v_registros_json.num_documento,
            v_registros_json.monto_acumulado::numeric,
            'activo',
            v_registros_json.nit_ci,
            v_registros_json.importe_documento::numeric,
            v_registros_json.fecha_documento::date,
            v_registros_json.modalidad_transaccion::INTEGER,
            v_registros_json.tipo_transaccion::INTEGER,
            v_registros_json.autorizacion::numeric,
            v_registros_json.monto_pagado::numeric,
            v_registros_json.fecha_de_pago::date,
            v_registros_json.razon,
            v_parametros.tipo,
            v_registros_json.num_documento_pago,
            --v_registros_json.num_contrato,
            v_registros_json.nit_entidad::numeric,
            v_rec.po_id_periodo,
            now(),
            v_parametros._nombre_usuario_ai,
            p_id_usuario,
            v_parametros._id_usuario_ai,
            NULL,
            NULL,
            'importado',
            4,
            178,--id del proveedor
            61,
            '10-0017-15',
            'si',
            'SIN TRAMITE',
            0,
            v_saldo


          );
        END LOOP;

        --Definicion de la respuesta
        v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'bancarizacion eliminado(a)');
        v_resp = pxp.f_agrega_clave(v_resp, 'id_banca_compra_venta', 10 :: VARCHAR);

        --Devuelve la respuesta
        RETURN v_resp;

      END;


      /*********************************
    #TRANSACCION: 'CONTA_BANCA_AUT'
    #DESCRIPCION:	Inserccion de registros automatico desde endesis y pxp
    #AUTOR:		ffigueroa
    #FECHA:		18-03-2016 14:36:46
   ***********************************/

  ELSIF (p_transaccion='CONTA_BANCA_AUT')
    THEN

      BEGIN

        --raise exception '%',v_parametros.id_depto_conta;


        --verificamos la gestion si esta abierta
        select banges.estado into v_estado_gestion from conta.tbancarizacion_gestion banges
          INNER JOIN param.tgestion ges on ges.id_gestion = banges.id_gestion
          inner join param.tperiodo per on per.id_gestion = ges.id_gestion
        where per.id_periodo =   v_parametros.id_periodo;
        IF v_estado_gestion = 'Bloqueado' THEN
          RAISE EXCEPTION '%','GESTION BLOQUEADA';
        END IF;



        SELECT
          per.fecha_ini,
          per.fecha_fin,
          param.f_literal_periodo(per.id_periodo) AS periodo,
          ges.gestion
        INTO v_periodo
        FROM param.tperiodo per
          INNER JOIN param.tgestion ges on ges.id_gestion = per.id_gestion
        WHERE per.id_periodo = v_parametros.id_periodo;


        v_host:='dbname=dbendesis host=192.168.100.30 user=ende_pxp password=ende_pxp';

        --creacion de tabla temporal del endesis
        v_consulta = conta.f_obtener_string_documento_bancarizacion(v_periodo.gestion::INTEGER);



       /* v_consulta:= ' WITH tabla_temporal_documentos AS (
              SELECT * FROM dblink(''' || v_host || ''',
          ''select tctcomp.id_int_comprobante,
          tctdoc.razon_social,
          tctdoc.id_documento,
          docval.importe_total,
          docval.id_moneda,
          tctdoc.nro_documento,
          tctdoc.nro_autorizacion,
          tctdoc.fecha_documento,
          tctdoc.nro_nit,
          traval.importe_debe,
          traval.importe_gasto
          from sci.tct_comprobante tctcomp
          inner join sci.tct_transaccion tcttra on tcttra.id_comprobante = tctcomp.id_comprobante
          inner JOIN sci.tct_transac_valor traval on traval.id_transaccion = tcttra.id_transaccion
          inner join sci.tct_documento tctdoc on tctdoc.id_transaccion = tcttra.id_transaccion
          inner join sci.tct_documento_valor docval on docval.id_documento = tctdoc.id_documento
          where   docval.id_moneda = 1 and traval.id_moneda=1
           ''
                   ) AS d (id_int_comprobante integer,
                   razon_social varchar(500),
                    id_documento integer,
                    importe_total numeric(10,2),
                    id_moneda INTEGER,
                    nro_documento bigint,
                    nro_autorizacion VARCHAR(20),
                    fecha_documento date,
                    nro_nit varchar(30),
                     importe_debe numeric(10,2),
                     importe_gasto numeric(10,2))
              )';

        v_consulta := v_consulta || ',tabla_temporal_sigma AS (
              SELECT * FROM dblink(''' || v_host || ''',
          ''select tctcomp.id_int_comprobante,
          tctcomp.id_comprobante,
          entre.comprobante_c31,
            traval.importe_haber,
  traval.importe_recurso,
          entre.fecha_entrega

          from sci.tct_comprobante tctcomp
             inner join sci.tct_transaccion tcttra on tcttra.id_comprobante = tctcomp.id_comprobante
            inner join sci.tct_cuenta cta on cta.id_cuenta=tcttra.id_cuenta and cta.tipo_cuenta=1
            inner join sci.tct_transac_valor traval on traval.id_transaccion = tcttra.id_transaccion and traval.id_moneda = 1
          inner join sci.tct_entrega_comprobante entrecom on entrecom.id_comprobante = tctcomp.id_comprobante
          inner join sci.tct_entrega entre on entre.id_entrega = entrecom.id_entrega

           ''
                   ) AS d (
                   id_int_comprobante integer,

                    id_comprobante integer,

                    comprobante_c31 VARCHAR(20),
                     importe_haber numeric(10,2),
                   importe_recurso numeric(10,2),
                    fecha_entrega date )
              )';
*/

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
      libro.nro_cheque,
      pg_pagado.id_proceso_wf,
      contra.resolucion_bancarizacion,
      pg_pagado.monto_retgar_mo,
      pg_pagado.liquido_pagable,
      pg_pagado.monto as monto_pago,
      pg_pagado.otros_descuentos,
      pg_pagado.descuento_inter_serv,
      libro.estado as estado_libro,
      libro.importe_cheque,
      doc.importe_debe,
      doc.importe_gasto,
      sigma.importe_recurso,
      sigma.importe_haber,
      contra.tipo_monto
      --libro_fk.importe_cheque as importe_cheque_fk,
      --libro_fk.nro_cheque as nro_cheque_fk
from tes.tplan_pago pg_pagado
inner join tes.tplan_pago pg_devengado on pg_devengado.id_plan_pago = pg_pagado.id_plan_pago_fk
inner join param.tplantilla plantilla  on plantilla.id_plantilla = pg_devengado.id_plantilla

left join tabla_temporal_sigma sigma on sigma.id_int_comprobante = pg_pagado.id_int_comprobante
left join tes.tts_libro_bancos libro on libro.id_int_comprobante = pg_pagado.id_int_comprobante
--left join tes.tts_libro_bancos libro_fk on libro_fk.id_libro_bancos_fk = libro.id_libro_bancos


left join tes.tcuenta_bancaria cuenta on cuenta.id_cuenta_bancaria = pg_pagado.id_cuenta_bancaria

inner join tes.tobligacion_pago obliga on obliga.id_obligacion_pago = pg_pagado.id_obligacion_pago
left join leg.tcontrato contra on contra.id_contrato = obliga.id_contrato

inner join param.tproveedor provee on provee.id_proveedor = obliga.id_proveedor

inner join tabla_temporal_documentos doc on doc.id_int_comprobante = pg_devengado.id_int_comprobante


where pg_pagado.estado=''pagado'' and pg_devengado.estado = ''devengado''
and (libro.tipo=''cheque'' or  pg_pagado.forma_pago = ''transferencia'' or pg_pagado.forma_pago = ''cheque'')
and ( pg_pagado.forma_pago = ''transferencia'' or pg_pagado.forma_pago=''cheque'')
-- and plantilla.tipo_informe in (''lcv'',''retenciones'')
and (libro.estado in (''cobrado'',''entregado'',''anulado'') or libro.estado is null )
and ((doc.fecha_documento >= ''' || v_periodo.fecha_ini || '''::date and doc.fecha_documento <=''' ||
                     v_periodo.fecha_fin || '''::date)
or (libro.fecha >= ''' || v_periodo.fecha_ini || '''::date and libro.fecha <=''' || v_periodo.fecha_fin || '''::date)
or (sigma.fecha_entrega >= ''' || v_periodo.fecha_ini || '''::date and sigma.fecha_entrega <=''' || v_periodo.fecha_fin
                     || '''::date)
)
and (
(doc.importe_total >= 50000)
 or (contra.bancarizacion = ''si'' and contra.tipo_monto=''cerrado'')
  or (contra.bancarizacion=''si'' and contra.tipo_monto=''abierto'' and doc.importe_total >= 50000)
  )
 ORDER BY doc.fecha_documento,doc.nro_documento ,libro.estado asc ';


        FOR v_record_plan_pago_pxp IN EXECUTE v_consulta LOOP


          --RAISE EXCEPTION '%',v_record_plan_pago_pxp.importe_haber;
          v_monto_acumulado = 0;
          v_saldo = 0;
          v_monto_contrato = 0;

          --vemos si es transferencia o cheque dependiendo de eso entra la feccha
          IF v_record_plan_pago_pxp.forma_pago = 'cheque'
          THEN
            v_fecha_libro_o_entrega = v_record_plan_pago_pxp.fecha_pago;
            v_nro_cheque_o_sigma = v_record_plan_pago_pxp.nro_cheque;
            --casos que son pagados tipo transferencia pero se paga despues en otra ciudad
            IF v_record_plan_pago_pxp.fecha_pago IS NULL
            THEN
              v_fecha_libro_o_entrega = v_record_plan_pago_pxp.fecha_entrega;


            END IF;
          ELSIF v_record_plan_pago_pxp.forma_pago = 'transferencia'
            THEN
              v_fecha_libro_o_entrega = v_record_plan_pago_pxp.fecha_entrega;
              v_nro_cheque_o_sigma = v_record_plan_pago_pxp.comprobante_c31;
          END IF;

          --si cualquiera de las fecha es mayor al periodo seleccinado no se registra
          --si las dos fechas son menores a la del periodo entonces se registra

          --si la fecha del documento o la del libro o de bancos estan dentro del periodo seleccionado
          --si es la resolucion antigua entonces solo importa la fecha del pago que este dentro de este periodo
          IF ((v_record_plan_pago_pxp.fecha_documento :: DATE <= v_periodo.fecha_fin :: DATE
               AND v_fecha_libro_o_entrega :: DATE <= v_periodo.fecha_fin :: DATE)

              OR (v_record_plan_pago_pxp.resolucion_bancarizacion = '10-0011-11'
                  AND v_fecha_libro_o_entrega :: DATE >= v_periodo.fecha_ini :: DATE
                  AND v_fecha_libro_o_entrega :: DATE <= v_periodo.fecha_fin :: DATE
              )

          )
          THEN


            --raise exception '%',v_record_plan_pago_pxp;

            IF EXISTS(SELECT 0
                      FROM conta.tbanca_compra_venta
                      WHERE id_documento = v_record_plan_pago_pxp.id_documento)
            THEN
            --existe ya un registro con esta documentacion asi que no se registra


            ELSE


              v_rec = param.f_get_periodo_gestion(v_record_plan_pago_pxp.fecha_documento);
              v_rec2 = param.f_get_periodo_gestion(v_fecha_libro_o_entrega);

              --todo aca validar de mejor forma
              --me fijo si la fecha de factura es igual a la del pago
              IF v_rec.po_id_periodo < v_rec2.po_id_periodo --fecha factura es antes que la del pago
              THEN
                --es credito
                v_modalidad_de_transaccion = 2;
              ELSE
                --es al contado
                v_modalidad_de_transaccion = 1;
              END IF;

              --vemos si es factura o retencion
              IF v_record_plan_pago_pxp.tipo_informe = 'lcv'
              THEN
                v_tipo_transaccion = 1;
              ELSIF v_record_plan_pago_pxp.tipo_informe = 'retenciones'
                THEN
                  v_tipo_transaccion = 2;
              END IF;

              --vemos el tipo de documento de pago segun la cuenta bancaria
              IF v_record_plan_pago_pxp.id_cuenta_bancaria_plan_pago = 61
              THEN
                v_tipo_documento_pago = 4; --es transeferencia de fondos
              ELSE
                v_tipo_documento_pago = 1; --es cheque de cualquier naturaleza
              END IF;

              --vemos si no tiene contrato se agrega la resolucion segun la fecha documento
              IF v_record_plan_pago_pxp.id_contrato IS NULL
              THEN

                --si la fecha es mayor al 1 de junio del 2015 entonces entra a la nueva resolucion
                /*if (v_record_plan_pago_pxp.fecha_documento::date >= '2015-07-01'::DATE ) THEN
                  --entra a la nueva resolucion
                  v_resolucion = '10-0017-15';

                  ELSE
                  --entra a la antigua resolucion
                  v_resolucion = '10-0011-11';
                END IF;*/

                v_resolucion = '10-0017-15';

              ELSE --tiene contrato


                v_resolucion = v_record_plan_pago_pxp.resolucion_bancarizacion;


              END IF;

              --sacamos el nit de la entidad financiera segun el contrato
              SELECT inst.doc_id
              INTO v_doc_id
              FROM tes.tcuenta_bancaria ctaban
                INNER JOIN param.tinstitucion inst ON inst.id_institucion = ctaban.id_institucion
              WHERE ctaban.id_cuenta_bancaria = v_record_plan_pago_pxp.id_cuenta_bancaria;

              --obtenemos el numero de traminte concatenado con la cuota
              v_numero_tramite_y_cuota =
              v_record_plan_pago_pxp.num_tramite :: VARCHAR || '(' || v_record_plan_pago_pxp.nro_cuota :: VARCHAR ||
              ')';

              --todo


              IF (v_record_plan_pago_pxp.importe_cheque IS NULL OR v_record_plan_pago_pxp.importe_cheque <= 0)
              THEN


                --v_monto_pagado = v_record_plan_pago_pxp.importe_total;
                v_monto_pagado = v_record_plan_pago_pxp.importe_haber;
              ELSE
                v_monto_pagado = v_record_plan_pago_pxp.importe_cheque;

              END IF;


              IF (v_record_plan_pago_pxp.estado_libro = 'depositado')
              THEN
                v_monto_pagado = v_record_plan_pago_pxp.importe_cheque_fk;
                v_nro_cheque_o_sigma = v_record_plan_pago_pxp.nro_cheque_fk;

              END IF;

              --v_monto_pagado = v_record_plan_pago_pxp.importe_total;
              --monto_pago pago total del plan de pago
              --monto_retgar_mo retencion total del monto del plan de pago
              --importe_total es el importe del documento factura


              --validamos que el intercambio de servicio no sea por el 100% por que si no no se debe bancarizar
              IF ((v_record_plan_pago_pxp.monto_pago - v_record_plan_pago_pxp.descuento_inter_serv) > 0)
              THEN


              --debemos sacar que porcentaje tiene esa retencion con el monto en el plan de pago
              v_porciento_en_relacion_a_monto_total_plan_pago = (v_record_plan_pago_pxp.monto_retgar_mo * 100) /
                                                                (v_record_plan_pago_pxp.monto_pago -
                                                                 v_record_plan_pago_pxp.descuento_inter_serv);

              --obtenemos la retencion
              v_retencion_cuota =
              (v_record_plan_pago_pxp.importe_total * v_porciento_en_relacion_a_monto_total_plan_pago) / 100;

              --obtenemos el porcentaje correspondiente de multa
              v_multa_porcentaje = (v_record_plan_pago_pxp.otros_descuentos * 100) / v_record_plan_pago_pxp.monto_pago;
              v_multa_cuota = (v_record_plan_pago_pxp.importe_total * v_multa_porcentaje) / 100;

              --obtenemos el porcentaje correspondiente para el intercambio de servicios
              v_intercambio_de_servicio_porcentaje = (v_record_plan_pago_pxp.descuento_inter_serv * 100) /
                                                     v_record_plan_pago_pxp.monto_pago;
              v_intercambio_de_servicio_cuota =
              (v_record_plan_pago_pxp.importe_total * v_intercambio_de_servicio_porcentaje) / 100;


              v_monto_pagado_para_acumular = v_record_plan_pago_pxp.importe_total;

              v_monto_pagado = v_record_plan_pago_pxp.importe_total;

              --obtenemos el monto pagado de la factura menos la retencion
              v_monto_pagado = v_monto_pagado - v_retencion_cuota;
              --v_monto_pagado = v_monto_pagado - v_record_plan_pago_pxp.descuento_inter_serv;


              --v_monto_pagado_para_acumular = v_monto_pagado;

              IF (v_record_plan_pago_pxp.id_documento = 245471)
              THEN
              --RAISE EXCEPTION '%',v_retencion_cuota;
              END IF;

              --si tiene retencion
              /* if (v_record_plan_pago_pxp.monto_retgar_mo > 0) THEN

                 v_monto_pagado = v_record_plan_pago_pxp.importe_total;
                 --obtenemos el monto pagado de la factura menos la retencion
                 v_monto_pagado = v_monto_pagado - v_retencion_cuota;
                 v_monto_pagado_para_acumular = v_monto_pagado;


                 ELSE
                 v_monto_pagado_para_acumular = v_record_plan_pago_pxp.importe_total;

               END IF;*/

              /*
              --si tiene multa
              if (v_record_plan_pago_pxp.otros_descuentos > 0) THEN

                 --RAISE EXCEPTION '%',v_retencion_cuota;

                --obtenemos el monto pagado de la factura menos la retencion
                v_monto_pagado = v_monto_pagado - v_multa_cuota;


              END IF;


              --si tiene intercambio de servicios
              if (v_record_plan_pago_pxp.descuento_inter_serv > 0) THEN

                 --RAISE EXCEPTION '%',v_retencion_cuota;

                --obtenemos el monto pagado de la factura menos la retencion
                v_monto_pagado = v_monto_pagado - v_intercambio_de_servicio_cuota;


              END IF;*/



              v_monto_acumulado = v_monto_pagado;
              v_saldo = 0;
              --si es bancarizacion por contrato tomamos en cuanta el saldo y el monto acumulado
              IF v_record_plan_pago_pxp.bancarizacion = 'si' AND v_record_plan_pago_pxp.tipo_monto = 'cerrado'
              THEN

                /*el monto acumulado se por primera vez se debe ingresar manualmente en el campo
                ya que asi podremos tomar encuenta datos anteriores
                ya que el sistema no cuenta con datos anteriores al 2015.*/

                v_monto_contrato = v_record_plan_pago_pxp.monto_contrato;

                --obtenemos el ultimo registro bancarizado del id_contrato
                SELECT monto_acumulado
                INTO v_monto_acumulado
                FROM conta.tbanca_compra_venta
                WHERE id_contrato = v_record_plan_pago_pxp.id_contrato AND lista_negra = 'no'
                ORDER BY id_banca_compra_venta DESC
                LIMIT 1;

                IF (v_monto_acumulado IS NULL)
                THEN
                  v_monto_acumulado = 0;
                END IF;


                v_monto_acumulado = v_monto_acumulado + v_monto_pagado;


                v_saldo = v_monto_contrato - v_monto_acumulado;

                --si se tiene contrato entonces se tiene la resolucion


              END IF;

              IF v_record_plan_pago_pxp.bancarizacion = 'si' AND v_record_plan_pago_pxp.tipo_monto = 'abierto'
              THEN


                select monto_acumulado INTO v_monto_acumulado from conta.tbanca_compra_venta where id_documento = v_record_plan_pago_pxp.id_documento;

                IF v_monto_acumulado is NULL THEN

                  v_monto_acumulado = 0;
                END IF;
                v_monto_acumulado = v_monto_acumulado + v_monto_pagado;
                v_saldo = v_retencion_cuota;


              END IF;


              IF (v_record_plan_pago_pxp.importe_total != v_record_plan_pago_pxp.descuento_inter_serv)
              THEN


                --Sentencia de la insercion
                INSERT INTO conta.tbanca_compra_venta (
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
                  monto_pagado, --este es el liquido pagable
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
                  id_depto_conta,
                  id_proceso_wf,
                  resolucion,
                  retencion_cuota,
                  multa_cuota,
                  estado_libro,
                  registro,
                  tipo_bancarizacion
                ) VALUES (
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
                  v_record_plan_pago_pxp.nro_autorizacion :: NUMERIC,
                  v_monto_pagado,

                  v_fecha_libro_o_entrega,
                  v_record_plan_pago_pxp.razon_social,
                  'Compras',
                  v_nro_cheque_o_sigma,
                  v_record_plan_pago_pxp.numero_contrato,
                  v_doc_id :: NUMERIC,
                  v_parametros.id_periodo,
                  now(),
                  v_parametros._nombre_usuario_ai,
                  p_id_usuario,
                  v_parametros._id_usuario_ai,
                  NULL,
                  NULL,
                  v_record_plan_pago_pxp.id_contrato,
                  v_record_plan_pago_pxp.id_proveedor,
                  v_record_plan_pago_pxp.id_cuenta_bancaria_plan_pago,
                  v_record_plan_pago_pxp.id_documento,
                  v_periodo.periodo,
                  v_record_plan_pago_pxp.nro_cuota,
                  v_numero_tramite_y_cuota,
                  v_saldo,
                  v_parametros.id_depto_conta,
                  v_record_plan_pago_pxp.id_proceso_wf,
                  v_resolucion,
                  v_retencion_cuota,
                  v_multa_cuota,
                  v_record_plan_pago_pxp.estado_libro,
                  'automatico',
                  'normal'


                );
              END IF;

              END IF;
            END IF;

          END IF;


        END LOOP;

        --Definicion de la respuesta
        v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'bancarizacion insertado para el periodo (a)');
        v_resp = pxp.f_agrega_clave(v_resp, 'id_periodo', v_parametros.id_periodo :: VARCHAR);

        --Devuelve la respuesta
        RETURN v_resp;

      END;


      /*********************************
     #TRANSACCION: 'CONTA_BANCA_ADDLN'
     #DESCRIPCION:	agrega a una lista negra
     #AUTOR:		admin
     #FECHA:		31-05-2016 14:36:46
    ***********************************/

  ELSIF (p_transaccion='CONTA_BANCA_ADDLN')
    THEN

      BEGIN
        --Sentencia de la eliminacion


        --verificamos la gestion si esta abierta
        select banges.estado into v_estado_gestion from conta.tbancarizacion_gestion banges
          INNER JOIN param.tgestion ges on ges.id_gestion = banges.id_gestion
          inner join param.tperiodo per on per.id_gestion = ges.id_gestion
        where per.id_periodo =   v_parametros.id_periodo;
        IF v_estado_gestion = 'Bloqueado' THEN
          RAISE EXCEPTION '%','GESTION BLOQUEADA';
        END IF;


        SELECT * INTO v_banca from conta.tbanca_compra_venta
          WHERE id_banca_compra_venta = v_parametros.id_banca_compra_venta;

        IF v_banca.lista_negra = 'si' THEN

          UPDATE conta.tbanca_compra_venta
        SET lista_negra   = 'no' ,
          saldo           = 0,
          monto_acumulado = 0
        WHERE id_banca_compra_venta = v_parametros.id_banca_compra_venta;

          ELSE
           UPDATE conta.tbanca_compra_venta
        SET lista_negra   = 'si',
          saldo           = 0,
          monto_acumulado = 0
        WHERE id_banca_compra_venta = v_parametros.id_banca_compra_venta;


        END IF;


        --Definicion de la respuesta
        v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'bancarizacion agregado a la lista negra(a)');
        --v_resp = pxp.f_agrega_clave(v_resp,'id_banca_compra_venta',v_parametros.id_banca_compra_venta::varchar);

        --Devuelve la respuesta
        RETURN v_resp;

      END;


      /*********************************
    #TRANSACCION: 'CONTA_BANCA_INSRET'
    #DESCRIPCION:	agrega las retenciones segun su periodo seleccionado
    #AUTOR:		admin
    #FECHA:		31-05-2016 14:36:46
   ***********************************/

  ELSIF (p_transaccion='CONTA_BANCA_INSRET')
    THEN

      BEGIN
        --Sentencia de la eliminacion

        --verificamos la gestion si esta abierta
        select banges.estado into v_estado_gestion from conta.tbancarizacion_gestion banges
          INNER JOIN param.tgestion ges on ges.id_gestion = banges.id_gestion
          inner join param.tperiodo per on per.id_gestion = ges.id_gestion
        where per.id_periodo =   v_parametros.id_periodo;
        IF v_estado_gestion = 'Bloqueado' THEN
          RAISE EXCEPTION '%','GESTION BLOQUEADA';
        END IF;

        SELECT
          fecha_ini,
          fecha_fin,
          param.f_literal_periodo(id_periodo) AS periodo
        INTO v_periodo
        FROM param.tperiodo
        WHERE id_periodo = v_parametros.id_periodo;


        IF  v_parametros.numero_tramite = '' THEN





           --select pxp.list( '''' ||obliga.num_tramite|| '''')
            SELECT pxp.list(obliga.id_obligacion_pago :: VARCHAR)
            INTO v_numeros_de_tramites
            FROM tes.tplan_pago pla

              INNER JOIN tes.tobligacion_pago obliga ON obliga.id_obligacion_pago = pla.id_obligacion_pago
              LEFT JOIN tes.tts_libro_bancos libro ON libro.id_int_comprobante = pla.id_int_comprobante
            WHERE pla.tipo = 'dev_garantia'
                  AND pla.estado = 'devuelto'
                  AND pla.fecha_dev >= v_periodo.fecha_ini :: DATE AND pla.fecha_dev <= v_periodo.fecha_fin :: DATE;


        ELSE


          select id_obligacion_pago
          into v_id_obligacion_pago
            from tes.tobligacion_pago
              where num_tramite = split_part(v_parametros.numero_tramite, '(', 1);

              v_numeros_de_tramites =  '('||v_id_obligacion_pago||')';


        END IF;

          --RAISE EXCEPTION '%',v_id_obligacion_pago;



        IF v_numeros_de_tramites IS NULL
        THEN
          RAISE EXCEPTION '%', 'no existe ningun devolucion de garantias en este periodo';
        END IF;

        v_host:='dbname=dbendesis host=192.168.100.30 user=ende_pxp password=ende_pxp';

        v_consulta = conta.f_obtener_string_documento_bancarizacion(v_periodo.gestion::INTEGER);


        --creacion de tabla temporal del endesis




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
      libro.nro_cheque,
      pg_pagado.id_proceso_wf,
      contra.resolucion_bancarizacion,
      pg_pagado.monto_retgar_mo,
      pg_pagado.liquido_pagable,
      pg_pagado.monto as monto_pago,
      pg_pagado.otros_descuentos,
      pg_pagado.descuento_inter_serv,
      libro.estado as estado_libro,
      libro.importe_cheque,
      doc.importe_debe,
      doc.importe_gasto,
      sigma.importe_recurso,
      sigma.importe_haber,
      contra.tipo_monto,
      obliga.id_obligacion_pago
from tes.tplan_pago pg_pagado
inner join tes.tplan_pago pg_devengado on pg_devengado.id_plan_pago = pg_pagado.id_plan_pago_fk
inner join param.tplantilla plantilla  on plantilla.id_plantilla = pg_devengado.id_plantilla

left join tabla_temporal_sigma sigma on sigma.id_int_comprobante = pg_pagado.id_int_comprobante
left join tes.tts_libro_bancos libro on libro.id_int_comprobante = pg_pagado.id_int_comprobante
left join tes.tts_libro_bancos libro_fk on libro_fk.id_libro_bancos_fk = libro.id_libro_bancos


left join tes.tcuenta_bancaria cuenta on cuenta.id_cuenta_bancaria = pg_pagado.id_cuenta_bancaria

inner join tes.tobligacion_pago obliga on obliga.id_obligacion_pago = pg_pagado.id_obligacion_pago
left join leg.tcontrato contra on contra.id_contrato = obliga.id_contrato

inner join param.tproveedor provee on provee.id_proveedor = obliga.id_proveedor

inner join tabla_temporal_documentos doc on doc.id_int_comprobante = pg_devengado.id_int_comprobante


where pg_pagado.estado=''pagado'' and pg_devengado.estado = ''devengado''
and (libro.tipo=''cheque'' or  pg_pagado.forma_pago = ''transferencia'' or pg_pagado.forma_pago = ''cheque'')
and ( pg_pagado.forma_pago = ''transferencia'' or pg_pagado.forma_pago=''cheque'')
 and plantilla.tipo_informe in (''lcv'',''retenciones'')
and (libro.estado in (''cobrado'',''entregado'',''anulado'') or libro.estado is null )

and (
(doc.importe_total >= 50000)
 or (contra.bancarizacion = ''si'' and contra.tipo_monto=''cerrado'')
  or (contra.bancarizacion=''si'' and contra.tipo_monto=''abierto'' and doc.importe_total >= 50000)
  ) and obliga.id_obligacion_pago in (' || v_numeros_de_tramites || ')
 ORDER BY doc.fecha_documento,doc.nro_documento ,libro.estado asc ';

        --registro de retenciones RETENCIONESSSSSSSS
        FOR v_record_plan_pago_pxp IN EXECUTE v_consulta LOOP




          IF EXISTS(SELECT 0
                    FROM conta.tbanca_compra_venta
                    WHERE num_documento = v_record_plan_pago_pxp.nro_documento :: VARCHAR
                          AND autorizacion = v_record_plan_pago_pxp.nro_autorizacion :: NUMERIC
                          AND tipo_bancarizacion = 'devolucion')
          THEN

          --ya existe un pago
          ELSE

            v_multa_cuota = 0;
            SELECT
              pla.id_plan_pago,
              pla.tipo_pago,
              pla.forma_pago,
              pla.tipo,
              pla.estado,
              pla.fecha_dev,
              libro.nro_cheque
            INTO v_record_retencion_original

            FROM tes.tplan_pago pla
              LEFT JOIN tes.tts_libro_bancos libro ON libro.id_int_comprobante = pla.id_int_comprobante
            WHERE pla.tipo = 'dev_garantia'
                  AND pla.estado = 'devuelto' AND pla.id_obligacion_pago = v_record_plan_pago_pxp.id_obligacion_pago;




            IF v_record_retencion_original.forma_pago = 'cheque'
            THEN

              --si es cheque entonces ponemos el cheque con el cual se pago la retencion
              --recuperamos el numero cheque y la fecha




              v_nro_cheque_o_sigma = v_record_retencion_original.nro_cheque;
              v_fecha_libro_o_entrega = v_record_retencion_original.fecha_dev;







            ELSIF v_record_retencion_original.forma_pago = 'transferencia'
              THEN

                --si es transferencia ponemos la transferencia del pago anterior ya que cuando se paga
                --por transferencia se saca todo el monto

                v_fecha_libro_o_entrega = v_record_retencion_original.fecha_dev;
                v_nro_cheque_o_sigma = v_record_plan_pago_pxp.comprobante_c31;




            ELSE
            --RAISE EXCEPTION '%', 'esta mal la forma de pago no es ni tranferencia ni cheque';
            END IF;


            IF v_record_plan_pago_pxp.monto_retgar_mo > 0
            THEN


              v_rec = param.f_get_periodo_gestion(v_record_plan_pago_pxp.fecha_documento);

              if v_fecha_libro_o_entrega is null  THEN


                v_rec2 = param.f_get_periodo_gestion(v_periodo.fecha_fin::DATE);
                ELSE
                v_rec2 = param.f_get_periodo_gestion(v_fecha_libro_o_entrega);
              END IF;




              --todo aca validar de mejor forma
              --me fijo si la fecha de factura es igual a la del pago
              IF v_rec.po_id_periodo < v_rec2.po_id_periodo --fecha factura es antes que la del pago
              THEN
                --es credito
                v_modalidad_de_transaccion = 2;
              ELSE
                --es al contado
                v_modalidad_de_transaccion = 1;
              END IF;

              --vemos si es factura o retencion
              IF v_record_plan_pago_pxp.tipo_informe = 'lcv'
              THEN
                v_tipo_transaccion = 1;
              ELSIF v_record_plan_pago_pxp.tipo_informe = 'retenciones'
                THEN
                  v_tipo_transaccion = 2;
              END IF;

              --vemos el tipo de documento de pago segun la cuenta bancaria
              IF v_record_plan_pago_pxp.id_cuenta_bancaria_plan_pago = 61
              THEN
                v_tipo_documento_pago = 4; --es transeferencia de fondos
              ELSE
                v_tipo_documento_pago = 1; --es cheque de cualquier naturaleza
              END IF;

              --vemos si no tiene contrato se agrega la resolucion segun la fecha documento
              IF v_record_plan_pago_pxp.id_contrato IS NULL
              THEN

                --si la fecha es mayor al 1 de junio del 2015 entonces entra a la nueva resolucion
                /*if (v_record_plan_pago_pxp.fecha_documento::date >= '2015-07-01'::DATE ) THEN
                  --entra a la nueva resolucion
                  v_resolucion = '10-0017-15';

                  ELSE
                  --entra a la antigua resolucion
                  v_resolucion = '10-0011-11';
                END IF;*/

                v_resolucion = '10-0017-15';

              ELSE --tiene contrato


                v_resolucion = v_record_plan_pago_pxp.resolucion_bancarizacion;


              END IF;

              --sacamos el nit de la entidad financiera segun el contrato
              SELECT inst.doc_id
              INTO v_doc_id
              FROM tes.tcuenta_bancaria ctaban
                INNER JOIN param.tinstitucion inst ON inst.id_institucion = ctaban.id_institucion
              WHERE ctaban.id_cuenta_bancaria = v_record_plan_pago_pxp.id_cuenta_bancaria;

              --obtenemos el numero de traminte concatenado con la cuota
              v_numero_tramite_y_cuota =
              v_record_plan_pago_pxp.num_tramite :: VARCHAR || '(' || v_record_plan_pago_pxp.nro_cuota :: VARCHAR ||
              ')';

              --debemos sacar que porcentaje tiene esa retencion con el monto en el plan de pago
              v_porciento_en_relacion_a_monto_total_plan_pago = (v_record_plan_pago_pxp.monto_retgar_mo * 100) /
                                                                (v_record_plan_pago_pxp.monto_pago -
                                                                 v_record_plan_pago_pxp.descuento_inter_serv);

              --obtenemos la retencion
              v_retencion_cuota =
              (v_record_plan_pago_pxp.importe_total * v_porciento_en_relacion_a_monto_total_plan_pago)
              / 100;

              --la retencion ahora es el pago
              v_monto_pagado = v_retencion_cuota;


              v_monto_acumulado = 0;
              v_saldo = 0;
              IF v_record_plan_pago_pxp.bancarizacion = 'si' AND v_record_plan_pago_pxp.tipo_monto = 'cerrado'
              THEN

                /*el monto acumulado se por primera vez se debe ingresar manualmente en el campo
                ya que asi podremos tomar encuenta datos anteriores
                ya que el sistema no cuenta con datos anteriores al 2015.*/

                v_monto_contrato = v_record_plan_pago_pxp.monto_contrato;

                --obtenemos el ultimo registro bancarizado del id_contrato
                SELECT monto_acumulado
                INTO v_monto_acumulado
                FROM conta.tbanca_compra_venta
                WHERE id_contrato = v_record_plan_pago_pxp.id_contrato AND lista_negra = 'no'
                ORDER BY id_banca_compra_venta DESC
                LIMIT 1;

                IF (v_monto_acumulado IS NULL)
                THEN
                  v_monto_acumulado = 0;
                END IF;


                v_monto_acumulado = v_monto_acumulado + v_monto_pagado;


                v_saldo = v_monto_contrato - v_monto_acumulado;

                --si se tiene contrato entonces se tiene la resolucion


              END IF;

              IF v_record_plan_pago_pxp.bancarizacion = 'si' AND v_record_plan_pago_pxp.tipo_monto = 'abierto'
              THEN

              select monto_acumulado INTO v_monto_acumulado from conta.tbanca_compra_venta where id_documento = v_record_plan_pago_pxp.id_documento;

                IF v_monto_acumulado is NULL THEN

                  v_monto_acumulado = 0;
                END IF;

                v_monto_acumulado = v_monto_acumulado + v_monto_pagado;
                v_saldo = 0;


              END IF;


              IF (v_record_plan_pago_pxp.importe_total != v_record_plan_pago_pxp.descuento_inter_serv)
              THEN


                --Sentencia de la insercion
                INSERT INTO conta.tbanca_compra_venta (
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
                  monto_pagado, --este es el liquido pagable
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
                  id_depto_conta,
                  id_proceso_wf,
                  resolucion,
                  retencion_cuota,
                  multa_cuota,
                  estado_libro,
                  registro,
                  tipo_bancarizacion
                ) VALUES (
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
                  v_record_plan_pago_pxp.nro_autorizacion :: NUMERIC,
                  v_monto_pagado,

                  v_fecha_libro_o_entrega,
                  v_record_plan_pago_pxp.razon_social,
                  'Compras',
                  v_nro_cheque_o_sigma,
                  v_record_plan_pago_pxp.numero_contrato,
                  v_doc_id :: NUMERIC,
                  v_parametros.id_periodo,
                  now(),
                  v_parametros._nombre_usuario_ai,
                  p_id_usuario,
                  v_parametros._id_usuario_ai,
                  NULL,
                  NULL,
                  v_record_plan_pago_pxp.id_contrato,
                  v_record_plan_pago_pxp.id_proveedor,
                  v_record_plan_pago_pxp.id_cuenta_bancaria_plan_pago,
                  v_record_plan_pago_pxp.id_documento,
                  v_periodo.periodo,
                  v_record_plan_pago_pxp.nro_cuota,
                  v_numero_tramite_y_cuota,
                  v_saldo,
                  v_parametros.id_depto_conta,
                  v_record_plan_pago_pxp.id_proceso_wf,
                  v_resolucion,
                  v_retencion_cuota,
                  v_multa_cuota,
                  v_record_plan_pago_pxp.estado_libro,
                  'automatico',
                  'devolucion'


                );
              END IF;


            END IF;

          END IF;


        END LOOP;

        --Definicion de la respuesta
        v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'bancarizacion agregado a la lista negra(a)');
        --v_resp = pxp.f_agrega_clave(v_resp,'id_banca_compra_venta',v_parametros.id_banca_compra_venta::varchar);

        --Devuelve la respuesta
        RETURN v_resp;

      END;




      /*********************************
       #TRANSACCION: 'CONTA_BANCA_CLON'
       #DESCRIPCION:	clona de registros
       #AUTOR:		admin
       #FECHA:		11-09-2015 14:36:46
      ***********************************/

  ELSIF (p_transaccion='CONTA_BANCA_CLON')
    THEN

      BEGIN


        --Sentencia de la eliminacion

        SELECT *
        INTO v_banca
        FROM conta.tbanca_compra_venta
        WHERE id_banca_compra_venta = v_parametros.id_banca_compra_venta;


        IF v_banca.revisado = 'si' THEN
          RAISE EXCEPTION '%','NO SE PUEDE CLONAR CUANDO ESTA REVISADO ';
        END IF;


        --verificamos la gestion si esta abierta
        select banges.estado into v_estado_gestion from conta.tbancarizacion_gestion banges
          INNER JOIN param.tgestion ges on ges.id_gestion = banges.id_gestion
          inner join param.tperiodo per on per.id_gestion = ges.id_gestion
        where per.id_periodo =   v_banca.id_periodo;
        IF v_estado_gestion = 'Bloqueado' THEN
          RAISE EXCEPTION '%','GESTION BLOQUEADA';
        END IF;



        INSERT INTO conta.tbanca_compra_venta (id_usuario_reg,
                                               id_usuario_mod,
                                               fecha_reg,
                                               fecha_mod,
                                               estado_reg,
                                               id_usuario_ai,
                                               usuario_ai,

                                               tipo,
                                               modalidad_transaccion,
                                               fecha_documento,
                                               tipo_transaccion,
                                               nit_ci,
                                               razon,
                                               num_documento,
                                               num_contrato,
                                               importe_documento,
                                               autorizacion,
                                               num_cuenta_pago,
                                               monto_pagado,
                                               monto_acumulado,
                                               nit_entidad,
                                               num_documento_pago,
                                               tipo_documento_pago,
                                               fecha_de_pago,
                                               id_depto_conta,
                                               id_periodo,
                                               revisado,
                                               id_proveedor,
                                               id_contrato,
                                               id_cuenta_bancaria,
                                               id_documento,
                                               periodo_servicio,
                                               numero_cuota,
                                               saldo,
                                               resolucion,
                                               tramite_cuota,
                                               id_proceso_wf,
                                               retencion_cuota,
                                               multa_cuota,
                                               estado_libro,
                                               lista_negra,
                                               registro,
                                               tipo_bancarizacion
        )




        VALUES
          (
            p_id_usuario,
            v_banca.id_usuario_mod,
            now(),
            v_banca.fecha_mod,
            v_banca.estado_reg,
            v_parametros._id_usuario_ai,
            v_parametros._nombre_usuario_ai,

            v_banca.tipo,
            v_banca.modalidad_transaccion,
            v_banca.fecha_documento,
            v_banca.tipo_transaccion,
            v_banca.nit_ci,
            v_banca.razon,
            v_banca.num_documento,
            v_banca.num_contrato,
            v_banca.importe_documento,
            v_banca.autorizacion,
            v_banca.num_cuenta_pago,
            v_banca.monto_pagado,
            v_banca.monto_acumulado,
            v_banca.nit_entidad,
            v_banca.num_documento_pago,
            v_banca.tipo_documento_pago,
            v_banca.fecha_de_pago,
            v_banca.id_depto_conta,
            v_banca.id_periodo,
            v_banca.revisado,
            v_banca.id_proveedor,
            v_banca.id_contrato,
            v_banca.id_cuenta_bancaria,
            v_banca.id_documento,
            v_banca.periodo_servicio,
            v_banca.numero_cuota,
            v_banca.saldo,
            v_banca.resolucion,
            v_banca.tramite_cuota,
            v_banca.id_proceso_wf,
            v_banca.retencion_cuota,
            v_banca.multa_cuota,
            v_banca.estado_libro,
            v_banca.lista_negra,
            v_banca.registro,
            'clonado'
          );



        --Definicion de la respuesta
        v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'bancarizacion clonado(a)');
        v_resp = pxp.f_agrega_clave(v_resp, 'id_banca_compra_venta', v_parametros.id_banca_compra_venta :: VARCHAR);

        --Devuelve la respuesta
        RETURN v_resp;

      END;





  ELSE

    RAISE EXCEPTION 'Transaccion inexistente: %', p_transaccion;

  END IF;

  EXCEPTION

  WHEN OTHERS
    THEN
      v_resp = '';
      v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', SQLERRM);
      v_resp = pxp.f_agrega_clave(v_resp, 'codigo_error', SQLSTATE);
      v_resp = pxp.f_agrega_clave(v_resp, 'procedimientos', v_nombre_funcion);
      RAISE EXCEPTION '%', v_resp;

END;
$BODY$
LANGUAGE plpgsql VOLATILE;