<?php
/**
 *@package pXP
 *@file gen-DetalleDetReporteAux.php
 *@author  (m.mamani)
 *@date 19-10-2018 15:39:09
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.DetalleDetReporteAux=Ext.extend(Phx.gridInterfaz,{

            constructor:function(config){
                this.maestro=config.maestro;
                //llama al constructor de la clase padre
                Phx.vista.DetalleDetReporteAux.superclass.constructor.call(this,config);
                this.init();
            },

            Atributos:[
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_detalle_det_reporte_aux'
                    },
                    type:'Field',
                    form:true
                },
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_plantilla_reporte'
                    },
                    type:'Field',
                    form:true
                },
                {
                    config: {
                        name: 'concepto',
                        fieldLabel: 'Nro. Cuenta',
                        allowBlank: true,
                        emptyText: 'Elija una opción...',
                        qtip: 'Define la cuenta sobre las que se realizan las operaciones',
                        store: new Ext.data.JsonStore({
                            url: '../../sis_contabilidad/control/Cuenta/listarCuenta',
                            id: 'id_cuenta',
                            root: 'datos',
                            sortInfo:{
                                field: 'nro_cuenta',
                                direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_cuenta','nombre_cuenta','desc_cuenta','nro_cuenta','gestion','desc_moneda'],
                            // turn on remote sorting
                            remoteSort: true,
                            baseParams: {par_filtro:'nro_cuenta#nombre_cuenta#desc_cuenta','filtro_ges':'actual'}
                        }),
                        displayField: 'nro_cuenta',
                        valueField: 'nro_cuenta',
                        tpl: new Ext.XTemplate([
                            '<tpl for=".">',
                            '<div class="x-combo-list-item">',
                            '<div class="awesomecombo-item {checked}">',
                            '<p><span style="color: red;">{nro_cuenta}</span>&nbsp;&nbsp;<b>{nombre_cuenta}</b></p>',
                            '</div>',
                            '</div></tpl>'
                        ]),
                        forceSelection: true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender: true,
                        mode: 'remote',
                        pageSize: 500,
                        queryDelay: 1000,
                        anchor: '50%',
                        gwidth:200,
                        width: 350,
                        minChars: 2,
                        enableMultiSelect: true,
                        renderer:function (value, p, record){
                            return String.format('{0}',record.data['concepto']);
                        }
                    },
                    type: 'AwesomeCombo',
                    id_grupo: 1,
                    grid: true,
                    egrid: true,
                    form: true

                },
                {
                    config: {
                        name: 'partida',
                        fieldLabel: 'Partida',
                        allowBlank: true,
                        emptyText: 'Elija una opción...',
                        qtip:'Partidas para comprobantes,  prevalece sobre la relación contable  (No se usa en reporte)',
                        store: new Ext.data.JsonStore({
                            url: '../../sis_presupuestos/control/Partida/listarPartida',
                            id: 'codigo',
                            root: 'datos',
                            sortInfo:{
                                field: 'nombre_partida',
                                direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_partida','codigo','nombre_partida','tipo','sw_movimiento'],
                            remoteSort: true,
                            baseParams: {par_filtro:'codigo#nombre_partida','filtro_ges':'actual'}
                        }),
                        valueField: 'codigo',
                        displayField: 'nombre_partida',
                        tpl: new Ext.XTemplate([
                            '<tpl for=".">',
                            '<div class="x-combo-list-item">',
                            '<div class="awesomecombo-item {checked}">',
                            '<p><span style="color: red;">{codigo}</span>&nbsp;&nbsp;<b>{nombre_partida}</b></p>',
                            '</div>',
                            '</div></tpl>'
                        ]),
                        forceSelection: true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender: true,
                        mode: 'remote',
                        pageSize: 500,
                        queryDelay: 1000,
                        anchor: '50%',
                        gwidth:200,
                        width: 350,
                        minChars: 2,
                        enableMultiSelect: true,
                        renderer:function (value, p, record){
                            return String.format('{0}',record.data['partida']);
                        }
                    },
                    type: 'AwesomeCombo',
                    id_grupo: 1,
                    grid: true,
                    egrid: true,
                    form: true
                },
                {
                    config:{
                        name:'origen',
                        fieldLabel:'Origen',
                        typeAhead: true,
                        allowBlank:true,
                        triggerAction: 'all',
                        emptyText:'Tipo...',
                        selectOnFocus:true,
                        mode:'local',
                        store:new Ext.data.ArrayStore({
                            fields: ['ID', 'valor'],
                            data :	[
                                ['debe','Debe'],
                                ['haber','Haber'],
                                ['saldo','Saldo']
                            ]
                        }),
                        valueField:'ID',
                        displayField:'valor',
                        anchor: '50%',
                        gwidth:100
                    },
                    type:'ComboBox',
                    id_grupo:1,
                    grid:true,
                    egrid: true,
                    form:true
                },
                {
                    config:{
                        name: 'orden_fila',
                        fieldLabel: 'Orden',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:65536
                    },
                    type:'NumberField',
                    filters:{pfiltro:'dra.orden_fila',type:'numeric'},
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
                    filters:{pfiltro:'dra.estado_reg',type:'string'},
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
                        name: 'usuario_ai',
                        fieldLabel: 'Funcionaro AI',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:300
                    },
                    type:'TextField',
                    filters:{pfiltro:'dra.usuario_ai',type:'string'},
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
                    filters:{pfiltro:'dra.fecha_reg',type:'date'},
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
                    filters:{pfiltro:'dra.id_usuario_ai',type:'numeric'},
                    id_grupo:1,
                    grid:false,
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
                    filters:{pfiltro:'dra.fecha_mod',type:'date'},
                    id_grupo:1,
                    grid:true,
                    form:false
                }
            ],
            tam_pag:50,
            title:'Detalle Reporte Auxliar',
            ActSave:'../../sis_contabilidad/control/DetalleDetReporteAux/insertarDetalleDetReporteAux',
            ActDel:'../../sis_contabilidad/control/DetalleDetReporteAux/eliminarDetalleDetReporteAux',
            ActList:'../../sis_contabilidad/control/DetalleDetReporteAux/listarDetalleDetReporteAux',
            id_store:'id_detalle_det_reporte_aux',
            fields: [
                {name:'id_detalle_det_reporte_aux', type: 'numeric'},
                {name:'estado_reg', type: 'string'},
                {name:'partida', type: 'string'},
                {name:'orden_fila', type: 'numeric'},
                {name:'origen', type: 'string'},
                {name:'concepto', type: 'string'},
                {name:'id_usuario_reg', type: 'numeric'},
                {name:'usuario_ai', type: 'string'},
                {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'id_usuario_ai', type: 'numeric'},
                {name:'id_usuario_mod', type: 'numeric'},
                {name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'usr_reg', type: 'string'},
                {name:'usr_mod', type: 'string'},
                {name:'id_plantilla_reporte', type: 'numeric'}

            ],
            sortInfo:{
                field: 'id_detalle_det_reporte_aux',
                direction: 'ASC'
            },
            bdel:true,
            bsave:true,
            onReloadPage:function(m){
                this.maestro=m;
                this.store.baseParams = {id_plantilla_reporte: this.maestro.id_plantilla_reporte };
                this.load({params:{start:0, limit:50}})
            },
            loadValoresIniciales: function () {
                this.Cmp.id_plantilla_reporte.setValue(this.maestro.id_plantilla_reporte);
                Phx.vista.DetalleDetReporteAux.superclass.loadValoresIniciales.call(this);
            }
        }
    )
</script>

		