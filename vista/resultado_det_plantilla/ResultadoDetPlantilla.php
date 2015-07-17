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

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.ResultadoDetPlantilla.superclass.constructor.call(this,config);
		this.init();
		this.grid.getTopToolbar().disable();
		this.grid.getBottomToolbar().disable();
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
				qtip:'El código se utiliza en las formulas',
				allowBlank: true,
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
		
		/*
		 balance(balance de la cuenta), 
		 detalle (listado segun nivel, y balance de los detalles), 
		 titulo (Solo titulo sin monto), 
		 formula (aplica la suma de varios campos)
		 * */
        {
            config:{
                name: 'origen',
                fieldLabel: 'Origen',
                qtip: 'Como calcula el monto, (1)  en caso de detalle agregar Nivel detalle (2) en caso de formula especificar el campoformula (3) en caso de sumatoria especificar orden inicial y final en campo formula ejmplo 1-10',
                allowBlank: false,
                anchor: '40%',
                gwidth: 80,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'local',
                store: ['balance', 'detalle', 'titulo', 'formula','sumatoria']
            },
            type:'ComboBox',
            id_grupo:1,
            filters:{   pfiltro:'resdet.origen',
                        type: 'list',
                         options: ['balance','detalle','titulo','formula']  
                    },
            grid:true,
            egrid: true,
            form:true
        },
		{
            config:{
                name: 'nivel_detalle',
				fieldLabel: 'Nivel Detalle',
				qtip: 'si el origen es detalle, el nivel especifica cuantos anidar a partir de la cuenta raiz (Código cuenta)',
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
				qtip: 'Solo se aplica cuando  el tipo de saldo es balance. <br>(1) balance: la diferencia entre saldo deudor y acreedor  (2) Deudor: solo suma los montos del debe (3) Acreedor: solo suma los montos al haber',
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
				qtip: '(1) defecto cuenta: regresa el signo del monto según el tipo de cuenta,  (2) Deudor: monto = saldo duedor - saldo acreedor (3) Acredor: monto = saldo acreedor - saldo deudor',
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
				fieldLabel: 'Código cuenta',
				displayField: 'nro_cuenta',
				valueField: 'nro_cuenta',
   				origen:'CUENTA',
   				allowBlank:true,
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
				qtip: 'Si el origen es formula,  ejm  {C1} + {C2} - {C3}',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:200
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
				qtip: 'El nombre de que se coloca par aeste registro , prevalece sobre el nombre de la cuenta',
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
				qtip: 'icluye en el balance los comprobantes de cierre, no -> ninguno, balance -> solo el balance de cierre, resultado -> solo el cierrede resutlados, o solo_cierre',
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
				qtip: 'icluye en el balance de apertura',
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
				qtip: 'incluir comprobantes de  ajuste por inflancion y tenencia de bienes',
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
                qtip: 'Se muestra en el reporte',
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
                qtip: 'Subraya el texto',
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
                qtip: 'Negrita',
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
                qtip: 'Espacios previos antes de introducir el registro',
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
                qtip: 'Posición del monto',
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
				qtip: 'Posicion del texto',
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
				qtip: 'Añade significado de signo  al monto, (+) (-)',
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
		'negrita','cursiva','espacio_previo','incluir_aitb','tipo_saldo','signo_balance'
		
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
		this.Cmp.formula.setValue(encodeURIComponent(this.Cmp.formula.getValue()));
		this.Cmp.signo.setValue(encodeURIComponent(this.Cmp.signo.getValue()));
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
						}
					}
				},
	bdel:true,
	bsave:true
	}
)
</script>
		
		