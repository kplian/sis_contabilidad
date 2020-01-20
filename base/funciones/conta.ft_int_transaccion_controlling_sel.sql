--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_int_transaccion_controlling_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_int_transaccion_controlling_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tint_transaccion'
 AUTOR:
 FECHA:	        01-09-2013 18:10:12
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
 ISSUE 		   FECHA   			 AUTOR				 DESCRIPCION:

#75 		28/11/2019		  Manuel Guerra	  	controlling
#93 		16/1/2020		  Manuel Guerra	  	modificacion en interfaz, ocultar columnas
***************************************************************************/

DECLARE

    v_consulta    		varchar;
    v_consulta_b   		varchar;
    v_con		  		VARCHAR[];
    v_rec		  		record;
    v_parametros  		record;
    v_nombre_funcion   	text;
    v_resp				varchar;
    v_cuentas			varchar;
    v_ordenes			varchar;
    v_tipo_cc			varchar;
    v_filtro_cuentas	varchar;
    v_filtro_ordenes	varchar;
    v_filtro_tipo_cc	varchar;
    v_filtro_tipo_cc_pre varchar;
    v_filtro			varchar;
    v_desde				varchar;
    v_hasta				varchar;
    v_filtro_tipo       varchar;
    v_fecha_anterior	date;
    v_filtro_aux        varchar;
    v_aux     		    varchar;
    valor_aux   		numeric;
    v_auxiliar 		    varchar;
    v_auxiliar_b	    varchar;
    v_auxiliar_c	    integer;
    v_auxiliar_d	    varchar;

    v_join    		    varchar;
    v_atributos    		varchar;
    v_filto_nro			varchar;
    v_filtro_internacional varchar;
    v_fecha_desde    	date;
    v_fecha_d    		varchar;
    v_fecha_h    		varchar;
    v_int     			varchar;
    v_pa     			integer;
    v_where             varchar;
    v_where2            varchar;
    v_where3            varchar;
    v_where4            varchar;
    v_count			    integer;
    v_ini			    integer;
    v_ini_a			    VARCHAR[];
