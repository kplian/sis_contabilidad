<?php
/**
*@package pXP
*@file gen-AnexoCabecera.php
*@author  (miguel.mamani)
*@date 21-08-2019 15:03:21
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.AnexoCabecera=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
        this.idContenedor = config.idContenedor;
        this.maestro = config;
        //llama al constructor de la clase padre
		Phx.vista.AnexoCabecera.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag,id_reporte_anexos: this.maestro.id_reporte_anexos}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_anexo_cabecera'
			},
			type:'Field',
			form:true 
		},
        {
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_reporte_anexos'
			},
			type:'Field',
			form:true
		},
        {
            config:{
                name: 'orden',
                fieldLabel: 'Orden',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:100
            },
            type:'NumberField',
            filters:{pfiltro:'aoa.orden',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'codigo',
                fieldLabel: 'Codigo',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:200
            },
            type:'TextField',
            filters:{pfiltro:'aoa.codigo',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'titulo',
                fieldLabel: 'Titulo',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:200
            },
            type:'TextField',
            filters:{pfiltro:'aoa.titulo',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'subtitulo',
                fieldLabel: 'Subtitulo',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:200
            },
            type:'TextField',
            filters:{pfiltro:'aoa.subtitulo',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'formula',
                fieldLabel: 'Formula',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:50
            },
            type:'TextField',
            filters:{pfiltro:'aoa.formula',type:'string'},
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
				filters:{pfiltro:'aoa.estado_reg',type:'string'},
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
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'aoa.fecha_reg',type:'date'},
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
				filters:{pfiltro:'aoa.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'aoa.usuario_ai',type:'string'},
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
				filters:{pfiltro:'aoa.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Anexo Cabecera',
	ActSave:'../../sis_contabilidad/control/AnexoCabecera/insertarAnexoCabecera',
	ActDel:'../../sis_contabilidad/control/AnexoCabecera/eliminarAnexoCabecera',
	ActList:'../../sis_contabilidad/control/AnexoCabecera/listarAnexoCabecera',
	id_store:'id_anexo_cabecera',
	fields: [
		{name:'id_anexo_cabecera', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'codigo', type: 'string'},
		{name:'titulo', type: 'string'},
		{name:'subtitulo', type: 'string'},
		{name:'formula', type: 'string'},
		{name:'id_reporte_anexos', type: 'numeric'},
		{name:'orden', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
	],
	sortInfo:{
		field: 'id_anexo_cabecera',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
    loadValoresIniciales: function () {
        this.Cmp.id_reporte_anexos.setValue(this.maestro.id_reporte_anexos);
        Phx.vista.AnexoCabecera.superclass.loadValoresIniciales.call(this);
    }
	}
)
</script>
		
		