--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_int_trans_validar (
  p_id_usuario integer,
  p_id_int_comprobante integer
)
RETURNS boolean AS
$body$
/*
	Autor: RCM
    Fecha: 05-09-2013
    Descripción: Función que se encarga de verificar la integridad del comprobante para posteriormente validarlo.
 
  ***************************************************************************************************   
    

    HISTORIAL DE MODIFICACIONES:
   	
 ISSUE            FECHA:		      AUTOR                 DESCRIPCION
   
 #0        		05-09-2013        N/N               creacion
 #00  ETR       05/05/2018        RAC KPLIAN        Los comprobantes manuales genera libro de bancos
 #01  ETR       13/12/2018        JJA               Correccion problema de no geracion de cheque para devoluciones de cuenta documentadas

*/


DECLARE


v_parametros  		record;
v_registros 		record;
v_nombre_funcion   	text;
v_resp				varchar;
v_nivel				integer;
v_monto				numeric;
v_mayor				numeric;
v_id_gestion  		integer;
v_tmp_formula		varchar;
v_formula_evaluado	varchar;
v_columna			varchar;
v_columna_nueva     varchar[];
v_sw_busqueda						boolean;
v_i									integer;
v_k									integer;
va_variables						varchar[];
v_registros_cbte					record;
v_id_cuenta_bancaria				integer;
v_conta_validar_forma_pago			varchar;
v_conta_integrar_libro_bancos		varchar;
v_valor								varchar;
v_id_gestion_chk					integer;		


