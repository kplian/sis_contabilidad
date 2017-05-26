--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_gen_transaccion (
  p_super public.hstore,
  p_tabla_padre public.hstore,
  p_plantilla_comprobante public.hstore,
  p_id_tabla_padre_valor integer,
  p_id_int_comprobante integer,
  p_id_usuario integer = NULL::integer,
  p_primario varchar = 'si'::character varying,
  p_id_detalle_plantilla_fk integer = NULL::integer
)
RETURNS varchar AS
$body$
/*
Autor:  Rensi Arteaga Copari
Fecha 27/08/2013
Descripcion:     Esta funciona inicia la generacion de las transacciones del 
				comprobantes segun la definicion de la planilla



*/


DECLARE
	v_this					conta.maestro_comprobante;
    v_tabla					record;
    v_nombre_funcion        text;
    v_plantilla_det				record;        
    v_resp 					varchar;
    v_consulta				varchar;
    v_posicion				integer;
    v_columnas				varchar;
    v_columna_requerida		varchar;
    r 						record;  --  esta variable no se usa
    v_valor					varchar;
    
    v_id_int_comprobante    integer;
    v_plantilla_det_sec     record;
    resp_det               varchar;
BEGIN
	
    v_nombre_funcion:='conta.f_gen_transaccion';
    
    --  FOR leer la plantillas de transaccion primarias
   
    
 	IF p_primario = 'si' THEN
     
            FOR v_plantilla_det in (Select * 
                                    from conta.tdetalle_plantilla_comprobante dpc 
                                    where  dpc.id_plantilla_comprobante =  
                                           (p_plantilla_comprobante->'id_plantilla_comprobante')::integer  and
                                           dpc.primaria = 'si') LOOP
            
                 --       generar trasaccion unitaria 
                  v_resp = conta.f_gen_transaccion_unitaria(
                                                          p_super, 
                                                          p_tabla_padre,
                                                          hstore(v_plantilla_det),
                                                          p_plantilla_comprobante,
                                                          p_id_tabla_padre_valor,
                                                          p_id_int_comprobante,
                                                          p_id_usuario
                                                          );
               
                 -- llamada recursiva 
                 
                   resp_det =  conta.f_gen_transaccion( p_super,
                                                        p_tabla_padre,
                                                        p_plantilla_comprobante,
                                                        p_id_tabla_padre_valor,
                                                        p_id_int_comprobante,
                                                        p_id_usuario,
                                                        'no',
                                                        v_plantilla_det.id_detalle_plantilla_comprobante
                                                       );
            
            
            
            
            
             
            
            END LOOP;
   ELSE
   
           -------------------------------------------------------
           --   IF procesar la transacciones secundarias si existen
           ------------------------------------------------------
           FOR v_plantilla_det_sec in (
                          Select * 
                            from conta.tdetalle_plantilla_comprobante dpc 
                            where  dpc.id_plantilla_comprobante =  
                                   (p_plantilla_comprobante->'id_plantilla_comprobante')::integer  and
                                   dpc.primaria = 'no'  and dpc.estado_reg='activo' 
                                   and dpc.id_detalle_plantilla_fk = p_id_detalle_plantilla_fk) LOOP
                                   
                   -- obtiene el record de la transaccion secundaria
                   -- llamada recursica  a esta misma funcion con la bandera  activada 
          
                            v_resp = conta.f_gen_transaccion_unitaria(
                                              p_super, --p_super
                                              p_tabla_padre,--p_tabla_padre
                                              hstore(v_plantilla_det_sec),--p_reg_det_plantilla
                                              p_plantilla_comprobante,--p_plantilla_comprobante
                                              p_id_tabla_padre_valor,--p_id_tabla_padre_valor
                                              p_id_int_comprobante,--p_id_int_comprobante
                                              p_id_usuario--p_id_usuario
                                              );
                                              
                                              
                                              
                        -- llamada recursiva 
                 
                       resp_det =  conta.f_gen_transaccion( p_super,
                                                            p_tabla_padre,
                                                            p_plantilla_comprobante,
                                                            p_id_tabla_padre_valor,
                                                            p_id_int_comprobante,
                                                            p_id_usuario,
                                                            'no',
                                                            v_plantilla_det_sec.id_detalle_plantilla_comprobante
                                                           );                       
                                           
           
           
           END LOOP;
   
   
   END IF;
       
    
    return v_resp;
    
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