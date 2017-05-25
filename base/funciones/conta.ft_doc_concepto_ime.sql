--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_doc_concepto_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_doc_concepto_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tdoc_concepto'
 AUTOR: 		 (admin)
 FECHA:	        15-09-2015 13:09:45
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
	v_id_doc_concepto		integer;
    v_registros_doc			record;
    v_registros_cig			record;
    v_codigo_rel            varchar;
    v_id_cuenta  			integer;
    v_id_partida	integer;
    v_id_auxiliar	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_doc_concepto_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_DOCC_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		15-09-2015 13:09:45
	***********************************/

	if(p_transaccion='CONTA_DOCC_INS')then
					
        begin
        
            select
            cig.desc_ingas
            into
            v_registros_cig
            from param.tconcepto_ingas cig
            where cig.id_concepto_ingas =  v_parametros.id_concepto_ingas;
            
            
            
            
            --obtiene datos del documento
            
             SELECT 
              dcv.tipo,
              dcv.id_periodo,
              per.id_gestion
             into
              v_registros_doc
             FROM conta.tdoc_compra_venta dcv 
             inner join param.tperiodo per on per.id_periodo = dcv.id_periodo
             where dcv.id_doc_compra_venta = v_parametros.id_doc_compra_venta;
             
         
             --obtener partida, cuenta auxiliar del concepto de gasto
            IF v_registros_doc.tipo = 'compra' THEN
               v_codigo_rel = 'CUECOMP';  --codigo de relacion contable para compras
            ELSE
               v_codigo_rel = 'CUEVENT';  --codigo de relacion contable para ventas
            END IF;
            
            --Validar si tiene relacion contable        
            SELECT 
              ps_id_partida ,
              ps_id_cuenta,
              ps_id_auxiliar
            into 
              v_id_partida,
              v_id_cuenta, 
              v_id_auxiliar
            FROM conta.f_get_config_relacion_contable(v_codigo_rel, 
                                                     v_registros_doc.id_gestion, 
                                                     v_parametros.id_concepto_ingas, 
                                                     v_parametros.id_centro_costo,  
                                                     'No se encontro relación contable para el conceto de gasto: '||v_registros_cig.desc_ingas||'. <br> Mensaje: ');
          
        
           IF  v_id_cuenta is NULL THEN
               raise exception 'no se encontro relacion contable ...';
           END IF;
           
          
        
        	--Sentencia de la insercion
        	insert into conta.tdoc_concepto(
			estado_reg,
			id_orden_trabajo,
			id_centro_costo,
			id_concepto_ingas,
			descripcion,
			cantidad_sol,
			precio_unitario,
			precio_total,
			id_usuario_reg,
			fecha_reg,
			id_usuario_mod,
			fecha_mod,
            id_doc_compra_venta,
            precio_total_final,
            id_partida
          	) values(
			'activo',
			v_parametros.id_orden_trabajo,
			v_parametros.id_centro_costo,
			v_parametros.id_concepto_ingas,
			v_parametros.descripcion,
			v_parametros.cantidad_sol,
			v_parametros.precio_unitario,
			v_parametros.precio_total,
			p_id_usuario,
			now(),			
			null,
			null,            
            v_parametros.id_doc_compra_venta,
            v_parametros.precio_total_final,
            v_id_partida
			)RETURNING id_doc_concepto into v_id_doc_concepto;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','CONCEPTO almacenado(a) con exito (id_doc_concepto'||v_id_doc_concepto||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_doc_concepto',v_id_doc_concepto::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_DOCC_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		15-09-2015 13:09:45
	***********************************/

	elsif(p_transaccion='CONTA_DOCC_MOD')then

		begin
        
              select
              cig.desc_ingas
              into
              v_registros_cig
              from param.tconcepto_ingas cig
              where cig.id_concepto_ingas =  v_parametros.id_concepto_ingas;
              
            --obtiene datos del documento
            
             SELECT 
              dcv.tipo,
              dcv.id_periodo,
              per.id_gestion
             into
              v_registros_doc
             FROM conta.tdoc_compra_venta dcv 
             inner join param.tperiodo per on per.id_periodo = dcv.id_periodo
             where dcv.id_doc_compra_venta = v_parametros.id_doc_compra_venta;
             
         
             --obtener partida, cuenta auxiliar del concepto de gasto
            IF v_registros_doc.tipo = 'compra' THEN
               v_codigo_rel = 'CUECOMP';  --codigo de relacion contable para compras
            ELSE
               v_codigo_rel = 'CUEVENT';  --codigo de relacion contable para ventas
            END IF;
            
            --Validar si tiene relacion contable        
            SELECT 
              ps_id_partida ,
              ps_id_cuenta,
              ps_id_auxiliar
            into 
              v_id_partida,
              v_id_cuenta, 
              v_id_auxiliar
            FROM conta.f_get_config_relacion_contable(v_codigo_rel, 
                                                     v_registros_doc.id_gestion, 
                                                     v_parametros.id_concepto_ingas, 
                                                     v_parametros.id_centro_costo,  
                                                     'No se encontro relación contable para el conceto de gasto: '||v_registros_cig.desc_ingas||'. <br> Mensaje: ');
          
        
        
        
			--Sentencia de la modificacion
			update conta.tdoc_concepto set
                id_orden_trabajo = v_parametros.id_orden_trabajo,
                id_centro_costo = v_parametros.id_centro_costo,
                id_concepto_ingas = v_parametros.id_concepto_ingas,
                descripcion = v_parametros.descripcion,
                cantidad_sol = v_parametros.cantidad_sol,
                precio_unitario = v_parametros.precio_unitario,
                precio_total = v_parametros.precio_total,
                id_usuario_mod = p_id_usuario,
                fecha_mod = now(),
                precio_total_final = v_parametros.precio_total_final,
                id_partida = v_id_partida
			where id_doc_concepto=v_parametros.id_doc_concepto;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','CONCEPTO modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_doc_concepto',v_parametros.id_doc_concepto::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_DOCC_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		15-09-2015 13:09:45
	***********************************/

	elsif(p_transaccion='CONTA_DOCC_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tdoc_concepto
            where id_doc_concepto=v_parametros.id_doc_concepto;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','CONCEPTO eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_doc_concepto',v_parametros.id_doc_concepto::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
        
   /*********************************    
 	#TRANSACCION:  'CONTA_VERCONCEP_IME'
 	#DESCRIPCION:	recupera relacion contable para el concepto indicado
 	#AUTOR:		admin	
 	#FECHA:		15-09-2015 13:09:45
	***********************************/

	elsif(p_transaccion='CONTA_VERCONCEP_IME')then

		begin
            
            --obtener partida, cuenta auxiliar del concepto de gasto
            IF v_parametros.relacion = 'compra' THEN
               v_codigo_rel = 'CUECOMP';  --codigo de relacion contable para compras
            ELSE
               v_codigo_rel = 'CUEVENT';  --codigo de relacion contable para ventas
            END IF;
            
            SELECT 
              ps_id_partida ,
              ps_id_cuenta,
              ps_id_auxiliar
            into 
              v_id_partida,
              v_id_cuenta, 
              v_id_auxiliar
           FROM conta.f_get_config_relacion_contable(v_codigo_rel, 
                                                     v_parametros.id_gestion, 
                                                     v_parametros.id_concepto_ingas, 
                                                     v_parametros.id_centro_costo,  
                                                     'No se encontro relación contable este concepto <br> Mensaje: ');
          
			
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','CONCEPTO verificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_concepto_ingas',v_parametros.id_concepto_ingas::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'id_partida',v_id_partida::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta',v_id_cuenta::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'id_auxiliar',v_id_auxiliar::varchar);
              
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