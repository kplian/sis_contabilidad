<?php
/**
*@package pXP
*@file gen-TablaRelacionContable.php
*@author  (admin)
*@date 16-05-2013 21:05:26
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.TablaRelacionContable=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.TablaRelacionContable.superclass.constructor.call(this,config);
		this.init();
		this.iniciarEventos();
		this.load({params:{start:0, limit:this.tam_pag}})
	},
	tam_pag:50,
		
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_tabla_relacion_contable'
			},
			type:'Field',
			form:true 
		},
		
		{
			config:{
				name: 'esquema',
				origen:'SUBSISTEMA',
	   			tinit:false,
				fieldLabel: 'Sistema',
				gdisplayField:'desc_subsistema',//mapea al store del grid
				allowBlank: false,
				gwidth: 200,
				//renderer:function (value, p, record){return String.format('{0}', record.data['desc_subsistema']);},
				valueField: 'codigo',
       			displayField: 'codigo',
       			gdisplayField: 'esquema',
       			hiddenName: 'esquema'
			},
			type:'ComboRec',			
			filters:{pfiltro:'tabrecon.esquema',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		
		{
			config:{
				name:'tabla',
				fieldLabel:'Tabla',
				allowBlank:false,
				emptyText:'Tabla...',
				store:new Ext.data.JsonStore({
					url: '../../sis_generador/control/Tabla/listarTablaCombo',
					id: 'oid_tabla',
					root: 'datos',
					sortInfo:{
						field: 'nombre',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['oid_tabla','nombre'],
					// turn on remote sorting
					remoteSort: true,
					baseParams:{par_filtro:'c.relname'}
				}),
				valueField: 'nombre',
				displayField: 'nombre',
				gdisplayField:'tabla',
				hiddenName: 'tabla',
				forceSelection:true,
				typeAhead: false,
    			triggerAction: 'all',
    			lazyRender:true,
				mode:'remote',
				pageSize:50,
				queryDelay:500,
				width:210,
				gwidth:220,
				minChars:2,
				listWidth:280
			},
			type:'ComboBox',
			id_grupo:0,
			filters:{	
		        pfiltro:'tabrecon.tabla',
				type:'string'
			},
			
			grid:true,
			form:true
	},
	{
			config:{
				name: 'tabla_id',
				fieldLabel: 'Id de la Tabla',
				allowBlank: false,
				anchor: '80%',
				gwidth: 150,
				maxLength:200
			},
			type:'TextField',
			filters:{pfiltro:'tabrecon.tabla_id',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'tabla_id_fk',
				fieldLabel: 'Id Padre (árbol)',
				allowBlank: true,
				anchor: '80%',
				gwidth: 150,
				maxLength:200
			},
			type:'TextField',
			filters:{pfiltro:'tabrecon.tabla_id_fk',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config: {
				name: 'recorrido_arbol',
				fieldLabel: 'Recorrido árbol',
				anchor: '100%',
				tinit: false,
				allowBlank: true,
				origen: 'CATALOGO',
				gdisplayField: 'recorrido_arbol',
				gwidth: 100,
				baseParams:{
						cod_subsistema:'PARAM',
						catalogo_tipo:'tgral__direc'
				},
				renderer:function (value, p, record){return String.format('{0}', record.data['recorrido_arbol']);}
			},
			type: 'ComboRec',
			id_grupo: 0,
			filters:{pfiltro:'tabrecon.recorrido_arbol',type:'string'},
			grid: true,
			form: true
		},
        
        {
            config:{
                name: 'tabla_id_auxiliar',
                fieldLabel: 'ID auxiliar',
                qtip:'hace referencia al nombre de campo que contiene id del auxiliar',
                allowBlank: true,
                anchor: '80%',
                gwidth: 150,
                maxLength:200
            },
            type:'TextField',
            filters:{pfiltro:'tabrecon.tabla_id',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
		
		{
            config:{
                name: 'tabla_codigo_auxiliar',
                fieldLabel: 'Codigo auxiliar',
                qtip:'hace referencia al nombre de campo que contiene codigo del auxiliar. (Si no encuentra un id pasa a la busqueda por codigo)',
                allowBlank: true,
                anchor: '80%',
                gwidth: 150,
                maxLength:200
            },
            type:'TextField',
            filters:{pfiltro:'tabrecon.tabla_id',type:'string'},
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
			filters:{pfiltro:'tabrecon.estado_reg',type:'string'},
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
			filters:{pfiltro:'tabrecon.fecha_reg',type:'date'},
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
			type:'NumberField',
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
			filters:{pfiltro:'tabrecon.fecha_mod',type:'date'},
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
			type:'NumberField',
			filters:{pfiltro:'usu2.cuenta',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		}
	],
	
	title:'Tabla Relación Contable',
	ActSave:'../../sis_contabilidad/control/TablaRelacionContable/insertarTablaRelacionContable',
	ActDel:'../../sis_contabilidad/control/TablaRelacionContable/eliminarTablaRelacionContable',
	ActList:'../../sis_contabilidad/control/TablaRelacionContable/listarTablaRelacionContable',
	id_store:'id_tabla_relacion_contable',
	fields: [
		{name:'id_tabla_relacion_contable', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'tabla', type: 'string'},
		{name:'tabla_id', type: 'string'},
		{name:'esquema', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'recorrido_arbol', type: 'string'},
		'tabla_codigo_auxiliar',
        'tabla_id_auxiliar'
	],
	sortInfo:{
		field: 'id_tabla_relacion_contable',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
	iniciarEventos : function () {
		this.Cmp.esquema.on('select',this.onSubsistemaSelect, this);
		
	},
	onSubsistemaSelect : function(s,r,i){	
		this.Cmp.tabla.getStore().baseParams.esquema=r.data.codigo;
	    this.Cmp.tabla.reset();
	    this.Cmp.tabla.modificado = true;		
	},	
	east:
          { 
          url:'../../../sis_contabilidad/vista/tipo_relacion_contable/TipoRelacionContableTabla.php',
          title:'Tipo Relacion Contable', 
          width:'60%',
          cls:'TipoRelacionContableTabla'
         }
})
</script>
		
		