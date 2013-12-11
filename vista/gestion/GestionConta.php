<?php
/**
*@package pXP
*@file GestionConta.php
*@author  RCM
*@date 10/12/2013
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.GestionConta = {
    bedit:false,
    bnew:false,
    bsave:false,
    bdel:false,
	require:'../../../sis_parametros/vista/gestion/Gestion.php',
	requireclase:'Phx.vista.Gestion',
	title:'Gestión',
	nombreVista: 'gestionConta',
	constructor: function(config) {
	    this.maestro=config.maestro;
     	Phx.vista.GestionConta.superclass.constructor.call(this,config);
     	this.init();
		this.load({params:{start:0, limit:50}})
		
		//Crea el botón para llamar a la replicación
		this.addButton('btnRepRelCon',
			{
				text: 'Replicar Relaciones Contables',
				iconCls: 'bchecklist',
				disabled: true,
				handler: this.replicarRelCon,
				tooltip: '<b>Replicar Relaciones Contables</b><br/>Replica la parametrización de todas las Relaciones Contables de una gestión a otra'
			}
		);
		
		//Oculta el botón para generar los periodos por subsistema
		this.getBoton('btnSincPeriodoSubsis').hide();
		
		//Creación de ventana para la gestión origen
		this.crearVentanaWF();
   },
   east: false,
   replicarRelCon: function(){
   		var d= this.sm.getSelected().data;
   		this.cmbGestOri.setValue('');
   		this.cmbGestOri.store.baseParams.antGestion=d.gestion-1;
   		this.cmbGestOri.modificado=true;
   		this.winWF.show();	
   },
   preparaMenu: function(n) {
		var tb = Phx.vista.GestionConta.superclass.preparaMenu.call(this);
	  	this.getBoton('btnRepRelCon').setDisabled(false);
  		return tb;
	},
	liberaMenu: function() {
		var tb = Phx.vista.GestionConta.superclass.liberaMenu.call(this);
		this.getBoton('btnRepRelCon').setDisabled(true);
		return tb;
	},
	crearVentanaWF: function(){
		//Creación del formulario
   		this.formWF = new Ext.form.FormPanel({
            baseCls: 'x-plain',
            autoDestroy: true,
            layout: 'form',
            items: [{
                        xtype: 'combo',
                        name: 'id_gestion_ori',
                        hiddenName: 'id_gestion_ori',
                        fieldLabel: 'Gestión origen',
                        listWidth:280,
                        allowBlank: false,
                        emptyText:'Elija la gestión de origen',
                        store:new Ext.data.JsonStore(
                        {
                            url: '../../sis_parametros/control/Gestion/listarGestion',
                            id: 'id_gestion',
                            root:'datos',
                            sortInfo:{
                                field:'ges.gestion',
                                direction:'ASC'
                            },
                            totalProperty:'total',
                            fields: ['id_gestion','gestion'],
                            remoteSort: true,
                            baseParams:{par_filtro:'ges.gestion'}
                        }),
                        valueField: 'id_gestion',
                        displayField: 'gestion',
                        forceSelection:true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender:true,
                        mode:'remote',
                        pageSize:50,
                        queryDelay:500,
                        width:210,
                        gwidth:220,
                        listWidth:'280',
                        minChars:2
                    }]
        });
        
        //Agarra los componentes en variables globales
        this.cmbGestOri =this.formWF.getForm().findField('id_gestion_ori');
        
        //Eventos
        this.cmbGestOri.store.on('exception', this.conexionFailure);
        
        //Creación de la ventna
         this.winWF = new Ext.Window({
            title: 'Replicar',
            collapsible: true,
            maximizable: true,
            autoDestroy: true,
            width: 350,
            height: 200,
            layout: 'fit',
            plain: true,
            bodyStyle: 'padding:5px;',
            buttonAlign: 'center',
            items: this.formWF,
            modal:true,
            closeAction: 'hide',
            buttons: [{
                text: 'Guardar',
                handler:this.onReplicar,
                scope:this
                
            },{
                text: 'Cancelar',
                handler:function(){this.winWF.hide()},
                scope:this
            }]
        });
   	},
   	onReplicar: function(res){
		//Llama a la función para ir al siguiente estado
   		Phx.CP.loadingShow(); 
   		var d= this.sm.getSelected().data;
		Ext.Ajax.request({
			url:'../../sis_parametros/control/Gestion/replicarRelacionesContablesGestion',
		  	params:{
		  		id_gestion:d.id_gestion,
		  		id_gestion_ori: this.cmbGestOri.getValue()
		      },
		      success:this.successRep,
		      failure: this.conexionFailure,
		      timeout:this.timeout,
		      scope:this
		});
	},
	successRep:function(resp){
        Phx.CP.loadingHide();
        this.winWF.hide();
        var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
        if(!reg.ROOT.error){
            this.reload();
            alert(reg.ROOT.datos.observaciones)
        }else{
            alert('Ocurrió un error durante el proceso')
        }
	}
  
};
</script>
