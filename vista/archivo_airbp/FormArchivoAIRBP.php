<?php
/**
 *@package pXP
 *@file    FormArchivoAIRBP.php
 *@author  Gonzalo Sarmiento Sejas
 *@date    12-01-2017
 *@description permite subir archivo AIRBP para cargar facturas al libro de compras
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.FormArchivoAIRBP=Ext.extend(Phx.frmInterfaz,{

            constructor:function(config)
            {
                Phx.vista.FormArchivoAIRBP.superclass.constructor.call(this,config);
                this.init();
                this.loadValoresIniciales();
            },

            loadValoresIniciales:function()
            {
                Phx.vista.FormArchivoAIRBP.superclass.loadValoresIniciales.call(this);
                this.getComponente('id_int_comprobante').setValue(this.id_int_comprobante);
            },

            successSave:function(resp)
            {
                Phx.CP.loadingHide();
                Phx.CP.getPagina(this.idContenedorPadre).reload();
                this.panel.close();
            },


            Atributos:[
                {
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_int_comprobante'

                    },
                    type:'Field',
                    form:true

                },
                {
                    config:{
                        name:'codigo',
                        fieldLabel:'Codigo Archivo',
                        allowBlank:false,
                        emptyText:'Codigo Archivo...',
                        store: new Ext.data.JsonStore({
                            url: '../../sis_parametros/control/PlantillaArchivoExcel/listarPlantillaArchivoExcel',
                            id: 'id_plantilla_archivo_excel',
                            root: 'datos',
                            sortInfo:{
                                field: 'codigo',
                                direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_plantilla_archivo_excel','nombre','codigo'],
                            // turn on remote sorting
                            remoteSort: true,
                            baseParams:{par_filtro:'codigo', vista: 'vista'}
                        }),
                        valueField: 'codigo',
                        displayField: 'codigo',
                        tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{nombre}</b></p><p>{codigo}</p></div></tpl>',
                        hiddenName: 'codigo',
                        forceSelection:true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender:true,
                        mode:'remote',
                        pageSize:10,
                        queryDelay:1000,
                        listWidth:260,
                        resizable:true,
                        anchor:'90%'
                    },
                    type:'ComboBox',
                    id_grupo:0,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        fieldLabel: "Documento",
                        gwidth: 130,
                        inputType:'file',
                        name: 'archivo',
                        buttonText: '',
                        maxLength:150,
                        anchor:'100%'
                    },
                    type:'Field',
                    form:true
                }
            ],
            title:'Subir Archivo AIRBP',
            fileUpload:true,
            ActSave:'../../sis_contabilidad/control/ArchivoAirbp/subirArchivoAIRBP'
        }
    )
</script>