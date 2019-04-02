<?php
/**
 *@package pXP
 *@file gCuadroActualizacion.php
 *@author  (Miguel Mamani)
 *@date 19/12/2108
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */
/**
HISTORIAL DE MODIFICACIONES:
ISSUE 		   FECHA   			 AUTOR				 DESCRIPCION:
#28	     	17/12/2018			  kplian  MMV							Reporte cuadro de actualización

 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.CuadroActualizacion = Ext.extend(Phx.frmInterfaz, {
        Atributos : [
            {
                config:{
                    name: 'desde',
                    fieldLabel: 'Desde',
                    allowBlank: true,
                    format: 'd/m/Y',
                    width: 150
                },
                type: 'DateField',
                id_grupo: 0,
                form: true
            },
            {
                config:{
                    name: 'hasta',
                    fieldLabel: 'Hasta',
                    allowBlank: true,
                    format: 'd/m/Y',
                    width: 150
                },
                type: 'DateField',
                id_grupo: 0,
                form: true
            },
            {
                config: {
                    name: 'tipo_cuenta',
                    fieldLabel: 'Tipo Cuenta',
                    typeAhead: false,
                    forceSelection: false,
                    allowBlank: false,
                    emptyText: 'Tipos...',
                    store: new Ext.data.JsonStore({
                        url: '../../sis_contabilidad/control/ConfigTipoCuenta/listarConfigTipoCuenta',
                        id: 'tipo_cuenta',
                        root: 'datos',
                        sortInfo: {
                            field: 'nro_base',
                            direction: 'ASC'
                        },
                        totalProperty: 'total',
                        fields: ['tipo_cuenta', 'nro_base'],
                        // turn on remote sorting
                        remoteSort: true,
                        baseParams: {par_filtro: 'tipo_cuenta'}
                    }),
                    valueField: 'tipo_cuenta',
                    displayField: 'tipo_cuenta',
                    gdisplayField: 'tipo_cuenta',
                    triggerAction: 'all',
                    lazyRender: true,
                    mode: 'remote',
                    pageSize: 20,
                    queryDelay: 200,
                    listWidth:280,
                    minChars: 2,
                    gwidth: 90,
                    enableMultiSelect:true
                },
                type: 'AwesomeCombo',
                id_grupo: 0,
                form: true
            },
            {
                config:{
                    name: 'fecha_moneda',
                    fieldLabel: 'Fecha Moneda',
                    allowBlank: false,
                    format: 'd/m/Y',
                    width: 190
                },
                type: 'DateField',
                id_grupo: 0,
                form: true
            },
            {
                config:{
                    name:'tipo_moneda',
                    fieldLabel:'Tipo de Moneda',
                    allowBlank:false,
                    emptyText:'Tipo de moneda...',
                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode: 'local',
                    valueField: 'tipo_moneda',
                    gwidth: 100,
                    store:new Ext.data.ArrayStore({
                        fields: ['variable', 'valor'],
                        data : [
                            ['MA','Moneda Actualización'],
                            ['MT','Moneda Triangulacion']
                        ]
                    }),
                    valueField: 'variable',
                    displayField: 'valor',
                    listeners: {
                        'afterrender': function(combo){
                            combo.setValue('MA');
                        }
                    }
                },
                type:'ComboBox',
                form:true
            }
        ],
        topBar : true,
        botones : false,
        labelSubmit : 'Generar',
        tooltipSubmit : '<b>Reporte Proyectoa</b>',
        constructor : function(config) {
            Phx.vista.CuadroActualizacion.superclass.constructor.call(this, config);
            this.init();
        },
        tipo : 'reporte',
        clsSubmit : 'bprint',

        Grupos : [{
            layout : 'column',
            items : [{
                xtype : 'fieldset',
                layout : 'form',
                border : true,
                title : 'Datos para el reporte',
                bodyStyle : 'padding:0 10px 0;',
                columnWidth : '800px',
                items : [],
                id_grupo : 0,
                collapsible : true
            }]
        }],
        ActSave:'../../sis_contabilidad/control/Cuenta/reporteCuadroActualizacion'
    })

</script>

