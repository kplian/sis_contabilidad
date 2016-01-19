--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_ajusta_tc_cuenta (
  p_id_usuario integer,
  p_id_ajuste integer,
  p_tipo varchar,
  p_id_cuenta integer,
  p_id_auxiliar integer,
  p_id_partida_ingreso integer,
  p_id_partida_egreso integer,
  p_id_cuenta_bancaria integer,
  p_id_moneda_ajuste integer,
  p_id_moneda_base integer,
  p_id_moneda_tri integer,
  p_fecha date,
  p_id_depto_conta integer,
  p_depto_inter boolean,
  p_solo_mayor_cero boolean = false,
  p_mostrar_errores boolean = true
)
RETURNS integer AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.f_ajusta_tc_cuenta
 DESCRIPCION:   esta función realiza el caculo de mayor para el departamentos indicado en moneda
                base (MB) y moneda de triangualcion (MT), con este valor calculo la actulización
 AUTOR: 		 (rac)  kplian
 FECHA:	        11-12-2015 12:39:12
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
v_registros				record;
v_reg_cuenta			record;
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
v_id_ajuste_det			INTEGER;
v_fecha_ini_ges			date;


v_id_cuenta				integer;
v_id_auxiliar			integer;
v_id_partida_egreso		integer;
v_id_partida_ingreso	integer;
v_id_gestion			integer;
v_nro_cuenta_banc		varchar;
v_rel_egre	varchar;
v_rel_ingre	varchar;
v_id_moneda_ajuste  	integer;

 

