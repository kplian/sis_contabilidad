CREATE OR REPLACE FUNCTION conta.ft_plantilla_det_reporte_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_plantilla_det_reporte_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tplantilla_det_reporte'
 AUTOR: 		 (m.mamani)
 FECHA:	        06-09-2018 20:33:59
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				06-09-2018 20:33:59								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tplantilla_det_reporte'
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_plantilla_det_reporte	integer;
	v_record				record;
BEGIN

    v_nombre_funcion = 'conta.ft_plantilla_det_reporte_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'CONTA_PDR_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		m.mamani
 	#FECHA:		06-09-2018 20:33:59
	***********************************/

	if(p_transaccion='CONTA_PDR_INS')then

        begin
        	--Sentencia de la insercion
        	insert into conta.tplantilla_det_reporte(
                                    origen,
                                    estado_reg,
                                    concepto,
                                    codigo_columna,
                                    columna,
                                    order_fila,
                                    id_plantilla_reporte,
                                    formula,
                                    partida,
                                    usuario_ai,
                                    fecha_reg,
                                    id_usuario_reg,
                                    id_usuario_ai,
                                    id_usuario_mod,
                                    fecha_mod,
                                    nombre_columna,
                                    saldo_inical,
                                    formulario,
                                    codigo_formulario,
                                    saldo_anterior,
                                    operacion,
                                    apertura_cb,
                                    cierre_cb,
                                    tipo_periodo
                                    ) values(
                                    v_parametros.origen,
                                    'activo',
                                    v_parametros.concepto,
                                    v_parametros.codigo_columna,
                                    v_parametros.columna,
                                    v_parametros.order_fila,
                                    v_parametros.id_plantilla_reporte,
                                    v_parametros.formula,
                                    v_parametros.partida,
                                    v_parametros._nombre_usuario_ai,
                                    now(),
                                    p_id_usuario,
                                    v_parametros._id_usuario_ai,
                                    null,
                                    null,
                                    v_parametros.nombre_columna,
                                    v_parametros.saldo_inical,
                                    v_parametros.formulario,
                                    v_parametros.codigo_formulario,
                                    v_parametros.saldo_anterior,
                                    v_parametros.operacion,
                                    v_parametros.apertura_cb,
                                    v_parametros.cierre_cb,
                                    v_parametros.tipo_periodo
			)RETURNING id_plantilla_det_reporte into v_id_plantilla_det_reporte;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Plantilla detalle reporte almacenado(a) con exito (id_plantilla_det_reporte'||v_id_plantilla_det_reporte||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_plantilla_det_reporte',v_id_plantilla_det_reporte::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'CONTA_PDR_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		m.mamani
 	#FECHA:		06-09-2018 20:33:59
	***********************************/

	elsif(p_transaccion='CONTA_PDR_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.tplantilla_det_reporte set
			origen = v_parametros.origen,
			concepto = v_parametros.concepto,
			codigo_columna = v_parametros.codigo_columna,
			columna = v_parametros.columna,
			order_fila = v_parametros.order_fila,
			id_plantilla_reporte = v_parametros.id_plantilla_reporte,
			formula = v_parametros.formula,
			partida = v_parametros.partida,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai,
            nombre_columna = v_parametros.nombre_columna,
            saldo_inical = v_parametros.saldo_inical,
            formulario = v_parametros.formulario,
        	codigo_formulario = v_parametros.codigo_formulario,
            saldo_anterior = v_parametros.saldo_anterior,
        	operacion = v_parametros.operacion,
            apertura_cb = v_parametros.apertura_cb,
            cierre_cb = v_parametros.cierre_cb,
            tipo_periodo = v_parametros.tipo_periodo
			where id_plantilla_det_reporte=v_parametros.id_plantilla_det_reporte;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Plantilla detalle reporte modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_plantilla_det_reporte',v_parametros.id_plantilla_det_reporte::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_PDR_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		m.mamani	
 	#FECHA:		06-09-2018 20:33:59
	***********************************/

	elsif(p_transaccion='CONTA_PDR_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tplantilla_det_reporte
            where id_plantilla_det_reporte=v_parametros.id_plantilla_det_reporte;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Plantilla detalle reporte eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_plantilla_det_reporte',v_parametros.id_plantilla_det_reporte::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
    /*********************************    
 	#TRANSACCION:  'CONTA_PDR_CLO'
 	#DESCRIPCION:	Clonar
 	#AUTOR:		m.mamani	
 	#FECHA:		06-09-2018 20:33:59
	***********************************/

	elsif(p_transaccion='CONTA_PDR_CLO')then

		begin
		
        select 	origen,
                concepto,
                codigo_columna,
                columna,
                order_fila,
                id_plantilla_reporte,
                formula,
                partida,
                nombre_columna,
                saldo_inical,
                formulario,
                codigo_formulario,
                saldo_anterior,
                calculo,
                concepto2,
                partida2,
                operacion,
                periodo,
                origen2
                into v_record
        from conta.tplantilla_det_reporte 
        where id_plantilla_det_reporte = v_parametros.id_plantilla_det_reporte;
        
        insert into conta.tplantilla_det_reporte(
                                    origen,
                                    estado_reg,
                                    concepto,
                                    codigo_columna,
                                    columna,
                                    order_fila,
                                    id_plantilla_reporte,
                                    formula,
                                    partida,
                                    fecha_reg,
                                    id_usuario_reg,
                                    id_usuario_ai,
                                    id_usuario_mod,
                                    fecha_mod,
                                    nombre_columna,
                                    saldo_inical,
                                    formulario,
                                    codigo_formulario,
                                    saldo_anterior,
                                    calculo,
                                    concepto2,
                                    partida2,
                                    operacion,
                                    periodo,
                                    origen2
                                    ) values(
                                    v_record.origen,
                                    'activo',
                                    v_record.concepto,
                                    v_record.codigo_columna,
                                    v_record.columna,
                                    v_record.order_fila + 1,
                                    v_record.id_plantilla_reporte,
                                    v_record.formula,
                                    v_record.partida,
                                    now(),
                                    p_id_usuario,
                                    v_parametros._id_usuario_ai,
                                    null,
                                    null,
                                    '',
                                    v_record.saldo_inical,
                                    v_record.formulario,
                                    v_record.codigo_formulario,
                                    v_record.saldo_anterior,
                                    v_record.calculo,
                                    v_record.concepto2,
                                    v_record.partida2,
                                    v_record.operacion,
                                    v_record.periodo,
                                    v_record.origen2						
			)RETURNING id_plantilla_det_reporte into v_id_plantilla_det_reporte;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Plantilla detalle reporte almacenado(a) con exito (id_plantilla_det_reporte'||v_id_plantilla_det_reporte||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_plantilla_det_reporte',v_id_plantilla_det_reporte::varchar);

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