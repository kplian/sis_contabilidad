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
Phx.vista.IntComprobante = Ext.extend(Phx.gridInterfaz,{
    fheight:500,
    fwidth: 850,
    nombreVista: 'IntComprobante',
	constructor:function(config){
		this.maestro=config.maestro;
		this.initButtons=[this.cmbDepto];
		
		
		//llama al constructor de la clase padre
		Phx.vista.IntComprobante.superclass.constructor.call(this,config);
		this.init();
		//this.load({params:{start:0, limit:this.tam_pag}});
		
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
		
		this.addButton('btnWizard',
            {
                text: 'Plantilla',
                iconCls: 'bchecklist',
                disabled: false,
                handler: this.loadWizard,
                tooltip: '<b>Plantilla de Comprobantes</b><br/>Seleccione una plantilla y genere comprobantes preconfigurados'
            }
        );
		
		this.bloquearOrdenamientoGrid();
		
		
        
        this.cmbDepto.on('clearcmb', function(){
        	this.DisableSelect();
		    this.store.removeAll();
        },this);
        
        this.cmbDepto.on('valid', function(){
			this.capturaFiltros();
		    
        },this);
		
		
		this.iniciarEventos();
	},
	
	loadWizard:function() {
            var rec=this.sm.getSelected();
            Phx.CP.loadWindows('../../../sis_contabilidad/vista/int_comprobante/WizardCbte.php',
                    'Generar comprobante desde plantilla ...',
                    {
                        width:'40%',
                        height:300
                    },
                    rec,
                    this.idContenedor,
                    'WizardCbte'
        )
    },
	
	capturaFiltros:function(combo, record, index){
        this.desbloquearOrdenamientoGrid();
        this.store.baseParams.id_deptos = this.cmbDepto.getValue();
        this.store.baseParams.nombreVista = this.nombreVista
        this.load(); 
    },
    
    validarFiltros:function(){
        if(this.cmbDepto.validate()){
            return true;
        }
        else{
            return false;
        }
    },
    onButtonAct:function(){
    	if(!this.validarFiltros()){
            alert('Especifique los filtros antes')
        }
    },
	iniciarEventos:function(){
		
		//Eventos
		this.Cmp.id_moneda.on('select',this.getTipoCambio,this);
		this.Cmp.fecha.on('select',this.getTipoCambio,this);		
		this.Cmp.id_clase_comprobante.on('select', this.habilitaMomentos,this);		
		
		this.Cmp.id_tipo_relacion_comprobante.on('valid', 
		   function(){
		   	  if(this.Cmp.id_tipo_relacion_comprobante.getValue()){
		   	  	this.Cmp.id_int_comprobante_fks.allowBlank = false;
		   	  	this.Cmp.id_int_comprobante_fks.enable();
		   	  }
		   	  else{
		   	  	this.Cmp.id_int_comprobante_fks.allowBlank = true;
		   	  	this.Cmp.id_int_comprobante_fks.reset();
		   	  	this.Cmp.id_int_comprobante_fks.disable();
		   	  }
		   	  
		   	
		   },this);	
		
		
		
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
			id_grupo: 0,
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_periodo'
			},
			type:'Field',
			id_grupo: 0,
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_subsistema'
			},
			type:'Field',
			id_grupo: 0,
			form: true 
		},
		
		{
			config: {
				name: 'manual',
				fieldLabel: 'Manual',
				gwidth: 50,
					renderer:function (value,p,record){
							if(value == 'si'){
								return String.format('<b><font color="green">{0}</font></b>', value);
							}
							else{
								return String.format('<b><font color="orange">{0}</font></b>', value);
							}
					 }
			},
			type: 'Field',
			id_grupo: 0,
			filters: {pfiltro: 'incbte.manual',type: 'string'},
			grid: true,
			form: false
		},
		{
			config:{
				name: 'nro_cbte',
				fieldLabel: 'Nro.Cbte.',
				emptyText: 'Nro. de Cbte.'
			},
			type:'Field',
			filters:{pfiltro:'incbte.nro_cbte',type:'string'},
			id_grupo:0,
			bottom_filter: true,
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
			id_grupo:2,
			grid:true,
			form:true
		},
		{
   			config:{
   				name:'id_depto',
   				 hiddenName: 'id_depto',
   				 url: '../../sis_parametros/control/Depto/listarDeptoFiltradoXUsuario',
	   				origen:'DEPTO',
	   				allowBlank:false,
	   				fieldLabel: 'Depto',
	   				gdisplayField:'desc_depto',//dibuja el campo extra de la consulta al hacer un inner join con orra tabla
	   				width:250,
   			        gwidth:180,
	   				baseParams:{estado:'activo',codigo_subsistema:'CONTA'},//parametros adicionales que se le pasan al store
	      			renderer:function (value, p, record){return String.format('{0}', record.data['desc_depto']);}
   			},
   			//type:'TrigguerCombo',
   			type:'ComboRec',
   			id_grupo:0,
   			filters:{pfiltro:'incbte.desc_depto',type:'string'},
   		    grid:false,
   			form:true
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
					fields: ['id_clase_comprobante', 'tipo_comprobante', 'descripcion','codigo','momento_comprometido','momento_ejecutado','momento_pagado'],
					remoteSort: true,
					baseParams: {par_filtro: 'ccom.tipo_comprobante#ccom.descripcion'}
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
				width:250,
				anchor: '100%',
				gwidth: 150,
				minChars: 2,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['desc_clase_comprobante']);
				}
			},
			type: 'ComboBox',
			id_grupo: 1,
			filters: {pfiltro: 'incbte.desc_clase_comprobante',type: 'string'},
			grid: true,
			form: true
		},
		{
			config:{
				name: 'momento',
				fieldLabel: 'Tipo',
				qtip: 'Si el comprobante es presupuestario es encesario especificar los momentos que utiliza',
				allowBlank: false,
				gwidth: 100,
				width:250,
				typeAhead: true,
       		    triggerAction: 'all',
       		    lazyRender: true,
       		    mode: 'local',
       		    valueField: 'inicio',       		    
       		    store: ['contable','presupuestario']
			},
			type: 'ComboBox',
			id_grupo: 1,
			filters: {	
	       		         type: 'list',
	       				 pfiltro:'incbte.momento',
	       				 options: ['contable','presupuestario'],	
	       		 	},
			grid: true,
			form: false
		},
		{
			config:{
				name: 'momento_comprometido',
				fieldLabel: 'Comprometido',
				renderer : function(value, p, record) {
					return record.data['momento_comprometido']=='true'?'si':'no';
				},
				gwidth: 50,
				
			},
			type:'Checkbox',
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'momento_ejecutado',
				fieldLabel: 'Ejecutado',
				renderer : function(value, p, record) {
					return record.data['momento_ejecutado']=='true'?'si':'no';
				},
				gwidth: 50,
				
			},
			type:'Checkbox',
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'momento_pagado',
				fieldLabel: 'Pagado',
				renderer : function(value, p, record) {
					return record.data['momento_pagado']=='true'?'si':'no';
				},
				gwidth: 50,
				
			},
			type:'Checkbox',
			id_grupo:1,
			grid:true,
			form:true
		},
	   {
			config: {
				name: 'id_tipo_relacion_comprobante',
				fieldLabel: 'Tipo Rel.',
				qtip: 'Tipo de relacion entre comprobantes',
				allowBlank: true,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_contabilidad/control/TipoRelacionComprobante/listarTipoRelacionComprobante',
					id: 'id_tipo_relacion_comprobante',
					root: 'datos',
					sortInfo: {
						field: 'id_tipo_relacion_comprobante',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_tipo_relacion_comprobante', 'codigo', 'nombre'],
					remoteSort: true,
					baseParams: {par_filtro: 'tiprelco.nombre#tiprelco.codigo'}
				}),
				valueField: 'id_tipo_relacion_comprobante',
				displayField: 'nombre',
				gdisplayField: 'desc_tipo_relacion_comprobante',
				hiddenName: 'id_tipo_relacion_comprobante',
				//forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				width:250,
				anchor: '100%',
				gwidth: 150,
				minChars: 2,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['desc_tipo_relacion_comprobante']);
				}
			},
			type: 'ComboBox',
			id_grupo: 1,
			filters: {pfiltro: 'incbte.desc_tipo_relacion_comprobante',type: 'string'},
			grid: true,
			form: true
		},
	   {
			config: {
				name: 'id_int_comprobante_fks',
				enableMultiSelect:true,
				fieldLabel: 'Cbte rels.',
				qtip: 'Comprobantes relacionados',
				allowBlank: true,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_contabilidad/control/IntComprobante/listarSimpleIntComprobante',
					id: 'id_int_comprobante',
					root: 'datos',
					sortInfo: {
						field: 'id_int_comprobante',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: [ 'id_int_comprobante','nro_cbte','nro_tramite',
                               'fecha','glosa1','glosa2','id_clase_comprobante', 'codigo', 'descripcion'],
					remoteSort: true,
					baseParams: {par_filtro: 'inc.nro_cbte#inc.fecha#inc.glosa1#inc.glosa2#inc.nro_tramite'}
				}),
				//tpl: '<tpl for="."><div class="awesomecombo-item {checked}"><p>{nro_cbte}</p>Fecha: <strong>{fecha}</strong>{nro_tramite}<p>{glosa1}<p> </div></tpl>',
				
				tpl: new Ext.XTemplate(
				'<tpl for="."><div class="awesomecombo-3item {checked}">',
				'<p>{nro_cbte}</p>Fecha: <strong>{fecha}</strong>{nro_tramite}<p>{glosa1}<p>',
				
				'</div></tpl>'),
				itemSelector: 'div.awesomecombo-3item',
				
				valueField: 'id_int_comprobante',
				displayField: 'nro_cbte',
				gdisplayField: 'desc_comprobante_rel',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				width:250,
				anchor: '100%',
				gwidth: 150,
				minChars: 2,
				resizable:true,				
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['desc_tipo_relacion_comprobante']);
				}
			},
			type: 'AwesomeCombo',
			id_grupo: 1,
			grid: false,
			form: true
		},
		
        {
            config:{
                name:'id_moneda',
                origen:'MONEDA',
                allowBlank:false,
                fieldLabel:'Moneda',
                gdisplayField:'desc_moneda',//mapea al store del grid
                gwidth:100,
                width:250,
                renderer:function (value, p, record){return String.format('{0}', record.data['desc_moneda']);}
             },
            type:'ComboRec',
            id_grupo:2,
            filters:{   
                pfiltro:'incbte.desc_moneda',
                type:'string'
            },
            grid:true,
            form:true
        },
		{
			config:{
				name: 'tipo_cambio',
				fieldLabel: 'Tipo Cambio',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:20,
				decimalPrecision:6
			},
			type:'NumberField',
			filters:{pfiltro:'incbte.tipo_cambio',type:'numeric'},
			id_grupo:2,
			grid:true,
			form:true
		},
		{
			config: {
				name: 'nro_tramite',
				gwidth: 150,
				fieldLabel: 'Nro. Trámite'
			},
			type: 'Field',
			id_grupo: 0,
			filters: {pfiltro: 'incbte.nro_tramite',type: 'string'},
			grid: true,
			bottom_filter: true,
			form: false
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
			filters: { pfiltro:'incbte.glosa1', type:'string' },
			id_grupo: 0,
			bottom_filter: true,
			grid: true,
			form: true
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
			bottom_filter: true,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'beneficiario',
				fieldLabel: 'Beneficiario',
				allowBlank: false,
				anchor: '100%',
				gwidth: 250,
				maxLength:100
			},
			type:'TextField',
			filters:{pfiltro:'incbte.beneficiario',type:'string'},
			id_grupo:0,
			bottom_filter: true,
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
	   			id_grupo:0,
	   			filters:{	
			        pfiltro:'incbte.desc_firma1',
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
	   			id_grupo:0,
	   			filters:{	
			        pfiltro:'incbte.desc_firma2',
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
	   			id_grupo:0,
	   			filters:{	
			        pfiltro:'incbte.desc_firma3',
					type:'string'
				},
	   			grid:true,
	   			form:true
	   	},
	   	{
			config:{
				name: 'cbte_cierre',
				qtip: 'Es un comprobante de cierre?',
				fieldLabel: 'Cierre',
				allowBlank: false,
                gwidth: 80,
                width: 80,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                
                mode: 'local',
                store:['no' ,'balance','resultado']
            },
            type:'ComboBox',
			filters:{pfiltro:'incbte.incluir_cierre',type:'string'},
			valorInicial: 'no',
			id_grupo:0,
			grid:true,
			egrid: true,
			form:true
		},
		{
			config: {
				name: 'cbte_apertura',
				qtip: 'Es un comprobante de apertura',
				fieldLabel: 'Apertura',
				allowBlank: false,
                gwidth: 80,
                width: 80,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store: ['no' ,'si']
            },
            type:'ComboBox',
			filters: { pfiltro: 'incbte.cbte_apertura', type: 'string' },
			valorInicial: 'no',
			id_grupo: 0,
			grid: true,
			egrid: true,
			form: true
		},
		{
			config: {
				name: 'cbte_aitb',
				qtip: 'es un comprobante para AITB',
				fieldLabel: 'AITBs',
				allowBlank: false,
                gwidth: 80,
                width: 80,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store: ['no' ,'si']
            },
            type:'ComboBox',
			filters: { pfiltro: 'incbte.cbte_aitb', type: 'string' },
			valorInicial: 'no',
			id_grupo: 0,
			grid: true,
			egrid: true,
			form: true
		},
		{
			config:{
				name: 'estado_reg',
				fieldLabel: 'Estado',
				emptyText: 'Estado Reg.'
			},
			type:'Field',
			filters:{pfiltro:'incbte.estado_reg',type:'string'},
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
				filters:{pfiltro:'incbte.usr_reg',type:'string'},
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
				filters: { pfiltro: 'incbte.usr_mod', type: 'string'},
				id_grupo: 0,
				grid: true,
				form: false
		},
		{
			config:{
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				format: 'd/m/Y', 
				renderer:function (value,p,record){ return value?value.dateFormat('d/m/Y H:i:s'):'' }
			},
				type:'DateField',
				filters:{pfiltro:'incbte.fecha_mod',type:'date'},
				id_grupo:0,
				grid:true,
				form:false
		}
	],
	
	 Grupos: [
            {
                layout: 'column',
                border: false,
                defaults: {
                   border: false
                },            
                items: [{
					        bodyStyle: 'padding-right:5px;',
					        items: [{
					            xtype: 'fieldset',
					            title: 'Datos principales',
					            autoHeight: true,
					            columns: 1,
					            items: [],
						        id_grupo:0
					        }]
					    }, {
					        bodyStyle: 'padding-left:5px;',
					        items: [{
					            xtype: 'fieldset',
					            columns: 2,
					            //layout: 'hbox',
					            title: 'Tipo  Comprobante',
					            autoHeight: true,
					            items: [],
						        id_grupo:1
					        }]
					    }, {
					        bodyStyle: 'padding-left:5px;',
					        items: [{
					            xtype: 'fieldset',
					            columns: 2,
					            //layout: 'hbox',
					            title: 'Tipo de Cambio',
					            autoHeight: true,
					            items: [],
						        id_grupo:2
					        }]
					    }]
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
		{name:'desc_firma3', type: 'string'},
		'momento_comprometido',
        'momento_ejecutado','id_moneda_base','cbte_cierre','cbte_apertura','cbte_aitb',
        'momento_pagado','manual','desc_tipo_relacion_comprobante','id_int_comprobante_fks','manual','id_tipo_relacion_comprobante'
	],
	
	rowExpander: new Ext.ux.grid.RowExpander({
	        tpl : new Ext.Template(
	            '<br>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Departamento:&nbsp;&nbsp;</b> {desc_depto} </p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Clase cbte:&nbsp;&nbsp;</b> {desc_clase_comprobante}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Origen:&nbsp;&nbsp;</b> {desc_subsistema}</p>',	           
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Beneficiario:&nbsp;&nbsp;</b> {beneficiario}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Glosa:&nbsp;&nbsp;</b> {glosa1} {glosa2}</p>',
	            
	             '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Frima 1:&nbsp;&nbsp;</b> {desc_firma1} </p>',
	              '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Firma 2:&nbsp;&nbsp;</b> {desc_firma2} </p>',
	              '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Firma 3:&nbsp;&nbsp;</b> {desc_firma3} </p>',
	            
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Creado por:&nbsp;&nbsp;</b> {usr_reg}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Estado Registro:&nbsp;&nbsp;</b> {estado_reg}</p><br>'
	        )
    }),
    
    arrayDefaultColumHidden:[ 'id_funcionario_firma1','id_funcionario_firma2','id_funcionario_firma3','id_subsistema','id_tipo_relacion_comprobante','momento_comprometido','momento_ejecutado','momento_pagado','fecha_mod','usr_reg','usr_mod','id_depto','estado','glosa1','id_clase_comprobante','momento','glosa2','desc_subsistema','desc_clase_comprobante','estado_reg','fecha_reg'],

	
	sortInfo:{
		field: 'fecha',
		direction: 'desc'
	},
	bdel: true,
	bsave: false,
	cmbDepto: new Ext.form.AwesomeCombo({
                name: 'id_depto',
                fieldLabel: 'Depto',
                typeAhead: false,
                forceSelection: true,
                allowBlank: false,
                disableSearchButton: true,
                emptyText: 'Depto Contable',
                store: new Ext.data.JsonStore({
                    url: '../../sis_parametros/control/Depto/listarDeptoFiltradoDeptoUsuario',
                    id: 'id_depto',
					root: 'datos',
					sortInfo:{
						field: 'deppto.nombre',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_depto','nombre','codigo'],
					// turn on remote sorting
					remoteSort: true,
					baseParams: { par_filtro:'deppto.nombre#deppto.codigo', estado:'activo', codigo_subsistema: 'CONTA'}
                }),
                valueField: 'id_depto',
   				displayField: 'nombre',
   				hiddenName: 'id_depto',
                enableMultiSelect: true,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'remote',
                pageSize: 20,
                queryDelay: 200,
                anchor: '80%',
                listWidth:'280',
                resizable:true,
                minChars: 2
            }),
            
            
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
	
	
	
	habilitaMomentos: function(combo, record, index){
		//si es solo contable coloco en falo los momentos y los deshabilita
		if(record.data.tipo_comprobante == 'contable'){
			
			this.Cmp.momento_ejecutado.setValue(false);
			this.Cmp.momento_pagado.setValue(false);
			
			this.Cmp.momento_ejecutado.disable();
			this.Cmp.momento_pagado.disable();
			
		}
		else{
			
			//ejecutado
			if(record.data.momento_ejecutado == 'opcional'){
				this.Cmp.momento_ejecutado.enable();
			}
			if(record.data.momento_ejecutado == 'obligatorio'){
				this.Cmp.momento_ejecutado.setValue(true);
				this.Cmp.momento_ejecutado.disable();
			}
			if(record.data.momento_ejecutado == 'no_permitido'){
				this.Cmp.momento_ejecutado.setValue(false);
				this.Cmp.momento_ejecutado.disable();
			}
			//pagado
			if(record.data.momento_pagado == 'opcional'){
				this.Cmp.momento_pagado.enable();
			}
			if(record.data.momento_pagado == 'obligatorio'){
				this.Cmp.momento_pagado.setValue(true);
				this.Cmp.momento_pagado.disable();
			}
			if(record.data.momento_pagado == 'no_permitido'){
				this.Cmp.momento_pagado.setValue(false);
				this.Cmp.momento_pagado.disable();
			}
			
		}
		
		//si es presupeustario acomoda los valores por defecto a los momentos
		
	},
	imprimirCbte: function(){
		//Ext.Msg.confirm('Confirmación','¿Está seguro de Imprimir el Comprobante?',function(btn){
			var rec = this.sm.getSelected();
			
			var data = rec.data;
			if (data) {
				Phx.CP.loadingShow();
				Ext.Ajax.request({
						//url : '../../sis_contabilidad/control/IntComprobante/reporteComprobante',
						url : '../../sis_contabilidad/control/IntComprobante/reporteCbte',
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
		
		