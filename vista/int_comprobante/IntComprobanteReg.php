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
Phx.vista.IntComprobanteReg = {
    bedit:false,
    bnew:false,
    bsave:false,
    bdel:true,
	require: '../../../sis_contabilidad/vista/int_comprobante/IntComprobante.php',
	requireclase: 'Phx.vista.IntComprobante',
	title: 'Libro Diario',
	nombreVista: 'IntComprobanteReg',
	
	constructor: function(config) {
	    Phx.vista.IntComprobanteReg.superclass.constructor.call(this,config);
	    
	    
	    //Botón para Validación del Comprobante
			this.addButton('btnValidar', {
				text : 'Validación',
				iconCls : 'bchecklist',
				disabled : true,
				handler : this.validarCbte,
				tooltip : '<b>Validación</b><br/>Validación del Comprobante'
			});
			
	    this.addButton('btnWizard', {
				text : 'Plantilla',
				iconCls : 'bgear',
				disabled : false,
				handler : this.loadWizard,
				tooltip : '<b>Plantilla de Comprobantes</b><br/>Seleccione una plantilla y genere comprobantes preconfigurados'
			});

			
			
			this.addButton('btnIgualarCbte', {
				text : 'Igualar',
				iconCls : 'bengineadd',
				disabled : false,
				handler : this.igualarCbte,
				tooltip : '<b>Igualar comprobante</b><br/>Si existe diferencia por redondeo o por tipo de cambio inserta una transacción para igualar'
			});
    
    },
	
   
	onButtonEdit:function(){
         this.swButton = 'EDIT';
         var rec = this.sm.getSelected().data;
         Phx.vista.IntComprobante.superclass.onButtonEdit.call(this); 
         this.Cmp.id_moneda.setReadOnly(true);
         if(rec.localidad == 'internacional'){
         	this.Cmp.fecha.setReadOnly(true);
         }
         //si el tic vari en lastransacciones ..
         if(rec.sw_tipo_cambio == 'si'){
            this.ocultarComponente(this.Cmp.tipo_cambio);
            this.ocultarComponente(this.Cmp.tipo_cambio_2);
         }
         else{
         	this.mostrarComponente(this.Cmp.tipo_cambio);
            this.mostrarComponente(this.Cmp.tipo_cambio_2);
            //Actuizar label ...
            this.sw_valores = 'no';
            this.getConfigCambiaria();
         }
         
       },
       
       onButtonNew:function(){
          this.swButton = 'NEW';
          this.sw_valores = 'si';
          Phx.vista.IntComprobante.superclass.onButtonNew.call(this); 
          this.Cmp.id_moneda.setReadOnly(false);
          this.Cmp.fecha.setReadOnly(false);
          this.mostrarComponente(this.Cmp.tipo_cambio);
          this.mostrarComponente(this.Cmp.tipo_cambio_2);
       },
       
       igualarCbte: function() {
			   
			    var rec = this.sm.getSelected().data;
			    Phx.CP.loadingShow();
				Ext.Ajax.request({
					url : '../../sis_contabilidad/control/IntComprobante/igualarComprobante',
					params : {
						id_int_comprobante : rec.id_int_comprobante
					},
					success : function(resp) {
						Phx.CP.loadingHide();
						var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
						if (reg.ROOT.error) {
							Ext.Msg.alert('Error', 'No se pudo igualar el cbte: ' + reg.ROOT.error)
						} else {
							this.reload();
						}
					},
					failure : this.conexionFailure,
					timeout : this.timeout,
					scope : this
				});
			

		},
       preparaMenu : function(n) {
			var tb = Phx.vista.IntComprobante.superclass.preparaMenu.call(this);
			this.getBoton('btnValidar').setDisabled(false);
			this.getBoton('btnImprimir').setDisabled(false);
			this.getBoton('btnRelDev').setDisabled(false);
			this.getBoton('btnIgualarCbte').setDisabled(false);
			
			

			return tb;
		},
		liberaMenu : function() {
			var tb = Phx.vista.IntComprobante.superclass.liberaMenu.call(this);
			this.getBoton('btnValidar').setDisabled(true);
			this.getBoton('btnImprimir').setDisabled(true);
			this.getBoton('btnRelDev').setDisabled(true);
			this.getBoton('btnIgualarCbte').setDisabled(true);
		},
		getTipoCambio : function() {
			//Verifica que la fecha y la moneda hayan sido elegidos
			if (this.Cmp.fecha.getValue() && this.Cmp.id_moneda.getValue()) {
				Ext.Ajax.request({
					url : '../../sis_parametros/control/TipoCambio/obtenerTipoCambio',
					params : {
						fecha : this.Cmp.fecha.getValue(),
						id_moneda : this.Cmp.id_moneda.getValue(),
						tipo : 'O'
					},
					success : function(resp) {
						Phx.CP.loadingHide();
						var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
						if (reg.ROOT.error) {
							Ext.Msg.alert('Error', 'Validación no realizada: ' + reg.ROOT.error)
						} else {
							this.Cmp.tipo_cambio.setValue(reg.ROOT.datos.tipo_cambio);
						}
					},
					failure : this.conexionFailure,
					timeout : this.timeout,
					scope : this
				});
			}

		},
        sw_valores:'si',
		getConfigCambiaria : function() {

			var localidad = 'nacional';
			
			if (this.swButton == 'EDIT') {
				var rec = this.sm.getSelected();
				localidad = rec.data.localidad;
				
			}

			//Verifica que la fecha y la moneda hayan sido elegidos
			if (this.Cmp.fecha.getValue() && this.Cmp.id_moneda.getValue()) {
				Phx.CP.loadingShow();
				Ext.Ajax.request({
				url:'../../sis_contabilidad/control/ConfigCambiaria/getConfigCambiaria',
				params:{
					fecha: this.Cmp.fecha.getValue(),
					id_moneda: this.Cmp.id_moneda.getValue(),
					localidad: localidad,
					sw_valores: this.sw_valores,
					tipo: 'O'
				}, success: function(resp) {
					Phx.CP.loadingHide();
					var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
					if (reg.ROOT.error) {
						this.Cmp.tipo_cambio.reset();
						this.Cmp.tipo_cambio_2.reset();
						Ext.Msg.alert('Error', 'Validación no realizada: ' + reg.ROOT.error)
					} else {
						
						//cambia labels
						
						this.Cmp.tipo_cambio.label.update(reg.ROOT.datos.v_tc1 +' (tc)');
						this.Cmp.tipo_cambio_2.label.update(reg.ROOT.datos.v_tc2 +' (tc)');
						if (this.sw_valores == 'si'){
						    //poner valores por defecto
						 	this.Cmp.tipo_cambio.setValue(reg.ROOT.datos.v_valor_tc1);
						    this.Cmp.tipo_cambio_2.setValue(reg.ROOT.datos.v_valor_tc2);
						}
						
					   
					   this.Cmp.id_config_cambiaria.setValue(reg.ROOT.datos.id_config_cambiaria);
					}
					

				}, failure: function(a,b,c,d){
					this.Cmp.tipo_cambio.reset();
					this.Cmp.tipo_cambio_2.reset();
					this.conexionFailure(a,b,c,d)
				},
				timeout: this.timeout,
				scope:this
				});
			}

		},
		validarCbte : function() {
			Ext.Msg.confirm('Confirmación', '¿Está seguro de Validar el Comprobante?', function(btn, x, c) {
				if (btn == 'yes') {
					var rec = this.sm.getSelected();
					Phx.CP.loadingShow();
					Ext.Ajax.request({
						url : '../../sis_contabilidad/control/IntComprobante/validarIntComprobante',
						params : {
							id_int_comprobante : rec.data.id_int_comprobante,
							igualar : 'no'
						},
						success : function(resp) {
							Phx.CP.loadingHide();
							var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
							if (reg.ROOT.error) {
								Ext.Msg.alert('Error', 'Validación no realizada: ' + reg.ROOT.error)
							} else {
								this.reload();
								Ext.Msg.alert('Mensaje', 'Proceso ejecutado con éxito')
							}
						},
						failure : this.conexionFailure,
						timeout : this.timeout,
						scope : this
					});
				}
			}, this);
		},
		
	
};
</script>
