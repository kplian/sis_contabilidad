<?php
    header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.editarGlosaAuxiliar=Ext.extend(Phx.frmInterfaz,{
    ActSave:'../../sis_contabilidad/control/IntTransaccion/editarGlosaAuxiliar',
    fheight : '90%',
    fwidth : '60%',
    breset: false,
    bcancel: true,
    //
    constructor:function(config)
    {
        var me = this;
        Phx.vista.editarGlosaAuxiliar.superclass.constructor.call(this,config);
        this.Cmp.id_auxiliar.store.baseParams.id_int_transaccion = this.detalle.id_int_transaccion;
        this.iniciarEventos();
        this.init();
        this.loadValoresIniciales();
    },
    //
    loadValoresIniciales:function()
    {
        Phx.vista.editarGlosaAuxiliar.superclass.loadValoresIniciales.call(this);
        this.ocultarComponente(this.Cmp.glosa);
        this.mostrarComponente(this.Cmp.id_auxiliar);
        this.ocultarComponente(this.Cmp.glosa_actual);
        this.mostrarComponente(this.Cmp.id_auxiliar_actual);
        this.Cmp.glosa_actual.reset();
        this.Cmp.id_auxiliar_actual.reset();
    },
    //
    successSave:function(resp)
    {
        Phx.CP.loadingHide();
        Phx.CP.getPagina(this.idContenedorPadre).reload();
        this.getComponente('glosa_actual').setValue(this.Cmp.glosa.getValue());
        this.getComponente('id_auxiliar_actual').setValue(this.Cmp.id_auxiliar.getValue());
        var manu = this.idContenedor+'-east';
        Phx.CP.getPagina(manu).reload();
        this.panel.close();
        alert('La modificacion fue existosa.');
        this.getComponente('motivo').setValue();
        this.Cmp.glosa.reset();
    },
    //
    Atributos:[
        {
            config:{
                labelSeparator:'',
                inputType:'hidden',
                readOnly:true,
                name: 'id_int_transaccion'
            },
            type:'Field',
            form:true
        },
        {
            config:{
                name : 'tipo_filtro',
                fieldLabel : 'Filtros',
                items: [
                    {boxLabel: 'Auxiliar', name: 'tipo_filtro', inputValue: 'auxiliar', checked: true},
                    {boxLabel: 'Glosa Transaccion', name: 'tipo_filtro', inputValue: 'glosa'}
                ],
                width : 270,
            },
            type : 'RadioGroupField',
            id_grupo : 0,
            form : true
        },
        {
            config:{
                name: 'id_auxiliar_actual',
                fieldLabel: 'Auxiliar Actual',
                readOnly:true,
                inputType:'hidden',
                width: 270,
            },
            type:'TextField',
            id_grupo:0,
            form:true
        },
        {
            config:{
                name: 'auxiliar',
                fieldLabel: 'Auxiliar Actual',
                readOnly:true,
                width: 270,
                renderer: function(val){if (val != ''){
                    return '<div class="gridmultiline">'+val+'</div>';
                    }
                }
            },
            type:'TextField',
            id_grupo:0,
            form:true
        },
        {
            config:{
                name: 'glosa_actual',
                fieldLabel: 'Glosa Actual',
                readOnly:true,
                width: 270,
                renderer: function(val){
                    if (val != ''){
                        return '<div class="gridmultiline">'+val+'</div>';
                    }
                }
            },
            type:'TextArea',
            id_grupo:0,
            form:true
        },
        { 
            config:{
                name:'id_auxiliar',
                allowBlank:true,
                fieldLabel:'Auxiliar a Modificar',
                emptyText:'Auxiliar...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_contabilidad/control/IntTransaccion/listarAuxiliarMod',
                    id: 'id_auxiliar',
                    root: 'datos',
                    sortInfo: {
                        field: 'nombre_auxiliar',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_auxiliar','nombre_auxiliar','codigo_auxiliar','fecha_reg'],
                    remoteSort: true,
                    baseParams: {par_filtro: 'codigo_auxiliar#nombre_auxiliar'}
                }),
                valueField : 'id_auxiliar',
                displayField : 'nombre_auxiliar',
                gdisplayField : 'desc_auxiliar',
                hiddenName : 'id_auxiliar',
                typeAhead : false,
                triggerAction : 'all',
                lazyRender : true,
                mode : 'remote',
                pageSize : 15,
                queryDelay : 1000,
                width : 250,
                anchor : '100%',
                gwidth : 150,
                minChars : 2,
                tpl:'<tpl for="."><div class="x-combo-list-item"><p>{codigo_auxiliar}</p><p>Nombre:{nombre_auxiliar}</p> </div></tpl>',
                renderer : function(value, p, record) {
                    return String.format('{0}', record.data['desc_auxiliar']);
                }
            },
            type:'ComboBox',
            id_grupo:0,
            form:true
        },
        {
            config:{
                name: 'glosa',
                fieldLabel: 'Glosa  a Modificar',
                allowBlank: true,
                width: 270,
                maxLength:1000,
                renderer: function(val){if (val != ''){return '<div class="gridmultiline">'+val+'</div>';}}
            },
            type:'TextArea',
            filters:{pfiltro:'transa.glosa',type:'string'},
            id_grupo:0,
            bottom_filter: true,
            form:true
        },
        {
            config:{
                name: 'motivo',
                fieldLabel: 'Motivo',
                allowBlank: false,
                width: 270,
                maxLength:1000,
            },
            type:'TextArea',
            id_grupo:0,
            grid:true
        },
    ],
    //
    iniciarEventos:function(){
        this.getComponente('id_auxiliar_actual').setValue(this.detalle.id_auxiliar);
        this.getComponente('auxiliar').setValue(this.detalle.desc_auxiliar);
        this.getComponente('glosa_actual').setValue(this.detalle.glosa);
        this.getComponente('id_int_transaccion').setValue(this.detalle.id_int_transaccion);
        this.Cmp.tipo_filtro.on('change', function(cmp, check){
            if(check.getRawValue() =='glosa'){
                this.Cmp.id_auxiliar.reset();
                this.Cmp.glosa.reset();
                this.ocultarComponente(this.Cmp.id_auxiliar);
                this.mostrarComponente(this.Cmp.glosa);
                this.ocultarComponente(this.Cmp.id_auxiliar_actual);
                this.ocultarComponente(this.Cmp.auxiliar);
                this.mostrarComponente(this.Cmp.glosa_actual);
                this.Cmp.glosa.enable();
            }else{
                this.Cmp.id_auxiliar.reset();
                this.Cmp.glosa.reset();
                this.mostrarComponente(this.Cmp.id_auxiliar);
                this.ocultarComponente(this.Cmp.glosa);
                this.mostrarComponente(this.Cmp.id_auxiliar_actual);
                this.mostrarComponente(this.Cmp.auxiliar);
                this.ocultarComponente(this.Cmp.glosa_actual);
                this.Cmp.id_auxiliar.enable();
            }
        }, this);
        
    },
    //
    east:{
        url: '../../../sis_contabilidad/vista/int_transaccion/Historico.php',
        title : 'Historico',
        width: '55%',
        cls: 'Historico',
    },
    //
}
)
</script>