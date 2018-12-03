--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_procesar_cierre_trans (
  p_agrupar_tramite boolean = false
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_config_cambiaria_ime
 DESCRIPCION:   este funcion  verifica el saldo cero de las trasaccion y las cierra 
 AUTOR: 		(rac)  kplian
 FECHA:	        01/09/2018
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

v_registros record;
 
BEGIN

   -- 
   
   IF p_agrupar_tramite THEN
   
      FOR v_registros in  (with presuma as (
                                  select
                                           t.id_cuenta,
                                           cue.desc_cuenta,
                                           aux.nombre_auxiliar,
                                           t.id_auxiliar,
                                           c.nro_tramite,
                                           pxp.aggarray(t.id_int_transaccion ) as ids_transaccion,
                                           sum(t.importe_debe_mb) as debe,
                                           sum(t.importe_haber_mb) as haber
                                         from conta.tint_transaccion t
                                         inner join conta.tint_comprobante c on c.id_int_comprobante = t.id_int_comprobante 
                                         inner join conta.tcuenta cue on cue.id_cuenta = t.id_cuenta
                                         inner join conta.tauxiliar aux on aux.id_auxiliar = t.id_auxiliar
                                         where  t.estado_reg = 'activo' and c.estado_reg = 'validado'
                                         group by 
                                              t.id_cuenta,
                                              t.id_auxiliar,
                                              c.nro_tramite ,
                                              cue.desc_cuenta,
                                              aux.nombre_auxiliar
                                  )
                                    select
                                    nro_tramite,
                                    id_cuenta,
                                    id_auxiliar,
                                    ids_transaccion,
                                                    
                                    debe - haber as saldo
                                    from presuma 
                                    where (debe - haber) = 0) LOOP
                                          
                                          
                    update  conta.tint_transaccion tr set
                        cerrado = 'si',
                        fecha_cerrado =  now()
                    where tr.id_int_transaccion =ANY(v_registros.ids_transaccion);                      
                                          
          
          
          END LOOP; 
   
   
   
   ELSE
   
        FOR v_registros in  (with presuma as (
                                      select
                                               t.id_cuenta,
                                               t.id_auxiliar,
                                               pxp.aggarray(t.id_int_transaccion ) as ids_transaccion,
                                               sum(COALESCE(t.importe_debe_mb,0)) as debe,
                                               sum(COALESCE(t.importe_haber_mb,0)) as haber
                                             from conta.tint_transaccion t
                                             inner join conta.tcuenta cue on cue.id_cuenta = t.id_cuenta
                                             inner join conta.tauxiliar aux on aux.id_auxiliar = t.id_auxiliar
                                             inner join conta.tint_comprobante c on c.id_int_comprobante = t.id_int_comprobante 
                                             where  t.estado_reg = 'activo' and c.estado_reg = 'validado'
                                             group by 
                                                  t.id_cuenta,
                                                  t.id_auxiliar 
                                      )
                                        select
                                        id_cuenta,
                                        id_auxiliar,
                                        ids_transaccion,
                                        debe - haber as saldo
                                        from presuma 
                                        where (debe - haber) = 0) LOOP
                                        
                                        
                  update  conta.tint_transaccion tr set
                      cerrado = 'si',
                      fecha_cerrado =  now()
                  where tr.id_int_transaccion =ANY(v_registros.ids_transaccion);                      
                                        
        
        
        END LOOP;      
    END IF;

 return true;

 
				        
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;