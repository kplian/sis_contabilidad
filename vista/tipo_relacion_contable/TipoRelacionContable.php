<?php
/**
*@package pXP
*@file gen-TipoRelacionContable.php
*@author  (admin)
*@date 16-05-2013 21:51:43
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.TipoRelacionContable=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		//llama al constructor de la clase padre
		Phx.vista.TipoRelacionContable.superclass.constructor.call(this,config);
		this.init();		
		this.iniciarEventos();
			
	},
	tam_pag:50,
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_tipo_relacion_contable'
			},
			type:'Field',
			form:true 
		},
		
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_tabla_relacion_contable'
			},
			type:'Field',
			form:true 
		},
		
		{
			config:{
				name: 'codigo_tipo_relacion',
				fieldLabel: 'Codigo Tipo Relación',
				allowBlank: false,
				anchor: '80%',
				gwidth: 150,
				maxLength:15
			},
			type:'TextField',
			filters:{pfiltro:'tiprelco.codigo_tipo_relacion',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'nombre_tipo_relacion',
				fieldLabel: 'Nombre Tipo Relación',
				allowBlank: false,
				anchor: '80%',
				gwidth: 200,
				maxLength:200
			},
			type:'TextField',
			filters:{pfiltro:'tiprelco.nombre_tipo_relacion',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
	       		config:{
	       			name:'tiene_centro_costo',
	       			fieldLabel:'Tiene Centro de Costo',
	       			allowBlank:false,
	       			emptyText:'Tiene...',
	       			typeAhead: true,
	       		    triggerAction: 'all',
	       		    lazyRender:true,
	       		    mode: 'local',
	       		    gwidth: 150,
	       		    anchor: '80%',
	       		    store:new Ext.data.ArrayStore({
		        	fields: ['ID', 'valor'],
		        	data :	[['si','Si'],	
		        			['no','No'],
		        			['si-unico','Si, solo permite centro de costo'],
		        			['si-general','Si, permitir configuración general cuando el centor de costo es vacio']]
		        				
		    		}),
					valueField:'ID',
					displayField:'valor',
	       		},
	       		type:'ComboBox',
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
			filters:{pfiltro:'tiprelco.estado_reg',type:'string'},
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
			filters:{pfiltro:'tiprelco.fecha_reg',type:'date'},
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
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
			type:'DateField',
			filters:{pfiltro:'tiprelco.fecha_mod',type:'date'},
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
	       			name:'tiene_partida',
	       			fieldLabel:'Tiene Partida',
	       			allowBlank:false,
	       			emptyText:'Tiene...',
	       			typeAhead: true,
	       		    triggerAction: 'all',
	       		    lazyRender:true,
	       		    mode: 'local',
	       		    gwidth: 100,
	       		    store:['si','no']
	       		},
	       		type:'ComboBox',
	       		id_grupo:1,
	       		grid:true,
	       		form:true
	       	},
	      {
	       		config:{
	       			name:'tiene_auxiliar',
	       			fieldLabel:'Tiene Auxiliar',
	       			allowBlank:false,
	       			emptyText:'Tiene...',
	       			typeAhead: true,
	       		    triggerAction: 'all',
	       		    lazyRender:true,
	       		    mode: 'local',
	       		    gwidth: 100,
	       		    store:['si','no']
	       		},
	       		type:'ComboBox',
	       		id_grupo:1,
	       		grid:true,
	       		form:true
	       	}
	],
	
	title:'Tipo Relacion Contable',
	ActSave:'../../sis_contabilidad/control/TipoRelacionContable/insertarTipoRelacionContable',
	ActDel:'../../sis_contabilidad/control/TipoRelacionContable/eliminarTipoRelacionContable',
	ActList:'../../sis_contabilidad/control/TipoRelacionContable/listarTipoRelacionContable',
	id_store:'id_tipo_relacion_contable',
	fields: [
		{name:'id_tipo_relacion_contable', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'nombre_tipo_relacion', type: 'string'},
		{name:'tiene_centro_costo', type: 'string'},
		{name:'tiene_partida', type: 'string'},
		{name:'tiene_auxiliar', type: 'string'},
		{name:'codigo_tipo_relacion', type: 'string'},
		{name:'id_tabla_relacion_contable', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
	],
	sortInfo:{
		field: 'id_tipo_relacion_contable',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true	
})
</script>
		
		