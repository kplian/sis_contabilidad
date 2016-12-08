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
Phx.vista.IntComprobanteLdEntrega = {
    bedit: false,
    bnew: false,
    bsave: false,
    bdel: true,
	require: '../../../sis_contabilidad/vista/int_comprobante/IntComprobanteLd.php',
	requireclase: 'Phx.vista.IntComprobanteLd',
	title: 'Libro Diario',
	nombreVista: 'IntComprobanteLdEntrega',
	
	constructor: function(config) {
	    Phx.vista.IntComprobanteLdEntrega.superclass.constructor.call(this,config);
	    
	    this.addButton('chkEntregas',{	text:'Entregas',
				iconCls: 'blist',
				disabled: true,
				handler: this.crearEntrega,
				tooltip: '<b>Crear Entregas </b><p>Las entregas permiten asociar con cbte en otros subsistema (por ejemplo SIGMA o SIGEP)</p>'
			});	
	    
	   
    
    },
    
    cmbDepto : new Ext.form.AwesomeCombo({
			name : 'id_depto',
			fieldLabel : 'Depto',
			typeAhead : false,
			forceSelection : true,
			allowBlank : false,
			disableSearchButton : true,
			emptyText : 'Depto Contable',
			store : new Ext.data.JsonStore({
				url : '../../sis_parametros/control/Depto/listarDeptoFiltradoDeptoUsuario',
				id : 'id_depto',
				root : 'datos',
				sortInfo : {
					field : 'deppto.nombre',
					direction : 'ASC'
				},
				totalProperty : 'total',
				fields : ['id_depto', 'nombre', 'codigo'],
				// turn on remote sorting
				remoteSort : true,
				baseParams : {
					par_filtro : 'deppto.nombre#deppto.codigo',
					estado : 'activo',
					codigo_subsistema : 'CONTA'
				}
			}),
			valueField : 'id_depto',
			displayField : 'nombre',
			hiddenName : 'id_depto',
			enableMultiSelect : false,
			triggerAction : 'all',
			lazyRender : true,
			mode : 'remote',
			pageSize : 20,
			queryDelay : 200,
			anchor : '80%',
			listWidth : '280',
			resizable : true,
			minChars : 2
		}),
    
    
   south:{
	  url: '../../../sis_contabilidad/vista/int_transaccion/IntTransaccionLd.php',
	  title: 'Transacciones', 
	  height: '50%',	//altura de la ventana hijo
	  cls: 'IntTransaccionLd'
	},
	preparaMenu : function(n) {
			var tb = Phx.vista.IntComprobanteLdEntrega.superclass.preparaMenu.call(this,n);
			
            this.getBoton('chkEntregas').enable();
            
			
			return tb;
	},
	liberaMenu : function() {
			var tb = Phx.vista.IntComprobanteLdEntrega.superclass.liberaMenu.call(this);
			
            this.getBoton('chkEntregas').disable();
			
	},
	
	crearEntrega: function(){
		var filas=this.sm.getSelections(),
			total= 0,tmp='',me = this;
	 	
	 	for(var i=0;i<this.sm.getCount();i++){
			aux={};
			if(total == 0){
				tmp = filas[i].data[this.id_store];
			}
			else{
				tmp = tmp + ','+ filas[i].data[this.id_store];
					}
					total = total + 1;
				}
		if(total != 0){
			if(confirm("¿Esta  seguro de Crear esta entrega?") ){
					 	Phx.CP.loadingShow();
					    Ext.Ajax.request({
							url : '../../sis_contabilidad/control/Entrega/crearEntrega',
							params : {
								id_int_comprobantes : tmp,
								id_depto_conta: me.cmbDepto.getValue(),
								total_cbte: total
							},
							success : function(resp) {
								Phx.CP.loadingHide();
								alert('La entrega fue creada con exito, incluye cbte(s): '+ total);
								this.reload();
								
							},
							failure : this.conexionFailure,
							timeout : this.timeout,
							scope : this
						});
			 }
		}
		else{
			alert ('No selecciono ningun comprobante');
		}
	}
};
</script>
