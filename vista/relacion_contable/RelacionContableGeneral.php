<?php
/**
*@package pXP
*@file gen-RelacionContable.php
*@author  (admin)
*@date 16-05-2013 21:51:43
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.RelacionContableGeneral = {
	require:'../../../sis_contabilidad/vista/relacion_contable/RelacionContable.php',
	requireclase:'Phx.vista.RelacionContable',
	title:'Relacion Contable',
	constructor:function(config){
		this.maestro=config.maestro;
		this.Atributos.splice(4, 0, {
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_tipo_relacion_contable'
			},
			type:'Field',
			form:true 
		});
		
		
		
    	//llama al constructor de la clase padre
		Phx.vista.RelacionContableGeneral.superclass.constructor.call(this,config);
		this.bloquearMenus();		
	},
	onReloadPage:function(m){
		this.maestro=m;				
		this.load({params:{start:0, limit:this.tam_pag, id_tipo_relacion_contable:this.maestro.id_tipo_relacion_contable}});
		
	},	
	iniciarEventos : function() {
		
		this.Cmp.id_gestion.on('select', function (c, r, i) {
			this.Cmp.id_centro_costo.store.setBaseParam('id_gestion',r.data.id_gestion);
			this.Cmp.id_cuenta.store.setBaseParam('id_gestion',r.data.id_gestion);
			this.Cmp.id_auxiliar.store.setBaseParam('id_gestion',r.data.id_gestion);
			this.Cmp.id_partida.store.setBaseParam('id_gestion',r.data.id_gestion);
			
			this.Cmp.id_centro_costo.enable(); 
			this.Cmp.id_cuenta.enable();  
			this.Cmp.id_auxiliar.enable(); 
			this.Cmp.id_partida.enable(); 
			
			this.Cmp.codigo_aplicacion.enable();
			this.Cmp.id_tipo_presupuesto.enable();
			this.Cmp.id_moneda.enable();
			
			this.Cmp.id_centro_costo.modificado = true;
			this.Cmp.id_cuenta.modificado = true;
			this.Cmp.id_auxiliar.modificado = true;
			this.Cmp.id_partida.modificado = true;
			this.Cmp.codigo_aplicacion.modificado = true;
		    this.Cmp.id_tipo_presupuesto.modificado = true;
		    this.Cmp.id_moneda.modificado = true;
		
			
			
			this.Cmp.id_centro_costo.reset();
			this.Cmp.id_cuenta.reset();
			this.Cmp.id_auxiliar.reset();
			this.Cmp.id_partida.reset();
			this.Cmp.codigo_aplicacion.reset();
		    this.Cmp.id_tipo_presupuesto.reset();
		    this.Cmp.id_moneda.reset();
			
			
		}, this);	
		
		this.Cmp.id_cuenta.on('select', function (c, r, i) {
          
            this.Cmp.id_auxiliar.store.setBaseParam('id_cuenta',r.data.id_cuenta);
            this.Cmp.id_auxiliar.modificado = true;
            this.Cmp.id_auxiliar.reset();
            
            //this.Cmp.id_partida.store.setBaseParam('id_cuenta',r.data.id_cuenta);
            //this.Cmp.id_partida.modificado = true;
            //this.Cmp.id_partida.reset();
            
            
        }, this);
		
			
		
	},
	onButtonNew : function () {
		Phx.vista.RelacionContable.superclass.onButtonNew.call(this);		
		this.Cmp.id_tipo_relacion_contable.setValue(this.maestro.id_tipo_relacion_contable);
		this.Cmp.id_centro_costo.disable(); 
		this.Cmp.id_cuenta.disable();  
		this.Cmp.id_auxiliar.disable(); 
		this.Cmp.id_partida.disable();
		this.Cmp.codigo_aplicacion.disable();
		this.Cmp.id_tipo_presupuesto.disable();
		this.Cmp.id_moneda.disable();
			
		this.habilitarCampos();
		
	} ,
	onButtonEdit : function () {
		var selected = this.sm.getSelected().data;
		Phx.vista.RelacionContable.superclass.onButtonEdit.call(this);		
		this.Cmp.id_centro_costo.store.setBaseParam('id_gestion',selected.id_gestion);
		this.Cmp.id_cuenta.store.setBaseParam('id_gestion',selected.id_gestion);
		this.Cmp.id_auxiliar.store.setBaseParam('id_gestion',selected.id_gestion);
		this.Cmp.id_partida.store.setBaseParam('id_gestion',selected.id_gestion);
		
		this.Cmp.id_auxiliar.store.setBaseParam('id_cuenta',selected.id_cuenta);
        this.Cmp.id_partida.store.setBaseParam('id_cuenta',selected.id_gestion);
        
		
		this.habilitarCampos();
		
		this.Cmp.id_centro_costo.enable(); 
		this.Cmp.id_cuenta.enable();  
		this.Cmp.id_auxiliar.enable(); 
		this.Cmp.id_partida.enable();
		
		this.Cmp.id_centro_costo.modificado = true;
		this.Cmp.id_cuenta.modificado = true;
		this.Cmp.id_auxiliar.modificado = true;
		this.Cmp.id_partida.modificado = true;
		
	},
	habilitarCampos : function () {
		
		if (this.maestro.tiene_centro_costo == 'si' || this.maestro.tiene_centro_costo == 'si-unico') {
			this.mostrarComponente(this.Cmp.id_centro_costo);
			this.setAllowBlank(this.Cmp.id_centro_costo, false);
			
		} else if (this.maestro.tiene_centro_costo == 'si-general') {
			this.mostrarComponente(this.Cmp.id_centro_costo);
			this.setAllowBlank(this.Cmp.id_centro_costo, true);
				
		} else {
			this.Cmp.id_centro_costo.reset();
			this.ocultarComponente(this.Cmp.id_centro_costo);
			this.setAllowBlank(this.Cmp.id_centro_costo, true);
		}
		//partida
		if (this.maestro.tiene_partida == 'si') {
			this.mostrarComponente(this.Cmp.id_partida);			
			this.setAllowBlank(this.Cmp.id_partida, false);			
		} else {
			this.Cmp.id_partida.reset();
			this.ocultarComponente(this.Cmp.id_partida);
			this.setAllowBlank(this.Cmp.id_partida, true);	
		}
		//auxiliar
		if (this.maestro.tiene_auxiliar == 'si') {
			this.mostrarComponente(this.Cmp.id_auxiliar);
			this.setAllowBlank(this.Cmp.id_auxiliar, false);	
		} else {
			this.Cmp.id_auxiliar.reset();
			this.ocultarComponente(this.Cmp.id_auxiliar);
			this.setAllowBlank(this.Cmp.id_auxiliar, true);
		}
		
		//moneda
		if (this.maestro.tiene_moneda == 'si') {			
			this.mostrarComponente(this.Cmp.id_moneda);
			this.setAllowBlank(this.Cmp.id_moneda, true);
			
		} else {
			this.Cmp.id_moneda.reset();
			this.ocultarComponente(this.Cmp.id_moneda);
			this.setAllowBlank(this.Cmp.id_moneda, true);
			
		}
		//tiene_tipo_centro
		
		if (this.maestro.tiene_tipo_centro == 'si') {			
			this.mostrarComponente(this.Cmp.id_tipo_presupuesto);
			this.setAllowBlank(this.Cmp.id_tipo_presupuesto, true);
			
		} else {			
			this.Cmp.id_tipo_presupuesto.reset();
			this.ocultarComponente(this.Cmp.id_tipo_presupuesto);
			this.setAllowBlank(this.Cmp.id_tipo_presupuesto, true);
		}
		
		//tiene_aplicacion
		if (this.maestro.tiene_aplicacion == 'si') {
						
			this.mostrarComponente(this.Cmp.codigo_aplicacion);
			this.setAllowBlank(this.Cmp.codigo_aplicacion, true);
			this.Cmp.codigo_aplicacion.enable();
			this.Cmp.codigo_aplicacion.store.baseParams.catalogo_tipo = this.maestro.codigo_aplicacion_catalogo ;
			this.Cmp.codigo_aplicacion.modificado = true;
			
			
			
		} else {
			
			this.Cmp.codigo_aplicacion.reset();
			this.ocultarComponente(this.Cmp.codigo_aplicacion);
			this.setAllowBlank(this.Cmp.codigo_aplicacion, true);
		}
		
		
		
	}
};
</script>