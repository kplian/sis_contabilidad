<?php
/**
*@package pXP
*@file    FormFiltroEstadoCuenta.php
*@author  Rensi Arteaga Copari 
*@date    27-07-2017
*@description filtro para ejecutar el estado de cuentas
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.FormFiltroEstadoCuenta=Ext.extend(Phx.frmInterfaz,{
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
				    
        Phx.vista.FormFiltroEstadoCuenta.superclass.constructor.call(this,config);
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
   				sysorigen: 'sis_contabilidad',
       		    name: 'id_auxiliar',
   				origen: 'AUXILIAR',
   				allowBlank: false,
   				gdisplayField: 'desc_cuenta',
   				fieldLabel: 'Auxiliar',
   				width: 150
       	     },
   			type:'ComboRec',
   			id_grupo: 0,
   			form: true
	     	},
	     	
	     	{
				config: {
					name: 'id_tipo_estado_cuenta',
					fieldLabel: 'Tipo Estado',
					typeAhead: false,
					forceSelection: false,
					allowBlank: false,
					emptyText: 'Tipos...',
					store: new Ext.data.JsonStore({
						url: '../../sis_contabilidad/control/TipoEstadoCuenta/listarTipoEstadoCuenta',
						id: 'id_tipo_estado_cuenta',
						root: 'datos',
						sortInfo: {
							field: 'nombre',
							direction: 'ASC'
						},
						totalProperty: 'total',
						fields: ['id_tipo_estado_cuenta','nombre', 'codigo'],
						remoteSort: true,
						baseParams: {par_filtro: 'nombre'}
					}),
					valueField: 'id_tipo_estado_cuenta',
					displayField: 'nombre',
					gdisplayField: 'desc_tec',
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
		  }

    ],
    labelSubmit: '<i class="fa fa-check"></i> Aplicar Filtro',
    east: {
          url: '../../../sis_contabilidad/vista/tipo_estado_cuenta/EstadoCuenta.php',
          width: '60%',
          cls: 'EstadoCuenta'
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
    	
    	
    },
    
    loadValoresIniciales: function(){
    	Phx.vista.FormFiltroEstadoCuenta.superclass.loadValoresIniciales.call(this);
    	
    }
    
})    
</script>