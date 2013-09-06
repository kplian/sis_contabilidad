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
Phx.vista.CtaDepto = {
    require:'../../../sis_parametros/vista/depto/Depto.php',
    requireclase:'Phx.vista.Depto',
    title:'Cuenta Bancaria',
    constructor: function(config) {
        Phx.vista.CtaDepto.superclass.constructor.call(this,config);     
    },    
    east : { 
          url:'../../../sis_contabilidad/vista/relacion_contable/RelacionContableTabla.php',
          title:'Relacion Contable', 
          width:'50%',
          cls:'RelacionContableTabla',
          params:{nombre_tabla:'param.tdepto',tabla_id:'id_depto'}
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
      Phx.vista.CtaDepto.superclass.EnableSelect.call(this,n,miExtra);  
   }
};
</script>