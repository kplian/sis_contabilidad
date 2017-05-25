<?php
/**
*@package pXP
*@file gen-ResultadoDep.php
*@author  (admin)
*@date 14-07-2015 13:40:02
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ResultadoDep=Ext.extend(Phx.gridInterfaz,{
    nombreVista: 'ResultadoDep',
	constructor:function(config){
		  this.maestro=config.maestro;
    	  //llama al constructor de la clase padre
		  Phx.vista.ResultadoDep.superclass.constructor.call(this,config);
		  this.init();
		  //si la interface es pestanha este código es para iniciar 
	      var dataPadre = Phx.CP.getPagina(this.idContenedorPadre).getSelectedData()
	      if(dataPadre){
	         this.onEnablePanel(this, dataPadre);
	      }
	      else
	      {
	         this.bloquearMenus();
	      }
	      
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_resultado_dep'
			},
			type:'Field',
			form:true 
		},
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
	                name: 'id_resultado_plantilla_hijo',
	                qtip: 'Plantilla que se calcula primero por dependecia, peud eexixtir dependencia recusiva ',
	                fieldLabel: 'Plantilla Dependiente',
	                typeAhead: false,
	                forceSelection: true,
	                allowBlank: false,
	                disableSearchButton: true,
	                emptyText: 'Reporte de ...',
	                store: new Ext.data.JsonStore({
	                    url: '../../sis_contabilidad/control/ResultadoPlantilla/listarResultadoPlantilla',
	                    id: 'id_resultado_plantilla',
						root: 'datos',
						sortInfo:{
							field: 'resplan.nombre',
							direction: 'ASC'
						},
						totalProperty: 'total',
						fields: ['id_resultado_plantilla','nombre','codigo'],
						// turn on remote sorting
						remoteSort: true,
						baseParams: { par_filtro:'resplan.nombre#resplan.codigo'}
	                }),
	                valueField: 'id_resultado_plantilla',
	   				displayField: 'nombre',
	   				gdisplayField: 'desc_resultado_plantilla',
	   				hiddenName: 'id_resultado_plantilla_hijo',
	                triggerAction: 'all',
	                lazyRender: true,
	                mode: 'remote',
	                pageSize: 20,
	                queryDelay: 200,
	                anchor: '80%',
	                listWidth:'280',
	                resizable:true,
	                gwidth: 200,
	                minChars: 2
	            },
	   			type:'ComboBox',
	   			filters:{pfiltro:'rp.nombre#rp.codigo',type:'string'},
	   			id_grupo:0,
	   			grid:true,
				form:true
         },
		{
			config:{
				name: 'obs',
				fieldLabel: 'obs',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
				type:'TextArea',
				filters:{pfiltro:'resdep.obs',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'prioridad',
				fieldLabel: 'prioridad',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:2
			},
				type:'NumberField',
				filters:{pfiltro:'resdep.prioridad',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
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
				filters:{pfiltro:'resdep.estado_reg',type:'string'},
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
				filters:{pfiltro:'resdep.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'resdep.fecha_reg',type:'date'},
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
				filters:{pfiltro:'resdep.usuario_ai',type:'string'},
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
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'resdep.fecha_mod',type:'date'},
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
	title:'Dependencias',
	ActSave:'../../sis_contabilidad/control/ResultadoDep/insertarResultadoDep',
	ActDel:'../../sis_contabilidad/control/ResultadoDep/eliminarResultadoDep',
	ActList:'../../sis_contabilidad/control/ResultadoDep/listarResultadoDep',
	id_store:'id_resultado_dep',
	fields: [
		{name:'id_resultado_dep', type: 'numeric'},
		{name:'id_resultado_plantilla', type: 'numeric'},
		{name:'obs', type: 'string'},
		{name:'prioridad', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'id_resultado_plantilla_hijo','desc_resultado_plantilla'
		
	],
	onReloadPage:function(m){
		this.maestro=m;
		this.store.baseParams = { id_resultado_plantilla: this.maestro.id_resultado_plantilla };
		this.load({ params:  {start: 0, limit: 50 }});
	},
	loadValoresIniciales:function(){
		Phx.vista.ResultadoDep.superclass.loadValoresIniciales.call(this);
		this.getComponente('id_resultado_plantilla').setValue(this.maestro.id_resultado_plantilla);
		
	},
	south:{
			url : '../../../sis_contabilidad/vista/resultado_det_plantilla/ResultadoDetPlantilla.php',
			title : 'Detalle del resultado',
			height:'50%',
			cls : 'ResultadoDetPlantilla'
		  },
	sortInfo:{
		field: 'id_resultado_dep',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true
	}
)
</script>
		
		