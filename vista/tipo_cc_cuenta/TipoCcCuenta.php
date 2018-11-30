<?php
/**
*@package pXP
*@file gen-TipoCcCuenta.php
*@author  (admin)
*@date 08-09-2017 19:16:00
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.TipoCcCuenta=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.TipoCcCuenta.superclass.constructor.call(this,config);
		this.init();
		
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_tipo_cc_cuenta'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_tipo_cc'
			},
			type:'Field',
			form:true 
		},
		
		{
           config: {
                    sysorigen: 'sis_contabilidad',
                    name: 'nro_cuenta',
                    qtip: 'Define la cuenta sobre las que se realizan las operaciones',
                    fieldLabel: 'Código cuenta',
                    displayField: 'nro_cuenta',
                    valueField: 'nro_cuenta',
                    origen: 'CUENTAS',
                    allowBlank: true,
                    fieldLabel: 'Cuenta',
                    gwidth: 200,
                    width: 180,
                    listWidth: 350,
                    renderer: function (value, p, record) {
                        return String.format('{0} - {1}', record.data['nro_cuenta'],record.data['desc_cuenta'] );
                    },
                    baseParams: {'filtro_ges': 'actual', sw_transaccional: undefined}
                },
                type: 'ComboRec',
                id_grupo: 0,
                filters: {
                    pfiltro: 'nro_cuenta',
                    type: 'string'
                },
                grid: true,
                egrid: true,
                form: true
         },
		
		
		{
   			config:{
   				sysorigen:'sis_contabilidad',
       		    name:'id_auxiliar',
   				origen:'AUXILIAR',
   				allowBlank:true,
   				fieldLabel:'Auxiliar',
   				gdisplayField:'desc_auxiliar',//mapea al store del grid
   				gwidth:200,
   				width: 380,
   				listWidth: 380,
   				//anchor: '80%',
	   			renderer:function (value, p, record){return String.format('{0}', record.data['desc_auxiliar']);}
       	     },
   			type:'ComboRec',
   			id_grupo:0,
   			filters:{	
		        pfiltro:'au.codigo_auxiliar#au.nombre_auxiliar',
				type:'string'
			},
   		   
   			grid:true,
   			form:true
	   	},
		
		
		{
			config:{
				name: 'obs',
				fieldLabel: 'Observaciones',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:500
			},
				type:'TextArea',
				filters:{pfiltro:'tcau.obs',type:'string'},
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
				filters:{pfiltro:'tcau.estado_reg',type:'string'},
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
				filters:{pfiltro:'tcau.usuario_ai',type:'string'},
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
				filters:{pfiltro:'tcau.fecha_reg',type:'date'},
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
				filters:{pfiltro:'tcau.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'tcau.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Configuración Filtros',
	ActSave:'../../sis_contabilidad/control/TipoCcCuenta/insertarTipoCcCuenta',
	ActDel:'../../sis_contabilidad/control/TipoCcCuenta/eliminarTipoCcCuenta',
	ActList:'../../sis_contabilidad/control/TipoCcCuenta/listarTipoCcCuenta',
	id_store:'id_tipo_cc_cuenta',
	fields: [
		{name:'id_tipo_cc_cuenta', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'obs', type: 'string'},
		{name:'nro_cuenta', type: 'string'},
		{name:'id_auxiliar', type: 'numeric'},
		{name:'id_tipo_cc', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'desc_cuenta','desc_auxiliar'
	],
	sortInfo:{
		field: 'id_tipo_cc_cuenta',
		direction: 'ASC'
	},
	
	onReloadPage: function (m) {
           this.maestro = m;
           this.store.baseParams = {id_tipo_cc: this.maestro.id_tipo_cc};
           this.load({params: {start: 0, limit: 50}});
    },
        
    loadValoresIniciales: function () {    	
         Phx.vista.TipoCcCuenta.superclass.loadValoresIniciales.call(this);
         this.Cmp.id_tipo_cc.setValue(this.maestro.id_tipo_cc);
    },
	
bdel:true,
bsave:true
})
</script>	