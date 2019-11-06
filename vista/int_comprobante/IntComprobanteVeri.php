<?php
/*
 #74	 ETR		17/05/2018			manuel guerra		vista para la verificacion de cbtes de la uo 
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.IntComprobanteVeri = {
    bedit: false,
    bnew: false,
    bsave: false,
    bdel: false,
	require: '../../../sis_contabilidad/vista/int_comprobante/IntComprobante.php',
	requireclase: 'Phx.vista.IntComprobante',
	title: 'Libro Diario',
	nombreVista: 'IntComprobanteVeri',
	ActList : '../../sis_contabilidad/control/IntComprobante/listarIntComprobanteWf',
	
	constructor: function(config) {
		
	    var me = this;	        
        Phx.vista.IntComprobanteVeri.superclass.constructor.call(me,config);   
	    this.addButton('chkdep', {	text:'Dependencias',
			iconCls:  'blist',
			disabled: true,
			handler:  this.checkDependencias,
			tooltip: '<b>Revisar Dependencias </b><p>Revisar dependencias del comprobante</p>'
		});			
		this.init();	
	},
    
    south:{
	  url:'../../../sis_contabilidad/vista/int_transaccion/IntTransaccionLd.php',
	  title:'Transacciones', 
	  height:'50%',
	  cls:'IntTransaccionLd'
	},
	preparaMenu : function(n) {
			var tb = Phx.vista.IntComprobanteVeri.superclass.preparaMenu.call(this);
			this.getBoton('btnImprimir').enable();
			this.getBoton('btnRelDev').disable();
			this.getBoton('btnDocCmpVnt').enable();
			this.getBoton('chkpresupuesto').enable();
			this.getBoton('btnObs').disable(); 
			this.getBoton('chkdep').enable();
			this.getBoton('btnChequeoDocumentosWf').enable();
            this.getBoton('diagrama_gantt').enable();  
			return tb;
	},
	liberaMenu : function() {
			var tb = Phx.vista.IntComprobanteVeri.superclass.liberaMenu.call(this);
			this.getBoton('btnImprimir').disable();
			this.getBoton('btnRelDev').disable();
			this.getBoton('btnDocCmpVnt').disable();
			this.getBoton('chkpresupuesto').disable();
			
			this.getBoton('chkdep').disable();
			this.getBoton('btnChequeoDocumentosWf').disable();
            this.getBoton('diagrama_gantt').disable();
            this.getBoton('btnObs').disable(); 
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
	//para retroceder de estado
    antEstado:function(res){
		var rec=this.sm.getSelected(),
         		obsValorInicial;
     	Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/AntFormEstadoWf.php',
        'Estado de Wf',
        {   modal: true,
            width: 450,
            height: 250
        }, 
        {    data: rec.data, 
        	 estado_destino: res.argument.estado,
             obsValorInicial: obsValorInicial }, this.idContenedor,'AntFormEstadoWf',
        {
       		config:
       		[{
		      	event:'beforesave',
		    	delegate: this.onAntEstado,
            }],
           	scope:this
       });
   },
   
   onAntEstado: function(wizard,resp){
        Phx.CP.loadingShow();
        var operacion = 'cambiar';
        operacion=  resp.estado_destino == 'inicio'?'inicio':operacion; 
        Ext.Ajax.request({
            url:'../../sis_contabilidad/control/IntComprobante/anteriorEstado',
            params:{
                    id_proceso_wf: resp.id_proceso_wf,
                    id_estado_wf:  resp.id_estado_wf,  
                    obs: resp.obs,
                    operacion: operacion,
                    id_int_comprobante: resp.data.id_int_comprobante
            },
            argument: { wizard: wizard },  
            success: this.successEstadoSinc,
            failure: this.conexionFailure,
            timeout: this.timeout,
            scope: this
        });           
    },
    successEstadoSinc:function(resp){
        Phx.CP.loadingHide();
        resp.argument.wizard.panel.destroy()
        this.reload();
    },
     
     
};
</script>