BEGIN

	v_nombre_funcion = 'conta.ft_int_transaccion_controlling_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'CONTA_LISAGR_SEL'
 	#DESCRIPCION:	Listado de nro tramites
 	#AUTOR:		#7  Manuel guerra
 	#FECHA:		28-12-2018
	***********************************/
    if(p_transaccion='CONTA_LISAGR_SEL') then

    	begin
    		--Sentencia de la consulta
            v_cuentas = '0';
            v_ordenes = '0';
            v_tipo_cc = '0';
            v_filtro_cuentas = '0=0';
            v_filtro_ordenes = '0=0';
            v_filtro_tipo_cc = '0=0';
    		v_aux = REPLACE(v_parametros.filtro, '(icbte.fecha','0=0 --(icbte.fecha');
            IF (v_parametros.hasta IS NULL) AND (v_parametros.desde IS NULL) THEN
            	v_desde = '0=0';
            ELSE
            	v_desde = 'and icbte.fecha::Date <'|| v_parametros.desde;
			END IF;
             IF  pxp.f_existe_parametro(p_tabla,'id_cuenta')  THEN
                  IF v_parametros.id_cuenta is not NULL  THEN
                      WITH RECURSIVE cuenta_rec (id_cuenta, id_cuenta_padre) AS (
                        SELECT cue.id_cuenta, cue.id_cuenta_padre
                        FROM conta.tcuenta cue
                        WHERE cue.id_cuenta = v_parametros.id_cuenta and cue.estado_reg = 'activo'
                      UNION ALL
                        SELECT cue2.id_cuenta, cue2.id_cuenta_padre
                        FROM cuenta_rec lrec
                        INNER JOIN conta.tcuenta cue2 ON lrec.id_cuenta = cue2.id_cuenta_padre
                        where cue2.estado_reg = 'activo'
                      )
                    SELECT  pxp.list(id_cuenta::varchar)
                      into
                        v_cuentas
                    FROM cuenta_rec;
                    v_filtro_cuentas = ' transa.id_cuenta in ('||v_cuentas||') ';
                END IF;
            END IF;

            IF  pxp.f_existe_parametro(p_tabla,'id_orden_trabajo')  THEN
                  IF v_parametros.id_orden_trabajo is not NULL THEN
                    IF v_parametros.id_orden_trabajo != 0 THEN
                          WITH RECURSIVE orden_rec (id_orden_trabajo, id_orden_trabajo_fk) AS (
                            SELECT cue.id_orden_trabajo, cue.id_orden_trabajo_fk
                            FROM conta.torden_trabajo cue
                            WHERE cue.id_orden_trabajo = v_parametros.id_orden_trabajo and cue.estado_reg = 'activo'
                          UNION ALL
                            SELECT cue2.id_orden_trabajo, cue2.id_orden_trabajo_fk
                            FROM orden_rec lrec
                            INNER JOIN conta.torden_trabajo cue2 ON lrec.id_orden_trabajo = cue2.id_orden_trabajo_fk
                            where cue2.estado_reg = 'activo'
                          )
                        SELECT  pxp.list(id_orden_trabajo::varchar)
                          into
                            v_ordenes
                        FROM orden_rec;

                        v_filtro_ordenes = ' transa.id_orden_trabajo in ('||v_ordenes||') ';
                    ELSE
                        --cuando la orden de trabajo es cero, se requiere msotrar las ordenes de trabajo nulas
                        v_filtro_ordenes = ' transa.id_orden_trabajo is null ';
                    END IF;
                END IF;
            END IF;

            IF  pxp.f_existe_parametro(p_tabla,'id_tipo_cc')  THEN
            	IF v_parametros.id_tipo_cc is not NULL THEN
                	WITH RECURSIVE tipo_cc_rec (id_tipo_cc, id_tipo_cc_fk) AS (
                        SELECT tcc.id_tipo_cc, tcc.id_tipo_cc_fk
                        FROM param.ttipo_cc tcc
                        WHERE tcc.id_tipo_cc = v_parametros.id_tipo_cc and tcc.estado_reg = 'activo'
                      UNION ALL
                        SELECT tcc2.id_tipo_cc, tcc2.id_tipo_cc_fk
                        FROM tipo_cc_rec lrec
                        INNER JOIN param.ttipo_cc tcc2 ON lrec.id_tipo_cc = tcc2.id_tipo_cc_fk
                        where tcc2.estado_reg = 'activo'
                      )
                    SELECT  pxp.list(id_tipo_cc::varchar)
                    into v_tipo_cc
                    FROM tipo_cc_rec;
                    v_filtro_tipo_cc = ' cc.id_tipo_cc in ('||v_tipo_cc||') ';
                    v_filtro_tipo_cc_pre = REPLACE (v_filtro_tipo_cc, 'cc.id_tipo_cc', 'vpe.id_tipo_cc');
                END IF;
            END IF;
			v_fecha_d=to_char(v_parametros.desde, 'DD-MM-YYYY');--v_parametros.desde;
            v_fecha_h=to_char(v_parametros.hasta, 'DD-MM-YYYY');--v_parametros.hasta;

            v_consulta:='WITH tab AS(
            			WITH data AS(
            				SELECT
                            0::integer as id_int_transaccion,
                            0::integer as id_int_comprobante,
                            null::varchar as nro_cbte,
                            vpe.nro_tramite::varchar as nro_tramite,
                            null::varchar as nro_tramite_aux,
                            0::integer as id_centro_costo,
                            0::integer as id_partida,
                            0::integer as id_partida_ejecucion,
                            0::integer as id_cuenta,
                            0::integer as id_auxiliar,
                            null::varchar as estado_reg,
                            vpe.id_tipo_cc as id_tipo_cc,

                            0::numeric as importe_debe_mb,
                            0::numeric as importe_haber_mb,
                            0::numeric as importe_debe_mt,
                            0::numeric as importe_haber_mt,
                            0::numeric as importe_debe_ma,
                            0::numeric as importe_haber_ma,
                            vpe.monto_mb,
                            CASE
                                WHEN vpe.tipo_movimiento=''comprometido'' THEN
                                	COALESCE(vpe.monto_mb,0)::numeric
                            	ELSE
                                	0::numeric
                            END as compro,
                            CASE
                                WHEN vpe.tipo_movimiento=''ejecutado'' THEN
                                	COALESCE(vpe.monto_mb,0)::numeric
                                ELSE
                                	0::numeric
                            END as ejec,
                            CASE
                                WHEN vpe.tipo_movimiento=''formulado'' THEN
                                	COALESCE(vpe.monto_mb,0)::numeric
                                ELSE
                                	0::numeric
                            END as formu--,
                           -- 0::integer as id_subsistema
                            FROM pre.vpartida_ejecucion vpe
                            WHERE (vpe.fecha::date BETWEEN '''||v_parametros.desde||''' AND '''||v_parametros.hasta||''')
                            and vpe.id_gestion = '||v_parametros.id_gestion||'
                            AND '||v_filtro_tipo_cc_pre||' ';
            	v_consulta:=v_consulta||'
            				UNION

                            select
                            transa.id_int_transaccion::integer,
                            transa.id_int_comprobante::integer,
                            icbte.nro_cbte::varchar,
                            icbte.nro_tramite::varchar,
                            icbte.nro_tramite_aux::varchar,
                            transa.id_centro_costo::integer,
                            transa.id_partida::integer,
                            transa.id_partida_ejecucion::integer,
                            transa.id_cuenta::integer,
                            transa.id_auxiliar::integer,
                            transa.estado_reg::varchar,
                            cc.id_tipo_cc,

                            COALESCE(transa.importe_debe_mb,0)::numeric as importe_debe_mb,
                            COALESCE(transa.importe_haber_mb,0)::numeric as importe_haber_mb,
                            COALESCE(transa.importe_debe_mt,0)::numeric as importe_debe_mt,
                            COALESCE(transa.importe_haber_mt,0)::numeric as importe_haber_mt,
                            COALESCE(transa.importe_debe_ma,0)::numeric as importe_debe_ma,
                            COALESCE(transa.importe_haber_ma,0)::numeric as importe_haber_ma,
                            0::numeric as monto_mb,
                            0::numeric as compro,
                            0::numeric as ejec,
                            0::numeric as formu--,
                           -- sub.id_subsistema::integer
                            from conta.tint_transaccion transa
                            inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                            inner join param.tdepto dep on dep.id_depto = icbte.id_depto
                            inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
                            inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                            left join pre.tpartida par on par.id_partida = transa.id_partida
                            left join param.vcentro_costo cc on cc.id_centro_costo = transa.id_centro_costo
                            left join conta.tauxiliar aux on aux.id_auxiliar = transa.id_auxiliar
                            join segu.tsubsistema sub on sub.id_subsistema=icbte.id_subsistema

                        	where icbte.estado_reg = ''validado''
                              and '||v_filtro_cuentas||'
                              and '||v_filtro_ordenes||'
                              and '||v_filtro_tipo_cc||'
                              and ';

                v_consulta:=v_consulta|| v_parametros.filtro;
                --raise exception '%,%',v_parametros.id_gestion,v_parametros.filtro;

                v_consulta_b:= 'with da as(
                              SELECT
                              substring(replace(replace(icbte.nro_tramite, ''-'', '' ''), ''_'', '' '')from ''[a-zA-Z\s]+'') as datos
                              FROM conta.tint_comprobante icbte
                              where icbte.estado_reg=''validado''
                              group by 1
                              )
                              select count(da.datos)
                              from da
                              order by 1';

                EXECUTE(v_consulta_b)into v_count;
                v_ini=1;

                FOR v_rec in (SELECT
                                substring(replace(replace(icbte.nro_tramite, '-', ' '), '_', ' ')from '[a-zA-Z\s]+') as datos
                                FROM conta.tint_comprobante icbte
                                where icbte.estado_reg='validado'
                                group by 1
                                order by 1)LOOP
                    v_con[v_ini] = v_rec.datos;
                    v_ini = v_ini + 1;
                END LOOP;

                v_consulta_b='';
                v_ini=1;
                WHILE v_ini <= v_count LOOP
                	v_consulta_b:=v_consulta_b ||'WHEN nro_tramite like ''%'|| REPLACE(rtrim(v_con[v_ini]),' ','-') ||'%''THEN '''|| rtrim(v_con[v_ini]) ||'''::varchar ';
                	v_ini=v_ini+1;
                END LOOP;

--                raise exception '%,%',v_parametros.desde,v_parametros.hasta;

                v_consulta:=v_consulta||'
                		)
                        SELECT
                        CASE
                            '||v_consulta_b||'
                        END AS tipo,
                        '''||to_char(v_parametros.desde, 'DD/MM/YYYY')||'''::date as desde,
                        '''||to_char(v_parametros.hasta, 'DD/MM/YYYY')||'''::date as hasta,
                        id_tipo_cc,
                       -- id_subsistema::integer,
                        --ROW_NUMBER () OVER (ORDER BY id_subsistema)::integer as id,
                        (sum(COALESCE(ejec,0))*100)/ '||v_parametros.ejecutado||' as ejecutado,

                        sum(COALESCE(importe_debe_mb,0))::numeric as importe_debe_mb,
                        sum(COALESCE(importe_haber_mb,0))::numeric as importe_haber_mb,
                        sum(COALESCE(importe_debe_mt,0))::numeric as importe_debe_mt,
                        sum(COALESCE(importe_haber_mt,0))::numeric as importe_haber_mt,

                        sum(COALESCE(monto_mb,0))::numeric as monto_mb,
                        sum(COALESCE(compro,0))::numeric as compro,
                        sum(COALESCE(ejec,0))::numeric as ejec,
                        sum(COALESCE(formu,0))::numeric as formu

                        from data
                        group by tipo,2,3,4
                        )
                        select
                        ta.tipo,
                        DENSE_RANK () OVER (order by ta.tipo)::integer as id,
                        ta.desde,
                        ta.hasta,
                        array_agg(ta.id_tipo_cc)::varchar,
                        '||v_parametros.numero||'::integer as numero,
                        sum(ta.ejecutado),
                        '||v_parametros.id_gestion||'::integer as id_gestion,
                        '||v_parametros.id_periodo||'::integer as id_periodo,

                        sum(ta.importe_debe_mb) as importe_debe_mb,
                        sum(ta.importe_haber_mb)as importe_haber_mb,
                        sum(ta.importe_debe_mt) as importe_debe_mt,
                        sum(ta.importe_haber_mt) as importe_haber_mt,

                        sum(ta.monto_mb) as monto_mb,
                        sum(ta.compro) as compro,
                        sum(ta.ejec) as ejec,
                        sum(ta.formu) as formu
                        from tab ta
                        where ta.tipo is not null
                        group by
                        ta.tipo,
                        ta.desde,
                        ta.hasta,
                        numero,
                        id_gestion,
                        id_periodo';

			--Definicion de la respuesta
            RAISE notice '%',v_consulta;
            --RAISE EXCEPTION '%',v_consulta;
			--Devuelve la respuesta
			return v_consulta;
		end;

    /*********************************
 	#TRANSACCION:  'CONTA_LISAGR_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		#7  Manuel guerra
 	#FECHA:		28-12-20180
	***********************************/

	elsif(p_transaccion='CONTA_LISAGR_CONT')then
		begin
     		--Sentencia de la consulta
			 v_cuentas = '0';
            v_ordenes = '0';
            v_tipo_cc = '0';
            v_filtro_cuentas = '0=0';
            v_filtro_ordenes = '0=0';
            v_filtro_tipo_cc = '0=0';
    		v_aux = REPLACE(v_parametros.filtro, '(icbte.fecha','0=0 --(icbte.fecha');
            v_fecha_desde=v_parametros.desde;
            IF (v_parametros.hasta IS NULL) AND (v_parametros.desde IS NULL) THEN
            	v_desde = '0=0';
            ELSE
            	v_desde = 'and icbte.fecha::Date <'|| v_parametros.desde;
			END IF;
             IF  pxp.f_existe_parametro(p_tabla,'id_cuenta')  THEN
                  IF v_parametros.id_cuenta is not NULL  THEN
                      WITH RECURSIVE cuenta_rec (id_cuenta, id_cuenta_padre) AS (
                        SELECT cue.id_cuenta, cue.id_cuenta_padre
                        FROM conta.tcuenta cue
                        WHERE cue.id_cuenta = v_parametros.id_cuenta and cue.estado_reg = 'activo'
                      UNION ALL
                        SELECT cue2.id_cuenta, cue2.id_cuenta_padre
                        FROM cuenta_rec lrec
                        INNER JOIN conta.tcuenta cue2 ON lrec.id_cuenta = cue2.id_cuenta_padre
                        where cue2.estado_reg = 'activo'
                      )
                    SELECT  pxp.list(id_cuenta::varchar)
                      into
                        v_cuentas
                    FROM cuenta_rec;
                    v_filtro_cuentas = ' transa.id_cuenta in ('||v_cuentas||') ';
                END IF;
            END IF;

            IF  pxp.f_existe_parametro(p_tabla,'id_orden_trabajo')  THEN
                  IF v_parametros.id_orden_trabajo is not NULL THEN
                    IF v_parametros.id_orden_trabajo != 0 THEN
                          WITH RECURSIVE orden_rec (id_orden_trabajo, id_orden_trabajo_fk) AS (
                            SELECT cue.id_orden_trabajo, cue.id_orden_trabajo_fk
                            FROM conta.torden_trabajo cue
                            WHERE cue.id_orden_trabajo = v_parametros.id_orden_trabajo and cue.estado_reg = 'activo'
                          UNION ALL
                            SELECT cue2.id_orden_trabajo, cue2.id_orden_trabajo_fk
                            FROM orden_rec lrec
                            INNER JOIN conta.torden_trabajo cue2 ON lrec.id_orden_trabajo = cue2.id_orden_trabajo_fk
                            where cue2.estado_reg = 'activo'
                          )
                        SELECT  pxp.list(id_orden_trabajo::varchar)
                          into
                            v_ordenes
                        FROM orden_rec;

                        v_filtro_ordenes = ' transa.id_orden_trabajo in ('||v_ordenes||') ';
                    ELSE
                        --cuando la orden de trabajo es cero, se requiere msotrar las ordenes de trabajo nulas
                        v_filtro_ordenes = ' transa.id_orden_trabajo is null ';
                    END IF;
                END IF;
            END IF;

            IF  pxp.f_existe_parametro(p_tabla,'id_tipo_cc')  THEN
            	IF v_parametros.id_tipo_cc is not NULL THEN
                	WITH RECURSIVE tipo_cc_rec (id_tipo_cc, id_tipo_cc_fk) AS (
                        SELECT tcc.id_tipo_cc, tcc.id_tipo_cc_fk
                        FROM param.ttipo_cc tcc
                        WHERE tcc.id_tipo_cc = v_parametros.id_tipo_cc and tcc.estado_reg = 'activo'
                      UNION ALL
                        SELECT tcc2.id_tipo_cc, tcc2.id_tipo_cc_fk
                        FROM tipo_cc_rec lrec
                        INNER JOIN param.ttipo_cc tcc2 ON lrec.id_tipo_cc = tcc2.id_tipo_cc_fk
                        where tcc2.estado_reg = 'activo'
                      )
                    SELECT  pxp.list(id_tipo_cc::varchar)
                      into
                        v_tipo_cc
                    FROM tipo_cc_rec;
                    v_filtro_tipo_cc = ' cc.id_tipo_cc in ('||v_tipo_cc||') ';
                    v_filtro_tipo_cc_pre = REPLACE (v_filtro_tipo_cc, 'cc.id_tipo_cc', 'vpe.id_tipo_cc');
                END IF;
            END IF;

			v_consulta:='select
                        count(sub.tipo) as total,
                        sum(sub.importe_debe_mb) as total_debe_mb,
                        sum(sub.importe_haber_mb) as total_haber_mb,
                        sum(sub.importe_debe_mt) as total_debe_mt,
                        sum(sub.importe_haber_mt) as total_haber_mt,

                        sum(sub.monto_mb) as monto_mb_total,

                        sum(sub.compro) as compro_total,
                        sum(sub.ejec) as ejec_total,
                        sum(sub.formu) as formu_total
                        from
                        (
                          WITH data as(
            				SELECT
                            0::integer as id_int_transaccion,
                            0::integer as id_int_comprobante,
                            null::varchar as nro_cbte,
                            vpe.nro_tramite::varchar as nro_tramite,
                            null::varchar as nro_tramite_aux,
                            0::integer as id_centro_costo,
                            0::integer as id_partida,
                            0::integer as id_partida_ejecucion,
                            0::integer as id_cuenta,
                            0::integer as id_auxiliar,
                            null::varchar as estado_reg,
                            vpe.id_tipo_cc as id_tipo_cc,

                            0::numeric as importe_debe_mb,
                            0::numeric as importe_haber_mb,
                            0::numeric as importe_debe_mt,
                            0::numeric as importe_haber_mt,
                            0::numeric as importe_debe_ma,
                            0::numeric as importe_haber_ma,

                            vpe.monto_mb,
                            CASE
                                WHEN vpe.tipo_movimiento=''comprometido'' THEN
                                    COALESCE(vpe.monto_mb,0)::numeric
                            END as compro,
                            CASE
                                WHEN vpe.tipo_movimiento=''ejecutado'' THEN
                                    COALESCE(vpe.monto_mb,0)::numeric
                            END as ejec,
                            CASE
                                WHEN vpe.tipo_movimiento=''formulado'' THEN
                                    COALESCE(vpe.monto_mb,0)::numeric
                            END as formu
                            FROM pre.vpartida_ejecucion vpe
                            WHERE (vpe.fecha::date BETWEEN '''||v_parametros.desde||''' AND '''||v_parametros.hasta||''')
                            and '||v_filtro_tipo_cc_pre||' ';

            	v_consulta:=v_consulta||'
                			union

                            select
                            transa.id_int_transaccion::integer,
                            transa.id_int_comprobante::integer,
                            icbte.nro_cbte::varchar,
                            icbte.nro_tramite::varchar,
                            icbte.nro_tramite_aux::varchar,
                            transa.id_centro_costo::integer,
                            transa.id_partida::integer,
                            transa.id_partida_ejecucion::integer,
                            transa.id_cuenta::integer,
                            transa.id_auxiliar::integer,
                            transa.estado_reg::varchar,
                            cc.id_tipo_cc,
                            COALESCE(transa.importe_debe_mb,0)::numeric as importe_debe_mb,
                            COALESCE(transa.importe_haber_mb,0)::numeric as importe_haber_mb,
                            COALESCE(transa.importe_debe_mt,0)::numeric as importe_debe_mt,
                            COALESCE(transa.importe_haber_mt,0)::numeric as importe_haber_mt,
                            COALESCE(transa.importe_debe_ma,0)::numeric as importe_debe_ma,
                            COALESCE(transa.importe_haber_ma,0)::numeric as importe_haber_ma,
                            0::numeric as monto_mb,
                            0::numeric as compro,
                            0::numeric as ejec,
                            0::numeric as formu
                            from conta.tint_transaccion transa
                            inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                            inner join param.tdepto dep on dep.id_depto = icbte.id_depto
                            inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
                            inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                            left join pre.tpartida par on par.id_partida = transa.id_partida
                            left join param.vcentro_costo cc on cc.id_centro_costo = transa.id_centro_costo
                            left join conta.tauxiliar aux on aux.id_auxiliar = transa.id_auxiliar
                            join segu.tsubsistema sub on sub.id_subsistema=icbte.id_subsistema

                        	where icbte.estado_reg = ''validado''
                              and '||v_filtro_cuentas||'
                              and '||v_filtro_ordenes||'
                              and '||v_filtro_tipo_cc||'
                              and ';
				v_consulta:=v_consulta||v_parametros.filtro;
                --
                v_consulta_b:= 'with da as(
                              SELECT
                              substring(replace(replace(icbte.nro_tramite, ''-'', '' ''), ''_'', '' '')from ''[a-zA-Z\s]+'') as datos
                              FROM conta.tint_comprobante icbte
                              where icbte.estado_reg=''validado''
                              group by 1
                              )
                              select count(da.datos)
                              from da
                              order by 1';

                EXECUTE(v_consulta_b)into v_count;

                v_ini=1;
                --#93
                FOR v_rec in (SELECT
                                substring(replace(replace(icbte.nro_tramite, '-', ' '), '_', ' ')from '[a-zA-Z\s]+') as datos
                                FROM conta.tint_comprobante icbte
                                where icbte.estado_reg='validado'
                                group by 1
                                order by 1)LOOP
                    v_con[v_ini] = v_rec.datos;
                    v_ini = v_ini + 1;
                END LOOP;
                v_consulta_b='';
                v_ini=1;
                WHILE v_ini <= v_count LOOP
                	v_consulta_b:=v_consulta_b ||'WHEN nro_tramite like ''%'|| REPLACE(rtrim(v_con[v_ini]),' ','-') ||'%''THEN '''|| rtrim(v_con[v_ini]) ||'''::varchar ';
                	v_ini=v_ini+1;
                END LOOP;
                --
                v_consulta:=v_consulta||'
                		)
                        SELECT
                        CASE
                            '||v_consulta_b||'
                        END AS tipo,
                        sum(COALESCE(importe_debe_mb,0))::numeric as importe_debe_mb,
                        sum(COALESCE(importe_haber_mb,0))::numeric as importe_haber_mb,
                        sum(COALESCE(importe_debe_mt,0))::numeric as importe_debe_mt,
                        sum(COALESCE(importe_haber_mt,0))::numeric as importe_haber_mt,

                        sum(COALESCE(monto_mb,0))::numeric as monto_mb,
                        sum(COALESCE(compro,0))::numeric as compro,
                       	sum(COALESCE(ejec,0))::numeric as ejec,
                       	sum(COALESCE(formu,0))::numeric as formu
                        from data
                        group by tipo
                        ) as sub ';
                         raise notice '%',v_consulta;
               --raise exception '%',v_consulta;
			--Devuelve la respuesta
			return v_consulta;
		end;


    /*********************************
 	#TRANSACCION:  'CONTA_MAYCTR_SEL'
 	#DESCRIPCION:	controlling, listado de transacciones
 	#AUTOR:		manu
 	#FECHA:		01-09-2013 18:10:12
	***********************************/

	elseif(p_transaccion='CONTA_MAYCTR_SEL')then
    	begin
        	v_cuentas = '0';
            v_ordenes = '0';
            v_tipo_cc = '0';
            v_filtro_cuentas = '0=0';
            v_filtro_ordenes = '0=0';
            v_filtro_tipo_cc = '0=0';
    		v_aux = REPLACE(v_parametros.filtro, '(icbte.fecha','0=0 --(icbte.fecha');

            IF (v_parametros.hasta IS NULL) AND (v_parametros.desde IS NULL) THEN
            	v_desde = '0=0';
            ELSE
            	v_desde = 'and icbte.fecha::Date <'|| v_parametros.desde;
			END IF;
             IF  pxp.f_existe_parametro(p_tabla,'id_cuenta')  THEN
                  IF v_parametros.id_cuenta is not NULL  THEN
                      WITH RECURSIVE cuenta_rec (id_cuenta, id_cuenta_padre) AS (
                        SELECT cue.id_cuenta, cue.id_cuenta_padre
                        FROM conta.tcuenta cue
                        WHERE cue.id_cuenta = v_parametros.id_cuenta and cue.estado_reg = 'activo'
                      UNION ALL
                        SELECT cue2.id_cuenta, cue2.id_cuenta_padre
                        FROM cuenta_rec lrec
                        INNER JOIN conta.tcuenta cue2 ON lrec.id_cuenta = cue2.id_cuenta_padre
                        where cue2.estado_reg = 'activo'
                      )
                    SELECT  pxp.list(id_cuenta::varchar)
                      into
                        v_cuentas
                    FROM cuenta_rec;
                    v_filtro_cuentas = ' transa.id_cuenta in ('||v_cuentas||') ';
                END IF;
            END IF;

            IF  pxp.f_existe_parametro(p_tabla,'id_orden_trabajo')  THEN
                  IF v_parametros.id_orden_trabajo is not NULL THEN
                    IF v_parametros.id_orden_trabajo != 0 THEN
                          WITH RECURSIVE orden_rec (id_orden_trabajo, id_orden_trabajo_fk) AS (
                            SELECT cue.id_orden_trabajo, cue.id_orden_trabajo_fk
                            FROM conta.torden_trabajo cue
                            WHERE cue.id_orden_trabajo = v_parametros.id_orden_trabajo and cue.estado_reg = 'activo'
                          UNION ALL
                            SELECT cue2.id_orden_trabajo, cue2.id_orden_trabajo_fk
                            FROM orden_rec lrec
                            INNER JOIN conta.torden_trabajo cue2 ON lrec.id_orden_trabajo = cue2.id_orden_trabajo_fk
                            where cue2.estado_reg = 'activo'
                          )
                        SELECT  pxp.list(id_orden_trabajo::varchar)
                          into
                            v_ordenes
                        FROM orden_rec;

                        v_filtro_ordenes = ' transa.id_orden_trabajo in ('||v_ordenes||') ';
                    ELSE
                        --cuando la orden de trabajo es cero, se requiere msotrar las ordenes de trabajo nulas
                        v_filtro_ordenes = ' transa.id_orden_trabajo is null ';
                    END IF;
                END IF;
            END IF;

            IF  pxp.f_existe_parametro(p_tabla,'id_tipo_cc')  THEN
            	IF v_parametros.id_tipo_cc is not NULL THEN
                	WITH RECURSIVE tipo_cc_rec (id_tipo_cc, id_tipo_cc_fk) AS (
                        SELECT tcc.id_tipo_cc, tcc.id_tipo_cc_fk
                        FROM param.ttipo_cc tcc
                        WHERE tcc.id_tipo_cc = v_parametros.id_tipo_cc and tcc.estado_reg = 'activo'
                      UNION ALL
                        SELECT tcc2.id_tipo_cc, tcc2.id_tipo_cc_fk
                        FROM tipo_cc_rec lrec
                        INNER JOIN param.ttipo_cc tcc2 ON lrec.id_tipo_cc = tcc2.id_tipo_cc_fk
                        where tcc2.estado_reg = 'activo'
                      )
                    SELECT  pxp.list(id_tipo_cc::varchar)
                      into
                        v_tipo_cc
                    FROM tipo_cc_rec;
                    v_filtro_tipo_cc = ' cc.id_tipo_cc in ('||v_tipo_cc||') ';
                END IF;
            END IF;
            --
            v_consulta:='WITH data as (
                          SELECT
                          1::integer as id_int_transaccion,
                          0::integer as id_int_comprobante,
                          null::varchar as codigo,

                          null::varchar as nro_cbte,
                          null::varchar as nro_tramite,
                          null::varchar as nro_tramite_aux,

                          0::integer as id_centro_costo,
                          0::integer as id_partida,
                          0::integer as id_partida_ejecucion,
                          0::integer as id_cuenta,
                          0::integer as id_auxiliar,
                          null::varchar as estado_reg,

                          0::numeric as importe_debe_mb,
                          0::numeric as importe_haber_mb,
                          0::numeric as importe_gasto_mb,
                          0::numeric as importe_recurso_mb,
                          0::numeric as importe_debe_mt,
                          0::numeric as importe_haber_mt,
                          0::numeric as importe_gasto_mt,
                          0::numeric as importe_recurso_mt,
                          0::numeric as importe_debe_ma,
                          0::numeric as importe_haber_ma,
                          0::numeric as importe_gasto_ma,
                          0::numeric as importe_recurso_ma,

                          null::varchar as nombre,
                          null::varchar as desc_centro_costo,
                          null::varchar as desc_cuenta,
                          null::varchar as desc_auxiliar,
                          null::varchar as desc_partida,
                          null::varchar as tipo_partida,
                          null::varchar as nombre_corto,
                          null::date as fecha,
                          null::varchar as glosa_cbte,
                          null::varchar as glosa_tran,
                          0::numeric as tipo_cambio,
                          0::numeric as tipo_cambio_2,
                          0::numeric as tipo_cambio_3,
                          null::varchar as actualizacion,
                          0::numeric as saldo_mb,
                          0::numeric as saldo_mt,
                          COALESCE(transa.importe_debe_mb,0) - COALESCE(transa.importe_haber_mb,0) as dif

                          from conta.tint_transaccion transa
                          inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                          inner join param.tdepto dep on dep.id_depto = icbte.id_depto
                          inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
                          inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                          inner join conta.tconfig_tipo_cuenta ctc on ctc.tipo_cuenta = cue.tipo_cuenta
                          inner join conta.tconfig_subtipo_cuenta csc on csc.id_config_subtipo_cuenta = cue.id_config_subtipo_cuenta
                          left join pre.tpartida par on par.id_partida = transa.id_partida
                          left join param.vcentro_costo cc on cc.id_centro_costo = transa.id_centro_costo
                          left join conta.tauxiliar aux on aux.id_auxiliar = transa.id_auxiliar
                          left join segu.tsubsistema sub on sub.id_subsistema=icbte.id_subsistema

                          where icbte.estado_reg = ''validado''
                                        and '||v_filtro_cuentas||'
                                        and '||v_filtro_ordenes||'
                                        and '||v_filtro_tipo_cc||'
                                        and icbte.fecha::Date < '''||v_parametros.desde||'''
                                        and '||v_aux||'
                                        ';
            v_consulta:=v_consulta||'
            			union all

                        select
                        transa.id_int_transaccion::integer,
                        transa.id_int_comprobante::integer,
                        sub.codigo,
                        icbte.nro_cbte::varchar,
                        icbte.nro_tramite::varchar,
                        icbte.nro_tramite_aux::varchar,

                        transa.id_centro_costo::integer,
                        transa.id_partida::integer,
                        transa.id_partida_ejecucion::integer,
                        transa.id_cuenta::integer,
                        transa.id_auxiliar::integer,
                        transa.estado_reg::varchar,

                        COALESCE(transa.importe_debe_mb,0)::numeric as importe_debe_mb,
                        COALESCE(transa.importe_haber_mb,0)::numeric as importe_haber_mb,
                        COALESCE(transa.importe_gasto_mb,0)::numeric as importe_gasto_mb,
                        COALESCE(transa.importe_recurso_mb,0)::numeric as importe_recurso_mb,

                        COALESCE(transa.importe_debe_mt,0)::numeric as importe_debe_mt,
                        COALESCE(transa.importe_haber_mt,0)::numeric as importe_haber_mt,
                        COALESCE(transa.importe_gasto_mt,0)::numeric as importe_gasto_mt,
                        COALESCE(transa.importe_recurso_mt,0)::numeric as importe_recurso_mt,

                        COALESCE(transa.importe_debe_ma,0)::numeric as importe_debe_ma,
                        COALESCE(transa.importe_haber_ma,0)::numeric as importe_haber_ma,
                        COALESCE(transa.importe_gasto_ma,0)::numeric as importe_gasto_ma,
                        COALESCE(transa.importe_recurso_ma,0)::numeric as importe_recurso_ma,

                        csc.nombre,
                        cc.codigo_cc::varchar as desc_centro_costo,
                        (cue.nro_cuenta || '' - '' || cue.nombre_cuenta)::varchar as desc_cuenta,
                        (aux.codigo_auxiliar || '' - '' || aux.nombre_auxiliar)::varchar as desc_auxiliar,
                        CASE par.sw_movimiento
                          WHEN ''flujo'' THEN
                            (''(F) ''||par.codigo || '' - '' || par.nombre_partida)::varchar
                          ELSE
                            (par.codigo || '' - '' || par.nombre_partida)::varchar
                        END as desc_partida,
                        par.sw_movimiento::varchar as tipo_partida,
                        dep.nombre_corto::varchar,
                        icbte.fecha::date,
                        icbte.glosa1::varchar as glosa_cbte,
                        transa.glosa::varchar as glosa_tran,
                        transa.tipo_cambio::numeric,
                        transa.tipo_cambio_2::numeric,
                        transa.tipo_cambio_3::numeric,
                        transa.actualizacion::varchar,
                        0::numeric as saldo_mb,
                        0::numeric as saldo_mt,
                        COALESCE(transa.importe_debe_mb,0) - COALESCE(transa.importe_haber_mb,0) as dif

                        from conta.tint_transaccion transa
                        inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                        inner join param.tdepto dep on dep.id_depto = icbte.id_depto
                        inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
                        inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                        inner join conta.tconfig_tipo_cuenta ctc on ctc.tipo_cuenta = cue.tipo_cuenta
                        inner join conta.tconfig_subtipo_cuenta csc on csc.id_config_subtipo_cuenta = cue.id_config_subtipo_cuenta
                        left join pre.tpartida par on par.id_partida = transa.id_partida
                        left join param.vcentro_costo cc on cc.id_centro_costo = transa.id_centro_costo
                        left join conta.tauxiliar aux on aux.id_auxiliar = transa.id_auxiliar
                        left join segu.tsubsistema sub on sub.id_subsistema=icbte.id_subsistema
				        where icbte.estado_reg = ''validado''
                              and '||v_filtro_cuentas||'
                              and '||v_filtro_ordenes||'
                              and '||v_filtro_tipo_cc||'
                              and ';
			v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion;
            v_consulta:=v_consulta|| ' ),
                                      xxx as
                                      (
                                        select
                                        row_number() over () as orden,*
                                        from DATA
                                      )
                                      select
                                      id_int_transaccion,
                                      id_int_comprobante,

                                      codigo::varchar,
                                      nro_cbte::varchar,
                                      nro_tramite::varchar,
                                      nro_tramite_aux::varchar,

                                      id_centro_costo,
                                      id_partida_ejecucion,
                                      id_cuenta,
                                      id_partida,
                                      id_auxiliar,

                                      importe_debe_mb::numeric,
                                      importe_haber_mb::numeric,
                                      importe_gasto_mb::numeric,
                                      importe_recurso_mb::numeric,

                                      importe_debe_mt::numeric,
                                      importe_haber_mt::numeric,
                                      importe_gasto_mt::numeric,
                                      importe_recurso_mt::numeric,

                                      importe_debe_ma::numeric,
                                      importe_haber_ma::numeric,
                                      importe_gasto_ma::numeric,
                                      importe_recurso_ma::numeric,

                                      desc_centro_costo::varchar,
                                      desc_cuenta::varchar,
                                      desc_auxiliar::varchar,
                                      desc_partida::varchar,
                                      tipo_partida::varchar,
                                      nombre_corto::varchar,

                                      fecha::date,
                                      glosa_cbte,
                                      glosa_tran,

                                      tipo_cambio::numeric,
                                      tipo_cambio_2::numeric,
                                      tipo_cambio_3::numeric,
                                      actualizacion::varchar,

                                      saldo_mb::numeric,
                                      saldo_mt::numeric,
                                      dif
                                      from xxx
                                      order by orden
                                      limit '||v_parametros.cantidad||'
                                      offset '||v_parametros.puntero;
            --
            raise notice '%',v_consulta;
            --            raise exception '%',v_consulta;
			return v_consulta;
		end;

    /*********************************
 	#TRANSACCION:  'CONTA_MAYCTR_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin
 	#FECHA:		01-09-2013 18:10:12
	***********************************/

	elsif(p_transaccion='CONTA_MAYCTR_CONT')then
		begin
        	v_cuentas = '0';
            v_ordenes = '0';
            v_tipo_cc = '0';
            v_filtro_cuentas = '0=0';
            v_filtro_ordenes = '0=0';
            v_filtro_tipo_cc = '0=0';
    		v_aux = REPLACE(v_parametros.filtro, '(icbte.fecha','0=0 --(icbte.fecha');
             IF (v_parametros.hasta IS NULL) AND (v_parametros.desde IS NULL) THEN
            	v_desde = '0=0';
            ELSE
            	v_desde = 'and icbte.fecha::Date <'|| v_parametros.desde;
			END IF;
             IF  pxp.f_existe_parametro(p_tabla,'id_cuenta')  THEN
                  IF v_parametros.id_cuenta is not NULL  THEN
                      WITH RECURSIVE cuenta_rec (id_cuenta, id_cuenta_padre) AS (
                        SELECT cue.id_cuenta, cue.id_cuenta_padre
                        FROM conta.tcuenta cue
                        WHERE cue.id_cuenta = v_parametros.id_cuenta and cue.estado_reg = 'activo'
                      UNION ALL
                        SELECT cue2.id_cuenta, cue2.id_cuenta_padre
                        FROM cuenta_rec lrec
                        INNER JOIN conta.tcuenta cue2 ON lrec.id_cuenta = cue2.id_cuenta_padre
                        where cue2.estado_reg = 'activo'
                      )
                    SELECT  pxp.list(id_cuenta::varchar)
                      into
                        v_cuentas
                    FROM cuenta_rec;
                    v_filtro_cuentas = ' transa.id_cuenta in ('||v_cuentas||') ';
                END IF;
            END IF;

            IF  pxp.f_existe_parametro(p_tabla,'id_orden_trabajo')  THEN
                  IF v_parametros.id_orden_trabajo is not NULL THEN
                    IF v_parametros.id_orden_trabajo != 0 THEN
                          WITH RECURSIVE orden_rec (id_orden_trabajo, id_orden_trabajo_fk) AS (
                            SELECT cue.id_orden_trabajo, cue.id_orden_trabajo_fk
                            FROM conta.torden_trabajo cue
                            WHERE cue.id_orden_trabajo = v_parametros.id_orden_trabajo and cue.estado_reg = 'activo'
                          UNION ALL
                            SELECT cue2.id_orden_trabajo, cue2.id_orden_trabajo_fk
                            FROM orden_rec lrec
                            INNER JOIN conta.torden_trabajo cue2 ON lrec.id_orden_trabajo = cue2.id_orden_trabajo_fk
                            where cue2.estado_reg = 'activo'
                          )
                        SELECT  pxp.list(id_orden_trabajo::varchar)
                          into
                            v_ordenes
                        FROM orden_rec;

                        v_filtro_ordenes = ' transa.id_orden_trabajo in ('||v_ordenes||') ';
                    ELSE
                        v_filtro_ordenes = ' transa.id_orden_trabajo is null ';
                    END IF;
                END IF;
            END IF;

            IF  pxp.f_existe_parametro(p_tabla,'id_tipo_cc')  THEN
                IF v_parametros.id_tipo_cc is not NULL THEN
                      WITH RECURSIVE tipo_cc_rec (id_tipo_cc, id_tipo_cc_fk) AS (
                        SELECT tcc.id_tipo_cc, tcc.id_tipo_cc_fk
                        FROM param.ttipo_cc tcc
                        WHERE tcc.id_tipo_cc = v_parametros.id_tipo_cc and tcc.estado_reg = 'activo'
                      UNION ALL
                        SELECT tcc2.id_tipo_cc, tcc2.id_tipo_cc_fk
                        FROM tipo_cc_rec lrec
                        INNER JOIN param.ttipo_cc tcc2 ON lrec.id_tipo_cc = tcc2.id_tipo_cc_fk
                        where tcc2.estado_reg = 'activo'
                      )
                    SELECT  pxp.list(id_tipo_cc::varchar)
                      into
                        v_tipo_cc
                    FROM tipo_cc_rec;
                    v_filtro_tipo_cc = ' cc.id_tipo_cc in ('||v_tipo_cc||') ';
                END IF;
            END IF;
            --

            v_consulta:='select
                        sum(sub.id_int_transaccion)::bigint as total,
                        sum(sub.total_debe)::numeric as total_debe,
                        sum(sub.total_haber)::numeric as total_haber,
                        sum(sub.total_debe_mt)::numeric as total_debe_mt,
                        sum(sub.total_haber_mt)::numeric as total_haber_mt,
                        sum(sub.total_debe_ma)::numeric as total_debe_ma,
                        sum(sub.total_haber_ma)::numeric as total_haber_ma,
                        sum(sub.total_saldo_mb)::numeric as total_saldo_mb,
                        sum(sub.total_saldo_mt)::numeric as total_saldo_mt,
                        sum(sub.dif)::numeric as dif
                        from
                        (
            			with data as (
                        select
                        0::integer as orden,
                        1::integer as id_int_transaccion,
                        0::numeric as total_debe,
                        0::numeric as total_haber,
                        0::numeric as total_debe_mt,
                        0::numeric as total_haber_mt,
                        0::numeric as total_debe_ma,
                        0::numeric as total_haber_ma,
                        sum(COALESCE(transa.importe_debe_mb,0))-sum(COALESCE(transa.importe_haber_mb,0)) as total_saldo_mb,
                        sum(COALESCE(transa.importe_debe_mt,0))-sum(COALESCE(transa.importe_haber_mt,0)) as total_saldo_mt,
                        sum(COALESCE(transa.importe_debe_mb,0))-sum(COALESCE(transa.importe_haber_mb,0))::numeric as dif,
                        1::integer as id
                        from conta.tint_transaccion transa
                        inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                        inner join param.tdepto dep on dep.id_depto = icbte.id_depto
                        inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
                        inner join segu.tusuario usu1 on usu1.id_usuario = transa.id_usuario_reg
                        inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                        inner join conta.tconfig_tipo_cuenta ctc on ctc.tipo_cuenta = cue.tipo_cuenta
                        inner join conta.tconfig_subtipo_cuenta csc on csc.id_config_subtipo_cuenta = cue.id_config_subtipo_cuenta
                        left join segu.tusuario usu2 on usu2.id_usuario = transa.id_usuario_mod
                        left join pre.tpartida par on par.id_partida = transa.id_partida
                        left join param.vcentro_costo cc on cc.id_centro_costo = transa.id_centro_costo
                        left join conta.tauxiliar aux on aux.id_auxiliar = transa.id_auxiliar
                        left join conta.torden_trabajo ot on ot.id_orden_trabajo =  transa.id_orden_trabajo
                        where icbte.estado_reg = ''validado''
                    	and '||v_filtro_cuentas||'
                        and '||v_filtro_ordenes||'
                        and '||v_filtro_tipo_cc||'
                        and icbte.fecha::Date < '''||v_parametros.desde||'''
                        and '||v_aux||'

                        union all

            			select
                        row_number() over () as orden,
                        count(transa.id_int_transaccion) as id_int_transaccion,
                        sum(COALESCE(transa.importe_debe_mb,0)) as total_debe,
                        sum(COALESCE(transa.importe_haber_mb,0)) as total_haber,
                        sum(COALESCE(transa.importe_debe_mt,0)) as total_debe_mt,
                        sum(COALESCE(transa.importe_haber_mt,0)) as total_haber_mt,
                        sum(COALESCE(transa.importe_debe_ma,0)) as total_debe_ma,
                        sum(COALESCE(transa.importe_haber_ma,0)) as total_haber_ma,
                        0::numeric as total_saldo_mb,
                        0::numeric as total_saldo_mt,
                        sum(COALESCE(transa.importe_debe_mb,0) - COALESCE(transa.importe_haber_mb,0)) as dif,
						1::integer as id
					    from conta.tint_transaccion transa
                        inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                        inner join param.tdepto dep on dep.id_depto = icbte.id_depto
                        inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
						inner join segu.tusuario usu1 on usu1.id_usuario = transa.id_usuario_reg
                        inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                        inner join conta.tconfig_tipo_cuenta ctc on ctc.tipo_cuenta = cue.tipo_cuenta
                        inner join conta.tconfig_subtipo_cuenta csc on csc.id_config_subtipo_cuenta = cue.id_config_subtipo_cuenta
						left join segu.tusuario usu2 on usu2.id_usuario = transa.id_usuario_mod
						left join pre.tpartida par on par.id_partida = transa.id_partida
						left join param.vcentro_costo cc on cc.id_centro_costo = transa.id_centro_costo
						left join conta.tauxiliar aux on aux.id_auxiliar = transa.id_auxiliar
                        left join conta.torden_trabajo ot on ot.id_orden_trabajo =  transa.id_orden_trabajo
				        where icbte.estado_reg = ''validado''
                              and '||v_filtro_cuentas||'
                              and '||v_filtro_ordenes||'
                              and '||v_filtro_tipo_cc||'
                              and';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta|| ')
                                        select
                                            id_int_transaccion,
                                            total_debe,
                                            total_haber,
                                            total_debe_mt,
                                            total_haber_mt,
                                            total_debe_ma,
                                            total_haber_ma,
                                            total_saldo_mb,
                                            total_saldo_mt,
                                            sum(dif) over (order by orden asc rows between unbounded preceding and current row) as dif,
                                            id
                                        from data
                                        )as sub
                                      ';

            raise notice '%',v_consulta;

			--Devuelve la respuesta
			return v_consulta;
		end;

     	/*********************************
 	#TRANSACCION:  'CONTA_PROAGR_SEL'
 	#DESCRIPCION:	Listado de nro tramites (combo)
 	#AUTOR:		#7  Manuel guerra
 	#FECHA:		28-12-2018
	***********************************/
    elsif(p_transaccion='CONTA_PROAGR_SEL') then

    	begin
    		--Sentencia de la consulta
            v_cuentas = '0';
            v_ordenes = '0';
            v_tipo_cc = '0';
            v_filtro_cuentas = '0=0';
            v_filtro_ordenes = '0=0';
            v_filtro_tipo_cc = '0=0';
    		v_aux = REPLACE(v_parametros.filtro, '(icbte.fecha','0=0 --(icbte.fecha');

            IF (v_parametros.hasta IS NULL) AND (v_parametros.desde IS NULL) THEN
            	v_desde = '0=0';
            ELSE
            	v_desde = 'and icbte.fecha::Date <'|| v_parametros.desde;
			END IF;
             IF  pxp.f_existe_parametro(p_tabla,'id_cuenta')  THEN
                  IF v_parametros.id_cuenta is not NULL  THEN
                      WITH RECURSIVE cuenta_rec (id_cuenta, id_cuenta_padre) AS (
                        SELECT cue.id_cuenta, cue.id_cuenta_padre
                        FROM conta.tcuenta cue
                        WHERE cue.id_cuenta = v_parametros.id_cuenta and cue.estado_reg = 'activo'
                      UNION ALL
                        SELECT cue2.id_cuenta, cue2.id_cuenta_padre
                        FROM cuenta_rec lrec
                        INNER JOIN conta.tcuenta cue2 ON lrec.id_cuenta = cue2.id_cuenta_padre
                        where cue2.estado_reg = 'activo'
                      )
                    SELECT  pxp.list(id_cuenta::varchar)
                      into
                        v_cuentas
                    FROM cuenta_rec;
                    v_filtro_cuentas = ' transa.id_cuenta in ('||v_cuentas||') ';
                END IF;
            END IF;

            IF  pxp.f_existe_parametro(p_tabla,'id_orden_trabajo')  THEN
                  IF v_parametros.id_orden_trabajo is not NULL THEN
                    IF v_parametros.id_orden_trabajo != 0 THEN
                          WITH RECURSIVE orden_rec (id_orden_trabajo, id_orden_trabajo_fk) AS (
                            SELECT cue.id_orden_trabajo, cue.id_orden_trabajo_fk
                            FROM conta.torden_trabajo cue
                            WHERE cue.id_orden_trabajo = v_parametros.id_orden_trabajo and cue.estado_reg = 'activo'
                          UNION ALL
                            SELECT cue2.id_orden_trabajo, cue2.id_orden_trabajo_fk
                            FROM orden_rec lrec
                            INNER JOIN conta.torden_trabajo cue2 ON lrec.id_orden_trabajo = cue2.id_orden_trabajo_fk
                            where cue2.estado_reg = 'activo'
                          )
                        SELECT  pxp.list(id_orden_trabajo::varchar)
                          into
                            v_ordenes
                        FROM orden_rec;

                        v_filtro_ordenes = ' transa.id_orden_trabajo in ('||v_ordenes||') ';
                    ELSE
                        --cuando la orden de trabajo es cero, se requiere msotrar las ordenes de trabajo nulas
                        v_filtro_ordenes = ' transa.id_orden_trabajo is null ';
                    END IF;
                END IF;
            END IF;

            IF  pxp.f_existe_parametro(p_tabla,'id_tipo_cc')  THEN
            	IF v_parametros.id_tipo_cc is not NULL THEN
                	WITH RECURSIVE tipo_cc_rec (id_tipo_cc, id_tipo_cc_fk) AS (
                        SELECT tcc.id_tipo_cc, tcc.id_tipo_cc_fk
                        FROM param.ttipo_cc tcc
                        WHERE tcc.id_tipo_cc = v_parametros.id_tipo_cc and tcc.estado_reg = 'activo'
                      UNION ALL
                        SELECT tcc2.id_tipo_cc, tcc2.id_tipo_cc_fk
                        FROM tipo_cc_rec lrec
                        INNER JOIN param.ttipo_cc tcc2 ON lrec.id_tipo_cc = tcc2.id_tipo_cc_fk
                        where tcc2.estado_reg = 'activo'
                      )
                    SELECT  pxp.list(id_tipo_cc::varchar)
                    into v_tipo_cc
                    FROM tipo_cc_rec;
                    v_filtro_tipo_cc = ' cc.id_tipo_cc in ('||v_tipo_cc||') ';
                    v_filtro_tipo_cc_pre = REPLACE (v_filtro_tipo_cc, 'cc.id_tipo_cc', 'vpe.id_tipo_cc');
                END IF;
            END IF;

            v_consulta:='WITH data as(
            			    select
                            icbte.nro_tramite::varchar
                            from conta.tint_transaccion transa
                            inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                            inner join param.tdepto dep on dep.id_depto = icbte.id_depto
                            inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
                            inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                            left join pre.tpartida par on par.id_partida = transa.id_partida
                            left join param.vcentro_costo cc on cc.id_centro_costo = transa.id_centro_costo
                            left join conta.tauxiliar aux on aux.id_auxiliar = transa.id_auxiliar
                            join segu.tsubsistema sub on sub.id_subsistema=icbte.id_subsistema

                        	where icbte.estado_reg = ''validado''
                              and '||v_filtro_cuentas||'
                              and '||v_filtro_ordenes||'
                              and '||v_filtro_tipo_cc||'
                              and ';
                v_consulta:=v_consulta|| v_parametros.filtro;
                v_consulta:=v_consulta||'group by icbte.nro_tramite
                			)
                            SELECT
                            row_number() OVER()::integer AS id_int_transaccion,
                            data.nro_tramite::varchar
                            from data ';

			--Definicion de la respuesta
            RAISE notice '%',v_consulta;
           -- RAISE EXCEPTION '%',v_consulta;
			--Devuelve la respuesta
			return v_consulta;
		end;

    /*********************************
 	#TRANSACCION:  'CONTA_PROAGR_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		#7  Manuel guerra
 	#FECHA:		28-12-20180
	***********************************/

	elsif(p_transaccion='CONTA_PROAGR_CONT')then
		begin
     		--Sentencia de la consulta
			 v_cuentas = '0';
            v_ordenes = '0';
            v_tipo_cc = '0';
            v_filtro_cuentas = '0=0';
            v_filtro_ordenes = '0=0';
            v_filtro_tipo_cc = '0=0';
    		v_aux = REPLACE(v_parametros.filtro, '(icbte.fecha','0=0 --(icbte.fecha');
            v_fecha_desde=v_parametros.desde;
            IF (v_parametros.hasta IS NULL) AND (v_parametros.desde IS NULL) THEN
            	v_desde = '0=0';
            ELSE
            	v_desde = 'and icbte.fecha::Date <'|| v_parametros.desde;
			END IF;
             IF  pxp.f_existe_parametro(p_tabla,'id_cuenta')  THEN
                  IF v_parametros.id_cuenta is not NULL  THEN
                      WITH RECURSIVE cuenta_rec (id_cuenta, id_cuenta_padre) AS (
                        SELECT cue.id_cuenta, cue.id_cuenta_padre
                        FROM conta.tcuenta cue
                        WHERE cue.id_cuenta = v_parametros.id_cuenta and cue.estado_reg = 'activo'
                      UNION ALL
                        SELECT cue2.id_cuenta, cue2.id_cuenta_padre
                        FROM cuenta_rec lrec
                        INNER JOIN conta.tcuenta cue2 ON lrec.id_cuenta = cue2.id_cuenta_padre
                        where cue2.estado_reg = 'activo'
                      )
                    SELECT  pxp.list(id_cuenta::varchar)
                      into
                        v_cuentas
                    FROM cuenta_rec;
                    v_filtro_cuentas = ' transa.id_cuenta in ('||v_cuentas||') ';
                END IF;
            END IF;

            IF  pxp.f_existe_parametro(p_tabla,'id_orden_trabajo')  THEN
                  IF v_parametros.id_orden_trabajo is not NULL THEN
                    IF v_parametros.id_orden_trabajo != 0 THEN
                          WITH RECURSIVE orden_rec (id_orden_trabajo, id_orden_trabajo_fk) AS (
                            SELECT cue.id_orden_trabajo, cue.id_orden_trabajo_fk
                            FROM conta.torden_trabajo cue
                            WHERE cue.id_orden_trabajo = v_parametros.id_orden_trabajo and cue.estado_reg = 'activo'
                          UNION ALL
                            SELECT cue2.id_orden_trabajo, cue2.id_orden_trabajo_fk
                            FROM orden_rec lrec
                            INNER JOIN conta.torden_trabajo cue2 ON lrec.id_orden_trabajo = cue2.id_orden_trabajo_fk
                            where cue2.estado_reg = 'activo'
                          )
                        SELECT  pxp.list(id_orden_trabajo::varchar)
                          into
                            v_ordenes
                        FROM orden_rec;

                        v_filtro_ordenes = ' transa.id_orden_trabajo in ('||v_ordenes||') ';
                    ELSE
                        --cuando la orden de trabajo es cero, se requiere msotrar las ordenes de trabajo nulas
                        v_filtro_ordenes = ' transa.id_orden_trabajo is null ';
                    END IF;
                END IF;
            END IF;

            IF  pxp.f_existe_parametro(p_tabla,'id_tipo_cc')  THEN
            	IF v_parametros.id_tipo_cc is not NULL THEN
                	WITH RECURSIVE tipo_cc_rec (id_tipo_cc, id_tipo_cc_fk) AS (
                        SELECT tcc.id_tipo_cc, tcc.id_tipo_cc_fk
                        FROM param.ttipo_cc tcc
                        WHERE tcc.id_tipo_cc = v_parametros.id_tipo_cc and tcc.estado_reg = 'activo'
                      UNION ALL
                        SELECT tcc2.id_tipo_cc, tcc2.id_tipo_cc_fk
                        FROM tipo_cc_rec lrec
                        INNER JOIN param.ttipo_cc tcc2 ON lrec.id_tipo_cc = tcc2.id_tipo_cc_fk
                        where tcc2.estado_reg = 'activo'
                      )
                    SELECT  pxp.list(id_tipo_cc::varchar)
                      into
                        v_tipo_cc
                    FROM tipo_cc_rec;
                    v_filtro_tipo_cc = ' cc.id_tipo_cc in ('||v_tipo_cc||') ';
                    v_filtro_tipo_cc_pre = REPLACE (v_filtro_tipo_cc, 'cc.id_tipo_cc', 'vpe.id_tipo_cc');
                END IF;
            END IF;

			v_consulta:='WITH data as(
            			    select
                            icbte.nro_tramite::varchar
                            from conta.tint_transaccion transa
                            inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                            inner join param.tdepto dep on dep.id_depto = icbte.id_depto
                            inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
                            inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                            left join pre.tpartida par on par.id_partida = transa.id_partida
                            left join param.vcentro_costo cc on cc.id_centro_costo = transa.id_centro_costo
                            left join conta.tauxiliar aux on aux.id_auxiliar = transa.id_auxiliar
                            join segu.tsubsistema sub on sub.id_subsistema=icbte.id_subsistema

                        	where icbte.estado_reg = ''validado''
                              and '||v_filtro_cuentas||'
                              and '||v_filtro_ordenes||'
                              and '||v_filtro_tipo_cc||'
                              and ';
              v_consulta:=v_consulta|| v_parametros.filtro;
              v_consulta:=v_consulta||'group by icbte.nro_tramite
              				)
                            SELECT
                            count(data.nro_tramite)
                            from data ';
               raise notice '%',v_consulta;
               --raise exception '%',v_consulta;
			--Devuelve la respuesta
			return v_consulta;
		end;


        /*********************************
 	#TRANSACCION:  'CONTA_PROARB_SEL'
 	#DESCRIPCION:	Listado de nro tramites EN TIPO ARBOL
 	#AUTOR:		#7  Manuel guerra
 	#FECHA:		28-12-2018
	***********************************/
    elsif(p_transaccion='CONTA_PROARB_SEL') then

    	begin

    		--Sentencia de la consulta
            v_cuentas = '0';
            v_ordenes = '0';
            v_tipo_cc = '0';
            v_filtro_cuentas = '0=0';
            v_filtro_ordenes = '0=0';
            v_filtro_tipo_cc = '0=0';
    		v_aux = REPLACE(v_parametros.filtro, '(icbte.fecha','0=0 --(icbte.fecha');

            IF (v_parametros.hasta IS NULL) AND (v_parametros.desde IS NULL) THEN
            	v_desde = '0=0';
            ELSE
            	v_desde = 'and icbte.fecha::Date <'|| v_parametros.desde;
			END IF;
             IF  pxp.f_existe_parametro(p_tabla,'id_cuenta')  THEN
                  IF v_parametros.id_cuenta is not NULL  THEN
                      WITH RECURSIVE cuenta_rec (id_cuenta, id_cuenta_padre) AS (
                        SELECT cue.id_cuenta, cue.id_cuenta_padre
                        FROM conta.tcuenta cue
                        WHERE cue.id_cuenta = v_parametros.id_cuenta and cue.estado_reg = 'activo'
                      UNION ALL
                        SELECT cue2.id_cuenta, cue2.id_cuenta_padre
                        FROM cuenta_rec lrec
                        INNER JOIN conta.tcuenta cue2 ON lrec.id_cuenta = cue2.id_cuenta_padre
                        where cue2.estado_reg = 'activo'
                      )
                    SELECT  pxp.list(id_cuenta::varchar)
                      into
                        v_cuentas
                    FROM cuenta_rec;
                    v_filtro_cuentas = ' transa.id_cuenta in ('||v_cuentas||') ';
                END IF;
            END IF;

            IF  pxp.f_existe_parametro(p_tabla,'id_orden_trabajo')  THEN
                  IF v_parametros.id_orden_trabajo is not NULL THEN
                    IF v_parametros.id_orden_trabajo != 0 THEN
                          WITH RECURSIVE orden_rec (id_orden_trabajo, id_orden_trabajo_fk) AS (
                            SELECT cue.id_orden_trabajo, cue.id_orden_trabajo_fk
                            FROM conta.torden_trabajo cue
                            WHERE cue.id_orden_trabajo = v_parametros.id_orden_trabajo and cue.estado_reg = 'activo'
                          UNION ALL
                            SELECT cue2.id_orden_trabajo, cue2.id_orden_trabajo_fk
                            FROM orden_rec lrec
                            INNER JOIN conta.torden_trabajo cue2 ON lrec.id_orden_trabajo = cue2.id_orden_trabajo_fk
                            where cue2.estado_reg = 'activo'
                          )
                        SELECT  pxp.list(id_orden_trabajo::varchar)
                          into
                            v_ordenes
                        FROM orden_rec;

                        v_filtro_ordenes = ' transa.id_orden_trabajo in ('||v_ordenes||') ';
                    ELSE
                        --cuando la orden de trabajo es cero, se requiere msotrar las ordenes de trabajo nulas
                        v_filtro_ordenes = ' transa.id_orden_trabajo is null ';
                    END IF;
                END IF;
            END IF;

            IF  pxp.f_existe_parametro(p_tabla,'id_tipo_cc')  THEN
            	IF v_parametros.id_tipo_cc is not NULL THEN
                	WITH RECURSIVE tipo_cc_rec (id_tipo_cc, id_tipo_cc_fk) AS (
                        SELECT tcc.id_tipo_cc, tcc.id_tipo_cc_fk
                        FROM param.ttipo_cc tcc
                        WHERE tcc.id_tipo_cc = v_parametros.id_tipo_cc and tcc.estado_reg = 'activo'
                      UNION ALL
                        SELECT tcc2.id_tipo_cc, tcc2.id_tipo_cc_fk
                        FROM tipo_cc_rec lrec
                        INNER JOIN param.ttipo_cc tcc2 ON lrec.id_tipo_cc = tcc2.id_tipo_cc_fk
                        where tcc2.estado_reg = 'activo'
                      )
                    SELECT  pxp.list(id_tipo_cc::varchar)
                    into v_tipo_cc
                    FROM tipo_cc_rec;
                    v_filtro_tipo_cc = ' cc.id_tipo_cc in ('||v_tipo_cc||') ';
                    v_filtro_tipo_cc_pre = REPLACE (v_filtro_tipo_cc, 'cc.id_tipo_cc', 'vpe.id_tipo_cc');
                END IF;
            END IF;

            if(v_parametros.id = 0) then
            	v_consulta:='SELECT
                            0::integer as ids,
                            0::integer as id_int_comprobante,
                            0::integer as id_int_transaccion,
                            ''-''::varchar as nro_tramite,
                            ''-''::varchar as nro_tramite_fk,
                            ''-''::varchar as desc_cuenta,
                            ''-''::varchar as desc_auxiliar,
                            ''-''::varchar as desc_centro_costo,
                            ''-''::varchar as desc_partida,
                            ''-''::varchar as tipo_nodo,

                            0::numeric as importe_debe_mb,
                            0::numeric as importe_haber_mb,
                            0::numeric as importe_debe_mt,
                            0::numeric as importe_haber_mt
                            ';
           	else
                if(coalesce(v_parametros.node,'id') = 'id') then
                    v_where = 't.nro_tramite_fk is null ';
                    v_where2 = '0=0 ';
                    v_where3 = '0=0 ';
                else
                    v_where = ' t.tipo_nodo =''hijo'' ';
                end if;

                if v_parametros.desc_centro_costo is not null then
                    v_where2 = 't.desc_centro_costo like ''%'||v_parametros.desc_centro_costo||'%'' ';
                else
                    v_where2 = '0=0 ';
                end if;

                if v_parametros.desc_partida is not null then

                    v_where3 = 't.desc_partida like ''%'||v_parametros.desc_partida||'%'' ';
                else
                    v_where3 = '0=0 ';
                end if;
                --raise exception '--%',v_parametros.tramite;
                /*
                if v_parametros.tramite is null or  v_parametros.tramite = '' then
                    v_where4 = '0=0 ';
                else
                    v_where4 = 't.nro_tramite like ''%'||v_parametros.tramite||'%'' ';
                end if;
                */
                /*
                 if(coalesce(v_parametros.node,'id') = 'id') then
                   v_where = 't.nro_tramite_fk is null ';
                    v_where2 = 't.nro_tramite is null ';
                else
                    v_where = ' t.nro_tramite_fk = '||v_parametros.node;
                    v_where2 = ' t.nro_tramite = '||v_parametros.node;
                end if;*/

            v_consulta:='with tabla AS(
            				WITH data as (
                                      select
                                      --transa.id_int_transaccion::integer,
                                      0::integer as id_int_transaccion,
                                      transa.id_int_comprobante::integer,
                                      icbte.nro_cbte::varchar,
                                      icbte.nro_tramite::varchar,
                                      icbte.nro_tramite_aux::varchar,
                                      transa.id_centro_costo::integer,
                                      transa.id_partida::integer,
                                      transa.id_partida_ejecucion::integer,
                                      transa.id_cuenta::integer,
                                      transa.id_auxiliar::integer,
                                      transa.estado_reg::varchar,

                                      COALESCE(transa.importe_debe_mb,0)::numeric as importe_debe_mb,
                                      COALESCE(transa.importe_haber_mb,0)::numeric as importe_haber_mb,
                                      COALESCE(transa.importe_debe_mt,0)::numeric as importe_debe_mt,
                                      COALESCE(transa.importe_haber_mt,0)::numeric as importe_haber_mt,

                                      csc.nombre,
                                      ''''::varchar as desc_centro_costo,
                                      ''''::varchar as desc_partida,
                                      par.sw_movimiento::varchar as tipo_partida,
                                      dep.nombre_corto::varchar,
                                      icbte.fecha::date

                                      from conta.tint_transaccion transa
                                      inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                                      inner join param.tdepto dep on dep.id_depto = icbte.id_depto
                                      inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
                                      inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                                      inner join conta.tconfig_tipo_cuenta ctc on ctc.tipo_cuenta = cue.tipo_cuenta
                                      inner join conta.tconfig_subtipo_cuenta csc on csc.id_config_subtipo_cuenta = cue.id_config_subtipo_cuenta
                                      left join pre.tpartida par on par.id_partida = transa.id_partida
                                      left join param.vcentro_costo cc on cc.id_centro_costo = transa.id_centro_costo
                                      left join conta.tauxiliar aux on aux.id_auxiliar = transa.id_auxiliar
                                      left join segu.tsubsistema sub on sub.id_subsistema=icbte.id_subsistema
                                      where icbte.estado_reg = ''validado''
                                      AND icbte.nro_tramite ilike ''%'||v_parametros.tipo||'%''
                                      and '||v_filtro_cuentas||'
                                      and '||v_filtro_ordenes||'
                                      and '||v_filtro_tipo_cc||'
                                      and ';
              v_consulta:=v_consulta|| v_parametros.filtro;
              v_consulta:=v_consulta|| 'order by id_int_transaccion ASC,desc_cuenta ASC)

              						  SELECT
                                      0::integer as id_int_transaccion,
                                      0::integer as id_int_comprobante,
                                      nro_tramite::varchar as nro_tramite,
                                      null::varchar as nro_tramite_fk,
                                      data.desc_centro_costo,
                                      data.desc_partida,
                                      null::varchar as desc_cuenta,
                                      null::varchar as desc_auxiliar,
                                      ''raiz''::varchar as tipo_nodo,
                                      sum(importe_debe_mb::numeric) as importe_debe_mb,
                                      sum(importe_haber_mb::numeric) as importe_haber_mb,
                                      sum(importe_debe_mt::numeric) as importe_debe_mt,
                                      sum(importe_haber_mt::numeric) as importe_haber_mt
                                      from data
                                      group by nro_tramite,nro_tramite_fk,desc_centro_costo,desc_partida

              						  UNION

                                       select
                                       transa.id_int_transaccion::integer,
                                       transa.id_int_comprobante::integer,
                                       --null::varchar as nro_tramite,
                                       icbte.nro_tramite::varchar as nro_tramite,
                                       icbte.nro_tramite::varchar as nro_tramite_fk,
                                       cc.codigo_cc::varchar as desc_centro_costo,
                                       CASE par.sw_movimiento
                                           WHEN ''flujo'' THEN
                                      			(''(F) ''||par.codigo || '' - '' || par.nombre_partida)::varchar
                                       ELSE
                                      			(par.codigo ||'' - '' || par.nombre_partida)::varchar
                                       END as desc_partida,

                                      (cue.nro_cuenta || '' - '' || cue.nombre_cuenta)::varchar as desc_cuenta,
                                      (aux.codigo_auxiliar || '' - '' || aux.nombre_auxiliar)::varchar as desc_auxiliar,

                                       ''hijo''::varchar as tipo_nodo,

                                       COALESCE(transa.importe_debe_mb,0)::numeric as importe_debe_mb,
                                       COALESCE(transa.importe_haber_mb,0)::numeric as importe_haber_mb,
                                       COALESCE(transa.importe_debe_mt,0)::numeric as importe_debe_mt,
                                       COALESCE(transa.importe_haber_mt,0)::numeric as importe_haber_mt

                                       from conta.tint_transaccion transa
                                       inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                                       inner join param.tdepto dep on dep.id_depto = icbte.id_depto
                                       inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
                                       inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                                       inner join conta.tconfig_tipo_cuenta ctc on ctc.tipo_cuenta = cue.tipo_cuenta
                                       inner join conta.tconfig_subtipo_cuenta csc on csc.id_config_subtipo_cuenta = cue.id_config_subtipo_cuenta
                                       left join pre.tpartida par on par.id_partida = transa.id_partida
                                       left join param.vcentro_costo cc on cc.id_centro_costo = transa.id_centro_costo
                                       left join conta.tauxiliar aux on aux.id_auxiliar = transa.id_auxiliar
                                       left join segu.tsubsistema sub on sub.id_subsistema=icbte.id_subsistema
                                       where icbte.estado_reg = ''validado''
                                       AND icbte.nro_tramite ilike ''%'||v_parametros.tipo||'%''
              						   and '||v_filtro_cuentas||'
                                       and '||v_filtro_ordenes||'
                                       and '||v_filtro_tipo_cc||'
                                       and ';
              v_consulta:=v_consulta|| v_parametros.filtro;
              v_consulta:=v_consulta|| ')
                                      SELECT
                                      '||v_parametros.id||' as ids,
                                      t.id_int_transaccion,
                                      t.id_int_comprobante,
                                      t.nro_tramite,
                                      t.nro_tramite_fk,
                                      CASE t.tipo_nodo
                                          WHEN ''raiz'' THEN
                                      	  		''-''::varchar
                                          ELSE
                                          		t.desc_cuenta
                                      END as desc_cuenta,

                                      CASE t.tipo_nodo
                                          WHEN ''raiz'' THEN
                                      	  		''-''::varchar
                                          ELSE
                                          		t.desc_auxiliar
                                      END as desc_auxiliar,

                                      CASE t.tipo_nodo
                                          WHEN ''raiz'' THEN
                                      	  		''-''::varchar
                                          ELSE
                                          		t.desc_centro_costo
                                      END as desc_centro_costo,
                                      CASE t.tipo_nodo
                                          WHEN ''raiz'' THEN
                                      	  		''-''::varchar
                                          ELSE
                                          		t.desc_partida
                                      END as desc_partida,
                                      t.tipo_nodo,

                                      sum (t.importe_debe_mb) as importe_debe_mb,
                                      sum (t.importe_haber_mb) as importe_haber_mb,
                                      sum (t.importe_debe_mt) as importe_debe_mt,
                                      sum (t.importe_haber_mt) as importe_haber_mt

                                      FROM tabla t
                                      where '||v_where||'
                                      and '||v_where2||'
                                      and '||v_where3||'

                                      group BY
                                      t.nro_tramite,
                                      t.nro_tramite_fk,
                                      t.id_int_comprobante,
                                      t.id_int_transaccion,
                                      desc_cuenta,
                                      desc_auxiliar,
                                      desc_centro_costo,
                                      desc_partida,
                                      t.tipo_nodo
                                      ORDER BY  t.nro_tramite,t.nro_tramite_fk,t.desc_centro_costo,t.desc_partida';
			--Definicion de la respuesta
            end if;
            RAISE notice '%',v_consulta;
          	 --RAISE exception '%',v_consulta;
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