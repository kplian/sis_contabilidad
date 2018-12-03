--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_validar_y_cerrar_transacciones (
  p_id_int_comprobante integer
)
RETURNS boolean AS
$body$
/*
	Autor: RAC
    Fecha: 01-09-2018
    Descripción: Es funcion obtiene un mayor de cuenta y aculizalres de las trasacciones miebro, si el saldo es cerro  las da por cerradas modifcados todas las involucradas
 
  ***************************************************************************************************   
    

    HISTORIAL DE MODIFICACIONES:
   	
 ISSUE            FECHA:		      AUTOR                 DESCRIPCION
   
 #0        		01-09-2018        RAC KPLIAN        creacion

*/
DECLARE

	
    v_nombre_funcion   				varchar;
    v_resp			                varchar;
    v_registros                     record;
    v_reg_basicos                   record;
   

BEGIN

    v_nombre_funcion:='conta.f_validar_y_cerrar_transacciones';
    
    --obtener array de cuentas del comprobante que estamos validando
   
    FOR v_reg_basicos in (select 
                              DISTINCT
                              tr.id_cuenta,
                              tr.id_auxiliar
                            from conta.tint_transaccion tr
                            inner join conta.tcuenta cu on cu.id_cuenta = tr.id_cuenta
                            inner join conta.tauxiliar aux on aux.id_auxiliar = tr.id_auxiliar
                            inner join conta.tconfig_subtipo_cuenta csc on csc.id_config_subtipo_cuenta = cu.id_config_subtipo_cuenta
                            inner join conta.tconfig_tipo_cuenta tc on tc.id_config_tipo_cuenta = csc.id_config_tipo_cuenta
                            where tr.id_int_comprobante = p_id_int_comprobante
                                  and tc.tipo_cuenta in ('activo','pasivo')) LOOP   --solo filtra cuentas de activo y pasivo que tengas auxiliares
    
         FOR v_registros in  (with presuma as (
                                          select
                                                   t.id_cuenta,
                                                   t.id_auxiliar,
                                                   pxp.aggarray(t.id_int_transaccion ) as ids_transaccion,
                                                   sum(COALESCE(t.importe_debe_mb,0)) as debe,
                                                   sum(COALESCE(t.importe_haber_mb,0)) as haber
                                                 from conta.tint_transaccion t
                                                 inner join conta.tint_comprobante c on c.id_int_comprobante = t.id_int_comprobante
                                                 inner join conta.tcuenta cue on cue.id_cuenta = t.id_cuenta
                                                 inner join conta.tauxiliar aux on aux.id_auxiliar = t.id_auxiliar 
                                                 where  t.estado_reg = 'activo'
                                                         and aux.id_auxiliar = v_reg_basicos.id_auxiliar
                                                         and cue.id_cuenta = v_reg_basicos.id_cuenta
                                                         and c.estado_reg = 'validado'
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
                          fecha_cerrado =  now(),
                          id_int_comprobante_cierre = p_id_int_comprobante
                      where tr.id_int_transaccion =ANY(v_registros.ids_transaccion);                      
                                            
            
            
            END LOOP;
    END LOOP;
    
   
    
    --8. Respuesta
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