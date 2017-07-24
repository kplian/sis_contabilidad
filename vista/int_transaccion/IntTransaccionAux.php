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
		this.getBoton('btnBanco').disable();
		Phx.vista.IntTransaccionAux.superclass.preparaMenu.call(this);
	},
	
	liberaMenu: function() {
		var tb = Phx.vista.IntTransaccionAux.superclass.liberaMenu.call(this);
		this.getBoton('btnBanco').setDisabled(true);
		
	},
	iniciarEventos: function(){
		
		 this.Cmp.id_centro_costo.on('select',function(cmp,rec,ind){
		 	  this.Cmp.id_orden_trabajo.reset();
		 	  this.Cmp.id_orden_trabajo.store.baseParams.id_centro_costo = rec.data.id_centro_costo;
		 	  this.Cmp.id_orden_trabajo.modificado = true;		 	  
		 	  this.Cmp.id_partida.store.baseParams.id_centro_costo = rec.data.id_centro_costo;
		 	  this.Cmp.id_partida.modificado = true;
		 	  
		 }, this);
		 
		 this.Cmp.id_partida.on('select',function(cmp,rec,ind){
		 	     this.Cmp.id_cuenta.reset();		 	     
		 	     this.Cmp.id_cuenta.store.baseParams.id_partida = rec.data.id_partida;
		 	     this.Cmp.id_cuenta.modificado = true;
		 }, this);
		  
		 this.Cmp.id_cuenta.on('select',function(cmp,rec,ind){		 	     
		 	     this.Cmp.id_auxiliar.reset();		 	     
		 	     this.Cmp.id_auxiliar.store.baseParams.id_cuenta = rec.data.id_cuenta;
		 	     this.Cmp.id_auxiliar.modificado = true;
		 }, this);
		 
		 this.Cmp.id_orden_trabajo.on('select',function(cmp,rec,ind){
		 	     this.Cmp.id_suborden.reset();
		 	     this.Cmp.id_suborden.store.baseParams.id_orden_trabajo = rec.data.id_orden_trabajo;
		 	     this.Cmp.id_suborden.modificado = true;
		 }, this);
	},
	
	onButtonEdit:function(){

	         this.swButton = 'EDIT';
	         var rec = this.sm.getSelected().data;
	         Phx.vista.IntTransaccionAux.superclass.onButtonEdit.call(this); 
	         
	         this.Cmp.id_partida.store.baseParams.id_centro_costo = rec.id_centro_costo;
		 	 this.Cmp.id_partida.modificado = true;		 	 
		 	 this.Cmp.id_cuenta.store.baseParams.id_partida = rec.id_partida;
		 	 this.Cmp.id_cuenta.modificado = true;		 	 
		 	 this.Cmp.id_auxiliar.store.baseParams.id_cuenta = rec.id_cuenta;
		 	 this.Cmp.id_auxiliar.modificado = true;
		 	 this.Cmp.id_orden_trabajo.store.baseParams.id_centro_costo = rec.id_centro_costo;
		 	 this.Cmp.id_orden_trabajo.modificado = true
		 	 this.Cmp.id_suborden.store.baseParams.id_orden_trabajo = rec.id_orden_trabajo;
		 	 this.Cmp.id_suborden.modificado = true;
		 	 
		 	
	         
	         
       },
	
	
};
</script>
