--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_periodo_compra_venta_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_periodo_compra_venta_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tperiodo_compra_venta'
 AUTOR: 		 (admin)
 FECHA:	        24-08-2015 14:16:54
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

	v_nombre_funcion = 'conta.ft_periodo_compra_venta_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_PCV_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		24-08-2015 14:16:54
	***********************************/

	if(p_transaccion='CONTA_PCV_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
                          pcv.id_periodo_compra_venta,
                          pcv.estado,
                          pcv.id_periodo,
                          pcv.estado_reg,
                          pcv.id_depto,
                          pcv.id_usuario_ai,
                          pcv.fecha_reg,
                          pcv.usuario_ai,
                          pcv.id_usuario_reg,
                          pcv.id_usuario_mod,
                          pcv.fecha_mod,
                          usu1.cuenta as usr_reg,
                          usu2.cuenta as usr_mod,
                          per.id_gestion,
                          per.fecha_ini,
                          per.fecha_fin,
 						  per.periodo
                          from conta.tperiodo_compra_venta pcv
                          inner join segu.tusuario usu1 on usu1.id_usuario = pcv.id_usuario_reg
                          inner join param.tperiodo per on per.id_periodo = pcv.id_periodo
                          left join segu.tusuario usu2 on usu2.id_usuario = pcv.id_usuario_mod
                         WHERE  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_PCV_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		24-08-2015 14:16:54
	***********************************/

	elsif(p_transaccion='CONTA_PCV_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_periodo_compra_venta)
					    from conta.tperiodo_compra_venta pcv
                          inner join segu.tusuario usu1 on usu1.id_usuario = pcv.id_usuario_reg
                          inner join param.tperiodo per on per.id_periodo = pcv.id_periodo
                          left join segu.tusuario usu2 on usu2.id_usuario = pcv.id_usuario_mod
                         WHERE ';
			
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