<?php
/**
 *@package pXP
 *@file gen-Depto.php
 *@author  )
 *@date 24-11-2011 15:52:20
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Ext.define('Phx.vista.RangoTorta',{		
	extend: 'Ext.util.Observable',
	
	constructor: function(config) {
		
		Ext.apply(this, config);
		var me = this;		
		this.callParent(arguments);
		
	    this.panel = Ext.getCmp(this.idContenedor);
	    
	    this.store = new Ext.data['JsonStore']({
			url: '../../sis_contabilidad/control/Rango/listarTipoCcArbRep',
			id: 'id_tipo_cc',
			//root: 'datos',
			sortInfo: {field: 'id_tipo_cc',direction: 'ASC'},
			totalProperty: 'total',
			fields:['id_tipo_cc','codigo','balance_mb'],
			remoteSort: true
		});
		this.store.load({ params: { node:'id',start: 0, limit: 300}});
	    /*
	    this.store = new Ext.data.JsonStore({
		        fields: ['season', 'total'],
		        data: [{
		            season: 'Summer',
		            total: 150
		        },{
		            season: 'Fall',
		            total: 245
		        },{
		            season: 'Winter',
		            total: 117
		        },{
		            season: 'Spring',
		            total: 184
		        }]
		    });
		    */
		
		this.panelTorta =  new Ext.Panel({
		        region:'center',
    		    split: true, 
    		    layout:  'fit',
    		     
		        items: {
		            store: this.store,
		            xtype: 'piechart',
		            dataField: 'balance_mb',
		            categoryField: 'codigo',
		            //extra styles get applied to the chart defaults
		            extraStyle:
		            {
		                legend:
		                {
		                    display: 'bottom',
		                    padding: 5,
		                    font:
		                    {
		                        family: 'Tahoma',
		                        size: 13
		                    }
		                }
		            }
		        }
		    });    
		/*	    
	   this.panelMapa = new Ext.Panel({  
    		    padding: '0 0 0 0',
    		    tbar: this.tb,
    		    html:'<div id="map-'+this.idContenedor +'"></div>',
    		    region:'center',
    		    split: true, 
    		    layout:  'fit' });*/
    		    
    	this.Border = new Ext.Container({
	        layout:'border',
	        items:[  this.panelTorta]
	    });	
	    
	        
	    
	    this.panel.add(this.Border);
	    this.panel.doLayout();
	    this.addEvents('init');	   
    	
    },
    
    onReloadPage : function(m){
    	
    	this.maestro = m;
    	
    	var padre = Phx.CP.getPagina(this.idContenedorPadre);
		var desde = padre.campo_fecha_desde.getValue(),
			hasta = padre.campo_fecha_hasta.getValue();
		
		
		
		this.store.baseParams = { node:  this.maestro.id_tipo_cc};
		
		if(desde && hasta){
		    this.store.baseParams=Ext.apply(this.store.baseParams,{ desde: desde.dateFormat('d/m/Y'), 
											                        hasta: hasta.dateFormat('d/m/Y')});
		}
    	
    	this.store.reload({ params: this.store.baseParams});
		
		
	 },
	 
	 liberaMenu:function(){
	 	
	 },
	 preparaMenu: function(){
	 	
	 },
	 postReloadPage: function(){
	 	
	 }
	 
	 

});
</script>