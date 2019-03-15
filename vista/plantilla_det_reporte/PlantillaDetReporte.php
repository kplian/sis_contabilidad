<?php
/**
 *@package pXP
 *@file gen-PlantillaDetReporte.php
 *@author  (m.mamani)
 *@date 06-09-2018 20:33:59
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.PlantillaDetReporte=Ext.extend(Phx.gridInterfaz,{
        formulario: '',
        constructor:function(config){
            this.maestro=config.maestro;
            Phx.vista.PlantillaDetReporte.superclass.constructor.call(this,config);
            this.init();
        },
        Atributos:[
            {
                //configuracion del componente
                config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_plantilla_det_reporte'
                },
                type:'Field',
                form:true
            },
            {
                //configuracion del componente
                config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_plantilla_reporte'
                },
                type:'Field',
                form:true
            },
            {
                config:{
                    name:'operacion',
                    fieldLabel:'Operación',
                    typeAhead: true,
                    allowBlank:false,
                    triggerAction: 'all',
                    emptyText:'Tipo...',
                    selectOnFocus:true,
                    mode:'local',
                    store:new Ext.data.ArrayStore({
                        fields: ['ID', 'valor'],
                        data :	[
                            ['periodo','Periodo'],
                            ['resultado','Mayor'],
                            ['impuestos','Impuestos'],
                            ['formula','Formula'],
                            ['operacion','Operacion'],
                            ['no','Titulo']
                        ]
                    }),
                    valueField:'ID',
                    displayField:'valor',
                    width: 300,
                    valorInicial: 'no',
                    gwidth:130
                },
                type:'ComboBox',
                id_grupo:1,
                grid:true,
                egrid: true,
                form:true
            },
            {
                config:{
                    name: 'order_fila',
                    fieldLabel: 'Orden',
                    allowBlank: false,
                    width: 50,
                    gwidth: 80,
                    style: 'background-color: #F0E68C;  background-image: none;'
                },
                type:'TextField',
                filters:{pfiltro:'pdr.order_fila',type:'string'},
                id_grupo:1,
                grid:true,
                egrid: true,
                form:true
            },
            {
                config:{
                    name: 'codigo_columna',
                    fieldLabel: 'Titulo',
                    allowBlank: true,
                    gwidth: 150,
                    width: 300,
                    style: 'background-color: #FFFACD;  background-image: none;'
                },
                type:'TextField',
                filters:{pfiltro:'pdr.codigo_columna',type:'string'},
                id_grupo:1,
                grid:true,
                form:true,
                egrid: true
            },
            {
                config:{
                    name: 'nombre_columna',
                    fieldLabel: 'Subtitulo',
                    allowBlank: false,
                    width: 300,
                    gwidth: 200,
                    style: 'background-color: #FFFACD;  background-image: none;'
                },
                type:'TextField',
                filters:{pfiltro:'pdr.nombre_columna',type:'string'},
                id_grupo:1,
                grid:true,
                form:true,
                egrid: true
            },
            {
                config:{
                    name: 'columna',
                    fieldLabel: 'Codigo',
                    qtip: 'Tomar en cuenta el alfabeto de A hasta Z </br>' +
                    'para porder hacer poperaciones con formulas',
                    allowBlank: true,
                    width: 80,
                    gwidth: 80,
                    style: 'background-color: #F0E68C;  background-image: none;'
                },
                type:'TextField',
                filters:{pfiltro:'pdr.columna',type:'string'},
                id_grupo:1,
                grid:true,
                egrid: true,
                form:true
            },
            {
                config: {
                    name: 'concepto',
                    fieldLabel: 'Nro. Cuenta',
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
                        remoteSort: true,
                        baseParams: {par_filtro:'nro_cuenta#nombre_cuenta#desc_cuenta','filtro_ges':'actual'}
                    }),
                    displayField: 'nro_cuenta',
                    valueField: 'nro_cuenta',
                    tpl: new Ext.XTemplate([
                        '<tpl for=".">',
                        '<div class="x-combo-list-item">',
                        '<div class="awesomecombo-item {checked}">',
                        '<p><b><span style="color: #800809;">{nro_cuenta}</span></b></p>',
                        '</div><p>&nbsp; &nbsp;&nbsp; &nbsp;{nombre_cuenta}</p>',
                        '</div></tpl>'
                    ]),
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
                        return String.format('{0}',record.data['concepto']);
                    }
                },
                type: 'AwesomeCombo',
                id_grupo: 1,
                grid: true,
                egrid: true,
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
                        remoteSort: true,
                        baseParams: {par_filtro:'codigo#nombre_partida','filtro_ges':'actual'}
                    }),
                    valueField: 'codigo',
                    displayField: 'nombre_partida',
                    tpl: new Ext.XTemplate([
                        '<tpl for=".">',
                        '<div class="x-combo-list-item">',
                        '<div class="awesomecombo-item {checked}">',
                        '<p><b><span style="color: #800809;">{codigo}</span></b></p>',
                        '</div><p>&nbsp; &nbsp;&nbsp; &nbsp;{nombre_partida}</p>',
                        '</div></tpl>'
                    ]),
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
                egrid: true,
                form: true
            },
            {
                config:{
                    name:'origen',
                    fieldLabel:'Tipo Saldo',
                    typeAhead: true,
                    allowBlank:true,
                    triggerAction: 'all',
                    emptyText:'Tipo...',
                    selectOnFocus:true,
                    mode:'local',
                    store:new Ext.data.ArrayStore({
                        fields: ['ID', 'valor'],
                        data :	[
                            ['debe','debe'],
                            ['haber','haber'],
                            ['saldo','saldo']
                        ]
                    }),
                    valueField:'ID',
                    displayField:'valor',
                    width: 250,
                    gwidth:100
                },
                type:'ComboBox',
                id_grupo:1,
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
                    width: 300,
                    gwidth: 200,
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
                    name:'formulario',
                    fieldLabel:'Formulario',
                    typeAhead: true,
                    allowBlank:true,
                    triggerAction: 'all',
                    emptyText:'Tipo...',
                    selectOnFocus:true,
                    mode:'local',
                    store:new Ext.data.ArrayStore({
                        fields: ['variable', 'valor'],
                        data :  [
                            ['impuesto_valor_agregado', 'FORMULARIO 200v3'],
                            ['impuesto_transacciones', 'FORMULARIO 400v3'],
                            ['iue_beneficiarios_exterior', 'FORMULARIO 530v2'],
                            ['retenciones', 'FORMULARIO 570v2'],
                            ['regimen_impuesto_valor_agregado', 'FORMULARIO 604v2'],
                            ['impuesto_transacciones_retenciones', 'FORMULARIO 410v2'],
                            ['impuesto_valor_agregado_agentes_retencion', 'FORMULARIO 608v2']
                        ]
                    }),
                    valueField:'variable',
                    displayField:'valor',
                    width: 300,
                    gwidth:100
                },
                type:'ComboBox',
                id_grupo:1,
                grid:true,
                egrid: true,
                form:true

            },
            {
                config: {
                    name: 'codigo_formulario',
                    fieldLabel: 'Codigo Formulario',
                    allowBlank: true,
                    emptyText: 'Elija una opción...',
                    store: new Ext.data.JsonStore({
                        url: '../../sis_contabilidad/control/DeclaracionesJuridicas/listarDeclaracionesCodigo',
                        id: 'fila',
                        root: 'datos',
                        sortInfo: {
                            field: 'fila',
                            direction: 'ASC'
                        },
                        totalProperty: 'total',
                        fields: ['codigo','descripcion','fila'],
                        remoteSort: true,
                        baseParams: {par_filtro: 'cd.codigo'}
                    }),
                    valueField: 'codigo',
                    displayField: 'codigo',
                    gdisplayField: 'codigo',
                    tpl: new Ext.XTemplate([
                        '<tpl for=".">',
                        '<div class="x-combo-list-item">',
                        '<div class="awesomecombo-item {checked}">',
                        '<p><span style="color: red;">{codigo}</span>&nbsp;&nbsp;<b>{descripcion}</b></p>',
                        '</div>',
                        '</div></tpl>'
                    ]),

                    forceSelection: true,
                    typeAhead: false,
                    triggerAction: 'all',
                    lazyRender: true,
                    mode: 'remote',
                    pageSize: 500,
                    queryDelay: 1000,
                    width: 300,
                    gwidth: 100,
                    minChars: 2,
                    enableMultiSelect: true,
                    renderer : function(value, p, record) {
                        return String.format('{0}', record.data['codigo_formulario']);
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
                    name:'tipo_periodo',
                    fieldLabel:'Tipo de periodo',
                    typeAhead: true,
                    allowBlank:true,
                    triggerAction: 'all',
                    emptyText:'Tipo...',
                    selectOnFocus:true,
                    mode:'local',
                    store:new Ext.data.ArrayStore({
                        fields: ['ID', 'valor'],
                        data :	[
                            ['normal','Normal'],
                            ['antes','Un periodo antes'],
                            ['despues','Un periodo despues']
                        ]
                    }),
                    valueField:'ID',
                    displayField:'valor',
                    width: 300,
                    valorInicial: 'normal',
                    gwidth:130
                },
                type:'ComboBox',
                id_grupo:1,
                grid:true,
                egrid: true,
                form:true
            },
            {
                config:{
                    name: 'apertura_cb',
                    fieldLabel: 'Incluir Apertura Cbte',
                    allowBlank: true,
                    width: 80,
                    gwidth: 80,
                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode: 'local',
                    store:['si','no']
                },
                type:'ComboBox',
                id_grupo:1,
                filters:{pfiltro:'pdr.apertura_cb',type:'string'},
                valorInicial: 'no',
                grid:true,
                egrid: true,
                form:true
            },
            {
                config:{
                    name: 'cierre_cb',
                    fieldLabel: 'Incluir Cierre Cbte',
                    allowBlank: true,
                    width: 80,
                    gwidth: 80,
                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode: 'local',
                    store:['si','no']
                },
                type:'ComboBox',
                id_grupo:1,
                filters:{pfiltro:'pdr.cierre_cb',type:'string'},
                valorInicial: 'no',
                grid:true,
                egrid: true,
                form:true
            },
            {
                config:{
                    name: 'saldo_inical',
                    fieldLabel: 'Saldo Inicial',
                    allowBlank: true,
                    width: 80,
                    gwidth: 80,
                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode: 'local',
                    store:['si','no']
                },
                type:'ComboBox',
                id_grupo:1,
                filters:{pfiltro:'pdr.saldo_inical',type:'string'},
                valorInicial: 'no',
                grid:true,
                egrid: true,
                form:true
            },
            {
                config:{
                    name: 'saldo_anterior',
                    fieldLabel: 'Saldo Anterior',
                    allowBlank: true,
                    width: 80,
                    gwidth: 80,
                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode: 'local',
                    store:['si','no']
                },
                type:'ComboBox',
                id_grupo:1,
                filters:{pfiltro:'pdr.saldo_anterior',type:'string'},
                valorInicial: 'no',
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
                filters:{pfiltro:'pdr.estado_reg',type:'string'},
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
                filters:{pfiltro:'pdr.usuario_ai',type:'string'},
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
                filters:{pfiltro:'pdr.fecha_reg',type:'date'},
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
                filters:{pfiltro:'pdr.id_usuario_ai',type:'numeric'},
                id_grupo:1,
                grid:false,
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
                filters:{pfiltro:'pdr.fecha_mod',type:'date'},
                id_grupo:1,
                grid:true,
                form:false
            }
        ],
        tam_pag:50,
        title:'Plantilla detalle reporte',
        ActSave:'../../sis_contabilidad/control/PlantillaDetReporte/insertarPlantillaDetReporte',
        ActDel:'../../sis_contabilidad/control/PlantillaDetReporte/eliminarPlantillaDetReporte',
        ActList:'../../sis_contabilidad/control/PlantillaDetReporte/listarPlantillaDetReporte',

        id_store:'id_plantilla_det_reporte',
        fields: [
            {name:'id_plantilla_det_reporte', type: 'numeric'},
            {name:'order_fila', type: 'string'},
            {name:'estado_reg', type: 'string'},
            {name:'concepto', type: 'string'},
            {name:'codigo_columna', type: 'string'},
            {name:'columna', type: 'string'},
            {name:'order', type: 'string'},
            {name:'id_plantilla_reporte', type: 'numeric'},
            {name:'formula', type: 'string'},
            {name:'partida', type: 'string'},
            {name:'usuario_ai', type: 'string'},
            {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
            {name:'id_usuario_reg', type: 'numeric'},
            {name:'id_usuario_ai', type: 'numeric'},
            {name:'id_usuario_mod', type: 'numeric'},
            {name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
            {name:'usr_reg', type: 'string'},
            {name:'usr_mod', type: 'string'},
            {name:'desc_cuenta', type: 'string'},
            {name:'origen', type: 'string'},
            {name:'desc_partida', type: 'string'},
            {name:'nombre_columna', type: 'string'},
            {name:'saldo_inical', type: 'string'},
            {name:'formulario', type: 'string'},
            {name:'codigo_formulario', type: 'string'},
            {name:'saldo_anterior', type: 'string'},
            {name:'operacion', type: 'string'},
            {name:'apertura_cb', type: 'string'},
            {name:'cierre_cb', type: 'string'},
            {name:'tipo_periodo', type: 'string'}

        ],
        sortInfo:{
            field: 'order_fila',
            direction: 'ASC'
        },
        bdel:true,
        bsave:true,
        fwidth: '26%',
        fheight: '75%',

        onReloadPage:function(m){
            this.maestro=m;
            this.store.baseParams = {id_plantilla_reporte: this.maestro.id_plantilla_reporte };
            this.load({params:{start:0, limit:50}})
        },
        loadValoresIniciales: function () {
            this.Cmp.id_plantilla_reporte.setValue(this.maestro.id_plantilla_reporte);
            Phx.vista.PlantillaDetReporte.superclass.loadValoresIniciales.call(this);
        },
        onButtonNew:function(){
            Phx.vista.PlantillaDetReporte.superclass.onButtonNew.call(this);
            //this.eventoCombo();
        },
        onButtonEdit:function(){
            Phx.vista.PlantillaDetReporte.superclass.onButtonEdit.call(this);
            //this.eventoCombo();
        }
        /*eventoCombo:function () {
            this.Cmp.operacion.on('select',function (cmp,rec) {
                if(this.Cmp.operacion.getValue() == 'titulo'){
                    this.inicarEventoComponet();
                }else if(this.Cmp.operacion.getValue() == 'formula'){
                    this.inicarEventoComponet();
                    this.mostrarComponente(this.Cmp.formula);
                }else if( this.Cmp.operacion.getValue() == 'resultado' || this.Cmp.operacion.getValue() == 'operacion'  ){
                    this.inicarEventoComponet();
                    this.mostrarComponente(this.Cmp.concepto);
                    this.mostrarComponente(this.Cmp.origen);
                    this.mostrarComponente(this.Cmp.partida);
                }else if(this.Cmp.operacion.getValue() == 'impuestos'){
                    this.inicarEventoComponet();
                    this.mostrarComponente(this.Cmp.formulario);
                    this.mostrarComponente(this.Cmp.codigo_formulario);
                }else if(this.Cmp.operacion.getValue() == 'subtitulo'){
                    this.inicarEventoComponet();
                }
            },this);
        },
        Clonar : function(){
            Phx.CP.loadingShow();
            var rec = this.sm.getSelected();
            var id_plantilla_det_reporte = rec.data.id_plantilla_det_reporte;
            Ext.Ajax.request({
                url:'../../sis_contabilidad/control/PlantillaDetReporte/clonarPlantillaDetReporte',
                params:{'id_plantilla_det_reporte':id_plantilla_det_reporte},
                success: this.successAuto,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });
        },
        successAuto:function(){
            Phx.CP.loadingHide();
            this.reload();
        },
        Grupos: [
            {
                layout: 'column',
                border: false,
                defaults: {
                    border: false
                },
                items: [
                    {
                        // bodyStyle: 'padding-left:10px;',
                        items: [
                            {
                                xtype: 'fieldset',
                                title: ' Datos Reporte ',
                                autoHeight: true,
                                items: [],
                                id_grupo: 1
                            }
                        ]
                    }
                ]
            }
        ],
        inicarEventoComponet:function () {

            this.ocultarComponente(this.Cmp.periodo);
            this.ocultarComponente(this.Cmp.concepto);
            this.ocultarComponente(this.Cmp.origen);
            this.ocultarComponente(this.Cmp.partida);
            this.ocultarComponente(this.Cmp.formulario);
            this.ocultarComponente(this.Cmp.codigo_formulario);
            this.ocultarComponente(this.Cmp.formula);
        }*/
    })
</script>
