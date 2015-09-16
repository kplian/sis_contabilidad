<?php
/**
*@package pXP
*@file gen-BancaCompraVenta.php
*@author  (admin)
*@date 11-09-2015 14:36:46
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.BancaCompraVenta=Ext.extend(Phx.gridInterfaz,{

tabEnter: true,
	constructor:function(config){
		
	
		
		var dia = 01;
		var mes = 01;
		var anio = 2015;
		var fecha_fin = '01/01/2016';
		
		this.initButtons=[this.cmbDepto, this.cmbTipo, this.cmbGestion, this.cmbPeriodo];
		
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.BancaCompraVenta.superclass.constructor.call(this,config);
		
		this.cmbGestion.on('select', function(combo, record, index){
			this.tmpGestion = record.data.gestion;
		    this.cmbPeriodo.enable();
		    this.cmbPeriodo.reset();
		    this.store.removeAll();
		    this.cmbPeriodo.store.baseParams = Ext.apply(this.cmbPeriodo.store.baseParams, {id_gestion: this.cmbGestion.getValue()});
		    this.cmbPeriodo.modificado = true;
		    
		    anio = record.data.gestion;
		    var fecha = new Date(mes+'/'+dia+'/'+anio);
			
			this.getComponente('fecha_documento').setMinValue(fecha);
 			this.getComponente('fecha_documento').setMaxValue(fecha_fin);
		    
		    
        },this);
        
        this.cmbPeriodo.on('select', function( combo, record, index){
			this.tmpPeriodo = record.data.periodo;
			this.capturaFiltros();
			
			 mes = record.data.periodo;
			 console.log(mes);
		    var fecha = new Date(mes+'/'+dia+'/'+anio);
		    fecha_fin = new Date(mes+'/'+dia+'/'+anio);
		    //fecha_fin.setDate(fecha_fin.getMonth() + 1);
		    fecha_fin.setMonth(fecha_fin.getMonth() + 1);
		    fecha_fin.setDate(fecha_fin.getDate() - 1);
		    console.log(fecha);
		    console.log(fecha_fin);
			
			this.getComponente('fecha_documento').setMinValue(fecha);
 			this.getComponente('fecha_documento').setMaxValue(fecha_fin);
			
			
		    
        },this);
        
        this.cmbDepto.on('select', function( combo, record, index){
			this.capturaFiltros();
		    
        },this);
        
        this.cmbTipo.on('select', function( combo, record, index){
			if(this.cmbTipo.getValue() == 'Compras'){
				console.log('compras');
				this.Cmp.tipo_transaccion.show()
			}else{
				console.log('ventas');
				this.Cmp.tipo_transaccion.hide();
			}
		    
        },this);
        
        
      
        
       
        
        this.getComponente('fecha_documento').setMinValue('01/02/2015');
 		this.getComponente('fecha_documento').setMaxValue('10/03/2015');
        
        
		this.init();
		this.grid.addListener('cellclick', this.oncellclick,this);
		
		this.iniciarEventos();
		
		this.addButton('exportar',{argument: {imprimir: 'exportar'},text:'<i class="fa fa-file-text-o fa-2x"></i> Generar TXT',/*iconCls:'' ,*/disabled:false,handler:this.exportar});

		//this.load({params:{start:0, limit:this.tam_pag}})
	},
	
	
	capturaFiltros:function(combo, record, index){
        this.desbloquearOrdenamientoGrid();
        if(this.validarFiltros()){
        	this.store.baseParams.id_gestion = this.cmbGestion.getValue();
	        this.store.baseParams.id_periodo = this.cmbPeriodo.getValue();
	        this.store.baseParams.id_depto = this.cmbDepto.getValue();
	        this.store.baseParams.tipo = this.cmbTipo.getValue();
	        this.load(); 
        }
        
    },
    
    validarFiltros:function(){
        if(this.cmbDepto.getValue() && this.cmbGestion.validate() && this.cmbPeriodo.validate()){
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
    
    
    
    cmbTipo : new Ext.form.ComboBox({
    	
				name: 'tipo',
				fieldLabel: 'tipo',
				allowBlank: true,
				emptyText: 'tipo...',
				typeAhead: true,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'local',
				store: ['Compras', 'Ventas'],
				width: 200,
				type: 'ComboBox',

    }),
    cmbDepto: new Ext.form.ComboBox({
                name: 'id_depto',
                fieldLabel: 'Depto',
                blankText: 'Depto',
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
    
	cmbGestion: new Ext.form.ComboBox({
				fieldLabel: 'Gestion',
				allowBlank: false,
				emptyText:'Gestion...',
				blankText: 'Año',
				store:new Ext.data.JsonStore(
				{
					url: '../../sis_parametros/control/Gestion/listarGestion',
					id: 'id_gestion',
					root: 'datos',
					sortInfo:{
						field: 'gestion',
						direction: 'DESC'
					},
					totalProperty: 'total',
					fields: ['id_gestion','gestion'],
					// turn on remote sorting
					remoteSort: true,
					baseParams:{par_filtro:'gestion'}
				}),
				valueField: 'id_gestion',
				triggerAction: 'all',
				displayField: 'gestion',
			    hiddenName: 'id_gestion',
    			mode:'remote',
				pageSize:50,
				queryDelay:500,
				listWidth:'280',
				width:80
			}),
	
	
     cmbPeriodo: new Ext.form.ComboBox({
				fieldLabel: 'Periodo',
				allowBlank: false,
				blankText : 'Mes',
				emptyText:'Periodo...',
				store:new Ext.data.JsonStore(
				{
					url: '../../sis_parametros/control/Periodo/listarPeriodo',
					id: 'id_periodo',
					root: 'datos',
					sortInfo:{
						field: 'periodo',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_periodo','periodo','id_gestion'],
					// turn on remote sorting
					remoteSort: true,
					baseParams:{par_filtro:'gestion'}
				}),
				valueField: 'id_periodo',
				triggerAction: 'all',
				displayField: 'periodo',
			    hiddenName: 'id_periodo',
    			mode:'remote',
				pageSize:50,
				disabled: true,
				queryDelay:500,
				listWidth:'280',
				width:80
			}),
	
	
	iniciarEventos:function(){
		this.Cmp.tipo_documento_pago.on('select', function(combo, record, index){ 
			console.log(this.Cmp.tipo_documento_pago.getValue());
		}, this);
		
		this.Cmp.autorizacion.on('change', function(combo, record, index){ 
			Ext.Ajax.request({
				url: '../../sis_contabilidad/control/BancaCompraVenta/listarBancaCompraVenta',
				params: {'autorizacion': ''+this.Cmp.autorizacion.getValue()+'','start':'0','limit':'1000',"sort":"id_banca_compra_venta","dir":"ASC"},
				success: this.verAutorizacion,
				failure: this.conexionFailure,
				timeout: this.timeout,
				scope: this
			});
		
		}, this);
		
		
	},
	
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_banca_compra_venta'
			},
			type:'Field',
			form:true 
		},
		
		 {
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_depto_conta'
			},
			type:'Field',
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
			form:true 
		},
		
		 {
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'tipo'
			},
			type:'Field',
			form:true 
		},
		
		{
			config:{
				name: 'revisado',
				fieldLabel: 'Revisado',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:3,
                renderer: function (value, p, record, rowIndex, colIndex){  
                	     
            	       //check or un check row
            	       var checked = '',
            	       	    momento = 'no';
            	       	    console.log(value);
                	   if(value == 'si'){
                	        	checked = 'checked';;
                	   }
            	       return  String.format('<div style="vertical-align:middle;text-align:center;"><input style="height:37px;width:37px;" type="checkbox"  {0}></div>',checked);
            	        
                 }
			},
			type: 'TextField',
			filters: { pfiltro:'dcv.revisado',type:'string'},
			id_grupo: 1,
			grid: true,
			form: false
		},
		
		
		
		{
			config: {
				name: 'modalidad_transaccion',
				fieldLabel: 'Modalidad transacción ',
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
			config:{
				name: 'fecha_documento',
				fieldLabel: 'Fecha factura /fecha documento ',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''},
							
						    
			},
				type:'DateField',
				filters:{pfiltro:'banca.fecha_documento',type:'date'},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
			config: {
				name: 'tipo_transaccion',
				fieldLabel: 'Tipo de transacción',
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
			config:{
				name: 'autorizacion',
				fieldLabel: 'Nº autorización  factura/ documento ',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100
			},
				type:'NumberField',
				filters:{pfiltro:'banca.autorizacion',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
			},
		
		{
			config:{
				name: 'nit_ci',
				fieldLabel: 'NIT/CI proveedor',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			},
				type:'TextField',
				filters:{pfiltro:'banca.nit_ci',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'razon',
				fieldLabel: 'Nombre/razón social proveedor',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			},
				type:'TextField',
				filters:{pfiltro:'banca.razon',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'num_documento',
				fieldLabel: 'Nº de factura/ N° documento ',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			},
				type:'TextField',
				filters:{pfiltro:'banca.num_documento',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'num_contrato',
				fieldLabel: 'Nº de contrato ',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			},
				type:'TextField',
				filters:{pfiltro:'banca.num_contrato',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'importe_documento',
				fieldLabel: 'Importe factura/ importe documento',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:655362
			},
				type:'NumberField',
				filters:{pfiltro:'banca.importe_documento',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		
		{
			config:{
				name: 'num_cuenta_pago',
				fieldLabel: 'N° de cuenta del documento de pago',
				allowBlank: true,
				anchor: '80%',
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
				fieldLabel: 'Monto pagado en documento de pag',
				allowBlank: true,
				anchor: '80%',
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
				anchor: '80%',
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
				name: 'nit_entidad',
				fieldLabel: 'NIT Entidad Financiera ',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100
			},
				type:'NumberField',
				filters:{pfiltro:'banca.nit_entidad',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'num_documento_pago',
				fieldLabel: 'N° documento de pago (Nº transacción u operación) ',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			},
				type:'TextField',
				filters:{pfiltro:'banca.num_documento_pago',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		
		
		


		
		
		
		
		
		{
			config: {
				name: 'tipo_documento_pago',
				fieldLabel: 'Tipo de documento de pago',
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
					baseParams: {par_filtro: 'confba.descripcion#confba.tipo',tipo:'Tipo de documento de pago'}
				}),
				valueField: 'digito',
				displayField: 'descripcion',
				gdisplayField: 'desc_tipo_documento_pago',

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
					return String.format('{0}', record.data['desc_tipo_documento_pago']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'confba.descripcion',type: 'string'},
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
				filters:{pfiltro:'banca.estado_reg',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'fecha_de_pago',
				fieldLabel: 'Fecha del documento de pago  ',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'banca.fecha_de_pago',type:'date'},
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
				filters:{pfiltro:'banca.fecha_reg',type:'date'},
				id_grupo:1,
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
				name: 'id_usuario_ai',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'banca.id_usuario_ai',type:'numeric'},
				id_grupo:1,
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
				filters:{pfiltro:'banca.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'bancarizacion',
	ActSave:'../../sis_contabilidad/control/BancaCompraVenta/insertarBancaCompraVenta',
	ActDel:'../../sis_contabilidad/control/BancaCompraVenta/eliminarBancaCompraVenta',
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
	
		
		
	],
	sortInfo:{
		field: 'id_banca_compra_venta',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
	
	oncellclick : function(grid, rowIndex, columnIndex, e) {
		
     	var record = this.store.getAt(rowIndex),
	        fieldName = grid.getColumnModel().getDataIndex(columnIndex); // Get field name
     	
     	if(fieldName == 'revisado') {
	       	//if(record.data['revisado'] == 'si'){
	       	   this.cambiarRevision(record);
	       //	}
	    }
     },
     cambiarRevision: function(record){
		Phx.CP.loadingShow();
	    var d = record.data
	    console.log(d)
        Ext.Ajax.request({
            url:'../../sis_contabilidad/control/BancaCompraVenta/cambiarRevision',
            params:{ id_banca_compra_venta: d.id_banca_compra_venta,revisado:d.revisado},
            success: this.successRevision,
            failure: this.conexionFailure,
            timeout: this.timeout,
            scope: this
        }); 
	},
	successRevision: function(resp){
       Phx.CP.loadingHide();
       var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
       if(reg.datos = 'correcto'){
         this.reload();
       }
    },
     
	 onButtonAct:function(){
        if(!this.validarFiltros()){
            alert('Especifique el año y el mes antes')
         }
        else{
            this.store.baseParams.id_gestion=this.cmbGestion.getValue();
            this.store.baseParams.id_periodo = this.cmbPeriodo.getValue();
            this.store.baseParams.id_depto = this.cmbDepto.getValue();
            this.store.baseParams.tipo = this.cmbTipo.getValue();
            
            Phx.vista.BancaCompraVenta.superclass.onButtonAct.call(this);
        }
    },
    
    onButtonNew:function(){
     	
     	
     	if(!this.validarFiltros()){
            alert('Especifique el año y el mes antes')
        }
        else{
        	this.accionFormulario = 'NEW';
            Phx.vista.BancaCompraVenta.superclass.onButtonNew.call(this);//habilita el boton y se abre
            this.Cmp.id_depto_conta.setValue(this.cmbDepto.getValue()); 
            this.Cmp.id_periodo.setValue(this.cmbPeriodo.getValue()); 
            this.Cmp.tipo.setValue(this.cmbTipo.getValue()); 
        }
    },
    
    
    exportar:function(){
			var rec = this.cmbPeriodo.getValue();
			var tipo = this.cmbTipo.getValue();

			console.log(rec);


			
			Ext.Ajax.request({
				url:'../../sis_contabilidad/control/BancaCompraVenta/exporta_txt',
				params:{'id_periodo':rec,'tipo':tipo,'start':0,'limit':150},
				success: this.successExport,
				failure: this.conexionFailure,
				timeout:this.timeout,
				scope:this
			});
		},
		successExport: function (resp) {
			//Phx.CP.loadingHide();
			console.log('resp' , resp)

			//doc.write(texto);
			var objRes = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));

			console.log(objRes.datos)
			//console.log(objRes.ROOT.datos[0].length)

			var texto = objRes.datos;
			  var link = document.createElement("a");
			  link.download = texto;
			  // Construct the uri
			  link.href = "/kerp_capacitacion/sis_contabilidad/reportes/banca_periodos/"+texto+".txt";
			  document.body.appendChild(link);
			  link.click();
			  // Cleanup the DOM
			  document.body.removeChild(link);
			  delete link;


		},
		verAutorizacion:function(resp){
			
			var objRes = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
			var datos = objRes.datos;
			
			
			if(datos[0] != undefined){
				this.Cmp.nit_ci.setValue(datos[0].nit_ci);
				this.Cmp.razon.setValue(datos[0].razon);
			}
			
		}
    
    
	}
)
</script>
		
		