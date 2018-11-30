<?php
/**
*@package pXP
*@file gen-PresupPartida.php
*@author  (admin)
*@date 29-02-2016 19:40:34
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ChkPresupuestoCbte=Ext.extend(Phx.gridInterfaz,{
    tam_pag:500,
	constructor:function(config){
		this.maestro=config.maestro;
		console.log('.............',config)
    	//llama al constructor de la clase padre
		Phx.vista.ChkPresupuestoCbte.superclass.constructor.call(this,config);
		this.init();
		
		this.store.baseParams={nro_tramite:this.data.nro_tramite, id_int_comprobante:this.data.id_int_comprobante }; 
        this.load({params:{start:0, limit:this.tam_pag}});
		
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_ver'
			},
			type:'Field',
			form:false 
		},
		{
			config:{
				name: 'descripcion',
				fieldLabel: 'Presupeusto',
				allowBlank: true,
				anchor: '80%',
				gwidth: 200,
				maxLength:300
			},
				type:'TextField',
				bottom_filter: true,
   			    filters:{pfiltro:'pcc.descripcion',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'nombre_partida',
				fieldLabel: 'Partida',
				allowBlank: true,
				anchor: '80%',
				gwidth: 200,
				maxLength:300,
				renderer:function (value,p,record){
						return  String.format('{0} - {1}', record.data.codigo_partida, value);
				}
			},
				type:'TextField',
				bottom_filter: true,
				filters:{pfiltro:'part.nombre_partida#part.codigo_partida',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
	   	
		
		{
			config:{
				name: 'monto_mb',
				fieldLabel: 'Monto MB (Necesario)',
				gwidth: 100,
				renderer:function (value,p,record){
						return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
				}
			},
				type: 'NumberField',
				filters: { pfiltro:'monto_mb', type: 'numeric' },
				id_grupo: 1,
				grid: true,
				form: false
		},
		{
			config:{
				name: 'verificacion',
				fieldLabel: 'Disponibilidad',
				gwidth: 100,
				renderer:function (value,p,record){
						if(value == 'true'){
							return  '<b><font size=2 color="green">SI</font><b>';
						}
						else{
							return '<b><font size=2 color="red">NO</font><b>';
						}
						
						
					}
			},
				type: 'NumberField',
				id_grupo: 1,
				grid: true,
				form: false
		},
		{
			config:{
				name: 'saldo',
				fieldLabel: 'Saldo',
				gwidth: 100,
				renderer:function (value,p,record){
					return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
						
				}
			},
				type: 'NumberField',
				filters: { pfiltro:'prpa.pagado', type: 'numeric' },
				id_grupo: 1,
				grid: true,
				form: false
		}
		
		
	],
	tam_pag:50,	
	title:'PREPAR',
	ActList:'../../sis_contabilidad/control/IntComprobante/listarVerPresCbte',
	id_store:'id_ver',
	fields: [
		 'id_ver', 'control_partida','id_par',
          'id_agrupador','importe_debe', 'importe_haber','movimiento',
          'id_presupuesto','tipo_cambio', 'monto_mb','verificacion', 'saldo',
          'codigo_partida', 'nombre_partida','desc_tipo_presupuesto', 'descripcion'
		
	],
	

	sortInfo:{
		field: 'id_ver',
		direction: 'ASC'
	},
	bdel: false,
	bedit: false,
	bsave: false,
	bnew: false
})
</script>	