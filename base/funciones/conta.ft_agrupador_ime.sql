--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_agrupador_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_agrupador_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tagrupador'
 AUTOR: 		 (rensi KPLIAN)
 FECHA:	        22-09-2015 16:47:53
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
	v_id_agrupador	integer;
    v_registros         	record;
    v_rec        			record;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_agrupador_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	
         
	/*********************************    
 	#TRANSACCION:  'CONTA_GENAGRU_IME'
 	#DESCRIPCION:	Crea el grupo de documentos con su detalle precio a la generacion del comprobante
 	#AUTOR:		admin	
 	#FECHA:		22-09-2015 16:47:53
	***********************************/

	if(p_transaccion='CONTA_GENAGRU_IME')then
					
        begin
        
        
             --Obtiene el periodo a partir de la fecha
        	v_rec = param.f_get_periodo_gestion(v_parametros.fecha_cbte);
        
        
        
        	-- creamos el grupo
        	insert into conta.tagrupador(
                estado_reg,
                fecha_ini,
                fecha_fin,
                tipo,
                id_depto_conta,
                id_moneda,
                id_usuario_reg,
                fecha_reg,
                id_usuario_ai,
                usuario_ai,
                id_usuario_mod,
                fecha_mod,
                incluir_rev,
                fecha_cbte,
                id_gestion
          	) values(
                'activo',
                v_parametros.fecha_ini,
                v_parametros.fecha_fin,
                v_parametros.tipo,
                v_parametros.id_depto_conta,
                v_parametros.id_moneda,
                p_id_usuario,
                now(),
                v_parametros._id_usuario_ai,
                v_parametros._nombre_usuario_ai,
                null,
			    null,
                v_parametros.incluir_rev,
                v_parametros.fecha_cbte,
                v_rec.po_id_gestion
							
			)RETURNING id_agrupador into v_id_agrupador;
			
            
            --insertamos los documentos  que satisfacen los requisitos del grupo
            
            FOR v_registros in (
                   select
                      id_doc_compra_venta
                   from conta.tdoc_compra_venta dcv 
                   where     dcv.id_depto_conta = v_parametros.id_depto_conta
                        and  dcv.tipo = v_parametros.tipo
                        and  (dcv.fecha BETWEEN v_parametros.fecha_ini and v_parametros.fecha_fin)
                        and dcv.id_moneda = v_parametros.id_moneda
                        and dcv.manual = 'si'   --solo documentos registrdos manaulmente
                        and dcv.id_int_comprobante is NULL  --solo documentos que no esten en ningun comprobante
                        and dcv.tabla_origen is null  --solo los documentos registrados en libro de compras o ventas
                        and  (
                                 (v_parametros.incluir_rev = 'si' and dcv.revisado = 'si') 
                              or 
                                 (v_parametros.incluir_rev = 'no' and dcv.revisado in('si','no'))
                              )
                        ) LOOP
            
                   --insertamos documento al grupo
                   INSERT INTO 
                          conta.tagrupador_doc
                        (
                          id_usuario_reg,
                          fecha_reg,
                          estado_reg,
                          id_agrupador,
                          id_doc_compra_venta
                        )
                        VALUES (
                          p_id_usuario,
                          now(),
                          'activo',
                          v_id_agrupador,
                          v_registros.id_doc_compra_venta
                        );
                   
            
            END LOOP;
            
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Agrupador creado con exito ('||v_id_agrupador||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_agrupador',v_id_agrupador::varchar);

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