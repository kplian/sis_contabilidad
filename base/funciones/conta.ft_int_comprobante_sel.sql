CREATE OR REPLACE FUNCTION "conta"."ft_int_comprobante_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_int_comprobante_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tint_comprobante'
 AUTOR: 		 (admin)
 FECHA:	        29-08-2013 00:28:30
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

	v_nombre_funcion = 'conta.ft_int_comprobante_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_INCBTE_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		29-08-2013 00:28:30
	***********************************/

	if(p_transaccion='CONTA_INCBTE_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						incbte.id_int_comprobante,
						incbte.id_clase_comprobante,
						incbte.id_int_comprobante_fk,
						incbte.id_subsistema,
						incbte.id_depto,
						incbte.id_moneda,
						incbte.id_periodo,
						incbte.id_funcionario_firma1,
						incbte.id_funcionario_firma2,
						incbte.id_funcionario_firma3,
						incbte.tipo_cambio,
						incbte.beneficiario,
						incbte.nro_cbte,
						incbte.estado_reg,
						incbte.glosa1,
						incbte.fecha,
						incbte.glosa2,
						incbte.nro_tramite,
						incbte.momento,
						incbte.id_usuario_reg,
						incbte.fecha_reg,
						incbte.id_usuario_mod,
						incbte.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						ccbte.descripcion as desc_clase_comprobante,
						sis.nombre as desc_subsistema,
						dpto.codigo || '' - '' || dpto.nombre as desc_depto,	
						mon.codigo || '' - '' || mon.moneda as desc_moneda,
						fir1.desc_funcionario2 as desc_firma1,
						fir2.desc_funcionario2 as desc_firma2,
						fir3.desc_funcionario2 as desc_firma3
						from conta.tint_comprobante incbte
						inner join segu.tusuario usu1 on usu1.id_usuario = incbte.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = incbte.id_usuario_mod
						inner join conta.tclase_comprobante ccbte on ccbte.id_clase_comprobante = incbte.id_clase_comprobante
						inner join segu.tsubsistema sis on sis.id_subsistema = incbte.id_subsistema
						inner join param.tdepto dpto on dpto.id_depto = incbte.id_depto
						inner join param.tmoneda mon on mon.id_moneda = incbte.id_moneda
						left join orga.vfuncionario fir1 on fir1.id_funcionario = incbte.id_funcionario_firma1
						left join orga.vfuncionario fir2 on fir2.id_funcionario = incbte.id_funcionario_firma2
						left join orga.vfuncionario fir3 on fir3.id_funcionario = incbte.id_funcionario_firma3
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_INCBTE_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		29-08-2013 00:28:30
	***********************************/

	elsif(p_transaccion='CONTA_INCBTE_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_int_comprobante)
					    from conta.tint_comprobante incbte
					    inner join segu.tusuario usu1 on usu1.id_usuario = incbte.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = incbte.id_usuario_mod
						inner join conta.tclase_comprobante ccbte on ccbte.id_clase_comprobante = incbte.id_clase_comprobante
						inner join segu.tsubsistema sis on sis.id_subsistema = incbte.id_subsistema
						inner join param.tdepto dpto on dpto.id_depto = incbte.id_depto
						inner join param.tmoneda mon on mon.id_moneda = incbte.id_moneda
						left join orga.vfuncionario fir1 on fir1.id_funcionario = incbte.id_funcionario_firma1
						left join orga.vfuncionario fir2 on fir2.id_funcionario = incbte.id_funcionario_firma2
						left join orga.vfuncionario fir3 on fir3.id_funcionario = incbte.id_funcionario_firma3
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
ALTER FUNCTION "conta"."ft_int_comprobante_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
