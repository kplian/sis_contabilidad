--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_resultado_plantilla_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_resultado_plantilla_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tresultado_plantilla'
 AUTOR: 		 (admin)
 FECHA:	        08-07-2015 13:12:43
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
	v_id_resultado_plantilla	integer;
    v_registros					record;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_resultado_plantilla_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_RESPLAN_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		08-07-2015 13:12:43
	***********************************/

	if(p_transaccion='CONTA_RESPLAN_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.tresultado_plantilla(
              codigo,
              estado_reg,
              nombre,
              id_usuario_reg,
              usuario_ai,
              fecha_reg,
              id_usuario_ai,
              fecha_mod,
              id_usuario_mod,
              tipo,
              cbte_aitb,
              cbte_apertura,
              cbte_cierre,
              periodo_calculo,
              id_clase_comprobante,
              glosa,
              id_tipo_relacion_comprobante,
              relacion_unica,
              nombre_func
          	) values(
              v_parametros.codigo,
              'activo',
              v_parametros.nombre,
              p_id_usuario,
              v_parametros._nombre_usuario_ai,
              now(),
              v_parametros._id_usuario_ai,
              null,
              null,
              v_parametros.tipo,
              v_parametros.cbte_aitb,
              v_parametros.cbte_apertura,
              v_parametros.cbte_cierre,
              v_parametros.periodo_calculo,
              v_parametros.id_clase_comprobante,
              v_parametros.glosa,
              v_parametros.id_tipo_relacion_comprobante,
              v_parametros.relacion_unica,
              v_parametros.nombre_func
							
			
			
			)RETURNING id_resultado_plantilla into v_id_resultado_plantilla;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Plantilla de Resultados almacenado(a) con exito (id_resultado_plantilla'||v_id_resultado_plantilla||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_resultado_plantilla',v_id_resultado_plantilla::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_RESPLAN_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		08-07-2015 13:12:43
	***********************************/

	elsif(p_transaccion='CONTA_RESPLAN_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.tresultado_plantilla set
              codigo = v_parametros.codigo,
              nombre = v_parametros.nombre,
              fecha_mod = now(),
              id_usuario_mod = p_id_usuario,
              id_usuario_ai = v_parametros._id_usuario_ai,
              usuario_ai = v_parametros._nombre_usuario_ai,
              tipo = v_parametros.tipo,
              cbte_aitb = v_parametros.cbte_aitb,
              cbte_apertura = v_parametros.cbte_apertura,
              cbte_cierre = v_parametros.cbte_cierre,
              periodo_calculo = v_parametros.periodo_calculo,
              id_clase_comprobante = v_parametros.id_clase_comprobante,
              glosa = v_parametros.glosa,
              id_tipo_relacion_comprobante = v_parametros.id_tipo_relacion_comprobante,
              relacion_unica = v_parametros.relacion_unica,
              nombre_func = v_parametros.nombre_func
			where id_resultado_plantilla = v_parametros.id_resultado_plantilla;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Plantilla de Resultados modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_resultado_plantilla',v_parametros.id_resultado_plantilla::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_RESPLAN_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		08-07-2015 13:12:43
	***********************************/

	elsif(p_transaccion='CONTA_RESPLAN_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tresultado_plantilla
            where id_resultado_plantilla=v_parametros.id_resultado_plantilla;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Plantilla de Resultados eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_resultado_plantilla',v_parametros.id_resultado_plantilla::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
    /*********************************    
 	#TRANSACCION:  'CONTA_CLONARPLT_IME'
 	#DESCRIPCION:	clonar plantilla de resultados
 	#AUTOR:		admin	
 	#FECHA:		08-07-2015 13:12:43
	***********************************/

	elsif(p_transaccion='CONTA_CLONARPLT_IME')then

		begin
		    ------------------------------------
            --  copiar el resultado plantilla	
            -----------------------------------
            select 
             rp.codigo,
             rp.nombre,
             rp.cbte_aitb,
             rp.cbte_apertura,
             rp.cbte_cierre,
             rp.id_clase_comprobante,
             rp.tipo,
             rp.periodo_calculo,
             rp.id_tipo_relacion_comprobante,
             rp.relacion_unica,
             rp.nombre_func
            into
              v_registros 
            from conta.tresultado_plantilla rp 
            where rp.id_resultado_plantilla = v_parametros.id_resultado_plantilla;
			
            
            INSERT INTO conta.tresultado_plantilla (
                  id_usuario_reg,
                  fecha_reg,
                  estado_reg,
                  codigo,
                  nombre,
                  cbte_aitb,
                  cbte_apertura,
                  cbte_cierre,
                  id_clase_comprobante,
                  tipo,
                  periodo_calculo,
                  id_tipo_relacion_comprobante,
                  relacion_unica,
                  nombre_func 
                )
                VALUES (
                   p_id_usuario,
                   now(),
                   'activo',
                   v_registros.codigo||'-CLON',
                   v_registros.nombre,
                   v_registros.cbte_aitb,
                   v_registros.cbte_apertura,
                   v_registros.cbte_cierre,
                   v_registros.id_clase_comprobante,
                   v_registros.tipo,
                   v_registros.periodo_calculo,
              	   v_registros.id_tipo_relacion_comprobante,
             	   v_registros.relacion_unica,
                   v_registros.nombre_func
                )  RETURNING id_resultado_plantilla into v_id_resultado_plantilla;
            
            ----------------------------------------------
            --  copiar el detalle de la plantilla 
            ---------------------------------------------
               
            
            FOR v_registros in (  Select  *
                                  from conta.tresultado_det_plantilla rdp 
                                  where rdp.id_resultado_plantilla = v_parametros.id_resultado_plantilla) LOOP
                      
                      
                      
                      INSERT INTO  conta.tresultado_det_plantilla
                                      (
                                        id_usuario_reg,
                                        fecha_reg,
                                        estado_reg,
                                        origen,
                                        formula,
                                        subrayar,
                                        font_size,
                                        posicion,
                                        signo,
                                        nivel_detalle,
                                        codigo_cuenta,
                                        codigo,
                                        orden,
                                        nombre_variable,
                                        montopos,
                                        id_resultado_plantilla,
                                        visible,
                                        incluir_cierre,
                                        incluir_apertura,
                                        negrita,
                                        cursiva,
                                        espacio_previo,
                                        incluir_aitb,
                                        tipo_saldo,
                                        signo_balance,
                                        relacion_contable,
                                        codigo_partida,
                                        id_auxiliar,
                                        destino,
                                        orden_cbte
                                      )
                                      VALUES (
                                        p_id_usuario,
                                        now(),
                                        'activo',
                                        v_registros.origen,
                                        v_registros.formula,
                                        v_registros.subrayar,
                                        v_registros.font_size,
                                        v_registros.posicion,
                                        v_registros.signo,
                                        v_registros.nivel_detalle,
                                        v_registros.codigo_cuenta,
                                        v_registros.codigo,
                                        v_registros.orden,
                                        v_registros.nombre_variable,
                                        v_registros.montopos,
                                        v_id_resultado_plantilla,   --> id nueva plantilla
                                        v_registros.visible,
                                        v_registros.incluir_cierre,
                                        v_registros.incluir_apertura,
                                        v_registros.negrita,
                                        v_registros.cursiva,
                                        v_registros.espacio_previo,
                                        v_registros.incluir_aitb,
                                        v_registros.tipo_saldo,
                                        v_registros.signo_balance,
                                        v_registros.relacion_contable,
                                        v_registros.codigo_partida,
                                        v_registros.id_auxiliar,
                                        v_registros.destino,
                                        v_registros.orden_cbte
                                      );
                                      
                                      
                                      
            
            END LOOP;
            
            -----------------------------------
            -- Clonar las dependencias
            -----------------------------------
            
            FOR  v_registros in ( select  *  
                                  from  conta.tresultado_dep rd 
                                  where rd.id_resultado_plantilla  = v_parametros.id_resultado_plantilla) LOOP
            
                  INSERT INTO conta.tresultado_dep
                                  (
                                    id_usuario_reg,
                                    fecha_reg,
                                    estado_reg,
                                    id_resultado_plantilla,
                                    prioridad,
                                    obs,
                                    id_resultado_plantilla_hijo
                                  )
                                  VALUES (
                                    p_id_usuario,
                                    now(),
                                    'activo',
                                    v_id_resultado_plantilla,  --> nueva plantilla
                                    v_registros.prioridad,
                                    v_registros.obs,
                                    v_registros.id_resultado_plantilla_hijo
                                  );
            
            END LOOP;
            
            
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Plantilla clonada con exito)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_resultado_plantilla',v_parametros.id_resultado_plantilla::varchar);
              
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