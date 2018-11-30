--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_tipo_cc_ot_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_tipo_cc_ot_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.ttipo_cc_ot'
 AUTOR: 		 (admin)
 FECHA:	        31-05-2017 22:07:39
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
    v_ordenes_trabajo	varchar;
			    
BEGIN

	v_nombre_funcion = 'conta.ft_tipo_cc_ot_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_FTO_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		31-05-2017 22:07:39
	***********************************/

	if(p_transaccion='CONTA_FTO_SEL')then
     				
    	begin
             
           --recueprar los padres de la rama
           WITH RECURSIVE orden(id_orden_trabajo, id_orden_trabajo_padre) AS (
              select 
                c.id_orden_trabajo,
                c.id_orden_trabajo_fk
              from conta.torden_trabajo c  
              where      c.id_orden_trabajo = v_parametros.id_orden_trabajo 
                     and c.estado_reg = 'activo' 
              UNION
              SELECT
               c2.id_orden_trabajo,
               c2.id_orden_trabajo_fk
              FROM conta.torden_trabajo c2, orden pc
              WHERE c2.id_orden_trabajo = pc.id_orden_trabajo_padre  and c2.estado_reg = 'activo'
           )
              SELECT 
                 pxp.list(id_orden_trabajo::varchar)
              into
                v_ordenes_trabajo 
              FROM orden;
           
            v_ordenes_trabajo = COALESCE(v_ordenes_trabajo, '0');
            
        
    		--Sentencia de la consulta
			v_consulta:='select 
            					 fto.id_tipo_cc_ot,
                                 fto.id_orden_trabajo,
                                 fto.estado_reg,
                                 fto.id_tipo_cc,
                                 fto.id_usuario_ai,
                                 fto.id_usuario_reg,
                                 fto.usuario_ai,
                                 fto.fecha_reg,
                                 fto.id_usuario_mod,
                                 fto.fecha_mod,
                                 usu1.cuenta as usr_reg,
                                 usu2.cuenta as usr_mod,
                                 (tcc.codigo||'' ''|| tcc.descripcion)::varchar as desc_tcc,
                                  (
                                          CASE WHEN fto.id_orden_trabajo = '||v_parametros.id_orden_trabajo||'  
                                              THEN  
                                                 ''directo''
                                              ELSE
                                                ''indirecto''
                                              END)::varchar as tipo_reg
                          from conta.ttipo_cc_ot fto
                               inner join segu.tusuario usu1 on usu1.id_usuario = fto.id_usuario_reg
                               inner join param.ttipo_cc tcc  on tcc.id_tipo_cc = fto.id_tipo_cc
                               left join segu.tusuario usu2 on usu2.id_usuario = fto.id_usuario_mod
                               where  fto.id_orden_trabajo in ('||v_ordenes_trabajo||') and ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_FTO_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		31-05-2017 22:07:39
	***********************************/

	elsif(p_transaccion='CONTA_FTO_CONT')then

		begin
        
        --recueprar los padres de la rama
           WITH RECURSIVE orden(id_orden_trabajo, id_orden_trabajo_padre) AS (
              select 
                c.id_orden_trabajo,
                c.id_orden_trabajo_fk
              from conta.torden_trabajo c  
              where      c.id_orden_trabajo = v_parametros.id_orden_trabajo 
                     and c.estado_reg = 'activo' 
              UNION
              SELECT
               c2.id_orden_trabajo,
               c2.id_orden_trabajo_fk
              FROM conta.torden_trabajo c2, orden pc
              WHERE c2.id_orden_trabajo = pc.id_orden_trabajo_padre  and c2.estado_reg = 'activo'
           )
              SELECT 
                 pxp.list(id_orden_trabajo::varchar)
              into
                v_ordenes_trabajo 
              FROM orden;
           
            v_ordenes_trabajo = COALESCE(v_ordenes_trabajo, '0');
            
            
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_tipo_cc_ot)
					     from conta.ttipo_cc_ot fto
                           inner join segu.tusuario usu1 on usu1.id_usuario = fto.id_usuario_reg
                           inner join param.ttipo_cc tcc  on tcc.id_tipo_cc = fto.id_tipo_cc
                           left join segu.tusuario usu2 on usu2.id_usuario = fto.id_usuario_mod
                           where  fto.id_orden_trabajo in ('||v_ordenes_trabajo||') and ';
			
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