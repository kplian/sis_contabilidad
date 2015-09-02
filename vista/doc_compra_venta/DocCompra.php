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
Phx.vista.DocCompra = {
    
	require: '../../../sis_contabilidad/vista/doc_compra_venta/DocCompraVenta.php',
	requireclase: 'Phx.vista.DocCompraVenta',
	title: 'Libro de Compras',
	nombreVista: 'DocCompra',
	
	constructor: function(config) {
	    Phx.vista.DocCompra.superclass.constructor.call(this,config);
        this.Cmp.id_plantilla.store.baseParams = Ext.apply(this.Cmp.id_plantilla.store.baseParams, {tipo_plantilla:'compra'});
    },
    
    loadValoresIniciales: function() {
    	Phx.vista.DocCompra.superclass.loadValoresIniciales.call(this);
        this.Cmp.tipo.setValue('compra'); 
        
   },
   capturaFiltros:function(combo, record, index){
        this.store.baseParams.tipo = 'compra';
        Phx.vista.DocCompra.superclass.capturaFiltros.call(this,combo, record, index);
    },
    
    
	
	
};
</script>
