--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_config_cambiaria_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_config_cambiaria_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tconfig_cambiaria'
 AUTOR: 		 (admin)
 FECHA:	        04-11-2015 12:39:12
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

	v_nombre_funcion = 'conta.ft_config_cambiaria_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_CNFC_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		04-11-2015 12:39:12
	***********************************/

	if(p_transaccion='CONTA_CNFC_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
                                cnfc.id_config_cambiaria,
                                cnfc.fecha_habilitado,
                                cnfc.origen,
                                cnfc.habilitado,
                                cnfc.estado_reg,
                                cnfc.ope_2,
                                cnfc.ope_1,
                                cnfc.obs,
                                cnfc.id_usuario_reg,
                                cnfc.fecha_reg,
                                cnfc.usuario_ai,
                                cnfc.id_usuario_ai,
                                cnfc.fecha_mod,
                                cnfc.id_usuario_mod,
                                usu1.cuenta as usr_reg,
                                usu2.cuenta as usr_mod,
                                cnfc.ope_3	
						from conta.tconfig_cambiaria cnfc
						inner join segu.tusuario usu1 on usu1.id_usuario = cnfc.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cnfc.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CNFC_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		04-11-2015 12:39:12
	***********************************/

	elsif(p_transaccion='CONTA_CNFC_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_config_cambiaria)
					    from conta.tconfig_cambiaria cnfc
					    inner join segu.tusuario usu1 on usu1.id_usuario = cnfc.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cnfc.id_usuario_mod
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