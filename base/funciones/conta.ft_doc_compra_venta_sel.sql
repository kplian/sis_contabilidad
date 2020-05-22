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

ISSUE		FECHA:		 					AUTOR:									 DESCRIPCION:
#1			20/08/2018						EGS					En la transaccion CONTA_DCVCBR_SEL se modifico consulta para cobros y saldos separados entre cobro comun y retencion de garantias
#2			13/08/2018						EGS					en la transaccion CONTA_DCVCBR_SEL se modifico consulta para cobros y saldos separados de anticipos
#76         28/11/2019                      EGS                 Se agrega filtro de tipo de cobro
#112	    17/04/2020					    manuel guerra	    reportes de autorizacion de pasajes y registro de pasajeros
#113         29/04/2020		     			MMV	                 Reporte Registro Ventas CC
#114      29/04/2020            manuelguerra    agregar propiedades de filtrado
#120      22/05/2020            manuelguerra    modificación de nombre de procedimiento
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
    v_filtro_ext		varchar;
    V_filtroLCV         varchar;
    v_id_auxiliar  		integer;
    v_id_auxiliar_2  	integer;
    v_consulta1         varchar;


   v_bandera						varchar;
   v_bandera_rg 					varchar;
   v_bandera_ant					varchar;
   v_bandera_regularizacion			varchar;
   v_bandera_regularizacion_rg			varchar;
    v_bandera_regularizacion_ant		varchar;
        v_filtro_dpte 			varchar;

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

            v_filtro_ext = ' 0 = 0 and ';

            IF  pxp.f_existe_parametro(p_tabla, 'nombre_vista') THEN
                IF v_parametros.nombre_vista = 'DocCompraPS' THEN
                   v_filtro_ext = '  dcv.sw_pgs = ''reg''   and   ';

                   IF  p_administrador != 1 THEN
                      v_filtro_ext = v_filtro_ext || ' dcv.id_usuario_reg = '||p_id_usuario|| ' and ';
                   END IF;

                END IF;
            END IF;

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
                            (dcv.importe_doc -  COALESCE(dcv.importe_descuento,0) - COALESCE(dcv.importe_excento,0))     as importe_aux_neto,
                            fun.id_funcionario,
                            fun.desc_funcionario2::varchar,
                            ic.fecha as fecha_cbte,
                            ic.estado_reg as estado_cbte,
                            COALESCE(dcv.codigo_aplicacion,'''') as  codigo_aplicacion,
                            pla.tipo_informe,
                            dcv.id_doc_compra_venta_fk,
                            dcv.nota_debito_agencia

						from conta.tdoc_compra_venta dcv
                          inner join segu.tusuario usu1 on usu1.id_usuario = dcv.id_usuario_reg
                          inner join param.tplantilla pla on pla.id_plantilla = dcv.id_plantilla
                          inner join param.tmoneda mon on mon.id_moneda = dcv.id_moneda
                          inner join conta.ttipo_doc_compra_venta tdcv on tdcv.id_tipo_doc_compra_venta = dcv.id_tipo_doc_compra_venta
                          left join conta.tauxiliar aux on aux.id_auxiliar = dcv.id_auxiliar
                          left join conta.tint_comprobante ic on ic.id_int_comprobante = dcv.id_int_comprobante
                          left join param.tdepto dep on dep.id_depto = dcv.id_depto_conta
                          left join segu.tusuario usu2 on usu2.id_usuario = dcv.id_usuario_mod
                          left join orga.vfuncionario fun on fun.id_funcionario = dcv.id_funcionario
				        where  '||v_filtro_ext;

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
            raise notice '%',v_consulta;
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

            v_filtro_ext = ' 0 = 0 and ';

            IF  pxp.f_existe_parametro(p_tabla,'nombre_vista') THEN
              IF v_parametros.nombre_vista = 'DocCompraPS' THEN
                 v_filtro_ext = '  dcv.sw_pgs = ''reg''   and   ';
                 IF  p_administrador != 1 THEN
                    v_filtro_ext = v_filtro_ext || ' dcv.id_usuario_reg = '||p_id_usuario|| ' and ';
                 END IF;
              END IF;
            END IF;


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
                          left join orga.vfuncionario fun on fun.id_funcionario = dcv.id_funcionario
				        where  '||v_filtro_ext;

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
                          DISTINCT(dcv.nro_autorizacion)::varchar,
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
                              importe_excento,
                              lcv.nro_cbte,
                              lcv.tipo_cambio
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
 	#AUTOR:		Juan
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

          --------------------filtro comprobante , nro nit y nro autorizacion para compras y ventas
          V_filtroLCV :='';
          if v_parametros.nro_comprobante !='' then
              V_filtroLCV :=  ' and  (lcv.nro_cbte like ''%'||v_parametros.nro_comprobante||'%'' or lcv.id_int_comprobante::varchar = '' '||v_parametros.nro_comprobante||' '' '||')';
          end if;
          if v_parametros.nro_nit !='' then
              V_filtroLCV := ' and  lcv.nit like ''%'||v_parametros.nro_nit||'%'' ';
          end if;
          if v_parametros.nro_autorizacion !='' then
              V_filtroLCV := ' and  lcv.nro_autorizacion like ''%'||v_parametros.nro_autorizacion||'%'' ';
          end if;
          ----------------------fin filtro ---------------------------------
          IF v_parametros.tipo_lcv = 'lcv_compras'  THEN
              v_tipo = 'compra';
              V_filtroLCV := V_filtroLCV ||'and lcv.nro_cbte is not null  order by fecha asc';
          ELSE
              v_tipo = 'venta';
              V_filtroLCV := V_filtroLCV ||'and (lcv.nro_cbte is not null or lcv.nombre=''ANULADA'')  order by nro_documento,fecha asc';

          END IF;

          v_filtro :=v_filtro||' and lcv.tipo_informe=''lcv'' ';

          --Sentencia de la consulta
		  v_consulta:='SELECT id_doc_compra_venta::BIGINT,
                               lcv.tipo::Varchar,
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
                               importe_excento::numeric,
                               lcv.nro_cbte,
                               lcv.tipo_cambio,
                               lcv.id_int_comprobante,
                               (SELECT usu1.cuenta FROM segu.tusuario usu1 WHERE usu1.id_usuario=LCV.id_usuario_comprobante) cuenta
                        FROM '||v_tabla_origen||' lcv
                        join segu.tusuario usu on usu.id_usuario=lcv.id_usuario_reg
                        where  lcv.tipo = '''||v_tipo||'''

                               and '||v_filtro||V_filtroLCV;


			raise notice '%', v_consulta;
            --RAISE EXCEPTION 'iii %',v_consulta;
			--Devuelve la respuesta
            --RAISE EXCEPTION 'Error j %',v_filtro||V_filtroLCV;
            --RAISE EXCEPTION 'Error j %',v_consulta;
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

			raise notice 'edison = %', v_consulta;

			--Devuelve la respuesta
			return v_consulta;

		end;

     /*********************************
 	#TRANSACCION:  'COMP_DIARIO_MAYOR'
 	#DESCRIPCION:	Comparacion de
 	#AUTOR:		admin
 	#FECHA:		18-08-2015 15:57:09
	***********************************/

	ELSEIF(p_transaccion='COMP_DIARIO_MAYOR')then

    	begin

        v_consulta1 ='';
        v_consulta1 = 'create temp table vlibro_compras_temporal(
                       -- id_libro_compra_temporal serial,
                        nro_cbte varchar,
                        credito_fiscal NUMERIC,
                        id_int_comprobante integer
                        ) on commit drop';
        execute(v_consulta1);

        v_consulta1 ='';
        v_consulta1 = 'create temp table vlibro_mayor_iva_credito_fiscal(
                        --id_libro_mayor_iva_credito_temporal serial,
                        nro_cbte varchar,
                        importe_debe_mb NUMERIC,
                        id_int_comprobante integer
                        ) on commit drop';
        execute(v_consulta1);

        v_consulta1 ='';
        v_consulta1 ='INSERT INTO vlibro_compras_temporal
                      (SELECT
                      COALESCE(lcv.nro_cbte,'''')::VARCHAR as nro_cbte,
                      COALESCE(lcv.credito_fiscal,0)::NUMERIC as credito_fiscal,
                      lcv.id_int_comprobante::integer
                      FROM conta.vlibro_compras lcv where  lcv.id_periodo ='||v_parametros.id_periodo||' AND lcv.nro_cbte is not null)';
        execute(v_consulta1);

        v_consulta1 ='';
        v_consulta1 ='INSERT INTO vlibro_mayor_iva_credito_fiscal
                       (SELECT
                        transa.nro_cbte::VARCHAR as nro_cbte_mayor,
                        COALESCE(transa.importe_debe_mb,0)::NUMERIC as importe_debe_mb,
                        transa.id_int_comprobante
                        FROM  conta.vlibro_mayor_iva_credito_fiscal transa
                        WHERE  --transa.id_cuenta in (1864)  AND -- #46 endetr Juan el filtro ya esta aplicado en la vista (conta.vlibro_mayor_iva_credito_fiscal) 16/05/2019
                        transa.id_periodo = '||v_parametros.id_periodo||'
                        AND transa.glosa1::text NOT LIKE
                       ''%ACTUALIZACIÓN DEL SALDO%''::text)';
        execute(v_consulta1);

        v_consulta = 'select
                        transa.nro_cbte::VARCHAR as nro_cbte_mayor,
                        COALESCE(transa.importe_debe_mb,0)::NUMERIC as importe_debe_mb_mayor,
                        (round(COALESCE(lcv.credito_fiscal,0),2)-round(COALESCE(transa.importe_debe_mb,0),2))::NUMERIC  as diferencia,
                        COALESCE(lcv.nro_cbte,'''')::VARCHAR as nro_cbte_compras,
                        COALESCE(lcv.credito_fiscal,0)::NUMERIC as tota_credito_fiscal_compras,
                        transa.id_int_comprobante
                        FROM vlibro_compras_temporal lcv
                        FULL JOIN
                        vlibro_mayor_iva_credito_fiscal transa on transa.id_int_comprobante = lcv.id_int_comprobante';

			return v_consulta;

		end;

      /*********************************
 	#TRANSACCION:  'CONTA_DCVCBR_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Rensi Arteaga Copari
 	#FECHA:		04-04-2018 15:57:09
	***********************************/

	elseif(p_transaccion='CONTA_DCVCBR_SEL')then

    	begin

            v_filtro_ext = ' 0 = 0 and ';

            --recuperar el auxiliardel proveedor


            IF v_parametros.id_proveedor is null  THEN
               raise exception 'necesitamos indicar el Proveedor ';
            END IF;


            select
               pr.id_auxiliar as id_auxiliar,
               aux.id_auxiliar as id_auxiliar_2
            into
               v_id_auxiliar,
               v_id_auxiliar_2
            from param.tproveedor pr
            inner join conta.tauxiliar aux on aux.codigo_auxiliar = pr.codigo
            where pr.id_proveedor = v_parametros.id_proveedor;


            IF v_id_auxiliar is null THEN
               raise exception 'No se encontro auxiliar para el proveedor especificado';
            END IF;


            IF v_id_auxiliar != v_id_auxiliar_2 THEN
               raise exception 'Conflicto de auxliares para el proveedor, revise la  parametrización';
            END IF;


            v_filtro_ext = '  dcv.id_auxiliar = '||v_id_auxiliar::varchar||' and ';


            v_bandera = split_part(pxp.f_get_variable_global('v_cobro_comun'), ',', 1);
             v_bandera_rg = split_part(pxp.f_get_variable_global('v_cobro_retencion_garantia'), ',', 1);
			 v_bandera_regularizacion = split_part(pxp.f_get_variable_global('v_cobro_comun'), ',', 2);
             v_bandera_regularizacion_rg = split_part(pxp.f_get_variable_global('v_cobro_retencion_garantia'), ',', 2);
             v_bandera_ant = split_part(pxp.f_get_variable_global('v_cobro_anticipo'), ',', 1);
             v_bandera_regularizacion_ant = split_part(pxp.f_get_variable_global('v_cobro_anticipo'), ',', 2);
             --raise exception 'bandera %',  v_bandera;

            --solo lista las facturas q faltan cobrar segun tipo de cobro #76
            IF v_bandera = v_parametros.tipo_cobro or v_bandera_regularizacion = v_parametros.tipo_cobro  THEN --#76
                v_filtro_ext = v_filtro_ext || '  escbr.cobrado_pendiente = ''no'' and ';
            ELSIF v_bandera_rg = v_parametros.tipo_cobro or v_bandera_regularizacion_rg = v_parametros.tipo_cobro THEN --#76
                 v_filtro_ext = v_filtro_ext || ' escbr.cobrado_retgar = ''no'' and ';
            ELSEIF v_bandera_ant = v_parametros.tipo_cobro or v_bandera_regularizacion_ant = v_parametros.tipo_cobro THEN --#76
                 v_filtro_ext = v_filtro_ext || ' escbr.cobrado_anticipo = ''no'' and ';
            END IF;

            --solo listasmos docuemntos relacioandos al auxiliar del proveedor
    		--Sentencia de la consulta
			v_consulta:='
 WITH  doc_cobrado(
                                    id_doc_compra_venta,
                                    importe_mb,
                                    importe_mt
                                            )

                           as (
                                    select
                                       dcv.id_doc_compra_venta,
                                       sum(COALESCE(csd.importe_mb,0)) as importe_mb,
                                       sum(COALESCE(csd.importe_mt,0)) as importe_mt

                                    from conta.tdoc_compra_venta dcv
                                    inner join cbr.tcobro_simple_det csd on csd.id_doc_compra_venta = dcv.id_doc_compra_venta
                                   inner join cbr.tcobro_simple cs on cs.id_cobro_simple = csd.id_cobro_simple
                                    inner join cbr.ttipo_cobro_simple tcs on tcs.id_tipo_cobro_simple = cs.id_tipo_cobro_simple
                                    WHERE tcs.codigo in ('''||v_bandera||''','''|| v_bandera_regularizacion||''')
                                    group by dcv.id_doc_compra_venta
                           ),
 doc_cobrado_retgar(
                                    id_doc_compra_venta,
                                    importe_mb,
                                    importe_mt
                                            )

                           as (
                                    select
                                       dcv.id_doc_compra_venta,
                                       sum(csd.importe_mb) as importe_mb,
                                       sum(csd.importe_mt) as importe_mt

                                    from conta.tdoc_compra_venta dcv
                                    inner join cbr.tcobro_simple_det csd on csd.id_doc_compra_venta = dcv.id_doc_compra_venta
                                    left join cbr.tcobro_simple cs on cs.id_cobro_simple = csd.id_cobro_simple
                                    left join cbr.ttipo_cobro_simple tcs on tcs.id_tipo_cobro_simple = cs.id_tipo_cobro_simple
                                    WHERE tcs.codigo in ('''||v_bandera_rg||''','''||v_bandera_regularizacion_rg||''')
                                    group by dcv.id_doc_compra_venta
                           )
                           ,
 doc_cobrado_anticipo(
                                    id_doc_compra_venta,
                                    importe_mb,
                                    importe_mt
                                            )

                           as (
                                    select
                                       dcv.id_doc_compra_venta,
                                       sum(csd.importe_mb) as importe_mb,
                                       sum(csd.importe_mt) as importe_mt

                                    from conta.tdoc_compra_venta dcv
                                    inner join cbr.tcobro_simple_det csd on csd.id_doc_compra_venta = dcv.id_doc_compra_venta
                                    left join cbr.tcobro_simple cs on cs.id_cobro_simple = csd.id_cobro_simple
                                    left join cbr.ttipo_cobro_simple tcs on tcs.id_tipo_cobro_simple = cs.id_tipo_cobro_simple
                                    WHERE tcs.codigo in ('''||v_bandera_ant||''','''||v_bandera_regularizacion_ant||''')
                                    group by dcv.id_doc_compra_venta
                           ),
              esta_cobrado(
                    id_doc_compra_venta,
                    cobrado_pendiente,
                    cobrado_retgar,
                    cobrado_anticipo
            )as(
                    SELECT
                     dcv.id_doc_compra_venta,
                     case
                       when dcv.id_moneda = 1 and ( dcv.importe_pendiente - COALESCE(doc.importe_mb, 0)) = 0 then
                      ''si''
                       when dcv.id_moneda = 2 and (dcv.importe_pendiente - COALESCE(doc.importe_mt, 0))=0 then
                       ''si''
                       else ''no''
                     end as cobrado_pendiente,
                     case
                       when dcv.id_moneda = 1 and  (dcv.importe_retgar - COALESCE(docrg.importe_mb, 0)) = 0 then
                      ''si''
                       when dcv.id_moneda = 2 and  ((dcv.importe_retgar - COALESCE(docrg.importe_mt, 0)) = 0) then
                      ''si''
                       else ''no''
                     end as cobrado_retgar,
                     case
                       when dcv.id_moneda = 1 and (dcv.importe_anticipo - COALESCE(docanti.importe_mb, 0)) = 0 then
                       ''si''
                       when dcv.id_moneda = 2 and (dcv.importe_anticipo - COALESCE(docanti.importe_mt, 0)) = 0 then
                       ''si''
                       else ''no''
                     end as cobrado_anticipo

                   FROM conta.tdoc_compra_venta dcv
                   left join doc_cobrado doc on doc.id_doc_compra_venta = dcv.id_doc_compra_venta
                   left join doc_cobrado_retgar docrg on docrg.id_doc_compra_venta = dcv.id_doc_compra_venta
                   left join doc_cobrado_anticipo docanti on docanti.id_doc_compra_venta = dcv.id_doc_compra_venta


            )

            select
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
                            (dcv.importe_doc -  COALESCE(dcv.importe_descuento,0) - COALESCE(dcv.importe_excento,0))     as importe_aux_neto,
                            fun.id_funcionario,
                            fun.desc_funcionario2::varchar,
                            ic.fecha as fecha_cbte,
                            ic.estado_reg as estado_cbte,
                            COALESCE(doc.importe_mb,0) as importe_cobrado_mb,
                            COALESCE(doc.importe_mt,0) as importe_cobrado_mt,
                            COALESCE(docrg.importe_mb,0) as importe_cobrado_retgar_mb,
                            COALESCE(docrg.importe_mt,0) as importe_cobrado_retgar_mt,
 							COALESCE(docanti.importe_mb,0) as importe_cobrado_ant_mb,
                            COALESCE(docanti.importe_mt,0) as importe_cobrado_ant_mt,
                            case
                              when dcv.id_moneda  = 1  then
                                 dcv.importe_pendiente - COALESCE(doc.importe_mb,0)
                              when  dcv.id_moneda  = 2 then
                                 dcv.importe_pendiente  - COALESCE(doc.importe_mt,0)
                              else
                                 0
                            end as saldo_por_cobrar_pendiente,
                            case
                              when dcv.id_moneda  = 1  then
                                dcv.importe_retgar - COALESCE(docrg.importe_mb,0)
                              when  dcv.id_moneda  = 2 then
                                  dcv.importe_retgar  - COALESCE(docrg.importe_mt,0)
                              else
                                 0
                            end as saldo_por_cobrar_retgar,
                            case
                              when dcv.id_moneda  = 1  then
                                dcv.importe_anticipo - COALESCE(docanti.importe_mb,0)
                              when  dcv.id_moneda  = 2 then
                                  dcv.importe_anticipo  - COALESCE(docanti.importe_mt,0)
                              else
                                 0
                            end as saldo_por_cobrar_anticipo,
                              escbr.cobrado_pendiente::varchar,
                              escbr.cobrado_retgar::varchar,
                              escbr.cobrado_anticipo ::varchar
						from conta.tdoc_compra_venta dcv
                          inner join segu.tusuario usu1 on usu1.id_usuario = dcv.id_usuario_reg
                          inner join param.tplantilla pla on pla.id_plantilla = dcv.id_plantilla
                          inner join param.tmoneda mon on mon.id_moneda = dcv.id_moneda
                          inner join conta.ttipo_doc_compra_venta tdcv on tdcv.id_tipo_doc_compra_venta = dcv.id_tipo_doc_compra_venta
                          left join doc_cobrado doc on doc.id_doc_compra_venta = dcv.id_doc_compra_venta
                          left join doc_cobrado_retgar docrg on docrg.id_doc_compra_venta = dcv.id_doc_compra_venta
                          left join doc_cobrado_anticipo docanti on docanti.id_doc_compra_venta = dcv.id_doc_compra_venta
                          left join conta.tauxiliar aux on aux.id_auxiliar = dcv.id_auxiliar
                          left join conta.tint_comprobante ic on ic.id_int_comprobante = dcv.id_int_comprobante
                          left join param.tdepto dep on dep.id_depto = dcv.id_depto_conta
                          left join segu.tusuario usu2 on usu2.id_usuario = dcv.id_usuario_mod
                          left join orga.vfuncionario fun on fun.id_funcionario = dcv.id_funcionario
                          left join esta_cobrado escbr on escbr.id_doc_compra_venta = dcv.id_doc_compra_venta
				        where  pla.tipo_plantilla = ''venta'' and '||v_filtro_ext;

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            --RAISE EXCEPTION 'v_consulta %',v_consulta;
			raise notice '%', v_consulta;

			--Devuelve la respuesta
			return v_consulta;

		end;
     /*********************************
 	#TRANSACCION:  'CONTA_DCVCBR_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		rensi
 	#FECHA:		04-04-2018 15:57:09
	***********************************/

	elsif(p_transaccion='CONTA_DCVCBR_CONT')then

		begin


            v_filtro_ext = ' 0 = 0 and ';

            --recuperar el auxiliardel proveedor


            IF v_parametros.id_proveedor is null  THEN
               raise exception 'necesitamos indicar el Proveedor ';
            END IF;


            select
               pr.id_auxiliar as id_auxiliar,
               aux.id_auxiliar as id_auxiliar_2
            into
               v_id_auxiliar,
               v_id_auxiliar_2
            from param.tproveedor pr
            inner join conta.tauxiliar aux on aux.codigo_auxiliar = pr.codigo
            where pr.id_proveedor = v_parametros.id_proveedor;


            IF v_id_auxiliar is null THEN
               raise exception 'No se encontro auxiliar para el proveedor especificado';
            END IF;


            IF v_id_auxiliar != v_id_auxiliar_2 THEN
               raise exception 'Conflicto de auxliares para el proveedor, revise la  parametrización';
            END IF;


            v_filtro_ext = '  dcv.id_auxiliar = '||v_id_auxiliar::varchar||' and ';

            v_bandera = split_part(pxp.f_get_variable_global('v_cobro_comun'), ',', 1);
             v_bandera_rg = split_part(pxp.f_get_variable_global('v_cobro_retencion_garantia'), ',', 1);
			 v_bandera_regularizacion = split_part(pxp.f_get_variable_global('v_cobro_comun'), ',', 2);
             v_bandera_regularizacion_rg = split_part(pxp.f_get_variable_global('v_cobro_retencion_garantia'), ',', 2);
             v_bandera_ant = split_part(pxp.f_get_variable_global('v_cobro_anticipo'), ',', 1);
             v_bandera_regularizacion_ant = split_part(pxp.f_get_variable_global('v_cobro_anticipo'), ',', 2);
             --raise exception 'bandera %',  v_bandera;

            --solo lista las facturas q faltan cobrar segun tipo de cobro
            IF v_bandera = v_parametros.tipo_cobro or v_bandera_regularizacion = v_parametros.tipo_cobro  THEN --#76
                v_filtro_ext = v_filtro_ext || '  escbr.cobrado_pendiente = ''no'' and ';
            ELSIF v_bandera_rg = v_parametros.tipo_cobro or v_bandera_regularizacion_rg = v_parametros.tipo_cobro THEN --#76
                 v_filtro_ext = v_filtro_ext || ' escbr.cobrado_retgar = ''no'' and ';
            ELSEIF v_bandera_ant = v_parametros.tipo_cobro or v_bandera_regularizacion_ant = v_parametros.tipo_cobro THEN --#76
                 v_filtro_ext = v_filtro_ext || ' escbr.cobrado_anticipo = ''no'' and ';
            END IF;

			--Sentencia de la consulta de conteo de registros
			v_consulta:=' WITH  doc_cobrado(
                                    id_doc_compra_venta,
                                    importe_mb,
                                    importe_mt
                                            )

                           as (
                                    select
                                       dcv.id_doc_compra_venta,
                                       sum(COALESCE(csd.importe_mb,0)) as importe_mb,
                                       sum(COALESCE(csd.importe_mt,0)) as importe_mt

                                    from conta.tdoc_compra_venta dcv
                                    inner join cbr.tcobro_simple_det csd on csd.id_doc_compra_venta = dcv.id_doc_compra_venta
                                   inner join cbr.tcobro_simple cs on cs.id_cobro_simple = csd.id_cobro_simple
                                    inner join cbr.ttipo_cobro_simple tcs on tcs.id_tipo_cobro_simple = cs.id_tipo_cobro_simple
                                    WHERE tcs.codigo in ('''||v_bandera||''','''|| v_bandera_regularizacion||''')
                                    group by dcv.id_doc_compra_venta
                           ),
 doc_cobrado_retgar(
                                    id_doc_compra_venta,
                                    importe_mb,
                                    importe_mt
                                            )

                           as (
                                    select
                                       dcv.id_doc_compra_venta,
                                       sum(csd.importe_mb) as importe_mb,
                                       sum(csd.importe_mt) as importe_mt

                                    from conta.tdoc_compra_venta dcv
                                    inner join cbr.tcobro_simple_det csd on csd.id_doc_compra_venta = dcv.id_doc_compra_venta
                                    left join cbr.tcobro_simple cs on cs.id_cobro_simple = csd.id_cobro_simple
                                    left join cbr.ttipo_cobro_simple tcs on tcs.id_tipo_cobro_simple = cs.id_tipo_cobro_simple
                                    WHERE tcs.codigo in ('''||v_bandera_rg||''','''||v_bandera_regularizacion_rg||''')
                                    group by dcv.id_doc_compra_venta
                           )
                           ,
 doc_cobrado_anticipo(
                                    id_doc_compra_venta,
                                    importe_mb,
                                    importe_mt
                                            )

                           as (
                                    select
                                       dcv.id_doc_compra_venta,
                                       sum(csd.importe_mb) as importe_mb,
                                       sum(csd.importe_mt) as importe_mt

                                    from conta.tdoc_compra_venta dcv
                                    inner join cbr.tcobro_simple_det csd on csd.id_doc_compra_venta = dcv.id_doc_compra_venta
                                    left join cbr.tcobro_simple cs on cs.id_cobro_simple = csd.id_cobro_simple
                                    left join cbr.ttipo_cobro_simple tcs on tcs.id_tipo_cobro_simple = cs.id_tipo_cobro_simple
                                    WHERE tcs.codigo in ('''||v_bandera_ant||''','''||v_bandera_regularizacion_ant||''')
                                    group by dcv.id_doc_compra_venta
                           ),
              esta_cobrado(
                    id_doc_compra_venta,
                    cobrado_pendiente,
                    cobrado_retgar,
                    cobrado_anticipo
            )as(
                    SELECT
                     dcv.id_doc_compra_venta,
                     case
                       when dcv.id_moneda = 1 and ( dcv.importe_pendiente - COALESCE(doc.importe_mb, 0)) = 0 then
                      ''si''
                       when dcv.id_moneda = 2 and (dcv.importe_pendiente - COALESCE(doc.importe_mt, 0))=0 then
                       ''si''
                       else ''no''
                     end as cobrado_pendiente,
                     case
                       when dcv.id_moneda = 1 and  (dcv.importe_retgar - COALESCE(docrg.importe_mb, 0)) = 0 then
                      ''si''
                       when dcv.id_moneda = 2 and  ((dcv.importe_retgar - COALESCE(docrg.importe_mt, 0)) = 0) then
                      ''si''
                       else ''no''
                     end as cobrado_retgar,
                     case
                       when dcv.id_moneda = 1 and (dcv.importe_anticipo - COALESCE(docanti.importe_mb, 0)) = 0 then
                       ''si''
                       when dcv.id_moneda = 2 and (dcv.importe_anticipo - COALESCE(docanti.importe_mt, 0)) = 0 then
                       ''si''
                       else ''no''
                     end as cobrado_anticipo

                   FROM conta.tdoc_compra_venta dcv
                   left join doc_cobrado doc on doc.id_doc_compra_venta = dcv.id_doc_compra_venta
                   left join doc_cobrado_retgar docrg on docrg.id_doc_compra_venta = dcv.id_doc_compra_venta
                   left join doc_cobrado_anticipo docanti on docanti.id_doc_compra_venta = dcv.id_doc_compra_venta


            ) select
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
                          left join orga.vfuncionario fun on fun.id_funcionario = dcv.id_funcionario
                          left join doc_cobrado doc on doc.id_doc_compra_venta = dcv.id_doc_compra_venta
                          left join doc_cobrado_retgar docrg on docrg.id_doc_compra_venta = dcv.id_doc_compra_venta
                          left join doc_cobrado_anticipo docanti on docanti.id_doc_compra_venta = dcv.id_doc_compra_venta
                          left join esta_cobrado escbr on escbr.id_doc_compra_venta = dcv.id_doc_compra_venta

				        where   pla.tipo_plantilla = ''venta''  and '||v_filtro_ext;

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
            --raise notice '%', v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;
     /*********************************
 	#TRANSACCION:  'CONTA_CFD_SEL'
 	#DESCRIPCION:	Contrato Factura
 	#AUTOR:		MMV
 	#FECHA:		21-09-2018
	***********************************/

     elsif(p_transaccion='CONTA_CFD_SEL')then

            begin
            v_consulta:='select   dcv.id_contrato,
                                  dcv.id_doc_compra_venta,
                                  dcv.id_moneda,
                                  dcv.fecha,
                                  dcv.nro_documento,
                                  dcv.nit,
                                  dcv.nro_autorizacion,
                                  dcv.razon_social,
                                  pla.desc_plantilla,
                                  dcv.nro_dui,
                                  mon.codigo as desc_moneda,
                                  au.codigo_auxiliar,
                                  COALESCE(dcv.nro_tramite,'''')as nro_tramite,
                                  COALESCE(ic.nro_cbte,dcv.id_int_comprobante::varchar)::varchar  as desc_comprobante,
                                  COALESCE(dcv.importe_pendiente,0)::numeric as importe_pendiente,
                                  COALESCE(dcv.importe_anticipo,0)::numeric as importe_anticipo,
                                  COALESCE(dcv.importe_retgar,0)::numeric as importe_retgar,
                                  COALESCE(dcv.importe_neto,0)::numeric as importe_neto,
                                  (dcv.importe_doc -  COALESCE(dcv.importe_descuento,0) - COALESCE(dcv.importe_excento,0)) as importe_aux_neto,
                                  COALESCE(dcv.importe_iva,0)::numeric as importe_iva,
                                  COALESCE(dcv.importe_descuento,0)::numeric as importe_descuento,
                                  COALESCE(dcv.importe_doc,0)::numeric as importe_doc,
                                  COALESCE(dcv.importe_it,0)::numeric as importe_it,
                                  COALESCE(dcv.importe_descuento_ley,0)::numeric as importe_descuento_ley,
                                  COALESCE(dcv.importe_pago_liquido,0)::numeric as importe_pago_liquido
                                  from conta.tdoc_compra_venta dcv
                                  inner join param.tplantilla pla on pla.id_plantilla = dcv.id_plantilla
                                  inner join param.tmoneda mon on mon.id_moneda = dcv.id_moneda
                                  inner join conta.tauxiliar au on au.id_auxiliar = dcv.id_auxiliar
                                  left join conta.tint_comprobante ic on ic.id_int_comprobante = dcv.id_int_comprobante
                                  where ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            raise notice '%',v_consulta;

			--Devuelve la respuesta
			return v_consulta;


     end;
       /*********************************
 	#TRANSACCION:  'CONTA_CFD_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		MMV
 	#FECHA:		21-09-2018
	***********************************/

	elsif(p_transaccion='CONTA_CFD_CONT')then

		begin

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
                          inner join conta.tauxiliar au on au.id_auxiliar = dcv.id_auxiliar
                          left join conta.tint_comprobante ic on ic.id_int_comprobante = dcv.id_int_comprobante
                          left join param.tdepto dep on dep.id_depto = dcv.id_depto_conta
                          left join segu.tusuario usu2 on usu2.id_usuario = dcv.id_usuario_mod
                          where ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
            raise notice '%', v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;
      /*********************************
    #TRANSACCION:  'CONTA_CFA_SEL'
    #DESCRIPCION:	Comoobox para filtar factura por codigo de proveedor
    #AUTOR:		MMV
    #FECHA:		19-09-2018 13:16:55
    ***********************************/
    elsif(p_transaccion='CONTA_CFA_SEL')then

    begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select  dc.id_doc_compra_venta,
            					 au.codigo_auxiliar,
                        		 dc.nit,
                        		 dc.razon_social,
                                 dc.nro_autorizacion
                                 from conta.tdoc_compra_venta dc
                                 inner join conta.tauxiliar au on au.id_auxiliar = dc.id_auxiliar
                                 where dc.tipo = ''venta'' and dc.id_contrato is null and';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

       /*********************************
 	#TRANSACCION:  'CONTA_CFA_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		MMV
 	#FECHA:		21-09-2018
	***********************************/

	elsif(p_transaccion='CONTA_CFA_CONT')then

		begin

			v_consulta:='select  count(dc.id_doc_compra_venta)
                                 from conta.tdoc_compra_venta dc
                                 inner join conta.tauxiliar au on au.id_auxiliar = dc.id_auxiliar
                                 where dc.tipo = ''venta'' and ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'CONTA_LISTRAM_SEL'
 	#DESCRIPCION:	listado de tramites de vi/fa
 	#AUTOR:		manu   #112
 	#FECHA:		18-08-2015 15:57:09
	***********************************/

	elsif(p_transaccion='CONTA_LISTRAM_SEL')then

    	begin
        	v_filtro =' 0 = 0 ';
        	IF p_administrador = 1 THEN
            	v_filtro = v_filtro|| 'and 0=0';
            ELSE
            	v_filtro = v_filtro||' and cd.id_funcionario IN (select *
                                                		FROM orga.f_get_funcionarios_x_usuario_asistente(now()::date,'||p_id_usuario||') AS (id_funcionario INTEGER))';
            END IF;
    		--Sentencia de la consulta
            v_consulta:='select
                        DISTINCT(cd.nro_tramite)::varchar
                        from cd.tcuenta_doc cd
                        where 0=0 and '||v_filtro||' and';
            --#114 
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||'  limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;
    /*********************************
 	#TRANSACCION:  'CONTA_LISTRAM_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		manu  #112  #120
 	#FECHA:		18-08-2015 15:57:09
	***********************************/

	elsif(p_transaccion='CONTA_LISTRAM_CONT')then

		begin
        	v_filtro =' 0 = 0 ';
        	IF p_administrador = 1 THEN
            	v_filtro = v_filtro|| 'and 0=0';
            ELSE
            	v_filtro = v_filtro|| 'and cd.id_funcionario IN (select *
                                                		FROM orga.f_get_funcionarios_x_usuario_asistente(now()::date,'||p_id_usuario||') AS (id_funcionario INTEGER))';
            END IF;
    		--Sentencia de la consulta
			v_consulta:='select
                        COUNT(cd.nro_tramite)
                        from cd.tcuenta_doc cd
                        where 0=0 and '||v_filtro||' and';
                        --#114 
            v_consulta:=v_consulta||v_parametros.filtro;
            --Devuelve la respuesta
			return v_consulta;

		end;


        /*********************************
        #TRANSACCION:  'CONTA_REPAUT_SEL'
        #DESCRIPCION:	Reporte de DETALLE DE AUTORIZAIOCN DE PASAJES AEREOS
        #AUTOR:		mp  #112
        #FECHA:		29-08-2013 00:28:30
        ***********************************/
		elsif(p_transaccion='CONTA_REPAUT_SEL') then
        
     		BEGIN            	            	                             
            	                  
				v_consulta:='select
                            COALESCE(dcv.nota_debito_agencia,''-'')::VARCHAR,
                            COALESCE(fun.desc_funcionario2,''-'')::VARCHAR,
                            COALESCE(dcv.nro_documento,''-'')::VARCHAR,
                            COALESCE(dcv.nro_tramite,''-'')::VARCHAR,
                            COALESCE(dcv.obs,''-'')::VARCHAR,
                            COALESCE(pres.descripcion,''-'')::VARCHAR,
                            COALESCE(mon.codigo,''-'')::VARCHAR	 as desc_moneda,
                            COALESCE(dcv.importe_neto,0)::numeric as importe_doc
                            from conta.tdoc_compra_venta dcv
                            join param.tmoneda mon on mon.id_moneda = dcv.id_moneda
                            left join param.tdepto dep on dep.id_depto = dcv.id_depto_conta
                            left join orga.vfuncionario fun on fun.id_funcionario = dcv.id_funcionario
                            join conta.tdoc_concepto cop on cop.id_doc_compra_venta=dcv.id_doc_compra_venta
                            join param.tcentro_costo cc on cc.id_centro_costo=cop.id_centro_costo
                            join pre.tpresupuesto pres on pres.id_centro_costo=cc.id_centro_costo
                            where dcv.revisado = ''si'' and
                            dcv.sw_pgs = ''reg'' and
                            dcv.tipo = ''compra'' AND                            
                            '; 
                v_consulta:=v_consulta||v_parametros.filtro;
                raise notice '%',v_consulta;
				return v_consulta;
			END;
    
    	/*********************************
        #TRANSACCION:  'CONTA_REPREPAS_SEL'
        #DESCRIPCION:	Reporte de proceso de registro de Pasajes Aéreo
        #AUTOR:		mp #112
        #FECHA:		29-08-2013 00:28:30
        ***********************************/
		elsif(p_transaccion='CONTA_REPREPAS_SEL') then
        
     		BEGIN
            	--#119   	
 
				v_consulta:='SELECT
                             COALESCE(fun.desc_funcionario2,''-'') ::varchar,
                             COALESCE(dcv.nro_documento,''-'') ::varchar,
                             COALESCE(dcv.nota_debito_agencia,''-'') ::varchar, 
                             COALESCE(dcv.nro_tramite,''-'') ::varchar, 
                             COALESCE(dcv.obs,''-'') ::varchar,           
                             (
                             	select
                                CASE 
                                WHEN (ceco.codigo_cc like ''P1%'') THEN
                                  vtcc.descripcion_techo::varchar	
                                ELSE
                                  ceco.codigo_cc::varchar	
                                END as descripcion                                
                                from conta.tdoc_compra_venta dcven     
                                left join conta.tdoc_concepto cop on cop.id_doc_compra_venta=dcven.id_doc_compra_venta
                                left join param.vcentro_costo ceco on ceco.id_centro_costo=cc.id_centro_costo
                                left join param.vtipo_cc_techo vtcc on vtcc.id_tipo_cc=ceco.id_tipo_cc
                                group by ceco.codigo_cc,vtcc.descripcion_techo,ceco.id_centro_costo                             
                             ),                                                
                             COALESCE(dcv.importe_neto,0)::numeric as importe_doc,
                             COALESCE(mon.codigo,''-'') ::varchar as desc_moneda, 
                             COALESCE(ttp.nombre,''-'') ::varchar as tipago,
                             COALESCE(pro.rotulo_comercial,''-'') ::varchar as rotulo_comercial                              
                             from cd.tpago_simple_det paside
                             join conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta = paside.id_doc_compra_venta
                             join param.tmoneda mon on mon.id_moneda = dcv.id_moneda
                             left join conta.tint_comprobante ic on ic.id_int_comprobante = dcv.id_int_comprobante 
                             left join orga.vfuncionario fun on fun.id_funcionario = dcv.id_funcionario
                             left join conta.tdoc_concepto cop on cop.id_doc_compra_venta=dcv.id_doc_compra_venta
                             left join param.tcentro_costo cc on cc.id_centro_costo=cop.id_centro_costo
                             left join pre.tpresupuesto pres on pres.id_centro_costo=cc.id_centro_costo
                             join cd.tpago_simple ps on ps.id_pago_simple=paside.id_pago_simple
                             left join cd.ttipo_pago_simple ttp on ttp.id_tipo_pago_simple=ps.id_tipo_pago_simple
                             left join param.tproveedor pro on pro.id_proveedor = ps.id_proveedor                           
                             where'; 
                v_consulta:=v_consulta||v_parametros.filtro;
                raise notice '%',v_consulta;
                --raise EXCEPTION '%',v_consulta;
				return v_consulta;
			END;

			/*********************************
 	#TRANSACCION:  'CONTA_RRC_SEL' #113
 	#DESCRIPCION:	Reporte Registros Ventas
 	#AUTOR:		MMV
 	#FECHA:		21-09-2020
	***********************************/

	elsif(p_transaccion='CONTA_RRC_SEL')then

		begin

            v_filtro_dpte = '0 = 0';

            if(v_parametros.id_depto <> 0)then
            	v_filtro_dpte = 'dcv.id_depto_conta = '||v_parametros.id_depto ;
            end if;

			v_consulta:='select	dcv.id_doc_compra_venta,
                                dcv.revisado,
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
                                dcv.estado,
                                dcv.id_depto_conta,
                                dcv.id_origen,
                                dcv.obs,
                                dcv.estado_reg,
                                dcv.codigo_control,
                                COALESCE(dcv.importe_it,0)::numeric as importe_it,
                                dcv.razon_social,
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
                                (dcv.importe_doc -  COALESCE(dcv.importe_descuento,0) - COALESCE(dcv.importe_excento,0))     as importe_aux_neto,
                                fun.id_funcionario,
                                fun.desc_funcionario2::varchar as desc_funcionario,
                                ic.fecha as fecha_cbte,
                                ic.estado_reg as estado_cbte,
                                pla.tipo_informe,
                                cc.codigo_cc
                            from conta.tdoc_compra_venta dcv
                              inner join param.tplantilla pla on pla.id_plantilla = dcv.id_plantilla
                              inner join param.tmoneda mon on mon.id_moneda = dcv.id_moneda
                              inner join conta.ttipo_doc_compra_venta tdcv on tdcv.id_tipo_doc_compra_venta = dcv.id_tipo_doc_compra_venta
                              inner join conta.tdoc_concepto dco on dco.id_doc_compra_venta = dcv.id_doc_compra_venta
                              inner join param.vcentro_costo cc on cc.id_centro_costo = dco.id_centro_costo
                              left join conta.tauxiliar aux on aux.id_auxiliar = dcv.id_auxiliar
                              left join param.tdepto dep on dep.id_depto = dcv.id_depto_conta
                              left join orga.vfuncionario fun on fun.id_funcionario = dcv.id_funcionario
                              left join conta.tint_comprobante ic on ic.id_int_comprobante = dcv.id_int_comprobante
                              where dcv.id_periodo = '||v_parametros.id_periodo||'and ic.estado_reg = ''validado''
                              and '||v_filtro_dpte||' and dcv.id_plantilla = '||v_parametros.id_plantilla||
                              'and  dcv.revisado = '''||v_parametros.revisado||''' ';
			--Devuelve la respuesta
            if (v_parametros.agrupar= 'centro_costo') then
             	v_consulta:=v_consulta||'order by codigo_cc asc';
            end if;
            if (v_parametros.agrupar= 'depto') then
             	v_consulta:=v_consulta||'order by desc_depto asc';
            end if;
             if (v_parametros.agrupar= 'depto_cc') then
             	v_consulta:=v_consulta||'order by desc_depto asc ,codigo_cc asc';
            end if;
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
PARALLEL UNSAFE
COST 100;