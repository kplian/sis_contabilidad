--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_validar_cbte_docs (
  p_id_int_comprobante integer,
  p_validar boolean = true
)
RETURNS varchar [] AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.f_validar_cbte_docs
 DESCRIPCION:   valida que los coumentos cuadren con el cbte
 AUTOR: 		 (rac)  kplian
 FECHA:	        13/06/2017
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE


v_nombre_funcion			varchar;
v_resp						varchar;
v_id_int_comprobante_bk		integer;
v_registros_cbte			record;
v_registros					record;
v_registros_rel				record;
v_id_int_transaccion_bk		integer;
v_conta_val_doc_venta		varchar;
v_conta_val_doc_compra		varchar;
v_registros_gasto			record;
v_registros_recurso			record;
v_registros_doc				record;
v_total_doc					numeric;
v_total_cbte_gasto			numeric;
v_total_cbte_recurso		numeric;
v_difenrecia				numeric;
v_conta_dif_doc_cbte		numeric;
v_resp_val_doc				varchar[];
v_conta_val_doc_otros_subcuentas_compras		varchar;
va_aux 						 VARCHAR[];



 

BEGIN

   v_nombre_funcion = 'conta.f_validar_cbte_docs';
   
   v_conta_val_doc_venta = pxp.f_get_variable_global('conta_val_doc_venta');
   v_conta_val_doc_compra = pxp.f_get_variable_global('conta_val_doc_compra');   
   v_conta_dif_doc_cbte = pxp.f_get_variable_global('conta_dif_doc_cbte')::numeric;
   
   
   v_conta_val_doc_otros_subcuentas_compras = pxp.f_get_variable_global('conta_val_doc_otros_subcuentas_compras');
   va_aux = string_to_array(v_conta_val_doc_otros_subcuentas_compras,',');
   
   v_resp_val_doc[1] = 'TRUE';
   
  
   
   --si el comprobante tiene cuentas de gasto o recurso
   --validamos
   --sumar todas las cuentas de gasto
       
     select
         sum(t.importe_debe) as debe,
         sum(t.importe_haber) as haber
     into
         v_registros_gasto
     from conta.tint_transaccion t
     inner join conta.tcuenta c on t.id_cuenta = c.id_cuenta
     inner join conta.tconfig_subtipo_cuenta csc on csc.id_config_subtipo_cuenta = c.id_config_subtipo_cuenta
     where      t.id_int_comprobante = p_id_int_comprobante
           and  (lower(c.tipo_cuenta) in('gasto','costo','egreso') or upper(csc.nombre) = ANY(va_aux)); 
             
             
  --sumar todas las cuentas de recurso
     select
         sum(t.importe_debe) as debe,
         sum(t.importe_haber) as haber
     into
         v_registros_recurso
     from conta.tint_transaccion t
     inner join conta.tcuenta c on t.id_cuenta = c.id_cuenta
     where      t.id_int_comprobante = p_id_int_comprobante
           and  lower(c.tipo_cuenta)  in('recurso','ingreso','venta'); 
   
   
   --solo valida para los cbte de diario
   IF v_registros_recurso is not null  or v_registros_gasto is not null THEN
   
       
             
             
      
        --sumamos el monto de documento y el via de todas los asociados
        
        select
           sum(dcv.importe_doc) as importe_doc,
           sum(dcv.importe_iva) as importe_iva,
           sum(dcv.importe_descuento) as importe_descuento
        into
           v_registros_doc
        from conta.tdoc_compra_venta dcv
        where dcv.id_int_comprobante = p_id_int_comprobante; 
         
        
        v_total_doc = COALESCE(v_registros_doc.importe_doc,0) -  COALESCE(v_registros_doc.importe_descuento,0) - COALESCE(v_registros_doc.importe_iva,0);
        v_total_cbte_recurso = COALESCE(v_registros_recurso.haber,0) - COALESCE(v_registros_recurso.debe,0);
        v_total_cbte_gasto = COALESCE(v_registros_gasto.debe,0) - COALESCE(v_registros_gasto.haber,0);
        
       
        IF v_conta_val_doc_compra = 'si' and  v_total_cbte_gasto > v_total_cbte_recurso  and p_validar THEN               
             
             IF v_total_doc !=  v_total_cbte_gasto   THEN 
                   v_difenrecia = v_total_cbte_gasto - v_total_doc; 
                                     
                   if  v_difenrecia > v_conta_dif_doc_cbte or v_difenrecia < (v_conta_dif_doc_cbte*-1) THEN                 
                        v_resp_val_doc[1] = 'FALSE';
                        v_resp_val_doc[2] = format('El monto  total de   documentos %s (DOC: %s IVA: %s DESC: %s )  no cuadra con los gastos del comprobante %s, diferencia de (%s)', v_total_doc::varchar,  COALESCE(v_registros_doc.importe_doc,0)::varchar, COALESCE(v_registros_doc.importe_iva,0)::varchar, COALESCE(v_registros_doc.importe_descuento,0)::Varchar, v_total_cbte_gasto::varchar, (v_total_cbte_gasto - v_total_doc)::varchar);
                        
                        return v_resp_val_doc;
                   end if;
              
              END IF;
        END IF;
        
         IF v_conta_val_doc_venta = 'si' and v_total_cbte_recurso >  v_total_cbte_gasto and p_validar   THEN          
             IF v_total_doc !=  v_total_cbte_recurso   THEN 
             
                  v_difenrecia = v_total_cbte_recurso - v_total_doc;                  
                  if  v_difenrecia > v_conta_dif_doc_cbte or v_difenrecia < (v_conta_dif_doc_cbte*-1) THEN 
                     v_resp_val_doc[1] = 'FALSE';
                     v_resp_val_doc[2] = format('(Ventas) El monto total de   documentos %s (DOC: %s IVA: %s DESC: %s )  no cuadra con los recursos del comprobante %s, diferencia de (%s)', v_total_doc::varchar, COALESCE(v_registros_doc.importe_doc,0)::varchar, COALESCE(v_registros_doc.importe_iva,0)::varchar, COALESCE(v_registros_doc.importe_descuento,0)::Varchar, v_total_cbte_recurso::varchar,(v_total_cbte_recurso - v_total_doc)::varchar);
                     return v_resp_val_doc;
                  end if;
                  
              END IF;
        END IF;
        
        ----------------------------------
        -- CONSIDERACIONES
        --  1, cuando sea un comprbante de ajuste muy probablemente las partida de gasto al haber y debe cuadren , en casos de ajuste no habra documentos asociados
        --  2,  
        -------------------------------------
             
   
   
   END IF;
    
     
   
  return v_resp_val_doc;

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