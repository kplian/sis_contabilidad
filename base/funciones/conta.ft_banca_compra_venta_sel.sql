CREATE OR REPLACE FUNCTION conta.ft_banca_compra_venta_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_banca_compra_venta_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tbanca_compra_venta'
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

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
			    
BEGIN

	v_nombre_funcion = 'conta.ft_banca_compra_venta_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_BANCA_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		11-09-2015 14:36:46
	***********************************/

	if(p_transaccion='CONTA_BANCA_SEL')then
     				
    	begin
      
    		--Sentencia de la consulta
			v_consulta:='select
						banca.id_banca_compra_venta,
						banca.num_cuenta_pago,
						banca.tipo_documento_pago,
						banca.num_documento,
						banca.monto_acumulado,
						banca.estado_reg,
						banca.nit_ci,
						banca.importe_documento,
						banca.fecha_documento,
						banca.modalidad_transaccion,
						banca.tipo_transaccion,
						banca.autorizacion,
						banca.monto_pagado,
						banca.fecha_de_pago,
						banca.razon,
						banca.tipo,
						banca.num_documento_pago,
						banca.num_contrato,
						banca.nit_entidad,
						banca.fecha_reg,
						banca.usuario_ai,
						banca.id_usuario_reg,
						banca.id_usuario_ai,
						banca.id_usuario_mod,
						banca.fecha_mod,
                        banca.id_periodo,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        confmo.descripcion as desc_modalidad_transaccion,
                        conftt.descripcion as desc_tipo_transaccion,
                        conftd.descripcion as desc_tipo_documento_pago,
                        banca.revisado	
						from conta.tbanca_compra_venta banca
						inner join segu.tusuario usu1 on usu1.id_usuario = banca.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = banca.id_usuario_mod
                        inner join conta.tconfig_banca confmo on confmo.digito = banca.modalidad_transaccion
                        inner join conta.tconfig_banca conftt on conftt.digito = banca.tipo_transaccion
                        inner join conta.tconfig_banca conftd on conftd.digito = banca.tipo_documento_pago
                        where ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
            
            
           
            
            
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_BANCA_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		11-09-2015 14:36:46
	***********************************/

	elsif(p_transaccion='CONTA_BANCA_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_banca_compra_venta)
					    from conta.tbanca_compra_venta banca
					    inner join segu.tusuario usu1 on usu1.id_usuario = banca.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = banca.id_usuario_mod
                        inner join conta.tconfig_banca confmo on confmo.digito = banca.modalidad_transaccion
                        inner join conta.tconfig_banca conftt on conftt.digito = banca.tipo_transaccion
                        inner join conta.tconfig_banca conftd on conftd.digito = banca.tipo_documento_pago
                        
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
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;