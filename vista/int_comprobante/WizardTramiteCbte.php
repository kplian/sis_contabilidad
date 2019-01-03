<?php
/**
 * 
 ISSUE     FORK          FECHA:		       AUTOR                 DESCRIPCION
   
 #7        ENDEERT		27-12-2018        MANUEL GUERRA            CREACION
*/
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
Phx.vista.WizardTramiteCbte = Ext.extend(Phx.frmInterfaz,{
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
		Phx.vista.WizardTramiteCbte.superclass.constructor.call(this,config);
		this.init(); 
	},
	
	loadValoresIniciales:function(){    	
		Phx.vista.WizardTramiteCbte.superclass.loadValoresIniciales.call(this);
		//iniciar valroes de comprobantes seleccionados 
		this.Cmp.id_int_comprobante.setValue(this.id_int_comprobante);
		this.Cmp.nro_tramite_aux.setValue(this.nro_tramite_aux);
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
			config: {
				name: 'nro_tramite_aux',
				fieldLabel: 'Nro Tramite',
				typeAhead: false,
				tinit:false,
				resizable:true,
				tasignacion:false,
				//forceSelection: false,
				allowBlank: true,
				emptyText: 'Tramite...',
				store: new Ext.data.JsonStore({
					url: '../../sis_contabilidad/control/IntComprobante/listadoTramites',
					id: 'id_proceso_wf',
					root: 'datos',
					sortInfo: {
						field: 'nro_tramite',
						direction: 'ASC'
					},					
					fields: ['nro_tramite', 'id_proceso_wf'],
					totalProperty: 'total',						
					remoteSort: true,
					baseParams: {par_filtro: 'w.nro_tramite'}
					//baseParams: Ext.apply({par_filtro:'nro_tramite'},config.baseParams)
				}),
				valueField: 'id_proceso_wf',
				displayField: 'nro_tramite',
				gdisplayField: 'nro_tramite',
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 20,
				width: 150,
				queryDelay: 200,
				listWidth:280,
				minChars: 2
			},
			type: 'ComboBox',
			id_grupo: 0,
			form: true
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
				url : '../../sis_contabilidad/control/IntComprobante/modificarTramiIntCbte',
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