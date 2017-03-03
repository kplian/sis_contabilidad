<?php
/**
 * @package pXP
 * @file gen-TipoCostoCuenta.php
 * @author  Miguel ALejandro Mamani Villegas
 * @date 30-12-2016 20:29:17
 * @description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.TipoCostoCuenta = Ext.extend(Phx.gridInterfaz, {

        constructor: function (config) {
            this.maestro = config.maestro;
            //llama al constructor de la clase padre
            Phx.vista.TipoCostoCuenta.superclass.constructor.call(this, config);
            this.init();

        },
        //hn
        Atributos: [
            {
                //configuracion del componente
                config: {
                    labelSeparator: '',
                    inputType: 'hidden',
                    name: 'id_tipo_costo_cuenta'
                },
                type: 'Field',
                form: true
            },
            {
                //configuracion del componente
                config: {
                    labelSeparator: '',
                    inputType: 'hidden',
                    name: 'id_tipo_costo'
                },
                type: 'Field',
                form: true
            },

            {
                config: {
                    sysorigen: 'sis_contabilidad',
                    name: 'codigo_cuenta',
                    qtip: 'Define la cuenta sobre las que se realizan las operaciones',
                    fieldLabel: 'Código cuenta',
                    displayField: 'nro_cuenta',
                    valueField: 'nro_cuenta',
                    origen: 'CUENTAS',
                    allowBlank: true,
                    fieldLabel: 'Cuenta',
                    gwidth: 200,
                    width: 180,
                    listWidth: 350,
                    renderer: function (value, p, record) {
                        return String.format('{0}', record.data['codigo_cuenta']);

                    },
                    baseParams: {'filtro_ges': 'actual', sw_transaccional: undefined}
                },
                type: 'ComboRec',
                id_grupo: 0,
                filters: {
                    pfiltro: 'codigo_cuenta',
                    type: 'string'
                },
                grid: true,
                egrid: true,
                form: true
            },
            //id_auxiliares',
            {
                config: {
                    resizable: true,
                    name: 'id_auxiliares',
                    enableMultiSelect: true,
                    fieldLabel: 'Auxiliar',
                    allowBlank: true,
                    emptyText: 'Auxiliar...',
                    store: new Ext.data.JsonStore({
                        url: '../../sis_contabilidad/control/Auxiliar/listarAuxiliar',
                        id: 'id_auxiliar',
                        root: 'datos',
                        sortInfo: {
                            field: 'nombre_auxiliar',
                            direction: 'ASC'
                        },
                        totalProperty: 'total',
                        fields: ['id_auxiliar', 'nombre_auxiliar', 'codigo_auxiliar'],
                        // turn on remote sorting
                        remoteSort: true,
                        baseParams: {par_filtro: 'codigo_auxiliar#nombre_auxiliar'}
                    }),
                    valueField: 'id_auxiliar',
                    displayField: 'nombre_auxiliar',
                    hiddenName: 'id_auxiliares',
                    tpl: new Ext.XTemplate('<tpl for="."><div class="awesomecombo-5item {checked}">', '<p>(Código: {codigo_auxiliar})</p><p> {nombre_auxiliar} </p>', '</div></tpl>'),
                    //tpl : new Ext.XTemplate('<tpl for="."><div class="awesomecombo-5item {checked}">', '<p>(ID: {id_int_comprobante}), Nro: {nro_cbte} , ({desc_moneda})</p>', '<p>Fecha: <strong>{fecha}</strong></p>', '<p>TR: {nro_tramite}</p>', '<p>GLS: {glosa1}</p>', '</div></tpl>'),
                    itemSelector: 'div.awesomecombo-5item',
                    forceSelection: false,
                    typeAhead: false,
                    triggerAction: 'all',
                    lazyRender: true,
                    mode: 'remote',
                    pageSize: 10,
                    queryDelay: 1000,
                    width: 250,
                    gwidth: 200,
                    listWidth: '280',
                    minChars: 2
                },
                type: 'AwesomeCombo',
                id_grupo: 0,
                grid: false,
                form: true
            },


            {
                config: {
                    name: 'auxiliares',
                    fieldLabel: 'Auxiliares',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 600,
                    maxLength: 10
                },
                type: 'TextField',
                id_grupo: 1,
                grid: true,
                form: false
            },


            {
                config: {
                    name: 'estado_reg',
                    fieldLabel: 'Estado Reg.',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength: 10
                },
                type: 'TextField',
                filters: {pfiltro: 'coc.estado_reg', type: 'string'},
                id_grupo: 1,
                grid: true,
                form: false
            },


            {
                config: {
                    name: 'usr_reg',
                    fieldLabel: 'Creado por',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength: 4
                },
                type: 'Field',
                filters: {pfiltro: 'usu1.cuenta', type: 'string'},
                id_grupo: 1,
                grid: true,
                form: false
            },
            {
                config: {
                    name: 'fecha_reg',
                    fieldLabel: 'Fecha creación',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    format: 'd/m/Y',
                    renderer: function (value, p, record) {
                        return value ? value.dateFormat('d/m/Y H:i:s') : ''
                    }
                },
                type: 'DateField',
                filters: {pfiltro: 'coc.fecha_reg', type: 'date'},
                id_grupo: 1,
                grid: true,
                form: false
            },
            {
                config: {
                    name: 'usr_mod',
                    fieldLabel: 'Modificado por',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength: 4
                },
                type: 'Field',
                filters: {pfiltro: 'usu2.cuenta', type: 'string'},
                id_grupo: 1,
                grid: true,
                form: false
            },
            {
                config: {
                    name: 'fecha_mod',
                    fieldLabel: 'Fecha Modif.',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    format: 'd/m/Y',
                    renderer: function (value, p, record) {
                        return value ? value.dateFormat('d/m/Y H:i:s') : ''
                    }
                },
                type: 'DateField',
                filters: {pfiltro: 'coc.fecha_mod', type: 'date'},
                id_grupo: 1,
                grid: true,
                form: false
            },
            {
                config: {
                    name: 'id_usuario_ai',
                    fieldLabel: 'Fecha creación',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength: 4
                },
                type: 'Field',
                filters: {pfiltro: 'coc.id_usuario_ai', type: 'numeric'},
                id_grupo: 1,
                grid: false,
                form: false
            },
            {
                config: {
                    name: 'usuario_ai',
                    fieldLabel: 'Funcionaro AI',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength: 300
                },
                type: 'TextField',
                filters: {pfiltro: 'coc.usuario_ai', type: 'string'},
                id_grupo: 1,
                grid: true,
                form: false
            }
        ],
        tam_pag: 50,
        title: 'Costo Cuenta',
        ActSave: '../../sis_contabilidad/control/TipoCostoCuenta/insertarTipoCostoCuenta',
        ActDel: '../../sis_contabilidad/control/TipoCostoCuenta/eliminarTipoCostoCuenta',
        ActList: '../../sis_contabilidad/control/TipoCostoCuenta/listarTipoCostoCuenta',
        id_store: 'id_tipo_costo_cuenta',
        fields: [
            {name: 'id_tipo_costo_cuenta', type: 'numeric'},
            {name: 'id_tipo_costo', type: 'numeric'},
            {name: 'auxiliares', type: 'string'},
            {name: 'estado_reg', type: 'string'},
            {name: 'codigo_cuenta', type: 'string'},
            {name: 'id_auxiliares', type: 'string'},
            {name: 'id_usuario_reg', type: 'numeric'},
            {name: 'fecha_reg', type: 'date', dateFormat: 'Y-m-d H:i:s.u'},
            {name: 'id_usuario_ai', type: 'numeric'},
            {name: 'usuario_ai', type: 'string'},
            {name: 'id_usuario_mod', type: 'numeric'},
            {name: 'fecha_mod', type: 'date', dateFormat: 'Y-m-d H:i:s.u'},
            {name: 'usr_reg', type: 'string'},
            {name: 'usr_mod', type: 'string'}


        ],
        sortInfo: {
            field: 'coc.codigo_cuenta',
            direction: 'DESC'
        },

        preparaMenu: function (tb) {
            // llamada funcion clace padre
            Phx.vista.TipoCostoCuenta.superclass.preparaMenu.call(this, tb)
        },
        onButtonNew: function () {
            Phx.vista.TipoCostoCuenta.superclass.onButtonNew.call(this);
            this.getComponente('id_tipo_costo').setValue(this.maestro.id_tipo_costo);

        },
        onReloadPage: function (m) {
            this.maestro = m;
            console.log('llega',m);
            if(m.id != 'id') {
                this.store.baseParams = {id_tipo_costo: this.maestro.id_tipo_costo};
                this.load({params: {start: 0, limit: 50}})
            }else{
                this.grid.getTopToolbar().disable();
                this.grid.getBottomToolbar().disable();
                this.store.removeAll();

            }
        },
        loadValoresIniciales: function () {
            this.Cmp.id_tipo_costo.setValue(this.id_tipo_costo);
            Phx.vista.TipoCostoCuenta.superclass.loadValoresIniciales.call(this);
        },


        bdel: true,
        bsave: true
    })
</script>