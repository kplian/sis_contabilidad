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
						dcv.importe_excento,
						dcv.id_plantilla,
						dcv.fecha,
						dcv.nro_documento,
						dcv.nit,
						dcv.importe_ice,
						dcv.nro_autorizacion,
						dcv.importe_iva,
						dcv.importe_descuento,
						dcv.importe_doc,
						dcv.sw_contabilizar,
						dcv.tabla_origen,
						dcv.estado,
						dcv.id_depto_conta,
						dcv.id_origen,
						dcv.obs,
						dcv.estado_reg,
						dcv.codigo_control,
						dcv.importe_it,
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
                        dcv.importe_descuento_ley,
                        dcv.importe_pago_liquido,
                        dcv.nro_dui,
                        dcv.id_moneda,
                        mon.codigo as desc_moneda,
                        dcv.id_int_comprobante,
                        COALESCE(ic.nro_cbte,dcv.id_int_comprobante::varchar)::varchar  as desc_comprobante
						from conta.tdoc_compra_venta dcv
						inner join segu.tusuario usu1 on usu1.id_usuario = dcv.id_usuario_reg
                        inner join param.tplantilla pla on pla.id_plantilla = dcv.id_plantilla
                        inner join param.tmoneda mon on mon.id_moneda = dcv.id_moneda
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
			v_consulta:='select count(id_doc_compra_venta)
					    from conta.tdoc_compra_venta dcv
						inner join segu.tusuario usu1 on usu1.id_usuario = dcv.id_usuario_reg
                        inner join param.tplantilla pla on pla.id_plantilla = dcv.id_plantilla
                        inner join param.tmoneda mon on mon.id_moneda = dcv.id_moneda
                        left join conta.tint_comprobante ic on ic.id_int_comprobante = dcv.id_int_comprobante
                        left join param.tdepto dep on dep.id_depto = dcv.id_depto_conta
						left join segu.tusuario usu2 on usu2.id_usuario = dcv.id_usuario_mod
				        where ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

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
                          DISTINCT(dcv.nro_autorizacion),
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
                           DISTINCT(dcv.nit),
                           dcv.razon_social
                          from conta.tdoc_compra_venta dcv
                        where dcv.nit != '''' and dcv.nit like '''||COALESCE(v_parametros.nit,'-')||'%''';
         
         
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