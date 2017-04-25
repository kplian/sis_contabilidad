<?php
/**
*@package pXP
*@file Auxiliar.php
*@author  Gonzalo Sarmiento Sejas
*@date 21-02-2013 20:44:52
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Auxiliar=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.Auxiliar.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:50}});

        this.addButton('replicar_aux',{
            grupo: [0,1,2,3,4],
            text: 'Replicar',
            iconCls: 'bfolder',
            disabled: false,
            handler: this.replicarAux,
            tooltip: '<b>Permite replicar un auxiliar recien registrado en la BD Ingresos</b>',
            scope:this
        });
	},

    replicarAux: function () {
        Ext.Ajax.request({
            url:'../../sis_contabilidad/control/Auxiliar/conectar',
            params:{id_usuario: 0},
            success:function(resp){
                var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
                //this.Cmp.id_oficina_registro_incidente.setValue(reg.ROOT.datos.id_oficina);
                console.log('cambio exitoso');
                Ext.Msg.alert('Aviso', 'Se replico toda la informacion de Auxiliares, Evite las replicaciones seguidas');
            },
            failure: this.conexionFailure,
            timeout:this.timeout,
            scope:this
        });
    },
    
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_auxiliar'
			},
			type:'Field',
			form:true 
		},
		/*{
 			config:{
 				name:'id_empresa',
 				fieldLabel:'Empresa',
 				allowBlank:false,
 				emptyText:'Empresa...',
 				store: new Ext.data.JsonStore({

			url: '../../sis_parametros/control/Empresa/listarEmpresa',
			id: 'id_empresa',
			root: 'datos',
			sortInfo:{
				field: 'id_empresa',
				direction: 'ASC'
			},
			totalProperty: 'total',
			fields: ['id_empresa','nombre'],
			// turn on remote sorting
			remoteSort: true,
			baseParams:{par_filtro:'nombre'}
		}),
 				valueField: 'id_empresa',
 				displayField: 'nombre',
 				gdisplayField: 'nombre',
 				hiddenName: 'id_empresa',
 				forceSelection:true,
 				typeAhead: true,
  			triggerAction: 'all',
  			lazyRender:true,
 				mode:'remote',
 				pageSize:10,
 				queryDelay:1000,
 				width:250,
 				minChars:2,
 			
 				renderer:function(value, p, record){return String.format('{0}', record.data['nombre']);}

 			},
 			type:'ComboBox',
 			id_grupo:0,
 			filters:{   pfiltro:'nombre',
 						type:'string'
 					},
 			grid:true,
 			form:true
	 },*/
		{
			config:{
				name: 'codigo_auxiliar',
				fieldLabel: 'Codigo Auxiliar',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:15
			},
			type:'TextField',
			filters:{pfiltro:'auxcta.codigo_auxiliar',type:'string'},
			bottom_filter : true,
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'nombre_auxiliar',
				fieldLabel: 'Nombre Auxiliar',
				allowBlank: true,
				anchor: '80%',
				gwidth: 230,
				maxLength:300
			},
			type:'TextField',
			filters:{pfiltro:'auxcta.nombre_auxiliar',type:'string'},
			bottom_filter : true,
			id_grupo:1,
			grid:true,
			form:true
		},
		{
	       		config:{
	       			name:'corriente',
	       			fieldLabel:'Corriente',
	       			qtip: '¿Es cuenta corriente?',
	       			allowBlank:false,
	       			emptyText:'Tipo...',
	       			typeAhead: true,
	       		    triggerAction: 'all',
	       		    lazyRender:true,
	       		    mode: 'local',
	       		    gwidth: 100,
	       		    store:['si','no']
	       		},
	       		type:'ComboBox',
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	     },
		{
			config:{
				name: 'estado_reg',
				fieldLabel: 'Estado Reg.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:10
			},
			type:'TextField',
			filters:{pfiltro:'auxcta.estado_reg',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
			type:'DateField',
			filters:{pfiltro:'auxcta.fecha_reg',type:'date'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'usr_reg',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
			type:'NumberField',
			filters:{pfiltro:'usu1.cuenta',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'usr_mod',
				fieldLabel: 'Modificado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
			type:'NumberField',
			filters:{pfiltro:'usu2.cuenta',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
			type:'DateField',
			filters:{pfiltro:'auxcta.fecha_mod',type:'date'},
			id_grupo:1,
			grid:true,
			form:false
		}
	],
	
	title:'Auxiliares de Cuenta',
	ActSave:'../../sis_contabilidad/control/Auxiliar/insertarAuxiliar',
	ActDel:'../../sis_contabilidad/control/Auxiliar/eliminarAuxiliar',
	ActList:'../../sis_contabilidad/control/Auxiliar/listarAuxiliar',
	id_store:'id_auxiliar',
	fields: [
		{name:'id_auxiliar', type: 'numeric'},
		{name:'id_empresa', type: 'numeric'},
		{name:'nombre', type:'string'},
		{name:'estado_reg', type: 'string'},
		{name:'codigo_auxiliar', type: 'string'},
		{name:'nombre_auxiliar', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'corriente'
		
	],
	sortInfo:{
		field: 'id_auxiliar',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,

	}
)
</script>
		
		