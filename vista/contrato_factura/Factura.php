<?php
/**
 *@package pXP
 *@file gen-Factura.php
 *@author  (admin)
 *@date 18-08-2015 15:57:09
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 *
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.Factura = Ext.extend(Phx.gridInterfaz,{
        fheight: '20%',
        fwidth: '40%',
        constructor:function(config){
            //llama al constructor de la clase padre
            Phx.vista.Factura.superclass.constructor.call(this,config);
            this.init();

        },
        Atributos:[
            {
                //configuracion del componente
                config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_contrato'
                },
                type:'Field',
                form:true
            },
            {
                //configuracion del componente
                config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_moneda'
                },
                type:'Field',
                form:true
            },
            {
                //configuracion del componente
                config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'codigo_auxiliar'
                },
                type:'Field',
                form:true
            },
            {
                config: {
                    name: 'id_doc_compra_venta',
                    fieldLabel: 'Factura',
                    allowBlank: true,
                    emptyText: 'Elija una opción...',
                    store: new Ext.data.JsonStore({
                        url: '../../sis_contabilidad/control/DocCompraVenta/listarCodigoProveedorFactura',
                        id: 'id_doc_compra_venta',
                        root: 'datos',
                        sortInfo: {
                            field: 'codigo_auxiliar',
                            direction: 'ASC'
                        },
                        totalProperty: 'total',
                        fields: ['id_doc_compra_venta','codigo_auxiliar','nit','razon_social','nro_autorizacion'],
                        remoteSort: true,
                        baseParams: {par_filtro:'dc.razon_social#dc.nit'}
                    }),
                    valueField: 'id_doc_compra_venta',
                    displayField: 'nit',
                    gdisplayField: 'nit',
                    tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>Nit: </b>{nit}</p>' +
                    '<p><b>Razon Social: </b><font color="#b8860b">{razon_social}</font></p>' +
                    '<p><b>Nro. Autorizacion: </b><font color="blue">{nro_autorizacion}</font></p></div></tpl>',
                    // hiddenName: 'id_doc_compra_venta',
                    forceSelection: true,
                    typeAhead: false,
                    triggerAction: 'all',
                    lazyRender: true,
                    mode: 'remote',
                    pageSize: 15,
                    queryDelay: 10,
                    anchor: '100%',
                    gwidth: 300,
                    minChars: 2,
                    renderer : function(value, p, record) {
                        return String.format('{0}', record.data['nit']);
                    }
                },
                type: 'ComboBox',
                id_grupo: 0,
                //filters: {pfiltro:' f.desc_funcionario1', type:'string'},
                grid: false,
                form: true
            },
            {
                config:{
                    name: 'nit',
                    fieldLabel: 'NIT',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:100
                },
                type:'TextField',
                filters:{pfiltro:'ctf.nit',type:'string'},
                id_grupo:1,
                grid:true,
                form:false
            },
            {
                config:{
                    name: 'nro_documento',
                    fieldLabel: 'Nro Doc',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:100
                },
                type:'TextField',
                filters:{pfiltro:'ctf.nro_documento',type:'string'},
                id_grupo:1,
                grid:true,
                form:false
            },
            {
                config:{
                    name: 'nro_autorizacion',
                    fieldLabel: 'Autorización',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:200
                },
                type:'TextField',
                filters:{pfiltro:'ctf.nro_autorizacion',type:'string'},
                id_grupo:1,
                grid:true,
                form:false
            },
            {
                config:{
                    name: 'nro_dui',
                    fieldLabel: 'Nro Dui',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:200
                },
                type:'TextField',
                filters:{pfiltro:'ctf.nro_dui',type:'string'},
                id_grupo:1,
                grid:true,
                form:false
            },
            {
                config:{
                    name: 'fecha',
                    fieldLabel: 'Fecha',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    format: 'd/m/Y',
                    renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
                },
                type:'DateField',
                filters:{pfiltro:'ctf.fecha',type:'date'},
                id_grupo:1,
                grid:true,
                form:false
            },
            {
                config:{
                    name: 'razon_social',
                    fieldLabel: 'Razón Social',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:-5
                },
                type:'TextField',
                filters:{pfiltro:'ctf.razon_social',type:'string'},
                id_grupo:1,
                grid:true,
                form:false
            },
            {
                config:{
                    name: 'codigo_control',
                    fieldLabel: 'Código de Control',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:200
                },
                type:'TextField',
                filters:{pfiltro:'ctf.codigo_control',type:'string'},
                id_grupo:1,
                grid:true,
                form:false
            },
            {
                config:{
                    name: 'desc_moneda',
                    fieldLabel: 'NO',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:-5
                },
                type:'TextField',
                filters:{pfiltro:'ctf.razon_social',type:'string'},
                id_grupo:1,
                grid:true,
                form:false
            },
            {
                config:{
                    name: 'importe_doc',
                    fieldLabel: 'Monto',
                    allowBlank: false,
                    anchor: '80%',
                    gwidth: 80,
                    galign: 'right ',
                    maxLength:1179650,
                    renderer:function (value,p,record){
                        if(record.data.tipo_reg != 'summary'){
                            return  String.format('{0}',  Ext.util.Format.number(value,'0,000.00'));
                        }
                        else{
                            Ext.util.Format.usMoney
                            return  String.format('<b><font size=2 >{0}</font></b>', Ext.util.Format.number(value,'0,000.00'));
                        }

                    }
                },
                type:'NumberField',
                filters:{pfiltro:'dcv.importe_doc',type:'numeric'},
                id_grupo:1,

                grid:true,
                form:false
            },
            {
                config:{
                    name: 'importe_excento',
                    fieldLabel: 'Exento',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    galign: 'right ',
                    renderer:function (value,p,record){
                        if(record.data.tipo_reg != 'summary'){
                            return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
                        }
                        else{
                            return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
                        }

                    }
                },
                type: 'NumberField',
                filters: {pfiltro:'dcv.importe_excento',type:'numeric'},
                id_grupo:1,

                grid: true,
                form: false
            },
            {
                config:{
                    name: 'importe_descuento',
                    fieldLabel: 'Descuento',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    galign: 'right ',
                    renderer:function (value,p,record){
                        if(record.data.tipo_reg != 'summary'){
                            return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
                        }
                        else{
                            return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
                        }

                    }
                },
                type:'NumberField',
                filters:{pfiltro:'dcv.importe_descuento',type:'numeric'},
                id_grupo:1,

                grid:true,
                form:false
            },
            {
                config:{
                    name: 'importe_neto',
                    fieldLabel: 'Importe c/d',
                    allowBlank: false,
                    anchor: '80%',
                    gwidth: 100,
                    galign: 'right ',
                    maxLength:1179650,
                    renderer:function (value,p,record){
                        if(record.data.tipo_reg != 'summary'){
                            return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
                        }
                        else{
                            return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
                        }

                    }
                },
                type:'NumberField',
                filters:{pfiltro:'dcv.importe_doc',type:'numeric'},
                id_grupo:1,
                grid:true,
                form:false
            },
            {
                config:{
                    name: 'importe_aux_neto',
                    fieldLabel: 'Neto',
                    allowBlank: false,
                    anchor: '80%',
                    gwidth: 100,
                    galign: 'right ',
                    maxLength:1179650,
                    renderer:function (value,p,record){
                        if(record.data.tipo_reg != 'summary'){
                            return  String.format('{0}', Ext.util.Format.number(value,'0,000.00') );
                        }
                        else{
                            return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
                        }

                    }
                },
                type:'NumberField',
                id_grupo:1,

                grid:true,
                form:false
            },
            {
                config:{
                    name: 'importe_iva',
                    fieldLabel: 'IVA',
                    allowBlank: true,
                    readOnly:true,
                    anchor: '80%',
                    gwidth: 100,
                    galign: 'right ',
                    renderer:function (value,p,record){
                        if(record.data.tipo_reg != 'summary'){
                            return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
                        }
                        else{
                            return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
                        }

                    }
                },
                type: 'NumberField',
                filters: { pfiltro:'dcv.importe_iva',type:'numeric'},
                id_grupo: 1,

                grid: true,
                form: false
            },
            {
                config:{
                    name: 'importe_pago_liquido',
                    fieldLabel: 'Liquido Pagado',
                    allowBlank: true,
                    readOnly:true,
                    anchor: '80%',
                    gwidth: 100,
                    galign: 'right ',
                    renderer:function (value,p,record){
                        if(record.data.tipo_reg != 'summary'){
                            return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
                        }
                        else{
                            return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
                        }

                    }
                },
                type:'NumberField',
                filters:{pfiltro:'dcv.importe_pago_liquido',type:'numeric'},
                id_grupo:1,

                grid:true,
                form: false
            },
            {
                config:{
                    name: 'desc_plantilla',
                    fieldLabel: 'Tipo Documento',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:255
                },
                type:'TextField',
                filters:{pfiltro:'ctf.desc_plantilla',type:'string'},
                id_grupo:1,
                grid:true,
                form:false
            }
        ],
        onReloadPage: function (m) {
            this.maestro = m;
            this.store.baseParams = {id_contrato: this.maestro.id_contrato};
            this.load({params: {start: 0, limit: 50}});
        },
        loadValoresIniciales: function () {
            this.Cmp.id_contrato.setValue(this.maestro.id_contrato);
            Phx.vista.Factura.superclass.loadValoresIniciales.call(this);
        },
        onButtonNew:function(){
            var codigo = this.maestro.codigo_aux;
            Phx.vista.Factura.superclass.onButtonNew.call(this);
            this.Cmp.id_doc_compra_venta.store.baseParams ={par_filtro:'dc.razon_social#dc.nit',codigo_auxiliar:codigo};
            this.Cmp.id_doc_compra_venta.lastQuery = null;
            this.iniciarEvento(this.Cmp.id_doc_compra_venta.getValue(),this.maestro.id_contrato);
        },
        tam_pag:50,
        title:'Contrato Factura',
        ActSave:'../../sis_contabilidad/control/DocCompraVenta/insertarContrato',
        ActDel:'../../sis_contabilidad/control/DocCompraVenta/eleminarContrato',
        ActList:'../../sis_contabilidad/control/DocCompraVenta/listarContraFactura',
        id_store:'id_doc_compra_venta',
        fields: [
            {name:'importe_doc', type: 'numeric'},
            {name:'id_moneda', type: 'numeric'},
            {name:'codigo_control', type: 'string'},
            {name:'id_doc_compra_venta', type: 'string'},
            {name:'importe_pendiente', type: 'numeric'},
            {name:'importe_descuento_ley', type: 'numeric'},
            {name:'nro_dui', type: 'string'},
            {name:'razon_social', type: 'string'},
            {name:'importe_pago_liquido', type: 'numeric'},
            {name:'desc_comprobante', type: 'string'},
            {name:'importe_it', type: 'numeric'},
            {name:'nro_documento', type: 'string'},
            {name:'importe_anticipo', type: 'numeric'},
            {name:'importe_neto', type: 'numeric'},
            {name:'nit', type: 'string'},
            {name:'importe_retgar', type: 'numeric'},
            {name:'importe_iva', type: 'numeric'},
            {name:'desc_plantilla', type: 'string'},
            {name:'importe_descuento', type: 'numeric'},
            {name:'nro_autorizacion', type: 'string'},
            {name:'importe_excento', type: 'numeric'},
            {name:'desc_moneda', type: 'string'},
            {name:'id_contrato', type: 'numeric'},
            {name:'fecha', type: 'date',dateFormat:'Y-m-d'},
            {name:'importe_aux_neto', type: 'numeric'},
            {name:'codigo_auxiliar', type: 'string'}
        ],
        sortInfo:{
            field: 'id_doc_compra_venta',
            direction: 'ASC'
        },
        bdel: true,
        bsave: false,
        bedit:false

    })
</script>