<?php
/**
*@package pXP
*@file    ListaCbtes.php
*@author  Manuel Guerra
*@description generar cbtes diarios

 
HISTORIAL DE MODIFICACIONES:
   	
 ISSUE        FORK			FECHA:		      AUTOR                 DESCRIPCION
#50	    ETR		17/05/2019			manuel guerra		    agregar filtro depto
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ListaCbtes=Ext.extend(Phx.frmInterfaz,{
	//ActSave:'../../sis_contabilidad/control/IntComprobante/ListadoCbte',

	constructor:function(config)
	{
		Phx.vista.ListaCbtes.superclass.constructor.call(this,config);
		this.init();    
		//this.loadValoresIniciales();			
	},
	
	successSave:function(resp)
	{		
		Phx.CP.loadingHide();
		Phx.CP.getPagina(this.idContenedorPadre).reload();
		this.panel.close();
	},

	Atributos:[			
		{
			config:{
				name:'id_usuario',
				fieldLabel:'Usuario',
				allowBlank:true,
				emptyText:'Usuario...',
				store: new Ext.data.JsonStore({
					url: '../../sis_seguridad/control/Usuario/listarUsuario',
					id: 'id_persona',
					root: 'datos',
					sortInfo:{
						field: 'desc_person',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_usuario','desc_person','cuenta'],
					remoteSort: true,
					baseParams:{par_filtro:'PERSON.nombre_completo2#cuenta',_adicionar:'si'}
				}),
				valueField: 'id_usuario',
				displayField: 'desc_person',
				gdisplayField:'desc_usuario',//dibuja el campo extra de la consulta al hacer un inner join con orra tabla
				tpl:'<tpl for="."><div class="x-combo-list-item"><p>{desc_person}</p></div></tpl>',
				hiddenName: 'id_usuario',
				forceSelection:true,
				typeAhead: true,
				triggerAction: 'all',
				lazyRender:true,
				mode:'remote',
				pageSize:10,
				queryDelay:1000,
				width:250,
				gwidth:280,
				minChars:2
			},
			type:'ComboBox',
			id_grupo:0,
			form:true
		},
		{
			config : {
				name : 'id_depto',
				hiddenName : 'id_depto',
				url : '../../sis_parametros/control/Depto/listarDeptoFiltradoXUsuario',
				origen : 'DEPTO',
				allowBlank : false,
				fieldLabel : 'Depto',
				gdisplayField : 'desc_depto', //dibuja el campo extra de la consulta al hacer un inner join con orra tabla
				width : 250,
				gwidth : 180,
				baseParams : {
					estado : 'activo',
					codigo_subsistema : 'CONTA'
				}, //parametros adicionales que se le pasan al store
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['desc_depto']);
				}
			},
			//type:'TrigguerCombo',
			type : 'ComboRec',
			id_grupo : 0,
			filters : {
				pfiltro : 'incbte.desc_depto',
				type : 'string'
			},
			grid : false,
			form : true
		}, 
		{
			config : {
				name : 'fecha_ini',
				fieldLabel : 'Fecha Inicial',
				allowBlank : true,
				width : 220,
				gwidth : 220,
				format : 'd/m/Y',
				renderer : function(value, p, record) {
					return value ? value.dateFormat('d/m/Y') : ''
				}
			},
			type : 'DateField',			
			id_grupo : 3,
			form : true
		}, {
			config : {
				name : 'fecha_fin',
				fieldLabel : 'Fecha Final',
				allowBlank : true,
				width : 220,
				gwidth : 220,
				format : 'd/m/Y',
				renderer : function(value, p, record) {
					return value ? value.dateFormat('d/m/Y') : ''
				}
			},
			type : 'DateField',
			
			id_grupo : 3,
			form : true
		},
	],
	
	onSubmit:function(){
		//TODO passar los datos obtenidos del wizard y pasar  el evento save		
		if (this.form.getForm().isValid()) {
			this.fireEvent('beforesave',this,this.getValues());
			this.getValues();
		}
	},
	getValues:function(){			
		var resp = {	
			id_usuario:this.Cmp.id_usuario.getValue(),
			id_depto:this.Cmp.id_depto.getValue(),			
			fecha_ini:this.Cmp.fecha_ini.getValue(),
			fecha_fin:this.Cmp.fecha_fin.getValue(),			
		}
		return resp;
	}
}
)
</script>
