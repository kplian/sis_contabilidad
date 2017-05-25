<?php
/**
*@package pXP
*@file gen-Ajuste.php
*@author  (admin)
*@date 10-12-2015 15:16:16
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Ajuste=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.Ajuste.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}});
		
		this.addButton('btnGencbte',
            {
                text: 'Generar Cbte',
                iconCls: 'bchecklist',
                disabled: true,
                handler: this.generarComprobante,
                tooltip: '<b>Generar Comprobante</b><br/>Generar cbte de  ajuste'
            }
        );
        
        
	},
			
	Atributos:[
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
				name: 'estado',
				fieldLabel: 'Estado',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:20
			},
				type:'TextField',
				filters:{pfiltro:'ajt.estado',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		}, 
		{
			config : {
				name : 'id_depto_conta',
				hiddenName : 'id_depto_conta',
				url : '../../sis_parametros/control/Depto/listarDeptoFiltradoXUsuario',
				origen : 'DEPTO',
				allowBlank : false,
				fieldLabel : 'Depto',
				gdisplayField : 'desc_depto', //dibuja el campo extra de la consulta al hacer un inner join con orra tabla
				width : 250,
				gwidth : 280,
				baseParams : {
					estado : 'activo',
					codigo_subsistema : 'CONTA'
				}, //parametros adicionales que se le pasan al store
				renderer : function(value, p, record) {
					return String.format('({0}) - {1}',  record.data['codigo_depto'], record.data['desc_depto']);
				}
			},
			//type:'TrigguerCombo',
			type : 'ComboRec',
			id_grupo : 0,
			filters : {
				pfiltro : 'dep.nombre',
				type : 'string'
			},
			grid : true,
			form : true
		},
		{
	       		config:{
	       			name:'tipo',
	       			fieldLabel:'Tipo',
	       			allowBlank:false,
	       			emptyText:'Tipo...',
	       			typeAhead: true,
	       		    triggerAction: 'all',
	       		    lazyRender:true,
	       		    mode: 'local',
	       		    valueField: 'tipo',
	       		    store:['bancos','cajas','manual']
	       		    
	       		},
	       		type:'ComboBox',
	       		id_grupo:0,
	       		filters:{	
	       		         type: 'list',
	       				 options: ['bancos','cajas','manual'],	
	       		 	},
	       		grid:true,
	       		form:true
	    },
		{
			config:{
				name: 'fecha',
				fieldLabel: 'Fecha Ajuste',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'ajt.fecha',type:'date'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'obs',
				fieldLabel: 'Obs',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
				type:'TextArea',
				filters:{pfiltro:'ajt.obs',type:'string'},
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
				filters:{pfiltro:'ajt.estado_reg',type:'string'},
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
				filters:{pfiltro:'ajt.fecha_reg',type:'date'},
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
				filters:{pfiltro:'ajt.fecha_mod',type:'date'},
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
				name: 'id_usuario_ai',
				fieldLabel: '',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'ajt.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'ajt.usuario_ai',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Ajuste',
	ActSave:'../../sis_contabilidad/control/Ajuste/insertarAjuste',
	ActDel:'../../sis_contabilidad/control/Ajuste/eliminarAjuste',
	ActList:'../../sis_contabilidad/control/Ajuste/listarAjuste',
	id_store:'id_ajuste',
	fields: [
		{name:'id_ajuste', type: 'numeric'},
		{name:'fecha', type: 'date',dateFormat:'Y-m-d'},
		{name:'id_depto_conta', type: 'numeric'},
		{name:'estado', type: 'string'},
		{name:'obs', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'nombre_corto','desc_depto','codigo_depto','tipo'
		
	],
	
	generarComprobante:function(){
		
		Phx.CP.loadingShow();
		var rec = this.sm.getSelected(),
		    data = rec.data;
	  
        Ext.Ajax.request({
            url:'../../sis_contabilidad/control/Ajuste/generarCbte',
            params:{ id_ajuste: data.id_ajuste},
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
    
    preparaMenu:function(tb){
        Phx.vista.Ajuste.superclass.preparaMenu.call(this,tb)
        var rec = this.sm.getSelected();
		if(rec.data.estado == 'borrador'){
        	this.getBoton('btnGencbte').enable();
        	this.getBoton('del').enable();
        }
        else{
        	this.getBoton('btnGencbte').disable();
        	this.getBoton('del').disable();
        }
        
          
    },
    
    liberaMenu:function(tb){
        Phx.vista.Ajuste.superclass.liberaMenu.call(this,tb);
        this.getBoton('btnGencbte').disable();
                    
    },
	
	
	
	
	sortInfo:{
		field: 'id_ajuste',
		direction: 'ASC'
	},
	
	south : {
			url : '../../../sis_contabilidad/vista/ajuste_det/AjusteDet.php',
			title : 'Cuentas para ajustar',
			height : '50%',
			cls : 'AjusteDet'
		},
		
	bdel:true,
	bsave:true,
	bedit: false
	}
)
</script>
		
		