--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_reclasificar_cuenta_bolsa (
)
RETURNS void AS
$body$
/**************************************************************************
 SISTEMA ENDESIS - SISTEMA DE SEGURIDAD (SSS)
***************************************************************************
 SCRIPT: 		trisg_usuario
 DESCRIPCIÓN: 	Segun la int_trasaccion del comprobante inserta o modfica los valores de int_trans_Val
 AUTOR: 		KPLIAN(rac)
 FECHA:			 10/02/2018
 COMENTARIOS:	
**************************************************************************/
--------------------------
-- CUERPO DE LA FUNCIÓN --
--------------------------

--**** DECLARACION DE VARIABLES DE LA FUNCIÓN (LOCALES) ****---


DECLARE
   v_registros_con 	 record;
   v_registros		 record;
   v_id_moneda_base  integer;
   v_importe_debe    numeric;
   v_importe_haber	 numeric;
   v_importe_recurso numeric;
   v_importe_gasto	 numeric;
   v_id_cuenta_bolsa  integer;
   v_id_cuenta        integer;
    
BEGIN
--  

   v_id_cuenta_bolsa = 2320;

   --listar comprobantes  con la cuenta bolsa que esten validados
   FOR v_registros in (
       select
          t.id_int_transaccion,
          t.id_centro_costo,
          t.id_partida,
          tp.id_tipo_presupuesto
       from conta.tint_transaccion t
       inner join conta.tint_comprobante c on c.id_int_comprobante = t.id_int_comprobante
       inner join pre.tpresupuesto pr on pr.id_centro_costo = t.id_centro_costo
       inner join pre.ttipo_presupuesto tp on tp.codigo = pr.tipo_pres
       where       t.id_cuenta = v_id_cuenta_bolsa              
              and  t.estado_reg = 'activo' ) LOOP
              
               
               
               --recueprar configuracion correcta, cuenta correcta
               select 
                 rc.id_cuenta
                into 
                  v_id_cuenta
               from conta.trelacion_contable rc
               where      rc.id_partida = v_registros.id_partida
                      and rc.id_tipo_presupuesto = v_registros.id_tipo_presupuesto
                      and rc.id_gestion = 2 -- 2018
                      and rc.id_tipo_relacion_contable =   1  --aopra ahcer compras
                limit 1 OFFSET 0;
       
       
               --modificar trasaccion
              
              update conta.tint_transaccion t set
                  id_cuenta = v_id_cuenta,
                  id_cuenta_bolsa = v_id_cuenta_bolsa
              where t.id_int_transaccion =  v_registros.id_int_transaccion;
              
              
    END LOOP;
    
      
       
      raise exception 'error lelga al final';
     
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;