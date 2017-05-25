--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_resultado_det_plantilla_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_resultado_det_plantilla_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tresultado_det_plantilla'
 AUTOR: 		 (admin)
 FECHA:	        08-07-2015 13:13:15
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
	v_id_resultado_det_plantilla	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_resultado_det_plantilla_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_RESDET_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		08-07-2015 13:13:15
	***********************************/

	if(p_transaccion='CONTA_RESDET_INS')then
					
        begin
        	
        
        -------------------------
        --  VALIDACIONES ...
        ---------------------------
            --revisar que el orden sea unico
            
            IF  exists (select 1 from conta.tresultado_det_plantilla rdp 
                        where rdp.id_resultado_plantilla = v_parametros.id_resultado_plantilla
                               and rdp.orden = v_parametros.orden) THEN
                   raise exception 'El número de orden esta duplicado';            
        	END IF;
            
            IF  v_parametros.destino != 'reporte' and v_parametros.origen not in ('balance','formula')  THEN
                raise exception 'si el detino es para insertar transacciones el origen debe ser balance o formula';
            END IF;
            
            IF  v_parametros.destino != 'reporte' THEN
               IF  (v_parametros.codigo_cuenta is NULL or v_parametros.codigo_cuenta = '' )  and (v_parametros.relacion_contable is NULL or v_parametros.relacion_contable = '' ) THEN
                  raise exception 'si el detino es para insertar trasacciones, es obligatorio especificar el nombre de la cuenta contable (o relacion contable)';
               END IF;
            END IF;
            
            --Sentencia de la insercion
        	insert into conta.tresultado_det_plantilla(
              orden,
              font_size,
              formula,
              subrayar,
              codigo,
              montopos,
              nombre_variable,
              posicion,
              estado_reg,
              nivel_detalle,
              origen,
              signo,
              codigo_cuenta,
              id_usuario_ai,
              usuario_ai,
              fecha_reg,
              id_usuario_reg,
              id_usuario_mod,
              fecha_mod,
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
          	) values(
			v_parametros.orden,
			v_parametros.font_size,
			v_parametros.formula,
			v_parametros.subrayar,
			v_parametros.codigo,
			v_parametros.montopos,
			v_parametros.nombre_variable,
			v_parametros.posicion,
			'activo',
			v_parametros.nivel_detalle,
			v_parametros.origen,
			v_parametros.signo,
			v_parametros.codigo_cuenta,
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			now(),
			p_id_usuario,
			null,
			null,
            v_parametros.id_resultado_plantilla,
            v_parametros.visible,
            v_parametros.incluir_cierre,
            v_parametros.incluir_apertura,
            v_parametros.negrita,
            v_parametros.cursiva,
            v_parametros.espacio_previo,
            v_parametros.incluir_aitb,
            v_parametros.tipo_saldo,
            v_parametros.signo_balance,
            v_parametros.relacion_contable,
            v_parametros.codigo_partida,
            v_parametros.id_auxiliar,
            v_parametros.destino,
            v_parametros.orden_cbte
			)RETURNING id_resultado_det_plantilla into v_id_resultado_det_plantilla;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle de Resultado almacenado(a) con exito (id_resultado_det_plantilla'||v_id_resultado_det_plantilla||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_resultado_det_plantilla',v_id_resultado_det_plantilla::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_RESDET_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		08-07-2015 13:13:15
	***********************************/

	elsif(p_transaccion='CONTA_RESDET_MOD')then

		begin
        
         -------------------------
         --  VALIDACIONES ...
         ---------------------------
            --revisar que el orden sea unico
            
            IF  exists (select 1 from conta.tresultado_det_plantilla rdp 
                        where rdp.id_resultado_plantilla = v_parametros.id_resultado_plantilla
                               and rdp.orden = v_parametros.orden
                               and rdp.id_resultado_det_plantilla != v_parametros.id_resultado_det_plantilla ) THEN
                   raise exception 'El número de orden esta duplicado';            
        	END IF;
            
            IF  v_parametros.destino != 'reporte' and v_parametros.origen not in ('balance','formula')  THEN
                raise exception 'si el detino es para insertar transacciones el origen debe ser balance o formula';
            END IF;
            
            IF  v_parametros.destino != 'reporte' THEN
               IF  (v_parametros.codigo_cuenta is NULL or v_parametros.codigo_cuenta = '' )  and (v_parametros.relacion_contable is NULL or v_parametros.relacion_contable = '' ) THEN
                  raise exception 'si el detino es para insertar trasacciones, es obligatorio especificar el nombre de la cuenta contable (o relacion contable)';
               END IF;
            END IF;
			--Sentencia de la modificacion
			update conta.tresultado_det_plantilla set
              orden = v_parametros.orden,
              font_size = v_parametros.font_size,
              formula = v_parametros.formula,
              subrayar = v_parametros.subrayar,
              codigo = v_parametros.codigo,
              montopos = v_parametros.montopos,
              nombre_variable = v_parametros.nombre_variable,
              posicion = v_parametros.posicion,
              nivel_detalle = v_parametros.nivel_detalle,
              origen = v_parametros.origen,
              signo = v_parametros.signo,
              codigo_cuenta = v_parametros.codigo_cuenta,
              id_usuario_mod = p_id_usuario,
              fecha_mod = now(),
              id_usuario_ai = v_parametros._id_usuario_ai,
              usuario_ai = v_parametros._nombre_usuario_ai,
              id_resultado_plantilla = v_parametros.id_resultado_plantilla,
              visible = v_parametros.visible,
              incluir_cierre = v_parametros.incluir_cierre,
              incluir_apertura = v_parametros.incluir_apertura,
              negrita = v_parametros.negrita,
              cursiva = v_parametros.cursiva,
              espacio_previo = v_parametros.espacio_previo,
              incluir_aitb = v_parametros.incluir_aitb,
              tipo_saldo  = v_parametros.tipo_saldo,
              signo_balance = v_parametros.signo_balance,
              relacion_contable = v_parametros.relacion_contable,
              codigo_partida = v_parametros.codigo_partida,
              id_auxiliar = v_parametros.id_auxiliar,
              destino = v_parametros.destino,
              orden_cbte = v_parametros.orden_cbte
			where id_resultado_det_plantilla=v_parametros.id_resultado_det_plantilla;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle de Resultado modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_resultado_det_plantilla',v_parametros.id_resultado_det_plantilla::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_RESDET_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		08-07-2015 13:13:15
	***********************************/

	elsif(p_transaccion='CONTA_RESDET_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tresultado_det_plantilla
            where id_resultado_det_plantilla=v_parametros.id_resultado_det_plantilla;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle de Resultado eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_resultado_det_plantilla',v_parametros.id_resultado_det_plantilla::varchar);
              
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