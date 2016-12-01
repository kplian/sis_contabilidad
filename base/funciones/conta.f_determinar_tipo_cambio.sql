--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_determinar_tipo_cambio (
  p_cod_mon_1 varchar,
  p_cod_mon_2 varchar,
  p_fecha date,
  p_forma_cambio varchar
)
RETURNS numeric AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_config_cambiaria_ime
 DESCRIPCION:   en funcion a los codigos de las moendas regresa el tipo de cambio correspondiente
                la conversion se ha pasando por moneda base, si no encuentra regresa NULL
 AUTOR: 		 (rac)  kplian
 FECHA:	        05-11-2015 12:39:12
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE


v_registros_mon_1  		record;
v_registros_mon_2       record;
v_nombre_funcion		varchar;
v_resp					varchar;
v_id_moneda_base		integer;

 

BEGIN

   v_nombre_funcion = 'conta.f_determinar_tipo_cambio';
   
    v_id_moneda_base = param.f_get_moneda_base();
   
   -- si la moenda son iguales el tipo de cambio es uno
   IF p_cod_mon_1 = p_cod_mon_2   THEN
      RETURN 1.00;
   END IF;
   
   --determina id de las moendas
   
     select 
      *
     into
      v_registros_mon_1 
     
     from param.tmoneda mon
     where mon.codigo = p_cod_mon_1 and  mon.estado_reg = 'activo';
     
     
     select 
      *
     into
      v_registros_mon_2 
     from param.tmoneda mon
     where mon.codigo = p_cod_mon_2 and mon.estado_reg = 'activo';
     
    -- calula tipo de cambio
    IF v_id_moneda_base != v_registros_mon_1.id_moneda and v_id_moneda_base != v_registros_mon_2.id_moneda THEN
    	RETURN  param.f_convertir_moneda (v_registros_mon_1.id_moneda,v_registros_mon_2.id_moneda, 1.00, p_fecha,p_forma_cambio,50,1.00, 'no'); 
   
    ELSE
       
       IF v_id_moneda_base = v_registros_mon_1.id_moneda THEN
          
          RETURN  param.f_get_tipo_cambio(v_registros_mon_2.id_moneda, p_fecha, p_forma_cambio);
       
       ELSE
         
         RETURN  param.f_get_tipo_cambio(v_registros_mon_1.id_moneda, p_fecha, p_forma_cambio);
       
       END IF;
    
    END IF;
   


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
STABLE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;