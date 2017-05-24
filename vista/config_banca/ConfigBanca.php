<?php
/**
 * @package pXP
 * @file gen-ConfigBanca.php
 * @author  (admin)
 * @date 11-09-2015 16:51:13
 * @description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.ConfigBanca = Ext.extend(Phx.gridInterfaz, {

            constructor: function (config) {
                this.maestro = config.maestro;
                //llama al constructor de la clase padre
                Phx.vista.ConfigBanca.superclass.constructor.call(this, config);
                this.init();
                this.load({params: {start: 0, limit: this.tam_pag}})

                this.addButton('Abrir/Cerrar Gestion', {
                    argument: {imprimir: 'Abrir/Cerrar Gestion'},
                    text: '<i class="fa fa-file-text-o fa-2x"></i> Abrir/Cerrar Gestion', /*iconCls:'' ,*/
                    disabled: false,
                    handler: this.abrirCerrarGestion
                });


            },

            Atributos: [
                {
                    //configuracion del componente
                    config: {
                        labelSeparator: '',
                        inputType: 'hidden',
                        name: 'id_config_banca'
                    },
                    type: 'Field',
                    form: true
                },

                {
                    config: {
                        name: 'tipo',
                        fieldLabel: 'tipo',
                        allowBlank: true,
                        emptyText: 'Tipo...',
                        typeAhead: true,
                        triggerAction: 'all',
                        lazyRender: true,
                        mode: 'local',
                        store: ['Tipo de documento de pago', 'Modalidad de transacción', 'Tipo de transacción'],
                        width: 200
                    },
                    type: 'ComboBox',
                    filters: {pfiltro: 'confba.tipo', type: 'string'},
                    id_grupo: 1,
                    grid: true,
                    form: true
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
                    filters: {pfiltro: 'confba.estado_reg', type: 'string'},
                    id_grupo: 1,
                    grid: true,
                    form: false
                },
                {
                    config: {
                        name: 'descripcion',
                        fieldLabel: 'descripcion',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength: 255
                    },
                    type: 'TextField',
                    filters: {pfiltro: 'confba.descripcion', type: 'string'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'digito',
                        fieldLabel: 'digito',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength: 4
                    },
                    type: 'NumberField',
                    filters: {pfiltro: 'confba.digito', type: 'numeric'},
                    id_grupo: 1,
                    grid: true,
                    form: true
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
                    filters: {pfiltro: 'confba.fecha_reg', type: 'date'},
                    id_grupo: 1,
                    grid: true,
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
                    filters: {pfiltro: 'confba.usuario_ai', type: 'string'},
                    id_grupo: 1,
                    grid: true,
                    form: false
                },
                {
                    config: {
                        name: 'id_usuario_ai',
                        fieldLabel: 'Funcionaro AI',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength: 4
                    },
                    type: 'Field',
                    filters: {pfiltro: 'confba.id_usuario_ai', type: 'numeric'},
                    id_grupo: 1,
                    grid: false,
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
                    filters: {pfiltro: 'confba.fecha_mod', type: 'date'},
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
                }
            ],
            tam_pag: 50,
            title: 'configuracion bancaria',
            ActSave: '../../sis_contabilidad/control/ConfigBanca/insertarConfigBanca',
            ActDel: '../../sis_contabilidad/control/ConfigBanca/eliminarConfigBanca',
            ActList: '../../sis_contabilidad/control/ConfigBanca/listarConfigBanca',
            id_store: 'id_config_banca',
            fields: [
                {name: 'id_config_banca', type: 'numeric'},
                {name: 'tipo', type: 'string'},
                {name: 'estado_reg', type: 'string'},
                {name: 'descripcion', type: 'string'},
                {name: 'digito', type: 'numeric'},
                {name: 'id_usuario_reg', type: 'numeric'},
                {name: 'fecha_reg', type: 'date', dateFormat: 'Y-m-d H:i:s.u'},
                {name: 'usuario_ai', type: 'string'},
                {name: 'id_usuario_ai', type: 'numeric'},
                {name: 'fecha_mod', type: 'date', dateFormat: 'Y-m-d H:i:s.u'},
                {name: 'id_usuario_mod', type: 'numeric'},
                {name: 'usr_reg', type: 'string'},
                {name: 'usr_mod', type: 'string'},

            ],
            sortInfo: {
                field: 'id_config_banca',
                direction: 'ASC'
            },
            bdel: true,
            bsave: true,
            abrirCerrarGestion: function () {
                Phx.CP.loadWindows('../../../sis_contabilidad/vista/bancarizacion_periodo/GestionBancarizacion.php',
                    'GestionBancarizacion',
                    {
                        width:900,
                        height:400
                    },'',this.idContenedor,'GestionBancarizacion')
            }
        }
    )
</script>
		
		