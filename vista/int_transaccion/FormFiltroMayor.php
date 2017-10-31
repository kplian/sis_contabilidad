<?php
/**
*@package pXP
*@file    FormFiltroMayor.php
*@author  manuel guerra
*@date    09-10-2017
*@description muestra un formulario que muestra la cuenta y el monto de la transferencia
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.FormFiltroMayor=Ext.extend(Phx.frmInterfaz,{
		
	layout:'fit',
	maxCount:0,
	constructor:function(config){   
		Phx.vista.FormFiltroMayor.superclass.constructor.call(this,config);
		this.init(); 
		this.iniciarEventos();		
		this.loadValoresIniciales();		
	},

	Atributos:[
		{
			config:{
				name:'tipo_moneda',
				fieldLabel:'Tipo de Moneda',
				allowBlank:false,
				emptyText:'Tipo...',
				typeAhead: true,
				triggerAction: 'all',
				lazyRender:true,
				mode: 'local',
				valueField: 'tipo_moneda',
				gwidth: 100,
				store:new Ext.data.ArrayStore({
					fields: ['variable', 'valor'],
					data : [ 
								['MB','Moneda Base'],
								['MT','Moneda Triangulacion'],
								['MA','Moneda Actualizacion'],
							]
				}),
				valueField: 'variable',
				displayField: 'valor'
			},
			type:'ComboBox',
			form:true
		},{
			config:{
				name: 'cc',
				fieldLabel: 'Centro Costo',
				allowBlank: true,
				anchor: '80%',
				gwidth: 50,				
			},
			type:'Checkbox',		
			form:true	
		},{
			config:{
				name: 'partida',
				fieldLabel: 'Partida',
				allowBlank: true,
				anchor: '80%',
				gwidth: 50,				
			},
			type:'Checkbox',		
			form:true	
		},{
			config:{
				name: 'auxiliar',
				fieldLabel: 'Auxiliar',
				allowBlank: true,
				anchor: '80%',
				gwidth: 50,				
			},
			type:'Checkbox',		
			form:true	
		},{
			config:{
				name: 'ordenes',
				fieldLabel: 'Ordenes',
				allowBlank: true,
				anchor: '80%',
				gwidth: 50,				
			},
			type:'Checkbox',			
			form:true	
		},
		{
			config:{
				name: 'nro_comprobante',
				fieldLabel: 'Nro de Comprobante',
				allowBlank: true,
				anchor: '80%',
				gwidth: 50,				
			},
			type:'Checkbox',			
			form:true	
		},{
			config:{
				name: 'relacional',
				fieldLabel: 'Comprobante Relacional',
				allowBlank: true,
				anchor: '80%',
				gwidth: 50,			
			},
			type:'Checkbox',			
			form:true	
		},{
			config:{
				name: 'nro_tramite',
				fieldLabel: 'Nro de Tramite',
				allowBlank: true,
				anchor: '80%',
				gwidth: 50,
				checked:true		
			},
			type:'Checkbox',
			form:true,		
		},{
			config:{
				name: 'fec',
				fieldLabel: 'Fecha',
				allowBlank: true,
				anchor: '80%',
				gwidth: 50,
				checked:true		
			},
			type:'Checkbox',
			form:true,		
		},
		{
			config:{
				name:'tipo_formato',
				fieldLabel:'Tipo de Reporte',
				allowBlank:false,
				emptyText:'Tipo...',
				typeAhead: true,
				triggerAction: 'all',
				lazyRender:true,
				mode: 'local',
				valueField: 'tipo_reporte',
				gwidth: 100,
				store:new Ext.data.ArrayStore({
					fields: ['variable', 'valor'],
					data : [ 
								['pdf','PDF'],
								['xls',' EXCEL']
							]
				}),
				valueField: 'variable',
				displayField: 'valor'
			},
			type:'ComboBox',
			form:true
		}
	],

	title:'Filtro',
	onSubmit:function(){
		//TODO passar los datos obtenidos del wizard y pasar  el evento save		
		if (this.form.getForm().isValid()) {
			this.fireEvent('beforesave',this,this.getValues());
			this.getValues();
		}
	},
	
	getValues:function(){		
		var resp = {			
			tipo_moneda:this.Cmp.tipo_moneda.getValue(),
			cc:this.Cmp.cc.getValue(),
			partida:this.Cmp.partida.getValue(),
			auxiliar:this.Cmp.auxiliar.getValue(),
			ordenes:this.Cmp.ordenes.getValue(),
			relacional:this.Cmp.relacional.getValue(),
			nro_tramite:this.Cmp.nro_tramite.getValue(),
			nro_comprobante:this.Cmp.nro_comprobante.getValue(),
			tipo_formato:this.Cmp.tipo_formato.getValue(),
			
			fec:this.Cmp.fec.getValue()
		}
		return resp;
	}

})
</script>
