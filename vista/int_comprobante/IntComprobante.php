<?php
/**
*@package pXP
*@file gen-IntComprobante.php
*@author  (admin)
*@date 29-08-2013 00:28:30
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.IntComprobante=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.IntComprobante.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
		
		//Botón para Validación del Comprobante
		this.addButton('btnValidar',
			{
				text: 'Validación',
				iconCls: 'bchecklist',
				disabled: true,
				handler: this.validarCbte,
				tooltip: '<b>Validación</b><br/>Validación del Comprobante'
			}
		);
		
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
		this.Cmp.id_moneda.on('select',this.getTipoCambio,this);
		this.Cmp.fecha.on('select',this.getTipoCambio,this);
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_int_comprobante'
			},
			type:'Field',
			form:true 
		},
		{
			config: {
				name: 'nro_tramite',
				fieldLabel: 'Nro. Trámite',
				allowBlank: true,
				emptyText: 'Nro. Trámite...',
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
				hiddenName: 'nro_tramite',
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
			id_grupo: 4,
			filters: {pfiltro: 'incbte.nro_tramite',type: 'string'},
			grid: true,
			form: true
		},
		{
			config: {
				name:'d_nro_cbte',
				value: 'Nro. Cbte.',
				width:70
			},
			type:'DisplayField',
			id_grupo: 4,
			grid:false,
			form:true,
			valorInicial:'Nro. Cbte.'
		},
		{
			config:{
				name: 'nro_cbte',
				fieldLabel: 'Nro.Cbte.',
				emptyText: 'Nro. de Cbte.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:30,
				labelAlign: 'top',
				disabled:true
			},
			type:'TextField',
			filters:{pfiltro:'incbte.nro_cbte',type:'string'},
			id_grupo:4,
			grid:true,
			form:true
		},
		{
			config: {
				name:'d_estado_reg',
				value: 'Estado Cbte.',
				width:80
			},
			type:'DisplayField',
			id_grupo: 4,
			grid:false,
			form:true,
			valorInicial:'Estado Cbte.',
		},
		{
			config:{
				name: 'estado_reg',
				fieldLabel: 'Estado',
				emptyText: 'Estado Cbte.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:10,
				disabled:true
			},
			type:'TextField',
			filters:{pfiltro:'incbte.estado_reg',type:'string'},
			id_grupo:4,
			grid:true,
			form:true
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
				name:'d_id_depto',
				value: 'Depto.',
				width:55
			},
			type:'DisplayField',
			id_grupo: 5,
			grid:false,
			form:true,
			valorInicial:'Depto.'
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
				name:'d_id_clase_comprobante',
				value: 'Tipo Cbte.',
				width:70
			},
			type:'DisplayField',
			id_grupo: 5,
			grid:false,
			form:true,
			valorInicial:'Tipo Cbte.',
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
					fields: ['id_clase_comprobante', 'tipo_comprobante', 'descripcion'],
					remoteSort: true,
					baseParams: {par_filtro: 'ccom.tipo_comprobante#ccom.descripcion'}
				}),
				valueField: 'id_clase_comprobante',
				displayField: 'tipo_comprobante',
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
			filters: {pfiltro: 'movtip.nombre',type: 'string'},
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
			filters:{pfiltro:'placal.prioridad',type:'string'},
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
			config: {
				name:'d_tipo_cambio',
				value: 'Tipo Cambio',
				width:70
			},
			type:'DisplayField',
			id_grupo: 7,
			grid:false,
			form:true,
			valorInicial:'Tipo Cambio',
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
				name: 'id_int_comprobante_fk',
				fieldLabel: 'id_int_comprobante_fk',
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
				hiddenName: 'id_int_comprobante_fk',
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
				name: 'usr_reg',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'NumberField',
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
				type:'NumberField',
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
	ActSave:'../../sis_contabilidad/control/IntComprobante/insertarIntComprobante',
	ActDel:'../../sis_contabilidad/control/IntComprobante/eliminarIntComprobante',
	ActList:'../../sis_contabilidad/control/IntComprobante/listarIntComprobante',
	id_store:'id_int_comprobante',
	fields: [
		{name:'id_int_comprobante', type: 'numeric'},
		{name:'id_clase_comprobante', type: 'numeric'},
		{name:'id_int_comprobante_fk', type: 'numeric'},
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
		{name:'desc_firma3', type: 'string'}
	],
	sortInfo:{
		field: 'fecha',
		direction: 'desc'
	},
	bdel:true,
	bsave:true,
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
							    id_grupo:4
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
	  url:'../../../sis_contabilidad/vista/int_transaccion/IntTransaccion.php',
	  title:'Transacciones', 
	  height:'50%',	//altura de la ventana hijo
	  cls:'IntTransaccion'
	},
	validarCbte: function(){
		Ext.Msg.confirm('Confirmación','¿Está seguro de Validar el Comprobante?',function(btn){
			var rec=this.sm.getSelected();
			Phx.CP.loadingShow();
			Ext.Ajax.request({
				url:'../../sis_contabilidad/control/IntComprobante/validarIntComprobante',
				params:{
					id_int_comprobante: rec.data.id_int_comprobante,
					igualar: 'no'
				},
				success: function(resp){
					Phx.CP.loadingHide();
					var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
					if (reg.ROOT.error) {
						Ext.Msg.alert('Error','Validación no realizada: '+reg.ROOT.error)
					} else {
						this.reload();
						Ext.Msg.alert('Mensaje','Proceso ejecutado con éxito')
					}
				},
				failure: this.conexionFailure,
				timeout: this.timeout,
				scope:this
			});
		}, this)
	},
	preparaMenu: function(n) {
		var tb = Phx.vista.IntComprobante.superclass.preparaMenu.call(this);
	   	this.getBoton('btnValidar').setDisabled(false);
	   	this.getBoton('btnImprimir').setDisabled(false);
  		return tb;
	},
	liberaMenu: function() {
		var tb = Phx.vista.IntComprobante.superclass.liberaMenu.call(this);
		this.getBoton('btnValidar').setDisabled(true);
		this.getBoton('btnImprimir').setDisabled(true);
		return tb;
	},
	getTipoCambio: function(){
		//Verifica que la fecha y la moneda hayan sido elegidos
		if(this.Cmp.fecha.getValue()&&this.Cmp.id_moneda.getValue()){
			Ext.Ajax.request({
				url:'../../sis_parametros/control/TipoCambio/obtenerTipoCambio',
				params:{
					fecha: this.Cmp.fecha.getValue(),
					id_moneda: this.Cmp.id_moneda.getValue(),
					tipo: 'O'
				},
				success: function(resp){
					Phx.CP.loadingHide();
					var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
					if (reg.ROOT.error) {
						Ext.Msg.alert('Error','Validación no realizada: '+reg.ROOT.error)
					} else {
						this.Cmp.tipo_cambio.setValue(reg.ROOT.datos.tipo_cambio);
					}
				},
				failure: this.conexionFailure,
				timeout: this.timeout,
				scope:this
			});
		}
		
	},
	imprimirCbte: function(){
		//Ext.Msg.confirm('Confirmación','¿Está seguro de Imprimir el Comprobante?',function(btn){
			var rec = this.sm.getSelected();
			var data = rec.data;
			if (data) {
				Ext.Ajax.request({
						url : '../../sis_contabilidad/control/IntComprobante/reporteComprobante',
						params : {
							'id_int_comprobante' : data.id_int_comprobante
						},
						success : this.successExport,
						failure : this.conexionFailure,
						timeout : this.timeout,
						scope : this
					});
			}
		//}, this)
	},
	
})
</script>
		
		