BEGIN

   v_nombre_funcion = 'conta.f_int_trans_validar';

   -- recuepra datos basicos del comprobante
   select
      ic.id_periodo,
      per.id_gestion,
      ic.manual,
      ic.origen,
      ic.tipo_cambio,
      ic.id_clase_comprobante,
      cc.codigo,
      ic.id_depto,
      pla.codigo as codigo_plantilla
   into
      v_registros_cbte
   from conta.tint_comprobante ic
   inner join param.tperiodo per on per.id_periodo = ic.id_periodo
   inner join conta.tclase_comprobante cc on cc.id_clase_comprobante = ic.id_clase_comprobante
   left join conta.tplantilla_comprobante pla on pla.id_plantilla_comprobante=ic.id_plantilla_comprobante
   where ic.id_int_comprobante = p_id_int_comprobante;
   
   
   
   --RAC 22/01/2018, vlaidar que la gestion de centros de costos, partidas y cuentas sea la mismas que la cabecera del cbte
    --revisa centros de costo
    v_id_gestion_chk = NULL;
    select  
      cc.id_gestion
     into
      v_id_gestion_chk
    from conta.tint_transaccion it 
    inner join param.tcentro_costo cc on cc.id_centro_costo = it.id_centro_costo
    where it.id_int_comprobante = p_id_int_comprobante and cc.id_gestion != v_registros_cbte.id_gestion;
    
    IF v_id_gestion_chk is  not null THEN
       raise exception 'Existe un centro de costo con una gestion diferente a la cabecera del cbte, comuniquese con el administrador';
    END IF;
    --revisa cuentas
     v_id_gestion_chk = NULL;
     select  
      cue.id_gestion
     into
      v_id_gestion_chk
    from conta.tint_transaccion it 
    inner join conta.tcuenta cue on cue.id_cuenta = it.id_cuenta
    where it.id_int_comprobante = p_id_int_comprobante and cue.id_gestion != v_registros_cbte.id_gestion;
    
    IF v_id_gestion_chk is not null THEN
       raise exception 'Existe una cuenta con una  gestion diferente a la cabecera del cbte, comuniquese con el administrador';
    END IF;
     --revisa partidas
     v_id_gestion_chk = NULL;
     select  
      par.id_gestion
     into
      v_id_gestion_chk
    from conta.tint_transaccion it 
    inner join pre.tpartida par on par.id_partida = it.id_partida
    where it.id_int_comprobante = p_id_int_comprobante and par.id_gestion != v_registros_cbte.id_gestion;
    
    IF v_id_gestion_chk is not null THEN
       raise exception 'Existe una partidacon una gestion diferente a la cabecera del cbte, comuniquese con el administrador';
    END IF;
   
   
   
   


   --validar que tenga tipo de cambio
   IF v_registros_cbte.tipo_cambio is null THEN
     raise exception 'Defina el tipo de cambio antes de continuar con la validación del cbte';
   END IF;



   -- si es un cbte manual o viene de integracion con la central (cbts en regionales .... )

           --listado de las transacciones del comprobante
           FOR v_registros in (select *
                               from conta.tint_transaccion it
                               where it.id_int_comprobante = p_id_int_comprobante) LOOP

                ----------------------------------------------------------------------------------------------------
                --  FORMA DE PAGO
                ------------------------------------------------------------------------------------------------------


               v_conta_validar_forma_pago = pxp.f_get_variable_global('conta_validar_forma_pago');
                -- busca si alguna de las cuentas contables tiene relacion
                -- con una cuenta bancaria
                v_id_cuenta_bancaria = NULL;

                IF v_conta_validar_forma_pago = 'si' THEN
                   --si es un cbte de pago ...
                   --IF upper(v_registros_cbte.codigo) in ('PAGO','PAGOCON','INGRESO','INGRESOCON') THEN
                   
                   --JJA 13/12/2018 Se comento la condision por que no generaba el cheque al realizar la devolucion de saldo de cuenta documentada
                   --IF upper(v_registros_cbte.codigo) in ('PAGO','PAGOCON','INGRESO','INGRESOCON')  AND v_registros_cbte.codigo_plantilla not in ('CD-DEVREP-SALDOS')  THEN
                   IF upper(v_registros_cbte.codigo) in ('PAGO','PAGOCON','INGRESO','INGRESOCON') THEN
                   
                        IF v_registros.banco = 'si'  THEN

                               IF v_registros.forma_pago = '' or v_registros.forma_pago is  null  THEN
                                 raise exception 'defina la forma de pago para proceder con la validación';
                               END IF;

                              --TODO verificar integracion con libro de bancos ....

                               --ver si tiene libro de bancos ....
                               v_conta_integrar_libro_bancos = pxp.f_get_variable_global('conta_integrar_libro_bancos');

                               v_valor = param.f_get_depto_param( v_registros_cbte.id_depto, 'ENTREGA');
                               
                               --JJA 13/12/2018 Se comento la condision por que no generaba el cheque al realizar la devolucion de saldo de cuenta documentada y se agrego la plantilla CD-DEVREP-SALDOS
                               --IF (v_conta_integrar_libro_bancos = 'si' AND v_valor='NO') OR (v_conta_integrar_libro_bancos='si' AND v_registros_cbte.codigo_plantilla in ('SOLFONDAV', 'REPOCAJA')) THEN
                               IF (v_conta_integrar_libro_bancos = 'si' AND v_valor='NO') OR (v_conta_integrar_libro_bancos='si' AND v_registros_cbte.codigo_plantilla in ('SOLFONDAV', 'REPOCAJA','CD-DEVREP-SALDOS')) THEN

                                    -- si alguna transaccion tiene banco habilitado para pago
                                    IF  not tes.f_integracion_libro_bancos(p_id_usuario,p_id_int_comprobante,  v_registros.id_int_transaccion) THEN
									  --raise exception 'error al registrar transacción en libro de bancos, comprobante %', p_id_int_comprobante;
                                    END IF;

                               END IF;
                            
                               
                        
                        END IF;
                    END IF;
                END IF;   
               
               
              
              -----------------------------------
              --TODO agregar otras validaciones
              -----------------------------------
              
              
              
              
           END LOOP;
   
  
   
   --retorna resultado
   RETURN TRUE;


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