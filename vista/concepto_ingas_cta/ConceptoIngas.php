<?php
/**
*@package pXP
*@file ConceptoIngas.php
*@author  RCM
*@date 20-09-2011 10:22:05
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ConceptoIngasCuenta = {
	require:'../../../sis_parametros/vista/concepto_ingas/ConceptoIngas.php',
	requireclase:'Phx.vista.ConceptoIngas',
	title:'Conceptos',
	constructor: function(config) {
    	Phx.vista.ConceptoIngasCuenta.superclass.constructor.call(this,config);    	
	}, 
	tabeast:[
		  { 
	          url:'../../../sis_contabilidad/vista/relacion_contable/RelacionContableTabla.php',
	          title:'Relacion Contable', 
	          width:'50%',
	          cls:'RelacionContableTabla',
	          params:{nombre_tabla:'param.tconcepto_ingas',tabla_id : 'id_concepto_ingas'}
   		 },
	      { 
		  url:'../../../sis_presupuestos/vista/concepto_partida/ConceptoPartida.php',
		  title:'Partidas', 
		  height:'50%',
		  cls:'ConceptoPartida'
		 }],
   bedit:true,
   bnew:true,
   bdel:true,
   bsave:false,
   EnableSelect : function (n, extra) {
   		var selected = this.sm.getSelected().data;
   		var miExtra = {codigos_tipo_relacion:'', filtro_partida : {propiedad: 'id_concepto_ingas', valor : selected.id_concepto_ingas,tipo:'CUECOMP'}};
   		
   		if (extra != null && typeof extra === 'object') {
   			miExtra = Ext.apply(extra, miExtra) 
   		} 
   		 		
   		Phx.vista.ConceptoIngasCuenta.superclass.EnableSelect.call(this,n,miExtra);  
   		
   }
};
</script>
