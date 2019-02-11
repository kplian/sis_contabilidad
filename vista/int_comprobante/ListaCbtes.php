<?php
/**
*@package pXP
*@file    ListaCbtes.php
*@author  Manuel Guerra
*@description generar cbtes diarios
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
			fecha_ini:this.Cmp.fecha_ini.getValue(),
			fecha_fin:this.Cmp.fecha_fin.getValue(),			
		}
		return resp;
	}
}
)
</script>
