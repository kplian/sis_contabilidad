<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  (fprudencio)
*@date 20-09-2011 10:22:05
*@description Archivo con la interfaz de usuario que permite 
*dar el visto a solicitudes de compra
*
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.IntTransaccionLd = {
    bedit:false,
    bnew:false,
    bsave:false,
    bdel:false,
	require: '../../../sis_contabilidad/vista/int_transaccion/IntTransaccion.php',
	requireclase: 'Phx.vista.IntTransaccion',
	title: 'Libro Diario',
	nombreVista: 'IntTransaccionLd',
	
	constructor: function(config) {
	    Phx.vista.IntTransaccionLd.superclass.constructor.call(this,config);
    
    },
	
   
	
	
};
</script>
