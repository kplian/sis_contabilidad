<?php
/**
*@package pXP
*@file gen-IntRelDevengado.php
*@author  (admin)
*@date 09-10-2015 12:31:01
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.IntRelDevengado=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
    	Phx.vista.IntRelDevengado.superclass.constructor.call(this,config);
		this.init();
		this.store.baseParams={id_int_comprobante_pago: this.id_int_comprobante}; 
        this.load({params:{start:0, limit:this.tam_pag}});
        
        this.Cmp.id_int_transaccion_pag.store.baseParams = Ext.apply(this.Cmp.id_int_transaccion_pag.store.baseParams,{id_int_comprobante: this.id_int_comprobante, resumen: 'no'}); 
	    //this.Cmp.id_int_transaccion_dev.store.baseParams = Ext.apply(this.Cmp.id_int_transaccion_dev.store.baseParams,{id_int_comprobante_fks: this.id_int_comprobante_fks, resumen: 'no', pres_gasto_recurso: 'si'}); 
		this.Cmp.id_int_transaccion_dev.store.baseParams = Ext.apply(this.Cmp.id_int_transaccion_dev.store.baseParams,{id_int_comprobante_fks: this.id_int_comprobante_fks, resumen: 'no',forzar_relacion:'si'}); 
	
	
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_int_rel_devengado'
			},
			type:'Field',
			form:true 
		},
		
		{
			config:{
				name: 'monto_pago',
				fieldLabel: 'monto_pago',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'rde.monto_pago',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'monto_pago_mb',
				fieldLabel: 'monto_pago_mb',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'rde.monto_pago_mb',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:false
		},
		
		{
			config: {
				name: 'id_int_transaccion_pag',
				fieldLabel: 'Tran Pago',
				qtip: 'Transaccion del comprobante de pago (donde se llevara  el presupuesto a momento pagado)',
				allowBlank: false,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_contabilidad/control/IntTransaccion/listarIntTransaccion',
					id: 'id_int_transaccion',
					root: 'datos',
					sortInfo: {
						field: 'id_int_transaccion',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_int_transaccion', 'desc_cuenta', 'desc_centro_costo', 'desc_auxiliar','desc_partida','importe_debe','importe_haber','desc_orden','importe_gasto','importe_recurso'],
					remoteSort: true,
					baseParams: {par_filtro: 'transa.id_int_comprobante#transa.id_int_transaccion#cue.nro_cuenta#cc.codigo_cc#aux.codigo_auxiliar#par.nombre_partida#par.codigo#ot.desc_orden'}
				}),
				valueField: 'id_int_transaccion',
				displayField: 'id_int_transaccion',
				hiddenName: 'id_int_transaccion_pag',
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				width: 250,
				anchor: '100%',
				gwidth: 350,
				minChars: 2,
				tpl : new Ext.XTemplate('<tpl for="."><div class="x-combo-list-item">'+
			          '<b>CC:</b>{desc_centro_costo}<br>'+
			          '<b>Cta.:</b>{desc_cuenta}<br>'+
					  '<b>Aux.:</b>{desc_auxiliar}</br>'+
                      '<b>Ptda.:</b> <font color="black">{desc_partida}</font><br>'+
                      '<b>Ot.: {desc_orden}</b></br> '+
                      '<b>Monto Gasto.: {importe_gasto}</b></br> '+
                      '<b>Monto Recurso.: {importe_recurso}</b>,   ID; {id_int_transaccion}</div></tpl>'),
                      
				renderer:function (value, p, record){
	   			        var color = 'green';
	   			    
		   			    if(record.data["tipo_partida_pag"] == 'flujo'){
		   			        color = 'red';
		   			    }
		   			    
		   					
		   				var retorno =  String.format('<b>(id Cbte: {0})</b><br><b>CC:</b>{1}, <br><b>Cta.:</b>{1}<br>',record.data['id_int_comprobante_pago'],record.data['desc_centro_costo_pag'], record.data['desc_cuenta_pag']);	
		   					
		   					if(record.data['desc_auxiliar_pag']){
			   					retorno = retorno + String.format('<b>Aux.:</b>{0}</br>', record.data['desc_auxiliar_pag']);
			   				}
		   					
		   					
		   					if(record.data['desc_partida_pag']){
			   					retorno = retorno + String.format('<b>Ptda.:</b> <font color="{0}">{1}</font><br>',color, record.data['desc_partida_pag']);
			   				}
		   					
			   				if(record.data['desc_orden_pag']){
			   					retorno = retorno + '<b>Ot.:</b> '+record.data['desc_orden_pag'];
			   				}	
		   				return String.format('<div class="gridmultiline">{0}</div>',retorno);	
	   			 }
			},
			type: 'ComboBox',
			id_grupo: 1,
			filters:{	
		        pfiltro:'desc_centro_costo_pag#desc_partida_pag#desc_cuenta_pag#desc_auxiliar_pag#ot.desc_orden_pag',
				type:'string'
			},
			grid: true,
			form: true
		},
		
		{
			config:{
				name: 'importe_gasto_pag',
				fieldLabel: 'Cbte Pago',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650,
				renderer:function (value, p, record){
					if(record.data.importe_gasto_pag > 0 ){
						return record.data.importe_gasto_pag;
					}
					else{
						return record.data.importe_recurso_pag;
					}
					 
				}
			},
				type:'NumberField',
				filters:{pfiltro:'importe_gasto_pag#importe_recurso_pag',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:false
		},
		
		{
			config: {
				name: 'id_int_transaccion_dev',
				fieldLabel: 'Tran Dev',
				qtip: 'Transaccion del comprobante de devengado (que tiene el presupuesto ejecutado)',
				allowBlank: false,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_contabilidad/control/IntTransaccion/listarIntTransaccion',
					id: 'id_int_transaccion',
					root: 'datos',
					sortInfo: {
						field: 'id_int_transaccion',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_int_transaccion', 'id_int_comprobante','desc_cuenta', 'desc_centro_costo', 'desc_auxiliar','desc_partida','importe_debe','importe_haber','desc_orden','importe_recurso','importe_gasto'],
					remoteSort: true,
					baseParams: {par_filtro: 'transa.id_int_comprobante#transa.id_int_transaccion#cue.nro_cuenta#cc.codigo_cc#aux.codigo_auxiliar#par.nombre_partida#par.codigo#ot.desc_orden'}
				}),
				valueField: 'id_int_transaccion',
				displayField: 'id_int_transaccion',
				hiddenName: 'id_int_transaccion_dev',
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				width: 250,
				anchor: '100%',
				gwidth: 350,
				minChars: 2,
				
			    tpl : new Ext.XTemplate('<tpl for="."><div class="x-combo-list-item">',
			          '<b>ID Cbte:</b>{id_int_comprobante}<br>'+
			          '<b>CC:</b>{desc_centro_costo}<br>'+
			          '<b>Cta.:</b>{desc_cuenta}<br>'+
					  '<b>Aux.:</b>{desc_auxiliar}</br>'+
                      '<b>Ptda.:</b> <font color="black">{desc_partida}</font><br>'+
                      '<b>Ot.: {desc_orden}</b></br> '+
                      '<b>Monto Gasto.: {importe_gasto}</b></br> '+  
                      '<b>Monto Recurso.: {importe_recurso}</b>, ID; {id_int_transaccion}</div></tpl>'),
                      
				renderer:function (value, p, record){
	   			        var color = 'green';
	   			    
		   			    if(record.data["tipo_partida_dev"] == 'flujo'){
		   			        color = 'red';
		   			    }
		   			    
		   					
		   				var retorno =  String.format('<b>Cbte: {0} (id: {1})</b><br><b>CC:</b>{2}, <br><b>Cta.:</b>{3}<br>',record.data['nro_cbte_dev'], record.data['id_int_comprobante_dev'], record.data['desc_centro_costo_dev'], record.data['desc_cuenta_dev']);	
		   					
		   					if(record.data['desc_auxiliar_dev']){
			   					retorno = retorno + String.format('<b>Aux.:</b>{0}</br>', record.data['desc_auxiliar_dev']);
			   				}
		   					
		   					
		   					if(record.data['desc_partida_dev']){
			   					retorno = retorno + String.format('<b>Ptda.:</b> <font color="{0}">{1}</font><br>',color, record.data['desc_partida_dev']);
			   				}
		   					
			   				if(record.data['desc_orden_dev']){
			   					retorno = retorno + '<b>Ot.:</b> '+record.data['desc_orden_dev'];
			   				}	
		   				return String.format('<div class="gridmultiline">{0}</div>',retorno);	
	   			 }
			},
			type: 'ComboBox',
			id_grupo: 1,
			filters:{	
		        pfiltro:'desc_centro_costo_dev#desc_partida_dev#desc_cuenta_dev#desc_auxiliar_dev#ot.desc_orden_dev',
				type:'string'
			},
			grid: true,
			form: true
		},
		{
			config:{
				name: 'importe_gasto_dev',
				fieldLabel: 'Cbte Dev',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650,
				renderer:function (value, p, record){
					if(record.data.importe_debe_pag > 0 ){
						return record.data.importe_gasto_dev;
					}
					else{
						return record.data.importe_recurso_dev;
					}
					 
				}
			},
				type:'NumberField',
				filters:{pfiltro:'importe_gasto_dev#importe_recurso_dev',type:'numeric'},
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
				filters:{pfiltro:'rde.estado_reg',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: '',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'rde.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'rde.fecha_reg',type:'date'},
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
				filters:{pfiltro:'rde.usuario_ai',type:'string'},
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
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'rde.fecha_mod',type:'date'},
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
	title:'RELDEV',
	ActSave:'../../sis_contabilidad/control/IntRelDevengado/insertarIntRelDevengado',
	ActDel:'../../sis_contabilidad/control/IntRelDevengado/eliminarIntRelDevengado',
	ActList:'../../sis_contabilidad/control/IntRelDevengado/listarIntRelDevengado',
	id_store:'id_int_rel_devengado',
	fields: [
		{name:'id_int_rel_devengado', type: 'numeric'},
		{name:'id_int_transaccion_pag', type: 'numeric'},
		{name:'id_int_transaccion_dev', type: 'numeric'},
		{name:'monto_pago', type: 'numeric'},
		{name:'id_partida_ejecucion_pag', type: 'numeric'},
		{name:'monto_pago_mb', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		'nro_cbte_dev',
        'desc_cuenta_dev',
        'desc_partida_dev',
        'desc_centro_costo_dev',
        'desc_orden_dev',
        'importe_debe_dev',
        'importe_haber_dev',
        'desc_cuenta_pag',
        'desc_partida_pag',
        'desc_centro_costo_pag',
        'desc_orden_pag',
        'importe_debe_pag',
        'importe_haber_pag',
        'id_cuenta_dev',
        'id_orden_trabajo_dev',
        'id_auxiliar_dev',
        'id_centro_costo_dev',
        'id_cuenta_pag',
        'id_orden_trabajo_pag',
        'id_auxiliar_pag',
        'id_int_comprobante_pago',
		'id_int_comprobante_dev',
		'tipo_partida_dev',
        'tipo_partida_pag',
        'desc_auxiliar_dev',
        'desc_auxiliar_pag',
        'importe_gasto_pag',
	    'importe_recurso_pag',
	    'importe_gasto_dev',
	    'importe_recurso_dev'

	],
	sortInfo:{
		field: 'id_int_rel_devengado',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
	preparaMenu : function(n) {
			var tb = Phx.vista.IntRelDevengado.superclass.preparaMenu.call(this);
			
			
			if(this.estado_reg != 'borrador'){
				this.getBoton('new').setDisabled(true);
			    this.getBoton('edit').setDisabled(true);
			    this.getBoton('del').setDisabled(true);
			}
			
			
			

			return tb;
	},
	liberaMenu : function() {
			var tb = Phx.vista.IntRelDevengado.superclass.liberaMenu.call(this);
			if(this.estado_reg != 'borrador'){
				this.getBoton('new').setDisabled(true);
			    this.getBoton('edit').setDisabled(true);
			    this.getBoton('del').setDisabled(true);
			}
	}
});
</script>
		
		