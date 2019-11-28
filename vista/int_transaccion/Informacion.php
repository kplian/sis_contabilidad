<?php
/*
 *
 */
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
    Phx.vista.Informacion=Ext.extend(Phx.frmInterfaz,{


        constructor:function(config)
        {
            this.panelResumen = new Ext.Panel({html:''});
            this.Grupos =
            [{
                xtype: 'fieldset',
                border: false,
                autoScroll: true,
                layout: 'form',
                items: [],
                id_grupo: 1
            }, this.panelResumen
            ];

            Phx.vista.Informacion.superclass.constructor.call(this,config);
            this.init();
            this.iniciarEventos();

            this.addButton('btnInfo', {
                text : 'Origen',
                iconCls : 'bpdf32',
                handler : this.mostrarSist,
                disabled:false,
                tooltip : '<b>Origen</b>'
            });

            this.addButton('btnPresu', {
                text : 'Presupuesto Actualizado',
                iconCls : 'blist',
                handler : this.presu,
                disabled:false,
                tooltip : '<b>Presupuesto Actualizado</b>'
            });

            this.addButton('btnComp', {
                text : 'Reporte',
                iconCls : 'bchecklist',
                handler : this.complementaria,
                disabled:false,
                tooltip : '<b>Informacion complementaria</b>'
            });

            this.addButton('btnDocCmpVnt', {
                text : 'Doc Cmp/Vnt',
                iconCls : 'brenew',
                disabled : false,
                handler : this.loadDocCmpVnt,
                tooltip : '<b>Documentos de compra/venta</b><br/>Muestras los docuemntos relacionados con el comprobante'
            });

            if(config.detalle){
                //cargar los valores para el filtro
                this.loadForm({data: config.detalle});
                var me = this;
                setTimeout(function(){
                    me.onSubmit()
                }, 1500);
            }
        },
        //
        Atributos:
        [
            {
                config:{
                    name: 'nro_tramite',
                    fieldLabel: 'Num Tramite.',
					readOnly: true,
                    anchor: '80%',
                    gwidth: 100,
                    //disabled:true
                },
                type:'Field',
                filters:{pfiltro:'nro_tramite',type:'string'},
                id_grupo:1,
                form:true
            },
            {
                config:{
                    name: 'monto',
                    fieldLabel: 'Monto',
                    anchor: '80%',
                    gwidth: 100,
                    readOnly: true,
                },
                type:'Field',
                id_grupo:1,
                form:true
            },
            {
                config:{
                    name: 'importe_debe_mb',
                    fieldLabel: 'Monto(Bs) ',
                    anchor: '80%',
                    gwidth: 100,
                    readOnly: true,
                },
                type:'Field',
                filters:{pfiltro:'importe_debe_mb',type:'string'},
                id_grupo:1,
                form:true
            },
            {
                config:{
                    name: 'importe_debe_mt',
                    fieldLabel: 'Monto($) ',
                    anchor: '80%',
                    gwidth: 100,
                    readOnly: true,
                },
                type:'Field',
                filters:{pfiltro:'importe_debe_mt',type:'string'},
                id_grupo:1,
                form:true
            },
            {
                config:{
                    name: 'codigo_cc',
                    fieldLabel: 'Centro de Costo',
                    anchor: '80%',
                    gwidth: 100,
                    readOnly: true,
                },
                type:'Field',
                id_grupo:1,
                form:true
            },
            {
                config:{
                    name: 'desc_auxiliar',
                    fieldLabel: 'Auxiliar',
                    anchor: '80%',
                    gwidth: 100,
                    readOnly:true
                },
                type:'Field',
                id_grupo:1,
                form:true
            },
            {
                config:{
                    name: 'desc_cuenta',
                    fieldLabel: 'Cuenta',
                    anchor: '80%',
                    gwidth: 100,
                    readOnly:true
                },
                type:'Field',
                id_grupo:1,
                form:true
            },
            {
                config:{
                    name: 'desc_partida',
                    fieldLabel: 'Partida',
                    anchor: '80%',
                    gwidth: 100,
                    readOnly:true
                },
                type:'Field',
                id_grupo:1,
                form:true
            },
            {
                config:{
                    name: 'glosa',
                    fieldLabel: 'Glosa Cbte',
                    anchor: '80%',
                    gwidth: 100,
                    readOnly:true
                },
                type:'TextArea',
                id_grupo:1,
                form:true
            },
            {
                config:{
                    name: 'glosa1',
                    fieldLabel: 'Descricpion Trans',
                    anchor: '80%',
                    gwidth: 100,
                    readOnly:true
                },
                type:'TextArea',
                id_grupo:1,
                form:true
            },
            {
                config:{
                    name: 'id_int_comprobante',
                    fieldLabel: 'cbte',
                    anchor: '80%',
                    gwidth: 100,
                    readOnly:true
                },
                type:'Field',
                id_grupo:1,
                form:true
            },
        ],
        //
        iniciarEventos:function(){

        },

        loadValoresIniciales: function(){
            Phx.vista.Informacion.superclass.loadValoresIniciales.call(this);
            this.Cmp.nro_tramite.setValue(this.nro_tramite);
            this.Cmp.importe_debe_mb.setValue(this.importe_debe_mb);
            this.Cmp.importe_debe_mt.setValue(this.importe_debe_mt);
            this.Cmp.codigo_cc.setValue(this.desc_centro_costo);
            this.Cmp.desc_auxiliar.setValue(this.desc_auxiliar);
            this.Cmp.desc_cuenta.setValue(this.desc_cuenta);
            this.Cmp.desc_partida.setValue(this.desc_partida);
            this.Cmp.monto.setValue(this.dif);
            this.Cmp.glosa.setValue(this.glosa_cbte);
            this.Cmp.glosa1.setValue(this.glosa_tran);
            this.Cmp.id_int_comprobante.setValue(this.id_int_comprobante);
        },
        bsubmit: false,
        breset: false,
        topBar: true,//barra de herramientas
        bottomBar: false,//barra de herramientas en la parte inferior
        botones: true,//Botones del formulario
        mostrarSist : function() {
            alert('el registro muestra en que lugar y estado se encuentra');
        },
        //
        presu : function() {
            alert('el registro muestra en que lugar y estado se encuentra');
        },
        complementaria:function(){
            alert('el registro muestra en que lugar y estado se encuentra');
        },
        //
        loadDocCmpVnt : function() {
            /*Phx.CP.loadWindows('../../../sis_contabilidad/vista/doc_compra_venta/DocCompraVentaCbte.php', 'Documentos del Cbte', {
                width : '80%',
                height : '80%'
            }, rec.data, this.idContenedor, 'DocCompraVentaCbte');
            */
            console.log('master',this);
            Phx.CP.loadWindows('../../../sis_contabilidad/vista/doc_compra_venta/DocCompraVentaCtrl.php',
                'Documentos',
                {
                    width:600,
                    height:500
                },
                {
                    'nro_tramite':this.nro_tramite,
                    'id_int_comprobante':this.id_int_comprobante,
                    'id_int_transaccion':this.id_int_transaccion,
                },
                this.idContenedor,
                'DocCompraVentaCtrl'
            );
        },



    })
</script>
