<?php
/**
*@package pXP
*@file gen-BancarizacionPeriodo.php
*@author  (favio.figueroa)
*@date 24-05-2017 16:07:40
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.BancarizacionPeriodo=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
        this.initButtons=[this.cmbGestion_bancarizacion];
    	//llama al constructor de la clase padre
		Phx.vista.BancarizacionPeriodo.superclass.constructor.call(this,config);

        this.bloquearOrdenamientoGrid();
        this.cmbGestion_bancarizacion.on('select', function(){
            if(this.validarFiltros()){
                this.capturaFiltros();
            }
        },this);

		this.init();

        this.addButton('btnCerrarPeriodo', {
            text : 'Cerrar',
            iconCls : 'block',
            disabled : true,
            handler : this.onCerrarPeriodo,
            tooltip : '<b>Cerrar</b> Cerrar el periodo , nadie puede insertar ni modificar documentos'
        });



        this.addButton('btnAbrirPeriodo', {
            text : 'Abrir',
            iconCls : 'bunlock',
            disabled : true,
            handler : this.onAbrirPeriodo,
            tooltip : '<b>Abrir</b>Abrir periodo para permitir registros de documentos'
        });

        this.bloquearMenus();

		//this.load({params:{start:0, limit:this.tam_pag}})
	},


    cmbGestion_bancarizacion: new Ext.form.ComboBox({
        fieldLabel: 'Gestion',
        allowBlank: false,
        emptyText:'Gestion...',
        blankText: 'Año',
        store:new Ext.data.JsonStore(
            {
                url: '../../sis_parametros/control/Gestion/listarGestion',
                id: 'id_gestion',
                root: 'datos',
                sortInfo:{
                    field: 'gestion',
                    direction: 'ASC'
                },
                totalProperty: 'total',
                fields: ['id_gestion','gestion'],
                // turn on remote sorting
                remoteSort: true,
                baseParams:{par_filtro:'gestion'}
            }),
        valueField: 'id_gestion',
        triggerAction: 'all',
        displayField: 'gestion',
        hiddenName: 'id_gestion',
        mode:'remote',
        pageSize:50,
        queryDelay:500,
        listWidth:'280',
        width:80
    }),

	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_bancarizacion_periodo'
			},
			type:'Field',
			form:true 
		},{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_gestion'
			},
			type:'Field',
			form:true
		}
		,{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_periodo'
			},
			type:'Field',
			form:true
		},

        {
            config:{
                name: 'periodo',
                fieldLabel: 'Periodo',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:255
            },
            type:'TextField',
            filters:{pfiltro:'bancaper.estado',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config: {
                name: 'estado',
                fieldLabel: 'Estado',
                allowBlank: true,
                emptyText: 'estado...',
                typeAhead: true,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'local',
                store: ['Desbloqueado', 'Bloqueado'],
                width: 200
            },
            filters:{pfiltro:'banges.estado',type:'string'},

            type: 'ComboBox',
            id_grupo: 1,
            grid:true,
            form: true
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
				filters:{pfiltro:'bancaper.estado_reg',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},

		{
			config:{
				name: 'usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
				type:'TextField',
				filters:{pfiltro:'bancaper.usuario_ai',type:'string'},
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
				filters:{pfiltro:'bancaper.fecha_reg',type:'date'},
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
				type:'Field',
				filters:{pfiltro:'usu1.cuenta',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'bancaper.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'bancaper.fecha_mod',type:'date'},
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
				type:'Field',
				filters:{pfiltro:'usu2.cuenta',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Bancarizacion Periodo',
	ActSave:'../../sis_contabilidad/control/BancarizacionPeriodo/insertarBancarizacionPeriodo',
	ActDel:'../../sis_contabilidad/control/BancarizacionPeriodo/eliminarBancarizacionPeriodo',
	ActList:'../../sis_contabilidad/control/BancarizacionPeriodo/listarBancarizacionPeriodo',
	id_store:'id_bancarizacion_periodo',
	fields: [
		{name:'id_bancarizacion_periodo', type: 'numeric'},
		{name:'id_periodo', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'estado', type: 'string'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'periodo', type: 'string'},

	],
	sortInfo:{
		field: 'per.id_periodo',
		direction: 'ASC'
	},
	bdel:false,
	bsave:false,
	bnew:false,
	bedit:false,


    onCerrarPeriodo: function(){this.cerrarAbrirPeriodo('cerrado');},
    onAbrirPeriodo: function(){this.cerrarAbrirPeriodo('abierto')},


    cerrarAbrirPeriodo: function(estado){
        var rec = this.sm.getSelected();
        if(rec){
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url : '../../sis_contabilidad/control/BancarizacionPeriodo/insertarBancarizacionPeriodo',
                params : {
                    id_bancarizacion_periodo : rec.data.id_bancarizacion_periodo,
                    id_periodo : rec.data.id_periodo,
                    estado : estado,
                },
                success : function(resp){
                    Phx.CP.loadingHide();
                    var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
                    if (reg.ROOT.error) {
                        Ext.Msg.alert('Error','no se pudo proceder: '+reg.ROOT.error)
                    } else {
                        this.reload();
                        Ext.Msg.alert('Mensaje','Proceso ejecutado con éxito')
                    }
                },
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope:this
            });
        }
    },



    validarFiltros:function(){
        if(this.cmbGestion_bancarizacion.isValid()){
            return true;
        }
        else{
            return false;
        }

    },

    capturaFiltros:function(combo, record, index){
        //this.desbloquearOrdenamientoGrid();
        this.store.baseParams.id_gestion=this.cmbGestion_bancarizacion.getValue();
        this.load();


    },


    preparaMenu: function (tb) {
        // llamada funcion clace padre
        Phx.vista.BancarizacionPeriodo.superclass.preparaMenu.call(this, tb)
    },
  /*  onButtonNew: function () {
        Phx.vista.BancarizacionPeriodo.superclass.onButtonNew.call(this);
        this.getComponente('id_gestion').setValue(this.maestro.id_gestion);
    },*/
    onReloadPage: function (m) {
        this.maestro = m;
        console.log(this.maestro);
        this.store.baseParams = {id_depto: this.maestro.id_depto,id_gestion:this.cmbGestion_bancarizacion.getValue()};
        this.load({params: {start: 0, limit: 50}})
    },

	}
)
</script>
		
		