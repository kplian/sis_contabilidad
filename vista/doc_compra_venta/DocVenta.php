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
Phx.vista.DocVenta= {
    tipoDoc: 'venta',
	require: '../../../sis_contabilidad/vista/doc_compra_venta/DocCompraVenta.php',
	requireclase: 'Phx.vista.DocCompraVenta',
	title: 'Libro de Ventas',
	nombreVista: 'DocVenta',
	formTitulo: 'Formulario de Documento Venta',
	
	
   constructor: function(config) {
	    Phx.vista.DocVenta.superclass.constructor.call(this,config);
	    this.crearFormularioApli();
        this.addButton('configApli',{ text: 'Finalidad Venta', iconCls: 'blist',disabled: false, handler: this.mostarFormApli, tooltip: '<b>Configurar Aplicación</b><br/>Permite asociar un tipo de venta,  esto permitirá difenrenciar que tipo de cuenta por cobrar debe ser aplicada'});

    },
    
    loadValoresIniciales: function() {
    	Phx.vista.DocVenta.superclass.loadValoresIniciales.call(this);
        //this.Cmp.tipo.setValue(me.tipoDoc); 
        
   },
   capturaFiltros:function(combo, record, index){
        this.store.baseParams.tipo = this.tipoDoc;
        Phx.vista.DocVenta.superclass.capturaFiltros.call(this,combo, record, index);
    },
    
    obtenerVariableGlobal: function(){
		//Verifica que la fecha y la moneda hayan sido elegidos
		Phx.CP.loadingShow();
		Ext.Ajax.request({
				url:'../../sis_seguridad/control/Subsistema/obtenerVariableGlobal',
				params:{
					codigo: 'conta_libro_ventas_detallado'  
				},
				success: function(resp){
					Phx.CP.loadingHide();
					var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
					
					if (reg.ROOT.error) {
						Ext.Msg.alert('Error','Error a recuperar la variable global')
					} else {
						if(reg.ROOT.datos.valor == 'no'){
							this.regitrarDetalle = 'no';
						}
					}
				},
				failure: this.conexionFailure,
				timeout: this.timeout,
				scope:this
			});
	},
	
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
							baseParams: {par_filtro:'descripcion',catalogo_tipo:'tipo_venta'}
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
    
     preparaMenu:function(tb){
        Phx.vista.DocCompraVenta.superclass.preparaMenu.call(this,tb)
        var data = this.getSelectedData();
        //if(data['revisado'] ==  'si' || data['id_int_comprobante'] > 0 || data.tipo_reg == 'summary' || data.tabla_origen !='ninguno'){
        if(data['revisado'] ==  'si' || data.tipo_reg == 'summary'){
             this.getBoton('edit').disable();
             this.getBoton('del').disable();
         
         }
         else{
            this.getBoton('edit').enable();
            this.getBoton('del').enable();
         } 
         
         if(this.regitrarDetalle == 'si'){
         	this.getBoton('btnWizard').enable();
         }
         else{
         	this.getBoton('btnWizard').disable();
         }
         
         this.getBoton('configApli').enable();
	       
    },
    
    liberaMenu:function(tb){
        Phx.vista.DocCompraVenta.superclass.liberaMenu.call(this,tb);
        if(this.regitrarDetalle == 'si'){
         	this.getBoton('btnWizard').enable();
         }
         else{
         	this.getBoton('btnWizard').disable();
         }
          this.getBoton('configApli').disable();
                    
    },
        
	
};
</script>
