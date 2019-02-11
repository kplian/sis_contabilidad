<?php
/**
*@package pXP
*@file    SolModPresupuesto.php
*@author  Rensi Arteaga Copari 
*@date    30-01-2014
*@  Para generar comprobantes desde plantilla de resultados,  
*   sobre la interface de libro diario 
 * 
 ISSUE            FECHA:		      AUTOR                 DESCRIPCION
   
 #2        		27-08-2018        RCM KPLIAN        CREACION
*/
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
Phx.vista.WizardGlosaCbte = Ext.extend(Phx.frmInterfaz,{
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
				    
        Phx.vista.WizardGlosaCbte.superclass.constructor.call(this,config);
        this.init(); 
           
        
    },
    
    loadValoresIniciales:function(){    	
    	Phx.vista.WizardGlosaCbte.superclass.loadValoresIniciales.call(this);
    	 //iniciar valroes de comprobantes seleccionados 
        this.Cmp.id_int_comprobante.setValue(this.id_int_comprobante);
        this.Cmp.glosa1.setValue(this.glosa1);
    },
    
    Atributos:[
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
			config : {
				name : 'glosa1',
				fieldLabel : 'Glosa',
				allowBlank : false,
				anchor : '100%',
				gwidth : 100,
				maxLength : 1500
			},
			type : 'TextArea',
			form : true
		}	 
        
	   	  
    ],
    labelSubmit: '<i class="fa fa-check"></i> Guardar Glosa',
    title: 'Modificar Glosa....',
    // Funcion guardar del formulario
    onSubmit: function(o) {
    	var me = this;
    	if (me.form.getForm().isValid()) {
             var parametros = me.getValForm()
             Phx.CP.loadingShow();
             
             Ext.Ajax.request({
						url : '../../sis_contabilidad/control/IntComprobante/modificarGlosaIntComprobante',
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
    	this.panel.destroy();
    }
    
})    
</script>