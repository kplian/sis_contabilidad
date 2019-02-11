<?php
/**
 *@package pXP
 *@file NroTramiteCuenta.php
 *@author  (admin)
 *@date 01-09-2013 18:10:12
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>

    Phx.vista.NroTramiteCuenta = Ext.extend(Phx.gridInterfaz,{
        title:'Mayor',
        constructor:function(config){
            var me = this;
            this.maestro=config.maestro;
            //Agrega combo de moneda
            this.Atributos = [
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_int_comprobante'
                    },
                    type:'Field',
                    form:false
                },
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_cuenta'
                    },
                    type:'Field',
                    form:false
                },
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_auxiliar'
                    },
                    type:'Field',
                    form:false
                },
                {
                    config:{
                        name: 'nro_tramite',
                        fieldLabel: 'Nro Tramite',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 110
                    },
                    type:'TextArea',
                    filters:{pfiltro:'nro_tramite',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:false,
                    bottom_filter:true
                },
                {
                    config:{
                        name: 'nro_cuenta',
                        fieldLabel: 'Nro Cuenta/Nombre',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 250,
                        renderer: function(value, p, record) {
                            return  '<div><p><b>'+record.data['nro_cuenta']+'</b></p>' +
                                '<p><font color="#C0392B"><b>'+ record.data['nombre_cuenta']+'</b></font></div>';
                        }
                    },
                    type:'TextArea',
                    filters:{pfiltro:'nro_cuenta',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:false,
                    bottom_filter:true
                },
                {
                    config:{
                        name: 'codigo_auxiliar',
                        fieldLabel: 'Cod Auxliar/Nombre',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 200,
                        renderer: function(value, p, record) {
                            return  '<div><p><b>'+record.data['codigo_auxiliar']+'</b></p>' +
                                '<p><font color="#1F618D"><b>'+ record.data['nombre_auxiliar']+'</b></font></div>';
                        }
                    },
                    type:'TextArea',
                    filters:{pfiltro:'codigo_auxiliar',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:false,
                    bottom_filter:true
                },
                {
                    config:{
                        name: 'importe_debe_mb',
                        fieldLabel: 'Debe MB',
                        allowBlank: false,
                        anchor: '80%',
                        gwidth: 100,
                        galign: 'right ',
                        maxLength:1179650,
                        renderer:function (value,p,record){
                            if(record.data.codigo_auxiliar != 'summary'){
                                return  String.format('{0}',  Ext.util.Format.number(value,'0,000.00'));
                            }
                            else{
                                Ext.util.Format.usMoney
                                return  String.format('<b><font size=4 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
                            }

                        }
                    },
                    type:'NumberField',
                    filters:{pfiltro:'importe_debe_mb',type:'numeric'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'importe_haber_mb',
                        fieldLabel: 'Haber MB',
                        allowBlank: false,
                        anchor: '80%',
                        gwidth: 100,
                        galign: 'right ',
                        maxLength:1179650,
                        renderer:function (value,p,record){
                            if(record.data.codigo_auxiliar != 'summary'){
                                return  String.format('{0}',  Ext.util.Format.number(value,'0,000.00'));
                            }
                            else{
                                Ext.util.Format.usMoney
                                return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
                            }

                        }
                    },
                    type:'NumberField',
                    filters:{pfiltro:'importe_haber_mb',type:'numeric'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'saldo_mb',
                        fieldLabel: 'Saldo MB',
                        allowBlank: false,
                        anchor: '80%',
                        gwidth: 100,
                        galign: 'right ',
                        maxLength:1179650,
                        renderer:function (value,p,record){
                            if(record.data.codigo_auxiliar != 'summary'){
                                return  String.format('{0}',  Ext.util.Format.number(value,'0,000.00'));
                            }
                            else{
                                Ext.util.Format.usMoney
                                return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
                            }

                        }
                    },
                    type:'NumberField',
                    filters:{pfiltro:'saldo_mb',type:'numeric'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'importe_debe_mt',
                        fieldLabel: 'Debe MT',
                        allowBlank: false,
                        anchor: '80%',
                        gwidth: 100,
                        galign: 'right ',
                        maxLength:1179650,
                        renderer:function (value,p,record){
                            if(record.data.codigo_auxiliar != 'summary'){
                                return  String.format('{0}',  Ext.util.Format.number(value,'0,000.00'));
                            }
                            else{
                                Ext.util.Format.usMoney
                                return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
                            }

                        }
                    },
                    type:'NumberField',
                    filters:{pfiltro:'importe_debe_mt',type:'numeric'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'importe_haber_mt',
                        fieldLabel: 'Haber MT',
                        allowBlank: false,
                        anchor: '80%',
                        gwidth: 100,
                        galign: 'right ',
                        maxLength:1179650,
                        renderer:function (value,p,record){
                            if(record.data.codigo_auxiliar != 'summary'){
                                return  String.format('{0}',  Ext.util.Format.number(value,'0,000.00'));
                            }
                            else{
                                Ext.util.Format.usMoney
                                return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
                            }

                        }
                    },
                    type:'NumberField',
                    filters:{pfiltro:'importe_haber_mt',type:'numeric'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },

                {
                    config:{
                        name: 'glosa1',
                        fieldLabel: 'Glosa',
                        allowBlank: true,
                        width: 380,
                        gwidth: 300,
                        maxLength:1000,
                        renderer: function(val){if (val != ''){return '<div class="gridmultiline">'+val+'</div>';}}
                    },
                    type:'TextArea',
                    filters:{pfiltro:'glosa1',type:'string'},
                    id_grupo:1,
                    bottom_filter: true,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'importe_debe_ma',
                        fieldLabel: 'Debe MA',
                        allowBlank: false,
                        anchor: '80%',
                        gwidth: 100,
                        galign: 'right ',
                        maxLength:1179650,
                        renderer:function (value,p,record){
                            if(record.data.codigo_auxiliar != 'summary'){
                                return  String.format('{0}',  Ext.util.Format.number(value,'0,000.00'));
                            }
                            else{
                                Ext.util.Format.usMoney
                                return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
                            }

                        }
                    },
                    type:'NumberField',
                    filters:{pfiltro:'importe_debe_ma',type:'numeric'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'importe_haber_ma',
                        fieldLabel: 'Haber MA',
                        allowBlank: false,
                        anchor: '80%',
                        gwidth: 100,
                        galign: 'right ',
                        maxLength:1179650,
                        renderer:function (value,p,record){
                            if(record.data.codigo_auxiliar != 'summary'){
                                return  String.format('{0}',  Ext.util.Format.number(value,'0,000.00'));
                            }
                            else{
                                Ext.util.Format.usMoney
                                return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
                            }

                        }
                    },
                    type:'NumberField',
                    filters:{pfiltro:'importe_haber_ma',type:'numeric'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'saldo_ma',
                        fieldLabel: 'Saldo MA',
                        allowBlank: false,
                        anchor: '80%',
                        gwidth: 100,
                        galign: 'right ',
                        maxLength:1179650,
                        renderer:function (value,p,record){
                            if(record.data.codigo_auxiliar != 'summary'){
                                return  String.format('{0}',  Ext.util.Format.number(value,'0,000.00'));
                            }
                            else{
                                Ext.util.Format.usMoney
                                return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
                            }

                        }
                    },
                    type:'NumberField',
                    filters:{pfiltro:'saldo_ma',type:'numeric'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'saldo_mt',
                        fieldLabel: 'Saldo MT',
                        allowBlank: false,
                        anchor: '80%',
                        gwidth: 100,
                        galign: 'right ',
                        maxLength:1179650,
                        renderer:function (value,p,record){
                            if(record.data.codigo_auxiliar != 'summary'){
                                return  String.format('{0}',  Ext.util.Format.number(value,'0,000.00'));
                            }
                            else{
                                Ext.util.Format.usMoney
                                return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
                            }

                        }
                    },
                    type:'NumberField',
                    filters:{pfiltro:'saldo_mt',type:'numeric'},
                    id_grupo:1,
                    grid:true,
                    form:false
                }
            ];

            //llama al constructor de la clase padre
            Phx.vista.NroTramiteCuenta.superclass.constructor.call(this,config);
            this.grid.getTopToolbar().disable();
            this.grid.getBottomToolbar().disable();
            this.init();
            this.grid.addListener('cellclick', this.oncellclick,this);
            this.addButton('btnReporte',
                {
                    text: 'Reporte',
                    iconCls : 'blist',
                    disabled: false,
                    handler: this.reporteTramite,
                    tooltip: '<b>Reporte Auxiliar detalle número de tramite</b>'
                }
            );
        },

        tam_pag: 50,
        ActList: '../../sis_contabilidad/control/IntTransaccion/mayorNroTramite',
        id_store: 'id_tipo_estado_columna',
        fields: [
            'id_int_comprobante',
            "id_cuenta",
            'nro_cuenta',
            "nombre_cuenta",
            'id_auxiliar',
            "codigo_auxiliar",
            'nombre_auxiliar',
            "nro_tramite",
            'fecha','glosa1',
            "importe_debe_mb",
            'importe_haber_mb',
            "saldo_mb",
            'importe_debe_mt',
            "importe_haber_mt",
            'saldo_mt',
            "importe_debe_ma",
            "importe_haber_ma",
            "saldo_ma"
        ],

        sortInfo:{
            field: 'nro_tramite',
            direction: 'ASC'
        },
        bdel: true,
        bsave: false,

        onReloadPage:function(param){
            //Se obtiene la gestión en función de la fecha del comprobante para filtrar partidas, cuentas, etc.
            var me = this;
            this.initFiltro(param);
        },

        initFiltro: function(param){
            this.store.baseParams=param;
            this.load( { params: { start:0, limit: this.tam_pag } });
        },

        preparaMenu : function(n) {
            var rec=this.sm.getSelected();
            if(rec.data.codigo_auxiliar != 'summary'){
                var tb = Phx.NroTramiteCuenta.AuxiliarCuenta.superclass.preparaMenu.call(this);
                return tb;
            }
            return undefined;
        },
        liberaMenu : function() {
            var tb = Phx.vista.NroTramiteCuenta.superclass.liberaMenu.call(this);
        },

        bnew : false,
        bedit: false,
        bdel:  false,
        oncellclick : function(grid, rowIndex, columnIndex, e) {
            var record = this.store.getAt(rowIndex).data,fieldName = grid.getColumnModel().getDataIndex(columnIndex); // Get field nam
            var PagMaes = Phx.CP.getPagina(this.idContenedorPadre);
            var desde = PagMaes.Cmp.desde.getValue();
            var hasta = PagMaes.Cmp.hasta.getValue();
            var id_gestion = PagMaes.Cmp.id_gestion.getValue();
            var nro_tramite = PagMaes.Cmp.nro_tramite.getValue();
            if (fieldName == 'detalle') {
                Phx.CP.loadWindows('../../../sis_contabilidad/vista/int_transaccion/FormFiltro.php',
                    'Mayor',
                    {
                        width:'100%',
                        height:'100%'
                    },
                    {
                        maestro:record.data,
                        detalle:
                            {
                                'tipo_filtro': 'fechas',
                                'desde': desde,
                                'hasta': hasta,
                                'id_gestion': id_gestion,
                                'id_auxiliar': record.id_auxiliar,
                                'nro_tramite': nro_tramite
                            }
                    },
                    this.idContenedor,
                    'FormFiltro'
                );
            }
        },
        reporteTramite : function () {
            var PagMaes = Phx.CP.getPagina(this.idContenedorPadre);
            var desde = PagMaes.Cmp.desde.getValue();
            var hasta = PagMaes.Cmp.hasta.getValue();
            var id_auxiliar = PagMaes.Cmp.id_auxiliar.getValue();
            var id_gestion = PagMaes.Cmp.id_gestion.getValue();
            var nro_tramite = PagMaes.Cmp.nro_tramite.getValue();
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url: '../../sis_contabilidad/control/IntTransaccion/reporteAuxliarTramite',
                params: {
                    'tipo_filtro': 'fechas',
                    'desde': desde,
                    'hasta': hasta,
                    'id_gestion': id_gestion,
                    'id_auxiliar': id_auxiliar,
                    'nro_tramite': nro_tramite
                },
                success: this.successExport,
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope: this
            });

        }

    })
</script>