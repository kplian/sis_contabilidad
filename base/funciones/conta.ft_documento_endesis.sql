CREATE OR REPLACE FUNCTION conta.ft_documento_endesis (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS SETOF record AS
$body$
DECLARE


  v_parametros record;
  v_nombre_funcion text;
  v_resp varchar;

  v_host varchar;

  v_sw integer;
  v_sw2 integer;
  v_count integer;
  v_consulta varchar;
  v_consulta2 varchar;
  v_registros record;
  -- PARA ALMACENAR EL CONJUNTO DE DATOS RESULTADO DEL SELECT
  v_tabla varchar;
  v_valor_nivel varchar;
  v_nivel varchar;
  v_niveles_acsi varchar;

  pm_criterio_filtro varchar;
  v_id integer;

  v_registro_proceso_wf record;
  v_fecha_ini_proc timestamp;
  v_fecha_fin_proc timestamp;
  v_id_procesos_sig integer [ ];
  v_id_almacenado integer [ ];
  v_fecha_fin_ant TIMESTAMP;
  v_id_proceso integer;
  v_id_estado integer;
  v_id_proceso_ant integer;

  v_i integer;
  p_id_proceso_wf integer;
  v_id_proceso_wf_prev integer;
  v_orden varchar;

BEGIN

  v_host:='dbname=dbendesis host=192.168.100.30 user=ende_pxp password=ende_pxp'
    ;
  v_nombre_funcion = 'conta.ft_documento_endesis';

  v_parametros = pxp.f_get_record(p_tabla);

  /*********************************    
     #TRANSACCION:  'FAC_DOC_SEL'
     #DESCRIPCION:    Consulta de conexion con endesis
     #AUTOR:        ffp    
     #FECHA:        01-12-2015 17:06:17
    ***********************************/

  IF(p_transaccion='FAC_DOC_SEL')then
  
  

        if v_parametros.banca_documentos = 'endesis'
        then
        v_consulta :='SELECT doc.id_documento,
                                   doc.nro_autorizacion,
                                   doc.nro_documento,
                                   doc.fecha_documento,
                                   doc.razon_social,
                                    doc.nro_nit,
                                    pla.sw_libro_compras,
                                    va.importe_total
                                    
                                    FROM sci.tct_documento doc
                                   inner join sci.tct_documento_valor va on va.id_documento = doc.id_documento
                                   inner join sci.tct_plantilla pla on pla.tipo_plantilla = doc.tipo_documento
                                   where ';

            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' ||
            v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad ||
            ' offset ' || v_parametros.puntero;

            FOR v_registros in (
            SELECT *
            FROM dblink('' || v_host || '', '' || v_consulta || '') AS t(id_documento
              integer,nro_autorizacion varchar(255),nro_documento BIGINT,fecha_documento date,
                razon_social varchar (255),nro_nit varchar(255),sw_libro_compras varchar(255), importe_total numeric))
            LOOP

              RETURN NEXT v_registros;
            END LOOP;
            
        elsif v_parametros.banca_documentos = 'pxp'
        then
        
        	v_consulta:=' select dcv.id_doc_compra_venta::integer as id_documento,
                           dcv.nro_autorizacion::varchar,
                           dcv.nro_documento::bigint,
                           dcv.fecha as fecha_documento,
                           dcv.razon_social::varchar,
                           dcv.nit::varchar as nro_nit,
                           ''libro de compras''::varchar as sw_libro_compras,
                           dcv.importe_pago_liquido::numeric as importe_total
                        
						from conta.tdoc_compra_venta dcv
						inner join segu.tusuario usu1 on usu1.id_usuario = dcv.id_usuario_reg
                        inner join param.tplantilla pla on pla.id_plantilla = dcv.id_plantilla
                        inner join param.tmoneda mon on mon.id_moneda = dcv.id_moneda
                        left join conta.tint_comprobante ic on ic.id_int_comprobante = dcv.id_int_comprobante
                        left join param.tdepto dep on dep.id_depto = dcv.id_depto_conta
						left join segu.tusuario usu2 on usu2.id_usuario = dcv.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            
            --Devuelve la respuesta
			
            --raise exception '%',v_consulta;
            FOR v_registros in execute (v_consulta)
            LOOP
              RETURN NEXT v_registros;
            END LOOP;
            
			
       
        end if;
    

    /*********************************    
     #TRANSACCION:  'FAC_DOC_CONT'
     #DESCRIPCION:    Conteo de registros
     #AUTOR:        favio figueroa
     #FECHA:        18-11-2014 19:30:03
    ***********************************/

    elsif(p_transaccion='FAC_DOC_CONT')then

    begin

      if v_parametros.banca_documentos = 'endesis'
          then
          v_consulta :='SELECT count(doc.id_documento) as count
                                FROM sci.tct_documento doc
                                 inner join sci.tct_documento_valor va on va.id_documento = doc.id_documento

                                inner join sci.tct_plantilla pla on pla.tipo_plantilla = doc.tipo_documento

                               where ';
          v_consulta:=v_consulta||v_parametros.filtro;

          FOR v_registros in (
        SELECT *
        FROM dblink('' || v_host || '', '' || v_consulta || '') AS t(count
          bigint))
        LOOP

          RETURN NEXT v_registros;
        END LOOP;
        
       elsif v_parametros.banca_documentos = 'pxp'
        then
        
        v_consulta:='select count(id_doc_compra_venta)
					    from conta.tdoc_compra_venta dcv
						inner join segu.tusuario usu1 on usu1.id_usuario = dcv.id_usuario_reg
                        inner join param.tplantilla pla on pla.id_plantilla = dcv.id_plantilla
                        inner join param.tmoneda mon on mon.id_moneda = dcv.id_moneda
                        left join conta.tint_comprobante ic on ic.id_int_comprobante = dcv.id_int_comprobante
                        left join param.tdepto dep on dep.id_depto = dcv.id_depto_conta
						left join segu.tusuario usu2 on usu2.id_usuario = dcv.id_usuario_mod
				        where ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			FOR v_registros in execute (v_consulta)
            LOOP
              RETURN NEXT v_registros;
            END LOOP;
            
        
        
      end if;

    end;
    
    

    else

    raise exception 'Transaccion inexistente: %',p_transaccion;

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
SECURITY DEFINER
COST 100 ROWS 1000;