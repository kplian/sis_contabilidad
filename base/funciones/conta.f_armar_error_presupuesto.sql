--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_armar_error_presupuesto (
  p_resp_ges numeric [],
  p_id_presupuesto integer,
  p_codigo_partida varchar,
  p_id_moneda integer,
  p_id_moneda_base integer,
  p_momento_presupeustario varchar,
  p_monto_cmp_mb numeric
)
RETURNS varchar AS
$body$
/*
	Autor: RAC (KPLIAN)
    Fecha: 06-04-2016
    Descripción: funcion que formatea el errores de la gestion de presupuesto en contabilidad
     ***************************************************************************************************   
    

    HISTORIAL DE MODIFICACIONES:
   	
 ISSUE            FECHA:		      AUTOR                 DESCRIPCION
   
 #0        		29-03-2018          RAC KPLIAN        Mejora los mensajes derror dejandolos mas claros
#73             19/09/2019          EGS                   Se modifica mensaje de error al aprobar ajuste
#84             03/01/2020          RAC         Corregir mensaje de error en ajustes presupuestarios para mostrar el monto faltante en la moneda base
*/

DECLARE
  v_nombre_funcion varchar;
  v_resp varchar;
  v_codico_cc varchar;
  v_mensaje_error varchar;
  v_tmp varchar;
  v_monto_aux_mb numeric; --#26
  
BEGIN
  v_nombre_funcion = 'conta.f_armar_error_presupuesto';
  
  --  recuperamos datos del presupuesto
                                         
             select 
                pre.codigo_cc
             into
                v_codico_cc
             from pre.vpresupuesto_cc pre
             where pre.id_centro_costo = p_id_presupuesto;
             
            
                                         
             IF p_resp_ges[4] is not null and  p_resp_ges[4] = 1  THEN
                  v_tmp = format('el presupuesto no alcanza por diferencia cambiaria, en moneda base tenemos:   %s y se requiere %s ', round(p_resp_ges[3],2)::varchar,  round(p_monto_cmp_mb,2)::varchar);
             ELSE
             
              
                  IF p_id_moneda_base = p_id_moneda THEN
                      v_tmp = format('solo se tiene disponible un monto en moneda base de:  %s y se requiere; %s (Falta . %s)', round(p_resp_ges[3],2)::varchar, round(p_monto_cmp_mb,2)::varchar,  round(p_resp_ges[3] -abs(p_monto_cmp_mb),2)::varchar);    --#73
                  ELSE
                  
           
                      --#84
                      v_monto_aux_mb =   param.f_convertir_moneda (  
                                                                   p_id_moneda, 
                                                                   p_id_moneda_base,
                                                                   p_monto_cmp_mb, 
                                                                   now()::date,
                                                                   'O',50); 
                       
                      v_tmp =  format('solo se tiene disponible un monto de:  %s y se requiere  %s. (Falta . %s)', round(p_resp_ges[3],2)::varchar, round(v_monto_aux_mb,2)::varchar,  round(p_resp_ges[3] - p_monto_cmp_mb,2)::varchar);
                  END IF;
                                            
             END IF;
                                         
             v_mensaje_error =  format('<BR/> (%s) Pres: %s, partida %s  <BR/> --> %s', p_momento_presupeustario::varchar, v_codico_cc::varchar, p_codigo_partida::varchar, v_tmp::varchar);
           

 return v_mensaje_error;

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