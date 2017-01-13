<?php
/**
*@package pXP
*@file    SolModPresupuesto.php
*@author  Rensi Arteaga Copari 
*@date    30-01-2014
*@description permites subir archivos a la tabla de documento_sol
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.WizardCbte=Ext.extend(Phx.frmInterfaz,{
    constructor:function(config)
    {   
    	this.panelResumen = new Ext.Panel({html:''});
    	this.Grupos = [{

	                    xtype: 'fieldset',
	                    border: false,
	                    autoScroll: true,
	                    layout: 'form',
	                    items: [],
	                    id_grupo: 0
				               
				    },
				     this.panelResumen
				    ];
				    
        Phx.vista.WizardCbte.superclass.constructor.call(this,config);
        this.init(); 
        this.iniciarEventos();   
       
        
        
    },
    
    Atributos:[
          
		  {
   			config:{
                name: 'id_depto',
                fieldLabel: 'Depto',
                typeAhead: false,
                forceSelection: true,
                allowBlank: false,
                disableSearchButton: true,
                emptyText: 'Depto Contable',
                store: new Ext.data.JsonStore({
                    url: '../../sis_parametros/control/Depto/listarDeptoFiltradoDeptoUsuario',
                    id: 'id_depto',
					root: 'datos',
					sortInfo:{
						field: 'deppto.nombre',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_depto','nombre','codigo'],
					// turn on remote sorting
					remoteSort: true,
					baseParams: { par_filtro:'deppto.nombre#deppto.codigo', estado:'activo', codigo_subsistema: 'CONTA'}
                }),
                valueField: 'id_depto',
   				displayField: 'codigo',
   				hiddenName: 'id_depto',
                enableMultiSelect: false,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'remote',
                pageSize: 20,
                queryDelay: 200,
                anchor: '80%',
                listWidth:'280',
                resizable:true,
                minChars: 2
            },
   			type:'ComboBox',
   			id_grupo:0,
   			form:true
         },
	   	   {
				config:{
					name: 'fecha',
					fieldLabel: 'Fecha Cbte',
					allowBlank: false,
					format: 'd/m/Y',
					width: 150
				},
				type: 'DateField',
				id_grupo: 0,
				form: true
		  },
         {
	   			config:{
	                name: 'id_resultado_plantilla',
	                fieldLabel: 'Plantilla',
	                qtip: 'plantilla base para generar el comprobante',
	                typeAhead: false,
	                forceSelection: true,
	                allowBlank: false,
	                disableSearchButton: true,
	                emptyText: 'plantilla ...',
	                store: new Ext.data.JsonStore({
	                    url: '../../sis_contabilidad/control/ResultadoPlantilla/listarResultadoPlantilla',
	                    id: 'id_resultado_plantilla',
						root: 'datos',
						sortInfo:{
							field: 'resplan.nombre',
							direction: 'ASC'
						},
						totalProperty: 'total',
						fields: ['id_resultado_plantilla','nombre','codigo','periodo_calculo'],
						// turn on remote sorting
						remoteSort: true,
						baseParams: { par_filtro:'resplan.nombre#resplan.codigo',
									  tipo: 'cbte',
									  periodo: 'rangos'} //para que solo liste las plantilal aplicable a rengos de fecha
	                }),
	                valueField: 'id_resultado_plantilla',
	   				displayField: 'nombre',
	   				hiddenName: 'id_resultado_plantilla',
	                triggerAction: 'all',
	                lazyRender: true,
	                mode: 'remote',
	                pageSize: 20,
	                queryDelay: 200,
	                anchor: '80%',
	                listWidth:'280',
	                resizable:true,
	                minChars: 2
	            },
	   			type:'ComboBox',
	   			id_grupo:0,
	   			form:true
           },
	   	   {
				config:{
					name: 'desde',
					qtip: 'Esta fecha indica desde cuando se toman en cuentas las trasacciones para el calculo de mayores',
					fieldLabel: 'Calculo Desde',					
					allowBlank: false,
					format: 'd/m/Y',
					width: 150
				},
				type: 'DateField',
				id_grupo: 0,
				form: true
		  },
		  {
				config:{
					name: 'hasta',					
					qtip: 'Esta fecha indica hasta  cuando se toman en cuentas las trasacciones para el calculo de mayores',
					fieldLabel: 'Calculo Hasta',
					allowBlank: false,
					format: 'd/m/Y',
					width: 150
				},
				type: 'DateField',
				id_grupo: 0,
				form: true
		  }
    ],
    labelSubmit: '<i class="fa fa-check"></i> Aplicar Filtro',
    title: 'Generar comprobante desde plantilla ....',
    // Funcion guardar del formulario
    onSubmit: function(o) {
    	var me = this;
    	if (me.form.getForm().isValid()) {
             var parametros = me.getValForm()
             Phx.CP.loadingShow();
             
             Ext.Ajax.request({
						url : '../../sis_contabilidad/control/IntComprobante/generarDesdePlantilla',
						params : parametros,
						success : this.successGen,
						failure : this.conexionFailure,
						timeout : this.timeout,
						scope : this
					})                    
        }
    },
    
    successGen: function(resp){
    	Phx.CP.loadingHide();
    	Phx.CP.getPagina(this.idContenedorPadre).reload();
    	alert('El comprobante se genero con exito')
    	this.panel.destroy();
    },
    iniciarEventos: function(){
    	this.Cmp.id_resultado_plantilla.setReadOnly(true);
    	this.Cmp.desde.setReadOnly(true);
    	this.Cmp.hasta.setReadOnly(true);
    	var d1,d2;
    	
    	
    	this.Cmp.fecha.on('change', function(obj, newValue, oldValue){
    		d2 = new Date(newValue.getFullYear(), 11, 31);
    	    d1 = new Date(newValue.getFullYear(), 0, 1);
	    	    
	    	
    		this.Cmp.id_resultado_plantilla.setReadOnly(false);
    		this.Cmp.desde.reset();
    		this.Cmp.hasta.reset();
    		this.Cmp.id_resultado_plantilla.reset();
    	} ,this);
    	
    	
    	this.Cmp.id_resultado_plantilla.on('select',function(combo, record, index ){
    		if(record.data.periodo_calculo == 'gestion'){
    			this.Cmp.desde.setReadOnly(true);
    	        this.Cmp.hasta.setReadOnly(true);
    	        this.Cmp.desde.setValue(d1);
    	        this.Cmp.hasta.setValue(d2);    	        
    	        this.Cmp.desde.setMaxValue(d2);
		    	this.Cmp.desde.setMinValue(d1);
		    	this.Cmp.hasta.setMaxValue(d2);
		    	this.Cmp.hasta.setMinValue(d1);    			
    		}
    		else{
    			
    			
    			if(record.data.periodo_calculo == 'diario'){
    				this.Cmp.desde.setReadOnly(true);
    	            this.Cmp.hasta.setReadOnly(true);
    				this.Cmp.desde.setValue(this.Cmp.fecha.getValue());
    				this.Cmp.hasta.setValue(this.Cmp.fecha.getValue());
    			}
    			else{
    				this.Cmp.desde.setReadOnly(false);
    	            this.Cmp.hasta.setReadOnly(false);
    			}	
    			
    		}
    	},this);
    }
    
    
})    
</script>