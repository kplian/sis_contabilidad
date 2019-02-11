--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_doc_invokeiue_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_doc_invokeiue_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.ft_doc_retencion_sel'
 AUTOR: 		 (admin)
 FECHA:	        28-08-2017 10:57:09
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/

DECLARE

	v_consulta    		VARCHAR;
	v_parametros  		RECORD;
	v_nombre_funcion   	TEXT;
    v_resp				VARCHAR;
    v_sincronizar		VARCHAR;
    v_gestion			INTEGER;
    v_tabla_origen    	VARCHAR;
    v_filtro     		VARCHAR;
    v_tipo   			VARCHAR;
    v_var   			VARCHAR;
    var_1   			VARCHAR;
    var_2   			VARCHAR;
    var_3  				VARCHAR;
    var_4  				VARCHAR;    
    var_5  				VARCHAR;
    var_6  				VARCHAR;
    var_7  				VARCHAR;
    var_8  				VARCHAR;
    v_ini  				VARCHAR;
    v_fin  				VARCHAR;
BEGIN

	v_nombre_funcion = 'conta.ft_doc_invokeiue_sel';
    v_parametros = pxp.f_get_record(p_tabla);
    
    /*********************************
    #TRANSACCION:  'CONTA_INVOUE_SEL'
    #DESCRIPCION:	listado para reporte de retenciones
    #AUTOR:		admin
    #FECHA:		18-08-2015 15:57:09
    ***********************************/

	IF(p_transaccion='CONTA_INVOUE_SEL')THEN
    	BEGIN
			
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
                            dcv.id_periodo,
                            per.id_gestion      
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
                          left join param.tperiodo per on per.id_periodo =  dcv.id_periodo
                            WHERE  pla.desc_plantilla = '''||v_parametros.tipo_ret||''' and ';
			--Devuelve la respuesta 
            
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by dcv.fecha asc' ;
            --raise notice '%',v_consulta;   
      	   -- raise exception '%',v_consulta;           
			RETURN v_consulta;        	
		END;
        
    /*********************************
    #TRANSACCION:  'CONTA_VENTAS_SEL'
    #DESCRIPCION:	listado para reporte de VENTAS
    #AUTOR:		mp
    #FECHA:		18-08-2015 15:57:09
    ***********************************/

	ELSIF(p_transaccion='CONTA_VENTAS_SEL')THEN
    	BEGIN		         	
         v_consulta:='select 
                      
                      dcv.id_doc_compra_venta::integer,
                      m.id_doc_compra_venta_fk::integer,
                      dcv.id_int_comprobante::integer,                      
                      dcv.id_periodo::integer,
                      per.id_gestion::integer,                      

                      dcv.fecha::date,
                      dcv.nro_documento::varchar,
                      dcv.nit::varchar,
                      dcv.nro_autorizacion::varchar,
                      dcv.razon_social::varchar,
                      dcv.codigo_control::varchar,

                      COALESCE(dcv.importe_doc,0)::numeric as importe_doc,
                      COALESCE(dcv.importe_pago_liquido,0)::numeric as importe_pago_liquido,

                      m.fecha::date as fecha_2,
                      m.nro_documento::varchar as nro_documento_2,
                      m.nro_autorizacion::varchar as nro_autorizacion_2,
                      m.importe_doc::numeric as importe_doc_2

                      from conta.tdoc_compra_venta dcv
                      join conta.tdoc_compra_venta m on m.id_doc_compra_venta=dcv.id_doc_compra_venta_fk
                      inner join segu.tusuario usu1 on usu1.id_usuario = dcv.id_usuario_reg
                      inner join param.tplantilla pla on pla.id_plantilla = dcv.id_plantilla
                      inner join param.tmoneda mon on mon.id_moneda = dcv.id_moneda
                      inner join conta.ttipo_doc_compra_venta tdcv on tdcv.id_tipo_doc_compra_venta = dcv.id_tipo_doc_compra_venta
                      left join conta.tauxiliar aux on aux.id_auxiliar = dcv.id_auxiliar
                      left join conta.tint_comprobante ic on ic.id_int_comprobante = dcv.id_int_comprobante                         
                      left join param.tdepto dep on dep.id_depto = dcv.id_depto_conta
                      left join segu.tusuario usu2 on usu2.id_usuario = dcv.id_usuario_mod
                      left join orga.vfuncionario fun on fun.id_funcionario = dcv.id_funcionario
                      left join param.tperiodo per on per.id_periodo = dcv.id_periodo
                      where dcv.tipo=''compra'' and dcv.id_doc_compra_venta_fk is not null and';
			--Devuelve la respuesta 
            
            v_consulta:=v_consulta||v_parametros.filtro;       
            v_consulta:=v_consulta||' order by fecha asc';
           --- raise notice '%',v_consulta;   
      	  --  raise exception '%',v_consulta;           
			RETURN v_consulta;        	
		END;   
    
     /*********************************
    #TRANSACCION:  'CONTA_COMPRAS_SEL'
    #DESCRIPCION:	listado para reporte de COMPRAS
    #AUTOR:		mp
    #FECHA:		18-08-2015 15:57:09
    ***********************************/

	ELSIF(p_transaccion='CONTA_COMPRAS_SEL')THEN
    	BEGIN
			
         v_consulta:='select                       
                      dcv.id_doc_compra_venta::integer,
                      m.id_doc_compra_venta_fk::integer,
                      dcv.id_int_comprobante::integer,                      
                      dcv.id_periodo::integer,
                      per.id_gestion::integer,                      

                      dcv.fecha::date,
                      dcv.nro_documento::varchar,
                      dcv.nit::varchar,
                      dcv.nro_autorizacion::varchar,
                      dcv.razon_social::varchar,
                      dcv.codigo_control::varchar,

                      COALESCE(dcv.importe_doc,0)::numeric as importe_doc,
                      COALESCE(dcv.importe_pago_liquido,0)::numeric as importe_pago_liquido,

                      m.fecha::date as fecha_2,
                      m.nro_documento::varchar as nro_documento_2,
                      m.nro_autorizacion::varchar as nro_autorizacion_2,
                      m.importe_doc::numeric as importe_doc_2

                      from conta.tdoc_compra_venta dcv
                      join conta.tdoc_compra_venta m on m.id_doc_compra_venta=dcv.id_doc_compra_venta_fk
                      inner join segu.tusuario usu1 on usu1.id_usuario = dcv.id_usuario_reg
                      inner join param.tplantilla pla on pla.id_plantilla = dcv.id_plantilla
                      inner join param.tmoneda mon on mon.id_moneda = dcv.id_moneda
                      inner join conta.ttipo_doc_compra_venta tdcv on tdcv.id_tipo_doc_compra_venta = dcv.id_tipo_doc_compra_venta
                      left join conta.tauxiliar aux on aux.id_auxiliar = dcv.id_auxiliar
                      left join conta.tint_comprobante ic on ic.id_int_comprobante = dcv.id_int_comprobante                         
                      left join param.tdepto dep on dep.id_depto = dcv.id_depto_conta
                      left join segu.tusuario usu2 on usu2.id_usuario = dcv.id_usuario_mod
                      left join orga.vfuncionario fun on fun.id_funcionario = dcv.id_funcionario
                      left join param.tperiodo per on per.id_periodo = dcv.id_periodo
                      where dcv.tipo=''venta'' and dcv.id_doc_compra_venta_fk is not null and';
			--Devuelve la respuesta 
            
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by dcv.fecha asc' ;  

			RETURN v_consulta;        	
		END;   
    
     
    ELSE
		RAISE EXCEPTION 'Transaccion inexistente';
	END IF;
    
EXCEPTION
	WHEN OTHERS THEN
      v_resp='';
      v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
      v_resp = pxp.f_agrega_clave(v_resp,'codigo_',SQLSTATE);
      v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
      RAISE EXCEPTION '%',v_resp;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;