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
Phx.vista.IntComprobanteLd = {
    bedit: false,
    bnew: false,
    bsave: false,
    bdel: true,
	require: '../../../sis_contabilidad/vista/int_comprobante/IntComprobante.php',
	requireclase: 'Phx.vista.IntComprobante',
	title: 'Libro Diario',
	nombreVista: 'IntComprobanteLd',
	
	constructor: function(config) {
	    Phx.vista.IntComprobanteLd.superclass.constructor.call(this,config);
	    
	    this.addButton('btnVolcar', {
				text : 'Volcar',
				iconCls : 'balert',
				disabled : true,
				handler : this.volcarCbte,
				tooltip : '<b>Volcar</b><br/>Genera un cbte volcado que revierte el actual'
		});
		
		this.addButton('chkdep',{	text:'Dependencias',
				iconCls: 'blist',
				disabled: true,
				handler: this.checkDependencias,
				tooltip: '<b>Revisar Dependencias </b><p>Revisar dependencias del comprobante</p>'
			});
	    
	    
    
    },
    
     volcarCbte: function() {
			  
			 if(confirm("Esta seguro de volcar el cbte,  este proceso no puede revertirse (Si tiene presupuesto será revertido)!")){
			 	 if(confirm("¿Esta realmente seguro?")){
				 	var rec = this.sm.getSelected().data;
				    Phx.CP.loadingShow();
					Ext.Ajax.request({
						url : '../../sis_contabilidad/control/IntComprobante/volcarCbte',
						params : {
							id_int_comprobante : rec.id_int_comprobante
						},
						success : function(resp) {
							Phx.CP.loadingHide();
							var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
							if (reg.ROOT.error) {
								Ext.Msg.alert('Error', 'Al volcar el cbte: ' + reg.ROOT.error)
							} else {
								this.reload();
							}
						},
						failure : this.conexionFailure,
						timeout : this.timeout,
						scope : this
					});
				}
			 }
			    
	},
	
   south:{
	  url:'../../../sis_contabilidad/vista/int_transaccion/IntTransaccionLd.php',
	  title:'Transacciones', 
	  height:'50%',	//altura de la ventana hijo
	  cls:'IntTransaccionLd'
	},
	preparaMenu : function(n) {
			var tb = Phx.vista.IntComprobante.superclass.preparaMenu.call(this);
			this.getBoton('btnImprimir').enable();
			this.getBoton('btnRelDev').enable();
			this.getBoton('btnDocCmpVnt').enable();
			this.getBoton('chkpresupuesto').enable();
			this.getBoton('btnVolcar').enable();
			this.getBoton('chkdep').enable();
			
			return tb;
	},
	liberaMenu : function() {
			var tb = Phx.vista.IntComprobante.superclass.liberaMenu.call(this);
			this.getBoton('btnImprimir').disable();
			this.getBoton('btnRelDev').disable();
			this.getBoton('btnDocCmpVnt').disable();
			this.getBoton('chkpresupuesto').disable();
			this.getBoton('btnVolcar').disable();
			this.getBoton('chkdep').disable();
			
	},
	checkDependencias: function(){                   
			  var rec=this.sm.getSelected();
			  var configExtra = [];
			  this.objChkPres = Phx.CP.loadWindows('../../../sis_contabilidad/vista/int_comprobante/CbteDependencias.php',
										'Dependencias',
										{
											modal:true,
											width: '80%',
											height: '80%'
										}, 
										  rec.data, 
										  this.idContenedor,
										 'CbteDependencias');
			   
	 },
	
	
};
</script>
