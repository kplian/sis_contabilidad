<?php
/**
*@package pXP
*@file gen-PlantillaComprobante.php
*@author  (admin)
*@date 10-06-2013 14:40:00
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.PlantillaComprobante=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.PlantillaComprobante.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
	},
	tam_pag:50,
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_plantilla_comprobante'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'comprobante_eliminado',
				fieldLabel: 'Comprobante Eliminado',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextArea',
			filters:{pfiltro:'cmpb.comprobante_eliminado',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'id_tabla',
				fieldLabel: 'id_tabla',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			},
			type:'TextField',
			filters:{pfiltro:'cmpb.id_tabla',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'subistema',
				fieldLabel: 'Subistema',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextArea',
			filters:{pfiltro:'cmpb.subistema',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'descripcion',
				fieldLabel: 'Descripcion',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextArea',
			filters:{pfiltro:'cmpb.descripcion',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'comprobante_controlado',
				fieldLabel: 'Comprobante Controlado',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextArea',
			filters:{pfiltro:'cmpb.comprobante_controlado',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'fecha',
				fieldLabel: 'Fecha',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextArea',
			filters:{pfiltro:'cmpb.fecha',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'acreedor',
				fieldLabel: 'Acreedor',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextArea',
			filters:{pfiltro:'cmpb.acreedor',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'depto',
				fieldLabel: 'Depto',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextArea',
			filters:{pfiltro:'cmpb.depto',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'momento_presupuestario',
				fieldLabel: 'Momento Presupuestario',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			},
			type:'TextField',
			filters:{pfiltro:'cmpb.momento_presupuestario',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'fk_comprobante',
				fieldLabel: 'fk Comprobante',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextArea',
			filters:{pfiltro:'cmpb.fk_comprobante',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'tabla_origen',
				fieldLabel: 'Tabla Origen',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			},
			type:'TextField',
			filters:{pfiltro:'cmpb.tabla_origen',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'clase_comprobante',
				fieldLabel: 'Clase Comprobante',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			},
			type:'TextField',
			filters:{pfiltro:'cmpb.clase_comprobante',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'moneda',
				fieldLabel: 'Moneda',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextArea',
			filters:{pfiltro:'cmpb.moneda',type:'string'},
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
			filters:{pfiltro:'cmpb.estado_reg',type:'string'},
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
			type:'NumberField',
			filters:{pfiltro:'usu1.cuenta',type:'string'},
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
			filters:{pfiltro:'cmpb.fecha_reg',type:'date'},
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
			type:'NumberField',
			filters:{pfiltro:'usu2.cuenta',type:'string'},
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
			filters:{pfiltro:'cmpb.fecha_mod',type:'date'},
			id_grupo:1,
			grid:true,
			form:false
		}
	],
	
	title:'Comprobante',
	ActSave:'../../sis_contabilidad/control/PlantillaComprobante/insertarPlantillaComprobante',
	ActDel:'../../sis_contabilidad/control/PlantillaComprobante/eliminarPlantillaComprobante',
	ActList:'../../sis_contabilidad/control/PlantillaComprobante/listarPlantillaComprobante',
	id_store:'id_plantilla_comprobante',
	fields: [
		{name:'id_plantilla_comprobante', type: 'numeric'},
		{name:'comprobante_eliminado', type: 'string'},
		{name:'id_tabla', type: 'string'},
		{name:'subistema', type: 'string'},
		{name:'descripcion', type: 'string'},
		{name:'comprobante_controlado', type: 'string'},
		{name:'fecha', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'acreedor', type: 'string'},
		{name:'depto', type: 'string'},
		{name:'momento_presupuestario', type: 'string'},
		{name:'fk_comprobante', type: 'string'},
		{name:'tabla_origen', type: 'string'},
		{name:'clase_comprobante', type: 'string'},
		{name:'moneda', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
	],
	sortInfo:{
		field: 'id_plantilla_comprobante',
		direction: 'ASC'
	},
	
	south : {
			url : '../../../sis_contabilidad/vista/detalle_plantilla_comprobante/DetallePlantillaComprobante.php',
			title : 'Detalle de Comprobante',
			height : '50%',
			cls : 'DetallePlantillaComprobante'
		},
		
	bdel:true,
	bsave:true
	}
)
</script>
		
		