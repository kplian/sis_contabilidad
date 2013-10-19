<?php
/**
*@package pXP
*@file gen-PlantillaComprobante.php
*@author  (admin)
*@date 10-06-2013 14:40:00
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.PlantillaComprobante=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.PlantillaComprobante.superclass.constructor.call(this,config);
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
					name: 'id_plantilla_comprobante'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'codigo',
				fieldLabel: 'Codigo',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			},
			type:'TextField',
			filters:{pfiltro:'cmpb.codigo',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
           config:{
                name:'momento_presupuestario',
                fieldLabel: 'Momento',
                allowBlank: false,
                anchor: '80%',
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store:['contable','presupuestario']
           },
           type:'ComboBox',
           filters:{pfiltro:'cmpb.momento_presupuestario',type:'string'},
           id_grupo:0,
           grid:true,
           form:true
          },
         {
           config:{
                name:'momento_comprometido',
                fieldLabel: 'Compromete',
                allowBlank: false,
                anchor: '80%',
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store:['si','no']
           },
           type:'ComboBox',
           filters:{pfiltro:'cmpb.momento_comprometido',type:'string'},
           id_grupo:0,
           grid:true,
           form:true
          } ,
         {
           config:{
                name:'momento_ejecutado',
                fieldLabel: 'Ejecuta',
                allowBlank: false,
                anchor: '80%',
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store:['si','no']
           },
           type:'ComboBox',
           filters:{pfiltro:'cmpb.momento_ejecutado',type:'string'},
           id_grupo:0,
           grid:true,
           form:true
          },
         {
           config:{
                name:'momento_pagado',
                fieldLabel: 'Paga',
                allowBlank: false,
                anchor: '80%',
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store:['si','no']
           },
           type:'ComboBox',
           filters:{pfiltro:'cmpb.momento_pagado',type:'string'},
           id_grupo:0,
           grid:true,
           form:true
          }, 
		{
			config:{
				name: 'clase_comprobante',
				fieldLabel: 'Clase Comprobante',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			},
			type:'TextField',
			filters:{pfiltro:'cmpb.clase_comprobante',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'tabla_origen',
				fieldLabel: 'Tabla Origen',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			},
			type:'TextField',
			filters:{pfiltro:'cmpb.tabla_origen',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'idtabla',
				fieldLabel: 'Id Tabla',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			},
			type:'TextField',
			filters:{pfiltro:'cmpb.id_tabla',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'campo_subsistema',
				fieldLabel: 'Campo Subsistema',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:200
			},
			type:'TextArea',
			filters:{pfiltro:'cmpb.campo_subsistema',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'campo_depto',
				fieldLabel: 'Campo Depto',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:200
			},
			type:'TextArea',
			filters:{pfiltro:'cmpb.campo_depto',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'campo_acreedor',
				fieldLabel: 'Campo Acreedor',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:200
			},
			type:'TextArea',
			filters:{pfiltro:'cmpb.campo_acreedor',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'campo_descripcion',
				fieldLabel: 'Campo Descripcion',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:200
			},
			type:'TextArea',
			filters:{pfiltro:'cmpb.campo_descripcion',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'campo_fk_comprobante',
				fieldLabel: 'Campo fk Comprobante',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:200
			},
			type:'TextArea',
			filters:{pfiltro:'cmpb.campo_fk_comprobante',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'campo_moneda',
				fieldLabel: 'Campo Moneda',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:200
			},
			type:'TextArea',
			filters:{pfiltro:'cmpb.campo_moneda',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'campo_fecha',
				fieldLabel: 'Campo Fecha',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:200
			},
			type:'TextArea',
			filters:{pfiltro:'cmpb.campo_fecha',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
        {
            config:{
                name: 'campo_gestion_relacion',
                fieldLabel: 'Gestion Rel Contable',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:200
            },
            type:'TextArea',
            filters:{pfiltro:'cmpb.campo_gestion_relacion',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'otros_campos',
                fieldLabel: 'Otros Campos',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:200
            },
            type:'TextArea',
            filters:{pfiltro:'cmpb.otros_campos',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },				
		{
			config:{
				name: 'funcion_comprobante_validado',
				fieldLabel: 'Funcion Comprobante Validado',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextArea',
			filters:{pfiltro:'cmpb.funcion_comprobante_validado',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},				
		{
			config:{
				name: 'funcion_comprobante_eliminado',
				fieldLabel: 'Funcion Comprobante Eliminado',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextArea',
			filters:{pfiltro:'cmpb.funcion_comprobante_eliminado',type:'string'},
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
			filters:{pfiltro:'cmpb.estado_reg',type:'string'},
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
			filters:{pfiltro:'cmpb.fecha_reg',type:'date'},
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
			filters:{pfiltro:'cmpb.fecha_mod',type:'date'},
			id_grupo:1,
			grid:true,
			form:false
		}
	],
	
	title:'Comprobante',
	ActSave:'../../sis_contabilidad/control/PlantillaComprobante/insertarPlantillaComprobante',
	ActDel:'../../sis_contabilidad/control/PlantillaComprobante/eliminarPlantillaComprobante',
	ActList:'../../sis_contabilidad/control/PlantillaComprobante/listarPlantillaComprobante',
	id_store:'id_plantilla_comprobante',
	fields: [
		{name:'id_plantilla_comprobante', type: 'numeric'},
		{name:'codigo', type:'string'},
		{name:'funcion_comprobante_eliminado', type: 'string'},
		{name:'idtabla', type: 'string'},
		{name:'campo_subsistema', type: 'string'},
		{name:'campo_descripcion', type: 'string'},
		{name:'funcion_comprobante_validado', type: 'string'},
		{name:'campo_fecha', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'campo_acreedor', type: 'string'},
		{name:'campo_depto', type: 'string'},
		{name:'momento_presupuestario', type: 'string'},
		{name:'campo_fk_comprobante', type: 'string'},
		{name:'tabla_origen', type: 'string'},
		{name:'clase_comprobante', type: 'string'},
		{name:'campo_moneda', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'campo_gestion_relacion', type: 'string'},
		{name:'otros_campos', type: 'string'},
		{name:'momento_comprometido', type: 'string'},
		{name:'momento_ejecutado', type: 'string'},
		{name:'momento_pagado', type: 'string'}
        
		
	],
	sortInfo:{
		field: 'id_plantilla_comprobante',
		direction: 'ASC'
	},
	
	south : {
			url : '../../../sis_contabilidad/vista/detalle_plantilla_comprobante/DetallePlantillaComprobante.php',
			title : 'Detalle de Comprobante',
			height : '50%',
			cls : 'DetallePlantillaComprobante'
		},
		
	bdel:true,
	bsave:true
	}
)
</script>
		
		