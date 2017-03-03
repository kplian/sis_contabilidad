<?php
/**
 *@package pXP
 *@file Cuenta.php
 *@author  Miguel ALjenadro Mamani Villegas
 *@date 21-02-2013 15:04:03
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.TipoCosto =function (config) {
        this.Atributos=[
            {
                //configuracion del componente
                config: {
                    labelSeparator: '',
                    inputType: 'hidden',
                    name: 'id_tipo_costo'
                },
                type: 'Field',
                form: true

            },
            {
                //configuracion del componente
                config: {
                    labelSeparator: '',
                    inputType: 'hidden',
                    name: 'id_tipo_costo_fk'
                },
                type: 'Field',
                form: true

            },
            {
                config: {
                    name: 'codigo',
                    fieldLabel: 'codigo',
                    allowBlank: false,
                    anchor: '80%',
                    gwidth: 150,
                    maxLength: 200
                },
                type: 'TextField',
                filters: {pfiltro: 'tco.codigo', type: 'string'},
                id_grupo: 1,
                grid: true,
                form: true
            },
            {
                config: {
                    name: 'nombre',
                    fieldLabel: 'nombre',
                    allowBlank: false,
                    anchor: '80%',
                    gwidth: 300,
                    maxLength: 500
                },
                type: 'TextField',
                filters: {pfiltro: 'tco.nombre', type: 'string'},
                id_grupo: 1,
                grid: true,
                form: true
            },

            {
                config: {
                    name: 'descripcion',
                    fieldLabel: 'descripcion',
                    allowBlank: false,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength: 500
                },
                type: 'TextField',
                filters: {pfiltro: 'tco.descripcion', type: 'string'},
                id_grupo: 1,
                grid: true,
                form: true
            },


            {
                config: {
                    name: 'sw_trans',
                    fieldLabel: 'Operación',
                    allowBlank: false,
                    emptyText: 'Tipo...',
                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender: true,
                    mode: 'local',
                    gwidth: 100,
                    store: ['movimiento', 'titular']
                },
                type: 'ComboBox',
                filters: {pfiltro: 'tco.sw_trans', type: 'string'},
                id_grupo: 0,
                grid: true,
                form: true
            },

            {
                config: {
                    name: 'estado_reg',
                    fieldLabel: 'Estado Reg.',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength: 10
                },
                type: 'TextField',
                filters: {pfiltro: 'tco.estado_reg', type: 'string'},
                id_grupo: 1,
                grid: true,
                form: false
            },
            {
                config: {
                    name: 'id_usuario_ai',
                    fieldLabel: '',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength: 4
                },
                type: 'Field',
                filters: {pfiltro: 'tco.id_usuario_ai', type: 'numeric'},
                id_grupo: 1,
                grid: false,
                form: false
            },
            {
                config: {
                    name: 'usuario_ai',
                    fieldLabel: 'Funcionaro AI',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength: 300
                },
                type: 'TextField',
                filters: {pfiltro: 'tco.usuario_ai', type: 'string'},
                id_grupo: 1,
                grid: true,
                form: false
            },
            {
                config: {
                    name: 'fecha_reg',
                    fieldLabel: 'Fecha creación',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    format: 'd/m/Y',
                    renderer: function (value, p, record) {
                        return value ? value.dateFormat('d/m/Y H:i:s') : ''
                    }
                },
                type: 'DateField',
                filters: {pfiltro: 'tco.fecha_reg', type: 'date'},
                id_grupo: 1,
                grid: true,
                form: false
            },
            {
                config: {
                    name: 'usr_reg',
                    fieldLabel: 'Creado por',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength: 4
                },
                type: 'Field',
                filters: {pfiltro: 'usu1.cuenta', type: 'string'},
                id_grupo: 1,
                grid: true,
                form: false
            },
            {
                config: {
                    name: 'usr_mod',
                    fieldLabel: 'Modificado por',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength: 4
                },
                type: 'Field',
                filters: {pfiltro: 'usu2.cuenta', type: 'string'},
                id_grupo: 1,
                grid: true,
                form: false
            },
            {
                config: {
                    name: 'fecha_mod',
                    fieldLabel: 'Fecha Modif.',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    format: 'd/m/Y',
                    renderer: function (value, p, record) {
                        return value ? value.dateFormat('d/m/Y H:i:s') : ''
                    }
                },
                type: 'DateField',
                filters: {pfiltro: 'tco.fecha_mod', type: 'date'},
                id_grupo: 1,
                grid: true,
                form: false
            }];


        Phx.vista.TipoCosto.superclass.constructor.call(this,config);
        this.tbar.items.get('b-new-'+this.idContenedor).disable();
        //Agregar elementos en la barra de tareas
        //this.tbar.add(this.cmbGestion);
        this.init();
        this.iniciarEventos();

    }
    Ext.extend(Phx.vista.TipoCosto,Phx.arbInterfaz,{
        title: 'Clasificacición de Costos',
        ActSave: '../../sis_contabilidad/control/TipoCosto/insertarTipoCosto',
        ActDel: '../../sis_contabilidad/control/TipoCosto/eliminarTipoCosto',
        ActList: '../../sis_contabilidad/control/TipoCosto/listarTipoCostoArb',
        enableDD:false,
        expanded:false,
        useArrows: true,
        nombreVista: 'Abastecimientos',

        id_store: 'id_tipo_costo',
        textRoot: 'CLASIFICADOR ',
        id_nodo: 'id_tipo_costo',
        id_nodo_p: 'id_tipo_costo_fk',

        fields: [
            {name: 'id_tipo_costo', type: 'numeric'},
            {name: 'codigo', type: 'string'},
            {name: 'nombre', type: 'string'},
            {name: 'sw_trans', type: 'string'},
            {name: 'descripcion', type: 'string'},
            {name: 'id_tipo_costo_fk', type: 'numeric'},
            {name: 'estado_reg', type: 'string'},
            {name: 'id_usuario_ai', type: 'numeric'},
            {name: 'usuario_ai', type: 'string'},
            {name: 'fecha_reg', type: 'date', dateFormat: 'Y-m-d H:i:s.u'},
            {name: 'id_usuario_reg', type: 'numeric'},
            {name: 'id_usuario_mod', type: 'numeric'},
            {name: 'fecha_mod', type: 'date', dateFormat: 'Y-m-d H:i:s.u'},
            {name: 'usr_reg', type: 'string'},
            {name: 'usr_mod', type: 'string'},
            {name: 'id_gestion', type: 'numeric'}

        ],

        sortInfo:
            {
                field: 'id_tipo_costo',
                direction: 'ASC'
            },

        bdel:true,
        bsave: false,
        rootVisible: false,
        getTipoCuentaPadre: function (n) {
            //var direc
            var padre = n.parentNode;

            if (padre) {
                if (padre.attributes.id != 'id') {
                    return this.getTipoCuentaPadre(padre);
                } else {
                    return n.attributes.tipo_cuenta;
                }
            } else {
                return undefined;
            }
        },
        preparaMenu:function (n) {

            if (n.attributes.tipo_nodo == 'hijo' || n.attributes.tipo_nodo == 'raiz' || n.attributes.id == 'id') {
                this.tbar.items.get('b-new-' + this.idContenedor).enable()
            }
            else {
                this.tbar.items.get('b-new-' + this.idContenedor).disable()
            }

            if (n.attributes.sw_trans == 'movimiento') {
                //this.getBoton('bCuentas').enable();
            }

            // llamada funcion clase padre
            return Phx.vista.TipoCosto.superclass.preparaMenu.call(this, n);


        },

        tabeast:[
            {
                url: '../../../sis_contabilidad/vista/tipo_costo_cuenta/TipoCostoCuenta.php',
                title: 'Cuentas y Auxiliares',
                width: 400,
                cls: 'TipoCostoCuenta'
            }
        ]
        /*iniciarEventos:function(){
         this.cmpSwTransaccional=this.getComponente('sw_trans')
         //this.cmpTipoCuentaPat=this.getComponente('tipo_cuenta_pat')
         this.cmpSwTransaccional.setValue(Ext.util.Format.capitalize(record.data.codigo);
         }*/

        /* cmbGestion: new Ext.form.ComboBox({
         name: 'gestion',
         id: 'gestion',
         fieldLabel: 'Gestion',
         allowBlank: true,
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
         hidden:false,
         width:80
         }),

         iniciarEvento: function () {
         this.cmbGestion.on('select',this.capturarEventos, this);
         },

         capturarEventos: function () {
         if(this.validarFiltros()){
         this.capturaFiltros();
         }
         },

         capturaFiltros:function(combo, record, index){

         console.log('llega',this.loaderTree.baseParams.id_gestion=this.cmbGestion.getValue());
         this.loaderTree.baseParams.id_gestion=this.cmbGestion.getValue();
         this.root.reload();

         },

         validarFiltros:function(){
         if(this.cmbGestion.isValid()){
         return true;
         }
         else{
         return false;
         }

         },

         onButtonAct:function(){
         if(!this.validarFiltros()){
         Ext.Msg.alert('ATENCION!!!','Especifique los filtros antes')
         }
         else{
         this.loaderTree.baseParams.id_gestion=this.cmbGestion.getValue();
         Phx.vista.TipoCosto.superclass.onButtonAct.call(this);
         }
         }*/


    })
</script>