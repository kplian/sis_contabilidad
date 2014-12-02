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
Phx.vista.AfpCuenta = {
	require:'../../../sis_planillas/vista/afp/Afp.php',
	requireclase:'Phx.vista.Afp',
	title:'Afp',
	  
	east : { 
          url:'../../../sis_contabilidad/vista/relacion_contable/RelacionContableTabla.php',
          title:'Relacion Contable', 
          width:'50%',
          cls:'RelacionContableTabla',
          params:{nombre_tabla:'plani.tafp',tabla_id : 'id_afp'}
   },
   
   
   bedit:false,
   bnew:false,
   bdel:false,
   bsave:false
};
</script>
