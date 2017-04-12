CREATE OR REPLACE FUNCTION "conta"."ft_doc_int_comprobante_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_doc_int_comprobante_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tdoc_int_comprobante'
 AUTOR: 		 (gsarmiento)
 FECHA:	        13-03-2017 15:41:29
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

	v_nombre_funcion = 'conta.ft_doc_int_comprobante_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_DOCCBTE_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		gsarmiento	
 	#FECHA:		13-03-2017 15:41:29
	***********************************/

	if(p_transaccion='CONTA_DOCCBTE_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						doccbte.id_doc_int_comprobante,
						doccbte.estado_reg,
						doccbte.fecha,
						doccbte.nit,
						doccbte.razon_social,
						doccbte.desc_plantilla,
						doccbte.nro_documento,
						doccbte.nro_dui,
						doccbte.nro_autorizacion,
						doccbte.codigo_control,
						doccbte.importe_doc,
						doccbte.importe_ice,
						doccbte.importe_descuento,
						doccbte.importe_excento,
						doccbte.liquido,
						doccbte.importe_sujeto,
						doccbte.importe_iva,
						doccbte.importe_gasto,
						doccbte.porc_gasto_prorrateado,
						doccbte.sujeto_prorrateado,
						doccbte.iva_prorrateado,
						doccbte.codigo,
						doccbte.nro_cuenta,
						doccbte.origen,
						doccbte.id_int_comprobante,
						doccbte.id_doc_compra_venta,
						doccbte.usuario,
						doccbte.id_usuario_reg,
						doccbte.fecha_reg,
						doccbte.id_usuario_ai,
						doccbte.usuario_ai,
						doccbte.id_usuario_mod,
						doccbte.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	
						from conta.tdoc_int_comprobante doccbte
						inner join segu.tusuario usu1 on usu1.id_usuario = doccbte.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = doccbte.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_DOCCBTE_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		gsarmiento	
 	#FECHA:		13-03-2017 15:41:29
	***********************************/

	elsif(p_transaccion='CONTA_DOCCBTE_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_doc_int_comprobante)
					    from conta.tdoc_int_comprobante doccbte
					    inner join segu.tusuario usu1 on usu1.id_usuario = doccbte.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = doccbte.id_usuario_mod
					    where ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

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
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;
ALTER FUNCTION "conta"."ft_doc_int_comprobante_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
