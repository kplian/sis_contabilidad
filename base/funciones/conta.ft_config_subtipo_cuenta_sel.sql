--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_config_subtipo_cuenta_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_config_subtipo_cuenta_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tconfig_subtipo_cuenta'
 AUTOR: 		 (admin)
 FECHA:	        07-06-2017 19:52:43
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

	v_nombre_funcion = 'conta.ft_config_subtipo_cuenta_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_CST_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		07-06-2017 19:52:43
	***********************************/

	if(p_transaccion='CONTA_CST_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
                            cst.id_config_subtipo_cuenta,
                            cst.estado_reg,
                            cst.descripcion,
                            cst.nombre,
                            cst.id_config_tipo_cuenta,
                            cst.codigo,
                            cst.fecha_reg,
                            cst.usuario_ai,
                            cst.id_usuario_reg,
                            cst.id_usuario_ai,
                            cst.id_usuario_mod,
                            cst.fecha_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                            ctc.tipo_cuenta,
                            ctc.nro_base
						from conta.tconfig_subtipo_cuenta cst
						inner join segu.tusuario usu1 on usu1.id_usuario = cst.id_usuario_reg
                        inner join conta.tconfig_tipo_cuenta ctc on ctc.id_config_tipo_cuenta = cst.id_config_tipo_cuenta
						left join segu.tusuario usu2 on usu2.id_usuario = cst.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CST_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		07-06-2017 19:52:43
	***********************************/

	elsif(p_transaccion='CONTA_CST_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_config_subtipo_cuenta)
					    from conta.tconfig_subtipo_cuenta cst
						inner join segu.tusuario usu1 on usu1.id_usuario = cst.id_usuario_reg
                        inner join conta.tconfig_tipo_cuenta ctc on ctc.id_config_tipo_cuenta = cst.id_config_tipo_cuenta
						left join segu.tusuario usu2 on usu2.id_usuario = cst.id_usuario_mod
				        where  ';
			
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