--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_int_trans_recalcular_tc (
  p_id_int_comprobante integer
)
RETURNS boolean AS
$body$
DECLARE


v_parametros  		record;
v_registros 		record;
v_nombre_funcion   	text;
v_resp				varchar;
v_nivel				integer;
v_monto				numeric;
v_mayor				numeric;
v_id_gestion  		integer;
v_tmp_formula		varchar;
v_formula_evaluado	varchar;
v_columna			varchar;
v_columna_nueva     varchar[];
v_sw_busqueda		boolean;
v_i					integer;
v_k					integer;
va_variables		varchar[];
v_registros_cbte	record;
v_registros_rel		record;
v_id_cuenta_bancaria	integer;
v_conta_validar_forma_pago		varchar;
v_id_moneda_base				integer;
v_importe_debe_mb				numeric;
v_importe_haber_mb				numeric;
v_importe_rel					numeric;
 

BEGIN

   v_nombre_funcion = 'conta.f_int_trans_recalcular_tc';
   
   -- recuepra datos basicos del comprobante
   select 
      ic.id_periodo,
      per.id_gestion,
      ic.manual,
      ic.origen,
      ic.tipo_cambio,
      ic.id_moneda,
      ic.fecha
   into
      v_registros_cbte
   from conta.tint_comprobante ic 
   inner join param.tperiodo per on per.id_periodo = ic.id_periodo
   where ic.id_int_comprobante = p_id_int_comprobante;
   
   IF v_registros_cbte.tipo_cambio is null THEN
      raise exception 'no se definio un tipo de cambio para el comprobante';
   END IF;
   
   -- Obtener la moneda base
   v_id_moneda_base = param.f_get_moneda_base();
          
    
   --listado de las transacciones del comprobante
   FOR v_registros in (select * 
                       from conta.tint_transaccion it 
                       where it.id_int_comprobante = p_id_int_comprobante) LOOP
              
   
        --recalcular
          --si es la moenda base   base utilizamos el tipo de cambio del comprobante, ...solicitamos C  (CUSTOM)
           v_importe_debe_mb  = param.f_convertir_moneda (v_registros_cbte.id_moneda, v_id_moneda_base, v_registros.importe_debe, v_registros_cbte.fecha,'CUS',2, v_registros_cbte.tipo_cambio);
           v_importe_haber_mb = param.f_convertir_moneda (v_registros_cbte.id_moneda, v_id_moneda_base, v_registros.importe_haber, v_registros_cbte.fecha,'CUS',2, v_registros_cbte.tipo_cambio);
           
             
            update conta.tint_transaccion it set
             importe_debe_mb = v_importe_debe_mb,
             importe_haber_mb = v_importe_haber_mb,
             importe_gasto_mb = v_importe_debe_mb,
             importe_recurso_mb = v_importe_haber_mb
            where it.id_int_transaccion = v_registros.id_int_transaccion; 
            
            
            --Si es comprobante de pago, revisamos si tienen relaciones con devengado 
            --listado de las transacciones del comprobante
             FOR v_registros_rel in (
                                      select 
                                         r.monto_pago, 
                                         r.monto_pago_mb,
                                         r.id_int_rel_devengado
                                     from conta.tint_rel_devengado r 
                                     where r.id_int_transaccion_pag = v_registros.id_int_transaccion and r.estado_reg = 'activo' ) LOOP
             
                   v_importe_rel  = param.f_convertir_moneda (v_registros_cbte.id_moneda, v_id_moneda_base, v_registros_rel.monto_pago, v_registros_cbte.fecha,'CUS',2, v_registros_cbte.tipo_cambio);
                   
                   
                   update conta.tint_rel_devengado r set
                     monto_pago_mb = v_importe_rel
                   where r.id_int_rel_devengado = v_registros_rel.id_int_rel_devengado;
                     
                
             END LOOP;
            
            
              
   END LOOP;
   
    --raise exception 'llega';  
   
   --retorna resultado
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