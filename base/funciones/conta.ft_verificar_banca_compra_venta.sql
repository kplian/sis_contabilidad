CREATE OR REPLACE FUNCTION conta.ft_verificar_banca_compra_venta (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_verificar_banca_compra_venta
 DESCRIPCION:   revision 
 AUTOR: 		Favio Figuero Penarrieta
 FECHA:	        21-09-2015 20:44:52
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_aux					varchar;
    v_record				record;
    
    v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_auxiliar	integer;
  v_estado_gestion VARCHAR;

BEGIN

    v_nombre_funcion = 'conta.ft_verificar_banca_compra_venta';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_REVISAR_BANCA'
 	#DESCRIPCION:	revision del registro
 	#AUTOR:		Favio Figueroa
 	#FECHA:		21-09-2015 20:44:52
	***********************************/

	if(p_transaccion='CONTA_REVISAR_BANCA')then
					
        begin


        --verificamos la gestion si esta abierta
      select banges.estado into v_estado_gestion from conta.tbancarizacion_gestion banges
        INNER JOIN param.tgestion ges on ges.id_gestion = banges.id_gestion
        inner join param.tperiodo per on per.id_gestion = ges.id_gestion
      where per.id_periodo = v_parametros.id_periodo;

      IF v_estado_gestion = 'Bloqueado' THEN
        RAISE EXCEPTION '%','GESTION BLOQUEADA';
      END IF;


        	select * into v_record from conta.tbanca_compra_venta
            where id_banca_compra_venta = 	v_parametros.id_banca_compra_venta;
            
            if v_record.tipo = '' then
            raise exception '%', ' tipo de documento Vacia' ; 
            end if;
            
            if v_record.modalidad_transaccion is null then
            raise exception '%', ' Modalidad de Transaccion de documento Vacia' ; 
            end if;
            
             if v_record.fecha_documento is null then
            raise exception '%', ' Fecha de Documento de documento Vacia' ; 
            end if;
            
            if v_record.tipo_transaccion is null then
            raise exception '%', 'Tipo de Transaccion de documento Vacia' ; 
            end if;
            
            if v_record.nit_ci = '' then
            raise exception '%', ' Nit de documento Vacia' ; 
            end if;
            
            if v_record.razon = '' then
            raise exception '%', ' Razon de documento Vacia' ; 
            end if;
            
            
            if (v_record.num_documento = '') then
            raise exception '%', ' Numero de documento Vacia' ; 
            end if;
            
            if (v_record.num_contrato = '') then
            raise exception '%', ' Numero de Contrato Vacia' ; 
            end if;
            
            if (v_record.importe_documento is null) then
            raise exception '%', ' Importe de Documento Vacia' ; 
            end if;
            
            if (v_record.autorizacion is null) then
            raise exception '%', ' Autorizacion de Contrato Vacia' ; 
            end if;
            
            if (v_record.num_cuenta_pago = '') then
            raise exception '%', ' Numero de cuenta de pago Vacia' ; 
            end if;
            
             if (v_record.monto_pagado is null) then
            raise exception '%', ' Monto Pagado Vacia' ; 
            end if;
            
             if (v_record.monto_acumulado is null) then
            raise exception '%', 'Monto Acumulado Vacia' ; 
            end if;
            
            if (v_record.nit_entidad is null) then
            raise exception '%', 'Nit Entidad Acumulado Vacia' ; 
            end if;
            
             if (v_record.num_documento_pago = '') then
            raise exception '%', ' Numero de documento de pago Vacia' ; 
            end if;
            
            if (v_record.tipo_documento_pago is null) then
            raise exception '%', 'tipo de documento de pago Acumulado Vacia' ; 
            end if;
            
             if (v_record.fecha_de_pago is null) then
            raise exception '%', 'fecha de pago Vacia' ; 
            end if;


            if v_record.revisado = 'si' then
            update conta.tbanca_compra_venta 
            set revisado = 'no' 
            where id_banca_compra_venta = v_parametros.id_banca_compra_venta;
            end if;
            
            if v_record.revisado = 'no' then
            update conta.tbanca_compra_venta 
            set revisado = 'si' 
            where id_banca_compra_venta = v_parametros.id_banca_compra_venta;
            end if;




			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Revision con exito (id_banca_compra_venta'||v_parametros.id_banca_compra_venta||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_banca_compra_venta',v_parametros.id_banca_compra_venta::varchar);

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