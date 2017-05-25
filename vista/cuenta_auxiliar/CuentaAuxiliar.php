<?php
/**
*@package pXP
*@file gen-CuentaAuxiliar.php
*@author  (admin)
*@date 05-08-2013 00:42:28
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.CuentaAuxiliar=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.CuentaAuxiliar.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag, id_cuenta: this.id_cuenta}})
	},
	tam_pag:50,
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_cuenta_auxiliar'
			},
			type:'Field',
			form:true 
		},
        {
            config:{
                name: 'id_cuenta',
                inputType:'hidden'
            }, 
            type:'Field',          
            form:true
        },
        {
                config:{
                    sysorigen:'sis_contabilidad',
                    name:'id_auxiliar',
                    origen:'AUXILIAR',
                    allowBlank:false,
                    fieldLabel:'Auxiliar',
                    gdisplayField:'nombre_auxiliar',//mapea al store del grid
                    gwidth:200,
                     renderer:function (value, p, record){return String.format('{0}',record.data['codigo_auxiliar'] + '-' + record.data['nombre_auxiliar']);}
                 },
                type:'ComboRec',
                id_grupo:0,
                filters:{   
                    pfiltro:'au.codigo_auxiliar#au.nombre_auxiliar',
                    type:'string'
                },
               
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
            filters:{pfiltro:'cax.estado_reg',type:'string'},
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
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
			type:'DateField',
			filters:{pfiltro:'cax.fecha_reg',type:'date'},
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
			filters:{pfiltro:'cax.fecha_mod',type:'date'},
			id_grupo:1,
			grid:true,
			form:false
		}
	],
	
	title:'Cuenta - Auxiliar',
	ActSave:'../../sis_contabilidad/control/CuentaAuxiliar/insertarCuentaAuxiliar',
	ActDel:'../../sis_contabilidad/control/CuentaAuxiliar/eliminarCuentaAuxiliar',
	ActList:'../../sis_contabilidad/control/CuentaAuxiliar/listarCuentaAuxiliar',
	id_store:'id_cuenta_auxiliar',
	fields: [
		{name:'id_cuenta_auxiliar', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_auxiliar', type: 'numeric'},
		{name:'id_cuenta', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'nombre_auxiliar','codigo_auxiliar'
		
	],
	sortInfo:{
		field: 'id_cuenta_auxiliar',
		direction: 'ASC'
	},
    onButtonNew:function(){

        Phx.vista.CuentaAuxiliar.superclass.onButtonNew.call(this);
        this.getComponente('id_cuenta').setValue(this.id_cuenta);
        
    },
	bdel:true,
	bsave:true
	}
)
</script>
		
		