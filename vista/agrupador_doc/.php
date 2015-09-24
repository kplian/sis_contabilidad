<?php
/**
*@package pXP
*@file gen-DocCompraVenta.php
*@author  (admin)
*@date 18-08-2015 15:57:09
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.DocCompraVenta=Ext.extend(Phx.gridInterfaz,{
    fheight: '80%',
    fwidth: '70%',
    tabEnter: true,
    tipoDoc: 'venta',
	constructor:function(config){
		this.initButtons=[this.cmbDepto, this.cmbGestion, this.cmbPeriodo];
		var me = this;
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
		                                title: 'Detalle de Pago',
		                                items: [],
		                                margins:'2 10 2 2',
		                                id_grupo:1,
		                                autoHeight : true,
		                                flex:1
		                             }
		               ]   
		     }];
		
    	//llama al constructor de la clase padre
		Phx.vista.DocCompraVenta.superclass.constructor.call(this,config);
		
		this.cmbGestion.on('select', function(combo, record, index){
			this.tmpGestion = record.data.gestion;
		    this.cmbPeriodo.enable();
		    this.cmbPeriodo.reset();
		    this.store.removeAll();
		    this.cmbPeriodo.store.baseParams = Ext.apply(this.cmbPeriodo.store.baseParams, {id_gestion: this.cmbGestion.getValue()});
		    this.cmbPeriodo.modificado = true;
        },this);
        
        this.cmbPeriodo.on('select', function( combo, record, index){
			this.tmpPeriodo = record.data.periodo;
			this.capturaFiltros();
		    
        },this);
        
        this.cmbDepto.on('select', function( combo, record, index){
			this.capturaFiltros();
		    
        },this);
        
        
        this.addButton('btnWizard',
            {
                text: 'Generar Cbte',
                iconCls: 'bchecklist',
                disabled: false,
                handler: this.loadWizard,
                tooltip: '<b>Generar Comprobante</b><br/>Genera cbte de  para el deto selecionado'
            }
        );
        
        
        
		
		this.iniciarEventos();
		this.init();
		this.grid.addListener('cellclick', this.oncellclick,this);
	},
	
	capturaFiltros:function(combo, record, index){
        this.desbloquearOrdenamientoGrid();
        if(this.validarFiltros()){
        	this.store.baseParams.id_gestion = this.cmbGestion.getValue();
	        this.store.baseParams.id_periodo = this.cmbPeriodo.getValue();
	        this.store.baseParams.id_depto = this.cmbDepto.getValue();
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
						direction: 'ASC'
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
	
            		
	Atributos:[
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
            //configuracion del componente
            config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'porc_descuento_ley',
                    allowDecimals: true,
                    decimalPrecision: 10
            },
            type:'NumberField',
            form:true 
        },
        {
            //configuracion del componente
            config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'porc_iva_cf',
                    allowDecimals: true,
                    decimalPrecision: 10
            },
            type:'NumberField',
            form:true 
        },
        {
            //configuracion del componente
            config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'porc_iva_df',
                    allowDecimals: true,
                    decimalPrecision: 10
            },
            type:'NumberField',
            form:true 
        },
        {
            //configuracion del componente
            config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'porc_it',
                    allowDecimals: true,
                    decimalPrecision: 10
            },
            type:'NumberField',
            form:true 
        },
        {
            //configuracion del componente
            config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'porc_ice',
                    allowDecimals: true,
                    decimalPrecision: 10
            },
            type:'NumberField',
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
			filters: { pfiltro:'dcv.revisado',type:'string'},
			id_grupo: 1,
			grid: true,
			form: false
		},
		/*{
   			config:{
   				 name:'id_depto_conta',
   				 hiddenName: 'id_depto_conta',
   				 qtip: 'Departamento contable',
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
   			type:'ComboRec',
   			id_grupo:0,
   			filters:{pfiltro:'dep.nombre',type:'string'},
   		    grid:true,
   		    bottom_filter: true,
   			form:true
       },*/
        {
            config:{
                name: 'id_plantilla',
                fieldLabel: 'Tipo Documento',
                allowBlank: false,
                emptyText:'Elija una plantilla...',
                store:new Ext.data.JsonStore(
                {
                    url: '../../sis_parametros/control/Plantilla/listarPlantilla',
                    id: 'id_plantilla',
                    root:'datos',
                    sortInfo:{
                        field:'desc_plantilla',
                        direction:'ASC'
                    },
                    totalProperty:'total',
                    fields: ['id_plantilla','nro_linea','desc_plantilla','tipo',
                    'sw_tesoro', 'sw_compro','sw_monto_excento','sw_descuento',
                    'sw_autorizacion','sw_codigo_control','tipo_plantilla','sw_nro_dui','sw_ice'],
                    remoteSort: true,
                    baseParams:{par_filtro:'plt.desc_plantilla',sw_compro:'si',sw_tesoro:'si'}
                }),
                tpl:'<tpl for="."><div class="x-combo-list-item"><p>{desc_plantilla}</p></div></tpl>',
                valueField: 'id_plantilla',
                hiddenValue: 'id_plantilla',
                displayField: 'desc_plantilla',
                gdisplayField:'desc_plantilla',
                listWidth:'280',
                forceSelection:true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender:true,
                mode:'remote',
                pageSize:20,
                queryDelay:500,
               
                gwidth: 250,
                minChars:2,
                renderer:function (value, p, record){return String.format('{0}', record.data['desc_plantilla']);}
            },
            type:'ComboBox',
            filters:{pfiltro:'pla.desc_plantilla',type:'string'},
            id_grupo: 0,
            grid: true,
            bottom_filter: true,
            form: true
        },
		
        {
            config:{
                name:'id_moneda',
                origen:'MONEDA',
                allowBlank:false,
                fieldLabel:'Moneda',
                gdisplayField:'desc_moneda',//mapea al store del grid
                gwidth:70,
                width:250,
                renderer:function (value, p, record){return String.format('{0}', record.data['desc_moneda']);}
             },
            type:'ComboRec',
            id_grupo:0,
            filters:{   
                pfiltro:'incbte.desc_moneda',
                type:'string'
            },
            grid:true,
            form:true
        },
		{
			config:{
				name: 'dia',
				fieldLabel: 'Dia',
				allowBlank: true,
				allowNEgative: false,
				allowDecimal: false,
				maxValue: 31,
				minValue: 1,
				width: 40,
				
				gwidth: 100
			},
				type:'NumberField',
				id_grupo:0,
				grid:false,
				form: true
		},
		
		{
			config:{
				name: 'fecha',
				fieldLabel: 'Fecha',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				format: 'd/m/Y',
				readOnly:true,
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'dcv.fecha',type:'date'},
				id_grupo:0,
				grid:true,
				form:true
		},
        {
            config:{
                name: 'nro_autorizacion',
                fieldLabel: 'Autorización',
                allowBlank: false,
                emptyText:'autorización ...',
                store:new Ext.data.JsonStore(
                {
                    url: '../../sis_contabilidad/control/DocCompraVenta/listarNroAutorizacion',
                    id: 'nro_autorizacion',
                    root:'datos',
                    sortInfo:{
                        field:'nro_autorizacion',
                        direction:'ASC'
                    },
                    totalProperty:'total',
                    fields: ['nro_autorizacion','nit','razon_social'],
                    remoteSort: true
                }),
                valueField: 'nro_autorizacion',
                hiddenValue: 'nro_autorizacion',
                displayField: 'nro_autorizacion',
                gdisplayField:'nro_autorizacion',
                queryParam: 'nro_autorizacion',
                listWidth:'280',
                forceSelection:false,
                autoSelect: false,
                hideTrigger:true,
                typeAhead: false,
                typeAheadDelay: 75,
                //triggerAction: 'query',
                lazyRender:false,
                mode:'remote',
                pageSize:20,
                queryDelay:500,
                gwidth: 250,
                minChars:1
            },
            type:'ComboBox',
            filters:{pfiltro:'dcv.nro_autorizacion',type:'string'},
            id_grupo: 0,
            grid: true,
            bottom_filter: true,
            form: true
        },
        
        {
            config:{
                name: 'nit',
                fieldLabel: 'NIT',
                qtip: 'Número de indentificación del proveedor',
                allowBlank: false,
                emptyText:'nit ...',
                store:new Ext.data.JsonStore(
                {
                    url: '../../sis_contabilidad/control/DocCompraVenta/listarNroNit',
                    id: 'nit',
                    root:'datos',
                    sortInfo:{
                        field:'nit',
                        direction:'ASC'
                    },
                    totalProperty:'total',
                    fields: ['nit','razon_social'],
                    remoteSort: true
                }),
                valueField: 'nit',
                hiddenValue: 'nit',
                displayField: 'nit',
                gdisplayField:'nit',
                queryParam: 'nit',
                listWidth:'280',
                forceSelection:false,
                autoSelect: false,
                typeAhead: false,
                typeAheadDelay: 75,
                hideTrigger:true,
                triggerAction: 'query',
                lazyRender:false,
                mode:'remote',
                pageSize:20,
                queryDelay:500,
                gwidth: 250,
                minChars:1
            },
            type:'ComboBox',
            filters:{pfiltro:'dcv.nit',type:'string'},
            id_grupo: 0,
            grid: true,
            bottom_filter: true,
            form: true
        },
		
		
		{
			config:{
				name: 'razon_social',
				fieldLabel: 'Razón Social',
				allowBlank: false,
				maskRe: /[A-Za-z0-9 ]/,
                fieldStyle: 'text-transform:uppercase',
                listeners:{
			          'change': function(field, newValue, oldValue){
			          			  console.log('keyup ...  ')
			          			  field.suspendEvents(true);
			                      field.setValue(newValue.toUpperCase());
			                      field.resumeEvents(true);
			                  }
			     },
				anchor: '80%',
				gwidth: 100,
				maxLength:180
			},
				type:'TextField',
				filters:{pfiltro:'dcv.razon_social',type:'string'},
				id_grupo:0,
				grid:true,
				bottom_filter: true,
				form:true
		},
		{
			config:{
				name: 'nro_documento',
				fieldLabel: 'Nro Doc',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
				type:'TextField',
				filters:{pfiltro:'dcv.nro_documento',type:'string'},
				id_grupo:0,
				grid:true,
				bottom_filter: true,
				form:true
		},
		{
			config:{
				name: 'nro_dui',
				fieldLabel: 'DUI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength :16,
				minLength:16
			},
				type:'TextField',
				filters:{pfiltro:'dcv.nro_dui',type:'string'},
				id_grupo:0,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'codigo_control',
				fieldLabel: 'Código de Control',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:200
			},
				type:'TextField',
				filters:{pfiltro:'dcv.codigo_control',type:'string'},
				id_grupo:0,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'obs',
				fieldLabel: 'Obs',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength: 400
			},
				type:'TextArea',
				filters:{ pfiltro:'dcv.obs',type:'string' },
				id_grupo:0,
				grid: true,
				bottom_filter: true,
				form: true
		},
		{
			config:{
				name: 'importe_doc',
				fieldLabel: 'Monto',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'dcv.importe_doc',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'importe_excento',
				fieldLabel: 'Excento',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100
			},
				type: 'NumberField',
				filters: {pfiltro:'dcv.importe_excento',type:'numeric'},
				id_grupo:1,
				grid: true,
				form: true
		},
		{
			config:{
				name: 'importe_descuento',
				fieldLabel: 'Descuento',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100
			},
				type:'NumberField',
				filters:{pfiltro:'dcv.importe_descuento',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'importe_descuento_ley',
				fieldLabel: 'Descuentos de Ley',
				allowBlank: true,
				readOnly:true,
				anchor: '80%',
				gwidth: 100
			},
				type:'NumberField',
				filters:{pfiltro:'dcv.importe_descuento_ley',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'importe_ice',
				fieldLabel: 'ICE',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100
			},
				type:'NumberField',
				filters:{pfiltro:'dcv.importe_ice',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'importe_iva',
				fieldLabel: 'IVA',
				allowBlank: true,
				readOnly:true,
				anchor: '80%',
				gwidth: 100
			},
				type: 'NumberField',
				filters: { pfiltro:'dcv.importe_iva',type:'numeric'},
				id_grupo: 1,
				grid: true,
				form: true
		},
		{
			config:{
				name: 'importe_it',
				fieldLabel: 'IT',
				allowBlank: true,
				anchor: '80%',
				readOnly:true,
				gwidth: 100
			},
				type:'NumberField',
				filters:{pfiltro:'dcv.importe_it',type:'numeric'},
				id_grupo:1,
				grid:true,
				form: true
		},
		{
			config:{
				name: 'importe_pago_liquido',
				fieldLabel: 'Liquido Pagado',
				allowBlank: true,
				readOnly:true,
				anchor: '80%',
				gwidth: 100
			},
				type:'NumberField',
				filters:{pfiltro:'dcv.importe_pago_liquido',type:'numeric'},
				id_grupo:1,
				grid:true,
				form: true
		},
		
		{
			config:{
				name: 'estado',
				fieldLabel: 'Estado',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:30
			},
				type:'TextField',
				filters:{pfiltro:'dcv.estado',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'sw_contabilizar',
				fieldLabel: 'Contabilizar',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength: 3
			},
				type: 'TextField',
				filters: { pfiltro:'dcv.sw_contabilizar', type:'string' },
				id_grupo: 1,
				grid: true,
				form: false
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
				filters:{pfiltro:'dcv.estado_reg',type:'string'},
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
				filters:{pfiltro:'dcv.fecha_reg',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: '',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'dcv.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'dcv.fecha_mod',type:'date'},
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
				filters:{pfiltro:'dcv.usuario_ai',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Documentos Compra/Venta',
	ActSave:'../../sis_contabilidad/control/DocCompraVenta/insertarDocCompraVenta',
	ActDel:'../../sis_contabilidad/control/DocCompraVenta/eliminarDocCompraVenta',
	ActList:'../../sis_contabilidad/control/DocCompraVenta/listarDocCompraVenta',
	id_store:'id_doc_compra_venta',
	fields: [
		{name:'id_doc_compra_venta', type: 'string'},
		{name:'revisado', type: 'string'},
		{name:'movil', type: 'string'},
		{name:'tipo', type: 'string'},
		{name:'importe_excento', type: 'numeric'},
		{name:'id_plantilla', type: 'numeric'},
		{name:'fecha', type: 'date',dateFormat:'Y-m-d'},
		{name:'nro_documento', type: 'string'},
		{name:'nit', type: 'string'},
		{name:'importe_ice', type: 'numeric'},
		{name:'nro_autorizacion', type: 'string'},
		{name:'importe_iva', type: 'numeric'},
		{name:'importe_descuento', type: 'numeric'},
		{name:'importe_doc', type: 'numeric'},
		{name:'sw_contabilizar', type: 'string'},
		{name:'tabla_origen', type: 'string'},
		{name:'estado', type: 'string'},
		{name:'id_depto_conta', type: 'numeric'},
		{name:'id_origen', type: 'numeric'},
		{name:'obs', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'codigo_control', type: 'string'},
		{name:'importe_it', type: 'numeric'},
		{name:'razon_social', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		'desc_depto','desc_plantilla',
		'importe_descuento_ley',
		'importe_pago_liquido','nro_dui','id_moneda','desc_moneda'
		
	],
	sortInfo:{
		field: 'id_doc_compra_venta',
		direction: 'ASC'
	},
	bdel: true,
	bsave: false,
	iniciarEventos: function(){
		
		this.Cmp.dia.on('change',function( cmp, newValue, oldValue){
			
			
			var dia =  newValue>9?newValue:'0'+newValue, 
			    mes =  this.tmpPeriodo>9?this.tmpPeriodo:'0'+this.tmpPeriodo,
			    tmpFecha = dia+'/'+mes+'/'+this.tmpGestion;
			    resp = this.Cmp.fecha.setValue(tmpFecha);
			
			
		}, this);
		
		this.Cmp.nro_autorizacion.on('select', function(cmb,rec,i){
			this.Cmp.nit.setValue(rec.data.nit);
			this.Cmp.razon_social.setValue(rec.data.razon_social);
		} ,this);
		
		this.Cmp.nit.on('select', function(cmb,rec,i){
			this.Cmp.razon_social.setValue(rec.data.razon_social);
		} ,this);
		
		
		
		
		//this.Cmp.nro_autorizacion .on('blur',this.cargarRazonSocial,this);
		this.Cmp.id_plantilla.on('select',function(cmb,rec,i){
				
				this.esconderImportes();
				console.log('selecionar plantilla', rec.data)
				//si es el formulario para nuevo reseteamos los valores ...
				if(this.accionFormulario == 'NEW'){
				    this.iniciarImportes();	
					this.Cmp.importe_excento.reset();
					
					this.Cmp.nro_autorizacion.reset();
					this.Cmp.codigo_control.reset();
					this.Cmp.importe_descuento.reset();
		         }     
	            this.getDetallePorAplicar(rec.data.id_plantilla);
	            if(rec.data.sw_monto_excento=='si'){
	               this.mostrarComponente(this.Cmp.importe_excento);
	            }
	            else{
	                this.ocultarComponente(this.Cmp.importe_excento);
	            }
	           
	            if(rec.data.sw_descuento=='si'){
	               this.mostrarComponente(this.Cmp.importe_descuento);
	            }
	            else{
	                this.ocultarComponente(this.Cmp.importe_descuento);
	            }
	          
	            if(rec.data.sw_autorizacion == 'si'){
	               this.mostrarComponente(this.Cmp.nro_autorizacion);
	            }
	            else{
	                this.ocultarComponente(this.Cmp.nro_autorizacion);
	            }
	            
	            if(rec.data.sw_codigo_control == 'si'){
	               this.mostrarComponente(this.Cmp.codigo_control);
	            }
	            else{
	                this.ocultarComponente(this.Cmp.codigo_control);
	            }
	            
	            console.log('NRO DUI', rec.data.sw_nro_dui)
	            if(rec.data.sw_nro_dui == 'si'){
	               this.Cmp.nro_dui.allowBlank =false;
	               this.mostrarComponente(this.Cmp.nro_dui);
	               this.Cmp.nro_documento.setValue(0);
	               this.Cmp.nro_documento.setReadOnly(true);
	               
	            }
	            else{
	            	this.Cmp.nro_dui.allowBlank = true;
	                this.ocultarComponente(this.Cmp.nro_dui);
	                this.Cmp.nro_documento.setReadOnly(false);
	            }
			
        },this);
        
        this.Cmp.importe_doc.on('change',this.calculaMontoPago,this);
        this.Cmp.importe_excento.on('change',this.calculaMontoPago,this);  
        this.Cmp.importe_descuento.on('change',this.calculaMontoPago,this);
        this.Cmp.importe_descuento_ley.on('change',this.calculaMontoPago,this);
        
        
        this.Cmp.nro_autorizacion.on('change',function(fild, newValue, oldValue){
        	if (newValue[3] == '4'){
        		this.mostrarComponente(this.Cmp.codigo_control);
	            this.Cmp.codigo_control.allowBlank = false;
        	}
        	else{
        		this.Cmp.codigo_control.allowBlank = true;
        		this.ocultarComponente(this.Cmp.codigo_control);
        		
        	};
        	
        },this);
        
        
        
        
	},
	
	calculaMontoPago:function(){
        var descuento_ley = 0.00;
            
        if(this.tmp_porc_monto_excento_var){
        	this.Cmp.importe_excento.setValue(this.Cmp.importe_doc.getValue()*this.tmp_porc_monto_excento_var)
        }
       
        if(this.Cmp.importe_excento.getValue() == 0){
        	descuento_ley = this.Cmp.importe_doc.getValue()*this.Cmp.porc_descuento_ley.getValue()*1.00;
            this.Cmp.importe_descuento_ley.setValue(descuento_ley);
        }
        else{
        	if(this.Cmp.importe_excento.getValue() > 0 ){
        	  descuento_ley = (this.Cmp.importe_doc.getValue()*1.00 - this.Cmp.importe_excento.getValue()*1.00)*this.Cmp.porc_descuento_ley.getValue();
              this.Cmp.importe_descuento_ley.setValue(descuento_ley);	
        	}
        	else{
        		alert('El monto exento no puede ser menor que cero');
        		return; 
        	}
        	
        }
        
        //calculo it
        if(this.Cmp.porc_it.getValue() > 0){
        	this.Cmp.importe_it.setValue(this.Cmp.porc_it.getValue()*this.Cmp.importe_doc.getValue())
        }
        
        //calculo iva cf
        if(this.Cmp.porc_iva_cf.getValue() > 0 || this.Cmp.porc_iva_df.getValue() > 0){
        	var excento = 0.00;
        	if(this.Cmp.importe_excento.getValue() > 0){
        		excento = this.Cmp.importe_excento.getValue();
        	}
        	if(this.Cmp.porc_iva_cf.getValue() > 0){
        	   this.Cmp.importe_iva.setValue(this.Cmp.porc_iva_cf.getValue()*(this.Cmp.importe_doc.getValue() - excento));
        	}
        	else {
        	   this.Cmp.importe_iva.setValue(this.Cmp.porc_iva_df.getValue()*(this.Cmp.importe_doc.getValue() - excento));
        	}
        }	
        	
        
        var liquido =  this.Cmp.importe_doc.getValue()   -  this.Cmp.importe_descuento.getValue() -  this.Cmp.importe_descuento_ley.getValue();
        this.Cmp.importe_pago_liquido.setValue(liquido>0?liquido:0);
     }, 
	cargarRazonSocial: function(obj){
		//Busca en la base de datos la razon social en función del NIT digitado. Si Razon social no esta vacío, entonces no hace nada
		if(this.getComponente('razon_social').getValue()==''){
			Phx.CP.loadingShow();
			Ext.Ajax.request({
				url:'../../sis_contabilidad/control/DocCompraVenta/obtenerRazonSocialxAutorizacion',
				params:{ 'nro_autorizacion': this.Cmp.nro_autorizacion.getValue()},
				success: function(resp){
					Phx.CP.loadingHide();
			        var objRes = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
			        console.log(objRes);
			        var razonSocial=objRes.ROOT.datos.razon_social;
			        this.getComponente('razon_social').setValue(razonSocial);
				},
				failure: this.conexionFailure,
				timeout: this.timeout,
				scope:this
			});
		}
	},
	getDetallePorAplicar:function(id_plantilla){
        var data = this.getSelectedData();
           Phx.CP.loadingShow();
           
           Ext.Ajax.request({
                // form:this.form.getForm().getEl(),
                url:'../../sis_contabilidad/control/PlantillaCalculo/recuperarDetallePlantillaCalculo',
                params:{id_plantilla:id_plantilla},
                success:this.successAplicarDesc,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });
     },
      successAplicarDesc:function(resp){
           Phx.CP.loadingHide();
           var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
           if(!reg.ROOT.error){
               //aplica descuentos 
               this.Cmp.porc_descuento_ley.setValue(reg.ROOT.datos.descuento_porc*1);
                //aplica iva-cf
               this.Cmp.porc_iva_cf.setValue(reg.ROOT.datos.porc_iva_cf*1);
                //aplica iva-df 
               this.Cmp.porc_iva_df.setValue(reg.ROOT.datos.porc_iva_df*1);
               //aplicar  it
               this.Cmp.porc_it.setValue(reg.ROOT.datos.porc_it*1);
               //aplicar  ice
               this.Cmp.porc_ice.setValue(reg.ROOT.datos.porc_ice*1);
               
               //habilitar campos
               this.mostrarImportes(reg.ROOT.datos)
               this.calculaMontoPago();
               
              
             
             }else{
                alert(reg.ROOT.mensaje)
            }
     },
     
    
    
     
     esconderImportes:function(){
     	this.ocultarComponente(this.Cmp.importe_descuento);
     	this.ocultarComponente(this.Cmp.nro_autorizacion);
     	this.ocultarComponente(this.Cmp.codigo_control);
     	this.ocultarComponente(this.Cmp.importe_excento);
     	this.ocultarComponente(this.Cmp.importe_iva);
     	this.ocultarComponente(this.Cmp.importe_it);
     	this.ocultarComponente(this.Cmp.importe_ice);
     	this.ocultarComponente(this.Cmp.importe_descuento_ley);
     	
     },
     iniciarImportes:function(){
     	this.Cmp.importe_excento.setValue(0);
     	this.Cmp.importe_iva.setValue(0);
     	this.Cmp.importe_it.setValue(0);
     	this.Cmp.importe_ice.setValue(0);
     	this.Cmp.importe_descuento_ley.setValue(0);
     },
     
     mostrarImportes: function(datos){
     	if( datos.porc_ice !== '0'){
     		this.mostrarComponente(this.Cmp.importe_ice);
     	}
     	if( datos.porc_it !== '0'){
     		this.mostrarComponente(this.Cmp.importe_it);
     	}
     	if( datos.porc_iva_cf !== '0'){
     		this.mostrarComponente(this.Cmp.importe_iva);
     	}
     	if( datos.porc_iva_df !== '0'){
     		this.mostrarComponente(this.Cmp.importe_iva);
     	}
     	if( datos.porc_ice !== '0'){
     		this.mostrarComponente(this.Cmp.importe_ice);
     	}
     	if( datos.descuento_porc !== '0'){
     		this.mostrarComponente(this.Cmp.importe_descuento_ley);
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
            
            Phx.vista.DocCompraVenta.superclass.onButtonAct.call(this);
        }
    },
    /*
     onButtonNew:function(){
     	
     	
     	if(!this.validarFiltros()){
            alert('Especifique el año y el mes antes')
        }
        else{
        	this.accionFormulario = 'NEW';
        	this.Cmp.nit.modificado = true;
     	    this.Cmp.nro_autorizacion.modificado = true;
            Phx.vista.DocCompraVenta.superclass.onButtonNew.call(this);
            this.esconderImportes();
            this.Cmp.id_depto_conta.setValue(this.cmbDepto.getValue())
        }
    },*/
   
   abrirFormulario: function(tipo, record){
   	       var me = this;
	       me.objSolForm = Phx.CP.loadWindows('../../../sis_contabilidad/vista/doc_compra_venta/FormCompraVenta.php',
	                                'Formulario de Documento Compra/Venta',
	                                {
	                                    modal:true,
	                                    width:'100%',
	                                    height:'100%'
	                                }, { data: { 
	                                	 objPadre: me ,
	                                	 tipoDoc: me.tipoDoc,
	                                	 id_gestion: me.cmbGestion.getValue(),
	                                	 id_periodo: me.cmbPeriodo.getValue(),
	                                	 id_depto: me.cmbDepto.getValue(),
	                                	 tmpPeriodo: me.tmpPeriodo,
	                                	 tmpGestion: me.tmpGestion,
	                                	 tipo_form : tipo,
	                                	 datosOriginales: record
	                                	}
	                                }, 
	                                this.idContenedor,
	                                'FormCompraVenta',
	                                {
	                                    config:[{
	                                              event:'successsave',
	                                              delegate: this.onSaveForm,
	                                              
	                                            }],
	                                    
	                                    scope:this
	                                 });  
   },
   
   onButtonNew:function(){
	       //abrir formulario de solicitud
	        if(!this.validarFiltros()){
	            alert('Especifique el año y el mes antes')
	        }
	        else{
	       
			       this.abrirFormulario('new')  
	    
		
          } 
    },
    onButtonEdit:function(){
     	if(!this.validarFiltros()){
            alert('Especifique el año y el mes antes')
        }
        else{
        	this.abrirFormulario('edit', this.sm.getSelected())
        	
        }
    },
    
    
    
    /*
    onButtonEdit:function(){
     	if(!this.validarFiltros()){
            alert('Especifique el año y el mes antes')
        }
        else{
        	this.Cmp.nit.modificado = true;
     	    this.Cmp.nro_autorizacion.modificado = true;
        	this.accionFormulario = 'EDIT';
        	
            Phx.vista.DocCompraVenta.superclass.onButtonEdit.call(this);
            this.esconderImportes();
            this.getPlantilla(this.Cmp.id_plantilla.getValue());
        }
    },*/
    
    getPlantilla: function(id_plantilla){
    	Phx.CP.loadingShow();
           
           Ext.Ajax.request({
                // form:this.form.getForm().getEl(),
                url: '../../sis_parametros/control/Plantilla/listarPlantilla',
                params: { id_plantilla: id_plantilla, start:0, limit:1 },
                success:this.successPlantilla,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });
    	
    },
    successPlantilla:function(resp){
           Phx.CP.loadingHide();
           var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if(reg.total == 1){
               	
           	  this.Cmp.id_plantilla.fireEvent('select',this.Cmp.id_plantilla, {data:reg.datos[0] }, 0);
           }else{
                alert('error al recuperar la plantilla para editar, actualice su navegador');
            }
     },
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
            url:'../../sis_contabilidad/control/DocCompraVenta/cambiarRevision',
            params:{ id_doc_compra_venta: d.id_doc_compra_venta},
            success: this.successRevision,
            failure: this.conexionFailure,
            timeout: this.timeout,
            scope: this
        }); 
	},
	successRevision: function(resp){
       Phx.CP.loadingHide();
       var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
       if(!reg.ROOT.error){
         this.reload();
       }
    },
    
     preparaMenu:function(tb){
        Phx.vista.DocCompraVenta.superclass.preparaMenu.call(this,tb)
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
        Phx.vista.DocCompraVenta.superclass.liberaMenu.call(this,tb);
                    
    },
    
    loadWizard:function() {
         if(!this.validarFiltros()){
            alert('Especifique el año y el mes antes')
        }
        else{
        	Phx.CP.loadWindows('../../../sis_contabilidad/vista/agrupador/WizardAgrupador.php',
                    'Generar comprobante',
                    {
                        width:'40%',
                        height:300
                    },
                    {   id_gestion: this.cmbGestion.getValue(), 
                    	id_periodo:   this.cmbPeriodo.getValue(),  
                    	id_depto_conta: this.cmbDepto.getValue(),
                        gestion: this.tmpGestion,
                        tipoDoc: this.tipoDoc
                    },
                    this.idContenedor,
                    'WizardAgrupador');
        	
        }
            
    }
    
   
    
    
})
</script>