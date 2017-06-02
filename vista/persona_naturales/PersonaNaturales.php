<?php
/**
*@package pXP
*@file gen-PersonaNaturales.php
*@author  (admin)
*@date 31-05-2017 20:17:08
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.PersonaNaturales=Ext.extend(Phx.gridInterfaz,{

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
                        columnWidth: 0.90,
                        defaults: {
                            anchor: '-5' // leave room for error icon
                        },
                        title: 'Datos Personas Naturales',
                        items: [],
                        id_grupo: 1,
                        flex:1,
                        autoHeight : true,
                        margins:'2 2 2 2'
                    }
                ]
            }];
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.PersonaNaturales.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_persona_natural'
			},
			type:'Field',
			form:true 
		},
        {
            config:{
                name: 'codigo_cliente',
                fieldLabel: 'Código Cliente',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:255
            },
            type:'TextField',
            filters:{pfiltro:'pns.codigo_cliente',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'nro_identificacion',
                fieldLabel: 'CI./NIT',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:4
            },
            type:'NumberField',
            filters:{pfiltro:'pns.nro_identificacion',type:'numeric'},
            id_grupo:1,
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
                maxLength:500
            },
            type:'TextField',
            filters:{pfiltro:'pns.nombre',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'cantidad_producto',
                fieldLabel: 'Cantidad producto vendido',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:4
            },
            type:'NumberField',
            filters:{pfiltro:'pns.cantidad_producto',type:'numeric'},
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
            filters:{pfiltro:'pns.codigo_producto',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'descripcion',
                fieldLabel: 'Descripción producto',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:1000
            },
            type:'TextField',
            filters:{pfiltro:'pns.descripcion',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'capacidad',
                fieldLabel: 'Capacidad del envase',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:255
            },
            type:'TextField',
            filters:{pfiltro:'pns.codigo_producto',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },

		{
			config:{
				name: 'precio_unitario',
				fieldLabel: 'Precio unitario',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:1310721
			},
				type:'NumberField',
				filters:{pfiltro:'pns.precio_unitario',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
        {
            config:{
                name: 'importe_total',
                fieldLabel: 'Importe total vendido',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:1310721
            },
            type:'NumberField',
            filters:{pfiltro:'pns.importe_total',type:'numeric'},
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
				filters:{pfiltro:'pns.estado_reg',type:'string'},
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
				filters:{pfiltro:'pns.fecha_reg',type:'date'},
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
				filters:{pfiltro:'pns.usuario_ai',type:'string'},
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
				filters:{pfiltro:'pns.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'pns.fecha_mod',type:'date'},
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
	title:'Persona Naturales',
	ActSave:'../../sis_contabilidad/control/PersonaNaturales/insertarPersonaNaturales',
	ActDel:'../../sis_contabilidad/control/PersonaNaturales/eliminarPersonaNaturales',
	ActList:'../../sis_contabilidad/control/PersonaNaturales/listarPersonaNaturales',
	id_store:'id_persona_natural',
	fields: [
		{name:'id_persona_natural', type: 'numeric'},
		{name:'precio_unitario', type: 'numeric'},
		{name:'descripcion', type: 'string'},
		{name:'codigo_cliente', type: 'string'},
		{name:'capacidad', type: 'string'},
		{name:'codigo_producto', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'nombre', type: 'string'},
		{name:'importe_total', type: 'numeric'},
		{name:'nro_identificacion', type: 'numeric'},
		{name:'cantidad_producto', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'}
		
	],
	sortInfo:{
		field: 'id_persona_natural',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
    fheight: '65%',
    fwidth: '55%'
	}
)
</script>
		
		