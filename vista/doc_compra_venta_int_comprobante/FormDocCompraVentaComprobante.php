<?php
/**
 *@package pXP
 *@file    FormRepDocCompraVentaIntComprobante.php
 *@author  Gonzalo Sarmiento Sejas
 *@date    24-02-2017
 *@description Archivo con la interfaz para generación de reporte
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.FormRepDocCompraVentaIntComprobante = Ext.extend(Phx.frmInterfaz, {

        Atributos : [
            {
                config:{
                    name: 'fecha_ini',
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
                    name: 'fecha_fin',
                    fieldLabel: 'Hasta',
                    allowBlank: true,
                    format: 'd/m/Y',
                    width: 150
                },
                type: 'DateField',
                id_grupo: 0,
                form: true
            }],


        title : 'Reporte Documentos Comprobante',

        topBar : true,
        botones : false,
        labelSubmit : 'Generar',
        tooltipSubmit : '<b>Reporte Documentos Comprobante</b>',

        constructor : function(config) {
            Phx.vista.FormRepDocCompraVentaIntComprobante.superclass.constructor.call(this, config);
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
                columnWidth : '500px',
                items : [],
                id_grupo : 0,
                collapsible : true
            }]
        }],

        ActSave:'../../sis_contabilidad/control/DocCompraVentaIntComprobante/reporteDocCompraIntComprobante',

        onSubmit: function(o, x, force){
            Phx.vista.FormRepDocCompraVentaIntComprobante.superclass.onSubmit.call(this,o, x, force);
        },

        successSave :function(resp){
            Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if (reg.ROOT.error) {
                alert('error al procesar');
                return
            }

            var nomRep = reg.ROOT.detalle.archivo_generado;
            if(Phx.CP.config_ini.x==1){
                nomRep = Phx.CP.CRIPT.Encriptar(nomRep);
            }

            window.open('../../../reportes_generados/'+nomRep+'?t='+new Date().toLocaleTimeString())

        }
    })
</script>