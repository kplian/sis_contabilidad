<?php
/**
 *@package pXP
 *@file ReporteRegistroVentas
 *@author  (Miguel Mamani)
 *@date 19/12/2108
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 * HISTORIAL DE MODIFICACIONES:
 * ISSUE 		   FECHA   			 AUTOR				 DESCRIPCION:
 * #113         29/04/2020		     MMV	             Reporte Registro Ventas CC
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.ReporteRegistroVentas = Ext.extend(Phx.frmInterfaz, {
        Atributos : [
            {
                config:{
                    name: 'id_depto',
                    fieldLabel: 'Depto',
                    typeAhead: false,
                    forceSelection: true,
                    allowBlank: false,
                    disableSearchButton: true,
                    emptyText: 'Seleccione una opcion..',
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
                    triggerAction: 'all',
                    lazyRender: true,
                    mode: 'remote',
                    pageSize: 20,
                    queryDelay: 200,
                    listWidth:'280',
                    resizable:true,
                    width: 280,
                    minChars: 2
                },
                type:'ComboBox',
                id_grupo:0,
                form:true
            },
            {
                config:{
                    name: 'id_plantilla',
                    fieldLabel: 'Tipo Documento',
                    allowBlank: false,
                    emptyText:'Elija una plantilla...',
                    store:new Ext.data.JsonStore(
                        {
                            url: '../../sis_parametros/control/Plantilla/listarPlantilla',
                            id: 'id_plantilla',
                            root:'datos',
                            sortInfo:{
                                field:'desc_plantilla',
                                direction:'ASC'
                            },
                            totalProperty:'total',
                            fields: ['id_plantilla','nro_linea','desc_plantilla','tipo',
                                'sw_tesoro', 'sw_compro','sw_monto_excento','sw_descuento',
                                'sw_autorizacion','sw_codigo_control','tipo_plantilla','sw_nro_dui','sw_ice'],
                            remoteSort: true,
                            baseParams:{par_filtro:'plt.desc_plantilla',sw_compro:'si',sw_tesoro:'si'}
                        }),
                    tpl:'<tpl for="."><div class="x-combo-list-item"><p>{desc_plantilla}</p></div></tpl>',
                    valueField: 'id_plantilla',
                    hiddenValue: 'id_plantilla',
                    displayField: 'desc_plantilla',
                    gdisplayField:'desc_plantilla',
                    listWidth:'280',
                    forceSelection:true,
                    typeAhead: false,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode:'remote',
                    pageSize:20,
                    queryDelay:500,
                    gwidth: 250,
                    width: 200,
                    minChars:2
                },
                type:'ComboBox',
                id_grupo: 0,
                form: true
            },
            {
                config:{
                    name : 'id_gestion',
                    origen : 'GESTION',
                    fieldLabel : 'Gestion',
                    gdisplayField: 'desc_gestion',
                    allowBlank : false,
                    width: 200
                },
                type : 'ComboRec',
                id_grupo : 0,
                form : true
            },
            {
                config:{
                    name:'id_periodo',
                    fieldLabel:'Periodo',
                    allowBlank:false,
                    emptyText:'Periodo...',
                    store: new Ext.data.JsonStore({
                        url: '../../sis_parametros/control/Periodo/listarPeriodo',
                        id: 'id_periodo',
                        root: 'datos',
                        sortInfo:{
                            field: 'id_periodo',
                            direction: 'ASC'
                        },
                        totalProperty: 'total',
                        fields: ['id_periodo','literal','periodo','fecha_ini','fecha_fin'],
                        // turn on remote sorting
                        remoteSort: true,
                        baseParams:{par_filtro:'periodo#literal'}
                    }),
                    valueField: 'id_periodo',
                    displayField: 'literal',
                    hiddenName: 'id_periodo',
                    forceSelection:true,
                    typeAhead: false,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode:'remote',
                    pageSize:12,
                    queryDelay:1000,
                    listWidth:600,
                    resizable:true,
                    width: 200
                },
                type:'ComboBox',
                id_grupo:0,
                form:true
            },
            {
                config:{
                    name: 'revisado',
                    fieldLabel: 'Revisado',
                    allowBlank: false,
                    emptyText:'Tipo...',
                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode: 'local',
                    width:150,
                    store:['no','si']
                },
                type:'ComboBox',
                id_grupo:0,
                valorInicial: 'no',
                form:true
            },
            {
                config:{
                    name:'agrupar',
                    fieldLabel:'Agrupar por',
                    allowBlank:false,
                    emptyText:'Tipo de moneda...',
                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode: 'local',
                    valueField: 'tipo_moneda',
                    gwidth: 100,
                    store:new Ext.data.ArrayStore({
                        fields: ['variable', 'valor'],
                        data : [
                            ['ninguno','Ninguno'],
                            ['centro_costo','Centro Costo'],
                            ['depto','Depto'],
                            ['depto_cc','Depto/Centro Costo']

                        ]
                    }),
                    valueField: 'variable',
                    displayField: 'valor',
                    listeners: {
                        'afterrender': function(combo){
                            combo.setValue('ninguno');
                        }
                    }
                },
                type:'ComboBox',
                form:true
            }
        ],
        topBar : true,
        botones : false,
        labelSubmit : 'Generar',
        tooltipSubmit : '<b>Reporte Proyectoa</b>',
        constructor : function(config) {
            Phx.vista.ReporteRegistroVentas.superclass.constructor.call(this, config);
            this.init();
            this.iniciarEventos();
        },
        tipo : 'reporte',
        clsSubmit : 'bprint',
        ActSave:'../../sis_contabilidad/control/DocCompraVenta/reporteRegistroVentas',
        iniciarEventos:function(){
            this.Cmp.id_gestion.on('select',function(c,r,n){
                this.Cmp.id_periodo.reset();
                this.Cmp.id_periodo.store.baseParams={id_gestion:c.value, vista: 'reporte'};
                this.Cmp.id_periodo.modificado=true;
            },this);
        },
        agregarArgsExtraSubmit: function() {
            this.argumentExtraSubmit.gestion = this.Cmp.id_gestion.getRawValue();
            this.argumentExtraSubmit.periodo = this.Cmp.id_periodo.getRawValue();
            this.argumentExtraSubmit.depto = this.Cmp.id_depto.getRawValue();
            this.argumentExtraSubmit.plantilla = this.Cmp.id_plantilla.getRawValue();
        }
    })
</script>

