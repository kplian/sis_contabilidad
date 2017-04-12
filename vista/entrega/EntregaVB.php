<?php
/**
 *@package pXP
 *@file gen-Entrega.php
 *@author  Miguel Alejandro Mamani  Villegas
 *@date 26-01-2017 19:50:19
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.EntregaVB = {
        require: '../../../sis_contabilidad/vista/entrega/Entrega.php',
        requireclase: 'Phx.vista.Entrega',
        title: 'Solicitud',
        nombreVista: 'EntregaVB',
        constructor: function (config) {
            Phx.vista.EntregaVB.superclass.constructor.call(this, config);
            //this.maestro = config.maestro;
            this.store.baseParams = {tipo_interfaz: this.nombreVista};
            this.store.baseParams.pes_estado = 'EntregaConsulta';
            this.finCons = true;

            this.getBoton('sig_estado').setVisible(false);
            this.getBoton('ant_estado').setVisible(false);
            this.getBoton('fin_entrega').setVisible(false);
        },
        preparaMenu : function(n) {
            var tb = Phx.vista.EntregaVB.superclass.preparaMenu.call(this,n);

            this.getBoton('btnImprimir').enable();
            this.getBoton('diagrama_gantt').enable();
            this.getBoton('btnChequeoDocumentosWf').enable();
            this.getBoton('fin_entrega').enable();
            return tb;
        },
        liberaMenu : function() {
            var tb = Phx.vista.EntregaVB.superclass.liberaMenu.call(this);
            this.getBoton('sig_estado').disable();
            this.getBoton('btnImprimir').disable();
            this.getBoton('fin_entrega').disable();
            this.getBoton('btnChequeoDocumentosWf').disable();
            this.getBoton('ant_estado').disable();
            this.getBoton('diagrama_gantt').disable();


        }
    }
</script>