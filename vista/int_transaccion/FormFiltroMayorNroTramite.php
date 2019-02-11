<?php
/**
 *@package pXP
 *@file    FormFiltroMayorNroTramite.php
 *@author  Rensi Arteaga Copari
 *@date    27-07-2017
 *@description filtro para ejecutar el estado de cuentas
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.FormFiltroMayorNroTramite=Ext.extend(Phx.frmInterfaz,{
        constructor:function(config)
        {

            console.log('configuracion.... ',config)
            this.panelResumen = new Ext.Panel({html:''});
            this.Grupos =
                [
                    {
                        xtype: 'fieldset',
                        border: false,
                        autoScroll: true,
                        layout: 'form',
                        items: [],
                        id_grupo: 0
                    },this.panelResumen
                ];

            Phx.vista.FormFiltroMayorNroTramite.superclass.constructor.call(this,config);
            this.init();

            if(config.detalle){
                //cargar los valores para el filtro
                this.loadForm({data: config.detalle});
                var me = this;
                setTimeout(function(){
                    me.onSubmit()
                }, 1500);
            }
        },

        Atributos:[
            {
                config:{
                    name : 'id_gestion',
                    origen : 'GESTION',
                    fieldLabel : 'Gestion',
                    gdisplayField: 'desc_gestion',
                    allowBlank : false,
                    width: 150
                },
                type : 'ComboRec',
                id_grupo : 0,
                form : true
            },
            {
                config:{
                    name: 'desde',
                    fieldLabel: 'Desde',
                    allowBlank: false,
                    format: 'd/m/Y',
                    width: 150
                },
                type: 'DateField',
                id_grupo: 0,
                form: true
            },
            {
                config:{
                    name: 'hasta',
                    fieldLabel: 'Hasta',
                    allowBlank: false,
                    format: 'd/m/Y',
                    width: 150
                },
                type: 'DateField',
                id_grupo: 0,
                form: true
            },
            {
                config:{
                    sysorigen: 'sis_contabilidad',
                    name: 'id_auxiliar',
                    origen: 'AUXILIAR',
                    allowBlank: true,
                    gdisplayField: 'desc_auxiliar',
                    fieldLabel: 'Auxiliar',
                    width: 150
                },
                type:'ComboRec',
                id_grupo: 0,
                form: true
            },
            {
                config:{
                    name : 'nro_tramite',
                    fieldLabel : 'Nro Tramite',
                    items: [
                        {boxLabel: 'Normal', name: 'nro_tramite', inputValue: 'normal'},
                        {boxLabel: 'Modificado', name: 'nro_tramite', inputValue: 'modificado', checked: true}
                    ]
                },
                type : 'RadioGroupField',
                id_grupo : 0,
                form : true
            }
        ],
        labelSubmit: '<i class="fa fa-check"></i> Aplicar Filtro',
        east: {
            url: '../../../sis_contabilidad/vista/int_transaccion/NroTramiteCuenta.php',
            width: '80%',
            cls: 'NroTramiteCuenta'
        },
        title: 'Filtro de Auxiliares',
        // Funcion guardar del formulario
        onSubmit: function(o) {
            var me = this;
            if (me.form.getForm().isValid()) {
                var parametros = me.getValForm();
                this.onEnablePanel(this.idContenedor + '-east', parametros);
            }
        },

        loadValoresIniciales: function(){
            Phx.vista.FormFiltroMayorNroTramite.superclass.loadValoresIniciales.call(this);
        }
    })
</script>