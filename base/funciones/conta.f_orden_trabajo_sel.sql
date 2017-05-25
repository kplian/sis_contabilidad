--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_orden_trabajo_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.f_orden_trabajo_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.torden_trabajo'
 AUTOR: 		Gonzalo Sarmiento Sejas
 FECHA:	        21-02-2013 21:08:55
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
    v_where			varchar;
			    
BEGIN

	v_nombre_funcion = 'conta.f_orden_trabajo_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_ODT_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		21-02-2013 21:08:55
	***********************************/

	if(p_transaccion='CONTA_ODT_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
                          id_orden_trabajo,
                          estado_reg,
                          fecha_final,
                          fecha_inicio,
                          desc_orden,
                          motivo_orden,
                          fecha_reg,
                          id_usuario_reg,
                          id_usuario_mod,
                          fecha_mod,
                          usr_reg,
                          usr_mod,
                          tipo,
                          movimiento,
                          codigo,
                          descripcion::varchar,
                          id_orden_trabajo_fk
                        
						from conta.vorden_trabajo odt
				        where  movimiento = ''si'' and tipo in (''estadistica'',''centro'',''pep'',''orden'') and ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            raise notice '%',v_consulta;
			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_ODT_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		21-02-2013 21:08:55
	***********************************/

	elsif(p_transaccion='CONTA_ODT_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_orden_trabajo)
					     from conta.vorden_trabajo odt
				         where  movimiento = ''si'' and tipo in (''estadistica'',''centro'',''pep'',''orden'') and ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
        
     
    /*********************************    
 	#TRANSACCION:  'CONTA_ODTALL_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		RAC KPLIAN
 	#FECHA:		16-05-2017 21:08:55
	***********************************/

	elseif(p_transaccion='CONTA_ODTALL_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
                          id_orden_trabajo,
                          estado_reg,
                          fecha_final,
                          fecha_inicio,
                          desc_orden,
                          motivo_orden,
                          fecha_reg,
                          id_usuario_reg,
                          id_usuario_mod,
                          fecha_mod,
                          usr_reg,
                          usr_mod,
                          tipo,
                          movimiento,
                          codigo,
                          descripcion::varchar,
                          id_orden_trabajo_fk
                        
						from conta.vorden_trabajo odt
				        where   ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            raise notice '%',v_consulta;
			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_ODTALL_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		RAC KPLIAN
 	#FECHA:		16-05-2017 21:08:55
	***********************************/

	elsif(p_transaccion='CONTA_ODTALL_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_orden_trabajo)
					     from conta.vorden_trabajo odt
				         where  ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;   
        
        
        
    /*********************************   
     #TRANSACCION:  'CONTA_ODTARB_SEL'
     #DESCRIPCION:    Consulta de ordenes en formato arbol
     #AUTOR:            Rensi Arteaga
     #FECHA:            12-05-2017
    ***********************************/

    elseif(p_transaccion='CONTA_ODTARB_SEL')then
                    
        begin       
              if(v_parametros.node = 'id') then
                v_where := ' odt.id_orden_trabajo_fk is NULL and movimiento = ''no'' ';   
                     
              else
                v_where := ' odt.id_orden_trabajo_fk = '||v_parametros.node;
              end if;
       
       
            --Sentencia de la consulta
            v_consulta:='select
                          id_orden_trabajo,
                          estado_reg,
                          fecha_final,
                          fecha_inicio,
                          desc_orden,
                          motivo_orden,
                          fecha_reg,
                          id_usuario_reg,
                          id_usuario_mod,
                          fecha_mod,
                          usr_reg,
                          usr_mod,
                          tipo,
                          movimiento,
                          codigo,
                          case
                          when (odt.movimiento=''si'' )then
                               ''hoja''::varchar
                          when (odt.movimiento=''no'' )then
                               ''hijo''::varchar
                          END as tipo_nodo,
                          id_orden_trabajo_fk
                        
						from conta.vorden_trabajo odt                          
                        where  '||v_where|| ' 
                           and odt.estado_reg = ''activo''
                        ORDER BY odt.id_orden_trabajo';
            raise notice '%',v_consulta;
           
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