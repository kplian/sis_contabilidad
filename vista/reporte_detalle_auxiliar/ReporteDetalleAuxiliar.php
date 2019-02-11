<?php
/**
 *@package pXP
 *@file ReporteDetalleAuxiliar.php
 *@author  (MMV)
 *@date 20-04-2017 00:51:02
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema*  	ISUUE			FECHA			AUTHOR 		DESCRIPCION
 *  	ISUUE			FECHA			AUTHOR 		DESCRIPCION
 *   #23           27/12/2018    Miguel Mamani   Reporte Detalle Auxiliares por Cuenta
 *  #10        02/01/2019    Miguel Mamani     		Nuevo parámetro tipo de moneda para el reporte detalle Auxiliares por Cuenta
 */


header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.ReporteDetalleAuxiliar = Ext.extend(Phx.frmInterfaz, {
        Atributos : [
            {
                config:{
                    name : 'id_gestion',
                    origen : 'GESTION',
                    fieldLabel : 'Gestion',
                    gdisplayField: 'desc_gestion',
                    allowBlank : false,
                    width: 150
                },
                type : 'ComboRec',
                id_grupo : 0,
                form : true
            },
            {
                config:{
                    name: 'desde',
                    fieldLabel: 'Desde',
                    allowBlank: false,
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
                    allowBlank: false,
                    format: 'd/m/Y',
                    width: 150
                },
                type: 'DateField',
                id_grupo: 0,
                form: true
            },
            {
                config:{
                    sysorigen: 'sis_contabilidad',
                    name: 'id_cuenta',
                    origen: 'CUENTA',
                    allowBlank: true,
                    fieldLabel: 'Cuenta',
                    gdisplayField: 'desc_cuenta',
                    baseParams: { sw_transaccional: 'movimiento' },
                    width: 150
                },
                type: 'ComboRec',
                id_grupo: 0,
                form: true
            },
            {
                config:{
                    name: 'cbte_cierre',
                    qtip : 'Incluir los comprobantes de cierre en el balance',
                    fieldLabel: 'Incluir cbtes. cierres',
                    allowBlank: false,
                    emptyText:'Tipo...',
                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode: 'local',
                    width:150,
                    store:['no','balance','resultado','todos']
                },
                type:'ComboBox',
                id_grupo:0,
                valorInicial: 'no',
                grid:true,
                form:true
            },

            //#10
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
                            ['MB','Moneda Base'],
                            ['MT','Moneda Triangulacion'],
                            ['MA','Moneda Actualizacion']
                        ]
                    }),
                    valueField: 'variable',
                    displayField: 'valor',
                    listeners: {
                        'afterrender': function(combo){
                            combo.setValue('MB');
                        }
                    }
                },
                type:'ComboBox',
                form:true
            } //#10
        ],
        topBar : true,
        botones : false,
        labelSubmit : 'Generar',
        tooltipSubmit : '<b>Reporte Proyectoa</b>',
        constructor : function(config) {
            Phx.vista.ReporteDetalleAuxiliar.superclass.constructor.call(this, config);
            this.init();
            this.iniciarEventos();
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

        ActSave:'../../sis_contabilidad/control/Auxiliar/reporteAuxiliarDetalle',
        iniciarEventos:function(){
            this.Cmp.id_gestion.on('select', function(cmb, rec, ind){
                console.log(rec.data.id_gestion);
                Ext.apply(this.Cmp.id_cuenta.store.baseParams,{id_gestion: rec.data.id_gestion});
                this.Cmp.id_cuenta.reset();
                this.Cmp.id_cuenta.modificado = true;
            },this);
        },
        agregarArgsExtraSubmit: function() {
            this.argumentExtraSubmit.id_gestions = this.Cmp.id_gestion.getRawValue();
            this.argumentExtraSubmit.moneda = this.Cmp.tipo_moneda.getRawValue();  //#10

        }
    })





</script>

