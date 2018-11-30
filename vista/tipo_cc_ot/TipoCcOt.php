<?php
/**
*@package pXP
*@file gen-TipoCcOt.php
*@author  (admin)
*@date 31-05-2017 22:07:39
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.TipoCcOt=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.TipoCcOt.superclass.constructor.call(this,config);
		this.init();
		
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_tipo_cc_ot'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_orden_trabajo'
			},
			type:'Field',
			form:true 
		},		
		{
	   		config:{
	   				name:'id_tipo_cc',
	   				qtip: 'Tipo de centro de costos',	   				
	   				origen:'TIPOCC',
	   				fieldLabel:'Tipo Centro',
	   				gdisplayField:'desc_tcc',//mapea al store del grid
	   				allowBlank:false,
	   				width:250,
	   				gwidth:200,
	   				renderer:function (value, p, record){return String.format('{0} ', record.data['desc_tcc']);}
	   				
	      		},
   			type:'ComboRec',
   			id_grupo:0,
   			filters:{pfiltro:'tcc.codigo#tcc.descripcion',type:'string'},
   		    grid:true,
   			form:true
	    },
	    {
			config:{
				name: 'tipo_reg',
				fieldLabel: 'Tipo',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				renderer:function (value, p, record){					
					if(value == 'directo'){
						return String.format('<font color="blue">{0}</font>', value);
					}
					else{
						return String.format('<font color="red">{0}</font>', value);
					}
					
				},
	   			maxLength:10
			},
			type:'TextField',
			id_grupo:1,
			grid:true,
			form:false
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
				filters:{pfiltro:'fto.estado_reg',type:'string'},
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
				filters:{pfiltro:'fto.fecha_reg',type:'date'},
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
				filters:{pfiltro:'fto.fecha_mod',type:'date'},
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
				filters:{pfiltro:'fto.usuario_ai',type:'string'},
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
				filters:{pfiltro:'fto.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
				form:false
		}
	],
	tam_pag:50,	
	title:'Filtro TCC',
	ActSave:'../../sis_contabilidad/control/TipoCcOt/insertarTipoCcOt',
	ActDel:'../../sis_contabilidad/control/TipoCcOt/eliminarTipoCcOt',
	ActList:'../../sis_contabilidad/control/TipoCcOt/listarTipoCcOt',
	id_store:'id_tipo_cc_ot',
	fields: [
		{name:'id_tipo_cc_ot', type: 'numeric'},
		{name:'id_orden_trabajo', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_tipo_cc', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'desc_tcc','tipo_reg'
		
	],
	
	onReloadPage:function(m,a,b){		
		this.maestro=m;
		this.store.baseParams={id_orden_trabajo:this.maestro.id_orden_trabajo};			
		this.load({params:{start:0, limit:50}})
		
	},
	
	loadValoresIniciales:function(){
		
		Phx.vista.TipoCcOt.superclass.loadValoresIniciales.call(this);
		this.getComponente('id_orden_trabajo').setValue(this.maestro.id_orden_trabajo);
				
	},
	
	preparaMenu:function(){
		var rec = this.sm.getSelected();
		var tb = this.tbar;
		if(rec.data.tipo_reg != 'indirecto'){
			Phx.vista.TipoCcOt.superclass.preparaMenu.call(this);
		}
		else{
			 this.getBoton('edit').disable();
			 this.getBoton('del').disable();
		}
	},
	
	
	sortInfo:{
		field: 'id_tipo_cc_ot',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true
})
</script>
		
		