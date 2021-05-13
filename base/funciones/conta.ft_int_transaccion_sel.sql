--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_int_transaccion_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:       Sistema de Contabilidad
 FUNCION:       conta.ft_int_transaccion_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tint_transaccion'
 AUTOR:          (RAC)
 FECHA:         01-09-2013 18:10:12
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
 ISSUE         FECHA             AUTOR               DESCRIPCION:
  #92        19/12/2108       Miguel Mamani   actualización reporte de detalle de auxiliares 'CONTA_MROMAYOR_SEL','CONTA_MROMAYOR_CONT','CONTA_AUXRE_SEL'
  #5         24/12/2108       Manuel Guerra   Correcion de sumas en axuiliares 'CONTA_TOTAUX_CONT'
  #10        02/01/2019       Miguel Mamani   Nuevo parámetro tipo de moneda para el reporte detalle Auxiliares por Cuenta
  #48        16/05/2019       Manuel Guerra   agregar columna tipo de presupuesto
  #49        17/05/2019       Manuel Guerra   correcion de join en reporte de cbte-transaccion
  #65        11/07/2019       EGS             Se agrega filtro para el parametro tipo en las trnsacciones  CONTA_AUXMAY_SEL,CONTA_AUXMAY_CONT,
                                              CONTA_TOTAUX_SEL,CONTA_TOTAUX_CONT
  #69        01/08/2019       Saul Zambrana   Se han eliminado 9 columnas y añadido 6 a la transaccion CONTA_LDCTRANS_SEL para el reporte:Detalle comprobante-transacciones
                                              asi mismo se ha modificado la empresion regular [\n\t] por [\n\t\r ] para la eliminacion de
  #91        15/01/2020       JUAN            Libro mayor añadir columna beneficiario
                                              asi mismo se ha modificado la empresion regular [\n\t] por [\n\t\r ] para la eliminacion de
  #83        03/01/2020       Miguel Mamani   Reporte Auxiliares aumentar columna beneficiario
  #95        23/01/2020       Rensi Arteaga   Incluir nro de tramite auxiliar
  #102        6/2/2020          Manuel Guerra     agregar campo nro_tramite_auxiliar, en vista del mayor
  #111       20/03/2020         MMV ETR      Correccion de logica
  #118       11/05/2020       RAC            Correcionde ogica de colunas beneficiario añadida en issue 91
***************************************************************************/

DECLARE

    v_consulta          varchar;
    v_parametros        record;
    v_nombre_funcion    text;
    v_resp              varchar;
    v_cuentas           varchar;
    v_ordenes           varchar;
    v_tipo_cc           varchar;
    v_filtro_cuentas    varchar;
    v_filtro_ordenes    varchar;
    v_filtro_tipo_cc    varchar;
    v_filtro            varchar;
    v_desde             varchar;
    v_hasta             varchar;
    v_filtro_tipo       varchar;
    v_fecha_anterior    date;
    v_filtro_aux        varchar;
    v_aux               varchar;
    valor_aux           numeric;
    v_auxiliar          varchar;
    v_auxiliar_b        varchar;
    v_auxiliar_c        integer;
    v_auxiliar_d        varchar;

    v_join              varchar;
    v_atributos         varchar;
    v_filto_nro         varchar; -- MMV #10
    v_filtro_internacional varchar;--#65
    v_inner 			varchar;
	v_add_filtro		varchar;
    v_filtor_tipo_cc	varchar;
    v_id_cuenta_permitidas	varchar;
    v_id_cuenta 		integer;
