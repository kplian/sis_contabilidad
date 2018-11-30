<?php
/**
 *@package pXP
 *@file gen-DeclaracionesJuridicas.php
 *@author  (m.mamani)
 *@date 27-08-2018 14:51:02
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.DeclaracionesJuridicas=Ext.extend(Phx.gridInterfaz,{

            constructor:function(config){
                this.initButtons=[this.cmbFormulario,this.cmbGestion, this.cmbPeriodo];
                this.maestro=config.maestro;
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
                this.cmbFormulario.on('select', function( combo, record, index){
                    this.capturaFiltros();
                },this);
                //llama al constructor de la clase padre
                Phx.vista.DeclaracionesJuridicas.superclass.constructor.call(this,config);
                this.init();
                this.addButton('subirArchivo',{
                    text :'Subir Archivo',
                    iconCls : 'bcancelfile',
                    // disabled: false,
                    handler : this.subirArchivo,
                    tooltip : '<b>Subir Archivo csc</b>'
                });
                this.addButton('validarFormulario',{
                    text :'Cerrar Periodo',
                    iconCls : 'bcancelfile',
                    // disabled: false,
                    handler : this.validarFormulario,
                    tooltip : '<b>Cerrar Periodo</b>'
                });
                this.addButton('elimanarFormulario',{
                    text :'Eliminar Formulario',
                    iconCls : 'bcancelfile',
                    // disabled: false,
                    handler : this.eliminarFOormulario,
                    tooltip : '<b>Eliminar Formulario</b>'
                });
            },

            Atributos:[
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_declaracion_juridica'
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
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'tipo'
                    },
                    type:'Field',
                    form:true
                },
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'estado'
                    },
                    type:'Field',
                    form:true
                },
                {
                    config:{
                        name: 'fila',
                        fieldLabel: 'Fila',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 50,
                        maxLength:4
                    },
                    type:'NumberField',
                    filters:{pfiltro:'djs.fila',type:'numeric'},
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
                        gwidth: 600
                    },
                    type:'TextField',
                    filters:{pfiltro:'djs.descripcion',type:'string'},
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
                        maxLength:20
                    },
                    type:'TextField',
                    filters:{pfiltro:'djs.codigo',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'importe',
                        fieldLabel: 'Importe',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:1310720
                    },
                    type:'NumberField',
                    filters:{pfiltro:'djs.importe',type:'numeric'},
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
                    filters:{pfiltro:'djs.estado_reg',type:'string'},
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
                    filters:{pfiltro:'djs.fecha_reg',type:'date'},
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
                    filters:{pfiltro:'djs.usuario_ai',type:'string'},
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
                    filters:{pfiltro:'djs.id_usuario_ai',type:'numeric'},
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
                    filters:{pfiltro:'djs.fecha_mod',type:'date'},
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
            title:'Declaraciones Juridicas',
            ActSave:'../../sis_contabilidad/control/DeclaracionesJuridicas/insertarDeclaracionesJuridicas',
            ActDel:'../../sis_contabilidad/control/DeclaracionesJuridicas/eliminarDeclaracionesJuridicas',
            ActList:'../../sis_contabilidad/control/DeclaracionesJuridicas/listarDeclaracionesJuridicas',
            id_store:'id_declaracion_juridica',
            fields: [
                {name:'id_declaracion_juridica', type: 'numeric'},
                {name:'descripcion', type: 'string'},
                {name:'tipo', type: 'string'},
                {name:'fila', type: 'numeric'},
                {name:'importe', type: 'numeric'},
                {name:'codigo', type: 'string'},
                {name:'estado_reg', type: 'string'},
                {name:'id_gestion', type: 'numeric'},
                {name:'id_periodo', type: 'numeric'},
                {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'usuario_ai', type: 'string'},
                {name:'id_usuario_reg', type: 'numeric'},
                {name:'id_usuario_ai', type: 'numeric'},
                {name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'id_usuario_mod', type: 'numeric'},
                {name:'usr_reg', type: 'string'},
                {name:'usr_mod', type: 'string'},
                {name:'estado', type: 'string'}

            ],
            sortInfo:{
                field: 'fila',
                direction: 'ASC'
            },
            bdel:false,
            bsave:false,
            bedit: false,
            bnew: false,

            cmbFormulario: new Ext.form.ComboBox({
                name:'formulario',
                fieldLabel:'Formulario',
                allowBlank: true,
                emptyText:'Formularios...',
                store: new Ext.data.ArrayStore({
                    fields: ['variable', 'valor'],
                    data :  [    ['impuesto_valor_agregado', 'FORMULARIO 200v3'],
                        ['impuesto_transacciones', 'FORMULARIO 400v3'],
                        ['iue_beneficiarios_exterior', 'FORMULARIO 530v2'],
                        ['retenciones', 'FORMULARIO 570v2'],
                        ['regimen_impuesto_valor_agregado', 'FORMULARIO 604v2'],
                        ['impuesto_transacciones_retenciones', 'FORMULARIO 410v2'],
                        ['impuesto_valor_agregado_agentes_retencion', 'FORMULARIO 608v2']
                    ]
                }),
                valueField: 'variable',
                displayField: 'valor',
                mode: 'local',
                forceSelection:true,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender: true,
                queryDelay: 1000,
                width: 200,
                minChars: 2 ,
                enableMultiSelect: true
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
            /* preparaMenu:function(tb){
                 Phx.vista.DeclaracionesJuridicas.superclass.preparaMenu.call(this,tb);
                 var data = this.getSelectedData();
                 if(data['estado'] ==  'no' ){
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
                 Phx.vista.DeclaracionesJuridicas.superclass.liberaMenu.call(this,tb);

             },*/
            onButtonAct:function(){
                if(!this.validarFiltros()){
                    alert('Especifique el año y el mes antes')
                }
                else{
                    this.store.baseParams.id_gestion = this.cmbGestion.getValue();
                    this.store.baseParams.id_periodo = this.cmbPeriodo.getValue();
                    this.store.baseParams.tipo = this.cmbFormulario.getValue();
                    Phx.vista.DeclaracionesJuridicas.superclass.onButtonAct.call(this);
                }
            },
            capturaFiltros:function(combo, record, index){
                //  this.desbloquearOrdenamientoGrid();
                if(this.validarFiltros()){
                    console.log('llega');
                    this.store.baseParams.id_gestion = this.cmbGestion.getValue();
                    this.store.baseParams.id_periodo = this.cmbPeriodo.getValue();
                    this.store.baseParams.tipo = this.cmbFormulario.getValue();
                    this.load();
                }

            },
            validarFiltros:function(){
                if( this.cmbGestion.validate() && this.cmbPeriodo.validate()){

                    this.getBoton('subirArchivo').enable();
                    this.getBoton('elimanarFormulario').enable();
                    this.getBoton('validarFormulario').enable();
                    return true;
                }
                else{
                    this.getBoton('subirArchivo').disable();
                    this.getBoton('elimanarFormulario').disable();
                    this.getBoton('validarFormulario').disable();
                    return false;

                }
            },
            subirArchivo:function(){
                var misdatos = new Object();
                misdatos.id_periodo = this.cmbPeriodo.getValue();
                misdatos.id_gestion = this.cmbPeriodo.getValue();
                misdatos.tipo = this.cmbFormulario.getValue();
                Phx.CP.loadWindows('../../../sis_contabilidad/vista/declaraciones_juridicas/SubirArchivo.php',
                    'Subir',
                    {
                        modal:true,
                        width:450,
                        height:150
                    },misdatos,this.idContenedor,'SubirArchivo');
            },
            eliminarFOormulario: function(){
                Phx.CP.loadingShow();
                Ext.Ajax.request({
                    url: '../../sis_contabilidad/control/DeclaracionesJuridicas/eliminarFormulario',
                    params: {   tipo : this.cmbFormulario.getValue(),
                        id_periodo :this.cmbPeriodo.getValue()
                    },
                    success: this.successSinc,
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });
            },
            validarFormulario: function(){
                Phx.CP.loadingShow();
                Ext.Ajax.request({
                    url: '../../sis_contabilidad/control/DeclaracionesJuridicas/validarFormulario',
                    params: {   tipo : this.cmbFormulario.getValue(),
                        id_periodo :this.cmbPeriodo.getValue()
                    },
                    success: this.successSinc,
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });
            },
            successSinc:function(resp){
                Phx.CP.loadingHide();
                var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
                if(!reg.ROOT.error){
                    if(this.wAuto){
                        this.wAuto.hide();
                    }
                    this.reload();
                }else{
                    alert('ocurrio un error durante el proceso')
                }
            }

        }
    )
</script>





		