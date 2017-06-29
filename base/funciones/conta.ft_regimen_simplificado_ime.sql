CREATE OR REPLACE FUNCTION conta.ft_regimen_simplificado_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_regimen_simplificado_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tregimen_simplificado'
 AUTOR: 		 (admin)
 FECHA:	        31-05-2017 20:17:05
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
	v_id_simplificado		integer;
    v_revisado				varchar;
    v_registros_json		record;
    v_reccord               record;
    v_estado_gestion		varchar;
    v_registros				record;
    v_id_periodo			integer;
    v_id_deptor				integer;

BEGIN

    v_nombre_funcion = 'conta.ft_regimen_simplificado_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'CONTA_RSO_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin
 	#FECHA:		31-05-2017 20:17:05
	***********************************/

	if(p_transaccion='CONTA_RSO_INS')then

        begin
        select r.estado
          into v_estado_gestion
          from conta.tperiodo_resolucion r
          where r.id_periodo = v_parametros.id_periodo and r.id_depto = v_parametros.id_depto_conta;

          IF v_estado_gestion = 'cerrado' THEN
        	RAISE EXCEPTION '%','PERIODO CERRADO';
      	  END IF;
        	--Sentencia de la insercion
        	insert into conta.tregimen_simplificado(
			precio_unitario,
			descripcion,
			codigo_cliente,
			codigo_producto,
			estado_reg,
			importe_total,
			cantidad_producto,
			nit,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod,
            id_periodo,
            id_depto_conta
          	) values(
			v_parametros.precio_unitario,
			v_parametros.descripcion,
			v_parametros.codigo_cliente,
			v_parametros.codigo_producto,
			'activo',
			v_parametros.importe_total,
            v_parametros.cantidad_producto,
			v_parametros.nit,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			v_parametros._id_usuario_ai,
			null,
			null,
			v_parametros.id_periodo,
            v_parametros.id_depto_conta

			)RETURNING id_simplificado into v_id_simplificado;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Regimen Simplificado  almacenado(a) con exito (id_simplificado'||v_id_simplificado||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_simplificado',v_id_simplificado::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'CONTA_RSO_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin
 	#FECHA:		31-05-2017 20:17:05
	***********************************/

	elsif(p_transaccion='CONTA_RSO_MOD')then

		begin
        select r.estado
          into v_estado_gestion
          from conta.tperiodo_resolucion r
          where r.id_periodo = v_parametros.id_periodo and r.id_depto = v_parametros.id_depto_conta;

          IF v_estado_gestion = 'cerrado' THEN
        	RAISE EXCEPTION '%','PERIODO CERRADO';
      	  END IF;
			--Sentencia de la modificacion
			update conta.tregimen_simplificado set
			precio_unitario = v_parametros.precio_unitario,
			descripcion = v_parametros.descripcion,
			codigo_cliente = v_parametros.codigo_cliente,
			codigo_producto = v_parametros.codigo_producto,
			importe_total = v_parametros.importe_total,
			cantidad_producto = v_parametros.cantidad_producto,
			nit = v_parametros.nit,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_simplificado=v_parametros.id_simplificado;
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Regimen Simplificado  modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_simplificado',v_parametros.id_simplificado::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'CONTA_RSO_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin
 	#FECHA:		31-05-2017 20:17:05
	***********************************/

	elsif(p_transaccion='CONTA_RSO_ELI')then

		begin

        select 	id_periodo,
        		id_depto_conta
        into
        v_id_periodo,
        v_id_deptor

        from conta.tregimen_simplificado
        where id_simplificado = v_parametros.id_simplificado;

        select r.estado
        into
        v_estado_gestion
        from conta.tperiodo_resolucion r
        where r.id_periodo = v_id_periodo and r.id_depto = v_id_deptor ;

          IF v_estado_gestion = 'cerrado' THEN
        	RAISE EXCEPTION '%','PERIODO CERRADO';
      	  END IF;
			--Sentencia de la eliminacion
			delete from conta.tregimen_simplificado
            where id_simplificado=v_parametros.id_simplificado;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Regimen Simplificado  eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_simplificado',v_parametros.id_simplificado::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;
    /*********************************
 	#TRANSACCION:  'CONTA_REV_IME'
 	#DESCRIPCION:	Control revision
 	#AUTOR:		MMV
 	#FECHA:		14-06-2017
	***********************************/
	elsif (p_transaccion='CONTA_REV_IME')then

        begin

            select co.revisado
            		into
                    v_revisado
            from conta.tregimen_simplificado co
			where co.id_simplificado = v_parametros.id_simplificado;

            if v_revisado = 'si' then
            update conta.tregimen_simplificado set
            revisado = 'no'
            where id_simplificado = v_parametros.id_simplificado;
            end if;
            if v_revisado = 'no' then
            update conta.tregimen_simplificado set
            revisado = 'si'
            where id_simplificado = v_parametros.id_simplificado;
            end if;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Revision con exito (id_simplificado'||v_parametros.id_simplificado||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_simplificado',v_parametros.id_simplificado::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;
/*********************************
 #TRANSACCION: 'CONTA_RSO_IMP'
 #DESCRIPCION:	Importacion de archivo txt
 #AUTOR:		MMV
 #FECHA:		20-06-2017 20:17:02
***********************************/

  ELSIF (p_transaccion='CONTA_RSO_IMP')THEN

      BEGIN
        FOR v_registros_json IN (SELECT *
                                 FROM json_populate_recordset(NULL :: conta.json_regimen_simplificado,
                                                              v_parametros.arra_json :: JSON)) LOOP


          --verificamos la gestion si esta abierta
		select r.estado
          into v_estado_gestion
          from conta.tperiodo_resolucion r
          where r.id_periodo = v_parametros.id_periodo and r.id_depto = v_parametros.id_depto_conta;

          IF v_estado_gestion = 'cerrado' THEN
        	RAISE EXCEPTION '%','PERIODO CERRADO';
      	  END IF;

		insert into conta.tregimen_simplificado(
			precio_unitario,
			descripcion,
			codigo_cliente,
			codigo_producto,
			estado_reg,
			importe_total,
			cantidad_producto,
			nit,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod,
            id_periodo,
            id_depto_conta
          	) values(
			v_registros_json.precio_unitario::numeric,
			v_registros_json.descripcion::varchar,
			v_registros_json.codigo_cliente::varchar,
			v_registros_json.codigo_producto::varchar,
			'activo',
			v_registros_json.importe_total::numeric,
			v_registros_json.cantidad_producto::numeric,
			v_registros_json.nit::varchar,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			v_parametros._id_usuario_ai,
			null,
			null,
			v_parametros.id_periodo,
            v_parametros.id_depto_conta
			);

      END LOOP;

        --Definicion de la respuesta
        v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', ' eliminado(a)');
        v_resp = pxp.f_agrega_clave(v_resp, 'id_simplificado', 10 :: VARCHAR);

        --Devuelve la respuesta
        RETURN v_resp;

      END;
   /*********************************
     #TRANSACCION: 'CONTA_RSO_ELITO'
     #DESCRIPCION:	Elimina todo los registros
     #AUTOR:		MMV
     #FECHA:		20-06-2017 20:17:02
    ***********************************/

  ELSIF (p_transaccion='CONTA_RSO_ELITO')
    THEN

      BEGIN


     	 select r.estado
          into v_estado_gestion
          from conta.tperiodo_resolucion r
          where r.id_periodo = v_parametros.id_periodo and r.id_depto = v_parametros.id_depto_conta;

          IF v_estado_gestion = 'cerrado' THEN
        	RAISE EXCEPTION '%','PERIODO CERRADO';
      	  END IF;



        DELETE FROM conta.tregimen_simplificado re
        WHERE re.id_periodo = v_parametros.id_periodo
              AND re.id_depto_conta = v_parametros.id_depto_conta
              AND re.revisado = 'no';

        --Definicion de la respuesta
        v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'eliminado(a)');

        --Devuelve la respuesta
        RETURN v_resp;

      END;
      /*********************************
       #TRANSACCION: 'CONTA_RSO_CLON'
       #DESCRIPCION:	clona de registros
       #AUTOR:		 MMV
       #FECHA:		20-06-2017 20:17:02
      ***********************************/

  ELSIF (p_transaccion='CONTA_RSO_CLON') THEN

      BEGIN


        --Sentencia de la eliminacion
		--raise exception 'llega %',v_parametros.id_simplificado;
        SELECT *
        INTO v_reccord
        FROM conta.tregimen_simplificado
        where id_simplificado = v_parametros.id_simplificado;


        /*IF v_reccord.revisado = 'si' THEN
          RAISE EXCEPTION '%','NO SE PUEDE CLONAR CUANDO ESTA REVISADO ';
        END IF;*/


        --verificamos la gestion si esta abierta


         select 	id_periodo,
        		id_depto_conta
        into
        v_id_periodo,
        v_id_deptor

        from conta.tregimen_simplificado
        where id_simplificado = v_parametros.id_simplificado;

        select r.estado
        into
        v_estado_gestion
        from conta.tperiodo_resolucion r
        where r.id_periodo = v_id_periodo and r.id_depto = v_id_deptor ;

          IF v_estado_gestion = 'cerrado' THEN
        	RAISE EXCEPTION '%','PERIODO CERRADO';
      	  END IF;
		insert into conta.tregimen_simplificado(
			precio_unitario,
			descripcion,
			codigo_cliente,
			codigo_producto,
			estado_reg,
			importe_total,
			cantidad_producto,
			nit,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod,
            revisado,
            id_periodo,
            id_depto_conta,
            registro,
            tipo_regimen_simplificado
          	) values(
			v_reccord.precio_unitario,
			v_reccord.descripcion,
			v_reccord.codigo_cliente,
			v_reccord.codigo_producto,
			'activo',
			v_reccord.importe_total,
			v_reccord.cantidad_producto,
			v_reccord.nit,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			v_parametros._id_usuario_ai,
			null,
			null,
            'no',
			v_reccord.id_periodo,
            v_reccord.id_depto_conta,
            'normal',
            'clonado'
			);


        --Definicion de la respuesta
        v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'clonado(a)');
        v_resp = pxp.f_agrega_clave(v_resp, 'id_simplificado', v_parametros.id_simplificado :: VARCHAR);

        --Devuelve la respuesta
        RETURN v_resp;

      END;

       /*********************************
       #TRANSACCION: 'CONTA_RSO_NEGR'
       #DESCRIPCION:	lista negra
       #AUTOR:			MMV
       #FECHA:			20-06-2017 20:17:02
      ***********************************/

  ELSIF (p_transaccion='CONTA_RSO_NEGR') THEN

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
        from conta.tregimen_simplificado
        where id_simplificado = v_parametros.id_simplificado;
        if v_registros.lista_negra = 'si'then
        update conta.tregimen_simplificado set
        lista_negra = 'no'
        where id_simplificado = v_parametros.id_simplificado;
        else
        update conta.tregimen_simplificado set
        lista_negra = 'si'
        where id_simplificado = v_parametros.id_simplificado;
  		end if;
        v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'agregado a la lista negra(a)');
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