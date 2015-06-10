--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_comprobante_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_comprobante_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tcomprobante'
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

	v_nombre_funcion = 'conta.ft_comprobante_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_CBTE_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		29-08-2013 00:28:30
	***********************************/

	if(p_transaccion='CONTA_CBTE_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						cbte.id_comprobante,
						cbte.id_clase_comprobante,
						cbte.id_comprobante_fk,
						cbte.id_subsistema,
						cbte.id_depto,
						cbte.id_moneda,
						cbte.id_periodo,
						cbte.id_funcionario_firma1,
						cbte.id_funcionario_firma2,
						cbte.id_funcionario_firma3,
						cbte.tipo_cambio,
						cbte.beneficiario,
						cbte.nro_cbte,
						cbte.estado_reg,
						cbte.glosa1,
						cbte.fecha,
						cbte.glosa2,
						cbte.nro_tramite,
						cbte.momento,
						cbte.id_usuario_reg,
						cbte.fecha_reg,
						cbte.id_usuario_mod,
						cbte.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						ccbte.descripcion as desc_clase_comprobante,
						sis.nombre as desc_subsistema,
						dpto.codigo || '' - '' || dpto.nombre as desc_depto,	
						mon.codigo || '' - '' || mon.moneda as desc_moneda,
						fir1.desc_funcionario2 as desc_firma1,
						fir2.desc_funcionario2 as desc_firma2,
						fir3.desc_funcionario2 as desc_firma3
						from conta.tcomprobante cbte
						inner join segu.tusuario usu1 on usu1.id_usuario = cbte.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cbte.id_usuario_mod
						inner join conta.tclase_comprobante ccbte on ccbte.id_clase_comprobante = cbte.id_clase_comprobante
						inner join segu.tsubsistema sis on sis.id_subsistema = cbte.id_subsistema
						inner join param.tdepto dpto on dpto.id_depto = cbte.id_depto
						inner join param.tmoneda mon on mon.id_moneda = cbte.id_moneda
						left join orga.vfuncionario fir1 on fir1.id_funcionario = cbte.id_funcionario_firma1
						left join orga.vfuncionario fir2 on fir2.id_funcionario = cbte.id_funcionario_firma2
						left join orga.vfuncionario fir3 on fir3.id_funcionario = cbte.id_funcionario_firma3
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CBTE_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		29-08-2013 00:28:30
	***********************************/

	elsif(p_transaccion='CONTA_CBTE_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_comprobante)
					    from conta.tcomprobante cbte
					    inner join segu.tusuario usu1 on usu1.id_usuario = cbte.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cbte.id_usuario_mod
						inner join conta.tclase_comprobante ccbte on ccbte.id_clase_comprobante = cbte.id_clase_comprobante
						inner join segu.tsubsistema sis on sis.id_subsistema = cbte.id_subsistema
						inner join param.tdepto dpto on dpto.id_depto = cbte.id_depto
						inner join param.tmoneda mon on mon.id_moneda = cbte.id_moneda
						left join orga.vfuncionario fir1 on fir1.id_funcionario = cbte.id_funcionario_firma1
						left join orga.vfuncionario fir2 on fir2.id_funcionario = cbte.id_funcionario_firma2
						left join orga.vfuncionario fir3 on fir3.id_funcionario = cbte.id_funcionario_firma3
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