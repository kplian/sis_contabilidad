--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_int_comprobante_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_int_comprobante_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tint_comprobante'
 AUTOR: 		 (admin)
 FECHA:	        29-08-2013 00:28:30
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
	v_id_int_comprobante	integer;
	v_id_subsistema			integer;
	v_rec					record;
	v_result				varchar;
    v_rec_cbte record;
    v_funcion_comprobante_eliminado varchar;
    v_id_subsistema_conta			integer;
    v_resp2							varchar;
    v_reg_cbte						record;
    v_momento_comprometido			varchar;
    v_momento_ejecutado 			varchar;
    v_momento_pagado 				varchar;
    v_tipo_comprobante				varchar;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_int_comprobante_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_INCBTE_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		29-08-2013 00:28:30
	***********************************/

	if(p_transaccion='CONTA_INCBTE_INS')then
					
        begin
        
        	------------------
        	-- VALIDACIONES
        	------------------
        	select 
              id_subsistema
              into 
             v_id_subsistema_conta
            from segu.tsubsistema
            where codigo = 'CONTA';
            
            --SUBSISTEMA: Obtiene el id_subsistema del Sistema de Contabilidad si es que no llega como parámetro
        	IF  pxp.f_existe_parametro(p_tabla,'id_subsistema') THEN
        		
                 IF v_parametros.id_subsistema is not NULL THEN
               	     v_id_subsistema = v_parametros.id_subsistema;
        	     else
                    v_id_subsistema = v_id_subsistema_conta;
                 end if;
        	ELSE
                v_id_subsistema = v_id_subsistema_conta;
            end if;
            
            
            v_momento_comprometido = 'si';
            v_momento_ejecutado = 'no';
            v_momento_pagado = 'no';
            
            --momentos presupeustarios
            IF v_parametros.momento_ejecutado = 'true' THEN
             v_momento_ejecutado = 'si';
            END IF;
            
            IF v_parametros.momento_pagado = 'true' THEN
             v_momento_pagado = 'si';
            END IF;
           
            
            --segun la calse del comprobante definir si es presupeustario o contable
            
            select 
              cc.tipo_comprobante
            into 
              v_tipo_comprobante
            from conta.tclase_comprobante cc 
            where cc.id_clase_comprobante = v_parametros.id_clase_comprobante;
            
        	
        	--PERIODO
        	--Obtiene el periodo a partir de la fecha
        	v_rec = param.f_get_periodo_gestion(v_parametros.fecha);
        	
        	
        	-----------------------------
        	--REGISTRO DEL COMPROBANTE
        	-----------------------------
        	insert into conta.tint_comprobante(
                id_clase_comprobante,
    		
                id_subsistema,
                id_depto,
                id_moneda,
                id_periodo,
                id_funcionario_firma1,
                id_funcionario_firma2,
                id_funcionario_firma3,
                tipo_cambio,
                beneficiario,
    			
                estado_reg,
                glosa1,
                fecha,
                glosa2,
    			
                --momento,
                id_usuario_reg,
                fecha_reg,
                id_usuario_mod,
                fecha_mod,
                id_usuario_ai,
                usuario_ai,
                id_int_comprobante_fks,
                cbte_cierre,
                cbte_apertura,
                cbte_aitb,
                manual,
                momento_comprometido,
                momento_ejecutado,
                momento_pagado,
                momento
          	) values(
              v_parametros.id_clase_comprobante,
  			
              v_id_subsistema,
              v_parametros.id_depto,
              v_parametros.id_moneda,
              v_rec.po_id_periodo,
              v_parametros.id_funcionario_firma1,
              v_parametros.id_funcionario_firma2,
              v_parametros.id_funcionario_firma3,
              v_parametros.tipo_cambio,
              v_parametros.beneficiario,
  			
              'borrador',
              v_parametros.glosa1,
              v_parametros.fecha,
              v_parametros.glosa2,
  			
              --v_parametros.momento,
              p_id_usuario,
              now(),
              null,
              null,
              v_parametros._id_usuario_ai,
              v_parametros._nombre_usuario_ai,
              (string_to_array(v_parametros.id_int_comprobante_fks,','))::INTEGER[],
              v_parametros.cbte_cierre,
              v_parametros.cbte_apertura,
              v_parametros.cbte_aitb,
              'si',
              v_momento_comprometido,
              v_momento_ejecutado,
              v_momento_pagado,
              v_tipo_comprobante
							
			)RETURNING id_int_comprobante into v_id_int_comprobante;
			
            
            
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Comprobante almacenado(a) con exito (id_int_comprobante'||v_id_int_comprobante||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_int_comprobante',v_id_int_comprobante::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_INCBTE_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		29-08-2013 00:28:30
	***********************************/

	elsif(p_transaccion='CONTA_INCBTE_MOD')then

		begin
		
			------------------
        	-- VALIDACIONES
        	------------------
        	select 
              id_subsistema
              into 
             v_id_subsistema_conta
            from segu.tsubsistema
            where codigo = 'CONTA';
            
            
            select 
              * 
            into 
             v_reg_cbte
            from conta.tint_comprobante ic where ic.id_int_comprobante = v_parametros.id_int_comprobante;
            
            IF v_reg_cbte.estado_reg != 'borrador' THEN
               raise exception 'solo puede editar comprobantes en borrador';
            END IF;
            
            --SUBSISTEMA: Obtiene el id_subsistema del Sistema de Contabilidad si es que no llega como parámetro
        	IF  pxp.f_existe_parametro(p_tabla,'id_subsistema') THEN
        		
                 IF v_parametros.id_subsistema is not NULL THEN
               	     v_id_subsistema = v_parametros.id_subsistema;
        	     else
                    v_id_subsistema = v_id_subsistema_conta;
                 end if;
        	ELSE
                v_id_subsistema = v_id_subsistema_conta;
            end if;
        	
        	--PERIODO
        	--Obtiene el periodo a partir de la fecha
        	v_rec = param.f_get_periodo_gestion(v_parametros.fecha);
            
            --segun la calse del comprobante definir si es presupeustario o contable
            select 
              cc.tipo_comprobante
            into 
              v_tipo_comprobante
            from conta.tclase_comprobante cc 
            where cc.id_clase_comprobante = v_parametros.id_clase_comprobante;
            
            --revisa momentos presupeustario
            v_momento_comprometido = v_reg_cbte.momento_comprometido;
            v_momento_ejecutado = v_reg_cbte.momento_ejecutado;
            v_momento_pagado =  v_reg_cbte.momento_pagado;
            
            IF  v_reg_cbte.manual = 'si' THEN
              --momentos presupeustarios
              IF v_parametros.momento_ejecutado = 'true' THEN
                v_momento_ejecutado = 'si';
              ELSE
                v_momento_ejecutado = 'no';
              END IF;
              
              IF v_parametros.momento_pagado = 'true' THEN
                v_momento_pagado = 'si';
              ELSE
                v_momento_pagado = 'no';
              END IF;
            ELSE
            
               IF v_momento_ejecutado != v_reg_cbte.momento_ejecutado  or  v_momento_pagado != v_reg_cbte.momento_pagado THEN
                 raise exception 'No peude cambiar los momentos en cbte automaticos';
               END IF;
               
                IF v_parametros.id_clase_comprobante != v_reg_cbte.id_clase_comprobante   THEN
                 raise exception 'No peude cambiar el tipo de cbte automaticos';
               END IF;
                
            END IF;
            
            
            
			------------------------------
			--Sentencia de la modificacion
			------------------------------
			update conta.tint_comprobante set
                id_clase_comprobante = v_parametros.id_clase_comprobante,
                momento = v_tipo_comprobante,
                id_int_comprobante_fks =  (string_to_array(v_parametros.id_int_comprobante_fks,','))::INTEGER[],
                id_subsistema = v_id_subsistema,
                id_depto = v_parametros.id_depto,
                id_moneda = v_parametros.id_moneda,
                id_periodo = v_rec.po_id_periodo,
                id_funcionario_firma1 = v_parametros.id_funcionario_firma1,
                id_funcionario_firma2 = v_parametros.id_funcionario_firma2,
                id_funcionario_firma3 = v_parametros.id_funcionario_firma3,
                tipo_cambio = v_parametros.tipo_cambio,
                beneficiario = v_parametros.beneficiario,
    			
                glosa1 = v_parametros.glosa1,
                fecha = v_parametros.fecha,
                glosa2 = v_parametros.glosa2,
    			
                -- momento = v_parametros.momento,
                id_usuario_mod = p_id_usuario,
                fecha_mod = now(),
                id_usuario_ai = v_parametros._id_usuario_ai,
                usuario_ai = v_parametros._nombre_usuario_ai,
                cbte_cierre = v_parametros.cbte_cierre,
                cbte_apertura = v_parametros.cbte_apertura,
                momento_comprometido = 'si', 
                momento_ejecutado = v_momento_ejecutado,
                momento_pagado =  v_momento_pagado
			where id_int_comprobante = v_parametros.id_int_comprobante;
            
            -- si el tipo de cambio varia es encesario recalcular las equivalenscias en todas las transacciones 
            IF v_parametros.tipo_cambio is not NULL and (v_reg_cbte.tipo_cambio is null or v_parametros.tipo_cambio != v_reg_cbte.tipo_cambio) THEN
              IF  not conta.f_int_trans_recalcular_tc(v_parametros.id_int_comprobante) THEN
                raise exception 'Error al reprocesar el tipo de cambio';
              END IF;
            END IF;
            
            -- procesar las trasaaciones (con diversos propostios, ejm validar  cuentas bancarias)
            
            
            IF not conta.f_int_trans_procesar(v_parametros.id_int_comprobante) THEN
              raise exception 'Error al procesar transacciones';
            END IF;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Comprobante modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_int_comprobante',v_parametros.id_int_comprobante::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_INCBTE_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		29-08-2013 00:28:30
	***********************************/

	elsif(p_transaccion='CONTA_INCBTE_ELI')then

		begin
			
            v_result = conta.f_eliminar_int_comprobante(p_id_usuario,
                                                        v_parametros._id_usuario_ai,
                                                        v_parametros._nombre_usuario_ai,
                                                        v_parametros.id_int_comprobante,
                                                        'si');  --si indica borrado manualmente
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje',v_result); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_int_comprobante',v_parametros.id_int_comprobante::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
		
	/*********************************    
 	#TRANSACCION:  'CONTA_INCBTE_VAL'
 	#DESCRIPCION:	Validación del comprobante
 	#AUTOR:			rcm	
 	#FECHA:			05/09/2013
	***********************************/

	elsif(p_transaccion='CONTA_INCBTE_VAL')then

		begin
            
            --validaciones 
            select * into v_reg_cbte
            from conta.tint_comprobante ic where ic.id_int_comprobante = v_parametros.id_int_comprobante;
            
            IF v_reg_cbte.estado_reg != 'borrador' THEN
               raise exception 'solo puede validar  comprobantes en borrador';
            END IF;
        
        
			--Lamada a la función de validación
			v_result = conta.f_validar_cbte(
                 p_id_usuario,
                 v_parametros._id_usuario_ai,
                 v_parametros._nombre_usuario_ai,
                 v_parametros.id_int_comprobante,
                 v_parametros.igualar);
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje',v_result); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_int_comprobante',v_parametros.id_int_comprobante::varchar);
              
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