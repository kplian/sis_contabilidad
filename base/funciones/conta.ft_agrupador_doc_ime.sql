--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_agrupador_doc_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_agrupador_doc_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tagrupador_doc'
 AUTOR: 		 (admin)
 FECHA:	        22-09-2015 16:48:19
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
ISSUE  						AUTHOR  				FECHA   					DESCRIPCION
#12							EGS						08/10/2018					se agrego validacion para variables globales de notas de credito y debito
#12							EGS						08/11/2018					se agrego la logica para mostrar que  las facturas estan anuladas antes que genere un comprobante

***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_agrupador_doc	integer;
    v_rec_agru				record;
    v_codigo_pla			varchar;
    v_registros				record;
    v_id_int_comprobante     integer;
    v_nro_tramite			varchar;
    
    v_item					record; 		--#12	EGS	08/11/2018
    v_lista_facturas_Anuladas varchar;		--#12	EGS	08/11/2018
    v_bandera				boolean;		--#12	EGS	08/11/2018
			    
BEGIN

    v_nombre_funcion = 'conta.ft_agrupador_doc_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_AGD_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		22-09-2015 16:48:19
	***********************************/

	if(p_transaccion='CONTA_AGD_INS')then
					
        begin
        	
            IF EXISTS(SELECT 1
                 from conta.tagrupador_doc ad 
                where    ad.id_agrupador = v_parametros.id_agrupador  
                    and ad.id_doc_compra_venta = v_parametros.id_doc_compra_venta)  THEN
            
              raise exception 'Este documento ya esta incluido';
              
            END IF;
            
            
            --Sentencia de la insercion
        	insert into conta.tagrupador_doc(
                id_doc_compra_venta,
                id_agrupador,
                estado_reg,
                id_usuario_ai,
                id_usuario_reg,
                usuario_ai,
                fecha_reg,
                fecha_mod,
                id_usuario_mod
          	) values(
                v_parametros.id_doc_compra_venta,
                v_parametros.id_agrupador,
                'activo',
                v_parametros._id_usuario_ai,
                p_id_usuario,
                v_parametros._nombre_usuario_ai,
                now(),
                null,
                null
			)RETURNING id_agrupador_doc into v_id_agrupador_doc;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Doc almacenado(a) con exito (id_agrupador_doc'||v_id_agrupador_doc||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_agrupador_doc',v_id_agrupador_doc::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	

	/*********************************    
 	#TRANSACCION:  'CONTA_AGD_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		22-09-2015 16:48:19
	***********************************/

	elsif(p_transaccion='CONTA_AGD_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tagrupador_doc
            where id_agrupador_doc=v_parametros.id_agrupador_doc;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Doc eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_agrupador_doc',v_parametros.id_agrupador_doc::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
     
     /*********************************    
 	#TRANSACCION:  'CONTA_GENCBTE_IME'
 	#DESCRIPCION:	Genera el comprobante para la grupacion seleccionada
 	#AUTOR:		admin	
 	#FECHA:		22-09-2015 16:48:19
	***********************************/

	elsif(p_transaccion='CONTA_GENCBTE_IME')then

		begin
			
            -- recupera datos del agrupador
            
            ----#12 	EGS		08/10/2018	
            select
              ag.tipo,
              agd.id_doc_compra_venta,
              pla.tipo_plantilla,
              pla.tipo_informe
            
            into
             v_rec_agru
            from conta.tagrupador ag
            left join conta.tagrupador_doc agd on agd.id_agrupador = ag.id_agrupador
            left join conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta=agd.id_doc_compra_venta
            left join param.tplantilla pla on pla.id_plantilla = dcv.id_plantilla
            where  ag.id_agrupador = v_parametros.id_agrupador;
           --#12 	EGS	08/11/2018 
           v_lista_facturas_Anuladas='';
           v_bandera = FALSE;
        	FOR v_item IN ( 
           		 SELECT	
            		agdd.id_doc_compra_venta,
            		dcv.nro_documento,
                    tdcv.nombre  
            	 FROM	conta.tagrupador_doc agdd
            		left join  conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta = agdd.id_doc_compra_venta
                    left join  conta.ttipo_doc_compra_venta tdcv on tdcv.id_tipo_doc_compra_venta = dcv.id_tipo_doc_compra_venta
          		 WHERE agdd.id_agrupador = v_parametros.id_agrupador)LOOP
                
                IF v_item.nombre='ANULADA' THEN
                v_bandera = TRUE;
               	v_lista_facturas_Anuladas = v_item.nro_documento||','||v_lista_facturas_Anuladas;
                 
                END IF;

            END  LOOP;
            
            IF v_bandera = TRUE THEN    
           		RAISE EXCEPTION	'En la Generacion de Comprobante Fallo la Facturas Con nro Doc % quitelas de la lista Por Favor estan en Estado Anulado',v_lista_facturas_Anuladas;
			END IF;
             --#12	EGS	08/11/2018   
            
            --recuepra codgio de la plantilla de comprobante
            IF  v_rec_agru.tipo = 'compra' and v_rec_agru.tipo_informe <> 'ncd' THEN
                v_codigo_pla =  pxp.f_get_variable_global('conta_cod_plan_compra');
            ELSIF v_rec_agru.tipo = 'venta' and v_rec_agru.tipo_informe <> 'ncd' THEN
            	v_codigo_pla =  pxp.f_get_variable_global('conta_cod_plan_venta');
            ELSIF v_rec_agru.tipo = 'compra' and v_rec_agru.tipo_informe = 'ncd' THEN  --#12	EGS	08/10/2018
            	v_codigo_pla =  pxp.f_get_variable_global('conta_cod_plan_nota_credito');--#12	EGS	08/10/2018	
            ELSIF v_rec_agru.tipo = 'venta' and v_rec_agru.tipo_informe = 'ncd' THEN     --#12	 EGS	08/10/2018	
            	v_codigo_pla =  pxp.f_get_variable_global('conta_cod_plan_nota_debito');--#12	EGS	08/10/2018	
                         
            END IF;
            
            
             ----#12 	EGS		08/10/2018	
             
            --raise exception 'hola %',v_rec_agru;
            
             -- Si NO  se contabiliza nacionalmente
            v_id_int_comprobante =   conta.f_gen_comprobante (
                                                   v_parametros.id_agrupador,
                                                   v_codigo_pla,
                                                   NULL,
                                                   p_id_usuario,
                                                   NULL,
                                                   NULL, 
                                                   NULL); --conexion
           
        
            --actualiza el comprobante en los documentos
            
           FOR v_registros in ( SELECT  
                                   agd.id_doc_compra_venta
                                FROM conta.tagrupador_doc agd where agd.id_agrupador =   v_parametros.id_agrupador) LOOP
                                
                select
                  c.nro_tramite
                into
                  v_nro_tramite
                from conta.tint_comprobante c
                where c.id_int_comprobante = v_id_int_comprobante;                
            
                UPDATE  conta.tdoc_compra_venta  SET 
                  id_int_comprobante = v_id_int_comprobante,
                  nro_tramite = v_nro_tramite
                WHERE  id_doc_compra_venta = v_registros.id_doc_compra_venta; 
           END LOOP;
           
           
          
           
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','El comprobante se genero con exito)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_agrupador',v_parametros.id_agrupador::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
    
        
	else
     
    	raise exception 'Transaccion inexistente: %',p_transaccion;

	end if;

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
