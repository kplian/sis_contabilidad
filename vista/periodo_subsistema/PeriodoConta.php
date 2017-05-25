<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  rcm
*@date 24-06-2103
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.PeriodoConta = {
	require:'../../../sis_parametros/vista/periodo_subsistema/PeriodoSubsistema.php',
	requireclase:'Phx.vista.PeriodoSubsistema',
	title:'Períodos',
	codSist: 'CONTA',
	bdel: false,
	bedit: false,
	bnew: false,
	
	constructor: function(config) {
       	Phx.vista.PeriodoConta.superclass.constructor.call(this,config);
		this.init();
		Ext.apply(this.store.baseParams,{codSist: this.codSist});
		//this.load({params:{start:0, limit:50}});
	},
	
    codReporte:'S/C',
	pdfOrientacion:'L'
};
</script>
