<?php
/**
*@package pXP
*@file gen-ResultadoDetPlantilla.php
*@author  (admin)
*@date 08-07-2015 13:13:15
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ResultadoDetPlantilla=Ext.extend(Phx.gridInterfaz,{
    fheight : '90%',
	fwidth : '50%',
	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.ResultadoDetPlantilla.superclass.constructor.call(this,config);
		this.init();
		this.grid.getTopToolbar().disable();
		this.grid.getBottomToolbar().disable();
		this.iniciarEventos();
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_resultado_det_plantilla'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'id_resultado_plantilla',
				inputType:'hidden'
			},
			type:'Field',
			form:true
		},
		{
			config:{
				name: 'codigo',
				fieldLabel: 'Código',
				qtip:'El código se utiliza para identificar de manera única el registro y principalmente como variable en las formulas',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:20
			},
				type:'TextField',
				filters:{pfiltro:'resdet.codigo',type:'string'},
				id_grupo:1,
				grid:true,
				egrid: true,
				form:true
		},
		{
			config:{
				name: 'orden',
				qtip: 'Prioridad con que se ejecutan las formulas',
				fieldLabel: 'orden',
				allowBlank: false,
				anchor: '80%',
				gwidth: 50
			},
			type: 'NumberField',
			filters: { pfiltro:'resdet.orden',type:'numeric'},
			id_grupo: 1,
			grid: true,
			egrid: true,
			form: true
		},
		{
			config:{
				name: 'orden_cbte',
				qtip: 'Orden en el que se insertar en comprobante o el orden en el que se muestra en el reporte',
				fieldLabel: 'Orden Cbte',
				allowBlank: false,
				anchor: '80%',
				gwidth: 50
			},
			type: 'NumberField',
			filters: { pfiltro:'resdet.orden_cbte',type:'numeric'},
			id_grupo: 1,
			grid: true,
			egrid: true,
			form: true
		},
		{
            config:{
                name: 'destino',
                fieldLabel: 'Destino',
                qtip: '(1) reporte (no se utiliza para generar comprobantes, solo como calculo auxiliar),<br> '+ 
                 	  '(2) debe (al debe si es positivo si no al haber), <br>'+
                	  '(3) haber (al haber si espositivo si no al contrario) <br>'+
                	  '(4) segun_saldo (lo suficiente para cuadrar al debe o al haber)',
                allowBlank: false,
                anchor: '40%',
                gwidth: 80,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'local',
                store: ['reporte','debe','haber','segun_saldo']
            },
            type:'ComboBox',
            
            id_grupo:1,
            filters:{   pfiltro:'resdet.destino',
                        type: 'list',
                         options: ['reporte','debe','haber','segun_saldo']  
                    },
            valorInicial: 'reporte',
            grid:true,
            egrid: true,
            form:true
       },
		
		/*
		 balance(balance de la cuenta), 
		 detalle (listado segun nivel, y balance de los detalles), 
		 titulo (Solo titulo sin monto), 
		 formula (aplica la suma de varios campos)
		 * */
        {
            config:{
                name: 'origen',
                fieldLabel: 'Operación',
                qtip: 'Como calcula el monto, <br>'+
                	  '(1) balance -> Realiza un balance de la cuenta señalada<br>'+
                	  '(2) detalle -> Desglosa la cuenta según su composición y nivel detalle especificado<br>'+
                	  '(3) titulo -> Solo colocara la "Etiqueta" que se especifique en el campo "Nombre Texto" (Solo se utiliza en Reportes)<br>'+
                	  '(4) formula -> Señala que se tiene que usar una formula para calcular el valor de la línea<br>'+
                	  '(5) sumatoria -> Para realizar la suma en un rango determinado, especificar orden inicial y final en campo formula ejemplo 1-10 <br>'+
                	  '(6) detalle_formula -> la formula se aplicará sobre el detalle/desglose de las cuentas según el nivel especificado',
                allowBlank: false,
                anchor: '40%',
                gwidth: 80,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'local',
                store: ['balance', 'detalle', 'titulo', 'formula','sumatoria','detalle_formula']
            },
            type:'ComboBox',
            id_grupo:1,
            filters:{   pfiltro:'resdet.origen',
                        type: 'list',
                         options: ['balance','detalle','titulo','formula','sumatoria','detalle_formula']  
                    },
            grid:true,
            valorInicial: 'balance',
            egrid: true,
            form:true
        },
		{
            config:{
                name: 'nivel_detalle',
				fieldLabel: 'Nivel Detalle',
				qtip: 'Si la  operación es detalle o detalle_formula, el nivel especifica cuantos niveles anidar a partir de la cuenta raiz (Código cuenta)',
				allowBlank: false,
				anchor: '40%',
                gwidth: 80,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store:['1','2','3','4']
            },
            type:'ComboBox',
            id_grupo:1,
            valorInicial: '1',
            filters:{pfiltro:'resdet.nivel_detalle',type:'string'},
			grid:true,
			egrid: true,
            form:true
       },
	   {
			config:{
				name: 'tipo_saldo',
				fieldLabel: 'Tipo saldo',
				qtip: 'Solo se aplica cuando  la operación es balance. <br>'+
				      '(1) balance: la diferencia entre saldo deudor y acreedor'+
				      '(2) Deudor: solo suma los montos del debe'+
				      '(3) Acreedor: solo suma los montos al haber',
				allowBlank: false,
                anchor: '40%',
                gwidth: 80,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store:['balance' ,'deudor' ,'acreedor']
            },
            type:'ComboBox',
			filters:{pfiltro:'resdet.tipo_saldo',type:'string'},
			valorInicial: 'balance',
			id_grupo:1,
			grid:true,
			egrid: true,
			form:true
		},
	   {
			config:{
				name: 'signo_balance',
				fieldLabel: 'Signo Balance',
				qtip: 'Se aplicará al resultado de los saldos en operaciones de balance<br>'+
					  '(1) Defecto cuenta -> regresa el signo del monto según el tipo de cuenta<br>'+
				      '(2) Deudor ->   monto = saldo duedor - saldo acreedor <br>'+
				      '(3) Acredor ->  monto = saldo acreedor - saldo deudor',
				allowBlank: false,
                anchor: '40%',
                gwidth: 80,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store:['defecto_cuenta' ,'deudor' ,'acreedor']
            },
            type:'ComboBox',
			filters:{pfiltro:'resdet.posicion',type:'string'},
			valorInicial: 'defecto_cuenta',
			id_grupo:1,
			grid:true,
			egrid: true,
			form:true
		},
		{
   			config:{
   				sysorigen:'sis_contabilidad',
       		    name: 'codigo_cuenta',
       		    qtip: 'Define la cuenta sobre las que se realizan las operaciones',
				fieldLabel: 'Código cuenta',
				displayField: 'nro_cuenta',
				valueField: 'nro_cuenta',
   				origen:'CUENTA',
   				allowBlank:false,
   				fieldLabel: 'Cuenta',
   				gwidth:200,
   				width: 180,
   				listWidth: 350,
   				renderer:function (value, p, record){
   					if(record.data['desc_cuenta'] != 'S/C'){
   						 return String.format('({0}) {1}', record.data['codigo_cuenta'],record.data['desc_cuenta']);
   				    }
   				    else{
   				    	return String.format('{0}', record.data['desc_cuenta']);
   				    }
   				},
   				baseParams: {'filtro_ges':'actual', sw_transaccional: undefined}
       	     },
   			type:'ComboRec',
   			id_grupo:0,
   			filters:{	
		        pfiltro:'resdet.codigo_cuenta#cue.nombre',
				type:'string'
			},
   			grid:true,
   			egrid: true,
   			form:true
	   	},
		{
			config:{
				name: 'formula',
				fieldLabel: 'Formula',
				qtip: 'Si el operación del tipo formula,  ejm  {C1} + {C2} - {C3}<br>'+
					  'Si es una sumatoria especificar el rango de filas ejm: 1-10 (Sumará los resultados desde la fla 1 hasta la 10)',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:400
			},
				type:'TextArea',
				filters:{pfiltro:'resdet.formula',type:'string'},
				id_grupo:1,
				grid:true,
				egrid: true,
				form:true
		},
	    {
			config:{
				name: 'nombre_variable',
				fieldLabel: 'Nombre Texto',
				qtip: 'El nombre de que se coloca para este registro , prevalece sobre el nombre de la cuenta',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
				type:'TextField',
				filters:{pfiltro:'resdet.nombre_variable',type:'string'},
				id_grupo:1,
				grid:true,
				egrid: true,
				form:true
		},
		{
			config:{
				name: 'incluir_cierre',
				qtip: 'Incluye en las operaciones de tipo balance los comprobantes de cierre,<br>'+
				      '(1) no -> no incluye ningun tipo de cierre <br>'+
				      '(2) todos -> inclyes todos los tipos de cierre <br>'+
				      '(3) balance -> solo  incluye cierres del tipo balance <br>'+
				      '(4) resultado -> solo incluye cierres del tipo  resutlados <br>'+
				      '(5) solo_cierre -> solo incluye los cbte de cierre de cualqueir tipo',
				fieldLabel: 'Incluir cierre',
				allowBlank: false,
                anchor: '40%',
                gwidth: 80,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store:['no' ,'todos' ,'balance','resultado','solo_cierre']
            },
            type:'ComboBox',
			filters:{pfiltro:'resdet.incluir_cierre',type:'string'},
			valorInicial: 'no',
			id_grupo:1,
			grid:true,
			egrid: true,
			form:true
		},
		{
			config: {
				name: 'incluir_apertura',
				qtip: 'Incluye en las operaciones de tipo balance los cbte de  apertura',
				fieldLabel: 'Icluir apertura',
				allowBlank: false,
                anchor: '40%',
                gwidth: 80,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store: ['todos' ,'solo_apertura', 'no']
            },
            type:'ComboBox',
			filters: { pfiltro: 'resdet.incluir_apertura', type: 'string' },
			valorInicial: 'todos',
			id_grupo: 1,
			grid: true,
			egrid: true,
			form: true
		},
		{
			config: {
				name: 'incluir_aitb',
				qtip: 'Incluye en las operaciones de tipo balance los cbts de  ajuste por inflación y tenencia de bienes',
				fieldLabel: 'Icluir AITBs',
				allowBlank: false,
                anchor: '40%',
                gwidth: 80,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store: ['todos' ,'solo_aitb', 'no']
            },
            type:'ComboBox',
			filters: { pfiltro: 'resdet.incluir_aitb', type: 'string' },
			valorInicial: 'todos',
			id_grupo: 1,
			grid: true,
			egrid: true,
			form: true
		},
		
		{
            config:{
                name: 'visible',
                fieldLabel: 'Visible',
                qtip: 'Cuando el destino es reporte define si la fila se muestra o no',
                allowBlank: true,
                anchor: '40%',
                gwidth: 80,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store:['si','no']
            },
            type:'ComboBox',
            id_grupo:1,
            valorInicial: 'si',
            filters: { pfiltro: 'resdet.visible', type: 'string' },
			grid: true,
			egrid: true,
            form: true
       },
		
		{
            config:{
                name: 'font_size',
                fieldLabel: 'Font size',
                qtip: 'Tamaño de letra en reporte',
                allowBlank: true,
                anchor: '40%',
                gwidth: 80,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store:['09','10','11','12','13','14','15','16','17']
            },
            type:'ComboBox',
            id_grupo:1,
            valorInicial: '10',
            filters:{pfiltro:'resdet.font_size',type:'string'},
			grid:true,
			egrid: true,
            form:true
       },
       {
            config:{
                name: 'subrayar',
                fieldLabel: 'Subrayar',
                qtip: 'Subraya el texto en reportes',
                allowBlank: true,
                anchor: '40%',
                gwidth: 80,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store:['si','no']
            },
            type:'ComboBox',
            id_grupo:1,
            filters:{pfiltro:'resdet.subrayar',type:'string'},
            valorInicial: 'no',
			grid:true,
			egrid: true,
            form:true
       },
       {
            config:{
                name: 'negrita',
                fieldLabel: 'Negrita',
                qtip: 'Negrita del texto en reportes',
                allowBlank: true,
                anchor: '40%',
                gwidth: 80,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store:['si','no']
            },
            type:'ComboBox',
            id_grupo:1,
            filters:{pfiltro:'resdet.negrita',type:'string'},
            valorInicial: 'no',
			grid:true,
			egrid: true,
            form:true
       },
       {
            config:{
                name: 'cursiva',
                fieldLabel: 'Cursiva',
                qtip: 'Cursiva en  el texto',
                allowBlank: true,
                anchor: '40%',
                gwidth: 80,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store:['si','no']
            },
            type:'ComboBox',
            id_grupo:1,
            filters:{pfiltro:'resdet.cursiva',type:'string'},
            valorInicial: 'no',
			grid:true,
			egrid: true,
            form:true
       },
	   {
            config:{
                name: 'espacio_previo',
                fieldLabel: 'Espacios',
                qtip: 'Espacios previos antes de introducir el registro en reportes',
                allowBlank: false,
                anchor: '40%',
                gwidth: 80,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store:['0','1','2','3','4','5','6']
            },
            type:'ComboBox',
            id_grupo:1,
            filters:{pfiltro:'resdet.espacio_previo',type:'numeric'},
            valorInicial: '0',
			grid:true,
			egrid: true,
            form:true
       },
	   {
            config:{
                name: 'montopos',
                fieldLabel: 'Pos. Monto',
                qtip: 'Posición del monto en reportes',
                allowBlank: false,
                anchor: '40%',
                gwidth: 80,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store:['1','2','3']
            },
            type:'ComboBox',
            id_grupo:1,
            filters:{pfiltro:'resdet.montopos',type:'numeric'},
            valorInicial: '1',
			grid:true,
			egrid: true,
            form:true
       },
		{
			config:{
				name: 'posicion',
				fieldLabel: 'Aling',
				qtip: 'Posicion del texto en reportes',
				allowBlank: false,
                anchor: '40%',
                gwidth: 80,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store:['left' ,'center' ,'right']
            },
            type:'ComboBox',
			filters:{pfiltro:'resdet.posicion',type:'string'},
			valorInicial: 'left',
			id_grupo:1,
			grid:true,
			egrid: true,
			form:true
		},
		{
			config:{
				name: 'signo',
				fieldLabel: 'Signo',
				qtip: 'Añade significado de signo  al monto, (+) (-), solo para reportes',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:15
			},
				type:'TextField',
				filters:{pfiltro:'resdet.signo',type:'string'},
				id_grupo:1,
				valorInicial: '',
				grid:true,
				egrid: true,
				form:true
		},
	   	{
   			config:{
   				sysorigen:'sis_contabilidad',
   				qtip: 'Auxiliar para cbtes, prevalece sobre la relacion contable (No se usa en reporte)',
       		    name:'id_auxiliar',
   				origen:'AUXILIAR',
   				allowBlank:true,
   				fieldLabel:'Auxiliar',
   				gdisplayField:'desc_auxiliar',//mapea al store del grid
   				gwidth:200,
   				width: 350,
   				listWidth: 350,
   				//anchor: '80%',
	   			renderer:function (value, p, record){return String.format('{0}', record.data['desc_auxiliar']);}
       	     },
   			type:'ComboRec',
   			id_grupo:0,
   			filters:{	
		        pfiltro:'aux.codigo_auxiliar#aux.nombre_auxiliar',
				type:'string'
			},
   		   
   			grid:true,
   			form:true
	   	},
	   	{
   			config:{
   				name: 'codigo_partida',
       		    hiddenName: 'codigo_partida',
       		    qtip:'Partidas para comprobantes,  prevalece sobre la relación contable  (No se usa en reporte)',
   				valueField: 'codigo',
   				displayField: 'nombre_partida',
   				allowBlank: true,
   				fieldLabel:' Partida',
   				gdisplayField: 'desc_partida',//mapea al store del grid
   				gwidth:200,
   				width: 350,
   				emptyText:'Partida...',
   				forceSelection:true,
 				typeAhead: false,
                triggerAction: 'all',
                lazyRender:true,
 				mode:'remote',
 				pageSize:10,
 				queryDelay:1000,
 				listWidth:'280',
 				resizable: true,
   				tpl: new Ext.XTemplate([
				     '<tpl for=".">',
				     '<div class="x-combo-list-item">',
				     	'<tpl if="sw_movimiento == \'flujo\'">',
				     	'<font color="red"><p>Nombre:{nombre_partida}</p></font>',
				     	'</tpl>',
				     	'<tpl if="sw_movimiento == \'presupuestaria\'">',
				     	'<font color="green"><p>Nombre:{nombre_partida}</p></font>',
				     	'</tpl>',
				     '<p>{codigo}</p> <p>Tipo: {sw_movimiento} <p>Rubro: {tipo}</p>',
				     '</div>',
				     '</tpl>'
				     
				   ]),
				store: new Ext.data.JsonStore({
						 url: '../../sis_presupuestos/control/Partida/listarPartida',
						 id: 'codigo',
						 root: 'datos',
						 sortInfo:{
							field: 'nombre_partida',
							direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_partida','codigo','nombre_partida','tipo','sw_movimiento'],
					// turn on remote sorting
					remoteSort: true,
					baseParams: {par_filtro:'codigo#nombre_partida','filtro_ges':'actual',sw_transaccional:'movimiento'}, 
					}),
	   			renderer:function (value, p, record){return String.format('{0}',record.data['desc_partida']);}
       	     },
       	     
   			type:'ComboBox',
   			id_grupo:0,
   			filters:{	
		        pfiltro: 'par.codigo_partida#par.nombre_partida',
				type: 'string'
			},
   		   
   			grid:true,
   			form:true
	   	},
        {
            config: {
                name: 'relacion_contable',
                fieldLabel: 'Relación Contable',
                qtip: 'Codigo de la relacion contable de donde se obtendran la partida, cuenta y auxiliar (Solo se utilza cuando el destino es diferente a Reportes)',
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
                    baseParams: { par_filtro: 'tiprelco.codigo_tipo_relacion#tiprelco.nombre_tipo_relacion' }
                }),
                valueField: 'codigo_tipo_relacion',
                displayField: 'codigo_tipo_relacion',
                gdisplayField: 'relacion_contable',
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
            filters: { pfiltro:'resdet.relacion_contable', type:'string' },
            id_grupo: 1,
            grid: true,
            form: true
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
				filters:{pfiltro:'resdet.estado_reg',type:'string'},
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
				filters:{pfiltro:'resdet.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'resdet.usuario_ai',type:'string'},
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
				filters:{pfiltro:'resdet.fecha_reg',type:'date'},
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
				filters:{pfiltro:'resdet.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Detalle de Resultado',
	ActSave:'../../sis_contabilidad/control/ResultadoDetPlantilla/insertarResultadoDetPlantilla',
	ActDel:'../../sis_contabilidad/control/ResultadoDetPlantilla/eliminarResultadoDetPlantilla',
	ActList:'../../sis_contabilidad/control/ResultadoDetPlantilla/listarResultadoDetPlantilla',
	id_store:'id_resultado_det_plantilla',
	fields: [
		{name:'id_resultado_det_plantilla', type: 'numeric'},
		{name:'orden', type: 'numeric'},
		{name:'font_size', type: 'string'},
		{name:'formula', type: 'string'},
		{name:'subrayar', type: 'string'},
		{name:'codigo', type: 'string'},
		{name:'montopos', type: 'numeric'},
		{name:'nombre_variable', type: 'string'},
		{name:'posicion', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'nivel_detalle', type: 'numeric'},
		{name:'origen', type: 'string'},
		{name:'signo', type: 'string'},
		{name:'codigo_cuenta', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'id_resultado_plantilla', 'visible','incluir_cierre','incluir_apertura','desc_cuenta',
		'negrita','cursiva','espacio_previo','incluir_aitb','tipo_saldo','signo_balance',
        'relacion_contable',
        'codigo_partida',
        'id_auxiliar','desc_auxiliar',
        'destino',
        'orden_cbte','desc_partida'
		
	],
	sortInfo:{
		field: 'orden',
		direction: 'ASC'
	},
	
	onReloadPage:function(m){
       
        this.maestro=m;
        var pag = Phx.CP.getPagina(this.idContenedorPadre).nombreVista;
        
		this.getComponente('id_resultado_plantilla').setValue(this.maestro.id_resultado_plantilla);
		if(pag == 'ResultadoDep'){
			this.store.baseParams = { id_resultado_plantilla: this.maestro.id_resultado_plantilla_hijo };
		}
		else{
			this.store.baseParams = { id_resultado_plantilla: this.maestro.id_resultado_plantilla };
	    }
        
        this.load({params:{start:0, limit:50}})       
       
               
   },
   
   onSubmit : function(o) {
		//this.Cmp.formula.setValue(encodeURIComponent(this.Cmp.formula.getValue()));
		//this.Cmp.signo.setValue(encodeURIComponent(this.Cmp.signo.getValue()));
		console.log(this.Cmp.signo.getValue(), this.Cmp.formula.getValue())
		Phx.vista.ResultadoDetPlantilla.superclass.onSubmit.call(this,o);
	},
   
   loadValoresIniciales : function() {
					Phx.vista.ResultadoDetPlantilla.superclass.loadValoresIniciales.call(this);
					if (this.maestro.id_resultado_plantilla != undefined) {
						var pag = Phx.CP.getPagina(this.idContenedorPadre).nombreVista;
						if(pag == 'ResultadoDep'){
						   this.Cmp.id_resultado_plantilla.setValue(this.maestro.id_resultado_plantilla_hijo);
						}
						else{
							this.Cmp.id_resultado_plantilla.setValue(this.maestro.id_resultado_plantilla);
							
							if(this.maestro.tipo =='reporte'){
								this.Cmp.destino.disable();
								this.Cmp.relacion_contable.disable();
								this.Cmp.codigo_partida.disable();
								this.Cmp.id_auxiliar.disable();
							}else{
								this.Cmp.destino.enable();
								this.Cmp.relacion_contable.enable();
								this.Cmp.codigo_partida.enable();
								this.Cmp.id_auxiliar.enable();
							}
						}
					}
				},
	iniciarEventos: function(){
       	this.Cmp.origen.on('select',function(cmb,rec,ind){
	       		
	       		if(cmb.getValue() == 'formula' || cmb.getValue() == 'detalle_formula' || cmb.getValue() == 'sumatoria'){
	       			this.Cmp.formula.enable();
	       		}
	       		else{
	       			this.Cmp.formula.disable();
	       		}
	       		
	       		if(cmb.getValue() == 'balance' || cmb.getValue() == 'detalle_formula' || cmb.getValue() == 'detalle'){
	       			this.Cmp.codigo_cuenta.allowBlank = false;
	       		}
	       		else{
	       			this.Cmp.codigo_cuenta.allowBlank = true;
	       		}
	       		
	       		
	    },this);
    },			
	bdel:true,
	bsave:true
	}
)
</script>
		
		