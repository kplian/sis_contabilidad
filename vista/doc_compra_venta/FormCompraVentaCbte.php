<?php
/**
*@package pXP
*@file FormRendicionCD.php
*@author  Rensi Arteaga 
*@date 16-02-2016
*@description Archivo con la interfaz de usuario que permite 
*ingresar el documento a rendir
*
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.FormCompraVentaCbte = {
	require: '../../../sis_contabilidad/vista/doc_compra_venta/FormCompraVenta.php',
	requireclase: 'Phx.vista.FormCompraVenta',
	mostrarFormaPago : false,
	heightHeader: 245,
	constructor: function(config) {		
	   Phx.vista.FormCompraVentaCbte.superclass.constructor.call(this,config);	   
    },
    
    extraAtributos:[
        {
				//configuracion del componente
				config:{
						labelSeparator:'',
						inputType:'hidden',
						name: 'id_int_comprobante'
				},
				type:'Field',
				form:true 
		}
     ],
    
	onNew: function(){    	
    	Phx.vista.FormCompraVentaCbte.superclass.onNew.call(this);
    	this.Cmp.id_int_comprobante.setValue(this.data.id_int_comprobante);
    	
    	 console.log('datos.....', this.data)
       
	},
	
	onEdit: function(){    	
    	Phx.vista.FormCompraVentaCbte.superclass.onEdit.call(this);	
    	this.Cmp.id_int_comprobante.setValue(this.data.id_int_comprobante);	
        this.cargarPeriodo();		
	},
	
	iniciarEventos: function(config){
		
		Phx.vista.FormCompraVentaCbte.superclass.iniciarEventos.call(this,config);
		
		this.Cmp.dia.hide();
		this.Cmp.fecha.setReadOnly(false);
		this.Cmp.fecha.on('change', this.cargarPeriodo, this);
		
		       
	},	
    
	cargarPeriodo: function(obj){
	//Busca en la base de datos la razon social en funci�n del NIT digitado. Si Razon social no esta vac�o, entonces no hace nada
		if(this.getComponente('fecha').getValue()!=''){
		Phx.CP.loadingShow();
		Ext.Ajax.request({
			url:'../../sis_parametros/control/Periodo/listarPeriodo',
			params:{ start:0, limit:30, 'fecha': this.getComponente('fecha').getValue().format('d-m-Y')},
			success: function(resp){
				Phx.CP.loadingHide();
				var objRes = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));								
				var idGestion=objRes.datos[0].id_gestion;
				this.Cmp.id_gestion.setValue(idGestion);
				this.Cmp.dia.setValue(this.getComponente('fecha').getValue().getDate());
			},
			failure: this.conexionFailure,
			timeout: this.timeout,
			scope: this
		});
		}
	},
	successSave:function(resp)
    {
        Phx.CP.loadingHide();
		Phx.CP.getPagina(this.idContenedorPadre).reload();
		
		
        this.panel.close();
    },	
};
</script>
