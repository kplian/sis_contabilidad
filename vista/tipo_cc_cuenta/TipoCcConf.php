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
Phx.vista.TipoCcConf = {
    bedit: false,
    bnew: false,
    bsave: true,
    bdel: true,
	require: '../../../sis_parametros/vista/tipo_cc/TipoCc.php',
	requireclase: 'Phx.vista.TipoCc',
	title: 'Tipo de Centro',
	nombreVista: 'TipoCcConf',
	constructor: function(config) {
	    Phx.vista.TipoCcConf.superclass.constructor.call(this,config);
	     
	},
	tabeast:[
		  {
    		  url:'../../../sis_contabilidad/vista/tipo_cc_cuenta/TipoCcCuenta.php',
    		  title:'Cuentas/Auxiliares', 
    		  width:'60%',
    		  cls:'TipoCcCuenta'
		  }		  
		]
};
</script>
