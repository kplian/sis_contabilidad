<?php
/**
*@package pXP
*@file gen-Comisionistas.php
*@author  (admin)
*@date 31-05-2017 20:17:02
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Comisionistas=Ext.extend(Phx.gridInterfaz,{
    fheight: '65%',
    fwidth: '45%',

    constructor:function(config){
        this.initButtons=[this.cmbDepto, this.cmbGestion, this.cmbPeriodo];
        this.Grupos = [
            {
                layout: 'column',
                border: false,
                autoHeight : true,
                defaults: {
                    border: true,
                    bodyStyle: 'padding:4px'
                },
                items: [
                    {
                        xtype: 'fieldset',
                        columnWidth: 1,
                        defaults: {
                            anchor: '-20' // leave room for error icon
                        },
                        title: 'Datos del Contrato',
                        items: [],
                        id_grupo: 0,
                        flex:1,
                        autoHeight : true,
                        margins:'2 2 2 2'
                    }
                ]
            }];
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.Comisionistas.superclass.constructor.call(this,config);
        this.grid.addListener('cellclick', this.oncellclick,this);
        this.cmbGestion.on('select', function(combo, record, index){
            this.tmpGestion = record.data.gestion;
            this.cmbPeriodo.enable();
            this.cmbPeriodo.reset();
            this.store.removeAll();
            this.cmbPeriodo.store.baseParams = Ext.apply(this.cmbPeriodo.store.baseParams, {id_gestion: this.cmbGestion.getValue()});
            this.cmbPeriodo.modificado = true;

        },this);
        this.cmbPeriodo.on('select', function( combo, record, index){
            this.tmpPeriodo = record.data.periodo;
            this.capturaFiltros();
        },this);
        this.cmbDepto.on('select', function( combo, record, index){
            this.capturaFiltros();
        },this);
        this.init();
        this.addButton('listaNegra',{
            grupo:[0,1,2,3,4],
            text :'Lista Negra',
            iconCls : 'bcancelfile',
            disabled: true,
            handler : this.addListaNegra,
            tooltip : '<b>Lista Negra</b><br/><b>Agrega a la lista negra</b>'
        });
        //this.addButton('insertAuto',{argument: {imprimir: 'insertAuto'},text:'<i class="fa fa-file-text-o fa-2x"></i> insertAuto',/*iconCls:'' ,*/disabled:true,handler:this.insertAuto});
        this.addButton('exportar',{argument: {imprimir: 'exportar'},text:'<i class="fa fa-file-text-o fa-2x"></i> Generar Periodo TXT - SIN',/*iconCls:'' ,*/disabled:true,handler:this.generar_txt});
        this.addButton('Importar',{argument: {imprimir: 'Importar'},text:'<i class="fa fa-file-text-o fa-2x"></i> Importar TXT',/*iconCls:'' ,*/disabled:true,handler:this.importar_txt});
        this.addButton('BorrarTodo',{argument: {imprimir: 'BorrarTodo'},text:'<i class="fa fa-file-text-o fa-2x"></i> BorrarTodo',/*iconCls:'' ,*/disabled:true,handler:this.BorrarTodo});
        this.addButton('Clonar',{argument: {imprimir: 'Clonar'},text:'<i class="fa fa-file-text-o fa-2x"></i> Clonar',/*iconCls:'' ,*/disabled:false,handler:this.Clonar});
        this.addButton('exportarGestionCompleta',{argument: {imprimir: 'exportarGestionCompleta'},text:'<i class="fa fa-file-text-o fa-2x"></i> Generar Gestion TXT - SIN',/*iconCls:'' ,*/disabled:false,handler:this.exportarGestionCompleta});

    },
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_comisionista'
			},
			type:'Field',
			form:true 
		},
        {
            config:{
                labelSeparator:'',
                inputType:'hidden',
                name: 'id_depto_conta'
            },
            type:'Field',
            form:true
        },
        {
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
                name: 'revisado',
                fieldLabel: 'Revisado',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:3,
                renderer: function (value){
                    //check or un check row
                    var checked = '',
                        momento = 'no';
                    if(value == 'si'){
                        checked = 'checked';;
                    }
                    return  String.format('<div style="vertical-align:middle;text-align:center;"><input style="height:37px;width:37px;" type="checkbox"  {0}></div>',checked);

                }
            },
            type: 'TextField',
            filters: { pfiltro:'cm.revisado',type:'string'},
            id_grupo: 0,
            grid: true,
            form: false
        },

        {
            config:{
                name: 'nit_comisionista',
                fieldLabel: 'NIT del Comisionista',
                allowBlank: false,
                anchor: '80%',
                gwidth: 200,
                maxLength:255,
                renderer: function (value, meta, record) {

                    var resp;
                    resp = value;
                    var css;
                    var lista_negra = '';

                    if(record.json.lista_negra == 'si'){
                        css = "color:red; font-weight: bold; display:block;";
                        lista_negra = '<div>(lista negra)</div>'
                    }else{
                        css = "";
                    }
                    var tipo_comisionista = '';
                    if(record.json.tipo_comisionista == 'clonado'){
                        tipo_comisionista = '<div style="color:orange; font-weight:bold;" >(clonado)</div>'
                    }
                    return  String.format('<div style="vertical-align:middle;text-align:center;"><span style="{0}">{1}{2}{3}</span></div>',css,resp,lista_negra,tipo_comisionista);

                }
            },
            type:'NumberField',
            filters:{pfiltro:'cm.nit_comisionista',type:'string'},
            id_grupo:0,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'nro_contrato',
                fieldLabel: 'Número de Contrato',
                allowBlank: false,
                anchor: '80%',
                gwidth: 150,
                maxLength:500
            },
            type:'TextField',
            filters:{pfiltro:'cm.nro_contrato',type:'string'},
            id_grupo:0,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'codigo_producto',
                fieldLabel: 'Código del producto',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:255
            },
            type:'TextField',
            filters:{pfiltro:'cm.codigo_producto',type:'string'},
            id_grupo:0,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'descripcion_producto',
                fieldLabel: 'Descripción de producto entregado',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:1000
            },
            type:'TextField',
            filters:{pfiltro:'cm.descripcion_producto',type:'string'},
            id_grupo:0,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'cantidad_total_entregado',
                fieldLabel: 'Cantidad total producto entregado',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:4
            },
            type:'NumberField',
            filters:{pfiltro:'cm.cantidad_total_entregado',type:'numeric'},
            id_grupo:0,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'cantidad_total_vendido',
                fieldLabel: 'Cantidad total producto vendido',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:1310721
            },
            type:'NumberField',
            filters:{pfiltro:'cm.cantidad_total_vendido',type:'numeric'},
            id_grupo:0,
            grid:true,
            form:true
        },

        {
            config:{
                name: 'precio_unitario',
                fieldLabel: 'Precio unitario',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:1310721
            },
            type:'NumberField',
            filters:{pfiltro:'cm.precio_unitario',type:'numeric'},
            id_grupo:0,
            grid:true,
            form:true
        },

        {
            config:{
                name: 'monto_total',
                fieldLabel: 'Monto total del producto',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:1310720
            },
            type:'NumberField',
            filters:{pfiltro:'cm.monto_total',type:'numeric'},
            id_grupo:0,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'monto_total_comision',
                fieldLabel: 'Monto total de la comisión del producto',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:1310720
            },
            type:'NumberField',
            filters:{pfiltro:'cm.monto_total_comision',type:'numeric'},
            id_grupo:0,
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
				filters:{pfiltro:'cm.estado_reg',type:'string'},
				id_grupo:0,
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
				id_grupo:0,
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
				filters:{pfiltro:'cm.usuario_ai',type:'string'},
				id_grupo:0,
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
				filters:{pfiltro:'cm.fecha_reg',type:'date'},
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
				filters:{pfiltro:'cm.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'cm.fecha_mod',type:'date'},
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
	title:'Comisionistas ',
	ActSave:'../../sis_contabilidad/control/Comisionistas/insertarComisionistas',
	ActDel:'../../sis_contabilidad/control/Comisionistas/eliminarComisionistas',
	ActList:'../../sis_contabilidad/control/Comisionistas/listarComisionistas',
	id_store:'id_comisionista',
	fields: [
        {name:'id_periodo', type: 'numeric'},
        {name:'id_depto_conta', type: 'numeric'},
		{name:'id_comisionista', type: 'numeric'},
		{name:'nit_comisionista', type: 'string'},
        {name:'nro_contrato', type: 'string'},
		{name:'codigo_producto', type: 'string'},
        {name:'descripcion_producto', type: 'string'},
		{name:'cantidad_total_entregado', type: 'numeric'},
        {name:'cantidad_total_vendido', type: 'numeric'},
        {name:'precio_unitario', type: 'numeric'},
        {name:'monto_total', type: 'numeric'},
        {name:'monto_total_comision', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
        {name:'revisado', type: 'string'},
        {name:'registro', type: 'string'},
        {name:'tipo_comisionista', type: 'string'},
        {name:'lista_negra', type: 'string'}

	],
	sortInfo:{
		field: 'id_comisionista',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
    oncellclick : function(grid, rowIndex, columnIndex, e) {
        var record = this.store.getAt(rowIndex),
            fieldName = grid.getColumnModel().getDataIndex(columnIndex); // Get field name

        if(fieldName == 'revisado') {
            this.cambiarRevision(record);
        }
    },
    cambiarRevision: function(record){
        Phx.CP.loadingShow();
        var d = record.data;
        Ext.Ajax.request({
            url:'../../sis_contabilidad/control/Comisionistas/cambiarRevision',
            params:{ id_comisionista: d.id_comisionista,
                      revisado: d.revisado
                    },
            success: this.successRevision,
            failure: this.conexionFailure,
            timeout: this.timeout,
            scope: this
        });
        this.reload();
    },
    successRevision: function(resp){
        Phx.CP.loadingHide();
        var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
    },

    preparaMenu:function(tb){
        Phx.vista.Comisionistas.superclass.preparaMenu.call(this,tb);
        var data = this.getSelectedData();
        if(data['revisado'] ==  'no' ){
            this.getBoton('edit').enable();
            this.getBoton('del').enable();

        }
        else{
            this.getBoton('edit').disable();
            this.getBoton('del').disable();
        }
        this.getBoton('listaNegra').enable();
    },

    liberaMenu:function(tb){
        Phx.vista.Comisionistas.superclass.liberaMenu.call(this,tb);

    },
    onButtonNew:function(){


        if(!this.validarFiltros()){
            alert('Especifique el año y el mes antes')
        }
        else{
            this.accionFormulario = 'NEW';
            Phx.vista.Comisionistas.superclass.onButtonNew.call(this);//habilita el boton y se abre

            this.Cmp.id_depto_conta.setValue(this.cmbDepto.getValue());
            this.Cmp.id_periodo.setValue(this.cmbPeriodo.getValue());


            Ext.Ajax.request({
                url: '../../sis_parametros/control/Periodo/literalPeriodo',
                params: { "id_periodo":this.cmbPeriodo.getValue(),"id_depto_conta":this.cmbDepto.getValue()},
                success: this.successLiteralPeriodo,
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope:   this
            });

        }
    },

    capturaFiltros:function(combo, record, index){
        this.desbloquearOrdenamientoGrid();
        if(this.validarFiltros()){

            this.store.baseParams.id_gestion = this.cmbGestion.getValue();
            this.store.baseParams.id_periodo = this.cmbPeriodo.getValue();
            this.store.baseParams.id_depto = this.cmbDepto.getValue();
            this.load();
        }

    },

    validarFiltros:function(){
        if(this.cmbDepto.getValue() && this.cmbGestion.validate() && this.cmbPeriodo.validate()){

           this.getBoton('exportar').enable();
            this.getBoton('Importar').enable();
            this.getBoton('BorrarTodo').enable();
            return true;
        }
        else{

            /*this.getBoton('exportar').disable();
            this.getBoton('Importar').disable();
            this.getBoton('Acumulado').disable();
            this.getBoton('BorrarTodo').disable();*/
            return false;

        }
    },
    onButtonAct:function(){
        if(!this.validarFiltros()){
            alert('Especifique el año y el mes antes')
        }
        else{
            this.store.baseParams.id_gestion=this.cmbGestion.getValue();
            this.store.baseParams.id_periodo = this.cmbPeriodo.getValue();
            this.store.baseParams.id_depto = this.cmbDepto.getValue();
            Phx.vista.Comisionistas.superclass.onButtonAct.call(this);
        }
    },

    cmbDepto: new Ext.form.ComboBox({
        name: 'id_depto',
        fieldLabel: 'Depto',
        blankText: 'Depto',
        typeAhead: false,
        forceSelection: true,
        allowBlank: false,
        disableSearchButton: true,
        emptyText: 'Depto Contable',
        store: new Ext.data.JsonStore({
            url: '../../sis_parametros/control/Depto/listarDeptoFiltradoDeptoUsuario',
            id: 'id_depto',
            root: 'datos',
            sortInfo:{
                field: 'deppto.nombre',
                direction: 'ASC'
            },
            totalProperty: 'total',
            fields: ['id_depto','nombre','codigo'],
            // turn on remote sorting
            remoteSort: true,
            baseParams: { par_filtro:'deppto.nombre#deppto.codigo', estado:'activo', codigo_subsistema: 'CONTA', _adicionar : 'si'}
        }),
        valueField: 'id_depto',
        displayField: 'nombre',
        hiddenName: 'id_depto',
        enableMultiSelect: true,
        triggerAction: 'all',
        lazyRender: true,
        mode: 'remote',
        pageSize: 20,
        queryDelay: 200,
        anchor: '80%',
        listWidth:'280',
        resizable:true,
        minChars: 2
    }),

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
    }),
    cmbPeriodo: new Ext.form.ComboBox({
        fieldLabel: 'Periodo',
        allowBlank: false,
        blankText : 'Mes',
        emptyText:'Periodo...',
        store:new Ext.data.JsonStore(
            {
                url: '../../sis_parametros/control/Periodo/listarPeriodo',
                id: 'id_periodo',
                root: 'datos',
                sortInfo:{
                    field: 'periodo',
                    direction: 'ASC'
                },
                totalProperty: 'total',
                fields: ['id_periodo','periodo','id_gestion','literal'],
                // turn on remote sorting
                remoteSort: true,
                baseParams:{par_filtro:'gestion'}
            }),
        valueField: 'id_periodo',
        triggerAction: 'all',
        displayField: 'literal',
        hiddenName: 'id_periodo',
        mode:'remote',
        pageSize:50,
        disabled: true,
        queryDelay:500,
        listWidth:'280',
        width:80
    }),
    generar_txt:function(){
        var rec = this.cmbPeriodo.getValue();
        var dep = this.cmbDepto.getValue();
        Ext.Ajax.request({
            url:'../../sis_contabilidad/control/Comisionistas/exporta_txt',
            params:{'id_periodo':rec,'id_depto':dep,'start':0,'limit':100000},
            success: this.successGeneracion_txt,
            failure: this.conexionFailure,
            timeout:this.timeout,
            scope:this
        });
    },
    successGeneracion_txt:function(resp){
        Phx.CP.loadingHide();
        var objRes = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
        var texto = objRes.datos;
        window.open('../../../reportes_generados/'+texto+'.txt')
    },

    exportarGestionCompleta:function(){
        var rec = this.cmbPeriodo.getValue();
        var dep = this.cmbDepto.getValue();
        Ext.Ajax.request({
            url:'../../sis_contabilidad/control/Comisionistas/exporta_txt',
            params:{'gestion':'si','id_periodo':rec,'id_depto':dep,'start':0,'limit':100000},
            success: this.successExportarGestionCompleta,
            failure: this.conexionFailure,
            timeout:this.timeout,
            scope:this
        });
    },
    successExportarGestionCompleta:function(resp){
        Phx.CP.loadingHide();
        var objRes = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
        var texto = objRes.datos;
        window.open('../../../reportes_generados/'+texto+'.txt')
    },
    importar_txt:function(){
        var misdatos = new Object();
        misdatos.id_periodo = this.cmbPeriodo.getValue();
        misdatos.id_depto_conta = this.cmbDepto.getValue();
        Phx.CP.loadWindows('../../../sis_contabilidad/vista/comisionistas/SubirArchivoCm.php',
            'Subir',
            {
                modal:true,
                width:450,
                height:150
            },misdatos,this.idContenedor,'SubirArchivoCm');
    },
    BorrarTodo:function(){
        Phx.CP.loadingShow();
        var id_periodo = this.cmbPeriodo.getValue();
        var id_depto_conta = this.cmbDepto.getValue();

        Ext.Ajax.request({
            url:'../../sis_contabilidad/control/Comisionistas/BorrarTodo',
            params:{'id_periodo':id_periodo,id_depto_conta:id_depto_conta},
            success: this.successAuto,
            failure: this.conexionFailure,
            timeout:this.timeout,
            scope:this
        });
    },
    Clonar : function(){
        Phx.CP.loadingShow();
        var rec = this.sm.getSelected();
        var id_comisionista = rec.data.id_comisionista;
        Ext.Ajax.request({
            url:'../../sis_contabilidad/control/Comisionistas/clonar',
            params:{'id_comisionista':id_comisionista},
            success: this.successAuto,
            failure: this.conexionFailure,
            timeout:this.timeout,
            scope:this
        });
    },
    addListaNegra : function(){
        var id_periodo = this.cmbPeriodo.getValue();
        var id_depto_conta = this.cmbDepto.getValue();
        var data = this.getSelectedData();
        Ext.Ajax.request({
            url:'../../sis_contabilidad/control/Comisionistas/agregarListarNegra',
            params:{'id_comisionista':data.id_comisionista,'id_periodo':id_periodo,id_depto_conta: id_depto_conta},
            success: this.successAuto,
            failure: this.conexionFailure,
            timeout:this.timeout,
            scope:this
        });
    },

    successAuto:function(){
        Phx.CP.loadingHide();
        this.reload();
    }

	}
)
</script>
		
		