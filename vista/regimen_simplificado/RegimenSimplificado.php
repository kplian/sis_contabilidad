<?php
/**
*@package pXP
*@file gen-RegimenSimplificado.php
*@author  (admin)
*@date 31-05-2017 20:17:05
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.RegimenSimplificado=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
        this.Grupos = [
            {
                layout: 'column',
                border: false,
                autoHeight : true,
                defaults: {
                    border: false,
                    bodyStyle: 'padding:4px'
                },
                items: [
                    {
                        xtype: 'fieldset',
                        columnWidth: 0.5,
                        defaults: {
                            anchor: '-20' // leave room for error icon
                        },
                        title: 'Datos Cliente',
                        items: [],
                        id_grupo: 0,
                        flex:1,
                        autoHeight : true,
                        margins:'2 2 2 2'
                    },

                    {
                        xtype: 'fieldset',
                        columnWidth: 0.5,
                        title: 'Detalle del Producto ',
                        items: [],
                        margins:'2 10 2 2',
                        id_grupo:1,
                        autoHeight : true,
                        flex:1
                    },
                    {
                        xtype: 'fieldset',
                        columnWidth: 0.5,
                        title: 'Detalle de bonificado',
                        items: [],
                        margins:'2 10 2 2',
                        id_grupo:2,
                        autoHeight : true,
                        flex:1
                    }
                ]
            }];
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.RegimenSimplificado.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_simplificado'
			},
			type:'Field',
			form:true 
		},
        {
            config:{
                name: 'codigo_cliente',
                fieldLabel: 'Código Cliente/CI.',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:250
            },
            type:'TextField',
            filters:{pfiltro:'rso.codigo_cliente',type:'string'},
            id_grupo:0,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'nit',
                fieldLabel: 'NIT del Cliente',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:255
            },
            type:'TextField',
            filters:{pfiltro:'rso.nit',type:'string'},
            id_grupo:0,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'nombre',
                fieldLabel: 'Nombre Cliente',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:1000
            },
            type:'TextField',
            filters:{pfiltro:'rso.nombre',type:'string'},
            id_grupo:0,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'cantidad_producto',
                fieldLabel: 'Cantidad producto vendido',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:4
            },
            type:'NumberField',
            filters:{pfiltro:'rso.cantidad_producto',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'codigo_producto',
                fieldLabel: 'Código del producto',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:255
            },
            type:'TextField',
            filters:{pfiltro:'rso.codigo_producto',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'descripcion',
                fieldLabel: 'Descripción producto',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:1000
            },
            type:'TextField',
            filters:{pfiltro:'rso.descripcion',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
		{
			config:{
				name: 'precio_unitario',
				fieldLabel: 'Precio unitario',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1310721
			},
				type:'NumberField',
				filters:{pfiltro:'rso.precio_unitario',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
        {
            config:{
                name: 'descuento',
                fieldLabel: 'Descuento en ventas',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:1310721
            },
            type:'NumberField',
            filters:{pfiltro:'rso.descuento',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'cantidad_bonificacion',
                fieldLabel: 'Cantidad producto bonificado',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:4
            },
            type:'NumberField',
            filters:{pfiltro:'rso.cantidad_bonificacion',type:'numeric'},
            id_grupo:2,
            grid:true,
            form:true
        },
		{
			config:{
				name: 'cantidad_bonificado',
				fieldLabel: 'Cantidad producto bonificado',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:20
			},
				type:'TextField',
				filters:{pfiltro:'rso.cantidad_bonificado',type:'string'},
				id_grupo:2,
				grid:true,
				form:true
		},
        {
            config:{
                name: 'descripcion_bonificado',
                fieldLabel: 'Descripción producto bonificado',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:1000
            },
            type:'TextField',
            filters:{pfiltro:'rso.descripcion_bonificado',type:'string'},
            id_grupo:2,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'importe_bonificado',
                fieldLabel: 'Importe por bonificación',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:1310721
            },
            type:'NumberField',
            filters:{pfiltro:'rso.importe_bonificado',type:'numeric'},
            id_grupo:2,
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
				filters:{pfiltro:'rso.estado_reg',type:'string'},
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
				filters:{pfiltro:'rso.fecha_reg',type:'date'},
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
				filters:{pfiltro:'rso.usuario_ai',type:'string'},
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
				filters:{pfiltro:'rso.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'rso.fecha_mod',type:'date'},
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
	title:'Regimen Simplificado ',
	ActSave:'../../sis_contabilidad/control/RegimenSimplificado/insertarRegimenSimplificado',
	ActDel:'../../sis_contabilidad/control/RegimenSimplificado/eliminarRegimenSimplificado',
	ActList:'../../sis_contabilidad/control/RegimenSimplificado/listarRegimenSimplificado',
	id_store:'id_simplificado',
	fields: [
		{name:'id_simplificado', type: 'numeric'},
		{name:'precio_unitario', type: 'numeric'},
		{name:'descripcion', type: 'string'},
		{name:'codigo_cliente', type: 'string'},
		{name:'cantidad_bonificado', type: 'string'},
		{name:'codigo_producto', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'descripcion_bonificado', type: 'string'},
		{name:'importe_bonificado', type: 'numeric'},
		{name:'nombre', type: 'string'},
		{name:'descuento', type: 'numeric'},
		{name:'cantidad_bonificacion', type: 'numeric'},
		{name:'cantidad_producto', type: 'numeric'},
		{name:'nit', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
	],
	sortInfo:{
		field: 'id_simplificado',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
    fheight: '55%',
    fwidth: '75%'
	}
)
</script>
		
		