<?php
/**
*@package pXP
*@file gen-Comprobante.php
*@author  (admin)
*@date 29-08-2013 00:28:30
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Comprobante=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.Comprobante.superclass.constructor.call(this, config);
		this.init();
		this.load({ params: { start: 0, limit: this.tam_pag }})
		
		//Botón para Imprimir el Comprobante
		this.addButton('btnImprimir',
			{
				text: 'Imprimir',
				iconCls: 'bprint',
				disabled: true,
				handler: this.imprimirCbte,
				tooltip: '<b>Imprimir Comprobante</b><br/>Imprime el Comprobante en el formato oficial'
			}
		);
		
		//Esconde el id_subsistema
		this.Cmp.id_subsistema.hide();
		
		//Eventos
		this.Cmp.id_moneda.on('select', this.getTipoCambio, this);
		this.Cmp.fecha.on('select', this.getTipoCambio, this);
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator: '',
					inputType: 'hidden',
					name: 'id_comprobante'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator: '',
					inputType: 'hidden',
					name: 'id_periodo'
			},
			type:'Field',
			form:true 
		},
		{
			config: {
				name: 'nro_tramite',
				fieldLabel: 'Nro. Trámite',
				gwidth: 150,
				minChars: 2,
				
			},
			type: 'Field',
			id_grupo: 4,
			filters: {pfiltro: 'incbte.nro_tramite',type: 'string'},
			grid: true,
			form: false
		},
		{
			config:{
				name: 'nro_cbte',
				fieldLabel: 'Nro.Cbte.',
				gwidth: 100
			},
			type:'TextField',
			filters:{pfiltro:'incbte.nro_cbte',type:'string'},
			id_grupo:4,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'fecha',
				fieldLabel: 'Fecha',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type:'DateField',
			filters:{pfiltro:'incbte.fecha',type:'date'},
			id_grupo:5,
			grid:true,
			form:true
		},
		{
			config: {
				name: 'id_depto',
				fieldLabel: 'Depto.',
				allowBlank: false,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_parametros/control/Depto/listarDeptoFiltradoXUsuario',
					id: 'id_',
					root: 'datos',
					sortInfo: {
						field: 'nombre',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_depto', 'codigo', 'nombre'],
					remoteSort: true,
					baseParams: {par_filtro: 'DEPPTO.nombre#DEPPTO.codigo'}
				}),
				valueField: 'id_depto',
				displayField: 'nombre',
				gdisplayField: 'desc_depto',
				hiddenName: 'id_depto',
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
					return String.format('{0}', record.data['desc_depto']);
				},
				listWidth:300
			},
			type: 'ComboBox',
			id_grupo: 5,
			filters: {pfiltro: 'movtip.nombre',type: 'string'},
			grid: true,
			form: true
		},
		{
			config: {
				name: 'id_clase_comprobante',
				fieldLabel: 'Tipo Cbte.',
				allowBlank: false,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_contabilidad/control/ClaseComprobante/listarClaseComprobante',
					id: 'id_clase_comprobante',
					root: 'datos',
					sortInfo: {
						field: 'id_clase_comprobante',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_clase_comprobante', 'tipo_comprobante', 'descripcion','codigo'],
					remoteSort: true,
					baseParams: {par_filtro: 'ccom.tipo_comprobante#ccom.descripcion#ccom.codigo'}
				}),
				valueField: 'id_clase_comprobante',
				displayField: 'descripcion',
				gdisplayField: 'desc_clase_comprobante',
				hiddenName: 'id_clase_comprobante',
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
					return String.format('{0}', record.data['desc_clase_comprobante']);
				}
			},
			type: 'ComboBox',
			id_grupo: 5,
			filters: {pfiltro: 'ccbte.descripcion',type: 'string'},
			grid: true,
			form: true
		},
		{
			config: {
				name: 'accion',
				fieldLabel: 'Acción',
				anchor: '40%',
				tinit: false,
				allowBlank: false,
				origen: 'CATALOGO',
				gdisplayField: 'accion',
				gwidth: 100,
				baseParams:{
						cod_subsistema:'CONTA',
						catalogo_tipo:'tcomprobante__accion'
				},
				renderer:function (value, p, record){return String.format('{0}', record.data['accion']);}
			},
			type: 'ComboRec',
			id_grupo: 6,
			filters:{pfiltro:'incbte.accion',type:'string'},
			grid: true,
			form: true
		},
		{
			config: {
				name:'momento',
				fieldLabel: 'Momento Presupuestario',
				items: [
	                {boxLabel: 'Comprometer', name: 'cb-auto-1',checked: true},
	                {boxLabel: 'Devengar', name: 'cb-auto-2', checked: true},
	                {boxLabel: 'Pagar', name: 'cb-auto-3'}
	            ]
			},
			type: 'CheckboxGroup',
			id_grupo: 6,
			filters: {pfiltro: 'incbte.nro_tramite',type: 'string'},
			grid: true,
			form: true
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
				gdisplayField: 'desc_moneda',
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
					return String.format('{0}', value?record.data['desc_moneda']:'');
				}
			},
			type: 'ComboBox',
			filters: {
				pfiltro: 'mon.codigo',
				type: 'string'
			},
			id_grupo: 7,
			grid: true,
			form: true
		},
		{
			config:{
				name: 'tipo_cambio',
				fieldLabel: 'Tipo Cambio',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:20,
				decimalPrecision:6
			},
			type:'NumberField',
			filters:{pfiltro:'incbte.tipo_cambio',type:'numeric'},
			id_grupo:7,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'glosa1',
				fieldLabel: 'Glosa',
				allowBlank: false,
				anchor: '100%',
				gwidth: 100,
				maxLength:1500
			},
			type:'TextArea',
			filters:{pfiltro:'incbte.glosa1',type:'string'},
			id_grupo:0,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'glosa2',
				fieldLabel: 'Conformidad',
				allowBlank: false,
				anchor: '100%',
				gwidth: 100,
				maxLength:400
			},
			type:'TextField',
			filters:{pfiltro:'incbte.glosa2',type:'string'},
			id_grupo:0,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'beneficiario',
				fieldLabel: 'Beneficiario',
				allowBlank: false,
				anchor: '100%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextField',
			filters:{pfiltro:'incbte.beneficiario',type:'string'},
			id_grupo:0,
			grid:true,
			form:true
		},
		{
	   		config:{
	       		    name:'id_funcionario_firma1',
	   				origen:'FUNCIONARIO',
	   				tinit:true,
	   				fieldLabel: 'Firma 1',
	   				gdisplayField:'desc_firma1',
	   			    gwidth: 120,
	   			    anchor: '100%',
	   			    allowBlank:true,
		   			renderer: function (value, p, record){return String.format('{0}', record.data['desc_firma1']);}
	       	     },
	   			type:'ComboRec',
	   			id_grupo:8,
	   			filters:{	
			        pfiltro:'fir1.desc_funcionario2',
					type:'string'
				},
	   			grid:true,
	   			form:true
	   	},
	   	{
	   		config:{
	       		    name:'id_funcionario_firma2',
	   				origen:'FUNCIONARIO',
	   				tinit:true,
	   				fieldLabel: 'Firma 2',
	   				gdisplayField:'desc_firma2',
	   			    gwidth: 120,
	   			    anchor: '100%',
	   			    allowBlank:true,
		   			renderer: function (value, p, record){return String.format('{0}', record.data['desc_firma2']);}
	       	     },
	   			type:'ComboRec',
	   			id_grupo:8,
	   			filters:{	
			        pfiltro:'fir2.desc_funcionario2',
					type:'string'
				},
	   			grid:true,
	   			form:true
	   	},
	   	{
	   		config:{
	       		    name:'id_funcionario_firma3',
	   				origen:'FUNCIONARIO',
	   				tinit:true,
	   				fieldLabel: 'Firma 3',
	   				gdisplayField:'desc_firma3',
	   			    gwidth: 120,
	   			    anchor: '100%',
	   			    allowBlank:true,
		   			renderer: function (value, p, record){return String.format('{0}', record.data['desc_firma3']);}
	       	     },
	   			type:'ComboRec',
	   			id_grupo:8,
	   			filters:{	
			        pfiltro:'fir3.desc_funcionario2',
					type:'string'
				},
	   			grid:true,
	   			form:true
	   	},
		
		{
			config: {
				name: 'id_comprobante_fk',
				fieldLabel: 'id_comprobante_fk',
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
				hiddenName: 'id_comprobante_fk',
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
				},
				hidden:true
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'movtip.nombre',type: 'string'},
			grid: true,
			form: true
		},
		{
			config: {
				name: 'id_subsistema',
				fieldLabel: 'Sistema Origen',
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['desc_subsistema']);
				}
			},
			type: 'TextField',
			id_grupo: 0,
			filters: {pfiltro: 'sis.codigo#sis.nombre',type: 'string'},
			grid: true,
			form: true
		},
		{
			config: {
				name: 'id_periodo',
				fieldLabel: 'id_periodo',
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
				hiddenName: 'id_periodo',
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
				},
				hidden:true
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'movtip.nombre',type: 'string'},
			grid: true,
			form: true
		},
		{
			config:{
				name: 'estado_reg',
				emptyText: 'Estado Reg.',
				gwidth: 100
			},
			type:'Field',
			filters:{pfiltro:'incbte.estado_reg',type:'string'},
			id_grupo:4,
			grid:true,
			form:true
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
				id_grupo:0,
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
			filters:{pfiltro:'incbte.fecha_reg',type:'date'},
			id_grupo:0,
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
			id_grupo:0,
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
			filters:{pfiltro:'incbte.fecha_mod',type:'date'},
			id_grupo:0,
			grid:true,
			form:false
		}
	],
	tam_pag:50,	
	title:'Comprobante',
	ActSave:'../../sis_contabilidad/control/Comprobante/insertarComprobante',
	ActDel:'../../sis_contabilidad/control/Comprobante/eliminarComprobante',
	ActList:'../../sis_contabilidad/control/Comprobante/listarComprobante',
	id_store:'id_comprobante',
	fields: [
		{name:'id_comprobante', type: 'numeric'},
		{name:'id_clase_comprobante', type: 'numeric'},
		{name:'id_comprobante_fk', type: 'numeric'},
		{name:'id_subsistema', type: 'numeric'},
		{name:'id_depto', type: 'numeric'},
		{name:'id_moneda', type: 'numeric'},
		{name:'id_periodo', type: 'numeric'},
		{name:'id_funcionario_firma1', type: 'numeric'},
		{name:'id_funcionario_firma2', type: 'numeric'},
		{name:'id_funcionario_firma3', type: 'numeric'},
		{name:'tipo_cambio', type: 'numeric'},
		{name:'beneficiario', type: 'string'},
		{name:'nro_cbte', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'glosa1', type: 'string'},
		{name:'fecha', type: 'date',dateFormat:'Y-m-d'},
		{name:'glosa2', type: 'string'},
		{name:'nro_tramite', type: 'string'},
		{name:'momento', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'desc_clase_comprobante', type: 'string'},
		{name:'desc_subsistema', type: 'string'},
		{name:'desc_depto', type: 'string'},
		{name:'desc_moneda', type: 'string'},
		{name:'desc_firma1', type: 'string'},
		{name:'desc_firma2', type: 'string'},
		{name:'desc_firma3', type: 'string'},
		'momento_comprometido',
        'momento_ejecutado',
        'momento_pagado'
	],
	sortInfo:{
		field: 'fecha',
		direction: 'desc'
	},
	Grupos: [
            {
                //layout: 'hbox',
                border: false,
                defaults: {
                   border: false
                },            
                items: [
                	{
						bodyStyle: 'padding-right:5px;',
					    items: [{
					    	xtype: 'fieldset',
					        title: 'Datos principales',
					        autoHeight: true,
					        //layout:'hbox',
					        items: [{
					        	xtype: 'compositefield',
							    fieldLabel: 'Nro.Trámite',
							    msgTarget : 'side',
							    // anchor    : '-20',
							    Defaults: {
							    	flex: 1
							    },
							    items:[ ],
							    id_grupo: 4
						      },
						      {
					        	xtype: 'compositefield',
							    fieldLabel: 'Fecha',
							    msgTarget : 'side',
							    // anchor    : '-20',
							    Defaults: {
							    	flex: 1
							    },
							    items:[ ],
							    id_grupo:5
						      },
						      {
						    	xtype: 'fieldset',
						        title: 'Momentos Presupuestarios',
						        autoHeight: true,
						        //layout:'hbox',
						        items: [{
						        	xtype: 'compositefield',
								    fieldLabel: 'Acción',
								    msgTarget : 'side',
								    // anchor    : '-20',
								    Defaults: {
								    	flex: 1
								    },
								    items:[ ],
								    id_grupo:6
							      }]
						       },
						       {
					        	xtype: 'compositefield',
							    fieldLabel: 'Moneda',
							    //msgTarget : 'side',
							    // anchor    : '-20',
							    Defaults: {
							    	flex: 1
							    },
							    items:[ ],
							    id_grupo:7
						      },
						      ],
						      id_grupo:0//fin grupo primario
					        },
					        {
						    	xtype: 'fieldset',
						        title: 'Firmas Comprobante',
						        autoHeight: true,
						        //layout:'hbox',
						        items: [],
							    id_grupo:8
						       }]
					    }
					]
            }
        ],
    south:{
	  url:'../../../sis_contabilidad/vista/transaccion/Transaccion.php',
	  title:'Transacciones', 
	  height:'50%',	//altura de la ventana hijo
	  cls:'Transaccion'
	},
	imprimirCbte: function(){
		Ext.Msg.confirm('Confirmación','¿Está seguro de Imprimir el Comprobante?',function(btn){
			Ext.Ajax.request({
					url : '../../sis_contabilidad/control/Comprobante/reporteComprobante',
					params : {
						'id_uni_cons' : data.id_uni_cons
					},
					success : this.successExport,
					failure : this.conexionFailure,
					timeout : this.timeout,
					scope : this
				});
		}, this)
	},
	preparaMenu: function(n) {
		var tb = Phx.vista.Comprobante.superclass.preparaMenu.call(this);
	   	this.getBoton('btnImprimir').setDisabled(false);
  		return tb;
	},
	liberaMenu: function() {
		var tb = Phx.vista.Comprobante.superclass.liberaMenu.call(this);
		this.getBoton('btnImprimir').setDisabled(true);
		return tb;
	},
	bnew:false,
	bedit:false,
	bdel:false,
	bsave:false
	
})
</script>
		
		