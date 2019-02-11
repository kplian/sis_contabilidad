<?php
/**
 *@package pXP
 *@file    SubirGastoSigep.php
 *@author  Gonzalo Sarmiento
 *@date    09/05/2017
 *@description Formulario para subir Archivo Gasto Sigep
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.SubirGastoSigep = Ext.extend(Phx.frmInterfaz,{
        Atributos: [
            {
                config:{
                    name: 'codigo',
                    fieldLabel: 'Codigo',
                    allowBlank:false,
                    emptyText:'Obtener de...',
                    triggerAction: 'all',
                    lazyRender:true,
                    mode: 'local',
                    store:['GSTSIGEP']
                },
                type:'ComboBox',
                id_grupo:0,
                form:true
            },
            {
                config:{
                    fieldLabel: "Documento (xls)",
                    gwidth: 130,
                    inputType:'file',
                    name: 'archivo',
                    buttonText: '',
                    maxLength:150,
                    anchor:'100%'
                },
                type:'Field',
                form:true
            }
        ],
        title : 'Subir Gasto Sigep',
        ActSave : '../../sis_contabilidad/control/GastoSigep/subirGastoSigep',
        topBar : false,
        botones : true,
        labelSubmit : 'Subir',
        tooltipSubmit : '<b>Subir Gasto Sigep</b>',
        constructor : function(config) {
            Phx.vista.SubirGastoSigep.superclass.constructor.call(this, config);
            this.init();
        },
        clsSubmit : 'bupload',
        fileUpload:true
    })
</script>
