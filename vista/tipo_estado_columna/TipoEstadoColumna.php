<?php
/**
*@package pXP
*@file gen-TipoEstadoColumna.php
*@author  (admin)
*@date 26-07-2017 21:49:56
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.TipoEstadoColumna=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	Phx.vista.TipoEstadoColumna.superclass.constructor.call(this,config);
		this.init();
		this.bloquearMenus();
		this.iniciarEventos();
		
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_tipo_estado_columna'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_tipo_estado_cuenta'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'codigo',
				fieldLabel: 'Código',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
				type:'TextField',
				filters:{pfiltro:'tecc.codigo',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'nombre',
				fieldLabel: 'Nombre',
				allowBlank: false,
				anchor: '80%',
				gwidth: 200,
				maxLength:300
			},
				type:'TextField',
				filters:{pfiltro:'tecc.nombre',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'prioridad',
				fieldLabel: 'Prioridad',
				allowBlank: false,
				anchor: '80%',
				gwidth: 50,
				maxLength:300
			},
				type:'NumberField',
				filters:{pfiltro:'tecc.prioridad',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
	       		config:{
	       			name:'origen',
	       			qtip:'Define donde se origina los datos, un balance de la subcuenta en contabilidad, o una funcion que hace el calculo',
	       			fieldLabel:'Origen de Datos',
	       			allowBlank:false,
	       			emptyText:'Tipo...',
	       			typeAhead: true,
	       		    triggerAction: 'all',
	       		    lazyRender:true,
	       		    mode: 'local',
	       		    gwidth: 100,
	       		    store:[ 'contabilidad', 'funcion' ]
	       		},
	       		type:'ComboBox',
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	     },
		 {
			config: {
				name: 'id_config_subtipo_cuenta',
				fieldLabel: 'Subtipo',
				typeAhead: false,
				forceSelection: false,
				allowBlank: true,
				emptyText: 'Tipos...',
				store: new Ext.data.JsonStore({
					url: '../../sis_contabilidad/control/ConfigSubtipoCuenta/listarConfigSubtipoCuenta',
					id: 'id_config_subtipo_cuenta',
					root: 'datos',
					sortInfo: {
						field: 'codigo',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['tipo_cuenta', 'id_config_subtipo_cuenta','nombre','codigo'],
					// turn on remote sorting
					remoteSort: true,
					baseParams: {par_filtro: 'cst.nombre#cst.codigo'}
				}),
				valueField: 'id_config_subtipo_cuenta',
				displayField: 'nombre',
				gdisplayField: 'desc_csc',
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 20,
				queryDelay: 200,
				listWidth:280,
				minChars: 2,
				gwidth: 200
				},
			type: 'ComboBox',
			id_grupo: 0,
			form: true,
			grid:true
		},
		
		{
			config:{
				name: 'nombre_funcion',
				qtip:'Nombre de la función que realiza el calculo, recibe como parametros (id_auxiliar, fecha_inicio, fecha_fin, id_tipo_estado_cuenta) debe retornar un numeric',
				fieldLabel: 'Funcion',
				allowBlank: true,
				anchor: '80%',
				gwidth: 200,
				maxLength:300
			},
				type:'TextField',
				filters:{pfiltro:'tecc.nombre_funcion',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'link_int_det',
				qtip:'dirección de la interface que se abra al apretar el boton de detalle',
				fieldLabel: 'Link Detalle',
				allowBlank: true,
				anchor: '80%',
				gwidth: 300,
				maxLength:400
			},
				type:'TextField',
				filters:{pfiltro:'tecc.link_int_det',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'nombre_clase',
				qtip:'Nombre de la case de se ejecuta al mostrar la interface de detalle',
				fieldLabel: 'Clase',
				allowBlank: true,
				anchor: '80%',
				gwidth: 300,
				maxLength:400
			},
				type:'TextField',
				filters:{pfiltro:'tecc.nombre_clase',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'parametros_det',
				qtip:'Parametros que se pasan  a la interface detalle en formato JSON Ejm {id_proveedor: record.id_tabla}',
				fieldLabel: 'Parametros',
				allowBlank: true,
				anchor: '80%',
				gwidth: 300,
				maxLength:400
			},
				type:'TextField',
				filters:{pfiltro:'tecc.parametros_det',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'descripcion',
				qtip:'Descripción del calculo de la columna, se mostrará como un qtip',
				fieldLabel: 'Descripcion',
				allowBlank: true,
				anchor: '80%',
				gwidth: 300,
				maxLength:400
			},
				type:'TextField',
				filters:{pfiltro:'tecc.descripcion',type:'string'},
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
				filters:{pfiltro:'tecc.estado_reg',type:'string'},
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
				filters:{pfiltro:'tecc.fecha_reg',type:'date'},
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
				filters:{pfiltro:'tecc.fecha_mod',type:'date'},
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
				filters:{pfiltro:'tecc.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'tecc.usuario_ai',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Columnas del Tipo de Estado de Cuentas',
	ActSave:'../../sis_contabilidad/control/TipoEstadoColumna/insertarTipoEstadoColumna',
	ActDel:'../../sis_contabilidad/control/TipoEstadoColumna/eliminarTipoEstadoColumna',
	ActList:'../../sis_contabilidad/control/TipoEstadoColumna/listarTipoEstadoColumna',
	id_store:'id_tipo_estado_columna',
	fields: [
		{name:'id_tipo_estado_columna', type: 'numeric'},
		{name:'codigo', type: 'string'},
		{name:'link_int_det', type: 'string'},
		{name:'origen', type: 'string'},
		{name:'id_config_subtipo_cuenta', type: 'numeric'},
		{name:'nombre', type: 'string'},
		{name:'nombre_funcion', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		'id_tipo_estado_cuenta','prioridad',
		'desc_csc', 'descripcion','nombre_clase','parametros_det'
		
	],
	sortInfo:{
		field: 'id_tipo_estado_columna',
		direction: 'ASC'
	},
	
	onReloadPage: function(m){
       
        this.maestro=m;      
        this.store.baseParams={id_tipo_estado_cuenta:this.maestro.id_tipo_estado_cuenta};
        this.load({params:{start:0, limit:50}})       
       
                
   },
   
   loadValoresIniciales : function() {
		Phx.vista.TipoEstadoColumna.superclass.loadValoresIniciales.call(this);
		this.getComponente('id_tipo_estado_cuenta').setValue(this.maestro.id_tipo_estado_cuenta);
		
	},
	
	iniciarEventos:function(){
		 this.Cmp.origen.on('beforeselect',function(combo,record,index){
			if(record.data.field1 =='contabilidad'){
					this.mostrarComponente(this.Cmp.id_config_subtipo_cuenta);
					this.ocultarComponente(this.Cmp.link_int_det);
					this.ocultarComponente(this.Cmp.nombre_funcion);
					this.ocultarComponente(this.Cmp.nombre_clase);
					this.ocultarComponente(this.Cmp.parametros_det);
					
			} else{
					this.ocultarComponente(this.Cmp.id_config_subtipo_cuenta);
					this.mostrarComponente(this.Cmp.link_int_det);
					this.mostrarComponente(this.Cmp.nombre_funcion);
					this.mostrarComponente(this.Cmp.nombre_clase);
					this.mostrarComponente(this.Cmp.parametros_det);
			} 
				
				
				
			},this);
		
	},
	onButtonEdit:function(n){
		Phx.vista.TipoEstadoColumna.superclass.onButtonEdit.call(this);
		if(this.Cmp.origen.getValue() =='contabilidad'){
					this.mostrarComponente(this.Cmp.id_config_subtipo_cuenta);
					this.ocultarComponente(this.Cmp.link_int_det);
					this.ocultarComponente(this.Cmp.nombre_funcion);
					this.ocultarComponente(this.Cmp.nombre_clase);
					this.ocultarComponente(this.Cmp.parametros_det);
		} else{
					this.ocultarComponente(this.Cmp.id_config_subtipo_cuenta);
					this.mostrarComponente(this.Cmp.link_int_det);
					this.mostrarComponente(this.Cmp.nombre_funcion);
					this.mostrarComponente(this.Cmp.nombre_clase);
					this.mostrarComponente(this.Cmp.parametros_det);
		}    
	},
	
	onButtonNew:function(n){
    	this.ocultarComponente(this.Cmp.link_int_det);
		this.ocultarComponente(this.Cmp.nombre_funcion);
		this.ocultarComponente(this.Cmp.id_config_subtipo_cuenta);
		this.ocultarComponente(this.Cmp.nombre_clase);
		this.ocultarComponente(this.Cmp.parametros_det);
		
    	
		Phx.vista.TipoEstadoColumna.superclass.onButtonNew.call(this);
	      
    },
	
	bdel:true,
	bsave:true
});
</script>		
		