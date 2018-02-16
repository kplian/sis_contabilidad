--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_relaciones_contables_auto_2 (
)
RETURNS varchar AS
$body$
DECLARE
 
  v_consulta varchar;
  g_registros record;
  retorno varchar;
  v_resp varchar;
  v_id_partida integer;
  v_id_gestion integer;
  v_nombre_funcion varchar;
  
  fl_id_cuenta_ie integer;
  fl_id_cuenta_ord integer;
  fl_id_cuenta_inv integer;
  fl_id_tipo_presup integer;
  fl_tipo_rc integer;
  v_i integer;
  
BEGIN
--id gestion actual
v_id_gestion=2;

--fl_id_cuenta_ie
--fl_id_cuenta_ord

--fl_id_tipo_presup
fl_tipo_rc = 1;

fl_id_cuenta_inv =2320;

v_i = 9;



   DELETE FROM conta.trelacion_contable    WHERE id_tipo_presupuesto in (9,10,11,12,13,14,15,16,17,18)  ;
  
  
                                             
    
retorno ='';       
 FOR g_registros in (SELECT  
                 trc.id_tabla,trc.id_partida 
              FROM conta.trelacion_contable trc 
             WHERE trc.id_gestion=2  --2018
             AND trc.id_tipo_relacion_contable = 1  -- compras
             AND trc.id_tipo_presupuesto=2) --gasto
 LOOP
 
      v_id_partida=g_registros.id_partida;
      v_i = 9;
      
       WHILE v_i <=   18 LOOP  
    
       -- Si id_partida no es null
      
       		--Sentencia de la insercion Cuenta Inversion
        	insert into conta.trelacion_contable(
                estado_reg,
                id_tipo_relacion_contable,
                id_cuenta,
                id_partida,
                id_gestion,
                id_auxiliar,
                id_centro_costo,
                fecha_reg,
                id_usuario_reg,
                fecha_mod,
                id_usuario_mod,
                id_tabla,
                defecto,
                codigo_aplicacion,
                id_tipo_presupuesto,
                id_moneda
                
          	) values(
                'activo',
                fl_tipo_rc,
                fl_id_cuenta_inv,
                v_id_partida,
                v_id_gestion,
                NULL,
                NULL,
                now(),
                1,
                null,
                null,
                g_registros.id_tabla,
                'no',
                NULL,
                v_i,
                NULL							
			);
   		
       
       
       v_i = v_i + 1;
     END LOOP;
 END LOOP;           
 
  
return retorno;

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