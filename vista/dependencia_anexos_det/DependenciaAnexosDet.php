<?php
/**
*@package pXP
*@file gen-DependenciaAnexosDet.php
*@author  (miguel.mamani)
*@date 09-08-2019 13:47:05
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.DependenciaAnexosDet=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.DependenciaAnexosDet.superclass.constructor.call(this,config);
		this.init();
		//this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_dependencia_anexos_det'
			},
			type:'Field',
			form:true 
		},{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_dependencia_anexos'
			},
			type:'Field',
			form:true
		},
        {
            config:{
                name: 'operacion',
                fieldLabel: 'Operacion',
                allowBlank: false,
                anchor: '40%',
                gwidth: 80,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'local',
                store: ['balance', 'resultado', 'formula', 'impuesto', 'titulo','periodo']
            },
            type:'ComboBox',
            id_grupo:1,
            filters:{   pfiltro:'rad.operacion',
                type: 'list',
                options: ['balance', 'resultado', 'formula','impuesto','titulo','periodo']
            },
            grid:true,
            valorInicial: 'balance',
            egrid: true,
            form:true
        },
        {
            config:{
                name: 'numero',
                fieldLabel: 'Titulo Numero',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:100
            },
            type:'TextField',
            filters:{pfiltro:'rad.numero',type:'string'},
            id_grupo:1,
            grid:true,
            egrid: true,
            form:true
        },
        {
            config:{
                name: 'titulo',
                fieldLabel: 'Titulo Columna',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:100
            },
            type:'TextField',
            filters:{pfiltro:'rad.titulo',type:'string'},
            id_grupo:1,
            grid:true,
            egrid: true,
            form:true
        },
        {
            config:{
                name: 'ordernar',
                fieldLabel: 'Ordernar',
                allowBlank: false,
                anchor: '40%',
                gwidth: 80,
                maxLength:65536
            },
            type:'NumberField',
            filters:{pfiltro:'rad.ordernar',type:'numeric'},
            id_grupo:1,
            grid:true,
            egrid: true,
            form:true
        },
        {
            config:{
                name: 'codigo',
                fieldLabel: 'Codigo',
                allowBlank: true,
                anchor: '40%',
                gwidth: 80,
                maxLength:20
            },
            type:'TextField',
            filters:{pfiltro:'rad.codigo',type:'string'},
            id_grupo:1,
            grid:true,
            egrid: true,
            form:true
        },
        {
            config: {
                name: 'cuenta',
                fieldLabel: 'Nro.Cuenta',
                allowBlank: true,
                emptyText: 'Elija una opción...',
                qtip: 'Define la cuenta sobre las que se realizan las operaciones',
                store: new Ext.data.JsonStore({
                    url: '../../sis_contabilidad/control/Cuenta/listarCuenta',
                    id: 'id_cuenta',
                    root: 'datos',
                    sortInfo:{
                        field: 'nro_cuenta',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_cuenta','nombre_cuenta','desc_cuenta','nro_cuenta','gestion','desc_moneda'],
                    remoteSort: true
                    //baseParams: {par_filtro:'nro_cuenta#nombre_cuenta#desc_cuenta','filtro_ges':'actual'}
                }),
                displayField: 'nro_cuenta',
                valueField: 'nro_cuenta',
                forceSelection: true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'remote',
                pageSize: 500,
                queryDelay: 1000,
                width: 300,
                gwidth:200,
                minChars: 2,
                enableMultiSelect: true,
                renderer:function (value, p, record){
                    return String.format('{0}',record.data['cuenta']);
                }
            },
            type: 'AwesomeCombo',
            id_grupo: 1,
            grid: true,
            egrid: true,
            form: true
        },
        {
            config:{
                name: 'tipo_cuenta',
                fieldLabel: 'Origen',
                allowBlank: true,
                anchor: '40%',
                gwidth: 80,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store:['debe','haber','saldo']
            },
            type:'ComboBox',
            id_grupo:1,
            valorInicial: 'saldo',
            filters: { pfiltro: 'rad.tipo_cuenta', type: 'string' },
            grid: true,
            form: true
        },
        {
            config: {
                name: 'partida',
                fieldLabel: 'Partida',
                allowBlank: true,
                emptyText: 'Elija una opción...',
                qtip:'Partidas para comprobantes,  prevalece sobre la relación contable  (No se usa en reporte)',
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
                    remoteSort: true
                    //baseParams: {par_filtro:'codigo#nombre_partida','filtro_ges':'actual'}
                }),
                valueField: 'codigo',
                displayField: 'codigo',
                forceSelection: true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'remote',
                pageSize: 500,
                queryDelay: 1000,
                gwidth:200,
                width: 300,
                minChars: 2,
                enableMultiSelect: true,
                renderer:function (value, p, record){
                    return String.format('{0}',record.data['partida']);
                }
            },
            type: 'AwesomeCombo',
            id_grupo: 1,
            grid: true,
            form: true
        },
        {
            config:{
                name: 'formula',
                fieldLabel: 'Formula',
                allowBlank: true,
                width: 300,
                gwidth: 200,
                maxLength:400
            },
            type:'TextArea',
            filters:{pfiltro:'rad.formula',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config: {
                name: 'id_impuesto_form',
                fieldLabel: 'Impuesto',
                allowBlank: true,
                tinit: false,
                emptyText: 'Formulario...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_contabilidad/control/ImpuestoForm/listarImpuestoForm',
                    id: 'id_impuesto_form',
                    root: 'datos',
                    sortInfo: {
                        field: 'nombre',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_impuesto_form','nombre','codigo'],
                    remoteSort: true,
                    baseParams: {par_filtro:''}
                }),
                valueField: 'id_impuesto_form',
                displayField: 'nombre',
                gdisplayField: 'nombre',
                hiddenName: 'nombre',
                forceSelection: true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'remote',
                pageSize: 15,
                queryDelay: 1000,
                anchor: '40%',
                gwidth: 150,
                listWidth: 305,
                resizable: true,
                minChars: 2,
                renderer:function(value, p, record){return String.format('{0}', record.data['nombre']);}
            },
            type: 'ComboBox',
            id_grupo: 1,
            grid: true,
            form: true
        },
        {
            config: {
                name: 'id_impuesto_form_cod',
                fieldLabel: 'Codigo Impuesto',
                allowBlank: true,
                tinit: false,
                emptyText: 'Codigo...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_contabilidad/control/ImpuestoForm/listarImpuestoForm',
                    id: 'id_impuesto_form',
                    root: 'datos',
                    sortInfo: {
                        field: 'nombre',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_impuesto_form','nombre','codigo'],
                    remoteSort: true
                }),
                valueField: 'id_impuesto_form',
                displayField: 'codigo',
                gdisplayField: 'codigo_impuesto',
                hiddenName: 'nombre',
                forceSelection: true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'remote',
                pageSize: 15,
                queryDelay: 1000,
                anchor: '30%',
                gwidth: 150,
                listWidth: 305,
                resizable: true,
                minChars: 2,
                renderer:function(value, p, record){return String.format('{0}', record.data['codigo_impuesto']);}
            },
            type: 'ComboBox',
            id_grupo: 1,
            grid: true,
            form: true
        },
        {
            config:{
                name: 'tipo_periodo',
                fieldLabel: 'Tipo Periodo',
                allowBlank: true,
                anchor: '40%',
                gwidth: 80,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store:['normal','un_mes_antes','un_mes_despues']
            },
            type:'ComboBox',
            id_grupo:1,
            valorInicial: 'normal',
            filters: { pfiltro: 'rad.tipo_periodo', type: 'string' },
            grid: true,
            egrid: true,
            form: true
        },
        {
            config:{
                name: 'apertura',
                fieldLabel: 'Incluir Apertura',
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
            valorInicial: 'no',
            filters: { pfiltro: 'rad.apertura', type: 'string' },
            grid: true,
            egrid: true,
            form: true
        },
        {
            config:{
                name: 'cierre',
                fieldLabel: 'Incluir Cierre',
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
            valorInicial: 'no',
            filters: { pfiltro: 'rad.cierre', type: 'string' },
            grid: true,
            egrid: true,
            form: true
        }, {
            config:{
                name: 'cbte_aitb',
                fieldLabel: 'Incluir Cbte Aitb',
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
            valorInicial: 'no',
            filters: { pfiltro: 'rad.cbte_aitb', type: 'string' },
            grid: true,
            egrid: true,
            form: true
        },
        {
            config:{
                name: 'desglosar',
                fieldLabel: 'Desglosar',
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
            valorInicial: 'no',
            filters: { pfiltro: 'rad.desglosar', type: 'string' },
            grid: true,
            egrid: true,
            form: true
        },
        {
            config:{
                name: 'visible',
                fieldLabel: 'Visible',
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
            filters: { pfiltro: 'rad.visible', type: 'string' },
            grid: true,
            egrid: true,
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
            filters:{pfiltro:'rad.estado_reg',type:'string'},
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
            filters:{pfiltro:'rad.fecha_reg',type:'date'},
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
            filters:{pfiltro:'rad.usuario_ai',type:'string'},
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
                name: 'id_usuario_ai',
                fieldLabel: 'Creado por',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:4
            },
            type:'Field',
            filters:{pfiltro:'rad.id_usuario_ai',type:'numeric'},
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
            filters:{pfiltro:'rad.fecha_mod',type:'date'},
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
	title:'Dependencia detalle',
	ActSave:'../../sis_contabilidad/control/DependenciaAnexosDet/insertarDependenciaAnexosDet',
	ActDel:'../../sis_contabilidad/control/DependenciaAnexosDet/eliminarDependenciaAnexosDet',
	ActList:'../../sis_contabilidad/control/DependenciaAnexosDet/listarDependenciaAnexosDet',
	id_store:'id_dependencia_anexos_det',
	fields: [
		{name:'id_dependencia_anexos_det', type: 'numeric'},
		{name:'ordernar', type: 'numeric'},
		{name:'apertura', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'tipo_cuenta', type: 'string'},
		{name:'id_dependencia_anexos', type: 'numeric'},
		{name:'formula', type: 'string'},
		{name:'cbte_aitb', type: 'string'},
		{name:'visible', type: 'string'},
		{name:'id_impuesto_form', type: 'numeric'},
		{name:'tipo_periodo', type: 'string'},
		{name:'codigo', type: 'string'},
		{name:'numero', type: 'string'},
		//{name:'codigo_formulario', type: 'string'},
		{name:'titulo', type: 'string'},
		//{name:'formulario_impuesto', type: 'string'},
		{name:'cierre', type: 'string'},
		{name:'partida', type: 'string'},
		{name:'desglosar', type: 'string'},
		{name:'operacion', type: 'string'},
		{name:'cuenta', type: 'string'},
		{name:'id_impuesto_form_cod', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'}
		
	],
	sortInfo:{
		field: 'ordernar',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
    fwidth: '50%',
    fheight: '80%',
    onReloadPage:function(m){
        this.maestro=m;
        this.store.baseParams = {id_dependencia_anexos: this.maestro.id_dependencia_anexos };
        this.load({params:{start:0, limit:50}})
    },
    loadValoresIniciales: function () {
        this.Cmp.id_dependencia_anexos.setValue(this.maestro.id_dependencia_anexos);
        Phx.vista.DependenciaAnexosDet.superclass.loadValoresIniciales.call(this);
    },
    onButtonNew:function(){
        Phx.vista.DependenciaAnexosDet.superclass.onButtonNew.call(this);
        this.eventosFormulario();
        this.iniciarEvento();
        this.Cmp.id_impuesto_form.on('select', function(combo, record, index){
            this.Cmp.id_impuesto_form_cod.store.baseParams ={par_filtro:'codigo',id_impuesto_form_padre:record.data.id_impuesto_form};
            this.Cmp.id_impuesto_form_cod.reset();
            this.Cmp.id_impuesto_form_cod.modificado = true;
        },this);
    },
    onButtonEdit:function(){
        Phx.vista.DependenciaAnexosDet.superclass.onButtonEdit.call(this);
        this.Cmp.id_impuesto_form.on('select', function(combo, record, index){
            this.Cmp.id_impuesto_form_cod.store.baseParams ={par_filtro:'codigo',id_impuesto_form_padre:record.data.id_impuesto_form};
            this.Cmp.id_impuesto_form_cod.reset();
            this.Cmp.id_impuesto_form_cod.modificado = true;
        },this);
        this.eventosFormulario();
        this.iniciarEvento();
    },
    iniciarEvento:function (){
        console.log(this.maestro.id_gestion);
        this.Cmp.cuenta.store.baseParams ={par_filtro:'nro_cuenta#nombre_cuenta#desc_cuenta','filtro_ges':'actual'};
        this.Cmp.partida.store.baseParams ={par_filtro:'codigo#nombre_partida',id_gestion: this.maestro.id_gestion};
        this.Cmp.cuenta.lastQuery = null;
        this.Cmp.partida.lastQuery = null;
    },
    eventosFormulario: function () {
        this.eventoBalance();
        this.Cmp.operacion.on('select',function (combo,record,index) {
            if(combo.value === 'balance'){
                this.eventoBalance();
            }if(combo.value === 'formula'){
                this.eventoFormula();
            }if(combo.value === 'resultado'){
                this.eventoResultado();
            }if(combo.value === 'impuesto'){
                this.eventoImpuesto();
            }if(combo.value === 'titulo'){
                this.eventoTitulo();
            }if(combo.value === 'periodo'){
                this.envetoPeriodo();
            }
        },this);
    },
    eventoBalance:function () {
        this.ocultarComponente(this.Cmp.id_impuesto_form_cod);
        this.ocultarComponente(this.Cmp.id_impuesto_form);
        this.ocultarComponente(this.Cmp.formula);

        this.mostrarComponente(this.Cmp.desglosar);
        this.mostrarComponente(this.Cmp.cierre);
        this.mostrarComponente(this.Cmp.apertura);
        this.mostrarComponente(this.Cmp.cbte_aitb);
        this.mostrarComponente(this.Cmp.tipo_periodo);
        this.mostrarComponente(this.Cmp.cuenta);
        this.mostrarComponente(this.Cmp.tipo_cuenta);
        this.mostrarComponente(this.Cmp.partida);
    },
    eventoFormula:function () {
        this.mostrarComponente(this.Cmp.formula);

        this.ocultarComponente(this.Cmp.cuenta);
        this.ocultarComponente(this.Cmp.tipo_cuenta);
        this.ocultarComponente(this.Cmp.partida);
        this.ocultarComponente(this.Cmp.desglosar);
        this.ocultarComponente(this.Cmp.cierre);
        this.ocultarComponente(this.Cmp.cbte_aitb);
        this.ocultarComponente(this.Cmp.apertura);
        this.ocultarComponente(this.Cmp.tipo_periodo);
    },
    eventoResultado: function(){
        this.ocultarComponente(this.Cmp.formula);

        this.mostrarComponente(this.Cmp.cuenta);
        this.mostrarComponente(this.Cmp.tipo_cuenta);
        this.mostrarComponente(this.Cmp.tipo_cuenta);
        this.mostrarComponente(this.Cmp.desglosar);
        this.mostrarComponente(this.Cmp.cierre);
        this.mostrarComponente(this.Cmp.cbte_aitb);
        this.mostrarComponente(this.Cmp.apertura);
        this.mostrarComponente(this.Cmp.tipo_periodo);
        this.mostrarComponente(this.Cmp.id_impuesto_form);
        this.mostrarComponente(this.Cmp.id_impuesto_form_cod);
    },
    eventoImpuesto:function () {
        this.ocultarComponente(this.Cmp.partida);
        this.ocultarComponente(this.Cmp.cuenta);
        this.ocultarComponente(this.Cmp.tipo_cuenta);
        this.ocultarComponente(this.Cmp.formula);
        this.ocultarComponente(this.Cmp.cierre);
        this.ocultarComponente(this.Cmp.cbte_aitb);
        this.ocultarComponente(this.Cmp.apertura);
        this.ocultarComponente(this.Cmp.desglosar);

        this.mostrarComponente(this.Cmp.tipo_periodo);
        this.mostrarComponente(this.Cmp.id_impuesto_form);
        this.mostrarComponente(this.Cmp.id_impuesto_form_cod);
    },
    eventoTitulo:function () {
        this.ocultarComponente(this.Cmp.partida);
        this.ocultarComponente(this.Cmp.cuenta);
        this.ocultarComponente(this.Cmp.tipo_cuenta);
        this.ocultarComponente(this.Cmp.formula);
        this.ocultarComponente(this.Cmp.cierre);
        this.ocultarComponente(this.Cmp.cbte_aitb);
        this.ocultarComponente(this.Cmp.apertura);
        this.ocultarComponente(this.Cmp.desglosar);
        this.ocultarComponente(this.Cmp.tipo_periodo);
        this.ocultarComponente(this.Cmp.id_impuesto_form);
        this.ocultarComponente(this.Cmp.id_impuesto_form_cod);
    },
    envetoPeriodo:function () {
        this.ocultarComponente(this.Cmp.partida);
        this.ocultarComponente(this.Cmp.cuenta);
        this.ocultarComponente(this.Cmp.tipo_cuenta);
        this.ocultarComponente(this.Cmp.formula);
        this.ocultarComponente(this.Cmp.cierre);
        this.ocultarComponente(this.Cmp.cbte_aitb);
        this.ocultarComponente(this.Cmp.apertura);
        this.ocultarComponente(this.Cmp.desglosar);
        this.ocultarComponente(this.Cmp.tipo_periodo);
        this.ocultarComponente(this.Cmp.id_impuesto_form);
        this.ocultarComponente(this.Cmp.id_impuesto_form_cod);
    }
	}
)
</script>
		
		