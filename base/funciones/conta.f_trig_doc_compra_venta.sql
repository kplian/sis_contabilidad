--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_trig_doc_compra_venta (
)
RETURNS trigger AS
$body$
DECLARE
     v_reg_pres_par 			record;
     v_reg_pres_par_new			record;
     v_reg						record;
     v_id_partida_new			integer;
     v_id_partida_old			integer;
     v_id_presupuesto			integer;
     v_id_presupuesto_new		integer;
     v_importe_total_segun_memoria	numeric;
     v_importe_total_segun_memoria_new	numeric;
     v_estado	varchar;
BEGIN
   --     select (current_database()::text)||'_'||NEW.cuenta into g_new_login;
   --   select (current_database()::text)||'_'||OLD.cuenta into g_old_login;
   
       
      

       
       IF TG_OP = 'UPDATE' THEN
          
            IF OLD.id_int_comprobante is not NULL THEN
            
                -- solo podemos  editar los datos que no son importes
                
                IF   
                      OLD.importe_excento  != NEW.importe_excento
                    OR     OLD.importe_ice  !=  NEW.importe_ice
                    OR     OLD.importe_it !=  NEW.importe_it
                    OR     OLD.importe_iva  !=  NEW.importe_iva
                    OR     OLD.importe_descuento  !=  NEW.importe_descuento
                    OR     OLD.importe_doc     !=      NEW.importe_doc                       
                    OR     OLD.importe_descuento_ley  !=  NEW.importe_descuento_ley
                    OR     OLD.importe_pago_liquido !=  NEW.importe_pago_liquido   THEN
                    
                    
                     select 
                      c.estado_reg
                     into
                      v_estado
                    from conta.tint_comprobante c
                    where c.id_int_comprobante = OLD.id_int_comprobante;
                    IF v_estado = 'validado' THEN
                       raise exception 'No puede modificar los importes de un documento relacionado con un comprobante, Tiene que retroceder el proceso para una edición correcta';
                    END IF;
                END IF;
                
                
                
            
            
            END IF;
            
            
       		RETURN NEW;
       
       ELSEIF TG_OP = 'DELETE' THEN
        
             
              
              IF OLD.id_int_comprobante is not NULL THEN
              
                select 
                  c.estado_reg
                 into
                  v_estado
                from conta.tint_comprobante c
                where c.id_int_comprobante = OLD.id_int_comprobante;
                
                IF v_estado = 'validado' THEN
                   raise exception 'No puede eliminar el documento por que tiene un comprobante relacionado';
                END IF;
              
               
              END IF;
                
              RETURN OLD;
             
       END IF;   
     
       
       
   
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;