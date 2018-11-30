<?php
/**
*@package pXP
*@file    SubirArchivo.php
*@author  Freddy Rojas
*@date    22-03-2012
*@description permites subir archivos a la tabla de documento_sol
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.SubirArchivoTran=Ext.extend(Phx.frmInterfaz,{
    ActSave:'../../sis_contabilidad/control/IntTransaccion/SubirArchivoTran',

    constructor:function(config)
    {
        Phx.vista.SubirArchivoTran.superclass.constructor.call(this,config);
        this.init();
        this.loadValoresIniciales();
    },

    loadValoresIniciales:function()
    {
        Phx.vista.SubirArchivoTran.superclass.loadValoresIniciales.call(this);
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
                fieldLabel: "Transacciones (archivo xlsx)",
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
        },
    ],
    title:'Subir Archivo',
    fileUpload:true

}
)
</script>