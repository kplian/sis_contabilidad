<?php
header("content-type: text/javascript; charset=UTF-8");
?>
<style type="text/css" rel="stylesheet">
    .dato_relevante {
        background-color: #bdffb2;
        color: #090;
    }
</style>

<script>

Phx.vista.Historico=Ext.extend(Phx.gridInterfaz,{
    viewConfig: {
        getRowClass: function(record, rowIndex, rowParams,store) {
            if(rowIndex == 0){
                return 'dato_relevante';
            }
        }
    },
    constructor:function(config){
        this.maestro=config.maestro;
        Phx.vista.Historico.superclass.constructor.call(this,config);
        this.init();
        this.onReloadPage();
    },
    //
    Atributos :
    [
        {
            config:{
                labelSeparator:'',
                inputType:'hidden',
                name: 'id_historico'
            },
            type:'Field',
            form:false
        },
        {
            config:{
                labelSeparator:'',
                inputType:'hidden',
                name: 'id_int_transaccion'
            },
            type:'Field',
            form:false
        },
        {
            config:{
                name: 'glosa_actual',
                fieldLabel: 'Glosa Anterior',
                allowBlank: true,
                anchor: '80%',
                gwidth: 110,
                renderer:function (value, p, record){
                    if (record.data.glosa_actual===null){
                        return '-';
                    }else{
                        return '<div class="gridmultiline">'+value+'</div>';
                    }
                },
            },
            type:'TextArea',
            filters:{pfiltro:'glosa_actual',type:'string'},
            id_grupo:1,
            grid:true,
            bottom_filter:true
        },
        {
            config:{
                name: 'glosa',
                fieldLabel: 'Glosa Modificada',
                allowBlank: true,
                anchor: '80%',
                gwidth: 110,
                renderer:function (value, p, record){
                    if (record.data.glosa===null){
                        return '-';
                    }else{
                        return '<div class="gridmultiline">'+value+'</div>';
                    }
                },
            },
            type:'TextArea',
            filters:{pfiltro:'glosa',type:'string'},
            id_grupo:0,
            grid:true,
            bottom_filter:true
        },
        {
            config:{
                labelSeparator:'',
                inputType:'hidden',
                name: 'id_auxiliar_actual'
            },
            type:'Field',
            form:false
        },
        {
            config:{
                name: 'nombre_auxiliar_actual',
                fieldLabel: 'Auxiliar Anterior',
                allowBlank: true,
                anchor: '80%',
                gwidth: 110,
                renderer:function (value, p, record){
                    if (record.data.nombre_auxiliar_actual===null){
                        return '-';
                    }else{
                        return '<div class="gridmultiline">'+value+'</div>';
                    }
                },
            },
            type:'TextArea',
            filters:{pfiltro:'nombre_auxiliar_actual',type:'string'},
            id_grupo:1,
            grid:true,
            bottom_filter:true
        },
        {
            config:{
                labelSeparator:'',
                inputType:'hidden',
                name: 'id_auxiliar'
            },
            type:'Field',
            form:false
        },
        {
            config:{
                name: 'nombre_auxiliar',
                fieldLabel: 'Auxiliar Modificada',
                allowBlank: true,
                anchor: '80%',
                gwidth: 110,
                renderer:function (value, p, record){
                    if (record.data.nombre_auxiliar===null){
                        return '-';
                    }else{
                        return '<div class="gridmultiline">'+value+'</div>';
                    }
                },
            },
            type:'TextArea',
            filters:{pfiltro:'nombre_auxiliar',type:'string'},
            id_grupo:0,
            grid:true,
            bottom_filter:true
        },
        {
            config:{
                name: 'motivo',
                fieldLabel: 'Motivo',
                allowBlank: true,
                anchor: '80%',
                gwidth: 110
            },
            type:'TextArea',
            filters:{pfiltro:'motivo',type:'string'},
            id_grupo:0,
            grid:true,
            bottom_filter:true
        },
        {
            config:{
                name: 'cuenta',
                fieldLabel: 'Usuario Reg',
                allowBlank: true,
                anchor: '80%',
                gwidth: 110
            },
            type:'TextArea',
            filters:{pfiltro:'cuenta',type:'string'},
            id_grupo:0,
            grid:true,
            bottom_filter:true
        },
        {
            config:{
                name: 'fecha_reg',
                fieldLabel: 'Fecha creación',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                format: 'd/m/Y',
                renderer:function (value,p,record)
                {
                    return value?value.dateFormat('d/m/Y H:i:s'):''
                }
            },
            type:'DateField',
            filters:{pfiltro:'fecha_reg',type:'date'},
            id_grupo:0,
            grid:true
        },
    ],

    title:'Historico',
    tam_pag: 50,
    ActList: '../../sis_contabilidad/control/IntTransaccion/listarHistorico',
    id_store: 'id_historico',
    fields: [
        'id_historico',
        {name:'id_int_transaccion', type: 'numeric'},
        'glosa',
        'glosa_actual',
        'id_auxiliar',
        'nombre_auxiliar',
        'id_auxiliar_actual',
        'nombre_auxiliar_actual',
        'motivo',
        {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
        'cuenta',
    ],
    sortInfo:{
        field: 'id_historico',
        direction: 'desc'
    },
    bnew : false,
    bedit: false,
    bdel:  false,
    bsave: false,
    //
    onReloadPage:function(m){
        this.maestro=m;
        var dataPadre = Phx.CP.getPagina(this.idContenedorPadre).detalle.id_int_transaccion;
        this.store.baseParams = {
            start:0,
            limit:50,
            sort:'id_historico',
            dir:'desc',
            id_int_transaccion:dataPadre,
            contenedor: this.idContenedor
        };
        this.store.reload({ params: this.store.baseParams});
    },
    //
})
</script>