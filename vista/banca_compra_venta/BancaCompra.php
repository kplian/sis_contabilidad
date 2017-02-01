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
Phx.vista.BancaCompra = {
    
	require: '../../../sis_contabilidad/vista/banca_compra_venta/BancaCompraVenta.php',
	requireclase: 'Phx.vista.BancaCompraVenta',
	title: 'Bancarización Compras',
	nombreVista: 'BancaCompra',
	tipoBan: 'Compras',
	
	constructor: function(config) {
	    Phx.vista.BancaCompra.superclass.constructor.call(this,config);
    },
    
    loadValoresIniciales: function() {
    	Phx.vista.BancaCompra.superclass.loadValoresIniciales.call(this);
        this.Cmp.tipo.setValue(this.tipoBan); 
      
        
   },
   capturaFiltros:function(combo, record, index){
        this.store.baseParams.tipo = this.tipoBan;
        Phx.vista.BancaCompra.superclass.capturaFiltros.call(this,combo, record, index);
    },
    
    
	
	
};
</script>