BEGIN

    v_nombre_funcion = 'conta.ft_int_transaccion_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
    #TRANSACCION:  'CONTA_INTRANSA_SEL'
    #DESCRIPCION:   Consulta de datos
    #AUTOR:     admin
    #FECHA:     01-09-2013 18:10:12
    ***********************************/

    if(p_transaccion='CONTA_INTRANSA_SEL')then

        begin
            --Sentencia de la consulta
            v_consulta:='select
                            transa.id_int_transaccion,
                            transa.id_partida,
                            transa.id_centro_costo,
                            transa.id_partida_ejecucion,
                            transa.estado_reg,
                            transa.id_int_transaccion_fk,
                            transa.id_cuenta,
                            transa.glosa,
                            transa.id_int_comprobante,
                            transa.id_auxiliar,
                            transa.id_usuario_reg,
                            transa.fecha_reg,
                            transa.id_usuario_mod,
                            transa.fecha_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                            CASE par.sw_movimiento
                                WHEN ''flujo'' THEN
                                    ''(F) ''||par.codigo || '' - '' || par.nombre_partida
                                ELSE
                                    par.codigo || '' - '' || par.nombre_partida
                                END  as desc_partida,

                            cc.codigo_cc as desc_centro_costo,
                            cue.nro_cuenta || '' - '' || cue.nombre_cuenta as desc_cuenta,
                            aux.codigo_auxiliar || '' - '' || aux.nombre_auxiliar as desc_auxiliar,
                            par.sw_movimiento as tipo_partida,
                            ot.id_orden_trabajo,
                            ot.desc_orden,
                            transa.importe_debe,
                            transa.importe_haber,
                            transa.importe_gasto,
                            transa.importe_recurso,
                            transa.importe_debe_mb,
                            transa.importe_haber_mb,
                            transa.importe_gasto_mb,
                            transa.importe_recurso_mb,
                            transa.banco,
                            transa.forma_pago,
                            transa.nombre_cheque_trans,
                            transa.nro_cuenta_bancaria_trans,
                            transa.nro_cheque,
                            transa.importe_debe_mt,
                            transa.importe_haber_mt,
                            transa.importe_gasto_mt,
                            transa.importe_recurso_mt,

                            transa.importe_debe_ma,
                            transa.importe_haber_ma,
                            transa.importe_gasto_ma,
                            transa.importe_recurso_ma,


                            transa.id_moneda_tri,
                            transa.id_moneda_act,
                            transa.id_moneda,
                            transa.tipo_cambio,
                            transa.tipo_cambio_2,
                            transa.tipo_cambio_3,
                            transa.actualizacion,
                            transa.triangulacion,
                            suo.id_suborden,
                            (''(''||suo.codigo||'') ''||suo.nombre)::varchar as desc_suborden,
                            ot.codigo as codigo_ot,
                            cp.codigo_categoria::varchar,
                            transa.nro_tramite_auxiliar,    --#95
                            transa.sw_edit
                        from conta.tint_transaccion transa
                        inner join segu.tusuario usu1 on usu1.id_usuario = transa.id_usuario_reg
                        inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                        left join segu.tusuario usu2 on usu2.id_usuario = transa.id_usuario_mod
                        left join pre.tpartida par on par.id_partida = transa.id_partida
                        left join pre.vpresupuesto_cc cc on cc.id_centro_costo = transa.id_centro_costo
                        left join conta.tauxiliar aux on aux.id_auxiliar = transa.id_auxiliar
                        left join conta.torden_trabajo ot on ot.id_orden_trabajo =  transa.id_orden_trabajo
                        left join conta.tsuborden suo on suo.id_suborden =  transa.id_suborden
                        left join pre.vcategoria_programatica cp ON cp.id_categoria_programatica = cc.id_categoria_prog


                        where ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;


            --Devuelve la respuesta
            return v_consulta;

        end;

    /*********************************
    #TRANSACCION:  'CONTA_INTRANSA_CONT'
    #DESCRIPCION:   Conteo de registros
    #AUTOR:     admin
    #FECHA:     01-09-2013 18:10:12
    ***********************************/

    elsif(p_transaccion='CONTA_INTRANSA_CONT')then

        begin
            --Sentencia de la consulta de conteo de registros
            v_consulta:='select
                          count(transa.id_int_transaccion) as total,
                          sum(transa.importe_debe) as total_debe,
                          sum(transa.importe_haber) as total_haber,
                          sum(transa.importe_debe_mb) as total_debe_mb,
                          sum(transa.importe_haber_mb) as total_haber_mb,
                          sum(transa.importe_debe_mt) as total_debe_mt,
                          sum(transa.importe_haber_mt) as total_haber_mt,
                          sum(transa.importe_debe_ma) as total_debe_ma,
                          sum(transa.importe_haber_ma) as total_haber_ma,
                          sum(transa.importe_gasto) as total_gasto,
                          sum(transa.importe_recurso) as total_recurso
                         from conta.tint_transaccion transa
                        inner join segu.tusuario usu1 on usu1.id_usuario = transa.id_usuario_reg
                        inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                        left join segu.tusuario usu2 on usu2.id_usuario = transa.id_usuario_mod
                        left join pre.tpartida par on par.id_partida = transa.id_partida
                        left join pre.vpresupuesto_cc cc on cc.id_centro_costo = transa.id_centro_costo
                        left join conta.tauxiliar aux on aux.id_auxiliar = transa.id_auxiliar
                        left join conta.torden_trabajo ot on ot.id_orden_trabajo =  transa.id_orden_trabajo
                        left join conta.tsuborden suo on suo.id_suborden =  transa.id_suborden
                        left join pre.vcategoria_programatica cp ON cp.id_categoria_programatica = cc.id_categoria_prog

                        where  ';



            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
 raise notice '%',v_consulta;

            --Devuelve la respuesta
            return v_consulta;

        end;
    /*********************************
    #TRANSACCION:  'CONTA_INTMAY_SEL'
    #DESCRIPCION:   listado de transacicones para el mayor
    #AUTOR:     rac
    #FECHA:     24-04-2015 18:10:12
    ***********************************/

    elsif(p_transaccion='CONTA_INTMAY_SEL')then

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

            v_consulta:='with data as (
                          SELECT
                          1::integer as id_int_transaccion,
                          0::integer as id_partida,
                          0::integer as id_centro_costo,
                          0::integer as id_partida_ejecucion,
                          null::varchar as estado_reg,

                          0::integer as id_int_transaccion_fk,
                          0::integer as id_cuenta,
                          null::varchar as glosa,
                          0::integer as id_int_comprobante,
                          0::integer as id_auxiliar,

                          0::integer as id_usuario_reg,
                          null::date as fecha_reg,
                          0::integer as id_usuario_mod,
                          null::date as fecha_mod,
                          null::varchar as usr_reg,
                          null::varchar as usr_mod,

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

                          null::varchar as desc_partida,
                          null::varchar as desc_centro_costo,
                          NULL::varchar as desc_cuenta,
                          null::varchar as desc_auxiliar,
                          null::varchar as tipo_partida,

                          0::integer as id_orden_trabajo,
                          null::varchar as desc_orden,
                          null::varchar as nro_cbte,
                          null::varchar as nro_tramite,
                          null::varchar as nombre_corto,

                          null::date as fecha,
                          ''SALDO ANTERIOR''::varchar as glosa1,
                          0::integer as id_proceso_wf,
                          0::integer as id_estado_wf,
                          null::varchar as cbte_relacional,

                          0::numeric as tipo_cambio,
                          0::numeric as tipo_cambio_2,
                          0::numeric as tipo_cambio_3,
                          null::varchar as actualizacion,

                          null::varchar as codigo_cc,
                          null::varchar as nro_tramite_auxiliar,--#102
                          COALESCE(sum(transa.importe_debe_mb),0)::numeric - COALESCE(sum(transa.importe_haber_mb),0)::numeric as saldo_mb,
                          COALESCE(sum(transa.importe_debe_mt),0)::numeric - COALESCE(sum(transa.importe_haber_mt),0)::numeric as saldo_mt,
                          COALESCE(sum(transa.importe_debe_mb),0)::numeric - COALESCE(sum(transa.importe_haber_mb),0)::numeric as dif,
                          null::varchar as beneficiario --#118
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
                                        and '||v_aux||' ';

            v_consulta:=v_consulta||'
                        union all

                        select
                        transa.id_int_transaccion::integer,
                        transa.id_partida::integer,
                        transa.id_centro_costo::integer,
                        transa.id_partida_ejecucion::integer,
                        transa.estado_reg::varchar,

                        transa.id_int_transaccion_fk::integer,
                        transa.id_cuenta::integer,
                        transa.glosa::varchar,
                        transa.id_int_comprobante::integer,
                        transa.id_auxiliar::integer,


                        transa.id_usuario_reg::integer,
                        transa.fecha_reg::date,
                        transa.id_usuario_mod::integer,
                        transa.fecha_mod::date,
                        usu1.cuenta::varchar as usr_reg,
                        usu2.cuenta::varchar as usr_mod,

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

                        CASE par.sw_movimiento
                            WHEN ''flujo'' THEN
                                (''(F) ''||par.codigo || '' - '' || par.nombre_partida)::varchar
                            ELSE
                                (par.codigo || '' - '' || par.nombre_partida)::varchar
                            END  as desc_partida,
                        cc.codigo_cc::varchar as desc_centro_costo,
                        (cue.nro_cuenta || '' - '' || cue.nombre_cuenta)::varchar as desc_cuenta,
                        (aux.codigo_auxiliar || '' - '' || aux.nombre_auxiliar)::varchar as desc_auxiliar,
                        par.sw_movimiento::varchar as tipo_partida,

                        ot.id_orden_trabajo::integer,
                        ot.desc_orden::varchar,
                        icbte.nro_cbte::varchar,
                        icbte.nro_tramite::varchar,
                        dep.nombre_corto::varchar,

                        icbte.fecha::date,
                        icbte.glosa1::varchar,
                        icbte.id_proceso_wf::integer,
                        icbte.id_estado_wf::integer,
                        icbte.c31::varchar as cbte_relacional,

                        transa.tipo_cambio::numeric,
                        transa.tipo_cambio_2::numeric,
                        transa.tipo_cambio_3::numeric,
                        transa.actualizacion::varchar,

                        cc.codigo_cc::varchar,
                        transa.nro_tramite_auxiliar,--#102
                        0::numeric as saldo_mb,
                        0::numeric as saldo_mt,
                        COALESCE(transa.importe_debe_mb,0) - COALESCE(transa.importe_haber_mb,0) as dif,
                        icbte.beneficiario --#118

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
                              and ';
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion;

            v_consulta:=v_consulta|| ' ),
                                      xxx as (
                                      select
                                      row_number() over () as orden,*
                                      from DATA)

                                      select
                                            id_int_transaccion::integer,
                                            id_partida::integer,
                                            id_centro_costo::integer,
                                            id_partida_ejecucion::integer,

                                            xxx.estado_reg::varchar,
                                            id_int_transaccion_fk::integer,
                                            id_cuenta::integer,
                                            glosa::varchar,
                                            xxx.id_int_comprobante::integer,
                                                                  id_auxiliar::integer,

                                            xxx.id_usuario_reg::integer,
                                            xxx.fecha_reg::date,
                                            xxx.id_usuario_mod::integer,
                                            xxx.fecha_mod::date,
                                            usr_reg::varchar,
                                            usr_mod::varchar,

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

                                            desc_partida::varchar,
                                            desc_centro_costo::varchar,
                                            desc_cuenta::varchar,
                                            desc_auxiliar::varchar,
                                            tipo_partida::varchar,
                                            id_orden_trabajo::integer,
                                            desc_orden::varchar,
                                            xxx.nro_cbte::varchar,
                                            xxx.nro_tramite::varchar,
                                            nombre_corto::varchar,

                                            xxx.fecha::date,
                                            xxx.glosa1::varchar,
                                            xxx.id_proceso_wf::integer,
                                            xxx.id_estado_wf::integer,
                                            cbte_relacional::varchar,

                                            xxx.tipo_cambio::numeric,
                                            xxx.tipo_cambio_2::numeric,
                                            xxx.tipo_cambio_3::numeric,

                                            actualizacion::varchar,
                                            codigo_cc::varchar,
                                            nro_tramite_auxiliar::VARCHAR,--#102
                                            saldo_mb::numeric,
                                            saldo_mt::numeric,
                                            sum(dif) over (order by orden asc rows between unbounded preceding and current row)::numeric as dif,
                                            xxx.beneficiario -- #91 --#118
                                      from xxx
                                      order by orden
                                      limit '||v_parametros.cantidad||'
                                      offset '||v_parametros.puntero;

            return v_consulta;
        end;


    /*********************************
    #TRANSACCION:  'CONTA_INTMAY_CONT'
    #DESCRIPCION:   Conteo de registros
    #AUTOR:     admin
    #FECHA:     01-09-2013 18:10:12
    ***********************************/

    elsif(p_transaccion='CONTA_INTMAY_CONT')then

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
                v_desde = 'icbte.fecha::Date <'''|| v_parametros.desde ||'''';
            END IF;

            IF  pxp.f_existe_parametro(p_tabla,'id_cuenta')  THEN
                IF v_parametros.id_cuenta is not NULL THEN
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
                        into v_cuentas
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



                    v_filtro_tipo_cc = 'cc.id_tipo_cc in ('||v_tipo_cc||') ';
                END IF;
             END IF;

            --RAC 16´/05/2017 quite esta suma de la consulta me parece incorecta, pero no estoy 100% seguro

            /*

            sum(CASE cue.valor_incremento
                            WHEN ''negativo'' THEN
                                COALESCE(transa.importe_debe_mb*-1,0)
                            ELSE
                                COALESCE(transa.importe_debe_mb,0)
                            END)  as total_debe,
            */

            --Sentencia de la consulta de conteo de registros

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
                                      group by sub.id';

            raise notice '%',v_consulta;
            --raise exception '%',v_consulta;
            --Devuelve la respuesta
            return v_consulta;

        end;

    /*********************************
    #TRANSACCION:  'CONTA_INTANA_SEL'
    #DESCRIPCION:   Consulta de datos
    #AUTOR:     admin
    #FECHA:     01-09-2013 18:10:12
    ***********************************/

    elseif(p_transaccion='CONTA_INTANA_SEL')then

        begin

             if pxp.f_existe_parametro(p_tabla,'id_periodo') then
               v_filtro = ' id_periodo='||v_parametros.id_periodo::varchar;
             elseif pxp.f_existe_parametro(p_tabla,'fecha_ini') then
               v_filtro = ' fecha BETWEEN '''||v_parametros.fecha_ini||'''::date and '''||v_parametros.fecha_fin||'''::Date';
             else
                v_filtro = ' 0=0 ';
             end if;


            --Sentencia de la consulta
            v_consulta:='SELECT
                            id_orden_trabajo,
                            sum(importe_debe_mb) as importe_debe_mb,
                            sum(importe_haber_mb) as importe_haber_mb,
                            sum(importe_debe_mt) as importe_debe_mt,
                            sum(importe_haber_mt) as importe_haber_mt,
                            sum(importe_debe_ma) as importe_debe_ma,
                            sum(importe_haber_ma) as importe_haber_ma,
                            codigo_ot::varchar,
                            desc_orden::varchar

                          FROM
                            conta.vint_transaccion_analisis  v
                          where    '||v_parametros.id_tipo_cc::varchar||' =ANY(ids) and '||v_filtro|| ' and ';


              --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;


            v_consulta:=v_consulta||'
                            group by
                                id_orden_trabajo,
                                codigo_ot,
                                desc_orden ';


            --Definicion de la respuesta

            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            raise notice '%',v_consulta;
            --Devuelve la respuesta
            return v_consulta;

        end;

    /*********************************
    #TRANSACCION:  'CONTA_INTANA_CONT'
    #DESCRIPCION:   Conteo de registros
    #AUTOR:     admin
    #FECHA:     01-09-2013 18:10:12
    ***********************************/

    elsif(p_transaccion='CONTA_INTANA_CONT')then

        begin

             if pxp.f_existe_parametro(p_tabla,'id_periodo') then
               v_filtro = ' id_periodo='||v_parametros.id_periodo::varchar;
             elseif pxp.f_existe_parametro(p_tabla,'fecha_ini') then
               v_filtro = ' fecha BETWEEN '''||v_parametros.fecha_ini||'''::date and '''||v_parametros.fecha_fin||'''::Date';
             else
                v_filtro = ' 0=0 ';
             end if;


             v_consulta:='WITH parcial AS (
                                            SELECT
                                                      id_orden_trabajo as id_orden_trabajo,
                                                      sum(importe_debe_mb) as importe_debe_mb,
                                                      sum(importe_haber_mb) as importe_haber_mb,
                                                      sum(importe_debe_mt) as importe_debe_mt,
                                                      sum(importe_haber_mt) as importe_haber_mt,
                                                      sum(importe_debe_ma) as importe_debe_ma,
                                                      sum(importe_haber_ma) as importe_haber_ma
                                                   FROM
                                                      conta.vint_transaccion_analisis  v
                                                   where    '||v_parametros.id_tipo_cc::varchar||' =ANY(ids) and '||v_filtro|| ' and ';

             v_consulta:=v_consulta||v_parametros.filtro;

             v_consulta:= v_consulta|| 'group by
                                                    id_orden_trabajo,
                                                    codigo_ot,
                                                    desc_orden  )

                                             SELECT
                                                   count(id_orden_trabajo) as total,
                                                   sum(importe_debe_mb) as importe_debe_mb,
                                                   sum(importe_haber_mb) as importe_haber_mb,
                                                   sum(importe_debe_mt) as importe_debe_mt,
                                                   sum(importe_haber_mt) as importe_haber_mt,
                                                   sum(importe_debe_ma) as importe_debe_ma,
                                                   sum(importe_haber_ma) as importe_haber_ma
                                            FROM parcial';

            raise notice '%',v_consulta;

            --Devuelve la respuesta
            return v_consulta;

        end;

    /*********************************
    #TRANSACCION:  'CONTA_REPMAY_SEL'
    #DESCRIPCION:   listado de transacicones para el mayor
    #AUTOR:     mp
    #FECHA:     17-10-2017 18:10:12
    ***********************************/

    elsif(p_transaccion='CONTA_REPMAY_SEL')then
        begin
            v_cuentas = '0';
            v_ordenes = '0';
            v_tipo_cc = '0';
            v_filtro_cuentas = '0=0';
            v_filtro_ordenes = '0=0';
            v_filtro_tipo_cc = '0=0';

            v_desde =  ' (icbte.fecha::Date between '''||v_parametros.desde||'''::Date    and '''||v_parametros.hasta||'''::date)  ';
            --v_desde =  ' ( (icbte.fecha::Date >= '''||v_parametros.desde||'''::Date OR '''||v_parametros.desde||'''::Date IS NULL) and (icbte.fecha::Date =< '''||v_parametros.hasta||'''::Date OR '''||v_parametros.hasta||'''::Date IS NULL) )';
            IF (v_desde IS NULL) THEN
                v_desde='0=0';
            END IF;

            IF  pxp.f_existe_parametro(p_tabla,'id_cuenta')  THEN
                  IF v_parametros.id_cuenta is not NULL THEN
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
                    into v_cuentas
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
                        into v_ordenes
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
                    SELECT pxp.list(id_tipo_cc::varchar)
                    into v_tipo_cc
                    FROM tipo_cc_rec;
                    v_filtro_tipo_cc = ' cc.id_tipo_cc in ('||v_tipo_cc||') ';
                END IF;
             END IF;
            --Sentencia de la consulta
            v_consulta:='select
                        transa.id_int_transaccion,
                        transa.id_partida,
                        transa.id_centro_costo,
                        transa.id_partida_ejecucion,
                        transa.estado_reg,
                        transa.id_int_transaccion_fk,
                        transa.id_cuenta,
                        transa.glosa,
                        transa.id_int_comprobante,
                        transa.id_auxiliar,
                        transa.id_usuario_reg,
                        transa.fecha_reg,
                        transa.id_usuario_mod,
                        transa.fecha_mod,
                        usu1.cuenta as usr_reg,
                        usu2.cuenta as usr_mod,
                        COALESCE(transa.importe_debe_mb,0) as importe_debe_mb,
                        COALESCE(transa.importe_haber_mb,0) as importe_haber_mb,
                        COALESCE(transa.importe_gasto_mb,0) as importe_gasto_mb,
                        COALESCE(transa.importe_recurso_mb,0) as importe_recurso_mb,

                        COALESCE(transa.importe_debe_mt,0) as importe_debe_mt,
                        COALESCE(transa.importe_haber_mt,0) as importe_haber_mt,
                        COALESCE(transa.importe_gasto_mt,0) as importe_gasto_mt,
                        COALESCE(transa.importe_recurso_mt,0) as importe_recurso_mt,

                        COALESCE(transa.importe_debe_ma,0) as importe_debe_ma,
                        COALESCE(transa.importe_haber_ma,0) as importe_haber_ma,
                        COALESCE(transa.importe_gasto_ma,0) as importe_gasto_ma,
                        COALESCE(transa.importe_recurso_ma,0) as importe_recurso_ma,

                        CASE par.sw_movimiento
                            WHEN ''flujo'' THEN
                                ''(F) ''||par.codigo || '' - '' || par.nombre_partida
                            ELSE
                                par.codigo || '' - '' || par.nombre_partida
                            END  as desc_partida,

                        cc.codigo_cc as desc_centro_costo,
                        cue.nro_cuenta || '' - '' || cue.nombre_cuenta as desc_cuenta,
                        aux.codigo_auxiliar || '' - '' || aux.nombre_auxiliar as desc_auxiliar,
                        par.sw_movimiento as tipo_partida,
                        ot.id_orden_trabajo,
                        ot.desc_orden,
                        icbte.nro_cbte,
                        icbte.nro_tramite,
                        dep.nombre_corto,
                        icbte.fecha,
                        icbte.glosa1,
                        icbte.id_proceso_wf,
                        icbte.id_estado_wf,
                        icbte.c31 as cbte_relacional
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
                              and '||v_desde||'
                              and '||v_filtro_tipo_cc||' and';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||'ORDER BY fecha,id_int_comprobante';

            return v_consulta;
        end;

    /*********************************
    #TRANSACCION:  'CONTA_INTPAR_SEL'
    #DESCRIPCION:   consulta de analisis de partidas por tipo_cc
    #AUTOR:     admin
    #FECHA:     01-09-2013 18:10:12
    ***********************************/

    elseif(p_transaccion='CONTA_INTPAR_SEL')then

        begin

             if pxp.f_existe_parametro(p_tabla,'id_periodo') then
               v_filtro = ' id_periodo='||v_parametros.id_periodo::varchar;
             elseif pxp.f_existe_parametro(p_tabla,'fecha_ini') then
               v_filtro = ' fecha BETWEEN '''||v_parametros.fecha_ini||'''::date and '''||v_parametros.fecha_fin||'''::Date';
             else
                v_filtro = ' 0=0 ';
             end if;


            --Sentencia de la consulta
            v_consulta:='SELECT
                            id_partida,
                            sum(importe_debe_mb) as importe_debe_mb,
                            sum(importe_haber_mb) as importe_haber_mb,
                            sum(importe_debe_mt) as importe_debe_mt,
                            sum(importe_haber_mt) as importe_haber_mt,
                            sum(importe_debe_ma) as importe_debe_ma,
                            sum(importe_haber_ma) as importe_haber_ma,
                            codigo_partida::varchar,
                            sw_movimiento::varchar,
                            descripcion_partida::varchar

                          FROM
                            conta.vint_transaccion_analisis  v
                          where    '||v_parametros.id_tipo_cc::varchar||' =ANY(ids) and '||v_filtro|| ' and ';


              --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;


            v_consulta:=v_consulta||'
                            group by
                                id_partida,
                                codigo_partida,
                                descripcion_partida,
                                sw_movimiento ';


            --Definicion de la respuesta

            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            raise notice '%',v_consulta;
            --Devuelve la respuesta
            return v_consulta;

        end;
     /*********************************
    #TRANSACCION:  'CONTA_REPMAYSAL_SEL'
    #DESCRIPCION:   listado de transacicones para el mayor con saldos
    #AUTOR:     mp
    #FECHA:     17-10-2017 18:10:12
    ***********************************/

    elsif(p_transaccion='CONTA_REPMAYSAL_SEL')then
        begin
            v_cuentas = '0';
            v_ordenes = '0';
            v_tipo_cc = '0';
            v_filtro_cuentas = '0=0';
            v_filtro_ordenes = '0=0';
            v_filtro_tipo_cc = '0=0';
            v_desde =  '(icbte.fecha::Date between '''||v_parametros.desde||'''::Date and '''||v_parametros.hasta||'''::date) ';
            IF (v_desde IS NULL) THEN
                v_desde='0=0';
            END IF;
            v_fecha_anterior = to_char(v_parametros.desde-1,'DD/MM/YYYY');
            v_aux = REPLACE(v_parametros.filtro, '(icbte.fecha','0=0 --(icbte.fecha');

            IF  pxp.f_existe_parametro(p_tabla,'id_cuenta')  THEN
                  IF v_parametros.id_cuenta is not NULL THEN
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
                    into v_cuentas
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
                        into v_ordenes
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
                    SELECT pxp.list(id_tipo_cc::varchar)
                    into v_tipo_cc
                    FROM tipo_cc_rec;
                    v_filtro_tipo_cc = ' cc.id_tipo_cc in ('||v_tipo_cc||') ';
                END IF;
             END IF;
            --Sentencia de la consulta
            v_consulta:='
                        SELECT
                        0::integer as id_int_transaccion,
                        0::integer as id_partida,
                        0::integer as id_centro_costo,
                        0::integer as id_partida_ejecucion,
                        null::varchar as estado_reg,
                        0::integer as id_int_transaccion_fk,
                        0::integer as id_cuenta,
                        null::varchar as glosa,
                        0::integer as id_int_comprobante,
                        0::integer as id_auxiliar,
                        0::integer as id_usuario_reg,
                        null::date as fecha_reg,
                        0::integer as id_usuario_mod,
                        null::date as fecha_mod,
                        null::varchar as usr_reg,
                        null::varchar as usr_mod,

                        case when(sum(COALESCE(transa.importe_debe_mb,0)) - sum(COALESCE(transa.importe_haber_mb,0)))>0
                            then
                            sum(COALESCE(transa.importe_debe_mb,0))::numeric - sum(COALESCE(transa.importe_haber_mb,0))::numeric
                        else
                            0
                        end as importe_debe_mb,

                        case when(sum(COALESCE(transa.importe_debe_mb,0)) - sum(COALESCE(transa.importe_haber_mb,0)))<0
                            then
                            (sum(COALESCE(transa.importe_debe_mb,0))::numeric - sum(COALESCE(transa.importe_haber_mb,0))::numeric)*(-1)
                        else
                            0
                        end as importe_haber_mb,

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

                        null::varchar as desc_partida,

                        null::varchar as desc_centro_costo,
                        NULL::varchar as desc_cuenta,
                        null::varchar as desc_auxiliar,
                        null::varchar as tipo_partida,
                        0::integer as id_orden_trabajo,
                        null::varchar as desc_orden,
                        null::varchar as nro_cbte,
                        null::varchar as nro_tramite,
                        null::varchar as nombre_corto,
                        '''||v_fecha_anterior||''' as fecha,
                        ''SALDO ANTERIOR''::varchar as glosa1,
                        0::integer as id_proceso_wf,
                        0::integer as id_estado_wf,
                        null::varchar as cbte_relacional,
                        sum(COALESCE(transa.importe_debe_mb,0))::numeric - sum(COALESCE(transa.importe_haber_mb,0))::numeric  as saldo

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
                              and '||v_aux||'  ';


            v_consulta := v_consulta || '
                        union all

                        select
                        transa.id_int_transaccion,
                        transa.id_partida,
                        transa.id_centro_costo,
                        transa.id_partida_ejecucion,
                        transa.estado_reg,
                        transa.id_int_transaccion_fk,
                        transa.id_cuenta,
                        transa.glosa,
                        transa.id_int_comprobante,
                        transa.id_auxiliar,
                        transa.id_usuario_reg,
                        transa.fecha_reg::date,
                        transa.id_usuario_mod,
                        transa.fecha_mod::date,
                        usu1.cuenta as usr_reg,
                        usu2.cuenta as usr_mod,
                        COALESCE(transa.importe_debe_mb,0) as importe_debe_mb,
                        COALESCE(transa.importe_haber_mb,0) as importe_haber_mb,
                        COALESCE(transa.importe_gasto_mb,0) as importe_gasto_mb,
                        COALESCE(transa.importe_recurso_mb,0) as importe_recurso_mb,

                        COALESCE(transa.importe_debe_mt,0) as importe_debe_mt,
                        COALESCE(transa.importe_haber_mt,0) as importe_haber_mt,
                        COALESCE(transa.importe_gasto_mt,0) as importe_gasto_mt,
                        COALESCE(transa.importe_recurso_mt,0) as importe_recurso_mt,

                        COALESCE(transa.importe_debe_ma,0) as importe_debe_ma,
                        COALESCE(transa.importe_haber_ma,0) as importe_haber_ma,
                        COALESCE(transa.importe_gasto_ma,0) as importe_gasto_ma,
                        COALESCE(transa.importe_recurso_ma,0) as importe_recurso_ma,

                        CASE par.sw_movimiento
                            WHEN ''flujo'' THEN
                                ''(F) ''||par.codigo || '' - '' || par.nombre_partida
                            ELSE
                                par.codigo || '' - '' || par.nombre_partida
                            END  as desc_partida,

                        cc.codigo_cc as desc_centro_costo,
                        cue.nro_cuenta || '' - '' || cue.nombre_cuenta as desc_cuenta,
                        aux.codigo_auxiliar || '' - '' || aux.nombre_auxiliar as desc_auxiliar,
                        par.sw_movimiento as tipo_partida,
                        ot.id_orden_trabajo,
                        ot.desc_orden,
                        icbte.nro_cbte,
                        icbte.nro_tramite,
                        dep.nombre_corto,
                        icbte.fecha,
                        icbte.glosa1,
                        icbte.id_proceso_wf,
                        icbte.id_estado_wf,
                        icbte.c31 as cbte_relacional,
                        0::numeric as saldo
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
                              and '||v_desde||'
                              and '||v_filtro_tipo_cc||' and ';

            v_consulta:=v_consulta||v_parametros.filtro;
            RAISE NOTICE '%',v_consulta;
           -- RAISE EXCEPTION '%', v_consulta;
            v_consulta:=v_consulta||'ORDER BY fecha,id_int_comprobante';


            return v_consulta;
        end;
    /*********************************
    #TRANSACCION:  'CONTA_INTPAR_CONT'
    #DESCRIPCION:   Conteo de registros
    #AUTOR:     admin
    #FECHA:     01-09-2013 18:10:12
    ***********************************/

    elsif(p_transaccion='CONTA_INTPAR_CONT')then

        begin

             if pxp.f_existe_parametro(p_tabla,'id_periodo') then
               v_filtro = ' id_periodo='||v_parametros.id_periodo::varchar;
             elseif pxp.f_existe_parametro(p_tabla,'fecha_ini') then
               v_filtro = ' fecha BETWEEN '''||v_parametros.fecha_ini||'''::date and '''||v_parametros.fecha_fin||'''::Date';
             else
                v_filtro = ' 0=0 ';
             end if;


             v_consulta:='WITH parcial AS (
                                            SELECT
                                                      id_partida as id_partida,
                                                      sum(importe_debe_mb) as importe_debe_mb,
                                                      sum(importe_haber_mb) as importe_haber_mb,
                                                      sum(importe_debe_mt) as importe_debe_mt,
                                                      sum(importe_haber_mt) as importe_haber_mt,
                                                      sum(importe_debe_ma) as importe_debe_ma,
                                                      sum(importe_haber_ma) as importe_haber_ma
                                                   FROM
                                                      conta.vint_transaccion_analisis  v
                                                   where    '||v_parametros.id_tipo_cc::varchar||' =ANY(ids) and '||v_filtro|| ' and ';

             v_consulta:=v_consulta||v_parametros.filtro;

             v_consulta:= v_consulta|| 'group by
                                                      id_partida,
                                                      codigo_partida,
                                                      descripcion_partida,
                                                      sw_movimiento  )

                                             SELECT
                                                   count(id_partida) as total,
                                                   sum(importe_debe_mb) as importe_debe_mb,
                                                   sum(importe_haber_mb) as importe_haber_mb,
                                                   sum(importe_debe_mt) as importe_debe_mt,
                                                   sum(importe_haber_mt) as importe_haber_mt,
                                                   sum(importe_debe_ma) as importe_debe_ma,
                                                   sum(importe_haber_ma) as importe_haber_ma
                                            FROM parcial';



            raise notice '%',v_consulta;

            --Devuelve la respuesta
            return v_consulta;

        end;

    /*********************************
    #TRANSACCION:  'CONTA_INTCUE_SEL'
    #DESCRIPCION:   consulta de analisis de cuentas por tipo_cc
    #AUTOR:     admin
    #FECHA:     01-09-2013 18:10:12
    ***********************************/

    elseif(p_transaccion='CONTA_INTCUE_SEL')then

        begin

             if pxp.f_existe_parametro(p_tabla,'id_periodo') then
               v_filtro = ' id_periodo='||v_parametros.id_periodo::varchar;
             elseif pxp.f_existe_parametro(p_tabla,'fecha_ini') then
               v_filtro = ' fecha BETWEEN '''||v_parametros.fecha_ini||'''::date and '''||v_parametros.fecha_fin||'''::Date';
             else
                v_filtro = ' 0=0 ';
             end if;


            --Sentencia de la consulta
            v_consulta:='SELECT
                            id_cuenta,
                            sum(importe_debe_mb) as importe_debe_mb,
                            sum(importe_haber_mb) as importe_haber_mb,
                            sum(importe_debe_mt) as importe_debe_mt,
                            sum(importe_haber_mt) as importe_haber_mt,
                            sum(importe_debe_ma) as importe_debe_ma,
                            sum(importe_haber_ma) as importe_haber_ma,
                            codigo_cuenta::varchar,
                            tipo_cuenta::varchar,
                            descripcion_cuenta::varchar

                          FROM
                            conta.vint_transaccion_analisis  v
                          where    '||v_parametros.id_tipo_cc::varchar||' =ANY(ids) and '||v_filtro|| ' and ';


              --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;


            v_consulta:=v_consulta||'
                            group by
                                id_cuenta,
                                codigo_cuenta,
                                descripcion_cuenta,
                                tipo_cuenta ';


            --Definicion de la respuesta

            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            raise notice '%',v_consulta;
            --Devuelve la respuesta
            return v_consulta;

        end;

    /*********************************
    #TRANSACCION:  'CONTA_INTCUE_CONT'
    #DESCRIPCION:   Conteo de registros
    #AUTOR:     admin
    #FECHA:     01-09-2013 18:10:12
    ***********************************/

    elsif(p_transaccion='CONTA_INTCUE_CONT')then

        begin

             if pxp.f_existe_parametro(p_tabla,'id_periodo') then
               v_filtro = ' id_periodo='||v_parametros.id_periodo::varchar;
             elseif pxp.f_existe_parametro(p_tabla,'fecha_ini') then
               v_filtro = ' fecha BETWEEN '''||v_parametros.fecha_ini||'''::date and '''||v_parametros.fecha_fin||'''::Date';
             else
                v_filtro = ' 0=0 ';
             end if;


             v_consulta:='WITH parcial AS (
                                            SELECT
                                                      id_cuenta as id_cuenta,
                                                      sum(importe_debe_mb) as importe_debe_mb,
                                                      sum(importe_haber_mb) as importe_haber_mb,
                                                      sum(importe_debe_mt) as importe_debe_mt,
                                                      sum(importe_haber_mt) as importe_haber_mt,
                                                      sum(importe_debe_ma) as importe_debe_ma,
                                                      sum(importe_haber_ma) as importe_haber_ma
                                                   FROM
                                                      conta.vint_transaccion_analisis  v
                                                   where    '||v_parametros.id_tipo_cc::varchar||' =ANY(ids) and '||v_filtro|| ' and ';

             v_consulta:=v_consulta||v_parametros.filtro;

             v_consulta:= v_consulta|| 'group by
                                                      id_cuenta,
                                                      codigo_cuenta,
                                                      descripcion_cuenta,
                                                      tipo_cuenta  )

                                             SELECT
                                                   count(id_cuenta) as total,
                                                   sum(importe_debe_mb) as importe_debe_mb,
                                                   sum(importe_haber_mb) as importe_haber_mb,
                                                   sum(importe_debe_mt) as importe_debe_mt,
                                                   sum(importe_haber_mt) as importe_haber_mt,
                                                   sum(importe_debe_ma) as importe_debe_ma,
                                                   sum(importe_haber_ma) as importe_haber_ma
                                            FROM parcial';



            raise notice '%',v_consulta;

            --Devuelve la respuesta
            return v_consulta;

        end;
     /*********************************
    #TRANSACCION:  'CONTA_AUXMAY_SEL'
    #DESCRIPCION:   consulta para grilla que reporta el mayor por auxiliarse
    #AUTOR:     admin
    #FECHA:     01-09-2013 18:10:12
    ***********************************/

    elseif(p_transaccion='CONTA_AUXMAY_SEL')then

        begin
             --raise notice '%',v_parametros.filtro;
            --raise exception '%',v_parametros.filtro;
           v_filtro_aux = ' 0=0 ';
           v_filtro_cuentas = ' 0=0 ';
           v_filtro_tipo = ' 0=0 ';
           v_aux = 'and 0=0 ';

            IF v_parametros.tipo_estado='abierto' then
                v_aux = 'AND saldo!=0';
           END IF;
           IF  pxp.f_existe_parametro(p_tabla,'id_cuenta')  THEN
                IF v_parametros.id_cuenta is not NULL THEN
                    WITH RECURSIVE cuenta_rec (id_cuenta, id_cuenta_padre) AS (
                          SELECT cue.id_cuenta, cue.id_cuenta_padre
                          FROM conta.tcuenta cue
                          WHERE cue.id_cuenta = v_parametros.id_cuenta and cue.estado_reg = 'activo'

                          UNION ALL

                          SELECT cue2.id_cuenta, cue2.id_cuenta_padre
                          FROM cuenta_rec lrec
                          INNER JOIN conta.tcuenta cue2 ON lrec.id_cuenta = cue2.id_cuenta_padre
                          WHERE cue2.estado_reg = 'activo'
                    )
                    SELECT  pxp.list(id_cuenta::varchar)
                    INTO v_cuentas
                    FROM cuenta_rec;
                    v_filtro_cuentas = ' transa.id_cuenta in ('||v_cuentas||') ';
                END IF;
           END IF;

           IF  pxp.f_existe_parametro(p_tabla,'id_auxiliar')  THEN
             IF v_parametros.id_auxiliar is not NULL THEN
                v_filtro_aux = ' transa.id_auxiliar in ('||v_parametros.id_auxiliar::varchar||') ';
             END IF;
           END IF;

           IF  pxp.f_existe_parametro(p_tabla,'id_config_subtipo_cuenta')  THEN
             IF v_parametros.id_config_subtipo_cuenta is not NULL THEN
                v_filtro_tipo = ' csc.id_config_subtipo_cuenta in ('||v_parametros.id_config_subtipo_cuenta::varchar||') ';
             END IF;
           END IF;
           --#65 se agrega filtro segun el tipo que se elija
           IF  pxp.f_existe_parametro(p_tabla,'tipo')  THEN
                IF v_parametros.tipo is not NULL THEN
                    IF v_parametros.tipo = 'internacional' THEN
                        v_filtro_internacional = ' pro.internacional = ''si'' ';
                    ELSIF v_parametros.tipo = 'nacional' THEN
                        v_filtro_internacional = ' pro.internacional = ''no'' ';
                    ELSIF v_parametros.tipo = 'interno' THEN
                        v_filtro_internacional = '(Q.codigo_auxiliar like ''FUN%'' or Q.codigo_auxiliar like ''ODT%'' ) ';
                    ELSE
                        v_filtro_internacional = '0=0';
                    END IF;
                ELSE
                    v_filtro_internacional = '0=0';
                END IF;
           END IF;

            --Sentencia de la consulta
            v_consulta:='select
                            Q.id_auxiliar,
                            Q.codigo_auxiliar,
                            Q.nombre_auxiliar,
                            Q.id_cuenta,
                            Q.nro_cuenta,
                            Q.nombre_cuenta,
                            Q.tipo_cuenta,
                            Q.sub_tipo_cuenta,
                            Q.desc_sub_tipo_cuenta,
                            Q.id_config_subtipo_cuenta,
                            Q.importe_debe_mb,
                            Q.importe_haber_mb,
                            Q.saldo,
                            pro.internacional
                       from
                       (select
                        aux.id_auxiliar,
                        aux.codigo_auxiliar,
                        aux.nombre_auxiliar,
                        cue.id_cuenta,
                        cue.nro_cuenta,
                        cue.nombre_cuenta,
                        ctc.tipo_cuenta,
                        csc.codigo as sub_tipo_cuenta,
                        csc.descripcion as desc_sub_tipo_cuenta,
                        csc.id_config_subtipo_cuenta,

                        COALESCE(sum(transa.importe_debe_mb),0) as importe_debe_mb,
                        COALESCE(sum(transa.importe_haber_mb),0) as importe_haber_mb,
                        COALESCE(sum(transa.importe_debe_mb),0) -  COALESCE(sum(transa.importe_haber_mb),0) as saldo

                        FROM conta.tint_transaccion transa
                        inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                        inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                        inner join conta.tconfig_tipo_cuenta ctc on ctc.tipo_cuenta = cue.tipo_cuenta
                        inner join conta.tconfig_subtipo_cuenta csc on csc.id_config_subtipo_cuenta = cue.id_config_subtipo_cuenta
                        inner join conta.tauxiliar aux on aux.id_auxiliar = transa.id_auxiliar
                        WHERE icbte.estado_reg = ''validado''
                              AND (icbte.fecha::Date between '''||v_parametros.desde||'''::Date and '''||v_parametros.hasta||'''::date)
                              AND '||v_filtro_cuentas ||' AND '|| v_filtro_aux||' AND '||v_filtro_tipo;

                v_consulta:=v_consulta||' GROUP by
                                          aux.id_auxiliar,
                                          aux.codigo_auxiliar,
                                          aux.nombre_auxiliar,
                                          cue.id_cuenta,
                                          cue.nro_cuenta,
                                          cue.nombre_cuenta,
                                          ctc.tipo_cuenta,
                                          csc.id_config_subtipo_cuenta,
                                          csc.codigo,
                                          csc.descripcion ';
            --Definicion de la respuesta
            v_consulta:=v_consulta||' ) Q    --#65
            left join param.tproveedor pro on pro.id_auxiliar = Q.id_auxiliar   --#65
            where '||v_filtro_internacional||' and ';  --#65
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||v_aux;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
           -- raise notice '%',v_consulta;
          --  raise exception '%',v_consulta;
            --Devuelve la respuesta
            return v_consulta;
        end;

    /*********************************
    #TRANSACCION:  'CONTA_AUXMAY_CONT'
    #DESCRIPCION:   Conteo de registros de interface de auxiliar de mayores
    #AUTOR:     admin
    #FECHA:     01-09-2013 18:10:12
    ***********************************/

    elsif(p_transaccion='CONTA_AUXMAY_CONT')then

        begin

           v_filtro_aux = ' 0=0 ';
           v_filtro_cuentas = ' 0=0 ';
           v_filtro_tipo = ' 0=0 ';
            v_aux = 'and 0=0 ';

            IF v_parametros.tipo_estado='abierto' then
                v_aux = 'AND saldo!=0';
            END IF;
             IF  pxp.f_existe_parametro(p_tabla,'id_cuenta')  THEN

                  IF v_parametros.id_cuenta is not NULL THEN

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

            IF  pxp.f_existe_parametro(p_tabla,'id_auxiliar')  THEN
             IF v_parametros.id_auxiliar is not NULL THEN
                v_filtro_aux = ' transa.id_auxiliar in ('||v_parametros.id_auxiliar::varchar||') ';
             END IF;

            END IF;

             IF  pxp.f_existe_parametro(p_tabla,'id_config_subtipo_cuenta')  THEN

             IF v_parametros.id_config_subtipo_cuenta is not NULL THEN
                v_filtro_tipo = ' csc.id_config_subtipo_cuenta in ('||v_parametros.id_config_subtipo_cuenta::varchar||') ';
             END IF;

            END IF;
            --#65 se agrega filtro segun el tipo que se elija
            IF  pxp.f_existe_parametro(p_tabla,'tipo')  THEN
                IF v_parametros.tipo is not NULL THEN
                    IF v_parametros.tipo = 'internacional' THEN
                        v_filtro_internacional = ' pro.internacional = ''si'' ';
                    ELSIF v_parametros.tipo = 'nacional' THEN
                        v_filtro_internacional = ' pro.internacional = ''no'' ';
                    ELSIF v_parametros.tipo = 'interno' THEN
                        v_filtro_internacional = '(det.codigo_auxiliar like ''FUN%'' or det.codigo_auxiliar like ''ODT%'' ) ';
                    ELSE
                        v_filtro_internacional = '0=0';
                    END IF;
                ELSE
                    v_filtro_internacional = '0=0';
                END IF;
           END IF;

            --Sentencia de la consulta de conteo de registros
            v_consulta:='select
                            count (*),
                            COALESCE(sum(importe_debe_mb),0) as importe_debe_mb,
                            COALESCE(sum(importe_haber_mb),0) as importe_haber_mb,
                            sum(det.saldo) as saldo
                          from ( select

                                                      aux.id_auxiliar,
                                                      aux.codigo_auxiliar,
                                                      aux.nombre_auxiliar,
                                                      cue.nro_cuenta,
                                                      cue.nombre_cuenta,
                                                      ctc.tipo_cuenta,
                                                      csc.codigo as sub_tipo_cuenta,
                                                      csc.descripcion as desc_sub_tipo_cuenta,
                                                      csc.id_config_subtipo_cuenta,
                                                      COALESCE(sum(transa.importe_debe_mb),0) as importe_debe_mb,
                                                      COALESCE(sum(transa.importe_haber_mb),0) as importe_haber_mb,
                                                      COALESCE(sum(transa.importe_debe_mb),0) -  COALESCE(sum(transa.importe_haber_mb),0) as saldo

                                                  FROM conta.tint_transaccion transa
                                                  inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                                                  inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                                                  inner join conta.tconfig_tipo_cuenta ctc on ctc.tipo_cuenta = cue.tipo_cuenta
                                                  inner join conta.tconfig_subtipo_cuenta csc on csc.id_config_subtipo_cuenta = cue.id_config_subtipo_cuenta
                                                  inner join conta.tauxiliar aux on aux.id_auxiliar = transa.id_auxiliar
                                                  WHERE

                                                             icbte.estado_reg = ''validado''
                                                         AND (icbte.fecha::Date between '''||v_parametros.desde||'''::Date and '''||v_parametros.hasta||'''::date)
                                                         AND '||v_filtro_cuentas ||' AND '|| v_filtro_aux||' AND '||v_filtro_tipo;





             v_consulta:=v_consulta||'

                                                  GROUP by

                                                                    aux.id_auxiliar,
                                                                    aux.codigo_auxiliar,
                                                                    aux.nombre_auxiliar,
                                                                    cue.id_cuenta,
                                                                    cue.nro_cuenta,
                                                                    cue.nombre_cuenta,
                                                                    ctc.tipo_cuenta,
                                                                    csc.codigo,
                                                                    csc.id_config_subtipo_cuenta,
                                                                    csc.descripcion

                                                                    ) det
                          left join param.tproveedor pro on pro.id_auxiliar = det.id_auxiliar --#65
                          where '||v_filtro_internacional||' and '; --#65
            --raise exception '------>   %',p_transaccion;



            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
             v_consulta:=v_consulta||v_aux;
           -- raise notice '%',v_consulta;

            --Devuelve la respuesta
            return v_consulta;

        end;

    /*********************************
    #TRANSACCION:  'CONTA_TOTAUX_SEL'
    #DESCRIPCION:   consulta para grilla que reporta el total por auxiliar
    #AUTOR:     MP
    #FECHA:     01-09-2013 18:10:12
    ***********************************/

    elseif(p_transaccion='CONTA_TOTAUX_SEL')then
        begin
            v_filtro_aux = ' 0=0 ';
            v_cuentas = ' 0=0 ';
            v_filtro_tipo = ' 0=0 ';
            v_aux = 'and 0=0 ';

            IF v_parametros.tipo_estado='abierto' then
                v_aux = 'AND saldo!=0';
            END IF;

            IF pxp.f_existe_parametro(p_tabla,'id_cuenta')  THEN
                IF v_parametros.id_cuenta is not NULL THEN
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
                    into v_cuentas
                    FROM cuenta_rec;
                    v_cuentas = 'cue.id_cuenta in ('||v_cuentas||')';
                    v_auxiliar='cue.id_cuenta';
                    v_auxiliar_b='cue.id_cuenta,';
                else
                    v_auxiliar='null::integer';
                    v_auxiliar_b='';
                END IF;
            END IF;

            IF  pxp.f_existe_parametro(p_tabla,'id_auxiliar')  THEN
                IF v_parametros.id_auxiliar is not NULL THEN
                    v_filtro_aux = ' transa.id_auxiliar in ('||v_parametros.id_auxiliar::varchar||') ';
                END IF;
            END IF;

            IF  pxp.f_existe_parametro(p_tabla,'id_config_subtipo_cuenta')  THEN
                IF v_parametros.id_config_subtipo_cuenta is not NULL THEN
                    v_filtro_tipo = ' csc.id_config_subtipo_cuenta in ('||v_parametros.id_config_subtipo_cuenta::varchar||') ';
                END IF;
            END IF;
            --preguntar si id_cuenta es nulo no enviar
            IF v_parametros.id_config_subtipo_cuenta is not NULL THEN
                v_auxiliar_c = 'csc.id_config_subtipo_cuenta';
                v_auxiliar_d = 'csc.id_config_subtipo_cuenta';
            ELSE
                v_auxiliar_c = '0';
                v_auxiliar_d = 'aux.aplicacion';
            END IF;
           --#65 se agrega filtro segun el tipo que se elija
           IF  pxp.f_existe_parametro(p_tabla,'tipo')  THEN
                IF v_parametros.tipo is not NULL THEN
                    IF v_parametros.tipo = 'internacional' THEN
                        v_filtro_internacional = ' pro.internacional = ''si'' ';
                    ELSIF v_parametros.tipo = 'nacional' THEN
                        v_filtro_internacional = ' pro.internacional = ''no'' ';
                    ELSIF v_parametros.tipo = 'interno' THEN
                        v_filtro_internacional = '(Q.codigo_auxiliar like ''FUN%'' or Q.codigo_auxiliar like ''ODT%'' ) ';
                    ELSE
                        v_filtro_internacional = '0=0';
                    END IF;
                ELSE
                    v_filtro_internacional = '0=0';
                END IF;
           END IF;
            --Sentencia de la consulta
            v_consulta:='select
                            Q.id_auxiliar,
                            Q.codigo_auxiliar,
                            Q.nombre_auxiliar,
                            Q.id_cuenta,
                            Q.nro_cuenta,
                            Q.nombre_cuenta,
                            Q.tipo_cuenta,
                            Q.sub_tipo_cuenta,
                            Q.desc_sub_tipo_cuenta,
                            Q.id_config_subtipo_cuenta,
                            Q.importe_debe_mb,
                            Q.importe_haber_mb,
                            Q.saldo,
                            pro.internacional  --#65
                       from
                       (
                          select
                          aux.id_auxiliar,
                          aux.codigo_auxiliar,
                          aux.nombre_auxiliar,
                          '||v_auxiliar||' AS id_cuenta,
                          NULL::VARCHAR AS nro_cuenta,
                          NULL::VARCHAR AS nombre_cuenta,
                          NULL::VARCHAR AS tipo_cuenta,
                          NULL::VARCHAR AS sub_tipo_cuenta,
                          NULL::VARCHAR AS desc_sub_tipo_cuenta,
                          '||v_auxiliar_c||' as id_config_subtipo_cuenta,

                          COALESCE(sum(transa.importe_debe_mb),0) as importe_debe_mb,
                          COALESCE(sum(transa.importe_haber_mb),0) as importe_haber_mb,
                          COALESCE(sum(transa.importe_debe_mb),0) - COALESCE(sum(transa.importe_haber_mb),0) as saldo

                          FROM conta.tint_transaccion transa
                          inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                          inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
                          inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                          inner join conta.tconfig_tipo_cuenta ctc on ctc.tipo_cuenta = cue.tipo_cuenta
                          inner join conta.tconfig_subtipo_cuenta csc on csc.id_config_subtipo_cuenta = cue.id_config_subtipo_cuenta
                          left join pre.tpartida par on par.id_partida = transa.id_partida
                          left join conta.tauxiliar aux on aux.id_auxiliar = transa.id_auxiliar
                          WHERE icbte.estado_reg = ''validado''
                          AND (icbte.fecha::Date between '''||v_parametros.desde||'''::Date and '''||v_parametros.hasta||'''::date)
                          AND '||v_filtro_aux||'
                          AND '||v_filtro_tipo ||'
                          AND '||v_cuentas ||'
                          ';
            v_consulta:=v_consulta||'GROUP BY
                                    aux.id_auxiliar,
                                    aux.codigo_auxiliar,
                                    aux.nombre_auxiliar,
                                    '||v_auxiliar_b||'
                                    '||v_auxiliar_d||'
                                    ORDER BY
                                    aux.codigo_auxiliar
                                    ';
            v_consulta:=v_consulta||' ) Q
            left join param.tproveedor pro on pro.id_auxiliar = Q.id_auxiliar      --#65
            where '||v_filtro_internacional||' and '; --#65
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||v_aux;
             v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --Devuelve la respuesta
            return v_consulta;
        end;
        /*********************************
        #TRANSACCION:  'CONTA_TOTAUX_CONT'
        #DESCRIPCION:   Conteo de registros de interface de total de mayores
        #AUTOR:     mp
        #FECHA:     01-09-2018 18:10:12
        ***********************************/


            elsif(p_transaccion='CONTA_TOTAUX_CONT')then

            begin
            v_filtro_aux = ' 0=0 ';
            v_cuentas = ' 0=0 ';
            v_filtro_tipo = ' 0=0 ';
            v_aux = 'and 0=0 ';

            IF v_parametros.tipo_estado='abierto' then
                v_aux = 'AND saldo!=0';
            END IF;

            IF pxp.f_existe_parametro(p_tabla,'id_cuenta')  THEN
                IF v_parametros.id_cuenta is not NULL THEN
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
                    into v_cuentas
                    FROM cuenta_rec;
                    v_cuentas = 'cue.id_cuenta in ('||v_cuentas||')';
                     v_auxiliar='cue.id_cuenta';
                    v_auxiliar_b='cue.id_cuenta,';
                else
                    v_auxiliar='null::integer';
                    v_auxiliar_b='';
                END IF;
            END IF;

            IF  pxp.f_existe_parametro(p_tabla,'id_auxiliar')  THEN
                IF v_parametros.id_auxiliar is not NULL THEN
                    v_filtro_aux = ' transa.id_auxiliar in ('||v_parametros.id_auxiliar::varchar||') ';
                END IF;
            END IF;

            IF  pxp.f_existe_parametro(p_tabla,'id_config_subtipo_cuenta')  THEN
                IF v_parametros.id_config_subtipo_cuenta is not NULL THEN
                    v_filtro_tipo = ' csc.id_config_subtipo_cuenta in ('||v_parametros.id_config_subtipo_cuenta::varchar||') ';
                END IF;
            END IF;
            --#5
            --preguntar si id_cuenta es nulo no enviar
            IF v_parametros.id_config_subtipo_cuenta is not NULL THEN
                v_auxiliar_c = 'csc.id_config_subtipo_cuenta';
                v_auxiliar_d = 'csc.id_config_subtipo_cuenta';
            ELSE
                v_auxiliar_c = '0';
                v_auxiliar_d = 'aux.aplicacion';
            END IF;
           --#65 se agrega filtro segun el tipo que se elija
           IF  pxp.f_existe_parametro(p_tabla,'tipo')  THEN
                IF v_parametros.tipo is not NULL THEN
                    IF v_parametros.tipo = 'internacional' THEN
                        v_filtro_internacional = ' pro.internacional = ''si'' ';
                    ELSIF v_parametros.tipo = 'nacional' THEN
                        v_filtro_internacional = ' pro.internacional = ''no'' ';
                    ELSIF v_parametros.tipo = 'interno' THEN
                        v_filtro_internacional = '(Q.codigo_auxiliar like ''FUN%'' or Q.codigo_auxiliar like ''ODT%'' ) ';
                    ELSE
                        v_filtro_internacional = '0=0';
                    END IF;
                ELSE
                    v_filtro_internacional = '0=0';
                END IF;
           END IF;

            --Sentencia de la consulta de conteo de registros
            v_consulta:='select
                            count (*),
                            COALESCE(sum(importe_debe_mb),0) as importe_debe_mb,
                            COALESCE(sum(importe_haber_mb),0) as importe_haber_mb,
                            sum(saldo) as saldo
                        from
                        (
                          select
                          aux.id_auxiliar,
                          aux.codigo_auxiliar,
                          aux.nombre_auxiliar,
                          '||v_auxiliar||' AS id_cuenta,
                          NULL::VARCHAR AS nro_cuenta,
                          NULL::VARCHAR AS nombre_cuenta,
                          NULL::VARCHAR AS tipo_cuenta,
                          NULL::VARCHAR AS sub_tipo_cuenta,
                          NULL::VARCHAR AS desc_sub_tipo_cuenta,
                          '||v_auxiliar_c||' as id_config_subtipo_cuenta,

                          COALESCE(sum(transa.importe_debe_mb),0) as importe_debe_mb,
                          COALESCE(sum(transa.importe_haber_mb),0) as importe_haber_mb,
                          COALESCE(sum(transa.importe_debe_mb),0) - COALESCE(sum(transa.importe_haber_mb),0) as saldo

                          FROM conta.tint_transaccion transa
                          inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                          inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
                          inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                          inner join conta.tconfig_tipo_cuenta ctc on ctc.tipo_cuenta = cue.tipo_cuenta
                          inner join conta.tconfig_subtipo_cuenta csc on csc.id_config_subtipo_cuenta = cue.id_config_subtipo_cuenta
                          left join pre.tpartida par on par.id_partida = transa.id_partida
                          left join conta.tauxiliar aux on aux.id_auxiliar = transa.id_auxiliar
                          WHERE icbte.estado_reg = ''validado''
                          AND (icbte.fecha::Date between '''||v_parametros.desde||'''::Date and '''||v_parametros.hasta||'''::date)
                          AND '||v_filtro_aux||'
                          AND '||v_filtro_tipo ||'
                          AND '||v_cuentas ||'
                          ';
            v_consulta:=v_consulta||'GROUP BY
                                    aux.id_auxiliar,
                                    aux.codigo_auxiliar,
                                    aux.nombre_auxiliar,
                                    '||v_auxiliar_b||'
                                    '||v_auxiliar_d||'
                                    ORDER BY
                                    aux.codigo_auxiliar
                                    ';
            v_consulta:=v_consulta||' ) Q
            left join param.tproveedor pro on pro.id_auxiliar = Q.id_auxiliar   --#65
            where '||v_filtro_internacional||' and ';     --#65
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||v_aux;

            --Devuelve la respuesta
            return v_consulta;

        end;
    /*********************************
    #TRANSACCION:  'CONTA_LDCTRANS_SEL'
    #DESCRIPCION:
    #AUTOR:     JUAN
    #FECHA:     01-09-2013 18:10:12
    ***********************************/

    elseif(p_transaccion='CONTA_LDCTRANS_SEL')then

        begin
             v_filtro_cuentas = '';
            IF  pxp.f_existe_parametro(p_tabla,'id_cuenta')  THEN
                  IF v_parametros.id_cuenta is not NULL THEN
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
                    into v_cuentas
                    FROM cuenta_rec;
                    v_filtro_cuentas = '  cue.id_cuenta in ('||v_cuentas||') and';
                END IF;
            END IF;
           --- raise exception '%',v_filtro_cuentas;
            IF  v_parametros.tipo_reporte='auditoria' THEN
               v_atributos := ',pers.nombre_completo2::varchar as usuario_reg_transaccion,
                               dcv.nro_documento,
                               conta.fnorm_text_latin(itr.glosa)::varchar as glosa_transaccion
                               ';
               v_join :='left join segu.tusuario usu on usu.id_usuario= itr.id_usuario_reg
                         left join segu.vpersona pers on pers.id_persona=usu.id_persona
                         left join conta.tdoc_compra_venta dcv on dcv.id_int_comprobante=icbt.id_int_comprobante';
               ELSE
               v_atributos := ', '' ''::varchar as usuario_reg_transaccion,
                              '' ''::varchar as nro_documento,
                              conta.fnorm_text_latin(itr.glosa)::varchar as glosa_transaccion
                             ';
               v_join := '';
            END IF;
            --#111 correcion de logica
            v_consulta:='select
                          itr.id_int_transaccion ,
                          icbt.id_int_comprobante , icbt.fecha_reg , icbt.fecha , icbt.nro_cbte , icbt.nro_tramite ,
                          regexp_replace(regexp_replace(tcc.descripcion,''[\n\t ]'','''',''g''),''[áéíóúñÁÉÍÓÚÑº´"]'',''*'',''g'')::varchar as glosa1 ,
                          coalesce(itr.importe_debe_mb,0) as debe_mb ,
                          coalesce(itr.importe_haber_mb,0) as haber_mb ,
                          (coalesce(itr.importe_debe_mb,0) - coalesce(itr.importe_haber_mb,0)) as saldo_debehaber_mb,

                        --#69 SE HAN ELIMINADO 3 COLUMNAS
                          coalesce(itr.importe_debe_mt,0) as debe_mt,
                          coalesce(itr.importe_haber_mt,0) as haber_mt,
                          (coalesce(itr.importe_debe_mt,0) - coalesce(itr.importe_haber_mt,0)) as saldo_debehaber_mt,

                        --#69 SE HAN ELIMINADO 3 COLUMNAS
                          coalesce(itr.importe_debe_ma,0) as debe_ma,
                          coalesce(itr.importe_haber_ma,0) as haber_ma,
                          (coalesce(itr.importe_debe_ma,0) - coalesce(itr.importe_haber_ma,0)) as saldo_debehaber_ma,

                       --#69 SE HAN ELIMINADO 3 COLUMNAS
                          icbt.tipo_cambio_3 as tc_ufv,
                          cue.tipo_cuenta ,
                          cue.nro_cuenta as cuenta_nro,
                          cue.nombre_cuenta as cuenta ,

                          par.sw_movimiento as partida_tipo,
                          par.codigo as partida_codigo,
                          par.nombre_partida as partida ,
                          regexp_replace(regexp_replace(tcct.codigo_techo,''[\n\t\r ]'','''',''g''),''[áéíóúñÁÉÍÓÚÑº´"]'',''*'',''g'')::varchar as centro_costo_techo_codigo,
                          regexp_replace(regexp_replace(tcct.descripcion_techo,''[\n\t\r ]'','''',''g''),''[áéíóúñÁÉÍÓÚÑº´"]'',''*'',''g'')::varchar as centro_costo_techo,
                          regexp_replace(regexp_replace(tcc.codigo,''[\n\t\r ]'','''',''g''),''[áéíóúñÁÉÍÓÚÑº´"]'',''*'',''g'')::varchar as centro_costo_codigo,
                          regexp_replace(regexp_replace(tcc.descripcion,''[\n\t\r ]'','''',''g''),''[áéíóúñÁÉÍÓÚÑº´"]'',''*'',''g'')::varchar as centro_costo ,
                          regexp_replace(regexp_replace(aux.codigo_auxiliar,''[\n\t\r ]'','''',''g''),''[áéíóúñÁÉÍÓÚÑº´"]'',''*'',''g'')::varchar as aux_codigo,
                          regexp_replace(regexp_replace(aux.nombre_auxiliar,''[\n\t\r ]'','''',''g''),''[áéíóúñÁÉÍÓÚÑº´"]'',''*'',''g'')::varchar as aux_nombre, 
                          (case when icbt.manual=''no'' then ''automática'' else ''manual'' end)::varchar as tipo_transaccion,
                          param.f_get_periodo_literal(per.id_periodo)::varchar as periodo,
                          to_char(itr.fecha_reg, ''HH12:MI:SS'')::varchar as hora,
                          itr.fecha_reg::timestamp as fecha_reg_transaccion
                          '||v_atributos||',
                          tpp.nombre,

                          --#69 SE ADICIONAN 6 NUEVAS COLUMNAS
                          --#69 SE MODIFICA LA EMPRESION REGULAR [\n\t] por [\n\t\r ]
                          conta.fnorm_text_latin(vc.beneficiario)::varchar as beneficiario,
                          vc.desc_clase_comprobante as tipo_cbte,
                          conta.fnorm_text_latin(vc.glosa1)::varchar as glosa,
                          us.desc_persona as persona_create,
                          um.desc_persona as persona_mod,
                          vc.nro_tramite_aux
                          --- HASTA AQUI

                          from conta.tint_comprobante icbt
                          join param.tperiodo per on per.id_periodo = icbt.id_periodo
                          join conta.tint_transaccion itr on itr.id_int_comprobante = icbt.id_int_comprobante
                          join conta.tcuenta cue on cue.id_cuenta = itr.id_cuenta
                          left join pre.tpartida par on par.id_partida = itr.id_partida
                          join param.tcentro_costo cc on cc.id_centro_costo=itr.id_centro_costo
                          join pre.tpresupuesto pre on pre.id_centro_costo=cc.id_centro_costo
                          join pre.ttipo_presupuesto tpp on pre.tipo_pres=tpp.codigo
                          inner join conta.vint_comprobante vc on vc.id_int_comprobante = icbt.id_int_comprobante  --NUEVO
                          inner join segu.vusuario us on us.id_usuario = vc.id_usuario_reg
                          left join segu.vusuario um on um.id_usuario = vc.id_usuario_mod       --NUEVO
                          left join param.ttipo_cc tcc on tcc.id_tipo_cc=cc.id_tipo_cc
                          left join param.vtipo_cc_techo tcct on tcc.id_tipo_cc =any (tcct.ids)
                          left join conta.tauxiliar aux on aux.id_auxiliar = itr.id_auxiliar
                          '||v_join||'
                          where icbt.estado_reg = ''validado'' and'||v_filtro_cuentas;
           

            v_consulta:=v_consulta||v_parametros.filtro;
            return v_consulta;

        end;
        /*********************************
        #TRANSACCION:  'CONTA_LDCTRANS_CONT'
        #DESCRIPCION:
        #AUTOR:     Admin
        #FECHA:     01-09-2018 18:10:12
        ***********************************/

        elsif(p_transaccion='CONTA_LDCTRANS_CONT')then

            begin



            v_consulta:='select
                          count(itr.id_int_transaccion)

                          from conta.tint_comprobante icbt
                          join param.tperiodo per on per.id_periodo = icbt.id_periodo
                          join conta.tint_transaccion itr on itr.id_int_comprobante = icbt.id_int_comprobante
                          join conta.tcuenta cue on cue.id_cuenta = itr.id_cuenta
                          join pre.tpartida par on par.id_partida = itr.id_partida
                          join param.tcentro_costo cc on cc.id_centro_costo=itr.id_centro_costo
                          left join param.ttipo_cc tcc on tcc.id_tipo_cc=cc.id_tipo_cc
                          left join param.vtipo_cc_techo tcct on tcc.id_tipo_cc =any (tcct.ids)
                          left join conta.tauxiliar aux on aux.id_auxiliar = itr.id_auxiliar

                          where icbt.estado_reg = ''validado''
                          AND per.id_gestion = 2
                          --  AND (icbt.fecha::date BETWEEN ''%01/01/2018%''::date and ''%01/10/2018%''::date)
                          --  AND icbt.id_int_comprobante=1440
                          AND ';


            v_consulta:=v_consulta||v_parametros.filtro;



            return v_consulta;

        end;
     --------------#92 INI-MMV------------
         /*********************************
        #TRANSACCION:  'CONTA_MROMAYOR_SEL' #92
        #DESCRIPCION:   actualización reporte de detalle de auxiliares
        #AUTOR:     MMV
        #FECHA:     07-12-2018
        ***********************************/
        elseif(p_transaccion='CONTA_MROMAYOR_SEL')then

            begin

                if (v_parametros.nro_tramite = 'normal')then --MMV #10
                     v_filto_nro = 't.nro_tramite ';
                else
                     v_filto_nro  = 'cb.nro_tramite_aux';
                end if ; --MMV #10

                 v_consulta:='with basica as (select    cb.id_int_comprobante,
                                                        t.id_cuenta,
                                                        cu.nro_cuenta,
                                                        cu.nombre_cuenta,
                                                        COALESCE(t.id_auxiliar,0) as id_auxiliar,
                                                        au.codigo_auxiliar,
                                                        au.nombre_auxiliar,
                                                        '||v_filto_nro||' as nro_tramite,  --MMV #10
                                                        cb.fecha,
                                                        cb.glosa1,
                                                        t.importe_debe_mb,
                                                        t.importe_haber_mb,
                                                        t.importe_debe_mt,
                                                        t.importe_haber_mt,
                                                        t.importe_debe_ma,
                                                        t.importe_haber_ma
                                                        from conta.tint_transaccion t
                                                        inner join conta.tint_comprobante cb on cb.id_int_comprobante = t.id_int_comprobante
                                                        inner join conta.tcuenta cu on cu.id_cuenta = t.id_cuenta
                                                        inner  join conta.tauxiliar au on au.id_auxiliar = t.id_auxiliar
                                                        inner join conta.tconfig_subtipo_cuenta su on su.id_config_subtipo_cuenta = cu.id_config_subtipo_cuenta
                                                        inner join conta.tconfig_tipo_cuenta tc on tc.id_config_tipo_cuenta = su.id_config_tipo_cuenta
                                                        inner join param.tperiodo pe on pe.id_periodo = cb.id_periodo
                                                        where cb.estado_reg = ''validado'' and  t.id_auxiliar = '||v_parametros.id_auxiliar||'
                                                        and pe.id_gestion = '||v_parametros.id_gestion||' and  cb.fecha::date BETWEEN '''||v_parametros.desde||'''::Date and '''||v_parametros.hasta||'''::date)
                                 select  t.id_int_comprobante,
                                         t.id_cuenta,
                                         t.nro_cuenta,
                                         t.nombre_cuenta,
                                         t.id_auxiliar,
                                         t.codigo_auxiliar,
                                         t.nombre_auxiliar,
                                         t.nro_tramite,
                                         t.fecha,
                                         t.glosa1,
                                         sum(COALESCE(t.importe_debe_mb,0)) as importe_debe_mb,
                                         sum(COALESCE(t.importe_haber_mb,0)) as importe_haber_mb,
                                         (case
                                              when sum(COALESCE(t.importe_haber_mb,0)) >  sum(COALESCE(t.importe_debe_mb,0)) then
                                                   sum(COALESCE(t.importe_haber_mb,0)) - sum(COALESCE(t.importe_debe_mb,0))
                                              when sum(COALESCE(t.importe_debe_mb,0)) > sum(COALESCE(t.importe_haber_mb,0)) then
                                                  sum(COALESCE(t.importe_debe_mb,0)) - sum(COALESCE(t.importe_haber_mb,0))
                                          end )as saldo_mb,
                                         sum(COALESCE(t.importe_debe_mt,0)) as importe_debe_mt,
                                         sum(COALESCE(t.importe_haber_mt,0)) as importe_haber_mt,
                                          (case
                                              when sum(COALESCE(t.importe_haber_mt,0)) >  sum(COALESCE(t.importe_debe_mt,0)) then
                                                   sum(COALESCE(t.importe_haber_mt,0)) - sum(COALESCE(t.importe_debe_mt,0))
                                              when sum(COALESCE(t.importe_debe_mt,0)) > sum(COALESCE(t.importe_haber_mt,0)) then
                                                  sum(COALESCE(t.importe_debe_mt,0)) - sum(COALESCE(t.importe_haber_mt,0))
                                          end )as saldo_mt,
                                         sum(COALESCE(t.importe_debe_ma,0)) as importe_debe_ma,
                                         sum(COALESCE(t.importe_haber_ma,0)) as importe_haber_ma,
                                         (case
                                              when sum(COALESCE(t.importe_haber_ma,0)) >  sum(COALESCE(t.importe_debe_ma,0)) then
                                                   sum(COALESCE(t.importe_haber_ma,0)) - sum(COALESCE(t.importe_debe_ma,0))
                                              when sum(COALESCE(t.importe_debe_ma,0)) > sum(COALESCE(t.importe_haber_ma,0)) then
                                                  sum(COALESCE(t.importe_debe_ma,0)) - sum(COALESCE(t.importe_haber_ma,0))
                                        end )as saldo_ma
                                       from basica t
                                       where ';
              --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||'group by  t.id_cuenta,
                                               t.nro_cuenta,
                                               t.id_auxiliar,
                                               t.nro_tramite,
                                               t.codigo_auxiliar,
                                               t.nombre_cuenta,
                                               t.nombre_auxiliar,
                                               t.fecha,
                                               t.id_int_comprobante,
                                               t.glosa1 order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;


                 return v_consulta;
                raise notice '%',v_consulta;
            end;


        /*********************************
        #TRANSACCION:  'CONTA_MROMAYOR_CONT' #92
        #DESCRIPCION:   count actualización reporte de detalle de auxiliares
        #AUTOR:     MMV
        #FECHA:     07-12-2018
        ***********************************/

        elsif(p_transaccion='CONTA_MROMAYOR_CONT')then

            begin

            if (v_parametros.nro_tramite = 'normal')then--MMV #10
                v_filto_nro = 't.nro_tramite ';
            else
                v_filto_nro  = 'cb.nro_tramite_aux';
            end if ; --MMV #10

            v_consulta:= 'with basica as (select    cb.id_int_comprobante,
                                                    t.id_cuenta,
                                                    cu.nro_cuenta,
                                                    cu.nombre_cuenta,
                                                    COALESCE(t.id_auxiliar,0) as id_auxiliar,
                                                    au.codigo_auxiliar,
                                                    au.nombre_auxiliar,
                                                    '||v_filto_nro||' as nro_tramite, --MMV #10
                                                    cb.fecha,
                                                    t.importe_debe_mb,
                                                    t.importe_haber_mb,
                                                    t.importe_debe_mt,
                                                    t.importe_haber_mt,
                                                    t.importe_debe_ma,
                                                    t.importe_haber_ma
                                                    from conta.tint_transaccion t
                                                    inner join conta.tint_comprobante cb on cb.id_int_comprobante = t.id_int_comprobante
                                                    inner join conta.tcuenta cu on cu.id_cuenta = t.id_cuenta
                                                    inner  join conta.tauxiliar au on au.id_auxiliar = t.id_auxiliar
                                                    inner join conta.tconfig_subtipo_cuenta su on su.id_config_subtipo_cuenta = cu.id_config_subtipo_cuenta
                                                    inner join conta.tconfig_tipo_cuenta tc on tc.id_config_tipo_cuenta = su.id_config_tipo_cuenta
                                                    inner join param.tperiodo pe on pe.id_periodo = cb.id_periodo
                                                    where cb.estado_reg = ''validado'' and  t.id_auxiliar = '||v_parametros.id_auxiliar||'
                                                    and pe.id_gestion = '||v_parametros.id_gestion||' and  cb.fecha::date BETWEEN '''||v_parametros.desde||'''::Date and '''||v_parametros.hasta||'''::date),
                                contar as (select    t.id_int_comprobante,
                                                     t.id_cuenta,
                                                     t.nro_cuenta,
                                                     t.nombre_cuenta,
                                                     t.id_auxiliar,
                                                     t.codigo_auxiliar,
                                                     t.nombre_auxiliar,
                                                     t.nro_tramite,
                                                     t.fecha,
                                                     sum(COALESCE(t.importe_debe_mb,0)) as importe_debe_mb,
                                                     sum(COALESCE(t.importe_haber_mb,0)) as importe_haber_mb,
                                                     sum(COALESCE(t.importe_debe_mt,0)) as importe_debe_mt,
                                                     sum(COALESCE(t.importe_haber_mt,0)) as importe_haber_mt,
                                                     sum(COALESCE(t.importe_debe_ma,0)) as importe_debe_ma,
                                                     sum(COALESCE(t.importe_haber_ma,0)) as importe_haber_ma
                                                   from basica t
                                                   group by
                                                     t.id_cuenta,
                                                     t.nro_cuenta,
                                                     t.id_auxiliar,
                                                     t.nro_tramite,
                                                     t.codigo_auxiliar,
                                                     t.nombre_cuenta,
                                                     t.nombre_auxiliar,
                                                     t.fecha,
                                                     t.id_int_comprobante)
                                  select count(c.id_int_comprobante),
                                         sum (c.importe_debe_mb) as importe_debe_mb_total,
                                         sum (c.importe_haber_mb) as importe_haber_mb_total,
                                         (case
                                              when sum(COALESCE(c.importe_haber_mb,0)) >  sum(COALESCE(c.importe_debe_mb,0)) then
                                                   sum(COALESCE(c.importe_haber_mb,0)) - sum(COALESCE(c.importe_debe_mb,0))
                                              when sum(COALESCE(c.importe_debe_mb,0)) > sum(COALESCE(c.importe_haber_mb,0)) then
                                                  sum(COALESCE(c.importe_debe_mb,0)) - sum(COALESCE(c.importe_haber_mb,0))
                                          end )as saldo_mb_total,
                                         sum (c.importe_debe_mt) as importe_debe_mt_total,
                                         sum (c.importe_haber_mt) as importe_haber_mt_total,
                                          (case
                                              when sum(COALESCE(c.importe_haber_mt,0)) >  sum(COALESCE(c.importe_debe_mt,0)) then
                                                   sum(COALESCE(c.importe_haber_mt,0)) - sum(COALESCE(c.importe_debe_mt,0))
                                              when sum(COALESCE(c.importe_debe_mt,0)) > sum(COALESCE(c.importe_haber_mt,0)) then
                                                   sum(COALESCE(c.importe_debe_mt,0)) - sum(COALESCE(c.importe_haber_mt,0))
                                          end ) saldo_mt_total,
                                         sum (c.importe_debe_ma) as importe_debe_ma_total,
                                         sum (c.importe_haber_ma) as importe_haber_ma_total,
                                         (case
                                              when sum(COALESCE(c.importe_haber_ma,0)) >  sum(COALESCE(c.importe_debe_ma,0)) then
                                                   sum(COALESCE(c.importe_haber_ma,0)) - sum(COALESCE(c.importe_debe_ma,0))
                                              when sum(COALESCE(c.importe_debe_ma,0)) > sum(COALESCE(c.importe_haber_ma,0)) then
                                                  sum(COALESCE(c.importe_debe_ma,0)) - sum(COALESCE(c.importe_haber_ma,0))
                                        end ) as saldo_ma_total
                                  from contar c
                                  where ';
            v_consulta:=v_consulta||v_parametros.filtro;
            return v_consulta;

        end;
        /*********************************
        #TRANSACCION:  'CONTA_AUXRE_SEL' #92
        #DESCRIPCION:   actualización reporte de detalle de auxiliares formato xls
        #AUTOR:     MMV
        #FECHA:     07-12-2018
        ***********************************/
        elseif(p_transaccion='CONTA_AUXRE_SEL')then
            begin

                  CREATE TEMPORARY TABLE temporal(   id_int_comprobante integer,
                                                     id_cuenta integer,
                                                     nro_cuenta varchar,
                                                     nombre_cuenta varchar,
                                                     id_auxiliar integer,
                                                     codigo_auxiliar varchar,
                                                     nombre_auxiliar varchar,
                                                     nro_tramite varchar,
                                                     fecha date,
                                                     glosa1 varchar,
                                                     importe_debe_mb numeric,
                                                     importe_haber_mb numeric,
                                                     saldo_mb numeric,
                                                     importe_debe_mt numeric,
                                                     importe_haber_mt numeric,
                                                     saldo_mt numeric,
                                                     tipo varchar,
                                                     beneficiario varchar )ON COMMIT DROP; --#83

            with basica as (select  cb.id_int_comprobante,
                                    t.id_cuenta,
                                    cu.nro_cuenta,
                                    cu.nombre_cuenta,
                                    COALESCE(t.id_auxiliar,0) as id_auxiliar,
                                    au.codigo_auxiliar,
                                    au.nombre_auxiliar,
                                    case
                                      when v_parametros.nro_tramite = 'normal' then
                                       t.nro_tramite
                                      when v_parametros.nro_tramite = 'modificado' then
                                          cb.nro_tramite_aux
                                    end as nro_tramite, --MMV #10
                                    cb.fecha,
                                    cb.glosa1,
                                    cb.beneficiario, --#83
                                    t.importe_debe_mb,
                                    t.importe_haber_mb,
                                    t.importe_debe_mt,
                                    t.importe_haber_mt,
                                    t.importe_debe_ma,
                                    t.importe_haber_ma
                                  from conta.tint_transaccion t
                                    inner join conta.tint_comprobante cb on cb.id_int_comprobante = t.id_int_comprobante
                                    inner join conta.tcuenta cu on cu.id_cuenta = t.id_cuenta
                                    inner  join conta.tauxiliar au on au.id_auxiliar = t.id_auxiliar
                                    inner join conta.tconfig_subtipo_cuenta su on su.id_config_subtipo_cuenta = cu.id_config_subtipo_cuenta
                                    inner join conta.tconfig_tipo_cuenta tc on tc.id_config_tipo_cuenta = su.id_config_tipo_cuenta
                                    inner join param.tperiodo pe on pe.id_periodo = cb.id_periodo
                                    where cb.estado_reg = 'validado' and  t.id_auxiliar = v_parametros.id_auxiliar
                                    and pe.id_gestion = v_parametros.id_gestion and  cb.fecha::date BETWEEN v_parametros.desde and v_parametros.hasta
                                )insert into temporal(   id_int_comprobante,
                                                         id_cuenta,
                                                         nro_cuenta,
                                                         nombre_cuenta,
                                                         id_auxiliar,
                                                         codigo_auxiliar,
                                                         nombre_auxiliar,
                                                         nro_tramite,
                                                         fecha,
                                                         glosa1,
                                                         beneficiario, --#83
                                                         importe_debe_mb,
                                                         importe_haber_mb,
                                                         saldo_mb,
                                                         importe_debe_mt,
                                                         importe_haber_mt,
                                                         tipo)select   t.id_int_comprobante,
                                                                       t.id_cuenta,
                                                                       t.nro_cuenta,
                                                                       t.nombre_cuenta,
                                                                       t.id_auxiliar,
                                                                       t.codigo_auxiliar,
                                                                       t.nombre_auxiliar,
                                                                       t.nro_tramite,
                                                                       t.fecha,
                                                                       t.glosa1,
                                                                       t.beneficiario, --#83
                                                                       sum(COALESCE(t.importe_debe_mb,0)) as importe_debe_mb,
                                                                       sum(COALESCE(t.importe_haber_mb,0)) as importe_haber_mb,
                                                                       0::numeric as saldo_mb,
                                                                       sum(COALESCE(t.importe_debe_mt,0)) as importe_debe_mt,
                                                                       sum(COALESCE(t.importe_haber_mt,0)) as importe_haber_mt,
                                                                       'A'::varchar as tipo
                                                                     from basica t
                                                                     group by
                                                                       t.id_cuenta,
                                                                       t.nro_cuenta,
                                                                       t.id_auxiliar,
                                                                       t.nro_tramite,
                                                                       t.codigo_auxiliar,
                                                                       t.nombre_cuenta,
                                                                       t.nombre_auxiliar,
                                                                       t.fecha,
                                                                       t.id_int_comprobante,
                                                                       t.glosa1,
                                                                       t.beneficiario;
                ---totales
                        with basica as (select  cb.id_int_comprobante,
                                                t.id_cuenta,
                                                cu.nro_cuenta,
                                                cu.nombre_cuenta,
                                                COALESCE(t.id_auxiliar,0) as id_auxiliar,
                                                 au.codigo_auxiliar,
                                                 au.nombre_auxiliar,
                                                case
                                                    when v_parametros.nro_tramite = 'normal' then
                                                     t.nro_tramite
                                                    when v_parametros.nro_tramite = 'modificado' then
                                                        cb.nro_tramite_aux
                                                end as nro_tramite, --MMV #10
                                                cb.fecha,
                                                t.importe_debe_mb,
                                                t.importe_haber_mb,
                                                t.importe_debe_mt,
                                                t.importe_haber_mt,
                                                t.importe_debe_ma,
                                                t.importe_haber_ma
                                              from conta.tint_transaccion t
                                                inner join conta.tint_comprobante cb on cb.id_int_comprobante = t.id_int_comprobante
                                                inner join conta.tcuenta cu on cu.id_cuenta = t.id_cuenta
                                                inner  join conta.tauxiliar au on au.id_auxiliar = t.id_auxiliar
                                                inner join conta.tconfig_subtipo_cuenta su on su.id_config_subtipo_cuenta = cu.id_config_subtipo_cuenta
                                                inner join conta.tconfig_tipo_cuenta tc on tc.id_config_tipo_cuenta = su.id_config_tipo_cuenta
                                                inner join param.tperiodo pe on pe.id_periodo = cb.id_periodo
                                                where cb.estado_reg = 'validado' and  t.id_auxiliar = v_parametros.id_auxiliar
                                                and pe.id_gestion = v_parametros.id_gestion and  cb.fecha::date BETWEEN v_parametros.desde and v_parametros.hasta
                        ),
                        totales as (select  t.id_int_comprobante,
                                           t.id_cuenta,
                                           t.nro_cuenta,
                                           t.nombre_cuenta,
                                           t.id_auxiliar,
                                           t.codigo_auxiliar,
                                           t.nombre_auxiliar,
                                           t.nro_tramite,
                                           t.fecha,
                                           sum(COALESCE(t.importe_debe_mb,0)) as importe_debe_mb,
                                           sum(COALESCE(t.importe_haber_mb,0)) as importe_haber_mb,
                                           sum(COALESCE(t.importe_debe_mt,0)) as importe_debe_mt,
                                           sum(COALESCE(t.importe_haber_mt,0)) as importe_haber_mt,
                                           sum(COALESCE(t.importe_debe_ma,0)) as importe_debe_ma,
                                           sum(COALESCE(t.importe_haber_ma,0)) as importe_haber_ma
                                         from basica t
                                         group by
                                           t.id_cuenta,
                                           t.nro_cuenta,
                                           t.id_auxiliar,
                                           t.nro_tramite,
                                           t.codigo_auxiliar,
                                           t.nombre_cuenta,
                                           t.nombre_auxiliar,
                                           t.fecha,
                                           t.id_int_comprobante)
                    insert into temporal(   id_int_comprobante,
                                             id_cuenta,
                                             nro_cuenta,
                                             nombre_cuenta,
                                             id_auxiliar,
                                             codigo_auxiliar,
                                             nombre_auxiliar,
                                             nro_tramite,
                                             fecha,
                                             glosa1,
                                             beneficiario, --#83
                                             importe_debe_mb,
                                             importe_haber_mb,
                                             saldo_mb,
                                             importe_debe_mt,
                                             importe_haber_mt,
                                             tipo)select null as id_int_comprobante,
                                                        null as id_cuenta,
                                                        null as nro_cuenta,
                                                        null as nombre_cuenta,
                                                        null as id_auxiliar,
                                                        null as codigo_auxiliar,
                                                        null as nombre_auxiliar,
                                                        ts.nro_tramite,
                                                        null as fecha,
                                                        null as glosa1,
                                                        null as beneficiario, --#83
                                                        sum (ts.importe_debe_mb) as importe_debe_mb,
                                                        sum (ts.importe_haber_mb) as importe_haber_mb,
                                                        sum (ts.importe_debe_mb )-  sum (ts.importe_haber_mb) as saldo_mb,
                                                        sum (ts.importe_debe_mt) as importe_debe_mt,
                                                        sum (ts.importe_haber_mt) as importe_haber_mt,
                                                        'B'::varchar as tipo
                                                 from totales ts
                                                 group by ts.nro_tramite;


            v_consulta:='select  t.id_int_comprobante,
                                 t.id_cuenta,
                                 t.nro_cuenta,
                                 t.nombre_cuenta,
                                 t.id_auxiliar,
                                 t.codigo_auxiliar,
                                 t.nombre_auxiliar,
                                 t.nro_tramite,
                                 t.fecha,
                                 t.glosa1,
                                 t.importe_debe_mb,
                                 t.importe_haber_mb,
                                 t.saldo_mb,
                                 t.importe_debe_mt,
                                 t.importe_haber_mt,
                                 t.tipo,
                                 t.beneficiario --#83
                            from temporal t
                            order by t.nro_tramite,t.tipo';
            return v_consulta;
        end;
        --------------#92 FIN-MMV------------
        
        
	/*********************************    
 	#TRANSACCION:  'CONTA_TRAHIST_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		01-09-2013 18:04:55
	***********************************/

	elsif(p_transaccion='CONTA_TRAHIST_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
                        h.id_historico,
                        h.id_int_transaccion,
                        h.glosa,
                        h.glosa_actual,
                        h.id_auxiliar,
                        aux.nombre_auxiliar,
                        h.id_auxiliar_actual,
                        concat(aux.codigo_auxiliar ||''-'' ||aux1.nombre_auxiliar)::varchar as nombre_auxiliar_actual,
                        h.motivo,
                        h.fecha_reg::timestamp,
                        usu1.cuenta
                        from conta.thistorico h
                        inner join segu.tusuario usu1 on usu1.id_usuario = h.id_usuario_reg
                        left join conta.tauxiliar aux on aux.id_auxiliar = h.id_auxiliar
                        left join conta.tauxiliar aux1 on aux1.id_auxiliar = h.id_auxiliar_actual
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
            raise notice '%',v_consulta;
            --raise exception '%',v_consulta;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_TRAHIST_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		01-09-2013 18:04:55
	***********************************/

	elsif(p_transaccion='CONTA_TRAHIST_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select
                        count(h.id_historico)
                        from conta.thistorico h
                        inner join segu.tusuario usu1 on usu1.id_usuario = h.id_usuario_reg
                        left join conta.tauxiliar aux on aux.id_auxiliar = h.id_auxiliar
                        left join conta.tauxiliar aux1 on aux1.id_auxiliar = h.id_auxiliar_actual
					    where ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;
			--Devuelve la respuesta
			return v_consulta;

		end;
					        
	/*********************************    
 	#TRANSACCION:  'CONTA_AUXMOD_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		01-09-2013 18:04:55
	***********************************/

	elsif(p_transaccion='CONTA_AUXMOD_SEL')then
     				
    	begin
        	v_inner = '';
            v_add_filtro   = '0=0  and ';

            IF pxp.f_existe_parametro(p_tabla,'id_cuenta') THEN
            	v_inner = 'inner join conta.tcuenta_auxiliar c on  c.id_auxiliar = auxcta.id_auxiliar and c.id_cuenta ='|| v_parametros.id_cuenta::varchar;
            END IF;

            v_filtor_tipo_cc = pxp.f_get_variable_global('conta_filtrar_cuenta_por_tipo_cc_interface_junior');

            IF v_filtor_tipo_cc = 'si'  and   pxp.f_existe_parametro(p_tabla, 'id_centro_costo')  THEN
                select pxp.list(tccc.id_auxiliar::varchar)
                into v_id_cuenta_permitidas
                from conta.ttipo_cc_cuenta tccc
                inner join param.tcentro_costo cc on tccc.id_tipo_cc = cc.id_tipo_cc
                where cc.id_centro_costo = v_parametros.id_centro_costo;
                v_add_filtro = '  auxcta.id_auxiliar in ('|| COALESCE(v_id_cuenta_permitidas,'0') ||')  and ';
            END IF;

            IF pxp.f_existe_parametro(p_tabla,'no_es_proveedor') THEN
              IF v_parametros.no_es_proveedor = 'si' THEN
                 v_add_filtro = v_add_filtro|| 'pro.id_proveedor is null and ';
              END IF;
            END IF;

            IF pxp.f_existe_parametro(p_tabla,'es_funcionario') THEN
              IF v_parametros.es_funcionario = 'si' THEN
                 v_add_filtro = v_add_filtro|| '(auxcta.codigo_auxiliar like ''FUN%'' or auxcta.codigo_auxiliar like ''ODT%'') and';
              END IF;
            END IF;
            
            SELECT i.id_cuenta
            INTO v_id_cuenta 
            FROM conta.tint_transaccion i
            WHERE i.id_int_transaccion = v_parametros.id_int_transaccion;
            
            SELECT  pxp.list(ca.id_auxiliar::varchar)
            INTO v_tipo_cc
            FROM conta.tcuenta_auxiliar ca
            JOIN conta.tcuenta c on c.id_cuenta = ca.id_cuenta
            WHERE ca.id_cuenta=v_id_cuenta; 
            
            IF v_tipo_cc IS NULL THEN
        		raise EXCEPTION 'No existe ningun auxiliar relacionado a esta cuenta';
            END IF;

            v_add_filtro = v_add_filtro|| 'auxcta.id_auxiliar in ('||v_tipo_cc||') and ';                    
            
    		--Sentencia de la consulta
			v_consulta:='select
						auxcta.id_auxiliar,
						auxcta.id_empresa,
						emp.nombre,
						auxcta.estado_reg,
						auxcta.codigo_auxiliar,
						auxcta.nombre_auxiliar,
						auxcta.fecha_reg,
						auxcta.id_usuario_reg,
						auxcta.id_usuario_mod,
						auxcta.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        auxcta.corriente,
                        auxcta.aplicacion
						from conta.tauxiliar auxcta
						inner join segu.tusuario usu1 on usu1.id_usuario = auxcta.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = auxcta.id_usuario_mod
				        left join param.tempresa emp on emp.id_empresa=auxcta.id_empresa
                        left join param.tproveedor pro on pro.id_auxiliar = auxcta.id_auxiliar 
                        '|| v_inner || '
				        where auxcta.estado=''si'' and '||v_add_filtro;

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			--Devuelve la respuesta
            RAISE NOTICE 'v_consulta %',v_consulta;
            --RAISE EXCEPTION 'v_consulta %',v_consulta;
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_AUXMOD_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		01-09-2013 18:04:55
	***********************************/

	elsif(p_transaccion='CONTA_AUXMOD_CONT')then

		begin
       
        	v_inner = '';
            v_add_filtro   = '0=0  and ';

            IF pxp.f_existe_parametro(p_tabla,'id_cuenta') THEN
            	v_inner = 'inner join conta.tcuenta_auxiliar c on  c.id_auxiliar = auxcta.id_auxiliar and c.id_cuenta ='|| v_parametros.id_cuenta::varchar;
            END IF;

            v_filtor_tipo_cc = pxp.f_get_variable_global('conta_filtrar_cuenta_por_tipo_cc_interface_junior');

            IF v_filtor_tipo_cc = 'si'  and   pxp.f_existe_parametro(p_tabla, 'id_centro_costo')  THEN
                select pxp.list(tccc.id_auxiliar::varchar)
                into v_id_cuenta_permitidas
                from conta.ttipo_cc_cuenta tccc
                inner join param.tcentro_costo cc on tccc.id_tipo_cc = cc.id_tipo_cc
                where cc.id_centro_costo = v_parametros.id_centro_costo;
                v_add_filtro = '  auxcta.id_auxiliar in ('|| COALESCE(v_id_cuenta_permitidas,'0') ||')  and ';
            END IF;

            IF pxp.f_existe_parametro(p_tabla,'no_es_proveedor') THEN
              IF v_parametros.no_es_proveedor = 'si' THEN
                 v_add_filtro = v_add_filtro|| 'pro.id_proveedor is null and ';
              END IF;
            END IF;

            IF pxp.f_existe_parametro(p_tabla,'es_funcionario') THEN
              IF v_parametros.es_funcionario = 'si' THEN
                 v_add_filtro = v_add_filtro|| '(auxcta.codigo_auxiliar like ''FUN%'' or auxcta.codigo_auxiliar like ''ODT%'') and';
              END IF;
            END IF;
            
            SELECT i.id_cuenta
            INTO v_id_cuenta 
            FROM conta.tint_transaccion i
            WHERE i.id_int_transaccion = v_parametros.id_int_transaccion;
            
            SELECT  pxp.list(ca.id_auxiliar::varchar)
            INTO v_tipo_cc
            FROM conta.tcuenta_auxiliar ca
            JOIN conta.tcuenta c on c.id_cuenta = ca.id_cuenta
            WHERE ca.id_cuenta=v_id_cuenta;
             
			IF v_tipo_cc IS NULL THEN
        		raise EXCEPTION 'No existe ningun auxiliar relacionado a esta cuenta';
            END IF;
            
            v_add_filtro = v_add_filtro|| 'auxcta.id_auxiliar in ('||v_tipo_cc||') and ';

            v_consulta:='select count(auxcta.id_auxiliar)
					    from conta.tauxiliar auxcta
						inner join segu.tusuario usu1 on usu1.id_usuario = auxcta.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = auxcta.id_usuario_mod
				        left join param.tempresa emp on emp.id_empresa=auxcta.id_empresa
                        left join param.tproveedor pro on pro.id_auxiliar = auxcta.id_auxiliar 
                        '|| v_inner || '
				        where auxcta.estado=''si'' and '||v_add_filtro;
            
			v_consulta:=v_consulta||v_parametros.filtro;
            RAISE  NOTICE 'v_consulta %',v_consulta;
            --RAISE  exception 'v_consulta %',v_consulta;
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
PARALLEL UNSAFE
COST 100;