--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.ft_tipo_estado_cuenta_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		conta.ft_tipo_estado_cuenta_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'conta.ttipo_estado_cuenta'
 AUTOR: 		 (admin)
 FECHA:	        26-07-2017 21:48:36
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
    
    v_monto_mb			numeric;
    v_monto_mt			numeric;
	v_detalle			record;	
    v_cont 				integer;	
    v_registros  		record;
    va_monto			numeric[];
    v_id_tabla			integer;    
BEGIN

	v_nombre_funcion = 'conta.ft_tipo_estado_cuenta_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CONTA_TEC_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		26-07-2017 21:48:36
	***********************************/

	if(p_transaccion='CONTA_TEC_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						tec.id_tipo_estado_cuenta,
						tec.codigo,
						tec.estado_reg,
						tec.columna_codigo_aux,
						tec.columna_id_tabla,
						tec.tabla,
						tec.nombre,
						tec.usuario_ai,
						tec.fecha_reg,
						tec.id_usuario_reg,
						tec.id_usuario_ai,
						tec.id_usuario_mod,
						tec.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	
						from conta.ttipo_estado_cuenta tec
						inner join segu.tusuario usu1 on usu1.id_usuario = tec.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = tec.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;
		------------------------------

        /*********************************    
        #TRANSACCION:  'CONTA_REP_SEL'
        #DESCRIPCION:	Conteo de registros
        #AUTOR:		admin	
        #FECHA:		26-07-2017 21:48:36
        ***********************************/

      elsif(p_transaccion='CONTA_REP_SEL')then

		begin
			-- 1) Crea una tabla temporal con los datos que se utilizaran 
        	CREATE TEMPORARY TABLE temp_estado_cuenta (
                                id_auxiliar integer,
                                id_tipo_estado_cuenta integer,
                                id_tipo_estado_columna integer,
                                id_config_subtipo_cuenta INTEGER,
                                fecha_ini  date,
                                fecha_fin date,
                                desc_csc varchar,
                                codigo varchar,
                                nombre varchar,
                                monto_mb numeric,
                                monto_mt numeric,
                                prioridad numeric,
                                nombre_funcion varchar,
                                link_int_det  VARCHAR,
                                tabla  varchar,
                                id_tabla integer,
                                origen  varchar,
                                descripcion  varchar,
                                nombre_clase	VARCHAR,
                                parametros_det	VARCHAR
                           ) ON COMMIT DROP;
				--listao tipos de columna para el tipo de estado de cuenta
				FOR v_detalle in (select tec.id_tipo_estado_cuenta,
                                         tec.id_tipo_estado_columna,
                                         tec.id_config_subtipo_cuenta,
                                         tec.codigo,
                                         tec.descripcion,
                                         tec.link_int_det,
                                         tec.nombre,
                                         tec.nombre_funcion,
                                         tec.origen,
                                         tec.prioridad,
                                         tec.nombre_clase,
                                         tec.parametros_det,
                                         csc.nombre as desc_csc,
                                         t.tabla,
                                         t.columna_id_tabla,
                                         t.columna_codigo_aux
                                  from conta.ttipo_estado_columna tec
                                  inner join conta.ttipo_estado_cuenta t on t.id_tipo_estado_cuenta = tec.id_tipo_estado_cuenta
                                  left join conta.tconfig_subtipo_cuenta  csc on csc.id_config_subtipo_cuenta = tec.id_config_subtipo_cuenta
                                  where tec.estado_reg = 'activo' and  tec.id_tipo_estado_cuenta = v_parametros.id_tipo_estado_cuenta 
                                  order by tec.prioridad asc
                                  ) LOOP
        		v_monto_mb = 0;
                v_monto_mt = 0;
                IF v_detalle.origen = 'contabilidad' THEN                                 
                     va_monto = conta.f_mayor_subtipo_cuenta(v_detalle.id_config_subtipo_cuenta, 
                     									    v_parametros.id_auxiliar, 
                                                            v_parametros.desde, 
                                                            v_parametros.hasta, 
                                                            'si',   --p_incluir_cierre, 
                                                            'todos',  --p_incluir_apertura, 
                                                            'todos',   --p_incluir_aitb, 
                                                            'defecto_cuenta',    --p_signo_balance, 
                                                            'balance'  -- tipo saldo
                                                            );
                ELSE                    
                     --EJECUTAR funcion que realiza el calculo de la columna                      
                      v_consulta = 'select  '||v_detalle.columna_id_tabla||' as id_tabla
                                    from  '||v_detalle.tabla||' x
                                    inner join conta.tauxiliar aux on upper(aux.codigo_auxiliar) = upper('||v_detalle.columna_codigo_aux ||') 
                                    where aux.id_auxiliar = '|| v_parametros.id_auxiliar::varchar;                                          
                      IF v_consulta is null THEN
                         raise exception 'Al parecer no existe alguno de los siguientes valores o tiene un problema de sistaxis en la configuraciÃ³n: %, %,%',v_detalle.tabla, v_detalle.columna_codigo_aux,v_detalle.columna_id_tabla;
                      END IF;                      
                      v_cont = 0;                      
                      FOR v_registros in execute(v_consulta) LOOP
                         v_cont = v_cont + 1;
                      END LOOP;
                      IF v_cont > 1 THEN
                          raise exception 'Se encontro mas de un resultado para el auxiliar  %,en la tabla % ',v_parametros.id_auxiliar, v_detalle.tabla;
                      ELSEIF v_cont = 0 THEN
                           raise exception 'No se encontrÃ³ ninguna coincidencia para el auxiliar  %,en la tabla % ',v_parametros.id_auxiliar, v_detalle.tabla;
					  END IF;                      
                      v_consulta = 'SELECT '||v_detalle.nombre_funcion||'(
                                           '||v_parametros.id_auxiliar::varchar ||', 
                                           '||v_registros.id_tabla||', 
                                           '''||v_detalle.tabla ||''',
                                           '||v_parametros.id_tipo_estado_cuenta ||', 
                                           '''||v_parametros.desde::varchar||'''::Date, 
                                           '''||v_parametros.hasta::varchar ||'''::Date );';                    
                      v_id_tabla =  v_registros.id_tabla;                                                                                
                      --exuta funcion de calculo
                      EXECUTE (v_consulta) into va_monto;
                  END IF;
                  v_monto_mb = va_monto[1];
                  v_monto_mt = va_monto[2];                          
                  --insertar resultado en tabla temporal                  
                  INSERT INTO temp_estado_cuenta (
                                id_auxiliar ,
                                id_tipo_estado_cuenta ,
                                id_tipo_estado_columna ,
                                id_config_subtipo_cuenta ,
                                fecha_ini  ,
                                fecha_fin ,
                                desc_csc ,
                                codigo ,
                                nombre ,
                                monto_mb ,
                                monto_mt ,
                                prioridad ,
                                nombre_funcion ,
                                link_int_det  ,
                                tabla  ,
                                id_tabla ,
                                origen,
                                descripcion,
                                nombre_clase,
                                parametros_det
                           )
                           VALUES(
                                v_parametros.id_auxiliar ,
                                v_parametros.id_tipo_estado_cuenta ,
                                v_detalle.id_tipo_estado_columna ,
                                v_detalle.id_config_subtipo_cuenta ,
                                v_parametros.desde  ,
                                v_parametros.hasta ,
                                v_detalle.desc_csc ,
                                v_detalle.codigo ,
                                v_detalle.nombre ,
                                v_monto_mb ,
                                v_monto_mt ,
                                v_detalle.prioridad ,
                                v_detalle.nombre_funcion ,
                                v_detalle.link_int_det  ,
                                v_detalle.tabla  ,
                                v_id_tabla ,
                                v_detalle.origen,
                                v_detalle.descripcion,
                                v_detalle.nombre_clase,
                                v_detalle.parametros_det
                                
                           );                      
       			END LOOP;                           
				
                v_consulta:='SELECT e.id_auxiliar ,
                                    e.id_tipo_estado_cuenta ,
                                    e.id_tipo_estado_columna ,
                                    e.id_config_subtipo_cuenta ,
                                    e.fecha_ini  ,
                                    e.fecha_fin ,
                                    e.desc_csc ,
                                    e.codigo ,
                                    e.nombre ,
                                    COALESCE(e.monto_mb,0) as monto_mb ,
                                    COALESCE(e.monto_mt,0) as monto_mt,
                                    e.prioridad ,
                                    e.nombre_funcion ,
                                    e.link_int_det  ,
                                    e.tabla  ,
                                    e.id_tabla,
                                    e.origen ,
                                    e.descripcion,
                                    a.nombre_auxiliar as desc_auxiliar,
                                    e.nombre_clase,
                                    e.parametros_det
                            FROM temp_estado_cuenta e
                            inner join conta.tauxiliar a on a.id_auxiliar = e.id_auxiliar 
                            order by  prioridad asc';  
                return v_consulta;
		end;
	------------------------------
	/*********************************    
 	#TRANSACCION:  'CONTA_TEC_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		26-07-2017 21:48:36
	***********************************/

	elsif(p_transaccion='CONTA_TEC_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_tipo_estado_cuenta)
					    from conta.ttipo_estado_cuenta tec
					    inner join segu.tusuario usu1 on usu1.id_usuario = tec.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = tec.id_usuario_mod
					    where ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
					
	else
					     
		raise exception 'Transaccion inexistente';
					         
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