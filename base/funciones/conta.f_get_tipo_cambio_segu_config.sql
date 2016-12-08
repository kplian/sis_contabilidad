--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_get_tipo_cambio_segu_config (
  p_id_moneda integer,
  p_fecha date,
  p_localidad varchar,
  p_sw_valores varchar,
  p_forma_cambio varchar = 'O'::character varying,
  out po_id_config_cambiaria integer,
  out po_valor_tc1 numeric,
  out po_valor_tc2 numeric,
  out po_tc1 varchar,
  out po_tc2 varchar
)
RETURNS record AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.f_get_tipo_cambio_segu_config
 DESCRIPCION:   recuepra los tipos de cambio segun configuracion activa y etiquetas
 AUTOR: 		(rac)  kplian
 FECHA:	        10-11-2015 12:39:12
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE


v_registros_cc  		record;
v_registros_mon_2       record;
v_nombre_funcion		varchar;
v_resp					varchar;
v_id_moneda_base        integer;
v_id_moneda_tri			integer;

v_m  					record;
v_mb  					record;
v_mt  					record;
va_tc1 					varchar[];
va_tc2 					varchar[];
    


v_registros				record;

 

BEGIN

  	 v_nombre_funcion = 'conta.f_get_tipo_cambio_segu_config';
   
   
        ----------------------------------------
        --recuperar la configuracion, cambiaria
        ----------------------------------------
            
            select 
             cc.*
            into
             v_registros_cc
            from conta.tconfig_cambiaria cc
            where cc.origen = p_localidad 
            and cc.habilitado = 'si' and cc.estado_reg = 'activo';
            
            po_id_config_cambiaria = v_registros_cc.id_config_cambiaria;
            
            IF v_registros_cc is NULL THEN
              raise exception 'No se encontro una configuracion cambiaria activa';
            END IF;
            
        ----------------------
        -- remplazar labels
        ---------------------
              
            -- obtener los codigos de la monedas 
            
            
            v_id_moneda_base = param.f_get_moneda_base();
            v_id_moneda_tri  = param.f_get_moneda_triangulacion();
            
            select 
             *
            into
             v_m
            from param.tmoneda m 
            where m.id_moneda = p_id_moneda; 
            
            select 
             *
            into
             v_mb
            from param.tmoneda m 
            where m.id_moneda = v_id_moneda_base; 
            
            select 
             *
            into
             v_mt
            from param.tmoneda m 
            where m.id_moneda = v_id_moneda_tri; 
            
            
            po_tc1 = replace(v_registros_cc.ope_1, '{M}',v_m.codigo);
            po_tc1 = replace(po_tc1, '{MB}',v_mb.codigo);
            po_tc1 = replace(po_tc1, '{MT}',v_mt.codigo);
            
            
            po_tc2 = replace(v_registros_cc.ope_2, '{M}',v_m.codigo);
            po_tc2 = replace(po_tc2, '{MB}',v_mb.codigo);
            po_tc2 = replace(po_tc2, '{MT}',v_mt.codigo);
            
        ----------------------------------------------
        -- obtener tipos de cambio del dia si existen
        ----------------------------------------------
        
            IF p_sw_valores = 'si' THEN
            
                -- desarmar cadenas de conversion
                 va_tc1 = regexp_split_to_array(po_tc1, '->');
                 va_tc2 = regexp_split_to_array(po_tc2, '->');
              
                -- calcula tipo de cambio 1 para la fecha
                 if p_localidad != 'internacional' then
                    po_valor_tc1 = conta.f_determinar_tipo_cambio(va_tc1[1], va_tc1[2],  p_fecha, p_forma_cambio);
                 else
                    po_valor_tc1 = NULL; --el tipo de cambio 1 ya viene con el cbte
                 end if;
                -- calcula tipo de cambio 2 para la fecha
                
                 po_valor_tc2 = conta.f_determinar_tipo_cambio(va_tc2[1], va_tc2[2],  p_fecha, p_forma_cambio);
                
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