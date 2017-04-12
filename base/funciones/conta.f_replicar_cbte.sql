--------------- SQL ---------------

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
    v_rec_tv			record;

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
    
    select 
      id_moneda, 
      fecha
    into 
      v_id_moneda_cbte, 
      v_fecha_cbte
    from conta.tint_comprobante
    where id_int_comprobante = p_id_int_comprobante;
    
    -- TODO, agrupacion de transacciones similares ....   
    
  
    --3. Inserción de las transacciones y transacciones valor
    
     --3. Inserción de las transacciones y transacciones valor
    for v_rec in (select *
    				from conta.tint_transaccion
    				where id_int_comprobante = p_id_int_comprobante) loop
    				
    	--Inserción de la transacción
    	insert into conta.ttransaccion(
          id_usuario_reg, 
          fecha_reg, 
          estado_reg, 
          id_comprobante,
          id_cuenta, 
          id_auxiliar, 
          id_centro_costo, 
          id_partida,
          id_partida_ejecucion, 
          glosa, 
          id_int_transaccion,
          id_orden_trabajo,
          importe_debe,
          importe_haber,
          importe_gasto,
          importe_recurso
    	) values(
          p_id_usuario, 
          now(), 
          'activo', 
          v_id_comprobante,
          v_rec.id_cuenta, 
          v_rec.id_auxiliar, 
          v_rec.id_centro_costo, 
          v_rec.id_partida,
          v_rec.id_partida_ejecucion, 
          v_rec.glosa, 
          v_rec.id_int_transaccion,
          v_rec.id_orden_trabajo,
          v_rec.importe_debe,
          v_rec.importe_haber,
          v_rec.importe_gasto,
          v_rec.importe_recurso
    	) returning id_transaccion into v_id_transaccion;
    	
    end loop;
    --el triguer se encarga de insertar estos valores ...
    
    
    
	--4. Verificación de replicación a ENDESIS
	
	--5. Respuesta
    return v_id_comprobante;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;