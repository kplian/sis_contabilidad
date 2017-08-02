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
Phx.vista.EstadoCuenta = Ext.extend(Phx.gridInterfaz,{
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
				fieldLabel: 'D',
				gwidth: 25, 
				renderer:function (value,p,record){  
					if(record.data.origen == 'contabilidad' || (record.data.link_int_det != ''&&record.data.link_int_det != undefined)){
					    return  String.format("<div style='text-align:center'><img title='Revisar Mayor' src = '../../../lib/imagenes/connect.png' align='center'/></div>");
				     }
				}
			   },
			   type:'Field',
			   grid:true
		    },
			
			
			{
				config:{
					name: 'nombre',
					fieldLabel: 'Nombre',
					allowBlank: true,
					anchor: '80%',
					gwidth: 300,
					maxLength:1000
				},
				type:'TextArea',
				filters:{pfiltro:'transa.glosa',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
			},
			
			{
				config: {
					name: 'monto_mb',
					fieldLabel: 'Monto MB',
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
				form: false
			},
			
			
			{
				config: {
					name: 'monto_mt',
					fieldLabel: 'Monto MT',
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
				form: false
			}
			
			
			
		];
			
		//llama al constructor de la clase padre
		Phx.vista.EstadoCuenta.superclass.constructor.call(this,config);
		
		this.grid.getTopToolbar().disable();
		this.grid.getBottomToolbar().disable();
		this.init();
		this.grid.addListener('cellclick', this.oncellclick,this);
		
	},
	
	tam_pag: 50,	
	ActList: '../../sis_contabilidad/control/TipoEstadoCuenta/listarEstadoCuenta',
	id_store: 'id_tipo_estado_columna',
	fields: [
		'id_auxiliar' ,
        'id_tipo_estado_cuenta' ,
        'id_tipo_estado_columna' ,
        'id_config_subtipo_cuenta' ,
        'fecha_ini'  ,
        'fecha_fin' ,
        'desc_csc' ,
        'codigo' ,
        'nombre' ,
        'monto_mb' ,
        'monto_mt' ,
        'prioridad' ,
        'nombre_funcion' ,
        'link_int_det'  ,
        'tabla'  ,
        'id_tabla',
        'origen' ,
        'descripcion',
        'desc_auxiliar','nombre_clase','parametros_det'

	],
	
	
    
    arrayDefaultColumHidden:['fecha_mod','usr_reg','usr_mod','estado_reg','fecha_reg','glosa'],

    sortInfo:{
		field: 'id_int_transaccion',
		direction: 'ASC'
	},
	bdel: true,
	bsave: false,
	loadValoresIniciales:function(){
		Phx.vista.EstadoCuenta.superclass.loadValoresIniciales.call(this);
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
			var tb = Phx.vista.EstadoCuenta.superclass.preparaMenu.call(this);
			return tb;
		}
		
		return undefined;
	},
	liberaMenu : function() {
			var tb = Phx.vista.EstadoCuenta.superclass.liberaMenu.call(this);
	},
	
	
    bnew : false,
    bedit: false,
    bdel:  false,
	oncellclick : function(grid, rowIndex, columnIndex, e) {
		
	    var record = this.store.getAt(rowIndex).data,
	        fieldName = grid.getColumnModel().getDataIndex(columnIndex); // Get field name

	    if (fieldName == 'detalle') {
	    	
	    	 if(record.origen == 'contabilidad' ){
			    	Phx.CP.loadWindows('../../../sis_contabilidad/vista/int_transaccion/FormFiltro.php',
		                    'Mayor',
		                    {
		                        width:'100%',
		                        height:'100%',
		                    },
		                    { maestro:record.data,
		                      detalle: {
		                      	        'tipo_filtro': 'fechas',
		                      	        'desde': record.fecha_ini,
		                      	        'hasta': record.fecha_fin,
		                      	        'id_config_subtipo_cuenta': record.id_config_subtipo_cuenta,
		                      	        'desc_csc': record.desc_csc,
		                      	        'desc_auxiliar': record.desc_auxiliar,
		                      	        'id_auxiliar': record.id_auxiliar
		                      	      }
		                      
		                     },
		                    this.idContenedor,
		                    'FormFiltro'
		           );
	        }
	         if(record.link_int_det != ''&&record.link_int_det != undefined){
	         	
	         	var detalle;
	         	
	         	
	         	eval("detalle="+record.parametros_det);
	         	console.log('....... ',detalle)
	         	Phx.CP.loadWindows(record.link_int_det,
		                    'Mayor',
		                    {
		                        width:'100%',
		                        height:'100%',
		                    },
		                    { 
		                    	maestro:record.data,
		                        detalle: detalle
		                      
		                     },
		                    this.idContenedor,
		                    record.nombre_clase
		           );
	         	
	         	
	         	
	         	
	         }
	        
	    }
	    
	    
		
	}
})
</script>