CREATE OR REPLACE FUNCTION conta.ft_banca_compra_venta_sel(p_administrador int4, p_id_usuario int4, p_tabla varchar, p_transaccion varchar)
  RETURNS varchar
AS
$BODY$
  /************************************************************************** 
  SISTEMA:        Sistema de Contabilidad
 FUNCION:         conta.ft_banca_compra_venta_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.tbanca_compra_venta'
 AUTOR:          (admin)
 FECHA:            11-09-2015 14:36:46
 COMENTARIOS:    
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:    
 AUTOR:            
 FECHA:        
***************************************************************************/

DECLARE

  v_consulta varchar;
  v_parametros record;
  v_nombre_funcion text;
  v_resp varchar;

  v_record record;
  v_host varchar;
  
  v_id_banca_compra_venta_seleccionado integer;

BEGIN

  v_nombre_funcion = 'conta.ft_banca_compra_venta_sel';
  v_parametros = pxp.f_get_record(p_tabla);

  v_host:='dbname=dbendesis host=192.168.100.30 user=ende_pxp password=ende_pxp'
    ;

  /*********************************    
     #TRANSACCION:  'CONTA_BANCA_SEL'
     #DESCRIPCION:    Consulta de datos
     #AUTOR:        admin    
     #FECHA:        11-09-2015 14:36:46
    ***********************************/

  if(p_transaccion='CONTA_BANCA_SEL')then

    begin

      
      --Sentencia de la consulta
      
      --raise exception '%',v_parametros.acumulado;
     
      v_id_banca_compra_venta_seleccionado = 0; 
      IF v_parametros.acumulado = 'si'
      then
      v_id_banca_compra_venta_seleccionado = v_parametros.id_banca_compra_venta;
      end if;             
                        
      
       if v_parametros.banca_documentos = 'endesis'
        then
        
        --creacion de tabla temporal del endesis 
          v_consulta:='WITH tabla_temporal_documentos AS (
              SELECT * FROM dblink('''||v_host||''',
          ''SELECT id_documento,razon_social FROM sci.tct_documento''
                   ) AS d (id_documento integer,razon_social varchar(255))
              )';
              
              v_consulta:=v_consulta||' select
						banca.id_banca_compra_venta,
						banca.num_cuenta_pago,
						banca.tipo_documento_pago,
						banca.num_documento,
						banca.monto_acumulado,
						banca.estado_reg,
						banca.nit_ci,
						banca.importe_documento,
						banca.fecha_documento,
						banca.modalidad_transaccion,
						banca.tipo_transaccion,
						banca.autorizacion,
						banca.monto_pagado,
						banca.fecha_de_pago,
						banca.razon,
						banca.tipo,
						banca.num_documento_pago,
						banca.num_contrato,
						banca.nit_entidad,
						banca.fecha_reg,
						banca.usuario_ai,
						banca.id_usuario_reg,
						banca.id_usuario_ai,
						banca.id_usuario_mod,
						banca.fecha_mod,
                        banca.id_periodo,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        confmo.descripcion as desc_modalidad_transaccion,
                        conftt.descripcion as desc_tipo_transaccion,
                        conftd.descripcion as desc_tipo_documento_pago,
                        banca.revisado,
                        banca.id_contrato,
                        banca.id_proveedor,
                        provee.desc_proveedor as desc_proveedor2,
                        contra.objeto as desc_contrato,
                        banca.id_cuenta_bancaria,
                        cuenta.denominacion as desc_cuenta_bancaria,
                        banca.id_documento,
                        doc.razon_social as desc_documento,
                        param.f_literal_periodo(banca.id_periodo) as periodo,
                        banca.saldo,
                        contra.monto as monto_contrato,
                        ges.gestion,
                        '||v_id_banca_compra_venta_seleccionado||' as banca_seleccionada,
 						banca.numero_cuota,
            			banca.tramite_cuota,
                        banca.id_proceso_wf,
                        banca.resolucion,
                        contra.tipo_monto,
                        banca.retencion_cuota,
                        banca.multa_cuota,
                        provee.rotulo_comercial,
                        banca.estado_libro,
                        banca.periodo_servicio,
                        banca.lista_negra,
                        banca.tipo_bancarizacion
						from conta.tbanca_compra_venta banca
						inner join segu.tusuario usu1 on usu1.id_usuario = banca.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = banca.id_usuario_mod
                        left join conta.tconfig_banca confmo on confmo.digito = banca.modalidad_transaccion
                        left join conta.tconfig_banca conftt on conftt.digito = banca.tipo_transaccion
                        left join conta.tconfig_banca conftd on conftd.digito = banca.tipo_documento_pago
                        left join param.vproveedor provee on provee.id_proveedor = banca.id_proveedor
                        left join leg.tcontrato contra on contra.id_contrato = banca.id_contrato                        
                        left join tes.tcuenta_bancaria cuenta on cuenta.id_cuenta_bancaria = banca.id_cuenta_bancaria                        
                        inner join param.tperiodo per on per.id_periodo = banca.id_periodo
                        inner join param.tgestion ges on ges.id_gestion = per.id_gestion
                        left join tabla_temporal_documentos doc on doc.id_documento = banca.id_documento
                        where ';

                        
       
       elsif v_parametros.banca_documentos = 'pxp'
       then
       
       v_consulta:='select
						banca.id_banca_compra_venta,
						banca.num_cuenta_pago,
						banca.tipo_documento_pago,
						banca.num_documento,
						banca.monto_acumulado,
						banca.estado_reg,
						banca.nit_ci,
						banca.importe_documento,
						banca.fecha_documento,
						banca.modalidad_transaccion,
						banca.tipo_transaccion,
						banca.autorizacion,
						banca.monto_pagado,
						banca.fecha_de_pago,
						banca.razon,
						banca.tipo,
						banca.num_documento_pago,
						banca.num_contrato,
						banca.nit_entidad,
						banca.fecha_reg,
						banca.usuario_ai,
						banca.id_usuario_reg,
						banca.id_usuario_ai,
						banca.id_usuario_mod,
						banca.fecha_mod,
                        banca.id_periodo,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        confmo.descripcion as desc_modalidad_transaccion,
                        conftt.descripcion as desc_tipo_transaccion,
                        conftd.descripcion as desc_tipo_documento_pago,
                        banca.revisado,
                        banca.id_contrato,
                        banca.id_proveedor,
                        provee.desc_proveedor as desc_proveedor2,
                        contra.objeto as desc_contrato,
                        banca.id_cuenta_bancaria,
                        cuenta.denominacion as desc_cuenta_bancaria,
                        banca.id_documento,
                        doc.razon_social::varchar as desc_documento,
                        param.f_literal_periodo(banca.id_periodo) as periodo,
                        banca.saldo,
                        contra.monto as monto_contrato,
                        ges.gestion,
                        '||v_id_banca_compra_venta_seleccionado||' as banca_seleccionada,
                        
                        banca.numero_cuota,
            			banca.tramite_cuota	,
                        banca.id_proceso_wf,
                        banca.resolucion
						from conta.tbanca_compra_venta banca
						inner join segu.tusuario usu1 on usu1.id_usuario = banca.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = banca.id_usuario_mod
                        left join conta.tconfig_banca confmo on confmo.digito = banca.modalidad_transaccion
                        left join conta.tconfig_banca conftt on conftt.digito = banca.tipo_transaccion
                        left join conta.tconfig_banca conftd on conftd.digito = banca.tipo_documento_pago
                        inner join param.vproveedor provee on provee.id_proveedor = banca.id_proveedor
                        left join leg.tcontrato contra on contra.id_contrato = banca.id_contrato                        
                        left join tes.tcuenta_bancaria cuenta on cuenta.id_cuenta_bancaria = banca.id_cuenta_bancaria                        
                        inner join param.tperiodo per on per.id_periodo = banca.id_periodo
                        inner join param.tgestion ges on ges.id_gestion = per.id_gestion
                        left join conta.tdoc_compra_venta doc on doc.id_doc_compra_venta = banca.id_documento
                        where ';
                        
       
        end if;
        
     
      --Definicion de la respuesta
      v_consulta:=v_consulta||v_parametros.filtro;
      
      
       
      v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' ||
        v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad ||
        ' offset ' || v_parametros.puntero;
        
       
      

      --Devuelve la respuesta
      return v_consulta;

    end;

    /*********************************    
     #TRANSACCION:  'CONTA_BANCA_CONT'
     #DESCRIPCION:    Conteo de registros
     #AUTOR:        admin    
     #FECHA:        11-09-2015 14:36:46
    ***********************************/

    elsif(p_transaccion='CONTA_BANCA_CONT')then

    begin
      --Sentencia de la consulta de conteo de registros
      v_consulta:='select count(id_banca_compra_venta)
					    from conta.tbanca_compra_venta banca
					    inner join segu.tusuario usu1 on usu1.id_usuario = banca.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = banca.id_usuario_mod
						                        inner join param.vproveedor provee on provee.id_proveedor = banca.id_proveedor

                        inner join conta.tconfig_banca confmo on confmo.digito = banca.modalidad_transaccion
                        inner join conta.tconfig_banca conftt on conftt.digito = banca.tipo_transaccion
                        inner join conta.tconfig_banca conftd on conftd.digito = banca.tipo_documento_pago

                        left join leg.tcontrato contra on contra.id_contrato = banca.id_contrato
                        left join tes.tcuenta_bancaria cuenta on cuenta.id_cuenta_bancaria = banca.id_cuenta_bancaria
                        inner join param.tperiodo per on per.id_periodo = banca.id_periodo
                        inner join param.tgestion ges on ges.id_gestion = per.id_gestion
					    where ';

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
$BODY$
LANGUAGE plpgsql VOLATILE;