<?php
/**
 *@package pXP
 *@file DocConceptoCtaDoc.php
 *@author  Gonzalo Sarmiento
 *@date 17-02-2017
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.DocConceptoCtaDoc = {
        require:'../../../sis_contabilidad/vista/doc_concepto/DocConcepto.php',
        requireclase:'Phx.vista.DocConcepto',
        title:'Conceptos',
        nombreVista: 'DocConceptoCtaDoc',
        bdel:true,
        bsave:false,
        bnew:true,
        id_gestion:0,

        constructor: function(config) {
            this.config = config;
            Phx.vista.DocConceptoCtaDoc.superclass.constructor.call(this, config);
            this.store.baseParams={id_doc_compra_venta:this.data.id_doc_compra_venta};
            this.init();
            this.load({params:{start:0, limit:this.tam_pag}});
            this.obtenerGestion(this.data.fecha);
            this.cargarValores();
            this.iniciarEventos();
        },

        cargarValores:function(){
            Phx.vista.DocConceptoCtaDoc.superclass.loadValoresIniciales.call(this);
            this.Cmp.id_centro_costo.store.baseParams.id_depto = this.id_depto;
            this.Cmp.id_concepto_ingas.store.baseParams.autorizacion = 'fondo_avance';
            this.Cmp.id_concepto_ingas.store.baseParams.autorizacion_nulos = 'no';
            //this.Cmp.descripcion.disable();
            //this.Cmp.cantidad_sol.disable();
            //this.Cmp.precio_unitario.disable();
            this.Cmp.precio_total.disable();
            //this.Cmp.id_orden_trabajo.disable();
        },

        onButtonEdit: function() {
            Phx.vista.DocConceptoCtaDoc.superclass.onButtonEdit.call(this);
            this.Cmp.id_doc_compra_venta.setValue(this.data.id_doc_compra_venta);
        },

        iniciarEventos: function(){

            this.Cmp.id_concepto_ingas.on('change',function( cmb, rec, ind){
                this.Cmp.id_orden_trabajo.reset();
            },this);

            this.Cmp.id_concepto_ingas.on('select',function( cmb, rec, ind){
                console.log('concepto_gasto ' + rec);
                this.Cmp.id_orden_trabajo.store.baseParams = {
                    par_filtro:'desc_orden#motivo_orden',
                    filtro_ot:rec.data.filtro_ot,
                    requiere_ot:rec.data.requiere_ot,
                    id_grupo_ots:rec.data.id_grupo_ots
                };
                this.Cmp.id_orden_trabajo.modificado = true;
                if(rec.data.requiere_ot =='obligatorio'){
                    this.Cmp.id_orden_trabajo.allowBlank = false;
                    this.Cmp.id_orden_trabajo.setReadOnly(false);
                }
                else{
                    this.Cmp.id_orden_trabajo.allowBlank = true;
                    this.Cmp.id_orden_trabajo.setReadOnly(true);
                }
                this.Cmp.id_orden_trabajo.reset();

                var idcc = this.Cmp.id_centro_costo.getValue();
                if(idcc){
                    this.checkRelacionConcepto({id_centro_costo: idcc , id_concepto_ingas: rec.data.id_concepto_ingas, id_gestion :  this.id_gestion});
                }

            },this);

            this.Cmp.precio_unitario.on('valid',function(field){
                this.calcularTotales()
            } ,this);

            this.Cmp.cantidad_sol.on('valid',function(field){
                this.calcularTotales()
            } ,this);
        },

        checkRelacionConcepto: function(cfg){
            var me = this;
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url:'../../sis_contabilidad/control/DocConcepto/verificarRelacionConcepto',
                params:{
                    id_centro_costo: cfg.id_centro_costo,
                    id_gestion: cfg.id_gestion,
                    id_concepto_ingas: cfg.id_concepto_ingas,
                    relacion: 'compra'
                },
                success: function(resp){
                    Phx.CP.loadingHide();
                    var objRes = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));

                },
                failure: function(resp){

                    this.conexionFailure(resp);
                    Phx.CP.loadingHide();
                },
                timeout: this.timeout,
                scope: this
            });

        },

        obtenerGestion:function(fecha){
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url:'../../sis_parametros/control/Gestion/obtenerGestionByFecha',
                params:{fecha:fecha},
                success:this.successGestion,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });
        },

        successGestion:function(resp){
            Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if(!reg.ROOT.error){
                this.id_gestion = reg.ROOT.datos.id_gestion;
                this.Cmp.id_centro_costo.store.baseParams.id_gestion = this.id_gestion;
                this.Cmp.id_concepto_ingas.store.baseParams.id_gestion = this.id_gestion;
            }else{

                alert('ocurrio al obtener la gestion')
            }
        },

        calcularTotales: function(){
            var porc_descuento  = this.data.importe_descuento/this.data.importe_doc;
            var pTot = this.Cmp.cantidad_sol.getValue() * this.Cmp.precio_unitario.getValue();
            this.Cmp.precio_total.setValue(pTot);
            this.Cmp.precio_total_final.setValue(pTot - (pTot * porc_descuento) );
        },

        onDestroy: function() {
            var numberItems = this.store.data.getCount();
            if(numberItems > 0){
                var total_factura = 0.00;
                for(i=0; i < numberItems; i++){
                    total_factura = parseFloat(this.store.data.items[i].data.precio_total) + parseFloat(total_factura);
                }
                if(total_factura.toFixed(2) != parseFloat(this.data.importe_doc)){
                    Ext.MessageBox.alert('Alerta', 'La suma de los conceptos no iguala con el total de la factura, importe total debe ser ' + this.data.importe_doc + ' ' + this.data.desc_moneda, function()
                        {
                            Phx.CP.loadWindows('../../../sis_contabilidad/vista/doc_concepto/DocConceptoCtaDoc.php', 'DocConceptoCtaDoc', {
                                modal : true,
                                width : '95%',
                                height : '95%',
                            }, {
                                data : this.data,
                                id_doc_compra_venta : this.data.id_doc_compra_venta,
                                id_depto : this.data.id_depto_conta
                            }, this.idContenedorPadre, 'DocConceptoCtaDoc');
                        },this
                    );
                }
            }else{
                Ext.MessageBox.alert('Alerta', 'No existen apropiaciones registradas', function()
                    {
                        Phx.CP.loadWindows('../../../sis_contabilidad/vista/doc_concepto/DocConceptoCtaDoc.php', 'DocConceptoCtaDoc', {
                            modal : true,
                            width : '95%',
                            height : '95%',
                        }, {
                            data : this.data,
                            id_depto : this.id_depto_conta
                        }, this.idContenedorPadre, 'DocConceptoCtaDoc');
                    },this
                );
            }
        }
    };
</script>
