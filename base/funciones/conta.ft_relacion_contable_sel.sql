--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_relacion_contable_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_relacion_contable_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.trelacion_contable'
 AUTOR: 		 (admin)
 FECHA:	        16-05-2013 21:52:14
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

	v_nombre_funcion = 'conta.ft_relacion_contable_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_RELCON_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		16-05-2013 21:52:14
	***********************************/

	if(p_transaccion='CONTA_RELCON_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						relcon.id_relacion_contable,
						relcon.estado_reg,
						relcon.id_tipo_relacion_contable,
						relcon.id_cuenta,
						relcon.id_partida,
						relcon.id_gestion,
						relcon.id_auxiliar,
						relcon.id_centro_costo,
						relcon.fecha_reg,
						relcon.id_usuario_reg,
						relcon.fecha_mod,
						relcon.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						relcon.id_tabla,
						ges.gestion,
						tiprelco.nombre_tipo_relacion,
						cu.nro_cuenta,
						cu.nombre_cuenta,
						au.codigo_auxiliar,
						au.nombre_auxiliar,
						par.codigo,
						par.nombre_partida,
						tiprelco.tiene_centro_costo,
						tiprelco.tiene_partida,
						tiprelco.tiene_auxiliar,
                        cc.codigo_cc,
                        relcon.defecto,
                        tiprelco.partida_tipo,
                        tiprelco.partida_rubro
						from conta.trelacion_contable relcon
						inner join conta.ttipo_relacion_contable tiprelco
							on tiprelco.id_tipo_relacion_contable = relcon.id_tipo_relacion_contable
						inner join param.tgestion ges
							on ges.id_gestion = relcon.id_gestion
                        left join param.vcentro_costo cc 
                          on cc.id_centro_costo = relcon.id_centro_costo
						left join conta.ttabla_relacion_contable tabrelco 
							on tiprelco.id_tabla_relacion_contable = tabrelco.id_tabla_relacion_contable
						left join conta.tcuenta cu 
							on cu.id_cuenta = relcon.id_cuenta
						left join conta.tauxiliar au 
							on au.id_auxiliar = relcon.id_auxiliar
						left join pre.tpartida par 
							on par.id_partida = relcon.id_partida
						inner join segu.tusuario usu1 on usu1.id_usuario = relcon.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = relcon.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_RELCON_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		16-05-2013 21:52:14
	***********************************/

	elsif(p_transaccion='CONTA_RELCON_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_relacion_contable)
					    from conta.trelacion_contable relcon
						inner join conta.ttipo_relacion_contable tiprelco
							on tiprelco.id_tipo_relacion_contable = relcon.id_tipo_relacion_contable
						inner join param.tgestion ges
							on ges.id_gestion = relcon.id_gestion
                        left join param.vcentro_costo cc 
                          on cc.id_centro_costo = relcon.id_centro_costo
						left join conta.ttabla_relacion_contable tabrelco 
							on tiprelco.id_tabla_relacion_contable = tabrelco.id_tabla_relacion_contable
						left join conta.tcuenta cu 
							on cu.id_cuenta = relcon.id_cuenta
						left join conta.tauxiliar au 
							on au.id_auxiliar = relcon.id_auxiliar
						left join pre.tpartida par 
							on par.id_partida = relcon.id_partida
						inner join segu.tusuario usu1 on usu1.id_usuario = relcon.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = relcon.id_usuario_mod
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