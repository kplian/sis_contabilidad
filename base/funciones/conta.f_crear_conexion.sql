CREATE OR REPLACE FUNCTION conta.f_crear_conexion (
  p_id_depto_lb integer = NULL::integer,
  p_tabla varchar = NULL::character varying,
  p_codigo_estacion varchar = NULL::character varying
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Sistema
 FUNCION:         conta.f_crear_conexion
 DESCRIPCION:   Funcion que recupera los datos de conexion al servidor remoto
 AUTOR:         EGS
 FECHA:            11/03/2019
 COMENTARIOS:    
***************************************************************************/
DECLARE

v_host              varchar;
v_puerto            varchar;
v_dbname            varchar;
v_user              varchar;
v_password          varchar;
v_sincronizar       varchar;
v_resp              varchar;
v_nombre_funcion    varchar;
v_cadena            varchar;
v_nombre_con        varchar;
v_instancia            record;
v_consulta            varchar;
v_migra_cbte          varchar;
BEGIN
        
        v_nombre_funcion =  'conta.f_crear_conexion';
        
        --direccion de la bd esclava a donde se migraran los comprobantes
        v_cadena = pxp.f_get_variable_global('conta_host_migracion');
        
        -- variable que habilita la migracion si = true , no = false
        v_migra_cbte = (pxp.f_get_variable_global('conta_migrar_comprobante'))::varchar;
        
        if (v_migra_cbte != 'true') then
            raise exception 'No esta habilitada ninguna opcion de sincronizacion para la base  de datos';
        end if;

      select trunc(random()*100000)::varchar into v_nombre_con;
      v_nombre_con = 'pg_' || v_nombre_con;
      perform dblink_connect(v_nombre_con, v_cadena);
      perform dblink_exec(v_nombre_con, 'begin;', true);
      return v_nombre_con;  
 
   
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