--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_relaciones_contables_auto (
  fl_tipo_rc integer,
  fl_id_tipo_presup integer,
  fl_id_cuenta_inv integer,
  fl_id_cuenta_ord integer,
  fl_id_cuenta_ie integer
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
  
BEGIN
--id gestion actual
v_id_gestion=2;


                                             
  -- Elimino los registros diferentes al id_tipo_presup            
  DELETE FROM conta.trelacion_contable WHERE id_tipo_presupuesto<>fl_id_tipo_presup AND id_tipo_relacion_contable=fl_tipo_rc AND id_gestion=v_id_gestion;
       
retorno ='';       
 FOR g_registros in (SELECT  
                 trc.id_tabla,trc.id_partida 
              FROM conta.trelacion_contable trc 
             WHERE trc.id_gestion=v_id_gestion AND trc.id_tipo_relacion_contable = fl_tipo_rc AND trc.id_tipo_presupuesto=fl_id_tipo_presup)
 LOOP
 
    v_id_partida=g_registros.id_partida;
    
       -- Si id_partida no es null
       IF v_id_partida IS NOT NULL THEN
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
                3,
                NULL							
			);
   		--Sentencia de la insercion Cuenta orden
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
                fl_id_cuenta_ord,
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
                6,
                NULL							
			); 
       --Sentencia de la insercion Cuenta Ingreso-Egreso
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
                fl_id_cuenta_ie,
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
                7,
                NULL							
			); 
      
 
       END IF;
    
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