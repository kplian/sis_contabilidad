CREATE OR REPLACE FUNCTION "conta"."ft_plan_pago_documento_airbp_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_plan_pago_documento_airbp_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tplan_pago_documento_airbp'
 AUTOR: 		 (admin)
 FECHA:	        30-01-2017 13:13:21
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
	v_id_plan_pago_documento_airbp	integer;

	v_plan_pago RECORD;
	v_host VARCHAR;
	v_record_documentos_airbp RECORD;
	v_gestion RECORD;
	v_consulta VARCHAR;
	v_monto_acumulado_con_facturas NUMERIC(10,2);
	v_diferencia NUMERIC(10,2);
	v_monto_usado_de_factura NUMERIC(10,2);
	v_usar VARCHAR;

	v_ids_documentos VARCHAR;
BEGIN

    v_nombre_funcion = 'conta.ft_plan_pago_documento_airbp_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_PPDAIRBP_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		30-01-2017 13:13:21
	***********************************/

	if(p_transaccion='CONTA_PPDAIRBP_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into conta.tplan_pago_documento_airbp(
			monto_fac,
			monto_usado,
			id_documento,
			monto_disponible,
			estado_reg,
			usar,
			id_plan_pago,
			id_usuario_ai,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.monto_fac,
			v_parametros.monto_usado,
			v_parametros.id_documento,
			v_parametros.monto_disponible,
			'activo',
			v_parametros.usar,
			v_parametros.id_plan_pago,
			v_parametros._id_usuario_ai,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_plan_pago_documento_airbp into v_id_plan_pago_documento_airbp;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Plan Pago Documento Airbp almacenado(a) con exito (id_plan_pago_documento_airbp'||v_id_plan_pago_documento_airbp||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_plan_pago_documento_airbp',v_id_plan_pago_documento_airbp::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_PPDAIRBP_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		30-01-2017 13:13:21
	***********************************/

	elsif(p_transaccion='CONTA_PPDAIRBP_MOD')then

		begin
			--Sentencia de la modificacion
			update conta.tplan_pago_documento_airbp set
			monto_fac = v_parametros.monto_fac,
			monto_usado = v_parametros.monto_usado,
			id_documento = v_parametros.id_documento,
			monto_disponible = v_parametros.monto_disponible,
			usar = v_parametros.usar,
			id_plan_pago = v_parametros.id_plan_pago,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_plan_pago_documento_airbp=v_parametros.id_plan_pago_documento_airbp;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Plan Pago Documento Airbp modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_plan_pago_documento_airbp',v_parametros.id_plan_pago_documento_airbp::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_PPDAIRBP_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		30-01-2017 13:13:21
	***********************************/

	elsif(p_transaccion='CONTA_PPDAIRBP_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tplan_pago_documento_airbp
            where id_plan_pago_documento_airbp=v_parametros.id_plan_pago_documento_airbp;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Plan Pago Documento Airbp eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_plan_pago_documento_airbp',v_parametros.id_plan_pago_documento_airbp::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'CONTA_PPDAIRBP_REL'
 	#DESCRIPCION:	registros
 	#AUTOR:		admin
 	#FECHA:		30-01-2017 13:13:21
	***********************************/

	elsif(p_transaccion='CONTA_PPDAIRBP_REL')then

		begin


			select * into v_gestion from param.tgestion where gestion = v_parametros.gestion;


			v_host:='dbname=dbendesis host=192.168.100.30 user=ende_pxp password=ende_pxp';


			FOR v_plan_pago in (select plan.fecha_tentativa,
														plan.nro_cuota,
														obliga.num_tramite,
														plan.id_int_comprobante,
														obliga.fecha,
														plan.monto,
			plan.id_plan_pago
													from tes.tplan_pago plan
														INNER JOIN tes.tobligacion_pago obliga on obliga.id_obligacion_pago = plan.id_obligacion_pago
														inner join param.tproveedor provee on  provee.id_proveedor = obliga.id_proveedor
													where plan.estado = 'anticipado'
																and provee.id_proveedor = 398
																AND obliga.fecha >= v_gestion.fecha_ini::DATE
																AND obliga.fecha <= v_gestion.fecha_fin::DATE
													ORDER BY plan.nro_cuota asc)LOOP




				v_consulta:= ' WITH documentos AS (
						SELECT * FROM dblink(''' || v_host || ''',
				''
				select facdet.id_factura_detalle,
								documento.id_documento,
								documento.fecha_documento,
								documento.nro_autorizacion,
								documento.nro_documento,
								documento.nro_nit,
								docval.importe_total
				from sci.tct_factura_detalle facdet
				INNER JOIN sci.tct_documento documento on documento.id_documento = facdet.id_documento
					INNER JOIN sci.tct_documento_valor docval on docval.id_documento = documento.id_documento
				WHERE documento.fecha_documento >= '''''||v_gestion.fecha_ini||'''''::DATE AND
							documento.fecha_documento <= '''''||v_gestion.fecha_fin||'''''::DATE
					and docval.id_moneda = 1
				ORDER BY documento.fecha_documento ASC,facdet.id_factura_detalle;


				 ''
								 ) AS d (
								 id_factura_detalle integer,
									id_documento integer,
									fecha_documento DATE,
									nro_autorizacion VARCHAR(20),
									nro_documento bigint,
									nro_nit VARCHAR(30),
									importe_total numeric(10,2)

									) )';


				--documentos para no usar por que ya estan relacionados con un pago
				SELECT pxp.list(id_documento::VARCHAR)
				INTO v_ids_documentos
				from conta.tplan_pago_documento_airbp
					WHERE usar = 'no';



				v_consulta:= v_consulta || 'select
									doc.id_factura_detalle,
									doc.id_documento,
									doc.fecha_documento,
									doc.nro_autorizacion ,
									doc.nro_documento ,
									doc.nro_nit ,
									doc.importe_total,
									 relacionado.usar,
									 relacionado.monto_disponible
									 from documentos doc
				 left join conta.tplan_pago_documento_airbp relacionado on relacionado.id_documento = doc.id_documento
				  ';

				IF v_ids_documentos is not NULL THEN
					v_consulta = v_consulta || ' where doc.id_documento not in('||v_ids_documentos||') ';
				END IF;

				--RAISE EXCEPTION '%',v_consulta;


				v_monto_acumulado_con_facturas = 0;
				v_diferencia = 0;
				v_monto_usado_de_factura = 0;
				v_usar = 'no';


				FOR v_record_documentos_airbp IN EXECUTE v_consulta LOOP


					RAISE EXCEPTION '%',v_record_documentos_airbp;


					-- cuando es la primera cuota se debe tomar en cuenta que esto es
					-- saldo de la gestion anterior
					IF v_plan_pago.nro_cuota = 0 or v_plan_pago.nro_cuota = 1 THEN
					END IF;



					-- v_plan_pago.monto es el monto total del plan se debe relacionar las facturas
					--e igualar a este monto

					--7000000.00

					IF v_record_documentos_airbp.usar = 'si' THEN
						v_record_documentos_airbp.importe_total = v_record_documentos_airbp.monto_disponible;
					END IF;



					IF v_plan_pago.monto > v_monto_acumulado_con_facturas THEN
						--v_record_documentos_airbp.importe_total es importe de la factura
						v_monto_acumulado_con_facturas = v_monto_acumulado_con_facturas + v_record_documentos_airbp.importe_total;

						v_monto_usado_de_factura = v_record_documentos_airbp.importe_total;

						--preguntamos otra vez por si ya igualo o esta mayor
						IF v_plan_pago.monto <= v_monto_acumulado_con_facturas THEN

							-- aca termina de la relacionar facturas por que ya esta igual o mayor
							--sacamos la diferencia que quedo de una factura
							v_diferencia = v_monto_acumulado_con_facturas - v_plan_pago.monto;

							--sacamos cuanto se esta relacionando de una factura por que esta factura se divide el restante para el siguiente
							v_monto_usado_de_factura = v_record_documentos_airbp.importe_total - v_diferencia;

							v_usar = 'si';

						END IF;

						insert into conta.tplan_pago_documento_airbp(
							monto_fac,
							monto_usado,
							id_documento,
							monto_disponible,
							estado_reg,
							usar,
							id_plan_pago,
							id_usuario_ai,
							id_usuario_reg,
							fecha_reg,
							usuario_ai,
							id_usuario_mod,
							fecha_mod
						) values(
							v_record_documentos_airbp.importe_total,
							v_monto_usado_de_factura,
							v_record_documentos_airbp.id_documento,
							v_diferencia,
							'activo',
							v_usar,
							v_plan_pago.id_plan_pago,
							v_parametros._id_usuario_ai,
							p_id_usuario,
							now(),
							v_parametros._nombre_usuario_ai,
							null,
							null



						)RETURNING id_plan_pago_documento_airbp into v_id_plan_pago_documento_airbp;





						ELSE




					END IF;







				END LOOP;



			END LOOP;


			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Plan Pago Documento Airbp eliminado(a)');
			v_resp = pxp.f_agrega_clave(v_resp,'id_plan_pago_documento_airbp',1::varchar);

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
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;
ALTER FUNCTION "conta"."ft_plan_pago_documento_airbp_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
