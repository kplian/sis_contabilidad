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
Phx.vista.CtaFuncionario = {
    require:'../../../sis_organigrama/vista/funcionario/Funcionario.php',
    requireclase:'Phx.vista.funcionario',
    title:'Funcionario',
    constructor: function(config) {
        Phx.vista.CtaFuncionario.superclass.constructor.call(this,config);     
    },    
    east : { 
          url: '../../../sis_contabilidad/vista/relacion_contable/RelacionContableTabla.php',
          title: 'Relacion Contable', 
          width: '50%',
          cls: 'RelacionContableTabla',
          params: { nombre_tabla: 'orga.tfuncionario', tabla_id: 'id_funcionario'}
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
      Phx.vista.CtaFuncionario.superclass.EnableSelect.call(this,n,miExtra);  
   }
};
</script>