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
               cbt.tipo_cambio,
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
             v_importe_debe_mb  =  v_parametros.importe_debe;
             v_importe_haber_mb = v_parametros.importe_haber;
             
            -- si la moneda es distinto de la moneda base, calculamos segun tipo de cambio
            IF v_id_moneda_base != v_registros.id_moneda  THEN
               
            
                              
                 IF  v_registros.tipo_cambio is not  NULL THEN
                              
                   --si es la moenda base   base utilizamos el tipo de cambio del comprobante, ...solicitamos C  (CUSTOM)
                   v_importe_debe_mb  = param.f_convertir_moneda (v_registros.id_moneda, v_id_moneda_base, v_importe_debe, v_registros.fecha,'CUS',2, v_registros.tipo_cambio);
                   v_importe_haber_mb = param.f_convertir_moneda (v_registros.id_moneda, v_id_moneda_base, v_importe_haber, v_registros.fecha,'CUS',2, v_registros.tipo_cambio);
                              
                ELSE
                   --TODO si no hay tipo de cambio registramos solo en la moneda origen .... 
                          
                   v_importe_debe_mb = NULL;
                   v_importe_haber_mb = NULL;      
                END IF;
             
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
                importe_debe_mb,
                importe_haber_mb,
                importe_gasto_mb,
                importe_recurso_mb,
                id_usuario_reg,
                fecha_reg,
                id_usuario_mod,
                fecha_mod
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
                v_parametros.importe_debe,
                v_parametros.importe_haber,
                v_importe_debe_mb,
                v_importe_haber_mb,
                v_importe_debe_mb,
                v_importe_haber_mb,
                p_id_usuario,
                now(),
                null,
                null
			)RETURNING id_int_transaccion into v_id_int_transaccion;
            
            
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
             v_importe_debe_mb  =  v_parametros.importe_debe;
             v_importe_haber_mb = v_parametros.importe_haber;
             
             -- si la moneda es distinto de la moneda base, calculamos segun tipo de cambio
            IF v_id_moneda_base != v_registros.id_moneda  THEN
               IF  v_registros.tipo_cambio is not  NULL THEN
                              
                   --si es la moenda base   base utilizamos el tipo de cambio del comprobante, ...solicitamos C  (CUSTOM)
                   v_importe_debe_mb  = param.f_convertir_moneda (v_registros.id_moneda, v_id_moneda_base, v_importe_debe, v_registros.fecha,'CUS',2, v_registros.tipo_cambio);
                   v_importe_haber_mb = param.f_convertir_moneda (v_registros.id_moneda, v_id_moneda_base, v_importe_haber, v_registros.fecha,'CUS',2, v_registros.tipo_cambio);
                              
                ELSE
                   --TODO si no hay tipo de cambio registramos solo en la moneda origen .... 
                   v_importe_debe_mb = NULL;
                   v_importe_haber_mb = NULL;      
                END IF;
             
            END IF;
            
            ---------------
        	--VALIDACIONES
        	---------------
        	--VerIfica el estado
        	if not exists(select 1 from conta.tint_transaccion tra
			        	inner join conta.tint_comprobante cbte
			        	on cbte.id_int_comprobante = tra.id_int_comprobante
			        	where tra.id_int_transaccion = v_parametros.id_int_transaccion
        				and cbte.estado_reg = 'borrador') then
        		raise exception 'Modificación no realizada: el comprobante no está en estado Borrador';
        	end if;
            
            
            
            
		
			--------------------------------
			--MODIFICACION DE LA TRANSACCION
			--------------------------------
			update conta.tint_transaccion set
              id_partida = v_parametros.id_partida,
              id_centro_costo = v_parametros.id_centro_costo,
              id_cuenta = v_parametros.id_cuenta,
              glosa = v_parametros.glosa,
              id_int_comprobante = v_parametros.id_int_comprobante,
              id_auxiliar = v_parametros.id_auxiliar,
              id_usuario_mod = p_id_usuario,
              fecha_mod = now(),
              importe_debe = v_parametros.importe_debe,
              importe_haber = v_parametros.importe_haber,
              importe_gasto = v_parametros.importe_debe,
              importe_recurso = v_parametros.importe_haber,
              importe_debe_mb = v_importe_debe_mb,
              importe_haber_mb = v_importe_haber_mb,
              importe_gasto_mb = v_importe_debe_mb,
              importe_recurso_mb = v_importe_haber_mb
			where id_int_transaccion=v_parametros.id_int_transaccion;
            
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
        				and cbte.estado_reg = 'borrador') then
        		raise exception 'Eliminación no realizada: el comprobante no está en estado Borrador';
        	end if;

            --------------------------
			--ELIMINACIÓN TRANSACCIÓN 
			--------------------------
			delete from conta.tint_transaccion
            where id_int_transaccion=v_parametros.id_int_transaccion;
               
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