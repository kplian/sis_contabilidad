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
Phx.vista.FormFiltroBalanceTipoCC=Ext.extend(Phx.frmInterfaz,{
    constructor:function(config)
    {   
    	this.panelResumen = new Ext.Panel({html:'Hola Prueba'});
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
				    
        Phx.vista.FormFiltroBalanceTipoCC.superclass.constructor.call(this,config);
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
                width:350,
                listWidth:'350',
                resizable:true,
                minChars: 2
            },   			
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
	       		    width:350,
	       		    mode: 'local',
	       		    valueField: 'autentificacion',
	       		    store:[1,2,3,4,5,6,7,8]
	       		    
	       		},
	       		type:'ComboBox',
	       		id_grupo:0,
	       		form:true
	      },
	      {
	   		config:{
		    			
		    			tinit:false,
		    			resizable:true,
		    			tasignacion:false,
				        name:'id_tipo_ccs',
			   			fieldLabel:'Tipo Centro',
			   			llowBlank:false,
			   			emptyText:'Tipo de Centro...',
			   			baseParams: {movimiento:'si'},
			   			store: new Ext.data.JsonStore({		
		    					url:  '../../sis_parametros/control/TipoCc/listarTipoCcAll',
		    					id: 'id_tipo_cc',
		    					root: 'datos',
		    					sortInfo:{
		    						field: 'codigo',
		    						direction: 'ASC'
		    					},
		    					totalProperty: 'total',
		    					fields: [
										'id_tipo_cc','codigo','control_techo','mov_pres','estado_reg', 
										'movimiento', 'id_ep','id_tipo_cc_fk','descripcion','tipo', 
										'control_partida','momento_pres','desc_ep',
										{name:'fecha_inicio', type: 'date',dateFormat:'Y-m-d'},
										{name:'fecha_final', type: 'date',dateFormat:'Y-m-d'}],
		    					// turn on remote sorting
		    					remoteSort: true,
		    					baseParams:{par_filtro:'tcc.id_tipo_cc#tcc.codigo#tcc.descripcion#tcc.desc_ep'}
		    					
		    				}), 
		    			 tpl: '<tpl for="."><div class="x-combo-list-item" ><div class="awesomecombo-item {checked}">{codigo}-{desc_orden}</div><p style="padding-left: 20px;">Tipo:{tipo}</p> </div></tpl>',
	
	    				tpl: new Ext.XTemplate([
										     	'<tpl for=".">',
										     	'<div class="x-combo-list-item">',
										     	'<div class="awesomecombo-item {checked}">',
										    		'<tpl if="tipo == \'centro\'">',
									    		      '<p><b><font color="green">{codigo}</font></b></p>',
									    		    '</tpl>',
									    		    '<tpl if="tipo == \'proyecto\'">',
									    		      '<p><b><font color="orange">{codigo}</font></b></p>',
									    		    '</tpl>',
									    		    '<tpl if="tipo == \'orden\'">',
									    		      '<p><b><font color="red">{codigo}</font></b></p>',
									    		    '</tpl>',
									    		    '<tpl if="tipo == \'estadistica\'">',
									    		      '<p><b><font color="blue">{codigo}</font></b></p>',
									    		    '</tpl>',
									    		    '</div><p><b>Desc: {descripcion}</b></p>',		   
									    		    '<p>Tipo: {tipo}</p>',			    		    
									    		    '<p>Ini: {fecha_inicio:date("d/m/Y")}</p>',
									    		    '<p>Fin.: {fecha_final:date("d/m/Y")}</p>',	
									    		    '<p>EP: {desc_ep}</p>',	    		   
									    		 '</div></tpl>'			     
											   ]),	
	    				valueField: 'id_tipo_cc',
	       				displayField: 'codigo',
	       				gdisplayField: 'desc_tcc',
	       				hiddenName: 'id_tipo_cc',
	       				forceSelection:true,
	       				typeAhead: false,
	           			triggerAction: 'all',
	           			lazyRender:true,
	       				mode:'remote',
	       				pageSize:10,
	       				queryDelay:1000,
	       				enableMultiSelect: true,
	       				listWidth:'320',
	       				width:350,
	       				minChars:2
		    		},
   			type:'AwesomeCombo',
   			id_grupo:0,
   			filters:{pfiltro:'vcc.codigo_tcc#vcc.descripcion_tcc',type:'string'},
   		    grid:true,
   			form:true
	    },
	   	
	     
	      
	     {
			config:{
				name: 'tipo',
				fieldLabel: 'Tipo de Orden?',
				allowBlank: false,
				width:350,							
				emptyText:'tipo...',       			
       			typeAhead: true,
       		    triggerAction: 'all',
       		    lazyRender:true,
       		    mode: 'local',
       		    valueField: 'inicio',
       		    enableMultiSelect:true ,   
       		    store:['centro','edt','orden','estadistica']
			},
			type:'AwesomeCombo',
			id_grupo:1,		
			grid:true,
			form:true
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
	       		    width:350,	       		   
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
	       			qtip : 'Incluir solo cuentas con movimiento?',
	       			fieldLabel: 'Solo con movimiento',
	       			allowBlank: false,
	       			emptyText:'Tipo...',
	       			typeAhead: true,
	       		    triggerAction: 'all',
	       		    lazyRender:true,
	       		    mode: 'local',
	       		    width:350,	       		   
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
	       			name: 'incluir_adm',
	       			qtip : 'Incluir centros administrativos?',
	       			fieldLabel: 'Incuir administritavios',
	       			allowBlank: false,
	       			emptyText:'Tipo...',
	       			typeAhead: true,
	       		    triggerAction: 'all',
	       		    lazyRender:true,
	       		    mode: 'local',
	       		    width:350,	       		   
	       		    store:['no','si']
	       		},
	       		type:'ComboBox',
	       		id_grupo:0,
	       		valorInicial: 'si',
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
	      {
	       		config:{
	       			name: 'moneda',
	       			qtip : 'Moenda en que se generara el repote',
	       			fieldLabel: 'Moneda',
	       			allowBlank: false,
	       			emptyText:'Tipo...',
	       			typeAhead: true,
	       		    triggerAction: 'all',
	       		    lazyRender:true,
	       		    mode: 'local',
	       		    gwidth: 100,
	       		    store:['base','triangulacion']
	       		},
	       		type:'ComboBox',
	       		id_grupo:0,
	       		valorInicial: 'base',
	       		form:true
	      }
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
						url : '../../sis_contabilidad/control/Cuenta/reporteBalanceTipoCC',
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