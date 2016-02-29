-- Function: conta.ft_relacion_contable_ime(integer, integer, character varying, character varying)

-- DROP FUNCTION conta.ft_relacion_contable_ime(integer, integer, character varying, character varying);

CREATE OR REPLACE FUNCTION conta.ft_relacion_contable_ime(p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
  RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_relacion_contable_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.trelacion_contable'
 AUTOR: 		 (rac - kplian)
 FECHA:	        16-05-2013 21:52:14
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
	v_id_relacion_contable	integer;
    
    v_tipo_rel  record;
    v_defecto varchar;
    v_resp_rep			varchar;
    v_id_deptos_lbs			varchar;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_relacion_contable_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_RELCON_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		16-05-2013 21:52:14
	***********************************/

	if(p_transaccion='CONTA_RELCON_INS')then
					
        begin
        	--raise exception 'Desabilitado por unos instantes...';
            -- sies una relacion contable unica buscamos que para la misma tabla no exista otrao
            select 
              * 
            into 
              v_tipo_rel 
            from conta.ttipo_relacion_contable trc 
            where trc.id_tipo_relacion_contable = v_parametros.id_tipo_relacion_contable;
            
            IF  pxp.f_existe_parametro(p_tabla, 'defecto') THEN
            
               v_defecto =  v_parametros.defecto;
        
            ELSE
            
               v_defecto = 'no';
            
            
            END IF;
            
            --si_unico solo permite un centro de costo para el id_tabla
	    IF v_tipo_rel.tiene_centro_costo IN ('si-unico') THEN
            
            
               IF  EXISTS(select  1 
                   from conta.trelacion_contable  rc 
                   where rc.id_gestion = v_parametros.id_gestion 
                     and rc.id_tipo_relacion_contable = v_parametros.id_tipo_relacion_contable
                     and rc.id_centro_costo is not null
                     and rc.estado_reg = 'activo'  
                     and (rc.id_tabla = v_parametros.id_tabla or rc.id_tabla  is null )  ) THEN
                     
                     raise exception 'En relaciones contables si-unico solo se permite una configuracion con un solo centro de costo';
                     
               END IF;   
            
            END IF;
            --si_general permite  centro de costo para el id_tabla
            IF (v_tipo_rel.tiene_centro_costo IN ('si-general') and v_defecto = 'no' )THEN
            
            
               IF  EXISTS(select  1 
                   from conta.trelacion_contable  rc 
                   where rc.id_gestion = v_parametros.id_gestion 
                     and rc.id_tipo_relacion_contable = v_parametros.id_tipo_relacion_contable
                     and rc.id_centro_costo = v_parametros.id_centro_costo
                     and rc.estado_reg = 'activo'
                     and rc.defecto = 'no'
                     and (rc.id_tabla = v_parametros.id_tabla or rc.id_tabla  is null )  ) THEN
                     
                     raise exception 'Ya existe una relacion contable para este elemento';
                     
               END IF;   
            
            END IF;
            
            IF v_tipo_rel.tiene_centro_costo = 'no' THEN            
            
               IF  EXISTS(select  1 
                   from conta.trelacion_contable  rc 
                   where rc.id_gestion = v_parametros.id_gestion 
                     and rc.id_tipo_relacion_contable = v_parametros.id_tipo_relacion_contable                                  
                     and rc.id_tabla = v_parametros.id_tabla) THEN                     
                     raise exception 'Ya existe una relacion contable para este registro';                     
               END IF;   
            
            END IF;
            
            
            IF  v_defecto = 'si'   THEN
             --si el valor es marcado como defecto es valido para cualquier atributo de la tabla  
               v_parametros.id_tabla = NULL;
               
             --validamos que solo exista un parametro por defecto activo para la gestion 
             
             
                IF   exists (select 1 
                             from conta.trelacion_contable rc 
                             where rc.defecto='si'  
                               and rc.id_tabla is NULL 
                               and (rc.id_centro_costo = v_parametros.id_centro_costo or rc.id_centro_costo is NULL)
                               and rc.id_tipo_relacion_contable = v_parametros.id_tipo_relacion_contable
                               and rc.id_gestion = v_parametros.id_gestion
                               and rc.estado_reg='activo')     THEN
                
                   
                      raise exception 'Ya existe un valor po defecto para este tipo de relacion contable'; 
                    
                END IF;  
               
            
            END IF;
            
        
        	--Sentencia de la insercion
        	insert into conta.trelacion_contable(
			estado_reg,
			id_tipo_relacion_contable,
			id_cuenta,
			id_partida,
			id_gestion,
			id_auxiliar,
			id_centro_costo,
			fecha_reg,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod,
			id_tabla,
            defecto
          	) values(
			'activo',
			v_parametros.id_tipo_relacion_contable,
			v_parametros.id_cuenta,
			v_parametros.id_partida,
			v_parametros.id_gestion,
			v_parametros.id_auxiliar,
			v_parametros.id_centro_costo,
			now(),
			p_id_usuario,
			null,
			null,
			v_parametros.id_tabla,
            v_defecto
							
			)RETURNING id_relacion_contable into v_id_relacion_contable;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Relación Contable almacenado(a) con exito (id_relacion_contable'||v_id_relacion_contable||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_relacion_contable',v_id_relacion_contable::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_RELCON_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		16-05-2013 21:52:14
	***********************************/

	elsif(p_transaccion='CONTA_RELCON_MOD')then

		begin
        
        -- sies una relacion contable unica buscamos que para la misma tabla no exista otrao
            select 
              * 
            into 
              v_tipo_rel 
            from conta.ttipo_relacion_contable trc 
            where trc.id_tipo_relacion_contable = v_parametros.id_tipo_relacion_contable;
           
            IF v_tipo_rel.tiene_centro_costo = 'si-unico' THEN
            
            
               IF  EXISTS(select  1 
                   from conta.trelacion_contable  rc 
                   where rc.id_gestion = v_parametros.id_gestion 
                     and rc.id_tipo_relacion_contable = v_parametros.id_tipo_relacion_contable
                     and rc.estado_reg = 'activo'  
                     and (rc.id_tabla = v_parametros.id_tabla or rc.id_tabla  is null ) 
                     and id_relacion_contable!=v_parametros.id_relacion_contable ) THEN
                     
                     raise exception 'Ya existe una relacion contable paes este elemento';
                     
               END IF;   
            
            END IF;
            
            IF  pxp.f_existe_parametro(p_tabla, 'defecto') THEN
            
               v_defecto =  v_parametros.defecto;
        
            ELSE
            
               v_defecto = 'no';
            
            
            END IF;
            
            
            IF  v_defecto = 'si'   THEN
             --si el valor es marcado como defecto es valido para cualquier atributo de la tabla  
               v_parametros.id_tabla = NULL;
               
             --validamos que solo exista un parametro por defecto activo para la gestion 
             
             
                IF   exists (select 1 
                             from conta.trelacion_contable rc 
                             where rc.defecto='si'  
                               and rc.id_tabla is NULL 
                                and (rc.id_centro_costo = v_parametros.id_centro_costo or rc.id_centro_costo is NULL)
                               and rc.id_tipo_relacion_contable = v_parametros.id_tipo_relacion_contable
                               and rc.id_gestion = v_parametros.id_gestion
                               and rc.estado_reg='activo'
                               and rc.id_relacion_contable != v_parametros.id_relacion_contable)     THEN
                
                   
                      raise exception 'Ya existe un valor por defecto para este tipo de relacion contable'; 
                    
                END IF;  
               
            
            END IF;
        
        
			--Sentencia de la modificacion
			update conta.trelacion_contable set
			id_tipo_relacion_contable = v_parametros.id_tipo_relacion_contable,
			id_cuenta = v_parametros.id_cuenta,
			id_partida = v_parametros.id_partida,
			id_gestion = v_parametros.id_gestion,
			id_auxiliar = v_parametros.id_auxiliar,
			id_centro_costo = v_parametros.id_centro_costo,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_tabla = v_parametros.id_tabla,
            defecto = v_defecto
			where id_relacion_contable=v_parametros.id_relacion_contable;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Relación Contable modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_relacion_contable',v_parametros.id_relacion_contable::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_RELCON_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		16-05-2013 21:52:14
	***********************************/

	elsif(p_transaccion='CONTA_RELCON_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.trelacion_contable
            where id_relacion_contable=v_parametros.id_relacion_contable;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Relación Contable eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_relacion_contable',v_parametros.id_relacion_contable::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
		
	/*********************************    
 	#TRANSACCION:  'CONTA_REPRELCON_REP'
 	#DESCRIPCION:	Replicación de parametrización de Relaciones Contables
 	#AUTOR:			RCM	
 	#FECHA:			10/12/2013
	***********************************/

	elsif(p_transaccion='CONTA_REPRELCON_REP')then

		begin
			--Llamada a la función de replicación
			v_resp_rep = conta.f_replicar_relacion_contable_cambio_gestion(v_parametros.id_relacion_contable, p_id_usuario);
            
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Replicacion realizada'); 
            v_resp = pxp.f_agrega_clave(v_resp,'observaciones',v_resp_rep); 
              
            --Devuelve la respuesta
            return v_resp;

		end;
   
    /*********************************    
 	#TRANSACCION:  'CONTA_GDLB_IME'
 	#DESCRIPCION:	recupera los departamentos de libro de bancos relacionados al departamento de contabilidad
 	#AUTOR:		admin	
 	#FECHA:		16-05-2013 21:52:14
	***********************************/

	elsif(p_transaccion='CONTA_GDLB_IME')then

		begin
			
            select
             pxp.list(dd.id_depto_origen::varchar)
            into
             v_id_deptos_lbs
            
            from param.tdepto_depto dd
            inner join param.tdepto d on d.id_depto = dd.id_depto_origen
            inner join segu.tsubsistema s on s.id_subsistema = d.id_subsistema and s.codigo = 'TES'
            where  dd.id_depto_destino = v_parametros.id_depto_conta and  d.modulo = 'LB';
        
        
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','relacion depto lb - conta)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_depto_conta',v_parametros.id_depto_conta::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'id_deptos_lbs',v_id_deptos_lbs::varchar);
            
            
              
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
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION conta.ft_relacion_contable_ime(integer, integer, character varying, character varying)
  OWNER TO postgres;
