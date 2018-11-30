--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_detalle_det_reporte_aux_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_detalle_det_reporte_aux_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tdetalle_det_reporte_aux'
 AUTOR: 		 (m.mamani)
 FECHA:	        19-10-2018 15:39:09
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				19-10-2018 15:39:09								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tdetalle_det_reporte_aux'	
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
			    
BEGIN

	v_nombre_funcion = 'conta.ft_detalle_det_reporte_aux_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_DRA_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		m.mamani	
 	#FECHA:		19-10-2018 15:39:09
	***********************************/

	if(p_transaccion='CONTA_DRA_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						dra.id_detalle_det_reporte_aux,
						dra.estado_reg,
						dra.partida,
						dra.orden_fila,
						dra.origen,
						dra.concepto,
						dra.id_usuario_reg,
						dra.usuario_ai,
						dra.fecha_reg,
						dra.id_usuario_ai,
						dra.id_usuario_mod,
						dra.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        dra.id_plantilla_reporte	
						from conta.tdetalle_det_reporte_aux dra
						inner join segu.tusuario usu1 on usu1.id_usuario = dra.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = dra.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_DRA_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		m.mamani	
 	#FECHA:		19-10-2018 15:39:09
	***********************************/

	elsif(p_transaccion='CONTA_DRA_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_detalle_det_reporte_aux)
					    from conta.tdetalle_det_reporte_aux dra
					    inner join segu.tusuario usu1 on usu1.id_usuario = dra.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = dra.id_usuario_mod
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