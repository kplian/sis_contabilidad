<?php
/**
*@package pXP
*@file gen-ClaseComprobante.php
*@author  (admin)
*@date 27-05-2013 16:07:00
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ClaseComprobante=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.ClaseComprobante.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
	},
	tam_pag:50,
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_clase_comprobante'
			},
			type:'Field',
			form:true 
		},
		
		{
			config:{
				name: 'tipo_comprobante',
				fieldLabel: 'Tipo',
				allowBlank: true,
				anchor: '80%',
				gwidth: 200,
				maxLength:300
			},
			type:'TextField',
			filters:{pfiltro:'ccom.tipo_comprobante',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'descripcion',
				fieldLabel: 'Descripcion',
				allowBlank: true,
				anchor: '80%',
				gwidth: 200,
				maxLength:300
			},
			type:'TextField',
			filters:{pfiltro:'ccom.descripcion',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
            config:{
                name:'id_documento',
                fieldLabel:'Documento',
                allowBlank:false,
                emptyText:'Documento...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_parametros/control/Documento/listarDocumento',
                    id: 'id_documento',
                    root: 'datos',
                    sortInfo:{
                        field: 'codigo',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_documento','codigo','descripcion'],
                    // turn on remote sorting
                    remoteSort: true,
                    baseParams:{par_filtro:'DOCUME.codigo#DOCUME.descripcion',codigosis:'CONTA'}
                }),
                valueField: 'id_documento',
                displayField: 'descripcion',
                gdisplayField:'desc_doc',//mapea al store del grid
                tpl:'<tpl for="."><div class="x-combo-list-item"><p>({codigo}) {descripcion}</p> </div></tpl>',
                hiddenName: 'id_documento',
                forceSelection:true,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode:'remote',
                pageSize:10,
                queryDelay:1000,
                minListWidth :280,
                width:250,
                gwidth:250,
                minChars:2,
                renderer:function (value, p, record){return String.format('{0}', record.data['desc_doc']);}
            },
            type:'ComboBox',
            id_grupo:0,
            filters:{   
                        pfiltro:'doc.descripcion',
                        type:'string'
                    },
           
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
			filters:{pfiltro:'ccom.estado_reg',type:'string'},
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
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
			type:'DateField',
			filters:{pfiltro:'ccom.fecha_reg',type:'date'},
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
			filters:{pfiltro:'ccom.fecha_mod',type:'date'},
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
	
	title:'Clase Comprobante',
	ActSave:'../../sis_contabilidad/control/ClaseComprobante/insertarClaseComprobante',
	ActDel:'../../sis_contabilidad/control/ClaseComprobante/eliminarClaseComprobante',
	ActList:'../../sis_contabilidad/control/ClaseComprobante/listarClaseComprobante',
	id_store:'id_clase_comprobante',
	fields: [
		{name:'id_clase_comprobante', type: 'numeric'},
		{name:'id_documento', type: 'numeric'},
		{name:'tipo_comprobante', type: 'string'},
		{name:'descripcion', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'desc_doc'
		
	],
	sortInfo:{
		field: 'id_clase_comprobante',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true
	}
)
</script>
		
		