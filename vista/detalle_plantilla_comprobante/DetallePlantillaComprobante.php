<?php
/**
*@package pXP
*@file gen-DetallePlantillaComprobante.php
*@author  (admin)
*@date 10-06-2013 14:51:03
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.DetallePlantillaComprobante=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.DetallePlantillaComprobante.superclass.constructor.call(this,config);
		this.init();		
		this.grid.getTopToolbar().disable();
		this.grid.getBottomToolbar().disable();
	},
	tam_pag:50,
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_detalle_plantilla_comprobante'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'id_plantilla_comprobante',
				inputType:'hidden'
			},
			type:'Field',
			form:true
		},
		{
			config:{
				name: 'codigo',
				fieldLabel: 'Código',
				qtip:'Código único para indetificar la transacción',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextField',
			filters:{pfiltro:'cmpbdet.codigo',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
        {
            config:{
                name: 'descripcion',
                fieldLabel: 'Desc. Trans.',
                qtip:'Descripciond en la transaccion se utiliza para mostrar mejores mensajes de error',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:100
            },
            type:'TextArea',
            filters:{pfiltro:'cmpbdet.descripcion',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
		
		{
           config:{
            	name:'debe_haber',
            	fieldLabel: 'Debe Haber',
            	qtip:'La transaccion se mueve al debe o al haber',
                allowBlank: false,
                anchor: '80%',
        		typeAhead: true,
            	triggerAction: 'all',
            	lazyRender:true,
            	mode: 'local',
            	store:['debe','haber']
           },
           type:'ComboBox',
           id_grupo:0,
           grid:true,
           form:true
          },
          {
           config:{
                name:'aplicar_documento',
                fieldLabel: 'Aplicar Documento',
                qtip:'Si la transaccion necesita ser modificada por un documento (ejm,  factura, recibo, etc)',
                allowBlank: false,
                anchor: '80%',
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store:['si','no']
           },
           type:'ComboBox',
           id_grupo:0,
           grid:true,
           form:true
          },
        
        {
            config:{
                name: 'prioridad_documento',
                fieldLabel: 'Prioridad Minima del documento',
                qtip:'Si tiene documento solo ejecuta la plantilla <= a este valor (por defecto 2)',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:100
            },
            type:'NumberField',
            valorInicial:2,
            filters:{pfiltro:'cmpbdet.prioridad_documento',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
          
        {
           config:{
            	name:'agrupar',
            	fieldLabel: 'Agrupar',
                allowBlank: false,
                anchor: '80%',
        		typeAhead: true,
            	triggerAction: 'all',
            	lazyRender:true,
            	mode: 'local',
            	store:['si','no']
           },
           type:'ComboBox',
           id_grupo:0,
           grid:true,
           form:true
          },		
           {
           config:{
            	name:'es_relacion_contable',
            	fieldLabel: 'Relacion Contable',
            	qtip:'Si tiene o no relacon contable',
                allowBlank: false,
                anchor: '80%',
        		typeAhead: true,
            	triggerAction: 'all',
            	lazyRender:true,
            	mode: 'local',
            	store:['si','no']
           },
           type:'ComboBox',
           id_grupo:0,
           grid:true,
           form:true
          },
          
        {
            config: {
                name: 'tipo_relacion_contable',
                fieldLabel: 'Relación Contable',
                qtip:'Codigo de la relacion contable de donde se obtendran la partida, cuenta y auxiliar',
                allowBlank: true,
                emptyText: 'Elija Relación Contable...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_contabilidad/control/TipoRelacionContable/listarTipoRelacionContable',
                    id: 'id_tipo_relacion_contable',
                    root: 'datos',
                    sortInfo: {
                        field: 'codigo_tipo_relacion',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_tipo_relacion_contable','codigo_tipo_relacion','nombre_tipo_relacion'],
                    remoteSort: true,
                    baseParams: {par_filtro:'tiprelco.codigo_tipo_relacion#tiprelco.nombre_tipo_relacion'}
                }),
                valueField: 'codigo_tipo_relacion',
                displayField: 'codigo_tipo_relacion',
                gdisplayField: 'tipo_relacion_contable',
                tpl:'<tpl for="."><div class="x-combo-list-item"><p>Código: {codigo_tipo_relacion}</p><p>Nombre: {nombre_tipo_relacion}</p></div></tpl>',
                forceSelection: true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'remote',
                pageSize: 20,
                queryDelay: 100,
                anchor: '100%',
                gwidth: 120,
                minChars: 2
            },
            type: 'ComboBox',
            filters:{pfiltro:'cmpbdet.tipo_relacion_contable',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        
        {
			config:{
				name: 'tabla_detalle',
				fieldLabel: 'Tabla Detalle',
				qtip:'Nombre de tabla o vista de donde se obtendran datos para la transaccion',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextArea',
			filters:{pfiltro:'cmpbdet.tabla_detalle',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
            config: {
                name: 'tipo_relacion_contable_cc',
                fieldLabel: 'Relación CC',
                qtip:'Relacion contable "unica" para conseguir el centro de costo, si es nulo o vacio no se opera, se ejecuta solo si no se tiene un campo  para centro de costo ya definido',
                allowBlank: true,
                emptyText: 'Elija Relación Contable...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_contabilidad/control/TipoRelacionContable/listarTipoRelacionContable',
                    id: 'id_tipo_relacion_contable',
                    root: 'datos',
                    sortInfo: {
                        field: 'codigo_tipo_relacion',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_tipo_relacion_contable','codigo_tipo_relacion','nombre_tipo_relacion'],
                    remoteSort: true,
                    baseParams: {par_filtro:'tiprelco.codigo_tipo_relacion#tiprelco.nombre_tipo_relacion'}
                }),
                valueField: 'codigo_tipo_relacion',
                displayField: 'codigo_tipo_relacion',
                gdisplayField: 'tipo_relacion_contable_cc',
                tpl:'<tpl for="."><div class="x-combo-list-item"><p>Código: {codigo_tipo_relacion}</p><p>Nombre: {nombre_tipo_relacion}</p></div></tpl>',
                forceSelection: true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'remote',
                pageSize: 20,
                queryDelay: 100,
                anchor: '100%',
                gwidth: 120,
                minChars: 2
            },
            type: 'ComboBox',
            filters:{pfiltro:'cmpbdet.tipo_relacion_contable_cc',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
			config:{
				name: 'campo_relacion_contable_cc',
				fieldLabel: 'Campo Relacion CC',
				qtip:'Define el campo llave para obtener la relacion contable del centro de costo',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextArea',
			filters:{pfiltro:'cmpbdet.campo_relacion_contable_cc',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
        
        
		{
			config:{
				name: 'campo_centro_costo',
				fieldLabel: 'Campo Centro Costo',
				qtip:'Las relaciones contables necesitan un CC para funcionar, tambien es CC que va en la transaccion',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextArea',
			filters:{pfiltro:'cmpbdet.campo_centro_costo',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'campo_orden_trabajo',
				fieldLabel: 'Campo Orden de Trabajo',
				qtip:'Algunas relaciones contables necesitan una OT para acumular costos',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextArea',
			filters:{pfiltro:'cmpbdet.campo_orden_trabajo',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'campo_partida',
				fieldLabel: 'Campo Partida',
				qtip:'Si se define sobreescribe el obtenido en la Relacion contable',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextArea',
			filters:{pfiltro:'cmpbdet.campo_partida',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},		
		{
			config:{
				name: 'campo_cuenta',
				fieldLabel: 'Campo Cuenta',
				qtip:'Si se define sobreescribe el obtenido en la Relacion contable',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextArea',
			filters:{pfiltro:'cmpbdet.campo_cuenta',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'campo_auxiliar',
				fieldLabel: 'Campo Auxiliar',
				qtip:'Si se define sobreescribe el obtenido en la Relacion contable',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextArea',
			filters:{pfiltro:'cmpbdet.campo_auxiliar',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'campo_relacion_contable',
				fieldLabel: 'Campo Relacion Contable',
				qtip:'Define el campo llave para obtener la relacion contable, ejm proveedor, cuenta bancaria, concepto de gato, etc',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextArea',
			filters:{pfiltro:'cmpbdet.campo_relacion_contable',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'campo_documento',
				fieldLabel: 'Campo Documento',
				qtip:'Define el campo donde se tiene almacenado el id_platilla que se aplicara como documento',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextArea',
			filters:{pfiltro:'cmpbdet.campo_documento',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'campo_concepto_transaccion',
				fieldLabel: 'Campo Concepto Transaccion',
				qtip:'Define el contenido de la glosa de la transaccion',
                allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextArea',
			filters:{pfiltro:'cmpbdet.campo_concepto_transaccion',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'campo_monto',
				fieldLabel: 'Campo Monto',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:150
			},
			type:'TextArea',
			filters:{pfiltro:'cmpbdet.campo_monto',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'campo_fecha',
				fieldLabel: 'Campo Fecha',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextArea',
			filters:{pfiltro:'cmpbdet.campo_fecha',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
           config:{
                name: 'primaria',
                fieldLabel: 'Trans Primaria',
                qtip:'Si es una trasaccion primaria se ejecuta primero, si no lo es se ejecuta despues de la plantilla base',
                allowBlank: false,
                anchor: '80%',
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store:['si','no']
           },
           type:'ComboBox',
           filters:{pfiltro:'cmpbdet.primaria',type:'string'},
           id_grupo:0,
           grid:true,
           form:true
          },
          
          {
            config: {
                name: 'id_detalle_plantilla_fk',
                qtip:'Si no es una trasaccion primaria, aca se indica cual es un transaccion base',
                fieldLabel: 'Plantilla base',
                allowBlank: true,
                store: new Ext.data.JsonStore({
                    url: '../../sis_contabilidad/control/DetallePlantillaComprobante/listarDetallePlantillaComprobante',
                    id: 'id_detalle_plantilla_comprobante',
                    root: 'datos',
                    totalProperty: 'total',
                    fields: ['id_detalle_plantilla_comprobante','descripcion'],
                    remoteSort: true,
                    baseParams: {par_filtro:'tiprelco.descripcion'}
                }),
                valueField: 'id_detalle_plantilla_comprobante',
                displayField: 'descripcion',
                gdisplayField: 'descripcion_base',
                forceSelection: true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'remote',
                pageSize: 20,
                queryDelay: 100,
                anchor: '100%',
                gwidth: 120,
                minChars: 2
            },
            type: 'ComboBox',
            filters:{pfiltro:'cmpbdetb.descripcion_base',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
          
      
		{
            config:{
                name: 'otros_campos',
                fieldLabel: 'Otros Campos',
                qtip:'Otros campo que son necesarios y se obtienen desde la tabla detalle',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:100
            },
            type:'TextArea',
            filters:{pfiltro:'cmpbdet.otros_campos',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'nom_fk_tabla_maestro',
                fieldLabel: 'Fk Tabla Maestro',
                qtip:'Hace referencia al nombre del campo en la Tabla Detalle que se usa como llave foranea, debe conincidir con el campo "Id Tabla" configurado en el maestro',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:100
            },
            type:'TextField',
            filters:{pfiltro:'cmpbdet.nom_fk_tabla_maestro',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'campo_partida_ejecucion',
                fieldLabel: 'Campo Partida Ejecucion',
                qtip:'Si el comprobante no compromete por si solo, aca se define la id_partida_ejecucion del comprometido que se usara',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:100
            },
            type:'TextArea',
            filters:{pfiltro:'cmpbdet.campo_partida_ejecucion',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'campo_monto_pres',
                fieldLabel: 'Campo Monto Presu.',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:150
            },
            type:'TextArea',
            filters:{pfiltro:'cmpbdet.campo_monto_pres',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
           config:{
                name: 'rel_dev_pago',
                fieldLabel: 'Es plant. presu.',
                qtip:'Si plantilla de presupuesto se utiliza para relacion el devengado con el pagado, no genera transacciones',
                allowBlank: false,
                anchor: '80%',
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store:['si','no']
           },
           type:'ComboBox',
           filters:{pfiltro:'cmpbdet.rel_dev_pago',type:'string'},
           id_grupo:0,
           grid:true,
           form:true
          },
        {
            config:{
                name: 'campo_trasaccion_dev',
                fieldLabel: 'Campo Trans Devengado.',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:100
            },
            type:'TextArea',
            filters:{pfiltro:'cmpbdet.campo_trasaccion_dev',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'campo_id_tabla_detalle',
                fieldLabel: 'Campo id tabla det.',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:100
            },
            type:'TextField',
            filters:{pfiltro:'cmpbdet.campo_id_tabla_detalle',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
           config:{
                name: 'forma_calculo_monto',
                fieldLabel: 'Forma de Calculo',
                qtip:'Forma en la que se calcula el monto, simple es una copia directa, decuento le resta al transaccion base, etc',
                allowBlank: false,
                anchor: '80%',
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store:['simple','descuento','incremento','diferencia']
           },
           type:'ComboBox',
           filters:{pfiltro:'cmpbdet.forma_calculo_monto',type:'string'},
           id_grupo:0,
           grid:true,
           form:true
          },
          {
            config:{
                name: 'func_act_transaccion',
                fieldLabel: 'Fun act transaccion.',
                qtip:'Funcion que se ejecuta despues  crear transaccion, por ejemplo es util para almacenar el id de la transaccion en algun otro lugar',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:100
            },
            type:'TextField',
            filters:{pfiltro:'cmpbdet.func_act_transaccion',type:'string'},
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
				maxLength:100
			},
			type:'TextArea',
			filters:{pfiltro:'cmpbdet.campo_id_cuenta_bancaria',type:'string'},
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
				maxLength:100
			},
			type:'TextArea',
			filters:{pfiltro:'cmpbdet.campo_id_cuenta_bancaria_mov',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		
		
		
		{
			config:{
				name: 'campo_forma_pago',
				fieldLabel: 'Campo Forma de Pago',
				qtip:'para las transacciones con cuentas de bancos, cheuqe o transferencia',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextArea',
			filters:{pfiltro:'cmpbdet.campo_nro_cheque',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		
		
        {
			config:{
				name: 'campo_nro_cheque',
				fieldLabel: 'Campo Nro. Cheque',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextArea',
			filters:{pfiltro:'cmpbdet.campo_nro_cheque',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
        {
			config:{
				name: 'campo_nombre_cheque_trans',
				fieldLabel: 'Campo Nombre Cheque/Trans',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextArea',
			filters:{pfiltro:'cmpbdet.campo_nombre_cheque_trans',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
        {
            config:{
                name: 'campo_nro_cuenta_bancaria_trans',
                fieldLabel: 'Nro. CB Dest. Trans',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:100
            },
            type:'TextArea',
            filters:{pfiltro:'cmpbdet.campo_nro_cuenta_bancaria_trans',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'campo_porc_monto_excento_var',
                fieldLabel: '% Monto Excento',
                qtip:'Alguno documentos necesitan aplicar un % excento que modifica el monto original (por ejm iva de electricidad )',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:100
            },
            type:'TextArea',
            filters:{pfiltro:'cmpbdet.campo_porc_monto_excento_var',type:'string'},
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
			filters:{pfiltro:'cmpbdet.estado_reg',type:'string'},
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
			filters:{pfiltro:'cmpbdet.fecha_reg',type:'date'},
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
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
			type:'DateField',
			filters:{pfiltro:'cmpbdet.fecha_mod',type:'date'},
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
		}
	],
	
	onSubmit : function(o) {
		//this.Cmp.campo_monto_pres.setValue(encodeURIComponent(this.Cmp.campo_monto_pres.getValue()));
		//this.Cmp.campo_monto.setValue(encodeURIComponent(this.Cmp.campo_monto.getValue()));
		Phx.vista.DetallePlantillaComprobante.superclass.onSubmit.call(this,o);
	},
	
	title:'Detalla Comprobante',
	ActSave:'../../sis_contabilidad/control/DetallePlantillaComprobante/insertarDetallePlantillaComprobante',
	ActDel:'../../sis_contabilidad/control/DetallePlantillaComprobante/eliminarDetallePlantillaComprobante',
	ActList:'../../sis_contabilidad/control/DetallePlantillaComprobante/listarDetallePlantillaComprobante',
	id_store:'id_detalle_plantilla_comprobante',
	fields: [
		{name:'id_detalle_plantilla_comprobante', type: 'numeric'},
		{name:'id_plantilla_comprobante', type: 'numeric'},
		{name:'debe_haber', type: 'string'},
		{name:'agrupar', type: 'string'},
		{name:'es_relacion_contable', type: 'string'},
		{name:'tabla_detalle', type: 'string'},
		{name:'campo_partida', type: 'string'},
		{name:'campo_concepto_transaccion', type: 'string'},
		{name:'tipo_relacion_contable', type: 'string'},
		{name:'campo_cuenta', type: 'string'},
		{name:'campo_monto', type: 'string'},
		{name:'campo_relacion_contable', type: 'string'},
		{name:'campo_documento', type: 'string'},
		{name:'aplicar_documento', type: 'numeric'},
		{name:'campo_centro_costo', type: 'string'},
		{name:'campo_auxiliar', type: 'string'},
		{name:'campo_fecha', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		'primaria', 
        'otros_campos', 
        'nom_fk_tabla_maestro', 
        'campo_partida_ejecucion' , 
        'descripcion' , 
        'campo_monto_pres' , 
        'id_detalle_plantilla_fk', 
        'forma_calculo_monto', 
        'func_act_transaccion', 
        'campo_id_tabla_detalle', 
        'rel_dev_pago', 
        'campo_trasaccion_dev','descripcion_base',
        {name:'campo_id_cuenta_bancaria', type: 'string'},
        {name:'campo_id_cuenta_bancaria_mov', type: 'string'},
        {name:'campo_nro_cheque', type: 'string'}, 
        'campo_nro_cuenta_bancaria_trans',
        'campo_porc_monto_excento_var',
        {name:'campo_nombre_cheque_trans', type: 'string'},
        'prioridad_documento',
        'campo_orden_trabajo','campo_forma_pago','codigo','tipo_relacion_contable_cc','campo_relacion_contable_cc'
		
	],
	sortInfo:{
		field: 'id_detalle_plantilla_comprobante',
		direction: 'ASC'
	},
	onReloadPage:function(m){
       
        this.maestro=m;

       if(m.id != 'id'){
        this.store.baseParams={id_plantilla_comprobante:this.maestro.id_plantilla_comprobante};
        this.load({params:{start:0, limit:50}})       
       }
       else{
         this.grid.getTopToolbar().disable();
         this.grid.getBottomToolbar().disable(); 
         this.store.removeAll();
       }
       
       this.Cmp.id_detalle_plantilla_fk.store.baseParams.id_plantilla_comprobante=this.maestro.id_plantilla_comprobante
                
   },
   
   loadValoresIniciales : function() {
					Phx.vista.DetallePlantillaComprobante.superclass.loadValoresIniciales.call(this);
					if (this.maestro.id_plantilla_comprobante != undefined) {
						this.getComponente('id_plantilla_comprobante').setValue(this.maestro.id_plantilla_comprobante);
					}
				},
    
	bdel:true,
	bsave:true
	}
)
</script>