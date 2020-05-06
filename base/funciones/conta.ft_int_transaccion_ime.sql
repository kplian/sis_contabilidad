--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_int_transaccion_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:    Sistema de Contabilidad
 FUNCION:     conta.ft_int_transaccion_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tint_transaccion'
 AUTOR:      (admin)
 FECHA:          01-09-2013 18:10:12
 COMENTARIOS:  
***************************************************************************
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
    ISSUE          FECHA           AUTOR                 DESCRIPCION:  
 #2             30/11/2018        CHROS             CONTROL PARA EVITAR EDITAR DATOS EN TRANSACCIONES
 #90            19/12/2018        EGS               se hizo validacion para forzar a escoger un axuiliar si existe para la cuenta    
 #3 endetr      20/12/2018        CHROS             permitir cambiar montos de transacción con un límite de centavo
 #108 ETR       04/03/2020        RAC KPLIAN        deshabilitar la integracion con LB segun configuracion de variable global.
 #110 ETR       25/03/2020        RAC KPLIAN        Al editar, eliminar o insertar validar que no exista un cheque generado
***************************************************************************/

DECLARE

        v_nro_requerimiento           integer;
        v_parametros                  record;
        v_registros                   record;
        v_registros_trans             record;
        v_id_requerimiento            integer;
        v_resp                        varchar;
        v_nombre_funcion              text;
        v_mensaje_error               text;
        v_id_int_transaccion          integer;
        v_importe_debe                numeric;
        v_importe_haber               numeric;    
        v_importe_debe_mb             numeric;
        v_importe_haber_mb            numeric;
        v_id_moneda_base              integer;
        v_tc_1                        numeric;
        v_tc_2                        numeric;
        v_monto                       numeric;
        v_factor                      numeric;
        v_conta_ejecucion_igual_pres_conta    varchar;
        v_monto_recurso               numeric;
        v_monto_gasto                 numeric;
        v_id_transaccion              integer;
        v_id_cuenta                   integer;
        v_id_auxiliar                 integer;
        v_id_centro_costo             integer;
        v_id_gestion                  integer;
        v_id_partida                  integer;
        v_debe                        numeric;
        v_haber                       numeric;
        v_reg_trans                   record;
        v_r                           record;
        v_exi_auxiliar                varchar; --#90    19/12/2018    EGS    
        v_sw_gen_lb                   boolean; --#108
        v_id_cuenta_bancaria          integer;
        v_conta_integrar_libro_bancos varchar;
        v_valor                       varchar;
        v_conta_generar_lb_manual_oc  varchar; 
