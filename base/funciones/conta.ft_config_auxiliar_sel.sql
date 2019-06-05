CREATE OR REPLACE FUNCTION conta.ft_config_auxiliar_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_config_auxiliar_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tconfig_auxiliar'
 AUTOR: 		 (egutierrez)
 FECHA:	        05-06-2019 15:37:13
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				05-06-2019 15:37:13								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tconfig_auxiliar'	
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
			    
BEGIN

	v_nombre_funcion = 'conta.ft_config_auxiliar_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_cfga_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		egutierrez	
 	#FECHA:		05-06-2019 15:37:13
	***********************************/

	if(p_transaccion='CONTA_cfga_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						cfga.id_config_auxiliar,
						cfga.id_auxiliar,
						cfga.descripcion,
						cfga.estado_reg,
						cfga.id_usuario_ai,
						cfga.id_usuario_reg,
						cfga.fecha_reg,
						cfga.usuario_ai,
						cfga.id_usuario_mod,
						cfga.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        aux.nombre_auxiliar as desc_auxiliar	
						from conta.tconfig_auxiliar cfga
						inner join segu.tusuario usu1 on usu1.id_usuario = cfga.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cfga.id_usuario_mod
                        left join conta.tauxiliar aux on aux.id_auxiliar = cfga.id_auxiliar
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_cfga_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		egutierrez	
 	#FECHA:		05-06-2019 15:37:13
	***********************************/

	elsif(p_transaccion='CONTA_cfga_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_config_auxiliar)
					    from conta.tconfig_auxiliar cfga
					    inner join segu.tusuario usu1 on usu1.id_usuario = cfga.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cfga.id_usuario_mod
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