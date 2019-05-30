CREATE OR REPLACE FUNCTION conta.f_migrar_armar_int_comprobante (
  p_id_usuario integer,
  p_id_int_comprobante integer,
  p_migra_nro_tramite varchar,
  p_conexion varchar = NULL::character varying
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:       Sistema de Contabilidad
 FUNCION:       conta.f_migrar_armar_int_comprobante
 DESCRIPCION:   arma los parametros para la funcion conta.f_migrar_int_comprobante en la base de datos destino                  
 AUTOR:         (EGS)  EndeETR
 FECHA:         18/03/2019            
 COMENTARIOS:    
***************************************************************************
 HISTORIAL DE MODIFICACIONES:       
 ISSUE:          FECHA:             AUTOR:             DESCRIPCION:    
   #55           29/05/2019         EGS                Arma los json de los comprobantes y sus transsacciones que migraran a la otra BD
***************************************************************************/

DECLARE
  
    v_nombre_funcion                           text;
    v_resp                                  varchar; 
    v_nombre_conexion                       varchar;
    v_consulta                              varchar;
    v_nombre_con                            varchar;
    v_intransaccion                         record;
    v_id_int_comprobante                    integer;
    v_nro_tramite                           varchar;
    v_comprobantes                          record;
    v_js_cbte                                varchar;
    v_js_intra                              varchar;
    v_resp_dblink                           varchar;
    j_id_int_comprobante_new                json;
    v_json_cbte                             varchar;
    v_json_intra                            varchar;
BEGIN

    v_nombre_funcion = 'conta.f_migrar_armar_int_comprobante'; 
    
    -- Verificar que el int_comprobante no sea null    
    if (p_id_int_comprobante is null) then
        raise exception 'Error al migrar el comprobante , el campo int_comprobante esta vacio';
    end if; 
    --creando la conexion
    if p_conexion is null then
     
        select * into v_nombre_conexion from conta.f_crear_conexion();
    else
        v_nombre_conexion = p_conexion;
    end if;
    --armamos y adjuntamos a los json si hay ya comprobantes con el mismo numero de tramite validados
    SELECT
        cbe.nro_tramite
    INTO
        v_nro_tramite      
    FROM conta.tint_comprobante cbe
    WHERE cbe.id_int_comprobante = p_id_int_comprobante;
    --armamos los datos a un formato json, un json para los comprobantes y otro para las transacciones
    --adjuntamos los datos al json del comprobante que pasa a estado validado
     v_js_cbte = '';
     v_js_intra = '';
     
     v_json_cbte = pxp.f_json__tabla(1,'conta','tint_comprobante','id_int_comprobante',p_id_int_comprobante)::varchar;
     v_js_cbte = v_js_cbte||v_json_cbte;
    
     v_json_intra = pxp.f_json__tabla(1,'conta','tint_transaccion','id_int_comprobante',p_id_int_comprobante)::varchar;
     v_js_intra = v_js_intra||v_json_intra;
     
      

     
   IF p_migra_nro_tramite = 'si' THEN
            v_js_cbte = SUBSTRING (v_js_cbte,1,length(v_js_cbte) - 1);
            v_js_intra = SUBSTRING (v_js_intra, 1,length(v_js_intra) - 1);
  
            IF v_js_cbte <> '[' THEN
                v_js_cbte = v_js_cbte||',';
            END IF;
            IF v_js_intra <> '[' THEN
                v_js_intra = v_js_intra||',';
            END IF; 
         --adjuntamos los datos de los comprobantes que comparten el mismo numero de tramite
            FOR v_comprobantes IN(
            SELECT 
                    cbt.id_int_comprobante,
                    cbt.nro_tramite
                  FROM conta.tint_comprobante cbt
                  WHERE cbt.nro_tramite = v_nro_tramite and 
                  cbt.id_int_comprobante_migrado is null and
                  cbt.estado_reg = 'validado' and
                  cbt.id_int_comprobante <> p_id_int_comprobante
        )LOOP    
                
                --RAISE EXCEPTION 'v_comprobantes.id_int_comprobante %',v_nro_tramite;
                
                v_json_cbte = pxp.f_json__tabla(1,'conta','tint_comprobante','id_int_comprobante',v_comprobantes.id_int_comprobante)::varchar;
                
                IF v_json_cbte <> '[]'THEN
                    v_json_cbte = SUBSTRING (v_json_cbte,2,length(v_json_cbte));
                    v_json_cbte = SUBSTRING (v_json_cbte,1,length(v_json_cbte) - 1);
                    v_js_cbte = v_js_cbte||v_json_cbte||',';
                END IF; 
                
                               
                    v_json_intra = pxp.f_json__tabla(1,'conta','tint_transaccion','id_int_comprobante',v_comprobantes.id_int_comprobante)::varchar;
                IF v_json_intra <> '[]'THEN 
                    v_json_intra = SUBSTRING (v_json_intra,2,length(v_json_intra));
                    v_json_intra = SUBSTRING (v_json_intra,1,length(v_json_intra) - 1);
                    v_js_intra = v_js_intra||v_json_intra||',';
                END IF;
                

        END LOOP;
   END IF;
   --quitamos la ultima coma y agregamos ] para cerrar el formato json
   v_js_cbte = SUBSTRING (v_js_cbte,1,length(v_js_cbte) - 1);
   v_js_cbte = v_js_cbte||']';

   --quitamos la ultima coma y agregamos ] para cerrar el formato json
   v_js_intra = SUBSTRING (v_js_intra, 1,length(v_js_intra) - 1);
   v_js_intra = v_js_intra||']';
  --Armamos la consulta para la base de datos Destino 
   v_consulta = 'SELECT * from conta.f_migrar_int_comprobante (1,'||''''||v_js_cbte||''''||'::json,'||''''||v_js_intra||''''||'::json,1)'; 
   --Ejecutamos las funcion en la base de datos destino   
   select * FROM dblink(v_nombre_conexion, v_consulta,TRUE)AS t1(resp_dblink varchar) into v_resp_dblink;
   
   --Despues de recuperar los ids nuevos los actualizamos 
    FOR j_id_int_comprobante_new IN (SELECT *
                        FROM json_array_elements(v_resp_dblink::json)) LOOP
                        UPDATE conta.tint_comprobante SET
                              id_int_comprobante_migrado = (j_id_int_comprobante_new->>'"id_int_comprobante_new"')::INTEGER 
                        WHERE id_int_comprobante = (j_id_int_comprobante_new->>'"id_int_comprobante_old"')::INTEGER ; 
    END LOOP; 
  
  --Cerramos la conexion
  select * into v_resp from conta.f_cerrar_conexion(v_nombre_conexion,'exito');   
  
  RETURN  'exito';
EXCEPTION                 
    WHEN OTHERS THEN
            v_resp='';
            v_resp = pxp.f_agrega_clave(v_resp,'p_id_int_comprobante',p_id_int_comprobante::varchar);
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