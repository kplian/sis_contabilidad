<?php
/**
*@package pXP
*@file gen-Pais.php
*@author  (favio figueroa)
*@date 16-11-2015 16:56:32
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Acumulado=Ext.extend(Phx.gridInterfaz,{



	
	constructor:function(config){
		
	
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
    	console.log(config)
		Phx.vista.Acumulado.superclass.constructor.call(this,config);
		
		console.log('this',this);
		this.id_bancarizacion = config.id_banca_compra_venta;
		console.log(this.id_bancarizacion);
		this.init();
		console.log('tipo monto',config);
		
		if (config.tipo_monto == 'abierto'){
			this.load({params:{num_documento:config.num_documento,autorizacion:config.autorizacion,start:0, limit:this.tam_pag,id_contrato:config.id_contrato,id_banca_compra_venta:config.id_banca_compra_venta,acumulado:'si'}})

		}else{
			this.load({params:{start:0, limit:this.tam_pag,id_contrato:config.id_contrato,id_banca_compra_venta:config.id_banca_compra_venta,acumulado:'si'}})

		}
		
		
			
			
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_banca_compra_venta',
					
			},
			type:'Field',
			form:true 
		},
		
		
		{
			config:{
				name: 'gestion',
				fieldLabel: 'gestion',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:255,
				
				
	
			},
			
			
				type:'TextField',
				
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'periodo',
				fieldLabel: 'periodo',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:255,
				renderer: function (value, meta, record) {
					console.log('meta',meta)

					var resp;
					console.log('seleccioanda',record.json.banca_seleccionada)
					console.log('valor',record.json.id_banca_compra_venta)
					meta.style=(record.json.banca_seleccionada == record.json.id_banca_compra_venta)?'background:green; color:#fff;':'';
					//meta.css = record.get('online') ? 'user-online' : 'user-offline';
					resp = value;

					return resp;
				}
			},
				type:'TextField',
				
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'tramite_cuota',
				fieldLabel: 'tramite_cuota',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			},
				type:'TextField',
				
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'fecha_documento',
				fieldLabel: 'Fecha Factura / Fecha Documento ',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''},
							
						    
			},
				type:'DateField',
				filters:{pfiltro:'banca.fecha_documento',type:'date'},
				id_grupo:0,
				grid:true,
				form:true
		},
		
		
		{
			config:{
				name: 'monto_pagado',
				fieldLabel: 'monto_pagado',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			},
				type:'TextField',
				
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'monto_acumulado',
				fieldLabel: 'Monto Acumulado',
				allowBlank: true,
				anchor: '90%',
				gwidth: 100,
				maxLength:655362
			},
				type:'NumberField',
				filters:{pfiltro:'banca.monto_acumulado',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'saldo',
				fieldLabel: 'saldo',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:255,
				renderer: function (value, meta, record) {
					console.log('meta',meta)

					var resp;
					console.log('saldo',record.json.saldo)
					meta.style=(record.json.saldo < 0)?'background:red; color:#fff;':'';
					//meta.css = record.get('online') ? 'user-online' : 'user-offline';
					resp = value;

					return resp;
				}
			},
				type:'TextField',
				
				id_grupo:1,
				grid:true,
				form:true
		},
		
		
		
		
		{
			config: {
				name: 'modalidad_transaccion',
				fieldLabel: 'Modalidad Transacción ',
				allowBlank: false,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_contabilidad/control/ConfigBanca/listarConfigBanca',
					id: 'id_config_banca',
					root: 'datos',
					sortInfo: {
						field: 'digito',
						direction: 'ASC',
						tipo:'favio'

					},
					totalProperty: 'total',
					fields: ['id_config_banca', 'digito', 'descripcion','tipo'],
					remoteSort: true,
					baseParams: {par_filtro: 'confba.descripcion#confba.tipo',tipo:'Modalidad de transacción'}
				}),
				valueField: 'digito',
				displayField: 'descripcion',
				gdisplayField: 'desc_modalidad_transaccion',
				tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{digito}</b>. {descripcion} </p> </div></tpl>',

				hiddenName: 'id_config_banca',
				forceSelection: true,
				typeAhead: true,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '60%',
				gwidth: 150,
				minChars: 2,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['desc_modalidad_transaccion']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'confba.descripcion',type: 'string'},
			grid: true,
			form: true
		},
		
		
		
		{
			config: {
				name: 'id_proveedor',
				fieldLabel: 'Proveedor',
				allowBlank: false,
				forceSelection: false,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_parametros/control/Proveedor/listarProveedorCombos',
					id: 'id_proveedor',
					root: 'datos',
					sortInfo: {
						field: 'id_proveedor',
						direction: 'ASC'

					},
					totalProperty: 'total',
					fields: ['id_proveedor','id_persona','id_institucion','desc_proveedor', 'rotulo_comercial', 'nit'],
					remoteSort: true,
					baseParams: {par_filtro: 'provee.desc_proveedor#provee.nit'}
				}),
				valueField: 'id_proveedor',
				displayField: 'desc_proveedor',
				gdisplayField: 'desc_proveedor2',
				tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{desc_proveedor}</b></p><p>NIT: {nit} </p> </div></tpl>',


				hiddenName: 'id_proveedor',
				forceSelection: true,
				typeAhead: true,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '60%',
				gwidth: 150,
				minChars: 2,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['desc_proveedor2']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'provee.desc_proveedor',type: 'string'},
			grid: true,
			form: true
		},
		
		
		{
			config: {
				name: 'tipo_transaccion',
				fieldLabel: 'Tipo de Transacción',
				allowBlank: false,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_contabilidad/control/ConfigBanca/listarConfigBanca',
					id: 'id_config_banca',
					root: 'datos',
					sortInfo: {
						field: 'digito',
						direction: 'ASC',
						tipo:'favio'

					},
					totalProperty: 'total',
					fields: ['id_config_banca', 'digito', 'descripcion','tipo'],
					remoteSort: true,
					baseParams: {par_filtro: 'confba.descripcion#confba.tipo',tipo:'Tipo de transacción'}
				}),
				valueField: 'digito',
				displayField: 'descripcion',
				gdisplayField: 'desc_tipo_transaccion',
				tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{digito} </b>. {descripcion} </p> </div></tpl>',

				hiddenName: 'id_config_banca',
				forceSelection: true,
				typeAhead: true,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '60%',
				gwidth: 150,
				minChars: 2,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['desc_tipo_transaccion']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'confba.descripcion',type: 'string'},
			grid: true,
			form: true
		},
		
		
	
	
	{
			config: {
				name: 'id_documento',
				fieldLabel: 'documento',
				allowBlank: true,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_contabilidad/control/BancaCompraVenta/listarDocumento',
					id: 'id_documento',
					root: 'datos',
					sortInfo: {
						field: 'id_documento',
						direction: 'DESC'

					},
					totalProperty: 'total',
					fields: ['id_documento', 'razon_social', 'nro_documento','nro_autorizacion','fecha_documento','nro_nit','sw_libro_compras','importe_total'],
					remoteSort: true,
					baseParams: {par_filtro: 'doc.razon_social#doc.nro_documento#doc.nro_autorizacion#doc.nro_nit'}
				}),
				valueField: 'id_documento',
				displayField: 'razon_social',
				gdisplayField: 'desc_documento',
				tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{sw_libro_compras}</b></p><p><b>{razon_social}</b></p><p>Nro fac: {nro_documento} </p> <p>Aut: {nro_autorizacion} </p><p>Importe: {importe_total}</p><p> Nit: {nro_nit} </p><p>fecha : {fecha_documento}</p></div></tpl>',


				hiddenName: 'id_documento',
				forceSelection: true,
				typeAhead: true,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '90%',
				gwidth: 150,
				minChars: 2,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['desc_documento']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'd.razon_social',type: 'string'},
			grid: false,
			form: true
		},
		
		
		{
			config:{
				name: 'fecha_documento',
				fieldLabel: 'Fecha Factura / Fecha Documento ',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''},
							
						    
			},
				type:'DateField',
				filters:{pfiltro:'banca.fecha_documento',type:'date'},
				id_grupo:0,
				grid:true,
				form:true
		},
		
		
		
		
		
		
		
		{
			config:{
				name: 'autorizacion',
				fieldLabel: 'Nro Autorización /Factura Documento ',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100
			},
				type:'NumberField',
				filters:{pfiltro:'banca.autorizacion',type:'numeric'},
				id_grupo:0,
				grid:true,
				form:true
		},
		
		
		
		
		{
			config:{
				name: 'nit_ci',
				fieldLabel: 'NIT / CI Proveedor',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			},
				type:'TextField',
				filters:{pfiltro:'banca.nit_ci',type:'string'},
				id_grupo:0,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'razon',
				fieldLabel: 'Nombre / Razón Social Proveedor',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			},
				type:'TextField',
				filters:{pfiltro:'banca.razon',type:'string'},
				id_grupo:0,
				grid:true,
				form:true,
				bottom_filter : true
		},
		
		{
			config:{
				name: 'num_documento',
				fieldLabel: 'Nro de Factura / Nro Documento ',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			},
				type:'TextField',
				filters:{pfiltro:'banca.num_documento',type:'string'},
				id_grupo:0,
				grid:true,
				form:true
		},
		
		{
			config: {
				name: 'id_contrato',
				hiddenName: 'id_contrato',
				fieldLabel: 'Obj Contrato',
				typeAhead: false,
				forceSelection: false,
				allowBlank: true,
				disabled: true,
				emptyText: 'Contratos...',
				store: new Ext.data.JsonStore({
					url: '../../sis_workflow/control/Tabla/listarTablaCombo',
					id: 'id_contrato',
					root: 'datos',
					sortInfo: {
						field: 'id_contrato',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_contrato', 'numero', 'tipo', 'objeto', 'estado', 'desc_proveedor','monto','moneda','fecha_inicio','fecha_fin','tipo_plazo'],
					// turn on remote sorting
					remoteSort: true,
					baseParams: {par_filtro:'con.numero#con.tipo#con.monto#prov.desc_proveedor#con.objeto#con.monto', tipo_proceso:"CON",tipo_estado:"revision",id_tabla:3}
				}),
				valueField: 'id_contrato',
				displayField: 'objeto',
				gdisplayField: 'desc_contrato',
				triggerAction: 'all',
				lazyRender: true,
				resizable:true,
				mode: 'remote',
				pageSize: 20,
				queryDelay: 200,
				listWidth:380,
				minChars: 2,
				gwidth: 100,
				anchor: '80%',
				renderer: function(value, p, record) {
					
					if(record.data['desc_contrato']){
						return String.format('{0}', record.data['desc_contrato']);
					}
					return '';
					
				},
				tpl: '<tpl for="."><div class="x-combo-list-item"><p>Nro: {numero} ({tipo})</p><p>Obj: <strong><b>{objeto}</b></strong></p><p>Prov : {desc_proveedor}</p> <p>Monto: {monto} {moneda}</p><p>Rango: {fecha_inicio} al {fecha_fin}</p></div></tpl>'
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {
				pfiltro: 'con.numero',
				type: 'numeric'
			},
			grid: true,
			form: true
		},
		
		
		{
			config:{
				name: 'num_contrato',
				fieldLabel: 'N de contrato ',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			},
				type:'TextField',
				filters:{pfiltro:'banca.num_contrato',type:'string'},
				id_grupo:0,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'monto_contrato',
				fieldLabel: 'monto_contrato',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			},
				type:'TextField',
				
				id_grupo:0,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'acumulado',
				fieldLabel: 'acumulado',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			},
				type:'TextField',
				
				id_grupo:0,
				grid:false,
				form:true
		},
		
		
		{
			config:{
				name: 'importe_documento',
				fieldLabel: 'Importe Factura / Importe Documento',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:655362
			},
				type:'NumberField',
				filters:{pfiltro:'banca.importe_documento',type:'numeric'},
				id_grupo:0,
				grid:true,
				form:true
		},
		
		
		{
			config: {
				name: 'id_cuenta_bancaria',
				fieldLabel: 'Cuenta Bancaria TESORERIA',
				allowBlank: true,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_tesoreria/control/CuentaBancaria/listarCuentaBancaria',
					id: 'id_cuenta_bancaria',
					root: 'datos',
					sortInfo: {
						field: 'id_cuenta_bancaria',
						direction: 'ASC'

					},
					totalProperty: 'total',
					fields: ['id_cuenta_bancaria', 'denominacion', 'nro_cuenta','nombre_institucion','doc_id'],
					remoteSort: true,
					baseParams: {par_filtro: 'ctaban.denominacion#ctaban.nro_cuenta'}
				}),
				valueField: 'id_cuenta_bancaria',
				displayField: 'denominacion',
				gdisplayField: 'desc_cuenta_bancaria',
				tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{denominacion}</b></p><p>Nro Cuenta: {nro_cuenta} </p> <p>Institucion: {nombre_institucion} </p><p>nit Institucion: {doc_id} </p></div></tpl>',


				hiddenName: 'id_cuenta_bancaria',
				forceSelection: true,
				typeAhead: true,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '90%',
				gwidth: 150,
				minChars: 2,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['desc_cuenta_bancaria']);
				}
			},
			type: 'ComboBox',
			id_grupo: 1,
			filters: {pfiltro: 'ctaban.denominacion',type: 'string'},
			grid: true,
			form: true
		},
		
		
		{
			config:{
				name: 'num_cuenta_pago',
				fieldLabel: 'Nro de Cuenta del Documento de Pago',
				allowBlank: true,
				anchor: '90%',
				gwidth: 100,
				maxLength:255
			},
				type:'TextField',
				filters:{pfiltro:'banca.num_cuenta_pago',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'monto_pagado',
				fieldLabel: 'Monto Pagado en Documento de Pago',
				allowBlank: true,
				anchor: '90%',
				gwidth: 100,
				maxLength:655362
			},
				type:'NumberField',
				filters:{pfiltro:'banca.monto_pagado',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'monto_acumulado',
				fieldLabel: 'Monto Acumulado',
				allowBlank: true,
				anchor: '90%',
				gwidth: 100,
				maxLength:655362
			},
				type:'NumberField',
				filters:{pfiltro:'banca.monto_acumulado',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'saldo',
				fieldLabel: 'saldo',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			},
				type:'TextField',
				
				id_grupo:1,
				grid:true,
				form:true
		},
		
		
		
		{
			config:{
				name: 'nit_entidad',
				fieldLabel: 'NIT Entidad Financiera ',
				allowBlank: true,
				anchor: '90%',
				gwidth: 100
			},
				type:'NumberField',
				filters:{pfiltro:'banca.nit_entidad',type:'numeric'},
				id_grupo:2,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'num_documento_pago',
				fieldLabel: 'Nro Documento de Pago (Nro Transacción u Operación) ',
				allowBlank: true,
				anchor: '90%',
				gwidth: 100,
				maxLength:255
			},
				type:'TextField',
				filters:{pfiltro:'banca.num_documento_pago',type:'string'},
				id_grupo:2,
				grid:true,
				form:true
		},
		
		
		
		


		
		
		
		
		
		{
			config: {
				name: 'tipo_documento_pago',
				fieldLabel: 'Tipo de Documento de Pago',
				allowBlank: false,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_contabilidad/control/ConfigBanca/listarConfigBanca',
					id: 'id_config_banca',
					root: 'datos',
					sortInfo: {
						field: 'digito',
						direction: 'ASC',
						tipo:'favio'

					},
					totalProperty: 'total',
					fields: ['id_config_banca', 'digito', 'descripcion','tipo'],
					remoteSort: true,
					baseParams: {par_filtro: 'confba.descripcion#confba.tipo#confba.digito',tipo:'Tipo de documento de pago'}
				}),
				valueField: 'digito',
				displayField: 'descripcion',
				gdisplayField: 'desc_tipo_documento_pago',
				tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{digito} </b>. {descripcion} </p> </div></tpl>',

				hiddenName: 'id_config_banca',
				forceSelection: true,
				typeAhead: true,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '90%',
				gwidth: 150,
				minChars: 1,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['desc_tipo_documento_pago']);
				}
			},
			type: 'ComboBox',
			id_grupo: 2,
			filters: {pfiltro: 'confba.descripcion',type: 'string'},
			grid: true,
			form: true
		},
		
		
		
		{
			config:{
				name: 'estado_reg',
				fieldLabel: 'Estado Reg.',
				allowBlank: true,
				anchor: '90%',
				gwidth: 100,
				maxLength:10
			},
				type:'TextField',
				filters:{pfiltro:'banca.estado_reg',type:'string'},
				id_grupo:2,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'fecha_de_pago',
				fieldLabel: 'Fecha del Documento de Pago  ',
				allowBlank: true,
				anchor: '90%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'banca.fecha_de_pago',type:'date'},
				id_grupo:2,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'fecha_reg',
				fieldLabel: 'Fecha Creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'banca.fecha_reg',type:'date'},
				id_grupo:2,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
				type:'TextField',
				filters:{pfiltro:'banca.usuario_ai',type:'string'},
				id_grupo:2,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'usr_reg',
				fieldLabel: 'Creado Por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'usu1.cuenta',type:'string'},
				id_grupo:2,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'banca.id_usuario_ai',type:'numeric'},
				id_grupo:2,
				grid:false,
				form:false
		},
		{
			config:{
				name: 'usr_mod',
				fieldLabel: 'Modificado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'usu2.cuenta',type:'string'},
				id_grupo:2,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'banca.fecha_mod',type:'date'},
				id_grupo:2,
				grid:true,
				form:false
		},
		
		{
                config: {
                    name: 'periodo_servicio',
                    fieldLabel: 'Periodo de servicio ',
                    allowBlank: true,
                    emptyText: 'Tipo...',
                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender: true,
                    mode: 'local',
                    store: ['ENERO', 'FEBRERO', 'MARZO','ABRIL','MAYO','JUNIO','AGOSTO','SEPTIEMBRE','OCTUBRE','NOVIEMBRE','DICIEMBRE'],
                    width: 200
                },
                type: 'ComboBox',
                id_grupo: 2,
                form: true
        },
                
		{
			config:{
				name: 'numero_cuota',
				fieldLabel: 'Numero de Cuota',
				allowBlank: true,
				anchor: '90%',
				gwidth: 100,
				maxLength:655362
			},
				type:'NumberField',
				filters:{pfiltro:'banca.numero_cuota',type:'numeric'},
				id_grupo:2,
				form:true
		},
		
	],
	tam_pag:1000,
	title:'Acumulado',
	ActList:'../../sis_contabilidad/control/BancaCompraVenta/listarBancaCompraVenta',
	id_store:'id_banca_compra_venta',
	fields: [
	
		
		
		
		
		{name:'id_banca_compra_venta', type: 'numeric'},
		{name:'num_cuenta_pago', type: 'string'},
		{name:'tipo_documento_pago', type: 'numeric'},
		{name:'num_documento', type: 'string'},
		{name:'monto_acumulado', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'nit_ci', type: 'string'},
		{name:'importe_documento', type: 'numeric'},
		{name:'fecha_documento', type: 'date',dateFormat:'Y-m-d'},
		{name:'modalidad_transaccion', type: 'numeric'},
		{name:'tipo_transaccion', type: 'numeric'},
		{name:'autorizacion', type: 'numeric'},
		{name:'monto_pagado', type: 'numeric'},
		{name:'fecha_de_pago', type: 'date',dateFormat:'Y-m-d'},
		{name:'razon', type: 'string'},
		{name:'tipo', type: 'string'},
		{name:'num_documento_pago', type: 'string'},
		{name:'num_contrato', type: 'string'},
		{name:'nit_entidad', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
		{name:'desc_modalidad_transaccion', type: 'string'},
		{name:'desc_tipo_transaccion', type: 'string'},
		{name:'desc_tipo_documento_pago', type: 'string'},
		{name:'revisado', type: 'string'},
	
		{name:'id_contrato', type: 'numeric'},
		{name:'id_proveedor', type: 'numeric'},
		{name:'id_cuenta_bancaria', type: 'numeric'},
		
		{name:'desc_proveedor2', type: 'string'},
		{name:'desc_contrato', type: 'string'},
		{name:'desc_cuenta_bancaria', type: 'string'},
		
		
		{name:'id_documento', type: 'numeric'},
		{name:'desc_documento', type: 'string'},
		{name:'periodo', type: 'string'},
		{name:'saldo', type: 'numeric'},
		'monto_contrato'
		,'gestion','banca_seleccionada',
		 'numero_cuota',
            			'tramite_cuota'	
		
		
	],
	sortInfo:{
		field: 'id_banca_compra_venta',
		direction: 'DESC'
	},
	bdel:true,
	bsave:true,
	bnew:false,
	bedit:false,
	bdel:false,
	holaMundo:function(){
		console.log('das')
	}


	}
)
</script>
		
		