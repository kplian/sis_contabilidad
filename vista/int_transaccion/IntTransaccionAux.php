<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  (fprudencio)
*@date 20-09-2011 10:22:05
*@description Archivo con la interfaz de usuario que permite 
*dar el visto a solicitudes de compra

 *HISTORIAL DE MODIFICACIONES:
	ISSUE			FECHA 				AUTHOR 						DESCRIPCION
  #1	      20-09-2011			RAC							creacion 
  #108        04/03/2020            RAC                         Adicionar boton para generar cheques depositos en LB
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.IntTransaccionAux = {
    require: '../../../sis_contabilidad/vista/int_transaccion/IntTransaccion.php',
	requireclase: 'Phx.vista.IntTransaccion',
	title: 'Libro Diario',
	conta_generar_lb_manual_oc: 'no',
	nombreVista: 'IntTransaccionLdAux',
	
	constructor: function(config) {
	    Phx.vista.IntTransaccionAux.superclass.constructor.call(this,config);
	    this.iniciarEventos();
	    
	    this.addButton('btnGenLb',
            {
                text: 'Generar LB',
                iconCls: 'bchecklist',
                disabled: true,
                handler: this.generarLb,
                tooltip: '<b>Generar Libro de Bancos</b><br/>Si la transacción afecta bancos permite generar registros en libro de bancos'
            }
        );
        
    
    },
    
    //dobrecarga funcion  variable global
    obtenerVariableGlobal: function(param){
		//Verifica que la fecha y la moneda hayan sido elegidos
		Phx.CP.loadingShow();
		Ext.Ajax.request({
				url:'../../sis_seguridad/control/Subsistema/obtenerVariableGlobal',
				params:{
					codigo: param  
				},
				success: function(resp){
					Phx.CP.loadingHide();
					var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
					
					if (reg.ROOT.error) {
						Ext.Msg.alert('Error','Error a recuperar la variable global')
					} else {
						if (param == 'conta_partidas'){
							if(reg.ROOT.datos.valor == 'no'){
								this.ocultarComponente(this.Cmp.id_partida);
							}
							
							this.obtenerVariableGlobal('conta_ejecucion_igual_pres_conta');
						}
						
						if (param == 'conta_ejecucion_igual_pres_conta'){
							if(reg.ROOT.datos.valor == 'si'){
								this.ocultarComponente(this.Cmp.importe_gasto);
								this.ocultarComponente(this.Cmp.importe_recurso);
								this.obtenerVariableGlobal('conta_generar_lb_manual_oc');
							}	
						}
						
						if (param == 'conta_generar_lb_manual_oc'){
							if(reg.ROOT.datos.valor == 'si'){
								this.conta_generar_lb_manual_oc = reg.ROOT.datos.valor;
							}	
						}
						
					}
				},
				failure: this.conexionFailure,
				timeout: this.timeout,
				scope:this
			});
		
	},
	
    generarLb: function () {
    	Phx.CP.loadingShow();
		Ext.Ajax.request({
				url:'../../sis_contabilidad/control/IntTransaccion/generarLB',
				params:{
					id_int_comprobante: this.maestro.id_int_comprobante 
				},
				success : function(resp) {
						Phx.CP.loadingHide();
						var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
						if (reg.ROOT.error) {
							Ext.Msg.alert('Error', 'error al generar Libro de bancos ' + reg.ROOT.error)
						} else {
							this.reload();
						}
				},
				failure: this.conexionFailure,
				timeout: this.timeout,
				scope:this
			});
    },
    preparaMenu:function(){
		var rec = this.sm.getSelected();
		var tb = this.tbar;
		this.getBoton('btnBanco').disable();
		console.log(this.maestro.prioridad_depto ,  this.conta_generar_lb_manual_oc )
		if (this.maestro.prioridad_depto == 0 && this.conta_generar_lb_manual_oc == 'si' ) {
			this.getBoton('btnGenLb').enable();
		} else {
			this.getBoton('btnGenLb').disable();
		}
		
		Phx.vista.IntTransaccionAux.superclass.preparaMenu.call(this);
	},
	
	liberaMenu: function() {
		var tb = Phx.vista.IntTransaccionAux.superclass.liberaMenu.call(this);
		this.getBoton('btnBanco').setDisabled(true);
		if (this.maestro.prioridad_depto == 0 && this.conta_generar_lb_manual_oc == 'si' ) {
			this.getBoton('btnGenLb').enable();
		} else {
			this.getBoton('btnGenLb').disable();
		}
		
	},
	iniciarEventos: function(){
		
		 this.Cmp.id_centro_costo.on('select',function(cmp,rec,ind){
		 	  this.Cmp.id_orden_trabajo.reset();
		 	  this.Cmp.id_orden_trabajo.store.baseParams.id_centro_costo = rec.data.id_centro_costo;
		 	  this.Cmp.id_orden_trabajo.modificado = true;		 	  
		 	  this.Cmp.id_partida.store.baseParams.id_centro_costo = rec.data.id_centro_costo;
		 	  this.Cmp.id_partida.modificado = true;
		 	  this.Cmp.id_cuenta.store.baseParams.id_centro_costo = rec.data.id_centro_costo;
		 	  this.Cmp.id_cuenta.modificado = true;
		 	  this.Cmp.id_auxiliar.store.baseParams.id_centro_costo = rec.data.id_centro_costo;
		 	  this.Cmp.id_auxiliar.modificado = true;
		 	  
		 	  
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
