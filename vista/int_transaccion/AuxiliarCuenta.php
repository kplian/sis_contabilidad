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
var aux=null;
var tes=null;
var ini=null;
var fin=null;
Phx.vista.AuxiliarCuenta = Ext.extend(Phx.gridInterfaz,{
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
						name: 'id_tipo_estado_columna'
				},
				type:'Field',
				form:false 
			},
			
			{
			config:{
				name: 'detalle',
				fieldLabel: 'M',
				gwidth: 25, 
				renderer:function (value,p,record){  
					return  String.format("<div style='text-align:center'><img title='Revisar Mayor' src = '../../../lib/imagenes/connect.png' align='center'/></div>");
				    
				}
			   },
			   type:'Field',
			   grid:true
			},
			
			{
				config:{
					name: 'codigo_auxiliar',
					fieldLabel: 'Código Aux',
					allowBlank: true,
					anchor: '80%',
					gwidth: 100,
					maxLength:1000
				},
				type:'TextArea',
				filters:{pfiltro:'codigo_auxiliar',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
			},
			
			{
				config:{
					name: 'nombre_auxiliar',
					fieldLabel: 'Nom Auxiliar',
					allowBlank: true,
					anchor: '80%',
					gwidth: 300,
					maxLength:1000
				},
				type:'TextArea',
				filters:{pfiltro:'nombre_auxiliar',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
			},
			
				
			{
				config:{
					name: 'nro_cuenta',
					fieldLabel: 'Nro Cuenta',
					allowBlank: true,
					anchor: '80%',
					gwidth: 80,
					maxLength:1000
				},
				type:'TextArea',
				filters:{pfiltro:'nro_cuenta',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
			},
			
			{
				config:{
					name: 'nombre_cuenta',
					fieldLabel: 'Cuenta',
					allowBlank: true,
					anchor: '80%',
					gwidth: 300,
					maxLength:1000
				},
				type:'TextArea',
				filters:{pfiltro:'nombre_cuenta',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
			},
			
			{
				config:{
					name: 'tipo_cuenta',
					fieldLabel: 'Tipo',
					allowBlank: true,
					anchor: '80%',
					gwidth: 80,
					maxLength:1000
				},
				type:'TextArea',
				filters:{pfiltro:'tipo_cuenta',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
			},
			
			{
				config:{
					name: 'desc_sub_tipo_cuenta',
					fieldLabel: 'Subtipo',
					allowBlank: true,
					anchor: '80%',
					gwidth: 300,
					maxLength:1000
				},
				type:'TextArea',
				filters:{pfiltro:'desc_sub_tipo_cuenta',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
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
				filters: {pfiltro: 'importe_debe_mb',type: 'numeric'},
				id_grupo: 1,
				grid: true,
				form: false
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
				filters: {pfiltro: 'importe_haber_mb',type: 'numeric'},
				id_grupo: 1,
				grid: true,
				form: false
			},
			
			{
				config: {
					name: 'saldo',
					fieldLabel: 'Saldo',
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
				filters: {pfiltro: 'saldo',type: 'numeric'},
				id_grupo: 1,
				grid: true,
				form: false
			}
			
		];
			
		//llama al constructor de la clase padre
		Phx.vista.AuxiliarCuenta.superclass.constructor.call(this,config);		
		this.grid.getTopToolbar().disable();
		this.grid.getBottomToolbar().disable();
		this.init();
		this.grid.addListener('cellclick', this.oncellclick,this);		
	},

	tam_pag: 50,	
	ActList: '../../sis_contabilidad/control/IntTransaccion/listarAuxiliarCuenta',
	id_store: 'id_tipo_estado_columna',
	fields: [
		 'id_auxiliar',
        'codigo_auxiliar',
        'nombre_auxiliar',
        'id_cuenta',
        'nro_cuenta',
        'nombre_cuenta',
        'tipo_cuenta',
        'sub_tipo_cuenta',
        'desc_sub_tipo_cuenta',
         'id_config_subtipo_cuenta', 
        'importe_debe_mb',
        'importe_haber_mb',
        'saldo'
	],
	
    sortInfo:{
		field: 'nombre_auxiliar',
		direction: 'ASC'
	},
	bdel: true,
	bsave: false,
	
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
			var tb = Phx.vista.AuxiliarCuenta.superclass.preparaMenu.call(this);
			return tb;
		}
		
		return undefined;
	},
	liberaMenu : function() {
			var tb = Phx.vista.AuxiliarCuenta.superclass.liberaMenu.call(this);
	},
	
			
    bnew : false,
    bedit: false,
    bdel:  false,
	oncellclick : function(grid, rowIndex, columnIndex, e) {
		
	    var record = this.store.getAt(rowIndex).data,
	        fieldName = grid.getColumnModel().getDataIndex(columnIndex); // Get field nam
	    
        var PagMaes = Phx.CP.getPagina(this.idContenedorPadre);
        var desde = PagMaes.Cmp.desde.getValue(); 
        var hasta = PagMaes.Cmp.hasta.getValue();
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
		                      	        'desde': desde,
		                      	        'hasta': hasta,
		                      	        'id_config_subtipo_cuenta': record.id_config_subtipo_cuenta,
		                      	        'desc_csc': record.desc_csc,
		                      	        'desc_auxiliar': record.nombre_auxiliar,
		                      	        'id_cuenta': record.id_cuenta,
		                      	        'desc_cuenta': record.nombre_cuenta,
		                      	        'desc_csc': record.desc_sub_tipo_cuenta,
		                      	        'id_auxiliar': record.id_auxiliar
		                      	      }
		                      
		                     },
		                    this.idContenedor,
		                    'FormFiltro'
		           );
	       
	       
	        
	    }
	    
	    
		
	}
})
</script>