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
Phx.vista.CtaAlmacen = {
    require:'../../../sis_almacenes/vista/almacen/Almacen.php',
    requireclase:'Phx.vista.Almacen',
    title:'Cuentas Almacenes',
    constructor: function(config) {
        Phx.vista.CtaAlmacen.superclass.constructor.call(this,config);     
    },    
    south : { 
          url:'../../../sis_contabilidad/vista/relacion_contable/RelacionContableTabla.php',
          title:'Relacion Contable', 
          height:'50%',
          cls:'RelacionContableTabla',
          params:{nombre_tabla:'alm.talmacen',tabla_id:'id_almacen'}
   },
   bedit:false,
   bnew:false,
   bdel:false,
   bsave:false,
   EnableSelect : function (n, extra) {
        var miExtra = {codigos_tipo_relacion:''};
        if (extra != null && typeof extra === 'object') {
            miExtra = Ext.apply(extra, miExtra) 
        }
      Phx.vista.CtaAlmacen.superclass.EnableSelect.call(this,n,miExtra);  
   }
};
</script>