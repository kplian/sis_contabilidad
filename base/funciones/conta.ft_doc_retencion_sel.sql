--------------- SQL ---------------

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
    var_4  				VARCHAR;    
    var_5  				VARCHAR;
    var_6  				VARCHAR;
    v_ini  				VARCHAR;
    v_fin  				VARCHAR;
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
			--si existiria otra vista x añadir
           	IF v_gestion < 2017  THEN
            	v_tabla_origen = 'conta.vretencion';
            ELSE
            	v_tabla_origen = 'conta.vretencion';
            END IF;
            
            IF v_parametros.filtro_sql = 'periodo'  THEN
            	v_filtro = '(ret.id_periodo = '||v_parametros.id_periodo||')';
            ELSE
                v_filtro = '(ret.fecha::Date BETWEEN '||v_ini||'::Date AND '||v_fin||'::Date)';                          
           	END IF;             

            IF v_parametros.tipo_ret = 'rcrb' THEN
                v_tipo = '(ret.id_plantilla = 9)';
            ELSE
            	IF v_parametros.tipo_ret = 'rcrs' THEN
            		v_tipo = '(ret.id_plantilla = 10)';
                ELSE
                	IF v_parametros.tipo_ret = 'rcra' THEN
                    	v_tipo = '(ret.id_plantilla = 17)';
                    ELSE
                    	IF v_parametros.tipo_ret = 'todo' THEN
                    		v_tipo = '(ret.id_plantilla = 9 OR ret.id_plantilla =10 OR ret.id_plantilla =17)';    
                        END IF;
                    END IF;
                END IF;                
            END IF;
			--RAISE EXCEPTION '%',v_filtro;
            var_1 = '%IT retenciones%';
            var_2 = '%IT-RET%';            
            var_3 = '%IUE Retenciones%';     
            var_4 = '%IUE-RET-BIE%';            
            var_5 = '%IUE-RET-SERV%';                 
            var_6 = '%RC-IVA%';
            --Sentencia de la consulta
		  	v_consulta:='SELECT DISTINCT 
                                ret.id_doc_compra_venta::BIGINT AS id_doc_compra_venta,
                                ret.tipo::VARCHAR AS tipo,
                                ret.fecha::DATE AS fecha,
                                ret.nit::VARCHAR AS nit,
                                ret.razon_social::VARCHAR AS razon_social,
                                ret.nro_documento::VARCHAR AS nro_documento,
                                ret.tipo_doc::VARCHAR AS tipo_doc,
                                ret.id_plantilla::INTEGER AS id_plantilla,
                                ret.tipo_informe::VARCHAR AS tipo_informe,
                                ret.id_moneda::INTEGER AS id_moneda,
                                ret.codigo_moneda::VARCHAR AS codigo_moneda,
                                ret.id_periodo::INTEGER AS id_periodo,
                                ret.id_gestion::INTEGER AS id_gestion,
                                ret.id_usuario_reg::VARCHAR AS id_usuario_reg,                            
                                ret.importe_doc::NUMERIC, 
                                ret.importe_descuento_ley::NUMERIC,   
                                ret.obs::VARCHAR,
                                ret.nro_tramite::VARCHAR,
                                CASE
                                    WHEN ret.desc_plantilla=''Recibo con Retenciones Servicios''  THEN ''Servicios''::VARCHAR
                                    WHEN ret.desc_plantilla=''Recibo con Retenciones Bienes''  THEN ''Bienes''::VARCHAR    
                                    WHEN ret.desc_plantilla=''Recibo con Retenciones de Alquiler''  THEN ''Alquileres''::VARCHAR
                                END AS plantilla,                        
								--
                                MAX(CASE WHEN (c.descripcion LIKE '''||var_1||''' AND c.codigo_tipo_relacion LIKE '''||var_2||''') THEN c.importe_presupuesto::NUMERIC END) AS it,
                                --MAX(CASE WHEN (c.descripcion LIKE '''||var_1||''' AND c.codigo_tipo_relacion LIKE '''||var_2||''') THEN (c.importe_presupuesto * ret.importe_doc)::NUMERIC END) AS it_total,
                                CASE 
                                    WHEN ret.id_plantilla=9 THEN 
                                        MAX(CASE WHEN (c.descripcion LIKE '''||var_1||''' AND c.codigo_tipo_relacion LIKE '''||var_2||''') THEN (c.importe_presupuesto * ret.importe_doc)::NUMERIC END)       
                                    ELSE
                                        0::NUMERIC
                                END AS it_bienes,
                                CASE 
                                    WHEN ret.id_plantilla=10 THEN 
                                        MAX(CASE WHEN (c.descripcion LIKE '''||var_1||''' AND c.codigo_tipo_relacion LIKE '''||var_2||''') THEN (c.importe_presupuesto * ret.importe_doc)::NUMERIC END)   
                                    ELSE
                                        0::NUMERIC
                                END AS it_servicios,
                                CASE 
                                    WHEN ret.id_plantilla=17 THEN 
                                        MAX(CASE WHEN (c.descripcion LIKE '''||var_1||''' AND c.codigo_tipo_relacion LIKE '''||var_2||''') THEN (c.importe_presupuesto * ret.importe_doc)::NUMERIC END)
                                    ELSE
                                        0::NUMERIC
                                END AS it_alquileres,
                                --
                                CASE
                                    WHEN ret.id_plantilla=9 THEN 
                                        MAX(CASE WHEN (c.descripcion LIKE '''||var_3||''' AND c.codigo_tipo_relacion LIKE '''||var_4||''') THEN c.importe_presupuesto::NUMERIC END)       
                                    WHEN ret.id_plantilla=10 THEN    	
                                        MAX(CASE WHEN (c.descripcion LIKE '''||var_3||''' AND c.codigo_tipo_relacion LIKE '''||var_5||''') THEN c.importe_presupuesto::NUMERIC END)	
                                    WHEN ret.id_plantilla=17 THEN  
                                        MAX(CASE WHEN (c.descripcion LIKE '''||var_6||''' AND c.codigo_tipo_relacion LIKE '''||var_6||''') THEN c.importe_presupuesto::NUMERIC END)
                                END AS iue_iva,    
                                --
                                CASE
                                    WHEN ret.id_plantilla=9 THEN 
                                        MAX(CASE WHEN (c.descripcion LIKE '''||var_3||''' AND c.codigo_tipo_relacion LIKE '''||var_4||''') THEN (c.importe_presupuesto * ret.importe_doc)::NUMERIC END)       
                                    WHEN ret.id_plantilla=10 THEN    	
                                        MAX(CASE WHEN (c.descripcion LIKE '''||var_3||''' AND c.codigo_tipo_relacion LIKE '''||var_5||''') THEN (c.importe_presupuesto * ret.importe_doc)::NUMERIC END)	
                                    WHEN ret.id_plantilla=17 THEN  
                                        MAX(CASE WHEN (c.descripcion LIKE '''||var_6||''' AND c.codigo_tipo_relacion LIKE '''||var_6||''') THEN (c.importe_presupuesto * ret.importe_doc)::NUMERIC END)
                                END AS iue_iva_total,
                                --
                                --
                                CASE 
                                    WHEN ret.id_plantilla=9 THEN 
                                        MAX(CASE WHEN (c.descripcion LIKE '''||var_3||''' AND c.codigo_tipo_relacion LIKE '''||var_4||''') THEN (c.importe_presupuesto * ret.importe_doc)::NUMERIC END)       
                                    ELSE
                                        0::NUMERIC
                                END AS iue_bienes,
                                CASE 
                                    WHEN ret.id_plantilla=10 THEN 
                                        MAX(CASE WHEN (c.descripcion LIKE '''||var_3||''' AND c.codigo_tipo_relacion LIKE '''||var_5||''') THEN (c.importe_presupuesto * ret.importe_doc)::NUMERIC END)       
                                    ELSE
                                        0::NUMERIC
                                END AS iue_servicios,
                                CASE 
                                    WHEN ret.id_plantilla=17 THEN 
                                        MAX(CASE WHEN (c.descripcion LIKE '''||var_6||''' AND c.codigo_tipo_relacion LIKE '''||var_6||''') THEN (c.importe_presupuesto * ret.importe_doc)::NUMERIC END)       
                                    ELSE
                                        0::NUMERIC
                                END AS rc_iva_alquileres,
                                --
                                CASE
                                    WHEN ret.id_plantilla=9 THEN 
                                        ((MAX(CASE WHEN (c.descripcion LIKE '''||var_1||''' AND c.codigo_tipo_relacion LIKE '''||var_2||''') THEN (c.importe_presupuesto * ret.importe_doc)::NUMERIC END)
                                        +MAX(CASE WHEN (c.descripcion LIKE '''||var_3||''' AND c.codigo_tipo_relacion LIKE '''||var_4||''') THEN (c.importe_presupuesto * ret.importe_doc)::NUMERIC END)))::NUMERIC
                                    WHEN ret.id_plantilla=10 THEN    	
                                        (MAX(CASE WHEN (c.descripcion LIKE '''||var_1||''' AND c.codigo_tipo_relacion LIKE '''||var_2||''') THEN (c.importe_presupuesto * ret.importe_doc)::NUMERIC END)+
                                        MAX(CASE WHEN (c.descripcion LIKE '''||var_3||''' AND c.codigo_tipo_relacion LIKE '''||var_5||''') THEN (c.importe_presupuesto * ret.importe_doc)::NUMERIC END))	
                                    WHEN ret.id_plantilla=17 THEN  
                                        ((MAX(CASE WHEN (c.descripcion LIKE '''||var_1||''' AND c.codigo_tipo_relacion LIKE '''||var_2||''') THEN (c.importe_presupuesto * ret.importe_doc)::NUMERIC END)+
                                        MAX(CASE WHEN (c.descripcion LIKE '''||var_6||''' AND c.codigo_tipo_relacion LIKE '''||var_6||''') THEN (c.importe_presupuesto * ret.importe_doc)::NUMERIC END)))::NUMERIC
                                END AS descuento, 
								--
                                CASE
                                    WHEN ret.id_plantilla=9 THEN 
                                        ((ret.importe_doc)::NUMERIC-(MAX(CASE WHEN (c.descripcion LIKE '''||var_1||''' AND c.codigo_tipo_relacion LIKE '''||var_2||''') THEN (c.importe_presupuesto * ret.importe_doc)::NUMERIC END)+
                                        MAX(CASE WHEN (c.descripcion LIKE '''||var_3||''' AND c.codigo_tipo_relacion LIKE '''||var_4||''') THEN (c.importe_presupuesto * ret.importe_doc)::NUMERIC END)))::NUMERIC
                                    WHEN ret.id_plantilla=10 THEN    	
										((ret.importe_doc)::NUMERIC-(MAX(CASE WHEN (c.descripcion LIKE '''||var_1||''' AND c.codigo_tipo_relacion LIKE '''||var_2||''') THEN (c.importe_presupuesto * ret.importe_doc)::NUMERIC END)+
                                        MAX(CASE WHEN (c.descripcion LIKE '''||var_3||''' AND c.codigo_tipo_relacion LIKE '''||var_5||''') THEN (c.importe_presupuesto * ret.importe_doc)::NUMERIC END)))::NUMERIC	
                                    WHEN ret.id_plantilla=17 THEN  
										((ret.importe_doc)::NUMERIC-(MAX(CASE WHEN (c.descripcion LIKE '''||var_1||''' AND c.codigo_tipo_relacion LIKE '''||var_2||''') THEN (c.importe_presupuesto * ret.importe_doc)::NUMERIC END)+
                                        MAX(CASE WHEN (c.descripcion LIKE '''||var_6||''' AND c.codigo_tipo_relacion LIKE '''||var_6||''') THEN(c.importe_presupuesto * ret.importe_doc)::NUMERIC END)))::NUMERIC
                                END AS liquido,                                      
                                --
                                CASE 
                                    WHEN ret.id_plantilla=9 THEN 
                                        MAX(CASE WHEN (c.descripcion LIKE '''||var_3||''' AND c.codigo_tipo_relacion LIKE '''||var_4||''') THEN ret.desc_plantilla::VARCHAR END)       
                                    ELSE
                                        0::VARCHAR
                                END AS bienes,
                                CASE 
                                    WHEN ret.id_plantilla=10 THEN 
                                        MAX(CASE WHEN (c.descripcion LIKE '''||var_3||''' AND c.codigo_tipo_relacion LIKE '''||var_5||''') THEN ret.desc_plantilla::VARCHAR END)       
                                    ELSE
                                        0::VARCHAR
                                END AS servicios,
                                CASE 
                                    WHEN ret.id_plantilla=17 THEN 
                                        MAX(CASE WHEN (c.descripcion LIKE '''||var_6||''' AND c.codigo_tipo_relacion LIKE '''||var_6||''') THEN ret.desc_plantilla::VARCHAR END)       
                                    ELSE
                                        0::VARCHAR
                                END AS alquileres                               
                                
                            FROM '||v_tabla_origen||' ret, param.tplantilla p
                            JOIN conta.tplantilla_calculo c ON p.id_plantilla = c.id_plantilla
                            WHERE  '||v_tipo||'
                                   AND ret.id_moneda = '||param.f_get_moneda_base()||'
                                   AND '||v_filtro||'
                            GROUP BY  ret.id_doc_compra_venta,
                                      ret.tipo,
                                      ret.fecha,
                                      ret.nit,
                                      ret.razon_social,
                                      ret.nro_documento,
                                      ret.tipo_doc,
                                      ret.id_plantilla,
                                      ret.tipo_informe,
                                      ret.id_moneda,
                                      ret.codigo_moneda,
                                      ret.id_periodo,
                                      ret.id_gestion,
                                      ret.periodo,
                                      ret.gestion,
                                      ret.id_usuario_reg,    
                                      ret.importe_doc,                       
                                      ret.importe_descuento_ley,
                                      ret.obs,
                                      ret.nro_tramite,
                                      ret.desc_plantilla
							ORDER BY ret.id_plantilla';
			--Devuelve la respuesta   
			--raise exception '-> %',v_consulta; 
			RETURN v_consulta;        	
		END;
    ELSE
		RAISE EXCEPTION 'Transaccion inexistente';
	END IF;
    
EXCEPTION
	WHEN OTHERS THEN
      v_resp='';
      v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
      v_resp = pxp.f_agrega_clave(v_resp,'codigo_',SQLSTATE);
      v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
      RAISE EXCEPTION '%',v_resp;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;