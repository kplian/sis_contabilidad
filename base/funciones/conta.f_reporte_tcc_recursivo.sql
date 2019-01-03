CREATE OR REPLACE FUNCTION conta.f_reporte_tcc_recursivo (
  p_nivel integer
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.f_reporte_tcc_recursivo
 DESCRIPCION:   Funcion que devuelve conjuntos suma recursiva
 AUTOR: 		 (MMV)
 FECHA:	        19/12/2018
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
 ISSUE 		   FECHA   			 AUTOR				 DESCRIPCION:
 #2        20/12/2018    Miguel Mamani     		Reporte Proyectos
 #10       02/01/2019    Miguel Mamani     		Nuevo parámetro tipo de moneda para el reporte detalle Auxiliares por Cuenta

***************************************************************************/
DECLARE

v_registros 				record;
v_nombre_funcion   			text;
v_resp						varchar;
v_sw_force					boolean;
v_id_tipo_cc_fk_abuelo 		integer;

BEGIN

    v_nombre_funcion = 'conta.f_reporte_tcc_recursivo';

    --raise notice 'lamada recursiva.........................';
    v_sw_force = false;  --para criterio de parada
    v_id_tipo_cc_fk_abuelo = null;
    FOR  v_registros in (select  tm.id_tipo_cc_fk,
                                 tcc.id_tipo_cc_fk as id_tipo_cc_fk_abuelo,
                                 tcc.codigo ||' - '||tcc.descripcion as codigo_tcc_abuelo,
                                 tcc.codigo,
                                 sum(tm.importe_debe_mb)  as importe_debe_mb,
                                 sum(tm.importe_haber_mb) as importe_haber_mb,
                                 (sum(tm.importe_debe_mb) - sum(tm.importe_haber_mb)) as saldo_mb,
                                 sum(tm.importe_debe_mt)  as importe_debe_mt, -- #10
                                 sum(tm.importe_haber_mt) as importe_haber_mt, -- #10
                                 (sum(tm.importe_debe_mt) - sum(tm.importe_haber_mt)) as saldo_mt, -- #10
                                 sum(tm.importe_debe_ma)  as importe_debe_ma, -- #10
                                 sum(tm.importe_haber_ma) as importe_haber_ma, -- #10
                                 (sum(tm.importe_debe_ma) - sum(tm.importe_haber_ma)) as saldo_ma -- #10
                         from tmp_prog tm
                         inner join  param.ttipo_cc tcc on tcc.id_tipo_cc = tm.id_tipo_cc_fk
                         where case
                         			when p_nivel = 3 then
                                    	tm.nivel  = p_nivel + 1
                                    when p_nivel = 2 then
                                    	tm.nivel  = p_nivel + 1
                                     when p_nivel = 1 then
                                    	tm.nivel  = p_nivel + 1
                         	    end
                         group by  tm.id_tipo_cc_fk,
                                   tcc.id_tipo_cc_fk,
                                   tcc.codigo,
                                   tcc.descripcion)LOOP

    insert into tmp_prog ( id_tipo_cc,
                           id_tipo_cc_fk,
                           codigo_tcc,
                           codigo,
                           importe_debe_mb,
                           importe_haber_mb,
                           saldo_mb,
                           importe_debe_mt,
                           importe_haber_mt,
                           saldo_mt,
                           importe_debe_ma,
                           importe_haber_ma,
                           saldo_ma,
                           nivel,
                           sw_tipo
                           )
                           values (
                           v_registros.id_tipo_cc_fk,
                           v_registros.id_tipo_cc_fk_abuelo,
                           v_registros.codigo_tcc_abuelo,
                           v_registros.codigo,
                           v_registros.importe_debe_mb,
                           v_registros.importe_haber_mb,
                           v_registros.saldo_mb,
                           v_registros.importe_debe_mt, -- #10
                           v_registros.importe_haber_mt, -- #10
                           v_registros.saldo_mt, -- #10
                           v_registros.importe_debe_ma, -- #10
                           v_registros.importe_haber_ma, -- #10
                           v_registros.saldo_ma, -- #10
                           p_nivel,
                           'titulo'
                           );
      v_sw_force = true;

   END LOOP;
   -- si tenemos mas datos para procesar hacemos la llamada recursiva
    IF v_sw_force THEN
      if p_nivel > 0 then
         PERFORM conta.f_reporte_tcc_recursivo( p_nivel -1);
      end if;

    END IF;

    RETURN TRUE;

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