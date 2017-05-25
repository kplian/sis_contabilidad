<?php
/**
*@package pXP
*@file gen-AjusteDet.php
*@author  (admin)
*@date 10-12-2015 15:16:44
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.AjusteDet=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
		var me = this;
		
		
		this.Atributos = [
					{
						//configuracion del componente
						config:{
								labelSeparator:'',
								inputType:'hidden',
								name: 'id_ajuste_det'
						},
						type:'Field',
						form:true 
					},
					{
						//configuracion del componente
						config:{
								labelSeparator:'',
								inputType:'hidden',
								name: 'id_ajuste'
						},
						type:'Field',
						form:true 
					},
					{
						config:{
							name: 'revisado',
							fieldLabel: 'Revisado',
							allowBlank: true,
							anchor: '80%',
							gwidth: 60,
							maxLength:3,
			                renderer: function (value, p, record, rowIndex, colIndex){  
			                	     
			            	       //check or un check row
			            	       var checked = '',
			            	       	   momento = 'no';
			                	   if(value == 'si'){
			                	        	checked = 'checked';;
			                	   }
			                	   if (me.maestro.estado != 'borrador'){
			                	   	  return  String.format('<div style="vertical-align:middle;text-align:center;"><input style="height:37px;width:37px;" type="checkbox"  {0}  disabled></div>',checked);
			            	    
			                	   }
			                	   else{
			                	   	 return  String.format('<div style="vertical-align:middle;text-align:center;"><input style="height:37px;width:37px;" type="checkbox"  {0}></div>',checked);
			            	      
			                	   }
			            	         
			                 }
						},
						type: 'TextField',
						filters: { pfiltro:'ajtd.revisado',type:'string'},
						id_grupo: 1,
						grid: true,
						form: false
					},
					{
			   			config:{
			   				sysorigen:'sis_contabilidad',
			       		    name:'id_cuenta',
			   				origen:'CUENTA',
			   				allowBlank:false,
			   				fieldLabel:'Cuenta',
			   				gdisplayField:'nombre_cuenta',//mapea al store del grid
			   				gwidth:300,
			   				width: 350,
			   				listWidth: 350, //parametros adicionales que se le pasan al store
			   				baseParams: {sw_control_efectivo: 'si'},
			   				renderer:function (value, p, record){
				   			    	
				   			     	var retorno =  String.format('<b>Cta.:</b>({0}) - {1} <br><b>Moneda Ajuste: ({2})</b><br>', record.data['nro_cuenta'],record.data['nombre_cuenta'],record.data['codigo_moneda']);	
					   					
				   					if(record.data['desc_auxiliar']){
					   					retorno = retorno + String.format('<b>Aux.:</b>{0}</br>', record.data['desc_auxiliar']);
					   				}
				   					if(record.data['desc_partida_ingreso']){
					   					retorno = retorno + String.format('<b>Ptda. ING:</b> <font color="green">{0}</font><br>', record.data['desc_partida_ingreso']);
					   				}
					   				if(record.data['desc_partida_egreso']){
					   					retorno = retorno + String.format('<b>Ptda. EGR:</b> <font color="red">{0}</font><br>', record.data['desc_partida_egreso']);
					   				}
					   				return String.format('<div class="gridmultiline">{0}</div>',retorno);
				   			 }
			   			},
			   			type:'ComboRec',
			   			id_grupo:0,
			   			filters:{	
					        pfiltro:'c.nombre_cuenta#c.nro_cuenta',
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
					        pfiltro:'a.codigo_auxiliar#a.nombre_auxiliar',
							type:'string'
						},
			   		   
			   			grid:false,
			   			form:true
				   	},
				   	{
			   			config:{
			   				sysorigen:'sis_presupuestos',
			       		    name: 'id_partida_ingreso',
			   				origen:'PARTIDA',
			   				allowBlank:false,
			   				fieldLabel:'Partida',
			   				gdisplayField:'desc_partida',//mapea al store del grid
			   				gwidth:200,
			   				width: 350,
			   				listWidth: 350
			       	     },
			   			type:'ComboRec',
			   			id_grupo:0,
			   			filters:{	
					        pfiltro: 'pin.codigo_partida#pin.nombre_partida',
							type: 'string'
						},			   		   
			   			grid:false,			   			
			   			form:true
				   	},
					
				   	{
			   			config:{
			   				sysorigen:'sis_presupuestos',
			       		    name:'id_partida_egreso',
			   				origen:'PARTIDA',
			   				allowBlank:false,
			   				fieldLabel:'Partida',
			   				gdisplayField:'desc_partida',//mapea al store del grid
			   				gwidth:200,
			   				width: 350,
			   				listWidth: 350
			       	     },
			   			type:'ComboRec',
			   			id_grupo:0,
			   			filters:{	
					        pfiltro: 'peg.codigo_partida#peg.nombre_partida',
							type: 'string'
						},
			   		   
			   			grid:false,
				   	}, 
				   	{
							config : {
								name : 'id_moneda_ajuste',
								origen : 'MONEDA',
								allowBlank : false,
								fieldLabel : 'Moneda',
								gdisplayField : 'codigo_moneda', //mapea al store del grid
								gwidth : 100,
								width : 250
							},
							type : 'ComboRec',
							id_grupo : 2,
							filters : {
								pfiltro : 'm.desc_moneda',
								type : 'string'
							},
							grid : false,
							form : true
					},
					{
						config:{
							name: 'tipo_cambio_1',
							fieldLabel: 'TC MB',
							allowBlank: true,
							anchor: '80%',
							gwidth: 50,
						},
							type:'NumberField',
							filters:{pfiltro:'ajtd.tipo_cambio_1',type:'numeric'},
							id_grupo:1,
							grid:true,
							form:false
					},
					{
						config:{
							name: 'tipo_cambio_2',
							fieldLabel: 'TC MT',
							allowBlank: true,
							anchor: '80%',
							gwidth: 50,
						},
							type:'NumberField',
							filters:{pfiltro:'ajtd.tipo_cambio_2',type:'numeric'},
							id_grupo:1,
							grid:true,
							form:false
					},
					{
						config:{
							name: 'mayor',
							fieldLabel: 'Mayor',
							allowBlank: false,
							anchor: '80%',
							gwidth: 100,
							maxLength:-5
						},
							type:'NumberField',
							filters:{pfiltro:'ajtd.mayor',type:'numeric'},
							id_grupo:1,
							grid:true,
							form:false
					},
					{
						config:{
							name: 'mayor_mb',
							fieldLabel: 'Mayor MB',
							allowBlank: false,
							anchor: '80%',
							gwidth: 100,
							maxLength:-5
						},
							type:'NumberField',
							filters:{pfiltro:'ajtd.mayor_mb',type:'numeric'},
							id_grupo:1,
							grid:true,
							form:false
					},
					{
						config:{
							name: 'mayor_mt',
							fieldLabel: 'Mayor MT',
							allowBlank: false,
							anchor: '80%',
							gwidth: 100,
							maxLength:-5
						},
							type:'NumberField',
							filters:{pfiltro:'ajtd.mayor_mt',type:'numeric'},
							id_grupo:1,
							grid:true,
							form:false
					},
					{
						config:{
							name: 'act_mb',
							fieldLabel: 'Act MB',
							allowBlank: true,
							anchor: '80%',
							gwidth: 100,
							maxLength:-5
						},
							type:'NumberField',
							filters:{pfiltro:'ajtd.act_mb',type:'numeric'},
							id_grupo:1,
							grid:true,
							form:false
					},
					{
						config:{
							name: 'act_mt',
							fieldLabel: 'Act MT',
							allowBlank: true,
							anchor: '80%',
							gwidth: 100,
							maxLength:-5
						},
							type:'NumberField',
							filters:{pfiltro:'ajtd.act_mt',type:'numeric'},
							id_grupo:1,
							grid:true,
							form:false
					},
					{
						config:{
							name: 'dif_mb',
							fieldLabel: 'Dif MB',
							allowBlank: true,
							anchor: '80%',
							gwidth: 100,
							renderer : function(value, p, record) {	
								if (record.data['dif_manual'] == 'no'){
									return String.format('<font  color="green">{0}</font>', value );
								}
								else{
									return String.format('<b><font  color="red">{0}</font></b>', value );
								}
								
							}
						},
							type:'NumberField',
							filters:{pfiltro:'ajtd.dif_mb',type:'numeric'},
							id_grupo:1,
							grid:true,
							form:false,
							egrid: true
					},
					{
						config:{
							name: 'dif_mt',
							fieldLabel: 'Dif MT',
							allowBlank: true,
							anchor: '80%',
							gwidth: 100,
							renderer : function(value, p, record) {	
								if (record.data['dif_manual'] == 'no'){
									return String.format('<font  color="green">{0}</font>', value );
								}
								else{
									return String.format('<b><font  color="red">{0}</font></b>', value );
								}
								
							}
						},
							type:'NumberField',
							filters:{pfiltro:'ajtd.dif_mt',type:'numeric'},
							id_grupo:1,
							grid:true,
							form:false,
							egrid: true
					},
			        {
			            config:{
			                name: 'id_cuenta_bancaria',
			                fieldLabel: 'Cuenta Bancaria',
			                allowBlank: false,
			                emptyText:'Elija una Cuenta...',
			                store:new Ext.data.JsonStore(
			                {
			                    url: '../../sis_tesoreria/control/CuentaBancaria/listarCuentaBancaria',
			                    id: 'id_cuenta_bancaria',
			                    root:'datos',
			                    sortInfo:{
			                        field:'id_cuenta_bancaria',
			                        direction:'ASC'
			                    },
			                    totalProperty:'total',
			                    fields: ['id_cuenta_bancaria','nro_cuenta','nombre_institucion','codigo_moneda','centro','denominacion'],
			                    remoteSort: true,
			                    baseParams : {
									par_filtro :'nro_cuenta'
								}
			                }),
			                tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{nro_cuenta}</b></p><p>Moneda: {codigo_moneda}, {nombre_institucion}</p><p>{denominacion}, Centro: {centro}</p></div></tpl>',
			                valueField: 'id_cuenta_bancaria',
			                hiddenValue: 'id_cuenta_bancaria',
			                displayField: 'nro_cuenta',
			                gdisplayField:'desc_cuenta_bancaria',
			                listWidth:'280',
			                forceSelection:true,
			                typeAhead: false,
			                triggerAction: 'all',
			                lazyRender:true,
			                mode:'remote',
			                pageSize:20,
			                queryDelay:500,
			                gwidth: 250,
			                minChars:2,
			                renderer:function(value, p, record){return String.format('{0}', record.data['desc_cuenta_bancaria']);}
			             },
			            type:'ComboBox',
			            filters:{pfiltro:'cb.nro_cuenta',type:'string'},
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
							type:'TextField',
							filters:{pfiltro:'ajtd.estado_reg',type:'string'},
							id_grupo:1,
							grid:true,
							form:false
					},
					{
						config:{
							name: 'id_usuario_ai',
							fieldLabel: '',
							allowBlank: true,
							anchor: '80%',
							gwidth: 100,
							maxLength:4
						},
							type:'Field',
							filters:{pfiltro:'ajtd.id_usuario_ai',type:'numeric'},
							id_grupo:1,
							grid:false,
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
							filters:{pfiltro:'ajtd.fecha_reg',type:'date'},
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
							filters:{pfiltro:'ajtd.fecha_mod',type:'date'},
							id_grupo:1,
							grid:true,
							form:false
					},
					{
						config:{
							name: 'usuario_ai',
							fieldLabel: 'Funcionaro AI',
							allowBlank: true,
							anchor: '80%',
							gwidth: 100,
							maxLength:300
						},
							type:'TextField',
							filters:{pfiltro:'ajtd.usuario_ai',type:'string'},
							id_grupo:1,
							grid:true,
							form:false
					}
				];
		
    	//llama al constructor de la clase padre
		Phx.vista.AjusteDet.superclass.constructor.call(this,config);
		this.init();
		this.grid.getTopToolbar().disable();
		this.grid.getBottomToolbar().disable();		
		this.grid.addListener('cellclick', this.oncellclick,this);
		this.obtenerVariableGlobal();
	},
	tam_pag:50,	
	title:'Ajuste Detalle',
	ActSave:'../../sis_contabilidad/control/AjusteDet/insertarAjusteDet',
	ActDel:'../../sis_contabilidad/control/AjusteDet/eliminarAjusteDet',
	ActList:'../../sis_contabilidad/control/AjusteDet/listarAjusteDet',
	id_store:'id_ajuste_det',
	fields: [
		{name:'id_ajuste_det', type: 'numeric'},
		{name:'mayor_mb', type: 'numeric'},
		{name:'tipo_cambio_1', type: 'numeric'},
		{name:'tipo_cambio_2', type: 'numeric'},
		{name:'mayor', type: 'numeric'},
		{name:'mayor_mt', type: 'numeric'},
		{name:'dif_mb', type: 'numeric'},
		{name:'act_mb', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_ajuste', type: 'numeric'},
		{name:'dif_mt', type: 'numeric'},
		{name:'act_mt', type: 'numeric'},
		{name:'id_cuenta', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'id_moneda_cuenta',
		'dif_manual',
		'nro_cuenta','nombre_cuenta','codigo_moneda','ajuste',
		'revisado','id_partida_ingreso','id_partida_egreso',
		'desc_auxiliar','desc_cuenta_bancaria','desc_partida_ingreso','desc_partida_egreso','id_moneda_ajuste'
		
	],
	
	onReloadPage:function(m){
       
        this.maestro=m;
        this.store.baseParams={id_ajuste:this.maestro.id_ajuste};
        this.load({params:{start:0, limit:50}});
        var fecha=new Date(this.maestro.fecha);
        this.maestro.id_gestion = this.getGestion(fecha);    
        
        
         if(m.tipo == 'bancos'){
         	  //buscamos los libros de bbancos aosciados al depto contable
         	  //this.getLibrosBancos();
         } 
      
       
      
                
   },
   
   getLibrosBancos:function(x){
   	    var me = this;
   	    Phx.CP.loadingShow();
		Ext.Ajax.request({ 
	                    url:'../../sis_contabilidad/control/RelacionContable/getDlbXDconta',
	                    params:{id_depto_conta: me.maestro.id_depto_conta},
	                    success:this.successLb,
	                    failure: this.conexionFailure,
	                    timeout:this.timeout,
	                    scope:this
	    });
		
	},
	
	successLb:   function(resp){
		
		Phx.CP.loadingHide();
		var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
        if(!reg.ROOT.error){
            var id_deptos_lbs = reg.ROOT.datos.id_deptos_lbs;
	        //Setea los stores de partida, cuenta, etc. con la gestion obtenida
			Ext.apply(this.Cmp.id_cuenta_bancaria.store.baseParams,{id_depto_lbs: id_deptos_lbs});
			this.Cmp.id_cuenta_bancaria.modificado = true;
           
        } else{
            alert('Error al obtener libros de bancos')
        } 
	},
	
	
   
	
	loadValoresIniciales : function() {
		Phx.vista.AjusteDet.superclass.loadValoresIniciales.call(this);
		if (this.maestro.id_ajuste != undefined) {
			this.getComponente('id_ajuste').setValue(this.maestro.id_ajuste);
		}
	},
	
	getGestion:function(x){
		if(Ext.isDate(x)){
			Phx.CP.loadingShow();
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
	
	successGestion: function(resp){
		Phx.CP.loadingHide();
		var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
        if(!reg.ROOT.error){
            var id_gestion = reg.ROOT.datos.id_gestion;
	        //Setea los stores de partida, cuenta, etc. con la gestion obtenida
			Ext.apply(this.Cmp.id_cuenta.store.baseParams,{id_gestion: id_gestion})
           
        } else{
            alert('Error al obtener la gestión. Cierre y vuelva a intentarlo')
        } 
	},
	
	 preparaMenu:function(tb){
        Phx.vista.AjusteDet.superclass.preparaMenu.call(this,tb)
        if(this.maestro.estado == 'borrador'){
        	this.getBoton('save').enable();
        	this.getBoton('del').enable();
        }
        else{
        	this.getBoton('save').disable();
        	this.getBoton('del').disable();
        }
        
          
    },
    
    liberaMenu:function(tb){
        Phx.vista.AjusteDet.superclass.liberaMenu.call(this,tb);
        
                    
    },
    
    oncellclick : function(grid, rowIndex, columnIndex, e) {
     	var record = this.store.getAt(rowIndex),
	        fieldName = grid.getColumnModel().getDataIndex(columnIndex); // Get field name
     	
     	if(fieldName == 'revisado') {
	       
	       	   this.cambiarRevision(record);
	      
	    }
     },
     cambiarRevision: function(record){
		Phx.CP.loadingShow();
	    var d = record.data
        Ext.Ajax.request({
            url:'../../sis_contabilidad/control/AjusteDet/cambiarRevision',
            params:{ id_ajuste_det: d.id_ajuste_det},
            success: this.successRevision,
            failure: this.conexionFailure,
            timeout: this.timeout,
            scope: this
        }); 
	},
	successRevision: function(resp){
       Phx.CP.loadingHide();
       var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
       if(!reg.ROOT.error){
         this.reload();
       }
    },
    
    onButtonSave: function(){
    	 
    	 if(this.maestro.estado == 'borrador'){
    	 	 Phx.vista.AjusteDet.superclass.onButtonSave.call(this);
    	 }
    	 else{
    	 	alert('solo peude realizar cambios cuando el ajust eesta en borrador');
    	 }
    	
    	
    },
    
    onButtonNew: function(){
        Phx.vista.AjusteDet.superclass.onButtonNew.call(this);
        if(this.maestro.tipo == 'bancos'){
        	this.mostrarComponente(this.Cmp.id_cuenta_bancaria);
        	this.ocultarComponente(this.Cmp.id_cuenta);
        	this.ocultarComponente(this.Cmp.id_auxiliar);
        	this.ocultarComponente(this.Cmp.id_partida_ingreso);        	
        	this.ocultarComponente(this.Cmp.id_partida_egreso);
        	this.ocultarComponente(this.Cmp.id_moneda_ajuste);
        }
        else{
        	this.mostrarComponente(this.Cmp.id_cuenta);
        	this.mostrarComponente(this.Cmp.id_auxiliar);
        	this.mostrarComponente(this.Cmp.id_partida_ingreso);        	
        	this.mostrarComponente(this.Cmp.id_partida_egreso);
        	this.mostrarComponente(this.Cmp.id_moneda_ajuste);
        	this.ocultarComponente(this.Cmp.id_cuenta_bancaria);
        
        	
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
						Ext.Msg.alert('Error','Error al recuperar la variable global')
					} else {
						if(reg.ROOT.datos.valor == 'no'){
							this.ocultarComponente(this.Cmp.id_partida_ingreso);
							this.ocultarComponente(this.Cmp.id_partida_egreso);
						}
					}
				},
				failure: this.conexionFailure,
				timeout: this.timeout,
				scope:this
			});
		
	},
    
	
	
	sortInfo:{
		field: 'id_ajuste_det',
		direction: 'ASC'
	},
	bdel: true,
	bsave: true,
	bedit: false
	}
)
</script>
		
		