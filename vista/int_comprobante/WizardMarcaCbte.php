<?php
/**
 * 
 ISSUE     FORK          FECHA:		       AUTOR                 DESCRIPCION
   
 #7        ENDEERT		27-12-2018        MANUEL GUERRA            CREACION
*/
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
Phx.vista.WizardMarcaCbte = Ext.extend(Phx.frmInterfaz,{
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
		},this.panelResumen
		];
		Phx.vista.WizardMarcaCbte.superclass.constructor.call(this,config);
		this.init();
		this.obtenerMarca(config);
		console.log('config',config); 
	},
	
	loadValoresIniciales:function(){    	
		Phx.vista.WizardMarcaCbte.superclass.loadValoresIniciales.call(this);
		//iniciar valroes de comprobantes seleccionados 
		this.Cmp.id_int_comprobante.setValue(this.id_int_comprobante);
		//this.Cmp.nro_tramite_aux.setValue(this.nro_tramite_aux);
	},

	Atributos:[
		{
			//configuracion del componente
			config : {
				labelSeparator : '',
				inputType : 'hidden',
				name : 'id_int_comprobante'
			},
			type : 'Field',
			form : true,
			grid : false
		},		
		    {
            config:{
                name: 'id_marca',
                fieldLabel: 'Marc. Cbte',
                allowBlank: false,
                emptyText: 'Elegir ...',
                tinit:false,
                resizable:true,
                tasignacion:false,
                store: new Ext.data.JsonStore({
                    url: '../../sis_contabilidad/control/Marca/listarMarca',
                    id : 'id_marca',
                    root: 'datos',
                    sortInfo:{
                        field: 'id_marca',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_marca','codigo','descripcion'],
                    remoteSort: true,
                    baseParams: { par_filtro: 'mar.id_marca#mar.codigo'}
                }),
                tpl:'<tpl for="."><div class="x-combo-list-item" ><div class="awesomecombo-item {checked}"><p><b>Codigo: </b>{codigo}</p></div>\
		                       <p style="padding-left: 20px;"><b>Descripcion: </b>{descripcion}</p></div></tpl>',
               	valueField: 'id_marca',
				displayField: 'codigo',
				gdisplayField: 'codigo',
				hiddenName: 'id_marca',
				forceSelection:true,
				typeAhead: false,
				triggerAction: 'all',
				listWidth:500,
				//resizable:true,
				lazyRender:true,
				mode:'remote',
				pageSize:10,
				queryDelay:1000,
				width: 250,
                enableMultiSelect:true,
				gwidth:250,
				minChars:2,
				anchor:'80%',
				qtip:'Marca de CBTE',
				renderer:function(value, p, record){
				
				}
            },
            type:'AwesomeCombo',
			bottom_filter: true,
            filters:{pfiltro:'mar.codigo',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },	
	],
	labelSubmit: '<i class="fa fa-check"></i> Guardar',
	title: 'Modificar....',
	// Funcion guardar del formulario
	onSubmit: function(o) {
		var me = this;
		if (me.form.getForm().isValid()) {
			var parametros = me.getValForm()
			Phx.CP.loadingShow();
			Ext.Ajax.request({
				url : '../../sis_contabilidad/control/CbteMarca/guardarCbteMarca',
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
	},
	
	 obtenerMarca: function(config){
			//console.log('config id_proyecto',config.id_proyecto);
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url:'../../sis_contabilidad/control/CbteMarca/listarCbteMarca',
                params:{
                    id_int_comprobante: config.id_int_comprobante,
                },
                success: function(resp){
                	 Phx.CP.loadingHide();
                     var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
                   	 var marca ='';
                        console.log('datos ajax',reg.datos[0]['id_marca']);
                        for (var i=0; i < reg.datos.length; i++) {
                          marca = marca + reg.datos[i]['id_marca'] + ',';
                        };
                        var marca = marca.substring(0, marca.length-1);
                        this.Cmp.id_marca.setValue(marca);
                        console.log('marca',marca);
              			//this.id_tipo_cc =reg.datos[0]['id_tipo_cc'];

                },
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope:this
            });
 
        },

})
</script>