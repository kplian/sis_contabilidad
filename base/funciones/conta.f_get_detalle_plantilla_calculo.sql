--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_get_detalle_plantilla_calculo (
  p_id_plantilla integer,
  p_codigo_relacion varchar,
  out ps_monto_porc numeric,
  out ps_observaciones varchar
)
RETURNS SETOF record AS
$body$
/*
Autor Rensi Arteaga Copari
Fecha 01/07/2013
Descripcion:  recupera los porcentajes segun codigo de relacion contable

ejmplo




*/
DECLARE
v_nombre_funcion varchar;
v_resp varchar;
v_registros record;
	
BEGIN

  ps_monto_porc = 0;
  ps_observaciones = '';

	
   FOR v_registros in ( 
                       select   
                        pc.descuento,
                        pc.tipo_importe,
                        pc.importe,
                        pc.descripcion,
                        pc.codigo_tipo_relacion
                       from conta.tplantilla_calculo pc
                       where  pc.id_plantilla = p_id_plantilla ) LOOP
                       
            IF  lower(v_registros.codigo_tipo_relacion) = lower(p_codigo_relacion)  THEN
            
              IF v_registros.tipo_importe = 'porcentaje' THEN
                 
                   ps_monto_porc = ps_monto_porc + v_registros.importe;
                   ps_observaciones = ps_observaciones ||'('|| v_registros.descripcion||','||v_registros.importe*100||'%) ';
                 
               ELSE 
                   
                 raise exception 'Para descuentos diferentes de porcentaje, falta definir la moneda el tabla de plantilla TODO'; 
                 
               END IF;
            END IF;
       
   
                          

   END LOOP;
    
       
  
return NEXT;
return;

   
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
COST 100 ROWS 1;