<?php
/**
*@package pXP
*@file    SolModPresupuesto.php
*@author  Rensi Arteaga Copari 
*@date    30-01-2014
*@description permites subir archivos a la tabla de documento_sol
*/
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
Phx.vista.BancoCbte=Ext.extend(Phx.frmInterfaz,{
    constructor:function(config)
    {   
    	this.panelResumen = new Ext.Panel({html:''});
    	
        Phx.vista.BancoCbte.superclass.constructor.call(this,config);
        this.init(); 
        this.iniciarEventos();   
       
        console.log('datos...',config)
        
        if(config.detalle.nombre_cheque_trans && config.detalle.nombre_cheque_trans != ''){
        	this.Cmp.nombre_cheque_trans.setValue(config.detalle.nombre_cheque_trans);
        }
        else{
        	this.Cmp.nombre_cheque_trans.setValue(config.cbte.beneficiario);
        }
        
        this.Cmp.forma_pago.setValue(config.detalle.forma_pago);
        this.Cmp.nro_cheque.setValue(config.detalle.nro_cheque);
        this.Cmp.nro_cuenta_bancaria.setValue(config.detalle.nro_cuenta_bancaria_trans);
        this.Cmp.id_int_transaccion.setValue(config.detalle.id_int_transaccion);
        
        
    },
    
    Atributos:[
          {
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_int_transaccion'
			},
			type:'Field',
			form:true 
		 },
         {
           config:{
               name: 'forma_pago',
               fieldLabel: 'Forma de Pago',
               gwidth: 100,
               maxLength:30,
               items: [
                   {boxLabel: 'Cheque',name: 'fp-auto',  inputValue: 'cheque', checked:true},
                   {boxLabel: 'Transferencia',name: 'fp-auto', inputValue: 'transferencia'}
               ]
           },
           type:'RadioGroupField',
           id_grupo:1,
           form:true
         }, 
         {
            config:{
                name: 'nro_cheque',
                fieldLabel: 'Número Cheque',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:255
            },
            type: 'NumberField',
            id_grupo:1,
            form:true
        },
        {
            config:{
                name: 'nro_cuenta_bancaria',
                fieldLabel: 'Banco y Cuenta Bancaria Dest.',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:50,
                disabled:true
            },
            type:'TextField',
            id_grupo:1,
            form:true
        },
        {
            config:{
                name: 'nombre_cheque_trans',
                fieldLabel: 'Nombre Pago',
                allowBlank: true,
                anchor: '80%',
                gwidth: 180,
                maxLength:255
            },
            type:'TextField',
            id_grupo:1,
            form:true
        }
		 
    ],
    title: 'Datos bancarios',
    // Funcion guardar del formulario
    onSubmit: function(o) {
    	var me = this;
    	if (me.form.getForm().isValid()) {
             var parametros = me.getValForm()
             Phx.CP.loadingShow();
             
             Ext.Ajax.request({
						url : '../../sis_contabilidad/control/IntTransaccion/guardarDatosBancos',
						params : parametros,
						success : this.successGen,
						failure : this.conexionFailure,
						timeout : this.timeout,
						scope : this
					})
                    
        }

    },
    
    successGen: function(resp){
    	Phx.CP.loadingHide();
    	Phx.CP.getPagina(this.idContenedorPadre).reload();
    	this.panel.destroy();
    },
    iniciarEventos: function(){
       this.Cmp.forma_pago.on('change',function(groupRadio,radio){
            this.ocultarCheque(radio.inputValue);
        },this);
    },
    ocultarCheque: function(pFormaPago){
        if(pFormaPago=='transferencia'){
            //Deshabilita campo cheque
            this.Cmp.nro_cheque.allowBlank=true;
            this.Cmp.nro_cheque.setValue('');
            this.Cmp.nro_cheque.disable();
            //Habilita nrocuenta bancaria destino
            this.Cmp.nro_cuenta_bancaria.allowBlank=false;
            this.Cmp.nro_cuenta_bancaria.enable();
        } else{
            //cheque
            //Habilita campo cheque
            this.Cmp.nro_cheque.allowBlank=false;
            this.Cmp.nro_cheque.enable();
            //Habilita nrocuenta bancaria destino
            this.Cmp.nro_cuenta_bancaria.allowBlank=true;
            this.Cmp.nro_cuenta_bancaria.setValue('');
            this.Cmp.nro_cuenta_bancaria.disable();
        }
        
    }
    
    
})    
</script>