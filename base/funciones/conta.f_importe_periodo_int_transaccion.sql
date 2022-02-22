CREATE OR REPLACE FUNCTION conta.f_importe_periodo_int_transaccion (
  p_id_gestion integer,
  p_nro_cuenta varchar,
  p_cbte_apertura varchar,
  p_cbte_cierre varchar,
  p_cbte_aitb varchar,
  p_partida varchar,
  p_tipo varchar,
  p_fecha_ini date,
  p_fecha_fin date
)
RETURNS TABLE (
  fill_periodo integer,
  fill_debe_mb numeric,
  fill_haber_mb numeric,
  fill_saldo_mb numeric
) AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.f_importe_periodo_int_transaccion
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.treporte_anexos'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        10-06-2019 21:31:03
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #80	ETR			21-08-2019 15:03:21 MMV				    Generador Reporte Anexo V02
 #
 ***************************************************************************/
DECLARE
v_nombre_funcion   				text;
v_resp							varchar;
v_id_cuenta						varchar;
v_id_partida					varchar;
v_consulta						varchar;
v_record						record;
v_filtro						varchar;

BEGIN

--obtener lod id de la cuentas depencia
  with recursive cuentas (     id_cuenta,
                               nro_cuenta,
                               id_cuenta_padre
                              ) as(
                              select 	cue.id_cuenta,
                                      cue.nro_cuenta,
                                      cue.id_cuenta_padre
                              from conta.tcuenta cue
                              where  cue.estado_reg = 'activo' and cue.nro_cuenta = ANY (string_to_array(p_nro_cuenta,','))
                              and cue.id_gestion = p_id_gestion
                              union all
                              select  cue2.id_cuenta,
                                      cue2.nro_cuenta,
                                      cue2.id_cuenta_padre
                              from cuentas lrec
                              inner join  conta.tcuenta cue2 ON lrec.id_cuenta = cue2.id_cuenta_padre
                              where cue2.estado_reg = 'activo'
                              )select pxp.list(id_cuenta::varchar)
                              into
                              v_id_cuenta
                              from cuentas c;

   if v_id_cuenta is not null then
     		v_filtro = 'and cu.id_cuenta in ('||v_id_cuenta||')';
        else
        	v_filtro = 'and 0=0';
    end if;

    if p_cbte_apertura = 'si' then
          v_filtro:= v_filtro||  'and cb.cbte_apertura = ''si'' ';
    else
          v_filtro:=  v_filtro|| 'and 0=0' ;
    end if;

    if p_cbte_cierre = 'no' then
          v_filtro:= v_filtro|| 'and cb.cbte_cierre = ''no'' ';
    else
          v_filtro:= v_filtro|| 'and cb.cbte_cierre = ''si'' ';
    end if;

    if p_cbte_aitb = 'si' then
          v_filtro:= v_filtro|| 'and cb.cbte_aitb = ''si'' ';
    else
          v_filtro:= v_filtro|| 'and 0=0';
    end if;

     select pxp.list(pa.id_partida::text)
        into v_id_partida
      from pre.tpartida pa
      where  pa.codigo = ANY (string_to_array(p_partida,','));

    if v_id_partida is not null then
     		v_filtro:= v_filtro|| 'and tr.id_partida in ('||v_id_partida ||')';
        else
        	v_filtro:= v_filtro|| 'and 0=0';
    end if;

    if p_tipo = 'periodo' then
        v_consulta := 'select  pr.periodo,
                                sum(tr.importe_debe_mb) as importe_debe_mb,
                                sum(tr.importe_haber_mb) as importe_haber_mb,
                                (case
                                    when sum(tr.importe_debe_mb) > sum(tr.importe_haber_mb) then
                                        sum(tr.importe_debe_mb) - sum(tr.importe_haber_mb)
                                    when sum(tr.importe_haber_mb) > sum(tr.importe_debe_mb) then
                                        sum(tr.importe_haber_mb) - sum(tr.importe_debe_mb)
                                end) as importe_saldo_mb
                        from conta.tint_transaccion tr
                        inner join conta.tint_comprobante cb on cb.id_int_comprobante = tr.id_int_comprobante
                        inner join conta.tcuenta cu on cu.id_cuenta = tr.id_cuenta
                        inner join param.tperiodo pr on pr.id_periodo = cb.id_periodo
                        where  cb.estado_reg = ''validado''';
          v_consulta:= v_consulta ||v_filtro;
          v_consulta:= v_consulta||'group by pr.periodo
                                    order by periodo';
    elsif  p_tipo = 'anual' then
         v_consulta := 'select  0::integer as periodo,
                                sum(tr.importe_debe_mb) as importe_debe_mb,
                                sum(tr.importe_haber_mb) as importe_haber_mb,
                                (case
                                    when sum(tr.importe_debe_mb) > sum(tr.importe_haber_mb) then
                                        sum(tr.importe_debe_mb) - sum(tr.importe_haber_mb)
                                    when sum(tr.importe_haber_mb) > sum(tr.importe_debe_mb) then
                                        sum(tr.importe_haber_mb) - sum(tr.importe_debe_mb)
                                end) as importe_saldo_mb
                        from conta.tint_transaccion tr
                        inner join conta.tint_comprobante cb on cb.id_int_comprobante = tr.id_int_comprobante
                        inner join conta.tcuenta cu on cu.id_cuenta = tr.id_cuenta
                        inner join param.tperiodo pr on pr.id_periodo = cb.id_periodo
                        where  cb.estado_reg = ''validado'' and cb.fecha::date BETWEEN '''||p_fecha_ini||''' and '''||p_fecha_fin||'''';
          v_consulta:= v_consulta ||v_filtro;
    else
      raise exception 'no esta difinido el tipo';
    end if;

  RETURN QUERY EXECUTE(v_consulta);
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
COST 100 ROWS 1000;

ALTER FUNCTION conta.f_importe_periodo_int_transaccion (p_id_gestion integer, p_nro_cuenta varchar, p_cbte_apertura varchar, p_cbte_cierre varchar, p_cbte_aitb varchar, p_partida varchar, p_tipo varchar, p_fecha_ini date, p_fecha_fin date)
  OWNER TO postgres;