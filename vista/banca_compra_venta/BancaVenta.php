<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  (favio figueroa)
*@date 16-09-2015 10:22:05
*@description Archivo con la interfaz de usuario que permite 
*dar el visto a solicitudes de compra
*
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.BancaVenta = {
    
	require: '../../../sis_contabilidad/vista/banca_compra_venta/BancaCompraVenta.php',
	requireclase: 'Phx.vista.BancaCompraVenta',
	title: 'Bancarización Ventas',
	nombreVista: 'BancaVenta',
	tipoBan: 'Ventas',
	
	constructor: function(config) {
	    Phx.vista.BancaVenta.superclass.constructor.call(this,config);
    },
    
    loadValoresIniciales: function() {
    	Phx.vista.BancaVenta.superclass.loadValoresIniciales.call(this);
        this.Cmp.tipo.setValue(this.tipoBan); 
      
        
   },
   capturaFiltros:function(combo, record, index){
        this.store.baseParams.tipo = this.tipoBan;
        Phx.vista.BancaVenta.superclass.capturaFiltros.call(this,combo, record, index);
    },
    
    
	
	
};
</script>