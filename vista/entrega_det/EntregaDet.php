<?php
/**
*@package pXP
*@file gen-EntregaDet.php
*@author  (admin)
*@date 17-11-2016 19:50:46
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.EntregaDet=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.EntregaDet.superclass.constructor.call(this,config);
		this.addButton('chkdep',{	text:'Dependencias',
				iconCls: 'blist',
				disabled: true,
				handler: this.checkDependencias,
				tooltip: '<b>Revisar Dependencias </b><p>Revisar dependencias del comprobante</p>'
			});
			
		this.init();
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_entrega_det'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_entrega'
			},
			type:'Field',
			form:true 
		},
		{
			config : {
				name : 'id_int_comprobante',
				fieldLabel : 'ID Cbte.',
				qtip : 'Comprobante a entregar',
				allowBlank : true,
				emptyText : 'Elija una opción...',
				store : new Ext.data.JsonStore({
					url : '../../sis_contabilidad/control/IntComprobante/listarSimpleIntComprobante',
					id : 'id_int_comprobante',
					root : 'datos',
					sortInfo : {
						field : 'id_int_comprobante',
						direction : 'DESC'
					},
					totalProperty : 'total',
					fields : ['id_int_comprobante', 'nro_cbte', 'nro_tramite', 'fecha', 'glosa1', 'glosa2', 'id_clase_comprobante', 'codigo', 'descripcion'],
					remoteSort : true,
					baseParams : {
						par_filtro : 'inc.id_int_comprobante#inc.nro_cbte#inc.fecha#inc.glosa1#inc.glosa2#inc.nro_tramite'
					}
				}),
				tpl : new Ext.XTemplate('<tpl for="."><div class="awesomecombo-5item {checked}">', '<p>(ID: {id_int_comprobante}), Nro: {nro_cbte}</p>', '<p>Fecha: <strong>{fecha}</strong></p>', '<p>TR: {nro_tramite}</p>', '<p>GLS: {glosa1}</p>', '</div></tpl>'),
				itemSelector : 'div.awesomecombo-5item',

				valueField : 'id_int_comprobante',
				displayField : 'nro_cbte',
				gdisplayField : 'nro_cbte',
				forceSelection : true,
				typeAhead : false,
				triggerAction : 'all',
				lazyRender : true,
				mode : 'remote',
				pageSize : 15,
				queryDelay : 1000,
				width : 250,
				anchor : '100%',
				listWidth : '320',
				gwidth : 150,
				minChars : 2,
				resizable : true,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['id_int_comprobante']);
				}
			},
			type : 'ComboBox',
			id_grupo : 1,
			filters:{pfiltro:'cbte.id_int_comprobante',type:'numeric'},
			grid : true,
			form : true
		},
		
		{
			config:{
				name: 'nro_cbte',
				fieldLabel: 'Nro Cbte',
				gwidth: 250
			},
				type:'Field',
				filters: { pfiltro:'cbte.nro_cbte',type:'string' },
				id_grupo: 1,
				grid: true,
				form: false
		},
		{
			config:{
				name: 'beneficiario',
				fieldLabel: 'Beneficiario',
				gwidth: 250
			},
				type:'Field',
				filters:{pfiltro:'cbte.beneficiario',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'nro_tramite',
				fieldLabel: 'Tramite',
				gwidth: 130
			},
				type:'Field',
				filters:{pfiltro:'cbte.nro_tramite',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'desc_clase_comprobante',
				fieldLabel: 'Tipo',
				gwidth: 130
			},
				type:'Field',
				filters:{pfiltro:'cbte.desc_clase_comprobante',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'glosa1',
				fieldLabel: 'Glosa',
				gwidth: 250
			},
				type:'Field',
				filters:{pfiltro:'cbte.glosa1',type:'string'},
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
				filters:{pfiltro:'ende.estado_reg',type:'string'},
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
				filters:{pfiltro:'ende.fecha_reg',type:'date'},
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
				filters:{pfiltro:'ende.usuario_ai',type:'string'},
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
				filters:{pfiltro:'ende.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'ende.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Entrega Detalle',
	ActSave:'../../sis_contabilidad/control/EntregaDet/insertarEntregaDet',
	ActDel:'../../sis_contabilidad/control/EntregaDet/eliminarEntregaDet',
	ActList:'../../sis_contabilidad/control/EntregaDet/listarEntregaDet',
	id_store:'id_entrega_det',
	fields: [
		{name:'id_entrega_det', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_int_comprobante', type: 'numeric'},
		{name:'id_entrega', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		'nro_cbte','nro_tramite', 'beneficiario','desc_clase_comprobante','glosa1'
		
	],
	sortInfo:{
		field: 'id_entrega_det',
		direction: 'ASC'
	},
	bdel:true,
	bsave:false,
	bedit:false,
	checkDependencias: function(){                   
			  var rec=this.sm.getSelected();
			  var configExtra = [];
			  this.objChkPres = Phx.CP.loadWindows('../../../sis_contabilidad/vista/int_comprobante/CbteDependencias.php',
										'Dependencias',
										{
											modal:true,
											width: '80%',
											height: '80%'
										}, 
										  rec.data, 
										  this.idContenedor,
										 'CbteDependencias');			   
	},
	onReloadPage:function(m){
		this.maestro=m;						
		this.store.baseParams={id_entrega:this.maestro.id_entrega};
		this.load({params:{start:0, limit:this.tam_pag}});
	},
	loadValoresIniciales:function(){
		Phx.vista.EntregaDet.superclass.loadValoresIniciales.call(this);
		console.log('asigna depto', this.maestro)
		this.Cmp.id_int_comprobante.store.baseParams.id_deptos = this.maestro.id_depto_conta;
		this.Cmp.id_int_comprobante.modificado = true;
		this.getComponente('id_entrega').setValue(this.maestro.id_entrega);		
	},
	preparaMenu : function(n) {
			var tb = Phx.vista.EntregaDet.superclass.preparaMenu.call(this);
			this.getBoton('chkdep').enable();
			if(this.maestro.estado == 'borrador'){
				this.getBoton('new').enable();
				this.getBoton('del').enable();
			}
			else{
				this.getBoton('new').disable();
				this.getBoton('del').disable();
			}
			return tb;
	},
	liberaMenu : function() {
			var tb = Phx.vista.EntregaDet.superclass.liberaMenu.call(this);
			this.getBoton('chkdep').disable();
			if(this.maestro.estado != 'borrador'){
				this.getBoton('new').disable();
			}
	}
})
</script>
		
		