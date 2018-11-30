<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  (fprudencio)
*@date   20-08-2018 10:22:05
*@description Archivo con la interfaz de usuario que permite 
*dar el visto a solicitudes de compra
**    HISTORIAL DE MODIFICACIONES:
   	
 ISSUE            FECHA:		      AUTOR                 DESCRIPCION
   
 #0        		  20-08-2018        RAC KPLIAN              creacion
 
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.DocNotaCredito = {
    
	require: '../../../sis_contabilidad/vista/doc_compra_venta/DocCompraVenta.php',
    ActList:'../../sis_contabilidad/control/DocCompraVenta/listarDocCompraVenta',
	requireclase: 'Phx.vista.DocCompraVenta',
	title: 'Notas de Crédito sobre Ventas',
	nombreVista: 'DocNotaCredito',
	tipoDoc: 'compra',
	sw_ncd: 'no',//21/08/2018  deshabilitar el generador de comprobantes para notas de credito debito	
	formTitulo: 'Notas de Crédito sobre Ventas',
	
	constructor: function(config) {
		
	    Phx.vista.DocNotaCredito.superclass.constructor.call(this,config);
        //this.Cmp.id_plantilla.store.baseParams = Ext.apply(this.Cmp.id_plantilla.store.baseParams, {tipo_plantilla:this.tipoDoc});
        
        this.addButton('btnNewDoc',{ 
	       	    text: 'Relacionar factura', 
	       	    iconCls: 'blist', 
	       	    disabled: false, 
	       	    handler: this.mostarFormAuto, 
	       	    tooltip: 'Permite relacionar factura a la nota de credito/debito'});
        
        
    },
   
    
    loadValoresIniciales: function() {
    	Phx.vista.DocNotaCredito.superclass.loadValoresIniciales.call(this);
        //this.Cmp.tipo.setValue(this.tipoDoc); 
        
   },
   capturaFiltros:function(combo, record, index){
        this.store.baseParams.tipo = this.tipoDoc;
        this.store.baseParams.tipo_informe = 'ncd';
        Phx.vista.DocNotaCredito.superclass.capturaFiltros.call(this,combo, record, index);
    },
    
    preparaMenu:function(tb){
        Phx.vista.DocNotaCredito.superclass.preparaMenu.call(this,tb)
        var data = this.getSelectedData();
        
         if (data.tipo_informe  == 'ncd') {
         	this.getBoton('btnNewDoc').enable();
         }
         else{
         	this.getBoton('btnNewDoc').disable();
         }
    },
    
    liberaMenu:function(tb){
        Phx.vista.DocNotaCredito.superclass.liberaMenu.call(this,tb);
    },
    
     abrirFormulario: function(tipo, record){
   	       var me = this;
   	       me.objSolForm = Phx.CP.loadWindows('../../../sis_contabilidad/vista/doc_compra_venta/FormCompraVenta.php',
	                                me.formTitulo,
	                                {
	                                    modal:true,
	                                    width:'90%',
										height:'90%'


	                                    
	                                }, { data: { 
		                                	 objPadre: me ,
		                                	 tipo_informe: 'ncd',
		                                	 tipoDoc: me.tipoDoc,	                                	 
		                                	 id_gestion: me.cmbGestion.getValue(),
		                                	 id_periodo: me.cmbPeriodo.getValue(),
		                                	 id_depto: me.cmbDepto.getValue(),
		                                	 tmpPeriodo: me.tmpPeriodo,
                                             tmpGestion: me.tmpGestion,
		                                	 tipo_form : tipo,
		                                	 datosOriginales: record
	                                    },
	                                     regitrarDetalle: 'no'
	                                }, 
	                                this.idContenedor,
	                                'FormCompraVenta',
	                                {
	                                    config:[{
	                                              event:'successsave',
	                                              delegate: this.onSaveForm,
	                                              
	                                            }],
	                                    
	                                    scope:this
	                                 });  
   },
    
   
	
};
</script>
