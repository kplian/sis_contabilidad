CREATE OR REPLACE FUNCTION conta.ft_persona_naturales_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_persona_naturales_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tpersona_naturales'
 AUTOR: 		 (admin)
 FECHA:	        31-05-2017 20:17:08
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
	v_id_persona_natural	integer;
    v_revisado				varchar;
    v_registros_json		record;
    v_estado_gestion		varchar;
    v_reccord				record;
    v_registros				record;
    v_id_periodo			integer;
    v_id_deptor				integer;

BEGIN

    v_nombre_funcion = 'conta.ft_persona_naturales_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'CONTA_PNS_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin
 	#FECHA:		31-05-2017 20:17:08
	***********************************/

	if(p_transaccion='CONTA_PNS_INS')then

        begin
          select r.estado
          into v_estado_gestion
          from conta.tperiodo_resolucion r
          where r.id_periodo = v_parametros.id_periodo and r.id_depto = v_parametros.id_depto_conta;

          IF v_estado_gestion = 'cerrado' THEN
        	RAISE EXCEPTION '%','PERIODO CERRADO';
      	  END IF;
        	--Sentencia de la insercion
        	insert into conta.tpersona_naturales(
			precio_unitario,
			descripcion,
			codigo_cliente,
			tipo_documento,
			codigo_producto,
			estado_reg,
			nombre,
			importe_total,
			nro_documeneto,
			cantidad_producto,
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
			v_parametros.tipo_documento,
			v_parametros.codigo_producto,
			'activo',
			v_parametros.nombre,
			v_parametros.importe_total,
			v_parametros.nro_documeneto,
			v_parametros.cantidad_producto,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			v_parametros._id_usuario_ai,
			null,
			null,
            v_parametros.id_periodo,
            v_parametros.id_depto_conta

			)RETURNING id_persona_natural into v_id_persona_natural;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Persona Naturales almacenado(a) con exito (id_persona_natural'||v_id_persona_natural||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_persona_natural',v_id_persona_natural::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'CONTA_PNS_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin
 	#FECHA:		31-05-2017 20:17:08
	***********************************/

	elsif(p_transaccion='CONTA_PNS_MOD')then

		begin
          select r.estado
          into v_estado_gestion
          from conta.tperiodo_resolucion r
          where r.id_periodo = v_parametros.id_periodo and r.id_depto = v_parametros.id_depto_conta;

          IF v_estado_gestion = 'cerrado' THEN
        	RAISE EXCEPTION '%','PERIODO CERRADO';
      	  END IF;
			--Sentencia de la modificacion
			update conta.tpersona_naturales set
			precio_unitario = v_parametros.precio_unitario,
			descripcion = v_parametros.descripcion,
			codigo_cliente = v_parametros.codigo_cliente,
			tipo_documento = v_parametros.tipo_documento,
			codigo_producto = v_parametros.codigo_producto,
			nombre = v_parametros.nombre,
			importe_total = v_parametros.importe_total,
			nro_documeneto = v_parametros.nro_documeneto,
			cantidad_producto = v_parametros.cantidad_producto,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai,
            id_periodo = v_parametros.id_periodo,
            id_depto_conta = v_parametros.id_depto_conta
			where id_persona_natural=v_parametros.id_persona_natural;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Persona Naturales modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_persona_natural',v_parametros.id_persona_natural::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'CONTA_PNS_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin
 	#FECHA:		31-05-2017 20:17:08
	***********************************/

	elsif(p_transaccion='CONTA_PNS_ELI')then

		begin
         select 	id_periodo,
        		    id_depto_conta
        into
        v_id_periodo,
        v_id_deptor

        from conta.tpersona_naturales
        where id_persona_natural = v_parametros.id_persona_natural;

        select r.estado
        into
        v_estado_gestion
        from conta.tperiodo_resolucion r
        where r.id_periodo = v_id_periodo and r.id_depto = v_id_deptor ;

          IF v_estado_gestion = 'cerrado' THEN
        	RAISE EXCEPTION '%','PERIODO CERRADO';
      	  END IF;
			--Sentencia de la eliminacion
			delete from conta.tpersona_naturales
            where id_persona_natural=v_parametros.id_persona_natural;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Persona Naturales eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_persona_natural',v_parametros.id_persona_natural::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;
        /*********************************
 	#TRANSACCION:  'CONTA_PNS_IME'
 	#DESCRIPCION:	Control revision
 	#AUTOR:		MMV
 	#FECHA:		14-06-2017
	***********************************/
	elsif (p_transaccion='CONTA_PNS_IME')then

        begin

            select co.revisado
            		into
                    v_revisado
            from conta.tpersona_naturales co
			where co.id_persona_natural = v_parametros.id_persona_natural;

            if v_revisado = 'si' then
            update conta.tpersona_naturales set
            revisado = 'no'
            where id_persona_natural = v_parametros.id_persona_natural;
            end if;
            if v_revisado = 'no' then
            update conta.tpersona_naturales set
            revisado = 'si'
            where id_persona_natural = v_parametros.id_persona_natural;
            end if;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Revision con exito (id_persona_natural'||v_parametros.id_persona_natural||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_persona_natural',v_parametros.id_persona_natural::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;
/*********************************
 #TRANSACCION: 'CONTA_PNS_IMP'
 #DESCRIPCION:	Importacion de archivo txt
 #AUTOR:		MMV
 #FECHA:		20-06-2017 20:17:02
***********************************/

  ELSIF (p_transaccion='CONTA_PNS_IMP')THEN

      BEGIN
        FOR v_registros_json IN (SELECT *
                                 FROM json_populate_recordset(NULL :: conta.json_persona_natural,
                                                              v_parametros.arra_json :: JSON)) LOOP


          --verificamos la gestion si esta abierta

          select r.estado
          into v_estado_gestion
          from conta.tperiodo_resolucion r
          where r.id_periodo = v_parametros.id_periodo and r.id_depto = v_parametros.id_depto_conta;

          IF v_estado_gestion = 'cerrado' THEN
        	RAISE EXCEPTION '%','PERIODO CERRADO';
      	  END IF;

			insert into conta.tpersona_naturales(
            codigo_cliente,
            tipo_documento,
            nro_documeneto,
            nombre,
            codigo_producto,
            descripcion,
            cantidad_producto,
			precio_unitario,
			importe_total,

			estado_reg,
            id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod,
            id_periodo,
            id_depto_conta
          	) values(
            v_registros_json.codigo_cliente::varchar,
            v_registros_json.tipo_documento::varchar,
            v_registros_json.nro_documeneto::varchar,
            v_registros_json.nombre::varchar,
            v_registros_json.codigo_producto::varchar,
            v_registros_json.descripcion::varchar,
            v_registros_json.cantidad_producto::numeric,
			v_registros_json.precio_unitario::numeric,
			v_registros_json.importe_total::numeric,
			'activo',
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
        v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'bancarizacion eliminado(a)');
        v_resp = pxp.f_agrega_clave(v_resp, 'id_persona_natural', 10 :: VARCHAR);

        --Devuelve la respuesta
        RETURN v_resp;

      END;
  	/*********************************
     #TRANSACCION: 'CONTA_PNS_ELITO'
     #DESCRIPCION:	Elimina todo los registro
     #AUTOR:		MMV
     #FECHA:		20-06-2017 20:17:02
    ***********************************/

  ELSIF (p_transaccion='CONTA_PNS_ELITO')
    THEN

      BEGIN

        select r.estado
          into v_estado_gestion
          from conta.tperiodo_resolucion r
          where r.id_periodo = v_parametros.id_periodo and r.id_depto = v_parametros.id_depto_conta;

          IF v_estado_gestion = 'cerrado' THEN
        	RAISE EXCEPTION '%','PERIODO CERRADO';
      	  END IF;

        DELETE FROM conta.tpersona_naturales cm
        WHERE cm.id_periodo = v_parametros.id_periodo
              AND cm.id_depto_conta = v_parametros.id_depto_conta
              AND cm.revisado = 'no';

        --Definicion de la respuesta
        v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'eliminado(a)');

        --Devuelve la respuesta
        RETURN v_resp;

      END;
	 /*********************************
       #TRANSACCION: 'CONTA_PNS_CLON'
       #DESCRIPCION:  clona de registros
       #AUTOR:		  MMV
       #FECHA:		  20-06-2017 20:17:02
      ***********************************/

  ELSIF (p_transaccion='CONTA_PNS_CLON') THEN

      BEGIN


        --Sentencia de la eliminacion
		--raise exception 'llega %',v_parametros.id_simplificado;
        SELECT *
        INTO v_reccord
        FROM conta.tpersona_naturales
        where id_persona_natural = v_parametros.id_persona_natural;

        /*IF v_reccord.revisado = 'si' THEN
          RAISE EXCEPTION '%','NO SE PUEDE CLONAR CUANDO ESTA REVISADO ';
        END IF;*/

            select 	id_periodo,
        		    id_depto_conta
        into
        v_id_periodo,
        v_id_deptor

        from conta.tpersona_naturales
        where id_persona_natural = v_parametros.id_persona_natural;

        select r.estado
        into
        v_estado_gestion
        from conta.tperiodo_resolucion r
        where r.id_periodo = v_id_periodo and r.id_depto = v_id_deptor ;

          IF v_estado_gestion = 'cerrado' THEN
        	RAISE EXCEPTION '%','PERIODO CERRADO';
      	  END IF;

		insert into conta.tpersona_naturales(
			precio_unitario,
			descripcion,
			codigo_cliente,
			tipo_documento,
			codigo_producto,
			estado_reg,
			nombre,
			importe_total,
			nro_documeneto,
			cantidad_producto,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod,
            id_periodo,
            id_depto_conta,
            registro,
            tipo_persona_natural
          	) values(
			v_reccord.precio_unitario,
			v_reccord.descripcion,
			v_reccord.codigo_cliente,
			v_reccord.tipo_documento,
			v_reccord.codigo_producto,
			'activo',
			v_reccord.nombre,
			v_reccord.importe_total,
			v_reccord.nro_documeneto,
			v_reccord.cantidad_producto,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			v_parametros._id_usuario_ai,
			null,
			null,
            v_reccord.id_periodo,
            v_reccord.id_depto_conta,
            'normal',
            'clonado'
			);


        --Definicion de la respuesta
        v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', ' clonado(a)');
        v_resp = pxp.f_agrega_clave(v_resp, 'id_persona_natural', v_parametros.id_persona_natural :: VARCHAR);

        --Devuelve la respuesta
        RETURN v_resp;

      END;
      /*********************************
       #TRANSACCION: 'CONTA_PNS_NEGR'
       #DESCRIPCION:	lista negra
       #AUTOR:			MMV
       #FECHA:		20-06-2017 20:17:02
      ***********************************/

  ELSIF (p_transaccion='CONTA_PNS_NEGR') THEN

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
        from conta.tpersona_naturales
        where id_persona_natural = v_parametros.id_persona_natural;

        if v_registros.lista_negra = 'si'then
        update conta.tpersona_naturales set
        lista_negra = 'no'
        where id_persona_natural = v_parametros.id_persona_natural;
        else
        update conta.tpersona_naturales set
        lista_negra = 'si'
        where id_persona_natural = v_parametros.id_persona_natural;
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