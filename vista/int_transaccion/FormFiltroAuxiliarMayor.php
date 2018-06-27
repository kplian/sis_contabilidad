<?php
/**
*@package pXP
*@file    FormFiltroAuxiliarMayor.php
*@author  Rensi Arteaga Copari 
*@date    27-07-2017
*@description filtro para ejecutar el estado de cuentas
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.FormFiltroAuxiliarMayor=Ext.extend(Phx.frmInterfaz,{
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
				    
        Phx.vista.FormFiltroAuxiliarMayor.superclass.constructor.call(this,config);
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
	   	}

    ],
    labelSubmit: '<i class="fa fa-check"></i> Aplicar Filtro',
    east: {
          url: '../../../sis_contabilidad/vista/int_transaccion/AuxiliarCuenta.php',
          width: '60%',
          cls: 'AuxiliarCuenta'
         },
    title: 'Filtro de Auxilairess',
    // Funcion guardar del formulario
    onSubmit: function(o) {
    	var me = this;
    	if (me.form.getForm().isValid()) {
             var parametros = me.getValForm()
             this.onEnablePanel(this.idContenedor + '-east', parametros)                    
        }
    },
     
    loadValoresIniciales: function(){
    	Phx.vista.FormFiltroAuxiliarMayor.superclass.loadValoresIniciales.call(this);
    	
    },
    iniciarEventos:function(){
    	this.Cmp.id_gestion.on('select', function(cmb, rec, ind){    		
    		 Ext.apply(this.Cmp.id_cuenta.store.baseParams,{id_gestion: rec.data.id_gestion});			
			 this.Cmp.id_cuenta.reset();			
			 this.Cmp.id_cuenta.modificado = true;
    		
    	},this);
    	
    	
    	
    }
    
})    
</script>