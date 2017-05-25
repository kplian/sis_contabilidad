--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_periodo_compra_venta_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_periodo_compra_venta_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tperiodo_compra_venta'
 AUTOR: 		 (admin)
 FECHA:	        24-08-2015 14:16:54
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_periodo_compra_venta	integer;
    v_registros					record;
    v_fecha_fin					date;
    v_estado					varchar;
			    
BEGIN

    v_nombre_funcion = 'conta.ft_periodo_compra_venta_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	 /*********************************    
 	#TRANSACCION:  'CONTA_GENPCV_IME'
 	#DESCRIPCION:	Genracion losperiodos de compra venta para el depto y gention selecionados
 	#AUTOR:		    Rensi Arteaga Copari
 	#FECHA:			24-08-2015 13:58:30
	***********************************/

	if(p_transaccion='CONTA_GENPCV_IME')then

		begin
			
        	
            
        	--obtener los registros de la tabla periodo que no esten en la tabla tperiodo_compra_venta
            FOR v_registros in  (
                select  
                    per.id_periodo
                from param.tperiodo as per
                where per.estado_reg = 'activo'
                and per.id_periodo not in (
                	select pcv.id_periodo 
                    from conta.tperiodo_compra_venta pcv
                    inner join param.tperiodo p2 on p2.id_periodo = pcv.id_periodo
                    where pcv.id_depto = v_parametros.id_depto
                    and p2.id_gestion = v_parametros.id_gestion
                ) and per.id_gestion = v_parametros.id_gestion
            ) LOOP
           
              INSERT INTO  conta.tperiodo_compra_venta
                        (
                          id_usuario_reg,
                          fecha_reg,
                          estado_reg,
                          id_depto,
                          id_periodo,
                          estado
                        )
                        VALUES (
                           p_id_usuario,
                           now(),
                          'activo',
                          v_parametros.id_depto,
                          v_registros.id_periodo,
                          'abierto'
                        );
        
            END LOOP;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Periodos compra venta generados el depto '||v_parametros.id_depto::varchar); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_gestion',v_parametros.id_gestion::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
    /*********************************    
 	#TRANSACCION:  'CONTA_ABRCERPER_IME'
 	#DESCRIPCION:	abre, cierra o cierra parcialmente los periodos de libro de compras y ventas
 	#AUTOR:		    Rensi Arteaga Copari
 	#FECHA:			24-08-2015 13:58:30
	***********************************/

	elsif(p_transaccion='CONTA_ABRCERPER_IME')then

		begin
			
        --raise exception 'sssss   sss %', v_parametros;
        
           select 
             per.fecha_fin
           into
             v_fecha_fin
           from conta.tperiodo_compra_venta pcv
           inner join param.tperiodo per on per.id_periodo = pcv.id_periodo 
            where pcv.id_periodo_compra_venta = v_parametros.id_periodo_compra_venta;
           
        
        	--todo para abrir el perido revisar que el periodo de conta del periodo correspondiente este cerrado
            IF not param.f_periodo_subsistema_abierto(v_fecha_fin, 'CONTA') THEN
              raise exception 'El periodo se encuentra cerrado en contabilidad';
            END IF;
            
            
            IF  v_parametros.tipo = 'cerrar' THEN
             v_estado = 'cerrado';
            ELSIF  v_parametros.tipo = 'cerrar_parcial' THEN
             v_estado = 'cerrado_parcial';
            ELSE 
             v_estado = 'abierto';
            END IF;
            
            update conta.tperiodo_compra_venta pcv set
              estado = v_estado
            where pcv.id_periodo_compra_venta = v_parametros.id_periodo_compra_venta; 
        	
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','periodo de libro de compra y ventas pasa al estado: ' || v_estado); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_periodo_compra_venta',v_parametros.id_periodo_compra_venta::varchar);
              
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