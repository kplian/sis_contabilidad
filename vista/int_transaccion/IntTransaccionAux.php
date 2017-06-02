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
Phx.vista.IntTransaccionAux = {
   require: '../../../sis_contabilidad/vista/int_transaccion/IntTransaccion.php',
	requireclase: 'Phx.vista.IntTransaccion',
	title: 'Libro Diario',
	nombreVista: 'IntTransaccionLdAux',
	
	constructor: function(config) {
	    Phx.vista.IntTransaccionAux.superclass.constructor.call(this,config);
	    this.iniciarEventos();
    
    },
    preparaMenu:function(){
		var rec = this.sm.getSelected();
		var tb = this.tbar;
		Phx.vista.IntTransaccionAux.superclass.preparaMenu.call(this);
		this.getBoton('btnBanco').disable();
	},
	
	liberaMenu: function() {
		var tb = Phx.vista.IntTransaccionAux.superclass.liberaMenu.call(this);
		this.getBoton('btnBanco').setDisabled(true);
		
	},
	iniciarEventos: function(){
		
		 this.Cmp.id_centro_costo.on('select',function(cmp.rec,ind){
		 	     this.Cmp.id_orden_trabajo.reset();
		 }, this);
		 
		 this.Cmp.id_cuenta.on('select',function(cmp.rec,ind){
		 	     this.Cmp.id_partida.reset();
		 	     this.Cmp.id_auxiliar.reset();
		 }, this);
		 
		 this.Cmp.id_orden_trabajo.on('select',function(cmp.rec,ind){
		 	     this.Cmp.id_suborden.reset();
		 }, this);
		 
		 
	}
	
};
</script>
