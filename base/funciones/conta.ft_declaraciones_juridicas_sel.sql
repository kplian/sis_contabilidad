--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_declaraciones_juridicas_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_declaraciones_juridicas_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tdeclaraciones_juridicas'
 AUTOR: 		 (m.mamani)
 FECHA:	        27-08-2018 14:51:02
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				27-08-2018 14:51:02								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tdeclaraciones_juridicas'	
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
			    
BEGIN

	v_nombre_funcion = 'conta.ft_declaraciones_juridicas_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_DJS_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		m.mamani	
 	#FECHA:		27-08-2018 14:51:02
	***********************************/

	if(p_transaccion='CONTA_DJS_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						djs.id_declaracion_juridica,
						djs.descripcion,
						djs.tipo,
						djs.fila,
						djs.importe,
						djs.codigo,
						djs.estado_reg,
						djs.id_gestion,
						djs.id_periodo,
						djs.fecha_reg,
						djs.usuario_ai,
						djs.id_usuario_reg,
						djs.id_usuario_ai,
						djs.fecha_mod,
						djs.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        djs.estado	
						from conta.tdeclaraciones_juridicas djs
						inner join segu.tusuario usu1 on usu1.id_usuario = djs.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = djs.id_usuario_mod
				        where';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			raise notice '->>> %',v_consulta;
			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_DJS_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		m.mamani	
 	#FECHA:		27-08-2018 14:51:02
	***********************************/

	elsif(p_transaccion='CONTA_DJS_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_declaracion_juridica)
					    from conta.tdeclaraciones_juridicas djs
					    inner join segu.tusuario usu1 on usu1.id_usuario = djs.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = djs.id_usuario_mod
					    where ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
    
    /*********************************    
 	#TRANSACCION:  'CONTA_DJS_COM'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		m.mamani	
 	#FECHA:		27-08-2018 14:51:02
	***********************************/
    elsif(p_transaccion='CONTA_DJS_COM')then

		begin
        
			v_consulta:='select cd.codigo,
             					cd.descripcion,
                                cd.fila   
                                from conta.tcodigo_declaracion_juridiico cd 
                                where ';
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			raise notice '->>> %',v_consulta;
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