<?php
/*
#75 		28/11/2019		  Manuel Guerra	  controlling
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Rango=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
    	this.initButtons = [this.cmbCategoria];
		Phx.vista.Rango.superclass.constructor.call(this,config);
		this.init();
        this.grid.addListener('cellclick', this.oncellclick,this);        
		//
		this.cmbCategoria.on('select', function(){
    		if(this.validarFiltros()){
          		this.capturaFiltros();
   			}
		},this);
		//
		this.addButton('btntcc',{
			text: 'Reporte',
			iconCls: 'bexcel',
			disabled: false,
			handler: this.reporteArbol,
			tooltip: '<b>Reporte TCC</b>'
		});
		//
        this.addButton('btnPentaho',{
            text: 'Pentaho',
            iconCls: 'bexcel',
            disabled: false,
            handler: this.reportePentaho,
            tooltip: '<b>Pentaho</b>'
        });
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_rango'
			},
			type:'Field',
			form:false 
		},
		{
			config:{
				name: 'detalle',
				fieldLabel: 'Mayor',
				gwidth: 25, 
				renderer:function (value,p,record){  
					if(record.data.tipo_reg != 'summary'){
					    return  String.format("<div style='text-align:center'><img title='Revisar Mayor' src = '../../../lib/imagenes/connect.png' align='center'/></div>");
				     }
				}
			},
			type:'Field',
			grid:true
		},
		{
			config:{
				name: 'orden',
				fieldLabel: 'O',
				gwidth: 25, 
				renderer:function (value,p,record){  
					if(record.data.tipo_reg != 'summary'){
					    return  String.format("<div style='text-align:center'><img title='Revisar Ordenes' src = '../../../lib/imagenes/connect.png' align='center'/></div>");
				     }
				}
			},
			type:'Field',
			grid:true
		},
		{
			config:{
				name: 'partida',
				fieldLabel: 'P',
				gwidth: 25, 
				renderer:function (value,p,record){  
					if(record.data.tipo_reg != 'summary'){
					    return  String.format("<div style='text-align:center'><img title='Revisar Partidas' src = '../../../lib/imagenes/connect.png' align='center'/></div>");
				     }
				}
			},
			type:'Field',
			grid:true
		},
		{
			config:{
				name: 'cuenta',
				fieldLabel: 'C',
				gwidth: 25, 
				renderer:function (value,p,record){  
					if(record.data.tipo_reg != 'summary'){
					    return  String.format("<div style='text-align:center'><img title='Revisar Cuentas' src = '../../../lib/imagenes/connect.png' align='center'/></div>");
				     }
				}
			},
			type:'Field',
			grid:true
		},
		{
			config:{
				name: 'ejecucion',
				fieldLabel: 'E',
				gwidth: 25, 
				renderer:function (value,p,record){  
					if(record.data.tipo_reg != 'summary'){
					    return  String.format("<div style='text-align:center'><img title='Revisar Cuentas' src = '../../../lib/imagenes/connect.png' align='center'/></div>");
				     }
				}
			},
			type:'Field',
			grid:true
		},
		
		{
			config:{
				name: 'periodo',
				fieldLabel: 'Periodo',
				gwidth: 70, 
				renderer:function (value,p,record){  
					if(record.data.tipo_reg != 'summary'){
							return  String.format("{0} / {1}",record.data.periodo,record.data.gestion);
					}
					
				}
			},
			type:'TextField',
			filters:{pfiltro:'per.periodo',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},		
		{
			config:{
				name: 'formulado',
				fieldLabel: 'Formulado MB',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
						}
						else{
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
						}
					}
			},
				type:'NumberField',
				filters:{pfiltro:'ran.formulado',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'comprometido',
				fieldLabel: 'Comprometido MB',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
						}
						else{
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
						}
					}
			},
				type:'NumberField',
				filters:{pfiltro:'ran.comprometido',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'ejecutado',
				fieldLabel: 'Ejecutado MB',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
						}
						else{
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
						}
					}
			},
				type:'NumberField',
				filters:{pfiltro:'ran.ejecutado',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:false
		},		
		{
			config:{
				name: 'disponible_mb',
				fieldLabel: 'Disponible MB',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
						}
						else{
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
						}
					}
			},
				type:'NumberField',
				filters:{pfiltro:'ran.disponible_mb',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'balance_mb',
				fieldLabel: 'Balance MB',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
						}
						else{
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
						}
					}
			},
				type:'NumberField',
				filters:{pfiltro:'ran.balance_mb',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'debe_mb',
				fieldLabel: 'Debe MB',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
						}
						else{
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
						}
					}
			},
				type:'NumberField',
				filters:{pfiltro:'ran.debe_mb',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'haber_mb',
				fieldLabel: 'Haber MB',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
						}
						else{
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
						}
					}
			},
				type:'NumberField',
				filters:{pfiltro:'ran.haber_mb',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:false
		},
		
		{
			config:{
				name: 'debe_mt',
				fieldLabel: 'Debe MT',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
						}
						else{
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
						}
					}
			},
				type:'NumberField',
				filters:{pfiltro:'ran.debe_mt',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'haber_mt',
				fieldLabel: 'Haber MT',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				renderer:function (value,p,record){
                    if(record.data.tipo_reg != 'summary'){
                        return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
                    }
                    else{
                        return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
                    }
                }
			},
				type:'NumberField',
				filters:{pfiltro:'ran.haber_mt',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'memoria',
				fieldLabel: 'Memoria MB',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
						}
						else{
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
						}
					}
			},
				type:'NumberField',
				filters:{pfiltro:'ran.memoria',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Rangos de Costo',
	ActList:'../../sis_contabilidad/control/Rango/listarRango',
	id_store:'id_rango',
	fields: [
		{name:'id_rango', type: 'numeric'},
		{name:'id_periodo', type: 'numeric'},
		{name:'haber_mb', type: 'numeric'},
		{name:'debe_mb', type: 'numeric'},
		{name:'debe_mt', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_tipo_cc', type: 'numeric'},
		{name:'haber_mt', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'fecha_ini', type: 'date',dateFormat:'Y-m-d'},
		{name:'fecha_fin', type: 'date',dateFormat:'Y-m-d'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'periodo','gestion','tipo_reg','desc_tipo_cc',
		'memoria','formulado','comprometido','ejecutado','balance_mb','disponible_mb','id_gestion'
		
		
	],
	sortInfo:{
		field: 'id_periodo',
		direction: 'ASC'
	},
	bdel:false,
	bnew:false,
	bedit:false,
	bsave:false,

	onReloadPage:function(m,a,b){		
		this.maestro = m;			
		var padre = Phx.CP.getPagina(this.idContenedorPadre);
		var desde = padre.campo_fecha_desde.getValue(),
			hasta = padre.campo_fecha_hasta.getValue();		
									
		this.store.baseParams = {id_tipo_cc: this.maestro.id_tipo_cc,categoria:this.cmbCategoria.getValue()}
		if(desde && hasta){
		    this.store.baseParams=Ext.apply(this.store.baseParams,{ desde: desde.dateFormat('d/m/Y'), 
												                    hasta: hasta.dateFormat('d/m/Y')});
		}			   	                    
		this.load({ params: { start: 0, limit: 100}});		
	},
	oncellclick : function(grid, rowIndex, columnIndex, e) {
		
	    var record = this.store.getAt(rowIndex),
	        fieldName = grid.getColumnModel().getDataIndex(columnIndex); // Get field name

	    if (fieldName == 'detalle') {
	    	Phx.CP.loadWindows('../../../sis_contabilidad/vista/int_transaccion/FormFiltroArbol.php',
                'Mayor',
                {
                    width:'100%',
                    height:'100%',
                },
                {
                    maestro:record.data,
                    detalle: {
                        'tipo_filtro': 'fechas',
                        'desde': record.data.fecha_ini,
                        'hasta': record.data.fecha_fin,
                        'id_tipo_cc': record.data.id_tipo_cc,
                        'desc_tipo_cc': record.data.desc_tipo_cc,
                        'id_gestion': record.data.id_gestion,
                        'id_gestion1': record.data.id_gestion,
                        'id_periodo': record.data.id_periodo,
                        'cbte_cierre':'no',
                        'balance_mb': record.data.balance_mb,
                        'memoria': record.data.memoria,
                        'formulado': record.data.formulado,
                        'comprometido': record.data.comprometido,
                        'ejecutado': record.data.ejecutado
                    }
                },
                this.idContenedor,
                'FormFiltroArbol'
           );	    
	    }
	    
	    if (fieldName == 'orden') {
	    	Phx.CP.loadWindows('../../../sis_contabilidad/vista/rango/RangoOt.php',
                'Mayor',
                {
                    width:'100%',
                    height:'100%',
                },
                {
                    maestro:record.data,
                    detalle:
                    {
                        'tipo_filtro': 'fechas',
                        'fecha_ini': record.data.fecha_ini,
                        'fecha_fin': record.data.fecha_fin,
                        'id_tipo_cc': record.data.id_tipo_cc,
                        'desc_tipo_cc': record.data.desc_tipo_cc,
                        'id_gestion': record.data.id_gestion,
                    }
                },
                this.idContenedor,
                'RangoOt'
            );
	    }
	    
	    if (fieldName == 'partida') {
	    	Phx.CP.loadWindows('../../../sis_contabilidad/vista/rango/RangoPartida.php',
                'Mayor Partida',
                {
                    width:'100%',
                    height:'100%',
                },
                {
                    maestro:record.data,
                    detalle: {
                        'tipo_filtro': 'fechas',
                        'fecha_ini': record.data.fecha_ini,
                        'fecha_fin': record.data.fecha_fin,
                        'id_tipo_cc': record.data.id_tipo_cc,
                        'desc_tipo_cc': record.data.desc_tipo_cc,
                        'id_gestion': record.data.id_gestion,
                        'gestion': record.data.gestion
                    }
                },
                this.idContenedor,
                'RangoPartida'
           );	    	
	    }
	    
	    if (fieldName == 'cuenta') {
	    	Phx.CP.loadWindows('../../../sis_contabilidad/vista/rango/RangoCuenta.php',
                'Mayor Partida',
                {
                    width:'100%',
                    height:'100%',
                },
                {
                    maestro:record.data,
                    detalle:
                    {
                        'tipo_filtro': 'fechas',
                        'fecha_ini': record.data.fecha_ini,
                        'fecha_fin': record.data.fecha_fin,
                        'id_tipo_cc': record.data.id_tipo_cc,
                        'desc_tipo_cc': record.data.desc_tipo_cc,
                        'id_gestion': record.data.id_gestion,
                        'gestion': record.data.gestion
                    }
                },
                this.idContenedor,
                'RangoCuenta'
            );
	    }
	    
	     if (fieldName == 'ejecucion') {
	    	Phx.CP.loadWindows('../../../sis_presupuestos/vista/partida_ejecucion/FormFiltro.php',
                'Mayor Partida',
                {
                    width:'100%',
                    height:'100%',
                },
                {
                    maestro:record.data,
                    detalle: {
                        'desde': record.data.fecha_ini,
                        'hasta': record.data.fecha_fin,
                        'momento': 'ejecutado',
                        'id_tipo_cc': record.data.id_tipo_cc,
                        'desc_tipo_cc': record.data.desc_tipo_cc,
                        'id_gestion': record.data.id_gestion,
                        'gestion': record.data.gestion
                    }
                },
                this.idContenedor,
                'FormFiltro'
            );
	     }
	},
	//
	cmbCategoria:new Ext.form.ComboBox({
		name:'categoria',
		fieldLabel:'Tipo',
		allowBlank:false,
		emptyText:'Categoria...',
		typeAhead: true,
		triggerAction: 'all',	
		lazyRender:true,
		value:'gestion',
		mode: 'local',
		width: 70,
		store:['gestion','periodo']
	}),
	//
	onButtonAct : function() {
		if (!this.validarFiltros()) {
			alert('Especifique los filtros antes')
		}
		else{
		    this.capturaFiltros();
		}
	},
	//	
	capturaFiltros:function(combo, record, index){				
		this.store.baseParams.categoria = this.cmbCategoria.getValue();
		this.load();
	},	
	//
	validarFiltros:function(){
	    if(this.cmbCategoria.isValid()){
	        return true;
	    }
	    else{
	        return false;
	    }  
	},
	//
	reporteArbol:function(){
		var aux=this.maestro.id_tipo_cc;
        Phx.CP.loadingShow();
		Ext.Ajax.request({
			//url:'../../sis_contabilidad/control/Rango/ReporteTcc',
            //url:'../../sis_contabilidad/control/IntTransaccion/reporteProyecto',
            url:'../../sis_contabilidad/control/Rango/reporteProyecto',
			params:
			{
                'id_gestion':3,
                'desde':this.maestro.fecha_inicio,
                'hasta':this.maestro.fecha_final,
                'id_cuenta':'',
                'id_tipo_cc':this.maestro.id_tipo_cc,
                'id_centro_costo':'',
                'cbte_cierre':'no',
                'tipo_moneda':'MB',
                "id_gestions":"2019",
                "moneda":"Moneda Base",
                "tipo_costo":this.maestro.codigo,
                "cuenta":"",
                "centro_costo":""

			},
			success: this.successExport,
			failure: this.conexionFailure,
			timeout:this.timeout,
			scope:this
		});

	},
    //#75
    reportePentaho:function(){
        alert('en construccion');
    },
})
</script>	