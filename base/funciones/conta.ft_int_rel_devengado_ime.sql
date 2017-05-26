--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_int_rel_devengado_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_int_rel_devengado_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tint_rel_devengado'
 AUTOR: 		 (admin)
 FECHA:	        09-10-2015 12:31:01
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
    v_registros     		record;
    v_registros_rel	        record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_int_rel_devengado	integer;
    v_id_moneda_base 		integer;
    v_id_moneda_tri		    integer;
    v_monto_pago_mb  		numeric;
    v_monto_pago_mt			numeric;
    v_monto_total_x_pagar	numeric;
    v_monto_total_devengado	numeric;
    va_montos  				numeric[];
    v_registros_dev			record;
    v_sw_reversion			varchar;
    v_importe_dev			numeric;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_int_rel_devengado_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_RDE_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		09-10-2015 12:31:01
	***********************************/

	if(p_transaccion='CONTA_RDE_INS')then
					
        begin
        
           select 
             ic.*,
             it.importe_debe,
             it.importe_haber,
             it.tipo_cambio as tipo_cambio_t,
             it.tipo_cambio_2 as tipo_cambio_2_t,
             it.id_moneda as id_moneda_t,
             it.importe_recurso,
             it.importe_gasto
            into
             v_registros
            from conta.tint_comprobante ic
            inner join conta.tint_transaccion it on it.id_int_comprobante = ic.id_int_comprobante
            where it.id_int_transaccion = v_parametros.id_int_transaccion_pag;
            
            
            --datos del devengado
             select 
             ic.*,
             it.importe_debe,
             it.importe_haber,
             it.importe_gasto,
             it.importe_recurso,
             it.tipo_cambio as tipo_cambio_t,
             it.tipo_cambio_2 as tipo_cambio_2_t,
             it.id_moneda as id_moneda_t
            into
             v_registros_dev
            from conta.tint_comprobante ic
            inner join conta.tint_transaccion it on it.id_int_comprobante = ic.id_int_comprobante
            where it.id_int_transaccion = v_parametros.id_int_transaccion_dev;
            
            
            IF v_registros.estado_reg = 'validado' THEN
               raise exception 'No puede insertar esta relación por que el cbte de pago ya esta validado';
            END IF;
            
         -- Obtener la moneda base
          v_id_moneda_base = param.f_get_moneda_base();
          v_id_moneda_tri  = param.f_get_moneda_triangulacion();
         
        
         --validacion de comprobante editable
         IF v_registros.sw_editable = 'no' THEN
              raise exception 'no puede insertar relaciones en comprobantes no editables';  
         END IF;
         
          IF v_registros.localidad = 'nacional'  THEN
            
            va_montos  = conta.f_calcular_monedas_segun_config(v_registros.id_moneda_t, 
                                                             v_id_moneda_base, 
                                                             v_id_moneda_tri, 
                                                             v_registros.tipo_cambio_t, 
                                                             v_registros.tipo_cambio_2_t, 
                                                             v_parametros.monto_pago, 
                                                             v_registros.id_config_cambiaria, 
                                                             v_registros.fecha); 
            
            v_monto_pago_mb  =  va_montos[1];
            v_monto_pago_mt = va_montos[2];
           
          
          ELSE
          
               
              v_monto_pago_mt =  param.f_convertir_moneda (v_registros.id_moneda_t, v_id_moneda_tri,   v_parametros.monto_pago, v_registros.fecha,'CUS',50, v_registros.tipo_cambio_t, 'no');
              v_monto_pago_mb =  param.f_convertir_moneda (v_id_moneda_tri, v_id_moneda_base,  v_monto_pago_mt, v_registros.fecha,'CUS',50,v_registros.tipo_cambio_2_t, 'no');
                 
             -- si es origen internacional de  la moneda  se  triangula            
                        
          END IF;
          
          
          --  validar que el monto a pagar  no sobre pase el monto ejecutado
                  
           SELECT
             sum(rd.monto_pago)
           into
             v_monto_total_x_pagar
           from conta.tint_rel_devengado rd
           where rd.id_int_transaccion_dev = v_parametros.id_int_transaccion_dev
           and rd.estado_reg = 'activo'; 
           
          
          
          -- obtengo el importe del devengado a ser validado
          IF v_registros_dev.importe_gasto = 0 THEN
          		v_importe_dev = v_registros.importe_recurso;
          ELSE
          		v_importe_dev = v_registros_dev.importe_gasto;
          END IF; 
          
          -------------------------------------------------------------- 
          --Si  NO es una reversion
          --------------------------------------------------------------
          IF v_parametros.monto_pago > 0  THEN         
                 
                --  el monto a pagar tiene que ser menor o igual  que (el monto devengado menos los montos  pagados ya registrados)
                --  en caso contrario lanzar error
                IF  v_parametros.monto_pago >   v_importe_dev - COALESCE(v_monto_total_x_pagar,0)  THEN
                   raise exception 'el monto a pagar supera el saldo pendiente devengado (%)', v_importe_dev - COALESCE(v_monto_total_x_pagar,0);
                END IF;
                 
                 v_sw_reversion = 'no';
               
          --------------------------------------------------------------
          --Si es reversion el monto es negativo las validaciones son diferentes
          --------------------------------------------------------------      
          ELSE
                --  el monto a revertir   tiene que ser menor o igual  que los montos pagasdos ya registrados
                --  en caso contrario lanzar error
                IF  (v_parametros.monto_pago*-1) >   COALESCE(v_monto_total_x_pagar,0)  THEN
                   raise exception 'el monto a revertir supera el saldo pagado (%)', COALESCE(v_monto_total_x_pagar,0);
                END IF;
                
                v_sw_reversion = 'si';
          END IF; 
           
           
           
        	--Sentencia de la insercion
        	insert into conta.tint_rel_devengado (
                id_int_transaccion_pag,
                id_int_transaccion_dev,
                monto_pago,
                monto_pago_mb,
                monto_pago_mt,
                estado_reg,
                id_usuario_ai,
                fecha_reg,
                usuario_ai,
                id_usuario_reg,
                fecha_mod,
                id_usuario_mod,
                sw_reversion
             ) values(
                v_parametros.id_int_transaccion_pag,
                v_parametros.id_int_transaccion_dev,
                v_parametros.monto_pago,
                v_monto_pago_mb,
                v_monto_pago_mt,
                'activo',
                v_parametros._id_usuario_ai,
                now(),
                v_parametros._nombre_usuario_ai,
                p_id_usuario,
                null,
                null,
                v_sw_reversion
			) RETURNING id_int_rel_devengado into v_id_int_rel_devengado;
			
            
            -- TODO recalcular tipo de cambio en transacciones  de pago
            -- calcular moneda base y triangulacion
            
            PERFORM  conta.f_calcular_monedas_transaccion(v_parametros.id_int_transaccion_pag);
            
            
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','RELDEV almacenado(a) con exito (id_int_rel_devengado'||v_id_int_rel_devengado||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_int_rel_devengado',v_id_int_rel_devengado::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_RDE_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		09-10-2015 12:31:01
	***********************************/

	elsif(p_transaccion='CONTA_RDE_MOD')then

		begin
			--calcula monto en moneda base
            
            select 
             ic.*,
             it.importe_debe,
             it.importe_haber,
             it.tipo_cambio as tipo_cambio_t,
             it.tipo_cambio_2 as tipo_cambio_2_t,
             it.id_moneda as id_moneda_t,
             it.importe_recurso,
             it.importe_gasto
            into
             v_registros
            from conta.tint_comprobante ic
            inner join conta.tint_transaccion it on it.id_int_comprobante = ic.id_int_comprobante
            where it.id_int_transaccion = v_parametros.id_int_transaccion_pag;
            
            
            --datos del devengado
             select 
             ic.*,
             it.importe_debe,
             it.importe_haber,
             it.tipo_cambio as tipo_cambio_t,
             it.tipo_cambio_2 as tipo_cambio_2_t,
             it.id_moneda as id_moneda_t,
             it.importe_recurso,
             it.importe_gasto
            into
             v_registros_dev
            from conta.tint_comprobante ic
            inner join conta.tint_transaccion it on it.id_int_comprobante = ic.id_int_comprobante
            where it.id_int_transaccion = v_parametros.id_int_transaccion_dev;
            
            --validacion de comprobante editable
            IF v_registros.sw_editable = 'no' THEN
              raise exception 'no puede insertar relaciones en comprobantes no editables';  
            END IF;
            
            IF v_registros.estado_reg = 'validado' THEN
               raise exception 'No puede modificar esta relación por que el cbte esta validado';
            END IF;
            
            
            /*******************************************************************
            --  validar que el monto a pagar  no sobre pase el monto ejecutado
            **********************************************************************/
             SELECT
               sum(rd.monto_pago)
             into
               v_monto_total_x_pagar
             from conta.tint_rel_devengado rd
             where rd.id_int_transaccion_dev = v_parametros.id_int_transaccion_dev
                   and rd.estado_reg = 'activo'
                   and id_int_rel_devengado != v_parametros.id_int_rel_devengado; 
             
             SELECT
              rd.*
             into
               v_registros_rel
             from conta.tint_rel_devengado rd
             where rd.id_int_rel_devengado = v_parametros.id_int_rel_devengado
                   and rd.estado_reg = 'activo';
             
             -- obtengo el importe del devengado a ser validado
            IF v_registros_dev.importe_gasto = 0 THEN
                  v_importe_dev = v_registros.importe_recurso;
            ELSE
                  v_importe_dev = v_registros_dev.importe_gasto;
            END IF;  
             
            -------------------------------------------------------------- 
            --Si  NO es una reversion
            --------------------------------------------------------------
            IF v_parametros.monto_pago > 0  THEN         
                   
                  --  el monto a pagar tiene que ser menor o igual  que (el monto devengado menos los montos  pagados ya registrados)
                  --  en caso contrario lanzar error
                  IF  v_parametros.monto_pago >   v_importe_dev - (COALESCE(v_monto_total_x_pagar,0))  THEN
                     raise exception 'el monto a pagar supera el saldo pendiente por devengar (%)', v_importe_dev - COALESCE(v_monto_total_x_pagar,0);
                  END IF;
                   
                   v_sw_reversion = 'no';
                 
            --------------------------------------------------------------
            --Si es reversion el monto es negativo las validaciones son diferentes
            --------------------------------------------------------------      
            ELSE
                  --  el monto a revertir   tiene que ser menor o igual  que los montos pagasdos ya registrados
                  --  en caso contrario lanzar error
                  IF  (v_parametros.monto_pago*-1) >   (COALESCE(v_monto_total_x_pagar,0))  THEN
                     raise exception 'el monto a revertir supera el saldo pagao (%)', COALESCE(v_monto_total_x_pagar,0);
                  END IF;
                  
                  v_sw_reversion = 'si';
            END IF;
           
          
            -- Obtener la moneda base
            v_id_moneda_base = param.f_get_moneda_base();
            v_id_moneda_tri  = param.f_get_moneda_triangulacion();
         
            IF  v_registros.localidad = 'nacional'  THEN
                va_montos  = conta.f_calcular_monedas_segun_config(v_registros.id_moneda_t, 
                                                               v_id_moneda_base, 
                                                               v_id_moneda_tri, 
                                                               v_registros.tipo_cambio_t, 
                                                               v_registros.tipo_cambio_2_t, 
                                                               v_parametros.monto_pago, 
                                                               v_registros.id_config_cambiaria, 
                                                               v_registros.fecha); 
                                                               
                v_monto_pago_mb  =  va_montos[1];
                v_monto_pago_mt = va_montos[2];                                               
                                                               
            ELSE
               
               v_monto_pago_mt =  param.f_convertir_moneda (v_registros.id_moneda_t, v_id_moneda_tri,   v_parametros.monto_pago, v_registros.fecha,'CUS',50, v_registros.tipo_cambio_t, 'no');
               v_monto_pago_mb =  param.f_convertir_moneda (v_id_moneda_tri, v_id_moneda_base,  v_monto_pago_mt, v_registros.fecha,'CUS',50,v_registros.tipo_cambio_2_t, 'no');
                 
            END IF;   
            
         
       
            --Sentencia de la modificacion
			update conta.tint_rel_devengado set
              id_int_transaccion_pag = v_parametros.id_int_transaccion_pag,
              id_int_transaccion_dev = v_parametros.id_int_transaccion_dev,
              monto_pago = v_parametros.monto_pago,
              monto_pago_mb = v_monto_pago_mb,
              monto_pago_mt = v_monto_pago_mt,
              fecha_mod = now(),
              id_usuario_mod = p_id_usuario,
              id_usuario_ai = v_parametros._id_usuario_ai,
              usuario_ai = v_parametros._nombre_usuario_ai,
              sw_reversion = v_sw_reversion
			where id_int_rel_devengado=v_parametros.id_int_rel_devengado;
            
            -- TODO recalcular tipo de cambio en transacciones  de pago
            -- calcular moneda base y triangulacion
            
            PERFORM  conta.f_calcular_monedas_transaccion(v_parametros.id_int_transaccion_pag);
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','RELDEV modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_int_rel_devengado',v_parametros.id_int_rel_devengado::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_RDE_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		09-10-2015 12:31:01
	***********************************/

	elsif(p_transaccion='CONTA_RDE_ELI')then

		begin
        
        
            select 
             ic.*
            into
             v_registros
            from conta.tint_comprobante ic
            inner join conta.tint_transaccion it on it.id_int_comprobante = ic.id_int_comprobante
            inner join conta.tint_rel_devengado rd on rd.id_int_transaccion_pag = it.id_int_transaccion
            where rd.id_int_rel_devengado = v_parametros.id_int_rel_devengado;
            
            
            IF v_registros.estado_reg = 'validado' THEN
               raise exception 'No puede eliminar  esta relación por que el cbte esta validado';
            END IF;
            
            --  validacion de comprobante editable
            IF v_registros.sw_editable = 'no' THEN
               raise exception 'no puede insertar relaciones en comprobantes no editables';  
            END IF;
            
            IF v_registros.localidad != 'nacional' THEN
               raise exception 'No puede eliminar  relaciones en cbtes internacionales';
            END IF;
            
			--Sentencia de la eliminacion
			delete from conta.tint_rel_devengado
            where id_int_rel_devengado=v_parametros.id_int_rel_devengado;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','RELDEV eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_int_rel_devengado',v_parametros.id_int_rel_devengado::varchar);
              
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