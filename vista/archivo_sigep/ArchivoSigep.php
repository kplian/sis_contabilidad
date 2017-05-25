<?php
/**
*@package pXP
*@file gen-ArchivoSigep.php
*@author  (gsarmiento)
*@date 10-05-2017 15:38:14
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ArchivoSigep=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.ArchivoSigep.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_archivo_sigep'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'nombre_archivo',
				fieldLabel: 'Nombre Archivo',
				allowBlank: true,
				anchor: '80%',
				gwidth: 400,
				maxLength:-5
			},
				type:'TextField',
				filters:{pfiltro:'arcsgp.nombre_archivo',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'extension',
				fieldLabel: 'Extension',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:-5
			},
			type:'TextField',
			filters:{pfiltro:'arcsgp.extension',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'url',
				fieldLabel: 'Documento',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:-5,
				renderer:function (value,p,record){
					return  String.format('{0}',"<div style='text-align:center'><a href = '" + value + "' align='center' width='70' height='70'>documento</a></div>");
				}
			},
				type:'TextField',
				filters:{pfiltro:'arcsgp.url',type:'string'},
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
			filters:{pfiltro:'arcsgp.estado_reg',type:'string'},
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
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'arcsgp.fecha_reg',type:'date'},
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
				filters:{pfiltro:'arcsgp.usuario_ai',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'arcsgp.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'arcsgp.fecha_mod',type:'date'},
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
	title:'Archivo Sigep',
	ActSave:'../../sis_contabilidad/control/ArchivoSigep/insertarArchivoSigep',
	ActDel:'../../sis_contabilidad/control/ArchivoSigep/eliminarArchivoSigep',
	ActList:'../../sis_contabilidad/control/ArchivoSigep/listarArchivoSigep',
	id_store:'id_archivo_sigep',
	fields: [
		{name:'id_archivo_sigep', type: 'numeric'},
		{name:'nombre_archivo', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'url', type: 'string'},
		{name:'extension', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
	],
	sortInfo:{
		field: 'id_archivo_sigep',
		direction: 'ASC'
	},

	south : {
		url : '../../../sis_contabilidad/vista/gasto_sigep/GastoSigep.php',
		title : 'Detalle',
		height : '50%', //altura de la ventana hijo
		cls : 'GastoSigep'
	},

	bdel:true,
	bsave:false,
	bnew:false,
	bedit:false
	}
)
</script>
		
		