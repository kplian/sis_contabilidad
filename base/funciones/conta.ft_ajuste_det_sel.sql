--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_ajuste_det_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_ajuste_det_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tajuste_det'
 AUTOR: 		 (admin)
 FECHA:	        10-12-2015 15:16:44
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

	v_nombre_funcion = 'conta.ft_ajuste_det_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_AJTD_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		10-12-2015 15:16:44
	***********************************/

	if(p_transaccion='CONTA_AJTD_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
                            ajtd.id_ajuste_det,
                            ajtd.mayor_mb,
                            ajtd.tipo_cambio_1,
                            ajtd.tipo_cambio_2,
                            ajtd.mayor,
                            ajtd.mayor_mt,
                            ajtd.dif_mb,
                            ajtd.act_mb,
                            ajtd.estado_reg,
                            ajtd.id_ajuste,
                            ajtd.dif_mt,
                            ajtd.act_mt,
                            ajtd.id_cuenta,
                            ajtd.id_usuario_ai,
                            ajtd.id_usuario_reg,
                            ajtd.fecha_reg,
                            ajtd.usuario_ai,
                            ajtd.id_usuario_mod,
                            ajtd.fecha_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                            c.nro_cuenta,
                            c.nombre_cuenta,
                            c.id_moneda as id_moneda_cuenta,
                            m.codigo as codigo_moneda,
                            ajtd.revisado,
                            ajtd.dif_manual,
                            ''(''||a.codigo_auxiliar||'') ''||a.nombre_auxiliar as desc_auxiliar,
                            ''(''||cb.nro_cuenta||'') ''||cb.denominacion as desc_cuenta_bancaria,
                            ''(''|| pin.codigo||'') ''||pin.nombre_partida as desc_partida_ingreso,       
                            ''(''|| peg.codigo||'') ''||peg.nombre_partida as desc_partida_egreso,
                             ajtd.id_moneda_ajuste
                          
                    from conta.tajuste_det ajtd
                         inner join segu.tusuario usu1 on usu1.id_usuario = ajtd.id_usuario_reg
                         inner join conta.tcuenta c on c.id_cuenta = ajtd.id_cuenta
                         inner join param.tmoneda m on m.id_moneda = ajtd.id_moneda_ajuste
                       
                         LEFT join pre.tpartida  pin on pin.id_partida = ajtd.id_partida_ingreso
                         LEFT join pre.tpartida  peg on peg.id_partida = ajtd.id_partida_egreso
                         left join tes.tcuenta_bancaria cb on cb.id_cuenta_bancaria = ajtd.id_cuenta_bancaria
                         left join conta.tauxiliar a on a.id_auxiliar = ajtd.id_auxiliar
                         left join segu.tusuario usu2 on usu2.id_usuario = ajtd.id_usuario_mod
                    WHERE  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_AJTD_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		10-12-2015 15:16:44
	***********************************/

	elsif(p_transaccion='CONTA_AJTD_CONT')then

		begin
			
            -- Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_ajuste_det)
                         from conta.tajuste_det ajtd
                         inner join segu.tusuario usu1 on usu1.id_usuario = ajtd.id_usuario_reg
                         inner join conta.tcuenta c on c.id_cuenta = ajtd.id_cuenta
                         inner join param.tmoneda m on m.id_moneda = ajtd.id_moneda_ajuste
                       
                         LEFT join pre.tpartida  pin on pin.id_partida = ajtd.id_partida_ingreso
                         LEFT join pre.tpartida  peg on peg.id_partida = ajtd.id_partida_egreso
                         left join tes.tcuenta_bancaria cb on cb.id_cuenta_bancaria = ajtd.id_cuenta_bancaria
                         left join conta.tauxiliar a on a.id_auxiliar = ajtd.id_auxiliar
                         left join segu.tusuario usu2 on usu2.id_usuario = ajtd.id_usuario_mod
                    WHERE  ';
			
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