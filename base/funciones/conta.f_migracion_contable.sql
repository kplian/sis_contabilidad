--------------- SQL ---------------

CREATE OR REPLACE FUNCTION conta.f_migracion_contable (
  p_id_usuario integer
)
RETURNS integer AS
$body$
/*
	Autor:JRR 
*/
DECLARE

    v_registros			record;
    v_id_empresa		integer;
    v_cuenta_padre		varchar;
    v_id_cuenta_padre	integer;
    v_id_subsistema 	integer;
    v_id_cuenta			integer;
	v_id_auxiliar		integer;
	v_id_partida		integer;
	v_id_partida_padre	integer;
	v_id_gestion 		integer;
	v_partida_padre		varchar;
    v_id_programa 		integer;
    v_id_proyecto		integer;
    v_id_actividad 		integer;
    v_id_prog_proy_acti integer;
    v_id_financiador	integer;
    v_id_regional		integer;
    v_id_ep    			integer;
    v_id_pres_padre    	integer;
    v_mov_pres			varchar[];
    v_id_categoria    	integer;
    v_id_presupuesto   	integer;
    v_id_centro_costo  	integer;
    v_id_tipo_cc    	integer;
    v_id_tipo_presupuesto_padre	integer;
    v_id_uo    			integer;
    v_cont				integer;
	v_fecha_ini			date;
	v_fecha_fin			date;
	v_id_periodo		integer;
	v_rec				record;
    v_lugares			integer[];
    v_id_lugar			integer;
    v_id_entidad		integer;
    v_id_depto			integer;
    v_id_documento		integer;
