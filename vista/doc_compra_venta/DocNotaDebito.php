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
 #12			  24-10-2018		EGS 					se habilito comprobantes y adiciono boton de finalidad
 
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
	sw_ncd: 'si',//#12 24-10-2018 EGS se habilito generador de comprobantes para notas de credito debito
	
	formTitulo: 'Notas de Débito  sobre Compras',
	
	constructor: function(config) {
		
	    Phx.vista.DocNotaDebito.superclass.constructor.call(this,config);
        
        this.addButton('btnNewDoc',{ 
	       	    text: 'Relacionar factura', 
	       	    iconCls: 'blist', 
	       	    disabled: false, 
	       	    handler: this.mostarFormAuto, 
	       	    tooltip: 'Permite relacionar factura a la nota de credito/debito'});
	     
	    //#12 24-10-2018 EGS
	    this.crearFormularioApli();
	    this.addButton('configApli',{ 
	    	text: 'Finalidad Nota Debito sobre Compras', 
	    	iconCls: 'blist',
	    	disabled: false, 
	    	handler: this.mostarFormApli, 
	    	tooltip: '<b>Configurar Aplicación</b><br/>Permite asociar un tipo de finalidad,  esto permitirá difenrenciar que tipo de cuenta por cobrar debe ser aplicada'});
		//#12 24-10-2018 EGS
        
        
    },
    //#12 24-10-2018 EGS
		crearFormularioApli:function(){
		  this.formApli = new Ext.form.FormPanel({
            baseCls: 'x-plain',
            autoDestroy: true,
           
            border: false,
            layout: 'form',
            autoHeight: true,
           
    
            items: [{
						name:'codigo_aplicacion',
						xtype:'combo',
						qtip:'Aplicación para filtro prioritario, primero busca uan relación contable especifica para la aplicación definida si no la encuentra busca un relación contable sin aplicación',
						fieldLabel : 'Aplicación:',
						resizable:true,
						allowBlank:true,
		   				emptyText:'Seleccione un catálogo...',
		   				store: new Ext.data.JsonStore({
							url: '../../sis_parametros/control/Catalogo/listarCatalogoCombo',
							id: 'id_catalogo',
							root: 'datos',
							sortInfo:{
								field: 'orden',
								direction: 'ASC'
							},
							totalProperty: 'total',
							fields: ['id_catalogo','codigo','descripcion'],
							// turn on remote sorting
							remoteSort: true,
							baseParams: {par_filtro:'descripcion',catalogo_tipo:'finalidad_nota_debito_sobre_compra'}
						}),
	       			    enableMultiSelect:false,    				
						valueField: 'codigo',
		   				displayField: 'descripcion',
		   				gdisplayField: 'codigo_aplicacion',
		   				forceSelection:true,
		   				typeAhead: false,
		       			triggerAction: 'all',
		       			lazyRender:true,
		   				mode:'remote',
		   				pageSize:10,
		   				queryDelay:1000,
		   				anchor: '80%',
		   				minChars:2
		    }]
        });
        
		
		
		this.wFormApli = new Ext.Window({
            title: 'Estados',
            collapsible: true,
            maximizable: true,
            autoDestroy: true,
            width: 380,
            height: 170,
            layout: 'fit',
            plain: true,
            bodyStyle: 'padding:5px;',
            buttonAlign: 'center',
            items: this.formApli,
            modal:true,
             closeAction: 'hide',
            buttons: [{
                text: 'Guardar',
                handler:this.saveFormApli,
                scope:this
                
            },
             {
                text: 'Cancelar',
                handler:function(){this.wFormApli.hide()},
                scope:this
            }]
        });
        
         this.cmpApli=this.formApli.getForm().findField('codigo_aplicacion');
         
         
	},
	mostarFormApli:function(){
		var data = this.getSelectedData();
		if(data){
			this.cmpApli.setValue(data.codigo_aplicacion);
		    this.wFormApli.show();
		}
		
	},
	saveFormApli:function(){
		    var d = this.getSelectedData();
		    Phx.CP.loadingShow();
            Ext.Ajax.request({
                url: '../../sis_contabilidad/control/DocCompraVenta/editAplicacion',
                params: { 
                	      codigo_aplicacion: this.cmpApli.getValue(),
                	      id_doc_compra_venta: d.id_doc_compra_venta
                	    },
                success: this.successSincApli,
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope: this
            });
		
	},
	
	successSincApli:function(resp){
            Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if(!reg.ROOT.error){
            	if(this.wFormApli){
            		this.wFormApli.hide(); 
            	}            	
                this.reload();
             }else{
                alert('ocurrio un error durante el proceso')
            }
    },
    //#12 24-10-2018 EGS
    
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
        
        
		this.getBoton('btnWizard').enable();//#12 24-10-2018 EGS
		        
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
	                                     regitrarDetalle: 'si'//#12 24-10-2018 EGS
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
