--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_detalle_det_reporte_aux_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_detalle_det_reporte_aux_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tdetalle_det_reporte_aux'
 AUTOR: 		 (m.mamani)
 FECHA:	        19-10-2018 15:39:09
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				19-10-2018 15:39:09								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tdetalle_det_reporte_aux'	
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_detalle_det_reporte_aux	integer;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_detalle_det_reporte_aux_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_DRA_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		m.mamani	
 	#FECHA:		19-10-2018 15:39:09
	***********************************/

	if(p_transaccion='CONTA_DRA_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.tdetalle_det_reporte_aux(
			estado_reg,
			partida,
			orden_fila,
			origen,
			concepto,
			id_usuario_reg,
			usuario_ai,
			fecha_reg,
			id_usuario_ai,
			id_usuario_mod,
			fecha_mod,
            id_plantilla_reporte
          	) values(
			'activo',
			v_parametros.partida,
			v_parametros.orden_fila,
			v_parametros.origen,
			v_parametros.concepto,
			p_id_usuario,
			v_parametros._nombre_usuario_ai,
			now(),
			v_parametros._id_usuario_ai,
			null,
			null,
            v_parametros.id_plantilla_reporte
							
			)RETURNING id_detalle_det_reporte_aux into v_id_detalle_det_reporte_aux;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle Reporte Auxliar almacenado(a) con exito (id_detalle_det_reporte_aux'||v_id_detalle_det_reporte_aux||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_detalle_det_reporte_aux',v_id_detalle_det_reporte_aux::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_DRA_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		m.mamani	
 	#FECHA:		19-10-2018 15:39:09
	***********************************/

	elsif(p_transaccion='CONTA_DRA_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.tdetalle_det_reporte_aux set
			partida = v_parametros.partida,
			orden_fila = v_parametros.orden_fila,
			origen = v_parametros.origen,
			concepto = v_parametros.concepto,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai,
            id_plantilla_reporte = v_parametros.id_plantilla_reporte
			where id_detalle_det_reporte_aux=v_parametros.id_detalle_det_reporte_aux;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle Reporte Auxliar modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_detalle_det_reporte_aux',v_parametros.id_detalle_det_reporte_aux::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_DRA_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		m.mamani	
 	#FECHA:		19-10-2018 15:39:09
	***********************************/

	elsif(p_transaccion='CONTA_DRA_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tdetalle_det_reporte_aux
            where id_detalle_det_reporte_aux=v_parametros.id_detalle_det_reporte_aux;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle Reporte Auxliar eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_detalle_det_reporte_aux',v_parametros.id_detalle_det_reporte_aux::varchar);
              
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