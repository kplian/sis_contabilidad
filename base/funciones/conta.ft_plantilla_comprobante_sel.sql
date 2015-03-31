--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_plantilla_comprobante_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_plantilla_comprobante_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tplantilla_comprobante'
 AUTOR: 		 (admin)
 FECHA:	        10-06-2013 14:40:00
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

	v_nombre_funcion = 'conta.ft_plantilla_comprobante_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_CMPB_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		10-06-2013 14:40:00
	***********************************/

	if(p_transaccion='CONTA_CMPB_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						cmpb.id_plantilla_comprobante,
						cmpb.codigo,
						cmpb.funcion_comprobante_eliminado,
						cmpb.id_tabla,
						cmpb.campo_subsistema,
						cmpb.campo_descripcion,
						cmpb.funcion_comprobante_validado,
						cmpb.campo_fecha,
						cmpb.estado_reg,
						cmpb.campo_acreedor,
						cmpb.campo_depto,
						cmpb.momento_presupuestario,
						cmpb.campo_fk_comprobante,
						cmpb.tabla_origen,
						cmpb.clase_comprobante,
						cmpb.campo_moneda,
						cmpb.id_usuario_reg,
						cmpb.fecha_reg,
						cmpb.id_usuario_mod,
						cmpb.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        cmpb.campo_gestion_relacion,
                        cmpb.otros_campos,
                        cmpb.momento_comprometido,
                        cmpb.momento_ejecutado,
                        cmpb.momento_pagado,
                        cmpb.campo_id_cuenta_bancaria,
                        cmpb.campo_id_cuenta_bancaria_mov,
                        cmpb.campo_nro_cheque,
                        cmpb.campo_nro_cuenta_bancaria_trans,
                        cmpb.campo_nro_tramite,
                        cmpb.campo_tipo_cambio
                        from conta.tplantilla_comprobante cmpb
						inner join segu.tusuario usu1 on usu1.id_usuario = cmpb.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cmpb.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CMPB_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		10-06-2013 14:40:00
	***********************************/

	elsif(p_transaccion='CONTA_CMPB_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_plantilla_comprobante)
					    from conta.tplantilla_comprobante cmpb
					    inner join segu.tusuario usu1 on usu1.id_usuario = cmpb.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cmpb.id_usuario_mod
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