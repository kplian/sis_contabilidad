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
        	--SUBSISTEMA: Obtiene el id_subsistema del Sistema de Contabilidad si es que no llega como parámetro
        	if coalesce(v_parametros.id_subsistema,0)!=0 then
        		v_id_subsistema = v_parametros.id_subsistema;
        	else
        		select id_subsistema
	        	into v_id_subsistema
	        	from segu.tsubsistema
	        	where codigo = 'CONTA';
        	end if;
        	
        	--PERIODO
        	--Obtiene el periodo a partir de la fecha
        	v_rec = param.f_get_periodo_gestion(v_parametros.fecha,v_id_subsistema);
        	
        	--Verifica si el Periodo esta abierto
        	v_resp = param.f_verifica_periodo_subsistema_abierto(v_rec.po_id_periodo_subsistema);
        	
        	
        	
        	-----------------------------
        	--REGISTRO DEL COMPROBANTE
        	-----------------------------
        	insert into conta.tint_comprobante(
			id_clase_comprobante,
			id_int_comprobante_fk,
			id_subsistema,
			id_depto,
			id_moneda,
			id_periodo,
			id_funcionario_firma1,
			id_funcionario_firma2,
			id_funcionario_firma3,
			tipo_cambio,
			beneficiario,
			nro_cbte,
			estado_reg,
			glosa1,
			fecha,
			glosa2,
			nro_tramite,
			--momento,
			id_usuario_reg,
			fecha_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.id_clase_comprobante,
			v_parametros.id_int_comprobante_fk,
			v_id_subsistema,
			v_parametros.id_depto,
			v_parametros.id_moneda,
			v_parametros.id_periodo,
			v_parametros.id_funcionario_firma1,
			v_parametros.id_funcionario_firma2,
			v_parametros.id_funcionario_firma3,
			v_parametros.tipo_cambio,
			v_parametros.beneficiario,
			v_parametros.nro_cbte,
			'borrador',
			v_parametros.glosa1,
			v_parametros.fecha,
			v_parametros.glosa2,
			v_parametros.nro_tramite,
			--v_parametros.momento,
			p_id_usuario,
			now(),
			null,
			null
							
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
        	--SUBSISTEMA: Obtiene el id_subsistema del Sistema de Contabilidad si es que no llega como parámetro
        	if coalesce(v_parametros.id_subsistema,0)!=0 then
        		v_id_subsistema = v_parametros.id_subsistema;
        	else
        		select id_subsistema
	        	into v_id_subsistema
	        	from segu.tsubsistema
	        	where codigo = 'CONTA';
        	end if;
        	
        	--PERIODO
        	--Obtiene el periodo a partir de la fecha
        	v_rec = param.f_get_periodo_gestion(v_parametros.fecha,v_id_subsistema);
        	
        	--Verifica si el Periodo esta abierto
        	v_resp = param.f_verifica_periodo_subsistema_abierto(v_rec.po_id_periodo_subsistema);
        	
			------------------------------
			--Sentencia de la modificacion
			------------------------------
			update conta.tint_comprobante set
			id_clase_comprobante = v_parametros.id_clase_comprobante,
			id_int_comprobante_fk = v_parametros.id_int_comprobante_fk,
			id_subsistema = v_parametros.id_subsistema,
			id_depto = v_parametros.id_depto,
			id_moneda = v_parametros.id_moneda,
			id_periodo = v_parametros.id_periodo,
			id_funcionario_firma1 = v_parametros.id_funcionario_firma1,
			id_funcionario_firma2 = v_parametros.id_funcionario_firma2,
			id_funcionario_firma3 = v_parametros.id_funcionario_firma3,
			tipo_cambio = v_parametros.tipo_cambio,
			beneficiario = v_parametros.beneficiario,
			nro_cbte = v_parametros.nro_cbte,
			glosa1 = v_parametros.glosa1,
			fecha = v_parametros.fecha,
			glosa2 = v_parametros.glosa2,
			nro_tramite = v_parametros.nro_tramite,
			--momento = v_parametros.momento,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now()
			where id_int_comprobante=v_parametros.id_int_comprobante;
               
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
			
            
            
            
            select * 
            into v_rec_cbte
            from conta.tint_comprobante
            where id_int_comprobante = v_parametros.id_int_comprobante;
        
			--Sentencia de la eliminacion
			delete from conta.tint_comprobante
            where id_int_comprobante=v_parametros.id_int_comprobante;
            
            
            -- si viene de una plantilla de comprobante busca la funcion de validacion configurada
       
             IF v_rec_cbte.id_plantilla_comprobante is not null THEN
             
                select 
                 pc.funcion_comprobante_eliminado
                into v_funcion_comprobante_eliminado
                from conta.tplantilla_comprobante pc  
                where pc.id_plantilla_comprobante = v_rec_cbte.id_plantilla_comprobante;
                
                
                EXECUTE ( 'select ' || v_funcion_comprobante_eliminado  ||'('||p_id_usuario::varchar||','|| v_parametros.id_int_comprobante::varchar||')');
                                   
                
             
             
             END IF;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Comprobante eliminado(a)'); 
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
			--Lamada a la función de validación
			v_result = conta.f_validar_cbte(p_id_usuario,v_parametros.id_int_comprobante,v_parametros.igualar);
               
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