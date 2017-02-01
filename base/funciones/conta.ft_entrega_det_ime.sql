--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_entrega_det_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_entrega_det_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tentrega_det'
 AUTOR: 		 (admin)
 FECHA:	        17-11-2016 19:50:46
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
	v_id_entrega_det	integer;
    v_registros			record;
    v_c31				varchar;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_entrega_det_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_END_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		17-11-2016 19:50:46
	***********************************/

	if(p_transaccion='CONTA_END_INS')then
					
        begin
        	
            --verificar que no este asociado a otra entrega
            
            
             v_c31 = null;
             select 
                c.c31
              into 
                v_c31
             from conta.tint_comprobante c 
             where c.id_int_comprobante =  v_parametros.id_int_comprobante;
                 
             if v_c31 is not null  and trim(v_c31) != ''   then                 
                raise exception 'El comprobantes (id: %)  ya se encuentra relacionado con la entrega o C31: %',  v_parametros.id_int_comprobante ,v_c31;
             end if;
            
            IF v_parametros.id_entrega is null THEN
               raise exception 'El id de la entrega no puede ser nulo';
            END IF;
            
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
              v_parametros.id_int_comprobante,
              v_parametros.id_entrega,
              p_id_usuario,
              now(),
              v_parametros._nombre_usuario_ai,
              v_parametros._id_usuario_ai,
              null,
			null
							
			
			
			)RETURNING id_entrega_det into v_id_entrega_det;
            
            
             --  temporalmente marca el cbte relacionado a la entrega
             update conta.tint_comprobante  set
                 c31 =  'ENT ID:'||v_parametros.id_entrega::varchar,
                 fecha_c31 = now()
              where id_int_comprobante = v_parametros.id_int_comprobante;
            
            --marca el cbte como relacionado
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Entrega Detalle almacenado(a) con exito (id_entrega_det'||v_id_entrega_det||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_entrega_det',v_id_entrega_det::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	
	/*********************************    
 	#TRANSACCION:  'CONTA_END_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		17-11-2016 19:50:46
	***********************************/

	elsif(p_transaccion='CONTA_END_ELI')then

		begin
        
       -- raise exception 'id_entrega_det %', v_parametros.id_entrega_det;
        
           select 
               e.estado,
               e.id_entrega,
               ed.id_int_comprobante
           into
              v_registros
           from conta.tentrega_det ed
           inner join conta.tentrega e on e.id_entrega = ed.id_entrega
           where ed.id_entrega_det = v_parametros.id_entrega_det;
        
          if v_registros.estado != 'borrador' then
             raise exception 'Solo puede quitar las relaciones en entregas borrador';
          end if;
        
            --desmarcar el cbte como no relacionado
             update conta.tint_comprobante  set
               c31 = NULL,
               fecha_c31 = NULL
             where id_int_comprobante=v_registros.id_int_comprobante;
             
			--Sentencia de la eliminacion
			delete from conta.tentrega_det
            where id_entrega_det=v_parametros.id_entrega_det;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Entrega Detalle eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_entrega_det',v_parametros.id_entrega_det::varchar);
              
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