CREATE OR REPLACE FUNCTION conta.ft_anexos_actualizaciones_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_anexos_actualizaciones_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tanexos_actualizaciones'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        27-06-2017 13:39:16
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
	v_id_anexos_actualizaciones	integer;
    v_revisado				varchar;
    v_registros_json 		record;
    v_estado_gestion		varchar;
    v_registros				record;
    v_reccord				record;
    v_id_periodo			integer;
    v_id_deptor				integer;


BEGIN

    v_nombre_funcion = 'conta.ft_anexos_actualizaciones_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'CONTA_ANS_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		27-06-2017 13:39:16
	***********************************/

	if(p_transaccion='CONTA_ANS_INS')then

        begin

          select r.estado
          into v_estado_gestion
          from conta.tperiodo_resolucion r
          where r.id_periodo = v_parametros.id_periodo and r.id_depto = v_parametros.id_depto_conta;

          IF v_estado_gestion = 'cerrado' THEN
        	RAISE EXCEPTION '%','PERIODO CERRADO';
      	  END IF;
        	--Sentencia de la insercion
        	insert into conta.tanexos_actualizaciones(
			descripcion_producto,
			nit_proveerdor,
			tipo_comision,
			nit_comisionista,
			monto_porcentaje,
			fecha_vigente,
			nro_contrato,
			id_depto_conta,
			id_periodo,
			precio_unitario,
			codigo_producto,
			estado_reg,
			id_usuario_ai,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.descripcion_producto,
			v_parametros.nit_proveerdor,
			v_parametros.tipo_comision,
			v_parametros.nit_comisionista,
			v_parametros.monto_porcentaje,
			v_parametros.fecha_vigente,
			v_parametros.nro_contrato,
			v_parametros.id_depto_conta,
			v_parametros.id_periodo,
			v_parametros.precio_unitario,
			v_parametros.codigo_producto,
			'activo',
			v_parametros._id_usuario_ai,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			null,
			null



			)RETURNING id_anexos_actualizaciones into v_id_anexos_actualizaciones;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Anexos Actualizaciones almacenado(a) con exito (id_anexos_actualizaciones'||v_id_anexos_actualizaciones||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_anexos_actualizaciones',v_id_anexos_actualizaciones::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'CONTA_ANS_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		27-06-2017 13:39:16
	***********************************/

	elsif(p_transaccion='CONTA_ANS_MOD')then

		begin
         select r.estado
          into v_estado_gestion
          from conta.tperiodo_resolucion r
          where r.id_periodo = v_parametros.id_periodo and r.id_depto = v_parametros.id_depto_conta;

          IF v_estado_gestion = 'cerrado' THEN
        	RAISE EXCEPTION '%','PERIODO CERRADO';
      	  END IF;
			--Sentencia de la modificacion
			update conta.tanexos_actualizaciones set
			descripcion_producto = v_parametros.descripcion_producto,
			nit_proveerdor = v_parametros.nit_proveerdor,
			tipo_comision = v_parametros.tipo_comision,
			nit_comisionista = v_parametros.nit_comisionista,
			monto_porcentaje = v_parametros.monto_porcentaje,
			fecha_vigente = v_parametros.fecha_vigente,
			nro_contrato = v_parametros.nro_contrato,
			precio_unitario = v_parametros.precio_unitario,
			codigo_producto = v_parametros.codigo_producto,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_anexos_actualizaciones=v_parametros.id_anexos_actualizaciones;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Anexos Actualizaciones modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_anexos_actualizaciones',v_parametros.id_anexos_actualizaciones::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'CONTA_ANS_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		27-06-2017 13:39:16
	***********************************/

	elsif(p_transaccion='CONTA_ANS_ELI')then

		begin
           select 	id_periodo,
        		id_depto_conta
        into
        v_id_periodo,
        v_id_deptor

        from conta.tanexos_actualizaciones
        where id_anexos_actualizaciones = v_parametros.id_anexos_actualizaciones;

        select r.estado
        into
        v_estado_gestion
        from conta.tperiodo_resolucion r
        where r.id_periodo = v_id_periodo and r.id_depto = v_id_deptor;

          IF v_estado_gestion = 'cerrado' THEN
        	RAISE EXCEPTION '%','PERIODO CERRADO';
      	  END IF;
			--Sentencia de la eliminacion
			delete from conta.tanexos_actualizaciones
            where id_anexos_actualizaciones=v_parametros.id_anexos_actualizaciones;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Anexos Actualizaciones eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_anexos_actualizaciones',v_parametros.id_anexos_actualizaciones::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;
    /*********************************
 	#TRANSACCION:  'CONTA_ANS_CONT'
 	#DESCRIPCION:	Control revision
 	#AUTOR:		MMV
 	#FECHA:		14-06-2017
	***********************************/
	elsif (p_transaccion='CONTA_ANS_CONT')then

        begin

            select co.revisado
            		into
                    v_revisado
            from conta.tanexos_actualizaciones co
			where co.id_anexos_actualizaciones = v_parametros.id_anexos_actualizaciones;

            if v_revisado = 'si' then
            update conta.tanexos_actualizaciones set
            revisado = 'no'
            where id_anexos_actualizaciones = v_parametros.id_anexos_actualizaciones;
            end if;
            if v_revisado = 'no' then
            update conta.tanexos_actualizaciones set
            revisado = 'si'
            where id_anexos_actualizaciones = v_parametros.id_anexos_actualizaciones;
            end if;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Revision con exito (id_anexos_actualizaciones'||v_parametros.id_anexos_actualizaciones||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_anexos_actualizaciones',v_parametros.id_anexos_actualizaciones::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

/*********************************
 #TRANSACCION: 'CONTA_ANS_IMP'
 #DESCRIPCION:	Importacion de archivo txt
 #AUTOR:		MMV
 #FECHA:		20-06-2017 20:17:02
***********************************/

  ELSIF (p_transaccion='CONTA_ANS_IMP')THEN

      BEGIN
        FOR v_registros_json IN (SELECT *
                                 FROM json_populate_recordset(NULL :: conta.json_act_anexos,
                                                              v_parametros.arra_json :: JSON)) LOOP


          --verificamos la gestion si esta abierta

            select r.estado
          into v_estado_gestion
          from conta.tperiodo_resolucion r
          where r.id_periodo = v_parametros.id_periodo and r.id_depto = v_parametros.id_depto_conta;

          IF v_estado_gestion = 'cerrado' THEN
        	RAISE EXCEPTION '%','PERIODO CERRADO';
      	  END IF;

			insert into conta.tanexos_actualizaciones(
			descripcion_producto,
			nit_proveerdor,
			tipo_comision,
			nit_comisionista,
			monto_porcentaje,
			fecha_vigente,
			nro_contrato,
			id_depto_conta,
			id_periodo,
			precio_unitario,
			codigo_producto,
			estado_reg,
			id_usuario_ai,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_registros_json.descripcion_producto::varchar,
			v_registros_json.nit_proveerdor::varchar,
			v_registros_json.tipo_comision::varchar,
			v_registros_json.nit_comisionista::varchar,
			v_registros_json.monto_porcentaje::varchar,
			v_registros_json.fecha_vigente::date,
			v_registros_json.nro_contrato::varchar,
			v_parametros.id_depto_conta,
			v_parametros.id_periodo,
			v_registros_json.precio_unitario::numeric,
			v_registros_json.codigo_producto::varchar,
			'activo',
			v_parametros._id_usuario_ai,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			null,
			null);

      END LOOP;

        --Definicion de la respuesta
        v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'bancarizacion eliminado(a)');
        v_resp = pxp.f_agrega_clave(v_resp, 'id_anexos_actualizaciones', 10 :: VARCHAR);

        --Devuelve la respuesta
        RETURN v_resp;

      END;
      	/*********************************
     #TRANSACCION: 'CONTA_ANS_ELITO'
     #DESCRIPCION:	Elimila todo los registros
     #AUTOR:		MMV
     #FECHA:		20-06-2017 20:17:02
    ***********************************/

  ELSIF (p_transaccion='CONTA_ANS_ELITO')
    THEN

      BEGIN

        select r.estado
          into v_estado_gestion
          from conta.tperiodo_resolucion r
          where r.id_periodo = v_parametros.id_periodo and r.id_depto = v_parametros.id_depto_conta;

          IF v_estado_gestion = 'cerrado' THEN
        	RAISE EXCEPTION '%','PERIODO CERRADO';
      	  END IF;

        DELETE FROM conta.tanexos_actualizaciones cm
        WHERE cm.id_periodo = v_parametros.id_periodo
              AND cm.id_depto_conta = v_parametros.id_depto_conta
              AND cm.revisado = 'no';

        --Definicion de la respuesta
        v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'eliminado(a)');

        --Devuelve la respuesta
        RETURN v_resp;

      END;
       /*********************************
       #TRANSACCION: 'CONTA_ANS_CLON'
       #DESCRIPCION:  clona de registros
       #AUTOR:		  MMV
       #FECHA:		  20-06-2017 20:17:02
      ***********************************/

  ELSIF (p_transaccion='CONTA_ANS_CLON') THEN

      BEGIN


        --Sentencia de la eliminacion
		--raise exception 'llega %',v_parametros.id_simplificado;
        SELECT *
        INTO v_reccord
        FROM conta.tanexos_actualizaciones
        where id_anexos_actualizaciones = v_parametros.id_anexos_actualizaciones;

        /*IF v_reccord.revisado = 'si' THEN
          RAISE EXCEPTION '%','NO SE PUEDE CLONAR CUANDO ESTA REVISADO ';
        END IF;*/


           select 	id_periodo,
        		id_depto_conta
        into
        v_id_periodo,
        v_id_deptor

        from conta.tanexos_actualizaciones
        where id_anexos_actualizaciones = v_parametros.id_anexos_actualizaciones;

        select r.estado
        into
        v_estado_gestion
        from conta.tperiodo_resolucion r
        where r.id_periodo = v_id_periodo and r.id_depto = v_id_deptor;

          IF v_estado_gestion = 'cerrado' THEN
        	RAISE EXCEPTION '%','PERIODO CERRADO';
      	  END IF;

		insert into conta.tanexos_actualizaciones(
			descripcion_producto,
			nit_proveerdor,
			tipo_comision,
			nit_comisionista,
			monto_porcentaje,
			fecha_vigente,
			nro_contrato,
			id_depto_conta,
			id_periodo,
			precio_unitario,
			codigo_producto,
			estado_reg,
			id_usuario_ai,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod,
            registro,
            tipo_anexo
          	) values(
			v_reccord.descripcion_producto,
			v_reccord.nit_proveerdor,
			v_reccord.tipo_comision,
			v_reccord.nit_comisionista,
			v_reccord.monto_porcentaje,
			v_reccord.fecha_vigente,
			v_reccord.nro_contrato,
			v_reccord.id_depto_conta,
			v_reccord.id_periodo,
			v_reccord.precio_unitario,
			v_reccord.codigo_producto,
			'activo',
			v_parametros._id_usuario_ai,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			null,
			null,
            'normal',
            'clonado'
			);


        --Definicion de la respuesta
        v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'anexos actualizaciones clonado(a)');
        v_resp = pxp.f_agrega_clave(v_resp, 'id_anexos_actualizaciones', v_parametros.id_anexos_actualizaciones :: VARCHAR);

        --Devuelve la respuesta
        RETURN v_resp;

      END;
      /*********************************
       #TRANSACCION: 'CONTA_ANS_NEGR'
       #DESCRIPCION:  lista negra
       #AUTOR:		  MMV
       #FECHA:		  20-06-2017 20:17:02
      ***********************************/

  ELSIF (p_transaccion='CONTA_ANS_NEGR') THEN

      BEGIN

        select r.estado
          into v_estado_gestion
          from conta.tperiodo_resolucion r
          where r.id_periodo = v_parametros.id_periodo and r.id_depto = v_parametros.id_depto_conta;

          IF v_estado_gestion = 'cerrado' THEN
        	RAISE EXCEPTION '%','PERIODO CERRADO';
      	  END IF;

        select *
        into
        v_registros
        from conta.tanexos_actualizaciones
        where id_anexos_actualizaciones = v_parametros.id_anexos_actualizaciones;

        if v_registros.lista_negra = 'si'then
        update conta.tanexos_actualizaciones set
        lista_negra = 'no'
        where id_anexos_actualizaciones = v_parametros.id_anexos_actualizaciones;
        else
        update conta.tanexos_actualizaciones set
        lista_negra = 'si'
        where id_anexos_actualizaciones = v_parametros.id_anexos_actualizaciones;
  		end if;
        v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'anexos agregado a la lista negra(a)');
   		RETURN v_resp;
   END;
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