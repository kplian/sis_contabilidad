--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_pagos_pendientes_prov (
  p_id_auxiliar integer,
  p_id_tabla integer,
  p_tabla varchar,
  p_id_tipo_estado_cuenta integer,
  p_desde date,
  p_hasta date
)
RETURNS numeric [] AS
$body$
/*
  #DESCRIPCION:     esta funcion es hecha para el estado de cuenta de proveedores
   					busca todos los pagos pendientes en tesoeria para el proveedor
                    los parametors de entrada son 
                    	p_id_auxiliar integer,
                        p_id_tabla integer,
                        p_tabla varchar,
                        p_id_tipo_estado_cuenta integer,
                        p_desde date,
                        p_hasta date
                    
                    retorna array numeric 
                    
                       [1]  moneda base
                       [2]  moneda triangulacion
                    
  #AUTOR:           rensi arteaga copari  kplian
  #FECHA:           29-07-2017

*/


DECLARE

  v_resp 				varchar;
  v_nombre_funcion 		varchar;
  va_montos				numeric[];
  v_reg_prov			record;
  v_id_moneda_tri		integer;
  v_id_moneda_base		integer;
  v_monto_mb			numeric;


BEGIN
   
     v_nombre_funcion = 'conta.f_estado_cuenta';
     v_id_moneda_tri  =  param.f_get_moneda_triangulacion();
     v_id_moneda_base =  param.f_get_moneda_base();
     
     select 
        *
     into
       v_reg_prov
     from param.vproveedor p
     where p.id_proveedor = p_id_tabla;
     
     
   
     
     select 
       sum(param.f_convertir_moneda(op.id_moneda, v_id_moneda_base, pp.monto, op.fecha,'O',2)) as monto_mb
     into 
        v_monto_mb
     from tes.tobligacion_pago op
     inner join tes.tplan_pago pp on pp.id_obligacion_pago = op.id_obligacion_pago 
     where op.id_proveedor = v_reg_prov.id_proveedor
           and pp.tipo in ('devengado_pagado', 'devengado_pagado_1c','devengado')
           and op.estado_reg = 'activo'
           and pp.estado_reg = 'activo'
           and pp.estado not in ('devengado','pagado','anulado','pago_exterior'); 
   

     
      va_montos[1] = v_monto_mb;
      
      --convertir a dolares a la fecha fin de busqueda  
      va_montos[2] = param.f_convertir_moneda(v_id_moneda_base, v_id_moneda_tri, v_monto_mb, p_hasta,'O',2);
      
    
      
     return va_montos; 

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
SECURITY DEFINER
COST 100;