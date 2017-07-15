--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_cuenta_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.f_cuenta_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tcuenta'
 AUTOR: 		Gonzalo Sarmiento Sejas
 FECHA:	        21-02-2013 15:04:03
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
	v_id_cuenta				integer;
    
    v_id_cuenta_padre 		integer;
    v_tipo_cuenta_pat 		varchar;
    v_registros_cuenta		record;
    v_registros				record;
    v_registros_ges			record;
    v_id_gestion_destino	integer;
    v_conta					integer;
    v_id_cuenta_padre_des	integer;
    v_reg_cuenta_ori		record;
			    
BEGIN

    v_nombre_funcion = 'conta.f_cuenta_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_CTA_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		21-02-2013 15:04:03
	***********************************/

	if(p_transaccion='CONTA_CTA_INS')then
					
        begin
           
           IF v_parametros.id_cuenta_padre != 'id' and v_parametros.id_cuenta_padre != '' THEN
             v_id_cuenta_padre = v_parametros.id_cuenta_padre::integer;
           ELSE
           --verificamos que no existe una cuenta raiz para este tipo_cuenta
           
               IF(exists (select 1  
                          from conta.tcuenta  c 
                          where c.id_gestion = v_parametros.id_gestion 
                            and c.tipo_cuenta = v_parametros.tipo_cuenta
                            and c.estado_reg='activo')) THEN
                            
                    raise exception 'solo se permite una cuenta base de %',v_parametros.tipo_cuenta;        
               
                END IF;
           END IF;
        
        
        IF v_parametros.tipo_cuenta_pat = '' THEN
       		 v_tipo_cuenta_pat = NULL;
        ELSE
       		 v_tipo_cuenta_pat = v_parametros.tipo_cuenta_pat;
        
        END IF;
        
        -- buscamos que el nuero de cuenta no se repita
        
        IF exists(SELECT 1
                  from conta.tcuenta c 
                  where trim(c.nro_cuenta) = trim(v_parametros.nro_cuenta)
                  and c.id_gestion = v_parametros.id_gestion
                  and c.estado_reg = 'activo') THEN
            
            raise exception 'El código de cuenta  % ya existe', v_parametros.nro_cuenta;
        
        END IF;
        
        
        
        	--Sentencia de la insercion
        	insert into conta.tcuenta(
                id_cuenta_padre,
                nombre_cuenta,
                sw_auxiliar,
                nivel_cuenta,
                tipo_cuenta,
                desc_cuenta,
                tipo_cuenta_pat,
                nro_cuenta,
                id_moneda,
                sw_transaccional,
                id_gestion,
                estado_reg,
                fecha_reg,
                id_usuario_reg,
                fecha_mod,
                id_usuario_mod,
                eeff,
                valor_incremento,
                sw_control_efectivo,
                id_config_subtipo_cuenta
          	) values(
                v_id_cuenta_padre,
                v_parametros.nombre_cuenta,
                v_parametros.sw_auxiliar,
                NULL,
                v_parametros.tipo_cuenta,
                v_parametros.desc_cuenta,
                v_tipo_cuenta_pat,
                v_parametros.nro_cuenta,
                v_parametros.id_moneda,
                v_parametros.sw_transaccional,
                v_parametros.id_gestion,
                'activo',
                now(),
                p_id_usuario,
                null,
                null,
                string_to_array(v_parametros.eeff,',')::varchar[],
                v_parametros.valor_incremento,
                v_parametros.sw_control_efectivo,
                v_parametros.id_config_subtipo_cuenta
							
			)RETURNING id_cuenta into v_id_cuenta;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cuenta almacenado(a) con exito (id_cuenta'||v_id_cuenta||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta',v_id_cuenta::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CTA_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		21-02-2013 15:04:03
	***********************************/

	elsif(p_transaccion='CONTA_CTA_MOD')then

		begin
           
        IF v_parametros.id_cuenta_padre != 'id' and v_parametros.id_cuenta_padre != '' THEN
             v_id_cuenta_padre=v_parametros.id_cuenta_padre::integer;
        END IF;
        
        
        IF v_parametros.tipo_cuenta_pat = ''  or v_parametros.tipo_cuenta_pat = 'null' THEN
       		 v_tipo_cuenta_pat = NULL;
        ELSE
       		 v_tipo_cuenta_pat = v_parametros.tipo_cuenta_pat;
        
        END IF;
        
        
        IF exists(SELECT 1
                  from conta.tcuenta c 
                  where trim(c.nro_cuenta) = trim(v_parametros.nro_cuenta)
                  and c.id_gestion = v_parametros.id_gestion
                  and c.estado_reg = 'activo'
                  and c.id_cuenta !=  v_parametros.id_cuenta ) THEN            
            raise exception 'El código de cuenta  % ya existe', v_parametros.nro_cuenta;        
        END IF;
        
            --  obtener valores previos
            select
              cue.valor_incremento,
              cue.eeff,
              cue.tipo_cuenta,
              cue.id_config_subtipo_cuenta
            into
              v_registros
            from conta.tcuenta cue
            where cue.id_cuenta = v_parametros.id_cuenta;
            
           
        
			--Sentencia de la modificacion
			update conta.tcuenta set
              nombre_cuenta = v_parametros.nombre_cuenta,
              sw_auxiliar = v_parametros.sw_auxiliar,
              tipo_cuenta = v_parametros.tipo_cuenta,
              id_cuenta_padre = v_id_cuenta_padre,
              desc_cuenta = v_parametros.desc_cuenta,
              tipo_cuenta_pat = v_tipo_cuenta_pat,
              nro_cuenta = v_parametros.nro_cuenta,
              id_moneda = v_parametros.id_moneda,
              sw_transaccional = v_parametros.sw_transaccional,
              id_gestion = v_parametros.id_gestion,
              fecha_mod = now(),
              id_usuario_mod = p_id_usuario,
              eeff = string_to_array(v_parametros.eeff,',')::varchar[],
              valor_incremento = v_parametros.valor_incremento,
              sw_control_efectivo =  v_parametros.sw_control_efectivo,
              id_config_subtipo_cuenta = v_parametros.id_config_subtipo_cuenta
			where id_cuenta = v_parametros.id_cuenta;
             
            --raise exception '% ', v_parametros.id_cuenta;
            --si los valores por defecto cambiarno modificar recursivamente
            IF       v_registros.eeff != string_to_array(v_parametros.eeff,',')::varchar[] 
                or   v_registros.valor_incremento != v_parametros.valor_incremento 
                or  v_registros.tipo_cuenta != v_parametros.tipo_cuenta  
                or  (v_registros.id_config_subtipo_cuenta is null or v_registros.id_config_subtipo_cuenta != v_parametros.id_config_subtipo_cuenta) THEN
                
                 FOR v_registros_cuenta in  (
                     WITH RECURSIVE cuenta_inf(id_cuenta, id_cuenta_padre) AS (
                          select 
                            c.id_cuenta,
                            c.id_cuenta_padre
                          from conta.tcuenta c  
                          where c.id_cuenta = v_parametros.id_cuenta
                        UNION
                          SELECT
                           c2.id_cuenta,
                           c2.id_cuenta_padre
                          FROM conta.tcuenta c2, cuenta_inf pc
                          WHERE c2.id_cuenta_padre = pc.id_cuenta  and c2.estado_reg = 'activo'
                        )
                       SELECT * FROM cuenta_inf) LOOP
                    
                    update conta.tcuenta c  set
                      eeff = string_to_array(v_parametros.eeff,',')::varchar[],
                      valor_incremento = v_parametros.valor_incremento,
                      tipo_cuenta = v_parametros.tipo_cuenta,
                      id_config_subtipo_cuenta = v_parametros.id_config_subtipo_cuenta
                     where id_cuenta = v_registros_cuenta.id_cuenta;
                     
                   
                
               END LOOP;
            
            
            END IF;
              
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cuenta modificado(a): '|| COALESCE(v_parametros.id_cuenta::varchar,'S/I')); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta',v_parametros.id_cuenta::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CONTA_CTA_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		21-02-2013 15:04:03
	***********************************/

	elsif(p_transaccion='CONTA_CTA_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from conta.tcuenta
            where id_cuenta=v_parametros.id_cuenta;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cuenta eliminado(a)  :'|| COALESCE(v_parametros.id_cuenta::varchar,'S/I')); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta',v_parametros.id_cuenta::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
    
    /*********************************    
 	#TRANSACCION:  'CONTA_CLONARCUE_IME'
 	#DESCRIPCION:	Clona el plan de cuentas para la gestion indicada
 	#AUTOR:	    Rensi Arteaga Copari
 	#FECHA:		03-08-2015 15:04:03
	***********************************/

	elsif(p_transaccion='CONTA_CLONARCUE_IME')then

		begin
			
           --  definir id de la gestion siguiente
    
           select
              ges.id_gestion,
              ges.gestion,
              ges.id_empresa
           into 
              v_registros_ges
           from 
           param.tgestion ges
           where ges.id_gestion = v_parametros.id_gestion;
          
          
          
           select
              ges.id_gestion
           into 
              v_id_gestion_destino
           from 
           param.tgestion ges
           where       ges.gestion = v_registros_ges.gestion + 1 
                   and ges.id_empresa = v_registros_ges.id_empresa 
                   and ges.estado_reg = 'activo';
           
          IF v_id_gestion_destino is null THEN        
                   raise exception 'no se encontró una siguiente gestión preparada (primero cree  gestión siguiente)';
          END IF;
          v_conta = 0;
          
          
          --  consulta recursiva de cuentas de la gestion origen
          FOR v_registros_cuenta in  (
                     WITH RECURSIVE cuenta_inf(id_cuenta, id_cuenta_padre) AS (
                          select 
                            c.id_cuenta,
                            c.id_cuenta_padre
                          from conta.tcuenta c  
                          where  c.id_gestion = v_parametros.id_gestion and c.id_cuenta_padre is NULL and c.estado_reg = 'activo'
                                 
                        UNION
                          SELECT
                           c2.id_cuenta,
                           c2.id_cuenta_padre
                          FROM conta.tcuenta c2, cuenta_inf pc
                          WHERE c2.id_cuenta_padre = pc.id_cuenta  and c2.estado_reg = 'activo'
                        )
                       SELECT * FROM cuenta_inf) LOOP
         
            
            
               --  busca si ya existe la relacion en la tablas de cuentas ids
                  IF NOT EXISTS(select 1 from conta.tcuenta_ids i where i.id_cuenta_uno =  v_registros_cuenta.id_cuenta) THEN
                     
                         
                         IF v_registros_cuenta.id_cuenta_padre is not null THEN
                            --  busca la cuenta del padre en cuetaids
                             v_id_cuenta_padre_des  = NULL;
                             select
                               cid.id_cuenta_dos
                             into
                               v_id_cuenta_padre_des
                             from conta.tcuenta_ids cid
                             where  cid.id_cuenta_uno = v_registros_cuenta.id_cuenta_padre;
                         END IF;
                         
                         
                         --obtiene los dastos de la cuenta origen
                         v_reg_cuenta_ori = NULL;
                         select * into v_reg_cuenta_ori from conta.tcuenta c where c.id_cuenta = v_registros_cuenta.id_cuenta;
                         --  inserta la cuenta para la nueva gestion
                        
                        INSERT INTO conta.tcuenta
                                (
                                  id_usuario_reg,
                                  fecha_reg,
                                  estado_reg,
                                  id_empresa,
                                  id_parametro,
                                  id_cuenta_padre,
                                  nro_cuenta,
                                  id_gestion,
                                  id_moneda,
                                  nombre_cuenta,
                                  desc_cuenta,
                                  nivel_cuenta,
                                  tipo_cuenta,
                                  sw_transaccional,
                                  sw_oec,
                                  sw_auxiliar,
                                  tipo_cuenta_pat,
                                  cuenta_sigma,
                                  sw_sigma,                              
                                  cuenta_flujo_sigma,
                                  valor_incremento,
                                  eeff,
                                  sw_control_efectivo,
                                  id_config_subtipo_cuenta
                                )
                                VALUES (
                                  p_id_usuario,
                                  now(),
                                  'activo',
                                  v_reg_cuenta_ori.id_empresa,
                                  v_reg_cuenta_ori.id_parametro,
                                  v_id_cuenta_padre_des,
                                  v_reg_cuenta_ori.nro_cuenta,
                                  v_id_gestion_destino,  --gestion destino
                                  v_reg_cuenta_ori.id_moneda,
                                  v_reg_cuenta_ori.nombre_cuenta,
                                  v_reg_cuenta_ori.desc_cuenta,
                                  v_reg_cuenta_ori.nivel_cuenta,
                                  v_reg_cuenta_ori.tipo_cuenta,
                                  v_reg_cuenta_ori.sw_transaccional,
                                  v_reg_cuenta_ori.sw_oec,
                                  v_reg_cuenta_ori.sw_auxiliar,
                                  v_reg_cuenta_ori.tipo_cuenta_pat,
                                  v_reg_cuenta_ori.cuenta_sigma,
                                  v_reg_cuenta_ori.sw_sigma,                              
                                  v_reg_cuenta_ori.cuenta_flujo_sigma,
                                  v_reg_cuenta_ori.valor_incremento,
                                  v_reg_cuenta_ori.eeff,
                                  v_reg_cuenta_ori.sw_control_efectivo,
                                  v_reg_cuenta_ori.id_config_subtipo_cuenta
                                ) RETURNING id_cuenta into v_id_cuenta;
                          
                          --insertar relacion en tre ambas gestion
                          INSERT INTO conta.tcuenta_ids (id_cuenta_uno,id_cuenta_dos, sw_cambio_gestion ) VALUES ( v_registros_cuenta.id_cuenta,v_id_cuenta, 'gestion');
                          v_conta = v_conta + 1;
                  END IF; 
            
               
           
        
             --Definicion de la respuesta
        
        
        
        
           END LOOP;
            
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Plan de cuentas clonado para la gestion: '||v_registros_ges.gestion::varchar); 
            v_resp = pxp.f_agrega_clave(v_resp,'observaciones','Se insertaron cuentas: '|| v_conta::varchar);
              
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