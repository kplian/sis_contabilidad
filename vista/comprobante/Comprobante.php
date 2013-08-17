<?php
/**
*@package pXP
*@file gen-Comprobante.php
*@author  RCM
*@date 15/07/2013
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Comprobante=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.Comprobante.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
	},
	tam_pag:50,
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_comprobante'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'nro_cbte',
				fieldLabel: 'Nro. Cbte.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:30,
				disabled:true
			},
			type:'TextField',
			filters:{pfiltro:'cbte.nro_cbte',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'fecha',
				fieldLabel: 'Fecha',
				allowBlank: true,
				gwidth: 85,
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type:'DateField',
			filters:{pfiltro:'cbte.fecha',type:'date'},
			id_grupo:0,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'id_periodo',
				fieldLabel: 'id_periodo',
				inputType:'hidden'
			},
			type:'NumberField',
			form:true
		},
		{
			config:{
				name: 'momento',
				fieldLabel: 'Momento',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:30
			},
			type:'TextField',
			filters:{pfiltro:'cbte.momento',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'tipo_cambio',
				fieldLabel: 'Tipo de Cambio',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
			type:'NumberField',
			filters:{pfiltro:'cbte.tipo_cambio',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'id_funcionario_firma1',
				fieldLabel: 'id_funcionario_firma1',
				allowBlank: true,
				anchor: '80%',
				gwidth: 150,
				maxLength:4,
				renderer:function (value, p, record){return String.format('{0}', record.data['desc_firma1']);}
			},
			type:'NumberField',
			filters:{pfiltro:'fun1.desc_funcionario1',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'id_funcionario_firma2',
				fieldLabel: 'id_funcionario_firma2',
				allowBlank: true,
				anchor: '80%',
				gwidth: 150,
				maxLength:4,
				renderer:function (value, p, record){return String.format('{0}', record.data['desc_firma2']);}
			},
			type:'NumberField',
			filters:{pfiltro:'fun2.desc_funcionario1',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'id_funcionario_firma3',
				fieldLabel: 'id_funcionario_firma3',
				allowBlank: true,
				anchor: '80%',
				gwidth: 150,
				maxLength:4,
				renderer:function (value, p, record){return String.format('{0}', record.data['desc_firma3']);}
			},
			type:'NumberField',
			filters:{pfiltro:'fun3.desc_funcionario1',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'beneficiario',
				fieldLabel: 'Beneficiario',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextField',
			filters:{pfiltro:'cbte.beneficiario',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'id_depto',
				fieldLabel: 'Depto.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
			type:'NumberField',
			filters:{pfiltro:'cbte.id_depto',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'glosa1',
				fieldLabel: 'Glosa',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1500
			},
			type:'TextField',
			filters:{pfiltro:'cbte.glosa1',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'glosa2',
				fieldLabel: 'Observaciones',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:400
			},
			type:'TextField',
			filters:{pfiltro:'cbte.glosa2',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config: {
				name: 'id_moneda',
				fieldLabel: 'Moneda',
				allowBlank: true,
				emptyText: 'Seleccione una Moneda...',
				store: new Ext.data.JsonStore({
					url: '../../sis_parametros/control/Moneda/listarMoneda',
					id: 'id_moneda',
					root: 'datos',
					sortInfo: {
						field: 'codigo',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_moneda','codigo'],
					remoteSort: true,
					baseParams: {par_filtro:'codigo'}
				}),
				//hidden: true,
				valueField: 'id_moneda',
				displayField: 'codigo',
				gdisplayField: 'codigo_moneda',
				forceSelection: false,
				typeAhead: false,
    			triggerAction: 'all',
    			lazyRender: true,
				mode: 'remote',
				pageSize: 20,
				queryDelay: 500,
				anchor: '99%',
				gwidth: 70,
				minChars: 2,
				renderer: function (value, p, record) {
					return String.format('{0}', value?record.data['codigo_moneda']:'');
				}
			},
			type: 'ComboBox',
			filters: {
				pfiltro: 'mon.codigo',
				type: 'string'
			},
			id_grupo: 0,
			grid: true,
			form: true
		},
		{
			config: {
				name: 'id_clase_comprobante',
				fieldLabel: 'Clase Comprobante',
				allowBlank: true,
				emptyText: 'Seleccione una Clase...',
				store: new Ext.data.JsonStore({
					url: '../../sis_contabilidad/control/ClaseComprobante/listarClaseComprobante',
					id: 'id_clase_comprobante',
					root: 'datos',
					sortInfo: {
						field: 'tipo_comprobante',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_clase_comprobante','tipo_comprobante','descripcion'],
					remoteSort: true,
					baseParams: {par_filtro:'descripcion'}
				}),
				//hidden: true,
				valueField: 'id_clase_comprobante',
				displayField: 'descripcion',
				gdisplayField: 'desc_clase_comprobante',
				forceSelection: false,
				typeAhead: false,
    			triggerAction: 'all',
    			lazyRender: true,
				mode: 'remote',
				pageSize: 20,
				queryDelay: 500,
				anchor: '99%',
				gwidth: 70,
				minChars: 2,
				renderer: function (value, p, record) {
					return String.format('{0}', value?record.data['desc_clase_comprobante']:'');
				}
			},
			type: 'ComboBox',
			filters: {
				pfiltro: 'ccbte.descripcion',
				type: 'string'
			},
			id_grupo: 0,
			grid: true,
			form: true
		},
		{
			config: {
				name: 'id_subsistema',
				fieldLabel: 'Subsistema',
				allowBlank: true,
				emptyText: 'Seleccione un Subsistema...',
				store: new Ext.data.JsonStore({
					url: '../../sis_seguridad/control/Subsistema/listarSubsistema',
					id: 'id_subsistema',
					root: 'datos',
					sortInfo: {
						field: 'codigo',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_subsistema','codigo','nombre'],
					remoteSort: true,
					baseParams: {par_filtro:'ssis.nombre#ssis.codigo'}
				}),
				//hidden: true,
				valueField: 'id_subsistema',
				displayField: 'nombre',
				gdisplayField: 'desc_subsistema',
				forceSelection: false,
				typeAhead: false,
    			triggerAction: 'all',
    			lazyRender: true,
				mode: 'remote',
				pageSize: 20,
				queryDelay: 500,
				anchor: '99%',
				gwidth: 70,
				minChars: 2,
				renderer: function (value, p, record) {
					return String.format('{0}', value?record.data['desc_subsistema']:'');
				}
			},
			type: 'ComboBox',
			filters: {
				pfiltro: 'ssis.nombre#ssis.codigo',
				type: 'string'
			},
			id_grupo: 0,
			grid: true,
			form: true
		},
		{
			config: {
				name: 'id_comprobante_fk',
				fieldLabel: 'Comprobante',
				allowBlank: true,
				emptyText: 'Seleccione un Comprobante...',
				store: new Ext.data.JsonStore({
					url: '../../sis_contabilidad/control/Comprobante/listarComprobante',
					id: 'id_comprobante',
					root: 'datos',
					sortInfo: {
						field: 'nro_cbte',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_comprobante','nro_cbte'],
					remoteSort: true,
					baseParams: {par_filtro:'nro_cbte'}
				}),
				//hidden: true,
				valueField: 'id_comprobante',
				displayField: 'nro_cbte',
				gdisplayField: 'desc_cbte',
				forceSelection: false,
				typeAhead: false,
    			triggerAction: 'all',
    			lazyRender: true,
				mode: 'remote',
				pageSize: 20,
				queryDelay: 500,
				anchor: '99%',
				gwidth: 70,
				minChars: 2,
				renderer: function (value, p, record) {
					return String.format('{0}', value?record.data['desc_cbte']:'');
				}
			},
			type: 'ComboBox',
			filters: {
				pfiltro: 'cbte.nro_cbte',
				type: 'string'
			},
			id_grupo: 0,
			grid: true,
			form: true
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
			filters:{pfiltro:'cbte.estado_reg',type:'string'},
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
			type:'NumberField',
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
			filters:{pfiltro:'cbte.fecha_reg',type:'date'},
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
			type:'NumberField',
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
			filters:{pfiltro:'cbte.fecha_mod',type:'date'},
			id_grupo:1,
			grid:true,
			form:false
		}
	],
	
	title:'Comprobante',
	ActSave:'../../sis_contabilidad/control/Comprobante/insertarComprobante',
	ActDel:'../../sis_contabilidad/control/Comprobante/eliminarComprobante',
	ActList:'../../sis_contabilidad/control/Comprobante/listarComprobante',
	id_store:'id_comprobante',
	fields: [
		{name:'id_comprobante', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_funcionario_firma2', type: 'numeric'},
		{name:'id_periodo', type: 'numeric'},
		{name:'momento', type: 'string'},
		{name:'tipo_cambio', type: 'numeric'},
		{name:'id_funcionario_firma1', type: 'numeric'},
		{name:'beneficiario', type: 'string'},
		{name:'id_depto', type: 'numeric'},
		{name:'glosa2', type: 'string'},
		{name:'id_moneda', type: 'numeric'},
		{name:'id_funcionario_firma3', type: 'numeric'},
		{name:'glosa1', type: 'string'},
		{name:'id_clase_comprobante', type: 'numeric'},
		{name:'id_subsistema', type: 'numeric'},
		{name:'nro_cbte', type: 'string'},
		{name:'id_comprobante_fk', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'fecha', type: 'date',dateFormat:'Y-m-d'},
	],
	sortInfo:{
		field: 'id_comprobante',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
	south: {
			url : '../../../sis_contabilidad/vista/transaccion/Transaccion.php',
			title : 'Transacciones',
			height : '50%',
			cls : 'Transaccion'
		},
	}
)
</script>
		
		