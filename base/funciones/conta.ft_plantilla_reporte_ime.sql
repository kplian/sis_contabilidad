CREATE OR REPLACE FUNCTION conta.ft_plantilla_reporte_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_plantilla_reporte_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tplantilla_reporte'
 AUTOR: 		 (m.mamani)
 FECHA:	        06-09-2018 19:52:00
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				06-09-2018 19:52:00								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tplantilla_reporte'
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_plantilla_reporte	integer;

BEGIN

    v_nombre_funcion = 'conta.ft_plantilla_reporte_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'CONTA_PER_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		m.mamani
 	#FECHA:		06-09-2018 19:52:00
	***********************************/

	if(p_transaccion='CONTA_PER_INS')then

        begin
        	--Sentencia de la insercion
        	insert into conta.tplantilla_reporte(
			nombre,
			glosa,
			modalidad,
			estado_reg,
			--tipo,
			id_usuario_ai,
			id_usuario_reg,
			usuario_ai,
			fecha_reg,
			id_usuario_mod,
			fecha_mod,
            codigo,
            nombre_func,
            visible
          	) values(
			v_parametros.nombre,
			v_parametros.glosa,
			v_parametros.modalidad,
			'activo',
			--v_parametros.tipo,
			v_parametros._id_usuario_ai,
			p_id_usuario,
			v_parametros._nombre_usuario_ai,
			now(),
			null,
			null,
			v_parametros.codigo,
            v_parametros.nombre_func,
            v_parametros.visible
			)RETURNING id_plantilla_reporte into v_id_plantilla_reporte;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','plantilla reporte almacenado(a) con exito (id_plantilla_reporte'||v_id_plantilla_reporte||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_plantilla_reporte',v_id_plantilla_reporte::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'CONTA_PER_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		m.mamani
 	#FECHA:		06-09-2018 19:52:00
	***********************************/

	elsif(p_transaccion='CONTA_PER_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.tplantilla_reporte set
			nombre = v_parametros.nombre,
			glosa = v_parametros.glosa,
			modalidad = v_parametros.modalidad,
			--tipo = v_parametros.tipo,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai,
            codigo = v_parametros.codigo,
            nombre_func = v_parametros.nombre_func,
            visible = v_parametros.visible
			where id_plantilla_reporte=v_parametros.id_plantilla_reporte;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','plantilla reporte modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_plantilla_reporte',v_parametros.id_plantilla_reporte::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_PER_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		m.mamani	
 	#FECHA:		06-09-2018 19:52:00
	***********************************/

	elsif(p_transaccion='CONTA_PER_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tplantilla_reporte
            where id_plantilla_reporte=v_parametros.id_plantilla_reporte;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','plantilla reporte eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_plantilla_reporte',v_parametros.id_plantilla_reporte::varchar);
              
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