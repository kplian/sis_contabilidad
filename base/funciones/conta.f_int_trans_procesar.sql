CREATE OR REPLACE FUNCTION conta.f_int_trans_procesar (
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
v_id_cuenta_bancaria	integer;
 

BEGIN

   v_nombre_funcion = 'conta.f_int_trans_procesar';
   
   -- recuepra datos basicos del comprobante
   select 
      ic.id_periodo,
      per.id_gestion,
      ic.manual,
      ic.origen,
      ic.id_clase_comprobante,
      cc.codigo,
      ic.nro_tramite ,
      ic.id_subsistema
   into
      v_registros_cbte
   from conta.tint_comprobante ic 
   inner join param.tperiodo per on per.id_periodo = ic.id_periodo
   inner join conta.tclase_comprobante cc on cc.id_clase_comprobante = ic.id_clase_comprobante
   where ic.id_int_comprobante = p_id_int_comprobante;
   
   
  
    
     --listado de las transacciones del comprobante
     FOR v_registros in (select * 
                         from conta.tint_transaccion it 
                         where it.id_int_comprobante = p_id_int_comprobante) LOOP
              
          ----------------------------------------------------------------------------------------------------
          --  FORMA DE PAGO, si es un cmprobante de pago
          --  analiza si la cuenta contable esta relacionada con una cuenta bancaria y esta al haber para pago
          --  tipo relacion contable = CUEBANCEGRE;   cuenta bancaria egreso
          ------------------------------------------------------------------------------------------------------
                
          --si es un cbte de pago
           
          IF upper(trim(v_registros_cbte.codigo)) in ('PAGO','PAGOCON') and v_registros_cbte.id_subsistema != 13  THEN  
             
             
            
           -- busca si alguna de las cuentas contables tiene relacion 
              -- con una cuenta bancaria
              v_id_cuenta_bancaria = NULL;
                    
              IF v_registros.importe_haber > 0   THEN   
                  select 
                     rc.id_tabla
                  into
                     v_id_cuenta_bancaria
                  from  conta.trelacion_contable rc
                  inner join conta.ttipo_relacion_contable trc on trc.id_tipo_relacion_contable = rc.id_tipo_relacion_contable
                  where      trc.codigo_tipo_relacion = 'CUEBANCEGRE' 
                         and rc.id_cuenta = v_registros.id_cuenta 
                         and rc.id_gestion = v_registros_cbte.id_gestion
                         and rc.id_auxiliar = v_registros.id_auxiliar
                  offset 0 limit 1;
              END IF;
                 
                 
              IF v_id_cuenta_bancaria is not null  THEN
                 UPDATE  conta.tint_transaccion it set
                   id_cuenta_bancaria =  v_id_cuenta_bancaria,
                   banco = 'si'   -- bandera que habilita boton de cheque  en la interface, y exige el registro en la validacion
                 WHERE id_int_transaccion = v_registros.id_int_transaccion;
                    
                -- raise exception 'entra %', v_registros.id_int_transaccion;
              ELSE
                     
                UPDATE  conta.tint_transaccion it set
                 id_cuenta_bancaria =  NULL,
                 banco = 'no'   
                WHERE id_int_transaccion = v_registros.id_int_transaccion;
                    
              END IF;
         END IF;
              
        -----------------------------------
        --TODO agregar otras validaciones
        -----------------------------------
              
     END LOOP;
         
   
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