<?php
/**
 *@package pXP
 *@file GestionBancarizacion.php
 *@author  RCM
 *@date 10/12/2013
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.GestionBancarizacion = {
        bedit:false,
        bnew:false,
        bsave:false,
        bdel:false,
        require:'../../../sis_parametros/vista/gestion/Gestion.php',
        requireclase:'Phx.vista.Gestion',
        title:'Gestión',
        nombreVista: 'gestionConta',
        constructor: function(config) {
            this.maestro=config.maestro;
            Phx.vista.GestionBancarizacion.superclass.constructor.call(this,config);
            this.init();
            this.load({params:{start:0, limit:50}})


            //Oculta el botón para generar los periodos por subsistema
            this.getBoton('btnSincPeriodoSubsis').hide();

            //Creación de ventana para la gestión origen
        },
        south: false,

        east:{
            url:'../../../sis_contabilidad/vista/bancarizacion_periodo/BancarizacionPeriodo.php',
            title:'BancarizacionPeriodo',
            width:300,
            cls:'BancarizacionPeriodo'
        },
        


    };
</script>
