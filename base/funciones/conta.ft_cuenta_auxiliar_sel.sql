--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_cuenta_auxiliar_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_cuenta_auxiliar_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tcuenta_auxiliar'
 AUTOR: 		 (admin)
 FECHA:	        11-07-2013 20:37:00
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

	v_nombre_funcion = 'conta.ft_cuenta_auxiliar_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_CAX_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		11-07-2013 20:37:00
	***********************************/

	if(p_transaccion='CONTA_CAX_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						cax.id_cuenta_auxiliar,
						cax.estado_reg,
						cax.id_auxiliar,
						cax.id_cuenta,
						cax.id_usuario_reg,
						cax.fecha_reg,
						cax.id_usuario_mod,
						cax.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        aux.codigo_auxiliar,
                        aux.nombre_auxiliar
						from conta.tcuenta_auxiliar cax
						inner join segu.tusuario usu1 on usu1.id_usuario = cax.id_usuario_reg
                        inner join conta.tauxiliar aux on cax.id_auxiliar = aux.id_auxiliar
						left join segu.tusuario usu2 on usu2.id_usuario = cax.id_usuario_mod
                        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CAX_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		11-07-2013 20:37:00
	***********************************/

	elsif(p_transaccion='CONTA_CAX_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_cuenta_auxiliar)
					    from conta.tcuenta_auxiliar cax
						inner join segu.tusuario usu1 on usu1.id_usuario = cax.id_usuario_reg
                        inner join conta.tauxiliar aux on cax.id_auxiliar = aux.id_auxiliar
						left join segu.tusuario usu2 on usu2.id_usuario = cax.id_usuario_mod
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