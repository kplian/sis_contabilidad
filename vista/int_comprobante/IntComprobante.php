<?php
/**
 *@package pXP
 *@file gen-IntComprobante.php
 *@author  (admin)
 *@date 29-08-2013 00:28:30
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
	Phx.vista.IntComprobante = Ext.extend(Phx.gridInterfaz, {
		fheight : '90%',
		fwidth : '90%',
		nombreVista : 'IntComprobante',
		constructor : function(config) {
			this.maestro = config.maestro;
			this.initButtons = [this.cmbDepto, this.cmbGestion];

			//llama al constructor de la clase padre
			Phx.vista.IntComprobante.superclass.constructor.call(this, config);			
			this.bbar.add(this.cmbTipoCbte);
			
			//Botón para Imprimir el Comprobante
			this.addButton('btnImprimir', {
				text : 'Imprimir',
				iconCls : 'bprint',
				disabled : true,
				handler : this.imprimirCbte,
				tooltip : '<b>Imprimir Comprobante</b><br/>Imprime el Comprobante en el formato oficial'
			});
			
			this.addButton('btnDocCmpVnt', {
				text : 'Doc Cmp/Vnt',
				iconCls : 'brenew',
				disabled : true,
				handler : this.loadDocCmpVnt,
				tooltip : '<b>Documentos de compra/venta</b><br/>Muestras los docuemntos relacionados con el comprobante'
			});

			this.addButton('btnAIRBP',
					{
						text: 'Subir AIRBP',
						iconCls: 'blist',
						disabled: false,
						handler: this.onButtonAIRBP,
						tooltip: 'Subir archivo facturas AIRBP'
					}
			);
			
			this.addButton('chkdep',{	text:'Dependencias',
				iconCls: 'blist',
				disabled: true,
				handler: this.checkDependencias,
				tooltip: '<b>Revisar Dependencias </b><p>Revisar dependencias del comprobante</p>'
			});
			

			this.addButton('btnRelDev', {
				text : 'Rel Dev',
				iconCls : 'btag_accept',
				disabled : true,
				handler : this.loadRelDev,
				tooltip : '<b>Relación con el devengado</b><br/>Solo para comprobantes de pago presupuestario'
			});
			
			this.addBotonesPresupuesto()
			
			
			this.addBotonesGantt();
	        this.addButton('btnChequeoDocumentosWf',
	            {
	                text: 'Documentos',
	                grupo:[0,1,2,3],
	                iconCls: 'bchecklist',
	                disabled: true,
	                handler: this.loadCheckDocumentosWf,
	                tooltip: '<b>Documentos del Trámite</b><br/>Permite ver los documentos asociados al NRO de trámite.'
	            }
	        );
        
	        this.addButton('btnObs',{
	                    text :'Obs Wf',
	                    grupo:[0,1,2,3],
	                    iconCls : 'bchecklist',
	                    disabled: true,
	                    handler : this.onOpenObs,
	                    tooltip : '<b>Observaciones</b><br/><b>Observaciones del WF</b>'
	         });

			

			this.bloquearOrdenamientoGrid();

			this.cmbDepto.on('clearcmb', function() {
				this.DisableSelect();
				this.store.removeAll();
			}, this);

			this.cmbDepto.on('valid', function() {
				 if(this.cmbGestion.validate()){
				   this.capturaFiltros();
				}
				

			}, this);
			
			this.cmbGestion.on('select', function(){
			    if( this.validarFiltros() ){
	                  this.capturaFiltros();
	             }
			},this);
			
			
			this.cmbTipoCbte.on('select', function(obj,newValue,oldValue){
			    if( this.validarFiltros() ){			      	
				    this.capturaFiltros();
			     }
			},this);
			
			this.cmbTipoCbte.on('clearcmb', function(obj,newValue,oldValue){
			    if( this.validarFiltros() ){			      	
				    this.capturaFiltros();
			     }
			},this); 
			
			
			

			this.iniciarEventos();
		},

		capturaFiltros : function(combo, record, index) {
			this.desbloquearOrdenamientoGrid();
			this.store.baseParams.id_deptos = this.cmbDepto.getValue();
			this.store.baseParams.id_gestion = this.cmbGestion.getValue();
			if(this.cmbTipoCbte.getValue()){
				this.store.baseParams.id_clase_comprobante = this.cmbTipoCbte.getValue();
			}
			else{
				delete this.store.baseParams.id_clase_comprobante;
			}
			this.store.baseParams.id_clase_comprobante = this.cmbTipoCbte.getValue();
			this.store.baseParams.nombreVista = this.nombreVista
			this.load();
		},

		validarFiltros : function() {
			console.log('values....', this.cmbDepto.getValue())
			if (this.cmbDepto.getValue() != '' && this.cmbGestion.validate() ) {
			
				return true;
			} else {
				return false;
			}
		},
		onButtonAct : function() {
			if (!this.validarFiltros()) {
				alert('Especifique los filtros antes')
			}
			else{
				 this.capturaFiltros();
			}
		},
		iniciarEventos : function() {

			
			this.Cmp.id_moneda.on('select', function(){
												this.getConfigCambiaria('si');
											    this.Cmp.id_int_comprobante_fks.reset();
											    this.Cmp.id_int_comprobante_fks.modificado = true;
											}, this);
											
											
			this.Cmp.fecha.on('select', function(){ this.getConfigCambiaria('si') }, this);
			this.Cmp.forma_cambio.on('select', function(){ this.getConfigCambiaria('si') }, this);
			this.Cmp.id_clase_comprobante.on('select', this.habilitaMomentos, this);

			this.Cmp.id_tipo_relacion_comprobante.on('valid', function() {
				if (this.Cmp.id_tipo_relacion_comprobante.getValue()) {
					this.Cmp.id_int_comprobante_fks.allowBlank = false;
					this.Cmp.id_int_comprobante_fks.enable();
				} else {
					this.Cmp.id_int_comprobante_fks.allowBlank = true;
					this.Cmp.id_int_comprobante_fks.reset();
					this.Cmp.id_int_comprobante_fks.disable();
				}

			}, this);
			
			this.Cmp.id_int_comprobante_fks.on('beforequery',function( queryEvent ){
				 var id_m = this.Cmp.id_moneda.getValue(),
				     id_g = this.cmbGestion.getValue();
				if(id_m && id_g){
					this.Cmp.id_int_comprobante_fks.store.baseParams.id_moneda  = id_m;
					//RAC 29/!2/2016 comentado por que hay pagos de 2017 que necesitan relacion con cbte 2016
					//this.Cmp.id_int_comprobante_fks.store.baseParams.id_gestion = id_g;
					this.Cmp.id_int_comprobante_fks.store.modificado = true;				
				} 
				else{
					queryEvent.cancel = true;
				}			
			},this);
		},

		Atributos : [{
			//configuracion del componente
			config : {
				labelSeparator : '',
				inputType : 'hidden',
				name : 'id_int_comprobante'
			},
			type : 'Field',
			form : true,
			grid : false
		}, {
			//configuracion del componente
			config : {
				labelSeparator : '',
				inputType : 'hidden',
				name : 'id_periodo'
			},
			type : 'Field',
			id_grupo : 0,
			form : true
		}, {
			//configuracion del componente
			config : {
				labelSeparator : '',
				inputType : 'hidden',
				name : 'id_subsistema'
			},
			type : 'Field',
			id_grupo : 0,
			form : true
		}, {
			//configuracion del componente
			config : {
				fieldLabel : 'ID.',
				gwidth : 50,
				name : 'id_int_comprobante'
			},
			type : 'Field',
			bottom_filter : true,
			form : false,
			grid : true
		}, 
		
		{
			//configuracion del componente
			config : {
				labelSeparator : '',
				inputType : 'hidden',
				name : 'id_config_cambiaria'
			},
			type : 'Field',
			id_grupo : 0,
			form : true
		},
		
		
		{
			config : {
				name : 'manual',
				fieldLabel : 'Manual',
				gwidth : 50,
				renderer : function(value, p, record) {
					if (value == 'si') {
						return String.format('<b><font color="green">{0}</font></b>', value);
					} else {
						return String.format('<b><font color="orange">{0}</font></b>', value);
					}
				}
			},
			type : 'Field',
			id_grupo : 0,
			filters : {
				pfiltro : 'incbte.manual',
				type : 'string'
			},
			grid : true,
			form : false
		}, {
			config : {
				name : 'nro_cbte',
				fieldLabel : 'Nro.Cbte.',
				gwidth : 135,
				emptyText : 'Nro. de Cbte.',
				renderer: function(value,p,record){
                         if(record.data.c31 && record.data.c31 !='' ){
                             return String.format('<font color="#0000FF">{0}</font><br>{1}', value,record.data.c31);
                         }
                          return String.format('{0}', value);
                       
                 }
			},
			type : 'Field',
			filters : {
				pfiltro : 'incbte.nro_cbte#incbte.C31',
				type : 'string'
			},
			id_grupo : 0,
			bottom_filter : true,
			grid : true,
			form : false
		}, {
			config : {
				name : 'fecha',
				fieldLabel : 'Fecha',
				allowBlank : false,
				anchor : '80%',
				maxValue : new Date(),
				gwidth : 100,
				format : 'd/m/Y',
				renderer : function(value, p, record) {
					return value ? value.dateFormat('d/m/Y') : ''
				}
			},
			type : 'DateField',
			filters : {
				pfiltro : 'incbte.fecha',
				type : 'date'
			},
			id_grupo : 2,
			grid : true,
			form : true
		}, 
		{
			config : {
				name : 'id_depto',
				hiddenName : 'id_depto',
				url : '../../sis_parametros/control/Depto/listarDeptoFiltradoXUsuario',
				origen : 'DEPTO',
				allowBlank : false,
				fieldLabel : 'Depto',
				gdisplayField : 'desc_depto', //dibuja el campo extra de la consulta al hacer un inner join con orra tabla
				width : 250,
				gwidth : 180,
				baseParams : {
					estado : 'activo',
					codigo_subsistema : 'CONTA'
				}, //parametros adicionales que se le pasan al store
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['desc_depto']);
				}
			},
			//type:'TrigguerCombo',
			type : 'ComboRec',
			id_grupo : 0,
			filters : {
				pfiltro : 'incbte.desc_depto',
				type : 'string'
			},
			grid : false,
			form : true
		}, 
		{
			config : {
				name : 'id_clase_comprobante',
				fieldLabel : 'Tipo Cbte.',
				allowBlank : false,
				emptyText : 'Elija una opción...',
				store : new Ext.data.JsonStore({
					url : '../../sis_contabilidad/control/ClaseComprobante/listarClaseComprobante',
					id : 'id_clase_comprobante',
					root : 'datos',
					sortInfo : {
						field : 'id_clase_comprobante',
						direction : 'ASC'
					},
					totalProperty : 'total',
					fields : ['id_clase_comprobante', 'tipo_comprobante', 'descripcion', 'codigo', 'momento_comprometido', 'momento_ejecutado', 'momento_pagado'],
					remoteSort : true,
					baseParams : {
						par_filtro : 'ccom.tipo_comprobante#ccom.descripcion'
					}
				}),
				valueField : 'id_clase_comprobante',
				displayField : 'descripcion',
				gdisplayField : 'desc_clase_comprobante',
				hiddenName : 'id_clase_comprobante',
				forceSelection : true,
				typeAhead : false,
				triggerAction : 'all',
				lazyRender : true,
				mode : 'remote',
				pageSize : 15,
				queryDelay : 1000,
				width : 250,
				anchor : '100%',
				gwidth : 150,
				minChars : 2,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['desc_clase_comprobante']);
				}
			},
			type : 'ComboBox',
			id_grupo : 1,
			filters : {
				pfiltro : 'incbte.desc_clase_comprobante',
				type : 'string'
			},
			grid : true,
			form : true
		}, {
			config : {
				name : 'momento',
				fieldLabel : 'Tipo',
				qtip : 'Si el comprobante es presupuestario es encesario especificar los momentos que utiliza',
				allowBlank : false,
				gwidth : 100,
				width : 250,
				typeAhead : true,
				triggerAction : 'all',
				lazyRender : true,
				mode : 'local',
				valueField : 'inicio',
				store : ['contable', 'presupuestario']
			},
			type : 'ComboBox',
			id_grupo : 1,
			filters : {
				type : 'list',
				pfiltro : 'incbte.momento',
				options : ['contable', 'presupuestario'],
			},
			grid : true,
			form : false
		}, {
			config : {
				name : 'momento_comprometido',
				fieldLabel : 'Comprometido',
				renderer : function(value, p, record) {
					return record.data['momento_comprometido'] == 'true' ? 'si' : 'no';
				},
				gwidth : 50,

			},
			type : 'Checkbox',
			id_grupo : 1,
			grid : true,
			form : true
		}, {
			config : {
				name : 'momento_ejecutado',
				fieldLabel : 'Ejecutado',
				renderer : function(value, p, record) {
					return record.data['momento_ejecutado'] == 'true' ? 'si' : 'no';
				},
				gwidth : 50,

			},
			type : 'Checkbox',
			id_grupo : 1,
			grid : true,
			form : true
		}, {
			config : {
				name : 'momento_pagado',
				fieldLabel : 'Pagado',
				renderer : function(value, p, record) {
					return record.data['momento_pagado'] == 'true' ? 'si' : 'no';
				},
				gwidth : 50,

			},
			type : 'Checkbox',
			id_grupo : 1,
			grid : true,
			form : true
		}, 
		{
			config : {
				name : 'id_tipo_relacion_comprobante',
				fieldLabel : 'Tipo Rel.',
				qtip : 'Tipo de relacion entre comprobantes',
				allowBlank : true,
				emptyText : 'Elija una opción...',
				store : new Ext.data.JsonStore({
					url : '../../sis_contabilidad/control/TipoRelacionComprobante/listarTipoRelacionComprobante',
					id : 'id_tipo_relacion_comprobante',
					root : 'datos',
					sortInfo : {
						field : 'id_tipo_relacion_comprobante',
						direction : 'ASC'
					},
					totalProperty : 'total',
					fields : ['id_tipo_relacion_comprobante', 'codigo', 'nombre'],
					remoteSort : true,
					baseParams : {
						par_filtro : 'tiprelco.nombre#tiprelco.codigo'
					}
				}),
				valueField : 'id_tipo_relacion_comprobante',
				displayField : 'nombre',
				gdisplayField : 'desc_tipo_relacion_comprobante',
				hiddenName : 'id_tipo_relacion_comprobante',
				//forceSelection: true,
				typeAhead : false,
				triggerAction : 'all',
				lazyRender : true,
				mode : 'remote',
				pageSize : 15,
				queryDelay : 1000,
				width : 250,
				anchor : '100%',
				gwidth : 150,
				minChars : 2,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['desc_tipo_relacion_comprobante']);
				}
			},
			type : 'ComboBox',
			id_grupo : 1,
			filters : {
				pfiltro : 'incbte.desc_tipo_relacion_comprobante',
				type : 'string'
			},
			grid : true,
			form : true
		}, {
			config : {
				name : 'id_int_comprobante_fks',
				enableMultiSelect : true,
				fieldLabel : 'Cbte rels.',
				qtip : 'Comprobantes relacionados',
				allowBlank : true,
				emptyText : 'Elija una opción...',
				store : new Ext.data.JsonStore({
					url : '../../sis_contabilidad/control/IntComprobante/listarSimpleIntComprobante',
					id : 'id_int_comprobante',
					root : 'datos',
					sortInfo : {
						field : 'id_int_comprobante',
						direction : 'desc'
					},
					totalProperty : 'total',
					fields : ['id_int_comprobante', 'nro_cbte', 'nro_tramite', 'fecha', 'glosa1', 'glosa2','desc_moneda', 'id_clase_comprobante', 'codigo', 'descripcion'],
					remoteSort : true,
					baseParams : {
						par_filtro : 'inc.id_int_comprobante#inc.nro_cbte#inc.fecha#inc.glosa1#inc.glosa2#inc.nro_tramite'
					}
				}),
				tpl : new Ext.XTemplate('<tpl for="."><div class="awesomecombo-5item {checked}">', '<p>(ID: {id_int_comprobante}), Nro: {nro_cbte} , ({desc_moneda})</p>', '<p>Fecha: <strong>{fecha}</strong></p>', '<p>TR: {nro_tramite}</p>', '<p>GLS: {glosa1}</p>', '</div></tpl>'),
				itemSelector : 'div.awesomecombo-5item',

				valueField : 'id_int_comprobante',
				displayField : 'nro_cbte',
				gdisplayField : 'desc_comprobante_rel',
				forceSelection : true,
				typeAhead : false,
				triggerAction : 'all',
				lazyRender : true,
				mode : 'remote',
				pageSize : 15,
				queryDelay : 1000,
				width : 250,
				anchor : '100%',
				listWidth : '320',
				gwidth : 150,
				minChars : 2,
				resizable : true,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['desc_tipo_relacion_comprobante']);
				}
			},
			type : 'AwesomeCombo',
			id_grupo : 1,
			grid : false,
			form : true
		}, {
			config : {
				name : 'id_moneda',
				origen : 'MONEDA',
				allowBlank : false,
				fieldLabel : 'Moneda',
				gdisplayField : 'desc_moneda', //mapea al store del grid
				gwidth : 100,
				width : 250,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['desc_moneda']);
				}
			},
			type : 'ComboRec',
			id_grupo : 2,
			filters : {
				pfiltro : 'incbte.desc_moneda',
				type : 'string'
			},
			grid : true,
			form : true
		}, 
		
		
		{
			config : {
				name : 'forma_cambio',
				fieldLabel : 'Cambio',
				qtip : 'Tipo cambio oficial, compra, venta o convenido',
				allowBlank : false,
				gwidth : 100,
				width : 250,
				typeAhead : true,
				triggerAction : 'all',
				lazyRender : true,
				mode : 'local',
				valueField : 'oficial',
				store : ['oficial', 'compra','venta','convenido']
			},
			type : 'ComboBox',
			id_grupo : 2,
			filters : {
				type : 'list',
				pfiltro : 'incbte.forma_cambio',
				options : ['oficial', 'compra','venta','convenido'],
			},
			grid : true,
			form : true
		},
		
		{
			config : {
				name : 'tipo_cambio',
				readOnly : true,
				fieldLabel : 'TC',
				allowBlank : false,
				anchor : '80%',
				gwidth : 70,
				maxLength : 20,
				decimalPrecision : 10
			},
			type : 'NumberField',
			filters : {
				pfiltro : 'incbte.tipo_cambio',
				type : 'numeric'
			},
			id_grupo : 2,
			grid : true,
			form : true
		}, 
		{
			config : {
				name : 'tipo_cambio_2',
				fieldLabel : '(TC)',
				allowBlank : false,
				readOnly : true,
				anchor : '80%',
				gwidth : 70,
				maxLength : 20,
				decimalPrecision : 6
			},
			type : 'NumberField',
			filters : {
				pfiltro : 'incbte.tipo_cambio_2',
				type : 'numeric'
			},
			id_grupo : 2,
			grid : true,
			form : true
		}, 
		{
			config : {
				name : 'tipo_cambio_3',
				fieldLabel : '(TC)',
				allowBlank : false,
				readOnly : true,
				anchor : '80%',
				gwidth : 70,
				maxLength : 20,
				decimalPrecision : 6
			},
			type : 'NumberField',
			filters : {
				pfiltro : 'incbte.tipo_cambio_3',
				type : 'numeric'
			},
			id_grupo : 2,
			grid : true,
			form : true
		},
		
		{
			config : {
				name : 'nro_tramite',
				gwidth : 150,
				fieldLabel : 'Nro. Trámite',
                renderer: function(value,p,record){
                         if(record.data.cbte_reversion=='si'){
                             return String.format('<div title="Cbte de Reversión"><b><font color="#0000FF">{0}</font></b></div>', value);
                         }
                        if(record.data.volcado=='si'){
                             return String.format('<div title="Cbte Revertido/Volcado"><b><font color="red">{0}</font></b></div>', value);
                        }
                             return String.format('{0}', value);
                       
                 }
			},
			type : 'Field',
			id_grupo : 0,
			filters : {
				pfiltro : 'incbte.nro_tramite',
				type : 'string'
			},
			grid : true,
			bottom_filter : true,
			form : false,
			grid : true,
		}, {
			config : {
				name : 'glosa1',
				fieldLabel : 'Glosa',
				allowBlank : false,
				anchor : '100%',
				gwidth : 100,
				maxLength : 1500
			},
			type : 'TextArea',
			filters : {
				pfiltro : 'incbte.glosa1',
				type : 'string'
			},
			id_grupo : 0,
			bottom_filter : true,
			grid : true,
			form : true
		}, {
			config : {
				name : 'glosa2',
				fieldLabel : 'Conformidad',
				allowBlank : false,
				anchor : '100%',
				gwidth : 100,
				maxLength : 400
			},
			type : 'TextField',
			filters : {
				pfiltro : 'incbte.glosa2',
				type : 'string'
			},
			id_grupo : 0,
			bottom_filter : true,
			grid : true,
			form : true
		}, {
			config : {
				name : 'beneficiario',
				fieldLabel : 'Beneficiario',
				allowBlank : false,
				anchor : '100%',
				gwidth : 250,
				maxLength : 100
			},
			type : 'TextField',
			filters : {
				pfiltro : 'incbte.beneficiario',
				type : 'string'
			},
			id_grupo : 0,
			bottom_filter : true,
			grid : true,
			form : true
		}, {
			config : {
				name : 'id_funcionario_firma1',
				origen : 'FUNCIONARIO',
				tinit : true,
				fieldLabel : 'Firma 1',
				gdisplayField : 'desc_firma1',
				gwidth : 120,
				anchor : '100%',
				allowBlank : true,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['desc_firma1']);
				}
			},
			type : 'ComboRec',
			id_grupo : 0,
			filters : {
				pfiltro : 'incbte.desc_firma1',
				type : 'string'
			},
			grid : true,
			form : true
		}, {
			config : {
				name : 'id_funcionario_firma2',
				origen : 'FUNCIONARIO',
				tinit : true,
				fieldLabel : 'Firma 2',
				gdisplayField : 'desc_firma2',
				gwidth : 120,
				anchor : '100%',
				allowBlank : true,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['desc_firma2']);
				}
			},
			type : 'ComboRec',
			id_grupo : 0,
			filters : {
				pfiltro : 'incbte.desc_firma2',
				type : 'string'
			},
			grid : true,
			form : true
		}, {
			config : {
				name : 'id_funcionario_firma3',
				origen : 'FUNCIONARIO',
				tinit : true,
				fieldLabel : 'Firma 3',
				gdisplayField : 'desc_firma3',
				gwidth : 120,
				anchor : '100%',
				allowBlank : true,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['desc_firma3']);
				}
			},
			type : 'ComboRec',
			id_grupo : 0,
			filters : {
				pfiltro : 'incbte.desc_firma3',
				type : 'string'
			},
			grid : true,
			form : true
		}, {
			config : {
				name : 'cbte_cierre',
				qtip : 'Es un comprobante de cierre?,  en la mayoria de lso casos es No,<br>  solo utilice si es un comprobante de cierre de balance o de resultados',
				fieldLabel : 'Cierre',
				allowBlank : false,
				gwidth : 80,
				width : 80,
				typeAhead : true,
				triggerAction : 'all',
				lazyRender : true,

				mode : 'local',
				store : ['no', 'balance', 'resultado']
			},
			type : 'ComboBox',
			filters : {
				pfiltro : 'incbte.cbte_cierre',
				type : 'string'
			},
			valorInicial : 'no',
			id_grupo : 0,
			grid : true,
			egrid : true,
			form : true
		}, {
			config : {
				name : 'cbte_apertura',
				qtip : 'Es un comprobante de apertura',
				fieldLabel : 'Apertura',
				allowBlank : false,
				gwidth : 80,
				width : 80,
				typeAhead : true,
				triggerAction : 'all',
				lazyRender : true,
				mode : 'local',
				store : ['no', 'si']
			},
			type : 'ComboBox',
			filters : {
				pfiltro : 'incbte.cbte_apertura',
				type : 'string'
			},
			valorInicial : 'no',
			id_grupo : 0,
			grid : true,
			egrid : true,
			form : true
		}, {
			config : {
				name : 'cbte_aitb',
				qtip : 'es un comprobante para AITB',
				fieldLabel : 'AITBs',
				allowBlank : false,
				gwidth : 80,
				width : 80,
				typeAhead : true,
				triggerAction : 'all',
				lazyRender : true,
				mode : 'local',
				store : ['no', 'si']
			},
			type : 'ComboBox',
			filters : {
				pfiltro : 'incbte.cbte_aitb',
				type : 'string'
			},
			valorInicial : 'no',
			id_grupo : 0,
			grid : true,
			egrid : true,
			form : true
		}, {
			config : {
				name : 'fecha_costo_ini',
				fieldLabel : 'Fecha Inicial',
				allowBlank : true,
				width : 100,
				gwidth : 100,
				format : 'd/m/Y',
				renderer : function(value, p, record) {
					return value ? value.dateFormat('d/m/Y') : ''
				}
			},
			type : 'DateField',
			filters : {
				pfiltro : 'incbte.fecha_costo_ini',
				type : 'date'
			},
			id_grupo : 3,
			egrid : true,
			grid : true,
			form : true
		}, {
			config : {
				name : 'fecha_costo_fin',
				fieldLabel : 'Fecha Final',
				allowBlank : true,
				width : 100,
				gwidth : 100,
				format : 'd/m/Y',
				renderer : function(value, p, record) {
					return value ? value.dateFormat('d/m/Y') : ''
				}
			},
			type : 'DateField',
			filters : {
				pfiltro : 'incbte.fecha_costo_fin',
				type : 'date'
			},
			id_grupo : 3,
			egrid : true,
			grid : true,
			form : true
		}, {
			config : {
				name : 'estado_reg',
				fieldLabel : 'Estado',
				emptyText : 'Estado Reg.'
			},
			type : 'Field',
			filters : {
				pfiltro : 'incbte.estado_reg',
				type : 'string'
			},
			grid : true,
			form : false
		}, {
			config : {
				name : 'usr_reg',
				fieldLabel : 'Creado por',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				maxLength : 4
			},
			type : 'Field',
			filters : {
				pfiltro : 'incbte.usr_reg',
				type : 'string'
			},
			id_grupo : 0,
			grid : true,
			form : false
		}, {
			config : {
				name : 'fecha_reg',
				fieldLabel : 'Fecha creación',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				format : 'd/m/Y',
				renderer : function(value, p, record) {
					return value ? value.dateFormat('d/m/Y H:i:s') : ''
				}
			},
			type : 'DateField',
			filters : {
				pfiltro : 'incbte.fecha_reg',
				type : 'date'
			},
			id_grupo : 0,
			grid : true,
			form : false
		}, {
			config : {
				name : 'usr_mod',
				fieldLabel : 'Modificado por',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				maxLength : 4
			},
			type : 'Field',
			filters : {
				pfiltro : 'incbte.usr_mod',
				type : 'string'
			},
			id_grupo : 0,
			grid : true,
			form : false
		}, {
			config : {
				name : 'fecha_mod',
				fieldLabel : 'Fecha Modif.',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				format : 'd/m/Y',
				renderer : function(value, p, record) {
					return value ? value.dateFormat('d/m/Y H:i:s') : ''
				}
			},
			type : 'DateField',
			filters : {
				pfiltro : 'incbte.fecha_mod',
				type : 'date'
			},
			id_grupo : 0,
			grid : true,
			form : false
		}],

		Grupos : [{
			layout : 'column',
			border : false,
			defaults : {
				border : false
			},
			items : [{
				bodyStyle : 'padding-right:5px;',
				items : [{
					xtype : 'fieldset',
					title : 'Datos principales',
					autoHeight : true,
					columns : 1,
					items : [],
					id_grupo : 0
				}]
			}, {
				bodyStyle : 'padding-left:5px;',
				items : [{
					xtype : 'fieldset',
					columns : 2,
					title : 'Tipo de Cambio',
					autoHeight : true,
					items : [],
					id_grupo : 2
				}]
			}, {
				bodyStyle : 'padding-left:5px;',
				items : [{
					xtype : 'fieldset',
					columns : 2,
					title : 'Tipo  Comprobante',
					autoHeight : true,
					items : [],
					id_grupo : 1
				}]
			}, {
				bodyStyle : 'padding-left:5px;',
				items : [{
					xtype : 'fieldset',
					columns : 2,
					title : 'Periodo del Costo',
					autoHeight : true,
					items : [],
					id_grupo : 3
				}]
			}]
		}],
		tam_pag : 50,
		title : 'Comprobante',
		ActSave : '../../sis_contabilidad/control/IntComprobante/insertarIntComprobante',
		ActDel : '../../sis_contabilidad/control/IntComprobante/eliminarIntComprobante',
		ActList : '../../sis_contabilidad/control/IntComprobante/listarIntComprobante',
		id_store : 'id_int_comprobante',
		fields : [{
			name : 'id_int_comprobante',
			type : 'numeric'
		}, {
			name : 'id_clase_comprobante',
			type : 'numeric'
		}, {
			name : 'id_int_comprobante_fk',
			type : 'numeric'
		}, {
			name : 'id_subsistema',
			type : 'numeric'
		}, {
			name : 'id_depto',
			type : 'numeric'
		}, {
			name : 'id_moneda',
			type : 'numeric'
		}, {
			name : 'id_periodo',
			type : 'numeric'
		}, {
			name : 'id_funcionario_firma1',
			type : 'numeric'
		}, {
			name : 'id_funcionario_firma2',
			type : 'numeric'
		}, {
			name : 'id_funcionario_firma3',
			type : 'numeric'
		}, {
			name : 'tipo_cambio',
			type : 'numeric'
		}, {
			name : 'beneficiario',
			type : 'string'
		}, {
			name : 'nro_cbte',
			type : 'string'
		}, {
			name : 'estado_reg',
			type : 'string'
		}, {
			name : 'glosa1',
			type : 'string'
		}, {
			name : 'fecha',
			type : 'date',
			dateFormat : 'Y-m-d'
		}, {
			name : 'glosa2',
			type : 'string'
		}, {
			name : 'nro_tramite',
			type : 'string'
		}, {
			name : 'momento',
			type : 'string'
		}, {
			name : 'id_usuario_reg',
			type : 'numeric'
		}, {
			name : 'fecha_reg',
			type : 'date',
			dateFormat : 'Y-m-d H:i:s.u'
		}, {
			name : 'id_usuario_mod',
			type : 'numeric'
		}, {
			name : 'fecha_mod',
			type : 'date',
			dateFormat : 'Y-m-d H:i:s.u'
		}, {
			name : 'usr_reg',
			type : 'string'
		}, {
			name : 'usr_mod',
			type : 'string'
		}, {
			name : 'desc_clase_comprobante',
			type : 'string'
		}, {
			name : 'desc_subsistema',
			type : 'string'
		}, {
			name : 'desc_depto',
			type : 'string'
		}, {
			name : 'desc_moneda',
			type : 'string'
		}, {
			name : 'desc_firma1',
			type : 'string'
		}, {
			name : 'desc_firma2',
			type : 'string'
		}, {
			name : 'desc_firma3',
			type : 'string'
		}, {
			name : 'fecha_costo_ini',
			type : 'date',
			dateFormat : 'Y-m-d'
		}, {
			name : 'fecha_costo_fin',
			type : 'date',
			dateFormat : 'Y-m-d'
		}, 'momento_comprometido', 'momento_ejecutado', 'id_moneda_base','id_proceso_wf','id_estado_wf',
		'cbte_cierre', 'cbte_apertura', 'cbte_aitb', 'momento_pagado', 'manual', 
		'desc_tipo_relacion_comprobante', 'id_int_comprobante_fks', 'manual', 
		'id_tipo_relacion_comprobante', 'tipo_cambio_2', 'id_moneda_tri', 'tipo_cambio_3', 'id_moneda_act',
		'sw_tipo_cambio', 'id_config_cambiaria', 'ope_1', 'ope_2', 'ope_3',
		'desc_moneda_tri', 'localidad','sw_editable','cbte_reversion','volcado','c31','fecha_c31','forma_cambio'],

		rowExpander : new Ext.ux.grid.RowExpander({
			tpl : new Ext.Template('<br>', '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Departamento:&nbsp;&nbsp;</b> {desc_depto} </p>', '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Clase cbte:&nbsp;&nbsp;</b> {desc_clase_comprobante}</p>', '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Origen:&nbsp;&nbsp;</b> {desc_subsistema}</p>', '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Beneficiario:&nbsp;&nbsp;</b> {beneficiario}</p>', '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Glosa:&nbsp;&nbsp;</b> {glosa1} {glosa2}</p>', '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Frima 1:&nbsp;&nbsp;</b> {desc_firma1} </p>', '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Firma 2:&nbsp;&nbsp;</b> {desc_firma2} </p>', '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Firma 3:&nbsp;&nbsp;</b> {desc_firma3} </p>', '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Creado por:&nbsp;&nbsp;</b> {usr_reg}</p>', '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Estado Registro:&nbsp;&nbsp;</b> {estado_reg}</p><br>')
		}),

		arrayDefaultColumHidden : ['id_funcionario_firma1', 'id_funcionario_firma2', 'id_funcionario_firma3', 'id_subsistema', 'id_tipo_relacion_comprobante', 'fecha_mod', 'usr_reg', 'usr_mod', 'id_depto', 'estado', 'glosa1', 'momento', 'glosa2', 'desc_subsistema', 'desc_clase_comprobante', 'estado_reg', 'fecha_reg'],

		sortInfo : {
			field : 'id_int_comprobante',
			direction : 'desc'
		},
		bdel : true,
		bsave : false,
		cmbDepto : new Ext.form.AwesomeCombo({
			name : 'id_depto',
			fieldLabel : 'Depto',
			typeAhead : false,
			forceSelection : true,
			allowBlank : false,
			disableSearchButton : true,
			emptyText : 'Depto Contable',
			store : new Ext.data.JsonStore({
				url : '../../sis_parametros/control/Depto/listarDeptoFiltradoDeptoUsuario',
				id : 'id_depto',
				root : 'datos',
				sortInfo : {
					field : 'deppto.nombre',
					direction : 'ASC'
				},
				totalProperty : 'total',
				fields : ['id_depto', 'nombre', 'codigo'],
				// turn on remote sorting
				remoteSort : true,
				baseParams : {
					par_filtro : 'deppto.nombre#deppto.codigo',
					estado : 'activo',
					codigo_subsistema : 'CONTA'
				}
			}),
			valueField : 'id_depto',
			displayField : 'nombre',
			hiddenName : 'id_depto',
			enableMultiSelect : true,
			triggerAction : 'all',
			lazyRender : true,
			mode : 'remote',
			pageSize : 20,
			queryDelay : 200,
			anchor : '80%',
			listWidth : '280',
			resizable : true,
			minChars : 2
		}),
		
		
      cmbGestion: new Ext.form.ComboBox({
				fieldLabel: 'Gestion',
				grupo:[0,1,2],
				allowBlank: false,
				blankText:'... ?',
				emptyText:'Gestion...',
				store:new Ext.data.JsonStore(
				{
					url: '../../sis_parametros/control/Gestion/listarGestion',
					id: 'id_gestion',
					root: 'datos',
					sortInfo:{
						field: 'gestion',
						direction: 'DESC'
					},
					totalProperty: 'total',
					fields: ['id_gestion','gestion'],
					// turn on remote sorting
					remoteSort: true,
					baseParams:{par_filtro:'gestion'}
				}),
				valueField: 'id_gestion',
				triggerAction: 'all',
				displayField: 'gestion',
			    hiddenName: 'id_gestion',
    			mode:'remote',
				pageSize:50,
				queryDelay:500,
				listWidth:'280',
				width:80
			}),	
			
		cmbTipoCbte: new Ext.form.ClearCombo({
				name : 'id_clase_comprobante',
				fieldLabel : 'Tipo Cbte.',
				allowBlank : true,
				emptyText : 'Elija una opción...',
				store : new Ext.data.JsonStore({
					url : '../../sis_contabilidad/control/ClaseComprobante/listarClaseComprobante',
					id : 'id_clase_comprobante',
					root : 'datos',
					sortInfo : {field : 'id_clase_comprobante',direction : 'ASC'},
					totalProperty : 'total',
					fields : ['id_clase_comprobante', 'tipo_comprobante', 'descripcion', 'codigo', 'momento_comprometido', 'momento_ejecutado', 'momento_pagado'],
					remoteSort : true,
					baseParams : {par_filtro : 'ccom.tipo_comprobante#ccom.descripcion'}
				}),
				valueField : 'id_clase_comprobante',
				displayField : 'descripcion',				
				hiddenName : 'id_clase_comprobante',
				forceSelection : true,
				typeAhead : false,
				triggerAction : 'all',
				lazyRender : true,
				mode : 'remote',
				pageSize : 15,
				queryDelay : 1000,
				width : 250,
				minChars : 2,
			}),		
			
		south : {
			url : '../../../sis_contabilidad/vista/int_transaccion/IntTransaccion.php',
			title : 'Transacciones',
			height : '50%', //altura de la ventana hijo
			cls : 'IntTransaccion'
		},
		

		habilitaMomentos : function(combo, record, index) {
			//si es solo contable coloco en falo los momentos y los deshabilita
			if (record.data.tipo_comprobante == 'contable') {

				this.Cmp.momento_comprometido.setValue(false);
				this.Cmp.momento_ejecutado.setValue(false);
				this.Cmp.momento_pagado.setValue(false);
				
				this.Cmp.momento_comprometido.disable();
				this.Cmp.momento_ejecutado.disable();
				this.Cmp.momento_pagado.disable();

			} else {
				
				
				//comprometido
				if (record.data.momento_comprometido == 'opcional') {
					this.Cmp.momento_comprometido.enable();
				}
				if (record.data.momento_comprometido == 'obligatorio') {
					this.Cmp.momento_comprometido.setValue(true);
					this.Cmp.momento_comprometido.disable();
				}
				if (record.data.momento_comprometido == 'no_permitido') {
					this.Cmp.momento_comprometido.setValue(false);
					this.Cmp.momento_comprometido.disable();
				}



				//ejecutado
				if (record.data.momento_ejecutado == 'opcional') {
					this.Cmp.momento_ejecutado.enable();
				}
				if (record.data.momento_ejecutado == 'obligatorio') {
					this.Cmp.momento_ejecutado.setValue(true);
					this.Cmp.momento_ejecutado.disable();
				}
				if (record.data.momento_ejecutado == 'no_permitido') {
					this.Cmp.momento_ejecutado.setValue(false);
					this.Cmp.momento_ejecutado.disable();
				}
				//pagado
				if (record.data.momento_pagado == 'opcional') {
					this.Cmp.momento_pagado.enable();
				}
				if (record.data.momento_pagado == 'obligatorio') {
					this.Cmp.momento_pagado.setValue(true);
					this.Cmp.momento_pagado.disable();
				}
				if (record.data.momento_pagado == 'no_permitido') {
					this.Cmp.momento_pagado.setValue(false);
					this.Cmp.momento_pagado.disable();
				}

			}

			//si es presupeustario acomoda los valores por defecto a los momentos

		},
		imprimirCbte : function() {
			var rec = this.sm.getSelected();
			var data = rec.data;
			if (data) {
				Phx.CP.loadingShow();
				Ext.Ajax.request({
					url : '../../sis_contabilidad/control/IntComprobante/reporteCbte',
					params : {
						'id_proceso_wf' : data.id_proceso_wf
					},
					success : this.successExport,
					failure : this.conexionFailure,
					timeout : this.timeout,
					scope : this
				});
			}

		},
		loadDocCmpVnt : function() {
			var rec = this.sm.getSelected();
			Phx.CP.loadWindows('../../../sis_contabilidad/vista/doc_compra_venta/DocCompraVentaCbte.php', 'Documentos del Cbte', {
				width : '80%',
				height : '80%'
			}, rec.data, this.idContenedor, 'DocCompraVentaCbte');
		},

		loadRelDev : function() {
			var rec = this.sm.getSelected();
			Phx.CP.loadWindows('../../../sis_contabilidad/vista/int_rel_devengado/IntRelDevengado.php', 'Documentos del Cbte', {
				width : '80%',
				height : '80%'
			}, rec.data, this.idContenedor, 'IntRelDevengado');
		},
	  
	 addBotonesGantt: function() {
        this.menuAdqGantt = new Ext.Toolbar.SplitButton({
            id: 'b-diagrama_gantt-' + this.idContenedor,
            text: 'Gantt',
            disabled: true,
            grupo:[0,1,2,3],
            iconCls : 'bgantt',
            handler:this.diagramGanttDinamico,
            scope: this,
            menu:{
            items: [{
                id:'b-gantti-' + this.idContenedor,
                text: 'Gantt Imagen',
                tooltip: '<b>Mues un reporte gantt en formato de imagen</b>',
                handler:this.diagramGantt,
                scope: this
            }, {
                id:'b-ganttd-' + this.idContenedor,
                text: 'Gantt Dinámico',
                tooltip: '<b>Muestra el reporte gantt facil de entender</b>',
                handler:this.diagramGanttDinamico,
                scope: this
            }
        ]}
        });
		this.tbar.add(this.menuAdqGantt);
    },
    
    loadCheckDocumentosWf:function() {
            var rec=this.sm.getSelected();
            rec.data.nombreVista = this.nombreVista;
            Phx.CP.loadWindows('../../../sis_workflow/vista/documento_wf/DocumentoWf.php',
                    'Documentos del Proceso',
                    {
                        width:'90%',
                        height:500
                    },
                    rec.data,
                    this.idContenedor,
                    'DocumentoWf'
        )
    },
    
    onOpenObs:function() {
            var rec=this.sm.getSelected();
            
            var data = {
            	id_proceso_wf: rec.data.id_proceso_wf,
            	id_estado_wf: rec.data.id_estado_wf,
            	num_tramite: rec.data.num_tramite
            }
            
            Phx.CP.loadWindows('../../../sis_workflow/vista/obs/Obs.php',
                    'Observaciones del WF',
                    {
                        width:'80%',
                        height:'70%'
                    },
                    data,
                    this.idContenedor,
                    'Obs'
        )
    },
    
    diagramGantt: function (){			
			var data=this.sm.getSelected().data.id_proceso_wf;
			Phx.CP.loadingShow();
			Ext.Ajax.request({
				url:'../../sis_workflow/control/ProcesoWf/diagramaGanttTramite',
				params:{'id_proceso_wf':data},
				success: this.successExport,
				failure: this.conexionFailure,
				timeout: this.timeout,
				scope: this
			});			
	},
	diagramGanttDinamico: function (){			
			var data=this.sm.getSelected().data.id_proceso_wf;
			window.open('../../../sis_workflow/reportes/gantt/gantt_dinamico.html?id_proceso_wf='+data)		
	}, 
	
	sigEstado:function(){                   
      	var rec=this.sm.getSelected();      	
      	this.mostrarWizard(rec, true);
      	
               
     },
     
    mostrarWizard : function(rec, validar_doc) {
     	var configExtra = [],
     		obsValorInicial;
     	   
		this.objWizard = Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/FormEstadoWf.php',
                                'Estado de Wf',
                                {
                                    modal: true,
                                    width: 700,
                                    height: 450
                                }, 
                                {
                                	configExtra: configExtra,
                                	eventosExtra: this.eventosExtra,
                                	data:{
                                       id_estado_wf: rec.data.id_estado_wf,
                                       id_proceso_wf: rec.data.id_proceso_wf,
                                       id_int_comprobante: rec.data.id_int_comprobante,
                                       fecha_ini: rec.data.fecha
                                   },
                                   obsValorInicial: obsValorInicial,
                                }, this.idContenedor, 'FormEstadoWf',
                                {
                                    config:[{
                                              event:'beforesave',
                                              delegate: this.onSaveWizard,
                                              
                                            },
					                        {
					                          event:'requirefields',
					                          delegate: function () {
						                          	this.onButtonEdit();
										        	this.window.setTitle('Registre los campos antes de pasar al siguiente estado');
										        	this.formulario_wizard = 'si';
					                          }
					                          
					                        }],
                                  
                                    scope:this
                        });        
     },
    onSaveWizard:function(wizard,resp){
        this.mandarDatosWizard(wizard, resp, true);
    },
    mandarDatosWizard:function(wizard,resp, validar_doc){
        Phx.CP.loadingShow();
        Ext.Ajax.request({
            url:'../../sis_contabilidad/control/IntComprobante/siguienteEstado',
            params:{
            	    id_int_comprobante: wizard.data.id_int_comprobante,
            	    id_proceso_wf_act:  resp.id_proceso_wf_act,
	                id_estado_wf_act:   resp.id_estado_wf_act,
	                id_tipo_estado:     resp.id_tipo_estado,
	                id_funcionario_wf:  resp.id_funcionario_wf,
	                id_depto_wf:        resp.id_depto_wf,
	                obs:                resp.obs,
	                instruc_rpc:		resp.instruc_rpc,
	                json_procesos:      Ext.util.JSON.encode(resp.procesos),
	                validar_doc:		validar_doc
	                
                },
            success: this.successWizard,
            failure: this.conexionFailure, 
            argument: { wizard:wizard , id_proceso_wf : resp.id_proceso_wf_act, resp : resp},
            timeout: this.timeout,
            scope: this
        });
        
        
        
    },
    successWizard: function(resp){
		var rec=this.sm.getSelected();
        Phx.CP.loadingHide();
       
        var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));

        if(reg.ROOT.datos.operacion == 'falla'){

			
				reg.ROOT.datos.desc_falla
				if (confirm(reg.ROOT.datos.desc_falla + "\n¿Desea continuar de todas formas?")) {
					this.mandarDatosWizard(resp.argument.wizard, resp.argument.resp, false);
				}
				else {
					resp.argument.wizard.panel.destroy()
					this.reload();
				}
			
        }
        else{
	        resp.argument.wizard.panel.destroy()
	        this.reload();
	        
	        if (resp.argument.id_proceso_wf) {
					Phx.CP.loadingShow();
					Ext.Ajax.request({
						url : '../../sis_contabilidad/control/IntComprobante/reporteCbte',
						params : {
							'id_proceso_wf' : resp.argument.id_proceso_wf
						},
						success : this.successExport,
						failure : this.conexionFailure,
						timeout : this.timeout,
						scope : this
					});
				}	
        }
        
        
        
        
    },
    addBotonesPresupuesto: function() {
    	
        this.menuPre = new Ext.Toolbar.SplitButton({
            id: 'b-chkpresupuesto-' + this.idContenedor,
            text: 'Presupuestos.',
            grupo:[0,1,2],
            disabled: true,
            iconCls : 'blist',
            handler:this.checkPresupuesto,
            scope: this,
            menu:{
            items: [{
                id:'btn-chkpresupuesto-' + this.idContenedor,
                text: 'Revisar Presupuesto Comprometido/Ejecutado',
                tooltip: '<b>Revisar Presupuesto</b><p>Revisar estado de ejecución presupeustaria para el tramite</p>',
                handler:this.checkPresupuesto,               
                scope: this
            }, {
                id:'b-btnRepOC-' + this.idContenedor,
                text: 'Verificar presupuesto disponible (Formulado)',
                tooltip: '<b>Reporte de Pre-orden de Compra</b>',
                handler:this.checkVerPresupuesto,
                scope: this
            }
        ]}});
		this.tbar.add(this.menuPre);
    },
    
     checkPresupuesto:function(){                   
			  var rec=this.sm.getSelected();
			  var configExtra = [];
			  this.objChkPres = Phx.CP.loadWindows('../../../sis_presupuestos/vista/presup_partida/ChkPresupuesto.php',
										'Estado del Presupuesto',
										{
											modal:true,
											width:700,
											height:450
										}, {
											data:{
											   nro_tramite: rec.data.nro_tramite								  
											}}, this.idContenedor,'ChkPresupuesto');
			   
	 },
	 
	  checkVerPresupuesto:function(){                   
			  var rec=this.sm.getSelected();
			  var configExtra = [];
			  this.objChkPres = Phx.CP.loadWindows('../../../sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php',
										'Verificación de disponibilidad del Presupuesto',
										{
											modal: true,
											width: 700,
											height: 450
										}, {
											  tabla_id: rec.data.id_int_comprobante,
											  tabla: 'conta.tint_comprobante'								  
											}, this.idContenedor,'VerificacionPresup');
											
											
										
			   
	 },
	 
	 checkDependencias: function(){                   
			  var rec=this.sm.getSelected();
			  var configExtra = [];
			  this.objChkPres = Phx.CP.loadWindows('../../../sis_contabilidad/vista/int_comprobante/CbteDependencias.php',
										'Dependencias',
										{
											modal:true,
											width: '80%',
											height: '80%'
										}, 
										  rec.data, 
										  this.idContenedor,
										 'CbteDependencias');			   
	},
    
    

	onButtonAIRBP : function() {
		var rec=this.sm.getSelected();
		Phx.CP.loadWindows('../../../sis_contabilidad/vista/archivo_airbp/FormArchivoAIRBP.php',
		'Subir Archivo AIRBP',
		{
			modal:true,
			width:450,
			height:200
		},rec.data,this.idContenedor,'FormArchivoAIRBP')
	}
})
</script>

