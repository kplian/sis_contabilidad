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
      ic.tipo_cambio_2,
      ic.id_moneda,
      ic.fecha,
      ic.sw_tipo_cambio
   into
      v_registros_cbte
   from conta.tint_comprobante ic 
   inner join param.tperiodo per on per.id_periodo = ic.id_periodo
   where ic.id_int_comprobante = p_id_int_comprobante;
   
   IF v_registros_cbte.tipo_cambio is null or  v_registros_cbte.tipo_cambio_2 is null THEN
      raise exception 'no se definio un tipo de cambio para el comprobante';
   END IF;
   
 
    
   --listado de las transacciones del comprobante
   FOR v_registros in (select * 
                       from conta.tint_transaccion it 
                       where it.id_int_comprobante = p_id_int_comprobante) LOOP
              
             --si el tipo de cambio no vario en las transacciones, actulizamos el tc en la transaccion si no es de actulizacion
             if v_registros_cbte.sw_tipo_cambio = 'no' then
             
                update conta.tint_transaccion it set
                 tipo_cambio = v_registros_cbte.tipo_cambio,
                 tipo_cambio_2 = v_registros_cbte.tipo_cambio_2
                where id_int_transaccion = v_registros.id_int_transaccion;
             
             end if;
            
             --calcula valroes en moenda base y de triangulacion 
             PERFORM  conta.f_calcular_monedas_transaccion(v_registros.id_int_transaccion);
            
          
              
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