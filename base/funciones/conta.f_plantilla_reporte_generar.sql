CREATE OR REPLACE FUNCTION conta.f_plantilla_reporte_generar (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS SETOF record AS
$body$
DECLARE
  	v_consulta 			varchar;
    v_parametros  		record;
	v_nombre_funcion   	text;
    v_resp				varchar;
    v_gestion			integer;
    v_record			record;
    v_registros 		record;
    v_monto_recorrido   numeric;
    v_recorrer			record;
	v_monto_a			numeric;
	v_monto_b			numeric;
BEGIN
 v_nombre_funcion = 'conta.f_plantilla_reporte_generar';
  v_parametros = pxp.f_get_record(p_tabla);


    /*********************************
     #TRANSACCION:    'CONTA_ANRES_SEL'
     #DESCRIPCION:    Generar reportes
     #AUTOR:          MMV
     #FECHA:          08-07-2015
    ***********************************/

	IF(p_transaccion = 'CONTA_ANRES_SEL')then
		BEGIN
 	 --  1) Crear una tabla temporal con los datos que se utilizaran
       CREATE TEMPORARY TABLE temp_reporte(	  id serial,
                                              id_plantilla_reporte integer,
                                              codigo varchar,
                                              orden numeric,
                                              columna varchar,
                                              titulo_columna varchar,
                                              sudtitulo varchar,
                                              origen  varchar,
                                              gestion integer,
                                              periodo integer,
                                              importe numeric,
                                              titulo  varchar,
                                              glosa	  varchar
                                              ) ON COMMIT DROP;

        select gestion
        into v_gestion
        from param.tgestion
        where id_gestion = v_parametros.id_gestion;


	select  pr.id_plantilla_reporte,
    		pr.codigo,
            pr.nombre,
            pr.modalidad,
            pr.nombre_func,
            pr.posicion
            into
            v_record
    from conta.tplantilla_reporte pr
    where pr.id_plantilla_reporte = v_parametros.id_plantilla_reporte;


  if v_record.nombre_func != '' then
      EXECUTE ( 'select conta.' ||v_record.nombre_func ||
                    		'('||v_parametros.id_plantilla_reporte::integer||',
                    		'||v_parametros.id_gestion::integer||')');
  else

     if v_record.posicion = 'vertical'then

     if  not conta.f_resultado_planilla_reporte_vertical( v_parametros.id_plantilla_reporte,
                                                 	v_parametros.id_gestion,
                                                 	v_record.modalidad) THEN
           raise exception 'error al procesa la plantilla %', v_record.nombre;
     end if;

     else
  		if  not conta.f_resultado_planilla_reporte( v_parametros.id_plantilla_reporte,
                                                 	v_parametros.id_gestion,
                                                 	v_record.modalidad) THEN
           raise exception 'error al procesa la plantilla %', v_record.nombre;
     	end if;
     end if;
  end if;

    FOR v_registros in (select 	id,
                                codigo,
                                orden,
                                columna,
                                titulo_columna,
                                sudtitulo,
                                gestion,
                                periodo,
                                importe,
                                titulo,
                                glosa
                                from temp_reporte
                                where codigo != ''
                                order by orden, periodo)LOOP
    		RETURN NEXT v_registros;
    END LOOP;
    END;
    /*********************************
     #TRANSACCION:    'CONTA_ANZ_SEL'
     #DESCRIPCION:    Generar reportes
     #AUTOR:          MMV
     #FECHA:          08-07-2015
    ***********************************/

	ELSIF(p_transaccion = 'CONTA_ANZ_SEL')then
    BEGIN

        ---  raise exception '-->  %',v_id_plantilla;
             CREATE TEMPORARY TABLE temporal( codigo_columna varchar,
                                              ordern integer,
                                              columna varchar,
                                              titulo varchar,
            							      monto_a numeric,
                                              monto_b numeric,
                                              monto_c numeric,
                                              monto_d numeric,
                                              monto_e numeric )ON COMMIT DROP;


    FOR v_recorrer in (	select 	dr.codigo_columna,
                                dr.order_fila,
                                dr.nombre_columna,
                                dr.columna,
                                dr.operacion,
                                dr.origen,
                                dr.concepto,
                                dr.partida,
                                dr.origen2,
                                dr.concepto2,
                                dr.tipo,
                                dr.calculo
                        from conta.tplantilla_det_reporte dr
                        where dr.id_plantilla_reporte = v_parametros.id_plantilla_reporte
                        order by order_fila )LOOP


    IF v_recorrer.calculo = 'si' THEN


          CASE v_recorrer.operacion
            WHEN 'resta' THEN

            select conta.f_calcular_monto_nro_cuenta(v_recorrer.concepto,v_parametros.id_gestion,v_recorrer.origen,v_recorrer.partida)
                    into v_monto_a;
            select conta.f_calcular_monto_nro_cuenta(v_recorrer.concepto2,v_parametros.id_gestion,v_recorrer.origen2,v_recorrer.partida2)
                   into v_monto_b;
              if v_monto_a < 0 then
                    v_monto_recorrido =  -1 * v_monto_a - v_monto_b;
              else
                     v_monto_recorrido =  v_monto_a - v_monto_b;
              end if;

          END CASE;

		IF EXISTS ( select	1
                     from temporal
                     where codigo_columna = v_recorrer.codigo_columna )THEN

                  if v_recorrer.columna =  '2'  then
                          update temporal set
                          ordern = v_recorrer.order_fila,
                          columna =  v_recorrer.columna,
                          monto_b = v_monto_recorrido
                          where  codigo_columna = v_recorrer.codigo_columna;

                  elsif v_recorrer.columna =  '3' then

                      update temporal set
                          ordern = v_recorrer.order_fila,
                          columna =  v_recorrer.columna,
                          monto_c = v_monto_recorrido
                          where  codigo_columna = v_recorrer.codigo_columna;
                  elsif v_recorrer.columna =  '4' then

                  update temporal set
                          ordern = v_recorrer.order_fila,
                          columna =  v_recorrer.columna,
                          monto_d = v_monto_recorrido
                          where  codigo_columna = v_recorrer.codigo_columna;
                   elsif v_recorrer.columna =  '5' then

                  update temporal set
                          ordern = v_recorrer.order_fila,
                          columna =  v_recorrer.columna,
                          monto_e = v_monto_recorrido
                          where  codigo_columna = v_recorrer.codigo_columna;
                  end if;
                  if( v_recorrer.codigo_columna = 'ANE8')then
                 -- raise exception '--> %', v_recorrer.codigo_columna;
                      insert into temporal( codigo_columna,
                                                ordern,
                                                columna,
                                                titulo,
                                                monto_a,
                                                monto_b,
                                                monto_c,
                                                monto_d,
                                                monto_e)
                                                values (
                                                v_recorrer.codigo_columna,
                                                v_recorrer.order_fila,
                                                v_recorrer.columna,
                                                v_recorrer.nombre_columna,
                                                v_monto_recorrido,
                                                0,
                                                0,
                                                0,
                                                0);
                  end if;

          ELSE
         insert into temporal( codigo_columna,
                                          ordern,
                                          columna,
                                          titulo,
                                          monto_a,
                                          monto_b,
                                          monto_c,
                                          monto_d,
                                          monto_e)
                                          values (
                                          v_recorrer.codigo_columna,
                                          v_recorrer.order_fila,
                                          v_recorrer.columna,
                                          v_recorrer.nombre_columna,
                                          v_monto_recorrido,
                                          0,
                                          0,
                                          0,
                                          0);

     END IF;

    ELSE

         IF v_recorrer.tipo = 'titulo' THEN
         	insert into  temporal(  codigo_columna,
            			            ordern,
                                    columna,
                                    titulo)
                                    VALUES(
                                    v_recorrer.codigo_columna,
                                    v_recorrer.order_fila,
                                    v_recorrer.columna,
                                    v_recorrer.nombre_columna
                                    );
         ELSE

       select conta.f_calcular_monto_nro_cuenta(v_recorrer.concepto,v_parametros.id_gestion,v_recorrer.origen,v_recorrer.partida)
              into
            v_monto_recorrido;


         IF EXISTS ( select	1
                     from temporal
                     where codigo_columna = v_recorrer.codigo_columna )THEN

        	if v_recorrer.columna =  '2'  then
                    update temporal set
                    ordern = v_recorrer.order_fila,
                    columna =  v_recorrer.columna,
                    monto_b = v_monto_recorrido
                    where  codigo_columna = v_recorrer.codigo_columna;
            elsif v_recorrer.columna =  '3' then

         		update temporal set
                    ordern = v_recorrer.order_fila,
                    columna =  v_recorrer.columna,
                    monto_c = v_monto_recorrido
                    where  codigo_columna = v_recorrer.codigo_columna;
            elsif v_recorrer.columna =  '4' then

            update temporal set
                    ordern = v_recorrer.order_fila,
                    columna =  v_recorrer.columna,
                    monto_d = v_monto_recorrido
                    where  codigo_columna = v_recorrer.codigo_columna;
             elsif v_recorrer.columna =  '5' then

            update temporal set
                    ordern = v_recorrer.order_fila,
                    columna =  v_recorrer.columna,
                    monto_e = v_monto_recorrido
                    where  codigo_columna = v_recorrer.codigo_columna;
            end if;

          ELSE

         			insert into temporal( codigo_columna,
                                          ordern,
                                          columna,
                                          titulo,
                                          monto_a,
                                          monto_b,
                                          monto_c,
                                          monto_d,
                                          monto_e)
                                          values (
                                          v_recorrer.codigo_columna,
                                          v_recorrer.order_fila,
                                          v_recorrer.columna,
                                          v_recorrer.nombre_columna,
                                          v_monto_recorrido,
                                          0,
                                          0,
                                          0,
                                          0);

         	END IF;
         END IF;
   END IF;

    END LOOP;

                     FOR v_registros in (select codigo_columna,
                                                ordern,
                                                columna,
                                                titulo,
                                                monto_a,
                                                monto_b,
                                                monto_c,
                                                monto_d,
                                                monto_e
                                                from temporal
                                                  order by ordern)LOOP
    		RETURN NEXT v_registros;
    END LOOP;
    END;
       /*********************************
 	#TRANSACCION:  'CONTA_ANOC_SEL'
 	#DESCRIPCION:	Anexos 8
 	#AUTOR:		MMV
 	#FECHA:		8/23/2018
	***********************************/
       ELSIF(p_transaccion='CONTA_ANOC_SEL')THEN
      	 BEGIN



            CREATE TEMPORARY TABLE temporal( titulo varchar,
                                             nro_cuenta varchar,
                                             nombre_cuenta varchar,
                                             motivo varchar,
                                             normativa varchar,
                                             importe numeric,
                                             ordenar integer )ON COMMIT DROP;


             FOR v_recorrer in (select 	dr.codigo_columna,
                                        dr.order_fila,
                                        dr.columna,
                                        dr.origen,
                                        dr.formula,
                                        dr.concepto,
                                        dr.partida,
                                        dr.nombre_columna,
                                        dr.saldo_inical,
                                        dr.formulario,
                        				dr.codigo_formulario
                                from conta.tplantilla_det_reporte dr
                                where dr.id_plantilla_reporte = v_parametros.id_plantilla_reporte
                                order by order_fila ) LOOP
         select conta.f_calcular_monto_nro_cuenta(v_recorrer.concepto,v_parametros.id_gestion,v_recorrer.origen,'no')
              into
            v_monto_recorrido;

            	insert into temporal ( 	titulo,
                						nro_cuenta,
                                     	nombre_cuenta,
                                     	motivo,
                                        normativa,
                                     	importe,
                                     	ordenar)
                                        values(
                                        '',
                                        v_recorrer.concepto,
                                        v_recorrer.nombre_columna,
                                        '',
                                        '',
                                       v_monto_recorrido ,
                                        v_recorrer.order_fila
                                        );

             END LOOP;
              FOR v_registros in (select initcap(titulo)::varchar as titulo,
                                        nro_cuenta,
                                        nombre_cuenta,
                                        motivo,
                                        normativa,
                                        importe,
                                        ordenar
                                        from temporal
                                        order by ordenar,titulo)LOOP
    		RETURN NEXT v_registros;
    END LOOP;

       END;
       /*********************************
 	#TRANSACCION:  'CONTA_NINE_SEL'
 	#DESCRIPCION:	Anexos 9
 	#AUTOR:		MMV
 	#FECHA:		8/23/2018
	***********************************/
       ELSIF(p_transaccion='CONTA_NINE_SEL')THEN
      	 BEGIN



            CREATE TEMPORARY TABLE temporal( titulo varchar,
                                             nro_cuenta varchar,
                                             nombre_cuenta varchar,
                                             motivo varchar,
                                             normativa varchar,
                                             importe numeric,
                                             ordenar integer )ON COMMIT DROP;


             FOR v_recorrer in (select 	dr.codigo_columna,
                                        dr.order_fila,
                                        dr.columna,
                                        dr.origen,
                                        dr.formula,
                                        dr.concepto,
                                        dr.partida,
                                        dr.nombre_columna,
                                        dr.saldo_inical,
                                        dr.formulario,
                        				dr.codigo_formulario
                                from conta.tplantilla_det_reporte dr
                                where dr.id_plantilla_reporte = v_parametros.id_plantilla_reporte
                                order by order_fila ) LOOP


         select conta.f_calcular_monto_nro_cuenta(v_recorrer.concepto,v_parametros.id_gestion,v_recorrer.origen,'no')
              into
            v_monto_recorrido;

            	insert into temporal ( 	titulo,
                						nro_cuenta,
                                     	nombre_cuenta,
                                     	motivo,
                                        normativa,
                                     	importe,
                                     	ordenar)
                                        values(
                                        '',
                                        v_recorrer.concepto,
                                        v_recorrer.nombre_columna,
                                        '',
                                        '',
                                        v_monto_recorrido ,
                                        v_recorrer.order_fila
                                        );


             END LOOP;


                FOR v_registros in (select initcap(titulo)::varchar as titulo,
                                nro_cuenta,
                                nombre_cuenta,
                                motivo,
                                normativa,
                                importe,
                               	ordenar
            					from temporal
                            	order by ordenar,nro_cuenta)LOOP
    		RETURN NEXT v_registros;
    END LOOP;


       END;

    ELSE
        RAISE EXCEPTION 'Transaccion inexistente';
    END IF;


EXCEPTION
	WHEN OTHERS THEN
        v_resp='';
        v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
        v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
        v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
        RAISE EXCEPTION '%',v_resp;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100 ROWS 1000;