<?php
/**
*@package pXP
*@file gen-IntTransaccion.php
*@author  (admin)
*@date 01-09-2013 18:10:12
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.IntTransaccion=Ext.extend(Phx.gridInterfaz,{
   
	constructor:function(config){
		
		
		this.maestro=config.maestro;
		
    	//llama al constructor de la clase padre
		Phx.vista.IntTransaccion.superclass.constructor.call(this,config);
		this.grid.getTopToolbar().disable();
		this.grid.getBottomToolbar().disable();
		this.init();
		
		this.obtenerVariableGlobal();
		
		
		this.Cmp.importe_debe.on('change',function(cmp){
			this.Cmp.importe_haber.suspendEvents();
			this.Cmp.importe_haber.setValue(0);
			this.Cmp.importe_haber.resumeEvents();
			
		},this);
		
		this.Cmp.importe_haber.on('change',
		    function(cmp){
			    this.Cmp.importe_debe.suspendEvents();
				this.Cmp.importe_debe.setValue(0);
				this.Cmp.importe_debe.resumeEvents();
			  
		   },this);
		
	},
		
	Atributos:[
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
			config: {
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
   				gwidth:600,
   				width: 350,
   				listWidth: 350,
   				
	   			renderer:function (value, p, record){
	   			    var color = 'green';
	   			    if(record.data["tipo_reg"] != 'summary'){
		   			    if(record.data["tipo_partida"] == 'flujo'){
		   			        color = 'red';
		   			    }
		   			    
		   					
		   				var retorno =  String.format('<b>CC:</b>{0}, <br><b>Cta.:</b>{1}<br>',record.data['desc_centro_costo'], record.data['desc_cuenta']);	
		   					
		   					if(record.data['desc_auxiliar']){
			   					retorno = retorno + String.format('<b>Aux.:</b>{2}</br>', record.data['desc_auxiliar']);
			   				}
		   					
		   					
		   					if(record.data['desc_partida']){
			   					retorno = retorno + String.format('<b>Ptda.:</b> <font color="{0}">{1}</font><br>',color, record.data['desc_partida']);
			   				}
		   					
		   					
			   				
			   				if(record.data['desc_orden']){
			   					retorno = retorno + '<b>Ot.:</b> '+record.data['desc_orden'];
			   				}	
		   				return retorno;	
	   			    	
	   			    }
	   			    else{
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
		        pfiltro: 'par.codigo_partida#par.nombre_partida',
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
				name: 'importe_debe',
				fieldLabel: 'Debe',
				allowBlank: true,
				width: '100%',
				gwidth: 100,
				maxLength: 100
			},
			type: 'NumberField',
			filters: {pfiltro: 'transa.importe_debe',type: 'numeric'},
			id_grupo: 1,
			grid: true,
			form: true
		},
		{
			config: {
				name: 'importe_haber',
				fieldLabel: 'Haber',
				allowBlank: true,
				width: '100%',
				gwidth: 100,
				maxLength: 100
			},
			type: 'NumberField',
			filters: {pfiltro: 'transa.importe_haber',type: 'numeric'},
			id_grupo: 1,
			grid: true,
			form: true
		},
		{
			config: {
				name: 'importe_debe_mb',
				fieldLabel: 'Debe MB',
				allowBlank: true,
				width: '100%',
				gwidth: 100,
				maxLength: 100
			},
			type: 'NumberField',
			filters: {pfiltro: 'transa.importe_debe_mb',type: 'numeric'},
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
				gwidth: 100,
				maxLength: 100
			},
			type: 'NumberField',
			filters: {pfiltro: 'transa.importe_haber_mb',type: 'numeric'},
			id_grupo: 1,
			grid: true,
			form: false
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
	],
	tam_pag:50,	
	title:'Transacción',
	ActSave:'../../sis_contabilidad/control/IntTransaccion/insertarIntTransaccion',
	ActDel:'../../sis_contabilidad/control/IntTransaccion/eliminarIntTransaccion',
	ActList:'../../sis_contabilidad/control/IntTransaccion/listarIntTransaccion',
	id_store:'id_int_transaccion',
	fields: [
		{name:'id_int_transaccion', type: 'numeric'},
		{name:'id_partida', type: 'numeric'},
		{name:'id_centro_costo', type: 'numeric'},
		{name:'id_partida_ejecucion', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_int_transaccion_fk', type: 'numeric'},
		{name:'id_cuenta', type: 'numeric'},
		{name:'glosa', type: 'string'},
		{name:'id_int_comprobante', type: 'numeric'},
		{name:'id_auxiliar', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'importe_debe', type: 'numeric'},
		{name:'importe_haber', type: 'numeric'},
		{name:'importe_gasto', type: 'numeric'},
		{name:'importe_recurso', type: 'numeric'},
		{name:'importe_debe_mb', type: 'numeric'},
		{name:'importe_haber_mb', type: 'numeric'},
		{name:'importe_gasto_mb', type: 'numeric'},
		{name:'importe_recurso_mb', type: 'numeric'},
		{name:'desc_cuenta', type: 'string'},
		{name:'desc_auxiliar', type: 'string'},
		{name:'desc_partida', type: 'string'},
		{name:'desc_centro_costo', type: 'string'},'tipo_partida','id_orden_trabajo','desc_orden','tipo_reg'
		
	],
	
	
	rowExpander: new Ext.ux.grid.RowExpander({
	        tpl : new Ext.Template(
	            '<br>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Glosa:&nbsp;&nbsp;</b> {glosa} </p><br>'
	        )
    }),
    
    arrayDefaultColumHidden:['fecha_mod','usr_reg','usr_mod','glosa','estado_reg','fecha_reg'],



	sortInfo:{
		field: 'id_int_transaccion',
		direction: 'ASC'
	},
	bdel: true,
	bsave: false,
	loadValoresIniciales:function(){
		Phx.vista.IntTransaccion.superclass.loadValoresIniciales.call(this);
		this.getComponente('id_int_comprobante').setValue(this.maestro.id_int_comprobante);		
	},
	onReloadPage:function(m){
		this.maestro=m;						
		this.store.baseParams={id_int_comprobante:this.maestro.id_int_comprobante, id_moneda:this.maestro.id_moneda};
		this.load({params:{start:0, limit:this.tam_pag}});
		
		//Se obtiene la gestión en función de la fecha del comprobante para filtrar partidas, cuentas, etc.
		var fecha=new Date(this.maestro.fecha);
		this.maestro.id_gestion = this.getGestion(fecha);
		//Se setea el combo de moneda con el valor del padre
		
		 this.setColumnHeader('importe_debe', this.Cmp.importe_haber.fieldLabel +' '+this.maestro.desc_moneda);
		 this.setColumnHeader('importe_haber', this.Cmp.importe_haber.fieldLabel +' '+this.maestro.desc_moneda);
		 //si a moneda del comprobate es base ocultamos la columnas duplicadas
		 if(this.maestro.id_moneda_base == this.maestro.id_moneda){
		 	this.ocultarColumnaByName('importe_debe_mb');
		 	this.ocultarColumnaByName('importe_haber_mb');
		 }
		 else{
		 	this.mostrarColumnaByName('importe_debe_mb');
		 	this.mostrarColumnaByName('importe_haber_mb');
		 }
	},
	
	preparaMenu:function(){
		var rec = this.sm.getSelected();
		var tb = this.tbar;
		if(rec.data.tipo_reg != 'summary'){
			return Phx.vista.IntTransaccion.superclass.preparaMenu.call(this);
		}
		else{
			 tb.items.get('b-edit-' + this.idContenedor).disable();
			 tb.items.get('b-del-' + this.idContenedor).disable();
		}
		
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
	obtenerVariableGlobal: function(){
		//Verifica que la fecha y la moneda hayan sido elegidos
		Phx.CP.loadingShow();
		Ext.Ajax.request({
				url:'../../sis_seguridad/control/Subsistema/obtenerVariableGlobal',
				params:{
					codigo: 'conta_partidas'  
				},
				success: function(resp){
					Phx.CP.loadingHide();
					var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
					
					if (reg.ROOT.error) {
						Ext.Msg.alert('Error','Error a recuperar la variable global')
					} else {
						if(reg.ROOT.datos.valor = 'no'){
							this.ocultarComponente(this.Cmp.id_partida);
						}
					}
				},
				failure: this.conexionFailure,
				timeout: this.timeout,
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
	}
})
</script>
		
		