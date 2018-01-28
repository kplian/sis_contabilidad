<?php
/**
*@package pXP
*@file FormCompraVentaCustom.php
*@author  RCM
*@date 27/01/2018
*@description Archivo con la interfaz de usuario que permite registrar facturas y recibos personalizado
*
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.FormCompraVentaCustom = {
    
	require: '../../../sis_contabilidad/vista/doc_compra_venta/FormCompraVenta.php',
	requireclase: 'Phx.vista.FormCompraVenta',
	title: 'Facturas/Recibos',
	nombreVista: 'FormCompraVenta',
	//regitrarDetalle: 'si',
	id_plantilla: 0,	
	constructor: function(config) {
		console.log('QQQ',config)
	    var me = this;
		me.regitrarDetalle = config.regitrarDetalle;

	    Phx.vista.FormCompraVentaCustom.superclass.constructor.call(this,config);
		Phx.CP.loadingShow();

	    this.id_plantilla = config.data.id_plantilla;
	    //Por problema de sincronia se pone timeout
	    setTimeout(function(){ 
	    	//Agrega el tipo de documento al store del tipo de plantilla
	    	me.id_plantilla = config.data.id_plantilla;
	    	Ext.apply(me.Cmp.id_plantilla.store.baseParams, {id_plantilla: me.id_plantilla});

	    	me.Cmp.id_depto_conta.setValue(config.data.id_depto);
	    	console.log('MMMM',config.data.id_depto);
	    	me.detCmp.id_centro_costo.store.baseParams.id_depto = config.data.id_depto;
	    	me.detCmp.id_centro_costo.store.baseParams.id_gestion = config.data.id_gestion;

	    	Phx.CP.loadingHide();
	    }, 1000);

    },
    
    loadValoresIniciales: function() {
    	Phx.vista.FormCompraVentaCustom.superclass.loadValoresIniciales.call(this);
   	},
   
    preparaMenu:function(tb){
    	Phx.vista.FormCompraVentaCustom.superclass.preparaMenu.call(this,tb)
    }
   
};
</script>
