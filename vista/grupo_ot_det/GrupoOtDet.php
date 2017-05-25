<?php
/**
*@package pXP
*@file gen-GrupoOtDet.php
*@author  (admin)
*@date 06-10-2014 14:44:23
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.GrupoOtDet=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.GrupoOtDet.superclass.constructor.call(this,config);
		this.init();
		this.bloquearMenus();
		
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_grupo_ot_det'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_grupo_ot'
			},
			type:'Field',
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
				filters:{pfiltro:'gotd.estado_reg',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
        {
            config:{
                    name:'id_orden_trabajo',
                    fieldLabel: 'Orden Trabajo',
                    sysorigen:'sis_contabilidad',
	       		    origen:'OT',
                    allowBlank:true,
                    gwidth:200,
                    renderer:function(value, p, record){return String.format('{0}', record.data['desc_orden']);}
            
            },
            type:'ComboRec',
            id_grupo:0,
            filters:{pfiltro:'ot.motivo_orden#ot.desc_orden',type:'string'},
            bottom_filter : true,
            grid:true,
            form:true
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
				filters:{pfiltro:'gotd.fecha_reg',type:'date'},
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
				filters:{pfiltro:'gotd.usuario_ai',type:'string'},
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
				name: 'id_usuario_ai',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'gotd.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'gotd.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Ordenes de Trabajo Agrupadas',
	ActSave:'../../sis_contabilidad/control/GrupoOtDet/insertarGrupoOtDet',
	ActDel:'../../sis_contabilidad/control/GrupoOtDet/eliminarGrupoOtDet',
	ActList:'../../sis_contabilidad/control/GrupoOtDet/listarGrupoOtDet',
	id_store:'id_grupo_ot_det',
	fields: [
		{name:'id_grupo_ot_det', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_orden_trabajo', type: 'numeric'},
		{name:'id_grupo_ot', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		'motivo_orden','desc_orden'
		
	],
	sortInfo:{
		field: 'id_grupo_ot_det',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
	
	onReloadPage:function(m){
		this.maestro=m;
		this.store.baseParams={id_grupo_ot:this.maestro.id_grupo_ot};
		this.load({params:{start:0, limit:50}})
		
	},
	loadValoresIniciales:function()
	{
		Phx.vista.GrupoOtDet.superclass.loadValoresIniciales.call(this);
		this.getComponente('id_grupo_ot').setValue(this.maestro.id_grupo_ot);		
	}
	
})
</script>
		
		