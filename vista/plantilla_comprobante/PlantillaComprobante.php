<?php
/**
*@package pXP
*@file gen-PlantillaComprobante.php
*@author  (admin)
*@date 10-06-2013 14:40:00
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.PlantillaComprobante=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.PlantillaComprobante.superclass.constructor.call(this,config);
		
		this.addButton('btnWizard',
            {
                text: 'Exportar Plantilla',
                iconCls: 'bchecklist',
                disabled: false,
                handler: this.expProceso,
                tooltip: '<b>Exportar</b><br/>Exporta a archivo SQL la plantilla'
            }
        );
		
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}});
	},
	
	expProceso : function(resp){
			var data=this.sm.getSelected().data;
			Phx.CP.loadingShow();
			Ext.Ajax.request({
				url: '../../sis_contabilidad/control/PlantillaComprobante/exportarDatos',
				params: { 'id_plantilla_comprobante' : data.id_plantilla_comprobante },
				success: this.successExport,
				failure: this.conexionFailure,
				timeout: this.timeout,
				scope: this
			});
			
	},
	
	tam_pag:50,
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_plantilla_comprobante'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'codigo',
				fieldLabel: 'Codigo',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			},
			type:'TextField',
			filters:{pfiltro:'cmpb.codigo',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		
		{
			config:{
				name: 'desc_plantilla',
				fieldLabel: 'Descripcion',
				qtip:'Describe la utilidad de esta plantilla de comprobante, (no influye en el contenido del comprobante)',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:200
			},
			type:'TextArea',
			filters:{pfiltro:'cmpb.desc_plantilla',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		
		{
           config:{
                name:'momento_presupuestario',
                fieldLabel: 'Momento',
                allowBlank: false,
                anchor: '80%',
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store:['contable','presupuestario']
           },
           type:'ComboBox',
           filters:{pfiltro:'cmpb.momento_presupuestario',type:'string'},
           id_grupo:0,
           grid:true,
           form:true
          },
         {
           config:{
                name:'momento_comprometido',
                fieldLabel: 'Compromete',
                qtip:'Compromete presupuesto',
                allowBlank: false,
                anchor: '80%',
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store:['si','no']
           },
           type:'ComboBox',
           filters:{pfiltro:'cmpb.momento_comprometido',type:'string'},
           id_grupo:0,
           grid:true,
           form:true
          } ,
         {
           config:{
                name:'momento_ejecutado',
                fieldLabel: 'Ejecuta',
                qtip:'Ejecuta presupuesto',
                allowBlank: false,
                anchor: '80%',
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store:['si','no']
           },
           type:'ComboBox',
           filters:{pfiltro:'cmpb.momento_ejecutado',type:'string'},
           id_grupo:0,
           grid:true,
           form:true
          },
         {
           config:{
                name:'momento_pagado',
                fieldLabel: 'Paga',
                allowBlank: false,
                qtip:'Paga presupuesto',
                anchor: '80%',
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store:['si','no']
           },
           type:'ComboBox',
           filters:{pfiltro:'cmpb.momento_pagado',type:'string'},
           id_grupo:0,
           grid:true,
           form:true
          }, 
		{
			config:{
				name: 'clase_comprobante',
				fieldLabel: 'Clase Comprobante',
				allowBlank: true,
				qtip:'... DIARIO, PAGO',
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			},
			type:'TextField',
			filters:{pfiltro:'cmpb.clase_comprobante',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'tabla_origen',
				fieldLabel: 'Tabla Origen',
				qtip:'Nombre de la tabla o vista de donde se sacaran los datos',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			},
			type:'TextField',
			filters:{pfiltro:'cmpb.tabla_origen',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'idtabla',
				fieldLabel: 'Id Tabla',
				qtip:'Nombre del campo llave de la tabla o vista  definida en (Tabla Origen)',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			},
			type:'TextField',
			filters:{pfiltro:'cmpb.id_tabla',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'campo_subsistema',
				qtip:'Identifica el subsistema que origina el comprobante',
				fieldLabel: 'Campo Subsistema',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:200
			},
			type:'TextArea',
			filters:{pfiltro:'cmpb.campo_subsistema',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'campo_depto',
				fieldLabel: 'Campo Depto',
				qtip:'Identifica el Departamento contable',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:200
			},
			type:'TextArea',
			filters:{pfiltro:'cmpb.campo_depto',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
        {
            config:{
                name: 'campo_nro_tramite',
                fieldLabel: 'Nro Tramite',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:200
            },
            type:'TextArea',
            filters:{pfiltro:'cmpb.campo_nro_tramite',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
		{
			config:{
				name: 'campo_acreedor',
				fieldLabel: 'Campo Acreedor',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:200
			},
			type:'TextArea',
			filters:{pfiltro:'cmpb.campo_acreedor',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'campo_descripcion',
				fieldLabel: 'Campo Descripcion',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:200
			},
			type:'TextArea',
			filters:{pfiltro:'cmpb.campo_descripcion',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'campo_fk_comprobante',
				fieldLabel: 'Campo fk Comprobante',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:200
			},
			type:'TextArea',
			filters:{pfiltro:'cmpb.campo_fk_comprobante',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'campo_cbte_relacionado',
				qtip: 'Solo para relaciones  ejm:  identificar devegando del pago, ajustes, reversiones, etc',
				fieldLabel: 'Campo ID Cbte relacionado',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:200
			},
			type:'TextArea',
			filters:{pfiltro:'cmpb.campo_cbte_relacionado',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		}, 
		{
			config : {
				name : 'codigo_tipo_relacion',
				fieldLabel : 'Tipo Rel.',
				qtip : 'Tipo de relacion entre comprobantes (ID cbte relacionado)',
				allowBlank : true,
				emptyText : 'Elija una opción...',
				store : new Ext.data.JsonStore({
					url : '../../sis_contabilidad/control/TipoRelacionComprobante/listarTipoRelacionComprobante',
					id : 'id_tipo_relacion_comprobante',
					root : 'datos',
					sortInfo : {
						field : 'id_tipo_relacion_comprobante',
						direction : 'ASC'
					},
					totalProperty : 'total',
					fields : ['id_tipo_relacion_comprobante', 'codigo', 'nombre'],
					remoteSort : true,
					baseParams : {
						par_filtro : 'tiprelco.nombre#tiprelco.codigo'
					}
				}),
				valueField : 'codigo',
				displayField : 'codigo',
				gdisplayField : 'codigo_tipo_relacion',
				hiddenName : 'codigo',
				typeAhead : false,
				triggerAction : 'all',
				lazyRender : true,
				mode : 'remote',
				pageSize : 15,
				queryDelay : 1000,
				width : 250,
				anchor : '100%',
				gwidth : 150,
				minChars : 2
			},
			type : 'ComboBox',
			id_grupo : 1,
			filters : {
				pfiltro : 'cmpb.codigo_tipo_relacion',
				type : 'string'
			},
			grid : true,
			form : true
		},
		
		{
			config:{
				name: 'campo_moneda',
				fieldLabel: 'Campo Moneda',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:200
			},
			type:'TextArea',
			filters:{pfiltro:'cmpb.campo_moneda',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'campo_fecha',
				fieldLabel: 'Campo Fecha',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:200
			},
			type:'TextArea',
			filters:{pfiltro:'cmpb.campo_fecha',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
        {
            config:{
                name: 'campo_gestion_relacion',
                fieldLabel: 'Gestion Rel Contable',
                qtip:'Para obtener cuentas contables es importante saber de gestion se obtendran',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:200
            },
            type:'TextArea',
            filters:{pfiltro:'cmpb.campo_gestion_relacion',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'otros_campos',
                qtip:'Define otros campos que se guardan temporalmente para ser usados depues en la plantilla de transacciones',
                fieldLabel: 'Otros Campos',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:800
            },
            type:'TextArea',
            filters:{pfiltro:'cmpb.otros_campos',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },				
		{
			config:{
				name: 'funcion_comprobante_validado',
				qtip:'funcion que se ejecuta una vez que se valida el comprobante',
				fieldLabel: 'Funcion Cbte Validado',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextArea',
			filters:{pfiltro:'cmpb.funcion_comprobante_validado',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},				
		{
			config:{
				name: 'funcion_comprobante_eliminado',
				fieldLabel: 'Funcion Cbte Eliminado',
				qtip:'Funcion que se ejecuta al eliminar el comprobante',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextArea',
			filters:{pfiltro:'cmpb.funcion_comprobante_eliminado',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},				
		{
			config:{
				name: 'funcion_comprobante_editado',
				fieldLabel: 'Funcion Cbte Editado',
				qtip:'Funcion que se ejecuta al validar un cbte que ha sido editado',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextArea',
			filters:{pfiltro:'cmpb.funcion_comprobante_editado',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'funcion_comprobante_prevalidado',
				fieldLabel: 'Funcion Cbte Prevalidado',
				qtip:'Esta funcion se ejecuta previamente a la validacion del comprobante,  puede ser util para revertir presupuestos previamente validados',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextArea',
			filters:{pfiltro:'cmpb.funcion_comprobante_prevalidado',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'funcion_comprobante_validado_eliminado',
				fieldLabel: 'Funcion Cbte Validado Eliminado',
				qtip:'Esta funcion corre al apretar el boton eliminar de un comprobante generado que ya a sido validado',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextArea',
			filters:{pfiltro:'cmpb.funcion_comprobante_validado_eliminado',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		
		{
			config:{
				name: 'campo_id_cuenta_bancaria',
				fieldLabel: 'Campo Cuenta Bancaria',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:200
			},
			type:'TextArea',
			filters:{pfiltro:'cmpb.campo_id_cuenta_bancaria',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'campo_id_cuenta_bancaria_mov',
				fieldLabel: 'Campo Movimiento Cuenta Bancaria',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:200
			},
			type:'TextArea',
			filters:{pfiltro:'cmpb.campo_id_cuenta_bancaria_mov',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'campo_nro_cheque',
				fieldLabel: 'Campo Número Cheque',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:200
			},
			type:'TextArea',
			filters:{pfiltro:'cmpb.campo_nro_cheque',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
        {
            config:{
                name: 'campo_nro_cuenta_bancaria_trans',
                fieldLabel: 'Campo Cuen Banc Trans',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:200
            },
            type:'TextArea',
            filters:{pfiltro:'cmpb.campo_nro_cuenta_bancaria_trans',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config: {
                name: 'campo_tipo_cambio',
                qtip: 'define de donde obtendra el tipo de cambio convenido',
                fieldLabel: 'Tipo de cambio convenido',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:200
            },
            type:'TextArea',
            filters:{pfiltro:'cmpb.campo_tipo_cambio',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config: {
                name: 'campo_depto_libro',
                qtip: 'Define de donde recuperamos el identificador del depto de libro de bancos',
                fieldLabel: 'Depto Libro de Bancos',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:200
            },
            type:'TextArea',
            filters:{pfiltro:'cmpb.campo_depto_libro',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
		{
			config:{
				name: 'campo_fecha_costo_ini',
				fieldLabel: 'Fecha Costo Ini',
				qtip: 'identifca el origen de fecha inicial para el costo',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:200
			},
			type:'TextArea',
			filters:{pfiltro:'cmpb.campo_fecha_costo_ini',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'campo_fecha_costo_fin',
				fieldLabel: 'Fecha Costo Fin',
				qtip: 'identifca el origen de fecha final para el costo',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:200
			},
			type:'TextArea',
			filters:{pfiltro:'cmpb.campo_fecha_costo_fin',type:'string'},
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
			filters:{pfiltro:'cmpb.estado_reg',type:'string'},
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
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
			type:'DateField',
			filters:{pfiltro:'cmpb.fecha_reg',type:'date'},
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
			filters:{pfiltro:'cmpb.fecha_mod',type:'date'},
			id_grupo:1,
			grid:true,
			form:false
		}
	],
	
	title:'Comprobante',
	ActSave:'../../sis_contabilidad/control/PlantillaComprobante/insertarPlantillaComprobante',
	ActDel:'../../sis_contabilidad/control/PlantillaComprobante/eliminarPlantillaComprobante',
	ActList:'../../sis_contabilidad/control/PlantillaComprobante/listarPlantillaComprobante',
	id_store:'id_plantilla_comprobante',
	fields: [
		{name:'id_plantilla_comprobante', type: 'numeric'},
		{name:'codigo', type:'string'},
		{name:'funcion_comprobante_eliminado', type: 'string'},
		{name:'idtabla', type: 'string'},
		{name:'campo_subsistema', type: 'string'},
		{name:'campo_descripcion', type: 'string'},
		{name:'funcion_comprobante_validado', type: 'string'},
		{name:'campo_fecha', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'campo_acreedor', type: 'string'},
		{name:'campo_depto', type: 'string'},
		{name:'momento_presupuestario', type: 'string'},
		{name:'campo_fk_comprobante', type: 'string'},
		{name:'tabla_origen', type: 'string'},
		{name:'clase_comprobante', type: 'string'},
		{name:'campo_moneda', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'campo_gestion_relacion', type: 'string'},
		{name:'otros_campos', type: 'string'},
		{name:'momento_comprometido', type: 'string'},
		{name:'momento_ejecutado', type: 'string'},
		{name:'momento_pagado', type: 'string'},
		{name:'campo_id_cuenta_bancaria', type: 'string'},
		{name:'campo_id_cuenta_bancaria_mov', type: 'string'},
		{name:'campo_nro_cheque', type: 'string'},
		'campo_nro_cuenta_bancaria_trans',
		'campo_nro_tramite','campo_tipo_cambio','campo_depto_libro',
	    'campo_fecha_costo_ini',
	    'campo_fecha_costo_fin',
	    'funcion_comprobante_editado','funcion_comprobante_prevalidado',
	    'funcion_comprobante_validado_eliminado','desc_plantilla',
	    'campo_cbte_relacionado','codigo_tipo_relacion'
        
		
	],
	sortInfo:{
		field: 'id_plantilla_comprobante',
		direction: 'ASC'
	},
	
	south : {
			url : '../../../sis_contabilidad/vista/detalle_plantilla_comprobante/DetallePlantillaComprobante.php',
			title : 'Detalle de Comprobante',
			height : '50%',
			cls : 'DetallePlantillaComprobante'
		},
		
	bdel:true,
	bsave:true
	}
)
</script>
		
		