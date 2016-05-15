<?php
/**
*@package pXP
*@file gen-TipoDocCompraVenta.php
*@author  (admin)
*@date 22-02-2016 16:19:51
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.TipoDocCompraVenta=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.TipoDocCompraVenta.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_tipo_doc_compra_venta'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'codigo',
				fieldLabel: 'Código',
				qtip: 'El código con el que se transcribe al reporte de LCV',
				allowBlank: false,
				anchor: '80%',
				gwidth: 50,
				maxLength:5
			},
				type:'TextField',
				filters:{pfiltro:'tdoc.codigo',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		 {
            config:{
                name: 'tipo',
                fieldLabel: 'Tipo',
                qtip: 'Se usa para compras o para ventas',
                allowBlank: false,
                anchor: '40%',
                gwidth: 80,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'local',
                store: ['compra','venta']
            },
            type:'ComboBox',
            id_grupo:1,
            filters:{   pfiltro: 'tdoc.tipo',
                        type: 'list',
                        options: ['compra','venta']  
                    },
            grid: true,
            egrid: true,
            form: true
       },
		{
			config:{
				name: 'nombre',
				fieldLabel: 'Nombre',
				allowBlank: true,
				anchor: '80%',
				gwidth: 200,
				maxLength:300
			},
				type:'TextField',
				filters:{pfiltro:'tdoc.nombre',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'obs',
				fieldLabel: 'Descripción',
				allowBlank: true,
				anchor: '80%',
				gwidth: 300,
				maxLength:1000
			},
				type:'TextArea',
				filters:{pfiltro:'tdoc.obs',type:'string'},
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
				filters:{pfiltro:'tdoc.estado_reg',type:'string'},
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
				filters:{pfiltro:'tdoc.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'tdoc.fecha_reg',type:'date'},
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
				filters:{pfiltro:'tdoc.usuario_ai',type:'string'},
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
				filters:{pfiltro:'tdoc.fecha_mod',type:'date'},
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
	title:'Tipo Doc',
	ActSave:'../../sis_contabilidad/control/TipoDocCompraVenta/insertarTipoDocCompraVenta',
	ActDel:'../../sis_contabilidad/control/TipoDocCompraVenta/eliminarTipoDocCompraVenta',
	ActList:'../../sis_contabilidad/control/TipoDocCompraVenta/listarTipoDocCompraVenta',
	id_store:'id_tipo_doc_compra_venta',
	fields: [
		{name:'id_tipo_doc_compra_venta', type: 'numeric'},
		{name:'codigo', type: 'string'},
		{name:'tipo', type: 'string'},
		{name:'obs', type: 'string'},
		{name:'nombre', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
	],
	sortInfo:{
		field: 'id_tipo_doc_compra_venta',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true
	}
)
</script>
		
		