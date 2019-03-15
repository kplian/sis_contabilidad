CREATE OR REPLACE FUNCTION conta.ft_plantilla_det_reporte_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_plantilla_det_reporte_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tplantilla_det_reporte'
 AUTOR: 		 (m.mamani)
 FECHA:	        06-09-2018 20:33:59
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				06-09-2018 20:33:59								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tplantilla_det_reporte'
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
    v_gestion 			varchar;
    v_id_gestion		integer;

BEGIN

	v_nombre_funcion = 'conta.ft_plantilla_det_reporte_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'CONTA_PDR_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		m.mamani
 	#FECHA:		06-09-2018 20:33:59
	***********************************/

	if(p_transaccion='CONTA_PDR_SEL')then

    	begin
        v_gestion =  (EXTRACT(YEAR FROM  now()))::varchar;
              select
               ges.id_gestion
              into
               v_id_gestion
              from param.tgestion ges
              where ges.gestion::varchar  = v_gestion and ges.estado_reg = 'activo';

              IF v_id_gestion is null THEN
                 raise exception 'No se encontro gestion para la fecha %', now()::Date;
              END IF;
    		--Sentencia de la consulta
			v_consulta:='select
						pdr.id_plantilla_det_reporte,
						pdr.origen,
						pdr.estado_reg,
						pdr.concepto,
						pdr.codigo_columna,
						pdr.columna,
						pdr.order_fila,
						pdr.id_plantilla_reporte,
						pdr.formula,
						pdr.partida,
						pdr.usuario_ai,
						pdr.fecha_reg,
						pdr.id_usuario_reg,
						pdr.id_usuario_ai,
						pdr.id_usuario_mod,
						pdr.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        COALESCE(cue.nombre_cuenta,''S/C'')::varchar as desc_cuenta,
                        par.nombre_partida as desc_partida,
                        pdr.nombre_columna,
                        pdr.saldo_inical,
                        pdr.formulario,
                        pdr.codigo_formulario,
                        pdr.saldo_anterior,
                        pdr.operacion,
                        pdr.apertura_cb,
                        pdr.cierre_cb,
                        pdr.tipo_periodo
						from conta.tplantilla_det_reporte pdr
						inner join segu.tusuario usu1 on usu1.id_usuario = pdr.id_usuario_reg
                        left join conta.tcuenta cue on cue.estado_reg = ''activo'' and cue.nro_cuenta = pdr.concepto and cue.id_gestion = '||v_id_gestion::varchar||' 
                        left join pre.tpartida par on par.estado_reg = ''activo'' and par.codigo = pdr.partida and par.id_gestion = '||v_id_gestion::varchar||' 
						left join segu.tusuario usu2 on usu2.id_usuario = pdr.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_PDR_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		m.mamani	
 	#FECHA:		06-09-2018 20:33:59
	***********************************/

	elsif(p_transaccion='CONTA_PDR_CONT')then

		begin
         v_gestion =  (EXTRACT(YEAR FROM  now()))::varchar;
              select 
               ges.id_gestion
              into
               v_id_gestion
              from param.tgestion ges 
              where ges.gestion::varchar  = v_gestion and ges.estado_reg = 'activo';
                
              IF v_id_gestion is null THEN
                 raise exception 'No se encontro gestion para la fecha %', now()::Date;
              END IF;
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(pdr.id_plantilla_det_reporte)
					    from conta.tplantilla_det_reporte pdr
					    inner join segu.tusuario usu1 on usu1.id_usuario = pdr.id_usuario_reg
                        left join conta.tcuenta cue on cue.estado_reg = ''activo'' and cue.nro_cuenta = pdr.concepto and cue.id_gestion = '||v_id_gestion::varchar||' 
                        left join pre.tpartida par on par.estado_reg = ''activo'' and par.codigo = pdr.partida and par.id_gestion = '||v_id_gestion::varchar||' 
						left join segu.tusuario usu2 on usu2.id_usuario = pdr.id_usuario_mod
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