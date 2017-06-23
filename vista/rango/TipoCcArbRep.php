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
				tpl: function (value,p,record){
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
       		    tpl: function (){
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
       		    tpl: function (){
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
	rootVisible: true,
	expanded: false,
	
	tabeast:[
		  {
    		  url:'../../../sis_contabilidad/vista/rango/Rango.php',
    		  title:'Detalle', 
    		  width:'35%',
    		  cls:'Rango'
	}]
	
	
   
})
</script>