<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  (fprudencio)
*@date 20-09-2011 10:22:05
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.DeptoConta = {
    require:'../../../sis_parametros/vista/depto/Depto.php',
    requireclase:'Phx.vista.Depto',
    title:'Departamentos Contables',
    tipo: 'DeptoConta',
    constructor: function(config) {
        Phx.vista.DeptoConta.superclass.constructor.call(this,config);   
        
        this.store.baseParams.codigo_subsistema='CONTA';
		if(this.tipo == 'DeptoConta'){
			this.load({params:{start:0, limit:50}})
		}  
    },    
    tabsouth :[{ 
          url:'../../../sis_contabilidad/vista/periodo_compra_venta/PeriodoCompraVenta.php',
          title:'Periodos Compra Venta', 
          height:'50%',
          cls:'PeriodoCompraVenta'
   }],
   bedit:false,
   bnew:false,
   bdel:false,
   bsave:false
};
</script>