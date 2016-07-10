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

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
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
            select
              ag.tipo
            into
             v_rec_agru
            from conta.tagrupador ag
            where  ag.id_agrupador = v_parametros.id_agrupador;
            
            
            --recuepra codgio de la plantillade comprobante
            IF  v_rec_agru.tipo = 'compra' THEN
                v_codigo_pla =  pxp.f_get_variable_global('conta_cod_plan_compra');
            ELSE
                v_codigo_pla =  pxp.f_get_variable_global('conta_cod_plan_venta');
            END IF;
            
            
             --  Si NO  se contabiliza nacionalmente
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
            
                UPDATE  conta.tdoc_compra_venta  SET 
                  id_int_comprobante = v_id_int_comprobante
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