--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_importar_cuentas_tmp (
  p_id_gestion integer
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.f_importar_cuentas_tmp
 DESCRIPCION:     esta funcion permite carcar un plan de cuentas importado desde excel en la tabla tcuenta_tmp, y lo lleva  la tabla principal
                 tcuenta con la estructura apropiada
 AUTOR: 		 (rac)  kplian
 FECHA:	        30-09-2016 12:39:12
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

v_nombre_funcion		varchar;
v_resp					varchar;
v_contador					integer;
v_indice					integer;
v_id_cuenta					integer;
v_registros					RECORD;
v_detalle					varchar;
v_tipo_cuenta				varchar[];
v_incremento				varchar;
v_eeff						varchar;
v_id_cuenta_padre			integer;
v_array_codigo				varchar[];
                             
v_max 						integer;
v_aux 						integer;
v_codigo_padre				varchar;
v_sw_transaccional			varchar;
v_valor_incremento		varchar;
v_config_tipo_cuenta			varchar;
v_text_exu			varchar;


 

BEGIN

   	v_nombre_funcion = 'conta.f_importar_cuentas_tmp';
    
    v_contador = 1;
    
    --recorre todos los nivel previstos ... 6
    WHILE v_contador  <= 6   LOOP
    
    
              FOR v_registros in (select
                                   *
                                  from conta.tcuenta_tmp c
                                  where c.nivel = v_contador
                                   ) LOOP
                                 
                   IF v_registros.codigo is not null  THEN 
                   
                        v_config_tipo_cuenta  =  v_registros.tipo_cuenta;
                   
                        --  recupera el detalle
                             
                        IF  v_contador = 1  THEN
                           v_detalle = v_registros.c1;                        
                        ELSEIF  v_contador = 2  THEN
                           v_detalle = v_registros.c2;                        
                        ELSEIF  v_contador = 3  THEN
                            v_detalle = v_registros.c3;                        
                        ELSEIF  v_contador = 4  THEN
                             v_detalle = v_registros.c4;                        
                        ELSEIF  v_contador = 5  THEN
                            v_detalle = v_registros.c5;                        
                        ELSEIF  v_contador = 6  THEN
                           v_detalle = v_registros.c6;                        
                       END IF;
                       
                       
                        v_indice = split_part(v_registros.codigo, '.', 1)::integer;
                        
                        IF v_registros.eeff = 'B'  THEN 
                            v_eeff =  'balance';
                        ELSE
                           v_eeff =  'resultado';
                        END IF;
                        
                        
                        IF v_registros.aux = 'S'  THEN 
                            v_sw_transaccional =  'si';
                        ELSE
                           v_sw_transaccional =  'no';
                        END IF;
                        
                        
                         IF v_registros.saldo = 'H'  THEN 
                                v_incremento =  'haber';
                         ELSE
                                v_incremento =  'debe';
                         END IF;
                         
                         v_valor_incremento = 'positivo';
                                                  
                         IF v_incremento =  'debe'  THEN                               
                                IF  lower(v_registros.saldo) = 'd red' THEN
                                    v_valor_incremento = 'negativo';
                                END IF;
                                
                         END IF;
                        
                        
                        
                        
                        
                   
                     
                        --si es de nivel priemro insertamos el tipo de cuenta      
                        IF  v_contador = 1  THEN
                        
                        
                          
                        
                        
                             
                             
                             IF v_registros.saldo = 'H'  THEN 
                                v_incremento =  'haber';
                             ELSE
                                v_incremento =  'debe';
                             END IF;
                            
                            
                            --Sentencia de la insercion
                            insert into conta.tconfig_tipo_cuenta(
                              nro_base,
                              tipo_cuenta,
                              estado_reg,
                              id_usuario_reg,
                              fecha_reg,
                              fecha_mod,
                              id_usuario_mod,
                              incremento,
                              eeff
                            ) 
                              values(
                              v_indice,
                              trim(lower(v_config_tipo_cuenta)),
                              'activo',
                              1, --usuario
                              now(),
                              null,
                              null,
                              v_incremento,
                              string_to_array(v_eeff,',')::varchar[]
                							
                            );
                            
                            v_tipo_cuenta[v_indice] = trim(lower(v_config_tipo_cuenta));
                        
                            v_id_cuenta_padre = null;
                        ELSE
                           -- buscamos el padre previamente registrado   
                        
                             v_array_codigo = regexp_split_to_array(v_registros.codigo, E'\\.');
                             
                             v_max = array_upper(v_array_codigo, 1);
                             v_aux = 1;
                             v_codigo_padre = '';
                             
                             WHILE v_aux < v_max LOOP
                                 
                                IF v_codigo_padre  != '' THEN
                                   v_codigo_padre = v_codigo_padre || '.';
                                END IF;
                                
                                v_codigo_padre = v_codigo_padre|| v_array_codigo[v_aux];                             
                                v_aux= v_aux +1;
                             END LOOP;
                             
                             select
                                c.id_cuenta 
                             into
                                v_id_cuenta_padre
                             from conta.tcuenta c 
                             where c.id_gestion = p_id_gestion and c.nro_cuenta = v_codigo_padre;
                            
                            IF v_id_cuenta_padre is null  THEN
                              raise exception 'no se encontro la cuenta padre %', v_codigo_padre;
                            END IF;
                        
                        
                        
                        END IF;
                        
                            
                        
                        
                        IF   not EXISTS(select  
                                            1
                                      from conta.tcuenta c 
                                      where c.id_gestion = p_id_gestion and c.nro_cuenta = v_registros.codigo) THEN
                                      
                                   
                        
                                IF v_sw_transaccional = 'si' THEN
                                   v_text_exu = 'movimiento';
                                ELSE
                                 v_text_exu = 'titular';
                                END IF;   
                                   
                            
                               --Sentencia de la insercion
                               insert into conta.tcuenta(
                                      id_cuenta_padre,
                                      nombre_cuenta,
                                      sw_auxiliar,
                                      nivel_cuenta,
                                      tipo_cuenta,
                                      desc_cuenta,
                                    
                                      nro_cuenta,
                                     
                                      sw_transaccional,
                                      id_gestion,
                                      estado_reg,
                                      fecha_reg,
                                      id_usuario_reg,
                                      fecha_mod,
                                      id_usuario_mod,
                                      eeff,
                                      valor_incremento,
                                      sw_control_efectivo
                                  ) values(
                                      v_id_cuenta_padre,
                                      v_detalle,
                                      v_sw_transaccional,   --si es de movimiento admite auxiliares                                   
                                      v_registros.nivel,
                                      v_tipo_cuenta[v_indice],
                                      v_detalle,                                    
                                      v_registros.codigo,                                      
                                      v_text_exu,
                                      p_id_gestion,
                                      'activo',
                                      now(),
                                      1,
                                      null,
                                      null,
                                      string_to_array(v_eeff,',')::varchar[],
                                      v_valor_incremento,
                                      'no'
                      							
                                  )RETURNING id_cuenta into v_id_cuenta;
                  
                      END IF; -- si la cuenta no existe
             
                END IF;
             
             
             END LOOP;
    
    
    
    
    
    v_contador = v_contador +1;
    END LOOP;


   
   
                       
  return true;


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