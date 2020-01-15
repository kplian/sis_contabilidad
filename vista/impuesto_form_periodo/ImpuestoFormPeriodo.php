<?php
/**
*@package pXP
*@file gen-ImpuestoFormPeriodo.php
*@author  (miguel.mamani)
*@date 29-07-2019 21:50:27
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ImpuestoFormPeriodo=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.ImpuestoFormPeriodo.superclass.constructor.call(this,config);
		this.init();
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_impuesto_form_periodo'
			},
			type:'Field',
			form:true 
		},
        {
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_impuesto_form'
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
            config:{
                name: 'periodo',
                fieldLabel: 'Periodo',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                renderer:function(value, p, record){

                    var mes = ['ENERO','FEBRERO','MARZO','ABRIL','MAYO','JUNIO','JULIO','AGOSTO','SEPTIEMBRE','OCTUBRE','NOVIEMBRE','DICIEMBRE'];
                    return String.format('<b>{0}</b>', mes[record.data['periodo'] - 1]);
                }
            },
            type:'TextField',
            id_grupo:1,
            grid:true
        },
        {
            config:{
                name: 'importe',
                fieldLabel: 'Importe',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100
            },
            type:'NumberField',
            filters:{pfiltro:'ifp.importe',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true,
            egrid:true
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
				filters:{pfiltro:'ifp.estado_reg',type:'string'},
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
				filters:{pfiltro:'ifp.fecha_reg',type:'date'},
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
				filters:{pfiltro:'ifp.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'ifp.usuario_ai',type:'string'},
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
				filters:{pfiltro:'ifp.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Impuesto Form Periodo',
	ActSave:'../../sis_contabilidad/control/ImpuestoFormPeriodo/insertarImpuestoFormPeriodo',
	ActDel:'../../sis_contabilidad/control/ImpuestoFormPeriodo/eliminarImpuestoFormPeriodo',
	ActList:'../../sis_contabilidad/control/ImpuestoFormPeriodo/listarImpuestoFormPeriodo',
	id_store:'id_impuesto_form_periodo',
	fields: [
		{name:'id_impuesto_form_periodo', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_impuesto_form', type: 'numeric'},
		{name:'id_periodo', type: 'numeric'},
		{name:'importe', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
        {name:'usr_mod', type: 'numeric'},
        {name:'periodo', type: 'numeric'}
		
	],
	sortInfo:{
		field: 'periodo',
		direction: 'ASC'
	},
	bdel:false,
	bsave:true,
    bnew:false,
    bedit:false,
    bexcel: false,
    onReloadPage: function (m) {
        this.maestro = m;
        this.store.baseParams = {id_impuesto_form: this.maestro.id_impuesto_form};
        this.load({params: {start: 0, limit: 50}});
    },
    loadValoresIniciales: function () {
        this.Cmp.id_impuesto_form.setValue(this.maestro.id_impuesto_form);
        Phx.vista.ImpuestoFormPeriodo.superclass.loadValoresIniciales.call(this);
    },
	}
)
</script>
		
		