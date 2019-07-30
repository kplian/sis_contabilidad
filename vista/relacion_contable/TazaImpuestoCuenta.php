<?php
/**
*@package pXP
*@file 
*@author  (Rensi Arteaga Copari)
*@date 225/07/2019
*@description relaciones contables pata a tabla ttaza_impuesto
 * 
 *    HISTORIAL DE MODIFICACIONES:
   	
 ISSUE            FECHA:		      AUTOR                 DESCRIPCION
   
 #66        	25/07/2019      Rensi Arteaga Copari     Creación       
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.TazaImpuestoCuenta = {
	require:'../../../sis_parametros/vista/taza_impuesto/TazaImpuesto.php',
	requireclase:'Phx.vista.TazaImpuesto',
	title:'Taza Impuesto',
	constructor: function(config) {		 
    	Phx.vista.TazaImpuestoCuenta.superclass.constructor.call(this,config);    	
	},    
	east : { 
          url:'../../../sis_contabilidad/vista/relacion_contable/RelacionContableTabla.php',
          title:'Relacion Contable', 
          width:'50%',
          cls:'RelacionContableTabla',
          params:{nombre_tabla:'param.ttaza_impuesto',tabla_id : 'id_taza_impuesto'}
   },
   
   bedit:false,
   bnew:false,
   bdel:false,
   bsave:false
};
</script>
