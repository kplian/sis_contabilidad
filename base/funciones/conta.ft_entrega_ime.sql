--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_entrega_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_entrega_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tentrega'
 AUTOR: 		 (admin)
 FECHA:	        17-11-2016 19:50:19
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
	v_id_entrega			integer;
    v_ids					varchar[];
    v_i						integer;
    v_id_entrega_det		integer;
    v_c31					varchar; 
    v_registros_ent			record;
    v_registros				record;
    v_sw_tmp				boolean;
    v_registros_aux			record;
    v_cont					integer;
    v_aux					boolean;
    v_valor					varchar;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_entrega_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_ENT_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		17-11-2016 19:50:19
	***********************************/

	if(p_transaccion='CONTA_ENT_ELI')then

		begin
			--Sentencia de la eliminacion
            
            select 
               *
            into
              v_registros_ent
            from conta.tentrega en
            where en.id_entrega =v_parametros.id_entrega;
            
            if v_registros_ent.estado != 'borrador' then
               raise exception 'Solo puede borrar entregas en estado borrador';
            end if;
            
            
            FOR v_registros in (
            						select * 
                                    from conta.tentrega_det ed 
                                    where ed.id_entrega =  v_parametros.id_entrega
                                 ) LOOP
                      
                      --> quita la relacion con la entrega           
                      update conta.tint_comprobante  set
                         c31 = NULL,
                         fecha_c31 = NULL
                      where id_int_comprobante = v_registros.id_int_comprobante;
                      
             END LOOP;
            
             delete from conta.tentrega_det
             where id_entrega=v_parametros.id_entrega; 
            
			 delete from conta.tentrega
             where id_entrega=v_parametros.id_entrega;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Entrega eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_entrega',v_parametros.id_entrega::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
        
    /****************************************    
 	#TRANSACCION:  'CONTA_CRENT_INS'
 	#DESCRIPCION:	Creación de entregas, se ejecuta desde la interface de libro diario
 	#AUTOR:		RAC KPLIAN	
 	#FECHA:		17-11-2016 19:50:19
	************************************************/

	elsif(p_transaccion='CONTA_CRENT_INS')then

		begin
        
             if v_parametros.total_cbte < 1 then
                raise exception 'No tiene comprobantes para entregar';
             end if;
        
             insert into conta.tentrega(
                      fecha_c31,
                      c31,
                      estado,
                      estado_reg,
                      id_usuario_ai,
                      usuario_ai,
                      fecha_reg,
                      id_usuario_reg,
                      fecha_mod,
                      id_usuario_mod,
                      id_depto_conta
                  ) values(
                      now(),
                      '',
                      'borrador', --> estado de la entrega
                      'activo',
                      v_parametros._id_usuario_ai,
                      v_parametros._nombre_usuario_ai,
                      now(),
                      p_id_usuario,
                      null,
                      null,
                      v_parametros.id_depto_conta
			)RETURNING id_entrega into v_id_entrega;
            
            -- 
            
            v_ids = string_to_array(v_parametros.id_int_comprobantes,',');
            v_i = 1;
            
            WHILE v_i <= v_parametros.total_cbte LOOP
            
                 --  valida que no tenga ninguna entrega ya configurada
                 v_c31 = null;
                 select 
                    c.c31
                  into 
                    v_c31
                 from conta.tint_comprobante c 
                 where c.id_int_comprobante =   v_ids[v_i]::integer;
                 
                 if v_c31 is not null  and trim(v_c31) != ''   then                 
                    raise exception 'El comprobantes (id: %)  ya se encuentra relacionado con la entrega o C31: %', v_ids[v_i] ,v_c31;
                 end if;
            
               
                 --Sentencia de la insercion
                insert into conta.tentrega_det(
                    estado_reg,
                    id_int_comprobante,
                    id_entrega,
                    id_usuario_reg,
                    fecha_reg,
                    usuario_ai,
                    id_usuario_ai,
                    id_usuario_mod,
                    fecha_mod
                ) values(
                    'activo',
                    v_ids[v_i]::integer,
                    v_id_entrega,
                    p_id_usuario,
                    now(),
                    v_parametros._nombre_usuario_ai,
                    v_parametros._id_usuario_ai,
                    null,
                    null    			
                )RETURNING id_entrega_det into v_id_entrega_det;
                
                --  temporalmente marca el cbte relacionado a la entrega
                update conta.tint_comprobante  set
                    c31 =  'ENT ID:'||v_id_entrega::varchar,
                    fecha_c31 = now()
                where id_int_comprobante = v_ids[v_i]::integer;
                
                v_i = v_i + 1;
                
            END LOOP;
			
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Creación de entrega contable para los cbte '||v_parametros.id_int_comprobantes); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_entrega',v_id_entrega::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
        
