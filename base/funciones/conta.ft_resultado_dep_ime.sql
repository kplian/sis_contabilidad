--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_resultado_dep_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_resultado_dep_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tresultado_dep'
 AUTOR: 		 (admin)
 FECHA:	        14-07-2015 13:40:02
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
	v_id_resultado_dep		integer;
    va_id_resultado_plantilla		integer[];
			    
BEGIN

    v_nombre_funcion = 'conta.ft_resultado_dep_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_RESDEP_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		14-07-2015 13:40:02
	***********************************/

	if(p_transaccion='CONTA_RESDEP_INS')then
					
        begin
        
            --validar que no exista dependencia ciclica ...
             IF v_parametros.id_resultado_plantilla = v_parametros.id_resultado_plantilla_hijo THEN
               raise exception 'No debe configurar una depedencia ciclica';
             END IF;
             
             WITH RECURSIVE path_rec(id_resultado_plantilla_hijo, id_resultado_plantilla ) AS (
                SELECT  
                  rdep.id_resultado_plantilla_hijo,
                  rdep.id_resultado_plantilla
                FROM conta.tresultado_dep rdep
                WHERE rdep.id_resultado_plantilla = v_parametros.id_resultado_plantilla
        	
                UNION
                SELECT
               	  rdep2.id_resultado_plantilla_hijo,
                  rdep2.id_resultado_plantilla
                FROM conta.tresultado_dep rdep2
                inner join path_rec  pr on rdep2.id_resultado_plantilla = pr.id_resultado_plantilla_hijo 
        	)
            SELECT 
              pxp.aggarray(id_resultado_plantilla_hijo) 
            into
              va_id_resultado_plantilla
            FROM path_rec;
             
            
            --raise exception '%',va_id_resultado_plantilla;
            IF  v_parametros.id_resultado_plantilla_hijo = ANY (va_id_resultado_plantilla ) THEN
               raise exception 'Esta plantilla ya se encuentra asignada de manera recursiva';
            END IF;
            
            --revisar que la prioridad sea unica para plantilla
            
            IF v_parametros.prioridad in (select rdep.prioridad from conta.tresultado_dep rdep where rdep.id_resultado_plantilla = v_parametros.id_resultado_plantilla)  THEN
              raise exception 'Ya existe una dependencia cone esta prioridad';
            END IF;
            
            
        	--Sentencia de la insercion
        	insert into conta.tresultado_dep(
              id_resultado_plantilla,
              id_resultado_plantilla_hijo,
              obs,
              prioridad,
              estado_reg,
              id_usuario_ai,
              fecha_reg,
              usuario_ai,
              id_usuario_reg,
              fecha_mod,
              id_usuario_mod
              ) values(
              v_parametros.id_resultado_plantilla,
              v_parametros.id_resultado_plantilla_hijo,
              v_parametros.obs,
              v_parametros.prioridad,
              'activo',
              v_parametros._id_usuario_ai,
              now(),
              v_parametros._nombre_usuario_ai,
              p_id_usuario,
              null,
              null
			)RETURNING id_resultado_dep into v_id_resultado_dep;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Dependencias almacenado(a) con exito (id_resultado_dep'||v_id_resultado_dep||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_resultado_dep',v_id_resultado_dep::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_RESDEP_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		14-07-2015 13:40:02
	***********************************/

	elsif(p_transaccion='CONTA_RESDEP_MOD')then

		begin
        
              --validar que no exista dependencia ciclica ...
             IF v_parametros.id_resultado_plantilla = v_parametros.id_resultado_plantilla_hijo THEN
               raise exception 'No debe configurar una dependencia ciclica';
             END IF;
             
             WITH RECURSIVE path_rec(id_resultado_plantilla_hijo, id_resultado_plantilla ) AS (
                SELECT  
                  rdep.id_resultado_plantilla_hijo,
                  rdep.id_resultado_plantilla
                FROM conta.tresultado_dep rdep
                WHERE rdep.id_resultado_plantilla = v_parametros.id_resultado_plantilla
                      and rdep.id_resultado_dep != v_parametros.id_resultado_dep
        	
                UNION
                SELECT
               	  rdep2.id_resultado_plantilla_hijo,
                  rdep2.id_resultado_plantilla
                FROM conta.tresultado_dep rdep2
                inner join path_rec  pr on rdep2.id_resultado_plantilla = pr.id_resultado_plantilla_hijo 
        	)
            SELECT 
              pxp.aggarray(id_resultado_plantilla_hijo) 
            into
              va_id_resultado_plantilla
            FROM path_rec;
             
            IF  v_parametros.id_resultado_plantilla_hijo = ANY (va_id_resultado_plantilla ) THEN
               raise exception 'esta plantilla ya se encuentra asignada de manera recursiva';
            END IF;
            
            
            --revisar que la prioridad sea unica para plantilla
            
            IF v_parametros.prioridad in (select rdep.prioridad from conta.tresultado_dep rdep where rdep.id_resultado_plantilla = v_parametros.id_resultado_plantilla and rdep.id_resultado_dep != v_parametros.id_resultado_dep )  THEN
              raise exception 'Ya existe una dependencia cone esta prioridad';
            END IF;
            
            
			--Sentencia de la modificacion
			update conta.tresultado_dep set
			id_resultado_plantilla = v_parametros.id_resultado_plantilla,
            id_resultado_plantilla_hijo = v_parametros.id_resultado_plantilla_hijo,
			obs = v_parametros.obs,
			prioridad = v_parametros.prioridad,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_resultado_dep=v_parametros.id_resultado_dep;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Dependencias modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_resultado_dep',v_parametros.id_resultado_dep::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_RESDEP_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		14-07-2015 13:40:02
	***********************************/

	elsif(p_transaccion='CONTA_RESDEP_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tresultado_dep
            where id_resultado_dep=v_parametros.id_resultado_dep;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Dependencias eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_resultado_dep',v_parametros.id_resultado_dep::varchar);
              
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