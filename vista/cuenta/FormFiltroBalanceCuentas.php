<?php
/**
*@package pXP
*@file    SolModPresupuesto.php
*@author  Rensi Arteaga Copari 
*@date    30-01-2014
*@description permites subir archivos a la tabla de documento_sol
HISTORIAL DE MODIFICACIONES:
ISSUE 		   FECHA   			 AUTOR				 DESCRIPCION:
#33         10/02/2019		  Miguel Mamani	  Parámetro tipo de moneda reporte balance de cuentas
#60         10/06/2019        RAC             parametros  orden de trabajo reporte de balance OT
*/
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
Phx.vista.FormFiltroBalanceCuentas=Ext.extend(Phx.frmInterfaz,{
    constructor:function(config)
    {   
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
				    
        Phx.vista.FormFiltroBalanceCuentas.superclass.constructor.call(this,config);
        this.init(); 
        this.iniciarEventos();   
       
        
        
    },
    
    Atributos:[
          
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
                name: 'id_deptos',
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
   				displayField: 'codigo',
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
            },
   			//type:'TrigguerCombo',
   			type:'AwesomeCombo',
   			id_grupo:0,
   			form:true
         },
	     {
	       		config:{
	       			name:'nivel',
	       			fieldLabel:'Nivel',
	       			allowBlank:false,
	       			emptyText:'nivel...',
	       			typeAhead: true,
	       		    triggerAction: 'all',
	       		    lazyRender:true,
	       		    mode: 'local',
	       		    valueField: 'autentificacion',
	       		    store:[1,2,3,4,5,6,7,8]
	       		    
	       		},
	       		type:'ComboBox',
	       		id_grupo:0,
	       		form:true
	      },
		 {
			config: {
				name: 'tipo_cuenta',
				fieldLabel: 'Tipo Cuenta',
				typeAhead: false,
				forceSelection: false,
				allowBlank: false,
				emptyText: 'Tipos...',
				store: new Ext.data.JsonStore({
					url: '../../sis_contabilidad/control/ConfigTipoCuenta/listarConfigTipoCuenta',
					id: 'tipo_cuenta',
					root: 'datos',
					sortInfo: {
						field: 'nro_base',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['tipo_cuenta', 'nro_base'],
					// turn on remote sorting
					remoteSort: true,
					baseParams: {par_filtro: 'tipo_cuenta'}
				}),
				valueField: 'tipo_cuenta',
				displayField: 'tipo_cuenta',
				gdisplayField: 'tipo_cuenta',
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 20,
				queryDelay: 200,
				listWidth:280,
				minChars: 2,
				gwidth: 90,
	       			enableMultiSelect:true
				},
			type: 'AwesomeCombo',
			id_grupo: 0,
			form: true
		},
	     
       	{
	       		config:{
	       			name: 'incluir_cierre',
	       			qtip : 'Incluir los comprobantes de cierre en el balance',
	       			fieldLabel: 'Incluir cierre',
	       			allowBlank: false,
	       			emptyText:'Tipo...',
	       			typeAhead: true,
	       		    triggerAction: 'all',
	       		    lazyRender:true,
	       		    mode: 'local',
	       		    gwidth: 100,
	       		    store:['no','balance','resultado','todos']
	       		},
	       		type:'ComboBox',
	       		id_grupo:0,
	       		valorInicial: 'no',
	       		grid:true,
	       		form:true
	      },
	      {
	       		config:{
	       			name: 'incluir_sinmov',
	       			qtip : 'Incluir slo cuentas con movimiento?',
	       			fieldLabel: 'Solo con movimiento',
	       			allowBlank: false,
	       			emptyText:'Tipo...',
	       			typeAhead: true,
	       		    triggerAction: 'all',
	       		    lazyRender:true,
	       		    mode: 'local',
	       		    gwidth: 100,
	       		    store:['no','si']
	       		},
	       		type:'ComboBox',
	       		id_grupo:0,
	       		valorInicial: 'no',
	       		grid:true,
	       		form:true
	       },
	       {
	       		config:{
	       			name: 'formato',
	       			qtip : 'formato de salida del reporte',
	       			fieldLabel: 'Formato',
	       			allowBlank: false,
	       			emptyText:'Tipo...',
	       			typeAhead: true,
	       		    triggerAction: 'all',
	       		    lazyRender:true,
	       		    mode: 'local',
	       		    gwidth: 100,
	       		    store:['pdf','excel']
	       		},
	       		type:'ComboBox',
	       		id_grupo:0,
	       		valorInicial: 'pdf',
	       		form:true
	     },
        //#33 MMV
        {
            config:{
                name:'tipo_moneda',
                fieldLabel:'Tipo de Moneda',
                allowBlank:false,
                emptyText:'Tipo de moneda...',
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                valueField: 'tipo_moneda',
                gwidth: 100,
                store:new Ext.data.ArrayStore({
                    fields: ['variable', 'valor'],
                    data : [
                        ['MB','Moneda Base'],
                        ['MT','Moneda Triangulacion'],
                        ['MA','Moneda Actualizacion']
                    ]
                }),
                valueField: 'variable',
                displayField: 'valor',
                listeners: {
                    'afterrender': function(combo){
                        combo.setValue('MB');
                    }
                }
            },
            type:'ComboBox',
            form:true
        }, // #33
        
        { //#60 bigin
          config:{			
			 name: 'id_ordenes_trabajos',
             fieldLabel: 'Orden de Costo',
             allowBlank: true,
			 tip:'Puede escoger uan rama especifica para reportar',
			 tinit:false,
			 tasignacion:true,
			 resizable:true,            
             emptyText : 'Ordenes...',            
             tpl: '<tpl for="."><div class="x-combo-list-item" ><div class="awesomecombo-item {checked}">{codigo}-{desc_orden}</div><p style="padding-left: 20px;">Tipo:{tipo}</p> </div></tpl>',
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
               valueField: 'id_orden_trabajo',
               displayField: 'desc_orden',
               gdisplayField: 'desc_orden',
               hiddenName: 'id_ordenes_trabajos',
               forceSelection:true,
               typeAhead: false,
               triggerAction: 'all',
                listWidth:350,
               lazyRender:true,
               mode:'remote',
               pageSize:10,
               queryDelay:1000,
               width:350,
               listWidth:'280',               
               enableMultiSelect: true,
               minChars:2
            },   			
   			type:'AwesomeCombo',
   			id_grupo:0,
   			form:true
         } //#60 end
    ],
    labelSubmit: '<i class="fa fa-check"></i> Aplicar Filtro',
    title: 'Filtro de mayores',
    // Funcion guardar del formulario
    onSubmit: function(o) {
    	var me = this;
    	if (me.form.getForm().isValid()) {
             var parametros = me.getValForm()
             Phx.CP.loadingShow();
             
             var deptos = this.Cmp.id_deptos.getValue('object');
             console.log('deptos',deptos)
             var sw = 0, codigos = ''
             deptos.forEach(function(entry) {
			    if(sw == 0){
			    	codigos = entry.codigo;
			    }
			    else{
			    	codigos = codigos + ', '+ entry.codigo;
			    }
			    sw = 1;
			});
             
             Ext.Ajax.request({
						url : '../../sis_contabilidad/control/Cuenta/reporteBalanceGeneral',
						params : Ext.apply(parametros,{'codigos': codigos, 'tipo_balance':'todos'}),
						success : this.successExport,
						failure : this.conexionFailure,
						timeout : this.timeout,
						scope : this
					})
                    
        }

    }
    
    
})    
</script>