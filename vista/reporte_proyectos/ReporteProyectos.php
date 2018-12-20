<?php
/**
 *@package pXP
 *@file gen-Categoria.php
 *@author  (admin)
 *@date 20-04-2017 00:51:02
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>



    Phx.vista.ReporteProyectos = Ext.extend(Phx.frmInterfaz, {

        Atributos : [
            /* {
                 config:{
                     name : 'tipo_filtro',
                     fieldLabel : 'Filtros',
                     items: [
                         {boxLabel: 'Gestión', name: 'tipo_filtro', inputValue: 'gestion', checked: true},
                         {boxLabel: 'Fechas', name: 'tipo_filtro', inputValue: 'fechas'}
                     ]


                 },
                 type : 'RadioGroupField',
                 id_grupo : 0,
                 form : true
             },*/
            {
                config:{
                    name : 'id_gestion',
                    origen : 'GESTION',
                    fieldLabel : 'Gestion',
                    gdisplayField: 'desc_gestion',
                    allowBlank : false,
                    width: 150
                },
                type : 'ComboRec',
                id_grupo : 0,
                form : true
            },
            {
                config:{
                    name: 'desde',
                    fieldLabel: 'Desde',
                    allowBlank: false,
                    format: 'd/m/Y',
                    width: 150
                },
                type: 'DateField',
                id_grupo: 0,
                form: true
            },
            {
                config:{
                    name: 'hasta',
                    fieldLabel: 'Hasta',
                    allowBlank: false,
                    format: 'd/m/Y',
                    width: 150
                },
                type: 'DateField',
                id_grupo: 0,
                form: true
            },
            {
                config:{
                    sysorigen: 'sis_contabilidad',
                    name: 'id_cuenta',
                    origen: 'CUENTA',
                    allowBlank: true,
                    fieldLabel: 'Cuenta',
                    gdisplayField: 'desc_cuenta',
                    baseParams: { sw_transaccional: undefined },
                    width: 150
                },
                type: 'ComboRec',
                id_grupo: 0,
                form: true
            },
            {
                config:{
                    name:'id_tipo_cc',
                    qtip: 'Tipo de centro de costos, cada tipo solo puede tener un centro por gestión',
                    origen:'TIPOCC',
                    fieldLabel:'Tipo Centro',
                    gdisplayField: 'desc_tipo_cc',
                    url:  '../../sis_parametros/control/TipoCc/listarTipoCcAll',
                    baseParams: {movimiento:''},
                    allowBlank:true,
                    width: 150

                },
                type:'ComboRec',
                id_grupo:0,
                filters:{pfiltro:'vcc.codigo_tcc#vcc.descripcion_tcc',type:'string'},
                grid:true,
                form:true
            },
            {
                config:{
                    name: 'id_centro_costo',
                    fieldLabel: 'Centro Costo',
                    allowBlank: true,
                    tinit: false,
                    origen: 'CENTROCOSTO',
                    gdisplayField: 'desc_centro_costo',
                    width: 150
                },
                type: 'ComboRec',
                id_grupo: 0,
                form: true
            },
            {
                config:{
                    name: 'cbte_cierre',
                    qtip : 'Incluir los comprobantes de cierre en el balance',
                    fieldLabel: 'Incluir cbtes. cierres',
                    allowBlank: false,
                    emptyText:'Tipo...',
                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode: 'local',
                    width:150,
                    store:['no','balance','resultado','todos']
                },
                type:'ComboBox',
                id_grupo:0,
                valorInicial: 'no',
                grid:true,
                form:true
            }/*,
            {
                config:{
                    name : 'cerrado',
                    fieldLabel : 'Reporte Arbol',
                    items: [
                        {boxLabel: 'Si', name: 'cerrado', inputValue: 'si'},
                        {boxLabel: 'No', name: 'cerrado', inputValue: 'no', checked: true}
                    ]
                },
                type : 'RadioGroupField',
                id_grupo : 0,
                form : true
            }*/

        ],
        topBar : true,
        botones : false,
        labelSubmit : 'Generar',
        tooltipSubmit : '<b>Reporte Proyectoa</b>',
        constructor : function(config) {
            Phx.vista.ReporteProyectos.superclass.constructor.call(this, config);
            this.init();
            this.iniciarEventos();
        },
        tipo : 'reporte',
        clsSubmit : 'bprint',

        Grupos : [{
            layout : 'column',
            items : [{
                xtype : 'fieldset',
                layout : 'form',
                border : true,
                title : 'Datos para el reporte',
                bodyStyle : 'padding:0 10px 0;',
                columnWidth : '800px',
                items : [],
                id_grupo : 0,
                collapsible : true
            }]
        }],

        ActSave:'../../sis_contabilidad/control/IntTransaccion/reporteProyecto',
        iniciarEventos:function(){
            this.Cmp.id_gestion.on('select', function(cmb, rec, ind){
                console.log(rec.data.id_gestion);
                Ext.apply(this.Cmp.id_centro_costo.store.baseParams,{id_gestion: rec.data.id_gestion});
                Ext.apply(this.Cmp.id_cuenta.store.baseParams,{id_gestion: rec.data.id_gestion});
                this.Cmp.id_centro_costo.reset();
                this.Cmp.id_centro_costo.modificado = true;
                this.Cmp.id_cuenta.reset();
                this.Cmp.id_cuenta.modificado = true;
            },this);
        },
        agregarArgsExtraSubmit: function() {
            this.argumentExtraSubmit.id_gestions = this.Cmp.id_gestion.getRawValue();

        }
    })





</script>

