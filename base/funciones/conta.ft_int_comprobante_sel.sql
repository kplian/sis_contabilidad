--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_int_comprobante_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_int_comprobante_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tint_comprobante'
 AUTOR: 		 (admin)
 FECHA:	        29-08-2013 00:28:30
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
    v_id_moneda_base	integer;
			    
BEGIN

	v_nombre_funcion = 'conta.ft_int_comprobante_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_INCBTE_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		29-08-2013 00:28:30
	***********************************/
    if(p_transaccion='CONTA_INCBTE_SEL') then
     				
    	begin
        
            v_id_moneda_base=param.f_get_moneda_base();
    		--Sentencia de la consulta
			v_consulta := 'select
                            incbte.id_int_comprobante,
                            incbte.id_clase_comprobante,
                            incbte.id_subsistema,
                            incbte.id_depto,
                            incbte.id_moneda,
                            incbte.id_periodo,
                            incbte.id_funcionario_firma1,
                            incbte.id_funcionario_firma2,
                            incbte.id_funcionario_firma3,
                            incbte.tipo_cambio,
                            incbte.beneficiario,
                            incbte.nro_cbte,
                            incbte.estado_reg,
                            incbte.glosa1,
                            incbte.fecha,
                            incbte.glosa2,
                            incbte.nro_tramite,
                            incbte.momento,
                            incbte.id_usuario_reg,
                            incbte.fecha_reg,
                            incbte.id_usuario_mod,
                            incbte.fecha_mod,
                            incbte.usr_reg,
                            incbte.usr_mod,
                            incbte.desc_clase_comprobante,
                            incbte.desc_subsistema,
                            incbte.desc_depto,	
                            incbte.desc_moneda,
                            incbte.desc_firma1,
                            incbte.desc_firma2,
                            incbte.desc_firma3,
                            incbte.momento_comprometido,
                            incbte.momento_ejecutado,
                            incbte.momento_pagado,
                            incbte.manual,
                            incbte.id_int_comprobante_fks,
                            incbte.id_tipo_relacion_comprobante,
                            incbte.desc_tipo_relacion_comprobante,
                            '||v_id_moneda_base::VARCHAR||'::integer as id_moneda_base
                          
                          from conta.vint_comprobante incbte
                          
                          where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            
			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_INCBTE_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		29-08-2013 00:28:30
	***********************************/

	elsif(p_transaccion='CONTA_INCBTE_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_int_comprobante)
					     from conta.vint_comprobante incbte
					     where ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
        
    /*********************************    
 	#TRANSACCION:  'CONTA_ICSIM_SEL'
 	#DESCRIPCION:	Consulta simplificada de comprobantes intermedios
 	#AUTOR:		rac	
 	#FECHA:		29-12-2014 00:28:30
	***********************************/
    elseif(p_transaccion='CONTA_ICSIM_SEL') then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta :=  'select inc.id_int_comprobante,
                                   inc.nro_cbte,
                                   inc.nro_tramite,
                                   inc.fecha,
                                   inc.glosa1,
                                   inc.glosa2,
                                   cc.id_clase_comprobante,
                                   cc.codigo,
                                   cc.descripcion
                                   
                            from conta.tint_comprobante inc
                            inner join conta.tclase_comprobante cc on cc.id_clase_comprobante = inc.id_clase_comprobante
                            where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            
			--Devuelve la respuesta
			return v_consulta;
						
		end;    
	
    /*********************************    
 	#TRANSACCION:  'CONTA_ICSIM_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		29-08-2013 00:28:30
	***********************************/

	elsif(p_transaccion='CONTA_ICSIM_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_int_comprobante)
			             from conta.tint_comprobante inc
                         inner join conta.tclase_comprobante cc on cc.id_clase_comprobante = inc.id_clase_comprobante
                         where ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
    
    	
	/*********************************    
 	#TRANSACCION:  'CONTA_CABCBT_SEL'
 	#DESCRIPCION:	Cabecera para el reporte de Comprobante
 	#AUTOR:			RCM	
 	#FECHA:			10/09/2013
	***********************************/

	elsif(p_transaccion='CONTA_CABCBT_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						depto.codigo as cod_depto, incbte.nro_cbte, incbte.fecha, incbte.beneficiario,
						incbte.glosa1, incbte.glosa2, incbte.tipo_cambio,
						fun1.desc_funcionario1 as firma1, fun2.desc_funcionario1 as firma2, fun3.desc_funcionario1 as firma3,
						fun1.nombre_cargo as firma1_cargo, fun2.nombre_cargo as firma2_cargo, fun3.nombre_cargo as firma3_cargo
						from conta.tint_comprobante incbte
						inner join param.tdepto depto on depto.id_depto = incbte.id_depto
						left join orga.vfuncionario_cargo fun1 on fun1.id_funcionario = incbte.id_funcionario_firma1
						left join orga.vfuncionario_cargo fun2 on fun2.id_funcionario = incbte.id_funcionario_firma2
						left join orga.vfuncionario_cargo fun3 on fun3.id_funcionario = incbte.id_funcionario_firma3
						where incbte.id_int_comprobante = '||v_parametros.id_int_comprobante;
			
			--Devuelve la respuesta
			return v_consulta;
						
		end;
		
	/*********************************    
 	#TRANSACCION:  'CONTA_DETCBT_SEL'
 	#DESCRIPCION:	Cabecera para el reporte de Comprobante
 	#AUTOR:			RCM	
 	#FECHA:			10/09/2013
	***********************************/

	elsif(p_transaccion='CONTA_DETCBT_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						cue.nro_cuenta || '' - '' || cue.nombre_cuenta as cuenta,
						aux.codigo_auxiliar || '' '' || aux.nombre_auxiliar as auxiliar,
						cc.codigo_cc as cc,
						par.codigo || '' -'' || par.nombre_partida as partida,
						tra.importe_debe, tra.importe_haber,
						param.f_convertir_moneda(cbte.id_moneda,2,tra.importe_debe,cbte.fecha,''O'',2) as importe_debe1,
						param.f_convertir_moneda(cbte.id_moneda,2,tra.importe_haber,cbte.fecha,''O'',2) as importe_haber1
						from conta.tint_transaccion tra
						inner join conta.tint_comprobante cbte on cbte.id_int_comprobante = tra.id_int_comprobante
						inner join conta.tcuenta cue on cue.id_cuenta = tra.id_cuenta
						left join conta.tauxiliar aux on aux.id_auxiliar = tra.id_auxiliar
						inner join param.vcentro_costo cc on cc.id_centro_costo = tra.id_centro_costo
						inner join pre.tpartida par on par.id_partida = tra.id_partida
						where tra.id_int_comprobante = '||v_parametros.id_int_comprobante;
			
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