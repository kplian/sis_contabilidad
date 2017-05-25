<?php
/**
*@package pXP
*@file gen-GastoSigep.php
*@author  (gsarmiento)
*@date 08-05-2017 20:06:08
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.GastoSigep=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.GastoSigep.superclass.constructor.call(this,config);
		this.init();
		//this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_gasto_sigep'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'gestion',
				fieldLabel: 'Gestion',
				allowBlank: true,
				anchor: '80%',
				gwidth: 50,
				maxLength:4
			},
				type:'NumberField',
				filters:{pfiltro:'gtsg.gestion',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'objeto',
				fieldLabel: 'Objeto',
				allowBlank: true,
				anchor: '80%',
				gwidth: 70,
				maxLength:10
			},
			type:'TextField',
			filters:{pfiltro:'gtsg.objeto',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'descripcion_gasto',
				fieldLabel: 'Descripcion Gasto',
				allowBlank: true,
				anchor: '80%',
				gwidth: 270,
				maxLength:150
			},
			type:'TextField',
			filters:{pfiltro:'gtsg.descripcion_gasto',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'programa',
				fieldLabel: 'Programa',
				allowBlank: true,
				anchor: '80%',
				gwidth: 60,
				maxLength:4
			},
			type:'NumberField',
			filters:{pfiltro:'gtsg.programa',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'proyecto',
				fieldLabel: 'Proyecto',
				allowBlank: true,
				anchor: '80%',
				gwidth: 60,
				maxLength:4
			},
			type:'NumberField',
			filters:{pfiltro:'gtsg.proyecto',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'actividad',
				fieldLabel: 'Actividad',
				allowBlank: true,
				anchor: '80%',
				gwidth: 60,
				maxLength:4
			},
				type:'NumberField',
				filters:{pfiltro:'gtsg.actividad',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'fuente',
				fieldLabel: 'Fuente',
				allowBlank: true,
				anchor: '80%',
				gwidth: 60,
				maxLength:4
			},
			type:'NumberField',
			filters:{pfiltro:'gtsg.fuente',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'organismo',
				fieldLabel: 'Organismo',
				allowBlank: true,
				anchor: '80%',
				gwidth: 70,
				maxLength:4
			},
			type:'NumberField',
			filters:{pfiltro:'gtsg.organismo',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'nro_preventivo',
				fieldLabel: 'Nro Prev. (C-31)',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'NumberField',
				filters:{pfiltro:'gtsg.nro_preventivo',type:'numeric'},
				bottom_filter:true,
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'nro_comprometido',
				fieldLabel: 'Nro Comp.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 70,
				maxLength:4
			},
			type:'NumberField',
			filters:{pfiltro:'gtsg.nro_devengado',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'nro_devengado',
				fieldLabel: 'Nro Deveg.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 70,
				maxLength:4
			},
			type:'NumberField',
			filters:{pfiltro:'gtsg.nro_devengado',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'entidad_transferencia',
				fieldLabel: 'Entidad Transferencia',
				allowBlank: true,
				anchor: '80%',
				gwidth: 120,
				maxLength:4
			},
			type:'NumberField',
			filters:{pfiltro:'gtsg.entidad_transferencia',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'monto',
				fieldLabel: 'Monto',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:-5
			},
				type:'NumberField',
				filters:{pfiltro:'gtsg.monto',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'estado',
				fieldLabel: 'Estado',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:10
			},
			type:'TextField',
			filters:{pfiltro:'gtsg.estado',type:'string'},
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
			filters:{pfiltro:'gtsg.estado_reg',type:'string'},
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
				filters:{pfiltro:'gtsg.fecha_reg',type:'date'},
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
				filters:{pfiltro:'gtsg.usuario_ai',type:'string'},
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
				name: 'id_usuario_ai',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'gtsg.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'gtsg.fecha_mod',type:'date'},
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
	title:'Gasto Sigep',
	ActSave:'../../sis_contabilidad/control/GastoSigep/insertarGastoSigep',
	ActDel:'../../sis_contabilidad/control/GastoSigep/eliminarGastoSigep',
	ActList:'../../sis_contabilidad/control/GastoSigep/listarGastoSigep',
	id_store:'id_gasto_sigep',
	fields: [
		{name:'id_gasto_sigep', type: 'numeric'},
		{name:'programa', type: 'numeric'},
		{name:'gestion', type: 'numeric'},
		{name:'actividad', type: 'numeric'},
		{name:'nro_preventivo', type: 'numeric'},
		{name:'nro_comprometido', type: 'numeric'},
		{name:'nro_devengado', type: 'numeric'},
		{name:'proyecto', type: 'numeric'},
		{name:'organismo', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'estado', type: 'string'},
		{name:'descripcion_gasto', type: 'string'},
		{name:'entidad_transferencia', type: 'numeric'},
		{name:'fuente', type: 'numeric'},
		{name:'objeto', type: 'string'},
		{name:'monto', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
	],
	sortInfo:{
		field: 'id_gasto_sigep',
		direction: 'ASC'
	},

	onReloadPage:function(m){
		this.maestro=m;
		this.store.baseParams={id_archivo_sigep:this.maestro.id_archivo_sigep};
		this.load({params:{start:0, limit:this.tam_pag}});
	},

	bdel:false,
	bsave:false,
	bnew:false,
	bedit:false
	}
)
</script>
		
		