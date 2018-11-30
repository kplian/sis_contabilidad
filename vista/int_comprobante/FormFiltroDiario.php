<?php
/**
*@package pXP
*@file    FormFiltroDiario.php
*@author  manuel guerra
*@date    09-10-2017
*@description muestra un formulario que muestra la cuenta y el monto de la transferencia
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.FormFiltroDiario=Ext.extend(Phx.frmInterfaz,{
		
	layout:'fit',
	maxCount:0,
	constructor:function(config){   
		Phx.vista.FormFiltroDiario.superclass.constructor.call(this,config);
		this.init(); 
		this.iniciarEventos();		
		this.loadValoresIniciales();		
	},

	Atributos:[
		{
			config:{
				name: 'nro_comprobante',
				fieldLabel: 'Nro de Comprobante',
				allowBlank: true,
				anchor: '80%',
				gwidth: 50,				
				checked:true				
			},
			type:'Checkbox',			
			form:true	
		},{
			config:{
				name: 'beneficiario',
				fieldLabel: 'Beneficiario',
				allowBlank: true,
				anchor: '80%',
				gwidth: 50,				
			},
			type:'Checkbox',		
			form:true	
		},/*{
			config:{
				name: 'partida',
				fieldLabel: 'Partida',
				allowBlank: true,
				anchor: '80%',
				gwidth: 50,				
			},
			type:'Checkbox',		
			form:true	
		},*/{
			config:{
				name: 'fecha',
				fieldLabel: 'Fecha',
				allowBlank: true,
				anchor: '80%',
				gwidth: 50,				
			},
			type:'Checkbox',			
			form:true	
		},/*{
			config:{
				name: 'nro_tramite',
				fieldLabel: 'Nro Tramite',
				allowBlank: true,
				anchor: '80%',
				gwidth: 50,			
			},
			type:'Checkbox',			
			form:true	
		},{
			config:{
				name: 'cc',
				fieldLabel: 'Centro de Costo',
				allowBlank: true,
				anchor: '80%',
				gwidth: 50,			
			},
			type:'Checkbox',			
			form:true	
		},{
			config:{
				name: 'desc_tipo_relacion_comprobante',
				fieldLabel: 'Tipo de Relacion de Comprobante',
				allowBlank: true,
				anchor: '80%',
				gwidth: 50,
				checked:true		
			},
			type:'Checkbox',
			form:true,		
		},*/{
			config:{
				name: 'fecIni',
				fieldLabel: 'Fecha Inicial',
				allowBlank: true,
				anchor: '80%',
				gwidth: 50		
			},
			type:'DateField',
			form:true,		
		},{
			config:{
				name: 'fecFin',
				fieldLabel: 'Fecha Final',
				allowBlank: true,
				anchor: '80%',
				gwidth: 50		
			},
			type:'DateField',
			form:true,		
		},{
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
				displayField: 'valor',
				listeners: {
					'afterrender': function(combo){			  
						combo.setValue('MB');
					}
				}
			},
			type:'ComboBox',
			form:true
		},{
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
								['pdf_c','PDF CUADRICULADA'],
								['xls',' EXCEL'],
							]
				}),
				valueField: 'variable',
				displayField: 'valor',
				listeners: {
					'afterrender': function(combo){			  
						combo.setValue('pdf');
					}
				}
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
			beneficiario:this.Cmp.beneficiario.getValue(),
			//partida:this.Cmp.partida.getValue(),						
			fecha:this.Cmp.fecha.getValue(),
			nro_comprobante:this.Cmp.nro_comprobante.getValue(),					
			//nro_tramite:this.Cmp.nro_tramite.getValue(),			
			//desc_tipo_relacion_comprobante:this.Cmp.desc_tipo_relacion_comprobante.getValue(),			
			tipo_formato:this.Cmp.tipo_formato.getValue(),			
			fecIni:this.Cmp.fecIni.getValue(),
			fecFin:this.Cmp.fecFin.getValue(),
			//cc:this.Cmp.cc.getValue()	
		}
		return resp;
	}

})
</script>
