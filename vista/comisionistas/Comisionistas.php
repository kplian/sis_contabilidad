<?php
/**
*@package pXP
*@file gen-Comisionistas.php
*@author  (admin)
*@date 31-05-2017 20:17:02
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Comisionistas=Ext.extend(Phx.gridInterfaz,{
    fheight: '65%',
    fwidth: '80%',

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
                        title: 'Datos del Contrato',
                        items: [],
                        id_grupo: 0,
                        flex:1,
                        autoHeight : true,
                        margins:'2 2 2 2'
                    },

                    {
                        xtype: 'fieldset',
                        columnWidth: 0.5,
                        title: 'Detalle del producto ',
                        items: [],
                        margins:'2 10 2 2',
                        id_grupo:1,
                        autoHeight : true,
                        flex:1
                    },
                    {
                        xtype: 'fieldset',
                        columnWidth: 0.5,
                        title: 'Detalle de la Entrega',
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
		Phx.vista.Comisionistas.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}});
        //this.addButton('exportar',{argument: {imprimir: 'exportar'},text:'<i class="fa fa-file-text-o fa-2x"></i> Generar TXT - SIN',disabled:true,handler:this.generar_txt});
        //this.addButton('Importar',{argument: {imprimir: 'Importar'},text:'<i class="fa fa-file-text-o fa-2x"></i> Importar TXT',disabled:true,handler:this.importar_txt});

    },
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_comisionista'
			},
			type:'Field',
			form:true 
		},
        {
            config:{
                name: 'revisado',
                fieldLabel: 'Revisado',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:3,
                renderer: function (value){
                    //check or un check row
                    var checked = '',
                        momento = 'no';
                    if(value == 'si'){
                        checked = 'checked';
                    }
                    return  String.format('<div style="vertical-align:middle;text-align:center;"><input style="height:37px;width:37px;" type="checkbox"  {0}></div>',checked);

                }
            },
            type: 'TextField',
            filters: { pfiltro:'cms.revisado',type:'string'},
            id_grupo: 0,
            grid: true,
            form: false
        },

        {
            config:{
                name: 'nit',
                fieldLabel: 'NIT del Comisionista',
                allowBlank: false,
                anchor: '80%',
                gwidth: 200,
                maxLength:255
            },
            type:'TextField',
            filters:{pfiltro:'cms.nit',type:'string'},
            id_grupo:0,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'razon_social',
                fieldLabel: 'Nombre/Razon Social',
                allowBlank: false,
                anchor: '80%',
                gwidth: 200,
                maxLength:1000
            },
            type:'TextField',
            filters:{pfiltro:'cms.razon_social',type:'string'},
            id_grupo:0,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'nro_contrato',
                fieldLabel: 'Número de Contrato',
                allowBlank: false,
                anchor: '80%',
                gwidth: 150,
                maxLength:500
            },
            type:'TextField',
            filters:{pfiltro:'cms.nro_contrato',type:'string'},
            id_grupo:0,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'fecha_ini',
                fieldLabel: 'Fecha Inicio Contrato',
                allowBlank: false,
                anchor: '80%',
                gwidth: 150,
                format: 'd/m/Y',
                renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type:'DateField',
            filters:{pfiltro:'cms.fecha_ini',type:'date'},
            id_grupo:0,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'fecha_fin',
                fieldLabel: 'Fecha Fin Contrato',
                allowBlank: false,
                anchor: '80%',
                gwidth: 150,
                format: 'd/m/Y',
                renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type:'DateField',
            filters:{pfiltro:'cms.fecha_fin',type:'date'},
            id_grupo:0,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'cantidad_producto_entregado',
                fieldLabel: 'Cantidad de producto entregado',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:4
            },
            type:'NumberField',
            filters:{pfiltro:'cms.cantidad',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'codigo',
                fieldLabel: 'Código del producto',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:255
            },
            type:'TextField',
            filters:{pfiltro:'cms.codigo',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'descripcion',
                fieldLabel: 'Descripción de producto entregado',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:1000
            },
            type:'TextField',
            filters:{pfiltro:'cms.descripcion',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
		{
			config:{
				name: 'capacidad_envace',
				fieldLabel: 'Capacidad del envase',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:20
			},
				type:'TextField',
				filters:{pfiltro:'cms.capacidad_envace',type:'string'},
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
            filters:{pfiltro:'cms.precio_unitario',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'nro_documento',
                fieldLabel: 'Número del documento de entrega',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:500
            },
            type:'NumberField',
            filters:{pfiltro:'cms.nro_documento',type:'numeric'},
            id_grupo:2,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'documento_entrega',
                fieldLabel: 'Documento de entrega',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:255
            },
            type:'TextField',
            filters:{pfiltro:'cms.documento_entrega',type:'string'},
            id_grupo:2,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'monto_total',
                fieldLabel: 'Monto total de la comisión del producto',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:1310720
            },
            type:'NumberField',
            filters:{pfiltro:'cms.monto_total',type:'numeric'},
            id_grupo:2,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'porcentaje',
                fieldLabel: 'Porcentaje Comisión',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:1310721
            },
            type:'NumberField',
            filters:{pfiltro:'cms.porcentaje',type:'numeric'},
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
				filters:{pfiltro:'cms.estado_reg',type:'string'},
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
				name: 'usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
				type:'TextField',
				filters:{pfiltro:'cms.usuario_ai',type:'string'},
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
				filters:{pfiltro:'cms.fecha_reg',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'cms.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'cms.fecha_mod',type:'date'},
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
	title:'Comisionistas ',
	ActSave:'../../sis_contabilidad/control/Comisionistas/insertarComisionistas',
	ActDel:'../../sis_contabilidad/control/Comisionistas/eliminarComisionistas',
	ActList:'../../sis_contabilidad/control/Comisionistas/listarComisionistas',
	id_store:'id_comisionista',
	fields: [
		{name:'id_comisionista', type: 'numeric'},
		{name:'capacidad_envace', type: 'string'},
		{name:'nit', type: 'string'},
		{name:'codigo', type: 'string'},
		{name:'cantidad_producto_entregado', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'porcentaje', type: 'numeric'},
		{name:'descripcion', type: 'string'},
		{name:'documento_entrega', type: 'string'},
		{name:'monto_total', type: 'numeric'},
		{name:'nro_documento', type: 'numeric'},
		{name:'razon_social', type: 'string'},
		{name:'fecha_fin', type: 'date',dateFormat:'Y-m-d'},
		{name:'fecha_ini', type: 'date',dateFormat:'Y-m-d'},
		{name:'precio_unitario', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
        {name:'nro_contrato', type: 'string'},
        {name:'revisado', type: 'string'}
		
	],
	sortInfo:{
		field: 'id_comisionista',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,

    preparaMenu:function(tb){
        Phx.vista.Comisionistas.superclass.preparaMenu.call(this,tb);
        var data = this.getSelectedData();
        if(data['revisado'] ==  'no' ){
            this.getBoton('edit').enable();
            this.getBoton('del').enable();

        }
        else{
            this.getBoton('edit').disable();
            this.getBoton('del').disable();
        }

    },

    liberaMenu:function(tb){
        Phx.vista.Comisionistas.superclass.liberaMenu.call(this,tb);

    },

    oncellclick : function(grid, rowIndex, columnIndex, e) {

        var record = this.store.getAt(rowIndex),
            fieldName = grid.getColumnModel().getDataIndex(columnIndex); // Get field name
        if(fieldName == 'revisado') {
            this.cambiarRevision(record);
        }
    },
    cambiarRevision: function(record){
        Phx.CP.loadingShow();
        var d = record.data;
        console.log('llega '+d);
        Ext.Ajax.request({
            url:'../../sis_contabilidad/control/Comisionistas/cambiarRevision',
            params:{ id_comisionista: d.id_comisionista,revisado:d.revisado},
            success: this.successRevision,
            failure: this.conexionFailure,
            timeout: this.timeout,
            scope: this
        });
        this.reload();
    },
    successRevision: function(resp){
        Phx.CP.loadingHide();
        var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));

    }


    /*importar_txt:function(){


        var misdatos = new Object();
        misdatos.id_periodo = this.cmbPeriodo.getValue();
        misdatos.tipo = this.tipoBan;

        Phx.CP.loadWindows('../../../sis_contabilidad/vista/banca_compra_venta/subirArchivo.php',
            'Subir',
            {
                modal:true,
                width:450,
                height:150
            },misdatos,this.idContenedor,'SubirArchivo');

    }*/

	}
)
</script>
		
		