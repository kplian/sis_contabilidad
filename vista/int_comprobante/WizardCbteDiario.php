<?php
/**
*@package pXP
*@file    SolModPresupuesto.php
*@author  Rensi Arteaga Copari 
*@date    30-01-2014
*@  Para generar comprobantes desde plantilla de resultados,  
*   sobre la interface de libro diario 
*/
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
Phx.vista.WizardCbteDiario=Ext.extend(Phx.frmInterfaz,{
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
				    
        Phx.vista.WizardCbteDiario.superclass.constructor.call(this,config);
        this.init(); 
        this.iniciarEventos();       
        
    },
    
    loadValoresIniciales:function(){    	
    	Phx.vista.WizardCbteDiario.superclass.loadValoresIniciales.call(this);
    	 //iniciar valroes de comprobantes seleccionados 
        this.Cmp.id_int_comprobante.setValue(this.id_int_comprobante);
        this.Cmp.id_depto.setValue(this.id_depto);
    },
    
    Atributos:[
         {
			//configuracion del componente
			config : {
				labelSeparator : '',
				inputType : 'hidden',
				name : 'id_depto'
			},
			type : 'Field',
			form : true,
			grid : false
		 },
		 {
			//configuracion del componente
			config : {
				labelSeparator : '',
				inputType : 'hidden',
				name : 'id_int_comprobante'  //pued almacenar mas de un cbte seleccioando
			},
			type : 'Field',
			form : true,
			grid : false
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
						              periodo: 'cbte'} //para que solo liste las plantillas aplicables sobre cbtes
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
    	
    	
    	
    	
    	
    }
    
    
})    
</script>