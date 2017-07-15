<?php
/**
*@package pXP
*@file gen-IntTransaccionMayor.php
*@author  (admin)
*@date 01-09-2013 18:10:12
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.IntTransaccionMayor=Ext.extend(Phx.gridInterfaz,{
    title:'Mayor',
	constructor:function(config){		
		var me = this;
		this.maestro=config.maestro;
		 //Agrega combo de moneda
		
		this.Atributos = [
			{
				//configuracion del componente
				config:{
						labelSeparator:'',
						inputType:'hidden',
						name: 'id_int_transaccion'
				},
				type:'Field',
				form:true 
			},
			{
				//configuracion del componente
				config:{
						labelSeparator:'',
						inputType:'hidden',
						name: 'id_int_comprobante'
				},
				type:'Field',
				form:true 
			},
			{
	   			config:{
	   				sysorigen:'sis_contabilidad',
	       		    name:'id_cuenta',
	   				origen:'CUENTA',
	   				allowBlank:false,
	   				fieldLabel:'Cuenta',
	   				gdisplayField:'desc_cuenta',//mapea al store del grid
	   				gwidth:500,
	   				width: 350,
	   				listWidth: 350,
	   				scope: this,
		   			renderer:function (value, p, record){
		   			    var color = 'green';
		   			    if(record.data["tipo_reg"] != 'summary'){
			   			    if(record.data["tipo_partida"] == 'flujo'){
			   			        color = 'red';
			   			    }
			   			    
			   					
			   				var retorno =  String.format('<b>CC:</b> {0}, <br><b>Ptda.:</b> <font color="{1}">{2}</font><br><b>Cta.:</b>{3}<br><b>Aux.:</b>{4}',record.data['desc_centro_costo'],color, record.data['desc_partida'],
			   					                   record.data['desc_cuenta'],record.data['desc_auxiliar']);	
			   					
				   				
				   				if(record.data['desc_orden']){
				   					retorno = retorno + '<br><b>Ord.:</b> '+record.data['desc_orden'];
				   				}
				   				if(record.data['desc_suborden']){
				   					retorno = retorno + '<br><b>Sub.:</b> '+record.data['desc_suborden'];
				   				}	
			   				return retorno;	
		   			    	
		   			    }
		   			    else{
		   			    	//cargar resumen en el panel
		   			    	var debe = record.data["importe_debe_mb"]?record.data["importe_debe_mb"]:0,
		   			    		haber = record.data["importe_haber_mb"]?record.data["importe_haber_mb"]:0,
		   			    		sum_debe, sum_haber;
		   			    	
		   			    	if ((debe - haber ) > 0) {
		   			    		sum_debe = debe - haber;
		   			    		sum_haber = '';
		   			    	}
		   			    	else{
		   			    		sum_debe = '';
		   			    		sum_haber = haber - debe;
		   			    	}
		   			    	Ext.util.Format.number(value,'0,000.00')
		   			    	
		   			    	var html = String.format("<table style='width:70%; border-collapse:collapse;'> \
		   			    							  <tr>\
													    <td >Debe </td>\
													    <td >Haber</td> \
													  </tr>\
		   			    	                          <tr>\
													    <td style='padding: 10px; border-top:  solid #000000; border-right:  solid #000000;'>{0} </td>\
													    <td style='padding: 10px; border-top:  solid #000000;'>{1}</td> \
													  </tr>\
													  <tr>\
													    <td style='padding: 10px; border-right: solid #000000;'>{2}</td>\
													    <td style='padding: 10px;' >{3}</td>\
													  </tr><table>" ,Ext.util.Format.number(debe,'0,000.00'), 
													  				 Ext.util.Format.number(haber,'0,000.00'), 
													  				 Ext.util.Format.number(sum_debe,'0,000.00'),
													  				 Ext.util.Format.number(sum_haber,'0,000.00'));
		   			    	
		   			    	//var html = String.format('<p>DEBE: {0} <br> HABER: {1} </br> SALDO: {2}</p>' ,debe, haber, debe - haber);
		   			    	
		   			    	Phx.CP.getPagina(me.idContenedorPadre).panelResumen.update(html)
		   			    	return '<b><p align="right">Total: &nbsp;&nbsp; </p></b>';
		   			    }
		   			    
		   			}
	       	     },
	   			type:'ComboRec',
	   			id_grupo:0,
	   			filters:{	
			        pfiltro:'cue.nombre_cuenta#cue.nro_cuenta#cc.codigo_cc#cue.nro_cuenta#cue.nombre_cuenta#aux.codigo_auxiliar#aux.nombre_auxiliar#par.codigo#par.nombre_partida#ot.desc_orden',
					type:'string'
				},
	   			grid:true,
	   			form:true
		   	},
		   	{
	   			config:{
	   				sysorigen:'sis_contabilidad',
	       		    name:'id_auxiliar',
	   				origen:'AUXILIAR',
	   				allowBlank:true,
	   				fieldLabel:'Auxiliar',
	   				gdisplayField:'desc_auxiliar',//mapea al store del grid
	   				gwidth:200,
	   				width: 350,
	   				listWidth: 350,
	   				//anchor: '80%',
		   			renderer:function (value, p, record){return String.format('{0}', record.data['desc_auxiliar']);}
	       	     },
	   			type:'ComboRec',
	   			id_grupo:0,
	   			filters:{	
			        pfiltro:'au.codigo_auxiliar#au.nombre_auxiliar',
					type:'string'
				},
	   		   
	   			grid:false,
	   			form:true
		   	},
		   	{
	   			config:{
	   				sysorigen:'sis_presupuestos',
	       		    name:'id_partida',
	   				origen:'PARTIDA',
	   				allowBlank:false,
	   				fieldLabel:'Partida',
	   				gdisplayField:'desc_partida',//mapea al store del grid
	   				gwidth:200,
	   				width: 350,
	   				listWidth: 350,
		   			renderer:function (value, p, record){return String.format('{0}',record.data['desc_partida']);}
	       	     },
	   			type:'ComboRec',
	   			id_grupo:0,
	   			filters:{	
			        pfiltro: 'par.codigo_partida#au.nombre_partida',
					type: 'string'
				},
	   		   
	   			grid:false,
	   			form:true
		   	},
		   	{
	            config:{
	                name: 'id_centro_costo',
	                fieldLabel: 'Centro Costo',
	                allowBlank: false,
	                tinit:false,
	                origen:'CENTROCOSTO',
	                gdisplayField: 'desc_centro_costo',
	                width: 350,
	   				listWidth: 350,
	                gwidth: 300,
	                renderer:function (value, p, record){return String.format('{0}',record.data['desc_centro_costo']);}
	            },
	            type:'ComboRec',
	            filters:{pfiltro:'cc.codigo_cc',type:'string'},
	            id_grupo:1,
	            grid:false,
	            form:true
	        },
	        {
	            config:{
	                    name:'id_orden_trabajo',
	                    fieldLabel: 'Orden Trabajo',
	                    sysorigen:'sis_contabilidad',
		       		    origen:'OT',
	                    allowBlank:true,
	                    gwidth:200,
	                    width: 350,
	   				    listWidth: 350,
	                    renderer:function(value, p, record){return String.format('{0}', record.data['desc_orden']);}
	            
	            },
	            type:'ComboRec',
	            id_grupo:0,
	            filters:{pfiltro:'ot.motivo_orden#ot.desc_orden',type:'string'},
	            grid:false,
	            form:true
	        },
			{
				config: {
					name: 'importe_debe_mb',
					fieldLabel: 'Debe MB',
					allowBlank: true,
					width: '100%',
					gwidth: 110,
					galign: 'right ',
					maxLength: 100,
					renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
						}
						else{
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
						}
					}
				},
				type: 'NumberField',
				filters: {pfiltro: 'transa.importe_debe_mb',type: 'numeric'},
				id_grupo: 1,
				grid: true,
				form: true
			},
			{
				config: {
					name: 'importe_haber_mb',
					fieldLabel: 'Haber MB',
					allowBlank: true,
					width: '100%',
					gwidth: 110,
					galign: 'right ',
					maxLength: 100,
					renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
						}
						else{
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
						}
					}
				},
				type: 'NumberField',
				filters: {pfiltro: 'transa.importe_haber_mb',type: 'numeric'},
				id_grupo: 1,
				grid: true,
				form: true
			},
			
			{
				config: {
					name: 'importe_debe_mt',
					fieldLabel: 'Debe MT',
					allowBlank: true,
					width: '100%',
					gwidth: 110,
					galign: 'right ',
					maxLength: 100,
					renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
						}
						else{
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
						}
					}
				},
				type: 'NumberField',
				filters: {pfiltro: 'transa.importe_debe_mt',type: 'numeric'},
				id_grupo: 1,
				grid: true,
				form: true
			},
			{
				config: {
					name: 'importe_haber_mt',
					fieldLabel: 'Haber MT',
					allowBlank: true,
					width: '100%',
					gwidth: 110,
					galign: 'right ',
					maxLength: 100,
					renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
						}
						else{
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
						}
					}
				},
				type: 'NumberField',
				filters: {pfiltro: 'transa.importe_haber_mt',type: 'numeric'},
				id_grupo: 1,
				grid: true,
				form: true
			},
			
			{
				config:{
					name: 'glosa',
					fieldLabel: 'Glosa',
					allowBlank: true,
					anchor: '80%',
					gwidth: 300,
					maxLength:1000
				},
				type:'TextArea',
				filters:{pfiltro:'transa.glosa',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
			},
			
			
			{
				config:{
					name: 'estado_reg',
					fieldLabel: 'Estado Reg.',
					allowBlank: true,
					anchor: '80%',
					gwidth: 100,
					maxLength:10
				},
				type:'Field',
				filters:{pfiltro:'transa.estado_reg',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
			},
			
			{
				config:{
					name: 'usr_reg',
					fieldLabel: 'Creado por',
					allowBlank: true,
					anchor: '80%',
					gwidth: 100,
					maxLength:4
				},
				type:'Field',
				filters:{pfiltro:'usu1.cuenta',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
			},
			{
				config:{
					name: 'fecha_reg',
					fieldLabel: 'Fecha creación',
					allowBlank: true,
					anchor: '80%',
					gwidth: 100,
								format: 'd/m/Y', 
								renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
				},
				type:'DateField',
				filters:{pfiltro:'transa.fecha_reg',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
			},
			{
				config:{
					name: 'usr_mod',
					fieldLabel: 'Modificado por',
					allowBlank: true,
					anchor: '80%',
					gwidth: 100,
					maxLength:4
				},
				type:'Field',
				filters:{pfiltro:'usu2.cuenta',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
			},
			{
				config:{
					name: 'fecha_mod',
					fieldLabel: 'Fecha Modif.',
					allowBlank: true,
					anchor: '80%',
					gwidth: 100,
								format: 'd/m/Y', 
								renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
				},
				type:'DateField',
				filters:{pfiltro:'transa.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
			}
		];
			
		
		
    	//llama al constructor de la clase padre
		Phx.vista.IntTransaccionMayor.superclass.constructor.call(this,config);
		
		this.addButton('chkdep',{	text:'Dependencias',
				iconCls: 'blist',
				disabled: true,
				handler: this.checkDependencias,
				tooltip: '<b>Revisar Dependencias </b><p>Revisar dependencias del comprobante</p>'
			});
			
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
	      
	      this.addButton('chkpresupuesto',{text:'Chk Presupuesto',
				iconCls: 'blist',
				disabled: true,
				handler: this.checkPresupuesto,
				tooltip: '<b>Revisar Presupuesto</b><p>Revisar estado de ejecución presupeustaria para el tramite</p>'
			});
			
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
			
			
		this.grid.getTopToolbar().disable();
		this.grid.getBottomToolbar().disable();
		this.init();
		
	},
	
	
	tam_pag: 50,	
	
	ActList: '../../sis_contabilidad/control/IntTransaccion/listarIntTransaccionMayor',
	id_store: 'id_int_transaccion',
	fields: [
		{ name:'id_int_transaccion', type: 'numeric'},
		{ name:'id_partida', type: 'numeric'},
		{ name:'id_centro_costo', type: 'numeric'},
		{ name:'id_partida_ejecucion', type: 'numeric'},
		{ name:'estado_reg', type: 'string'},
		{ name:'id_int_transaccion_fk', type: 'numeric'},
		{ name:'id_cuenta', type: 'numeric'},
		{ name:'glosa', type: 'string'},
		{ name:'id_int_comprobante', type: 'numeric'},
		{ name:'id_auxiliar', type: 'numeric'},
		{ name:'id_usuario_reg', type: 'numeric'},
		{ name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{ name:'id_usuario_mod', type: 'numeric'},
		{ name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{ name:'usr_reg', type: 'string'},
		{ name:'usr_mod', type: 'string'},
		{ name:'importe_debe', type: 'numeric'},
		{ name:'importe_haber', type: 'numeric'},
		{ name:'importe_gasto', type: 'numeric'},
		{ name:'importe_recurso', type: 'numeric'},
		{ name:'importe_debe_mb', type: 'numeric'},
		{ name:'importe_haber_mb', type: 'numeric'},
		{ name:'importe_gasto_mb', type: 'numeric'},
		{ name:'importe_recurso_mb', type: 'numeric'},
		
		{ name:'importe_debe_mt', type: 'numeric'},
		{ name:'importe_haber_mt', type: 'numeric'},
		{ name:'importe_gasto_mt', type: 'numeric'},
		{ name:'importe_recurso_mt', type: 'numeric'},
		
		{ name:'desc_cuenta', type: 'string'},
		{ name:'desc_auxiliar', type: 'string'},
		{ name:'desc_partida', type: 'string'},
		{ name:'desc_centro_costo', type: 'string'},
		'tipo_partida','id_orden_trabajo','desc_orden',
		'tipo_reg','nro_cbte','nro_tramite','nombre_corto','fecha','glosa1','id_proceso_wf','id_estado_wf','id_suborden','desc_suborden',
		
	],
	
	
	rowExpander: new Ext.ux.grid.RowExpander({
	        tpl : new Ext.Template(
	            '<br>',	    
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Cbte:&nbsp;&nbsp;</b> {nro_cbte} - {nombre_corto}</p>',	            
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Trámite:&nbsp;&nbsp;</b> {nro_tramite} &nbsp; {fecha:date("d/m/Y")}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Glosa Comprobante :&nbsp;&nbsp;</b> <p>{glosa1}</p></p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Glosa Trasacción:&nbsp;&nbsp;</b> {glosa}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Creado por:&nbsp;&nbsp;</b> {usr_reg}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Estado Registro:&nbsp;&nbsp;</b> {estado_reg}</p><br>'
	        )
    }),
    
    arrayDefaultColumHidden:['fecha_mod','usr_reg','usr_mod','estado_reg','fecha_reg','glosa'],

    sortInfo:{
		field: 'id_int_transaccion',
		direction: 'ASC'
	},
	bdel: true,
	bsave: false,
	loadValoresIniciales:function(){
		Phx.vista.IntTransaccionMayor.superclass.loadValoresIniciales.call(this);
		this.getComponente('id_int_comprobante').setValue(this.maestro.id_int_comprobante);		
	},
	onReloadPage:function(param){
		//Se obtiene la gestión en función de la fecha del comprobante para filtrar partidas, cuentas, etc.
		var me = this;
		this.initFiltro(param);
	},
	
	initFiltro: function(param){
		this.store.baseParams=param;
		this.load( { params: { start:0, limit: this.tam_pag } });
	},
	
	preparaMenu : function(n) {
		var rec=this.sm.getSelected();
		if(rec.data.tipo_reg != 'summary'){
			var tb = Phx.vista.IntTransaccionMayor.superclass.preparaMenu.call(this);
			this.getBoton('chkdep').enable();
			this.getBoton('btnChequeoDocumentosWf').enable();
			this.getBoton('btnImprimir').enable();
			this.getBoton('chkpresupuesto').enable();
			this.getBoton('btnDocCmpVnt').enable();
			
			return tb;
		}
		else{
			 this.getBoton('chkdep').disable();
			 this.getBoton('btnChequeoDocumentosWf').disable();
			 this.getBoton('btnImprimir').disable();
			 this.getBoton('chkpresupuesto').disable();
			 this.getBoton('btnDocCmpVnt').disable();
		 }
			
         return undefined;
	},
	liberaMenu : function() {
			var tb = Phx.vista.IntTransaccionMayor.superclass.liberaMenu.call(this);
			this.getBoton('chkdep').disable();
			this.getBoton('btnChequeoDocumentosWf').disable();
			this.getBoton('btnImprimir').disable();
			this.getBoton('chkpresupuesto').disable();
			this.getBoton('btnDocCmpVnt').disable();
			
			
	},
	
	
	getGestion:function(x){
		if(Ext.isDate(x)){
	        Ext.Ajax.request({ 
	                    url:'../../sis_parametros/control/Gestion/obtenerGestionByFecha',
	                    params:{fecha:x},
	                    success:this.successGestion,
	                    failure: this.conexionFailure,
	                    timeout:this.timeout,
	                    scope:this
	        });
		} else{
			alert('Error al obtener gestión: fecha inválida')
		}
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
										  {id_int_comprobante: rec.data.id_int_comprobante}, 
										  this.idContenedor,
										 'CbteDependencias');
			   
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
											}}, this.idContenedor,'ChkPresupuesto',
										{
											config:[{
													  event:'onclose',
													  delegate: this.onCloseChk												  
													}],
											
											scope:this
										 });
			   
	 },
	successGestion: function(resp){
		var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
        if(!reg.ROOT.error){
            var id_gestion = reg.ROOT.datos.id_gestion;
	        //Setea los stores de partida, cuenta, etc. con la gestion obtenida
			Ext.apply(this.Cmp.id_cuenta.store.baseParams,{id_gestion: id_gestion})
			Ext.apply(this.Cmp.id_partida.store.baseParams,{id_gestion: id_gestion})
			Ext.apply(this.Cmp.id_centro_costo.store.baseParams,{id_gestion: id_gestion})
           
        } else{
            alert('Error al obtener la gestión. Cierre y vuelva a intentarlo')
        } 
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
           );
    },
    
    loadDocCmpVnt : function() {
			var rec = this.sm.getSelected();
			Phx.CP.loadWindows('../../../sis_contabilidad/vista/doc_compra_venta/DocCompraVentaCbte.php', 'Documentos del Cbte', {
				width : '80%',
				height : '80%'
			}, rec.data, this.idContenedor, 'DocCompraVentaCbte');
	},
	
	ExtraColumExportDet:[{ 
		   	    label:'Partida',
				name:'desc_partida',
				width:'200',
				type:'string',
				gdisplayField:'desc_partida',
				value:'desc_partida'
			},
			{ 
		   	    label:'Cbte',
				name:'nro_cbte',
				width:'100',
				type:'string',
				gdisplayField:'nro_cbte',
				value:'nro_cbte'
			}],
	
	
    bnew : false,
    bedit: false,
    bdel:  false
})
</script>
		
		