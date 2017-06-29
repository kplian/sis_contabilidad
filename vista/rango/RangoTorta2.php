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
Ext.define('Phx.vista.RangoTorta2',{		
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
		
		
		
		this.tbar = new Ext.Toolbar({
				        items:['Tipo: ',this.cmbTipo]
				        });
		
		
	  
			   
			   
			
	   this.panelTorta = new Ext.Panel({  
    		    padding: '0 0 0 0',
    		    tbar: this.tbar,
    		    html:'<div id="map-'+this.idContenedor +'" style="width: 100%; height: 100%; position:absolute;"></div>',
    		    //html:'<div id="map-'+this.idContenedor +'" style="position: absolute;  top: 0; right: 0; bottom: 0; left: 0;border: 15px solid orange"></div>',
    		    region:'center',
    		    layout:  'fit' });
    		   
    	this.Border = new Ext.Container({
	        layout:'border',
	        items:[ this.panelTorta]
	    });	
	    
	        
	    
	    this.panel.add(this.Border);
	    this.panel.doLayout();
	    this.addEvents('init');	
	   
	    
	   this.chart = Highcharts.chart('map-'+this.idContenedor, {
				    chart: {
				        plotBackgroundColor: null,
				        plotBorderWidth: null,
				        plotShadow: false,
				        type: 'bar'
				    },
				    title: {
				        text: "RELACIÓN DE EJECUCIÓN DE TIPOS DE CENTROS"
				    },
				    tooltip: {
				      pointFormat: '({series.name}) <br>{point.descripcion}: <br><b>{point.y}</b>'
				    },
				    plotOptions: {
				        pie: {
				            allowPointSelect: true,
				            cursor: 'pointer',
				            dataLabels: {
				                enabled: true,
				                /*formatter:function() {
				                	var pcnt = (this.y / dataSum) * 100;
				                    return Highcharts.numberFormat(pcnt) + '%';
				                    
				                      
				                }, */  
				                format: '{point.name}: <br><b>{point.percentage:.1f} %</b>',
				                style: {
				                    color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
				                }
				            }
				        }
				    },
				    series: [{
				        name: 'Centro de Costo',
				        colorByPoint: true,
				        data: [{}]
				    }]
				});	
				
				     
    	this.cmbTipo.on('select',function(cm,dat,num){
		    
		    
		    this.chart.series[0].update({ type: dat.data.field1 });
		    this.chart.redraw();
		    
		},this);
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
    	
    	this.store.reload({ params: this.store.baseParams, callback : this.cargarChart, scope: this});
    	
    	
		
		
	 },
	 
	 cmbTipo: new Ext.form.ComboBox({
                    name: 'tipo',
                    fieldLabel: 'Tipo',
                    allowBlank: false,
                    forceSelection : true,
                    emptyText:'Tipo...',
                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender: true,
                    value:'ingreso',
                    mode: 'local',
                    width: 70,
                    store: ['bar','pie','line','column'],
                    value: 'column'
                }),
	 
	 cargarChart: function(r,o,s){
	 	
	 	console.log('datos de regreso ..',r,o,s)
	 	
	 	console.log(this.chart)
	 	console.log(this.chart.series)
	 	var resul = [];	 	
	 	r.forEach(function(element) {
	 		resul.push({
				    	name: element.data.codigo,
						descripcion:element.json.descripcion,
						y: element.data.balance_mb*1.0
		             });
	 			
	 		
		    
		});
		console.log('resultado.....',resul)
		//this.chart.series[0].remove();
	 	/*this.chart.series[0].setData({ name: 'Brands',
				                       colorByPoint: true,
				                       data: resul
				                       updatePoints:false});*/
				                       
				                       
		this.chart.series[0].setData(resul);		                       
				                       
		//this.chart.redraw() 		                       
	 	
	 },
	 
	 liberaMenu:function(){
	 	
	 },
	 preparaMenu: function(){
	 	
	 },
	 postReloadPage: function(){
	 	
	 }
	 
	 

});
</script>