BEGIN

  	  v_nombre_funcion = 'conta.f_ajusta_tc_cuenta';
      
              --obtener el primer dia de la gestion
             SELECT 
              po_fecha_ini,
              po_id_gestion
             into
              v_fecha_ini_ges,
              v_id_gestion
             FROM param.f_get_limites_gestion(p_fecha::date);
      
           ----------------------------------------------------------------------
           --  deifnir cuentas partidas y auxiliares segun el tipo de ajuste
           ------------------------------------------------------------------
           
           
           IF p_tipo = 'bancos' or   p_tipo = 'cajas'  THEN
           
           
               IF p_tipo = 'bancos' THEN
                 v_rel_egre = 'CUEBANCEGRE';
                 v_rel_ingre = 'CUEBANCING';
               ELSE
               --TODO  cambiar relaciones contables de cajas
                 v_rel_egre = 'CUEBANCEGRE';
                 v_rel_ingre = 'CUEBANCING';
               END IF;
              
               --obtenemos las cuentas a partir de las relaciones contables egreso e ingreso de bancos
               -- p_id_cuenta_bancaria
               
               SELECT 
                ps_id_cuenta,
                ps_id_auxiliar,
                ps_id_partida
               into 
                 v_id_cuenta,
                 v_id_auxiliar,
                 v_id_partida_egreso
               FROM conta.f_get_config_relacion_contable(v_rel_egre, 
                                                         v_id_gestion, 
                                                         p_id_cuenta_bancaria,
                                                         NULL);
                                                          
           
               IF p_mostrar_errores  THEN
                  IF v_id_cuenta is null THEN                  
                      select  c.nro_cuenta 
                        into 
                            v_nro_cuenta_banc   
                      from tes.tcuenta_bancaria c where c.id_cuenta_bancaria = p_id_cuenta_bancaria;                      
                      raise exception 'no se encontro relacion contable % para la cuenta  %',v_rel_egre, v_nro_cuenta_banc;
                  END IF;               
               END IF;
               
               
               SELECT 
                 ps_id_partida
               into 
                 v_id_partida_ingreso
               FROM conta.f_get_config_relacion_contable(v_rel_ingre, 
                                                         v_id_gestion, 
                                                         p_id_cuenta_bancaria, 
                                                          NULL);                                          
               
               
               
               
               IF p_mostrar_errores  THEN
                  IF v_id_cuenta is null THEN                  
                      select  c.nro_cuenta 
                        into 
                            v_nro_cuenta_banc   
                      from tes.tcuenta_bancaria c where c.id_cuenta_bancaria = p_id_cuenta_bancaria;                      
                      raise exception 'no se encontro relacion contable % para la cuenta  %',v_rel_ingre, v_nro_cuenta_banc;
                  END IF;               
               END IF;
               
               select
                 c.id_moneda
               into
                v_id_moneda_ajuste
               from conta.tcuenta c
               where c.id_cuenta = v_id_cuenta;
           
          
           
           ELSEIF p_tipo = 'manual'  THEN
           
           		v_id_cuenta = p_id_cuenta;
                v_id_auxiliar =	p_id_auxiliar;
                v_id_partida_egreso = p_id_partida_egreso;
                v_id_partida_ingreso = p_id_partida_ingreso;
                v_id_moneda_ajuste = p_id_moneda_ajuste;
           
           ELSE             
               raise exception 'Tipo no reconocido';           
           END IF;
           
             
             
      
       -- obtener moneda de la cuenta
              select
                c.*
              into
               v_reg_cuenta
              from conta.tcuenta c
              where c.id_cuenta = v_id_cuenta;
                
               
              IF  v_reg_cuenta.sw_control_efectivo != 'si'  THEN 
                raise exception 'la cuenta contable no tiene control de efectivo (%) - %', v_reg_cuenta.nro_cuenta,v_reg_cuenta.nombre_cuenta;
              END IF;
              
             
             
           
              -- raise exception '% ,%',(date_trunc('year', v_registros.fecha))::Date, v_registros.fecha;
             va_mayor =  conta.f_mayor_cuenta(v_id_cuenta, 
                                              v_fecha_ini_ges, 
                                              p_fecha, 
                                              p_id_depto_conta::varchar,
                                              'no', --icluir cierre
                                              'todos', --incluri apertura
                                              'todos', --incluir aitbs
                                              'defecto', --signo del balance
                                              'balance', --  tipo de saldo
                                              v_id_auxiliar);
                                              
              
             
                                        
              IF v_id_moneda_ajuste =  p_id_moneda_base THEN
                 v_mayor = va_mayor[1];
               ELSEIF v_id_moneda_ajuste = p_id_moneda_tri   THEN
                 v_mayor = va_mayor[2];
               ELSE
                 v_mayor = 0;
                 
                 --si noe sun depto internacional ...
                  IF not p_depto_inter  THEN
                       -- TODO  Si la cuenta no esta en moneda base ni moneda de triangualcion
                      IF p_tipo = 'bancos' THEN
                              
                         -- calcular mayor de la cuenta por libro de bancos
                         v_mayor =   tes.f_obtener_saldo_cuenta_bancaria(p_id_cuenta_bancaria,p_fecha);
                     
                      ELSEIF p_tipo = 'cajas' THEN
                      
                          raise exception 'TODO no se implemento el arqueo de caja';
                      ELSE 
                          raise exception 'TODO como hacer esto en cuentas manuales ...???';
                      END IF;   
                  
                  END IF; 
                           
               END IF;                                
                
             
              
              --  solo_mayor_ceto por defecto es falso,  con esto se permite guardar nclusive si el mayor es igual a cero
            
             
             IF   (va_mayor[1] != 0  and p_solo_mayor_cero) or   (not p_solo_mayor_cero) THEN
                      
                      
                      --si es un depto internacional el proceso de calculo es diferente
                      --asumimos que la moneda por mas de ser diferente a la moneda base esta ajustada en dolares
                      IF p_depto_inter  THEN
                           v_tc_mb =  param.f_get_tipo_cambio_v2(p_id_moneda_tri, p_id_moneda_base, p_fecha, 'O');
                           v_tc_mt = NULL;
                           
                           v_act_mb =   param.f_convertir_moneda (p_id_moneda_tri, p_id_moneda_base, va_mayor[2], p_fecha,'O',2,v_tc_mb);
                           v_act_mt =  va_mayor[2];
                      
                      ELSE
                      
                      --  si es depto nacional convertimos la mayor en la moneda  directamente a bzse y triangulacion
                      
                           -- definir tipo de cambio de la moneda de la cuenta segun fecha hacia   MB  y MT
                           v_tc_mb =  param.f_get_tipo_cambio_v2(v_id_moneda_ajuste, p_id_moneda_base, p_fecha, 'O');
                           v_tc_mt =  param.f_get_tipo_cambio_v2(v_id_moneda_ajuste, p_id_moneda_tri, p_fecha, 'O');
                           
                           -- calcular valor en mb y mt a la fecha
                           v_act_mb =   param.f_convertir_moneda (v_id_moneda_ajuste, p_id_moneda_base, v_mayor, p_fecha,'O',2,v_tc_mb);
                           v_act_mt =   param.f_convertir_moneda (v_id_moneda_ajuste, p_id_moneda_tri, v_mayor, p_fecha,'O',2,v_tc_mt);
                         
                    END IF;     
                     
                     
                     v_dif_mb =  round(v_act_mb - va_mayor[1], 2);
                     v_dif_mt =  round(v_act_mt - va_mayor[2], 2);
                     
                     -- calcular las diferencias entre el mayor y valor actulizado
                                                     
                      
                   
                    -- inserta datos bascios del ajuste
                    insert into conta.tajuste_det(
                      estado_reg,
                      id_ajuste,
                      id_cuenta,
                      id_auxiliar,
                      id_partida_egreso,
                      id_partida_ingreso,
                      id_usuario_ai,
                      id_usuario_reg,
                      fecha_reg,
                      usuario_ai,
                      tipo_cambio_1,
                      tipo_cambio_2,
                      mayor_mb,
                      mayor_mt,
                      mayor,
                      act_mb,
                      act_mt,
                      dif_mb,
                      dif_mt,
                      id_cuenta_bancaria,
                      id_moneda_ajuste
                    ) values(
                     'activo',
                      p_id_ajuste,
                      v_id_cuenta,
                      v_id_auxiliar,
                      v_id_partida_egreso,
                      v_id_partida_ingreso,
                      NULL,
                      p_id_usuario,
                      now(),
                      NULL,
                      v_tc_mb,
                      v_tc_mt,
                      va_mayor[1],
                      va_mayor[2],
                      v_mayor,
                      v_act_mb,
                      v_act_mt,
                      v_dif_mb,
                      v_dif_mt,
                      p_id_cuenta_bancaria,
                      v_id_moneda_ajuste
                      
                    )RETURNING id_ajuste_det into v_id_ajuste_det;
                    
   
             END IF;
    
      return v_id_ajuste_det;


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