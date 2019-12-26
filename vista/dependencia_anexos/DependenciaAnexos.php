<?php
/**
 *@package pXP
 *@file gen-DependenciaAnexos.php
 *@author  (miguel.mamani)
 *@date 08-08-2019 20:35:20
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.DependenciaAnexos=Ext.extend(Phx.gridInterfaz,{

            constructor:function(config){
                this.maestro=config.maestro;
                //llama al constructor de la clase padre
                Phx.vista.DependenciaAnexos.superclass.constructor.call(this,config);
                this.init();
                var dataPadre = Phx.CP.getPagina(this.idContenedorPadre).getSelectedData();
                if(dataPadre){
                    this.onEnablePanel(this, dataPadre);
                }
                else
                {
                    this.bloquearMenus();
                }
            },

            Atributos:[
                {
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_dependencia_anexos'
                    },
                    type:'Field',
                    form:true
                },
                {
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_reporte_anexos'
                    },
                    type:'Field',
                    form:true
                },
                {
                    config: {
                        name: 'id_plantilla',
                        fieldLabel: 'Plantilla',
                        allowBlank: false,
                        emptyText: 'Elija una opción...',
                        store: new Ext.data.JsonStore({
                            url: '../../sis_contabilidad/control/ReporteAnexos/listarReporteAnexos',
                            id: 'id_reporte_anexos',
                            root: 'datos',
                            sortInfo: {
                                field: 'titulo',
                                direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_reporte_anexos', 'titulo', 'codigo'],
                            remoteSort: true,
                            baseParams: {par_filtro: 'ras.titulo'}
                        }),
                        valueField: 'id_reporte_anexos',
                        displayField: 'codigo',
                        gdisplayField: 'des_titulo',
                        hiddenName: 'id_plantilla',
                        forceSelection: true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender: true,
                        mode: 'remote',
                        pageSize: 15,
                        queryDelay: 1000,
                        anchor: '100%',
                        gwidth: 100,
                        minChars: 2,
                        renderer : function(value, p, record) {
                            return String.format('{0}', record.data['des_titulo']);
                        }
                    },
                    type: 'ComboBox',
                    id_grupo: 0,
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
                    filters:{pfiltro:'das.estado_reg',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'prioridad',
                        fieldLabel: 'prioridad',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:4
                    },
                    type:'NumberField',
                    filters:{pfiltro:'das.prioridad',type:'numeric'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'obs',
                        fieldLabel: 'obs',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:100
                    },
                    type:'TextField',
                    filters:{pfiltro:'das.obs',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:true
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
                        name: 'fecha_reg',
                        fieldLabel: 'Fecha creación',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        format: 'd/m/Y',
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
                    },
                    type:'DateField',
                    filters:{pfiltro:'das.fecha_reg',type:'date'},
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
                    filters:{pfiltro:'das.usuario_ai',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'id_usuario_ai',
                        fieldLabel: 'Funcionaro AI',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:4
                    },
                    type:'Field',
                    filters:{pfiltro:'das.id_usuario_ai',type:'numeric'},
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
                    filters:{pfiltro:'das.fecha_mod',type:'date'},
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
            title:'Dependencia anexos',
            ActSave:'../../sis_contabilidad/control/DependenciaAnexos/insertarDependenciaAnexos',
            ActDel:'../../sis_contabilidad/control/DependenciaAnexos/eliminarDependenciaAnexos',
            ActList:'../../sis_contabilidad/control/DependenciaAnexos/listarDependenciaAnexos',
            id_store:'id_dependencia_anexos',
            fields: [
                {name:'id_dependencia_anexos', type: 'numeric'},
                {name:'id_reporte_anexos', type: 'numeric'},
                {name:'estado_reg', type: 'string'},
                {name:'prioridad', type: 'numeric'},
                {name:'obs', type: 'string'},
                {name:'id_usuario_reg', type: 'numeric'},
                {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'usuario_ai', type: 'string'},
                {name:'id_usuario_ai', type: 'numeric'},
                {name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'id_usuario_mod', type: 'numeric'},
                {name:'usr_reg', type: 'string'},
                {name:'usr_mod', type: 'string'},
                {name:'id_plantilla', type: 'numeric'},
                {name:'des_titulo', type: 'string'}

            ],
            sortInfo:{
                field: 'id_dependencia_anexos',
                direction: 'ASC'
            },
 
            tabeast:[
            {
                url:'../../../sis_contabilidad/vista/dependencia_anexos_det/DependenciaAnexosDet.php',
                title:'Detalle',
                width:'70%',
                cls:'DependenciaAnexosDet'
            }
        ],
            bdel:true,
            bsave:true,
            onReloadPage:function(m){
                this.maestro=m;
                this.store.baseParams = {id_reporte_anexos: this.maestro.id_reporte_anexos };
                this.load({params:{start:0, limit:50}})
            },
            loadValoresIniciales: function () {
                this.Cmp.id_reporte_anexos.setValue(this.maestro.id_reporte_anexos);
                Phx.vista.DependenciaAnexos.superclass.loadValoresIniciales.call(this);
            }
        }
    )
</script>
		
		