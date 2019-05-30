<?php
/**
*@package pXP
*@file gen-ConfigTpre.php
*@author  (mguerra)
*@date 18-03-2019 16:32:29
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*issue #54			
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ConfigTpre=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.ConfigTpre.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
				labelSeparator:'',
				inputType:'hidden',
				name: 'id_conf_pre'
			},
			type:'Field',
			form:true 
		},
		{
	   		config:{
   				name:'id_tipo_cc',
   				qtip: 'Tipo de centro de costos, cada tipo solo puede tener un centro por gestión',	   				
   				origen:'TIPOCC',
   				fieldLabel:'Tipo Centro',
   				gdisplayField: 'desc_tcc',	   				
   				allowBlank:false,
   				width:350,
   				gwidth:200	   				
      		},
   			type:'ComboRec',
   			id_grupo:0,
   			filters:{pfiltro:'vcc.codigo_tcc#vcc.descripcion_tcc',type:'string'},
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
				filters:{pfiltro:'contc.estado_reg',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'obs',
				fieldLabel: 'obs',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
				type:'TextField',
				filters:{pfiltro:'contc.obs',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
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
			filters:{pfiltro:'contc.fecha_reg',type:'date'},
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
			filters:{pfiltro:'contc.usuario_ai',type:'string'},
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
				filters:{pfiltro:'contc.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'contc.fecha_mod',type:'date'},
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
	title:'Configuracion de Tipo de Centro',
	ActSave:'../../sis_contabilidad/control/ConfigTpre/insertarConfigTpre',
	ActDel:'../../sis_contabilidad/control/ConfigTpre/eliminarConfigTpre',
	ActList:'../../sis_contabilidad/control/ConfigTpre/listarConfigTpre',
	id_store:'id_conf_pre',
	fields: [
		{name:'id_conf_pre', type: 'numeric'},
		{name:'id_tipo_cc', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'obs', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		'desc_tcc',
		
	],
	sortInfo:{
		field: 'id_conf_pre',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true
	}
)
</script>
		
		