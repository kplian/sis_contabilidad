<?php
/**
*@package pXP
*@file gen-ConfigCambiaria.php
*@author  (admin)
*@date 04-11-2015 12:39:12
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ConfigCambiaria=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.ConfigCambiaria.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}});
		this.iniciarEventos();
	},
	
	arrayStore :{
                	'TODOS':['{M}->{MT}','{MB}->{MT}','{MT}->{MB}'],
                	'{M}->{MB}':['{M}->{MT}','{MB}->{MT}'],
                	'{M}->{MT}':['{MT}->{MB}']
       },
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_config_cambiaria'
			},
			type:'Field',
			form:true 
		},
		
		
		{
            config:{
                name:'origen',
                fieldLabel:'origen',
                qtip: 'fomula que se aplica segun el origen del comprobante',
                allowBlank: false,
                anchor: '80%',
                emptyText:'Tipo...',                   
                typeAhead:true,
                triggerAction:'all',
                lazyRender:true,
                mode:'local',
                store:['nacional','internacional']
            },
            type:'ComboBox',
            id_grupo:1,
            filters:{type: 'list',
                     pfiltro:'cnfc.origen',
                     options: ['nacional','internacional']
                    },
            grid:true,
            form:true
      },
	
	  {
            config:{
                name: 'ope_1',
				qtip: 'La operación 1 siempre parte de la moneda de trasacción y utiliza el tipo de cambio 1',
				fieldLabel:'Ope 1',
                allowBlank: false,
                anchor: '80%',
                emptyText:'operación 1...',                   
                typeAhead:true,
                triggerAction:'all',
                lazyRender:true,
                mode:'local',
                store:['{M}->{MB}','{M}->{MT}']
            },
            type:'ComboBox',
            id_grupo:1,
            filters:{type: 'list',
                     pfiltro:'cnfc.habilitado',
                     options: ['{M}->{MB}','{M}->{MT}']
                    },
            grid:true,
            form:true
       },
       
       {
            config:{
                name: 'ope_2',
				qtip: 'La operación 2 aplica el tipo de cambio 2',
				fieldLabel:'Ope 2',
                allowBlank: false,
                anchor: '80%',
                emptyText:'operación 2...',                   
                typeAhead: true,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'local',
                store: []
            },
            type: 'ComboBox',
            id_grupo:1,
            filters: { type: 'list',
                       pfiltro:'cnfc.habilitado',
                       options: ['{M}->{MB}','{M}->{MT}']
                    },
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
				maxLength:500
			},
				type:'TextField',
				filters:{pfiltro:'cnfc.obs',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
            config:{
                name:'habilitado',
                fieldLabel:'habilitado',
                qtip: 'activa el uso de esta configuración',
                allowBlank: false,
                anchor: '80%',
                emptyText:'Tipo...',                   
                typeAhead:true,
                triggerAction:'all',
                lazyRender:true,
                mode:'local',
                valueField:'inicio',                   
                store:['si','no']
            },
            type:'ComboBox',
            id_grupo:1,
            filters:{type: 'list',
                     pfiltro:'cnfc.habilitado',
                     options: ['si','no']
                    },
            grid:true,
            form:true
       },
		{
			config:{
				name: 'fecha_habilitado',
				fieldLabel: 'fecha_habilitado',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'cnfc.fecha_habilitado',type:'date'},
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
				filters:{pfiltro:'cnfc.estado_reg',type:'string'},
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
				filters:{pfiltro:'cnfc.fecha_reg',type:'date'},
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
				filters:{pfiltro:'cnfc.usuario_ai',type:'string'},
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
				filters:{pfiltro:'cnfc.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'cnfc.fecha_mod',type:'date'},
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
	title:'Configuración Cambiaria',
	ActSave:'../../sis_contabilidad/control/ConfigCambiaria/insertarConfigCambiaria',
	ActDel:'../../sis_contabilidad/control/ConfigCambiaria/eliminarConfigCambiaria',
	ActList:'../../sis_contabilidad/control/ConfigCambiaria/listarConfigCambiaria',
	id_store:'id_config_cambiaria',
	fields: [
		{name:'id_config_cambiaria', type: 'numeric'},
		{name:'fecha_habilitado', type: 'date',dateFormat:'Y-m-d'},
		{name:'origen', type: 'string'},
		{name:'habilitado', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'ope_2', type: 'string'},
		{name:'ope_1', type: 'string'},
		{name:'obs', type: 'string'},
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
		field: 'id_config_cambiaria',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
	
	iniciarEventos:function(){
		
		 this.Cmp.ope_1.on('select', function(cmb,rec,i) {
		 	this.Cmp.ope_2.reset();
		 	this.Cmp.ope_2.store.loadData(this.arrayStore[rec.json[0]]) ;
		 }, this);
		 
		
	},
	onButtonEdit: function(){
         var data = this.getSelectedData();
         this.Cmp.ope_2.store.loadData(this.arrayStore.TODOS) ;
         Phx.vista.ConfigCambiaria.superclass.onButtonEdit.call(this); 
    }
	
})
</script>
		
		