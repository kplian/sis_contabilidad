<?php
/**
*@package pXP
*@file gen-PeriodoCompraVenta.php
*@author  (admin)
*@date 24-08-2015 14:16:54
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.PeriodoCompraVenta=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
		this.initButtons=[this.cmbGestion];
    	//llama al constructor de la clase padre
		Phx.vista.PeriodoCompraVenta.superclass.constructor.call(this,config);
		
		this.bloquearOrdenamientoGrid();
		this.cmbGestion.on('select', function(){
		    if(this.validarFiltros()){
                  this.capturaFiltros();
            }
		},this);
		
		
		this.init();
		
		this.addButton('btnGenPer',
            {
                text: 'Generar Periodos',
                iconCls: 'bchecklist',
                disabled: false,
                handler: this.generarPeriodos,
                tooltip: '<b>Generar Periodos</b><br/>GEnerar periodos de compra y venta para el depto y gestion selecionados'
            }
        );
        
        this.addButton('btnCerrarPeriodo', {
				text : 'Cerrar',
				iconCls : 'block',
				disabled : true,
				handler : this.onCerrarPeriodo,
				tooltip : '<b>Cerrar</b> Cerrar el periodo , nadie puede insertar ni modificar documentos'
			});
			
		this.addButton('btnCerrarParPeriodo', {
				text : 'Cerrar Parcial',
				iconCls : 'block',
				disabled : true,
				handler : this.onCerrarParPeriodo,
				tooltip : '<b>Cerrar Parcialmente</b> Cierra para todos pero permite al personal de contabilidad realizar registros'
			});	
		
		this.addButton('btnAbrirPeriodo', {
				text : 'Abrir',
				iconCls : 'bunlock',
				disabled : true,
				handler : this.onAbrirPeriodo,
				tooltip : '<b>Abrir</b>Abrir periodo para permitir registros de documentos'
			});	
		
		this.bloquearMenus();
		//this.load({params:{start:0, limit:this.tam_pag}})
	},
	
	
    
	
	cmbGestion: new Ext.form.ComboBox({
				fieldLabel: 'Gestion',
				allowBlank: false,
				emptyText:'Gestion...',
				blankText: 'Año',
				store:new Ext.data.JsonStore(
				{
					url: '../../sis_parametros/control/Gestion/listarGestion',
					id: 'id_gestion',
					root: 'datos',
					sortInfo:{
						field: 'gestion',
						direction: 'ASC'
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
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_periodo_compra_venta'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_periodo'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_depto'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'periodo',
				fieldLabel: 'Periodo',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:20
			},
				type:'TextField',
				filters:{pfiltro:'per.periodo',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'estado',
				fieldLabel: 'estado',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:20
			},
				type:'TextField',
				filters:{pfiltro:'pcv.estado',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'fecha_ini',
				fieldLabel: 'Inicio',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'per.fecha_ini',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'fecha_fin',
				fieldLabel: 'Fin',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'per.fecha_fin',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
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
				filters:{pfiltro:'pcv.estado_reg',type:'string'},
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
				filters:{pfiltro:'pcv.fecha_reg',type:'date'},
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
				filters:{pfiltro:'pcv.fecha_mod',type:'date'},
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
				filters:{pfiltro:'pcv.usuario_ai',type:'string'},
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
				filters:{pfiltro:'pcv.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
				form:false
		}
	],
	tam_pag:50,	
	title:'PCV',
	ActSave:'../../sis_contabilidad/control/PeriodoCompraVenta/insertarPeriodoCompraVenta',
	ActDel:'../../sis_contabilidad/control/PeriodoCompraVenta/eliminarPeriodoCompraVenta',
	ActList:'../../sis_contabilidad/control/PeriodoCompraVenta/listarPeriodoCompraVenta',
	id_store:'id_periodo_compra_venta',
	fields: [
		{name:'id_periodo_compra_venta', type: 'numeric'},
		{name:'estado', type: 'string'},
		{name:'id_periodo', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_depto', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'periodo','id_gestion',
		{name:'fecha_ini', type: 'date',dateFormat:'Y-m-d'},
		{name:'fecha_fin', type: 'date',dateFormat:'Y-m-d'}
		
	],
	sortInfo:{
		field: 'per.periodo',
		direction: 'ASC'
	},
	
	validarFiltros:function(){
        if(this.cmbGestion.isValid()){
            return true;
        }
        else{
            return false;
        }
        
    },
    
    capturaFiltros:function(combo, record, index){
        //this.desbloquearOrdenamientoGrid();
        this.store.baseParams.id_gestion=this.cmbGestion.getValue();
        this.load(); 
            
        
    },
    onButtonAct:function(){
        if(!this.validarFiltros()){
            alert('Especifique el año antes')
         }
        else{
            this.store.baseParams.id_gestion=this.cmbGestion.getValue();
            Phx.vista.PeriodoCompraVenta.superclass.onButtonAct.call(this);
        }
    },
	
	onReloadPage:function(m){
		this.maestro=m;
		this.store.baseParams={id_depto: this.maestro.id_depto};
		if(!this.validarFiltros()){
            alert('Especifique el año antes')
         }
        else{
           this.store.baseParams.id_gestion=this.cmbGestion.getValue();
           this.load({params:{start:0, limit:50}})
        }
		
	},
	
	generarPeriodos: function(){
		   var id_gestion = this.cmbGestion.getValue(),
		       id_depto = this.maestro.id_depto;
		   
		   if(!this.validarFiltros()){
	            alert('Especifique el año antes');
	            return;
	        }
	        
	        if(!id_depto){
	        	alert('selecione un departamento antes');
	        	return;
	        }
		   
		    Phx.CP.loadingShow();
			Ext.Ajax.request({
				url:'../../sis_contabilidad/control/PeriodoCompraVenta/generarPeriodosCompraVenta',
				params:{
					id_gestion: id_gestion,
					id_depto: this.maestro.id_depto
				},
				success: function(resp){
					Phx.CP.loadingHide();
					var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
					if (reg.ROOT.error) {
						Ext.Msg.alert('Error','Validación no realizada: '+reg.ROOT.error)
					} else {
						this.reload();
						Ext.Msg.alert('Mensaje','Proceso ejecutado con éxito')
					}
				},
				failure: this.conexionFailure,
				timeout: this.timeout,
				scope:this
			});
		
	},
	
	
	onCerrarPeriodo: function(){this.cerrarAbrirPeriodo('cerrar');},
	onCerrarParPeriodo: function(){this.cerrarAbrirPeriodo('cerrar_parcial')},
	onAbrirPeriodo: function(){this.cerrarAbrirPeriodo('abrir')},
	
	cerrarAbrirPeriodo: function(estado){
		var rec = this.sm.getSelected();
	    if(rec){
		    Phx.CP.loadingShow();
			Ext.Ajax.request({
					url : '../../sis_contabilidad/control/PeriodoCompraVenta/cerrarAbrirPeriodo',
					params : {
						id_periodo_compra_venta : rec.data.id_periodo_compra_venta,
						tipo: estado
					},
					success : function(resp){
						Phx.CP.loadingHide();
						var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
						if (reg.ROOT.error) {
							Ext.Msg.alert('Error','no se pudo proceder: '+reg.ROOT.error)
						} else {
							this.reload();
							Ext.Msg.alert('Mensaje','Proceso ejecutado con éxito')
						}
					},
					failure: this.conexionFailure,
					timeout: this.timeout,
					scope:this
				});
		 }
	},
	
	preparaMenu: function(n) {
		var tb = Phx.vista.PeriodoCompraVenta.superclass.preparaMenu.call(this);
	   	this.getBoton('btnCerrarParPeriodo').setDisabled(false);
	   	this.getBoton('btnCerrarPeriodo').setDisabled(false);
	   	this.getBoton('btnAbrirPeriodo').setDisabled(false);
	   	
	   	
  		return tb;
	},
	liberaMenu: function() {
		var tb = Phx.vista.PeriodoCompraVenta.superclass.liberaMenu.call(this);
		this.getBoton('btnCerrarParPeriodo').setDisabled(true);
	   	this.getBoton('btnCerrarPeriodo').setDisabled(true);
	   	this.getBoton('btnAbrirPeriodo').setDisabled(true)
	},
	
	bdel: false,
	bsave: false,
	bnew:  false,
	bedit:  false
	}
)
</script>
		
		