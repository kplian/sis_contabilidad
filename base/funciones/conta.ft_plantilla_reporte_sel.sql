CREATE OR REPLACE FUNCTION conta.ft_plantilla_reporte_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_plantilla_reporte_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tplantilla_reporte'
 AUTOR: 		 (m.mamani)
 FECHA:	        06-09-2018 19:52:00
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				06-09-2018 19:52:00								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tplantilla_reporte'
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'conta.ft_plantilla_reporte_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'CONTA_PER_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		m.mamani
 	#FECHA:		06-09-2018 19:52:00
	***********************************/

	if(p_transaccion='CONTA_PER_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						per.id_plantilla_reporte,
						per.nombre,
						per.glosa,
						per.modalidad,
						per.estado_reg,
						per.id_usuario_ai,
						per.id_usuario_reg,
						per.usuario_ai,
						per.fecha_reg,
						per.id_usuario_mod,
						per.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        per.codigo,
                        per.nombre_func,
                        per.visible
						from conta.tplantilla_reporte per
						inner join segu.tusuario usu1 on usu1.id_usuario = per.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = per.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_PER_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		m.mamani	
 	#FECHA:		06-09-2018 19:52:00
	***********************************/

	elsif(p_transaccion='CONTA_PER_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_plantilla_reporte)
					    from conta.tplantilla_reporte per
					    inner join segu.tusuario usu1 on usu1.id_usuario = per.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = per.id_usuario_mod
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