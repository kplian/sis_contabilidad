--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_rango_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_rango_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.trango'
 AUTOR: 		 (admin)
 FECHA:	        22-06-2017 21:30:05
 COMENTARIOS:
***************************************************************************

 HISTORIAL DE MODIFICACIONES:
 ISSUE 		   FECHA   			 AUTOR				 DESCRIPCION:
  #62 		 18/06/2019		  Manuel Guerra  corrección bug, agregación de campo sumatoria
   #62 		 18/06/2019		  Manuel Guerra  corrección bug, agregación de campo sumatoria
   #75		 28/11/2019		  Manuel Guerra  controlling
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
    v_where				varchar;
    va_id_periodo		integer[];
    v_filtro			varchar;
    v_periodo			varchar;
	v_nivel_inical		integer;
	v_registros			record;
BEGIN

	v_nombre_funcion = 'conta.ft_rango_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'CONTA_RAN_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		rac	 #62
 	#FECHA:		22-06-2017 21:30:05
	***********************************/

	if(p_transaccion='CONTA_RAN_SEL')then

    	begin
            v_filtro = ' 0=0 ';
       --  raise exception '%',v_parametros.id_tipo_cc;
            IF pxp.f_existe_parametro(p_tabla,'desde') and pxp.f_existe_parametro(p_tabla,'hasta') THEN
                SELECT
                pxp.list(per.id_periodo::Varchar)
                INTO
                v_periodo
                FROM param.tperiodo per
                WHERE v_parametros.desde BETWEEN per.fecha_ini and per.fecha_fin
                      OR v_parametros.hasta BETWEEN per.fecha_ini and per.fecha_fin
                      OR per.fecha_fin BETWEEN v_parametros.desde and v_parametros.hasta;
                v_filtro = ' ran.id_periodo in ('||COALESCE(v_periodo,'0')||')';
            END IF;

            IF v_parametros.categoria = 'periodo' THEN
                --Sentencia de la consulta
                v_consulta:='select
                            ran.id_rango,
                            ran.id_periodo,
                            ran.debe_mb,
                            ran.haber_mb,
                            ran.debe_mt,
                            ran.haber_mt,
                            ran.estado_reg,
                            ran.id_tipo_cc,
                            ran.id_usuario_ai,
                            ran.usuario_ai,
                            ran.fecha_reg,
                            ran.id_usuario_reg,
                            ran.id_usuario_mod,
                            ran.fecha_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                            per.periodo,
                            ges.gestion,
                            per.fecha_ini,
                            per.fecha_fin,
                            tcc.codigo as desc_tipo_cc,
                            ran.memoria,
                            ran.formulado,
                            ran.comprometido,
                            ran.ejecutado,
                           (ran.debe_mb - ran.haber_mb) as balance_mb,
                           (ran.formulado-ran.comprometido) as disponible_mb,
                           ges.id_gestion
                           from conta.trango ran
                           inner join param.ttipo_cc tcc on tcc.id_tipo_cc = ran.id_tipo_cc
                           inner join param.tperiodo per on per.id_periodo = ran.id_periodo
                           inner join param.tgestion ges on ges.id_gestion = per.id_gestion
                           inner join segu.tusuario usu1 on usu1.id_usuario = ran.id_usuario_reg
                           left join segu.tusuario usu2 on usu2.id_usuario = ran.id_usuario_mod
                    	   where '||v_filtro||' and  ';
                    	   --Definicion de la respuesta
				v_consulta:=v_consulta||v_parametros.filtro;
            ELSE

            	v_consulta:='with datos as (
                              select
                              sum(ran.debe_mb)as debe_mb,
                              sum(ran.haber_mb)as haber_mb,
                              sum(ran.debe_mt)as debe_mt,
                              sum(ran.haber_mt)as haber_mt,
                              sum(ran.memoria)as memoria,
                              sum(ran.formulado)as formulado,
                              sum(ran.comprometido)as comprometido,
                              sum(ran.ejecutado)as ejecutado,
                              sum(ran.debe_mb - ran.haber_mb) as balance_mb,
                              sum(ran.formulado-ran.comprometido) as disponible_mb,
                              ges.id_gestion
                              from conta.trango ran
                              inner join param.ttipo_cc tcc on tcc.id_tipo_cc = ran.id_tipo_cc
                              inner join param.tperiodo per on per.id_periodo = ran.id_periodo
                              inner join param.tgestion ges on ges.id_gestion = per.id_gestion
                              inner join segu.tusuario usu1 on usu1.id_usuario = ran.id_usuario_reg
                              left join segu.tusuario usu2 on usu2.id_usuario = ran.id_usuario_mod
                              where
                              '||v_filtro||' and '|| v_parametros.filtro ||'
                              GROUP BY
                              ges.id_gestion
                            )
                            select
                            ROW_NUMBER () OVER (ORDER BY ges.id_gestion)::integer as id_rango,
                            0::integer as id_periodo,
                            datos.debe_mb,
                            datos.haber_mb,
                            datos.debe_mt,
                            datos.haber_mt,
                            ''activo''::varchar as estado_reg,
                            '|| v_parametros.id_tipo_cc ||',
                            0::integer as id_usuario_ai,
                            0::varchar as usuario_ai,
                            null::timestamp as fecha_reg,
                            0::integer as id_usuario_reg,
                            0::integer as id_usuario_mod,
                            null::timestamp as fecha_mod,
                            null::varchar as usr_reg,
                            null::varchar as usr_mod,
                            0::integer as periodo,
                            ges.gestion as gestion,
                            (''01-01-''|| ges.gestion)::date as fecha_ini,
							(''31-12-''|| ges.gestion)::date as fecha_fin,
                            tcc.codigo as desc_tipo_cc,
                            datos.memoria,
                            datos.formulado,
                            datos.comprometido,
                            datos.ejecutado,
                            datos.balance_mb,
                            datos.disponible_mb,
                            datos.id_gestion
                            from datos
                            join param.tgestion ges on ges.id_gestion = datos.id_gestion
                            join param.ttipo_cc tcc on tcc.id_tipo_cc = '|| v_parametros.id_tipo_cc ||' ';
            END IF;

			v_consulta:=v_consulta||' order by ' || v_parametros.ordenacion|| ' ' ||
            									    v_parametros.dir_ordenacion || ' limit ' ||
                                                    v_parametros.cantidad || ' offset ' ||
                                                    v_parametros.puntero;
			raise notice '%',v_consulta;
            --raise exception '%',v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'CONTA_RAN_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		rac	#62
 	#FECHA:		22-06-2017 21:30:05
	***********************************/

	elsif(p_transaccion='CONTA_RAN_CONT')then

		begin
            v_filtro = ' 0=0 ';
            --si tengo fechas obtenemos los periodos correpondinetes
            if pxp.f_existe_parametro(p_tabla,'desde') and pxp.f_existe_parametro(p_tabla,'hasta') then
            	select
                pxp.list(per.id_periodo::Varchar)
                into
                v_periodo
                from param.tperiodo per
                where   v_parametros.desde BETWEEN per.fecha_ini and per.fecha_fin
                OR v_parametros.hasta BETWEEN per.fecha_ini and per.fecha_fin
                OR per.fecha_fin BETWEEN v_parametros.desde and v_parametros.hasta;
                v_filtro = ' ran.id_periodo in ('||COALESCE(v_periodo,'0')||')';
            end if;
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select  count(ran.id_rango),
                                 sum(ran.debe_mb) as debe_mb,
                                 sum(ran.haber_mb) as haber_mb,
                                 sum(ran.debe_mt) as debe_mt,
                                 sum(ran.haber_mt) as haber_mt,
                                 sum(memoria) as memoria,
                                 sum(formulado) as formulado,
                                 sum(comprometido) as comprometido,
                                 sum(ejecutado) as ejecutado,
                                 sum(ran.debe_mb -  ran.haber_mb) as balance_mb,
                                 sum(ran.formulado - ran.comprometido) as disponible_mb
					    from conta.trango ran
                             inner join param.ttipo_cc tcc on tcc.id_tipo_cc = ran.id_tipo_cc
                             inner join param.tperiodo per on per.id_periodo = ran.id_periodo
                             inner join param.tgestion ges on ges.id_gestion = per.id_gestion
                             inner join segu.tusuario usu1 on usu1.id_usuario = ran.id_usuario_reg
                             left join segu.tusuario usu2 on usu2.id_usuario = ran.id_usuario_mod
                        where '||v_filtro||' and  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
     #TRANSACCION:  'CONTA_TCCREP_SEL'
     #DESCRIPCION:    Consulta tipos de centro de costo en formato arbol
     #AUTOR:          Rensi Arteaga
     #FECHA:          26-05-2017
    ***********************************/

    elseif(p_transaccion='CONTA_TCCREP_SEL')then

        begin
              if(v_parametros.node = 'id') then
                v_where := ' tcc.id_tipo_cc_fk is NULL  ';
              else
                v_where := ' tcc.id_tipo_cc_fk = '||v_parametros.node;
              end if;

              v_filtro = ' 0=0 ';

              --si tengo fechas obtenemos los periodos correpondinetes
              if pxp.f_existe_parametro(p_tabla,'desde') and pxp.f_existe_parametro(p_tabla,'hasta') then
                  select
                  pxp.list(per.id_periodo::Varchar)
                  into
                  v_periodo
                  from param.tperiodo per
                  where v_parametros.desde BETWEEN per.fecha_ini and per.fecha_fin
                      OR v_parametros.hasta BETWEEN per.fecha_ini and per.fecha_fin
                      OR per.fecha_fin BETWEEN v_parametros.desde and v_parametros.hasta;
                  v_filtro = ' ran.id_periodo in ('||COALESCE(v_periodo,'0')||')';
              end if;

              v_consulta:='select
                          tcc.id_tipo_cc,
                          tcc.codigo,
                          tcc.control_techo,
                          array_to_string(tcc.mov_pres,'','')::varchar as mov_pres,
                          tcc.estado_reg,
                          tcc.movimiento,
                          tcc.id_ep,
                          tcc.id_tipo_cc_fk,
                          tcc.descripcion,
                          tcc.tipo,
                          tcc.control_partida,
                          array_to_string(tcc.momento_pres,'','')::varchar as momento_pres,
                          tcc.fecha_inicio,
                          tcc.fecha_final,
                          case
                          when (tcc.movimiento=''si'' )then
                          ''hoja''::varchar
                          when (tcc.movimiento=''no'' )then
                          ''hijo''::varchar
                          END as tipo_nodo,
                          sum(ran.debe_mb) as debe_mb,
                          sum(ran.haber_mb) as haber_mb,
                          sum(ran.debe_mb) -  sum(ran.haber_mb) as balance_mb,
                          sum(ran.debe_mt) as debe_mt,
                          sum(ran.haber_mt) as haber_mt ,
                          sum(ran.debe_mt) -  sum(ran.haber_mt) as balance_mt,
                          sum(memoria) as memoria,
                          sum(formulado) as formulado,
                          sum(comprometido) as comprometido,
                          sum(ejecutado) as ejecutado
                          from param.ttipo_cc tcc
                          left join conta.trango ran on ran.id_tipo_cc = tcc.id_tipo_cc
                          where  '||v_where|| ' and tcc.estado_reg = ''activo'' and '||v_filtro||'
                          group by
                          tcc.id_tipo_cc,
                          tcc.codigo,
                          tcc.control_techo,
                          tcc.mov_pres,
                          tcc.estado_reg,
                          tcc.movimiento,
                          tcc.id_ep,
                          tcc.id_tipo_cc_fk,
                          tcc.descripcion,
                          tcc.tipo,
                          tcc.control_partida,
                          tcc.momento_pres,
                          tcc.fecha_reg,
                          tcc.usuario_ai,
                          tcc.id_usuario_reg,
                          tcc.id_usuario_ai,
                          tcc.id_usuario_mod,
                          tcc.fecha_mod,
                          tcc.fecha_inicio,
                          tcc.fecha_final,
                          tcc.movimiento';
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