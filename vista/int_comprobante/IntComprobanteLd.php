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
Phx.vista.IntComprobanteLd = {
    bedit:false,
    bnew:false,
    bsave:false,
    bdel:true,
	require: '../../../sis_contabilidad/vista/int_comprobante/IntComprobante.php',
	requireclase: 'Phx.vista.IntComprobante',
	title: 'Libro Diario',
	nombreVista: 'IntComprobanteLd',
	
	constructor: function(config) {
	    Phx.vista.IntComprobanteLd.superclass.constructor.call(this,config);
    
    },
	
   south:{
	  url:'../../../sis_contabilidad/vista/int_transaccion/IntTransaccionLd.php',
	  title:'Transacciones', 
	  height:'50%',	//altura de la ventana hijo
	  cls:'IntTransaccionLd'
	},
	preparaMenu : function(n) {
			var tb = Phx.vista.IntComprobante.superclass.preparaMenu.call(this);
			this.getBoton('btnImprimir').setDisabled(false);
			this.getBoton('btnRelDev').setDisabled(false);
			this.getBoton('btnDocCmpVnt').setDisabled(false);
			
			

			return tb;
	},
	liberaMenu : function() {
			var tb = Phx.vista.IntComprobante.superclass.liberaMenu.call(this);
			this.getBoton('btnImprimir').setDisabled(true);
			this.getBoton('btnRelDev').setDisabled(true);
			this.getBoton('btnDocCmpVnt').setDisabled(true);
	}
	
	
};
</script>
