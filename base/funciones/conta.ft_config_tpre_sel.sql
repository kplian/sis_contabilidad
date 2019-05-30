CREATE OR REPLACE FUNCTION conta.ft_config_tpre_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_config_tpre_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tconfig_tpre'
 AUTOR: 		 (mguerra)
 FECHA:	        18-03-2019 16:32:29
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #54				18-03-2019 16:32:29								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tconfig_tpre'	
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
			    
BEGIN

	v_nombre_funcion = 'conta.ft_config_tpre_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_CONTC_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		mguerra	
 	#FECHA:		18-03-2019 16:32:29
	***********************************/

	if(p_transaccion='CONTA_CONTC_SEL')then
     				
    	begin

    		--Sentencia de la consulta
			v_consulta:='select
			            (''(''||vcc.codigo_tcc ||'') '' ||vcc.descripcion_tcc)::varchar AS desc_tcc,
						contc.id_conf_pre,
						contc.id_tipo_cc,
						contc.estado_reg,
						contc.obs,
						contc.fecha_reg,
						contc.usuario_ai,
						contc.id_usuario_reg,
						contc.id_usuario_ai,
						contc.fecha_mod,
						contc.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	
						from conta.tconfig_tpre contc
						inner join segu.tusuario usu1 on usu1.id_usuario = contc.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = contc.id_usuario_mod
                        join param.vcentro_costo vcc on vcc.id_tipo_cc=contc.id_tipo_cc
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta|| v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			--' order by ' ||v_parametros.ordenacion|| ' ' ||
			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CONTC_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		mguerra	
 	#FECHA:		18-03-2019 16:32:29
	***********************************/

	elsif(p_transaccion='CONTA_CONTC_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_conf_pre)
					    from conta.tconfig_tpre contc
					    inner join segu.tusuario usu1 on usu1.id_usuario = contc.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = contc.id_usuario_mod
                        join param.vcentro_costo vcc on vcc.id_tipo_cc=contc.id_tipo_cc
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