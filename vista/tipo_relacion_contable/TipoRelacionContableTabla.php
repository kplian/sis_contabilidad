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
		
	}
};
</script>