BEGIN

    v_nombre_funcion = 'conta.ft_int_transaccion_ime';
    v_parametros = pxp.f_get_record(p_tabla);

  /*********************************    
   #TRANSACCION:  'CONTA_INTRANSA_INS'
   #DESCRIPCION:  Insercion de registros
   #AUTOR:    admin  
   #FECHA:    01-09-2013 18:10:12
  ***********************************/

  if(p_transaccion='CONTA_INTRANSA_INS')then
          
        begin
                    
             select
               cbt.id_moneda,
               cbt.id_moneda_tri,
               cbt.id_moneda_act,
               cbt.tipo_cambio,
               cbt.tipo_cambio_2,
               cbt.tipo_cambio_3,
               cbt.fecha
             into
               v_registros
             from conta.tint_comprobante cbt
             where  cbt.id_int_comprobante = v_parametros.id_int_comprobante;
          ----------------------------------------------
          --  si la moneda es diferente de la base
          ----------------------------------------------
            
             -- Obtener la moneda base
             v_id_moneda_base = param.f_get_moneda_base();
            
             v_importe_debe  =  v_parametros.importe_debe;
             v_importe_haber = v_parametros.importe_haber;          
           
            
            --si el tipo de cambia varia a de la cabecara marcamos la cabecera, 
            -- para que no actulice automaricamente las transacciones si es modificada
            IF      v_registros.tipo_cambio !=  v_parametros.tipo_cambio 
                 or v_registros.tipo_cambio_2 !=  v_parametros.tipo_cambio_2 
                 or v_registros.tipo_cambio_3 !=  v_parametros.tipo_cambio_3 THEN
              
              update conta.tint_comprobante set
                sw_tipo_cambio = 'si'
              where id_int_comprobante =  v_parametros.id_int_comprobante;
            
            END IF;
            
            --verifica si presupeusto y iguala con la contabilidad
            
            v_conta_ejecucion_igual_pres_conta = pxp.f_get_variable_global('conta_ejecucion_igual_pres_conta');
        
            IF v_conta_ejecucion_igual_pres_conta  = 'no' THEN            
               v_monto_gasto = v_parametros.importe_gasto;
               v_monto_recurso = v_parametros.importe_recurso;
            ELSE
               v_monto_gasto = v_parametros.importe_debe;
               v_monto_recurso = v_parametros.importe_haber;
            END IF;
            
                  
          --#90    19/12/2018    EGS 
            SELECT
                cu.ex_auxiliar 
            INTO
             v_exi_auxiliar                   
            FROM conta.tcuenta cu
            left join conta.tcuenta_auxiliar cua on cua.id_cuenta = cu.id_cuenta
            where cua.estado_reg = 'activo' and cu.id_cuenta =  v_parametros.id_cuenta;
              
            IF v_exi_auxiliar = 'si' and  v_parametros.id_auxiliar is null then
               RAISE EXCEPTION 'Esta Cuenta exige un auxiliar escoja uno';
            END IF;
            
          --#90    19/12/2018    EGS   
          -----------------------------
          --REGISTRO DE LA TRANSACCIÓN
          -----------------------------
          insert into conta.tint_transaccion(
                id_partida,
                id_centro_costo,
                estado_reg,
                id_cuenta,
                glosa,
                id_int_comprobante,
                id_auxiliar,
                importe_debe,
                importe_haber,
                importe_gasto,
                importe_recurso,
                id_usuario_reg,
                fecha_reg,
                id_usuario_mod,
                fecha_mod,
                id_orden_trabajo,
                tipo_cambio,
                tipo_cambio_2,
                tipo_cambio_3,
                id_moneda,
                id_moneda_tri,
                id_moneda_act,
                id_suborden                
            ) values(
                v_parametros.id_partida,
                v_parametros.id_centro_costo,
                'activo',
                v_parametros.id_cuenta,
                v_parametros.glosa,
                v_parametros.id_int_comprobante,
                v_parametros.id_auxiliar,
                v_parametros.importe_debe,
                v_parametros.importe_haber,
                v_monto_gasto,
                v_monto_recurso,
               
                p_id_usuario,
                now(),
                null,
                null,
                v_parametros.id_orden_trabajo,
                v_parametros.tipo_cambio,
                v_parametros.tipo_cambio_2,
                v_parametros.tipo_cambio_3,
                v_registros.id_moneda,
                v_registros.id_moneda_tri,
                v_registros.id_moneda_act,
                v_parametros.id_suborden
      )RETURNING id_int_transaccion into v_id_int_transaccion;
            
            
            
      -- calcular moneda base y triangulacion
            
      PERFORM  conta.f_calcular_monedas_transaccion(v_id_int_transaccion);
            
      -- procesar las trasaaciones (con diversos propostios, ejm validar  cuentas bancarias)
      IF not conta.f_int_trans_procesar(v_parametros.id_int_comprobante) THEN
        raise exception 'Error al procesar transacciones';
      END IF;
      
      -- #110 caida si la trasaccion tiene cuenta bacaria que no se modifque si tiene un registro de  LB
      IF not conta.f_validar_libro_bancos_trans(v_id_int_transaccion, 'insertar') THEN
         raise exception 'Error al procesar transacciones';
      END IF;
            
      
      --Definicion de la respuesta
      v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Transacción almacenado(a) con exito (id_int_transaccion'||v_id_int_transaccion||')'); 
      v_resp = pxp.f_agrega_clave(v_resp,'id_int_transaccion',v_id_int_transaccion::varchar);

      -- Devuelve la respuesta
      return v_resp;

    end;
        
    /*********************************    
   #TRANSACCION:  'CONTA_INTRANSAXLS_INS'
   #DESCRIPCION:  Insercion de registros desde excel
   #AUTOR:    admin  
   #FECHA:    01-09-2013 18:10:12
  ***********************************/

  elsif(p_transaccion='CONTA_TRANSAXLS_INS')then
              
    begin
     --raise exception 'AAAAAAAAA %',v_parametros;
     
     v_haber = 0;
     v_debe = 0;
     
     
        select 
           p.id_gestion,
           c.tipo_cambio,
           c.tipo_cambio_2,
           c.tipo_cambio_3,
           c.id_moneda,
           c.id_moneda_act,
           c.id_moneda_tri 
        into 
            v_reg_trans
        from conta.tint_comprobante c
        join param.tperiodo p on p.id_periodo=c.id_periodo
        where c.id_int_comprobante=v_parametros.id_int_comprobante;
        
      v_id_gestion = v_reg_trans.id_gestion;
     
      
      
      if not pxp.f_existe_parametro(p_tabla,'debe') and not pxp.f_existe_parametro(p_tabla,'haber') then
        raise exception 'No existen valores Debe/Haber para la cuenta "%"', v_parametros.cuenta;
      else
      
        
        if pxp.f_existe_parametro(p_tabla,'debe') then
          
          if v_parametros.debe is null or  v_parametros.debe = ''  or  v_parametros.debe = ' ' then
            v_debe = 0;
           else
            v_debe = v_parametros.debe::numeric;
          end if;
        end if;
        
        
        
        if pxp.f_existe_parametro(p_tabla,'haber') then
          if  v_parametros.haber is null or  v_parametros.haber = ' ' or  v_parametros.haber = '' then
            v_haber = 0;
          else
             v_haber = v_parametros.haber::numeric;
          end if;
        end if;
        
         -- raise exception 'DEBE %  HABER %', v_parametros.debe, v_parametros.haber;
        
        
        v_id_cuenta = null;
        select c.id_cuenta
        into v_id_cuenta
        from conta.tcuenta c
        where c.sw_transaccional='movimiento' and c.id_gestion=v_id_gestion
        and c.nro_cuenta=v_parametros.cuenta;
        if v_id_cuenta is null then
          raise exception 'No se encontró la cuenta %', v_parametros.cuenta;
        end if;
        
        v_id_auxiliar = null;
        
      
        
        if  pxp.f_existe_parametro(p_tabla,'auxiliar') THEN
          if v_parametros.auxiliar<>'' then
            select 
              a.id_auxiliar
            into 
              v_id_auxiliar
            from conta.tauxiliar a
            join conta.tcuenta_auxiliar ca on ca.id_auxiliar=a.id_auxiliar
            where ca.id_cuenta=v_id_cuenta and a.codigo_auxiliar=v_parametros.auxiliar;
            
            
            if v_id_auxiliar is null then
              select a.id_auxiliar
              into v_id_auxiliar
              from conta.tauxiliar a
              where a.codigo_auxiliar=v_parametros.auxiliar;
              
              
              if v_id_auxiliar is null then
                raise exception 'No existe el auxiliar "%"', v_parametros.auxiliar;
              else
                insert into conta.tcuenta_auxiliar (id_usuario_reg, fecha_reg, estado_reg, id_auxiliar, id_cuenta)
                values (p_id_usuario, now(), 'activo', v_id_auxiliar, v_id_cuenta);
              end if;
              
              
            end if;
            
          end if;
        END IF;
        
       
        
        v_id_centro_costo = null;
        
        select cc.id_centro_costo
        into v_id_centro_costo
        from param.ttipo_cc tcc
        join param.tcentro_costo cc on cc.id_tipo_cc=tcc.id_tipo_cc
        where tcc.movimiento='si' and cc.id_gestion=v_id_gestion and tcc.codigo=v_parametros.centro_costo;
        if v_id_centro_costo is null then
          raise exception 'No se encontró el Centro de Costo "%"', v_parametros.centro_costo;
        end if;

        
        select p.id_partida
        into v_id_partida
        from pre.tpartida p
        join conta.tcuenta_partida cp on cp.id_partida=p.id_partida
        where p.id_gestion=v_id_gestion and cp.id_cuenta=v_id_cuenta and p.codigo=v_parametros.partida;
        if v_id_partida is null then
          select p.id_partida
          into v_id_partida
          from pre.tpartida p
          where p.id_gestion=v_id_gestion and p.codigo=v_parametros.partida;
          if v_id_partida is null then
            raise exception 'La partida "%" no se encuentra registrado', v_parametros.auxiliar;
          else
            insert into conta.tcuenta_partida (id_usuario_reg, fecha_reg, estado_reg, id_cuenta, id_partida, sw_deha, se_rega)
            values (p_id_usuario, now(), 'activo', v_id_cuenta, v_id_partida, 'debe', 'gasto');
          end if;
        end if;
        
       -- raise exception 'DEBE %  HABER %', v_debe, v_haber;
        if COALESCE(v_debe,0)  = 0 and COALESCE(v_haber,0) = 0   then
           raise exception 'por lo menso debe tener importe en el debe o en el haber';
        end if;
  
        --inserta trasaccion
        INSERT INTO conta.tint_transaccion
        (
          id_usuario_reg,
          fecha_reg,
          estado_reg,
          id_int_comprobante,
          id_cuenta,
          id_auxiliar,
          id_centro_costo,
          id_partida,
          id_partida_ejecucion,
          id_int_transaccion_fk,
          glosa,
          importe_debe,
          importe_haber,
         
          importe_gasto,
          importe_recurso,
            
          id_detalle_plantilla_comprobante,
          importe_reversion,
          factor_reversion,
          id_cuenta_bancaria, 
          id_cuenta_bancaria_mov, 
          nro_cheque, 
          nro_cuenta_bancaria_trans, 
          porc_monto_excento_var,
          nombre_cheque_trans,
          id_orden_trabajo,
          forma_pago,
          id_suborden,
                tipo_cambio,
                tipo_cambio_2,
                tipo_cambio_3,
                id_moneda,
                id_moneda_tri,
                id_moneda_act
         ) 
        VALUES (
          1::integer,
          now(),
          'activo',
          v_parametros.id_int_comprobante::integer,
          v_id_cuenta::integer,
          v_id_auxiliar::integer,
          v_id_centro_costo::integer,
          v_id_partida::integer,
          null::integer,--id_partida_ejecucion
          null::integer,--id_int_transaccion_fk
          v_parametros.glosa::varchar,
          COALESCE( v_debe,0)::numeric,
           COALESCE(v_haber,0)::numeric,
           COALESCE(v_debe,0)::numeric,
           COALESCE(v_haber,0)::numeric,
          null::integer,--id_detalle_plantilla_comprobante
          0::numeric,--importe_reversion
          0::numeric,--factor_reversion
          null::integer,--id_cuenta_bancaria
          null::integer,--id_cuenta_bancaria_mov
          null::integer,--nro_cheque
          null::varchar,--nro_cuenta_bancaria_trans
          null::numeric,--porc_monto_excento_var
          null::varchar,--nombre_cheque_trans
          null::integer,--id_orden_trabajo
          null::varchar,--forma_pago
          null::integer,--id_suborden,
           v_reg_trans.tipo_cambio,
           v_reg_trans.tipo_cambio_2,
                v_reg_trans.tipo_cambio_3,
                v_reg_trans.id_moneda,
                v_reg_trans.id_moneda_tri,
                v_reg_trans.id_moneda_act
        ) RETURNING id_int_transaccion into v_id_int_transaccion;
        
        --select it.importe_debe, it.importe_haber into v_r from conta.tint_transaccion it  where it.id_int_transaccion = v_id_transaccion ;
        
        -- raise exception 'importes % ', v_r;
        -- calcular moneda base y triangulacion
        PERFORM  conta.f_calcular_monedas_transaccion(v_id_int_transaccion);
        
        -- raise exception 'importes % ', v_r;
        
        --Definicion de la respuesta
        v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Transacción almacenado(a) con exito (id_int_transaccion'||v_id_int_transaccion||')'); 
        v_resp = pxp.f_agrega_clave(v_resp,'id_int_transaccion',v_id_int_transaccion::varchar);
        --Devuelve la respuesta
        
      end if;
      return v_resp;
    end;

  /*********************************    
   #TRANSACCION:  'CONTA_INTRANSA_MOD'
   #DESCRIPCION:  Modificacion de registros
   #AUTOR:    admin  
   #FECHA:    01-09-2013 18:10:12
  ***********************************/

  elsif(p_transaccion='CONTA_INTRANSA_MOD')then

    begin    
    
               --#90    19/12/2018    EGS     
   
              SELECT
                cu.ex_auxiliar 
              INTO
              v_exi_auxiliar                   
              FROM conta.tcuenta cu
              left join conta.tcuenta_auxiliar cua on cua.id_cuenta = cu.id_cuenta
              where cua.estado_reg = 'activo' and cu.id_cuenta =  v_parametros.id_cuenta;
              
              IF v_exi_auxiliar = 'si' and  v_parametros.id_auxiliar is null then
                RAISE EXCEPTION 'Esta Cuenta exige un auxiliar escoja uno';
              END IF;
            --#90    19/12/2018    EGS     
        
              select
               cbt.id_moneda,
               cbt.tipo_cambio,
               cbt.fecha,
               cbt.id_moneda_tri,
               cbt.id_moneda_act,
               cbt.tipo_cambio_2,
               cbt.tipo_cambio_3,
               cbt.id_moneda,
               cbt.cbte_reversion
             into
               v_registros
             from conta.tint_comprobante cbt
             where  cbt.id_int_comprobante = v_parametros.id_int_comprobante;
             
            --#9999   19/11/2018, RAC,  validar que no se peuden editar trasaccion con partida ejecucion  (OJO una anteriro validacion parece que fue pisada)
            select 
              *  into v_registros_trans
            from conta.tint_transaccion tr
            where tr.id_int_transaccion =  v_parametros.id_int_transaccion;
             
            --#2 CHROS
            IF v_registros_trans.id_partida_ejecucion is not null and v_registros.cbte_reversion='no' THEN
              IF v_parametros.id_centro_costo <> v_registros_trans.id_centro_costo THEN
                raise exception 'No es posible cambiar el CENTRO DE COSTO para no romper la integridad presupuestaria';
              ELSEIF v_parametros.id_partida <> v_registros_trans.id_partida THEN
                raise exception 'No es posible cambiar la PARTIDA para no romper la integridad presupuestaria';
              ELSEIF v_parametros.id_orden_trabajo <> v_registros_trans.id_orden_trabajo THEN
                raise exception 'No es posible cambiar la ORDEN para no romper la integridad presupuestaria';
              ELSEIF v_parametros.id_suborden <> v_registros_trans.id_suborden THEN
                raise exception 'No es posible cambiar la SUB-ORDEN para no romper la integridad presupuestaria';
              ELSEIF v_parametros.importe_debe <> v_registros_trans.importe_debe THEN
                --#3 endetr
                IF ABS(v_parametros.importe_debe - v_registros_trans.importe_debe)>0.01 THEN
                  raise exception 'No es posible cambiar la DEBE para no romper la integridad presupuestaria';
                END IF;
              ELSEIF v_parametros.importe_haber <> v_registros_trans.importe_haber THEN
                --#3 endetr
                IF ABS(v_parametros.importe_haber - v_registros_trans.importe_haber)>0.01 THEN
                  raise exception 'No es posible cambiar la HABER para no romper la integridad presupuestaria';
                END IF;
              ELSEIF v_parametros.tipo_cambio <> v_registros_trans.tipo_cambio THEN
                raise exception 'No es posible cambiar la BS->BS para no romper la integridad presupuestaria';
              ELSEIF v_parametros.tipo_cambio_2 <> v_registros_trans.tipo_cambio_2 THEN
                raise exception 'No es posible cambiar la BS->USD para no romper la integridad presupuestaria';
              ELSEIF v_parametros.tipo_cambio_3 <> v_registros_trans.tipo_cambio_3 THEN
                raise exception 'No es posible cambiar la BS->UFV para no romper la integridad presupuestaria';
              END IF;
              --raise exception 'No puede editar trasacciones que vengas de otros sistemas, para no romper la integridad presupuestaria';
            END IF;
            
            -- si el tipo de cambia varia a de la cabecara marcamos la cabecera, 
            -- para que no actulice automaricamente las transacciones si es modificada
            IF      v_registros.tipo_cambio !=  v_parametros.tipo_cambio 
                or  v_registros.tipo_cambio_2 !=  v_parametros.tipo_cambio_2 
                or  v_registros.tipo_cambio_2 !=  v_parametros.tipo_cambio_3 THEN
              
              update conta.tint_comprobante set
                sw_tipo_cambio = 'si'
              where id_int_comprobante =  v_parametros.id_int_comprobante;
            
            END IF;
            
          ------------
          --VALIDACIONES
          ---------------
          --VerIfica el estado
          if not exists(select 1 from conta.tint_transaccion tra
                inner join conta.tint_comprobante cbte
                on cbte.id_int_comprobante = tra.id_int_comprobante
                where tra.id_int_transaccion = v_parametros.id_int_transaccion
                and cbte.estado_reg in ('borrador', 'vbcbte')  and cbte.sw_editable = 'si') then
            raise exception 'Modificación no realizada: el comprobante no está en estado Borrador o no es editable';
          end if;
            
            
            
           ------------------------------------------------------------------------------ 
           -- si tiene relacion de devengado se limina la relacion
           --------------------------------------------------------------------------------- 
            FOR v_registros in (
                                    select 
                                       rd.id_int_rel_devengado,
                                       rd.monto_pago 
                                    from conta.tint_rel_devengado rd
                                    where   (rd.id_int_transaccion_dev = v_parametros.id_int_transaccion
                                         or rd.id_int_transaccion_pag = v_parametros.id_int_transaccion)
                                         and rd.estado_reg = 'activo' )LOOP
                      DELETE FROM 
                        conta.tint_rel_devengado 
                      WHERE id_int_rel_devengado = v_registros.id_int_rel_devengado;
            END LOOP;
            
            
            v_conta_ejecucion_igual_pres_conta = pxp.f_get_variable_global('conta_ejecucion_igual_pres_conta');
        
            IF v_conta_ejecucion_igual_pres_conta  = 'no' THEN            
               v_monto_gasto = v_parametros.importe_gasto;
               v_monto_recurso = v_parametros.importe_recurso;
            ELSE
               v_monto_gasto = v_parametros.importe_debe;
               v_monto_recurso = v_parametros.importe_haber;
            END IF;
            
            
            
            --------------------------------
            --MODIFICACION DE LA TRANSACCION
            --------------------------------
            update conta.tint_transaccion set
                    id_partida = v_parametros.id_partida,
                    id_centro_costo = v_parametros.id_centro_costo,
                    id_orden_trabajo = v_parametros.id_orden_trabajo,
                    id_cuenta = v_parametros.id_cuenta,
                    glosa = v_parametros.glosa,
                    id_int_comprobante = v_parametros.id_int_comprobante,
                    id_auxiliar = v_parametros.id_auxiliar,
                    id_usuario_mod = p_id_usuario,
                    fecha_mod = now(),
                    tipo_cambio = v_parametros.tipo_cambio,
                    tipo_cambio_2 = v_parametros.tipo_cambio_2,
                    tipo_cambio_3 = v_parametros.tipo_cambio_3,
                    importe_debe = v_parametros.importe_debe,
                    importe_haber = v_parametros.importe_haber,
                    importe_gasto = v_monto_gasto,
                    importe_recurso = v_monto_recurso,
                    id_suborden = v_parametros.id_suborden
                   
            where id_int_transaccion = v_parametros.id_int_transaccion;
            
           
             -- calcular moneda base y triangulacion
            
            PERFORM  conta.f_calcular_monedas_transaccion(v_parametros.id_int_transaccion);
            
            -- procesar las trasaaciones (con diversos propostios, ejm validar  cuentas bancarias)
            IF not conta.f_int_trans_procesar(v_parametros.id_int_comprobante) THEN
              raise exception 'Error al procesar transacciones';
            END IF;
            
            
            -- #110 caida si la trasaccion tiene cuenta bacaria que no se modifque si tiene un registro de  LB
            IF not conta.f_validar_libro_bancos_trans(v_parametros.id_int_transaccion, 'modificar') THEN
              raise exception 'Error al procesar transacciones';
            END IF;
            
               
           --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Transacción modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_int_transaccion',v_parametros.id_int_transaccion::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
    end;
        
        
    /*********************************    
   #TRANSACCION:  'CONTA_SAVTRABAN_MOD'
   #DESCRIPCION:  actuliza datos bancarios para la transaccion
   #AUTOR:    rensi (kplian)  
   #FECHA:    04-08-2015 18:10:12
  ***********************************/

  elsif(p_transaccion='CONTA_SAVTRABAN_MOD')then

    begin
        
    
      --------------------------------
      --MODIFICACION DE LA TRANSACCION
      --------------------------------
      update conta.tint_transaccion set
             nombre_cheque_trans = v_parametros.nombre_cheque_trans,
             forma_pago = v_parametros.forma_pago,
             nro_cheque = v_parametros.nro_cheque,
             nro_cuenta_bancaria_trans = v_parametros.nro_cuenta_bancaria
      where id_int_transaccion=v_parametros.id_int_transaccion;
            
               
      --Definicion de la respuesta
      v_resp = pxp.f_agrega_clave(v_resp,'mensaje','datos bancarios actualizados para la transaccion del cbte)'); 
      v_resp = pxp.f_agrega_clave(v_resp,'id_int_transaccion',v_parametros.id_int_transaccion::varchar);
               
      --Devuelve la respuesta
      return v_resp;
            
    end;

  /*********************************    
   #TRANSACCION:  'CONTA_INTRANSA_ELI'
   #DESCRIPCION:  Eliminacion de registros
   #AUTOR:    admin  
   #FECHA:    01-09-2013 18:10:12
  ***********************************/

  elsif(p_transaccion='CONTA_INTRANSA_ELI')then

    begin
    
          --#2 CHROS añadido cbte.cbte_reversion='no' para no permitir eliminar transacciones que no sean de un comprobante revertido
          ---------------
          --VALIDACIONES
          ---------------
          --VerIfica el estado, solamente puede eliminarse cuando esté en estao borrador
          if not exists(select 1 from conta.tint_transaccion tra
                inner join conta.tint_comprobante cbte on cbte.id_int_comprobante = tra.id_int_comprobante
                where tra.id_int_transaccion = v_parametros.id_int_transaccion
                and ((cbte.estado_reg = 'borrador' and cbte.sw_editable = 'si') or cbte.cbte_reversion='no')) then
            raise exception 'Eliminación no realizada: el comprobante no está en estado Borrador o no es editable';
          end if;
            
          
            --si tiene relacion de devengado es necesario eliminarlas
            
           FOR v_registros in (
                                    select 
                                       rd.id_int_rel_devengado 
                                    from conta.tint_rel_devengado rd
                                    where   (rd.id_int_transaccion_dev = v_parametros.id_int_transaccion
                                         or rd.id_int_transaccion_pag = v_parametros.id_int_transaccion)
                                         and rd.estado_reg = 'activo' )LOOP
                                         
                      DELETE FROM 
                        conta.tint_rel_devengado 
                      WHERE id_int_rel_devengado = v_registros.id_int_rel_devengado;
           END LOOP;
           
            -- #110 caida si la trasaccion tiene cuenta bacaria que no se modifque si tiene un registro de  LB
            IF not conta.f_validar_libro_bancos_trans(v_parametros.id_int_transaccion, 'eliminar') THEN
              raise exception 'Error al procesar transacciones';
            END IF;
            
            
           --------------------------
           --ELIMINACIÓN TRANSACCIÓN 
           --------------------------
           delete from conta.tint_transaccion
           where id_int_transaccion = v_parametros.id_int_transaccion;
               
           --Definicion de la respuesta
           v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Transacción eliminado(a)'); 
           v_resp = pxp.f_agrega_clave(v_resp,'id_int_transaccion',v_parametros.id_int_transaccion::varchar);
              
           --Devuelve la respuesta
           return v_resp;

    end;
    
    /*********************************    
     #TRANSACCION:  'CONTA_GENERAR_LB'
     #DESCRIPCION:  generar libro de banco de manera manual 
     #AUTOR:    rensi (kplian)  
     #FECHA:    10-03-2020 18:10:12
    ***********************************/

  elsif(p_transaccion='CONTA_GENERAR_LB')then

    begin
          v_sw_gen_lb := false;
          
          select 
             cbt.id_int_comprobante,
             dep.prioridad,
             dep.id_depto,
             cc.codigo,
             pla.codigo as codigo_plantilla
          into 
             v_registros_trans
          from conta.tint_comprobante cbt
          join param.tdepto dep on dep.id_depto = cbt.id_depto
          join conta.tclase_comprobante cc on cc.id_clase_comprobante = cbt.id_clase_comprobante
          left join conta.tplantilla_comprobante pla on pla.id_plantilla_comprobante=cbt.id_plantilla_comprobante
          where  cbt.id_int_comprobante = v_parametros.id_int_comprobante;
          
          IF v_registros_trans.prioridad > 0  THEN
              raise exception 'solo  se permite generar el libro de bancos en departamentos contables de prioridad cero (oficina central) - %', v_registros_trans.prioridad;
          END IF;
          
          
          --ver si tiene libro de bancos ....
          v_conta_integrar_libro_bancos = pxp.f_get_variable_global('conta_integrar_libro_bancos');
          v_conta_generar_lb_manual_oc =  pxp.f_get_variable_global('conta_generar_lb_manual_oc');
          v_valor = param.f_get_depto_param( v_registros_trans.id_depto, 'ENTREGA');
        
           --listado de las transacciones del comprobante
          FOR v_registros in (select *
                              from conta.tint_transaccion it
                              where it.id_int_comprobante = v_parametros.id_int_comprobante) LOOP

                -- busca si alguna de las cuentas contables tiene relacion
                -- con una cuenta bancaria
                v_id_cuenta_bancaria = NULL;

                   --si es un cbte de pago ...
                   IF upper(v_registros_trans.codigo) in ('PAGO','PAGOCON','INGRESO','INGRESOCON') THEN
                   
                        IF v_registros.banco = 'si'  THEN

                               IF v_registros.forma_pago = '' or v_registros.forma_pago is  null  THEN
                                 raise exception 'defina la forma de pago para proceder con la validación';
                               END IF;

                               --JJA 13/12/2018  se agrego la plantilla CD-DEVREP-SALDOS
                               IF (v_conta_integrar_libro_bancos = 'si' AND v_valor='NO') OR (v_conta_integrar_libro_bancos='si' AND v_registros_trans.codigo_plantilla in ('SOLFONDAV', 'REPOCAJA','CD-DEVREP-SALDOS')) THEN
                                   
                                    --#108 genera  registros en LB solo si la generacion manual esta desactiva y si no es un depto de contabilidad central (prioridad 0)
                                    IF v_conta_generar_lb_manual_oc = 'si' OR v_registros_trans.prioridad = 0  THEN
                                        -- si alguna transaccion tiene banco habilitado para pago
                                        IF  tes.f_integracion_libro_bancos(p_id_usuario, v_parametros.id_int_comprobante,  v_registros.id_int_transaccion) THEN
                                          v_sw_gen_lb := true;
                                        END IF;
                                    
                                    END IF;
                               END IF;
                        END IF;
                    END IF;
           END LOOP;
           
           IF not v_sw_gen_lb THEN
              raise exception 'no se genero ningun registro en libro de bancos';
           END IF;
            
               
      --Definicion de la respuesta
      v_resp = pxp.f_agrega_clave(v_resp,'mensaje','datos bancarios actualizados para la transaccion del cbte)'); 
      v_resp = pxp.f_agrega_clave(v_resp,'id_int_comprobante', v_parametros.id_int_comprobante::varchar);
               
      --Devuelve la respuesta
      return v_resp;
    end;     
         
  else
     
      raise exception 'Transaccion inexistente, revise el código: %',p_transaccion;

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
PARALLEL UNSAFE
COST 100;