--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_clase_comprobante_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_clase_comprobante_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tclase_comprobante'
 AUTOR: 		 (admin)
 FECHA:	        27-05-2013 16:07:00
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

	v_nombre_funcion = 'conta.ft_clase_comprobante_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_CCOM_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		27-05-2013 16:07:00
	***********************************/

	if(p_transaccion='CONTA_CCOM_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						ccom.id_clase_comprobante,
						ccom.id_documento,
						ccom.tipo_comprobante,
						ccom.descripcion,
						ccom.estado_reg,
						ccom.id_usuario_reg,
						ccom.fecha_reg,
						ccom.fecha_mod,
						ccom.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        ''(''||doc.codigo||'') ''|| doc.descripcion as desc_doc,
                        ccom.momento_comprometido,
                        ccom.momento_ejecutado,
                        ccom.momento_pagado,
                        ccom.codigo,
                        ccom.tiene_apertura,
                        ccom.movimiento
						from conta.tclase_comprobante ccom
                        inner join param.tdocumento doc on ccom.id_documento = doc.id_documento
						inner join segu.tusuario usu1 on usu1.id_usuario = ccom.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = ccom.id_usuario_mod
                        WHERE  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CCOM_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		27-05-2013 16:07:00
	***********************************/

	elsif(p_transaccion='CONTA_CCOM_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_clase_comprobante)
					    from conta.tclase_comprobante ccom
					    inner join segu.tusuario usu1 on usu1.id_usuario = ccom.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = ccom.id_usuario_mod
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