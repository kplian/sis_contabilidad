--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_doc_concepto_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_doc_concepto_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tdoc_concepto'
 AUTOR: 		 (admin)
 FECHA:	        15-09-2015 13:09:45
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

	v_nombre_funcion = 'conta.ft_doc_concepto_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_DOCC_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		15-09-2015 13:09:45
	***********************************/

	if(p_transaccion='CONTA_DOCC_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
                            docc.id_doc_concepto,
                            docc.estado_reg,
                            docc.id_orden_trabajo,
                            docc.id_centro_costo,
                            docc.id_concepto_ingas,
                            docc.descripcion,
                            docc.cantidad_sol,
                            docc.precio_unitario,
                            docc.precio_total,
                            docc.id_usuario_reg,
                            docc.fecha_reg,
                            docc.id_usuario_ai,
                            docc.usuario_ai,
                            docc.id_usuario_mod,
                            docc.fecha_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                            docc.id_doc_compra_venta,
                            cc.codigo_cc as desc_centro_costo,
                            cig.desc_ingas as desc_concepto_ingas,
                            ot.desc_orden as desc_orden_trabajo,
                            pre.id_presupuesto,
                            docc.precio_total_final,
                            par.codigo as desc_partida
						from conta.tdoc_concepto docc
						inner join segu.tusuario usu1 on usu1.id_usuario = docc.id_usuario_reg
                        inner join param.tconcepto_ingas cig on cig.id_concepto_ingas = docc.id_concepto_ingas
                        inner join param.vcentro_costo cc on cc.id_centro_costo = docc.id_centro_costo
                        inner join pre.tpresupuesto pre on pre.id_centro_costo = cc.id_centro_costo
                        left join pre.tpartida par on par.id_partida=docc.id_partida
						left join segu.tusuario usu2 on usu2.id_usuario = docc.id_usuario_mod
                        left join conta.torden_trabajo ot on ot.id_orden_trabajo = docc.id_orden_trabajo
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
             
            raise notice '%',  v_consulta;
			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_DOCC_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		15-09-2015 13:09:45
	***********************************/

	elsif(p_transaccion='CONTA_DOCC_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_doc_concepto)
					    from conta.tdoc_concepto docc
						inner join segu.tusuario usu1 on usu1.id_usuario = docc.id_usuario_reg
                        inner join param.tconcepto_ingas cig on cig.id_concepto_ingas = docc.id_concepto_ingas
                        inner join param.vcentro_costo cc on cc.id_centro_costo = docc.id_centro_costo
                        inner join pre.tpresupuesto pre on pre.id_centro_costo = cc.id_centro_costo
						left join segu.tusuario usu2 on usu2.id_usuario = docc.id_usuario_mod
                        left join conta.torden_trabajo ot on ot.id_orden_trabajo = docc.id_orden_trabajo
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