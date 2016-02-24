<?php
/**
 *@package pXP
 *@file    GenerarLibroBancos.php
 *@author  Gonzalo Sarmiento Sejas
 *@date    01-12-2014
 *@description Archivo con la interfaz para generaci�n de reporte
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
	Phx.vista.ReporteLibroComprasVentasIVA = Ext.extend(Phx.frmInterfaz, {
		
		Atributos : [
		{
            config:{
                name:'id_empresa',
                fieldLabel:'Empresa',
                allowBlank:true,
                emptyText:'Empresa...',
                store: new Ext.data.JsonStore({
                         url: '../../sis_parametros/control/Empresa/listarEmpresa',
                         id: 'id_empresa',
                         root: 'datos',
                         sortInfo:{
                            field: 'nit',
                            direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_empresa','nombre','nit'],
                    // turn on remote sorting
                    remoteSort: true,
                    baseParams:{par_filtro:'nombre#nit'}
                    }),
                valueField: 'id_empresa',
                displayField: 'nombre',
                tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{nombre}</b></p><p>{nit}</p></div></tpl>',
                hiddenName: 'id_empresa',
                forceSelection:true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender:true,
                mode:'remote',
                pageSize:10,
                queryDelay:1000,
                listWidth:600,
                resizable:true,
                anchor:'100%'
                
            },
            type:'ComboBox',
            id_grupo:0,
            filters:{   
                        pfiltro:'nombre#nit',
                        type:'string'
                    },
            grid:true,
            form:true
        },
		{
			config:{
				name: 'nombre_empresa',
				fieldLabel: 'Nombre Empresa',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100, 
				renderer:function (value,p,record){return value}
			},
			type:'Field',
			filters:{pfiltro:'nombre_empresa',type:'string'},
			id_grupo:1,
			form:true
		},
		{
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'nit'
			},
			type:'Field',
			form:true 
		},
		
		{
			config:{
				name:'tipo',
				fieldLabel:'Tipo de Reporte',
				typeAhead: true,
				allowBlank:false,
	    		triggerAction: 'all',
	    		emptyText:'Tipo...',
	    		selectOnFocus:true,
				mode:'local',
				store:new Ext.data.ArrayStore({
	        	fields: ['ID', 'valor'],
	        	data :	[['LCEstandar','Libro de Compras Estandar'],	
						['LCNCD','Libro de Compras NCD']]	        				
	    		}),
				valueField:'ID',
				displayField:'valor',
				width:250,			
				
			},
			type:'ComboBox',
			id_grupo:1,
			form:true
		},
		{
			config:{
				name:'filtro',
				fieldLabel:'Filtrar Por',
				typeAhead: true,
				allowBlank:false,
	    		triggerAction: 'all',
	    		emptyText:'Filtro...',
	    		selectOnFocus:true,
				mode:'local',
				store:new Ext.data.ArrayStore({
	        	fields: ['ID', 'valor'],
	        	data :	[['periodo','Año y Mes'],	
						['fechas','Rango de Fechas']]	        				
	    		}),
				valueField:'ID',
				displayField:'valor',
				width:250,			
				
			},
			type:'ComboBox',
			id_grupo:1,
			form:true
		},
		
		{
            config:{
                name:'id_gestion',
                fieldLabel:'Gestión',
                allowBlank:true,
                emptyText:'Gestión...',
                store: new Ext.data.JsonStore({
                         url: '../../sis_parametros/control/Gestion/listarGestion',
                         id: 'id_gestion',
                         root: 'datos',
                         sortInfo:{
                            field: 'gestion',
                            direction: 'DESC'
                    },
                    totalProperty: 'total',
                    fields: ['id_gestion','gestion','moneda','codigo_moneda'],
                    // turn on remote sorting
                    remoteSort: true,
                    baseParams:{par_filtro:'gestion'}
                    }),
                valueField: 'id_gestion',
                displayField: 'gestion',
                //tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{nro_cuenta}</b></p><p>{denominacion}</p></div></tpl>',
                hiddenName: 'id_gestion',
                forceSelection:true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender:true,
                mode:'remote',
                pageSize:10,
                queryDelay:1000,
                listWidth:600,
                resizable:true,
                anchor:'100%'
                
            },
            type:'ComboBox',
            id_grupo:0,
            filters:{   
                        pfiltro:'gestion',
                        type:'string'
                    },
            grid:true,
            form:true
        },
		{
            config:{
                name:'id_periodo',
                fieldLabel:'Periodo',
                allowBlank:true,
                emptyText:'Periodo...',
                store: new Ext.data.JsonStore({
                         url: '../../sis_parametros/control/Periodo/listarPeriodo',
                         id: 'id_periodo',
                         root: 'datos',
                         sortInfo:{
                            field: 'id_periodo',
                            direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_periodo','literal','periodo','fecha_ini','fecha_fin'],
                    // turn on remote sorting
                    remoteSort: true,
                    baseParams:{par_filtro:'periodo#literal'}
                    }),
                valueField: 'id_periodo',
                displayField: 'literal',
                //tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{nro_cuenta}</b></p><p>{denominacion}</p></div></tpl>',
                hiddenName: 'id_periodo',
                forceSelection:true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender:true,
                mode:'remote',
                pageSize:12,
                queryDelay:1000,
                listWidth:600,
                resizable:true,
                anchor:'100%'
                
            },
            type:'ComboBox',
            id_grupo:0,
            filters:{   
                        pfiltro:'literal',
                        type:'string'
                    },
            grid:true,
            form:true
        },
		{
			config:{
				name: 'finalidad',
				fieldLabel: 'Finalidad',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100, 
				renderer:function (value,p,record){return value}
			},
			type:'Field',
			filters:{pfiltro:'finalidad',type:'string'},
			id_grupo:1,
			form:true
		},
		{
			config:{
				name: 'fecha_ini',
				fieldLabel: 'Fecha Inicio',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type:'DateField',
			filters:{pfiltro:'fecha_ini',type:'date'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'fecha_fin',
				fieldLabel: 'Fecha Fin',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type:'DateField',
			filters:{pfiltro:'fecha_fin',type:'date'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name:'formato_reporte',
				fieldLabel:'Formato del Reporte',
				typeAhead: true,
				allowBlank:false,
	    		triggerAction: 'all',
	    		emptyText:'Formato...',
	    		selectOnFocus:true,
				mode:'local',
				store:new Ext.data.ArrayStore({
	        	fields: ['ID', 'valor'],
	        	data :	[['txt','TXT'],
						['pdf','PDF'],	
						['excel','Excel']]	        				
	    		}),
				valueField:'ID',
				displayField:'valor',
				width:250,			
				
			},
			type:'ComboBox',
			id_grupo:1,
			form:true
		}],
		
		
		title : 'Reporte Libro Compras Ventas IVA',		
		ActSave : '../../sis_contabilidad/control/TsLibroBancos/reporteLibroBancos',
		
		topBar : true,
		botones : false,
		labelSubmit : 'Generar',
		tooltipSubmit : '<b>Reporte LCV - IVA</b>',
		
		constructor : function(config) {
			Phx.vista.ReporteLibroComprasVentasIVA.superclass.constructor.call(this, config);
			this.init();			
			this.iniciarEventos();
		},
		
		iniciarEventos:function(){        
			this.cmpFormatoReporte = this.getComponente('formato_reporte');
			this.cmpFechaIni = this.getComponente('fecha_ini');
			this.cmpFechaFin = this.getComponente('fecha_fin');
			this.cmpIdGestion = this.getComponente('id_gestion');
			this.cmpEstado = this.getComponente('estado');
			this.cmpTipo = this.getComponente('tipo');
			this.cmpNombreBanco = this.getComponente('nombre_banco');
			this.cmpNroCuenta = this.getComponente('nro_cuenta');
			
			this.getComponente('finalidad').hide(true);
			this.cmpNroCuenta.hide(true);
			this.getComponente('id_finalidad').on('change',function(c,r,n){
				this.getComponente('finalidad').setValue(c.lastSelectionText);
			},this);
			
			this.cmpIdGestion.on('select',function(c,r,n){
				this.cmpNombreBanco.setValue(r.data.nombre_institucion);
				this.cmpNroCuenta.setValue(c.lastSelectionText);
				this.getComponente('id_periodo').reset();
				this.getComponente('id_periodo').store.baseParams={id_gestion:c.value, vista: 'reporte'};				
				this.getComponente('id_periodo').modificado=true;
			},this);
		},
		
		onSubmit:function(o){
			if(this.cmpFormatoReporte.getValue()==2){
				var data = 'FechaIni=' + this.cmpFechaIni.getValue().format('d-m-Y');
				data = data + '&FechaFin=' + this.cmpFechaFin.getValue().format('d-m-Y');
				data = data + '&IdCuentaBancaria=' + this.cmpIdCuentaBancaria.getValue();
				data = data + '&Estado=' + this.cmpEstado.getValue();
				data = data + '&Tipo=' + this.cmpTipo.getValue();
				data = data + '&NombreBanco=' + this.cmpNombreBanco.getValue();
				data = data + '&NumeroCuenta=' + this.cmpNroCuenta.getValue();
				
				console.log(data);
				window.open('http://sms.obairlines.bo/LibroBancos/Home/VerLibroBancos?'+data);
				//window.open('http://localhost:2309/Home/VerLibroBancos?'+data);				
			}else{
				Phx.vista.ReporteLibroComprasVentasIVA.superclass.onSubmit.call(this,o);				
			}
		},
		
		tipo : 'reporte',
		clsSubmit : 'bprint',
		
		Grupos : [{
			layout : 'column',
			items : [{
				xtype : 'fieldset',
				layout : 'form',
				border : true,
				title : 'Datos para el reporte',
				bodyStyle : 'padding:0 10px 0;',
				columnWidth : '500px',
				items : [],
				id_grupo : 0,
				collapsible : true
			}]
		}]
})
</script>