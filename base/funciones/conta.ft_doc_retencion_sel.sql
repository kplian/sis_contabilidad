CREATE OR REPLACE FUNCTION conta.ft_doc_retencion_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
) 
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_doc_retencion_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.ft_doc_retencion_sel'
 AUTOR: 		 (admin)
 FECHA:	        28-08-2017 10:57:09
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/

DECLARE

	v_consulta    		VARCHAR;
	v_parametros  		RECORD;
	v_nombre_funcion   	TEXT;
    v_resp				VARCHAR;
    v_sincronizar		VARCHAR;
    v_gestion			INTEGER;
    v_tabla_origen    	VARCHAR;
    v_filtro     		VARCHAR;
    v_tipo   			VARCHAR;
    v_var   			VARCHAR;
    var_1   			VARCHAR;
    var_2   			VARCHAR;
    var_3  				VARCHAR;
BEGIN

	v_nombre_funcion = 'conta.ft_doc_retencion_sel';
    v_parametros = pxp.f_get_record(p_tabla);
    
    /*********************************
    #TRANSACCION:  'CONTA_REPRET_FRM'
    #DESCRIPCION:	listado para reporte de retenciones
    #AUTOR:		admin
    #FECHA:		18-08-2015 15:57:09
    ***********************************/

	IF(p_transaccion='CONTA_REPRET_FRM')THEN
    	BEGIN

        	v_sincronizar = pxp.f_get_variable_global('sincronizar');
           	SELECT gestion into v_gestion
           	FROM param.tgestion
           	WHERE id_gestion=v_parametros.id_gestion;

           	IF v_gestion < 2017  THEN
            	v_tabla_origen = 'conta.vretencion';
            ELSE
            	v_tabla_origen = 'conta.vretencion';
            END IF;

            IF v_parametros.filtro_sql = 'periodo'  THEN
            	v_filtro =  ' (ret.id_periodo = '||v_parametros.id_periodo||')  ';
            ELSE
               	v_filtro =  ' (ret.fecha::Date between '''||v_parametros.fecha_ini||'''::Date  and '''||v_parametros.fecha_fin||'''::date)  ';
           	END IF; 
            
            IF v_parametros.tipo_ret = 'rcrs'  THEN
                v_tipo = '10';
            ELSE
                v_tipo = '11';
            END IF;
            v_var = 'si';
            var_1 = '%it_retenciones%';
            var_2 = '%iue_retenciones%';
            var_3 = '%rc_iva%';     
            --Sentencia de la consulta

		  	v_consulta:='SELECT DISTINCT 
                                ret.id_doc_compra_venta ::BIGINT AS id_doc_compra_venta,
                                ret.tipo::VARCHAR AS tipo,
                                --ret.fecha::DATE AS fecha,
                                ret.nit::VARCHAR AS nit,
                                ret.razon_social::VARCHAR AS razon_social,
                                ret.nro_documento::VARCHAR AS nro_documento,
                                ret.importe_doc::NUMERIC AS importe_doc,
                                ret.tipo_doc::VARCHAR AS tipo_doc,
                                ret.id_plantilla::INTEGER AS id_plantilla,
                                ret.tipo_informe::VARCHAR AS tipo_informe,
                                ret.id_moneda::INTEGER AS id_moneda,
                                ret.codigo_moneda::VARCHAR AS codigo_moneda,
                                ret.id_periodo::INTEGER AS id_periodo,
                                ret.id_gestion::INTEGER AS id_gestion,
                                ret.periodo::INTEGER AS periodo,
                                ret.gestion::INTEGER AS gestion, 
                                ret.id_usuario_reg::VARCHAR AS id_usuario_reg,
                                MAX(CASE WHEN c.descripcion LIKE '''|| var_1 ||''' THEN c.importe_presupuesto ::NUMERIC END) AS a,
                                MAX(CASE WHEN c.descripcion LIKE '''|| var_2 ||''' THEN c.importe_presupuesto ::NUMERIC END) AS b,
                                MAX(CASE WHEN c.descripcion LIKE '''|| var_3 ||''' THEN c.importe_presupuesto ::NUMERIC END) AS c                                                                
                        FROM '||v_tabla_origen||' ret, param.tplantilla p
                        JOIN conta.tplantilla_calculo c ON p.id_plantilla = c.id_plantilla
                        WHERE  ret.id_plantilla = '||v_tipo||'
                               AND ret.id_moneda = '||param.f_get_moneda_base()||'
                               AND '||v_filtro||'
                               AND c.descuento='''||v_var||'''
                        GROUP BY 
                              ret.id_doc_compra_venta,
                              ret.tipo,
                              --ret.fecha,
                              ret.nit,
                              ret.razon_social,
                              ret.nro_documento,
                              ret.importe_doc,
                              ret.tipo_doc,
                              ret.id_plantilla,
                              ret.tipo_informe,
                              ret.id_moneda,
                              ret.codigo_moneda,
                              ret.id_periodo,
                              ret.id_gestion,
                              ret.periodo,
                              ret.gestion,
                              ret.id_usuario_reg';
			--raise exception '%', v_consulta;
			--Devuelve la respuesta
			RETURN v_consulta;
		END;
    ELSE
		RAISE EXCEPTION 'Transaccion inexistente';
	END IF;
    
EXCEPTION
	WHEN OTHERS THEN
      v_resp='';
      v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
      v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
      v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
      RAISE EXCEPTION '%',v_resp;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;
 