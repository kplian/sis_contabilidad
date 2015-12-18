<?php
/**
*@package pXP
*@file gen-PlantillaCalculo.php
*@author  rcm
*@date 30-08-2013 19:01:20
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.PlantillaCalculo=Ext.extend(Phx.gridInterfaz,{

    constructor:function(config){
        this.maestro=config.maestro;
        //llama al constructor de la clase padre
        Phx.vista.PlantillaCalculo.superclass.constructor.call(this,config);
        this.grid.getTopToolbar().disable();
        this.grid.getBottomToolbar().disable();
        this.init();
        
        //Manage Events
        this.Cmp.tipo_importe.on('select',function(cmb,rec,index){
            if(rec.data.descripcion=='porcentaje'){
                this.Cmp.importe.setMaxValue(100);
            } else{
                this.Cmp.importe.setMaxValue(Number.MAX_VALUE);
            }
        },this);
    },
            
    Atributos:[
        {
            //configuracion del componente
            config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_plantilla_calculo'
            },
            type:'Field',
            form:true 
        },
        {
            //configuracion del componente
            config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_plantilla'
            },
            type:'Field',
            form:true 
        },
        {
            config:{
                name: 'descripcion',
                fieldLabel: 'Descripción',
                allowBlank: false,
                anchor: '80%',
                gwidth: 250,
                maxLength:50
            },
                type:'TextField',
                filters:{pfiltro:'placal.descripcion',type:'string'},
                id_grupo:1,
                grid:true,
                form:true
        },
        {
            config: {
                name: 'prioridad',
                fieldLabel: 'Prioridad',
                qtip: '(1) el registro de entrada que trae el importe del documento , (2) calcula sobre el importe en uno,  (3) es solo referencial',
                anchor: '40%',
                tinit: false,
                allowBlank: false,
                origen: 'CATALOGO',
                gdisplayField: 'Prioridad',
                gwidth: 100,
                baseParams:{
                        cod_subsistema:'CONTA',
                        catalogo_tipo:'tplantilla_calculo__prioridad'
                },
                renderer:function (value, p, record){return String.format('{0}', record.data['prioridad']);}
            },
            type: 'ComboRec',
            id_grupo: 0,
            filters:{pfiltro:'placal.prioridad',type:'string'},
            grid: true,
            form: true
        },
        {
            config: {
                name: 'codigo_tipo_relacion',
                fieldLabel: 'Relación Contable',
                qtip: 'Si para esta transacción recupera (cuentas,partida auxiliar) a partir de una relación contable.  Generalmente se usa en prioridad 2, la prioridad 1 ya viene con estos parámetros, y la 3 no se procesa',
                allowBlank: true,
                emptyText: 'Elija Relación Contable...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_contabilidad/control/TipoRelacionContable/listarTipoRelacionContable',
                    id: 'id_tipo_relacion_contable',
                    root: 'datos',
                    sortInfo: {
                        field: 'codigo_tipo_relacion',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_tipo_relacion_contable','codigo_tipo_relacion','nombre_tipo_relacion'],
                    remoteSort: true,
                    baseParams: {par_filtro:'tiprelco.codigo_tipo_relacion#tiprelco.nombre_tipo_relacion'}
                }),
                valueField: 'codigo_tipo_relacion',
                displayField: 'codigo_tipo_relacion',
                gdisplayField: 'codigo_tipo_relacion',
                tpl:'<tpl for="."><div class="x-combo-list-item"><p>Código: {codigo_tipo_relacion}</p><p>Nombre: {nombre_tipo_relacion}</p></div></tpl>',
                forceSelection: true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'remote',
                pageSize: 20,
                queryDelay: 100,
                anchor: '100%',
                gwidth: 120,
                minChars: 2
            },
            type: 'ComboBox',
            filters: {
                pfiltro: 'placal.codigo_tipo_relacion',
                type: 'string'
            },
            id_grupo: 0,
            grid: true,
            form: true
        },
        {
            config: {
                name: 'debe_haber',
                fieldLabel: 'Debe / Haber',
                qtip: 'si la transacción se mueve al debe o al haber',
                anchor: '60%',
                tinit: false,
                allowBlank: false,
                origen: 'CATALOGO',
                gdisplayField: 'debe_haber',
                gwidth: 100,
                baseParams:{
                        cod_subsistema:'CONTA',
                        catalogo_tipo:'tplantilla_calculo__debe_haber'
                },
                renderer:function (value, p, record){return String.format('{0}', record.data['debe_haber']);}
            },
            type: 'ComboRec',
            id_grupo: 0,
            filters:{pfiltro:'placal.debe_haber',type:'string'},
            grid: true,
            form: true
        },
        {
            config: {
                name: 'tipo_importe',
                fieldLabel: 'Tipo Importe',
                qtip: 'si el importe es un porcentaje sobre el importe del documento o un monto fijo',
                anchor: '60%',
                tinit: false,
                allowBlank: false,
                origen: 'CATALOGO',
                gdisplayField: 'tipo_importe',
                gwidth: 100,
                baseParams:{
                        cod_subsistema:'CONTA',
                        catalogo_tipo:'tplantilla_calculo__tipo_importe'
                },
                renderer:function (value, p, record){return String.format('{0}', record.data['tipo_importe']);}
            },
            type: 'ComboRec',
            id_grupo: 0,
            filters:{pfiltro:'placal.tipo_importe',type:'string'},
            grid: true,
            form: true
        },
        {
            config:{
                name: 'importe',
                fieldLabel: 'Importe / Porcen.',
                qtip: 'valor del  importe o porcentaje para mover en el debe o haber (contable)',
                decimalPrecision:12,
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:30,
                minValue:0
            },
            type:'NumberField',
            filters:{pfiltro:'placal.importe',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'importe_presupuesto',
                fieldLabel: 'Presup. Importe / Porcen.',
                qtip: 'valor del importe o porcentaje para mover en recurso o gasto (presupuestos)',
                allowBlank: false,
                decimalPrecision:12,
                anchor: '80%',
                gwidth: 100,
                maxLength:30,
                minValue:0
            },
            type:'NumberField',
            filters:{pfiltro:'placal.importe_presupuesto',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config: {
                name: 'descuento',
                fieldLabel: 'Descuento',
                qtip: 'si la transacción tiene que considerar el descuento o no',
                anchor: '60%',
                tinit: false,
                allowBlank: false,
                origen: 'CATALOGO',
                gdisplayField: 'descuento',
                gwidth: 100,
                baseParams:{
                        cod_subsistema:'PARAM',
                        catalogo_tipo:'tgral__bandera_min'
                },
                renderer:function (value, p, record){return String.format('{0}', record.data['descuento']);}
            },
            type: 'ComboRec',
            id_grupo: 0,
            filters:{pfiltro:'placal.descuento',type:'string'},
            grid: true,
            form: true
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
                filters:{pfiltro:'placal.estado_reg',type:'string'},
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
                type:'NumberField',
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
                filters:{pfiltro:'placal.fecha_reg',type:'date'},
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
                filters:{pfiltro:'placal.fecha_mod',type:'date'},
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
                type:'NumberField',
                filters:{pfiltro:'usu2.cuenta',type:'string'},
                id_grupo:1,
                grid:true,
                form:false
        }
    ],
    tam_pag:50, 
    title:'Plantilla de Cálculo',
    ActSave:'../../sis_contabilidad/control/PlantillaCalculo/insertarPlantillaCalculo',
    ActDel:'../../sis_contabilidad/control/PlantillaCalculo/eliminarPlantillaCalculo',
    ActList:'../../sis_contabilidad/control/PlantillaCalculo/listarPlantillaCalculo',
    id_store:'id_plantilla_calculo',
    fields: [
        {name:'id_plantilla_calculo', type: 'numeric'},
        {name:'prioridad', type: 'numeric'},
        {name:'debe_haber', type: 'string'},
        {name:'tipo_importe', type: 'string'},
        {name:'id_plantilla', type: 'numeric'},
        {name:'codigo_tipo_relacion', type: 'string'},
        {name:'importe', type: 'numeric'},
        {name:'descripcion', type: 'string'},
        {name:'estado_reg', type: 'string'},
        {name:'id_usuario_reg', type: 'numeric'},
        {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
        {name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
        {name:'id_usuario_mod', type: 'numeric'},
        {name:'usr_reg', type: 'string'},
        {name:'usr_mod', type: 'string'},
        {name:'importe_presupuesto', type: 'numeric'},
        {name:'descuento', type: 'string'}
        
    ],
    sortInfo:{
        field: 'id_plantilla_calculo',
        direction: 'ASC'
    },
    bdel:true,
    bsave:true,
    loadValoresIniciales:function(){
        Phx.vista.PlantillaCalculo.superclass.loadValoresIniciales.call(this);
        this.Cmp.id_plantilla.setValue(this.maestro.id_plantilla);      
    },
    onReloadPage:function(m){
        this.maestro=m;                     
        this.store.baseParams={id_plantilla:this.maestro.id_plantilla};
        this.load({params:{start:0, limit:this.tam_pag}});          
    }
})
</script>
        
        