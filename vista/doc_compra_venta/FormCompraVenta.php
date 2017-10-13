<?php
/**
 *@package pXP
 *@file    FormCompraVenta.php
 *@author  Rensi Arteaga Copari
 *@date    30-01-2014
 *@description permites subir archivos a la tabla de documento_sol
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.FormCompraVenta=Ext.extend(Phx.frmInterfaz,{
        ActSave:'../../sis_contabilidad/control/DocCompraVenta/insertarDocCompleto',
        tam_pag: 10,
        tabEnter: true,
        codigoSistema: 'ADQ',
        mostrarFormaPago : true,
        mostrarPartidas: false,
        regitrarDetalle: 'si',
        id_moneda_defecto: 0,  // 0 quiere decir todas las monedas
        //layoutType: 'wizard',
        layout: 'fit',
        autoScroll: false,
        breset: false,
        heightHeader: 290,
        conceptos_eliminados: [],
        listadoConcepto: '../../sis_parametros/control/ConceptoIngas/listarConceptoIngasMasPartida',
        parFilConcepto:'desc_ingas#par.codigo',
        tipo_pres_gasto: 'gasto',
        tipo_pres_recurso: 'recurso',
        constructor:function(config)
        {
            this.addEvents('beforesave');
            this.addEvents('successsave');
            if (config.data.mostrarFormaPago === false) {
                this.mostrarFormaPago = config.data.mostrarFormaPago;
            }
            Ext.apply(this,config);
            this.obtenerVariableGlobal(config);
            this.generarAtributos();

        },

        constructorEtapa2:function(config)
        {
            if(this.regitrarDetalle == 'si'){
                this.buildComponentesDetalle();
                this.buildDetailGrid();
            }

            this.buildGrupos();


            Phx.vista.FormCompraVenta.superclass.constructor.call(this,config);

            this.init();


            this.iniciarEventos();

            if(this.regitrarDetalle == 'si'){
                this.iniciarEventosDetalle();
            }

            if(this.data.tipo_form == 'new'){
                this.onNew();
            }
            else{
                this.onEdit();
            }

            if(this.data.readOnly===true && this.regitrarDetalle == 'si'){
                for(var index in this.Cmp) {
                    if( this.Cmp[index].setReadOnly){
                        this.Cmp[index].setReadOnly(true);
                    }
                }
                this.megrid.getTopToolbar().disable();
            }
            this.Cmp.id_plantilla.store.baseParams = Ext.apply(this.Cmp.id_plantilla.store.baseParams, {tipo_plantilla:this.Cmp.tipo.getValue()});

        },
        buildComponentesDetalle: function(){
            var me = this,
                bpar = (me.data.tipoDoc=='compra')?{par_filtro: me.parFilConcepto, movimiento: 'gasto', autorizacion: me.autorizacion, autorizacion_nulos: me.autorizacion_nulos }:{par_filtro: me.parFilConcepto, movimiento: 'recurso'};
            me.detCmp = {
                'id_concepto_ingas': new Ext.form.ComboBox({
                    name: 'id_concepto_ingas',
                    msgTarget: 'title',
                    fieldLabel: 'Concepto',
                    allowBlank: false,
                    emptyText : 'Concepto...',
                    store : new Ext.data.JsonStore({
                        url: me.listadoConcepto,
                        id : 'id_concepto_ingas',
                        root: 'datos',
                        sortInfo:{
                            field: 'desc_ingas',
                            direction: 'ASC'
                        },
                        totalProperty: 'total',
                        fields: ['id_concepto_ingas','tipo','desc_ingas','movimiento','desc_partida','id_grupo_ots','filtro_ot','requiere_ot'],
                        remoteSort: true,
                        baseParams: bpar
                    }),
                    valueField: 'id_concepto_ingas',
                    displayField: 'desc_ingas',
                    hiddenName: 'id_concepto_ingas',
                    forceSelection: true,
                    typeAhead: false,
                    triggerAction: 'all',
                    listWidth: 500,
                    resizable: true,
                    lazyRender: true,
                    mode: 'remote',
                    pageSize: 10,
                    queryDelay: 1000,
                    minChars: 2,
                    qtip: 'Si el conceto de gasto que necesita no existe por favor  comuniquese con el área de presupuestos para solictar la creación',
                    tpl: '<tpl for="."><div class="x-combo-list-item"><p><b>{desc_ingas}</b></p><strong>{tipo}</strong><p>PARTIDA: {desc_partida}</p></div></tpl>',
                })
            };



            if(me.mostrarPartidas){
                Ext.apply(me.detCmp,{'desc_partida': new Ext.form.TextField({
                    name: 'desc_partida',
                    msgTarget: 'title',
                    fieldLabel: 'Partida',
                    allowBlank: true,
                    anchor: '80%',
                    maxLength:1200,
                    disabled : true
                })});
            }


            Ext.apply(me.detCmp,{
                'id_centro_costo': new Ext.form.ComboRec({
                    name:'id_centro_costo',
                    msgTarget: 'title',
                    origen:'CENTROCOSTO',
                    fieldLabel: 'Centro de Costos',
                    url: '../../sis_parametros/control/CentroCosto/listarCentroCostoFiltradoXDepto',
                    emptyText : 'Centro Costo...',
                    allowBlank: false,
                    baseParams: (me.data.tipoDoc == 'compra')?{tipo_pres:me.tipo_pres_gasto, filtrar:'grupo_ep'}:{tipo_pres: me.tipo_pres_recurso, filtrar:'grupo_ep'}
                }),

                'id_orden_trabajo': new Ext.form.ComboRec({
                    name:'id_orden_trabajo',
                    msgTarget: 'title',
                    sysorigen:'sis_contabilidad',
                    fieldLabel: 'Orden Trabajo',
                    origen:'OT',
                    baseParams: {tipo_pres: 'recurso'},
                    allowBlank:true
                }),

                'descripcion': new Ext.form.TextArea({
                    name: 'descripcion',
                    msgTarget: 'title',
                    fieldLabel: 'Descripcion',
                    allowBlank: false,
                    anchor: '80%',
                    maxLength:1200
                }),
                'cantidad_sol': new Ext.form.NumberField({
                    name: 'cantidad_sol',
                    msgTarget: 'title',
                    fieldLabel: 'Cantidad',
                    allowBlank: false,
                    allowDecimals: false,
                    maxLength:10
                }),
                'precio_unitario': new Ext.form.NumberField({
                    name: 'precio_unitario',
                    msgTarget: 'title',
                    currencyChar:' ',
                    fieldLabel: 'Prec. Unit.',
                    minValue: 0.0001,
                    allowBlank: false,
                    allowDecimals: true,
                    allowNegative:false,
                    decimalPrecision:2
                }),
                'precio_total': new Ext.form.NumberField({
                    name: 'precio_total',
                    msgTarget: 'title',
                    readOnly: true,
                    allowBlank: true
                }),
                'precio_total_final': new Ext.form.NumberField({
                    name: 'precio_total_final',
                    msgTarget: 'title',
                    readOnly: true,
                    allowBlank: true
                })


            });


        },

        calcularTotales: function(){
            var pTot = this.detCmp.cantidad_sol.getValue() * this.detCmp.precio_unitario.getValue();
            this.detCmp.precio_total.setValue(pTot);
            if(this.Cmp.porc_descuento.getValue() > 0){
                this.detCmp.precio_total_final.setValue(pTot - (pTot * this.Cmp.porc_descuento.getValue()));
            }
            else{
                this.detCmp.precio_total_final.setValue(pTot);
            }
        },

        iniciarEventosDetalle: function(){


            this.detCmp.precio_unitario.on('valid',function(field){
                this.calcularTotales()
            } ,this);

            this.detCmp.cantidad_sol.on('valid',function(field){
                this.calcularTotales()
            } ,this);



            this.detCmp.id_concepto_ingas.on('change',function( cmb, rec, ind){
                console.log('concepto_gasto ' + rec);
                this.detCmp.id_orden_trabajo.reset();
            },this);

            this.detCmp.id_concepto_ingas.on('select',function( cmb, rec, ind){
                console.log('concepto_gasto ' + rec);
                this.detCmp.id_orden_trabajo.store.baseParams = {
                    filtro_ot:rec.data.filtro_ot,
                    requiere_ot:rec.data.requiere_ot,
                    id_grupo_ots:rec.data.id_grupo_ots
                };
                this.detCmp.id_orden_trabajo.modificado = true;
                if(rec.data.requiere_ot =='obligatorio'){
                    this.detCmp.id_orden_trabajo.allowBlank = false;
                    this.detCmp.id_orden_trabajo.setReadOnly(false);
                }
                else{
                    this.detCmp.id_orden_trabajo.allowBlank = true;
                    this.detCmp.id_orden_trabajo.setReadOnly(true);
                }
                this.detCmp.id_orden_trabajo.reset();

                var idcc = this.detCmp.id_centro_costo.getValue();
                if(idcc){
                    this.checkRelacionConcepto({id_centro_costo: idcc , id_concepto_ingas: rec.data.id_concepto_ingas, id_gestion :  this.Cmp.id_gestion.getValue()});
                }

                if(this.mostrarPartidas){
                    this.detCmp.desc_partida.setValue(rec.data.desc_partida);
                }


            },this);


            this.detCmp.id_centro_costo.on('select',function( cmb, rec, ind){
                console.log('centro_costo ' + rec);
                var idc = this.detCmp.id_concepto_ingas.getValue();
                if(idc){
                    this.checkRelacionConcepto({id_centro_costo: rec.data.id_centro_costo , id_concepto_ingas: idc, id_gestion :  this.Cmp.id_gestion.getValue()});
                }

            },this);



        },

        onInitAdd: function(){
            if(this.data.readOnly===true){
                return false
            }

        },
        onCancelAdd: function(re,save){
            if(this.sw_init_add){
                this.mestore.remove(this.mestore.getAt(0));
            }

            this.sw_init_add = false;
            this.evaluaGrilla();

        },
        onUpdateRegister: function(){
            this.sw_init_add = false;

        },

        onAfterEdit:function(re, o, rec, num){
            //set descriptins values ...  in combos boxs
            console.log('edit ' + rec);
            var cmb_rec = this.detCmp['id_concepto_ingas'].store.getById(rec.get('id_concepto_ingas'));
            if(cmb_rec){
                rec.set('desc_concepto_ingas', cmb_rec.get('desc_ingas'));
            }

            var cmb_rec = this.detCmp['id_orden_trabajo'].store.getById(rec.get('id_orden_trabajo'));
            if(cmb_rec){
                rec.set('desc_orden_trabajo', cmb_rec.get('desc_orden'));
            }

            var cmb_rec = this.detCmp['id_centro_costo'].store.getById(rec.get('id_centro_costo'));
            if(cmb_rec){
                rec.set('desc_centro_costo', cmb_rec.get('codigo_cc'));
            }

        },

        evaluaRequistos: function(){
            //valida que todos los requistosprevios esten completos y habilita la adicion en el grid
            var i = 0;
            sw = true,
                me =this;
            while( i < me.Componentes.length) {

                if(me.Componentes[i] &&!me.Componentes[i].isValid()){
                    sw = false;
                    //i = this.Componentes.length;
                }
                i++;
            }
            return sw
        },

        bloqueaRequisitos: function(sw){
            this.Cmp.id_plantilla.setDisabled(sw);
            this.cargarDatosMaestro();

        },

        cargarDatosMaestro: function(){

            this.detCmp.id_orden_trabajo.store.baseParams.fecha_solicitud = this.Cmp.fecha.getValue().dateFormat('d/m/Y');
            this.detCmp.id_orden_trabajo.modificado = true;

            this.detCmp.id_centro_costo.store.baseParams.id_gestion = this.Cmp.id_gestion.getValue();
            this.detCmp.id_centro_costo.store.baseParams.codigo_subsistema = this.codigoSistema;
            this.detCmp.id_centro_costo.store.baseParams.id_depto = this.Cmp.id_depto_conta.getValue();

            if(this.data.id_uo){
                this.detCmp.id_centro_costo.store.baseParams.id_uo = this.data.id_uo;
            }
            this.detCmp.id_centro_costo.modificado = true;
            //cuando esta el la inteface de presupeustos no filtra por bienes o servicios
            this.detCmp.id_concepto_ingas.store.baseParams.movimiento=(this.Cmp.tipo.getValue()=='compra')?'gasto':'recurso';
            this.detCmp.id_concepto_ingas.store.baseParams.id_gestion=this.Cmp.id_gestion.getValue();
            this.detCmp.id_concepto_ingas.modificado = true;

        },

        evaluaGrilla: function(){
            //al eliminar si no quedan registros en la grilla desbloquea los requisitos en el maestro
            var  count = this.mestore.getCount();
            if(count == 0){
                this.bloqueaRequisitos(false);
            }
        },


        buildDetailGrid: function(){

            //cantidad,detalle,peso,totalo
            var Items = Ext.data.Record.create([{
                name: 'cantidad_sol',
                type: 'float'
            }, {
                name: 'id_concepto_ingas',
                type: 'int'
            }, {
                name: 'desc_partida',
                type: 'int'
            }, {
                name: 'id_centro_costo',
                type: 'int'
            }, {
                name: 'id_orden_trabajo',
                type: 'int'
            },{
                name: 'precio_unitario',
                type: 'float'
            },{
                name: 'precio_total',
                type: 'float'
            },{
                name: 'precio_total_final',
                type: 'float'
            }
            ]);

            this.mestore = new Ext.data.JsonStore({
                url: '../../sis_contabilidad/control/DocConcepto/listarDocConcepto',
                id: 'id_doc_concepto',
                root: 'datos',
                totalProperty: 'total',
                fields: ['id_doc_concepto','id_centro_costo','descripcion', 'precio_unitario',
                    'id_doc_compra_venta','id_orden_trabajo','id_concepto_ingas','precio_total','cantidad_sol',
                    'desc_centro_costo','desc_concepto_ingas','desc_orden_trabajo','precio_total_final', 'desc_partida'
                ],remoteSort: true,
                baseParams: {dir:'ASC',sort:'id_doc_concepto',limit:'50',start:'0'}
            });

            this.editorDetail = new Ext.ux.grid.RowEditor({
                saveText: 'Aceptar',
                name: 'btn_editor'

            });

            this.summary = new Ext.ux.grid.GridSummary();
            // al iniciar la edicion
            this.editorDetail.on('beforeedit', this.onInitAdd , this);

            //al cancelar la edicion
            this.editorDetail.on('canceledit', this.onCancelAdd , this);

            //al cancelar la edicion
            this.editorDetail.on('validateedit', this.onUpdateRegister, this);

            this.editorDetail.on('afteredit', this.onAfterEdit, this);




            this.columnasDet = [
                new Ext.grid.RowNumberer(),
                {
                    header: 'Concepto',
                    dataIndex: 'id_concepto_ingas',
                    width: 200,
                    sortable: false,
                    renderer:function(value, p, record){return String.format('{0}', record.data['desc_concepto_ingas']);},
                    editor: this.detCmp.id_concepto_ingas
                }]

            if(this.mostrarPartidas){
                this.columnasDet.push(
                    {
                        header: 'Partida',
                        dataIndex: 'desc_partida',
                        align: 'center',
                        width: 150,
                        renderer:function (value, p, record){return String.format('{0}', record.data['desc_partida']);},
                        editor: this.detCmp.desc_partida
                    });
            }


            this.columnasDet = this.columnasDet.concat([
                {

                    header: 'Centro de Costo',
                    dataIndex: 'id_centro_costo',
                    align: 'center',
                    width: 200,
                    renderer:function (value, p, record){return String.format('{0}', record.data['desc_centro_costo']);},
                    editor: this.detCmp.id_centro_costo
                },
                {

                    header: 'Orden de Trabajo',
                    dataIndex: 'id_orden_trabajo',
                    align: 'center',
                    width: 150,
                    renderer:function(value, p, record){return String.format('{0}', record.data['desc_orden_trabajo']?record.data['desc_orden_trabajo']:'');},
                    editor: this.detCmp.id_orden_trabajo
                },
                {

                    header: 'Descripción',
                    dataIndex: 'descripcion',

                    align: 'center',
                    width: 200,
                    editor: this.detCmp.descripcion
                },
                {

                    header: 'Cantidad',
                    dataIndex: 'cantidad_sol',
                    align: 'center',
                    width: 50,
                    summaryType: 'sum',
                    editor: this.detCmp.cantidad_sol
                },
                {

                    header: 'P / Unit',
                    dataIndex: 'precio_unitario',
                    align: 'center',
                    width: 50,
                    trueText: 'Yes',
                    falseText: 'No',
                    minValue: 0.001,
                    summaryType: 'sum',
                    editor: this.detCmp.precio_unitario
                },
                {
                    xtype: 'numbercolumn',
                    header: 'Importe Total',
                    dataIndex: 'precio_total',
                    format: '$0,0.00',
                    width: 75,
                    sortable: false,
                    summaryType: 'sum',
                    editor: this.detCmp.precio_total
                },
                {
                    xtype: 'numbercolumn',
                    header: 'Importe Neto',
                    dataIndex: 'precio_total_final',
                    format: '$0,0.00',
                    width: 75,
                    sortable: false,
                    summaryType: 'sum',
                    editor: this.detCmp.precio_total_final
                }]);


            this.megrid = new Ext.grid.GridPanel({
                layout: 'fit',
                store:  this.mestore,
                region: 'center',
                split: true,
                border: false,
                plain: true,
                //autoHeight: true,
                plugins: [ this.editorDetail, this.summary ],
                stripeRows: true,
                tbar: [{
                    /*iconCls: 'badd',*/
                    text: '<i class="fa fa-plus-circle fa-lg"></i> Agregar Concepto',
                    scope: this,
                    width: '100',
                    handler: function(){
                        if(this.evaluaRequistos() === true){

                            var e = new Items({
                                id_concepto_ingas: undefined,
                                cantidad_sol: 1,
                                descripcion: '',
                                precio_total: 0,
                                precio_total_final: 0,
                                precio_unitario: undefined
                            });
                            this.editorDetail.stopEditing();
                            this.mestore.insert(0, e);
                            this.megrid.getView().refresh();
                            this.megrid.getSelectionModel().selectRow(0);
                            this.editorDetail.startEditing(0);
                            this.sw_init_add = true;

                            this.bloqueaRequisitos(true);
                        }
                        else{
                            //alert('Verifique los requisitos');
                        }

                    }
                },{
                    ref: '../removeBtn',
                    text: '<i class="fa fa-trash fa-lg"></i> Eliminar',
                    scope:this,
                    handler: function(){
                        this.editorDetail.stopEditing();
                        var s = this.megrid.getSelectionModel().getSelections();
                        for(var i = 0, r; r = s[i]; i++){



                            // si se edita el documento y el concepto esta registrado, marcarlo para eliminar de la base
                            if(r.data.id_doc_concepto > 0){
                                this.conceptos_eliminados.push(r.data.id_doc_concepto);
                            }
                            this.mestore.remove(r);
                        }


                        this.evaluaGrilla();
                    }
                }],

                columns: this.columnasDet
            });
        },
        buildGrupos: function(){
            var me = this;
            if(me.regitrarDetalle == 'si'){
                me.Grupos = [{
                    layout: 'border',
                    border: false,
                    frame:  true,
                    items:[
                        {
                            xtype: 'fieldset',
                            border: false,
                            split: true,
                            layout: 'column',
                            region: 'north',
                            autoScroll: true,
                            collapseFirst : false,
                            collapsible: true,
                            collapseMode : 'mini',
                            width: '100%',
                            height: me.heightHeader,
                            padding: '0 0 0 10',
                            items:[
                                {
                                    bodyStyle: 'padding-right:5px;',
                                    width: '33%',
                                    autoHeight: true,
                                    border: true,
                                    items:[
                                        {
                                            xtype: 'fieldset',
                                            frame: true,
                                            border: false,
                                            layout: 'form',
                                            title: 'Tipo',
                                            width: '100%',

                                            //margins: '0 0 0 5',
                                            padding: '0 0 0 10',
                                            bodyStyle: 'padding-left:5px;',
                                            id_grupo: 0,
                                            items: [],
                                        }]
                                },
                                {
                                    bodyStyle: 'padding-right:5px;',
                                    width: '33%',
                                    border: true,
                                    autoHeight: true,
                                    items: [{
                                        xtype: 'fieldset',
                                        frame: true,
                                        layout: 'form',
                                        title: ' Datos básicos ',
                                        width: '100%',
                                        border: false,
                                        //margins: '0 0 0 5',
                                        padding: '0 0 0 10',
                                        bodyStyle: 'padding-left:5px;',
                                        id_grupo: 1,
                                        items: [],
                                    }]
                                },
                                {
                                    bodyStyle: 'padding-right:2px;',
                                    width: '33%',
                                    border: true,
                                    autoHeight: true,
                                    items: [{
                                        xtype: 'fieldset',
                                        frame: true,
                                        layout: 'form',
                                        title: 'Detalle de pago',
                                        width: '100%',
                                        border: false,
                                        padding: '0 0 0 10',
                                        bodyStyle: 'padding-left:2px;',
                                        id_grupo: 2,
                                        items: [],
                                    }]
                                }
                            ]
                        },
                        me.megrid
                    ]
                }];
            }
            else{
                me.Grupos = [{
                    xtype: 'fieldset',
                    border: false,
                    split: true,
                    layout: 'column',
                    autoScroll: true,
                    autoHeight: true,
                    collapseFirst : false,
                    collapsible: true,
                    collapseMode : 'mini',
                    width: '100%',
                    padding: '0 0 0 10',
                    items:[
                        {
                            bodyStyle: 'padding-right:5px;',
                            width: '33%',
                            autoHeight: true,
                            border: true,
                            items:[
                                {
                                    xtype: 'fieldset',
                                    frame: true,
                                    border: false,
                                    layout: 'form',
                                    title: 'Tipo',
                                    width: '100%',

                                    //margins: '0 0 0 5',
                                    padding: '0 0 0 10',
                                    bodyStyle: 'padding-left:5px;',
                                    id_grupo: 0,
                                    items: [],
                                }]
                        },
                        {
                            bodyStyle: 'padding-right:5px;',
                            width: '33%',
                            border: true,
                            autoHeight: true,
                            items: [{
                                xtype: 'fieldset',
                                frame: true,
                                layout: 'form',
                                title: ' Datos básicos ',
                                width: '100%',
                                border: false,
                                //margins: '0 0 0 5',
                                padding: '0 0 0 10',
                                bodyStyle: 'padding-left:5px;',
                                id_grupo: 1,
                                items: [],
                            }]
                        },
                        {
                            bodyStyle: 'padding-right:2px;',
                            width: '33%',
                            border: true,
                            autoHeight: true,
                            items: [{
                                xtype: 'fieldset',
                                frame: true,
                                layout: 'form',
                                title: 'Detalle de pago',
                                width: '100%',
                                border: false,
                                //margins: '0 0 0 5',
                                padding: '0 0 0 10',
                                bodyStyle: 'padding-left:2px;',
                                id_grupo: 2,
                                items: [],
                            }]
                        }
                    ]
                }];
            }




        },

        loadValoresIniciales:function()
        {

            Phx.vista.FormCompraVenta.superclass.loadValoresIniciales.call(this);



        },


        extraAtributos:[],
        generarAtributos: function(){
            var me = this;
            this.Atributos=[
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_doc_compra_venta'
                    },
                    type:'Field',
                    form:true
                },
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_solicitud_efectivo'
                    },
                    type:'Field',
                    form:true
                },
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_gestion'
                    },
                    type:'Field',
                    form:true
                },
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'tipo'
                    },
                    type:'Field',
                    form:true
                },
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'porc_descuento',
                        allowDecimals: true,
                        decimalPrecision: 10
                    },
                    type: 'NumberField',
                    form: true
                },
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'porc_descuento_ley',
                        allowDecimals: true,
                        decimalPrecision: 10
                    },
                    type:'NumberField',
                    form:true
                },
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'porc_iva_cf',
                        allowDecimals: true,
                        decimalPrecision: 10
                    },
                    type:'NumberField',
                    form:true
                },
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'porc_iva_df',
                        allowDecimals: true,
                        decimalPrecision: 10
                    },
                    type:'NumberField',
                    form:true
                },
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'porc_it',
                        allowDecimals: true,
                        decimalPrecision: 10
                    },
                    type:'NumberField',
                    form:true
                },
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'porc_ice',
                        allowDecimals: true,
                        decimalPrecision: 10
                    },
                    type:'NumberField',
                    form:true
                },
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'tipo_excento',
                        allowDecimals: true,
                        decimalPrecision: 10
                    },
                    type: 'TextField',
                    form: true
                },
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'valor_excento',
                        allowDecimals: true,
                        decimalPrecision: 10
                    },
                    type: 'NumberField',
                    form: true
                },

                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_depto_conta'
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
                        maxLength:3
                    },
                    type: 'TextField',
                    id_grupo: 1,
                    form: false
                },

                {
                    config:{
                        name: 'id_plantilla',
                        fieldLabel: 'Tipo Documento',
                        allowBlank: false,
                        emptyText:'Elija una plantilla...',
                        store:new Ext.data.JsonStore(
                            {
                                url: '../../sis_parametros/control/Plantilla/listarPlantilla',
                                id: 'id_plantilla',
                                root:'datos',
                                sortInfo:{
                                    field:'desc_plantilla',
                                    direction:'ASC'
                                },
                                totalProperty:'total',
                                fields: ['id_plantilla','nro_linea','desc_plantilla','tipo',
                                    'sw_tesoro', 'sw_compro','sw_monto_excento','sw_descuento',
                                    'sw_autorizacion','sw_codigo_control','tipo_plantilla','sw_nro_dui','sw_ic','tipo_excento','valor_excento','sw_qr','sw_nit','plantilla_qr',
                                    'sw_estacion','sw_punto_venta','sw_codigo_no_iata'],
                                remoteSort: true,
                                baseParams:{par_filtro:'plt.desc_plantilla',sw_compro:'si',sw_tesoro:'si'}
                            }),
                        tpl:'<tpl for="."><div class="x-combo-list-item"><p>{desc_plantilla}</p></div></tpl>',
                        valueField: 'id_plantilla',
                        hiddenValue: 'id_plantilla',
                        displayField: 'desc_plantilla',
                        gdisplayField:'desc_plantilla',
                        listWidth:'280',
                        forceSelection:true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender:true,
                        mode:'remote',
                        pageSize:20,
                        queryDelay:500,
                        minChars:2
                    },
                    type:'ComboBox',
                    id_grupo: 0,
                    form: true
                },

                {
                    config:{
                        name: 'codigo_qr',
                        fieldLabel: 'QR',
                        allowBlank: true,
                        enableKeyEvents: true,
                        anchor: '80%',
                        maxLength:180
                    },
                    type:'TextField',
                    id_grupo:0,
                    form:true
                },


                {
                    config:{
                        name:'id_moneda',
                        origen:'MONEDA',
                        allowBlank:false,
                        baseParams: {id_moneda_defecto: me.id_moneda_defecto},
                        fieldLabel:'Moneda',
                        gdisplayField:'desc_moneda',
                        gwidth:100,
                        width:180
                    },
                    type:'ComboRec',
                    id_grupo:0,
                    form:true
                },
                {
                    config:{
                        name: 'dia',
                        fieldLabel: 'Dia',
                        allowBlank: true,
                        allowNEgative: false,
                        allowDecimal: false,
                        maxValue: 31,
                        minValue: 1,
                        width: 40
                    },
                    type:'NumberField',
                    id_grupo:0,
                    form: true
                },

                {
                    config:{
                        name: 'fecha',
                        fieldLabel: 'Fecha',
                        allowBlank: false,
                        anchor: '80%',
                        format: 'd/m/Y',
                        readOnly:true,
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
                    },
                    type:'DateField',
                    id_grupo:0,
                    form:true
                },
                {
                    config:{
                        name: 'nro_autorizacion',
                        fieldLabel: 'Autorización',
                        allowBlank: false,
                        emptyText:'autorización ...',
                        store:new Ext.data.JsonStore(
                            {
                                url: '../../sis_contabilidad/control/DocCompraVenta/listarNroAutorizacion',
                                id: 'nro_autorizacion',
                                root:'datos',
                                sortInfo:{
                                    field:'nro_autorizacion',
                                    direction:'ASC'
                                },
                                totalProperty:'total',
                                fields: ['nro_autorizacion','nit','razon_social'],
                                remoteSort: true
                            }),
                        valueField: 'nro_autorizacion',
                        hiddenValue: 'nro_autorizacion',
                        displayField: 'nro_autorizacion',
                        queryParam: 'nro_autorizacion',
                        listWidth:'280',
                        forceSelection:false,
                        autoSelect: false,
                        hideTrigger:true,
                        typeAhead: false,
                        typeAheadDelay: 75,
                        lazyRender:false,
                        mode:'remote',
                        pageSize:20,
                        width: 200,
                        boxMinWidth: 200,
                        queryDelay:500,
                        minChars:1,
                        maskRe: /[0-9/-]+/i,
                        regex: /[0-9/-]+/i
                    },
                    type:'ComboBox',
                    id_grupo: 0,
                    form: true
                },

                {
                    config:{
                        name: 'nit',
                        fieldLabel: 'NIT',
                        qtip: 'Número de indentificación del proveedor',
                        allowBlank: false,
                        emptyText:'nit ...',
                        store:new Ext.data.JsonStore(
                            {
                                url: '../../sis_contabilidad/control/DocCompraVenta/listarNroNit',
                                id: 'nit',
                                root:'datos',
                                sortInfo:{
                                    field:'nit',
                                    direction:'ASC'
                                },
                                totalProperty:'total',
                                fields: ['nit','razon_social'],
                                remoteSort: true
                            }),
                        valueField: 'nit',
                        hiddenValue: 'nit',
                        displayField: 'nit',
                        gdisplayField:'nit',
                        queryParam: 'nit',
                        listWidth:'280',
                        forceSelection:false,
                        autoSelect: false,
                        typeAhead: false,
                        typeAheadDelay: 75,
                        hideTrigger:true,
                        triggerAction: 'query',
                        lazyRender:false,
                        mode:'remote',
                        pageSize:20,
                        queryDelay:500,
                        anchor: '80%',
                        minChars:1
                    },
                    type:'ComboBox',
                    id_grupo: 0,
                    form: true
                },


                {
                    config:{
                        name: 'razon_social',
                        fieldLabel: 'Razón Social',
                        allowBlank: false,
                        maskRe: /[A-Za-z0-9 &-. ñ Ñ]/,
                        fieldStyle: 'text-transform:uppercase',
                        listeners:{
                            'change': function(field, newValue, oldValue){

                                field.suspendEvents(true);
                                field.setValue(newValue.toUpperCase());
                                field.resumeEvents(true);
                            }
                        },
                        anchor: '80%',
                        maxLength:180
                    },
                    type:'TextField',
                    id_grupo:0,
                    form:true
                },
                {
                    config:{
                        name: 'nro_documento',
                        fieldLabel: 'Nro Factura / Doc',
                        allowBlank: false,
                        anchor: '80%',
                        allowDecimals: false,
                        maxLength:100,
                        maskRe: /[0-9/-]+/i,
                        regex: /[0-9/-]+/i


                    },
                    type:'NumberField',
                    id_grupo:1,
                    form:true
                },
                {
                    config:{
                        name: 'nro_dui',
                        fieldLabel: 'DUI',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength :16,
                        minLength:9,
                        listeners:{
                            'change': function(field, newValue, oldValue){

                                field.suspendEvents(true);
                                field.setValue(newValue.toUpperCase());
                                field.resumeEvents(true);
                            }
                        },
                    },
                    type:'TextField',
                    id_grupo:1,
                    form:true
                },
                {
                    config:{
                        name: 'codigo_control',
                        fieldLabel: 'Código de Control',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        enableKeyEvents: true,
                        fieldStyle : 'text-transform: uppercase',
                        maxLength:200,
                        validator: function(v) {
                            return /^0|^([A-Fa-f0-9]{2,2}\-)*[A-Fa-f0-9]{2,2}$/i.test(v)? true : 'Introducir texto de la forma xx-xx, donde x representa dígitos  hexadecimales  [0-9]ABCDEF.';
                        },
                        maskRe: /[0-9ABCDEF/-]+/i,
                        regex: /[0-9ABCDEF/-]+/i
                    },
                    type:'TextField',
                    id_grupo:1,
                    form:true
                },
                {
                    config:{
                        name: 'estacion',
                        fieldLabel: 'Estacion',
                        qtip: 'Estacion donde se encentra el punto de venta y la agencia',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 120,
                        typeAhead: true,
                        triggerAction: 'all',
                        lazyRender: true,
                        mode: 'local',
                        store: ['CBB','LPB','SRZ','CIJ','TJA','POI','ORU','TDD','SRE','UYU', 'CCA', 'RIB', 'RBQ', 'GYA', 'BYC']
                    },
                    type:'ComboBox',
                    id_grupo:1,
                    filters:{
                        type: 'list',
                        options: ['CBB','LPB','SRZ','CIJ','TJA','POI','ORU','TDD','SRE','UYU', 'CCA', 'RIB', 'RBQ', 'GYA', 'BYC']
                    },
                    grid:true,
                    egrid: true,
                    form:true
                },
                {
                    config:{
                        name: 'id_punto_venta',
                        fieldLabel: 'Punto de Venta/Agencia IATA',
                        allowBlank: true,
                        emptyText:'Elija un punto de venta...',
                        store:new Ext.data.JsonStore(
                            {
                                url: '../../sis_ventas_facturacion/control/PuntoVenta/listarPuntoVenta',
                                id: 'id_punto_venta',
                                root:'datos',
                                sortInfo:{
                                    field:'codigo',
                                    direction:'ASC'
                                },
                                totalProperty:'total',
                                fields: ['id_punto_venta','nombre','codigo'],
                                remoteSort: true,
                                baseParams:{par_filtro:'puve.nombre#puve.codigo'}
                            }),
                        tpl:'<tpl for="."><div class="x-combo-list-item"><p>{nombre}</p><p>{codigo}</p></div></tpl>',
                        valueField: 'id_punto_venta',
                        hiddenValue: 'id_punto_venta',
                        displayField: 'nombre',
                        gdisplayField:'nombre',
                        listWidth:'280',
                        forceSelection:true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender:true,
                        mode:'remote',
                        pageSize:20,
                        queryDelay:500,
                        minChars:2
                    },
                    type:'ComboBox',
                    id_grupo: 1,
                    form: true
                },
                {
                    config:{
                        name: 'id_agencia',
                        fieldLabel: 'Agencia IATA/Agencia No IATA',
                        allowBlank: true,
                        emptyText:'Elija una agencia...',
                        store:new Ext.data.JsonStore(
                            {
                                url: '../../sis_obingresos/control/Agencia/listarAgencia',
                                id: 'id_agencia',
                                root:'datos',
                                sortInfo:{
                                    field:'codigo_noiata',
                                    direction:'ASC'
                                },
                                totalProperty:'total',
                                fields: ['id_agencia','nombre','codigo_noiata','codigo','tipo_agencia'],
                                remoteSort: true,
                                baseParams:{par_filtro:'age.nombre#age.codigo_noiata#age.codigo#age.tipo_agencia', tipo_agencia: ''}
                            }),
                        tpl:'<tpl for="."><div class="x-combo-list-item"><p>{nombre}</p><p>Codigo IATA: {codigo}</p><p>Codigo NO IATA: {codigo_noiata}</p></div></tpl>',
                        valueField: 'id_agencia',
                        hiddenValue: 'id_agencia',
                        displayField: 'nombre',//codigo_noiata
                        gdisplayField:'nombre',//codigo_noiata
                        listWidth:'280',
                        forceSelection:true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender:true,
                        mode:'remote',
                        pageSize:20,
                        queryDelay:500,
                        minChars:2
                    },
                    type:'ComboBox',
                    id_grupo: 1,
                    form: true
                },
                {
                    config:{
                        name: 'obs',
                        fieldLabel: 'Obs',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength: 400
                    },
                    type:'TextArea',
                    id_grupo:1,
                    bottom_filter: true,
                    form: true
                },
                {
                    config:{
                        name: 'importe_doc',
                        fieldLabel: 'Monto',
                        allowBlank: false,
                        allowNegative :false,
                      
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:1179650
                    },
                    type:'NumberField',
                    id_grupo:2,
                    form:true
                },
                {
                    config:{
                        name: 'importe_descuento',
                        fieldLabel: 'Descuento',
                        allowBlank: true,
                        allowNegative :false,
                        anchor: '80%',
                        gwidth: 100
                    },
                    type:'NumberField',
                    id_grupo:2,
                    form:true
                },
                {
                    config:{
                        name: 'importe_neto',
                        qtip: 'Importe del documento menos descuentos, sobre este monto se calcula el iva',
                        fieldLabel: 'Monto Neto',
                        allowBlank: false,
                        allowNegative :false,
                        readOnly: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:1179650
                    },
                    type:'NumberField',
                    id_grupo:2,
                    form:true
                },
                {
                    config:{
                        name: 'importe_excento',
                        qtip: 'sobre el importe ento, ¿que monto es exento de impuestos?',
                        fieldLabel: 'Exento',
                        allowNegative :false,
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100
                    },
                    type: 'NumberField',
                    id_grupo:2,
                    form: true
                },
                {
                    config:{
                        name: 'importe_pendiente',
                        fieldLabel:  (me.data.tipoDoc == 'compra')?'Cuentas por  Pagar':'Cuentas por Cobrar',
                        qtip: 'Usualmente una cuenta pendiente de  cobrar o  pagar, si la cuenta se aplica posterior a la emisión del documento',
                        allowBlank: true,
                        allowNegative :false,
                        anchor: '80%',
                        gwidth: 100
                    },
                    type:'NumberField',
                    filters:{pfiltro:'dcv.importe_pendiente',type:'numeric'},
                    id_grupo:2,
                    form:true
                },
                {
                    config:{
                        name: 'importe_anticipo',
                        fieldLabel: 'Anticipo',
                        qtip: 'Importe pagado por anticipado al documento',
                        allowBlank: true,
                        allowNegative :false,
                        anchor: '80%'
                    },
                    type:'NumberField',
                    filters: { pfiltro: 'dcv.importe_anticipo', type: 'numeric' },
                    id_grupo: 2,
                    form: true
                },
                {
                    config:{
                        name: 'importe_retgar',
                        fieldLabel: 'Ret. Garantia',
                        qtip: 'Importe retenido por garantia',
                        allowBlank: true,
                        allowNegative: false,
                        anchor: '80%'
                    },
                    type: 'NumberField',
                    filters: { pfiltro:'dcv.importe_retgar',type:'numeric'},
                    id_grupo: 2,
                    form: true
                },
                {
                    config:{
                        sysorigen: 'sis_contabilidad',
                        name: 'id_auxiliar',
                        origen: 'AUXILIAR',
                        readOnly: true,
                        allowBlank: true,
                        fieldLabel: 'Cuenta Corriente',
                        baseParams :  {corriente: 'si'},
                        gdisplayField: 'codigo_auxiliar',//mapea al store del grid
                        anchor: '80%',
                        listWidth: 350
                    },
                    type: 'ComboRec',
                    id_grupo: 2,
                    form: true
                },
                {
                    config:{
                        name: 'importe_descuento_ley',
                        fieldLabel: 'Descuentos de Ley',
                        allowBlank: true,
                        readOnly:true,
                        anchor: '80%',
                        allowNegative :false,
                        gwidth: 100
                    },
                    type:'NumberField',
                    id_grupo:2,
                    form:true
                },
                {
                    config:{
                        name: 'importe_ice',
                        fieldLabel: 'ICE',
                        allowBlank: true,
                        allowNegative :false,
                        anchor: '80%',
                        gwidth: 100
                    },
                    type:'NumberField',
                    id_grupo:2,
                    form:true
                },
                {
                    config:{
                        name: 'importe_iva',
                        fieldLabel: 'IVA',
                        allowBlank: true,
                        readOnly:true,
                        allowNegative :false,
                        anchor: '80%',
                        gwidth: 100
                    },
                    type: 'NumberField',
                    id_grupo: 2,
                    form: true
                },
                {
                    config:{
                        name: 'importe_it',
                        fieldLabel: 'IT',
                        allowBlank: true,
                        allowNegative :false,
                        anchor: '80%',
                        readOnly:true,
                        gwidth: 100
                    },
                    type:'NumberField',
                    id_grupo:2,
                    form: true
                },
                {
                    config:{
                        name: 'importe_pago_liquido',
                        fieldLabel: 'Liquido Pagado',
                        allowBlank: true,
                        allowNegative :false,
                        readOnly:true,
                        anchor: '80%',
                        gwidth: 100
                    },
                    type:'NumberField',
                    id_grupo:2,
                    form: true
                }

            ];

            this.Atributos = this.Atributos.concat(me.extraAtributos);

        },
        title: 'Frm solicitud',
        iniciarEventos: function(){

            this.Cmp.dia.on('change',function( cmp, newValue, oldValue){
                var dia =  newValue>9?newValue:'0'+newValue,
                    mes =  this.data.tmpPeriodo>9?this.data.tmpPeriodo:'0'+this.data.tmpPeriodo,
                    tmpFecha = dia+'/'+mes+'/'+this.data.tmpGestion;
                resp = this.Cmp.fecha.setValue(tmpFecha);
            }, this);

            this.Cmp.nro_autorizacion.on('select', function(cmb,rec,i){

                if(this.data.tipoDoc == 'compra'){
                    this.Cmp.nit.setValue(rec.data.nit);
                    this.Cmp.razon_social.setValue(rec.data.razon_social);///
                }

            } ,this);


            this.Cmp.nro_autorizacion.on('change', function(cmb,newval,oldval){
                var rec = cmb.getStore().getById(newval)
                if(!rec){
                    //si el combo no tiene resultado
                    if(cmb.lastQuery){
                        //y se tiene una consulta anterior( cuando editemos no abra cnsulta anterior)
                        this.Cmp.nit.reset();
                        this.Cmp.razon_social.reset();
                    }
                }

            } ,this);


            this.Cmp.nit.on('select', function(cmb,rec,i){
                this.Cmp.razon_social.setValue(rec.data.razon_social);
            } ,this);

            this.Cmp.nit.on('change', function(cmb,newval,oldval){
                var rec = cmb.getStore().getById(newval);
                if(!rec){
                    //si el combo no tiene resultado
                    if(cmb.lastQuery){
                        //y se tiene una consulta anterior( cuando editemos no abra cnsulta anterior)
                        this.Cmp.razon_social.reset();
                    }
                }

            } ,this);




            //this.Cmp.nro_autorizacion .on('blur',this.cargarRazonSocial,this);
            this.Cmp.id_plantilla.on('select',function(cmb,rec,i){
                console.log('id_plantilla ' + rec);
                this.esconderImportes();
                //si es el formulario para nuevo reseteamos los valores ...
                if(this.accionFormulario == 'NEW'){

                    this.iniciarImportes();
                    this.Cmp.importe_excento.reset();
                    this.Cmp.nro_autorizacion.reset();
                    this.Cmp.codigo_control.reset();
                    this.Cmp.importe_descuento.reset();

                }
                else{
                    //calcula porcentaje descuento
                    this.Cmp.porc_descuento.setValue(this.Cmp.importe_descuento.getValue()/this.Cmp.importe_doc.getValue());
                }

                this.getDetallePorAplicar(rec.data.id_plantilla);
                if(rec.data.sw_monto_excento=='si'){
                    this.mostrarComponente(this.Cmp.importe_excento);
                    this.Cmp.tipo_excento.setValue(rec.data.tipo_excento);
                    this.Cmp.valor_excento.setValue(rec.data.valor_excento);
                    if(rec.data.tipo_excento == 'variable'){
                        this.Cmp.importe_excento.setReadOnly(false);
                    }else{
                        this.Cmp.importe_excento.setReadOnly(true);
                    }

                }
                else{
                    this.ocultarComponente(this.Cmp.importe_excento);
                    this.Cmp.importe_excento.setReadOnly(false);
                    this.Cmp.tipo_excento.setValue('variable');
                    this.Cmp.importe_excento.setValue(0);
                    this.Cmp.valor_excento.setValue(0);

                }

                if(rec.data.sw_descuento=='si'){
                    this.mostrarComponente(this.Cmp.importe_descuento);
                    this.mostrarComponente(this.Cmp.importe_neto);
                }
                else{
                    this.ocultarComponente(this.Cmp.importe_descuento);
                    this.ocultarComponente(this.Cmp.importe_neto);

                    this.Cmp.porc_descuento.setValue(0);
                    this.Cmp.importe_descuento.setValue(0);
                }

                if(rec.data.sw_autorizacion == 'si'){
                    this.mostrarComponente(this.Cmp.nro_autorizacion);
                }
                else{
                    this.ocultarComponente(this.Cmp.nro_autorizacion);
                }

                if(rec.data.sw_nit == 'si'){
                    this.mostrarComponente(this.Cmp.nit);
                }
                else{
                    this.ocultarComponente(this.Cmp.nit);
                }

                if(rec.data.sw_qr == 'si' && rec.data.plantilla_qr != ''){
                    this.mostrarComponente(this.Cmp.codigo_qr);
                    this.plantilla_qr = rec.data.plantilla_qr;
                }
                else{
                    this.ocultarComponente(this.Cmp.codigo_qr);
                }

                if(rec.data.sw_codigo_control == 'si'){
                    this.mostrarComponente(this.Cmp.codigo_control);
                }
                else{
                    this.ocultarComponente(this.Cmp.codigo_control);
                }




                if(rec.data.sw_nro_dui == 'si'){
                    this.Cmp.nro_dui.allowBlank =false;
                    this.mostrarComponente(this.Cmp.nro_dui);
                    this.Cmp.nro_documento.setValue(0);
                    this.Cmp.nro_documento.setReadOnly(true);

                }
                else{
                    this.Cmp.nro_dui.allowBlank = true;
                    this.ocultarComponente(this.Cmp.nro_dui);
                    this.Cmp.nro_documento.setReadOnly(false);
                }
                if(rec.data.sw_estacion == 'si'){
                    this.mostrarComponente(this.Cmp.estacion);//en
                }
                else{
                    this.ocultarComponente(this.Cmp.estacion);
                    this.Cmp.estacion.reset();
                }
                if(rec.data.sw_punto_venta == 'si'){
                    this.ocultarComponente(this.Cmp.id_punto_venta);// modificado
                }
                else{
                    this.ocultarComponente(this.Cmp.id_punto_venta);
                    this.Cmp.id_punto_venta.reset();
                }
                if(rec.data.sw_codigo_no_iata == 'si'){
                    this.mostrarComponente(this.Cmp.id_agencia);
                }
                else{
                    this.ocultarComponente(this.Cmp.id_agencia);
                    this.Cmp.id_agencia.reset();
                }
            },this);

            this.Cmp.importe_doc.on('change',this.calculaMontoPago,this);
            this.Cmp.importe_excento.on('change',this.calculaMontoPago,this);
            this.Cmp.importe_descuento.on('change',this.calculaMontoPago,this);
            this.Cmp.importe_descuento_ley.on('change',this.calculaMontoPago,this);

            this.Cmp.importe_pendiente.on('change',this.calculaMontoPago,this);
            this.Cmp.importe_anticipo.on('change',this.calculaMontoPago,this);
            this.Cmp.importe_retgar.on('change',this.calculaMontoPago,this);


            this.Cmp.nro_autorizacion.on('change',function(fild, newValue, oldValue){
                if (newValue[3] == '4' || newValue[3] == '8'|| newValue[3] == '6'){
                    this.mostrarComponente(this.Cmp.codigo_control);
                    this.Cmp.codigo_control.allowBlank = false;
                }
                else{
                    this.Cmp.codigo_control.allowBlank = true;
                    this.Cmp.codigo_control.setValue('0');
                    this.ocultarComponente(this.Cmp.codigo_control);

                };

            },this);

            this.Cmp.codigo_control.on('keyup',function(cmp, e){
                //inserta guiones en codigo de contorl
                var value = cmp.getValue(), tmp='',tmp2='',sw = 0;
                tmp = value.replace(/-/g, '');
                for(var i = 0; i< tmp.length; i++){
                    tmp2 = tmp2 + tmp[i];
                    if( (i+1)%2 == 0 && i!= tmp.length-1){
                        tmp2 = tmp2 + '-';
                    }
                }
                cmp.setValue(tmp2.toUpperCase());
            },this);



            this.Cmp.codigo_qr.on('specialkey',function(cmb, e){

              if(e.getKey() == e.ENTER) {
                   var res = cmb.getValue().split("|"),
                       plt = this.plantilla_qr.split("|");

                   console.log('........', res, plt);

                 //if(res.length == 12) {

                     for (var i = 0; i < plt.length; i++) {

                         if (this.Cmp[plt[i]]) {

                             if (plt[i] == 'importe_excento') {
                                 var aux = 0;
                                 if (this.Cmp[plt[i]].getValue()) {
                                     aux = this.Cmp[plt[i]].getValue();
                                 }
                                 this.Cmp[plt[i]].setValue(res[i] + aux);
                                 console.log(res[i], aux)
                             }
                             else {
                                 this.Cmp[plt[i]].setValue(res[i]);
                             }

                             if (plt[i] == 'nit') {
                                 this.cargarRazonSocial();
                             }
                             if (plt[i]=='nro_documento'){
                                 var nro_doc = Math.floor(res[1]);
                                 this.getComponente('nro_documento').setValue(nro_doc);
                             }
                             if(plt[i]=='importe_doc'){

                                 var importe = this.controlMiles(res[4]);
                                 this.getComponente('importe_doc').setValue(importe);

                             }
                             if(plt[i]=='fecha'){

                                 var mesPeriodo = this.data.tmpPeriodo > 9 ? this.data.tmpPeriodo : '0' + this.data.tmpPeriodo;
                                 var fechaInt = this.data.tmpGestion + '-' + mesPeriodo + '-' + '30';
                                 var mesPer = new Date(fechaInt).getMonth();
                                 var mesFactura = res[3].split("/");
                                 var fechaFac = mesFactura[2] + '-' + mesFactura[1] + '-' + mesFactura[0];
                                 var mesFac = new Date(fechaFac).getMonth();
                                 var monthNames = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Mayo",
                                     "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"
                                 ];
                                 var literalFactura = monthNames[mesFac];
                                 var literalPeriodo = monthNames[mesPer];
                                 if (mesFactura[1] != mesPeriodo) {
                                     this.mensaje_('ALERTA', 'Actualmente se encuentra en el periodo: ' + literalPeriodo + ', la factura corresponde al periodo de: ' + literalFactura, 'ERROR');
                                 }

                             }

                         }
                         console.log(plt[i]);
                     }
                // }
                   }
                    // else{
                    // 	alert('la plantilla de array no se corresponde con el QR');
                    //  }

                    this.calculaMontoPago();


                //}


            },this);






        },

        resetearMontos: function(){
            this.Cmp.importe_doc.setValue(0);
            this.Cmp.importe_neto.setValue(0);
            this.Cmp.importe_pago_liquido.setValue(0);
            this.iniciarImportes();
        },

        calculaMontoPago:function(){

            var me = this,
                descuento_ley = 0.00;

            if(this.Cmp.importe_descuento.getValue() > 0 ){
                if( this.Cmp.importe_descuento.getValue() > this.Cmp.importe_doc.getValue()){
                    alert("el descuento no puede ser mayor que monto del documento");
                    this.resetearMontos();
                    return;
                }
                this.Cmp.importe_neto.setValue(this.Cmp.importe_doc.getValue() -  this.Cmp.importe_descuento.getValue());
                this.Cmp.porc_descuento.setValue(this.Cmp.importe_descuento.getValue()/this.Cmp.importe_doc.getValue());


            }else{
                this.Cmp.importe_neto.setValue(this.Cmp.importe_doc.getValue());
                this.Cmp.porc_descuento.setValue(0);
            }

            var porc_descuento = this.Cmp.porc_descuento.getValue();

            if(this.regitrarDetalle == 'si'){
                for (i = 0; i < me.megrid.store.getCount(); i++) {
                    record = me.megrid.store.getAt(i);
                    record.set('precio_total_final', record.data.precio_total - (record.data.precio_total * porc_descuento) );
                }
            }

            if(this.tmp_porc_monto_excento_var){
                alert('ENTRA ...')
                this.Cmp.importe_excento.setValue(this.Cmp.importe_neto.getValue()*this.tmp_porc_monto_excento_var)
            }

            if(this.Cmp.tipo_excento.getValue() == 'constante' ){
                this.Cmp.importe_excento.setValue(this.Cmp.valor_excento.getValue())
            }

            if(this.Cmp.tipo_excento.getValue() == 'porcentual' ){
                this.Cmp.importe_excento.setValue(this.Cmp.importe_neto.getValue()*this.Cmp.valor_excento.getValue())
            }



            if(this.Cmp.importe_excento.getValue() == 0){
                descuento_ley = this.Cmp.importe_neto.getValue()*this.Cmp.porc_descuento_ley.getValue()*1.00;
                this.Cmp.importe_descuento_ley.setValue(descuento_ley);
            }
            else{
                descuento_ley = (this.Cmp.importe_neto.getValue()*1.00 - this.Cmp.importe_excento.getValue()*1.00)*this.Cmp.porc_descuento_ley.getValue();
                this.Cmp.importe_descuento_ley.setValue(descuento_ley);
            }

            //calculo it
            if(this.Cmp.porc_it.getValue() > 0){
                this.Cmp.importe_it.setValue(this.Cmp.porc_it.getValue()*this.Cmp.importe_neto.getValue())
            }

            //calculo iva cf
            if(this.Cmp.porc_iva_cf.getValue() > 0 || this.Cmp.porc_iva_df.getValue() > 0){

                var excento = 0.00;

                if(this.Cmp.importe_excento.getValue() > 0){
                    excento = this.Cmp.importe_excento.getValue();
                }
                if(this.Cmp.porc_iva_cf.getValue() > 0){

                    this.Cmp.importe_iva.setValue(this.Cmp.porc_iva_cf.getValue()*(this.Cmp.importe_neto.getValue() - excento));
                }
                else {
                    this.Cmp.importe_iva.setValue(this.Cmp.porc_iva_df.getValue()*(this.Cmp.importe_neto.getValue() - excento));
                }
            }
            else{
            	 this.Cmp.importe_iva.setValue(0);
			}
            
            if(this.mostrarFormaPago){
                if(this.Cmp.importe_retgar.getValue() > 0 || this.Cmp.importe_anticipo.getValue() > 0 ||  this.Cmp.importe_pendiente.getValue() > 0){
                    this.Cmp.id_auxiliar.allowBlank = false;
                    this.Cmp.id_auxiliar.setReadOnly(false);
                }
                else{
                    this.Cmp.id_auxiliar.allowBlank = true;
                    this.Cmp.id_auxiliar.setReadOnly(true);
                    this.Cmp.id_auxiliar.reset();
                }
                this.Cmp.id_auxiliar.validate();
            }

            var liquido =  this.Cmp.importe_neto.getValue()   -  this.Cmp.importe_retgar.getValue() -  this.Cmp.importe_anticipo.getValue() -  this.Cmp.importe_pendiente.getValue()  -  this.Cmp.importe_descuento_ley.getValue();
            this.Cmp.importe_pago_liquido.setValue(liquido>0?liquido:0);



        },

        getDetallePorAplicar:function(id_plantilla){
            var data = this.getSelectedData();
            Phx.CP.loadingShow();

            Ext.Ajax.request({
                // form:this.form.getForm().getEl(),
                url:'../../sis_contabilidad/control/PlantillaCalculo/recuperarDetallePlantillaCalculo',
                params:{id_plantilla:id_plantilla},
                success:this.successAplicarDesc,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });
        },
        successAplicarDesc:function(resp){
            Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if(!reg.ROOT.error){

                this.Cmp.porc_descuento.setValue(0);
                //aplica descuentos
                this.Cmp.porc_descuento_ley.setValue(reg.ROOT.datos.descuento_porc*1);
                //aplica iva-cf
                this.Cmp.porc_iva_cf.setValue(reg.ROOT.datos.porc_iva_cf*1);
                //aplica iva-df
                this.Cmp.porc_iva_df.setValue(reg.ROOT.datos.porc_iva_df*1);
                //aplicar  it
                this.Cmp.porc_it.setValue(reg.ROOT.datos.porc_it*1);
                //aplicar  ice
                this.Cmp.porc_ice.setValue(reg.ROOT.datos.porc_ice*1);
                //habilitar campos
                this.mostrarImportes(reg.ROOT.datos)
                this.calculaMontoPago();
            }
            else{
                alert(reg.ROOT.mensaje)
            }
        },

        esconderImportes:function(){
            this.ocultarComponente(this.Cmp.importe_descuento);
            this.ocultarComponente(this.Cmp.importe_neto);
            this.ocultarComponente(this.Cmp.nro_autorizacion);
            this.ocultarComponente(this.Cmp.codigo_control);
            this.ocultarComponente(this.Cmp.importe_excento);
            this.ocultarComponente(this.Cmp.importe_iva);
            this.ocultarComponente(this.Cmp.importe_it);
            this.ocultarComponente(this.Cmp.importe_ice);
            this.ocultarComponente(this.Cmp.importe_descuento_ley);

            this.ocultarComponente(this.Cmp.importe_pendiente);
            this.ocultarComponente(this.Cmp.importe_anticipo);
            this.ocultarComponente(this.Cmp.importe_retgar);
            this.ocultarComponente(this.Cmp.id_auxiliar);
            this.ocultarComponente(this.Cmp.estacion);
            this.ocultarComponente(this.Cmp.id_punto_venta);
            this.ocultarComponente(this.Cmp.id_agencia);
        },
        iniciarImportes:function(){
            this.Cmp.importe_excento.setValue(0);
            this.Cmp.importe_iva.setValue(0);
            this.Cmp.importe_it.setValue(0);
            this.Cmp.importe_ice.setValue(0);
            this.Cmp.importe_descuento_ley.setValue(0);
            this.Cmp.importe_descuento.setValue(0);

            this.Cmp.importe_pendiente.setValue(0);
            this.Cmp.importe_anticipo.setValue(0);
            this.Cmp.importe_retgar.setValue(0);
        },

        mostrarImportes: function(datos){
            if( datos.porc_ice !== '0'){
                this.mostrarComponente(this.Cmp.importe_ice);
            }
            if( datos.porc_it !== '0'){
                this.mostrarComponente(this.Cmp.importe_it);
            }
            if( datos.porc_iva_cf !== '0'){
                this.mostrarComponente(this.Cmp.importe_iva);
            }
            if( datos.porc_iva_df !== '0'){
                this.mostrarComponente(this.Cmp.importe_iva);
            }

            if( datos.descuento_porc !== '0'){
                this.mostrarComponente(this.Cmp.importe_descuento_ley);
            }

            if(this.mostrarFormaPago){
                this.mostrarComponente(this.Cmp.importe_pendiente);
                this.mostrarComponente(this.Cmp.importe_anticipo);
                this.mostrarComponente(this.Cmp.importe_retgar);
                this.mostrarComponente(this.Cmp.id_auxiliar);
            }



        },


        onEdit:function(){
            this.Cmp.nit.modificado = true;
            this.Cmp.nro_autorizacion.modificado = true;
            this.Cmp.fecha.setReadOnly(false);
            this.accionFormulario = 'EDIT';
            if(this.data.datosOriginales){
                this.loadForm(this.data.datosOriginales);
            }


            this.esconderImportes();
            //carga configuracion de plantilla
            this.getPlantilla(this.Cmp.id_plantilla.getValue());

            this.Cmp.id_depto_conta.setValue(this.data.id_depto);
            this.Cmp.id_gestion.setValue(this.data.id_gestion);
            this.Cmp.tipo.setValue(this.data.tipoDoc);
            
            
           
            //load detalle de conceptos
            if(this.regitrarDetalle == 'si'){
            	this.detCmp.id_centro_costo.store.baseParams.id_depto = this.data.id_depto;
                this.mestore.baseParams.id_doc_compra_venta = this.Cmp.id_doc_compra_venta.getValue();
                this.mestore.load()
            }




        },

        onNew: function(){

            this.accionFormulario = 'NEW';
            this.Cmp.nit.modificado = true;
            this.Cmp.nro_autorizacion.modificado = true;
            this.esconderImportes();


            this.Cmp.id_depto_conta.setValue(this.data.id_depto);
            this.Cmp.id_gestion.setValue(this.data.id_gestion);
            this.Cmp.tipo.setValue(this.data.tipoDoc);


        },

        onSubmit: function(o) {
            var me = this;
            if(me.regitrarDetalle == 'si'){
                //  validar formularios
                var arra = [], total_det = 0.0, i;
                for (i = 0; i < me.megrid.store.getCount(); i++) {
                    record = me.megrid.store.getAt(i);
                    arra[i] = record.data;
                    total_det = total_det + (record.data.precio_total)*1

                }

                //si tiene conceptos eliminados es necesari oincluirlos ...


                me.argumentExtraSubmit = { 'regitrarDetalle': me.regitrarDetalle,
                    'id_doc_conceto_elis': this.conceptos_eliminados.join(),
                    'json_new_records': JSON.stringify(arra, function replacer(key, value) {
                        if (typeof value === 'string') {
                            return String(value).replace(/&/g, "%26")
                        }
                        return value;
                    }) };

                if( i > 0 &&  !this.editorDetail.isVisible()){




                    if ((total_det.toFixed(2)*1) == this.Cmp.importe_doc.getValue()){
                        Phx.vista.FormCompraVenta.superclass.onSubmit.call(this, o, undefined, true);
                    }
                    else{
                        alert('El total del detalle no cuadra con el total del documento');
                    }


                }
                else{
                    alert('no tiene ningun concepto  en el documento')
                }
            }
            else{
                me.argumentExtraSubmit = { 'regitrarDetalle': me.regitrarDetalle };
                Phx.vista.FormCompraVenta.superclass.onSubmit.call(this, o, undefined, true);
            }
        },


        successSave:function(resp)
        {
            Phx.CP.loadingHide();
            Phx.CP.getPagina(this.idContenedorPadre).reload();
            this.panel.close();
        },

        checkRelacionConcepto: function(cfg){
            var me = this;
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url:'../../sis_contabilidad/control/DocConcepto/verificarRelacionConcepto',
                params:{
                    id_centro_costo: cfg.id_centro_costo,
                    id_gestion: cfg.id_gestion,
                    id_concepto_ingas: cfg.id_concepto_ingas,
                    relacion: me.data.tipoDoc
                },
                success: function(resp){
                    Phx.CP.loadingHide();
                    var objRes = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));

                },
                failure: function(resp){

                    this.conexionFailure(resp);
                    Phx.CP.loadingHide();
                },
                timeout: this.timeout,
                scope: this
            });

        },
        getPlantilla: function(id_plantilla){
            Phx.CP.loadingShow();

            Ext.Ajax.request({
                // form:this.form.getForm().getEl(),
                url: '../../sis_parametros/control/Plantilla/listarPlantilla',
                params: { id_plantilla: id_plantilla, start:0, limit:1 },
                success:this.successPlantilla,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });

        },
        successPlantilla:function(resp){
            Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if(reg.total == 1){

                this.Cmp.id_plantilla.fireEvent('select',this.Cmp.id_plantilla, {data:reg.datos[0] }, 0);
                this.Cmp.nro_autorizacion.fireEvent('change',this.Cmp.nro_autorizacion,this.data.datosOriginales.data.nro_autorizacion)


            }else{
                alert('error al recuperar la plantilla para editar, actualice su navegador');
            }
        },

        obtenerVariableGlobal: function(config){
            var me = this;
            //Verifica que la fecha y la moneda hayan sido elegidos
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url:'../../sis_seguridad/control/Subsistema/obtenerVariableGlobal',
                params:{
                    codigo: 'conta_partidas'
                },
                success: function(resp){
                    Phx.CP.loadingHide();
                    var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));

                    if (reg.ROOT.error) {
                        Ext.Msg.alert('Error','Error a recuperar la variable global')
                    } else {
                        if(reg.ROOT.datos.valor != 'si'){
                            me.listadoConcepto = '../../sis_parametros/control/ConceptoIngas/listarConceptoIngas';
                            me.parFilConcepto = 'desc_ingas';
                            me.mostrarPartidas = false;
                        }


                        me.constructorEtapa2(config);

                    }
                },
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope:this
            });

        },

        cargarRazonSocial: function(nit){
            //Busca en la base de datos la razon social en función del NIT digitado. Si Razon social no esta vacío, entonces no hace nada
            if(this.getComponente('razon_social').getValue()==''){
                Phx.CP.loadingShow();
                Ext.Ajax.request({
                    url:'../../sis_contabilidad/control/DocCompraVenta/obtenerRazonSocialxNIT',
                    params:{ 'nit': this.Cmp.nit.getValue()},
                    success: function(resp){
                        Phx.CP.loadingHide();
                        var objRes = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
                        var razonSocial=objRes.ROOT.datos.razon_social;
                        this.getComponente('razon_social').setValue(razonSocial);
                        this.getComponente('id_moneda').setValue(1);
                        this.getComponente('id_moneda').setRawValue('Bolivianos');

                    },
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope:this
                });
            }

        },
        mensaje_: function (titulo, mensaje) {

            var tipo = 'ext-mb-warning';
            Ext.MessageBox.show({
                title: titulo,
                msg: mensaje,
                buttons: Ext.MessageBox.OK,
                icon: tipo
            })

        },
        controlMiles:function (value) {
            return value    .replace(',', "")
                            //.replace(/([0-9])([0-9]{2})$/, '$1.$2')
                            //.replace(/\B(?=(\d{3})+(?!\d)\.?)/g, "");
        }






    })
</script>