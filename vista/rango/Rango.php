<?php
/**
*@package pXP
*@file gen-Rango.php
*@author  (admin)
*@date 22-06-2017 21:30:05
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Rango=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.Rango.superclass.constructor.call(this,config);
		this.init();
		//this.grid.addListener('celldblclick', this.oncelldblclick, this);
        this.grid.addListener('cellclick', this.oncellclick,this);
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
				fieldLabel: '',
				gwidth: 25, 
				renderer:function (value,p,record){  
					if(record.data.tipo_reg != 'summary'){
					    return  String.format("<div style='text-align:center'><img title='Revisar detalle' src = '../../../lib/imagenes/connect.png' align='center'/></div>",record.data.periodo,record.data.gestion);
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
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'ran.fecha_reg',type:'date'},
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
				filters:{pfiltro:'ran.fecha_mod',type:'date'},
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
		{name:'usr_mod', type: 'string'},'periodo','gestion','tipo_reg','desc_tipo_cc'
		
	],
	sortInfo:{
		field: 'per.periodo',
		direction: 'ASC'
	},
	bdel:false,
	bnew:false,
	bedit:false,
	bsave:false,
	onReloadPage:function(m,a,b){		
		this.maestro = m;
		
		console.log('this.idContenedorPadre',this.idContenedorPadre)
		
		var padre = Phx.CP.getPagina(this.idContenedorPadre);
		var desde = padre.campo_fecha_desde.getValue(),
			hasta = padre.campo_fecha_hasta.getValue();
			
			console.log('pagina...',padre)
			
			
			
		this.store.baseParams = {id_tipo_cc: this.maestro.id_tipo_cc}
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
	    	Phx.CP.loadWindows('../../../sis_contabilidad/vista/int_transaccion/FormFiltro.php',
                    'Mayor',
                    {
                        width:'100%',
                        height:'100%',
                    },
                    { maestro:record.data,
                      detalle: {
                      	        'tipo_filtro': 'fechas',
                      	        'desde': record.data.fecha_ini,
                      	        'hasta': record.data.fecha_fin,
                      	        'id_tipo_cc': record.data.id_tipo_cc,
                      	        'desc_tipo_cc': record.data.desc_tipo_cc
                      	      }
                      
                     },
                    this.idContenedor,
                    'FormFiltro'
           );
	    	
	    }
		
	}
	
	
})
</script>	