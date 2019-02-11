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
Phx.vista.DocCompraBOA = {
    
	require: '../../../sis_contabilidad/vista/doc_compra_venta/DocCompraVenta.php',
	ActList:'../../sis_contabilidad/control/DocCompraVenta/listarDocCompraCajero',
	requireclase: 'Phx.vista.DocCompraVenta',
	title: 'Libro de Compras',
	nombreVista: 'DocCompra',
	tipoDoc: 'compra',
	formTitulo: 'Formulario de Documento Compra',
	
	constructor: function(config) {		
	    Phx.vista.DocCompraBOA.superclass.constructor.call(this,config);
    },
    modificarAtributos: function(){
        	this.Atributos[this.getIndAtributo('estacion')].grid=true;
            this.Atributos[this.getIndAtributo('codigo_noiata')].grid=true;
            this.Atributos[this.getIndAtributo('nombre')].grid=true;

    },
    
    loadValoresIniciales: function() {
    	Phx.vista.DocCompraBOA.superclass.loadValoresIniciales.call(this);
        
        
   },
   capturaFiltros:function(combo, record, index){
        this.store.baseParams.tipo = this.tipoDoc;
        Phx.vista.DocCompraBOA.superclass.capturaFiltros.call(this,combo, record, index);
    },
    
    
	
	
};
</script>
