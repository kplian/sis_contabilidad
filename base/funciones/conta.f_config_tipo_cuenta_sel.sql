--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_config_tipo_cuenta_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.f_config_tipo_cuenta_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tconfig_tipo_cuenta'
 AUTOR: 		 (admin)
 FECHA:	        26-02-2013 19:19:24
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

	v_nombre_funcion = 'conta.f_config_tipo_cuenta_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_CTC_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		26-02-2013 19:19:24
	***********************************/

	if(p_transaccion='CONTA_CTC_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
                            ctc.id_config_tipo_cuenta,
                            ctc.nro_base,
                            ctc.tipo_cuenta,
                            ctc.estado_reg,
                            ctc.id_usuario_reg,
                            ctc.fecha_reg,
                            ctc.fecha_mod,
                            ctc.id_usuario_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                            ctc.incremento,
                            array_to_string( ctc.eeff, '','',''null'')::varchar	 as eeff,
                            movimiento
						from conta.tconfig_tipo_cuenta ctc
						inner join segu.tusuario usu1 on usu1.id_usuario = ctc.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = ctc.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CTC_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		26-02-2013 19:19:24
	***********************************/

	elsif(p_transaccion='CONTA_CTC_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_config_tipo_cuenta)
					    from conta.tconfig_tipo_cuenta ctc
					    inner join segu.tusuario usu1 on usu1.id_usuario = ctc.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = ctc.id_usuario_mod
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