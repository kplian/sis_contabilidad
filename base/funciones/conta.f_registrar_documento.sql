CREATE OR REPLACE FUNCTION conta.f_registrar_documento (
  p_administrador integer,
  p_id_usuario integer,
  p_id_plantilla integer,
  p_codigo_relacion varchar,
  p_nombre_usuario_ai varchar,
  p_id_usuario_ai varchar,
  p_hstore public.hstore
)
RETURNS integer AS
$body$
/**************************************************************************
 SISTEMA:		Contabilidad
 FUNCION: 		cd.f_registrar_documento
 DESCRIPCION:   Crea el documento (factura, recibo, etc.) directo en la tabla de documentos de contabilidad
 AUTOR: 		RCM
 FECHA:	        27-11-2017 15:26
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/
DECLARE

	v_resp              varchar;
    v_nombre_funcion    text;
    v_desc_plantilla    varchar;
    v_descuento         numeric;
    v_descuento_porc    numeric;
    v_iva               numeric;
    v_it                numeric;
    v_ice               numeric;
    v_tabla             varchar;
    id_doc_compra_venta integer;

    v_revisado varchar;
    v_movil varchar;
    v_tipo varchar;
    v_importe_excento numeric;
    v_fecha date;
    v_nro_documento varchar;
    v_nit varchar;
    v_importe_ice numeric;
    v_nro_autorizacion varchar;
    v_importe_iva numeric;
    v_importe_descuento numeric;
    v_importe_doc numeric;
    v_sw_contabilizar varchar;
    v_tabla_origen varchar;
    v_estado varchar;
    v_id_depto_conta integer;
    v_id_origen integer;
    v_obs varchar;
    v_estado_reg varchar;
    v_codigo_control varchar;
    v_importe_it numeric;
    v_razon_social varchar;
    v_importe_descuento_ley numeric;
    v_importe_pago_liquido numeric;
    v_nro_dui varchar;
    v_id_moneda integer;
    v_importe_pendiente numeric;
    v_importe_anticipo numeric;
    v_importe_retgar numeric;
    v_importe_neto numeric;
    v_id_auxiliar integer;
    v_id_tipo_compra_venta integer;
    v_id_doc_compra_venta integer;
    v_codigo_trans varchar = 'CONTA_DCV_INS';

BEGIN

    /*
    HSTORE PARAMETROS

    (p_hstore->'_nombre_usuario_ai')::varchar, --coalesce(v_parametros._nombre_usuario_ai,''),
    (p_hstore->'_id_usuario_ai')::integer, --coalesce(v_parametros._id_usuario_ai::varchar,''),
    (p_hstore->'revisado')::varchar, --'si',--'revisado',
    (p_hstore->'movil')::varchar, --'no',--'movil',
    (p_hstore->'tipo')::varchar, --'venta',--'tipo',
    (p_hstore->'importe_excento')::numeric, --coalesce(v_venta.excento::varchar,'0'),--'importe_excento',
    (p_hstore->'fecha')::date, --to_char(v_venta.fecha,'DD/MM/YYYY'),--'fecha',
    (p_hstore->'nro_documento')::varchar, --COALESCE(v_venta.nro_factura,'0')::varchar,--'nro_documento',
    (p_hstore->'nit')::varchar, --coalesce(v_venta.nit,''),--'nit',
    (p_hstore->'importe_ice')::numeric, --v_venta.total_venta_msuc::varchar,--'importe_ice',
    (p_hstore->'nro_autorizacion')::varchar, --coalesce(v_venta.nroaut,''), --'nro_autorizacion',
    (p_hstore->'importe_iva')::numeric, --(v_venta.total_venta_msuc * v_iva)::varchar,--'importe_iva',
    (p_hstore->'importe_descuento')::numeric, --'0',--'importe_descuento',
    (p_hstore->'importe_doc')::numeric, --(v_venta.total_venta_msuc )::varchar,--'importe_doc',
    (p_hstore->'sw_contabilizar')::varchar, --'no',--'sw_contabilizar',
    (p_hstore->'tabla_origen')::varchar, --'vef.tventa',--'tabla_origen',
    (p_hstore->'estado')::varchar, --'validado',--'estado',
    (p_hstore->'id_depto_conta')::integer, --v_id_depto_conta::varchar,--'id_depto_conta',
    (p_hstore->'id_origen')::integer, --v_venta.id_venta::varchar,--'id_origen',
    (p_hstore->'obs')::varchar, --coalesce(v_venta.observaciones,''),--'obs',
    (p_hstore->'estado_reg')::varchar, --'activo',--'estado_reg',
    (p_hstore->'codigo_control')::varchar, --coalesce(v_venta.cod_control,''),--'codigo_control',
    (p_hstore->'importe_it')::numeric, --(v_venta.total_venta_msuc * v_it)::varchar,--'importe_it',
    (p_hstore->'razon_social')::varchar, --coalesce(v_venta.nombre_factura,''),--'razon_social',
    (p_hstore->'importe_descuento_ley')::numeric, --(v_venta.total_venta_msuc * v_descuento_porc)::varchar,--'importe_descuento_ley',
    (p_hstore->'importe_pago_liquido')::numeric, --coalesce((v_venta.total_venta_msuc - (v_venta.total_venta_msuc * v_descuento_porc))::varchar,''),--'importe_pago_liquido',
    (p_hstore->'nro_dui')::varchar, --'0',--'nro_dui',
    (p_hstore->'id_moneda')::integer, --v_venta.id_moneda_sucursal::varchar,--'id_moneda',
    (p_hstore->'importe_pendiente')::numeric, --'0',--'importe_pendiente',
    (p_hstore->'importe_anticipo')::numeric, --'0',--'importe_anticipo',
    (p_hstore->'importe_retgar')::numeric, --'0',--'importe_retgar',
    (p_hstore->'importe_neto')::numeric, --(v_venta.total_venta_msuc - (v_venta.total_venta_msuc * v_descuento_porc))::varchar,--'importe_neto',--
    (p_hstore->'id_auxiliar')::integer, --'',--'id_auxiliar',
    (p_hstore->'id_tipo_compra_venta')::integer, --v_id_tipo_compra_venta::varchar
    */
    --Identificacion de la funcion
	v_nombre_funcion = 'f_registrar_documento';



    --Obtencion nombre plantilla
    select desc_plantilla
    into v_desc_plantilla
    from param.tplantilla
    where id_plantilla = p_id_plantilla;

    if v_desc_plantilla is null then
        raise exception 'Plantilla no definida';
    end if;

    --Por defecto inicializa los valores de las variables con los parametros recibidos
    v_revisado = (p_hstore->'revisado')::varchar; --'si',--'revisado',
    v_movil = (p_hstore->'movil')::varchar; --'no',--'movil',
    v_tipo = (p_hstore->'tipo')::varchar; --'venta',--'tipo',
    v_importe_excento = (p_hstore->'importe_excento')::numeric; --coalesce(v_venta.excento::varchar,'0'),--'importe_excento',
    v_fecha = (p_hstore->'fecha')::date; --to_char(v_venta.fecha,'DD/MM/YYYY'),--'fecha',
    v_nro_documento = (p_hstore->'nro_documento')::varchar; --COALESCE(v_venta.nro_factura,'0')::varchar,--'nro_documento',
    v_nit = (p_hstore->'nit')::varchar; --coalesce(v_venta.nit,''),--'nit',
    v_importe_ice = (p_hstore->'importe_ice')::numeric; --v_venta.total_venta_msuc::varchar,--'importe_ice',
    v_nro_autorizacion = (p_hstore->'nro_autorizacion')::varchar; --coalesce(v_venta.nroaut,''); --'nro_autorizacion',
    v_importe_iva = (p_hstore->'importe_iva')::numeric; --(v_venta.total_venta_msuc * v_iva)::varchar,--'importe_iva',
    v_importe_descuento = (p_hstore->'importe_descuento')::numeric; --'0',--'importe_descuento',
    v_importe_doc = (p_hstore->'importe_doc')::numeric; --(v_venta.total_venta_msuc )::varchar,--'importe_doc',
    v_sw_contabilizar = (p_hstore->'sw_contabilizar')::varchar; --'no',--'sw_contabilizar',
    v_tabla_origen = (p_hstore->'tabla_origen')::varchar; --'vef.tventa',--'tabla_origen',
    v_estado = (p_hstore->'estado')::varchar; --'validado',--'estado',
    v_id_depto_conta = (p_hstore->'id_depto_conta')::integer; --v_id_depto_conta::varchar,--'id_depto_conta',
    v_id_origen = (p_hstore->'id_origen')::integer; --v_venta.id_venta::varchar,--'id_origen',
    v_obs = (p_hstore->'obs')::varchar; --coalesce(v_venta.observaciones,''),--'obs',
    v_estado_reg = (p_hstore->'estado_reg')::varchar; --'activo',--'estado_reg',
    v_codigo_control = (p_hstore->'codigo_control')::varchar; --coalesce(v_venta.cod_control,''),--'codigo_control',
    v_importe_it = (p_hstore->'importe_it')::numeric; --(v_venta.total_venta_msuc * v_it)::varchar,--'importe_it',
    v_razon_social = (p_hstore->'razon_social')::varchar; --coalesce(v_venta.nombre_factura,''),--'razon_social',
    v_importe_descuento_ley = (p_hstore->'importe_descuento_ley')::numeric; --(v_venta.total_venta_msuc * v_descuento_porc)::varchar,--'importe_descuento_ley',
    v_importe_pago_liquido = (p_hstore->'importe_pago_liquido')::numeric; --coalesce((v_venta.total_venta_msuc - (v_venta.total_venta_msuc * v_descuento_porc))::varchar,''),--'importe_pago_liquido',
    v_nro_dui = (p_hstore->'nro_dui')::varchar; --'0',--'nro_dui',
    v_id_moneda = (p_hstore->'id_moneda')::integer; --v_venta.id_moneda_sucursal::varchar,--'id_moneda',
    v_importe_pendiente = (p_hstore->'importe_pendiente')::numeric; --'0',--'importe_pendiente',
    v_importe_anticipo = (p_hstore->'importe_anticipo')::numeric; --'0',--'importe_anticipo',
    v_importe_retgar = (p_hstore->'importe_retgar')::numeric; --'0',--'importe_retgar',
    v_importe_neto = (p_hstore->'importe_neto')::numeric; --(v_venta.total_venta_msuc - (v_venta.total_venta_msuc * v_descuento_porc))::varchar,--'importe_neto',--
    v_id_auxiliar = (p_hstore->'id_auxiliar')::integer; --'',--'id_auxiliar',
    v_id_tipo_compra_venta = (p_hstore->'id_tipo_compra_venta')::integer; --v_id_tipo_compra_venta::varchar
    

    --Creacion de tabla de parametros
    v_tabla = pxp.f_crear_parametro(ARRAY['_nombre_usuario_ai',
                                        '_id_usuario_ai',
                                        'revisado',
                                        'movil',
                                        'tipo',
                                        'importe_excento',
                                        'id_plantilla',
                                        'fecha',
                                        'nro_documento',
                                        'nit',
                                        'importe_ice',
                                        'nro_autorizacion',
                                        'importe_iva',
                                        'importe_descuento',
                                        'importe_doc',
                                        'sw_contabilizar',
                                        'tabla_origen',
                                        'estado',
                                        'id_depto_conta',
                                        'id_origen',
                                        'obs',
                                        'estado_reg',
                                        'codigo_control',
                                        'importe_it',
                                        'razon_social',
                                        'importe_descuento_ley',
                                        'importe_pago_liquido',
                                        'nro_dui',
                                        'id_moneda',                            
                                        'importe_pendiente',
                                        'importe_anticipo',
                                        'importe_retgar',
                                        'importe_neto',
                                        'id_auxiliar',
                                        'id_doc_compra_venta',
                                        'id_tipo_compra_venta'], --36
                                    ARRAY[  coalesce(p_nombre_usuario_ai::varchar,''), --coalesce(v_parametros._nombre_usuario_ai::varchar,'')::varchar,
                                        coalesce(p_id_usuario_ai::varchar,''), --coalesce(v_parametros._id_usuario_ai::varchar::varchar,'')::varchar,
                                        coalesce(v_revisado::varchar,''), --'si'::varchar,--'revisado'::varchar,
                                        coalesce(v_movil::varchar,''), --'no'::varchar,--'movil'::varchar,
                                        coalesce(v_tipo::varchar,''), --'venta'::varchar,--'tipo'::varchar,
                                        coalesce(v_importe_excento::varchar,''), --coalesce(v_venta.excento::varchar::varchar,'0')::varchar,--'importe_excento'::varchar,
                                        coalesce(p_id_plantilla::varchar,''), --v_venta.id_plantilla::varchar::varchar,--'id_plantilla'::varchar,
                                        coalesce(v_fecha::varchar,''), --to_char(v_venta.fecha::varchar,'DD/MM/YYYY')::varchar,--'fecha'::varchar,
                                        coalesce(v_nro_documento::varchar,''), --COALESCE(v_venta.nro_factura::varchar,'0')::varchar::varchar,--'nro_documento'::varchar,
                                        coalesce(v_nit::varchar,''), --coalesce(v_venta.nit::varchar,'')::varchar,--'nit'::varchar,
                                        coalesce(v_importe_ice::varchar,''), --v_venta.total_venta_msuc::varchar::varchar,--'importe_ice'::varchar,
                                        coalesce(v_nro_autorizacion::varchar,''), --coalesce(v_venta.nroaut::varchar,'')::varchar, --'nro_autorizacion'::varchar,
                                        coalesce(v_importe_iva::varchar,''), --(v_venta.total_venta_msuc * v_iva)::varchar::varchar,--'importe_iva'::varchar,
                                        coalesce(v_importe_descuento::varchar,''), --'0'::varchar,--'importe_descuento'::varchar,
                                        coalesce(v_importe_doc::varchar,''), --(v_venta.total_venta_msuc )::varchar::varchar,--'importe_doc'::varchar,
                                        coalesce(v_sw_contabilizar::varchar,''), --'no'::varchar,--'sw_contabilizar'::varchar,
                                        coalesce(v_tabla_origen::varchar,''), --'vef.tventa'::varchar,--'tabla_origen'::varchar,
                                        coalesce(v_estado::varchar,''), --'validado'::varchar,--'estado'::varchar,
                                        coalesce(v_id_depto_conta::varchar,''), --v_id_depto_conta::varchar::varchar,--'id_depto_conta'::varchar,
                                        coalesce(v_id_origen::varchar,''), --v_venta.id_venta::varchar::varchar,--'id_origen'::varchar,
                                        coalesce(v_obs::varchar,''), --coalesce(v_venta.observaciones::varchar,'')::varchar,--'obs'::varchar,
                                        coalesce(v_estado_reg::varchar,''), --'activo'::varchar,--'estado_reg'::varchar,
                                        coalesce(v_codigo_control::varchar,''), --coalesce(v_venta.cod_control::varchar,'')::varchar,--'codigo_control'::varchar,
                                        coalesce(v_importe_it::varchar,''), --(v_venta.total_venta_msuc * v_it)::varchar::varchar,--'importe_it'::varchar,
                                        coalesce(v_razon_social::varchar,''), --coalesce(v_venta.nombre_factura::varchar,'')::varchar,--'razon_social'::varchar,
                                        coalesce(v_importe_descuento_ley::varchar,''), --(v_venta.total_venta_msuc * v_descuento_porc)::varchar::varchar,--'importe_descuento_ley'::varchar,
                                        coalesce(v_importe_pago_liquido::varchar,''), --coalesce((v_venta.total_venta_msuc - (v_venta.total_venta_msuc * v_descuento_porc))::varchar::varchar,'')::varchar,--'importe_pago_liquido'::varchar,
                                        coalesce(v_nro_dui::varchar,''), --'0'::varchar,--'nro_dui'::varchar,
                                        coalesce(v_id_moneda::varchar,''), --v_venta.id_moneda_sucursal::varchar::varchar,--'id_moneda'::varchar,
                                        coalesce(v_importe_pendiente::varchar,''), --'0'::varchar,--'importe_pendiente'::varchar,
                                        coalesce(v_importe_anticipo::varchar,''), --'0'::varchar,--'importe_anticipo'::varchar,
                                        coalesce(v_importe_retgar::varchar,''), --'0'::varchar,--'importe_retgar'::varchar,
                                        coalesce(v_importe_neto::varchar,''), --(v_venta.total_venta_msuc - (v_venta.total_venta_msuc * v_descuento_porc))::varchar::varchar,--'importe_neto'::varchar,--
                                        coalesce(v_id_auxiliar::varchar,''), --''::varchar,--'id_auxiliar'::varchar,
                                        coalesce(null::varchar,''), --coalesce(v_id_doc_compra_venta::varchar,''),--id_doc_compra_venta
                                        coalesce(v_id_tipo_compra_venta::varchar,'') --v_id_tipo_compra_venta::varchar
                                        ],
                                    ARRAY['varchar',
                                        'integer',  
                                        'varchar',
                                        'varchar',
                                        'varchar',
                                        'numeric',
                                        'int4',
                                        'date',
                                        'varchar',
                                        'varchar',
                                        'numeric',
                                        'varchar',
                                        'numeric',
                                        'numeric',
                                        'numeric',
                                        'varchar',
                                        'varchar',
                                        'varchar',
                                        'int4',
                                        'int4',
                                        'varchar',
                                        'varchar',
                                        'varchar',
                                        'numeric',
                                        'varchar',
                                        'numeric',
                                        'numeric',
                                        'varchar',
                                        'int4',                         
                                        'numeric',
                                        'numeric',
                                        'numeric',
                                        'numeric',
                                        'integer',
                                        'integer',
                                        'integer']
    );
            
    --Insercion del documento
    v_resp = conta.ft_doc_compra_venta_ime(p_administrador,p_id_usuario,v_tabla,v_codigo_trans);

    --Obtencion del ID generado
    v_id_doc_compra_venta = pxp.f_obtiene_clave_valor(v_resp,'id_doc_compra_venta','','','valor')::integer;
    
    --Respuesta
    return v_id_doc_compra_venta;

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