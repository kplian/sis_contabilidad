--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_grupo_ot_det_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_grupo_ot_det_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tgrupo_ot_det'
 AUTOR: 		 (admin)
 FECHA:	        06-10-2014 14:44:23
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

	v_nombre_funcion = 'conta.ft_grupo_ot_det_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_GOTD_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		06-10-2014 14:44:23
	***********************************/

	if(p_transaccion='CONTA_GOTD_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						gotd.id_grupo_ot_det,
						gotd.estado_reg,
						gotd.id_orden_trabajo,
						gotd.id_grupo_ot,
						gotd.fecha_reg,
						gotd.usuario_ai,
						gotd.id_usuario_reg,
						gotd.id_usuario_ai,
						gotd.id_usuario_mod,
						gotd.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	,
                        ot.desc_orden,
                        ot.motivo_orden
						from conta.tgrupo_ot_det gotd
                        inner join conta.torden_trabajo ot on ot.id_orden_trabajo = gotd.id_orden_trabajo
						inner join segu.tusuario usu1 on usu1.id_usuario = gotd.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = gotd.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_GOTD_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		06-10-2014 14:44:23
	***********************************/

	elsif(p_transaccion='CONTA_GOTD_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_grupo_ot_det)
					    from conta.tgrupo_ot_det gotd
                        inner join conta.torden_trabajo ot on ot.id_orden_trabajo = gotd.id_orden_trabajo
						inner join segu.tusuario usu1 on usu1.id_usuario = gotd.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = gotd.id_usuario_mod
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