<?php
/**
*@package pXP
*@file gen-DocCompraVentaCbte.php
*@author  (admin)
*@date 18-08-2015 15:57:09
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.DocCompraVentaCbte=Ext.extend(Phx.gridInterfaz,{
    fheight: '80%',
    fwidth: '70%',
    tabEnter: true,
    constructor:function(config){
		var me = this;
		//llama al constructor de la clase padre
		Phx.vista.DocCompraVentaCbte.superclass.constructor.call(this,config);
		
        this.init();
	},
	
	  		
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_doc_compra_venta'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'tipo'
			},
			type:'Field',
			form:true 
		},
        {
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_depto_conta'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_depto_conta'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'revisado',
				fieldLabel: 'Revisado',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:3,
                renderer: function (value, p, record, rowIndex, colIndex){  
                	     
            	       //check or un check row
            	       var checked = '',
            	       	    momento = 'no';
                	   if(value == 'si'){
                	        	checked = 'checked';;
                	   }
            	       return  String.format('<div style="vertical-align:middle;text-align:center;"><input style="height:37px;width:37px;" type="checkbox"  {0}  disabled></div>',checked);
            	        
                 }
			},
			type: 'TextField',
			filters: { pfiltro:'dcv.revisado',type:'string'},
			id_grupo: 1,
			grid: true,
			form: false
		},
		
        {
            config:{
                name: 'desc_plantilla',
                fieldLabel: 'Tipo Documento',
                allowBlank: false,
                emptyText:'Elija una plantilla...',
                gwidth: 250
            },
            type:'Field',
            filters:{pfiltro:'pla.desc_plantilla',type:'string'},
            id_grupo: 0,
            grid: true,
            bottom_filter: true,
            form: false
        },
		
        {
            config:{
                name:'desc_moneda',
                origen:'MONEDA',
                allowBlank:false,
                fieldLabel:'Moneda',
                gdisplayField:'desc_moneda',//mapea al store del grid
                gwidth:70,
                width:250,
             },
            type:'Field',
            id_grupo:0,
            filters:{   
                pfiltro:'incbte.desc_moneda',
                type:'string'
            },
            grid:true,
            form:false
        },
		
		{
			config:{
				name: 'fecha',
				fieldLabel: 'Fecha',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				format: 'd/m/Y',
				readOnly:true,
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'dcv.fecha',type:'date'},
				id_grupo:0,
				grid:true,
				form:false
		},
        {
            config:{
                name: 'nro_autorizacion',
                fieldLabel: 'Autorización',
                gwidth: 250,
               
            },
            type:'Field',
            filters:{pfiltro:'dcv.nro_autorizacion',type:'string'},
            id_grupo: 0,
            grid: true,
            bottom_filter: true,
            form: false
        },
        
        {
            config:{
                name: 'nit',
                fieldLabel: 'NIT',
                qtip: 'Número de indentificación del proveedor',
                allowBlank: false,
                emptyText:'nit ...',
                gwidth: 250
            },
            type:'ComboBox',
            filters:{pfiltro:'dcv.nit',type:'string'},
            id_grupo: 0,
            grid: true,
            bottom_filter: true,
            form: false
        },
		
		
		{
			config:{
				name: 'razon_social',
				fieldLabel: 'Razón Social',
				gwidth: 100,
				maxLength:180
			},
			type:'TextField',
			filters:{pfiltro:'dcv.razon_social',type:'string'},
			id_grupo:0,
			grid:true,
			bottom_filter: true,
			form:false
		},
		{
			config:{
				name: 'nro_documento',
				fieldLabel: 'Nro Doc',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
				type:'TextField',
				filters:{pfiltro:'dcv.nro_documento',type:'string'},
				id_grupo:0,
				grid:true,
				bottom_filter: true,
				form:false
		},
		{
			config:{
				name: 'nro_dui',
				fieldLabel: 'DUI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength :16,
				minLength:9
			},
				type:'TextField',
				filters:{pfiltro:'dcv.nro_dui',type:'string'},
				id_grupo:0,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'codigo_control',
				fieldLabel: 'Código de Control',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:200
			},
				type:'TextField',
				filters:{pfiltro:'dcv.codigo_control',type:'string'},
				id_grupo:0,
				grid:true,
				form:false
		},
		
		{
			config:{
				name: 'obs',
				fieldLabel: 'Obs',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength: 400
			},
				type:'TextArea',
				filters:{ pfiltro:'dcv.obs',type:'string' },
				id_grupo:0,
				grid: true,
				bottom_filter: true,
				form: false
		},
		{
			config:{
				name: 'importe_doc',
				fieldLabel: 'Monto',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'dcv.importe_doc',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'importe_excento',
				fieldLabel: 'Excento',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100
			},
				type: 'NumberField',
				filters: {pfiltro:'dcv.importe_excento',type:'numeric'},
				id_grupo:1,
				grid: true,
				form: false
		},
		{
			config:{
				name: 'importe_descuento',
				fieldLabel: 'Descuento',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100
			},
				type:'NumberField',
				filters:{pfiltro:'dcv.importe_descuento',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'importe_descuento_ley',
				fieldLabel: 'Descuentos de Ley',
				allowBlank: true,
				readOnly:true,
				anchor: '80%',
				gwidth: 100
			},
				type:'NumberField',
				filters:{pfiltro:'dcv.importe_descuento_ley',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'importe_ice',
				fieldLabel: 'ICE',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100
			},
				type:'NumberField',
				filters:{pfiltro:'dcv.importe_ice',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'importe_iva',
				fieldLabel: 'IVA',
				allowBlank: true,
				readOnly:true,
				anchor: '80%',
				gwidth: 100
			},
				type: 'NumberField',
				filters: { pfiltro:'dcv.importe_iva',type:'numeric'},
				id_grupo: 1,
				grid: true,
				form: false
		},
		{
			config:{
				name: 'importe_it',
				fieldLabel: 'IT',
				allowBlank: true,
				anchor: '80%',
				readOnly:true,
				gwidth: 100
			},
				type:'NumberField',
				filters:{pfiltro:'dcv.importe_it',type:'numeric'},
				id_grupo:1,
				grid:true,
				form: false
		},
		{
			config:{
				name: 'importe_pago_liquido',
				fieldLabel: 'Liquido Pagado',
				allowBlank: true,
				readOnly:true,
				anchor: '80%',
				gwidth: 100
			},
				type:'NumberField',
				filters:{pfiltro:'dcv.importe_pago_liquido',type:'numeric'},
				id_grupo:1,
				grid:true,
				form: false
		},
		
		{
			config:{
				name: 'estado',
				fieldLabel: 'Estado',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:30
			},
				type:'TextField',
				filters:{pfiltro:'dcv.estado',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'sw_contabilizar',
				fieldLabel: 'Contabilizar',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength: 3
			},
				type: 'TextField',
				filters: { pfiltro:'dcv.sw_contabilizar', type:'string' },
				id_grupo: 1,
				grid: true,
				form: false
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
				filters:{pfiltro:'dcv.estado_reg',type:'string'},
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
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'dcv.fecha_reg',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: '',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'dcv.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'dcv.fecha_mod',type:'date'},
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
				filters:{pfiltro:'dcv.usuario_ai',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		}*/
	],
	tam_pag: 50,	
	title: 'Documentos Compra/Venta',
	ActSave: '../../sis_contabilidad/control/DocCompraVenta/insertarDocCompraVentaCbte',
	ActDel: '../../sis_contabilidad/control/DocCompraVenta/eliminarDocCompraVentaCbte',
	ActList: '../../sis_contabilidad/control/DocCompraVenta/listarDocCompraVenta',
	id_store: 'id_doc_compra_venta',
	fields: [
		{name:'id_doc_compra_venta', type: 'string'},
		{name:'revisado', type: 'string'},
		{name:'movil', type: 'string'},
		{name:'tipo', type: 'string'},
		{name:'importe_excento', type: 'numeric'},
		{name:'id_plantilla', type: 'numeric'},
		{name:'fecha', type: 'date',dateFormat:'Y-m-d'},
		{name:'nro_documento', type: 'string'},
		{name:'nit', type: 'string'},
		{name:'importe_ice', type: 'numeric'},
		{name:'nro_autorizacion', type: 'string'},
		{name:'importe_iva', type: 'numeric'},
		{name:'importe_descuento', type: 'numeric'},
		{name:'importe_doc', type: 'numeric'},
		{name:'sw_contabilizar', type: 'string'},
		{name:'tabla_origen', type: 'string'},
		{name:'estado', type: 'string'},
		{name:'id_depto_conta', type: 'numeric'},
		{name:'id_origen', type: 'numeric'},
		{name:'obs', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'codigo_control', type: 'string'},
		{name:'importe_it', type: 'numeric'},
		{name:'razon_social', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		'desc_depto','desc_plantilla',
		'importe_descuento_ley',
		'importe_pago_liquido','nro_dui','id_moneda','desc_moneda'
		
	],
	sortInfo:{
		field: 'id_doc_compra_venta',
		direction: 'ASC'
	},
	bdel: true,
	bsave: false,/*
	abrirFormulario: function(tipo, record){
   	       var me = this;
	       me.objSolForm = Phx.CP.loadWindows('../../../sis_contabilidad/vista/doc_compra_venta/FormCompraVenta.php',
	                                'Formulario de Documento Compra/Venta',
	                                {
	                                    modal:true,
	                                    width:'100%',
	                                    height:'100%'
	                                }, { data: { 
	                                	 objPadre: me ,
	                                	 tipoDoc: me.tipoDoc,
	                                	 id_gestion: me.cmbGestion.getValue(),
	                                	 id_periodo: me.cmbPeriodo.getValue(),
	                                	 id_depto: me.cmbDepto.getValue(),
	                                	 tmpPeriodo: me.tmpPeriodo,
	                                	 tmpGestion: me.tmpGestion,
	                                	 tipo_form : tipo,
	                                	 datosOriginales: record
	                                	}
	                                }, 
	                                this.idContenedor,
	                                'FormCompraVenta',
	                                {
	                                    config:[{
	                                              event:'successsave',
	                                              delegate: this.onSaveForm,
	                                              
	                                            }],
	                                    
	                                    scope:this
	                                 });  
   },
   
   onButtonNew:function(){
	       //abrir formulario de solicitud
	        if(!this.validarFiltros()){
	            alert('Especifique el año y el mes antes')
	        }
	        else{
	            this.abrirFormulario('new')  
	        } 
    },
    onButtonEdit:function(){
     	if(!this.validarFiltros()){
            alert('Especifique el año y el mes antes')
        }
        else{
        	this.abrirFormulario('edit', this.sm.getSelected())
        }
    },
    
    preparaMenu:function(tb){
        Phx.vista.DocCompraVentaCbte.superclass.preparaMenu.call(this,tb)
        var data = this.getSelectedData();
        if(data['revisado'] ==  'no' ){
            this.getBoton('edit').enable();
            this.getBoton('del').enable();
         
         }
         else{
            this.getBoton('edit').disable();
            this.getBoton('del').disable();
         } 
	        
    },
    
    liberaMenu:function(tb){
        Phx.vista.DocCompraVentaCbte.superclass.liberaMenu.call(this,tb);
                    
    }
   
    */
    
})
</script>