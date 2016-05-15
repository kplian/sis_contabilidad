<?php
/**
*@package pXP
*@file IntComprobanteRegPresupuestario
*@author  gsarmiento
*@date 03-05-2016 10:22:05
*@description Archivo con la interfaz de usuario que permite 
*mostrar los comprobantes presupuestarios
*
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.IntComprobanteRegContable = {
    bsave:false,
   
	require: '../../../sis_contabilidad/vista/int_comprobante/IntComprobanteReg.php',
	requireclase: 'Phx.vista.IntComprobanteReg',
	title: 'Cbtes Contables',
	nombreVista: 'IntComprobanteRegContable',
	
	constructor: function(config) {
	    Phx.vista.IntComprobanteRegContable.superclass.constructor.call(this,config);	       
    },
   
	capturaFiltros : function(combo, record, index) {
			this.desbloquearOrdenamientoGrid();
			this.store.baseParams.id_deptos = this.cmbDepto.getValue();
			this.store.baseParams.nombreVista = this.nombreVista;
			this.store.baseParams.momento = 'contable';
			this.load();
		}
	
};
</script>