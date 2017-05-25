--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_act_gestion_transaccion (
  p_id_int_comprobante integer,
  p_id_gestion_cbte integer,
  p_id_gestion_trans integer
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.f_act_gestion_transaccion
 DESCRIPCION:   actuliza las cuentas, partidas y centros de costos segun gestion de cabecera
 AUTOR: 		 (rac)  kplian
 FECHA:	        21-12-2015 12:39:12
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE


v_nombre_funcion		varchar;
v_resp					varchar;


v_gestion_cbte			integer;

v_gestion_trans			integer;


v_gestion_origen			integer;

v_gestion_destino			integer;
sw_trans					boolean;
v_registros					record;
v_id_centro_costo_act		integer;
v_id_partida_act			integer;
v_id_cuenta_act				integer;
 

BEGIN

    v_nombre_funcion = 'conta.f_act_gestion_transaccion';
  
    --  verifica que solo sea una gestion de diferencia...
    
    SELECT 
      g.gestion
    into 
      v_gestion_cbte
    FROM PARAM.TGESTION g 
    where g.id_gestion = p_id_gestion_cbte;
    
    
    SELECT 
      g.gestion
    into 
      v_gestion_trans
    FROM PARAM.TGESTION g 
    where g.id_gestion = p_id_gestion_trans;
    
    
    
    IF v_gestion_trans < v_gestion_cbte THEN
        
        IF  (v_gestion_cbte - v_gestion_trans)  > 1  THEN
               raise exception 'La diferencias de gestion no puede ser mayor a una';
        END IF;
        
        sw_trans = true;
       
          
    ELSEIF v_gestion_trans >  v_gestion_cbte THEN
        
        IF  (v_gestion_trans - v_gestion_cbte)  > 1  THEN
                   raise exception 'La diferencias de gestion no puede ser mayor a una';
        END IF;
        
        sw_trans = false;
        
        
    ELSE 
      raise exception 'las gestiones  son iguales';
    END IF;
    

    -- for listados de las transacciones
    FOR  v_registros in (
                          select 
                               it.*,
                               c.id_gestion,
                               c.nombre_cuenta
                          from conta.tint_transaccion it
                          inner join conta.tcuenta c on c.id_cuenta = it.id_cuenta
                          where it.id_int_comprobante = p_id_int_comprobante
                                and it.estado_reg = 'activo'
                          
                     ) LOOP 
                     
                     
           v_id_centro_costo_act = NULL;
           v_id_partida_act = NULL;
           v_id_cuenta_act = NULL;
                     
           
           -- revisa la gestion de la cuenta , si no conincide con la gestion de ltransaccion lanzamos errors
           IF v_registros.id_gestion != p_id_gestion_trans  THEN
               raise exception 'la gestión de a cuenta % no se corresponde con la gestion de la transacción', v_registros.nombre_cuenta;
           END IF;
           
           -- recupera nuevo centro de costo
           
           select case  
              when sw_trans then 
                 pi.id_presupuesto_dos
              else
                 pi.id_presupuesto_uno
              end            
           into 
               v_id_centro_costo_act
           from pre.tpresupuesto_ids pi
           where 
               case                
                  when sw_trans then 
                      pi.id_presupuesto_uno = v_registros.id_centro_costo
                  else
                      pi.id_presupuesto_dos = v_registros.id_centro_costo
                  end;
           
          
            IF v_id_centro_costo_act is null THEN
              raise exception 'no se encontro el centro de costo para la gestión destino % (para id: %   en tabla IDS)', v_gestion_cbte, v_registros.id_centro_costo;
           END IF;
           
           -- recupera nueva partida
           
           select case  
              when sw_trans then 
                 pi.id_partida_dos
              else
                 pi.id_partida_uno
              end            
           into 
               v_id_partida_act
           from pre.tpartida_ids pi
           where 
               case                
                  when sw_trans then 
                      pi.id_partida_uno = v_registros.id_partida
                  else
                      pi.id_partida_dos = v_registros.id_partida
                  end;
           
           
           IF v_id_partida_act is null THEN
              raise exception 'no se encontro el partida para la gestión destino % (para id: %   en tabla IDS)', v_gestion_cbte, v_registros.id_partida;
           END IF;
           
           -- recupera nueva cuenta
           
           select case  
              when sw_trans then 
                 pi.id_cuenta_dos
              else
                 pi.id_cuenta_uno
              end            
           into 
               v_id_cuenta_act
           from conta.tcuenta_ids pi
           where 
               case                
                  when sw_trans then 
                      pi.id_cuenta_uno = v_registros.id_cuenta
                  else
                      pi.id_cuenta_dos = v_registros.id_cuenta
                  end;
           
           
           IF v_id_cuenta_act is null THEN
              raise exception 'no se encontro el cuenta para la gestión destino % (para id: %   en tabla IDS)', v_gestion_cbte, v_registros.id_cuenta;
           END IF;
           
           -- actualizamos transaccion con los valores actuales
           
           update conta.tint_transaccion t set
              id_cuenta = v_id_cuenta_act,
              id_partida = v_id_partida_act,
              id_centro_costo = v_id_centro_costo_act
           where id_int_transaccion = v_registros.id_int_transaccion;
           
           
           
           
           
           
      END LOOP;      
   
    return true;


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