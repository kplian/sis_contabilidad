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
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_int_transaccion	integer;
    
    v_importe_debe 			numeric;
    v_importe_haber 		numeric;
    v_importe_recurso 		numeric;
    v_importe_gasto 		numeric;
    v_registros 			record;
    v_registros_con 		record;
    v_id_moneda_base		integer;
    
    
    v_importe_debe_mb  		numeric;
    v_importe_haber_mb 		numeric;
    v_importe_recurso_mb 	numeric;
    v_importe_gasto_mb		numeric;
 
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
        	---------------
        	--VALIDACIONES
        	---------------
            
             select 
              c.fecha,
              c.tipo_cambio,
              c.id_moneda
            into
             v_registros_con
            from conta.tint_comprobante  c
            where c.id_int_comprobante = v_parametros.id_int_comprobante;
          
          --recupera moneda base
          v_id_moneda_base = param.f_get_moneda_base();
          
          --pordefecto solo copiamos
          v_importe_debe  =  v_parametros.importe_debe;
          v_importe_haber 	=  v_parametros.importe_haber;
          v_importe_recurso = v_parametros.importe_debe;
          v_importe_gasto	= v_parametros.importe_haber;
          
          v_importe_debe_mb  =  v_importe_debe;
          v_importe_haber_mb 	= v_importe_haber;
          v_importe_recurso_mb = v_importe_recurso;
          v_importe_gasto_mb	= v_importe_gasto;
       
          
          -- si la moneda es distinto de la moneda base, calculamos segun tipo de cambio
          IF v_id_moneda_base != v_registros_con.id_moneda  THEN
             
               IF  v_registros_con.tipo_cambio is not  NULL THEN
                               
                 --si es la moenda base   base utilizamos el tipo de cambio del comprobante, ...solicitamos C  (CUSTOM)
                 v_importe_debe_mb  = param.f_convertir_moneda (v_registros_con.id_moneda, v_id_moneda_base, v_importe_debe, v_registros_con.fecha,'CUS',2, v_registros_con.tipo_cambio);
                 v_importe_haber_mb = param.f_convertir_moneda (v_registros_con.id_moneda, v_id_moneda_base, v_importe_haber, v_registros_con.fecha,'CUS',2, v_registros_con.tipo_cambio);
                 v_importe_recurso_mb =  param.f_convertir_moneda (v_registros_con.id_moneda, v_id_moneda_base, v_importe_recurso, v_registros_con.fecha,'CUS',2, v_registros_con.tipo_cambio);
                 v_importe_gasto_mb  = param.f_convertir_moneda (v_registros_con.id_moneda, v_id_moneda_base, v_importe_gasto, v_registros_con.fecha,'CUS',2, v_registros_con.tipo_cambio);
                            
              ELSE
                            
                --si no tenemso tipo de cambio convenido .....
                 v_importe_debe_mb  = param.f_convertir_moneda (v_registros_con.id_moneda, v_id_moneda_base, v_importe_debe, v_registros_con.fecha,'O',2);
                 v_importe_haber_mb = param.f_convertir_moneda (v_registros_con.id_moneda, v_id_moneda_base, v_importe_haber, v_registros_con.fecha,'O',2);
                 v_importe_recurso_mb =  param.f_convertir_moneda (v_registros_con.id_moneda, v_id_moneda_base, v_importe_recurso, v_registros_con.fecha,'O',2);
                 v_importe_gasto_mb  = param.f_convertir_moneda (v_registros_con.id_moneda, v_id_moneda_base,  v_importe_gasto, v_registros_con.fecha,'O',2);
                           
                            
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
              importe_recurso,
              importe_gasto,			
              importe_debe_mb,
              importe_haber_mb,
              importe_recurso_mb,
              importe_gasto_mb,			
              id_usuario_reg,
              fecha_reg,
              id_usuario_mod,
              fecha_mod,
              id_orden_trabajo
          	) values(
              v_parametros.id_partida,
              v_parametros.id_centro_costo,
              'activo',
              v_parametros.id_cuenta,
              v_parametros.glosa,
              v_parametros.id_int_comprobante,
              v_parametros.id_auxiliar,
              v_importe_debe,
              v_importe_haber,
              v_importe_recurso,
              v_importe_gasto,
              v_importe_debe_mb,
              v_importe_haber_mb,
              v_importe_recurso_mb,
              v_importe_gasto_mb,
              p_id_usuario,
              now(),
              null,
              null,
              v_parametros.id_orden_trabajo
			)RETURNING id_int_transaccion into v_id_int_transaccion;
			
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
			---------------
        	--VALIDACIONES
        	---------------
            select 
              c.fecha,
              c.tipo_cambio,
              c.id_moneda
            into
             v_registros_con
            from conta.tint_comprobante  c
            where c.id_int_comprobante = v_parametros.id_int_comprobante;
          
          --recupera moneda base
          v_id_moneda_base = param.f_get_moneda_base();
          
          --pordefecto solo copiamos
          v_importe_debe  =  v_parametros.importe_debe;
          v_importe_haber 	=  v_parametros.importe_haber;
          v_importe_recurso = v_parametros.importe_debe;
          v_importe_gasto	= v_parametros.importe_haber;
          
          v_importe_debe_mb  =  v_importe_debe;
          v_importe_haber_mb 	= v_importe_haber;
          v_importe_recurso_mb = v_importe_recurso;
          v_importe_gasto_mb	= v_importe_gasto;
       
          
          -- si la moneda es distinto de la moneda base, calculamos segun tipo de cambio
          IF v_id_moneda_base != v_registros_con.id_moneda  THEN
             
               IF  v_registros_con.tipo_cambio is not  NULL THEN
                               
                 --si es la moenda base   base utilizamos el tipo de cambio del comprobante, ...solicitamos C  (CUSTOM)
                 v_importe_debe_mb  = param.f_convertir_moneda (v_registros_con.id_moneda, v_id_moneda_base, v_importe_debe, v_registros_con.fecha,'CUS',2, v_registros_con.tipo_cambio);
                 v_importe_haber_mb = param.f_convertir_moneda (v_registros_con.id_moneda, v_id_moneda_base, v_importe_haber, v_registros_con.fecha,'CUS',2, v_registros_con.tipo_cambio);
                 v_importe_recurso_mb =  param.f_convertir_moneda (v_registros_con.id_moneda, v_id_moneda_base, v_importe_recurso, v_registros_con.fecha,'CUS',2, v_registros_con.tipo_cambio);
                 v_importe_gasto_mb  = param.f_convertir_moneda (v_registros_con.id_moneda, v_id_moneda_base, v_importe_gasto, v_registros_con.fecha,'CUS',2, v_registros_con.tipo_cambio);
                            
              ELSE
                            
                --si no tenemso tipo de cambio convenido .....
                 v_importe_debe_mb  = param.f_convertir_moneda (v_registros_con.id_moneda, v_id_moneda_base, v_importe_debe, v_registros_con.fecha,'O',2);
                 v_importe_haber_mb = param.f_convertir_moneda (v_registros_con.id_moneda, v_id_moneda_base, v_importe_haber, v_registros_con.fecha,'O',2);
                 v_importe_recurso_mb =  param.f_convertir_moneda (v_registros_con.id_moneda, v_id_moneda_base, v_importe_recurso, v_registros_con.fecha,'O',2);
                 v_importe_gasto_mb  = param.f_convertir_moneda (v_registros_con.id_moneda, v_id_moneda_base,  v_importe_gasto, v_registros_con.fecha,'O',2);
                           
                            
              END IF;
           
          END IF;
            
            
            
        	--VerIfica el estado
        	if not exists(select 1 from conta.tint_transaccion tra
			        	inner join conta.tint_comprobante cbte
			        	on cbte.id_int_comprobante = tra.id_int_comprobante
			        	where tra.id_int_transaccion = v_parametros.id_int_transaccion
        				and cbte.estado_reg = 'borrador') then
        		raise exception 'Modificación no realizada: el comprobante no está en estado Borrador';
        	end if;
		
           --raise exception 'ss';
			--------------------------------
			--MODIFICACION DE LA TRANSACCION
			--------------------------------
			update conta.tint_transaccion set
			id_partida = v_parametros.id_partida,
            id_orden_trabajo = v_parametros.id_orden_trabajo,
			id_centro_costo = v_parametros.id_centro_costo,
			id_cuenta = v_parametros.id_cuenta,
			glosa = v_parametros.glosa,
			id_int_comprobante = v_parametros.id_int_comprobante,
			id_auxiliar = v_parametros.id_auxiliar,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			importe_debe = v_importe_debe,
			importe_haber = v_importe_haber,
			importe_gasto = v_importe_gasto,
			importe_recurso = v_importe_recurso,
            importe_debe_mb = v_importe_debe_mb,
			importe_haber_mb = v_importe_haber_mb,
			importe_gasto_mb = v_importe_gasto_mb,
			importe_recurso_mb = v_importe_recurso_mb
			where id_int_transaccion=v_parametros.id_int_transaccion;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Transacción modificado(a)'); 
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