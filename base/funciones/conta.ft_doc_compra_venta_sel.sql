--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_doc_compra_venta_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_doc_compra_venta_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tdoc_compra_venta'
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

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
    v_id_entidad		integer;
    v_id_deptos			varchar;
    v_registros 		record;
    v_reg_entidad		record;
    v_tabla_origen    	varchar;
    v_filtro     		varchar;
    v_tipo   			varchar;
    v_sincronizar		varchar;
    v_gestion			integer;

BEGIN

	v_nombre_funcion = 'conta.ft_doc_compra_venta_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'CONTA_DCV_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin
 	#FECHA:		18-08-2015 15:57:09
	***********************************/

	if(p_transaccion='CONTA_DCV_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
                            dcv.id_doc_compra_venta,
                            dcv.revisado,
                            dcv.movil,
                            dcv.tipo,
                            COALESCE(dcv.importe_excento,0)::numeric as importe_excento,
                            dcv.id_plantilla,
                            dcv.fecha,
                            dcv.nro_documento,
                            dcv.nit,
                            COALESCE(dcv.importe_ice,0)::numeric as importe_ice,
                            dcv.nro_autorizacion,
                            COALESCE(dcv.importe_iva,0)::numeric as importe_iva,
                            COALESCE(dcv.importe_descuento,0)::numeric as importe_descuento,
                            COALESCE(dcv.importe_doc,0)::numeric as importe_doc,
                            dcv.sw_contabilizar,
                            COALESCE(dcv.tabla_origen,''ninguno'') as tabla_origen,
                            dcv.estado,
                            dcv.id_depto_conta,
                            dcv.id_origen,
                            dcv.obs,
                            dcv.estado_reg,
                            dcv.codigo_control,
                            COALESCE(dcv.importe_it,0)::numeric as importe_it,
                            dcv.razon_social,
                            dcv.id_usuario_ai,
                            dcv.id_usuario_reg,
                            dcv.fecha_reg,
                            dcv.usuario_ai,
                            dcv.id_usuario_mod,
                            dcv.fecha_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                            dep.nombre as desc_depto,
                            pla.desc_plantilla,
                            COALESCE(dcv.importe_descuento_ley,0)::numeric as importe_descuento_ley,
                            COALESCE(dcv.importe_pago_liquido,0)::numeric as importe_pago_liquido,
                            dcv.nro_dui,
                            dcv.id_moneda,
                            mon.codigo as desc_moneda,
                            dcv.id_int_comprobante,
                            COALESCE(dcv.nro_tramite,''''),
                            COALESCE(ic.nro_cbte,dcv.id_int_comprobante::varchar)::varchar  as desc_comprobante,
                            COALESCE(dcv.importe_pendiente,0)::numeric as importe_pendiente,
                            COALESCE(dcv.importe_anticipo,0)::numeric as importe_anticipo,
                            COALESCE(dcv.importe_retgar,0)::numeric as importe_retgar,
                            COALESCE(dcv.importe_neto,0)::numeric as importe_neto,
                            aux.id_auxiliar,
                            aux.codigo_auxiliar,
                            aux.nombre_auxiliar,
                            dcv.id_tipo_doc_compra_venta,
                            (tdcv.codigo||'' - ''||tdcv.nombre)::Varchar as desc_tipo_doc_compra_venta,
                            (dcv.importe_doc -  COALESCE(dcv.importe_descuento,0) - COALESCE(dcv.importe_excento,0))     as importe_aux_neto
                            
						from conta.tdoc_compra_venta dcv
                          inner join segu.tusuario usu1 on usu1.id_usuario = dcv.id_usuario_reg
                          inner join param.tplantilla pla on pla.id_plantilla = dcv.id_plantilla
                          inner join param.tmoneda mon on mon.id_moneda = dcv.id_moneda
                          inner join conta.ttipo_doc_compra_venta tdcv on tdcv.id_tipo_doc_compra_venta = dcv.id_tipo_doc_compra_venta
                          left join conta.tauxiliar aux on aux.id_auxiliar = dcv.id_auxiliar
                          left join conta.tint_comprobante ic on ic.id_int_comprobante = dcv.id_int_comprobante                         
                          left join param.tdepto dep on dep.id_depto = dcv.id_depto_conta
                          left join segu.tusuario usu2 on usu2.id_usuario = dcv.id_usuario_mod
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;
     /*********************************
 	#TRANSACCION:  'CONTA_DCV_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin
 	#FECHA:		18-08-2015 15:57:09
	***********************************/

	elsif(p_transaccion='CONTA_DCV_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select
                              count(dcv.id_doc_compra_venta),
                              COALESCE(sum(dcv.importe_ice),0)::numeric  as total_importe_ice,
                              COALESCE(sum(dcv.importe_excento),0)::numeric  as total_importe_excento,
                              COALESCE(sum(dcv.importe_it),0)::numeric  as total_importe_it,
                              COALESCE(sum(dcv.importe_iva),0)::numeric  as total_importe_iva,
                              COALESCE(sum(dcv.importe_descuento),0)::numeric  as total_importe_descuento,
                              COALESCE(sum(dcv.importe_doc),0)::numeric  as total_importe_doc,
                              COALESCE(sum(dcv.importe_retgar),0)::numeric  as total_importe_retgar,
                              COALESCE(sum(dcv.importe_anticipo),0)::numeric  as total_importe_anticipo,
                              COALESCE(sum(dcv.importe_pendiente),0)::numeric  as tota_importe_pendiente,
                              COALESCE(sum(dcv.importe_neto),0)::numeric  as total_importe_neto,
                              COALESCE(sum(dcv.importe_descuento_ley),0)::numeric  as total_importe_descuento_ley,
                              COALESCE(sum(dcv.importe_pago_liquido),0)::numeric  as total_importe_pago_liquido,
                              COALESCE(sum(dcv.importe_doc -  COALESCE(dcv.importe_descuento,0) - COALESCE(dcv.importe_excento,0)),0) as total_importe_aux_neto

					   from conta.tdoc_compra_venta dcv
                          inner join segu.tusuario usu1 on usu1.id_usuario = dcv.id_usuario_reg
                          inner join param.tplantilla pla on pla.id_plantilla = dcv.id_plantilla
                          inner join param.tmoneda mon on mon.id_moneda = dcv.id_moneda
                          inner join conta.ttipo_doc_compra_venta tdcv on tdcv.id_tipo_doc_compra_venta = dcv.id_tipo_doc_compra_venta
                          left join conta.tauxiliar aux on aux.id_auxiliar = dcv.id_auxiliar
                          left join conta.tint_comprobante ic on ic.id_int_comprobante = dcv.id_int_comprobante                         
                          left join param.tdepto dep on dep.id_depto = dcv.id_depto_conta
                          left join segu.tusuario usu2 on usu2.id_usuario = dcv.id_usuario_mod
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
            raise notice '%', v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;   
        
        
    /*********************************
 	#TRANSACCION:  'CONTA_DCVCAJ_SEL'
 	#DESCRIPCION:	Consulta de libro de compras que considera agencias , propio de BOA
 	#AUTOR:		Gonzalos, ...  Modificado Rensi
 	#FECHA:		26-05-2017 15:57:09
	***********************************/

	elsif(p_transaccion='CONTA_DCVCAJ_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
                            dcv.id_doc_compra_venta,
                            dcv.revisado,
                            dcv.movil,
                            dcv.tipo,
                            COALESCE(dcv.importe_excento,0)::numeric as importe_excento,
                            dcv.id_plantilla,
                            dcv.fecha,
                            dcv.nro_documento,
                            dcv.nit,
                            COALESCE(dcv.importe_ice,0)::numeric as importe_ice,
                            dcv.nro_autorizacion,
                            COALESCE(dcv.importe_iva,0)::numeric as importe_iva,
                            COALESCE(dcv.importe_descuento,0)::numeric as importe_descuento,
                            COALESCE(dcv.importe_doc,0)::numeric as importe_doc,
                            dcv.sw_contabilizar,
                            COALESCE(dcv.tabla_origen,''ninguno'') as tabla_origen,
                            dcv.estado,
                            dcv.id_depto_conta,
                            dcv.id_origen,
                            dcv.obs,
                            dcv.estado_reg,
                            dcv.codigo_control,
                            COALESCE(dcv.importe_it,0)::numeric as importe_it,
                            dcv.razon_social,
                            dcv.id_usuario_ai,
                            dcv.id_usuario_reg,
                            dcv.fecha_reg,
                            dcv.usuario_ai,
                            dcv.id_usuario_mod,
                            dcv.fecha_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                            dep.nombre as desc_depto,
                            pla.desc_plantilla,
                            COALESCE(dcv.importe_descuento_ley,0)::numeric as importe_descuento_ley,
                            COALESCE(dcv.importe_pago_liquido,0)::numeric as importe_pago_liquido,
                            dcv.nro_dui,
                            dcv.id_moneda,
                            mon.codigo as desc_moneda,
                            dcv.id_int_comprobante,
                            dcv.nro_tramite,
                            COALESCE(ic.nro_cbte,dcv.id_int_comprobante::varchar)::varchar  as desc_comprobante,
                            COALESCE(dcv.importe_pendiente,0)::numeric as importe_pendiente,
                            COALESCE(dcv.importe_anticipo,0)::numeric as importe_anticipo,
                            COALESCE(dcv.importe_retgar,0)::numeric as importe_retgar,
                            COALESCE(dcv.importe_neto,0)::numeric as importe_neto,
                            aux.id_auxiliar,
                            aux.codigo_auxiliar,
                            aux.nombre_auxiliar,
                            dcv.id_tipo_doc_compra_venta,
                            (tdcv.codigo||'' - ''||tdcv.nombre)::Varchar as desc_tipo_doc_compra_venta,
                            (dcv.importe_doc -  COALESCE(dcv.importe_descuento,0) - COALESCE(dcv.importe_excento,0))     as importe_aux_neto,
                            dcv.estacion,
                            dcv.id_punto_venta,
                            (ob.nombre ||'' - ''|| upper(ob.tipo_agencia))::Varchar as nombre,
                            dcv.id_agencia,
                            ob.codigo_noiata

						from conta.tdoc_compra_venta dcv
                          inner join segu.tusuario usu1 on usu1.id_usuario = dcv.id_usuario_reg
                          inner join param.tplantilla pla on pla.id_plantilla = dcv.id_plantilla
                          inner join param.tmoneda mon on mon.id_moneda = dcv.id_moneda
                          inner join conta.ttipo_doc_compra_venta tdcv on tdcv.id_tipo_doc_compra_venta = dcv.id_tipo_doc_compra_venta
                          left join conta.tauxiliar aux on aux.id_auxiliar = dcv.id_auxiliar
                          left join conta.tint_comprobante ic on ic.id_int_comprobante = dcv.id_int_comprobante
                          left join obingresos.tagencia ob on ob.id_agencia = dcv.id_agencia
                          left join param.tdepto dep on dep.id_depto = dcv.id_depto_conta
                          left join segu.tusuario usu2 on usu2.id_usuario = dcv.id_usuario_mod
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;  
        
     /*********************************
 	#TRANSACCION:  'CONTA_DCVCAJ_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin
 	#FECHA:		18-08-2015 15:57:09
	***********************************/

	elsif(p_transaccion='CONTA_DCVCAJ_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select
                              count(dcv.id_doc_compra_venta),
                              COALESCE(sum(dcv.importe_ice),0)::numeric  as total_importe_ice,
                              COALESCE(sum(dcv.importe_excento),0)::numeric  as total_importe_excento,
                              COALESCE(sum(dcv.importe_it),0)::numeric  as total_importe_it,
                              COALESCE(sum(dcv.importe_iva),0)::numeric  as total_importe_iva,
                              COALESCE(sum(dcv.importe_descuento),0)::numeric  as total_importe_descuento,
                              COALESCE(sum(dcv.importe_doc),0)::numeric  as total_importe_doc,
                              COALESCE(sum(dcv.importe_retgar),0)::numeric  as total_importe_retgar,
                              COALESCE(sum(dcv.importe_anticipo),0)::numeric  as total_importe_anticipo,
                              COALESCE(sum(dcv.importe_pendiente),0)::numeric  as tota_importe_pendiente,
                              COALESCE(sum(dcv.importe_neto),0)::numeric  as total_importe_neto,
                              COALESCE(sum(dcv.importe_descuento_ley),0)::numeric  as total_importe_descuento_ley,
                              COALESCE(sum(dcv.importe_pago_liquido),0)::numeric  as total_importe_pago_liquido,
                              COALESCE(sum(dcv.importe_doc -  COALESCE(dcv.importe_descuento,0) - COALESCE(dcv.importe_excento,0)),0) as total_importe_aux_neto

					  from conta.tdoc_compra_venta dcv
                          inner join segu.tusuario usu1 on usu1.id_usuario = dcv.id_usuario_reg
                          inner join param.tplantilla pla on pla.id_plantilla = dcv.id_plantilla
                          inner join param.tmoneda mon on mon.id_moneda = dcv.id_moneda
                          inner join conta.ttipo_doc_compra_venta tdcv on tdcv.id_tipo_doc_compra_venta = dcv.id_tipo_doc_compra_venta
                          left join conta.tauxiliar aux on aux.id_auxiliar = dcv.id_auxiliar
                          left join conta.tint_comprobante ic on ic.id_int_comprobante = dcv.id_int_comprobante
                          left join obingresos.tagencia ob on ob.id_agencia = dcv.id_agencia
                          left join param.tdepto dep on dep.id_depto = dcv.id_depto_conta
                          left join segu.tusuario usu2 on usu2.id_usuario = dcv.id_usuario_mod
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
            raise notice '%', v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;        

	/*********************************
 	#TRANSACCION:  'CONTA_DCVNA_SEL'
 	#DESCRIPCION:	colulta nit y razon social a parti del nro de autorizacion
 	#AUTOR:		Rensi Arteaga Copari
 	#FECHA:		18-08-2015 15:57:09
	***********************************/

	elsif(p_transaccion='CONTA_DCVNA_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
                          DISTINCT(dcv.nro_autorizacion)::numeric,
                          dcv.nit,
                          dcv.razon_social
                          from conta.tdoc_compra_venta dcv
                        where  dcv.nro_autorizacion != '''' and dcv.nro_autorizacion like '''||COALESCE(v_parametros.nro_autorizacion,'-')||'%''';


            v_consulta:=v_consulta||'  limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;



			--Devuelve la respuesta
			return v_consulta;

		end;
    /*********************************
 	#TRANSACCION:  'CONTA_DCVNA_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin
 	#FECHA:		18-08-2015 15:57:09
	***********************************/

	elsif(p_transaccion='CONTA_DCVNA_CONT')then

		begin

            v_consulta:='select
                          count(DISTINCT(dcv.nro_autorizacion))
                        from conta.tdoc_compra_venta dcv
                        where dcv.nro_autorizacion != '''' and dcv.nro_autorizacion like '''||COALESCE(v_parametros.nro_autorizacion,'-')||'%'' ';


			--Devuelve la respuesta
			return v_consulta;

		end;

    /*********************************
 	#TRANSACCION:  'CONTA_DCVNIT_SEL'
 	#DESCRIPCION:	colulta  razon social a partir del nro de nit
 	#AUTOR:		Rensi Arteaga Copari
 	#FECHA:		18-08-2015 15:57:09
	***********************************/

	elsif(p_transaccion='CONTA_DCVNIT_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
                           DISTINCT(dcv.nit)::bigint,
                           dcv.razon_social
                          from conta.tdoc_compra_venta dcv
                          inner join param.tplantilla pla on pla.id_plantilla = dcv.id_plantilla
                        where dcv.nit != '''' and pla.tipo_informe = ''lcv'' and dcv.nit like '''||COALESCE(v_parametros.nit,'-')||'%''';


            v_consulta:=v_consulta||'  limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;



			--Devuelve la respuesta
			return v_consulta;

		end;
    /*********************************
 	#TRANSACCION:  'CONTA_DCVNIT_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin
 	#FECHA:		18-08-2015 15:57:09
	***********************************/

	elsif(p_transaccion='CONTA_DCVNIT_CONT')then

		begin

            v_consulta:='select
                          count(DISTINCT(dcv.nit))
                        from conta.tdoc_compra_venta dcv
                        where dcv.nit != '''' and dcv.nit like '''||COALESCE(v_parametros.nit,'-')||'%'' ';


			--Devuelve la respuesta
			return v_consulta;

		end;
    /*********************************
 	#TRANSACCION:  'CONTA_REPLCV_SEL'
 	#DESCRIPCION:	listado para reporte de libro de compras y ventas
 	#AUTOR:		admin
 	#FECHA:		18-08-2015 15:57:09
	***********************************/

	ELSEIF(p_transaccion='CONTA_REPLCV_SEL')then

    	begin




            select
              d.id_entidad,
              d.id_subsistema
            into
              v_registros
            from param.tdepto  d
            where  d.id_depto = v_parametros.id_depto;


            IF v_registros.id_entidad is null THEN
              raise exception 'El departamento contable no tiene definido la entidad a la que pertenece';
            END IF;

            select
              pxp.list(d.id_depto::varchar)
            into
              v_id_deptos
            from param.tdepto d
            where d.id_entidad  = v_registros.id_entidad
                  and  d.id_subsistema = v_registros.id_subsistema ;



    		--Sentencia de la consulta
			v_consulta:='SELECT
                              id_doc_compra_venta,
                              tipo,
                              fecha,
                              nit,
                              razon_social,
                              COALESCE(nro_documento,''0'')::Varchar,
                              COALESCE(nro_dui,''0'')::Varchar,
                              nro_autorizacion,
                              importe_doc,
                              total_excento,
                              sujeto_cf,
                              importe_descuento,
                              subtotal,
                              credito_fiscal,
                              importe_iva,
                              codigo_control,
                              tipo_doc,
                              id_plantilla,
                              id_moneda,
                              codigo_moneda,
                              id_periodo,
                              id_gestion,
                              periodo,
                              gestion,
                              venta_gravada_cero,
                              subtotal_venta,
                              sujeto_df,
                              importe_ice,
                              importe_excento
                        FROM
                          conta.vlcv lcv
                        where      lcv.tipo = '''||v_parametros.tipo||'''
                               and lcv.id_periodo = '||v_parametros.id_periodo||'
                               and id_depto_conta in ( '||v_id_deptos||')
                        order by fecha, id_doc_compra_venta';

			raise notice '%', v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;


    /*********************************
 	#TRANSACCION:  'CONTA_REPLCV_FRM'
 	#DESCRIPCION:	listado para reporte de libro de compras y ventas  desde formualrio, incialmente usar datos de endesis
 	#AUTOR:		admin
 	#FECHA:		18-08-2015 15:57:09
	***********************************/

	ELSEIF(p_transaccion='CONTA_REPLCV_FRM')then

    	begin


           v_sincronizar = pxp.f_get_variable_global('sincronizar');

           SELECT gestion into v_gestion
           FROM param.tgestion
           WHERE id_gestion=v_parametros.id_gestion;

           IF v_gestion < 2017  THEN
              v_tabla_origen = 'conta.tlcv_endesis';
           ELSE
              v_tabla_origen = 'conta.vlcv';
           END IF;

           IF v_parametros.filtro_sql = 'periodo'  THEN
               v_filtro =  ' (lcv.id_periodo = '||v_parametros.id_periodo||')  ';
           ELSE
               v_filtro =  ' (lcv.fecha::Date between '''||v_parametros.fecha_ini||'''::Date  and '''||v_parametros.fecha_fin||'''::date)  ';
           END IF;


          IF v_parametros.tipo_lcv = 'lcv_compras'  THEN
              v_tipo = 'compra';
          ELSE
              v_tipo = 'venta';
          END IF;

          --Sentencia de la consulta
		  v_consulta:='SELECT id_doc_compra_venta::BIGINT,
                               tipo::Varchar,
                               fecha::date,
                               nit::varchar,
                               razon_social::Varchar,
                               COALESCE(nro_documento::varchar, ''0'')::Varchar,
                               COALESCE(nro_dui::varchar, ''0'')::Varchar,
                               nro_autorizacion::Varchar,
                               importe_doc::numeric,
                               total_excento::numeric,
                               sujeto_cf::numeric,
                               importe_descuento::numeric,
                               subtotal::numeric,
                               credito_fiscal::numeric,
                               importe_iva::numeric,
                               codigo_control::varchar,
                               tipo_doc::varchar,
                               id_plantilla::integer,
                               id_moneda::integer,
                               codigo_moneda::Varchar,
                               id_periodo::integer,
                               id_gestion::integer,
                               periodo::integer,
                               gestion::integer,
                               venta_gravada_cero::numeric,
                               subtotal_venta::numeric,
                               sujeto_df::numeric,
                               importe_ice::numeric,
                               importe_excento::numeric
                        FROM '||v_tabla_origen||' lcv
                        where  lcv.tipo = '''||v_tipo||'''
                               and id_moneda = '||param.f_get_moneda_base()||'
                               and '||v_filtro||'
                        order by fecha, id_doc_compra_venta';

			raise notice '%', v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;

    /*********************************
 	#TRANSACCION:  'CONTA_REPLCV_ENDESIS_ERP'
 	#DESCRIPCION:	listado consolidado para reporte de libro de compras y ventas  desde formulario, tanto del endesis como del erp
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		18-08-2015 15:57:09
	***********************************/

	ELSEIF(p_transaccion='CONTA_REPLCV_ENDERP')then

    	begin

           IF v_parametros.filtro_sql = 'periodo'  THEN
               v_filtro =  ' (lcv.id_periodo = '||v_parametros.id_periodo||')  ';
           ELSE
               v_filtro =  ' (lcv.fecha::Date between '''||v_parametros.fecha_ini||'''::Date  and '''||v_parametros.fecha_fin||'''::date)  ';
           END IF;

           IF v_parametros.id_usuario != 0 THEN
           		v_filtro = v_filtro || ' and lcv.id_usuario_reg='||v_parametros.id_usuario||' ';
           END IF;

          IF v_parametros.tipo_lcv = 'lcv_compras' or v_parametros.tipo_lcv='endesis_erp' THEN
              v_tipo = 'compra';
          ELSE
              v_tipo = 'venta';
          END IF;

          --Sentencia de la consulta
		  v_consulta:='SELECT id_doc_compra_venta::BIGINT,
                               tipo::Varchar,
                               fecha::date,
                               nit::varchar,
                               razon_social::Varchar,
                               COALESCE(nro_documento::varchar, ''0'')::Varchar,
                               COALESCE(nro_dui::varchar, ''0'')::Varchar,
                               nro_autorizacion::Varchar,
                               importe_doc::numeric,
                               total_excento::numeric,
                               sujeto_cf::numeric,
                               importe_descuento::numeric,
                               subtotal::numeric,
                               credito_fiscal::numeric,
                               importe_iva::numeric,
                               codigo_control::varchar,
                               tipo_doc::varchar,
                               id_plantilla::integer,
                               id_moneda::integer,
                               codigo_moneda::Varchar,
                               id_periodo::integer,
                               id_gestion::integer,
                               periodo::integer,
                               gestion::integer,
                               venta_gravada_cero::numeric,
                               subtotal_venta::numeric,
                               sujeto_df::numeric,
                               importe_ice::numeric,
                               importe_excento::numeric
                        FROM conta.tlcv_endesis lcv
                        where  lcv.tipo = '''||v_tipo||'''
                               and id_moneda = '||param.f_get_moneda_base()||'
                               and '||v_filtro||'
                        UNION ALL
                        SELECT id_doc_compra_venta::BIGINT,
                               tipo::Varchar,
                               fecha::date,
                               nit::varchar,
                               razon_social::Varchar,
                               COALESCE(nro_documento::varchar, ''0'')::Varchar,
                               COALESCE(nro_dui::varchar, ''0'')::Varchar,
                               nro_autorizacion::Varchar,
                               importe_doc::numeric,
                               total_excento::numeric,
                               sujeto_cf::numeric,
                               importe_descuento::numeric,
                               subtotal::numeric,
                               credito_fiscal::numeric,
                               importe_iva::numeric,
                               codigo_control::varchar,
                               tipo_doc::varchar,
                               id_plantilla::integer,
                               id_moneda::integer,
                               codigo_moneda::Varchar,
                               id_periodo::integer,
                               id_gestion::integer,
                               periodo::integer,
                               gestion::integer,
                               venta_gravada_cero::numeric,
                               subtotal_venta::numeric,
                               sujeto_df::numeric,
                               importe_ice::numeric,
                               importe_excento::numeric
                        FROM conta.vlcv lcv
                        where  lcv.tipo = '''||v_tipo||'''
                               and id_moneda = '||param.f_get_moneda_base()||'
                               and '||v_filtro||'
                        order by fecha, id_doc_compra_venta';

			raise notice '%', v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;


    else

		raise exception 'Transaccion inexistente';

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