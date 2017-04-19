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
tipoBan: 'Compras',
fheight: '80%',
    fwidth: '95%',
	constructor:function(config){
		
	
	
	
	this.tbarItems = ['-',
			this.cmbResolucion,
			
           ];
	
		
		var dia = 01;
		var mes = 01;
		var anio = 2015;
		var fecha_fin = '01/01/2016';
		
		this.initButtons=[this.cmbDepto, this.cmbGestion, this.cmbPeriodo];
		
		
		
		
		this.monto_acumulado_aux = 0;
		this.contrato;
		this.Grupos = [
		            {
		                layout: 'column',
		                border: false,
		                autoHeight : true,
		                defaults: {
		                    border: false,
                            bodyStyle: 'padding:4px'
		                },            
		                items: [
		                              {
		                                xtype: 'fieldset',
		                                columnWidth: 0.5,
		                                defaults: {
								            anchor: '-20' // leave room for error icon
								        },
		                                title: 'Datos del Documento',
		                                items: [],
		                                id_grupo: 0,
		                                flex:1,
		                                autoHeight : true,
		                                margins:'2 2 2 2'
		                             },
		                              
		                            {
		                                xtype: 'fieldset',
		                                columnWidth: 0.5,
		                                title: 'Detalle del Pago',
		                                items: [],
		                                margins:'2 10 2 2',
		                                id_grupo:1,
		                                autoHeight : true,
		                                flex:1
		                            },
		                             {
		                                xtype: 'fieldset',
		                                columnWidth: 0.5,
		                                title: 'Detalle del Pago2',
		                                items: [],
		                                margins:'2 10 2 2',
		                                id_grupo:2,
		                                autoHeight : true,
		                                flex:1
		                             }
		               ]   
		     }];
		
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.BancaCompraVenta.superclass.constructor.call(this,config);
		
		 var fieldset = this.form.items.items[0].items.items[1];
		
		 
		 fieldset.add({
         	xtype:'button',
         	text:'<i class="fa fa-file"></i> Ver Historial Acumulado',
         	scope:this,
         	handler:this.acumulado
         	
         });
         fieldset.doLayout(); 
         
		this.cmbResolucion.on('select', function(combo, record, index){
		    this.tmpResolucion = record.data.field1;
		    this.capturaFiltros();
        },this);
		
		this.cmbGestion.on('select', function(combo, record, index){
			this.tmpGestion = record.data.gestion;
		    this.cmbPeriodo.enable();
		    this.cmbPeriodo.reset();
		    this.store.removeAll();
		    this.cmbPeriodo.store.baseParams = Ext.apply(this.cmbPeriodo.store.baseParams, {id_gestion: this.cmbGestion.getValue()});
		    this.cmbPeriodo.modificado = true;
		    
		    /*anio = record.data.gestion;
		    var fecha = new Date(mes+'/'+dia+'/'+anio);
			
			this.getComponente('fecha_documento').setMinValue(fecha);
 			this.getComponente('fecha_documento').setMaxValue(fecha_fin);*/
		    
		    
        },this);
        
        
        this.cmbPeriodo.on('select', function( combo, record, index){
			this.tmpPeriodo = record.data.periodo;
			this.capturaFiltros();
			
			/* mes = record.data.periodo;
			 console.log(mes);
		    var fecha = new Date(mes+'/'+dia+'/'+anio);
		    fecha_fin = new Date(mes+'/'+dia+'/'+anio);
		    fecha_fin.setMonth(fecha_fin.getMonth() + 1);
		    fecha_fin.setDate(fecha_fin.getDate() - 1);
		    console.log(fecha);
		    console.log(fecha_fin);
			
			this.getComponente('fecha_documento').setMinValue(fecha);
 			this.getComponente('fecha_documento').setMaxValue(fecha_fin);*/
			
			
		    
        },this);
        
        this.cmbDepto.on('select', function( combo, record, index){
			this.capturaFiltros();
		    
        },this);
        
        /*this.cmbTipo.on('select', function( combo, record, index){
			if(this.cmbTipo.getValue() == 'Compras'){
				console.log('compras');
				this.Cmp.tipo_transaccion.show()
			}else{
				console.log('ventas');
				this.Cmp.tipo_transaccion.hide();
			}
		    
        },this);
        */
        
      
        
       
        
        
        
        
		this.init();
		this.grid.addListener('cellclick', this.oncellclick,this);
		
		this.iniciarEventos();
		
		 this.construyeVariablesContratos();
		 
		 
		 
		 
		 this.win_pago = new Ext.Window(
                    {
                        layout: 'fit',
                        width: 500,
                        height: 250,
                        modal: true,
                        closeAction: 'hide',

                        items: new Ext.FormPanel({
                            labelWidth: 75, // label settings here cascade unless overridden

                            frame: true,
                            // title: 'Factura Manual Concepto',
                            bodyStyle: 'padding:5px 5px 0',
                            width: 339,
                            defaults: {width: 191},
                            // defaultType: 'textfield',

                            items: [this.cmbGestion_retenciones
                                
                            ],

                            buttons: [{
                                text: 'Save',
                                handler: this.submitGenerarRetenciones,

                                scope: this
                            }, {
                                text: 'Cancel'
                            }]
                        }),

                    });
                    
		 
		this.addButton('btnChequeoDocumentosWf',
            {
                text: 'Documentos',
                grupo:[0,1,2],
                iconCls: 'bchecklist',
                disabled: false,
                handler: this.loadCheckDocumentosSolWf,
                tooltip: '<b>Documentos de la Solicitud</b><br/>Subir los documetos requeridos en la solicitud seleccionada.'
            }
        );
	
		 
		 this.addBotonesListaNegra();
		 this.addBotonesRetencionGarantias();
		 
		this.addButton('insertAuto',{argument: {imprimir: 'insertAuto'},text:'<i class="fa fa-file-text-o fa-2x"></i> insertAuto',/*iconCls:'' ,*/disabled:true,handler:this.insertAuto});


		 
		this.addButton('exportar',{argument: {imprimir: 'exportar'},text:'<i class="fa fa-file-text-o fa-2x"></i> Generar TXT - SIN',/*iconCls:'' ,*/disabled:true,handler:this.generar_txt});

		this.addButton('Importar',{argument: {imprimir: 'Importar'},text:'<i class="fa fa-file-text-o fa-2x"></i> Importar TXT',/*iconCls:'' ,*/disabled:true,handler:this.importar_txt});


		this.addButton('Acumulado',{argument: {imprimir: 'Acumulado'},text:'<i class="fa fa-file-text-o fa-2x"></i> Acumulado',/*iconCls:'' ,*/disabled:true,handler:this.acumulado});


		this.addButton('BorrarTodo',{argument: {imprimir: 'BorrarTodo'},text:'<i class="fa fa-file-text-o fa-2x"></i> BorrarTodo',/*iconCls:'' ,*/disabled:true,handler:this.BorrarTodo});



		this.addButton('Clonar',{argument: {imprimir: 'Clonar'},text:'<i class="fa fa-file-text-o fa-2x"></i> Clonar',/*iconCls:'' ,*/disabled:false,handler:this.Clonar});
		//this.addButton('airbp',{argument: {imprimir: 'airbp'},text:'<i class="fa fa-file-text-o fa-2x"></i> airbp',/*iconCls:'' ,*/disabled:false,handler:this.airbp});



		this.addButton('exportarGestionCompleta',{argument: {imprimir: 'exportarGestionCompleta'},text:'<i class="fa fa-file-text-o fa-2x"></i> Generar Gestion TXT - SIN',/*iconCls:'' ,*/disabled:false,handler:this.exportarGestionCompleta});


		//this.load({params:{start:0, limit:this.tam_pag}})
	},
	
	
	capturaFiltros:function(combo, record, index){
        this.desbloquearOrdenamientoGrid();
        if(this.validarFiltros()){
        	if(this.cmbResolucion.getValue() == 'todos'){
        		this.store.baseParams.resolucion = '';
        	}else{
        		this.store.baseParams.resolucion = this.cmbResolucion.getValue();

        	}
        	
        	
        	this.store.baseParams.id_gestion = this.cmbGestion.getValue();
	        this.store.baseParams.id_periodo = this.cmbPeriodo.getValue();
	        this.store.baseParams.id_depto = this.cmbDepto.getValue();
	        this.store.baseParams.tipo = this.tipoBan;
	        this.store.baseParams.acumulado = 'no';
	        this.load(); 
        }
        
    },
    
    validarFiltros:function(){
        if(this.cmbDepto.getValue() && this.cmbGestion.validate() && this.cmbPeriodo.validate()){
        	this.getBoton('insertAuto').enable();
        	this.getBoton('exportar').enable();
        	this.getBoton('Importar').enable();
        	this.getBoton('Acumulado').enable();
        	this.getBoton('BorrarTodo').enable();
            return true;
        }
        else{
        	this.getBoton('insertAuto').disable();
        	this.getBoton('exportar').disable();
        	this.getBoton('Importar').disable();
        	this.getBoton('Acumulado').disable();
        	this.getBoton('BorrarTodo').disable();
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
			
			cmbResolucion : new Ext.form.ComboBox({
    	
				name: 'resol',
				fieldLabel: 'resol',
				allowBlank: true,
				emptyText: 'resol...',
				typeAhead: true,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'local',
				store: ['10-0011-11', '10-0017-15','todos'],
				width: 200,
				type: 'ComboBox',

			}),
    
	
	
	
	
	
	
	cmbGestion_retenciones: new Ext.form.ComboBox({
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
			
	iniciarEventos:function(){
		this.Cmp.tipo_documento_pago.on('select', function(combo, record, index){ 
			//console.log(this.Cmp.tipo_documento_pago.getValue());
		}, this);
		
		/*this.Cmp.autorizacion.on('change', function(combo, record, index){ 
			Ext.Ajax.request({
				url: '../../sis_contabilidad/control/BancaCompraVenta/listarBancaCompraVenta',
				params: {'autorizacion': ''+this.Cmp.autorizacion.getValue()+'','start':'0','limit':'1000',"sort":"id_banca_compra_venta","dir":"ASC"},
				success: this.verAutorizacion,
				failure: this.conexionFailure,
				timeout: this.timeout,
				scope: this
			});
		
		}, this);*/
		
		
		this.Cmp.id_proveedor.on('select', function(combo, record, index){ 
			//console.log(record.data.desc_proveedor);
			
			var res = record.data.desc_proveedor.split("(");
			this.Cmp.nit_ci.setValue(record.data.nit);
			this.Cmp.razon.setValue(res[0]);
			
			
			this.Cmp.id_documento.store.setBaseParam('nro_nit', record.data.nit);
			
			
			this.Cmp.id_contrato.enable();
			this.Cmp.id_contrato.reset();
			this.Cmp.id_contrato.store.baseParams.filter = "[{\"type\":\"numeric\",\"comparison\":\"eq\", \"value\":\""+combo.getValue()+"\",\"field\":\"CON.id_proveedor\"}]";
			this.Cmp.id_contrato.modificado = true;
			
			
		}, this);
		
		this.Cmp.tipo_transaccion.on('select', function(combo, record, index){ 
			//console.log(record.data.desc_proveedor);
			if(record.data.digito == 2 || record.data.digito == 3){
				this.Cmp.autorizacion.setValue(4);
			}else{
				this.Cmp.autorizacion.setValue('');
			}
			
		}, this);
		
		
		this.Cmp.id_cuenta_bancaria.on('select', function(combo, record, index){ 
			
			if(this.Cmp.id_cuenta_bancaria.getValue() == 61){
				this.Cmp.tipo_documento_pago.reset();
				this.Cmp.tipo_documento_pago.store.baseParams.descripcion = "Transferencia de fondos";
				this.Cmp.tipo_documento_pago.modificado = true;
				
				
				this.Cmp.tipo_documento_pago.store.load({params:{start:0,limit:10},
					callback:function(){
					
					this.Cmp.tipo_documento_pago.setValue(4);
				 	}, scope : this
				}); 
				
			}else{
				this.Cmp.tipo_documento_pago.reset();
				this.Cmp.tipo_documento_pago.store.baseParams.descripcion = "Cheque de cualquier naturaleza";
				this.Cmp.tipo_documento_pago.modificado = true;
				
				this.Cmp.tipo_documento_pago.store.load({params:{start:0,limit:10},
					callback:function(){
					
					this.Cmp.tipo_documento_pago.setValue(1);
				 	}, scope : this
				}); 
				
			}
			this.Cmp.num_cuenta_pago.setValue(record.data.nro_cuenta);
			this.Cmp.nit_entidad.setValue(record.data.doc_id);
			
			
			
		}, this);
		
		this.Cmp.id_contrato.on('select', function(combo, record, index){ 
			
			
			
			//this.Cmp.id_contrato.setValue(record.data.id_contrato);
			this.Cmp.num_contrato.setValue(record.data.numero);
			
			this.Cmp.monto_contrato.setValue(record.data.monto);
			this.contrato = record.data;
			
			if(record.data.tipo_plazo == 'tiempo_indefinido' ){
				this.Cmp.acumulado.setValue('si');
				
				Ext.Ajax.request({
				url:'../../sis_contabilidad/control/BancaCompraVenta/listarBancaCompraVenta',
				params:{'id_contrato':record.data.id_contrato,'sort':'id_banca_compra_venta','dir':'DESC','start':0,'limit':1},
				success: this.successMontoAcumulado,
				failure: this.conexionFailure,
				timeout:this.timeout,
				scope:this
				});
			
			}else{
				this.Cmp.acumulado.setValue('no');
			}
			
			
			
		}, this);
		
		
		
		
		/*this.Cmp.monto_pagado.on('valid', function(combo, record, index){ 
			
			console.log(this.Cmp.monto_pagado.getValue())
			console.log(this.Cmp.monto_acumulado.getValue())
			console.log('aux',parseFloat(this.monto_acumulado_aux) + parseFloat(this.Cmp.monto_pagado.getValue()))
			this.Cmp.monto_acumulado.setValue(parseFloat(this.monto_acumulado_aux) + parseFloat(this.Cmp.monto_pagado.getValue()));
				
			
		}, this);*/
		
		
		this.Cmp.tipo_transaccion.on('select', function(combo, record, index){
			
			 this.Cmp.id_documento.modificado = true;
			if(this.Cmp.tipo_transaccion.getValue() == 1){
				this.Cmp.id_documento.store.setBaseParam('sw_libro_compras', 'libro_compras');
			} else if(this.Cmp.tipo_transaccion.getValue() == 2){
				this.Cmp.id_documento.store.setBaseParam('sw_libro_compras', 'retenciones');
			} else if(this.Cmp.tipo_transaccion.getValue() == 3){
				//this.Cmp.id_documento.store.reset();
				this.Cmp.id_documento.store.setBaseParam('sw_libro_compras', undefined);
				
			}
			
			

			
		}, this);
		
		this.Cmp.id_documento.on('select', function(combo, record, index){
			
			console.log(record)
			this.Cmp.fecha_documento.setValue(record.data.fecha_documento);
			this.Cmp.autorizacion.setValue(record.data.nro_autorizacion);
			this.Cmp.nit_ci.setValue(record.data.nro_nit);
			this.Cmp.razon.setValue(record.data.razon_social);
			this.Cmp.num_documento.setValue(record.data.nro_documento);
			this.Cmp.importe_documento.setValue(record.data.importe_total);
			
			

			
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
                	   if(value == 'si'){
                	        	checked = 'checked';;
                	   }
            	       return  String.format('<div style="vertical-align:middle;text-align:center;"><input style="height:37px;width:37px;" type="checkbox"  {0}></div>',checked);
            	        
                 }
			},
			type: 'TextField',
			filters: { pfiltro:'banca.revisado',type:'string'},
			id_grupo: 0,
			grid: true,
			form: false
		},
		
		{
			config:{
				name: 'tramite_cuota',
				fieldLabel: 'tramite_cuota',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:255,
				renderer: function (value, meta, record) {

					var resp;
					//meta.style=(record.json.saldo < 0)?'background:red; color:#fff; width:130px; height:30px;':'';
					//meta.css = record.get('online') ? 'user-online' : 'user-offline';
					resp = value;
					var css;
					
					var lista_negra = '';
					
					if(record.json.lista_negra == 'si'){
						css = "color:red; font-weight: bold; display:block;"
						lista_negra = '<div>(lista negra)</div>'
					}else{
						css = "";
					}


					var devolucion = '';
					if(record.json.tipo_bancarizacion == 'devolucion'){
						devolucion = '<div style="color:blue; font-weight:bold;" >(devolucion)</div>'
					}

					if(record.json.tipo_bancarizacion == 'clonado'){
						devolucion = '<div style="color:orange; font-weight:bold;" >(clonado)</div>'
					}

            	    return  String.format('<div style="vertical-align:middle;text-align:center;"><span style="{0}">{1}{2}{3}</span></div>',css,resp,lista_negra,devolucion);


					//return resp;
				}
			},
				type:'TextField',
				filters: {pfiltro: 'banca.tramite_cuota',type: 'string'},
				id_grupo:0,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'rotulo_comercial',
				fieldLabel: 'rotulo_comercial',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			},
				type:'TextField',
				filters: {pfiltro: 'provee.rotulo_comercial',type: 'string'},
				id_grupo:0,
				grid:true,
				form:false,
				bottom_filter : true
		},
		
		
		{
			config:{
				name: 'resolucion',
				fieldLabel: 'resolucion',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			},
				type:'TextField',
				filters: {pfiltro: 'banca.resolucion',type: 'string'},
				id_grupo:0,
				grid:true,
				form:false,
				bottom_filter : true
		},
		
		
		{
			config:{
				name: 'tipo_monto',
				fieldLabel: 'tipo_monto',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			},
				type:'TextField',
				filters: {pfiltro: 'contra.tipo_monto',type: 'string'},
				id_grupo:0,
				grid:true,
				form:false,
		},
		
		
		{
			config:{
				name: 'periodo',
				fieldLabel: 'periodo',
				allowBlank: true,
				anchor: '80%',
				gwidth: 30,
				maxLength:255,
				disabled:true,
				renderer: function (value, meta, record) {

					var resp;
					//meta.style=(record.json.saldo < 0)?'background:red; color:#fff; width:130px; height:30px;':'';
					//meta.css = record.get('online') ? 'user-online' : 'user-offline';
					resp = value;
					var css;
					
					if(record.json.saldo < 0){
						css = "color:red;"
					}else{
						css = "";
					}


            	    return  String.format('<div style="vertical-align:middle;text-align:center;"><span style="{0}">{1}</span></div>',css,resp);


					//return resp;
				}
			},
				type:'TextField',
				
				id_grupo:0,
				form:true,
				grid: true
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
					baseParams: {par_filtro: 'doc.nro_documento#va.importe_total'}
				}),
				valueField: 'id_documento',
				displayField: 'razon_social',
				gdisplayField: 'desc_documento',
				tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{sw_libro_compras}</b></p><p><b>{razon_social}</b></p><p>Nro fac: {nro_documento} </p> <p>Aut: {nro_autorizacion} </p><p>Importe: {importe_total}</p><p> Nit: {nro_nit} </p><p>fecha : {fecha_documento}</p></div></tpl>',


				hiddenName: 'id_documento',
				forceSelection: true,
				typeAhead: false,
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
				forceSelection: true,
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
					baseParams: {par_filtro:'con.numero#con.tipo#con.monto#prov.desc_proveedor#con.objeto#con.monto', tipo_proceso:"CON",tipo_estado:"finalizado",id_tabla:3}
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
				maxLength:255,
				renderer: function (value, meta, record) {

					var resp;
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
                    store: ['ENERO', 'FEBRERO', 'MARZO','ABRIL','MAYO','JUNIO','JULIO','AGOSTO','SEPTIEMBRE','OCTUBRE','NOVIEMBRE','DICIEMBRE'],
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
		
		{
			config:{
				name: 'estado_libro',
				fieldLabel: 'estado_libro',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			},
				type:'TextField',
				filters: {pfiltro: 'banca.estado_libro',type: 'string'},
				id_grupo:0,
				grid:true,
				form:false,
				bottom_filter : true
		},
		
		
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
		'monto_contrato',
		  'numero_cuota',
            			'tramite_cuota','id_proceso_wf'	,'resolucion',
            			'tipo_monto','rotulo_comercial','estado_libro',
            			'periodo_servicio','lista_negra','tipo_bancarizacion'
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
        Ext.Ajax.request({
            url:'../../sis_contabilidad/control/BancaCompraVenta/cambiarRevision',
            params:{ id_banca_compra_venta: d.id_banca_compra_venta,revisado:d.revisado,id_periodo: this.cmbPeriodo.getValue()},
            success: this.successRevision,
            failure: this.conexionFailure,
            timeout: this.timeout,
            scope: this
        }); 
        this.reload();
	},
	successRevision: function(resp){
       Phx.CP.loadingHide();
       var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
       //this.reload();
       /*if(reg.datos = 'correcto'){
         this.reload();
       }*/
    },
   
     
	 onButtonAct:function(){
        if(!this.validarFiltros()){
            alert('Especifique el año y el mes antes')
         }
        else{
        	
        	
            this.store.baseParams.id_gestion=this.cmbGestion.getValue();
            this.store.baseParams.id_periodo = this.cmbPeriodo.getValue();
            this.store.baseParams.id_depto = this.cmbDepto.getValue();
            this.store.baseParams.tipo = this.tipoBan;
            
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
            //this.Cmp.tipo.setValue(this.cmbTipo.getValue()); 
            
            Ext.Ajax.request({
                url: '../../sis_parametros/control/Periodo/literalPeriodo',
                params: { "id_periodo":this.cmbPeriodo.getValue(),"id_depto_conta":this.cmbDepto.getValue()},
                success: this.successLiteralPeriodo,
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope:   this
            });
            
            
            
        }
    },
    
    successLiteralPeriodo:function(resp){
    	 var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
    	 
    	this.Cmp.periodo.setValue(reg.datos[0].f_literal_periodo);
    },
    
    
    
     preparaMenu:function(tb){
        Phx.vista.BancaCompraVenta.superclass.preparaMenu.call(this,tb)
        var data = this.getSelectedData();
        if(data['revisado'] ==  'no' ){
            this.getBoton('edit').enable();
            this.getBoton('del').enable();
         
         }
         else{
            this.getBoton('edit').disable();
            this.getBoton('del').disable();
         } 
	        
    },
    
    liberaMenu:function(tb){
        Phx.vista.BancaCompraVenta.superclass.liberaMenu.call(this,tb);
                    
    },
    
    
     construyeVariablesContratos:function(){
    	Phx.CP.loadingShow();
    	Ext.Ajax.request({
                url: '../../sis_workflow/control/Tabla/cargarDatosTablaProceso',
                params: { "tipo_proceso": "CON", "tipo_estado": "finalizado" , "limit":"100","start":"0"},
                success: this.successCotratos,
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope:   this
            });
           
    	
    	
    },
    successCotratos:function(resp){
           Phx.CP.loadingHide();
           var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
           if(reg.datos){
                
              this.ID_CONT = reg.datos[0].atributos.id_tabla
              
              this.Cmp.id_contrato.store.baseParams.id_tabla = this.ID_CONT;
             
             }else{
                alert('Error al cargar datos de contratos')
            }
     },
     
    
    
    
    generar_txt:function(){
			var rec = this.cmbPeriodo.getValue();
			var tipo = this.tipoBan;




			

			
			Ext.Ajax.request({
				url:'../../sis_contabilidad/control/BancaCompraVenta/exporta_txt',
				params:{'id_periodo':rec,'tipo':tipo,'start':0,'limit':100000,'acumulado':'no','resolucion':this.cmbResolucion.getValue()},
				success: this.successGeneracion_txt,
			
				failure: this.conexionFailure,
				timeout:this.timeout,
				scope:this
			});
		},
		
		successGeneracion_txt:function(resp){
			Phx.CP.loadingHide();
	        var objRes = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
	        
	        var texto = objRes.datos;
	        window.open('../../../reportes_generados/'+texto+'.txt')
		},
		exportarGestionCompleta:function(){
			var rec = this.cmbPeriodo.getValue();
			var tipo = this.tipoBan;

			Ext.Ajax.request({
				url:'../../sis_contabilidad/control/BancaCompraVenta/exporta_txt',
				params:{'gestion':'si','id_periodo':rec,'tipo':tipo,'start':0,'limit':100000,'acumulado':'no','resolucion':this.cmbResolucion.getValue()},
				success: this.successExportarGestionCompleta,

				failure: this.conexionFailure,
				timeout:this.timeout,
				scope:this
			});
		},

		successExportarGestionCompleta:function(resp){
			Phx.CP.loadingHide();
	        var objRes = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));

	        var texto = objRes.datos;
	        window.open('../../../reportes_generados/'+texto+'.txt')
		},
	
	/*
		successGeneracion_txt: function (resp) {
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
			  link.href = "/kerp_capacitacion/reportes_generados/"+texto+".txt";
			  document.body.appendChild(link);
			  link.click();
			  // Cleanup the DOM
			  document.body.removeChild(link);
			  delete link;


		},*/
		
		successMontoAcumulado:function(resp){
			
			
			//console.log(this.form.getForm().items.items)
			//console.log(this.form.getForm().reset())
			
			this.monto_acumulado_aux=0;
			var objRes = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));

			for(var i=0; i<objRes.datos.length;i++){
				this.monto_acumulado_aux = this.monto_acumulado_aux + objRes.datos[i].monto_acumulado
			}
			this.Cmp.monto_acumulado.setValue(this.monto_acumulado_aux);
		},
		importar_txt:function(){
			
			
			var misdatos = new Object();
			misdatos.id_periodo = this.cmbPeriodo.getValue();
			misdatos.tipo = this.tipoBan;
			
			Phx.CP.loadWindows('../../../sis_contabilidad/vista/banca_compra_venta/subirArchivo.php',
	        'Subir',
	        {
	            modal:true,
	            width:450,
	            height:150
	        },misdatos,this.idContenedor,'SubirArchivo');
	        
		},
		verAutorizacion:function(resp){
			
			var objRes = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
			var datos = objRes.datos;
			
			
			if(datos[0] != undefined){
				this.Cmp.nit_ci.setValue(datos[0].nit_ci);
				this.Cmp.razon.setValue(datos[0].razon);
			}
			
		},
		acumulado : function (){
			
			 var data = this.getSelectedData();
			
			
			Phx.CP.loadWindows('../../../sis_contabilidad/vista/banca_compra_venta/Acumulado.php',
				'Acumulado',
				{
					width:900,
					height:400
				},data,this.idContenedor,'Acumulado')
		},
		
		insertAuto:function(){
			
			Phx.CP.loadingShow();
			
			var rec = this.cmbPeriodo.getValue();
			var tipo = this.tipoBan;
			
			var id_depto_conta = this.cmbDepto.getValue();
			
			Ext.Ajax.request({
				url:'../../sis_contabilidad/control/BancaCompraVenta/insertAuto',
				params:{'id_periodo':rec,'tipo':tipo,'start':0,'limit':100000,id_depto_conta:id_depto_conta},
				success: this.successAuto,
			
				failure: this.conexionFailure,
				timeout:this.timeout,
				scope:this
			});
		},
		successAuto:function(resp){
			Phx.CP.loadingHide();
			this.reload();
		},
		BorrarTodo:function(){
			
			Phx.CP.loadingShow();
			
			var id_periodo = this.cmbPeriodo.getValue();
			var tipo = this.tipoBan;
			
			var id_depto_conta = this.cmbDepto.getValue();
			
			
			Ext.Ajax.request({
				url:'../../sis_contabilidad/control/BancaCompraVenta/BorrarTodo',
				params:{'id_periodo':id_periodo,'tipo':tipo,id_depto_conta:id_depto_conta},
				success: this.successAuto,
			
				failure: this.conexionFailure,
				timeout:this.timeout,
				scope:this
			});
		},
		
		loadCheckDocumentosSolWf:function() {
            var rec=this.sm.getSelected();
            rec.data.nombreVista = this.nombreVista;
            Phx.CP.loadWindows('../../../sis_workflow/vista/documento_wf/DocumentoWf.php',
                    'Chequear documento del WF',
                    {
                        width:'90%',
                        height:500
                    },
                    rec.data,
                    this.idContenedor,
                    'DocumentoWf')
   		},
   		Retenciones : function(){
   			
   			this.win_pago.show();
   			
   		},
   		submitGenerarRetenciones :function(){
   			alert(this.cmbGestion_retenciones.getValue())
   		},
   		
   		addBotonesListaNegra: function() {
   			
   			// agregamos botones
        this.menuAdqGantt = new Ext.Toolbar.SplitButton({
            id: 'b-diagrama_gantt-' + this.idContenedor,
            text: 'Lista Negra',
            disabled: false,
            grupo:[0,1,2],
            iconCls : 'bcancelfile',
            handler:this.listaNegra,
            scope: this,
            menu:{
            items: [{
                id:'b-gantti-' + this.idContenedor,
                text: 'Agregar a Lista Negra',
                tooltip: '<b>agrega a la lista negra</b>',
                handler:this.addListaNegra,
                scope: this
            }, /*{
                id:'b-ganttd-' + this.idContenedor,
                text: 'Lista Negra',
                tooltip: '<b>Muestra la lista negra</b>',
                handler:this.listaNegra,
                scope: this
            }*/
        ]}
        });
		this.tbar.add(this.menuAdqGantt);
    },
    
    addListaNegra : function(){
		var id_periodo = this.cmbPeriodo.getValue();
    	 var data = this.getSelectedData();
    	Ext.Ajax.request({
				url:'../../sis_contabilidad/control/BancaCompraVenta/agregarListarNegra',
				params:{'id_banca_compra_venta':data.id_banca_compra_venta,'id_periodo':id_periodo},
				success: this.successAuto,
			
				failure: this.conexionFailure,
				timeout:this.timeout,
				scope:this
			});
    },
    
    
    
    
    addBotonesRetencionGarantias: function() {
        this.menuRetencionGarantias = new Ext.Toolbar.SplitButton({
            id: 'b-retencion_garantias-' + this.idContenedor,
            text: 'Retencion',
            disabled: false,
            grupo:[0,1,2],
            iconCls : 'bmoney',
            handler:this.listaRetencionGarantias,
            scope: this,
            menu:{
            items: [{
                id:'b-ins-reten-' + this.idContenedor,
                text: 'Insertar Retenciones',
                tooltip: '<b>Insertar Retenciones de garantias</b>',
                handler:this.addRetencionGarantias,
                scope: this
            },
            {
                id:'b-ins-reten-sin-pp-' + this.idContenedor,
                text: 'Insertar Retenciones sin plan de pago',
                tooltip: '<b>Insertar Retenciones de garantias</b>',
                handler:this.addRetencionGarantiasSinPlanPago,
                scope: this
            },
             /*{
                id:'b-list-reten-' + this.idContenedor,
                text: 'Lista de Rentenciones de Garantia',
                tooltip: '<b>Lista de retenciones de garantias</b>',
                handler:this.listaRetencionGarantias,
                scope: this
            }*/
        ]}
        });
		this.tbar.add(this.menuRetencionGarantias);
    },
    
    addRetencionGarantias : function (){
    	
			Phx.CP.loadingShow();
			
			var id_periodo = this.cmbPeriodo.getValue();
			
			var id_depto_conta = this.cmbDepto.getValue();
			
			Ext.Ajax.request({
				url:'../../sis_contabilidad/control/BancaCompraVenta/insertarRetencionesPeriodo',
				params:{'id_periodo':id_periodo,'id_depto_conta':id_depto_conta,'numero_tramite':''},
				success: this.successAuto,
			
				failure: this.conexionFailure,
				timeout:this.timeout,
				scope:this
			});
    },
    
    addRetencionGarantiasSinPlanPago : function(){
    	Phx.CP.loadingShow();
			
			var id_periodo = this.cmbPeriodo.getValue();
			
			var id_depto_conta = this.cmbDepto.getValue();
			
			var rec = this.sm.getSelected();
			
			var numero_tramite = rec.data.tramite_cuota;
			
			Ext.Ajax.request({
				url:'../../sis_contabilidad/control/BancaCompraVenta/insertarRetencionesPeriodo',
				params:{'id_periodo':id_periodo,'id_depto_conta':id_depto_conta,'numero_tramite':numero_tramite},
				success: this.successAuto,
			
				failure: this.conexionFailure,
				timeout:this.timeout,
				scope:this
			});
    },
	Clonar : function(){
    	Phx.CP.loadingShow();



			var rec = this.sm.getSelected();

			var id_banca_compra_venta = rec.data.id_banca_compra_venta;

			Ext.Ajax.request({
				url:'../../sis_contabilidad/control/BancaCompraVenta/clonar',
				params:{'id_banca_compra_venta':id_banca_compra_venta},
				success: this.successAuto,

				failure: this.conexionFailure,
				timeout:this.timeout,
				scope:this
			});
    },
	airbp : function(){




		Phx.CP.loadWindows('../../../sis_contabilidad/vista/plan_pago_documento_airbp/PlanPagoDocumentoAirbp.php',
			'PlanPagoDocumentoAirbp',
			{
				width:900,
				height:400
			},'',this.idContenedor,'PlanPagoDocumentoAirbp')

    }
    
    
		
		/*,
		onSubmit : function(o, x, force) {
			alert(this.Cmp.id_contrato.getValue());
		} */
    
    
	}
)
</script>
		
		