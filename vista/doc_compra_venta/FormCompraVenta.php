<?php
/**
*@package pXP
*@file    FormCompraVenta.php
*@author  Rensi Arteaga Copari 
*@date    30-01-2014
*@description permites subir archivos a la tabla de documento_sol
*/
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
Phx.vista.FormCompraVenta=Ext.extend(Phx.frmInterfaz,{
    ActSave:'../../sis_contabilidad/control/DocCompraVenta/insertarDocCompleto',
    tam_pag: 10,
    tabEnter: true,
    //layoutType: 'wizard',
    layout: 'fit',
    autoScroll: false,
    breset: false,
    conceptos_eliminados: [],
    //labelSubmit: '<i class="fa fa-check"></i> Siguiente',
    constructor:function(config)
    {   
    	
    	Ext.apply(this,config);
    	//declaracion de eventos
        this.addEvents('beforesave');
        this.addEvents('successsave');
    	
    	this.buildComponentesDetalle();
        this.buildDetailGrid();
        this.buildGrupos();
        
        Phx.vista.FormCompraVenta.superclass.constructor.call(this,config);
        
        
        
        this.init();    
        this.iniciarEventos();
        this.iniciarEventosDetalle();
        if(this.data.tipo_form == 'new'){
        	this.onNew();
        }
        else{
        	this.onEdit();
        }
        
        
        this.Cmp.id_plantilla.store.baseParams = Ext.apply(this.Cmp.id_plantilla.store.baseParams, {tipo_plantilla:this.Cmp.tipo.getValue()});
        
    },
    buildComponentesDetalle: function(){
    	var me = this,
    	    bpar = (me.data.tipoDoc=='compra')?{par_filtro:'desc_ingas#par.codigo', movimiento: 'gasto'}:{par_filtro:'desc_ingas#par.codigo', movimiento: 'recurso'};
    	me.detCmp = {
    		       'id_concepto_ingas': new Ext.form.ComboBox({
							                name: 'id_concepto_ingas',
							                msgTarget: 'title',
							                fieldLabel: 'Concepto',
							                allowBlank: false,
							                emptyText : 'Concepto...',
							                store : new Ext.data.JsonStore({
							                            url:'../../sis_parametros/control/ConceptoIngas/listarConceptoIngasMasPartida',
							                            id : 'id_concepto_ingas',
							                            root: 'datos',
							                            sortInfo:{
							                                    field: 'desc_ingas',
							                                    direction: 'ASC'
							                            },
							                            totalProperty: 'total',
							                            fields: ['id_concepto_ingas','tipo','desc_ingas','movimiento','desc_partida','id_grupo_ots','filtro_ot','requiere_ot'],
							                            remoteSort: true,
							                            baseParams: bpar
							                }),
							               valueField: 'id_concepto_ingas',
							               displayField: 'desc_ingas',
							               hiddenName: 'id_concepto_ingas',
							               forceSelection:true,
							               typeAhead: false,
							               triggerAction: 'all',
							               listWidth:500,
							               resizable:true,
							               lazyRender:true,
							               mode:'remote',
							               pageSize:10,
							               queryDelay:1000,
							               minChars:2,
							               qtip:'Si el conceto de gasto que necesita no existe por favor  comuniquese con el área de presupuestos para solictar la creación',
							               tpl: '<tpl for="."><div class="x-combo-list-item"><p><b>{desc_ingas}</b></p><strong>{tipo}</strong><p>PARTIDA: {desc_partida}</p></div></tpl>',
							             }),
	              'id_centro_costo': new Ext.form.ComboRec({
						                    name:'id_centro_costo',
						                    msgTarget: 'title',
						                    origen:'CENTROCOSTO',
						                    fieldLabel: 'Centro de Costos',
						                    url: '../../sis_parametros/control/CentroCosto/listarCentroCostoFiltradoXDepto',
						                    emptyText : 'Centro Costo...',
						                    allowBlank: false,
						                    baseParams: (me.data.tipoDoc == 'compra')?{tipo_pres:'gasto', filtrar:'grupo_ep'}:{tipo_pres:'recurso', filtrar:'grupo_ep'}
						                }),
	               'id_orden_trabajo': new Ext.form.ComboRec({
						                    name:'id_orden_trabajo',
						                    msgTarget: 'title',
						                    sysorigen:'sis_contabilidad',
						                    fieldLabel: 'Orden Trabajo',
							       		    origen:'OT',
							       		    baseParams: {tipo_pres: 'recurso'},
						                    allowBlank:true
						            }),
						            
					'descripcion': new Ext.form.TextArea({
										name: 'descripcion',
										msgTarget: 'title',
										fieldLabel: 'Descripcion',
										allowBlank: false,
										anchor: '80%',
										maxLength:1200
								}),
					'cantidad_sol': new Ext.form.NumberField({
										name: 'cantidad_sol',
										msgTarget: 'title',
						                fieldLabel: 'Cantidad',
						                allowBlank: false,
						                allowDecimals: false,
						                maxLength:10
								}),
					'precio_unitario': new Ext.form.NumberField({
						                name: 'precio_unitario',
						                msgTarget: 'title',
						                currencyChar:' ',
						                fieldLabel: 'Prec. Unit.',
						                minValue: 0.0001, 
						                allowBlank: false,
						                allowDecimals: true,
						                allowNegative:false,
						                decimalPrecision:2
						            }),			
					'precio_total': new Ext.form.NumberField({
									    name: 'precio_total',
									    msgTarget: 'title',
									    readOnly: true,
									    allowBlank: true
                      		 	})
					
			  }
    		
    		
    }, 
    
    
    iniciarEventosDetalle: function(){
    	
        
        this.detCmp.precio_unitario.on('valid',function(field){
             var pTot = this.detCmp.cantidad_sol.getValue() * this.detCmp.precio_unitario.getValue();
             this.detCmp.precio_total.setValue(pTot);
            } ,this);
        
       this.detCmp.cantidad_sol.on('valid',function(field){
            var pTot = this.detCmp.cantidad_sol.getValue() * this.detCmp.precio_unitario.getValue();
            this.detCmp.precio_total.setValue(pTot);
           
        } ,this);
        
        this.detCmp.id_concepto_ingas.on('change',function( cmb, rec, ind){
	        	    this.detCmp.id_orden_trabajo.reset();
	           },this);
	        
	    this.detCmp.id_concepto_ingas.on('select',function( cmb, rec, ind){
	        	
	        	    this.detCmp.id_orden_trabajo.store.baseParams = {
			        		                                           filtro_ot:rec.data.filtro_ot,
			        		 										   requiere_ot:rec.data.requiere_ot,
			        		 										   id_grupo_ots:rec.data.id_grupo_ots
			        		 										 };
			        this.detCmp.id_orden_trabajo.modificado = true;
			        if(rec.data.requiere_ot =='obligatorio'){
			        	this.detCmp.id_orden_trabajo.allowBlank = false;
			        	this.detCmp.id_orden_trabajo.setReadOnly(false);
			        }
			        else{
			        	this.detCmp.id_orden_trabajo.allowBlank = true;
			        	this.detCmp.id_orden_trabajo.setReadOnly(true);
			        }
			        this.detCmp.id_orden_trabajo.reset();
			     console.log('rec data,', rec) 
			    var idcc = this.detCmp.id_centro_costo.getValue();
				if(idcc){
				  this.checkRelacionConcepto({id_centro_costo: idcc , id_concepto_ingas: rec.data.id_concepto_ingas, id_gestion :  this.Cmp.id_gestion.getValue()});	
				}
			        
			  },this);
			  
			  
			this.detCmp.id_centro_costo.on('select',function( cmb, rec, ind){
				var idc = this.detCmp.id_concepto_ingas.getValue();
				if(idc){
				  this.checkRelacionConcepto({id_centro_costo: rec.data.id_centro_costo , id_concepto_ingas: idc, id_gestion :  this.Cmp.id_gestion.getValue()});	
				}
				
			},this);  
			  
    },
    
    onInitAdd: function(){
    	//return false
    },
    onCancelAdd: function(re,save){
    	if(this.sw_init_add){
    		this.mestore.remove(this.mestore.getAt(0));
    	}
    	
    	this.sw_init_add = false;
    	this.evaluaGrilla();
    	
    },
    onUpdateRegister: function(){
    	this.sw_init_add = false;
    	
    },
    
    onAfterEdit:function(re, o, rec, num){
    	//set descriptins values ...  in combos boxs
    	
    	var cmb_rec = this.detCmp['id_concepto_ingas'].store.getById(rec.get('id_concepto_ingas'));
    	if(cmb_rec){
    		rec.set('desc_concepto_ingas', cmb_rec.get('desc_ingas')); 
    	}
    	
    	var cmb_rec = this.detCmp['id_orden_trabajo'].store.getById(rec.get('id_orden_trabajo'));
    	if(cmb_rec){
    		rec.set('desc_orden_trabajo', cmb_rec.get('desc_orden')); 
    	}
    	
    	var cmb_rec = this.detCmp['id_centro_costo'].store.getById(rec.get('id_centro_costo'));
    	if(cmb_rec){
    		rec.set('desc_centro_costo', cmb_rec.get('codigo_cc')); 
    	}
    	
    },
    
    evaluaRequistos: function(){
    	//valida que todos los requistosprevios esten completos y habilita la adicion en el grid
     	var i = 0;
    	sw = true,
    	me =this;
    	while( i < me.Componentes.length) {
    		
    		if(me.Componentes[i] &&!me.Componentes[i].isValid()){
    		   sw = false;
    		   //i = this.Componentes.length;
    		}
    		i++;
    	}
    	return sw
    },
    
    bloqueaRequisitos: function(sw){
    	this.Cmp.id_plantilla.setDisabled(sw);
    	this.cargarDatosMaestro();
    	
    },
    
    cargarDatosMaestro: function(){
    	
        
        this.detCmp.id_orden_trabajo.store.baseParams.fecha_solicitud = this.Cmp.fecha.getValue().dateFormat('d/m/Y');
        this.detCmp.id_orden_trabajo.modificado = true;
        
        this.detCmp.id_centro_costo.store.baseParams.id_gestion = this.Cmp.id_gestion.getValue();
        this.detCmp.id_centro_costo.store.baseParams.codigo_subsistema = 'ADQ';
        this.detCmp.id_centro_costo.store.baseParams.id_depto = this.Cmp.id_depto_conta.getValue();
        this.detCmp.id_centro_costo.modificado = true;
        //cuando esta el la inteface de presupeustos no filtra por bienes o servicios
        this.detCmp.id_concepto_ingas.store.baseParams.movimiento=(this.Cmp.tipo.getValue()=='compra')?'gasto':'recurso';
        this.detCmp.id_concepto_ingas.store.baseParams.id_gestion=this.Cmp.id_gestion.getValue();
        this.detCmp.id_concepto_ingas.modificado = true;
    	
    },
    
    evaluaGrilla: function(){
    	//al eliminar si no quedan registros en la grilla desbloquea los requisitos en el maestro
    	var  count = this.mestore.getCount();
    	if(count == 0){
    		this.bloqueaRequisitos(false);
    	} 
    },
    
    
    buildDetailGrid: function(){
    	
    	//cantidad,detalle,peso,totalo
        var Items = Ext.data.Record.create([{
                        name: 'cantidad_sol',
                        type: 'float'
                    }, {
                        name: 'id_concepto_ingas',
                        type: 'int'
                    }, {
                        name: 'id_centro_costo',
                        type: 'int'
                    }, {
                        name: 'id_orden_trabajo',
                        type: 'int'
                    },{
                        name: 'precio_unitario',
                        type: 'float'
                    },{
                        name: 'precio_total',
                        type: 'float'
                    }
                    ]);
        
        this.mestore = new Ext.data.JsonStore({
					url: '../../sis_contabilidad/control/DocConcepto/listarDocConcepto',
					id: 'id_doc_concepto',
					root: 'datos',
					totalProperty: 'total',
					fields: ['id_doc_concepto','id_centro_costo','descripcion', 'precio_unitario',
					         'id_doc_compra_venta','id_orden_trabajo','id_concepto_ingas','precio_total','cantidad_sol',
							 'desc_centro_costo','desc_concepto_ingas','desc_orden_trabajo'
					],remoteSort: true,
					baseParams: {dir:'ASC',sort:'id_doc_concepto',limit:'50',start:'0'}
				});
    	
    	this.editorDetail = new Ext.ux.grid.RowEditor({
                saveText: 'Aceptar',
                name: 'btn_editor'
               
            });
            
        this.summary = new Ext.ux.grid.GridSummary();
        // al iniciar la edicion
        this.editorDetail.on('beforeedit', this.onInitAdd , this);
        
        //al cancelar la edicion
        this.editorDetail.on('canceledit', this.onCancelAdd , this);
        
        //al cancelar la edicion
        this.editorDetail.on('validateedit', this.onUpdateRegister, this);
        
        this.editorDetail.on('afteredit', this.onAfterEdit, this);
        
        
        
        
        
        
        
        this.megrid = new Ext.grid.GridPanel({
        	        layout: 'fit',
                    store:  this.mestore,
                    region: 'center',
                    split: true,
                    border: false,
                    plain: true,
                    //autoHeight: true,
                    plugins: [ this.editorDetail, this.summary ],
                    stripeRows: true,
                    tbar: [{
                        /*iconCls: 'badd',*/
                        text: '<i class="fa fa-plus-circle fa-lg"></i> Agregar Concepto',
                        scope: this,
                        width: '100',
                        handler: function(){
                        	if(this.evaluaRequistos() === true){
                        		
	                        		 var e = new Items({
	                        		 	id_concepto_ingas: undefined,
		                                cantidad_sol: 1,
		                                descripcion: '',
		                                precio_total: 0,
		                                precio_unitario: undefined
	                            });
	                            this.editorDetail.stopEditing();
	                            this.mestore.insert(0, e);
	                            this.megrid.getView().refresh();
	                            this.megrid.getSelectionModel().selectRow(0);
	                            this.editorDetail.startEditing(0);
	                            this.sw_init_add = true;
	                            
	                            this.bloqueaRequisitos(true);
                        	}
                        	else{
                        		//alert('Verifique los requisitos');
                        	}
                           
                        }
                    },{
                        ref: '../removeBtn',
                        text: '<i class="fa fa-trash fa-lg"></i> Eliminar',
                        scope:this,
                        handler: function(){
                            this.editorDetail.stopEditing();
                            var s = this.megrid.getSelectionModel().getSelections();
                            for(var i = 0, r; r = s[i]; i++){
                                
                                console.log('al eliminar ...', r);
                                
                                // si se edita el documento y el concepto esta registrado, marcarlo para eliminar de la base
                                if(r.data.id_doc_concepto > 0){
                                	this.conceptos_eliminados.push(r.data.id_doc_concepto);
                                }
                                this.mestore.remove(r);
                            }
                            
                            
                            this.evaluaGrilla();
                        }
                    }],
            
                    columns: [
                    new Ext.grid.RowNumberer(),
                    {
                        header: 'Concepto',
                        dataIndex: 'id_concepto_ingas',
                        width: 200,
                        sortable: false,
                        renderer:function(value, p, record){return String.format('{0}', record.data['desc_concepto_ingas']);},
                        editor: this.detCmp.id_concepto_ingas 
                    },
                    {
                       
                        header: 'Centro de Costo',
                        dataIndex: 'id_centro_costo',
                        align: 'center',
                        width: 200,
                        renderer:function (value, p, record){return String.format('{0}', record.data['desc_centro_costo']);},
                        editor: this.detCmp.id_centro_costo 
                    },
                    {
                       
                        header: 'Orden de Trabajo',
                        dataIndex: 'id_orden_trabajo',
                        align: 'center',
                        width: 150,
                        renderer:function(value, p, record){return String.format('{0}', record.data['desc_orden_trabajo']?record.data['desc_orden_trabajo']:'');},
					    editor: this.detCmp.id_orden_trabajo 
                    },
                    {
                       
                        header: 'Descripción',
                        dataIndex: 'descripcion',
                        
                        align: 'center',
                        width: 200,
                        editor: this.detCmp.descripcion 
                    },
                    {
                       
                        header: 'Cantidad',
                        dataIndex: 'cantidad_sol',
                        align: 'center',
                        width: 50,
                        summaryType: 'sum',
                        editor: this.detCmp.cantidad_sol 
                    },
                    
                    
                    {
                       
                        header: 'P / Unit',
                        dataIndex: 'precio_unitario',
                        align: 'center',
                        width: 50,
                        trueText: 'Yes',
                        falseText: 'No',
                        minValue: 0.001,
                        summaryType: 'sum',
                        editor: this.detCmp.precio_unitario
                    },
                    {
                        xtype: 'numbercolumn',
                        header: 'Importe Total',
                        dataIndex: 'precio_total',
                        format: '$0,0.00',
                        width: 50,
                        sortable: false,
                        summaryType: 'sum',
                        editor: this.detCmp.precio_total 
                    }]
                });
    },
    buildGrupos: function(){
    	this.Grupos = [{
    	           	    layout: 'border',
    	           	    border: false,
    	           	    frame:  true,
	                    items:[
	                      {
                        	xtype: 'fieldset',
	                        border: false,
	                        split: true,
	                        layout: 'column',
	                        region: 'north',
	                        autoScroll: true,
	                        autoHeight: true,
	                        collapseFirst : false,
	                        collapsible: true,
	                        collapseMode : 'mini',
	                        width: '100%',
	                        //autoHeight: true,
	                        padding: '0 0 0 10',
	    	                items:[
		    	                   {
							        bodyStyle: 'padding-right:5px;',
							        width: '33%',
							        autoHeight: true,
							        border: true,
							        items:[
			    	                   {
			                            xtype: 'fieldset',
			                            frame: true,
			                            border: false,
			                            layout: 'form',	
			                            title: 'Tipo',
			                            width: '100%',
			                            
			                            //margins: '0 0 0 5',
			                            padding: '0 0 0 10',
			                            bodyStyle: 'padding-left:5px;',
			                            id_grupo: 0,
			                            items: [],
			                         }]
			                     },
			                     {
			                      bodyStyle: 'padding-right:5px;',
			                     width: '33%',
			                      border: true,
			                      autoHeight: true,
							      items: [{
			                            xtype: 'fieldset',
			                            frame: true,
			                            layout: 'form',
			                            title: ' Datos básicos ',
			                            width: '100%',
			                            border: false,
			                            //margins: '0 0 0 5',
			                            padding: '0 0 0 10',
			                            bodyStyle: 'padding-left:5px;',
			                            id_grupo: 1,
			                            items: [],
			                         }]
		                         },
			                     {
			                      bodyStyle: 'padding-right:2px;',
			                      width: '33%',
			                      border: true,
			                      autoHeight: true,
							      items: [{
			                            xtype: 'fieldset',
			                            frame: true,
			                            layout: 'form',
			                            title: 'Tiempo',
			                            width: '100%',
			                            border: false,
			                            //margins: '0 0 0 5',
			                            padding: '0 0 0 10',
			                            bodyStyle: 'padding-left:2px;',
			                            id_grupo: 2,
			                            items: [],
			                         }]
		                         }
    	                      ]
    	                  },
    	                    this.megrid
                         ]
                 }];
    	
    	
    },
    
    loadValoresIniciales:function() 
    {        
        
       Phx.vista.FormCompraVenta.superclass.loadValoresIniciales.call(this);
        
        
        
    },
    
   
                
    
    
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
					name: 'id_gestion'
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
				maxLength:3
			},
			type: 'TextField',
			id_grupo: 1,
			form: false
		},
		
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
                minChars:2
            },
            type:'ComboBox',
            id_grupo: 0,
            form: true
        },
		{
            config:{
                name:'id_moneda',
                origen:'MONEDA',
                allowBlank:false,
                fieldLabel:'Moneda',
                gdisplayField:'desc_moneda',
                gwidth:100,
                width:250
             },
            type:'ComboRec',
            id_grupo:0,
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
				width: 40
			},
				type:'NumberField',
				id_grupo:0,
				form: true
		},
		
		{
			config:{
				name: 'fecha',
				fieldLabel: 'Fecha',
				allowBlank: false,
				anchor: '80%',
				format: 'd/m/Y',
				readOnly:true,
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				id_grupo:0,
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
                queryParam: 'nro_autorizacion',
                listWidth:'280',
                forceSelection:false,
                autoSelect: false,
                hideTrigger:true,
                typeAhead: false,
                typeAheadDelay: 75,
                lazyRender:false,
                mode:'remote',
                pageSize:20,
                queryDelay:500,
                minChars:1
            },
            type:'ComboBox',
            id_grupo: 0,
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
                minChars:1
            },
            type:'ComboBox',
            id_grupo: 0,
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
				maxLength:180
			},
				type:'TextField',
				id_grupo:0,
				form:true
		},
		{
			config:{
				name: 'nro_documento',
				fieldLabel: 'Nro Doc',
				allowBlank: false,
				anchor: '80%',
				maxLength:100
			},
				type:'TextField',
				id_grupo:1,
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
				id_grupo:1,
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
				id_grupo:1,
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
				id_grupo:1,
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
				id_grupo:2,
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
				id_grupo:2,
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
				id_grupo:2,
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
				id_grupo:2,
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
				id_grupo:2,
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
				id_grupo: 2,
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
				id_grupo:2,
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
				id_grupo:2,
				form: true
		}
		
		
	],
	title: 'Frm solicitud',
	iniciarEventos: function(){
		
		this.Cmp.dia.on('change',function( cmp, newValue, oldValue){
			var dia =  newValue>9?newValue:'0'+newValue, 
			    mes =  this.data.tmpPeriodo>9?this.data.tmpPeriodo:'0'+this.data.tmpPeriodo,
			    tmpFecha = dia+'/'+mes+'/'+this.data.tmpGestion;
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
           }
           else{
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
	
	
    onEdit:function(){
        this.Cmp.nit.modificado = true;
 	    this.Cmp.nro_autorizacion.modificado = true;
    	this.accionFormulario = 'EDIT';
    	
    	this.loadForm(this.data.datosOriginales);
    	
    	this.esconderImportes();
        //carga configuracion de plantilla
        this.getPlantilla(this.Cmp.id_plantilla.getValue());
        
        this.Cmp.id_depto_conta.setValue(this.data.id_depto);
        this.Cmp.id_gestion.setValue(this.data.id_gestion);
        this.Cmp.tipo.setValue(this.data.tipoDoc); 
        //load detalle de conceptos
        this.mestore.baseParams.id_doc_compra_venta = this.Cmp.id_doc_compra_venta.getValue();
        this.mestore.load()
        
        
        	
        
    },
    
    onNew: function(){
    	
    	this.accionFormulario = 'NEW';
    	this.Cmp.nit.modificado = true;
 	    this.Cmp.nro_autorizacion.modificado = true;
        this.esconderImportes();
         console.log('datos del padre....',this, this.data)
        
        this.Cmp.id_depto_conta.setValue(this.data.id_depto);
        this.Cmp.id_gestion.setValue(this.data.id_gestion);
        this.Cmp.tipo.setValue(this.data.tipoDoc); 
       
       
	},
   
    onSubmit: function(o) {
    	//  validar formularios
        var arra = [], total_det = 0.0, i, me = this;
        for (i = 0; i < me.megrid.store.getCount(); i++) {
    		record = me.megrid.store.getAt(i);
    		arra[i] = record.data;
    		total_det = total_det + (record.data.precio_total)*1
    		
		}
		
		//si tiene conceptos eliminados es necesari oincluirlos ...
		
		
		me.argumentExtraSubmit = { 'id_doc_conceto_elis': this.conceptos_eliminados.join(), 
		                           'json_new_records': JSON.stringify(arra, function replacer(key, value) {
   	    	           if (typeof value === 'string') {
							        return String(value).replace(/&/g, "%26")
							    }
							    return value;
							}) };
							
   	    if( i > 0 &&  !this.editorDetail.isVisible()){
   	    	
   	    	
   	    	console.log('doc', this.Cmp.importe_doc.getValue(), 'detalle', total_det);
   	    	
   	    	if (total_det*1 == this.Cmp.importe_doc.getValue()){
   	    		Phx.vista.FormCompraVenta.superclass.onSubmit.call(this, o, undefined, true);
   	    	}
   	    	else{
   	    		alert('El total del detalle no cuadra con el total del documento');
   	    	}
   	    	
   	    	
   	    }
   	    else{
   	    	alert('no tiene ningun concepto  en el documento')
   	    }
   	},
   
   
   	 successSave:function(resp)
    {
        Phx.CP.loadingHide();
        Phx.CP.getPagina(this.idContenedorPadre).reload();
        this.panel.close();
    },
    
     checkRelacionConcepto: function(cfg){
    	var me = this;
    	Phx.CP.loadingShow();
		Ext.Ajax.request({
			url:'../../sis_contabilidad/control/DocConcepto/verificarRelacionConcepto',
			params:{ 
				      id_centro_costo: cfg.id_centro_costo, 
				      id_gestion: cfg.id_gestion, 
				      id_concepto_ingas: cfg.id_concepto_ingas,
				      relacion: me.data.tipoDoc
				      },
			success: function(resp){
				Phx.CP.loadingHide();
		        var objRes = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
		        
			},
			failure: function(resp){
				
				this.conexionFailure(resp);
				Phx.CP.loadingHide();
			},
			timeout: this.timeout,
			scope: this
		});
    	
    },
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
     }
    
   
    
   
	
    
})    
</script>