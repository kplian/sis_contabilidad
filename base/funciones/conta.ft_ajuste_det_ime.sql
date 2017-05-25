--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_ajuste_det_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_ajuste_det_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tajuste_det'
 AUTOR: 		 (admin)
 FECHA:	        10-12-2015 15:16:44
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
	v_id_ajuste_det			integer;
    v_registros				record;
    v_reg_cuenta			record;
    v_registros_det			record;
    v_tc_mb					numeric;
    v_tc_mt					numeric;
    v_id_moneda_base 	    integer;
    v_id_moneda_tri  	    integer;
    va_mayor 				numeric[];
    v_mayor 				numeric;
    v_act_mb				numeric;
    v_act_mt				numeric;
    v_dif_mb				numeric;
    v_dif_mt				numeric;
    v_conta_prioridad_depto_inter		varchar;
    v_depto_inter			boolean;
    v_revisado 				varchar;
    
  
			    
BEGIN

    v_nombre_funcion = 'conta.ft_ajuste_det_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_AJTD_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		10-12-2015 15:16:44
	***********************************/

	if(p_transaccion='CONTA_AJTD_INS')then
					
        begin
        
              select 
                 a.*,
                 dep.prioridad 
              into 
               v_registros
              from conta.tajuste a
              inner join param.tdepto dep on a.id_depto_conta = dep.id_depto
              where  a.id_ajuste = v_parametros.id_ajuste;
              
              IF v_registros.estado != 'borrador' THEN
                 raise exception 'Solo puede insertar cuentas en ajustes en borrador';              
              END IF;
              
              
              --verificamos si es un depto internacional
              v_conta_prioridad_depto_inter = pxp.f_get_variable_global('conta_prioridad_depto_inter');
              
              IF  v_registros.prioridad::varchar =   v_conta_prioridad_depto_inter THEN
                 v_depto_inter = true;
              ELSE
                 v_depto_inter =  false;
              END IF;
              
              
              --verificar que la ceutan no se duplique
              IF v_parametros.id_cuenta_bancaria is not null  and  v_registros.tipo = 'bancos' THEN
              
                    IF Exists (select    1 
                             from conta.tajuste_det ad 
                             where ad.id_ajuste = v_parametros.id_ajuste
                                   and ad.id_cuenta_bancaria = v_parametros.id_cuenta_bancaria)  then
                             
                             raise exception 'La cuenta bancaria ya esta registrada para este ajuste';
                    end if;
              
              END IF;
              
              
              IF Exists (select    1 
                         from conta.tajuste_det ad 
                         where ad.id_ajuste = v_parametros.id_ajuste
                               and ad.id_cuenta = v_parametros.id_cuenta)  then
                         
                         raise exception 'La cuenta ya esta registrada para este ajuste';
              end if;
            
            
              v_id_moneda_base = param.f_get_moneda_base();
              v_id_moneda_tri  = param.f_get_moneda_triangulacion();
            
             
           
           
           
             v_id_ajuste_det = conta.f_ajusta_tc_cuenta(p_id_usuario, 
                                                        v_parametros.id_ajuste, 
                                                        v_registros.tipo,
                                                        v_parametros.id_cuenta,
                                                        v_parametros.id_auxiliar,
                                                        v_parametros.id_partida_ingreso,
                                                        v_parametros.id_partida_egreso,
                                                        v_parametros.id_cuenta_bancaria,
                                                        v_parametros.id_moneda_ajuste,
                                                        v_id_moneda_base, 
                                                        v_id_moneda_tri, 
                                                        v_registros.fecha,
                                                        v_registros.id_depto_conta,
                                                        v_depto_inter);
           
           
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Ajuste Detalle almacenado(a) con exito (id_ajuste_det'||v_id_ajuste_det||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_ajuste_det',v_id_ajuste_det::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_AJTD_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		10-12-2015 15:16:44
	***********************************/

	elsif(p_transaccion='CONTA_AJTD_MOD')then

		begin
        
              select 
                 a.*,
                 dep.prioridad 
              into 
               v_registros
              from conta.tajuste a
              inner join param.tdepto dep on a.id_depto_conta = dep.id_depto
              where  a.id_ajuste = v_parametros.id_ajuste;
              
              IF v_registros.estado != 'borrador' THEN
                 raise exception 'Solo puede modificar ajustes en borrador';              
              END IF;
			
            update conta.tajuste_det  set			
			  dif_mb =  v_parametros.dif_mb,
              dif_mt = v_parametros.dif_mt,
              id_usuario_mod = p_id_usuario,
              fecha_mod = now(),
              dif_manual = 'si'
              
              
            where id_ajuste_det = v_parametros.id_ajuste_det;
            
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cambio manual de diferencias para el ajuste id:'||v_parametros.id_ajuste_det); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_ajuste_det',v_parametros.id_ajuste_det::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;
     
    /*********************************    
 	#TRANSACCION:  'CONTA_REVAJ_IME'
 	#DESCRIPCION:	cambiar el estado de la revision para el ajuste indicado
 	#AUTOR:		admin	
 	#FECHA:		10-12-2015 15:16:44
	***********************************/

	elsif(p_transaccion='CONTA_REVAJ_IME')then

		begin
        
             select 
              a.revisado,
              a.id_ajuste
            into 
              v_registros_det
            from conta.tajuste_det a where a.id_ajuste_det =v_parametros.id_ajuste_det;
            
             IF  v_registros_det.revisado = 'si' THEN
             v_revisado = 'no';
            ELSE
             v_revisado = 'si';
            END IF;
            
            
             select 
                 a.*
              into 
               v_registros
             from conta.tajuste a
             where  a.id_ajuste = v_registros_det.id_ajuste;
            
            
             IF v_registros.estado != 'borrador' THEN
                 raise exception 'Solo puede revisar ajsute en borrador';              
             END IF;
            
            
            update conta.tajuste_det set			
			  revisado = v_revisado,
              id_usuario_mod = p_id_usuario,
              fecha_mod = now()
            where id_ajuste_det=v_parametros.id_ajuste_det;
			
           
            
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','cambio la revisi{on del ajuste(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_ajuste_det',v_parametros.id_ajuste_det::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;   
        
        

	/*********************************    
 	#TRANSACCION:  'CONTA_AJTD_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		10-12-2015 15:16:44
	***********************************/

	elsif(p_transaccion='CONTA_AJTD_ELI')then

		begin
        
            select 
               * 
            into 
             v_registros_det
            from conta.tajuste_det ad
            where  ad.id_ajuste_det = v_parametros.id_ajuste_det;
        
             select 
               * 
            into 
             v_registros
            from conta.tajuste a
            where  a.id_ajuste = v_registros_det.id_ajuste;
            
            IF v_registros.estado != 'borrador' THEN
               raise exception 'Solo puede eliminar  cuentas en ajustes en borrador';              
            END IF;
        
        
			--Sentencia de la eliminacion
			delete from conta.tajuste_det
            where id_ajuste_det=v_parametros.id_ajuste_det;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Ajuste Detalle eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_ajuste_det',v_parametros.id_ajuste_det::varchar);
              
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