<?php
/**
*@package pXP
*@file gen-ReporteAnexos.php
*@author  (miguel.mamani)
*@date 10-06-2019 21:31:03
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ReporteAnexos=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
        this.initButtons=[this.cmbGestion];
        //llama al constructor de la clase padre
		Phx.vista.ReporteAnexos.superclass.constructor.call(this,config);
        this.cmbGestion.on('select', function(combo, record, index){
            this.tmpGestion = record.data.gestion;
            this.capturaFiltros();
        },this);
		this.init();
        this.addButton('onForm',{
            text :'Formularios',
            iconCls : 'bcancelfile',
             disabled: false,
            handler : this.onFormularios
        });
        this.addButton('Imprir',{
            text: 'Imprimir',
            iconCls: 'bexcel',
            disabled: false,
            handler:
            this.onImprimit});
        this.addButton('cabecera',{
            text: 'Cabecera',
            iconCls: 'bchecklist',
            disabled: false,
            handler: this.onButtonCabecera,
            scope:this
        });
	},
			
	Atributos:[
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
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_gestion'
			},
			type:'Field',
			form:true
		},
        {
            config:{
                name: 'ordenar',
                fieldLabel: 'Ordenar',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:50
            },
            type:'NumberField',
            filters:{pfiltro:'ras.ordenar',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name:'tipo',
                fieldLabel:'Tipo',
                allowBlank:false,
                emptyText:'visible...',
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                gwidth: 100,
                store:new Ext.data.ArrayStore({
                    fields: ['ID', 'valor'],
                    data :	[['vertical','vertical'],
                        ['horizontal','horizontal']]

                }),
                valueField:'ID',
                value:'horizontal',
                displayField:'valor'
            },
            type:'ComboBox',
            id_grupo:0,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'header',
                fieldLabel: 'Header',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:50
            },
            type:'TextField',
            filters:{pfiltro:'ras.header',type:'string'},
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
				maxLength:100
			},
				type:'TextField',
				filters:{pfiltro:'ras.titulo',type:'string'},
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
                maxLength:50
            },
            type:'TextField',
            filters:{pfiltro:'ras.codigo',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name:'visible',
                fieldLabel:'Visible',
                allowBlank:false,
                emptyText:'visible...',
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                gwidth: 100,
                store:new Ext.data.ArrayStore({
                    fields: ['ID', 'valor'],
                    data :	[['si','si'],
                        ['no','no']]

                }),
                valueField:'ID',
                value:'si',
                displayField:'valor'
            },
            type:'ComboBox',
            id_grupo:0,
            grid:true,
            form:true
        },
        {
            config:{
                name:'funcion',
                fieldLabel:'Funcion',
                allowBlank:false,
                emptyText:'Funcion...',
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                gwidth: 100,
                store:new Ext.data.ArrayStore({
                    fields: ['ID', 'valor'],
                    data :	[['si','si'],
                        ['no','no']]

                }),
                valueField:'ID',
                value:'no',
                displayField:'valor'
            },
            type:'ComboBox',
            id_grupo:0,
            grid:true,
            form:true
        },
		{
			config:{
				name: 'nombre_funcion',
				fieldLabel: 'Nombre Funcion',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:50
			},
				type:'TextField',
				filters:{pfiltro:'ras.nombre_funcion',type:'string'},
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
				filters:{pfiltro:'ras.estado_reg',type:'string'},
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
				filters:{pfiltro:'ras.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'ras.usuario_ai',type:'string'},
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
				filters:{pfiltro:'ras.fecha_reg',type:'date'},
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
				filters:{pfiltro:'ras.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Reporte Anexos',
	ActSave:'../../sis_contabilidad/control/ReporteAnexos/insertarReporteAnexos',
	ActDel:'../../sis_contabilidad/control/ReporteAnexos/eliminarReporteAnexos',
	ActList:'../../sis_contabilidad/control/ReporteAnexos/listarReporteAnexos',
	id_store:'id_reporte_anexos',
	fields: [
		{name:'id_reporte_anexos', type: 'numeric'},
        {name:'ordenar', type: 'numeric'},
		{name:'titulo', type: 'string'},
		{name:'funcion', type: 'string'},
		{name:'codigo', type: 'string'},
		{name:'nombre_funcion', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'header', type: 'string'},
		{name:'visible', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
        {name:'tipo', type: 'string'},
        {name:'id_gestion', type: 'numeric'}
	],
	sortInfo:{
		field: 'id_reporte_anexos',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
    tabsouth:[
        {
            url:'../../../sis_contabilidad/vista/reporte_anexos_det/ReporteAnexosDet.php',
            title:'Detalle',
            height:'50%',
            cls:'ReporteAnexosDet'
        },
        {
            url:'../../../sis_contabilidad/vista/dependencia_anexos/DependenciaAnexos.php',
            title:'Dependencias',
            height:'50%',
            cls:'DependenciaAnexos'
        }
    ],
    onButtonAct:function(){
        this.store.baseParams.id_gestion=this.cmbGestion.getValue();
        Phx.vista.ReporteAnexos.superclass.onButtonAct.call(this);
    },
    onButtonNew:function(){
        if(!this.validarFiltros()){
            alert('Especifique el año')
        }else{
            Phx.vista.ReporteAnexos.superclass.onButtonNew.call(this);//habilita el boton y se abre
            this.Cmp.id_gestion.setValue(this.cmbGestion.getValue());
        }
    },
    capturaFiltros:function(combo, record, index){
        // this.desbloquearOrdenamientoGrid();
        if(this.validarFiltros()){
            this.store.baseParams.id_gestion = this.cmbGestion.getValue();
            this.load();
        }
    },
    validarFiltros:function(){
        if(this.cmbGestion.validate()){
            return true;
        } else{
            return false;
        }
    },

    onImprimit:function () {
        var rec = this.sm.getSelected();
        Phx.CP.loadingShow();
        Ext.Ajax.request({
            url:'../../sis_contabilidad/control/ReporteAnexos/ReporteAnexosPlantillas',
            params:{
                id_gestion : this.cmbGestion.getValue(),
                id_reporte_anexos : rec.data.id_reporte_anexos
            },
            success: this.successExport,
            failure: this.conexionFailure,
            timeout:this.timeout,
            scope:this
        });
    },
    onFormularios:function () {
        var rec = this.sm.getSelected();
        Phx.CP.loadWindows('../../../sis_contabilidad/vista/impuesto_form/ImpuestoForm.php', 'Formularios', {
            modal : true,
            width : '95%',
            height : '95%'
        }, rec.data, this.idContenedor, 'ImpuestoForm');
    },
    onButtonCabecera:function () {
        var rec = this.sm.getSelected();
        console.log ('Data',rec.data);
        Phx.CP.loadWindows('../../../sis_contabilidad/vista/anexo_cabecera/AnexoCabecera.php',
            'Cabecera Anexo Vrtical',
            {
                width:'50%',
                height:'50%'
            },
            rec.data,
            this.idContenedor,
            'AnexoCabecera');
    },
    cmbGestion: new Ext.form.ComboBox({
        fieldLabel: 'Gestion',
        allowBlank: false,
        emptyText:'Gestion...',
        blankText: 'Año',
        store:new Ext.data.JsonStore(
            {
                url: '../../sis_parametros/control/Gestion/listarGestion',
                id: 'id_gestion',
                root: 'datos',
                sortInfo:{
                    field: 'gestion',
                    direction: 'DESC'
                },
                totalProperty: 'total',
                fields: ['id_gestion','gestion'],
                // turn on remote sorting
                remoteSort: true,
                baseParams:{par_filtro:'gestion'}
            }),
        valueField: 'id_gestion',
        triggerAction: 'all',
        displayField: 'gestion',
        hiddenName: 'id_gestion',
        mode:'remote',
        pageSize:50,
        queryDelay:500,
        listWidth:'280',
        width:80
    })
	}
)
</script>
		
		