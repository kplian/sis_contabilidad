<?php
/**
*@package pXP
*@file gen-ResultadoPlantilla.php
*@author  (admin)
*@date 08-07-2015 13:12:43
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ResultadoPlantilla=Ext.extend(Phx.gridInterfaz,{
    nombreVista: 'ResultadoPlantilla',
	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.ResultadoPlantilla.superclass.constructor.call(this,config);
		this.init();
		//Botón para Validación del Comprobante
		this.addButton('btnClonar',
			{
				text: 'Clonar',
				iconCls: 'bchecklist',
				disabled: true,
				handler: this.clonar,
				tooltip: '<b>Clonar</b><br/>Clona la plantilla, su detalle y dependencias'
			}
		);
		this.load({params:{start:0, limit:this.tam_pag}});
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_resultado_plantilla'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'codigo',
				fieldLabel: 'codigo',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
				type:'TextField',
				filters:{pfiltro:'resplan.codigo',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'nombre',
				fieldLabel: 'nombre',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
				type:'TextField',
				filters:{pfiltro:'resplan.nombre',type:'string'},
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
				filters:{pfiltro:'resplan.estado_reg',type:'string'},
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
				name: 'usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
				type:'TextField',
				filters:{pfiltro:'resplan.usuario_ai',type:'string'},
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
				filters:{pfiltro:'resplan.fecha_reg',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'resplan.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'resplan.fecha_mod',type:'date'},
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
	title:'Plantilla de Resultados',
	ActSave:'../../sis_contabilidad/control/ResultadoPlantilla/insertarResultadoPlantilla',
	ActDel:'../../sis_contabilidad/control/ResultadoPlantilla/eliminarResultadoPlantilla',
	ActList:'../../sis_contabilidad/control/ResultadoPlantilla/listarResultadoPlantilla',
	id_store:'id_resultado_plantilla',
	fields: [
		{name:'id_resultado_plantilla', type: 'numeric'},
		{name:'codigo', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'nombre', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
	],
	sortInfo:{
		field: 'id_resultado_plantilla',
		direction: 'ASC'
	},
	clonar: function(){
		Ext.Msg.confirm('Confirmación','¿Está seguro de clonar esta plantilla?',function(btn){
			var rec=this.sm.getSelected();
			Phx.CP.loadingShow();
			Ext.Ajax.request({
				url:'../../sis_contabilidad/control/ResultadoPlantilla/clonarPlantilla',
				params:{
					id_resultado_plantilla: rec.data.id_resultado_plantilla
				},
				success: function(resp){
					Phx.CP.loadingHide();
					var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
					if (reg.ROOT.error) {
						Ext.Msg.alert('Error','Clonación no realizada: '+reg.ROOT.error)
					} else {
						this.reload();
						Ext.Msg.alert('Mensaje','Proceso ejecutado con éxito')
					}
				},
				failure: this.conexionFailure,
				timeout: this.timeout,
				scope:this
			});
		}, this)
	},
	preparaMenu: function(n) {
		var tb = Phx.vista.ResultadoPlantilla.superclass.preparaMenu.call(this);
	   	this.getBoton('btnClonar').setDisabled(false);
  		return tb;
	},
	liberaMenu: function() {
		var tb = Phx.vista.ResultadoPlantilla.superclass.liberaMenu.call(this);
		this.getBoton('btnClonar').setDisabled(true);
		return tb;
	},
	tabeast:[
	      {
			url : '../../../sis_contabilidad/vista/resultado_det_plantilla/ResultadoDetPlantilla.php',
			title : 'Detalle de Comprobante',
			width:'70%',
			cls : 'ResultadoDetPlantilla'
		  },
		  {
		   url:'../../../sis_contabilidad/vista/resultado_dep/ResultadoDep.php',
		   title: 'Dependencias', 
		   width:'70%',
		   cls: 'ResultadoDep'
		 }],
	bdel:true,
	bsave:true
	}
)
</script>
		
		