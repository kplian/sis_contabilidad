<?php
/**
*@package pXP
*@file gen-DocConcepto.php
*@author  (admin)
*@date 15-09-2015 13:09:45
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.DocConcepto=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.DocConcepto.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_doc_concepto'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
				labelSeparator:'',
				inputType:'hidden',
				name: 'id_doc_compra_venta'
			},
			type:'Field',
			form:true
		},
		{
			config: {
				name: 'id_concepto_ingas',
				fieldLabel: 'Concepto Ingas',
				allowBlank: false,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_parametros/control/ConceptoIngas/listarConceptoIngasMasPartida',
					id: 'id_concepto_ingas',
					root: 'datos',
					sortInfo: {
						field: 'desc_ingas',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_concepto_ingas','tipo','desc_ingas','movimiento','desc_partida','id_grupo_ots','filtro_ot','requiere_ot'],
					remoteSort: true,
					baseParams: {par_filtro: 'conig.desc_ingas#par.codigo', movimiento:'gasto'}
				}),
				valueField: 'id_concepto_ingas',
				displayField: 'desc_ingas',
				gdisplayField: 'desc_concepto_ingas',
				hiddenName: 'id_concepto_ingas',
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
					return String.format('{0}', record.data['desc_concepto_ingas']);
				},
				tpl: '<tpl for="."><div class="x-combo-list-item"><p><b>{desc_ingas}</b></p><strong>{tipo}</strong><p>Partida:{desc_partida}</p></div></tpl>'
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'movtip.nombre',type: 'string'},
			grid: true,
			form: true
		},
		{
			config: {
				name: 'id_centro_costo',
				fieldLabel: 'Centro Costo',
				allowBlank: false,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_parametros/control/CentroCosto/listarCentroCostoFiltradoXDepto',
					id: 'id_centro_costo',
					root: 'datos',
					sortInfo: {
						field: 'codigo_cc',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_centro_costo', 'codigo_cc', 'codigo_uo', 'nombre_uo'],
					remoteSort: true,
					baseParams: {par_filtro: 'cec.id_centro_costo#cec.codigo_cc',tipo_pres:'gasto', filtrar:'grupo_ep'}
				}),
				valueField: 'id_centro_costo',
				displayField: 'codigo_cc',
				gdisplayField: 'desc_centro_costo',
				hiddenName: 'id_centro_costo',
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
					return String.format('{0}', record.data['desc_centro_costo']);
				},
				tpl: '<tpl for="."><div class="x-combo-list-item"><p><b>{codigo_cc}</b></p><strong>Unidad:{nombre_uo}</strong></div></tpl>',
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'movtip.nombre',type: 'string'},
			grid: true,
			form: true
		},
		{
			config: {
				name: 'id_orden_trabajo',
				fieldLabel: 'Orden Trabajo',
				allowBlank: true,
				sysorigen:'sis_contabilidad',
				origen:'OT',
				emptyText: 'Elija una opción...',
				valueField: 'id_orden_trabajo',
				displayField: 'desc_orden',
				gdisplayField: 'desc_orden_trabajo',
				hiddenName: 'id_orden_trabajo',
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
					return String.format('{0}', record.data['desc_orden_trabajo']);
				}
			},
			type: 'ComboRec',
			id_grupo: 0,
			filters: {pfiltro: 'movtip.nombre',type: 'string'},
			grid: true,
			form: true
		},
		{
			config:{
				name: 'descripcion',
				fieldLabel: 'Descripcion',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1200
			},
				type:'TextField',
				filters:{pfiltro:'docc.descripcion',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'cantidad_sol',
				fieldLabel: 'Cantidad',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:10
			},
				type:'NumberField',
				filters:{pfiltro:'docc.cantidad',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'precio_unitario',
				fieldLabel: 'Precio Unitario',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:1245186
			},
				type:'NumberField',
				filters:{pfiltro:'docc.precio_unitario',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'precio_total',
				fieldLabel: 'Precio Total',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:1245186
			},
				type:'NumberField',
				filters:{pfiltro:'docc.precio_total',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			//configuracion del componente
			config:{
				labelSeparator:'',
				fieldLabel: 'Importe Neto',
				inputType:'hidden',
				name: 'precio_total_final'
			},
			type:'Field',
			grid: true,
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
			filters:{pfiltro:'docc.estado_reg',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'usr_reg',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'usu1.cuenta',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
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
				filters:{pfiltro:'docc.fecha_reg',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'docc.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'docc.usuario_ai',type:'string'},
				id_grupo:1,
				grid:true,
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
				id_grupo:1,
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
				filters:{pfiltro:'docc.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'CONCEPTO',
	ActSave:'../../sis_contabilidad/control/DocConcepto/insertarDocConcepto',
	ActDel:'../../sis_contabilidad/control/DocConcepto/eliminarDocConcepto',
	ActList:'../../sis_contabilidad/control/DocConcepto/listarDocConcepto',
	id_store:'id_doc_concepto',
	fields: [
		{name:'id_doc_concepto', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_orden_trabajo', type: 'numeric'},
		{name:'desc_orden_trabajo', type: 'numeric'},
		{name:'id_centro_costo', type: 'numeric'},
		{name:'desc_centro_costo', type: 'numeric'},
		{name:'id_concepto_ingas', type: 'numeric'},
		{name:'desc_concepto_ingas', type: 'numeric'},
		{name:'descripcion', type: 'string'},
		{name:'cantidad_sol', type: 'numeric'},
		{name:'precio_unitario', type: 'numeric'},
		{name:'precio_total', type: 'numeric'},
		{name:'precio_total_final', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
	],
	sortInfo:{
		field: 'id_doc_concepto',
		direction: 'ASC'
	},

	loadValoresIniciales: function() {

		Phx.vista.DocConcepto.superclass.loadValoresIniciales.call(this);
		if(typeof this.id_doc_compra_venta == 'undefined')
			this.Cmp.id_doc_compra_venta.setValue(this.data.id_doc_compra_venta);
		else
			this.Cmp.id_doc_compra_venta.setValue(this.id_doc_compra_venta);
	},

	bdel:true,
	bsave:true
	}
)
</script>
		
		