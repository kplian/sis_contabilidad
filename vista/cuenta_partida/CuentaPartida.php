<?php
/**
*@package pXP
*@file gen-CuentaPartida.php
*@author  (admin)
*@date 04-05-2017 10:19:16
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.CuentaPartida=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.CuentaPartida.superclass.constructor.call(this,config);
		this.init();
		this.bloquearMenus();
		
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_cuenta_partida'
			},
			type:'Field',
			form:true 
		},
		
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_cuenta'
			},
			type:'Field',
			form:true 
		},
		
		{
   			config:{
   				sysorigen:'sis_presupuestos',
       		    name:'id_partida',
   				origen:'PARTIDA',
   				allowBlank:false,
   				fieldLabel:'Partida',
   				gdisplayField:'desc_partida',//mapea al store del grid
   				gwidth:200,
   				width: 380,
   				listWidth: 380
       	     },
   			type:'ComboRec',
   			id_grupo:0,
   			filters:{	
		        pfiltro: 'par.codigo_partida#par.nombre_partida',
				type: 'string'
			},
   		   
   			grid:true,
   			
   			form:true
	   	},
	   	
	   	{
			config:{
				name: 'sw_deha',
				qtip:'segun el movimeinto de la cuenta se peude filtar que partida se pueden usar',
				fieldLabel: 'Debe / Haber',
				allowBlank: false,
				anchor: '40%',
				gwidth: 50,
				emptyText:'si/no...',       			
       			typeAhead: true,
       		    triggerAction: 'all',
       		    lazyRender:true,
       		    mode: 'local',
       		    valueField: 'inicio',  
       		    store:['debe','haber']
			},
			type:'ComboBox',			
			id_grupo:1,
			filters:{	
	       		         type: 'list',
	       				 pfiltro:'cupa.sw_deha',
	       				 options: ['debe','haber'],	
	       		 	},
			grid:true,
			form:true
		},
		
		{
			config:{
				name: 'se_rega',
				qtip:'segun el movimeinto de la partida se peude filtar que partida se pueden usar',
				fieldLabel: 'Recurso / Gasto',
				allowBlank: false,
				anchor: '40%',
				gwidth: 50,
				emptyText:'si/no...',       			
       			typeAhead: false,
       		    triggerAction: 'all',
       		    lazyRender:true,
       		    mode: 'local',
       		    valueField: 'inicio',      		    
       		  
       		    store:['recurso','gasto']
			},
			type:'ComboBox',			
			id_grupo:1,
			filters:{	
	       		         type: 'list',
	       				 pfiltro:'cupa.se_rega',
	       				 options: ['recurso','gasto'],	
	       		 	},
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
				filters:{pfiltro:'cupa.estado_reg',type:'string'},
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
				filters:{pfiltro:'cupa.fecha_reg',type:'date'},
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
				filters:{pfiltro:'cupa.usuario_ai',type:'string'},
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
				filters:{pfiltro:'cupa.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'cupa.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,				
				form:false
		}
	],
	
	onReloadPage:function(m,a,b){
		
		this.maestro=m;
		if(this.maestro.sw_transaccional == 'movimiento'){
			this.store.baseParams={id_cuenta:this.maestro.id_cuenta};
			this.Cmp.id_partida.store.baseParams = Ext.apply(this.Cmp.id_partida.store.baseParams,   {id_gestion: this.maestro.id_gestion});
			this.Cmp.id_partida.modificado = true;
			this.load({params:{start:0, limit:50}})
		}
		else{
			this.bloquearMenus();
			this.store.removeAll();
		}
		
		
	},
	loadValoresIniciales:function(){
		
		Phx.vista.CuentaPartida.superclass.loadValoresIniciales.call(this);
		this.getComponente('id_cuenta').setValue(this.maestro.id_cuenta);
				
	},
	
	
	
	tam_pag:50,	
	title:'Cuenta Partida',
	ActSave:'../../sis_contabilidad/control/CuentaPartida/insertarCuentaPartida',
	ActDel:'../../sis_contabilidad/control/CuentaPartida/eliminarCuentaPartida',
	ActList:'../../sis_contabilidad/control/CuentaPartida/listarCuentaPartida',
	id_store:'id_cuenta_partida',
	fields: [
		{name:'id_cuenta_partida', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'sw_deha', type: 'string'},
		{name:'id_partida', type: 'numeric'},
		{name:'se_rega', type: 'string'},
		{name:'id_cuenta', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'desc_partida'
		
	],
	sortInfo:{
		field: 'id_cuenta_partida',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true
	}
)
</script>
		
		