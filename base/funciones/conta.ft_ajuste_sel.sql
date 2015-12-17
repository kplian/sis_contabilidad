--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_ajuste_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_ajuste_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tajuste'
 AUTOR: 		 (admin)
 FECHA:	        10-12-2015 15:16:16
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

	v_nombre_funcion = 'conta.ft_ajuste_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_AJT_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		10-12-2015 15:16:16
	***********************************/

	if(p_transaccion='CONTA_AJT_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
                            ajt.id_ajuste,
                            ajt.fecha,
                            ajt.id_depto_conta,
                            ajt.estado,
                            ajt.obs,
                            ajt.estado_reg,
                            ajt.id_usuario_ai,
                            ajt.usuario_ai,
                            ajt.fecha_reg,
                            ajt.id_usuario_reg,
                            ajt.fecha_mod,
                            ajt.id_usuario_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                            dep.codigo as codigo_depto,
                            dep.nombre as desc_depto,
                            dep.nombre_corto,
                            ajt.tipo
                         from conta.tajuste ajt
                            inner join segu.tusuario usu1 on usu1.id_usuario = ajt.id_usuario_reg
                            inner join param.tdepto dep on dep.id_depto = ajt.id_depto_conta
                            left join segu.tusuario usu2 on usu2.id_usuario = ajt.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_AJT_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		10-12-2015 15:16:16
	***********************************/

	elsif(p_transaccion='CONTA_AJT_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_ajuste)
					     from conta.tajuste ajt
                            inner join segu.tusuario usu1 on usu1.id_usuario = ajt.id_usuario_reg
                            inner join param.tdepto dep on dep.id_depto = ajt.id_depto_conta
                            left join segu.tusuario usu2 on usu2.id_usuario = ajt.id_usuario_mod
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