/****************************************    
 	#TRANSACCION:  'CONTA_FINENTR_INS'
 	#DESCRIPCION:	Fin de la entrega
 	#AUTOR:		RAC KPLIAN	
 	#FECHA:		17-11-2016 19:50:19
	************************************************/

	elsif(p_transaccion='CONTA_FINENTR_INS')then

		begin
           
        
            --  verificar que la estrega este en estado  borrador
            select
              *
            into
              v_registros
            from conta.tentrega en 
            where en.id_entrega = v_parametros.id_entrega;
            
             
            --  actualizar el la fecha y nro de c31 en la entrega, c31 y fecha  en los cbte
            
            update conta.tentrega set
              c31 = v_parametros.c31,
              fecha_c31 = v_parametros.fecha_c31,
              obs = v_parametros.obs,
              id_tipo_relacion_comprobante = v_parametros.id_tipo_relacion_comprobante,
              estado = 'finalizado'
            where id_entrega = v_parametros.id_entrega;
            
            v_sw_tmp = true;
            --  lista todos los cbtes a entrega
            v_cont = 0;
            FOR v_registros_ent in (
            						select 
                                       ed.id_entrega,
                                       ed.id_entrega_det,
                                       cbte.id_int_comprobante,
                                       cbte.id_tipo_relacion_comprobante,
                                       cbte.id_int_comprobante_fks
                                    from conta.tentrega_det ed 
                                    inner join conta.tint_comprobante cbte on cbte.id_int_comprobante = ed.id_int_comprobante
                                    where ed.id_entrega =  v_parametros.id_entrega
                                 ) LOOP
                  --  actulizar los combronbastes relacionados
                  
                  --  temporalmente marca el cbte relacionado a la entrega
                  update conta.tint_comprobante  set
                      c31 =  v_parametros.c31,
                      fecha_c31 = v_parametros.fecha_c31
                  where id_int_comprobante = v_registros_ent.id_int_comprobante;
                     
                  --  si existe relacion,  identificar los comprobantes relacionados SIN NRO DE C31             
                  IF v_parametros.id_tipo_relacion_comprobante is not null AND v_parametros.id_tipo_relacion_comprobante = v_registros_ent.id_tipo_relacion_comprobante THEN
                   		
                       --  actualizar los combronbastes relacionados
                        FOR v_registros_aux in (select
                                                  cbte.id_int_comprobante,
                                                  cbte.c31
                                              from conta.tint_comprobante cbte
                                              where cbte.id_int_comprobante = ANY(v_registros_ent.id_int_comprobante_fks)) LOOP
                                
                                --actulizamos solo si no tiene un C31 relacionado
                                IF (v_registros_aux.c31 is null or trim(v_registros_aux.c31) = '') THEN
                                     
                                      --actuliza cbte relacionado
                                      update conta.tint_comprobante  set
                                          c31 =  v_parametros.c31,
                                          fecha_c31 = v_parametros.fecha_c31
                                      where id_int_comprobante = v_registros_aux.id_int_comprobante;
                               
                                 END IF;
                                
                                v_cont = v_cont + 1;
                        END LOOP; 
                        
                  END IF;
                  
                     --  IF verificar si es necesario llamar a libro de bancos
                     v_valor = param.f_get_depto_param( v_registros.id_depto_conta, 'ENTREGA');
                    
                     IF v_valor = 'SI' THEN
                         -- llamda a libro de bnacos
                         v_aux = tes.f_integracion_libro_bancos(p_id_usuario,v_registros_ent.id_int_comprobante); --si es una esntrega 
                       
                     END IF;
                  
                     --  marca si tiene cbtes 
                     v_sw_tmp = false;
                      
             END LOOP;
              
              
            --s no tiene cbtes lanza un error
            IF v_sw_tmp THEN
               raise exception 'no tiene ningun comprobante';
            END IF;
            
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','cambio de estado para la entrega id: '||v_parametros.id_entrega); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_entrega',v_id_entrega::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'v_cont',v_cont::varchar);
            
              
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