<?php
/**
*@package pXP
*@file    SolModPresupuesto.php
*@author  Rensi Arteaga Copari 
*@date    30-01-2014
*@description permites subir archivos a la tabla de documento_sol
*/
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
Phx.vista.FormFiltro=Ext.extend(Phx.frmInterfaz,{
    constructor:function(config)
    {   
    	
    	console.log('configuracion.... ',config)
    	this.panelResumen = new Ext.Panel({html:''});
    	this.Grupos = [{

	                    xtype: 'fieldset',
	                    border: false,
	                    autoScroll: true,
	                    layout: 'form',
	                    items: [],
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
					allowBlank: true,
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
					allowBlank: true,
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
    // Funcion guardar del formulario
    onSubmit: function(o) {
    	var me = this;
    	if (me.form.getForm().isValid()) {
             var parametros = me.getValForm()
             this.onEnablePanel(this.idContenedor + '-east', parametros)                    
        }

    },
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