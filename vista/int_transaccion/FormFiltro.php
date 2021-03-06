<?php
/**
*@package pXP
*@file    SolModPresupuesto.php
*@author  Rensi Arteaga Copari 
*@date    30-01-2014
*@description permites subir archivos a la tabla de documento_sol
*/
/**
HISTORIAL DE MODIFICACIONES:
ISSUE 		   FECHA   			 AUTOR				 DESCRIPCION:
#6 			27/12/2108		  Manuel Guerra	  agrego el filtro de cbtes de cierre
#17 		09/01/2019		  Manuel Guerra	  agrego el filtro de nro_tramite_aux
 */
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
Phx.vista.FormFiltro=Ext.extend(Phx.frmInterfaz,{
	
    constructor:function(config)
    {   
    	this.panelResumen = new Ext.Panel({html:''});
    	this.Grupos = 
    	[
            {
                xtype: 'fieldset',
                border: true,
                autoScroll: true,
                layout: 'form',
                items:
                [
                ],
                id_grupo: 0
            },
            this.panelResumen
	    ];
				    
        Phx.vista.FormFiltro.superclass.constructor.call(this,config);
        this.init(); 
        this.iniciarEventos(); 
        
        if(config.detalle){
        	
			//cargar los valores para el filtro
			this.loadForm({data: config.detalle});
			var me = this;
			setTimeout(function(){
				me.onSubmit()
			}, 1500);
			
		}
	
    },
    
  
    
    Atributos:[
           {
	   			config:{
	   				name : 'tipo_filtro',
	   				fieldLabel : 'Filtros',
	   				items: [
		                {boxLabel: 'Gestión', name: 'tipo_filtro', inputValue: 'gestion', checked: true},
		                {boxLabel: 'Solo fechas', name: 'tipo_filtro', inputValue: 'fechas'}
		            ],
		            
		    
	   			},
	   			type : 'RadioGroupField',
	   			id_grupo : 0,
	   			form : true
	   	   },
           {
	   			config:{
	   				name : 'id_gestion',
	   				origen : 'GESTION',
	   				fieldLabel : 'Gestion',
	   				gdisplayField: 'desc_gestion',
	   				allowBlank : false,
	   				width: 150
	   			},
	   			type : 'ComboRec',
	   			id_grupo : 0,
	   			form : true
	   	   },
	   	   {
				config:{
					name: 'desde',
					fieldLabel: 'Desde',
					allowBlank: false,
					format: 'd/m/Y',
					width: 150
				},
				type: 'DateField',
				id_grupo: 0,
				form: true
		  },
		  {
				config:{
					name: 'hasta',
					fieldLabel: 'Hasta',
					allowBlank: false,
					format: 'd/m/Y',
					width: 150
				},
				type: 'DateField',
				id_grupo: 0,
				form: true
		  },
		  {
			config:{
				name:'id_depto',
				hiddenName: 'id_depto',
				url: '../../sis_parametros/control/Depto/listarDeptoFiltradoXUsuario',
				origen:'DEPTO',
				allowBlank:true,
				fieldLabel: 'Depto',
				baseParams:{estado:'activo',codigo_subsistema:'CONTA'},
				width: 150
			},
			type:'ComboRec',
			id_grupo:0,
			form:true
         },
         {
			config: {
				name: 'id_config_tipo_cuenta',
				fieldLabel: 'Tipo Cuenta',
				typeAhead: false,
				forceSelection: false,
				allowBlank: true,
				emptyText: 'Tipos...',
				store: new Ext.data.JsonStore({
					url: '../../sis_contabilidad/control/ConfigTipoCuenta/listarConfigTipoCuenta',
					id: 'id_config_tipo_cuenta',
					root: 'datos',
					sortInfo: {
						field: 'nro_base',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_config_tipo_cuenta','tipo_cuenta', 'nro_base'],
					// turn on remote sorting
					remoteSort: true,
					baseParams: {par_filtro: 'tipo_cuenta'}
				}),
				valueField: 'id_config_tipo_cuenta',
				displayField: 'tipo_cuenta',
				gdisplayField: 'tipo_cuenta',
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 20,
				queryDelay: 200,
				width: 150,
				listWidth:280,
				minChars: 2
				},
			type: 'ComboBox',	
			id_grupo: 0,
			form: true,
			grid:false
		 },
		 {
			config: {
					name: 'id_config_subtipo_cuenta',
					fieldLabel: 'Subtipo',
					typeAhead: false,
					forceSelection: false,
					allowBlank: true,
					emptyText: 'Tipos...',
					store: new Ext.data.JsonStore({
						url: '../../sis_contabilidad/control/ConfigSubtipoCuenta/listarConfigSubtipoCuenta',
						id: 'id_config_subtipo_cuenta',
						root: 'datos',
						sortInfo: {
							field: 'codigo',
							direction: 'ASC'
						},
						totalProperty: 'total',
						fields: ['tipo_cuenta', 'id_config_subtipo_cuenta','nombre','codigo'],
						// turn on remote sorting
						remoteSort: true,
						baseParams: {par_filtro: 'cst.nombre#cst.codigo'}
					}),
					valueField: 'id_config_subtipo_cuenta',
					displayField: 'nombre',
					gdisplayField: 'desc_csc',
					triggerAction: 'all',
					lazyRender: true,
					mode: 'remote',
					pageSize: 20,
					width: 150,
					queryDelay: 200,
					listWidth:280,
					minChars: 2
				},
			type: 'ComboBox',
			id_grupo: 0,
			form: true
		 },
   	 	 {
   			config:{
   				sysorigen: 'sis_contabilidad',
       		    name: 'id_cuenta',
   				origen: 'CUENTA',
   				allowBlank: true,
   				fieldLabel: 'Cuenta',
   				gdisplayField: 'desc_cuenta',
   				baseParams: { sw_transaccional: undefined },
   				width: 150
       	     },
   			type: 'ComboRec',
   			id_grupo: 0,
   			form: true
	   	},
	   	{
   			config:{
   				sysorigen: 'sis_contabilidad',
       		    name: 'id_auxiliar',
   				origen: 'AUXILIAR',
   				allowBlank: true,
   				gdisplayField: 'desc_auxiliar',
   				fieldLabel: 'Auxiliar',
   				width: 150
       	     },
   			type:'ComboRec',
   			id_grupo: 0,
   			form: true
	   	},
	   	{
   			config:{
   				sysorigen: 'sis_presupuestos',
       		    name: 'id_partida',
   				origen: 'PARTIDA',
   				gdisplayField: 'desc_partida',
   				allowBlank: true,
   				fieldLabel: 'Partida',
   				width: 150
       	     },
   			type:'ComboRec',
   			id_grupo:0,
   			form:true
	   	},
	   	
	   	{
	   		config:{
	   				name:'id_tipo_cc',
	   				qtip: 'Tipo de centro de costos, cada tipo solo puede tener un centro por gestión',	   				
	   				origen:'TIPOCC',
	   				fieldLabel:'Tipo Centro',
	   				gdisplayField: 'desc_tipo_cc',
	   				url:  '../../sis_parametros/control/TipoCc/listarTipoCcAll',
	   				baseParams: {movimiento:''},	   				
	   				allowBlank:true,
	   				width: 150 
	   				
	      		},
   			type:'ComboRec',
   			id_grupo:0,
   			filters:{pfiltro:'vcc.codigo_tcc#vcc.descripcion_tcc',type:'string'},
   		    grid:true,
   			form:true
	    },
	   	
	   	
	   	{
            config:{
                name: 'id_centro_costo',
                fieldLabel: 'Centro Costo',
                allowBlank: true,
                tinit: false,
                origen: 'CENTROCOSTO',
                gdisplayField: 'desc_centro_costo',
                width: 150
            },
            type: 'ComboRec',
            id_grupo: 0,
            form: true
        },
        {
            config:{
                    name: 'id_orden_trabajo',
                    fieldLabel: 'Ordenes',
                    tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{codigo}</b></p><p>{desc_orden}</p> <p>Tipo:{tipo}</p></div></tpl>',
                    sysorigen: 'sis_contabilidad',
	       		    origen: 'OT',
                    allowBlank: true,
                    gwidth: 200,
                    store : new Ext.data.JsonStore({
                            url:'../../sis_contabilidad/control/OrdenTrabajo/listarOrdenTrabajoAll',
                            id : 'id_orden_trabajo',
                            root: 'datos',
                            sortInfo:{
                                    field: 'motivo_orden',
                                    direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_orden_trabajo','motivo_orden','desc_orden','motivo_orden','codigo','tipo'],
                            remoteSort: true,
                            baseParams:{par_filtro:'desc_orden#motivo_orden'}
                    }),
                    width: 150
            
            },
            type: 'ComboRec',
            id_grupo: 0,
            form: true
        },
        {
            config:{
                    name:'id_suborden',
                    fieldLabel: 'Suborden',
                    sysorigen:'sis_contabilidad',
	       		    origen:'SUBORDEN',
                    allowBlank:true,
                    gwidth:200,
                    width: 150,
   				    listWidth: 380
            
            },
            type:'ComboRec',
            id_grupo:0,
            filters:{pfiltro:'suo.codigo#suo.nombre',type:'string'},
            grid:false,
            form:true
        },
        
        {
			config: {
				name: 'nro_tramite',
				allowBlank: true,
				fieldLabel: 'Nro. Trámite',
				width: 150
			},
			type: 'Field',
			id_grupo: 0,
			form: true
		},
		//#17
		{
			config: {
				name: 'nro_tramite_aux',
				allowBlank: true,
				fieldLabel: 'Nro. Trámite Aux',
				width: 150
			},
			type: 'Field',
			id_grupo: 0,
			form: true
		},
		{
			config:{
				name: 'cbte_cierre',
				qtip : 'Incluir los comprobantes de cierre en el balance',
				fieldLabel: 'Incluir cbtes. cierres',
				allowBlank: false,
				emptyText:'Tipo...',
				typeAhead: true,
				triggerAction: 'all',
				lazyRender:true,
				mode: 'local',
				width:150,	
				store:['no','balance','resultado','todos']
			},
			type:'ComboBox',
			id_grupo:0,
			valorInicial: 'no',
			grid:true,
			form:true
		},
		// #6
		{
			config:{
				name : 'cerrado',
				fieldLabel : 'Filtrar Cerradas',
				items: [
					{boxLabel: 'Si', name: 'cerrado', inputValue: 'si'},
					{boxLabel: 'No', name: 'cerrado', inputValue: 'no', checked: true}
				],
			},
			type : 'RadioGroupField',
			id_grupo : 0,
			form : true
		 }

	],
	labelSubmit: '<i class="fa fa-check"></i> Aplicar Filtro',
	east: {
		url: '../../../sis_contabilidad/vista/int_transaccion/IntTransaccionMayor.php',
		title: undefined, 
		width: '70%',
		cls: 'IntTransaccionMayor'
	},
	title: 'Filtro de mayores',
	autoScroll: true,
	// Funcion guardar del formulario
	//#6  #17
	onSubmit: function(o) {    	
		var me = this;
		if (me.form.getForm().isValid()) {		
			var parametros = me.getValForm();
			
			var gest=this.Cmp.id_gestion.lastSelectionText;
			var dpto=this.Cmp.id_depto.lastSelectionText;
			var tpocuenta=this.Cmp.id_config_tipo_cuenta.lastSelectionText;
			var subtpocuenta=this.Cmp.id_config_subtipo_cuenta.lastSelectionText;
			
			var cuenta=this.Cmp.id_cuenta.lastSelectionText;
			var auxiliar=this.Cmp.id_auxiliar.lastSelectionText;
			var partida=this.Cmp.id_partida.lastSelectionText;
			var tcc=this.Cmp.id_tipo_cc.lastSelectionText;
			
			var cc=this.Cmp.id_centro_costo.lastSelectionText;
			var ot=this.Cmp.id_orden_trabajo.lastSelectionText;
			var suborden=this.Cmp.id_suborden.lastSelectionText;
			var nro_tram=this.Cmp.nro_tramite.lastSelectionText;
			var nro_tram_aux=this.Cmp.nro_tramite_aux.lastSelectionText;		
			var cerrar= this.Cmp.cerrado.getValue();	
			var cbte_cierre= this.Cmp.cbte_cierre.getValue();		
			this.onEnablePanel(this.idContenedor + '-east', 
				Ext.apply(parametros,{	
					'gest': gest,
					'dpto': dpto,
					'tpocuenta': tpocuenta,
					'subtpocuenta': subtpocuenta,
					'cuenta': cuenta,
					'auxiliar': auxiliar,
					'partida': partida,
					'tcc' : tcc,										
					'cc' : cc,
					'ot' : ot,
					'suborden' : suborden,
					'nro_tram' : nro_tram,
					'nro_tram_aux' : nro_tram_aux,
					'cerrar':cerrar,
					'cbte_cierre':cbte_cierre
				}));
		}
	},
	//
	iniciarEventos:function(){
		this.Cmp.id_gestion.on('select', function(cmb, rec, ind){
			
		 Ext.apply(this.Cmp.id_cuenta.store.baseParams,{id_gestion: rec.data.id_gestion})
			 Ext.apply(this.Cmp.id_partida.store.baseParams,{id_gestion: rec.data.id_gestion})
			 Ext.apply(this.Cmp.id_centro_costo.store.baseParams,{id_gestion: rec.data.id_gestion})
			 this.Cmp.id_cuenta.reset();
			 this.Cmp.id_partida.reset();
			 this.Cmp.id_centro_costo.reset();
			 this.Cmp.id_cuenta.modificado = true;
			 this.Cmp.id_partida.modificado = true;
			 this.Cmp.id_centro_costo.modificado = true;
    		
    	},this);
    	
    	this.Cmp.id_config_tipo_cuenta.on('select', function(cmb, rec, ind){
    		
    		this.Cmp.id_config_subtipo_cuenta.reset();
    		this.Cmp.id_config_subtipo_cuenta.store.baseParams.id_config_tipo_cuenta =  cmb.getValue();
    		this.Cmp.id_config_subtipo_cuenta.modificado = true;
    		
    		this.Cmp.id_cuenta.reset();
    		this.Cmp.id_cuenta.store.baseParams.tipo_cuenta = rec.data.tipo_cuenta;
    	    this.Cmp.id_cuenta.modificado = true;
    		
    	},this);
    	
    	
    	this.Cmp.id_config_subtipo_cuenta.on('select', function(cmb, rec, ind){
    		this.Cmp.id_cuenta.reset();
    		this.Cmp.id_cuenta.store.baseParams.id_config_subtipo_cuenta = cmb.getValue();
    	    this.Cmp.id_cuenta.modificado = true;
    		
    	},this);
    	
    	
    	this.Cmp.tipo_filtro.on('change', function(cmp, check){
    		    
    		    if(check.getRawValue() !='gestion'){
    		    	this.Cmp.id_gestion.reset();
    		    	this.ocultarComponente(this.Cmp.id_gestion);
    		    	this.ocultarComponente(this.Cmp.id_cuenta);
    		    	this.ocultarComponente(this.Cmp.id_partida);
    		    	this.ocultarComponente(this.Cmp.id_centro_costo);
    		    }
    		    else{
    		    	this.mostrarComponente(this.Cmp.id_gestion);
    		    	this.mostrarComponente(this.Cmp.id_cuenta);
    		    	this.mostrarComponente(this.Cmp.id_partida);
    		    	this.mostrarComponente(this.Cmp.id_centro_costo);
    		    	
    		    }
    		    	
    		    
    		
    	}, this);
    	
    },
    
    loadValoresIniciales: function(){
    	Phx.vista.FormFiltro.superclass.loadValoresIniciales.call(this);
    	delete this.Cmp.id_config_subtipo_cuenta.store.baseParams.id_config_tipo_cuenta;
    	this.Cmp.id_config_subtipo_cuenta.modificado = true;
    	delete this.Cmp.id_cuenta.store.baseParams.id_gestion;
    	delete this.Cmp.id_cuenta.store.baseParams.tipo_cuenta;
    	delete this.Cmp.id_cuenta.store.baseParams.id_config_subtipo_cuenta;
    	this.Cmp.id_cuenta.modificado = true;
    	
    	
    	
    	
    }
    
})    
</script>
