--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_validar_cbte_docs (
  p_id_int_comprobante integer,
  p_validar boolean = true,
  p_forzar_validacion varchar = 'no'::character varying
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

   	
 ISSUE            FECHA:		      AUTOR                 DESCRIPCION
   
 #86  ETR       24/02/2018        RAC KPLIAN        Validar que el monto IVA y descuentos cuadre al validar el comprobante

 
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
va_aux 						 					VARCHAR[];
v_conta_lista_blanca_cbte_docs					varchar;
v_registros_doc_dui	         record;
v_registros_iva_cf	         record; -- #86 +
v_registros_iva_df	         record; -- #86 +
v_registros_desc_ley    	 record; -- #86 +
v_lista_docs           		 varchar;-- #86 +
v_reg_cbte  				 record; -- #86 +
v_error_round                numeric;-- #86 +



BEGIN

   v_nombre_funcion = 'conta.f_validar_cbte_docs';
   
   v_conta_val_doc_venta = pxp.f_get_variable_global('conta_val_doc_venta');
   v_conta_val_doc_compra = pxp.f_get_variable_global('conta_val_doc_compra');   
   v_conta_dif_doc_cbte = pxp.f_get_variable_global('conta_dif_doc_cbte')::numeric;
   v_conta_lista_blanca_cbte_docs = pxp.f_get_variable_global('conta_lista_blanca_cbte_docs'); 
   v_conta_val_doc_otros_subcuentas_compras = pxp.f_get_variable_global('conta_val_doc_otros_subcuentas_compras');
   va_aux = string_to_array(v_conta_val_doc_otros_subcuentas_compras,',');
   
   --#obtenemos el periodo del cbte y la fecha
   v_error_round = 0.06;-- #86 + error de redondeo apra validacion
   
   
   v_resp_val_doc[1] = 'TRUE';
   
   --#86   considerar casos en los que si se salta la validacio de codumentos, por ejemplo cbte volcados, de reversion
   IF p_forzar_validacion = 'si' THEN
      p_validar  =TRUE;
   END IF;
   
   select 
      c.fecha,
      c.volcado,
      c.cbte_reversion,
      c.cbte_apertura,
      c.cbte_cierre,
      c.cbte_aitb
     into
       v_reg_cbte
   from conta.tint_comprobante c  
   where   c.id_int_comprobante =  p_id_int_comprobante;
   
   
   IF v_reg_cbte.cbte_cierre = 'si'   or v_reg_cbte.cbte_apertura = 'si' or  v_reg_cbte.cbte_reversion  = 'si'or v_reg_cbte.cbte_aitb  = 'si' THEN
      p_validar  =FALSE;  --soltamso la validacion solo apra casos especificamos
   END IF;
   
   
   
   -- #86 OJO ANALIZAR ESTOS CASOS .. me aprece que nodeberiamos tener.....
  
  /*
   IF exists (
               select 1
               from conta.tint_comprobante c
               left join conta.tplantilla_comprobante pc on pc.id_plantilla_comprobante = c.id_plantilla_comprobante
               where c.id_int_comprobante = p_id_int_comprobante
                     and  pc.codigo =ANY(string_to_array(v_conta_lista_blanca_cbte_docs,',')) )THEN
       p_validar = FALSE;
       
   END IF;*/
   
   
  
   
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
           
           
   -- #86  suma del IVA Credito Fiscal ...  revisar que el plan de cuentas este configurado adecuadamente
     select
         sum(t.importe_debe) as debe,
         sum(t.importe_haber) as haber
     into
         v_registros_iva_cf
     from conta.tint_transaccion t
     inner join conta.tcuenta c on t.id_cuenta = c.id_cuenta
     inner join conta.tconfig_subtipo_cuenta s on s.id_config_subtipo_cuenta = c.id_config_subtipo_cuenta
     where      t.id_int_comprobante = p_id_int_comprobante
     
           and  trim(s.nombre)  in('IVA-CF'); 
           
           
       
           
   -- #86  suma del IVA DEBITO  Fiscal ...  revisar que el plan de cuentas este configurado adecuadamente
     select
         sum(t.importe_debe) as debe,
         sum(t.importe_haber) as haber
     into
         v_registros_iva_df
     from conta.tint_transaccion t
     inner join conta.tcuenta c on t.id_cuenta = c.id_cuenta
     inner join conta.tconfig_subtipo_cuenta s on s.id_config_subtipo_cuenta = c.id_config_subtipo_cuenta
     where      t.id_int_comprobante = p_id_int_comprobante
     
           and  trim(s.nombre)  in('IVA-DF');         
           
   
    -- #86   suma de descuentos retenciones de ley    
     select
         sum(t.importe_debe) as debe,
         sum(t.importe_haber) as haber
     into
         v_registros_desc_ley
     from conta.tint_transaccion t
     inner join conta.tcuenta c on t.id_cuenta = c.id_cuenta
     inner join conta.tconfig_subtipo_cuenta s on s.id_config_subtipo_cuenta = c.id_config_subtipo_cuenta
     where      t.id_int_comprobante = p_id_int_comprobante
     
           and  trim(s.nombre)  in('DESC-LEY');  
           
                  
     --sumamos el monto de documento y el IVA  de todas los asociados
        
      select
         sum(dcv.importe_doc) as importe_doc,
         sum(dcv.importe_iva) as importe_iva,
         sum(dcv.importe_descuento) as importe_descuento,
         sum(dcv.importe_descuento_ley) as  importe_descuento_ley --#86 ++
      into
         v_registros_doc
      from conta.tdoc_compra_venta dcv
      where dcv.id_int_comprobante = p_id_int_comprobante;  
        
      -- #86  validar la fecha de los documentos facturas y recibos
       select 
           pxp.list(dcv.id_doc_compra_venta::varchar)  into v_lista_docs
       from  conta.tdoc_compra_venta dcv
       inner join param.tperiodo per on   dcv.fecha BETWEEN per.fecha_ini and per.fecha_fin
       inner join conta.tint_comprobante c on c.id_int_comprobante = dcv.id_int_comprobante
       where dcv.id_int_comprobante = p_id_int_comprobante
             and dcv.estado_reg = 'activo'
             and per.id_periodo != c.id_periodo;
      
      
        
    ---------------------------------------------         
    --#86  VALDIAR FECHAS DE LOS DOCUMENTOS
    ---------------------------------------------
    
   IF  p_validar  THEN
      IF v_lista_docs is not null THEN
                   v_resp_val_doc[1] = 'FALSE';
                   v_resp_val_doc[2] = format('Existen  documentos que no se correponden al perido del comprobante, revise los IDS:  %s', v_lista_docs::varchar);
                        
                   IF p_forzar_validacion = 'si' THEN
                     raise exception '%',v_resp_val_doc[2];
                   ELSE
                     return v_resp_val_doc;
                   END IF;
        END IF;
    END IF;       
    
    
   
           
     ------------------------------
     -- #86 VALDIAR EL IVa, CF     
     -------------------------------
     
     IF v_registros_iva_cf is not null   THEN
     
           IF v_conta_val_doc_compra = 'si' and p_validar  THEN
                
               IF not conta.f_comparar_numeric(COALESCE(v_registros_doc.importe_iva,0),  COALESCE(v_registros_iva_cf.debe,0) , v_error_round )  THEN  
                  
                  
                  --raise exception '-- % , %'   ,v_registros_doc.importe_iva,v_registros_iva_cf.debe ;            
               
                   v_resp_val_doc[1] = 'FALSE';
                   v_resp_val_doc[2] = 'FALTA REGISTRAR ALGUN DOCUMENTO!!! (Factura CON CREDITO FISCAL o algun excento esta mal registrado). IVA cbte: ('||COALESCE(v_registros_iva_cf.debe,0)::varchar||'),  IVA Documentos : ('|| COALESCE(v_registros_doc.importe_iva,0)::varchar||').';
                     
                     raise exception '%',v_resp_val_doc[2]::varchar;
                      
                   IF p_forzar_validacion = 'si' THEN
                     raise exception '%',v_resp_val_doc[2]::varchar;
                   ELSE
                     return v_resp_val_doc;
                   END IF;
                   
               END IF;
           END IF;
     END IF;      
           
     ----------------------------
     -- #86 VALDIAR EL IVA, DF     
     ----------------------------- 
     
       IF v_registros_iva_df is not null  THEN
     
           IF v_conta_val_doc_compra = 'si' and p_validar  THEN
                
               IF not conta.f_comparar_numeric(COALESCE(v_registros_doc.importe_iva,0) , COALESCE(v_registros_iva_df.haber,0) ,v_error_round )     THEN               
               
                   v_resp_val_doc[1] = 'FALSE';
                   v_resp_val_doc[2] = 'FALTA REGISTRAR ALGUN DOCUMENTO!!! (Factura CON DEBITO FISCAL o algun excento esta mal registrado). IVA DF cbte: ('|| COALESCE( v_registros_iva_df.haber,0)::varchar||'),  IVA Documentos: ('||COALESCE(v_registros_doc.importe_iva,0)::varchar ||').';
                        
                   IF p_forzar_validacion = 'si' THEN
                     raise exception '%',v_resp_val_doc[2];
                   ELSE
                     return v_resp_val_doc;
                   END IF;
                   
               END IF;
           END IF;
     END IF;
     
     ----------------------------------------
     -- #86 VALDIAR  DSECUENTOS DE LEY    
     --------------------------------------
    
       IF v_registros_desc_ley is not null  or v_registros_doc.importe_descuento_ley > 0 THEN
     
           IF v_conta_val_doc_compra = 'si' and p_validar  THEN
                
               IF  not conta.f_comparar_numeric(COALESCE(v_registros_doc.importe_descuento_ley,0), COALESCE(v_registros_desc_ley.haber,0) , v_error_round )   THEN               
               
                   v_resp_val_doc[1] = 'FALSE';
                   v_resp_val_doc[2] = 'FALTA REGISTRAR ALGUN DOCUMENTO!!! (Los descuentos de ley no cuadran). Decuentos CBTE: ('||  COALESCE(v_registros_desc_ley.haber,0)::varchar||'),  Descuentos DOCS ('||  COALESCE(v_registros_doc.importe_descuento_ley,0)::varchar ||').';
                        
                   IF p_forzar_validacion = 'si' THEN
                     raise exception '%',v_resp_val_doc[2];
                   ELSE
                     return v_resp_val_doc;
                   END IF;
                   
               END IF;
           END IF;
     END IF; 
     
     
     
     /* --#86      
   --revisar que si el comprobante esta en la lista blanca        
   
   
   --solo valida para los cbte de diario
   IF v_registros_recurso is not null  or v_registros_gasto is not null THEN
   
       
        
        
        --RAC 20/01/2018, si tenemos una IDEA se tiene que restar el monto  (El monto neto de la DUI es solo para afectar el libro de compras)
        select
           sum(dcv.importe_doc) as importe_doc,
           sum(dcv.importe_iva) as importe_iva,
           sum(dcv.importe_descuento) as importe_descuento
        into
           v_registros_doc_dui
        from conta.tdoc_compra_venta dcv
        inner join param.tplantilla plt on plt.id_plantilla = dcv.id_plantilla 
        where dcv.id_int_comprobante = p_id_int_comprobante  and  plt.desc_plantilla = 'Póliza de Importación - DUI'; 
        
         
        -- le recucimos el importe de la dui
        --raise exception '% --- %' , v_registros_doc.importe_doc, v_registros_doc_dui.importe_doc;
        
        
        v_total_doc = COALESCE(v_registros_doc.importe_doc,0) -  COALESCE(v_registros_doc.importe_descuento,0) - COALESCE(v_registros_doc.importe_iva,0);
        
        IF v_registros_doc_dui is not null THEN
          v_total_doc = v_total_doc  - COALESCE(v_registros_doc_dui.importe_doc, 0) +  COALESCE(v_registros_doc_dui.importe_iva, 0);        
        END IF;
         
        
        
        v_total_cbte_recurso = COALESCE(v_registros_recurso.haber,0) - COALESCE(v_registros_recurso.debe,0);
        v_total_cbte_gasto = COALESCE(v_registros_gasto.debe,0) - COALESCE(v_registros_gasto.haber,0);
        
        
        
       
        
        
        
       
        IF v_conta_val_doc_compra = 'si' and  v_total_cbte_gasto > v_total_cbte_recurso  and p_validar THEN               
             
             IF v_total_doc !=  v_total_cbte_gasto   THEN 
                   v_difenrecia = v_total_cbte_gasto - v_total_doc; 
                                     
                   if  v_difenrecia > v_conta_dif_doc_cbte or v_difenrecia < (v_conta_dif_doc_cbte*-1) THEN                 
                        v_resp_val_doc[1] = 'FALSE';
                        v_resp_val_doc[2] = format('FALTA REGISTRAR ALGUN DOCUMENTO!!! (Factura, Recibo, Invoice, etc.). El monto total de los documentos registrados es: %s (DOC: %s, IVA: %s, DESC: %s ) y no cuadra con los gastos del comprobante (%s), existe una diferencia de: (%s).', v_total_doc::varchar,  COALESCE(v_registros_doc.importe_doc,0)::varchar, COALESCE(v_registros_doc.importe_iva,0)::varchar, COALESCE(v_registros_doc.importe_descuento,0)::Varchar, v_total_cbte_gasto::varchar, (v_total_cbte_gasto - v_total_doc)::varchar);
                        
                      
                         IF p_forzar_validacion = 'si' THEN
                           raise exception '%',v_resp_val_doc[2];
                         ELSE
                           return v_resp_val_doc;
                         END IF;
                   end if;
              
              END IF;
        END IF;
        
         IF v_conta_val_doc_venta = 'si' and v_total_cbte_recurso >  v_total_cbte_gasto and p_validar   THEN          
             IF v_total_doc !=  v_total_cbte_recurso   THEN 
             
                  v_difenrecia = v_total_cbte_recurso - v_total_doc;                  
                  if  v_difenrecia > v_conta_dif_doc_cbte or v_difenrecia < (v_conta_dif_doc_cbte*-1) THEN 
                     v_resp_val_doc[1] = 'FALSE';
                    
                     v_resp_val_doc[2] = format('FALTA REGISTRAR ALGUN DOCUMENTO!!! (Factura, Recibo, Invoice, etc.). El monto total de los documentos registrados es: %s (DOC: %s, IVA: %s, DESC: %s ) y no cuadra con los recursos del comprobante (%s), existe una diferencia de (%s).', v_total_doc::varchar, COALESCE(v_registros_doc.importe_doc,0)::varchar, COALESCE(v_registros_doc.importe_iva,0)::varchar, COALESCE(v_registros_doc.importe_descuento,0)::Varchar, v_total_cbte_recurso::varchar,(v_total_cbte_recurso - v_total_doc)::varchar);
                     
                     
                     IF p_forzar_validacion = 'si' THEN
                       raise exception '%',v_resp_val_doc[2];
                     ELSE
                       return v_resp_val_doc;
                     END IF;
                     
                     
                  end if;
                  
              END IF;
        END IF;
        
        ----------------------------------
        -- CONSIDERACIONES
        --  1, cuando sea un comprbante de ajuste muy probablemente las partida de gasto al haber y debe cuadren , en casos de ajuste no habra documentos asociados
        --  2,  
        -------------------------------------
             
   
   
   END IF;*/
  
    
     --raise exception 'llega';
   
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