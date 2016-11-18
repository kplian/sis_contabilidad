<?php
/**
 *@package pXP
 *@file gen-SistemaDist.php
 *@author  (fprudencio)
 *@date 20-09-2011 10:22:05
 *@description Archivo con la interfaz de usuario que permite
 *dar el visto a solicitudes de compra
 *
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.DocCompraCajero = {

        require: '../../../sis_contabilidad/vista/doc_compra_venta/DocCompraVenta.php',
        requireclase: 'Phx.vista.DocCompraVenta',
        title: 'Libro de Compras',
        nombreVista: 'DocCompraCajero',
        tipoDoc: 'compra',
        formTitulo: 'Formulario de Documento Compra',
        bsave:false,
        constructor: function(config) {


            Phx.vista.DocCompraCajero.superclass.constructor.call(this,config);

            //this.Cmp.id_plantilla.store.baseParams = Ext.apply(this.Cmp.id_plantilla.store.baseParams, {tipo_plantilla:this.tipoDoc});
            this.cmbDepto.store.load({params:{start:0,limit:100},
                callback : function (r) {
                    console.log(r);
                    if (r.length == 1) {
                        this.cmbDepto.setValue(r[0].data.id_depto);
                        this.cmbDepto.fireEvent('select', this.cmbDepto, this.cmbDepto.store.getById(r[0].data.id_depto));
                    }
                }, scope : this
            });

            this.getBoton('btnExpTxt').hide();
            this.getBoton('btnWizard').hide();
            this.store.baseParams.filtro_usuario = 'si';
        },
        arrayDefaultColumHidden:['revisado'],

        loadValoresIniciales: function() {
            Phx.vista.DocCompraCajero.superclass.loadValoresIniciales.call(this);
            //this.Cmp.tipo.setValue(this.tipoDoc);

        },
        capturaFiltros:function(combo, record, index){
            this.store.baseParams.tipo = this.tipoDoc;
            this.store.baseParams.filtro_usuario = 'si';
            Phx.vista.DocCompraCajero.superclass.capturaFiltros.call(this,combo, record, index);
        },
        abrirFormulario: function(tipo, record){
            var me = this;
            console.log(' me.regitrarDetalle', me.regitrarDetalle)
            me.objSolForm = Phx.CP.loadWindows('../../../sis_contabilidad/vista/doc_compra_venta/FormCompraVenta.php',
                me.formTitulo,
                {
                    modal:true,
                    width:'100%',
                    height:'100%'

                }, { data: {
                    objPadre: me ,
                    tipoDoc: me.tipoDoc,
                    id_gestion: me.cmbGestion.getValue(),
                    id_periodo: me.cmbPeriodo.getValue(),
                    id_depto: me.cmbDepto.getValue(),
                    tmpPeriodo: me.tmpPeriodo,
                    tmpGestion: me.tmpGestion,
                    tipo_form : tipo,
                    datosOriginales: record,
                    mostrarFormaPago :false
                },
                    regitrarDetalle: me.regitrarDetalle
                },
                this.idContenedor,
                'FormCompraVenta',
                {
                    config:[{
                        event:'successsave',
                        delegate: this.onSaveForm,

                    }],

                    scope:this
                });
        },

        cmbDepto: new Ext.form.ComboBox({
            name: 'id_depto',
            fieldLabel: 'Depto',
            blankText: 'Depto',
            typeAhead: false,
            forceSelection: true,
            allowBlank: false,
            disableSearchButton: true,
            emptyText: 'Depto Contable',
            store: new Ext.data.JsonStore({
                url: '../../sis_parametros/control/Depto/listarDepto',
                id: 'id_depto',
                root: 'datos',
                sortInfo:{
                    field: 'deppto.nombre',
                    direction: 'ASC'
                },
                totalProperty: 'total',
                fields: ['id_depto','nombre','codigo'],
                // turn on remote sorting
                remoteSort: true,
                baseParams: { par_filtro:'deppto.nombre#deppto.codigo', estado:'activo', codigo_subsistema: 'CONTA',prioridad:1}
            }),
            valueField: 'id_depto',
            displayField: 'nombre',
            hiddenName: 'id_depto',
            enableMultiSelect: true,
            triggerAction: 'all',
            lazyRender: true,
            mode: 'remote',
            pageSize: 20,
            queryDelay: 200,
            anchor: '80%',
            listWidth:'280',
            resizable:true,
            minChars: 2
        })




    };
</script>
