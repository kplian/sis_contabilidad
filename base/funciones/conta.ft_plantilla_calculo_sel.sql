--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_plantilla_calculo_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_plantilla_calculo_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tplantilla_calculo'
 AUTOR: 		 (admin)
 FECHA:	        28-08-2013 19:01:20
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

	v_nombre_funcion = 'conta.ft_plantilla_calculo_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_PLACAL_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		28-08-2013 19:01:20
	***********************************/

	if(p_transaccion='CONTA_PLACAL_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						placal.id_plantilla_calculo,
						placal.prioridad,
						placal.debe_haber,
						placal.tipo_importe,
						placal.id_plantilla,
						placal.codigo_tipo_relacion,
						placal.importe,
						placal.descripcion,
						placal.estado_reg,
						placal.id_usuario_reg,
						placal.fecha_reg,
						placal.fecha_mod,
						placal.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						placal.importe_presupuesto,
						placal.descuento	
						from conta.tplantilla_calculo placal
						inner join segu.tusuario usu1 on usu1.id_usuario = placal.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = placal.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_PLACAL_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		28-08-2013 19:01:20
	***********************************/

	elsif(p_transaccion='CONTA_PLACAL_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_plantilla_calculo)
					    from conta.tplantilla_calculo placal
					    inner join segu.tusuario usu1 on usu1.id_usuario = placal.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = placal.id_usuario_mod
					    where ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
        
    /*********************************    
 	#TRANSACCION:  'CONTA_EXPLAN_SEL'
 	#DESCRIPCION:	datos para exportar plantilla
 	#FECHA:		10-02-2016 19:01:20
	***********************************/

	elsif(p_transaccion='CONTA_EXPLAN_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
                            ''plantilla''::varchar as tipo_reg,
                            plt.id_plantilla,
                            plt.estado_reg,
                            plt.desc_plantilla,
                            plt.sw_tesoro,
                            plt.sw_compro,
                            plt.nro_linea,
                            plt.tipo,
                            plt.fecha_reg,
                            plt.id_usuario_reg,
                            plt.fecha_mod,
                            plt.id_usuario_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                            plt.sw_monto_excento,
                            plt.sw_descuento ,
                            plt.sw_autorizacion,
                            plt.sw_codigo_control,
                            plt.tipo_plantilla,
                            plt.sw_ic,
                            plt.sw_nro_dui,
                            plt.tipo_excento,
            			    plt.valor_excento,
                            plt.tipo_informe
						from param.tplantilla plt
						inner join segu.tusuario usu1 on usu1.id_usuario = plt.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = plt.id_usuario_mod
				        where   plt.id_plantilla = '||v_parametros.id_plantilla;
			
			
			
			--Devuelve la respuesta
			return v_consulta;
						
		end;    
	 /*********************************    
 	#TRANSACCION:  'CONTA_EXPLCAL_SEL'
 	#DESCRIPCION:	datos para exportar plantilla de calculo
 	#FECHA:		10-02-2016 19:01:20
	***********************************/

	elsif(p_transaccion='CONTA_EXPLCAL_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
                           ''plantilla_calculo''::varchar as tipo_reg,
                            placal.id_plantilla_calculo,
                            placal.prioridad,
                            placal.debe_haber,
                            placal.tipo_importe,
                            placal.id_plantilla,
                            placal.codigo_tipo_relacion,
                            placal.importe,
                            placal.descripcion,
                            placal.estado_reg,
                            placal.id_usuario_reg,
                            placal.fecha_reg,
                            placal.fecha_mod,
                            placal.id_usuario_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                            placal.importe_presupuesto,
                            placal.descuento,
                            plt.desc_plantilla	
						from conta.tplantilla_calculo placal
                        inner join param.tplantilla plt on plt.id_plantilla = placal.id_plantilla
						inner join segu.tusuario usu1 on usu1.id_usuario = placal.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = placal.id_usuario_mod
				        where  placal.id_plantilla = '||v_parametros.id_plantilla;
			
			
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