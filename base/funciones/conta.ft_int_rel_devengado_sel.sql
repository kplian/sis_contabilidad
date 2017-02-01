--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_int_rel_devengado_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_int_rel_devengado_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tint_rel_devengado'
 AUTOR: 		 (admin)
 FECHA:	        09-10-2015 12:31:01
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

	v_nombre_funcion = 'conta.ft_int_rel_devengado_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_RDE_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		09-10-2015 12:31:01
	***********************************/

	if(p_transaccion='CONTA_RDE_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='SELECT 
                            id_int_rel_devengado,
                            id_int_transaccion_pag,
                            id_int_transaccion_dev,
                            monto_pago,
                            id_partida_ejecucion_pag,
                            monto_pago_mb,
                            estado_reg,
                            id_usuario_ai,
                            fecha_reg,
                            usuario_ai,
                            id_usuario_reg,
                            fecha_mod,
                            id_usuario_mod,
                            usr_reg,
                            usr_mod,
                            nro_cbte_dev,
                            desc_cuenta_dev,
                            desc_partida_dev,
                            desc_centro_costo_dev,
                            desc_orden_dev,
                            importe_debe_dev,
                            importe_haber_dev,
                            desc_cuenta_pag,
                            desc_partida_pag,
                            desc_centro_costo_pag,
                            desc_orden_pag,
                            importe_debe_pag,
                            importe_haber_pag,
                            id_cuenta_dev,
                            id_orden_trabajo_dev,
                            id_auxiliar_dev,
                            id_centro_costo_dev,
                            id_cuenta_pag,
                            id_orden_trabajo_pag,
                            id_auxiliar_pag,
                            id_centro_costo_pag,
                            id_int_comprobante_pago,
   							id_int_comprobante_dev,
                            tipo_partida_dev,
    						tipo_partida_pag,
                            desc_auxiliar_dev,
                            desc_auxiliar_pag,
                            importe_gasto_pag,
                            importe_recurso_pag,
                            importe_gasto_dev,
                            importe_recurso_dev
                          FROM 
                            conta.vint_rel_devengado
                          where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_RDE_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		09-10-2015 12:31:01
	***********************************/

	elsif(p_transaccion='CONTA_RDE_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='SELECT count(id_int_rel_devengado)
					     FROM 
                            conta.vint_rel_devengado
                         WHERE ';
			
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