<?php
/**
 *@package pXP
 *@file gen-ContratoFactura.php
 *@author  (m.mamani)
 *@date 19-09-2018 13:16:55
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.ContratoFactura=Ext.extend(Phx.gridInterfaz,{

            constructor:function(config){
                this.initButtons=[this.cmbGestion];
                this.maestro=config.maestro;
                Phx.vista.ContratoFactura.superclass.constructor.call(this,config);
                this.init();
                this.cmbGestion.on('select',this.capturarEventos, this);
            },

            Atributos:[
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_contrato'
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
                },{
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'codigo_aux'
                    },
                    type:'Field',
                    form:true
                },
                {
                    config:{
                        name: 'nro_tramite',
                        fieldLabel: 'Nro. Tramite',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 150
                    },
                    type:'TextField',
                    filters:{pfiltro:'pw.nro_tramite',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:true,
                    bottom_filter:true
                },
                {
                    config:{
                        name: 'tipo',
                        fieldLabel: 'Tipo',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:30
                    },
                    type:'TextField',
                    filters:{pfiltro:'ccf.tipo',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'desc_funcionario',
                        fieldLabel: 'Solicitante',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 200
                    },
                    type:'TextField',
                    filters:{pfiltro:'fun.desc_funcionario1',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:true,
                    bottom_filter:true
                },
                {
                    config:{
                        name: 'numero_contrato',
                        fieldLabel: 'Numero Contrato',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 80
                    },
                    type:'TextField',
                    filters:{pfiltro:'co.numero',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:true,
                    bottom_filter:true
                },
                {
                    config:{
                        name: 'desc_proveedor',
                        fieldLabel: 'Proveedor',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 200
                    },
                    type:'TextField',
                    filters:{pfiltro:'pr.desc_proveedor',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:true,
                    bottom_filter:true
                },
                {
                    config:{
                        name: 'objeto',
                        fieldLabel: 'objeto',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100
                    },
                    type:'TextField',
                    filters:{pfiltro:'ccf.objeto',type:'string'},
                    id_grupo:1,
                    grid:false,
                    form:false
                },
                {
                    config:{
                        name: 'bancarizacion',
                        fieldLabel: 'bancarizacion',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:2
                    },
                    type:'TextField',
                    filters:{pfiltro:'ccf.bancarizacion',type:'string'},
                    id_grupo:1,
                    grid:false,
                    form:false
                },
                {
                    config:{
                        name: 'fecha_inicio',
                        fieldLabel: 'Fecha Inicio',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        format: 'd/m/Y',
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
                    },
                    type:'DateField',
                    filters:{pfiltro:'ccf.fecha_inicio',type:'date'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'fecha_fin',
                        fieldLabel: 'Fecha Fin',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        format: 'd/m/Y',
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
                    },
                    type:'DateField',
                    filters:{pfiltro:'ccf.fecha_fin',type:'date'},
                    id_grupo:1,
                    grid:true,
                    form:true
                }
            ],
            tam_pag:50,
            title:'contrato  factura',
            ActSave:'../../sis_contabilidad/control/ContratoFactura/insertarContratoFactura',
            ActDel:'../../sis_contabilidad/control/ContratoFactura/eliminarContratoFactura',
            ActList:'../../sis_contabilidad/control/ContratoFactura/listarContratoFactura',
            id_store:'id_contrato',
            fields: [
                {name:'id_contrato', type: 'numeric'},
                {name:'objeto', type: 'string'},
                {name:'id_gestion', type: 'numeric'},
                {name:'bancarizacion', type: 'string'},
                {name:'fecha_fin', type: 'date',dateFormat:'Y-m-d'},
                {name:'nro_tramite', type: 'string'},
                {name:'tipo', type: 'string'},
                {name:'desc_proveedor', type: 'string'},
                {name:'fecha_inicio', type: 'date',dateFormat:'Y-m-d'},
                {name:'desc_funcionario', type: 'string'},
                {name:'numero_contrato', type: 'string'},
                {name:'codigo_aux', type: 'string'}

            ],
            sortInfo:{
                field: 'id_contrato',
                direction: 'ASC'
            },
            bdel:false,
            bsave:false,
            bedit:false,
            bnew:false,
            capturarEventos: function () {
                if(this.validarFiltros()){
                    this.capturaFiltros();
                }
            },
            capturaFiltros:function(combo, record, index){

                this.desbloquearOrdenamientoGrid();
                this.store.baseParams.id_gestion=this.cmbGestion.getValue();
                this.load({params:{start:0, limit:this.tam_pag}});
                //this.load();
            },
            validarFiltros:function(){
                if(this.cmbGestion.isValid()){
                    return true;
                }
                else{
                    return false;
                }
            },
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
            tabeast:[
                {
                    url:'../../../sis_contabilidad/vista/contrato_factura/Factura.php',
                    title:'Factura',
                    width:'50%',
                    cls:'Factura'
                }]

        }
    )
</script>

		