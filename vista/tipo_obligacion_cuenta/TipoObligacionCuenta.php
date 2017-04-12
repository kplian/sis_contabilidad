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
Phx.vista.TipoObligacionCuenta = {
	require:'../../../sis_planillas/vista/tipo_obligacion/TipoObligacion.php',
	requireclase:'Phx.vista.TipoObligacion',
	title:'Tipo Obligacion',
	constructor: function(config) {
		this.initButtons=[this.cmbTipoPlanilla];
		this.cmbTipoPlanilla.on('select',this.capturaFiltros,this);  
		this.maestro=config.maestro;
		Phx.vista.TipoObligacion.superclass.constructor.call(this,config);
		this.init();
    	    	
	},    
	east : { 
          url:'../../../sis_contabilidad/vista/relacion_contable/RelacionContableTabla.php',
          title:'Relacion Contable', 
          width:'50%',
          cls:'RelacionContableTabla',
          params:{nombre_tabla:'plani.ttipo_obligacion',tabla_id : 'id_tipo_obligacion'}
   },
   south:false,
   
   capturaFiltros:function(combo, record, index){	   			
		this.store.baseParams.id_tipo_planilla = this.cmbTipoPlanilla.getValue();		
		this.load({params:
			{start:0,
				limit:50}
				});
	},
   bedit:false,
   bnew:false,
   bdel:false,
   bsave:false,
   cmbTipoPlanilla:new Ext.form.ComboBox({
	       			name: 'id_tipo_planilla',							
							typeAhead: false,
							hiddenName: 'id_tipo_planilla',
							allowBlank: false,
							emptyText: 'Lista de Planillas...',
							store: new Ext.data.JsonStore({
								url: '../../sis_planillas/control/TipoPlanilla/listarTipoPlanilla',
								id: 'id_tipo_planilla',
								root: 'datos',
								sortInfo: {
									field: 'codigo',
									direction: 'ASC'
								},
								totalProperty: 'total',
								fields: ['id_tipo_planilla', 'nombre', 'codigo','periodicidad'],
								// turn on remote sorting
								remoteSort: true,
								baseParams: {par_filtro: 'tippla.nombre#tippla.codigo'}
							}),
							valueField: 'id_tipo_planilla',
							displayField: 'nombre',							
							triggerAction: 'all',
							lazyRender: true,
							mode: 'remote',
							pageSize: 20,
							queryDelay: 200,
							listWidth:280,
							minChars: 2,
							gwidth: 120,
							tpl: '<tpl for="."><div class="x-combo-list-item"><p>{codigo}</p><strong>{nombre}</strong> </div></tpl>'
				       		}),
};
</script>
