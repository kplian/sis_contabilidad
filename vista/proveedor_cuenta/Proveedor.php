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
Phx.vista.ProveedorCuenta = {
	require:'../../../sis_adquisiciones/vista/proveedor/Proveedor.php',
	requireclase:'Phx.vista.Proveedor',
	title:'Proveedor',
	constructor: function(config) {
    	Phx.vista.ProveedorCuenta.superclass.constructor.call(this,config);    	
	},    
	/*east : { 
          url:'../../../sis_contabilidad/vista/relacion_contable/RelacionContableTabla.php',
          title:'Relacion Contable', 
          width:'50%',
          cls:'RelacionContableTabla',
          params:{nombre_tabla:'param.tproveedor',tabla_id : 'id_proveedor'}
   },*/
   tabeast:[
	{
	  url:'../../../sis_contabilidad/vista/relacion_contable/RelacionContableTabla.php',
	  title:'Relacion Contable', 
	  width:'50%',
	  cls:'RelacionContableTabla',
	  params:{nombre_tabla:'param.tproveedor',tabla_id : 'id_proveedor'}
	},
	{
	  url:'../../../sis_parametros/vista/proveedor_cta_bancaria/ProveedorCtaBancaria.php',
	  title:'Cta Bancaria', 
	  width:'50%',
	  cls:'ProveedorCtaBancaria',
	  params:{nombre_tabla:'param.tproveedor',tabla_id : 'id_proveedor'}
	}],
	
   bedit:true,
   bnew:false,
   bdel:false,
   bsave:false,
   EnableSelect : function (n, extra) {
   		var miExtra = {codigos_tipo_relacion:''};
   		if (extra != null && typeof extra === 'object') {
   			miExtra = Ext.apply(extra, miExtra) 
   		}
   		
   		Phx.vista.ProveedorCuenta.superclass.EnableSelect.call(this,n,miExtra);  
   		
   }
};
</script>
