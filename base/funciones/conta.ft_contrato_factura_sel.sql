--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_contrato_factura_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_contrato_factura_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tcontrato_factura'
 AUTOR: 		 (m.mamani)
 FECHA:	        19-09-2018 13:16:55
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				19-09-2018 13:16:55								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tcontrato_factura'	
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
			    
BEGIN

	v_nombre_funcion = 'conta.ft_contrato_factura_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_CCF_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		m.mamani	
 	#FECHA:		19-09-2018 13:16:55
	***********************************/

	if(p_transaccion='CONTA_CCF_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select  co.id_contrato,
                                co.id_gestion,
                                pw.id_proceso_wf,
                                pw.nro_tramite,
                                co.tipo,
                                co.objeto,
                                pr.desc_proveedor,
                                co.bancarizacion,
                                co.fecha_inicio,
                                co.fecha_fin,
                                fun.desc_funcionario1 as desc_funcionario,
                                co.numero as numero_contrato,
                                 pr.codigo as codigo_aux
                        from leg.tcontrato co
                        inner join wf.tproceso_wf pw on pw.id_proceso_wf = co.id_proceso_wf
                        inner join param.vproveedor pr on pr.id_proveedor = co.id_proveedor
                        inner join orga.vfuncionario fun on fun.id_funcionario = co.id_funcionario
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CCF_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		m.mamani	
 	#FECHA:		19-09-2018 13:16:55
	***********************************/

	elsif(p_transaccion='CONTA_CCF_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select  count (co.id_contrato)
                                  from leg.tcontrato co
                                  inner join wf.tproceso_wf pw on pw.id_proceso_wf = co.id_proceso_wf
                        inner join param.vproveedor pr on pr.id_proveedor = co.id_proveedor
                        inner join orga.vfuncionario fun on fun.id_funcionario = co.id_funcionario
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