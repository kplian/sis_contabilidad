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
    v_monto_pago_mb  		numeric;
    v_monto_total_x_pagar	numeric;
    v_monto_total_devengado	numeric;
			    
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
             it.importe_haber
            into
             v_registros
            from conta.tint_comprobante ic
            inner join conta.tint_transaccion it on it.id_int_comprobante = ic.id_int_comprobante
            where it.id_int_transaccion = v_parametros.id_int_transaccion_pag;
            
            
            
            IF v_registros.estado_reg = 'validado' THEN
               raise exception 'No puede insertar esta relación por que el cbte esta validado';
            END IF;
            
            -- Obtener la moneda base
          v_id_moneda_base = param.f_get_moneda_base();
          v_monto_pago_mb  =  v_parametros.monto_pago;
       
          
          -- si la moneda es distinto de la moneda base, calculamos segun tipo de cambio
          IF v_id_moneda_base != v_registros.id_moneda  THEN
             
              IF  v_registros.tipo_cambio is not  NULL THEN
                 --si es la moenda base   base utilizamos el tipo de cambio del comprobante, ...solicitamos C  (CUSTOM)
                 v_monto_pago_mb  = param.f_convertir_moneda (v_regitros.id_moneda, v_id_moneda_base, v_monto_pago_mb, v_regitros.fecha,'CUS',2, v_regitros.tipo_cambio);
                           
              ELSE
                 --si no tenemso tipo de cambio convenido .....
                 v_monto_pago_mb  = param.f_convertir_moneda (v_regitros.id_moneda, v_id_moneda_base, v_monto_pago_mb, v_regitros.fecha,'O',2);
              END IF;
           
          END IF;
          
          --  validar que el monto a pagar  no sobre pase el monto ejecutado
        
           SELECT
             sum(rd.monto_pago)
           into
             v_monto_total_x_pagar
           from conta.tint_rel_devengado rd
           where rd.id_int_transaccion_dev = v_parametros.id_int_transaccion_dev
           and rd.estado_reg = 'activo'; 
           
           
           
           
           IF v_registros.importe_debe <  COALESCE(v_monto_total_x_pagar,0) + v_parametros.monto_pago THEN
             raise exception 'El monto ejecutado (%) es menor al monto que se quiere pagar (%)', v_registros.importe_debe, COALESCE(v_monto_total_x_pagar,0) + v_parametros.monto_pago;
           END IF;
           
           
        	--Sentencia de la insercion
        	insert into conta.tint_rel_devengado(
			id_int_transaccion_pag,
			id_int_transaccion_dev,
			monto_pago,
			monto_pago_mb,
			estado_reg,
			id_usuario_ai,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.id_int_transaccion_pag,
			v_parametros.id_int_transaccion_dev,
			v_parametros.monto_pago,
			v_monto_pago_mb,
			'activo',
			v_parametros._id_usuario_ai,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			null,
			null
							
			
			
			)RETURNING id_int_rel_devengado into v_id_int_rel_devengado;
			
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
             it.importe_haber
            into
             v_registros
            from conta.tint_comprobante ic
            inner join conta.tint_transaccion it on it.id_int_comprobante = ic.id_int_comprobante
            where it.id_int_transaccion = v_parametros.id_int_transaccion_pag;
            
            
            
            IF v_registros.estado_reg = 'validado' THEN
               raise exception 'No puede modificar esta relación por que el cbte esta validado';
            END IF;
            
         --  validar que el monto a pagar  no sobre pase el monto ejecutado
        
           SELECT
             sum(rd.monto_pago)
           into
             v_monto_total_x_pagar
           from conta.tint_rel_devengado rd
           where rd.id_int_transaccion_dev = v_parametros.id_int_transaccion_dev
                 and rd.estado_reg = 'activo'; 
           
           SELECT
            rd.*
           into
             v_registros_rel
           from conta.tint_rel_devengado rd
           where rd.id_int_rel_devengado = v_parametros.id_int_rel_devengado
                 and rd.estado_reg = 'activo';
           
           
           
           
           IF v_registros.importe_debe <  (COALESCE(v_monto_total_x_pagar,0) + v_parametros.monto_pago - v_registros_rel.monto_pago) THEN
             raise exception 'El monto ejecutado (%) es menor al monto que se quiere pagar (%)', v_registros.importe_debe, (COALESCE(v_monto_total_x_pagar,0) + v_parametros.monto_pago - v_registros_rel.monto_pago);
           END IF;   
            
            
            -- Obtener la moneda base
          v_id_moneda_base = param.f_get_moneda_base();
          v_monto_pago_mb  =  v_parametros.monto_pago;
       
          
          -- si la moneda es distinto de la moneda base, calculamos segun tipo de cambio
          IF v_id_moneda_base != v_registros.id_moneda  THEN
             
              IF  v_registros.tipo_cambio is not  NULL THEN
                 --si es la moenda base   base utilizamos el tipo de cambio del comprobante, ...solicitamos C  (CUSTOM)
                 v_monto_pago_mb  = param.f_convertir_moneda (v_regitros.id_moneda, v_id_moneda_base, v_monto_pago_mb, v_regitros.fecha,'CUS',2, v_regitros.tipo_cambio);
                           
              ELSE
                 --si no tenemso tipo de cambio convenido .....
                 v_monto_pago_mb  = param.f_convertir_moneda (v_regitros.id_moneda, v_id_moneda_base, v_monto_pago_mb, v_regitros.fecha,'O',2);
              END IF;
           
          END IF;
            
            
            --Sentencia de la modificacion
			update conta.tint_rel_devengado set
			id_int_transaccion_pag = v_parametros.id_int_transaccion_pag,
			id_int_transaccion_dev = v_parametros.id_int_transaccion_dev,
			monto_pago = v_parametros.monto_pago,
            monto_pago_mb = v_monto_pago_mb,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_int_rel_devengado=v_parametros.id_int_rel_devengado;
               
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
            where it.id_int_transaccion = v_parametros.id_int_transaccion_pag;
            
            IF v_registros.estado_reg = 'validado' THEN
               raise exception 'No puede eliminar  esta relación por que el cbte esta validado';
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