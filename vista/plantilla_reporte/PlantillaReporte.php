<?php
/**
 *@package pXP
 *@file gen-PlantillaReporte.php
 *@author  (m.mamani)
 *@date 06-09-2018 19:52:00
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.PlantillaReporte=Ext.extend(Phx.gridInterfaz,{

            constructor:function(config){
                this.maestro=config.maestro;
                //llama al constructor de la clase padre
                Phx.vista.PlantillaReporte.superclass.constructor.call(this,config);
                this.init();
                this.load({params:{start:0, limit:this.tam_pag}})
            },

            Atributos:[
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
                    config:{
                        name:'tipo',
                        fieldLabel:'Tipo Reporte',
                        typeAhead: true,
                        allowBlank:true,
                        triggerAction: 'all',
                        emptyText:'Tipo...',
                        selectOnFocus:true,
                        mode:'local',
                        store:new Ext.data.ArrayStore({
                            fields: ['valor', 'ID'],
                            data :	[
                                ['Formato xls','xls'],
                                ['Formato pdf','pdf']
                            ]
                        }),
                        valueField:'ID',
                        displayField:'valor',
                        anchor: '50%',
                        gwidth:100
                    },
                    type:'ComboBox',
                    id_grupo:1,
                    grid:false,
                    form:false
                },
                {
                    config:{
                        name: 'nombre',
                        fieldLabel: 'Nombre Reporte',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:100
                    },
                    type:'TextField',
                    filters:{pfiltro:'per.nombre',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name:'modalidad',
                        fieldLabel:'Modalidad',
                        typeAhead: true,
                        allowBlank:true,
                        triggerAction: 'all',
                        emptyText:'Tipo...',
                        selectOnFocus:true,
                        mode:'local',
                        store:new Ext.data.ArrayStore({
                            fields: ['valor', 'ID'],
                            data :	[
                                ['Anual','anual'],
                                ['Periodo','periodo']
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
                    form:true
                },
                {
                    config:{
                        name: 'glosa',
                        fieldLabel: 'Glosa',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100
                    },
                    type:'TextField',
                    filters:{pfiltro:'per.glosa',type:'string'},
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
                    filters:{pfiltro:'per.estado_reg',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },

                {
                    config:{
                        name: 'id_usuario_ai',
                        fieldLabel: '',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:4
                    },
                    type:'Field',
                    filters:{pfiltro:'per.id_usuario_ai',type:'numeric'},
                    id_grupo:1,
                    grid:false,
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
                    filters:{pfiltro:'per.usuario_ai',type:'string'},
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
                    filters:{pfiltro:'per.fecha_reg',type:'date'},
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
                    filters:{pfiltro:'per.fecha_mod',type:'date'},
                    id_grupo:1,
                    grid:true,
                    form:false
                }
            ],
            tam_pag:50,
            title:'plantilla reporte',
            ActSave:'../../sis_contabilidad/control/PlantillaReporte/insertarPlantillaReporte',
            ActDel:'../../sis_contabilidad/control/PlantillaReporte/eliminarPlantillaReporte',
            ActList:'../../sis_contabilidad/control/PlantillaReporte/listarPlantillaReporte',
            id_store:'id_plantilla_reporte',
            fields: [
                {name:'id_plantilla_reporte', type: 'numeric'},
                {name:'nombre', type: 'string'},
                {name:'glosa', type: 'string'},
                {name:'modalidad', type: 'string'},
                {name:'estado_reg', type: 'string'},
                {name:'tipo', type: 'string'},
                {name:'id_usuario_ai', type: 'numeric'},
                {name:'id_usuario_reg', type: 'numeric'},
                {name:'usuario_ai', type: 'string'},
                {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'id_usuario_mod', type: 'numeric'},
                {name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'usr_reg', type: 'string'},
                {name:'usr_mod', type: 'string'}

            ],
            sortInfo:{
                field: 'nombre',
                direction: 'ASC'
            },
            bdel:true,
            bsave:true,

            tabeast:[
                {
                    url : '../../../sis_contabilidad/vista/plantilla_det_reporte/PlantillaDetReporte.php',
                    title : 'Detalle del Reporte',
                    width:'70%',
                    cls : 'PlantillaDetReporte'
                },
                {
                    url : '../../../sis_contabilidad/vista/detalle_det_reporte_aux/DetalleDetReporteAux.php',
                    title : 'Detalle del Reporte Aux',
                    width:'70%',
                    cls : 'DetalleDetReporteAux'
                }
            ]
        }
    )
</script>

		