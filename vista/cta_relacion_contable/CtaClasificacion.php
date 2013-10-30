<?php
/**
*@package pXP
*@file 
*@author  rcm
*@date 24/10/2013
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.CtaClasificacion = {
    require:'../../../sis_almacenes/vista/clasificacion/Clasificacion.php',
    requireclase:'Phx.vista.Clasificacion',
    title:'Cuentas Clasificación',
    constructor: function(config) {
        Phx.vista.CtaClasificacion.superclass.constructor.call(this,config);
        this.tbar.items.get('b-new-' + this.idContenedor).hide();     
        this.tbar.items.get('b-edit-' + this.idContenedor).hide();
        this.tbar.items.get('b-del-' + this.idContenedor).hide();
    },    
    east : { 
          url:'../../../sis_contabilidad/vista/relacion_contable/RelacionContableTabla.php',
          title:'Relacion Contable', 
          width:'50%',
          cls:'RelacionContableTabla',
          params:{nombre_tabla:'alm.tclasificacion',tabla_id:'id_clasificacion'}
   },
   EnableSelect : function (n, extra) {
        var miExtra = {codigos_tipo_relacion:''};
        if (extra != null && typeof extra === 'object') {
            miExtra = Ext.apply(extra, miExtra) 
        }
      Phx.vista.CtaClasificacion.superclass.EnableSelect.call(this,n,miExtra);  
   }
};
</script>