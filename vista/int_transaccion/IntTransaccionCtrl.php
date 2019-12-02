<?php
/*
#75 		28/11/2019		  Manuel Guerra	  controlling
*/
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
    Phx.vista.IntTransaccionCtrl = Ext.extend(Phx.arbGridInterfaz, {
        constructor: function (config) {
            this.maestro = config.maestro;
            //this.initButtons=[this.cmbDepto];
            Phx.vista.IntTransaccionCtrl.superclass.constructor.call(this, config);

            //this.tbar.add('Tramite:');
            //this.tbar.add(this.datoFiltroTra);

            /*this.tbar.add('Cecos:');
            this.tbar.add(this.datoFiltroCc);

            this.tbar.add('Partida:');
            this.tbar.add(this.datoFiltroPar);*/

            this.tbar.add('Tcc:');
            this.tbar.add(this.datoFiltroTcc);

            this.addButton('btnInfo', {
                text : 'Informacion',
                iconCls : 'bpdf32',
                disabled : true,
                handler : this.loadInformacion,
                tooltip : '<b>Informacion del registro</b>'
            });
           // this.loaderTree.on('beforeload', this.onBeforeLoad, this);
            this.loaderTree.baseParams = {id: 0};
            this.init();
            this.iniciarEventos();
        },

        Atributos:[
            {
                config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id'
                },
                type:'Field',
                form:true,
                //grid:true
            },
            {
                config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'ids'
                },
                type:'Field',
                form:true,
                grid:true
            },
            {
                config:{
                    fieldLabel: 'Nro Tramite',
                    gwidth: 320,
                    name: 'nro_tramite',
                    //maxLength:200,
                    anchor: '80%',
                    gtpl:function (){
                        if(this.tipo_nodo != 'hijo'){
                            return String.format(this.nro_tramite);
                        }
                    }
                },
                type:'TextField',
                id_grupo:1,
                form:true,
                grid:true
            },{
                config:{
                    fieldLabel: '-',
                    gwidth: 10,
                    name: 'nro_tramite_fk',
                },
                type:'Field',
                id_grupo:1,
                grid:false
            },{
                config:{
                    fieldLabel: 'Centro Costo',
                    gwidth: 170,
                    name: 'desc_centro_costo',
                    maxLength:170,
                    //anchor: '80%',
                    gtpl:function (p){
                        if(this.desc_centro_costo !=null){
                            return String.format('<b><p size=2 style="color:#ff0005";>'+this.desc_centro_costo+'</p><b>');
                        }
                    }
                },
                type:'TextArea',
                id_grupo:1,
                grid:true
            },{
                config:{
                    fieldLabel: 'Partida',
                    gwidth: 150,
                    maxLength:260,
                    name: 'desc_partida',
                    anchor: '80%',
                    gtpl:function (p){
                        if(this.desc_partida !=null){
                            return String.format('<b><p size=2 style="color:#3654ff";>'+this.desc_partida+'</p><b>');
                        }
                    }
                },
                type:'TextArea',
                id_grupo:0,
                grid:true
            },{
                config:{
                    fieldLabel: 'Cuenta',
                    gwidth: 100,
                    name: 'desc_cuenta',
                    maxLength:260,
                    anchor: '80%',
                    gtpl:function (p){
                        if(this.desc_cuenta !=null){
                            return String.format('<b><p size=2 style="color:#ff6d36";>'+this.desc_cuenta+'</p><b>');
                        }
                    }
                },
                type:'TextArea',
                id_grupo:0,
                grid:false
            },{
                config:{
                    fieldLabel: 'Auxiliar',
                    gwidth: 100,
                    maxLength:260,
                    name: 'desc_auxiliar',
                    anchor: '80%',
                    gtpl:function (p){
                        if(this.desc_auxiliar !=null){
                            return String.format('<b><p size=2 style="color:#3654ff";>'+this.desc_auxiliar+'</p><b>');
                        }
                    }
                },
                type:'TextArea',
                id_grupo:0,
                grid:false
            },{
                config:{
                    name: 'importe_debe_mb',
                    fieldLabel: 'Debe MB',
                    gwidth: 150,
                    galign: 'right',
                    gtpl: function (){
                        if(this.tipo_nodo != 'hijo'){
                            return String.format('<b><p size=2 style="color:#161142";>'+Ext.util.Format.number(this.importe_debe_mb,'0,000.00')+'</p><b>');
                        }else{
                            return  String.format('<b>{0}<b>',Ext.util.Format.number(this.importe_debe_mb,'0,000.00'));
                        }

                    }
                },
                type:'Field',
                grid:true,
            },{
                config:{
                    name: 'importe_haber_mb',
                    fieldLabel: 'Haber MB',
                    gwidth: 150,
                    galign: 'right',
                    gtpl: function (){
                        return  String.format('<b>{0}<b>',Ext.util.Format.number(this.importe_haber_mb,'0,000.00'));
                    }
                },
                type:'Field',
                grid:true,
            },{
                config:{
                    name: 'importe_debe_mt',
                    fieldLabel: 'Debe MT',
                    gwidth: 150,
                    galign: 'right',
                    gtpl: function (){
                        return  String.format('<b>{0}<b>',Ext.util.Format.number(this.importe_debe_mt,'0,000.00'));
                    }
                },
                type:'Field',
                id_grupo:0,
                grid:true,
            },{
                config:{
                    name: 'importe_haber_mt',
                    fieldLabel: 'Haber MT',
                    gwidth: 150,
                    galign: 'right',
                    gtpl: function (){
                        return  String.format('<b>{0}<b>',Ext.util.Format.number(this.importe_haber_mt,'0,000.00'));
                    }
                },
                type:'Field',
                id_grupo:0,
                grid:true,
            },
            {
                config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_int_transaccion'
                },
                type:'Field',
                form:true,
                grid:false
            },{
                config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_int_comprobante'
                },
                type:'Field',
                form:true,
                grid:false
            },
        ],
       /* datoFiltroTra:new Ext.form.Field({
                        allowBlank:true,
                        enableKeyEvents : true,
                        width: 150
                    }),*/
        /*datoFiltroCc:new Ext.form.Field({
                        allowBlank:true,
                        enableKeyEvents : true,
                        width: 150
                    }),
        datoFiltroPar:new Ext.form.Field({
                        allowBlank:true,
                        enableKeyEvents : true,
                        width: 150
                    }),*/



        datoFiltroTcc: new Ext.form.ComboBox({
            name:'id_tipo_cc',
            fieldLabel:'Tipo Centro',
            allowBlank:true,
            emptyText:'Tipo de Centro...',
            baseParams: {movimiento:'si'},
            store: new Ext.data.JsonStore({
                url: '../../sis_parametros/control/TipoCc/listarTipoCc',
                id: 'id_tipo_cc',
                root: 'datos',
                sortInfo:{
                    field: 'codigo',
                    direction: 'ASC'
                },
                totalProperty: 'total',
                fields: [
                    'id_tipo_cc','codigo','control_techo','mov_pres','estado_reg',
                    'movimiento', 'id_ep','id_tipo_cc_fk','descripcion','tipo',
                    'control_partida','momento_pres','desc_ep',
                    {name:'fecha_inicio', type: 'date',dateFormat:'Y-m-d'},
                    {name:'fecha_final', type: 'date',dateFormat:'Y-m-d'}],
                // turn on remote sorting
                remoteSort: true,
                baseParams:{par_filtro:'tcc.id_tipo_cc#tcc.codigo#tcc.descripcion#tcc.desc_ep'},

            }),
            tpl:'<tpl for="."><div class="x-combo-list-item"><p>{codigo}</p><p>Desc:{descripcion}</p><p>Tipo:{tipo}</p><p>Ini.:{fecha_inicio:date("d/m/Y")}</p><p>Fin.:{fecha_final:date("d/m/Y")}</p><p>EP: {desc_ep}</p>  </div></tpl>',
            valueField: 'id_tipo_cc',
            displayField: 'codigo',
            gdisplayField: 'desc_tcc',
            hiddenName: 'id_tipo_cc',
            forceSelection:false,
            typeAhead: false,
            triggerAction: 'all',
            lazyRender:true,
            mode:'remote',
            pageSize:10,
            queryDelay:1000,
            listWidth:'320',
            width:150,
            minChars:2
        }),

        NodoCheck: false,//si los nodos tienen los valores para el check
        baseParams: {clasificacion: true},
        fwidth: 420,
        fheight: 300,
        enableDD: false,
        ActList:'../../sis_contabilidad/control/IntTransaccion/listarTransArbol',
        id_nodo:'nro_tramite',
        id_nodo_p:'nro_tramite_fk',
        id_store:'nro_tramite',
        textRoot:'Tramites',

        sortInfo:{
            field: 'nro_tramite',
            direction: 'ASC'
        },
        bnew: false,
        bedit: false,
        bdel:false,
        bsave:false,
        rootVisible: false,
        expanded: false,

        fields: [
           // {name:'id_int_transaccion', type: 'integer'},
           // {name:'id_int_comprobante', type: 'integer'},
            {name:'nro_tramite', type: 'string'},
            {name:'nro_tramite_fk', type: 'string'},
            {name:'desc_cuenta', type: 'string'},
            {name:'desc_auxiliar', type: 'string'},
            {name:'desc_centro_costo', type: 'string'},
            {name:'desc_partida', type: 'string'},
            'importe_debe_mb',
            'importe_haber_mb',
            'importe_debe_mt',
            'importe_haber_mt',
            {name:'ids', type: 'integer'},
            'id_int_comprobante',
            'id_int_transaccion'
        ],

        loadValoresIniciales: function () {
            Phx.vista.IntTransaccionCtrl.superclass.loadValoresIniciales.call(this);
            this.Cmp.id.setValue(this.maestro.id);
        },

        onReloadPage: function (m) {
            v_maestro =m;
            this.maestro = m;
            this.loaderTree.baseParams =
                {
                    id: this.maestro.id,
                    id_tipo_cc: this.maestro.numero,
                    desde: this.maestro.desde,
                    hasta: this.maestro.hasta,
                    tipo: this.maestro.tipo,
                    id_gestion:this.maestro.id_gestion,
                    id_periodo:this.maestro.id_periodo,
                    desc_centro_costo:'',
                    desc_partida:'',
                   // tramite:'',
                };
            this.sm.clearSelections();
            this.root.reload();
        },

        iniciarEventos:function(){
            this.datoFiltroTcc.on('select', function(combo, record, index){
                this.onButtonAct();
            },this);
           // Phx.CP.loadingHide();
            /*this.datoFiltroCc.on('specialkey',function(field, e){
                if (e.getKey() == e.ENTER) {
                    this.onButtonAct();
                }
            },this);
            this.datoFiltroPar.on('specialkey',function(field, e){
                if (e.getKey() == e.ENTER) {
                    this.onButtonAct();
                }
            },this)*/
        },

        onButtonAct:function(){
            this.sm.clearSelections();
            var cc = this.datoFiltroTcc.lastSelectionText;

            if((cc && cc!='')){
                this.loaderTree.baseParams={
                        id: this.maestro.id,
                        id_tipo_cc: this.maestro.numero,
                        desde: this.maestro.desde,
                        hasta: this.maestro.hasta,
                        tipo: this.maestro.tipo,
                        id_gestion:this.maestro.id_gestion,
                        id_periodo:this.maestro.id_periodo,
                        desc_centro_costo:cc,
                        desc_partida:'',
                       // tramite:tra,
                    };
            }
            else{
                this.loaderTree.baseParams={
                    id: this.maestro.id,
                    id_tipo_cc: this.maestro.numero,
                    desde: this.maestro.desde,
                    hasta: this.maestro.hasta,
                    tipo: this.maestro.tipo,
                    id_gestion:this.maestro.id_gestion,
                    id_periodo:this.maestro.id_periodo,
                    desc_centro_costo:'',
                    desc_partida:'',
                    //tramite:'',
                };
            }
            this.sm.clearSelections();
            this.root.reload();
        },

        loadInformacion : function() {
            var nodo = this.sm.getSelectedNode();
            console.log('**',nodo.attributes);
            Phx.CP.loadWindows('../../../sis_contabilidad/vista/int_transaccion/Informacion.php', 'Informacion del Registro', {
                width : '70%',
                height : '60%'
            },
            nodo.attributes,
            this.idContenedor,
            'Informacion');
        },
    }
)
</script>

