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
        //this.Cmp.id_plantilla.store.baseParams = Ext.apply(this.Cmp.id_plantilla.store.baseParams, {tipo_plantilla:'venta'});
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
	}
	
};
</script>
