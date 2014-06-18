<?php
/**
*@package pXP
*@file plantilla.php
*@author  rcm
*@date 	30/08/2013
*@description Interfaz heredada de Plantilla de parámetros
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.PlantillaConta = {
	require:'../../../sis_parametros/vista/plantilla/Plantilla.php',
	requireclase:'Phx.vista.Plantilla',
	title:'Plantilla',
	bedit: true,
	bdel:(Phx.CP.config_ini.sis_integracion=='ENDESIS')?false:true,
    bnew:(Phx.CP.config_ini.sis_integracion=='ENDESIS')?false:true,
    
	constructor: function(config) {
       	Phx.vista.PlantillaConta.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:50}});
	},
	
	south:{
		  url:'../../../sis_contabilidad/vista/plantilla_calculo/PlantillaCalculo.php',
		  title:'Plantilla Cálculo', 
		  height:'50%',
		  cls:'PlantillaCalculo'
	}

};
</script>
