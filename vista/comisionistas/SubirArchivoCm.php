<?php
/**
 *@package pXP
 *@file    SubirArchivoCm.php
 *@author
 *@date
 *@description permites subir archivos a la tabla de documento_sol
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.SubirArchivoCm=Ext.extend(Phx.frmInterfaz,{
            ActSave:'../../sis_contabilidad/control/Comisionistas/importar_txt',

            constructor:function(config)
            {
                Phx.vista.SubirArchivoCm.superclass.constructor.call(this,config);
                this.init();
                this.loadValoresIniciales();
            },

            loadValoresIniciales:function()
            {
                Phx.vista.SubirArchivoCm.superclass.loadValoresIniciales.call(this);
                //console.log(this);
                this.getComponente('id_periodo').setValue(this.id_periodo);
                this.getComponente('id_depto_conta').setValue(this.id_depto_conta);
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
                        name: 'id_periodo'
                    },
                    type:'Field',
                    form:true
                },
                {
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_depto_conta'
                    },
                    type:'Field',
                    form:true
                },
                {
                    config:{
                        fieldLabel: "Documento (archivo Pdf,Word)",
                        gwidth: 130,
                        inputType: 'file',
                        name: 'archivo',
                        allowBlank: false,
                        buttonText: '',
                        maxLength: 150,
                        anchor:'100%'
                    },
                    type:'Field',
                    form:true
                }
            ],
            title:'Subir Archivo',
            fileUpload:true

        }
    )
</script>
