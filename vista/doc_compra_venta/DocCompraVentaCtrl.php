<?php
/**
manu
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.DocCompraVentaCtrl = {

        require: '../../../sis_contabilidad/vista/doc_compra_venta/DocCompraVenta.php',
        ActList:'../../sis_contabilidad/control/DocCompraVenta/listarDocCompraVenta',
        requireclase: 'Phx.vista.DocCompraVenta',
        title: 'Libro de Compras',
        nombreVista: 'DocCompraVentaCbte',
        tipoDoc: 'compra',
        formTitulo: 'Formulario de Documento Compra',

        constructor: function(config) {

            Phx.vista.DocCompraVentaCtrl.superclass.constructor.call(this,config);
            this.init();
            this.loadValoresIniciales();
            this.cmbPeriodo.hide();
            this.cmbDepto.hide();
            this.cmbGestion.hide();

            this.getBoton('btnWizard').hide();
            this.getBoton('btnExpTxt').hide();

            this.addButton('btnShowDoc',
                {
                    text: 'Ver Detalle',
                    iconCls: 'brenew',
                    disabled: true,
                    handler: this.showDoc,
                    tooltip: 'Muestra el detalle del documento'
                }
            );
            this.store.baseParams = { id_int_comprobante: this.id_int_comprobante };
            this.load({params:{start:0, limit:this.tam_pag}});
        },

        bedit: false,
        bdel: false,
        bsave: false,
        bnew: false,
        //
        Atributos:[
            {
                config:{
                    name: 'id_doc_compra_venta',
                    fieldLabel: 'Documento ID',
                    allowBlank: false,
                    emptyText:'Elija una plantilla...',
                    store:new Ext.data.JsonStore(
                        {
                            url: '../../sis_contabilidad/control/DocCompraVenta/listarDocCompraVenta',
                            id: 'id_doc_compra_venta',
                            root:'datos',
                            sortInfo:{
                                field:'desc_plantilla',
                                direction:'ASC'
                            },
                            totalProperty:'total',
                            fields: ['id_doc_compra_venta','revisado','nro_documento','nit',
                                'desc_plantilla', 'desc_moneda','importe_doc','nro_documento',
                                'tipo','razon_social','fecha'],
                            remoteSort: true,
                            baseParams:{par_filtro:'mon.codigo#pla.desc_plantilla#dcv.razon_social#dcv.nro_documento#dcv.nit#dcv.importe_doc'}
                        }),
                    tpl:'<tpl for="."><div class="x-combo-list-item"><p>{razon_social},  NIT: {nit}</p><p>{desc_plantilla} </p><p>Doc: {nro_documento} de Fecha: {fecha}</p><p> {importe_doc} {desc_moneda}  </p></div></tpl>',
                    valueField: 'id_doc_compra_venta',
                    hiddenValue: 'id_doc_compra_venta',
                    displayField: 'desc_plantilla',
                    //gdisplayField:'nro_documento',
                    listWidth:'280',
                    forceSelection:true,
                    typeAhead: false,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode:'remote',
                    pageSize:20,
                    queryDelay:500,
                    gwidth: 100,
                    minChars:2
                },
                type:'ComboBox',
                id_grupo: 0,
                grid:true,
                bottom_filter: true,
                form: true
            },
            {
                config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'tipo'
                },
                type:'Field',
                form:true
            },
            {
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
                    gwidth: 100,
                    maxLength:3,
                    renderer: function (value){
                        //check or un check row
                        var checked = '',
                            momento = 'no';
                        if(value == 'si'){
                            checked = 'checked';;
                        }
                        return  String.format('<div style="vertical-align:middle;text-align:center;"><input style="height:37px;width:37px;" type="checkbox"  {0}  disabled></div>',checked);
                    }
                },
                type: 'TextField',
                filters: { pfiltro:'dcv.revisado',type:'string'},
                id_grupo: 1,
                grid: false,
                form: false
            },
            {
                config:{
                    name: 'desc_plantilla',
                    fieldLabel: 'Tipo Documento',
                    allowBlank: false,
                    emptyText:'Elija una plantilla...',
                    gwidth: 250
                },
                type:'Field',
                filters:{pfiltro:'pla.desc_plantilla',type:'string'},
                id_grupo: 0,
                grid: true,
                bottom_filter: true,
                form: false
            },
        ],
        //
        tam_pag: 50,
        title: 'Documentos Compra y Venta',
        ActList: '../../sis_contabilidad/control/DocCompraVenta/listarDocCompraVenta',
        id_store: 'id_doc_compra_venta',
        fields: [
            {name:'id_doc_compra_venta', type: 'string'},
            {name:'revisado', type: 'string'},
            {name:'movil', type: 'string'},
            {name:'tipo', type: 'string'},
            {name:'importe_excento', type: 'numeric'},
            {name:'id_plantilla', type: 'numeric'},
            {name:'fecha', type: 'date',dateFormat:'Y-m-d'},
            {name:'nro_documento', type: 'string'},
            {name:'nit', type: 'string'},
            {name:'importe_ice', type: 'numeric'},
            {name:'nro_autorizacion', type: 'string'},
            {name:'importe_iva', type: 'numeric'},
            {name:'importe_descuento', type: 'numeric'},
            {name:'importe_doc', type: 'numeric'},
            {name:'sw_contabilizar', type: 'string'},
            {name:'tabla_origen', type: 'string'},
            {name:'estado', type: 'string'},
            {name:'id_depto_conta', type: 'numeric'},
            {name:'id_origen', type: 'numeric'},
            {name:'obs', type: 'string'},
            {name:'estado_reg', type: 'string'},
            {name:'codigo_control', type: 'string'},
            {name:'importe_it', type: 'numeric'},
            {name:'razon_social', type: 'string'},
            {name:'id_usuario_ai', type: 'numeric'},
            {name:'id_usuario_reg', type: 'numeric'},
            {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
            {name:'usuario_ai', type: 'string'},
            {name:'id_usuario_mod', type: 'numeric'},
            {name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
            {name:'usr_reg', type: 'string'},
            {name:'usr_mod', type: 'string'},
            {name:'importe_pendiente', type: 'numeric'},
            {name:'importe_anticipo', type: 'numeric'},
            {name:'importe_retgar', type: 'numeric'},
            {name:'importe_neto', type: 'numeric'},
            'desc_depto','desc_plantilla',
            'importe_descuento_ley',
            'importe_pago_liquido','nro_dui','id_moneda','desc_moneda','id_auxiliar','codigo_auxiliar','nombre_auxiliar'

        ],
        sortInfo:{
            field: 'id_doc_compra_venta',
            direction: 'ASC'
        },

    preparaMenu:function(tb){
        Phx.vista.DocCompraVentaCtrl.superclass.preparaMenu.call(this,tb)
        this.getBoton('btnShowDoc').enable();
        this.getBoton('btnExpTxt').hide();
    },

    liberaMenu:function(tb){
        Phx.vista.DocCompraVentaCtrl.superclass.liberaMenu.call(this,tb);
        this.getBoton('btnShowDoc').disable();
        this.getBoton('btnExpTxt').hide();
    },
    //
    loadValoresIniciales:function(){
        Phx.vista.DocCompraVentaCtrl.superclass.loadValoresIniciales.call(this);
        this.getBoton('btnExpTxt').hide();
    },

    };
</script>
