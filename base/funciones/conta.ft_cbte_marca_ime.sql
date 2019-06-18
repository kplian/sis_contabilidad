CREATE OR REPLACE FUNCTION conta.ft_cbte_marca_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Sistema de Contabilidad
 FUNCION:         conta.ft_cbte_marca_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tcbte_marca'
 AUTOR:          (egutierrez)
 FECHA:            10-06-2019 20:02:44
 COMENTARIOS:    
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #0                10-06-2019 20:02:44                                Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'conta.tcbte_marca'    
 #61               11/06/2019              EGS                        Elimina si no existe ni una marca
 ***************************************************************************/

DECLARE

    v_nro_requerimiento     integer;
    v_parametros            record;
    v_id_requerimiento      integer;
    v_resp                  varchar;
    v_nombre_funcion        text;
    v_mensaje_error         text;
    v_id_cbte_marca         integer;
    v_marca                 integer;
    v_id_marca              varchar[];
    v_tamano                integer;
    v_consulta              varchar;
                
BEGIN

    v_nombre_funcion = 'conta.ft_cbte_marca_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************    
     #TRANSACCION:  'CONTA_CBTEMAR_INS'
     #DESCRIPCION:    Insercion de registros
     #AUTOR:        egutierrez    
     #FECHA:        10-06-2019 20:02:44
    ***********************************/

    if(p_transaccion='CONTA_CBTEMAR_INS')then
                    
        begin
            --Sentencia de la insercion
            insert into conta.tcbte_marca(
            id_int_comprobante,
            id_marca,
            estado_reg,
            id_usuario_reg,
            fecha_reg,
            usuario_ai,
            id_usuario_ai,
            id_usuario_mod,
            fecha_mod
              ) values(
            v_parametros.id_int_comprobante,
            v_parametros.id_marca,
            'activo',
            p_id_usuario,
            now(),
            v_parametros._nombre_usuario_ai,
            v_parametros._id_usuario_ai,
            null,
            null
                            
            
            
            )RETURNING id_cbte_marca into v_id_cbte_marca;
            
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Relacion de marca con el cbte almacenado(a) con exito (id_cbte_marca'||v_id_cbte_marca||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cbte_marca',v_id_cbte_marca::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

    /*********************************    
     #TRANSACCION:  'CONTA_CBTEMAR_MOD'
     #DESCRIPCION:    Modificacion de registros
     #AUTOR:        egutierrez    
     #FECHA:        10-06-2019 20:02:44
    ***********************************/

    elsif(p_transaccion='CONTA_CBTEMAR_MOD')then

        begin
            --Sentencia de la modificacion
            update conta.tcbte_marca set
            id_int_comprobante = v_parametros.id_int_comprobante,
            id_marca = v_parametros.id_marca,
            id_usuario_mod = p_id_usuario,
            fecha_mod = now(),
            id_usuario_ai = v_parametros._id_usuario_ai,
            usuario_ai = v_parametros._nombre_usuario_ai
            where id_cbte_marca=v_parametros.id_cbte_marca;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Relacion de marca con el cbte modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cbte_marca',v_parametros.id_cbte_marca::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
        end;

    /*********************************    
     #TRANSACCION:  'CONTA_CBTEMAR_ELI'
     #DESCRIPCION:    Eliminacion de registros
     #AUTOR:        egutierrez    
     #FECHA:        10-06-2019 20:02:44
    ***********************************/

    elsif(p_transaccion='CONTA_CBTEMAR_ELI')then

        begin
            --Sentencia de la eliminacion
            delete from conta.tcbte_marca
            where id_cbte_marca=v_parametros.id_cbte_marca;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Relacion de marca con el cbte eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cbte_marca',v_parametros.id_cbte_marca::varchar);
              
            --Devuelve la respuesta
            return v_resp;

       end;
           /*********************************    
     #TRANSACCION:  'CONTA_CBTEMGU_MOD'
     #DESCRIPCION:    guarda los registros de marca
     #AUTOR:        egutierrez    
     #FECHA:        10-06-2019 20:02:44
    ***********************************/

      elsif(p_transaccion='CONTA_CBTEMGU_MOD')then

        begin
            --RAISE exception 'v_parametros %',v_parametros.id_marca; 
            --Sentencia de la modificacion
            
             v_id_marca = string_to_array(v_parametros.id_marca,',');
             v_tamano = coalesce(array_length(v_id_marca, 1),0);

            FOR v_i IN 1..v_tamano LOOP
               SELECT 
                  '1'
               INTO
                v_marca
               FROM conta.tcbte_marca cbm
               WHERE cbm.id_int_comprobante = v_parametros.id_int_comprobante and cbm.id_marca =  v_id_marca[v_i]::integer;
               
                IF v_marca is null THEN              
              --insertamos  registro si no esta presente como activo
                  insert into conta.tcbte_marca 
                     (id_int_comprobante, 
                     id_marca, 
                     estado_reg,
                     id_usuario_reg) 
                  values(
                  v_parametros.id_int_comprobante,
                  v_id_marca[v_i]::integer,
                  'activo',
                  p_id_usuario);                 
                
                END IF; 
            END LOOP; 
            IF v_parametros.id_marca <> '' THEN 
            v_consulta = 'DELETE FROM conta.tcbte_marca WHERE id_int_comprobante = '||v_parametros.id_int_comprobante||' and id_marca not in ('||v_parametros.id_marca||')';  
            ELSE
            v_consulta = 'DELETE FROM conta.tcbte_marca WHERE id_int_comprobante = '||v_parametros.id_int_comprobante;  --#61
            END IF;
            --raise exception 'v_consulta %',v_consulta;
            EXECUTE (v_consulta);
            
            v_resp = 'exito';                  
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