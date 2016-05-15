<?php
/**
*@package pXP
*@file gen-OficinaOt.php
*@author  (jrivera)
*@date 09-10-2015 18:48:40
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.OficinaOt=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.OficinaOt.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_oficina_ot'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'id_oficina',
				fieldLabel: 'Oficina',
				allowBlank: false,
				emptyText:'Oficina...',
				store:new Ext.data.JsonStore(
				{
					url: '../../sis_organigrama/control/Oficina/listarOficina',
					id: 'id_oficina',
					root: 'datos',
					sortInfo:{
						field: 'nombre',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_oficina','nombre','codigo','nombre_lugar'],
					// turn on remote sorting
					remoteSort: true,
					baseParams:{par_filtro:'ofi.nombre'}
				}),
				valueField: 'id_oficina',
				displayField: 'nombre',
				gdisplayField:'nombre_oficina',
				hiddenName: 'id_oficina',
    			triggerAction: 'all',
    			lazyRender:true,
				mode:'remote',
				pageSize:50,
				queryDelay:500,
				anchor:"100%",
				gwidth:150,
				minChars:2,
				tpl:'<tpl for="."><div class="x-combo-list-item"><p>{codigo}</p><p>{nombre}</p><p>{nombre_lugar}</p> </div></tpl>',
				renderer:function (value, p, record){return String.format('{0}', record.data['nombre_oficina']);}
			},
			type:'ComboBox',
			filters:{pfiltro:'ofi.nombre',type:'string'},
			id_grupo:0,
			grid:true,
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
                    baseParams:{par_filtro:'desc_orden#motivo_orden'},
                    renderer:function(value, p, record){return String.format('{0}', record.data['desc_orden']);}
            
            },
            type:'ComboRec',
            id_grupo:0,
            filters:{pfiltro:'ot.motivo_orden#ot.desc_orden',type:'string'},
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
				filters:{pfiltro:'ofot.estado_reg',type:'string'},
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
				filters:{pfiltro:'ofot.usuario_ai',type:'string'},
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
				filters:{pfiltro:'ofot.fecha_reg',type:'date'},
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
				filters:{pfiltro:'ofot.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'ofot.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Ot por Oficina',
	ActSave:'../../sis_contabilidad/control/OficinaOt/insertarOficinaOt',
	ActDel:'../../sis_contabilidad/control/OficinaOt/eliminarOficinaOt',
	ActList:'../../sis_contabilidad/control/OficinaOt/listarOficinaOt',
	id_store:'id_oficina_ot',
	fields: [
		{name:'id_oficina_ot', type: 'numeric'},
		{name:'id_oficina', type: 'numeric'},
		{name:'id_orden_trabajo', type: 'numeric'},
		{name:'desc_orden', type: 'string'},
		{name:'nombre_oficina', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
	],
	sortInfo:{
		field: 'id_oficina_ot',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true
	}
)
</script>
		
		