BEGIN

	truncate table conta.tcuenta CASCADE;
	truncate table conta.tauxiliar CASCADE;
	truncate table conta.tcuenta_auxiliar CASCADE; 
    truncate table conta.tint_comprobante CASCADE; 
	truncate table pre.tpartida CASCADE;
    truncate table pre.tpresupuesto CASCADE;
    truncate table param.tcentro_costo CASCADE;
    truncate table param.ttipo_cc CASCADE;
    
    
    select id_subsistema into v_id_subsistema
	from segu.tsubsistema
	where codigo = 'CONTA';
	
	if not exists (select 1 from param.tmoneda where id_moneda = 1) then
		INSERT INTO param.tmoneda
		(id_usuario_reg, id_usuario_mod, fecha_reg, fecha_mod, estado_reg, id_usuario_ai, usuario_ai, id_moneda, moneda, codigo, tipo_moneda, prioridad, tipo_actualizacion, origen, contabilidad, triangulacion, codigo_internacional, show_combo, actualizacion)
		VALUES(1, NULL, '2016-01-13 02:08:11.893', NULL, 'activo', NULL, NULL, 1, 'Boliviano', 'BS', 'base', 1, '', 'nacional', 'si', 'no', 'BOB', 'si', 'no');
		
	end if;
	
	if not exists (select 1 from param.tmoneda where id_moneda = 2) then
		INSERT INTO param.tmoneda
		(id_usuario_reg, id_usuario_mod, fecha_reg, fecha_mod, estado_reg, id_usuario_ai, usuario_ai, id_moneda, moneda, codigo, tipo_moneda, prioridad, tipo_actualizacion, origen, contabilidad, triangulacion, codigo_internacional, show_combo, actualizacion)
		VALUES(1, 1, '2016-01-13 02:08:49.634', '2017-10-22 00:52:17.134', 'activo', NULL, NULL, 2, 'Dolar', '$us', 'intercambio', 2, 'sin_actualizacion', 'internacional', 'si', 'si', 'USD', 'si', 'no');

	end if;
	
	if not exists (select 1 from param.tmoneda where id_moneda = 3) then
		INSERT INTO param.tmoneda
		(id_usuario_reg, id_usuario_mod, fecha_reg, fecha_mod, estado_reg, id_usuario_ai, usuario_ai, id_moneda, moneda, codigo, tipo_moneda, prioridad, tipo_actualizacion, origen, contabilidad, triangulacion, codigo_internacional, show_combo, actualizacion)
		VALUES(1, 1, '2014-02-01 23:54:29.000', '2017-10-22 00:51:14.192', 'activo', NULL, NULL, 3, 'Unidad de Fomento a la Vivienda', 'UFV', 'ref', 3, 'por_transaccion', 'nacional', 'si', 'no', 'UFV', 'si', 'si');

	end if;
    
    if not exists (select 1 from conta.tconfig_cambiaria) then
    	INSERT INTO conta.tconfig_cambiaria ("id_usuario_reg", "origen", "ope_1", "ope_2", "obs", "habilitado", "fecha_habilitado", "ope_3")
		VALUES (1, E'nacional', E'{M}->{MB}', E'{M}->{MT}', NULL, E'si', E'2017-07-24', E'{MB}->{MA}');
    end if;
	select id_empresa into v_id_empresa
	from param.tempresa;
	
	if (v_id_empresa is null) then	
		INSERT INTO param.tempresa
		(id_usuario,nombre, logo, nit, codigo)
		VALUES(1,'Empresa Electrica Corani', './../../sis_parametros/control/_archivo//docLog1.jpg', '111', 'CORANI') 
		returning id_empresa into v_id_empresa;		
	end if;
    
    select id_lugar into v_id_lugar
	from param.tlugar
	where codigo = 'BO';
	
	
	
	if (v_id_lugar is null) then
		INSERT INTO param.tlugar
		(id_usuario_reg, id_usuario_mod, fecha_reg, fecha_mod, estado_reg, id_usuario_ai, usuario_ai,  id_lugar_fk, codigo, nombre, tipo, sw_municipio, sw_impuesto, codigo_largo, es_regional)
		VALUES(1, NULL, '2019-01-23 18:00:07.180', NULL, 'activo', NULL, NULL, NULL, 'BO', 'Bolivia', 'pais', 'no', 'no', 'BO', 'si')returning id_lugar into v_id_lugar;
	end if;
	
	v_lugares[1] = v_id_lugar;
    
    select id_entidad into v_id_entidad
	from param.tentidad;
	
	
	if (v_id_entidad is null) then	
		INSERT INTO param.tentidad
		(id_usuario_reg, nombre, nit, tipo_venta_producto, estados_comprobante_venta, estados_anulacion_venta, pagina_entidad, direccion_matriz, identificador_min_trabajo, identificador_caja_salud)
		VALUES(1, 'Corani', '1111', '', 'finalizado', '', 'www.corani.bo', 'Edificio Torres Sofer piso 4', '', '')returning id_entidad into v_id_entidad;	
	end if;
    
    select id_depto into v_id_depto
    from param.tdepto
    where id_subsistema = v_id_subsistema;
    
    if (v_id_depto is null) then
      INSERT INTO param.tdepto ("id_usuario_reg", "id_subsistema", "codigo", "nombre", "nombre_corto", "id_lugares", "prioridad", "modulo", "id_entidad")
      VALUES (1,v_id_subsistema, E'CT-CBBA', E'DEPARTAMENTO DE CONTABILIDAD CENTRAL', E'Contabilidad CENTRAL CBBA', v_lugares, 0, E'', v_id_entidad);
	end if;
    
    delete from conta.tclase_comprobante;
    raise notice '%',v_id_subsistema;
    delete from param.tdocumento where id_subsistema = v_id_subsistema;    
    
    /* Data for the 'param.tdocumento' table  (Records 1 - 4) */

    INSERT INTO param.tdocumento ("id_usuario_reg", "id_subsistema", "codigo", "descripcion", "periodo_gestion", "tipo", "tipo_numeracion", "formato", "ruta_plantilla")
    VALUES (1,v_id_subsistema, E'CDIR', E'Comprobante de Diario', E'periodo', NULL, E'depto', NULL, NULL) returning id_documento into v_id_documento;

    INSERT INTO conta.tclase_comprobante ("id_usuario_reg",  "id_documento", "descripcion", "tipo_comprobante", "codigo", "momento_comprometido", "momento_ejecutado", "momento_pagado", "tiene_apertura", "movimiento")
    VALUES (1,  v_id_documento, E'Comprobante de Diario Presupuestario', E'presupuestario', E'DIARIO', E'opcional', E'opcional', E'opcional', E'si', E'diario');

    INSERT INTO conta.tclase_comprobante ("id_usuario_reg",  "id_documento", "descripcion", "tipo_comprobante", "codigo", "momento_comprometido", "momento_ejecutado", "momento_pagado", "tiene_apertura", "movimiento")
    VALUES (1, v_id_documento, E'Comprobante de Diario Contable', E'contable', E'DIARIOCON', E'no_permitido', E'no_permitido', E'no_permitido', E'si', E'diario');



    INSERT INTO param.tdocumento ("id_usuario_reg","id_subsistema", "codigo", "descripcion", "periodo_gestion", "tipo", "tipo_numeracion", "formato", "ruta_plantilla")
    VALUES (1, v_id_subsistema, E'CPAG', E'Comprobante de Pago', E'periodo', NULL, E'depto', NULL, NULL)returning id_documento into v_id_documento;
    
    INSERT INTO conta.tclase_comprobante ("id_usuario_reg",  "id_documento", "descripcion", "tipo_comprobante", "codigo", "momento_comprometido", "momento_ejecutado", "momento_pagado", "tiene_apertura", "movimiento")
    VALUES (1, v_id_documento, E'Comprobante de Pago Presupuestario', E'presupuestario', E'PAGO', E'opcional', E'opcional', E'opcional', E'no', E'diario');
   
    INSERT INTO conta.tclase_comprobante ("id_usuario_reg",  "id_documento", "descripcion", "tipo_comprobante", "codigo", "momento_comprometido", "momento_ejecutado", "momento_pagado", "tiene_apertura", "movimiento")
    VALUES (1, v_id_documento, E'Comprobante de Pago Contable', E'contable', E'PAGOCON', E'no_permitido', E'no_permitido', E'no_permitido', E'no', E'diario');


    
    
    INSERT INTO param.tdocumento ("id_usuario_reg", "id_subsistema", "codigo", "descripcion", "periodo_gestion", "tipo", "tipo_numeracion", "formato", "ruta_plantilla")
    VALUES (1, v_id_subsistema, E'CBT', E'Numero de Tramite Cbte', E'gestion', E'', E'depto', NULL, NULL)returning id_documento into v_id_documento;

    INSERT INTO param.tdocumento ("id_usuario_reg", "id_subsistema", "codigo", "descripcion", "periodo_gestion", "tipo", "tipo_numeracion", "formato", "ruta_plantilla")
    VALUES (1, v_id_subsistema, E'CING', E'Comprobante de Ingreso', E'periodo', E'', E'depto', NULL, NULL)returning id_documento into v_id_documento;  

    
    INSERT INTO conta.tclase_comprobante ("id_usuario_reg",  "id_documento", "descripcion", "tipo_comprobante", "codigo", "momento_comprometido", "momento_ejecutado", "momento_pagado", "tiene_apertura", "movimiento")
    VALUES (1, v_id_documento, E'Comprobante de Ingreso Contable', E'contable', E'INGRESOCON', E'no_permitido', E'no_permitido', E'no_permitido', E'no', E'ingreso');

    INSERT INTO conta.tclase_comprobante ("id_usuario_reg",  "id_documento", "descripcion", "tipo_comprobante", "codigo", "momento_comprometido", "momento_ejecutado", "momento_pagado", "tiene_apertura", "movimiento")
    VALUES (1, v_id_documento, E'Comprobante de Ingreso Presupuestario', E'presupuestario', E'INGRESO', E'opcional', E'opcional', E'opcional', E'no', E'ingreso');
            
     
	if not exists (select 1 from param.tgestion where gestion = 2019) then
		INSERT INTO param.tgestion
		(id_usuario, gestion, estado, id_moneda_base, id_empresa, fecha_ini, fecha_fin, tipo)
		VALUES(1, 2019, 'activo', 1, v_id_empresa, NULL, NULL, 'MES');
        
        --(3) Generación de los Períodos y Períodos Subsistema
            v_cont =1;
            
			
                            
            while v_cont <= 12 loop
            
            	
                
	            --Obtención del primer día del mes correspondiente a la fecha_ini
	            v_fecha_ini= ('01-'||v_cont||'-2019')::date;
	            
	            --Obtención el último dia del mes correspondiente a la fecha_fin
	            v_fecha_fin=(date_trunc('MONTH', v_fecha_ini) + INTERVAL '1 MONTH - 1 day')::date;
	             
	            insert into param.tperiodo(
                  id_usuario_reg,
                  id_usuario_mod,
                  fecha_reg,
                  fecha_mod,
                  estado_reg,
                  periodo,
                  id_gestion,
                  fecha_ini,
                  fecha_fin
                ) VALUES (
                  1,
                  NULL,
                  now(),
                  NULL,
                  'activo',
                  v_cont,
                  v_id_gestion,
                  v_fecha_ini,
                  v_fecha_fin
                ) returning id_periodo into v_id_periodo;
                
                --Registro de los periodos de los subsistemas existentes
                for v_rec in (select id_subsistema
                			from segu.tsubsistema
                			where estado_reg = 'activo'
                			and codigo not in ('PXP','GEN','SEGU','WF','PARAM','ORGA','MIGRA')) loop
                	insert into param.tperiodo_subsistema(
                	id_periodo,
                	id_subsistema,
                	estado,
                	id_usuario_reg,
                	fecha_reg
                	) values(
                	v_id_periodo,
                	v_rec.id_subsistema,
                	'cerrado',
                	1,
                	now()
                	);
                	
                		
                end loop;     
            
               v_cont=v_cont+1;
            
            END LOOP;

	end if;
	
	
	
	
	select id_gestion into v_id_gestion
	from param.tgestion
	where gestion = 2019;
    
    select id_programa into v_id_programa
	from param.tprograma;
    
    if (v_id_programa is null) then
    	INSERT INTO 
            param.tprograma
          (
            id_usuario_reg, 
            codigo_programa,
            nombre_programa,
            descripcion_programa
          )
          VALUES (
            1,  
            'GEN',
            'Programa Generico',
            'Programa Generico'
          )returning id_programa into v_id_programa;
    end if;
    
    select id_proyecto into v_id_proyecto
	from param.tproyecto;
    
    if (v_id_proyecto is null) then
    	INSERT INTO 
            param.tproyecto
          (
            id_usuario_reg, 
            codigo_proyecto,
            nombre_proyecto
          )
          VALUES (
            1,  
            'GEN',
            'Proyecto Generico'
          )returning id_proyecto into v_id_proyecto;
    end if;
    
    
    select id_actividad into v_id_actividad
	from param.tactividad;
    
    if (v_id_actividad is null) then
    	INSERT INTO 
            param.tactividad
          (
            id_usuario_reg, 
            codigo_actividad,
            nombre_actividad
          )
          VALUES (
            1,  
            'GEN',
            'Actividad Generica'
          ) returning id_actividad into v_id_actividad;
    end if;
	
    select id_prog_pory_acti into v_id_prog_proy_acti
	from param.tprograma_proyecto_acttividad;
    
    if (v_id_prog_proy_acti is null) then
    	INSERT INTO 
          param.tprograma_proyecto_acttividad
        (
          id_usuario_reg,          
          id_programa,
          id_proyecto,
          id_actividad
        )
        VALUES (
          1,          
          v_id_programa,
          v_id_proyecto,
          v_id_actividad
        )returning id_prog_pory_acti into v_id_prog_proy_acti;
    end if;
    
    select id_financiador into v_id_financiador
	from param.tfinanciador;
    
    if (v_id_financiador is null) then
    	INSERT INTO 
            param.tfinanciador
          (
            id_usuario_reg, 
            codigo_financiador,
            nombre_financiador
          )
          VALUES (
            1,  
            'GEN',
            'Financiador Generico'
          )returning id_financiador into v_id_financiador;
    end if;
    
    select id_regional into v_id_regional
	from param.tregional;
    
    if (v_id_regional is null) then
    	INSERT INTO 
            param.tregional
          (
            id_usuario_reg, 
            codigo_regional,
            nombre_regional
          )
          VALUES (
            1,  
            'GEN',
            'Regional Generica'
          )returning id_regional into v_id_regional;
    end if;
	
    select id_ep into v_id_ep
	from param.tep;
    
    if (v_id_ep is null) then
    	INSERT INTO 
            param.tep
          (
            id_usuario_reg,             
            id_prog_pory_acti,
            id_regional,
            id_financiador
            
          )
          VALUES (
            1,  
            v_id_prog_proy_acti,
            v_id_regional,
            v_id_financiador
          )returning id_ep into v_id_ep;
    end if;
    
    select id_categoria_programatica into v_id_categoria
	from pre.tcategoria_programatica;
    
    if (v_id_categoria is null) then
    	INSERT INTO 
            pre.tcategoria_programatica
          (
            id_usuario_reg,             
            id_gestion,
            descripcion
            
          )
          VALUES (
            1,  
            v_id_gestion,
            'Categoria Generica'
          )returning id_categoria_programatica into v_id_categoria;
    end if;
    
    
    select id_uo into v_id_uo
	from orga.tuo;
    
    if (v_id_uo is null) then
    	INSERT INTO 
          orga.tuo
        (
          id_usuario_reg,          
          nombre_unidad,
          nombre_cargo,
          cargo_individual,
          descripcion,
          presupuesta,
          codigo,
          nodo_base,
          gerencia,
          correspondencia,          
          planilla,
          prioridad,
          codigo_alterno
        )
        VALUES (
          1,          
          'ENDE Corani',
          'ENDE Corani',
          'si',
          'ENDE Corani',
          'si',
          'ENCOR',
          'si',
          'no',
          'no',          
          'no',
          1,
          'ENCOR'
        )returning id_uo into v_id_uo;
    end if;
    
    
    if not EXISTS(select 1 from param.tdepto_uo_ep ) then
    	
      INSERT INTO param.tdepto_uo_ep ("id_usuario_reg", "id_depto", "id_ep", "id_uo")
      VALUES (1,  v_id_depto, v_id_ep, v_id_uo);

    end if;
	
	for v_registros in (select * from conta.tmigra_cuenta) loop
		v_cuenta_padre = trim(trailing '0' from v_registros.nro_cuenta);
		if (char_length(v_cuenta_padre) = 1 ) then
			v_id_cuenta_padre = NULL;
		elsif (char_length(v_cuenta_padre) = 2) then
		
			select c.id_cuenta into v_id_cuenta_padre
			from conta.tcuenta c
			where c.nro_cuenta = substring(v_cuenta_padre from 1 for 1)||'0000000000';
			
		elsif (char_length(v_cuenta_padre) = 3) then
		
			select c.id_cuenta into v_id_cuenta_padre
			from conta.tcuenta c
			where c.nro_cuenta = substring(v_cuenta_padre from 1 for 2)||'000000000';			
		
		elsif (char_length(v_cuenta_padre) >= 4 and char_length(v_cuenta_padre)<=5) then
		
			select c.id_cuenta into v_id_cuenta_padre
			from conta.tcuenta c
			where c.nro_cuenta = substring(v_cuenta_padre from 1 for 3)||'00000000';
			
		elsif (char_length(v_cuenta_padre) >= 6 and char_length(v_cuenta_padre)<=7) then
		
			select c.id_cuenta into v_id_cuenta_padre
			from conta.tcuenta c
			where c.nro_cuenta = substring(v_cuenta_padre from 1 for 5)||'000000';
		else
			select c.id_cuenta into v_id_cuenta_padre
			from conta.tcuenta c
			where c.nro_cuenta = substring(v_cuenta_padre from 1 for 7) || '0000';
		end if;
		
		
		insert into conta.tcuenta(
                id_cuenta_padre,
                nombre_cuenta,
                sw_auxiliar,
                nivel_cuenta,
                tipo_cuenta,
                desc_cuenta,
                tipo_cuenta_pat,
                nro_cuenta,
                id_moneda,
                sw_transaccional,
                id_gestion,
                estado_reg,
                fecha_reg,
                id_usuario_reg,
                fecha_mod,
                id_usuario_mod,                
                valor_incremento,
                id_config_subtipo_cuenta
          	) values(
                v_id_cuenta_padre,
                v_registros.nombre_cuenta,
                v_registros.sw_auxiliar,
                NULL,
                v_registros.tipo_cuenta,
                v_registros.nombre_cuenta,
                NULL,
                v_registros.nro_cuenta,
                v_registros.id_moneda,
                v_registros.sw_transaccional,
                v_id_gestion,
                'activo',
                now(),
                1,
                null,
                null,                
                v_registros.valor_incremento,
                v_registros.sub_tipo_cuenta
							
			)RETURNING id_cuenta into v_id_cuenta;
		
	end loop;
	
	
	for v_registros in (select * from conta.tmigra_auxiliar) loop
		
		
		select c.id_cuenta into v_id_cuenta_padre
		from conta.tcuenta c
		where c.nro_cuenta = substring(v_registros.codigo_auxiliar from 1 for 7) || '0000';
			
		
		--Sentencia de la insercion
        	insert into conta.tauxiliar(
			--id_empresa,
			estado_reg,
			codigo_auxiliar,
			nombre_auxiliar,
			fecha_reg,
			id_usuario_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			--v_parametros.id_empresa,
			'activo',
			v_registros.codigo_auxiliar,
			v_registros.nombre_auxiliar,
			now(),
			1,
			null,
			null
							
			)RETURNING id_auxiliar into v_id_auxiliar;
		
			--Sentencia de la insercion
        	insert into conta.tcuenta_auxiliar(
			estado_reg,
			id_auxiliar,
			id_cuenta,
			id_usuario_reg,
			fecha_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_id_auxiliar,
			v_id_cuenta_padre,
			1,
			now(),
			null,
			null

			);
		
	end loop;
	
	for v_registros in (select * from pre.tmigra_partida) loop
		
		
		v_partida_padre = trim(trailing '0' from v_registros.codigo);
		if (char_length(v_partida_padre) = 1 ) then
			v_id_partida_padre = NULL;
		elsif (char_length(v_partida_padre) = 2) then		
			select id_partida into v_id_partida_padre
			from pre.tpartida
			where codigo = substring(v_partida_padre from 1 for 1)||'000';
		elsif (char_length(v_partida_padre) = 3) then		
			select id_partida into v_id_partida_padre
			from pre.tpartida
			where codigo = substring(v_partida_padre from 1 for 2)||'00';
		elsif (char_length(v_partida_padre) = 4) then		
			select id_partida into v_id_partida_padre
			from pre.tpartida
			where codigo = substring(v_partida_padre from 1 for 3)||'0';
			
			if (v_id_partida_padre is null) then            	
				select id_partida into v_id_partida_padre
				from pre.tpartida
				where codigo = substring(v_partida_padre from 1 for 2)||'00';
			end if;
		end if;
		
		--Sentencia de la insercion
        	insert into pre.tpartida(
			estado_reg,
			id_partida_fk,
			tipo,
			descripcion,
			codigo,
			id_usuario_reg,
			fecha_reg,
			id_usuario_mod,
			fecha_mod,
            id_gestion,
            sw_transaccional,
            sw_movimiento,
            nombre_partida
            
          	) values(
			'activo',
			v_id_partida_padre,
			v_registros.tipo,
			v_registros.descripcion,
			v_registros.codigo,
			1,
			now(),
			null,
			null,
            v_id_gestion,
            v_registros.sw_transaccional,
            v_registros.sw_movimiento,
            v_registros.nombre_partida
			)RETURNING id_partida into v_id_partida;
		
	end loop;
    
    for v_registros in (select * from pre.tmigra_pres) loop
		SELECT id_tipo_presupuesto into v_id_tipo_presupuesto_padre
        from pre.ttipo_presupuesto
        where codigo = v_registros.padre;	
        if (v_registros.ingreso = 'si') then
        	v_mov_pres = array_append(v_mov_pres, 'ingreso'); 
        end if;
        
        if (v_registros.egreso = 'si') then
        	v_mov_pres = array_append(v_mov_pres, 'egreso'); 
        end if;
        
		INSERT INTO 
            param.ttipo_cc
          (
            id_usuario_reg,            
            codigo,
            descripcion,
            movimiento,
            tipo,
            mov_pres,
            control_partida,
            control_techo,
            momento_pres,
            id_ep,
            id_tipo_cc_fk,
            fecha_inicio,
            fecha_final,
            operativo
          )
          VALUES (
            1,            
            v_registros.codigo,
            v_registros.nombre,
            v_registros.movimiento,
            v_registros.tipo,
            v_mov_pres,
            v_registros.control_partida,
            v_registros.control_techo,
            ARRAY['formulado','comprometido','ejecutado','pagado'],
            v_id_ep,
            v_id_tipo_presupuesto_padre,
            '01/01/2019',
            NULL,
            v_registros.operativo
          )returning id_tipo_cc into v_id_tipo_cc;
		
		  INSERT INTO 
            param.tcentro_costo
          (
            id_usuario_reg,            
            id_ep,
            id_uo,
            id_gestion,
            id_tipo_cc
          )
          VALUES (
            1,            
            v_id_ep,
            v_id_uo,
            v_id_gestion,
            v_id_tipo_cc
          )returning id_centro_costo into v_id_centro_costo;
          
          INSERT INTO 
            pre.tpresupuesto
          (
            id_usuario_reg,            
            id_centro_costo,
            tipo_pres,            
            id_categoria_prog,           
            estado,            
            descripcion,            
            sw_consolidado
          )
          VALUES (
            1,           
            v_id_centro_costo,
            2,            
            v_id_categoria,            
            'borrador',           
            v_registros.nombre,           
            'no'
          )returning id_presupuesto into v_id_presupuesto;
          
          
		
		
	end loop;
	
	
	
    return 1;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;