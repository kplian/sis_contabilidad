--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_int_transaccion_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_int_transaccion_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tint_transaccion'
 AUTOR: 		 (admin)
 FECHA:	        01-09-2013 18:10:12
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
    v_registros				record;
    v_registros_trans		record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_int_transaccion	integer;
    
     v_importe_debe  		numeric;
     v_importe_haber 		numeric;    
     v_importe_debe_mb 		numeric;
     v_importe_haber_mb		numeric;
     v_id_moneda_base		integer;
     v_tc_1 				numeric;
     v_tc_2 				numeric;
     v_monto 				numeric;
     v_factor				numeric;
     v_conta_ejecucion_igual_pres_conta		varchar;
     v_monto_recurso 						numeric;
     v_monto_gasto 							numeric;
 
BEGIN

    v_nombre_funcion = 'conta.ft_int_transaccion_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_INTRANSA_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		01-09-2013 18:10:12
	***********************************/

	if(p_transaccion='CONTA_INTRANSA_INS')then
					
        begin
        
             
             select
               cbt.id_moneda,
               cbt.id_moneda_tri,
               cbt.tipo_cambio,
               cbt.tipo_cambio_2,
               cbt.fecha
             into
               v_registros
             from conta.tint_comprobante cbt
             where  cbt.id_int_comprobante = v_parametros.id_int_comprobante;
        	----------------------------------------------
        	--  si la moneda es diferente de la base
        	----------------------------------------------
            
             -- Obtener la moneda base
             v_id_moneda_base = param.f_get_moneda_base();
            
             v_importe_debe  =  v_parametros.importe_debe;
             v_importe_haber = v_parametros.importe_haber;          
           
            
            --si el tipo de cambia varia a de la cabecara marcamos la cabecera, 
            -- para que no actulice automaricamente las transacciones si es modificada
            IF  v_registros.tipo_cambio !=  v_parametros.tipo_cambio or v_registros.tipo_cambio_2 !=  v_parametros.tipo_cambio_2 THEN
              
              update conta.tint_comprobante set
                sw_tipo_cambio = 'si'
              where id_int_comprobante =  v_parametros.id_int_comprobante;
            
            END IF;
            
            --verifica si presupeusto y iguala con la contabilidad
            
            v_conta_ejecucion_igual_pres_conta = pxp.f_get_variable_global('conta_ejecucion_igual_pres_conta');
        
            IF v_conta_ejecucion_igual_pres_conta  = 'no' THEN            
               v_monto_gasto = v_parametros.importe_gasto;
               v_monto_recurso = v_parametros.importe_recurso;
            ELSE
               v_monto_gasto = v_parametros.importe_debe;
               v_monto_recurso = v_parametros.importe_haber;
            END IF;
            
          
         
       
        	-----------------------------
        	--REGISTRO DE LA TRANSACCIÓN
        	-----------------------------
        	insert into conta.tint_transaccion(
                id_partida,
                id_centro_costo,
                estado_reg,
                id_cuenta,
                glosa,
                id_int_comprobante,
                id_auxiliar,
                importe_debe,
                importe_haber,
                importe_gasto,
                importe_recurso,
                id_usuario_reg,
                fecha_reg,
                id_usuario_mod,
                fecha_mod,
                id_orden_trabajo,
                tipo_cambio,
                tipo_cambio_2,
                id_moneda,
                id_moneda_tri,
                id_suborden
                
          	) values(
                v_parametros.id_partida,
                v_parametros.id_centro_costo,
                'activo',
                v_parametros.id_cuenta,
                v_parametros.glosa,
                v_parametros.id_int_comprobante,
                v_parametros.id_auxiliar,
                v_parametros.importe_debe,
                v_parametros.importe_haber,
                v_monto_gasto,
                v_monto_recurso,
               
                p_id_usuario,
                now(),
                null,
                null,
                v_parametros.id_orden_trabajo,
                v_parametros.tipo_cambio,
                v_parametros.tipo_cambio_2,
                v_registros.id_moneda,
                v_registros.id_moneda_tri,
                v_parametros.id_suborden
			)RETURNING id_int_transaccion into v_id_int_transaccion;
            
            
            
            -- calcular moneda base y triangulacion
            
            PERFORM  conta.f_calcular_monedas_transaccion(v_id_int_transaccion);
            
            -- procesar las trasaaciones (con diversos propostios, ejm validar  cuentas bancarias)
            IF not conta.f_int_trans_procesar(v_parametros.id_int_comprobante) THEN
              raise exception 'Error al procesar transacciones';
            END IF;
            
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Transacción almacenado(a) con exito (id_int_transaccion'||v_id_int_transaccion||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_int_transaccion',v_id_int_transaccion::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_INTRANSA_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		01-09-2013 18:10:12
	***********************************/

	elsif(p_transaccion='CONTA_INTRANSA_MOD')then

		begin
        
              select
               cbt.id_moneda,
               cbt.tipo_cambio,
               cbt.fecha,
               cbt.id_moneda_tri,
               cbt.tipo_cambio_2,
               cbt.id_moneda
             into
               v_registros
             from conta.tint_comprobante cbt
             where  cbt.id_int_comprobante = v_parametros.id_int_comprobante;
             
            -- si el tipo de cambia varia a de la cabecara marcamos la cabecera, 
            -- para que no actulice automaricamente las transacciones si es modificada
            IF  v_registros.tipo_cambio !=  v_parametros.tipo_cambio or v_registros.tipo_cambio_2 !=  v_parametros.tipo_cambio_2 THEN
              
              update conta.tint_comprobante set
                sw_tipo_cambio = 'si'
              where id_int_comprobante =  v_parametros.id_int_comprobante;
            
            END IF;
            
        	------------
        	--VALIDACIONES
        	---------------
        	--VerIfica el estado
        	if not exists(select 1 from conta.tint_transaccion tra
			        	inner join conta.tint_comprobante cbte
			        	on cbte.id_int_comprobante = tra.id_int_comprobante
			        	where tra.id_int_transaccion = v_parametros.id_int_transaccion
        				and cbte.estado_reg = 'borrador'  and cbte.sw_editable = 'si') then
        		raise exception 'Modificación no realizada: el comprobante no está en estado Borrador o no es editable';
        	end if;
            
            
            
           ------------------------------------------------------------------------------ 
           -- si tiene relacion de devengado se limina la relacion
           --------------------------------------------------------------------------------- 
            FOR v_registros in (
                                    select 
                                       rd.id_int_rel_devengado,
                                       rd.monto_pago 
                                    from conta.tint_rel_devengado rd
                                    where   (rd.id_int_transaccion_dev = v_parametros.id_int_transaccion
                                         or rd.id_int_transaccion_pag = v_parametros.id_int_transaccion)
                                         and rd.estado_reg = 'activo' )LOOP
                      DELETE FROM 
                        conta.tint_rel_devengado 
                      WHERE id_int_rel_devengado = v_registros.id_int_rel_devengado;
            END LOOP;
            
            
            v_conta_ejecucion_igual_pres_conta = pxp.f_get_variable_global('conta_ejecucion_igual_pres_conta');
        
            IF v_conta_ejecucion_igual_pres_conta  = 'no' THEN            
               v_monto_gasto = v_parametros.importe_gasto;
               v_monto_recurso = v_parametros.importe_recurso;
            ELSE
               v_monto_gasto = v_parametros.importe_debe;
               v_monto_recurso = v_parametros.importe_haber;
            END IF;
            
            
            
			--------------------------------
			--MODIFICACION DE LA TRANSACCION
			--------------------------------
			update conta.tint_transaccion set
              id_partida = v_parametros.id_partida,
              id_centro_costo = v_parametros.id_centro_costo,
              id_orden_trabajo = v_parametros.id_orden_trabajo,
              id_cuenta = v_parametros.id_cuenta,
              glosa = v_parametros.glosa,
              id_int_comprobante = v_parametros.id_int_comprobante,
              id_auxiliar = v_parametros.id_auxiliar,
              id_usuario_mod = p_id_usuario,
              fecha_mod = now(),
              tipo_cambio = v_parametros.tipo_cambio,
              tipo_cambio_2 = v_parametros.tipo_cambio_2,
              importe_debe = v_parametros.importe_debe,
              importe_haber = v_parametros.importe_haber,
              importe_gasto = v_monto_gasto,
              importe_recurso = v_monto_recurso,
              id_suborden = v_parametros.id_suborden
             
			where id_int_transaccion = v_parametros.id_int_transaccion;
            
            
             -- calcular moneda base y triangulacion
            
            PERFORM  conta.f_calcular_monedas_transaccion(v_parametros.id_int_transaccion);
            
            -- procesar las trasaaciones (con diversos propostios, ejm validar  cuentas bancarias)
            IF not conta.f_int_trans_procesar(v_parametros.id_int_comprobante) THEN
              raise exception 'Error al procesar transacciones';
            END IF;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Transacción modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_int_transaccion',v_parametros.id_int_transaccion::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;
        
        
    /*********************************    
 	#TRANSACCION:  'CONTA_SAVTRABAN_MOD'
 	#DESCRIPCION:	actuliza datos bancarios para la transaccion
 	#AUTOR:		rensi (kplian)	
 	#FECHA:		04-08-2015 18:10:12
	***********************************/

	elsif(p_transaccion='CONTA_SAVTRABAN_MOD')then

		begin
        
		
			--------------------------------
			--MODIFICACION DE LA TRANSACCION
			--------------------------------
			update conta.tint_transaccion set
             nombre_cheque_trans = v_parametros.nombre_cheque_trans,
             forma_pago = v_parametros.forma_pago,
             nro_cheque = v_parametros.nro_cheque,
             nro_cuenta_bancaria_trans = v_parametros.nro_cuenta_bancaria
			where id_int_transaccion=v_parametros.id_int_transaccion;
            
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','datos bancarios actualizados para la transaccion del cbte)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_int_transaccion',v_parametros.id_int_transaccion::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_INTRANSA_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		01-09-2013 18:10:12
	***********************************/

	elsif(p_transaccion='CONTA_INTRANSA_ELI')then

		begin
		
			---------------
        	--VALIDACIONES
        	---------------
        	--VerIfica el estado, solamente puede eliminarse cuando esté en estao borrador
        	if not exists(select 1 from conta.tint_transaccion tra
			        	inner join conta.tint_comprobante cbte
			        	on cbte.id_int_comprobante = tra.id_int_comprobante
			        	where tra.id_int_transaccion = v_parametros.id_int_transaccion
        				and cbte.estado_reg = 'borrador' and cbte.sw_editable = 'si') then
        		raise exception 'Eliminación no realizada: el comprobante no está en estado Borrador o no es editable';
        	end if;
            
          
            --si tiene relacion de devengado es necesario eliminarlas
            
            FOR v_registros in (
                                    select 
                                       rd.id_int_rel_devengado 
                                    from conta.tint_rel_devengado rd
                                    where   (rd.id_int_transaccion_dev = v_parametros.id_int_transaccion
                                         or rd.id_int_transaccion_pag = v_parametros.id_int_transaccion)
                                         and rd.estado_reg = 'activo' )LOOP
                                         
                      DELETE FROM 
                        conta.tint_rel_devengado 
                      WHERE id_int_rel_devengado = v_registros.id_int_rel_devengado;
            END LOOP;
            
            
            --------------------------
			--ELIMINACIÓN TRANSACCIÓN 
			--------------------------
			delete from conta.tint_transaccion
            where id_int_transaccion = v_parametros.id_int_transaccion;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Transacción eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_int_transaccion',v_parametros.id_int_transaccion::varchar);
              
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