--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_insert_int_trans_val (
)
RETURNS trigger AS
$body$
/**************************************************************************
 SISTEMA ENDESIS - SISTEMA DE SEGURIDAD (SSS)
***************************************************************************
 SCRIPT: 		trisg_usuario
 DESCRIPCIÓN: 	Segun la int_trasaccion del comprobante inserta o modfica los valores de int_trans_Val
 AUTOR: 		KPLIAN(rac)
 FECHA:			11-12-2014
 COMENTARIOS:	
**************************************************************************/
--------------------------
-- CUERPO DE LA FUNCIÓN --
--------------------------

--**** DECLARACION DE VARIABLES DE LA FUNCIÓN (LOCALES) ****---


DECLARE
   v_registros_con 	 record;
   v_registros		 record;
   v_id_moneda_base  integer;
   v_importe_debe    numeric;
   v_importe_haber	 numeric;
   v_importe_recurso numeric;
   v_importe_gasto	 numeric;
    
BEGIN

      --*** EJECUCIÓN DEL PROCEDIMIENTO ESPECÍFICO
      
      
          select 
            c.fecha,
            c.tipo_cambio,
            c.id_moneda
          into
           v_registros_con
          from conta.tint_comprobante  c
          where c.id_int_comprobante = NEW.id_int_comprobante;
          
         -- raise exception 'tipo de cambio en la tras %', v_registros_con.tipo_cambio;
                  
         -- Obtener la moneda base
         v_id_moneda_base=param.f_get_moneda_base();
      
         IF TG_OP = 'INSERT' THEN

           BEGIN
               
                 -- inserta transaccion valor para las diferente monedas habilitadas
                  
                  FOR  v_registros in (
                            select 
                              mon.id_moneda
                            from param.tmoneda mon
                             where mon.estado_reg = 'activo' and contabilidad = 'si'
                             order by mon.prioridad
                      ) LOOP
                  
                       
                            IF v_registros.id_moneda = v_id_moneda_base   and v_registros_con.tipo_cambio is not  NULL THEN
                               
                               --si es la moenda base   base utilizamos el tipo de cambio del comprobante, ...solicitamos C  (CUSTOM)
                               v_importe_debe  = param.f_convertir_moneda (v_registros_con.id_moneda, v_registros.id_moneda, NEW.importe_debe, v_registros_con.fecha,'CUS',2, v_registros_con.tipo_cambio);
                               v_importe_haber = param.f_convertir_moneda (v_registros_con.id_moneda, v_registros.id_moneda, NEW.importe_haber, v_registros_con.fecha,'CUS',2, v_registros_con.tipo_cambio);
                               v_importe_recurso =  param.f_convertir_moneda (v_registros_con.id_moneda, v_registros.id_moneda, NEW.importe_recurso, v_registros_con.fecha,'CUS',2, v_registros_con.tipo_cambio);
                               v_importe_gasto  = param.f_convertir_moneda (v_registros_con.id_moneda, v_registros.id_moneda, NEW.importe_gasto, v_registros_con.fecha,'CUS',2, v_registros_con.tipo_cambio);
                            
                            ELSE
                            
                              --si no tenemso tipo de cambio convenido .....
                               v_importe_debe  = param.f_convertir_moneda (v_registros_con.id_moneda, v_registros.id_moneda, NEW.importe_debe, v_registros_con.fecha,'O',2);
                               v_importe_haber = param.f_convertir_moneda (v_registros_con.id_moneda, v_registros.id_moneda, NEW.importe_haber, v_registros_con.fecha,'O',2);
                               v_importe_recurso =  param.f_convertir_moneda (v_registros_con.id_moneda, v_registros.id_moneda, NEW.importe_recurso, v_registros_con.fecha,'O',2);
                               v_importe_gasto  = param.f_convertir_moneda (v_registros_con.id_moneda, v_registros.id_moneda,  NEW.importe_gasto, v_registros_con.fecha,'O',2);
                           
                            
                            END IF;
                      
                             
                      
                          insert into conta.tint_trans_val(
                              id_usuario_reg, 
                              fecha_reg, 
                              estado_reg, 
                              id_int_transaccion,
                              id_moneda,
                              importe_debe, 
                              importe_haber, 
                              importe_recurso,
                              importe_gasto
                          ) 
                          values(
                              NEW.id_usuario_reg, 
                              NEW.fecha_reg, 
                              'activo', 
                              NEW.id_int_transaccion,
                              v_registros.id_moneda,
                              v_importe_debe,
                              v_importe_haber,
                              v_importe_recurso,
                              v_importe_gasto
                           );
                  
                  END LOOP;

     
    	 END;
     
   ELSIF TG_OP = 'UPDATE' THEN

        BEGIN
            
                --obtenemos los registros de trans_valor de la transacion
                  
                  FOR  v_registros in (
                            select 
                              tv.id_moneda,
                              tv.id_int_transaccion,
                              tv.id_int_trans_val
                            from conta.tint_trans_val  tv 
                            where tv.estado_reg = 'activo' and tv.id_int_transaccion = NEW.id_int_transaccion
                      ) LOOP
                  
                       
                            IF v_registros.id_moneda = v_id_moneda_base   and v_registros_con.tipo_cambio is not  NULL THEN
                            
                               --si es la moenda base   base utilizamos el tipo de cambio del comprobante, ...solicitamos C  (CUSTOM)
                               v_importe_debe  = param.f_convertir_moneda (v_registros_con.id_moneda, v_registros.id_moneda, NEW.importe_debe, v_registros_con.fecha,'C',2, v_registros_con.tipo_cambio);
                               v_importe_haber = param.f_convertir_moneda (v_registros_con.id_moneda, v_registros.id_moneda, NEW.importe_haber, v_registros_con.fecha,'C',2, v_registros_con.tipo_cambio);
                               v_importe_recurso =  param.f_convertir_moneda (v_registros_con.id_moneda, v_registros.id_moneda, NEW.importe_recurso, v_registros_con.fecha,'C',2, v_registros_con.tipo_cambio);
                               v_importe_gasto  = param.f_convertir_moneda (v_registros_con.id_moneda, v_registros.id_moneda, NEW.importe_gasto, v_registros_con.fecha,'C',2, v_registros_con.tipo_cambio);
                            
                            ELSE
                            
                              --si no tenemso tipo de cambio convenido .....
                               v_importe_debe  = param.f_convertir_moneda (v_registros_con.id_moneda, v_registros.id_moneda, NEW.importe_debe, v_registros_con.fecha,'O',2);
                               v_importe_haber = param.f_convertir_moneda (v_registros_con.id_moneda, v_registros.id_moneda, NEW.importe_haber, v_registros_con.fecha,'O',2);
                               v_importe_recurso =  param.f_convertir_moneda (v_registros_con.id_moneda, v_registros.id_moneda, NEW.importe_recurso, v_registros_con.fecha,'O',2);
                               v_importe_gasto  = param.f_convertir_moneda (v_registros_con.id_moneda, v_registros.id_moneda,  NEW.importe_gasto, v_registros_con.fecha,'O',2);
                           
                            
                            END IF;
                      
                             
                      
                          update conta.tint_trans_val set
                             
                              estado_reg = NEW.estado_reg,
                              fecha_mod = NEW.fecha_mod,
                              id_usuario_mod =  NEW.id_usuario_mod,
                              importe_debe = v_importe_debe, 
                              importe_haber = v_importe_haber, 
                              importe_recurso = v_importe_recurso,
                              importe_gasto = v_importe_gasto
                          where id_int_trans_val = v_registros.id_int_trans_val;
                  
                  END LOOP;
              
             
             
             -- si el nuevo estado reg cambi a inactivo,... inactivamos los registros de transaccion valor
            


        END;

  --procedimiento de eliminación 

   ELSIF TG_OP = 'DELETE' THEN

        BEGIN

        END;
        

   END IF;

   RETURN NULL;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;