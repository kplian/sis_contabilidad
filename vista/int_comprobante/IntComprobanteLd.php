<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  (fprudencio)
*@date 20-09-2011 10:22:05
*@description Archivo con la interfaz de usuario que permite 
*dar el visto a solicitudes de compra

 * 
 *  ISSUE            FECHA:		      AUTOR                 DESCRIPCION
   
 #1        		20-09-2011       RCM KPLIAN        CREACION
 #2             27-08-2018       RAC KPLIAN        adciona edicion de glosa
 #55			30/05/2019		 EGS			   Se cre boton para poder migrar comprobantes a otra bd de pxp 

*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.IntComprobanteLd = {
    bedit: false,
    bnew: false,
    bsave: true,
    bdel: true,
	require: '../../../sis_contabilidad/vista/int_comprobante/IntComprobante.php',
	requireclase: 'Phx.vista.IntComprobante',
	title: 'Libro Diario',
	nombreVista: 'IntComprobanteLd',
	ActSave : '../../sis_contabilidad/control/IntComprobante/modificarFechasCostosCbte',
	constructor: function(config) {
	    Phx.vista.IntComprobanteLd.superclass.constructor.call(this,config);
	    
	    this.addBotonesVolcar();
		this.addBotonesClonar();
		
		
		this.addButton('btnWizard', {
					text : 'Plantilla',
					iconCls : 'bgear',
					disabled : true,
					handler : this.loadWizard,
					scope:this,
					tooltip : '<b>Plantilla de Comprobantes</b><br/>Seleccione una plantilla y genere comprobantes preconfigurados'
			});	
			
		this.addButton('btnWizardGlosa', {
					text : 'Glosa',
					iconCls : 'bgear',
					disabled : true,
					handler : this.loadWizardGlosa,
					scope:this,
					tooltip : '<b>Cambio de Glosa</b> Permite editar la glosa del cbte, queda un BK en el log de seguridad'
			});		
		this.addButton('btnmigraCbte', {//#55
				text : 'Migracion Comprobante',
				iconCls : 'badjunto',
				disabled : true,
				handler : this.migraCbte,
				tooltip : '<b>Migra Comprobante</b><br/>'
			});		
			
	   this.init();	 
	},
    
   volcarCbte: function(sw_validar) {
			  
			 if(confirm("Esta seguro de volcar el cbte,  este proceso no puede revertirse (Si tiene presupuesto será revertido)!")){
			 	 if(confirm("¿Esta realmente seguro?")){
				 	var rec = this.sm.getSelected().data;
				    Phx.CP.loadingShow();
					Ext.Ajax.request({
						url : '../../sis_contabilidad/control/IntComprobante/volcarCbte',
						params : {
							id_int_comprobante : rec.id_int_comprobante,
							sw_validar: (sw_validar=='si')?'si':'no'
						},
						success : function(resp) {
							Phx.CP.loadingHide();
							var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
							if (reg.ROOT.error) {
								Ext.Msg.alert('Error', 'Al volcar el cbte: ' + reg.ROOT.error)
							} else {
								this.reload()
							}
						},
						failure : this.conexionFailure,
						timeout : this.timeout,
						scope : this
					});
				}
			 }
			    
	},
	
	clonarCbteSt: function(){
		this.clonarCbte('si');
	},
    clonarCbte: function(sw_tramite) {
	 		  
			 if(confirm("Esta seguro de clonar  el cbte")){
			 	 if(confirm("¿Esta realmente seguro?")){
				 	var rec = this.sm.getSelected().data;
				    Phx.CP.loadingShow();
					Ext.Ajax.request({
						url : '../../sis_contabilidad/control/IntComprobante/clonarCbte',
						params : {
							id_int_comprobante : rec.id_int_comprobante,
							sw_tramite: sw_tramite=='si'?'si':'no'
						},
						success : function(resp) {
							Phx.CP.loadingHide();
							var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
							if (reg.ROOT.error) {
								Ext.Msg.alert('Error', 'Al clonar el cbte: ' + reg.ROOT.error)
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
	  url: '../../../sis_contabilidad/vista/int_transaccion/IntTransaccionLd.php',
	  title: 'Transacciones', 
	  height: '50%',	//altura de la ventana hijo
	  cls: 'IntTransaccionLd'
	},
	preparaMenu : function(n) {
			var tb = Phx.vista.IntComprobanteLd.superclass.preparaMenu.call(this);
			var rec = this.sm.getSelected();
			this.getBoton('btnImprimir').enable();
			this.getBoton('btnRelDev').enable();
			//this.getBoton('btnDocCmpVnt').enable();
			this.getBoton('chkpresupuesto').enable();
			this.getBoton('btnVolcar').enable();
			this.getBoton('btnClonar').enable();
			this.getBoton('chkdep').enable();
			this.getBoton('btnChequeoDocumentosWf').enable();
            this.getBoton('diagrama_gantt').enable();
            this.getBoton('btnObs').enable();
            this.getBoton('btnWizard').enable();
            this.getBoton('btnWizardGlosa').enable();
            this.getBoton('btnmigraCbte').enable();  //#55
            
            
			
			if(rec.data.momento =='presupuestario'||rec.data.momento =='contable'){  //OGO ANALIZAR MEJOR  registor de documentos en cbte contable
				this.getBoton('btnDocCmpVnt').enable();
			}else{
				this.getBoton('btnDocCmpVnt').disable();
			}
            
			
			return tb;
	},
	liberaMenu : function() {
			var tb = Phx.vista.IntComprobanteLd.superclass.liberaMenu.call(this);
			this.getBoton('btnImprimir').disable();
			this.getBoton('btnRelDev').disable();
			this.getBoton('btnDocCmpVnt').disable();
			this.getBoton('chkpresupuesto').disable();
			this.getBoton('btnVolcar').disable();
			this.getBoton('btnClonar').disable();
			this.getBoton('chkdep').disable();
			this.getBoton('btnChequeoDocumentosWf').disable();
            this.getBoton('diagrama_gantt').disable();
            this.getBoton('btnObs').disable();
            this.getBoton('btnWizard').disable() ;
            this.getBoton('btnWizardGlosa').disable(); 
            this.getBoton('btnmigraCbte').enable();	//#55
          
			
	},
	
	addBotonesClonar: function() {
        this.menuClonar = new Ext.Toolbar.SplitButton({
            id: 'b-btnClonar-' + this.idContenedor,
            text: 'Clonar',
            disabled: true,
            grupo:[0,1,2,3],
            iconCls : 'balert',
            scope: this,
            menu:{
            items: [{
                id:'b-sint-' + this.idContenedor,
                text: 'Clonar sin  Trámite',
                tooltip: '<b>Clonar el cbte sin mantener el nro de trámite</b>',
                handler:function(){this.clonarCbteSt()},
                scope: this
            }, {
                id:'b-cont-' + this.idContenedor,
                text: 'Clonar con Trámite',
                tooltip: '<b>Clonar el cbte manteniendo el nro de trámite</b>',
                handler:function(){this.clonarCbte()},
                scope: this
            }
        ]}
        });
		this.tbar.add(this.menuClonar	);
    },
    
    addBotonesVolcar: function() {
        this.menuClonar = new Ext.Toolbar.SplitButton({
            id: 'b-btnVolcar-' + this.idContenedor,
            text: 'Revertir',
            disabled: true,
            grupo:[0,1,2,3],
            iconCls : 'balert',
            scope: this,
            menu:{
            items: [{
                id:'b-volb-' + this.idContenedor,
                text: 'Reversión Parcial (borrador)',
                tooltip: '<b>Al volcar en borrador tiene la opción de revertir parcialmente</b>',
                handler:function(){this.volcarCbte('no')},
                scope: this
            }, {
                id:'b-vol-' + this.idContenedor,
                text: 'Reversión Total (Validado)',
                tooltip: '<b>Al volcar y validar se revierte el 100%</b>',
                handler:function(){this.volcarCbte('si')},
                scope: this
            }
        ]}
        });
		this.tbar.add(this.menuClonar);
    },
    
    
    loadWizard : function() {
			
			var rec = this.sm.getSelected();			
			Phx.CP.loadWindows('../../../sis_contabilidad/vista/int_comprobante/WizardCbteDiario.php', 'Generar comprobante desde plantilla ...', {
				width : '40%',
				height : 300
			}, {
				'id_int_comprobante': rec.data.id_int_comprobante,
				'id_depto': this.cmbDepto.getValue()
			   }, this.idContenedor, 'WizardCbteDiario')
		},
		
	loadWizardGlosa : function() {
			
			var rec = this.sm.getSelected();			
			Phx.CP.loadWindows('../../../sis_contabilidad/vista/int_comprobante/WizardGlosaCbte.php', 'Cambiar glosa ...', {
				width : '40%',
				height : 300
			}, {
				'id_int_comprobante': rec.data.id_int_comprobante,
				'glosa1': rec.data.glosa1
			   }, this.idContenedor, 'WizardGlosaCbte')
		},
		
		migraCbte: function () { //#55
			   var migrar_todo;
			   var filas = this.sm.getSelections();
	                var data = [], aux = {};
	                //arma una matriz de los identificadores de registros que se van a eliminar
	                this.agregarArgsExtraSubmit();
	                var rr = {};
	                for (var i = 0; i < this.sm.getCount(); i++) {
	                    aux = {};
	                    aux[this.id_store] = filas[i].data[this.id_store];
	                    aux.id_int_comprobante = filas[i].data.id_int_comprobante;
	                    data.push(aux);
	                }
	     		var rec = {maestro: this.sm.getSelected().data, id_int_comprobante: Ext.util.JSON.encode(data)}
				console.log("ver ooo ",rec);
	
			    var opcion = confirm('Seguro que quiere migrar los comprobantes con :'+rec.id_int_comprobante+' ');
			    if (opcion == true) {
			    				 Ext.Msg.confirm('Confirmación', 'Desea migrar los comprobantes que comparten el mismo numero de tramite (si/no)', function(btn) {
								if (btn == "yes") {
									migrar_todo = 'si';
					               Phx.CP.loadingShow();
										Ext.Ajax.request({
											url : '../../sis_contabilidad/control/IntComprobante/migrarComprobante',
											params : {
												'id_int_comprobante' : rec.id_int_comprobante,
												'todo':migrar_todo
											},
											success : function(resp){
				                    				Ext.Msg.alert('mensaje', 'Comprobantes Migrados');
													 Phx.CP.loadingHide();//para ocultar el loading al cargar el sucess
				                   					 
				               				 },
											failure: function(resp){
				                	 				Phx.CP.loadingHide();
				                    					 var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
												     if (reg.ROOT.error) {
												     	 Ext.Msg.alert('Error',reg.ROOT.detalle.mensaje)
				                   					 }
				               				 },
										    timeout: this.timeout,
										   scope: this
										})
								}
								else{
									migrar_todo = 'no';
									Phx.CP.loadingShow();
										Ext.Ajax.request({
											url : '../../sis_contabilidad/control/IntComprobante/migrarComprobante',
											params : {
												'id_int_comprobante' : rec.id_int_comprobante,
												'todo':migrar_todo
											},
											success : function(resp){
				                	 				Ext.Msg.alert('mensaje', 'Comprobantes Migrados');
													 Phx.CP.loadingHide();//para ocultar el loading al cargar el sucess
				               				 },
											failure: function(resp){
				                	 				Phx.CP.loadingHide();
				                    					 var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
												     if (reg.ROOT.error) {
												     	 Ext.Msg.alert('Error',reg.ROOT.detalle.mensaje)
				                   					 }
				               				 },
										    timeout: this.timeout,
										   scope: this
										})
					               
								}
			 			});
			    	
				};
			 

	       },	
		
		
};
</script>
