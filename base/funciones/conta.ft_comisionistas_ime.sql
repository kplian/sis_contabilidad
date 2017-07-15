CREATE OR REPLACE FUNCTION conta.ft_comisionistas_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_comisionistas_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tcomisionistas'
 AUTOR: 		 (admin)
 FECHA:	        31-05-2017 20:17:02
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
	v_id_comisionista		integer;
    v_revisado				varchar;
    v_registros_json		record;
    v_estado_gestion		varchar;
    v_reccord				record;
    v_registros			 	record;
    v_id_periodo			integer;
    v_id_deptor				integer;

BEGIN

    v_nombre_funcion = 'conta.ft_comisionistas_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'CONTA_CMS_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		MMV
 	#FECHA:		31-05-2017 20:17:02
	***********************************/

	if(p_transaccion='CONTA_CMS_INS')then

    	  select r.estado
          into v_estado_gestion
          from conta.tperiodo_resolucion r
          where r.id_periodo = v_parametros.id_periodo and r.id_depto = v_parametros.id_depto_conta;

          IF v_estado_gestion = 'cerrado' THEN
        	RAISE EXCEPTION '%','PERIODO CERRADO';
      	  END IF;

        begin
        	--Sentencia de la insercion
        	insert into conta.tcomisionistas(
			nit_comisionista,
			nro_contrato,
			codigo_producto,
			estado_reg,
			descripcion_producto,
			cantidad_total_entregado,
			cantidad_total_vendido,
			precio_unitario,
			monto_total,
			monto_total_comision,
			id_usuario_reg,
			usuario_ai,
			fecha_reg,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod,
            id_periodo,
            id_depto_conta
          	) values(
			v_parametros.nit_comisionista,
			v_parametros.nro_contrato,
			v_parametros.codigo_producto,
			'activo',
			v_parametros.descripcion_producto,
			v_parametros.cantidad_total_entregado,
			v_parametros.cantidad_total_vendido,
			v_parametros.precio_unitario,
			v_parametros.monto_total,
			v_parametros.monto_total_comision,
			p_id_usuario,
			v_parametros._nombre_usuario_ai,
			now(),
			v_parametros._id_usuario_ai,
			null,
			null,
            v_parametros.id_periodo,
            v_parametros.id_depto_conta
			)RETURNING id_comisionista into v_id_comisionista;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Comisionistas  almacenado(a) con exito (id_comisionista'||v_id_comisionista||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_comisionista',v_id_comisionista::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'CONTA_CMS_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		MMV
 	#FECHA:		31-05-2017 20:17:02
	***********************************/

	elsif(p_transaccion='CONTA_CMS_MOD')then

		begin
          select r.estado
          into v_estado_gestion
          from conta.tperiodo_resolucion r
          where r.id_periodo = v_parametros.id_periodo and r.id_depto = v_parametros.id_depto_conta;

          IF v_estado_gestion = 'cerrado' THEN
        	RAISE EXCEPTION '%','PERIODO CERRADO';
      	  END IF;
			--Sentencia de la modificacion
			update conta.tcomisionistas set
			nit_comisionista = v_parametros.nit_comisionista,
			nro_contrato = v_parametros.nro_contrato,
			codigo_producto = v_parametros.codigo_producto,
			descripcion_producto = v_parametros.descripcion_producto,
			cantidad_total_entregado = v_parametros.cantidad_total_entregado,
			cantidad_total_vendido = v_parametros.cantidad_total_vendido,
			precio_unitario = v_parametros.precio_unitario,
			monto_total = v_parametros.monto_total,
			monto_total_comision = v_parametros.monto_total_comision,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_comisionista=v_parametros.id_comisionista;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Comisionistas  modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_comisionista',v_parametros.id_comisionista::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'CONTA_CMS_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		MMV
 	#FECHA:		20-06-2017 20:17:02
	***********************************/

	elsif(p_transaccion='CONTA_CMS_ELI')then

		begin
          select 	id_periodo,
        			id_depto_conta
                    into
                    v_id_periodo,
                    v_id_deptor
               	 	from conta.tcomisionistas
                	where id_comisionista = v_parametros.id_comisionista;

        select r.estado
        into
        v_estado_gestion
        from conta.tperiodo_resolucion r
        where r.id_periodo = v_id_periodo and r.id_depto = v_id_deptor ;

          IF v_estado_gestion = 'cerrado' THEN
        	RAISE EXCEPTION '%','PERIODO CERRADO';
      	  END IF;
			--Sentencia de la eliminacion
			delete from conta.tcomisionistas
            where id_comisionista=v_parametros.id_comisionista;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Comisionistas  eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_comisionista',v_parametros.id_comisionista::varchar);

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
            from conta.tcomisionistas co
			where co.id_comisionista = v_parametros.id_comisionista;

            if v_revisado = 'si' then
            update conta.tcomisionistas set
            revisado = 'no'
            where id_comisionista = v_parametros.id_comisionista;
            end if;
            if v_revisado = 'no' then
            update conta.tcomisionistas set
            revisado = 'si'
            where id_comisionista = v_parametros.id_comisionista;
            end if;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Revision con exito (id_comisionista'||v_parametros.id_comisionista||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_comisionista',v_parametros.id_comisionista::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;
        /*********************************
 #TRANSACCION: 'CONTA_REV_IMP'
 #DESCRIPCION:	Importacion de archivo txt
 #AUTOR:		MMV
 #FECHA:		20-06-2017 20:17:02
***********************************/

  ELSIF (p_transaccion='CONTA_REV_IMP')THEN

      BEGIN
        FOR v_registros_json IN (SELECT *
                                 FROM json_populate_recordset(NULL :: conta.json_comisionistas,
                                                              v_parametros.arra_json :: JSON)) LOOP


          --verificamos la gestion si esta abierta

          select r.estado
          into v_estado_gestion
          from conta.tperiodo_resolucion r
          where r.id_periodo = v_parametros.id_periodo and r.id_depto = v_parametros.id_depto_conta;

          IF v_estado_gestion = 'cerrado' THEN
        	RAISE EXCEPTION '%','PERIODO CERRADO';
      	  END IF;
		insert into conta.tcomisionistas(
			nit_comisionista,
			nro_contrato,
			codigo_producto,
			estado_reg,
			descripcion_producto,
			cantidad_total_entregado,
			cantidad_total_vendido,
			precio_unitario,
			monto_total,
			monto_total_comision,
			id_usuario_reg,
			usuario_ai,
			fecha_reg,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod,
            id_periodo,
            id_depto_conta
          	) values(
			v_registros_json.nit_comisionista::varchar,
			v_registros_json.nro_contrato::varchar,
			v_registros_json.codigo_producto::varchar,
			'activo',
			v_registros_json.descripcion_producto::varchar,
			v_registros_json.cantidad_total_entregado::numeric,
			v_registros_json.cantidad_total_vendido::numeric,
			v_registros_json.precio_unitario::numeric,
			v_registros_json.monto_total::numeric,
			v_registros_json.monto_total_comision::numeric,
			p_id_usuario,
			v_parametros._nombre_usuario_ai,
			now(),
			v_parametros._id_usuario_ai,
			null,
			null,
            v_parametros.id_periodo,
            v_parametros.id_depto_conta
			);

      END LOOP;

        --Definicion de la respuesta
        v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'eliminado(a)');
        v_resp = pxp.f_agrega_clave(v_resp, 'id_comisionista', 10 :: VARCHAR);

        --Devuelve la respuesta
        RETURN v_resp;

      END;
        /*********************************
     #TRANSACCION: 'CONTA_REV_ELITO'
     #DESCRIPCION:	Elimina todos los registros
     #AUTOR:		MMV
     #FECHA:		20-06-2017 20:17:02
    ***********************************/

  ELSIF (p_transaccion='CONTA_REV_ELITO')
    THEN

      BEGIN

          select r.estado
          into v_estado_gestion
          from conta.tperiodo_resolucion r
          where r.id_periodo = v_parametros.id_periodo and r.id_depto = v_parametros.id_depto_conta;

          IF v_estado_gestion = 'cerrado' THEN
        	RAISE EXCEPTION '%','PERIODO CERRADO';
      	  END IF;

        DELETE FROM conta.tcomisionistas cm
        WHERE cm.id_periodo = v_parametros.id_periodo
              AND cm.id_depto_conta = v_parametros.id_depto_conta
              AND cm.revisado = 'no';

        --Definicion de la respuesta
        v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'eliminado(a)');

        --Devuelve la respuesta
        RETURN v_resp;

      END;
	 /*********************************
       #TRANSACCION: 'CONTA_REV_CLON'
       #DESCRIPCION: clona de registros
       #AUTOR:		MMV
       #FECHA:		20-06-2017 20:17:02
      ***********************************/

  ELSIF (p_transaccion='CONTA_REV_CLON') THEN

      BEGIN


        --Sentencia de la eliminacion
		--raise exception 'llega %',v_parametros.id_simplificado;
        SELECT *
        INTO v_reccord
        FROM conta.tcomisionistas
        where id_comisionista = v_parametros.id_comisionista;

        /*IF v_reccord.revisado = 'si' THEN
          RAISE EXCEPTION '%','NO SE PUEDE CLONAR CUANDO ESTA REVISADO ';
        END IF;*/
           select 	id_periodo,
        			id_depto_conta
                    into
                    v_id_periodo,
                    v_id_deptor
               	 	from conta.tcomisionistas
                	where id_comisionista = v_parametros.id_comisionista;

        select r.estado
        into
        v_estado_gestion
        from conta.tperiodo_resolucion r
        where r.id_periodo = v_id_periodo and r.id_depto = v_id_deptor ;
        IF v_estado_gestion = 'cerrado' THEN
        	RAISE EXCEPTION '%','PERIODO CERRADO';
      	END IF;

		insert into conta.tcomisionistas(
			nit_comisionista,
			nro_contrato,
			codigo_producto,
			estado_reg,
			descripcion_producto,
			cantidad_total_entregado,
			cantidad_total_vendido,
			precio_unitario,
			monto_total,
			monto_total_comision,
			id_usuario_reg,
			usuario_ai,
			fecha_reg,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod,
            id_periodo,
            id_depto_conta,
            registro,
            tipo_comisionista
          	) values(
			v_reccord.nit_comisionista,
			v_reccord.nro_contrato,
			v_reccord.codigo_producto,
			'activo',
			v_reccord.descripcion_producto,
			v_reccord.cantidad_total_entregado,
			v_reccord.cantidad_total_vendido,
			v_reccord.precio_unitario,
			v_reccord.monto_total,
			v_reccord.monto_total_comision,
			p_id_usuario,
			v_parametros._nombre_usuario_ai,
			now(),
			v_parametros._id_usuario_ai,
			null,
			null,
            v_reccord.id_periodo,
            v_reccord.id_depto_conta,
			'normal',
            'clonado'
			);


        --Definicion de la respuesta
        v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'clonado(a)');
        v_resp = pxp.f_agrega_clave(v_resp, 'id_comisionista', v_parametros.id_comisionista :: VARCHAR);

        --Devuelve la respuesta
        RETURN v_resp;

      END;

      /*********************************
       #TRANSACCION: 'CONTA_REV_NEGR'
       #DESCRIPCION:  lista negra
       #AUTOR:		  MMV
       #FECHA:		  20-06-2017 20:17:02
      ***********************************/

  ELSIF (p_transaccion='CONTA_REV_NEGR') THEN

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
        from conta.tcomisionistas
        where id_comisionista = v_parametros.id_comisionista;

        if v_registros.lista_negra = 'si'then
        update conta.tcomisionistas set
        lista_negra = 'no'
        where id_comisionista = v_parametros.id_comisionista;
        else
        update conta.tcomisionistas set
        lista_negra = 'si'
        where id_comisionista = v_parametros.id_comisionista;
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