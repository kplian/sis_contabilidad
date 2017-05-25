<?php
/**
*@package pXP
*@file gen-TipoRelacionContable.php
*@author  (admin)
*@date 16-05-2013 21:51:43
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.TipoRelacionContableTabla = {
	require:'../../../sis_contabilidad/vista/tipo_relacion_contable/TipoRelacionContable.php',
	requireclase:'Phx.vista.TipoRelacionContable',
	title:'Tipo Relacion Contable',
	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.TipoRelacionContableTabla.superclass.constructor.call(this,config);
		this.bloquearMenus();		
	},
	onReloadPage:function(m){
		this.maestro=m;
		this.store.baseParams={id_tabla_relacion_contable:this.maestro.id_tabla_relacion_contable};
		this.load({params:{start:0, limit:50}})
	},
	onButtonNew:function(){

		Phx.vista.TipoRelacionContable.superclass.onButtonNew.call(this);
		this.getComponente('id_tabla_relacion_contable').setValue(this.maestro.id_tabla_relacion_contable);
		//Oculta componentes
		this.Cmp.partida_tipo.disable();
		this.Cmp.partida_rubro.disable();
	},
	onButtonEdit:function(){
		Phx.vista.TipoRelacionContable.superclass.onButtonEdit.call(this);
		//Oculta componentes
		if(this.Cmp.tiene_partida.getValue()=='si'){
			this.Cmp.partida_tipo.enable();
			this.Cmp.partida_rubro.enable();
			this.setAllowBlank(this.Cmp.partida_tipo, false);
			this.setAllowBlank(this.Cmp.partida_rubro, false);
		} else{
			this.Cmp.partida_tipo.disable();
			this.Cmp.partida_rubro.disable();	
			this.setAllowBlank(this.Cmp.partida_tipo, true);
			this.setAllowBlank(this.Cmp.partida_rubro, true);
		}
		
	}
};
</script>