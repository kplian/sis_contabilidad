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
Phx.vista.TipoRelacionContableGeneral = {
	require:'../../../sis_contabilidad/vista/tipo_relacion_contable/TipoRelacionContable.php',
	requireclase:'Phx.vista.TipoRelacionContable',
	title:'Tipo Relacion Contable',
	constructor:function(config){
		//llama al constructor de la clase padre
		Phx.vista.TipoRelacionContableGeneral.superclass.constructor.call(this,config);
		this.store.baseParams={es_general:'si'};
		this.load({params:{start:0, limit:this.tam_pag}})		
	},
	east : { 
          url:'../../../sis_contabilidad/vista/relacion_contable/RelacionContableGeneral.php',
          title:'Relacion Contable', 
          width:'50%',
          cls:'RelacionContableGeneral'
   }
};
</script>