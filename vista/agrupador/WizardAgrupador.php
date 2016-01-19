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
Phx.vista.WizardAgrupador=Ext.extend(Phx.frmInterfaz,{
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
				    
        Phx.vista.WizardAgrupador.superclass.constructor.call(this,config);
        this.init(); 
        
        this.Cmp.id_depto_conta.setValue(this.id_depto_conta);
        this.Cmp.tipo.setValue(this.tipoDoc);
        //definir rangos de fecha ... segun gestion
        d2 = new Date(this.gestion, 11, 31);
    	d1 = new Date(this.gestion, 0, 1);
        this.Cmp.fecha_cbte.setMinValue(d1);
        this.Cmp.fecha_cbte.setMaxValue(d2);
        this.Cmp.fecha_ini.setMinValue(d1);
		this.Cmp.fecha_fin.setMinValue(d1);
        
        
        this.iniciarEventos();   
       
        
        
    },
    
    Atributos:[
          {
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'tipo'
			},
			type:'Field',
			form:true 
		  },
        
         {
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_depto_conta'
			},
			type:'Field',
			form:true 
		 },
	   	 {
				config:{
					name: 'fecha_cbte',
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
                name: 'id_moneda',
                origen: 'MONEDA',
                allowBlank: false,
                fieldLabel: 'Moneda',
                width: 150
             },
            type:'ComboRec',
            id_grupo:2,
            form:true
        },
        {
           config:{
                name:'incluir_rev',
                fieldLabel: 'Solo Revisados',
                allowBlank: false,
                qtip:'Solo incluir los documentos marcados como revisados?',
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                width: 150,
                mode: 'local',
                store:['si','no']
           },
           type:'ComboBox',
           id_grupo:0,
           form:true
          },
          {
				config:{
					name: 'fecha_ini',
					qtip: 'Indica la fecha desde mínima de documentos a incluir',
					fieldLabel: 'Desde',					
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
					name: 'fecha_fin',					
					qtip: 'Indica la fecha desde máxima de documentos a incluir',
					fieldLabel: 'Hasta',
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
    title: 'Parametros para agrupar documentos',
    // Funcion guardar del formulario
    
    
    onSubmit: function(o) {
    	//guardar el agrupador, y generar contenido
    	var me = this;
    	if (me.form.getForm().isValid()) {
             var parametros = me.getValForm()
             Phx.CP.loadingShow();
             
             Ext.Ajax.request({
						url : '../../sis_contabilidad/control/Agrupador/generarAgrupacion',
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
    	//abrir interface con documentos abrupados
    	var objRes = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
    	console.log('retorno..', objRes)
    	Phx.CP.loadWindows('../../../sis_contabilidad/vista/agrupador_doc/AgrupadorDoc.php',
                    'Generar comprobante',
                    {
                        width:'80%',
                        height:'80%'
                    },
                    {   
                    	id_agrupador: objRes.ROOT.datos.id_agrupador,
                    	idContenedorAbuelo: this.idContenedorPadre,
                        tipoDoc: this.tipoDoc,
                        fecha_cbte: this.Cmp.fecha_cbte.getValue().dateFormat(this.Cmp.fecha_cbte.format)
                    },
                    this.idContenedor,
                    'AgrupadorDoc');
    	
    	
    	this.panel.destroy();
    	
    	
    },
    iniciarEventos: function(){
    	    this.Cmp.fecha_cbte.on('change', function(obj, newValue, oldValue){
	    		this.Cmp.fecha_ini.reset();
	    		this.Cmp.fecha_fin.reset();  
	    		this.Cmp.fecha_ini.setMaxValue(newValue);
			    this.Cmp.fecha_fin.setMaxValue(newValue); 
		    	
	    	} ,this);
    	
    	
    	
    }
    
    
})    
</script>