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
                this.iniciarEventoOperacion();

                this.ocultarComponente(this.Cmp.concepto2);
                this.ocultarComponente(this.Cmp.partida2);
                this.ocultarComponente(this.Cmp.operacion);
                this.ocultarComponente(this.Cmp.origen2);
                this.addButton('Clonar',{argument: {imprimir: 'Clonar'},text:'<i class="fa fa-file-text-o fa-2x"></i> Clonar',/*iconCls:'' ,*/disabled:false,handler:this.Clonar});

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
                        name: 'codigo_columna',
                        fieldLabel: 'Codigo',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:100
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
                        name: 'order_fila',
                        fieldLabel: 'Orden',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 80,
                        maxLength:200
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
                        name: 'nombre_columna',
                        fieldLabel: 'Nombre Columna',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 200
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
                        fieldLabel: 'Columna',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 80,
                        maxLength:100
                    },
                    type:'TextField',
                    filters:{pfiltro:'pdr.columna',type:'string'},
                    id_grupo:1,
                    grid:true,
                    egrid: true,
                    form:true
                },
                {
                    config:{
                        name:'periodo',
                        fieldLabel:'Periodo',
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
                                ['un_mes_antes','Un mes antes'],
                                ['un_mes_despues','Un mes Después']
                            ]
                        }),
                        valueField:'ID',
                        displayField:'valor',
                        anchor: '50%',
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
                        name: 'calculo',
                        fieldLabel: 'Calculo',
                        allowBlank: true,
                        anchor: '40%',
                        gwidth: 50,
                        typeAhead: true,
                        triggerAction: 'all',
                        lazyRender:true,
                        mode: 'local',
                        store:['si','no']
                    },
                    type:'ComboBox',
                    id_grupo:1,
                    valorInicial: 'no',
                    grid:true,
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
                            // turn on remote sorting
                            remoteSort: true,
                            baseParams: {par_filtro:'nro_cuenta#nombre_cuenta#desc_cuenta','filtro_ges':'actual'}
                        }),
                        displayField: 'nro_cuenta',
                        valueField: 'nro_cuenta',
                        tpl: new Ext.XTemplate([
                            '<tpl for=".">',
                            '<div class="x-combo-list-item">',
                            '<div class="awesomecombo-item {checked}">',
                            '<p><span style="color: red;">{nro_cuenta}</span>&nbsp;&nbsp;<b>{nombre_cuenta}</b></p>',
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
                        anchor: '50%',
                        gwidth:200,
                        width: 350,
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
                    config:{
                        name:'origen',
                        fieldLabel:'Origen',
                        typeAhead: true,
                        allowBlank:true,
                        triggerAction: 'all',
                        emptyText:'Tipo...',
                        selectOnFocus:true,
                        mode:'local',
                        store:new Ext.data.ArrayStore({
                            fields: ['ID', 'valor'],
                            data :	[
                                ['debe','Debe'],
                                ['haber','Haber'],
                                ['saldo','Saldo']
                            ]
                        }),
                        valueField:'ID',
                        displayField:'valor',
                        anchor: '50%',
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
                            '<p><span style="color: red;">{codigo}</span>&nbsp;&nbsp;<b>{nombre_partida}</b></p>',
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
                        anchor: '50%',
                        gwidth:200,
                        width: 350,
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
                        name:'operacion',
                        fieldLabel:'Operacion',
                        typeAhead: true,
                        allowBlank:true,
                        triggerAction: 'all',
                        emptyText:'Tipo...',
                        selectOnFocus:true,
                        mode:'local',
                        store:new Ext.data.ArrayStore({
                            fields: ['ID', 'valor'],
                            data :	[
                                ['suma','suma'],
                                ['resta','resta'],
                                ['multiplicacion','multiplicación'],
                                ['division','división']
                            ]
                        }),
                        valueField:'ID',
                        displayField:'valor',
                        anchor: '50%',
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
                        name: 'concepto2',
                        fieldLabel: 'Nro. Cuenta 2',
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
                            // turn on remote sorting
                            remoteSort: true,
                            baseParams: {par_filtro:'nro_cuenta#nombre_cuenta#desc_cuenta','filtro_ges':'actual',sw_transaccional:'movimiento'}
                        }),
                        displayField: 'nro_cuenta',
                        valueField: 'nro_cuenta',
                        tpl: new Ext.XTemplate([
                            '<tpl for=".">',
                            '<div class="x-combo-list-item">',
                            '<div class="awesomecombo-item {checked}">',
                            '<p><span style="color: red;">{nro_cuenta}</span>&nbsp;&nbsp;<b>{nombre_cuenta}</b></p>',
                            '</div>',
                            '</div></tpl>'
                        ]),
                        style: 'background-color: #A6EFB3;  background-image: none;',
                        forceSelection: true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender: true,
                        mode: 'remote',
                        pageSize: 500,
                        queryDelay: 1000,
                        anchor: '50%',
                        gwidth:200,
                        width: 350,
                        minChars: 2,
                        enableMultiSelect: true,
                        renderer:function (value, p, record){
                            return String.format('{0}',record.data['concepto2']);
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
                        name:'origen2',
                        fieldLabel:'Origen 2',
                        typeAhead: true,
                        allowBlank:true,
                        triggerAction: 'all',
                        emptyText:'Tipo...',
                        selectOnFocus:true,
                        mode:'local',
                        store:new Ext.data.ArrayStore({
                            fields: ['ID', 'valor'],
                            data :	[
                                ['debe','Debe'],
                                ['haber','Haber'],
                                ['saldo','Saldo']
                            ]
                        }),
                        style: 'background-color: #A6EFB3;  background-image: none;',
                        valueField:'ID',
                        displayField:'valor',
                        anchor: '50%',
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
                        name: 'partida2',
                        fieldLabel: 'Partida 2',
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
                            baseParams: {par_filtro:'codigo#nombre_partida','filtro_ges':'actual',sw_transaccional:'movimiento'}
                        }),
                        valueField: 'codigo',
                        displayField: 'nombre_partida',
                        tpl: new Ext.XTemplate([
                            '<tpl for=".">',
                            '<div class="x-combo-list-item">',
                            '<div class="awesomecombo-item {checked}">',
                            '<p><span style="color: red;">{codigo}</span>&nbsp;&nbsp;<b>{nombre_partida}</b></p>',
                            '</div>',
                            '</div></tpl>'
                        ]),
                        style: 'background-color: #A6EFB3;  background-image: none;',
                        forceSelection: true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender: true,
                        mode: 'remote',
                        pageSize: 500,
                        queryDelay: 1000,
                        anchor: '50%',
                        gwidth:200,
                        width: 350,
                        minChars: 2,
                        enableMultiSelect: true,
                        renderer:function (value, p, record){
                            return String.format('{0}',record.data['partida2']);
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
                            data :  [    ['impuesto_valor_agregado', 'FORMULARIO 200v3'],
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
                        anchor: '50%',
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
                        // hiddenName: 'id_day_week',
                        forceSelection: true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender: true,
                        mode: 'remote',
                        pageSize: 500,
                        queryDelay: 1000,
                        anchor: '50%',
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
                        name: 'saldo_inical',
                        fieldLabel: 'Saldo Inicial',
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
                    filters:{pfiltro:'pdr.saldo_anterior',type:'string'},
                    valorInicial: 'no',
                    grid:true,
                    egrid: true,
                    form:true
                },
                {
                    config:{
                        name: 'formula',
                        fieldLabel: 'Regla',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100
                    },
                    type:'TextField',
                    filters:{pfiltro:'pdr.formula',type:'string'},
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
                {name:'calculo', type: 'string'},
                {name:'concepto2', type: 'string'},
                {name:'partida2', type: 'string'},
                {name:'operacion', type: 'string'},
                {name:'periodo', type: 'string'},
                {name:'origen2', type: 'string'}

            ],
            sortInfo:{
                field: 'order_fila',
                direction: 'ASC'
            },
            bdel:true,
            bsave:true,
            fwidth: '65%',
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
                var f = this.Cmp.formulario.getValue();
                Phx.vista.PlantillaDetReporte.superclass.onButtonNew.call(this);
                this.iniciarEvento();
                this.Cmp.codigo_formulario.store.baseParams ={par_filtro: 'cd.codigo',filtro:f};

            },
            iniciarEvento:function () {
                this.Cmp.codigo_formulario.lastQuery = null;
            },
            iniciarEventoOperacion:function () {

                this.Cmp.calculo.on('select',function(cmp,rec){
                    if(this.Cmp.calculo.getValue() == 'si'){
                        this.mostrarComponente(this.Cmp.concepto2);
                        this.mostrarComponente(this.Cmp.partida2);
                        this.mostrarComponente(this.Cmp.operacion);
                        this.mostrarComponente(this.Cmp.origen2);
                    }else{
                        this.ocultarComponente(this.Cmp.concepto2);
                        this.ocultarComponente(this.Cmp.partida2);
                        this.ocultarComponente(this.Cmp.operacion);
                        this.ocultarComponente(this.Cmp.origen2);
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
            }
        }
    )
</script>
