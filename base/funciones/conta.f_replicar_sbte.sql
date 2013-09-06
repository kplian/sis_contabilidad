CREATE OR REPLACE FUNCTION conta.f_replicar_cbte (
  p_id_usuario integer,
  p_id_int_comprobante integer
)
RETURNS integer AS
$body$
/*
	Autor: RCM
    Fecha: 06-09-2013
    Descripción: Función que se Replica el comprbante de las estructuras intermedias a las destino. Puede ser también a ENDESIS
*/
DECLARE

    v_rec	 			record;
    v_id_comprobante	integer;
    v_id_transaccion	integer;
    v_id_moneda_cbte	integer;
    v_fecha_cbte		date;

BEGIN
	
	--1. Verificar existencia del comprobante validado
    if not exists(select 1 from conta.tint_comprobante
    			where id_int_comprobante = p_id_int_comprobante
                and estado_reg in ('validado')) then
    	raise exception 'Replicación no realizada: el comprobante debe estar Validado';
    end if;
    
    --2. Inserción de la cabecera
    --Obtención del id del comprobante
    v_id_comprobante = nextval('conta.tcomprobante_id_comprobante_seq'::regclass);
    
    insert into conta.tcomprobante(
    id_comprobante	,id_int_comprobante,
    id_usuario_reg  ,fecha_reg   ,estado_reg            ,id_clase_comprobante,
    id_subsistema   ,id_depto    ,id_moneda             ,id_periodo,
    nro_cbte        ,momento     ,glosa1                ,glosa2,
    beneficiario    ,tipo_cambio ,id_funcionario_firma1 ,id_funcionario_firma2,
    id_funcionario_firma3 ,fecha       ,nro_tramite	
    )
    select
    v_id_comprobante,id_int_comprobante,
    id_usuario_reg  ,fecha_reg   ,estado_reg            ,id_clase_comprobante,
    id_subsistema   ,id_depto    ,id_moneda             ,id_periodo,
    nro_cbte        ,momento     ,glosa1                ,glosa2,
    beneficiario    ,tipo_cambio ,id_funcionario_firma1 ,id_funcionario_firma2,
    id_funcionario_firma3 ,fecha       ,nro_tramite
    from conta.tint_comprobante
    where id_int_comprobante = p_id_int_comprobante;
    
    select id_moneda, fecha
    into v_id_moneda_cbte, v_fecha_cbte
    from conta.tint_comprobante
    where id_int_comprobante = p_id_int_comprobante;
    
    --3. Inserción de las transacciones y transacciones valor
    for v_rec in (select *
    				from conta.tint_transaccion
    				where id_int_comprobante = p_id_int_comprobante) loop
    				
    	--Inserción de la transacción
    	insert into conta.ttransaccion(
    	id_usuario_reg, fecha_reg, estado_reg, id_comprobante,
    	id_cuenta, id_auxiliar, id_centro_costo, id_partida,
    	id_partida_ejecucion, glosa, id_int_transaccion
    	) values(
    	p_id_usuario, now(), 'activo', v_id_comprobante,
    	v_rec.id_cuenta, v_rec.id_auxiliar, v_rec.id_centro_costo, v_rec.id_partida,
    	v_rec.id_partida_ejecucion, v_rec.glosa, v_rec.id_int_transaccion
    	) returning id_transaccion into v_id_transaccion;
    	
    	--Inserción de Transacción Valor
    	insert into conta.ttrans_val(
    	id_usuario_reg, fecha_reg, estado_reg, id_transaccion,
    	id_moneda, importe_debe, importe_haber, importe_recurso,
    	importe_gasto
    	)
    	select
    	p_id_usuario, now(), 'activo',v_id_transaccion,
    	mon.id_moneda,
    	param.f_convertir_moneda (v_id_moneda_cbte,mon.id_moneda,v_rec.importe_debe, v_fecha_cbte,'O',2),
    	param.f_convertir_moneda (v_id_moneda_cbte,mon.id_moneda,v_rec.importe_haber, v_fecha_cbte,'O',2),
    	param.f_convertir_moneda (v_id_moneda_cbte,mon.id_moneda,v_rec.importe_recurso, v_fecha_cbte,'O',2),
    	param.f_convertir_moneda (v_id_moneda_cbte,mon.id_moneda,v_rec.importe_gasto, v_fecha_cbte,'O',2)
    	from param.tmoneda mon
    	where mon.estado_reg = 'activo'
    	order by mon.prioridad;
    				
    end loop;
    
	--4. Verificación de replicación a ENDESIS
	
	--5. Respuesta
    return v_id_comprobante;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER;