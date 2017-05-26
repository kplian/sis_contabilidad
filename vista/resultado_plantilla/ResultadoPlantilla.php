<?php
/**
*@package pXP
*@file gen-ResultadoPlantilla.php
*@author  (admin)
*@date 08-07-2015 13:12:43
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ResultadoPlantilla=Ext.extend(Phx.gridInterfaz,{
    nombreVista: 'ResultadoPlantilla',
	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.ResultadoPlantilla.superclass.constructor.call(this,config);
		this.init();
		//Botón para Validación del Comprobante
		this.addButton('btnClonar',
			{
				text: 'Clonar',
				iconCls: 'bchecklist',
				disabled: true,
				handler: this.clonar,
				tooltip: '<b>Clonar</b><br/>Clona la plantilla, su detalle y dependencias'
			}
		);
		
		this.addButton('btnWizard',
            {
                text: 'Exportar Plantilla',
                iconCls: 'bchecklist',
                disabled: false,
                handler: this.expProceso,
                tooltip: '<b>Exportar</b><br/>Exporta a archivo SQL la plantilla'
            }
        );
        
        this.iniciarEventos();
        
		this.load({params:{start:0, limit:this.tam_pag}});
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_resultado_plantilla'
			},
			type:'Field',
			form:true 
		},
	   {
			config:{
				name: 'tipo',
				fieldLabel: 'Tipo Plantilla',
				qtip: 'Tipo de plantilla, para reprote o para insertar comprobante',
				allowBlank: false,
                anchor: '40%',
                gwidth: 80,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store:['reporte' ,'cbte']
            },
            type:'ComboBox',
			filters:{pfiltro:'resplan.tipo',type:'string'},
			valorInicial: 'reporte',
			id_grupo:1,
			grid:true,
			egrid: true,
			form:true
		},
		{
			config:{
				name: 'codigo',
				fieldLabel: 'codigo',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
				type:'TextField',
				filters:{pfiltro:'resplan.codigo',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'nombre',
				fieldLabel: 'nombre',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
				type:'TextField',
				filters:{pfiltro:'resplan.nombre',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		
		{
			config:{
				name: 'cbte_cierre',
				qtip: 'Es un comprobante de cierre?',
				fieldLabel: 'Cierre',
				allowBlank: false,
                anchor: '40%',
                gwidth: 80,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store:['no' ,'balance','resultado']
            },
            type:'ComboBox',
			filters:{pfiltro:'resplan.incluir_cierre',type:'string'},
			valorInicial: 'no',
			id_grupo:1,
			grid:true,
			egrid: true,
			form:true
		},
		{
			config: {
				name: 'cbte_apertura',
				qtip: 'Es un comprobante de apertura',
				fieldLabel: 'Apertura',
				allowBlank: false,
                anchor: '40%',
                gwidth: 80,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store: ['no' ,'si']
            },
            type:'ComboBox',
			filters: { pfiltro: 'resplan.cbte_apertura', type: 'string' },
			valorInicial: 'no',
			id_grupo: 1,
			grid: true,
			egrid: true,
			form: true
		},
		{
			config: {
				name: 'cbte_aitb',
				qtip: 'es un comprobante para AITB',
				fieldLabel: 'AITBs',
				allowBlank: false,
                anchor: '40%',
                gwidth: 80,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store: ['no' ,'si']
            },
            type:'ComboBox',
			filters: { pfiltro: 'resplan.cbte_aitb', type: 'string' },
			valorInicial: 'no',
			id_grupo: 1,
			grid: true,
			egrid: true,
			form: true
		},
		{
			config: {
				name: 'periodo_calculo',
				qtip: '<b>(gestion, diario, rango)</b> <BR>'+
					  'para los calculo con balance de cuentas es necesario especificar el inicio y el fin<br>'+
					  '<b>(cbte)</b> <br>la plantilla se aplica a un cbte o a un grupo seleccionado desde libro diario',
				fieldLabel: 'Periodo',
				allowBlank: false,
                anchor: '40%',
                gwidth: 80,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store: ['gestion' ,'diario','rango','cbte']
            },
            type:'ComboBox',
			filters: { pfiltro: 'resplan.periodo_calculo', type: 'string' },
			valorInicial: 'rango',
			id_grupo: 1,
			grid: true,
			egrid: true,
			form: true
		},
	   {
			config: {
				name: 'id_clase_comprobante',
				fieldLabel: 'Tipo Cbte.',
				allowBlank: true,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_contabilidad/control/ClaseComprobante/listarClaseComprobante',
					id: 'id_clase_comprobante',
					root: 'datos',
					sortInfo: {
						field: 'id_clase_comprobante',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_clase_comprobante', 'tipo_comprobante', 'descripcion','codigo','momento_comprometido','momento_ejecutado','momento_pagado'],
					remoteSort: true,
					baseParams: {par_filtro: 'ccom.tipo_comprobante#ccom.descripcion'}
				}),
				valueField: 'id_clase_comprobante',
				displayField: 'descripcion',
				gdisplayField: 'desc_clase_comprobante',
				hiddenName: 'id_clase_comprobante',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				width:250,
				anchor: '100%',
				gwidth: 150,
				minChars: 2,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['desc_clase_comprobante']);
				}
			},
			type: 'ComboBox',
			id_grupo: 1,
			filters: {pfiltro: 'cc.descripcion',type: 'string'},
			grid: true,
			form: true
		},
		{
			config:{
				name: 'glosa',
				fieldLabel: 'Glosa',
				allowBlank: true,
				anchor: '100%',
				gwidth: 100,
				maxLength:1500
			},
			type:'TextArea',
			filters: { pfiltro:'resplan.glosa', type:'string' },
			id_grupo: 0,
			grid: true,
			form: true
		},
		
		{
			config : {
				name : 'id_tipo_relacion_comprobante',
				fieldLabel : 'Tipo Rel.',
				qtip : 'Tipo de relacion entre comprobantes',
				allowBlank : false,
				emptyText : 'Elija una opción...',
				store : new Ext.data.JsonStore({
					url : '../../sis_contabilidad/control/TipoRelacionComprobante/listarTipoRelacionComprobante',
					id : 'id_tipo_relacion_comprobante',
					root : 'datos',
					sortInfo : {
						field : 'id_tipo_relacion_comprobante',
						direction : 'ASC'
					},
					totalProperty : 'total',
					fields : ['id_tipo_relacion_comprobante', 'codigo', 'nombre'],
					remoteSort : true,
					baseParams : {
						par_filtro : 'tiprelco.nombre#tiprelco.codigo'
					}
				}),
				valueField : 'id_tipo_relacion_comprobante',
				displayField : 'nombre',
				gdisplayField : 'desc_tipo_relacion_comprobante',
				hiddenName : 'id_tipo_relacion_comprobante',
				//forceSelection: true,
				typeAhead : false,
				triggerAction : 'all',
				lazyRender : true,
				mode : 'remote',
				pageSize : 15,
				queryDelay : 1000,
				width : 250,
				anchor : '100%',
				gwidth : 150,
				minChars : 2,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['desc_tipo_relacion_comprobante']);
				}
			},
			type : 'ComboBox',
			id_grupo : 1,
			
			filters : {
				pfiltro : 'trc.nombre',
				type : 'string'
			},
			grid : true,
			form : true
		},
		
		{
			config : {
				name : 'relacion_unica',
				fieldLabel : 'Relación Unica',
				qtip : 'Si la relación es unica valida que el cbte original solo tengo una relación del tipo seleccionado',
				allowBlank : false,
				gwidth : 100,
				width : 250,
				typeAhead : true,
				triggerAction : 'all',
				lazyRender : true,
				mode : 'local',
				valueField : 'oficial',
				store : ['si', 'no']
			},
			type : 'ComboBox',
			id_grupo : 2,
			valorInicial : 'no',
			filters : {
				type : 'list',
				pfiltro : 'incbte.relacion_unica',
				options : ['si', 'no'],
			},
			grid : true,
			form : true
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
				filters:{pfiltro:'resplan.estado_reg',type:'string'},
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
				name: 'usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
				type:'TextField',
				filters:{pfiltro:'resplan.usuario_ai',type:'string'},
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
				filters:{pfiltro:'resplan.fecha_reg',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'resplan.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'resplan.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
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
		}
	],
	tam_pag:50,	
	title:'Plantilla de Resultados',
	ActSave:'../../sis_contabilidad/control/ResultadoPlantilla/insertarResultadoPlantilla',
	ActDel:'../../sis_contabilidad/control/ResultadoPlantilla/eliminarResultadoPlantilla',
	ActList:'../../sis_contabilidad/control/ResultadoPlantilla/listarResultadoPlantilla',
	id_store:'id_resultado_plantilla',
	fields: [
		{name:'id_resultado_plantilla', type: 'numeric'},
		{name:'codigo', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'nombre', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		'tipo',
        'cbte_aitb',
        'cbte_apertura',
        'cbte_cierre',
        'periodo_calculo',
        'id_clase_comprobante',
        'glosa',
        'desc_clase_comprobante',
        'relacion_unica',
        'id_tipo_relacion_comprobante',
        'desc_tipo_relacion_comprobante'
		
	],
	sortInfo:{
		field: 'id_resultado_plantilla',
		direction: 'ASC'
	},
	clonar: function(){
		Ext.Msg.confirm('Confirmación','¿Está seguro de clonar esta plantilla?',function(btn){
			var rec=this.sm.getSelected();
			Phx.CP.loadingShow();
			Ext.Ajax.request({
				url:'../../sis_contabilidad/control/ResultadoPlantilla/clonarPlantilla',
				params:{
					id_resultado_plantilla: rec.data.id_resultado_plantilla
				},
				success: function(resp){
					Phx.CP.loadingHide();
					var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
					if (reg.ROOT.error) {
						Ext.Msg.alert('Error','Clonación no realizada: '+reg.ROOT.error)
					} else {
						this.reload();
						Ext.Msg.alert('Mensaje','Proceso ejecutado con éxito')
					}
				},
				failure: this.conexionFailure,
				timeout: this.timeout,
				scope:this
			});
		}, this)
	},
	
	expProceso : function(resp){
			var data=this.sm.getSelected().data;
			Phx.CP.loadingShow();
			Ext.Ajax.request({
				url: '../../sis_contabilidad/control/ResultadoPlantilla/exportarDatos',
				params: { 'id_resultado_plantilla' : data.id_resultado_plantilla },
				success: this.successExport,
				failure: this.conexionFailure,
				timeout: this.timeout,
				scope: this
			});
			
	},
	
	preparaMenu: function(n) {
		var tb = Phx.vista.ResultadoPlantilla.superclass.preparaMenu.call(this);
	   	this.getBoton('btnClonar').setDisabled(false);
  		return tb;
	},
	liberaMenu: function() {
		var tb = Phx.vista.ResultadoPlantilla.superclass.liberaMenu.call(this);
		this.getBoton('btnClonar').setDisabled(true);
		return tb;
	},
	tabeast:[
	      {
			url : '../../../sis_contabilidad/vista/resultado_det_plantilla/ResultadoDetPlantilla.php',
			title : 'Detalle de Comprobante',
			width:'70%',
			cls : 'ResultadoDetPlantilla'
		  },
		  {
		   url:'../../../sis_contabilidad/vista/resultado_dep/ResultadoDep.php',
		   title: 'Dependencias', 
		   width:'70%',
		   cls: 'ResultadoDep'
		 }],
		 
	 onButtonNew:function(){
          
                  
          Phx.vista.ResultadoPlantilla.superclass.onButtonNew.call(this);           
          this.ocultarComponente(this.Cmp.id_tipo_relacion_comprobante);
		  this.ocultarComponente(this.Cmp.relacion_unica);
     },	
     
    onButtonEdit:function(){ 
    	var rec = this.sm.getSelected().data;
     	Phx.vista.ResultadoPlantilla.superclass.onButtonEdit.call(this); 
     	if(rec.periodo_calculo == 'cbte'){
        	this.mostrarComponente(this.Cmp.id_tipo_relacion_comprobante);
				this.mostrarComponente(this.Cmp.relacion_unica);			
		}
		else{
			this.ocultarComponente(this.Cmp.id_tipo_relacion_comprobante);
			this.ocultarComponente(this.Cmp.relacion_unica);
		}
    },
	
	iniciarEventos: function(){
		
		
		
		this.Cmp.periodo_calculo.on('select',function(combo, record, index){
			var tmp = combo.getValue();
			if(tmp == 'cbte'){				
				this.mostrarComponente(this.Cmp.id_tipo_relacion_comprobante);
				this.mostrarComponente(this.Cmp.relacion_unica);			
			}
			else{
				this.ocultarComponente(this.Cmp.id_tipo_relacion_comprobante);
				this.ocultarComponente(this.Cmp.relacion_unica);
			}
			
			
		},this);
		
	} ,
		 
	bdel:true,
	bsave:true
})
</script>
		
		