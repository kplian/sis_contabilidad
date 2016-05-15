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
	tipoDoc: 'compra',
	formTitulo: 'Formulario de Documento Compra',
	
	constructor: function(config) {
	    Phx.vista.DocCompra.superclass.constructor.call(this,config);
        //this.Cmp.id_plantilla.store.baseParams = Ext.apply(this.Cmp.id_plantilla.store.baseParams, {tipo_plantilla:this.tipoDoc});
    },
    
    loadValoresIniciales: function() {
    	Phx.vista.DocCompra.superclass.loadValoresIniciales.call(this);
        //this.Cmp.tipo.setValue(this.tipoDoc); 
        
   },
   capturaFiltros:function(combo, record, index){
        this.store.baseParams.tipo = this.tipoDoc;
        Phx.vista.DocCompra.superclass.capturaFiltros.call(this,combo, record, index);
    },
    
    
	
	
};
</script>
