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
            this.iniciarEventos();
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
            },{
                config:{
                    name:'tipo_anexo',
                    fieldLabel:'Reporte',
                    allowBlank:false,
                    emptyText:'Tipo...',
                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode: 'local',
                    valueField: 'tipo_reporte',
                    gwidth: 100,
                    store:new Ext.data.ArrayStore({
                        fields: ['variable', 'valor'],
                        data : [
                            ['ane_1','ANEXO 1'],
                            ['ane_2','ANEXO 2'],
                            ['ane_4','ANEXO 4'],
                            ['ane_5','ANEXO 5'],
                            ['ane_6','ANEXO 6'],
                            ['ane_7','ANEXO 7'],
                            ['ane_7_1','ANEXO 7.1'],
                            ['ane_8','ANEXO 8'],
                            ['ane_9','ANEXO 9'],
                            ['ane_10','ANEXO 10'],
                            ['ane_11','ANEXO 11']
                        ]
                    }),
                    valueField: 'variable',
                    displayField: 'valor'
                },
                type:'ComboBox',
                form:true
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
        }]
    })
</script>