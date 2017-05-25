--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_calcular_relacion_devengado_pago (
  p_id_int_comprobante integer,
  p_id_usuario integer
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.f_calcular_relacion_devengado_pago
 DESCRIPCION:   en funcion a los codigos de las moendas regresa el tipo de cambio correspondiente
                la conversion se ha pasando por moneda base, si no encuentra regresa NULL
 AUTOR: 		 (rac)  kplian
 FECHA:	        05-11-2015 12:39:12
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE


v_registros_mon_1  		record;
v_registros_mon_2       record;
v_nombre_funcion		varchar;
v_resp					varchar;

v_registros				record;
v_reg_cbte_dev			record;
v_reg_cbte_pago			record;

v_conta_cod_cuentas_x_pagar   	varchar;
v_conta_cod_cuentas_x_cobrar    varchar;
v_conta_cod_iva   				varchar;

va_conta_cod_cuentas_x_pagar   	varchar[];
va_conta_cod_cuentas_x_cobrar   varchar[];
va_conta_cod_iva   				varchar[];

 

BEGIN

  	  v_nombre_funcion = 'conta.f_calcular_relacion_devengado_pago';
   
        /*
            El comprobante de pago puede estar en diferente gestión que el devengado (las busqueda de cuentas es por código)
         */

      -- obtener comprobante de pago

        select 
         cp.*,
         p.id_gestion
        into
         v_reg_cbte_pago 
        from  conta.tint_comprobante cp
        inner join param.tperiodo p on p.id_periodo ? cp.id_periodo
        where cp.id_int_comprobante = p_id_int_comprobante;
        
               
      
        -- crear table temporal para almacenr gastos disponibles
        
        CREATE TEMPORARY TABLE temp_gasto_dev (
                                      id serial,
                                      id_int_transaccion_dev  integer,
                                      id_int_transaccion_pag  integer,
                                      monto_dis				  numeric,
                                      factor                  numeric
                                     ) ON COMMIT DROP;
      
      
         ---------------------------------------------------------------------------------
         -- recuperar codigos de las cuentas  de IVA DF y IVA CF, cuentas por pagar y cuentas por cobrar
         -- en Array ya que para cada tipo podriamso tener mas de uan cueta
         -- ejem cuentas por pagar a cotor plazo, largo plazo etc ....
         ---------------------------------------------------------------------------------
         
            -- recupera codigos de las cuentas de la configuracion general
            v_conta_cod_cuentas_x_pagar = pxp.f_get_variable_global('conta_cod_cuentas_x_pagar');
            v_conta_cod_cuentas_x_cobrar = pxp.f_get_variable_global('conta_cod_cuentas_x_cobrar');
            v_conta_cod_iva = pxp.f_get_variable_global('conta_cod_iva');
         
         
                  
      
           --  FOR  listar todas las transacciones de pago diponibles  (Cuenta por pagar o por cobrar)
           --       que tengan cuentas por pagar o por cobrar
        
        
            -- FOR listar  todos los comprobantes de devengado (relacioandos al cbte de pago)
            
            FOR v_reg_cbte_dev in (
                          select
                             c.*
                           from 
                          conta.tint_comprobante c
                          where c.id_int_comprobante  = ANY(c.id_int_comprobante_fks)) LOOP
            
         
                --  verificar que la moneda del cbte de devengado sea la misma que el cbte de pago
                
                IF v_reg_cbte_dev.id_moneda != v_reg_cbte_pago.id_moneda  THEN            
                    raise exception 'la moneda del cbte de devengado (%, id: %) es diferente al cbte de pago', v_reg_cbte_dev.nro_cbte, v_reg_cbte_dev.id_int_comprobante;
                END IF;
                
                
                 -- FOR  recorrer transacciones de gasto devengadas 
                 --      que tienen partida ejecucion  o  cuentas de IVA
                
                
                      -- sumar  si tienen pago realizados  (tabla int_rel_dev)
                
                      --  insertar en tabla temporal el saldo disponible para este gasto
                
                
            
            END LOOP;
            
             --  Calcular Factor deprorrateo para cada gasto (el ultimo suma 1)
            
             --  calcular importe a pagar
            
             --  insertar relacion devengado pago
             
             --  vaciar tabla temporal
        
        
        -- end LOOP de transaciones pagos    
            
            
          
      
      
     
    
      return TRUE;




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
STABLE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;