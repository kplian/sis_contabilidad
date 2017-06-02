<?php
/**
*@package pXP
*@file OrdenTrabajoArb.php
*@author  Gonzalo Sarmiento Sejas
*@date 21-02-2013 15:04:03
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.OrdenTrabajoArb=Ext.extend(Phx.arbGridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;		
    	//llama al constructor de la clase padre
		Phx.vista.OrdenTrabajoArb.superclass.constructor.call(this,config);
		
		this.init();
		this.iniciarEventos();
		
	},
	
	
	

			
	Atributos:[
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
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_orden_trabajo_fk'
			},
			type:'Field',
			form:true 
		},
		
		{
			config:{
				name: 'codigo',
				fieldLabel: 'Codigo Orden',
				allowBlank: false,
				anchor: '80%',
				gwidth: 300,
				maxLength:100
			},
			type:'TextField',
			filters:{pfiltro:'odt.codigo',type:'string'},
			bottom_filter : true,
			id_grupo:1,
			grid:true,
			form:true
		},
		
		{
			config:{
				name: 'desc_orden',
				fieldLabel: 'Descripcion Orden',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:400
			},
			type:'TextField',
			filters:{pfiltro:'odt.desc_orden',type:'string'},
			bottom_filter : true,
			id_grupo:1,
			grid:true,
			form:true
		},
		
		
		
		
		{
			config:{
				name: 'motivo_orden',
				fieldLabel: 'Motivo Orden',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:450
			},
			type:'TextArea',
			filters:{pfiltro:'odt.motivo_orden',type:'string'},
			bottom_filter : true,
			id_grupo:1,
			grid:true,
			form:true
		},
		
		{
			config:{
				name: 'movimiento',
				qtip:'los nodos transaccionales no tienen hijos, son lo que usan en las transacciones (por ejm solicitudes de compra)',
				fieldLabel: 'Transaccional',
				allowBlank: false,
				anchor: '40%',
				gwidth: 50,
				maxLength:2,
				emptyText:'si/no...',       			
       			typeAhead: true,
       		    triggerAction: 'all',
       		    lazyRender:true,
       		    mode: 'local',
       		    valueField: 'inicio', 
       		    forcSselect:true,      		    
       		   // displayField: 'descestilo',
       		    store:['si','no']
			},
			type:'ComboBox',
			id_grupo:1,
			filters:{	
	       		         type: 'list',
	       				 pfiltro:'odt.movimiento',
	       				 options: ['si','no'],	
	       		 	},
	       	valorInicial:'si',
			grid:true,
			form:true
		},
		
		{
			config:{
				name: 'tipo',
				fieldLabel: 'Tipo de Aplicacion?',
				allowBlank: false,
				anchor: '80%',
				gwidth: 50,				
				emptyText:'tipo...',       			
       			typeAhead: true,
       		    triggerAction: 'all',
       		    lazyRender:true,
       		    mode: 'local',
       		    valueField: 'inicio',    
       		    store:['centro','edt','orden','estadistica']
			},
			type:'ComboBox',
			id_grupo:1,
			filters:{	
	       		         type: 'list',
	       				 pfiltro:'odt.tipo',
	       				 options: ['centro','edt','orden','estadistica']
	       		 	},
	        valorInicial:'estadistica',
			grid:true,
			form:true
		},
		
		{
			config:{
				name: 'fecha_inicio',
				fieldLabel: 'Fecha Inicio',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type:'DateField',
			filters:{pfiltro:'odt.fecha_inicio',type:'date'},
			id_grupo:1,
			grid:true,
			form:true
		},
		
		
		{
			config:{
				name: 'fecha_final',
				fieldLabel: 'Fecha Final',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type:'DateField',
			filters:{pfiltro:'odt.fecha_final',type:'date'},
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
			filters:{pfiltro:'odt.estado_reg',type:'string'},
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
			filters:{pfiltro:'odt.fecha_reg',type:'date'},
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
			type:'NumberField',
			filters:{pfiltro:'usu1.cuenta',type:'string'},
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
			type:'NumberField',
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
			filters:{pfiltro:'odt.fecha_mod',type:'date'},
			id_grupo:1,
			grid:true,
			form:false
		}
	],
	
	title:'Ordenes',
	ActSave:'../../sis_contabilidad/control/OrdenTrabajo/insertarOrdenTrabajoArb',
	ActDel:'../../sis_contabilidad/control/OrdenTrabajo/eliminarOrdenTrabajoArb',
	ActList:'../../sis_contabilidad/control/OrdenTrabajo/listarOrdenTrabajoArb',
	id_store:'id_cuenta',
	
	textRoot:'Ordenes de Costo',
    id_nodo:'id_orden_trabajo',
    id_nodo_p:'id_orden_trabajo_fk',
	
	fields: [
	   {name:'id_orden_trabajo', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'fecha_final', type: 'date',dateFormat:'Y-m-d'},
		{name:'fecha_inicio', type: 'date',dateFormat:'Y-m-d'},
		{name:'desc_orden', type: 'string'},
		{name:'motivo_orden', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'tipo','movimiento','codigo','descripcion','id_orden_trabajo_fk','tipo_nodo'
		
		
		
	],
	
	sortInfo:{
		field: 'id_orden_trabajo',
		direction: 'ASC'
	},
	bdel: true,
	bsave: false,
	rootVisible: true,
	expanded: false,
	
	
    getTipoCuentaPadre: function(n) {
			var direc
			var padre = n.parentNode;
            if (padre) {
				if (padre.attributes.id != 'id') {
					return this.getTipoCuentaPadre(padre);
				} else {
					return n.attributes.tipo_cuenta;
				}
			} else {
				return undefined;
			}
		},
		
		
	tabeast:[
		  {
    		  url:'../../../sis_contabilidad/vista/tipo_cc_ot/TipoCcOt.php',
    		  title:'Tipo de Centro', 
    		  width:'60%',
    		  cls:'TipoCcOt'
		  }]
})
</script>