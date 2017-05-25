CREATE OR REPLACE FUNCTION "conta"."ft_transaccion_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_transaccion_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tint_transaccion'
 AUTOR: 		 (admin)
 FECHA:	        01-09-2013 18:10:12
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

	v_nombre_funcion = 'conta.ft_transaccion_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_TRANSA_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		01-09-2013 18:10:12
	***********************************/

	if(p_transaccion='CONTA_TRANSA_SEL')then
     				
    	begin
    	
    		--Sentencia de la consulta
			v_consulta:='select
						transa.id_transaccion,
						transa.id_partida,
						transa.id_centro_costo,
						transa.id_partida_ejecucion,
						transa.estado_reg,
						transa.id_transaccion_fk,
						transa.id_cuenta,
						transa.glosa,
						transa.id_comprobante,
						transa.id_auxiliar,
						transa.id_usuario_reg,
						transa.fecha_reg,
						transa.id_usuario_mod,
						transa.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						tval.importe_debe,	
						tval.importe_haber,
						tval.importe_gasto,
						tval.importe_recurso,
						par.codigo || '' - '' || par.nombre_partida as desc_partida,
						cc.codigo_cc as desc_centro_costo,
						cue.nro_cuenta || '' - '' || cue.nombre_cuenta as desc_cuenta,
						aux.codigo_auxiliar || '' - '' || aux.nombre_auxiliar as desc_auxiliar,
						tval.id_trans_val,
						tval.id_moneda
						from conta.ttransaccion transa
						inner join segu.tusuario usu1 on usu1.id_usuario = transa.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = transa.id_usuario_mod
						left join pre.tpartida par on par.id_partida = transa.id_partida
						left join param.vcentro_costo cc on cc.id_centro_costo = transa.id_centro_costo
						inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
						left join conta.tauxiliar aux on aux.id_auxiliar = transa.id_auxiliar
						inner join conta.ttrans_val tval on tval.id_transaccion = transa.id_transaccion
				        where ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_TRANSA_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		01-09-2013 18:10:12
	***********************************/

	elsif(p_transaccion='CONTA_TRANSA_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(transa.id_transaccion)
					    from conta.ttransaccion transa
					    inner join segu.tusuario usu1 on usu1.id_usuario = transa.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = transa.id_usuario_mod
						left join pre.tpartida par on par.id_partida = transa.id_partida
						left join param.tcentro_costo cc on cc.id_centro_costo = transa.id_centro_costo
						inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
						left join conta.tauxiliar aux on aux.id_auxiliar = transa.id_auxiliar
						inner join conta.ttrans_val tval on tval.id_transaccion = transa.id_transaccion
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
ALTER FUNCTION "conta"."ft_transaccion_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
