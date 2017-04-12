--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_detalle_plantilla_comprobante_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_detalle_plantilla_comprobante_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tdetalle_plantilla_comprobante'
 AUTOR: 		 (admin)
 FECHA:	        10-06-2013 14:51:03
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

	v_nombre_funcion = 'conta.ft_detalle_plantilla_comprobante_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_CMPBDET_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		10-06-2013 14:51:03
	***********************************/

	if(p_transaccion='CONTA_CMPBDET_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
                            cmpbdet.id_detalle_plantilla_comprobante,
                            cmpbdet.id_plantilla_comprobante,
                            cmpbdet.debe_haber,
                            cmpbdet.agrupar,
                            cmpbdet.es_relacion_contable,
                            cmpbdet.tabla_detalle,
                            cmpbdet.campo_partida,
                            cmpbdet.campo_concepto_transaccion,
                            cmpbdet.tipo_relacion_contable,
                            cmpbdet.campo_cuenta,
                            cmpbdet.campo_monto,
                            cmpbdet.campo_relacion_contable,
                            cmpbdet.campo_documento,
                            cmpbdet.aplicar_documento,
                            cmpbdet.campo_centro_costo,
                            cmpbdet.campo_auxiliar,
                            cmpbdet.campo_fecha,
                            cmpbdet.estado_reg,
                            cmpbdet.fecha_reg,
                            cmpbdet.id_usuario_reg,
                            cmpbdet.fecha_mod,
                            cmpbdet.id_usuario_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod	,
                            cmpbdet.primaria, 
                            cmpbdet.otros_campos, 
                            cmpbdet.nom_fk_tabla_maestro, 
                            cmpbdet.campo_partida_ejecucion , 
                            cmpbdet.descripcion , 
                            cmpbdet.campo_monto_pres , 
                            cmpbdet.id_detalle_plantilla_fk , 
                            cmpbdet.forma_calculo_monto, 
                            cmpbdet.func_act_transaccion, 
                            cmpbdet.campo_id_tabla_detalle, 
                            cmpbdet.rel_dev_pago, 
                            cmpbdet.campo_trasaccion_dev ,
                            cmpbdetb.descripcion as descripcion_base,
                            cmpbdet.campo_id_cuenta_bancaria,
                            cmpbdet.campo_id_cuenta_bancaria_mov,
                            cmpbdet.campo_nro_cheque,
                            cmpbdet.campo_nro_cuenta_bancaria_trans,
                            cmpbdet.campo_porc_monto_excento_var,
                            cmpbdet.campo_nombre_cheque_trans,
                            cmpbdet.prioridad_documento,
                            cmpbdet.campo_orden_trabajo,
                            cmpbdet.campo_forma_pago,
                            cmpbdet.codigo,
                            cmpbdet.tipo_relacion_contable_cc,
                            cmpbdet.campo_relacion_contable_cc
                            
                        
						from conta.tdetalle_plantilla_comprobante cmpbdet
						inner join segu.tusuario usu1 on usu1.id_usuario = cmpbdet.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cmpbdet.id_usuario_mod
                        left join conta.tdetalle_plantilla_comprobante cmpbdetb on cmpbdetb.id_detalle_plantilla_comprobante = cmpbdet.id_detalle_plantilla_fk
				        where cmpbdet.id_plantilla_comprobante='||v_parametros.id_plantilla_comprobante|| ' and ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CMPBDET_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		10-06-2013 14:51:03
	***********************************/

	elsif(p_transaccion='CONTA_CMPBDET_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(cmpbdet.id_detalle_plantilla_comprobante)
					    from conta.tdetalle_plantilla_comprobante cmpbdet
						inner join segu.tusuario usu1 on usu1.id_usuario = cmpbdet.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cmpbdet.id_usuario_mod
                        left join conta.tdetalle_plantilla_comprobante cmpbdetb on cmpbdetb.id_detalle_plantilla_comprobante = cmpbdet.id_detalle_plantilla_fk
				        where cmpbdet.id_plantilla_comprobante='||v_parametros.id_plantilla_comprobante|| ' and ';
			
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