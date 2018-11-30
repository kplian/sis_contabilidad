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
   
 #0        		  21-08-2018        RAC KPLIAN              creacion
 
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.DocNotaDebito = {
    
	require: '../../../sis_contabilidad/vista/doc_compra_venta/DocCompraVenta.php',
    ActList:'../../sis_contabilidad/control/DocCompraVenta/listarDocCompraVenta',
	requireclase: 'Phx.vista.DocCompraVenta',
	title: 'Notas de Débito  sobre Compras',
	nombreVista: 'DocNotaDebito',
	tipoDoc: 'venta',
	sw_ncd: 'no',//21/08/2018  deshabilitar el generador de comprobantes para notas de credito debito
	
	formTitulo: 'Notas de Débito  sobre Compras',
	
	constructor: function(config) {
		
	    Phx.vista.DocNotaDebito.superclass.constructor.call(this,config);
        
        this.addButton('btnNewDoc',{ 
	       	    text: 'Relacionar factura', 
	       	    iconCls: 'blist', 
	       	    disabled: false, 
	       	    handler: this.mostarFormAuto, 
	       	    tooltip: 'Permite relacionar factura a la nota de credito/debito'});
        
        
    },
   
    
    loadValoresIniciales: function() {
    	Phx.vista.DocNotaDebito.superclass.loadValoresIniciales.call(this);
       
        
   },
   capturaFiltros:function(combo, record, index){
        this.store.baseParams.tipo = this.tipoDoc;
        this.store.baseParams.tipo_informe = 'ncd';
        Phx.vista.DocNotaDebito.superclass.capturaFiltros.call(this,combo, record, index);
    },
    
    preparaMenu:function(tb){
        Phx.vista.DocNotaDebito.superclass.preparaMenu.call(this,tb)
        var data = this.getSelectedData();
        
         if (data.tipo_informe  == 'ncd') {
         	this.getBoton('btnNewDoc').enable();
         }
         else{
         	this.getBoton('btnNewDoc').disable();
         }
    },
    
    liberaMenu:function(tb){
        Phx.vista.DocNotaDebito.superclass.liberaMenu.call(this,tb);
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
