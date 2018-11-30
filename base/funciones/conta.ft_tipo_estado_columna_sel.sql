--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_tipo_estado_columna_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_tipo_estado_columna_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.ttipo_estado_columna'
 AUTOR: 		 (admin)
 FECHA:	        26-07-2017 21:49:56
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

	v_nombre_funcion = 'conta.ft_tipo_estado_columna_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_TECC_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		26-07-2017 21:49:56
	***********************************/

	if(p_transaccion='CONTA_TECC_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
                              tecc.id_tipo_estado_columna,
                              tecc.codigo,
                              tecc.link_int_det,
                              tecc.origen,
                              tecc.id_config_subtipo_cuenta,
                              tecc.nombre,
                              tecc.nombre_funcion,
                              tecc.estado_reg,
                              tecc.id_usuario_ai,
                              tecc.fecha_reg,
                              tecc.usuario_ai,
                              tecc.id_usuario_reg,
                              tecc.fecha_mod,
                              tecc.id_usuario_mod,
                              usu1.cuenta as usr_reg,
                              usu2.cuenta as usr_mod,
                              tecc.prioridad,
                              tecc.id_tipo_estado_cuenta,
                              csc.nombre as desc_csc,
                              tecc.descripcion,
                              tecc.nombre_clase,
                              tecc.parametros_det 
                              
                              	
                        from conta.ttipo_estado_columna tecc
                        inner join segu.tusuario usu1 on usu1.id_usuario = tecc.id_usuario_reg
                        left join conta.tconfig_subtipo_cuenta csc on csc.id_config_subtipo_cuenta = tecc.id_config_subtipo_cuenta
                        left join segu.tusuario usu2 on usu2.id_usuario = tecc.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_TECC_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		26-07-2017 21:49:56
	***********************************/

	elsif(p_transaccion='CONTA_TECC_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_tipo_estado_columna)
					    from conta.ttipo_estado_columna tecc
                        inner join segu.tusuario usu1 on usu1.id_usuario = tecc.id_usuario_reg
                        left join conta.tconfig_subtipo_cuenta csc on csc.id_config_subtipo_cuenta = tecc.id_config_subtipo_cuenta
                        left join segu.tusuario usu2 on usu2.id_usuario = tecc.id_usuario_mod
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