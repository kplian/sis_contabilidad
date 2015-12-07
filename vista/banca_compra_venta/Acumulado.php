<?php
/**
*@package pXP
*@file gen-Pais.php
*@author  (favio figueroa)
*@date 16-11-2015 16:56:32
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Acumulado=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
    	console.log(config)
		Phx.vista.Acumulado.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag,id_contrato:config.id_contrato}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_banca_compra_venta'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'monto_acumulado',
				fieldLabel: 'Monto Acumulado',
				allowBlank: true,
				anchor: '90%',
				gwidth: 100,
				maxLength:655362
			},
				type:'NumberField',
				filters:{pfiltro:'banca.monto_acumulado',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'fecha_reg',
				fieldLabel: 'Fecha Creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'banca.fecha_reg',type:'date'},
				id_grupo:2,
				grid:true,
				form:false
		},
		
	],
	tam_pag:50,	
	title:'Acumulado',
	ActList:'../../sis_contabilidad/control/BancaCompraVenta/listarBancaCompraVenta',
	id_store:'id_banca_compra_venta',
	fields: [
		{name:'id_contrato', type: 'numeric'},
		
		{name:'monto_acumulado', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		
	],
	sortInfo:{
		field: 'id_banca_compra_venta',
		direction: 'DESC'
	},
	bdel:true,
	bsave:true


	}
)
</script>
		
		