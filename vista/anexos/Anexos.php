<?php
/**
 *@package pXP
 *@file Auxiliar.php
 *@author  Manuel Guerra
 *@date 30-07-2018 16:04:52
 *@description
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.Anexos=Ext.extend(Phx.frmInterfaz,{

        constructor:function(config){
            Phx.vista.Anexos.superclass.constructor.call(this,config);
            this.init();
        },

        Atributos:[
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
                config: {
                    name: 'id_plantilla_reporte',
                    fieldLabel: 'Reporte',
                    allowBlank: true,
                    emptyText: 'Elija una opción...',
                    store: new Ext.data.JsonStore({
                        url: '../../sis_contabilidad/control/PlantillaReporte/listarPlantillaReporte',
                        id: 'id_plantilla_reporte',
                        root: 'datos',
                        sortInfo: {
                            field: 'nombre',
                            direction: 'ASC'
                        },
                        totalProperty: 'total',
                        fields: ['id_plantilla_reporte','nombre','glosa','visible'],
                        remoteSort: true,
                        baseParams: {par_filtro: 'per.nombre',visible:'si'}
                    }),
                    valueField: 'id_plantilla_reporte',
                    displayField: 'nombre',
                    gdisplayField: 'nombre',
                    hiddenName: 'id_plantilla_reporte',
                    forceSelection: true,
                    typeAhead: false,
                    triggerAction: 'all',
                    lazyRender: true,
                    mode: 'remote',
                    pageSize: 15,
                    queryDelay: 1000,
                    anchor: '100%',
                    gwidth: 300,
                    minChars: 2,
                    renderer : function(value, p, record) {
                        return String.format('{0}', record.data['nombre']);
                    }
                },
                type: 'ComboBox',
                id_grupo: 0,
                form: true
            }
        ],
        title : 'Reporte de Anexos',
        topBar : true,
        botones : false,
        labelSubmit : 'Generar',
        tooltipSubmit : '<b>Reporte de Anexos</b>',
        ActSave:'../../sis_contabilidad/control/Anexos/reporteAnexos',
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
                columnWidth : '500px',
                items : [],
                id_grupo : 0,
                collapsible : true
            }]
        }],
        agregarArgsExtraSubmit: function() {
            this.argumentExtraSubmit.plantilla_reporte = this.Cmp.id_plantilla_reporte.getRawValue();


        }


    })
</script>