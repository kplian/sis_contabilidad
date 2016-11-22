--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_entrega_det_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_entrega_det_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tentrega_det'
 AUTOR: 		 (admin)
 FECHA:	        17-11-2016 19:50:46
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

	v_nombre_funcion = 'conta.ft_entrega_det_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_END_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		17-11-2016 19:50:46
	***********************************/

	if(p_transaccion='CONTA_END_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
                                  ende.id_entrega_det,
                                  ende.estado_reg,
                                  ende.id_int_comprobante,
                                  ende.id_entrega,
                                  ende.id_usuario_reg,
                                  ende.fecha_reg,
                                  ende.usuario_ai,
                                  ende.id_usuario_ai,
                                  ende.id_usuario_mod,
                                  ende.fecha_mod,
                                  usu1.cuenta as usr_reg,
                                  usu2.cuenta as usr_mod,
                                  cbte.nro_cbte::varchar,
                                  cbte.nro_tramite::varchar,
                                  cbte.beneficiario::varchar,
                                  cbte.desc_clase_comprobante::varchar,
                                  cbte.glosa1::varchar
                              from conta.tentrega_det ende
                              inner join conta.vint_comprobante cbte on cbte.id_int_comprobante = ende.id_int_comprobante
                              inner join segu.tusuario usu1 on usu1.id_usuario = ende.id_usuario_reg
                              left join segu.tusuario usu2 on usu2.id_usuario = ende.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            RAISE NOTICE '%',v_consulta;
			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_END_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		17-11-2016 19:50:46
	***********************************/

	elsif(p_transaccion='CONTA_END_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_entrega_det)
					          from conta.tentrega_det ende
                              inner join conta.vint_comprobante cbte on cbte.id_int_comprobante = ende.id_int_comprobante
                              inner join segu.tusuario usu1 on usu1.id_usuario = ende.id_usuario_reg
                              left join segu.tusuario usu2 on usu2.id_usuario = ende.id_usuario_mod
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