<?php
/**
*@package pXP
*@file TipoCcArbRep.php
*@author  Gonzalo Sarmiento Sejas
*@date 21-02-2013 15:04:03
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.TipoCcArbRep=Ext.extend(Phx.arbGridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
		//llama al constructor de la clase padre
		Phx.vista.TipoCcArbRep.superclass.constructor.call(this,config);
		
		this.campo_fecha_desde = new Ext.form.DateField({
	            name: 'desde',
	            fieldLabel: 'Desde',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				format: 'd/m/Y'
	    });
			
		this.campo_fecha_hasta = new Ext.form.DateField({
	            name: 'hasta',
	            fieldLabel: 'Hasta',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				format: 'd/m/Y'
	    });
	    
	   
	    
	    
		this.tbar.addField('Desde:');
		this.tbar.addField(this.campo_fecha_desde);
		this.tbar.addField('Hasta:');		
		this.tbar.addField(this.campo_fecha_hasta);
		this.campo_fecha_desde.setValue();
		this.campo_fecha_hasta.setValue();
		
		
		//Botón para Imprimir el Comprobante
		this.addButton('btnImprimir', {
				text : 'Sincronizar',
				iconCls : 'bexecdb',
				disabled : false,
				handler : this.sincronizarRangos,
				tooltip : '<b>Actuliza los valores de costos desde los comrpbantes aprobados  entre los  periodos de fechas seleccioandas</b>'
			});
		
    			
		this.init();
		
		this.iniciarEventos();
		
		
	},
	
	Atributos:[
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
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_tipo_cc_fk'
			},
			type:'Field',
			form:true 
		},
		
		{
			config:{
				name: 'codigo',
				fieldLabel: 'codigo',
				allowBlank: false,
				anchor: '80%',
				gwidth: 200,
				maxLength:200/*
				gtpl: function (value,p,record){
					console.log(this, arguments)
						return  String.format('<b>{0}<b> {1} [{2}] MB',this.codigo, this.descripcion, Ext.util.Format.number(this.balance_mb,'0,000.00'));
				}*/
				
			},
				type:'TextField',
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'descripcion',
				fieldLabel: 'descripcion',
				allowBlank: true,
				anchor: '80%',
				gwidth: 300,
				maxLength:400
			},
				type:'TextArea',
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'balance_mb',
				fieldLabel: 'Balance MB ?',				
				gwidth: 159,
       		    galign: 'right',
       		    gtpl: function (){
					console.log('....oooo', arguments)
						return  String.format('<b>{0}<b>',Ext.util.Format.number(this.balance_mb,'0,000.00'));
				}
			},
			type:'Field',
			grid:true
		},
		{
			config:{
				name: 'balance_mt',
				fieldLabel: 'Balance MT ?',				
				gwidth: 150,
				galign: 'right',
       		    gtpl: function (){
					return  String.format('<b>{0}<b>',Ext.util.Format.number(this.balance_mt,'0,000.00'));
				}
			},
			type:'Field',
			grid:true
		}
	],
	

	title:'Ordenes',	
	ActList:'../../sis_contabilidad/control/Rango/listarTipoCcArbRep',
	id_store:'id_tipo_cc',
	
	textRoot:'Ordenes de Costo',
    id_nodo:'id_tipo_cc',
    id_nodo_p:'id_tipo_cc_fk',
	
	fields:  [
		{name:'id_tipo_cc', type: 'numeric'},
		{name:'codigo', type: 'string'},
		{name:'control_techo', type: 'string'},
		{name:'mov_pres', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'movimiento', type: 'string'},
		{name:'id_ep', type: 'numeric'},
		{name:'id_tipo_cc_fk', type: 'numeric'},
		{name:'descripcion', type: 'string'},
		{name:'tipo', type: 'string'},
		{name:'control_partida', type: 'string'},
		{name:'momento_pres', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d'},
		{name:'fecha_inicio', type: 'date',dateFormat:'Y-m-d'},
		{name:'fecha_final', type: 'date',dateFormat:'Y-m-d'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'id_ep','debe_mb','haber_mb',
		'debe_mt','haber_mt','balance_mb','balance_mb'
		
	],
	
	sortInfo:{
		field: 'id_tipo_cc',
		direction: 'ASC'
	},
	bdel: false,
	bnew: false,
	bedit: false,
	bsave: false,
	rootVisible: false,
	expanded: false,
	
	validarFiltros : function() {		
		if ( this.campo_fecha_hasta.validate()  && this.campo_fecha_desde.validate()) {			
			return true;
		} else {
			return false;
		}
		
	},
	onButtonAct : function() {
		
			if (!this.validarFiltros()) {
				alert('Especifique los filtros antes')
			}
			else{
				 this.capturaFiltros();
			}
			
	},
	capturaFiltros : function(combo, record, index) {
		
		
		  var desde = this.campo_fecha_desde.getValue(),
		      hasta = this.campo_fecha_hasta.getValue();
		
		
		    if(desde && hasta){
		    	this.loaderTree.baseParams={ 
			                         desde: desde.dateFormat('d/m/Y'), 
			                         hasta: hasta.dateFormat('d/m/Y')};
		    }
			
			                         
			
			this.root.reload();
			
	},
	
	sincronizarRangos: function(){
		
		
		var desde = this.campo_fecha_desde.getValue(),
		    hasta = this.campo_fecha_hasta.getValue();
		 if(desde && hasta){
		 	Phx.CP.loadingShow();
			Ext.Ajax.request({
					url:'../../sis_contabilidad/control/Rango/sincronizarRangos',
					params:{ desde: desde.dateFormat('d/m/Y'), 
				             hasta: hasta.dateFormat('d/m/Y')},
					success: this.successRango,
					failure: this.conexionFailure,
					timeout: this.timeout,
					scope: this
				});
		 }
		 else{
		 	alert('Especifique el rango de fecha que queire sincronizar');
		 }
			
	},
	
	successRango: function(){
		Phx.CP.loadingHide();
		this.root.reload();
	},
	
	 
	tabeast:[
		  {
    		  url:'../../../sis_contabilidad/vista/rango/Rango.php',
    		  title:'Detalle', 
    		  width:'50%',
    		  cls:'Rango'
			},
			{
	          url:'../../../sis_contabilidad/vista/rango/RangoTorta2.php',
	          title:'Pie', 
	          cls:'RangoTorta2'
         }]
	
	
	
	
   
})
</script>