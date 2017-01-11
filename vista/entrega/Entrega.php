<?php
/**
*@package pXP
*@file gen-Entrega.php
*@author  (admin)
*@date 17-11-2016 19:50:19
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Entrega=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
    	this.initButtons = [this.cmbDepto];
		Phx.vista.Entrega.superclass.constructor.call(this,config);
		
        
        this.addButton('fin_entrega', {
				text : 'Finalizar Entrega',
				iconCls : 'btag_accept',
				disabled : true,
				handler : this.cambiarEstado,
				tooltip: '<b>Finaliza la entrega, defini el nro de Cbte relacionado en SIGMA/SIGEP/OTRO</b>' 
			});
			
		//Botón para Imprimir el Comprobante
		this.addButton('btnImprimir', {
				text : 'Imprimir',
				iconCls : 'bprint',
				disabled : true,
				handler : this.imprimirCbte,
				tooltip : '<b>Imprimir Reporte de Entrega</b><br/>Imprime un detalle de las factidas presupeustarias relacioandas a la entrega'
		});
				
		this.init();
		this.bloquearOrdenamientoGrid();
        this.cmbDepto.on('clearcmb', function() {
				this.DisableSelect();
				this.store.removeAll();
			}, this);
			
		this.cmbDepto.on('valid', function() {
				this.capturaFiltros();				
		}, this);	
			
	},
	
	
	
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
			enableMultiSelect : false,
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
			
	Atributos:[
		
		{
			config:{
				name: 'id_entrega',
				fieldLabel: 'Nro',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:200
			},
				type:'TextField',
				filters:{pfiltro:'ent.id_entrega',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'c31',
				fieldLabel: 'Nro C31',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:200
			},
				type:'TextField',
				filters:{pfiltro:'ent.c31',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'fecha_c31',
				fieldLabel: 'Fecha C31',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'ent.fecha_c31',type:'date'},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'estado',
				fieldLabel: 'Estado',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:20
			},
				type:'TextField',
				filters:{pfiltro:'ent.estado',type:'string'},
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
				filters:{pfiltro:'ent.estado_reg',type:'string'},
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
				filters:{pfiltro:'ent.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'ent.usuario_ai',type:'string'},
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
				filters:{pfiltro:'ent.fecha_reg',type:'date'},
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
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'ent.fecha_mod',type:'date'},
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
		}
	],
	tam_pag:50,	
	title:'Entrega',
	ActSave:'../../sis_contabilidad/control/Entrega/insertarEntrega',
	ActDel:'../../sis_contabilidad/control/Entrega/eliminarEntrega',
	ActList:'../../sis_contabilidad/control/Entrega/listarEntrega',
	id_store:'id_entrega',
	fields: [
		{name:'id_entrega', type: 'numeric'},
		{name:'fecha_c31', type: 'date',dateFormat:'Y-m-d'},
		{name:'c31', type: 'string'},
		{name:'estado', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'id_depto_conta'
		
	],
	sortInfo:{
		field: 'id_entrega',
		direction: 'ASC'
	},
	south : {
			url : '../../../sis_contabilidad/vista/entrega_det/EntregaDet.php',
			title : 'Detalle',
			height : '50%', //altura de la ventana hijo
			cls : 'EntregaDet'
		},
	//para retroceder de estado
    cambiarEstado:function(res){
         var rec=this.sm.getSelected(),
             obsValorInicial;
             Phx.CP.loadWindows('../../../sis_contabilidad/vista/entrega/EntregaForm.php',
            'Estado de Wf',
            {   modal: true,
                width: '70%',
                height: '70%'
            }, 
            {    data: rec.data }, this.idContenedor,'EntregaForm',
            {
                config:[{
                          event:'beforesave',
                          delegate: this.onCambiartEstado,
                        }
                        ],
               scope:this
           });
   },
   
    onCambiartEstado: function(wizard,resp){
            Phx.CP.loadingShow();
            var operacion = 'cambiar';
            Ext.Ajax.request({
                url:'../../sis_contabilidad/control/Entrega/cambiarEstado',
                params:{
                        id_entrega: resp.id_entrega,
                        c31:  resp.c31,
                        fecha_c31:  resp.fecha_c31,  
                        id_tipo_relacion_comprobante:  resp.id_tipo_relacion_comprobante,    
                        obs: resp.obs
                 },
                argument: { wizard: wizard },  
                success: this.successEstadoSinc,
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope: this
            });
           
    },
    successEstadoSinc:function(resp){
        Phx.CP.loadingHide();
        resp.argument.wizard.panel.destroy()
        this.reload();
    },
    
    preparaMenu : function(n) {
			var tb = Phx.vista.Entrega.superclass.preparaMenu.call(this,n);
			var rec=this.sm.getSelected();
			if(rec.data.estado == 'finalizado'){
				this.getBoton('fin_entrega').disable();
			}else{
				this.getBoton('fin_entrega').enable();
			}
			
			this.getBoton('btnImprimir').enable();
			
			return tb;
	},
	liberaMenu : function() {
			var tb = Phx.vista.Entrega.superclass.liberaMenu.call(this);
			this.getBoton('fin_entrega').disable();
			this.getBoton('btnImprimir').disable();
			
	},  
	capturaFiltros : function(combo, record, index) {
			this.desbloquearOrdenamientoGrid();
			this.store.baseParams.id_depto = this.cmbDepto.getValue();
			this.store.baseParams.nombreVista = this.nombreVista
			this.load();
		},

	validarFiltros : function() {
			if (this.cmbDepto.getValue() != '' ) {			
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
	imprimirCbte : function() {
			var rec = this.sm.getSelected();
			var data = rec.data;
			if (data) {
				Phx.CP.loadingShow();
				Ext.Ajax.request({
					url : '../../sis_contabilidad/control/Entrega/reporteEntrega',
					params : {
						'id_entrega' : data.id_entrega
					},
					success : this.successExport,
					failure : this.conexionFailure,
					timeout : this.timeout,
					scope : this
				});
			}

		},	
	bdel: true,
	bsave: false,
	bnew: false,
	bedit: false
})
</script>