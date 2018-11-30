<?php
/**
*@package pXP
*@file gen-Categoria.php
*@author  (admin)
*@date 20-04-2017 00:51:02
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>



	Phx.vista.DetalleComprobanteTransaccion = Ext.extend(Phx.frmInterfaz, {
		
		Atributos : [
		{
			config:{
				name: 'id_entidad',
				fieldLabel: 'Entidad',
				qtip: 'entidad a la que pertenese el depto, ',
				allowBlank: false,
				emptyText:'Entidad...',
				store:new Ext.data.JsonStore(
				{
					url: '../../sis_parametros/control/Entidad/listarEntidad',
					id: 'id_entidad',
					root: 'datos',
					sortInfo:{
						field: 'nombre',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_entidad','nit','nombre'],
					// turn on remote sorting
					remoteSort: true,
					baseParams: { par_filtro:'nit#nombre' }
				}),
				valueField: 'id_entidad',
				displayField: 'nombre',
				gdisplayField:'desc_entidad',
				hiddenName: 'id_entidad',
    			triggerAction: 'all',
    			lazyRender:true,
				mode:'remote',
				pageSize:50,
				queryDelay:500,
				anchor:"90%",
				listWidth:280,
				gwidth:250,
				minChars:2,
				renderer:function (value, p, record){return String.format('{0}', record.data['desc_entidad']);}

       		},
       		type:'ComboBox',
			filters:{pfiltro:'ENT.nombre',type:'string'},
			id_grupo:0,
			egrid: true,
			grid:true,
			form:true
		},
		{
			config:{
				name:'filtro_sql',
				fieldLabel:'Filtrar Por',
				typeAhead: true,
				allowBlank:false,
	    		triggerAction: 'all',
	    		emptyText:'Filtro...',
	    		selectOnFocus:true,
				mode:'local',
				store:new Ext.data.ArrayStore({
	        	fields: ['ID', 'valor'],
	        	data :	[['periodo','Año y Mes'],	
						['fechas','Rango de Fechas']]	        				
	    		}),
				valueField:'ID',
				displayField:'valor',
				width:250,			
				
			},
			type:'ComboBox',
			id_grupo:1,
			form:true
		},
		
		{
            config:{
                name:'id_gestion',
                fieldLabel:'Gestión',
                allowBlank:true,
                emptyText:'Gestión...',
                store: new Ext.data.JsonStore({
                         url: '../../sis_parametros/control/Gestion/listarGestion',
                         id: 'id_gestion',
                         root: 'datos',
                         sortInfo:{
                            field: 'gestion',
                            direction: 'DESC'
                    },
                    totalProperty: 'total',
                    fields: ['id_gestion','gestion','moneda','codigo_moneda'],
                    // turn on remote sorting
                    remoteSort: true,
                    baseParams:{par_filtro:'gestion'}
                    }),
                valueField: 'id_gestion',
                displayField: 'gestion',
                //tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{nro_cuenta}</b></p><p>{denominacion}</p></div></tpl>',
                hiddenName: 'id_gestion',
                forceSelection:true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender:true,
                mode:'remote',
                pageSize:10,
                queryDelay:1000,
                listWidth:600,
                resizable:true,
                anchor:'100%'
                
            },
            type:'ComboBox',
            id_grupo:0,
            filters:{   
                        pfiltro:'gestion',
                        type:'string'
                    },
            grid:true,
            form:true
        },
		{
            config:{
                name:'id_periodo',
                fieldLabel:'Periodo',
                allowBlank:true,
                emptyText:'Periodo...',
                store: new Ext.data.JsonStore({
                         url: '../../sis_parametros/control/Periodo/listarPeriodo',
                         id: 'id_periodo',
                         root: 'datos',
                         sortInfo:{
                            field: 'id_periodo',
                            direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_periodo','literal','periodo','fecha_ini','fecha_fin'],
                    // turn on remote sorting
                    remoteSort: true,
                    baseParams:{par_filtro:'periodo#literal'}
                    }),
                valueField: 'id_periodo',
                displayField: 'literal',
                //tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{nro_cuenta}</b></p><p>{denominacion}</p></div></tpl>',
                hiddenName: 'id_periodo',
                forceSelection:true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender:true,
                mode:'remote',
                pageSize:12,
                queryDelay:1000,
                listWidth:600,
                resizable:true,
                anchor:'100%'
                
            },
            type:'ComboBox',
            id_grupo:0,
            filters:{   
                        pfiltro:'literal',
                        type:'string'
                    },
            grid:true,
            form:true
        },
		{
			config:{
				name: 'fecha_ini',
				fieldLabel: 'Fecha Inicio',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type:'DateField',
			filters:{pfiltro:'fecha_ini',type:'date'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'fecha_fin',
				fieldLabel: 'Fecha Fin',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type:'DateField',
			filters:{pfiltro:'fecha_fin',type:'date'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name:'formato_reporte',
				fieldLabel:'Formato del Reporte',
				typeAhead: true,
				allowBlank:false,
	    		triggerAction: 'all',
	    		emptyText:'Formato...',
	    		selectOnFocus:true,
				mode:'local',
				store:new Ext.data.ArrayStore({
	        	fields: ['ID', 'valor'],
	        	data :	[['txt','TXT'],
						['csv','CSV'],
                        ]
	    		}),
				valueField:'ID',
				displayField:'valor',
				width:250,			
				
			},
			type:'ComboBox',
			id_grupo:1,
			form:true
		},
        {
			config: {
				name: 'id_config_tipo_cuenta',
				fieldLabel: 'Tipo Cuenta',
				typeAhead: false,
				forceSelection: false,
				allowBlank: true,
				emptyText: 'Tipos...',
				store: new Ext.data.JsonStore({
					url: '../../sis_contabilidad/control/ConfigTipoCuenta/listarConfigTipoCuenta',
					id: 'id_config_tipo_cuenta',
					root: 'datos',
					sortInfo: {
						field: 'nro_base',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_config_tipo_cuenta','tipo_cuenta', 'nro_base'],
					// turn on remote sorting
					remoteSort: true,
					baseParams: {par_filtro: 'tipo_cuenta'}
				}),
				valueField: 'tipo_cuenta',
				displayField: 'tipo_cuenta',
				gdisplayField: 'tipo_cuenta',
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 20,
				queryDelay: 200,
				width: 250,
				listWidth:280,
				minChars: 2
				},
			type: 'ComboBox',	
			id_grupo: 0,
			form: true,
			grid:false
		 },
   	 	 {
   			config:{
   				sysorigen: 'sis_contabilidad',
       		    name: 'id_cuenta',
   				origen: 'CUENTA',
   				allowBlank: true,
   				fieldLabel: 'Cuenta',
   				gdisplayField: 'desc_cuenta',
   				baseParams: { sw_transaccional: undefined },
   				width: 250
       	     },
   			type: 'ComboRec',
   			id_grupo: 0,
   			form: true
	   	},
		{
			config:{
				name:'tipo_reporte',
				fieldLabel:'Tipo reporte',
				typeAhead: true,
				//allowBlank:false,
	    		triggerAction: 'all',
	    		emptyText:'Tipo reporte...',
	    		selectOnFocus:true,
				mode:'local',
				store:new Ext.data.ArrayStore({
	        	fields: ['ID', 'valor'],
	        	data :	[
	        	        //['estandar','Estandar'],
						['auditoria','Auditoria'],
                        ]
	    		}),
				valueField:'ID',
				displayField:'valor',
				width:250,			
				
			},
			type:'ComboBox',
			id_grupo:1,
			form:true
		},
	    {
	        config: {
	            labelSeparator: '',
	            inputType: 'hidden',
	            name: 'datos'
	        },
	        type: 'Field',
	        form: true
	    },
  
		],
		
		
		//title : 'Reporte Libro Compras Ventas IVA',		
		//ActSave : '../../sis_contabilidad/control/TsLibroBancos/reporteLibroBancos',
		
		topBar : true,
		botones : false,
		labelSubmit : 'Generar',
		tooltipSubmit : '<b>Reporte LCV - IVA</b>',
		
		constructor : function(config) {
			Phx.vista.DetalleComprobanteTransaccion.superclass.constructor.call(this, config);
			this.init();
			
			this.ocultarComponente(this.Cmp.fecha_fin);
			this.ocultarComponente(this.Cmp.fecha_ini);
			this.ocultarComponente(this.Cmp.id_gestion);
			this.ocultarComponente(this.Cmp.id_periodo);
						
			this.iniciarEventos();
			
			//this.Cmp.datos.setValue('No contabilizado');
			this.Cmp.datos.setValue('contabilizado');
		},
		
		iniciarEventos:function(){        
			
			this.Cmp.id_gestion.on('select',function(c,r,n){
				
				this.Cmp.id_periodo.reset();
				this.Cmp.id_periodo.store.baseParams={id_gestion:c.value, vista: 'reporte'};				
				this.Cmp.id_periodo.modificado=true;
				
			},this);
			
			
			this.Cmp.filtro_sql.on('select',function(combo, record, index){
				
				if(index == 0){
					this.ocultarComponente(this.Cmp.fecha_fin);
					this.ocultarComponente(this.Cmp.fecha_ini);
					this.mostrarComponente(this.Cmp.id_gestion);
					this.mostrarComponente(this.Cmp.id_periodo);
				}
				else{
					this.mostrarComponente(this.Cmp.fecha_fin);
					this.mostrarComponente(this.Cmp.fecha_ini);
					this.ocultarComponente(this.Cmp.id_gestion);
					this.ocultarComponente(this.Cmp.id_periodo);
				}
				
			}, this);
		},
		
		
		
		tipo : 'reporte',
		clsSubmit : 'bprint',
		
		Grupos : [{
			layout : 'column',
			items : [{
				xtype : 'fieldset',
				layout : 'form',
				border : true,
				title : 'Datos para el reporte',
				bodyStyle : 'padding:0 10px 0;',
				columnWidth : '500px',
				items : [],
				id_grupo : 0,
				collapsible : true
			}]
		}],
		
	ActSave:'../../sis_contabilidad/control/IntTransaccion/listaDetalleComprobanteTransacciones',
	
    successSave :function(resp){
    	
       //alert(this.Cmp.id_config_tipo_cuenta.getValue());
       //alert(this.Cmp.id_cuenta.getValue());
       Phx.CP.loadingHide();
       var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
       if (reg.ROOT.error) {
            alert('error al procesar');
            return
       } 
       var nomRep = reg.ROOT.detalle.archivo_generado;
        if(Phx.CP.config_ini.x==1){  			
        	nomRep = Phx.CP.CRIPT.Encriptar(nomRep);
        }
       
        if(this.Cmp.formato_reporte.getValue()=='pdf'){
        	window.open('../../../lib/lib_control/Intermediario.php?r='+nomRep+'&t='+new Date().toLocaleTimeString())
        }
        else{
        	window.open('../../../reportes_generados/'+nomRep+'?t='+new Date().toLocaleTimeString())
        }
	}
})





</script>
		
		