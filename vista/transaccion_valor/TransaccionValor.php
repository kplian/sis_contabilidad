<?php
/**
*@package pXP
*@file gen-TransaccionValor.php
*@author  (admin)
*@date 22-07-2013 03:57:28
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.TransaccionValor=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.TransaccionValor.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_transaccion_valor'
			},
			type:'Field',
			form:true 
		},
		{
			config: {
				name: 'id_transaccion',
				fieldLabel: 'id_transaccion',
				allowBlank: false,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_/control/Clase/Metodo',
					id: 'id_',
					root: 'datos',
					sortInfo: {
						field: 'nombre',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_', 'nombre', 'codigo'],
					remoteSort: true,
					baseParams: {par_filtro: 'movtip.nombre#movtip.codigo'}
				}),
				valueField: 'id_',
				displayField: 'nombre',
				gdisplayField: 'desc_',
				hiddenName: 'id_transaccion',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '100%',
				gwidth: 150,
				minChars: 2,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['desc_']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'movtip.nombre',type: 'string'},
			grid: true,
			form: true
		}
		{
			config: {
				name: 'id_moneda',
				fieldLabel: 'id_moneda',
				allowBlank: true,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_/control/Clase/Metodo',
					id: 'id_',
					root: 'datos',
					sortInfo: {
						field: 'nombre',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_', 'nombre', 'codigo'],
					remoteSort: true,
					baseParams: {par_filtro: 'movtip.nombre#movtip.codigo'}
				}),
				valueField: 'id_',
				displayField: 'nombre',
				gdisplayField: 'desc_',
				hiddenName: 'id_moneda',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '100%',
				gwidth: 150,
				minChars: 2,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['desc_']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'movtip.nombre',type: 'string'},
			grid: true,
			form: true
		}
			{
				config:{
					name: 'importe_debe',
					fieldLabel: 'importe_debe',
					allowBlank: true,
					anchor: '80%',
					gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'contva.importe_debe',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
			{
				config:{
					name: 'estado_reg',
					fieldLabel: 'Estado Reg.',
					allowBlank: true,
					anchor: '80%',
					gwidth: 100,
				maxLength:10
			},
				type:'TextField',
				filters:{pfiltro:'contva.estado_reg',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
			{
				config:{
					name: 'importe_gasto',
					fieldLabel: 'importe_gasto',
					allowBlank: true,
					anchor: '80%',
					gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'contva.importe_gasto',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
			{
				config:{
					name: 'importe_haber',
					fieldLabel: 'importe_haber',
					allowBlank: true,
					anchor: '80%',
					gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'contva.importe_haber',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
			{
				config:{
					name: 'importe_recurso',
					fieldLabel: 'importe_recurso',
					allowBlank: true,
					anchor: '80%',
					gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'contva.importe_recurso',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
			{
				config:{
					name: 'fecha_reg',
					fieldLabel: 'Fecha creación',
					allowBlank: true,
					anchor: '80%',
					gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'contva.fecha_reg',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config: {
				name: 'usr_reg',
				fieldLabel: 'Creado por',
				allowBlank: true,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_/control/Clase/Metodo',
					id: 'id_',
					root: 'datos',
					sortInfo: {
						field: 'nombre',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_', 'nombre', 'codigo'],
					remoteSort: true,
					baseParams: {par_filtro: 'movtip.nombre#movtip.codigo'}
				}),
				valueField: 'id_',
				displayField: 'nombre',
				gdisplayField: 'desc_',
				hiddenName: 'usr_reg',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '100%',
				gwidth: 150,
				minChars: 2,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['desc_']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'movtip.nombre',type: 'string'},
			grid: true,
			form: true
		}
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
				filters:{pfiltro:'contva.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config: {
				name: 'usr_mod',
				fieldLabel: 'Modificado por',
				allowBlank: true,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_/control/Clase/Metodo',
					id: 'id_',
					root: 'datos',
					sortInfo: {
						field: 'nombre',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_', 'nombre', 'codigo'],
					remoteSort: true,
					baseParams: {par_filtro: 'movtip.nombre#movtip.codigo'}
				}),
				valueField: 'id_',
				displayField: 'nombre',
				gdisplayField: 'desc_',
				hiddenName: 'usr_mod',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '100%',
				gwidth: 150,
				minChars: 2,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['desc_']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'movtip.nombre',type: 'string'},
			grid: true,
			form: true
		
	],
	tam_pag:50,	
	title:'Transacción Valor',
	ActSave:'../../sis_contabilidad/control/TransaccionValor/insertarTransaccionValor',
	ActDel:'../../sis_contabilidad/control/TransaccionValor/eliminarTransaccionValor',
	ActList:'../../sis_contabilidad/control/TransaccionValor/listarTransaccionValor',
	id_store:'id_transaccion_valor',
	fields: [
		{name:'id_transaccion_valor', type: 'numeric'},
		{name:'id_transaccion', type: 'numeric'},
		{name:'id_moneda', type: 'numeric'},
		{name:'importe_debe', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'importe_gasto', type: 'numeric'},
		{name:'importe_haber', type: 'numeric'},
		{name:'importe_recurso', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
	],
	sortInfo:{
		field: 'id_transaccion_valor',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true
	}
)
</script>
		
		