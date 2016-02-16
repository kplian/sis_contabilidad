<?php
/**
*@package pXP
*@file gen-AgrupadorDoc.php
*@author  (admin)
*@date 18-08-2015 15:57:09
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.AgrupadorDoc=Ext.extend(Phx.gridInterfaz,{
    fheight: '80%',
    fwidth: '70%',
    tabEnter: true,
    tipoDoc: 'venta',
	constructor:function(config){
		
		var me = this;
		
    	//llama al constructor de la clase padre
		Phx.vista.AgrupadorDoc.superclass.constructor.call(this,config);
		
        
        this.store.baseParams={id_agrupador: this.id_agrupador};
        this.load({params:{start:0, limit:this.tam_pag}})
		
		this.iniciarEventos();
		this.init();
		
		this.addButton('btnWizard',
            {
                text: 'Generar Cbte',
                iconCls: 'bpagar',
                disabled: false,
                handler: this.genCbte,
                tooltip: '<b>Generar Comprobante</b><br/>Insertar el comprobante segun los documentos seleccionados'
            }
        );
	},
    
    genCbte: function() {
         
          Phx.CP.loadingShow();
          Ext.Ajax.request({
						url : '../../sis_contabilidad/control/AgrupadorDoc/generarCbte',
						params :  {id_agrupador: this.id_agrupador},
						success : this.successGen,
						failure : this.conexionFailure,
						timeout : this.timeout,
						scope : this
					});
        	
         
    },
	
	successGen: function(resp){
    	Phx.CP.loadingHide();
    	Phx.CP.getPagina(this.idContenedorAbuelo).reload();
    	//abrir interface con documentos abrupados
    	this.panel.destroy();
    },
    
    Atributos:[
	    {
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_agrupador_doc'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_agrupador'
			},
			type:'Field',
			form:true 
		},
		
		 {
            config:{
                name: 'id_doc_compra_venta',
                fieldLabel: 'Documento',
                allowBlank: false,
                emptyText:'Elija una plantilla...',
                store:new Ext.data.JsonStore(
                {
                    url: '../../sis_contabilidad/control/DocCompraVenta/listarDocCompraVenta',
                    id: 'id_doc_compra_venta',
                    root:'datos',
                    sortInfo:{
                        field:'desc_plantilla',
                        direction:'ASC'
                    },
                    totalProperty:'total',
                    fields: ['id_doc_compra_venta','revisado','nro_documento','nit',
                    'desc_plantilla', 'desc_moneda','importe_doc','nro_documento',
                    'tipo','razon_social','fecha'],
                    remoteSort: true,
                    baseParams:{par_filtro:'mon.codigo#pla.desc_plantilla#dcv.razon_social#dcv.nro_documento#dcv.nit'}
                }),
                tpl:'<tpl for="."><div class="x-combo-list-item"><p>{razon_social},  NIT: {nit}</p><p>{desc_plantilla} </p><p>Doc: {nro_documento} de Fecha: {fecha}</p><p> {importe_doc} {desc_moneda}  </p></div></tpl>',
                valueField: 'id_doc_compra_venta',
                hiddenValue: 'id_doc_compra_venta',
                displayField: 'desc_plantilla',
                gdisplayField:'nro_documento',
                listWidth:'280',
                forceSelection:true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender:true,
                mode:'remote',
                pageSize:20,
                queryDelay:500,
               gwidth: 250,
                minChars:2
            },
            type:'ComboBox',
            id_grupo: 0,
            grid: false,
            bottom_filter: true,
            form: true
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
				minLength:16
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
				name: 'importe_neto',
				fieldLabel: 'Monto Neto',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'dcv.importe_doc',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
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
				name: 'importe_pendiente',
				fieldLabel: 'Cuenta Pendiente',
				qtip: 'Usualmente una cuenta pendiente de  cobrar o  pagar (dependiendo si es compra o venta), posterior a la emisión del documento',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100
			},
				type:'NumberField',
				filters:{pfiltro:'dcv.importe_pendiente',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'importe_anticipo',
				fieldLabel: 'Anticipo',
				qtip: 'Importe pagado por anticipado al documento',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100
			},
				type:'NumberField',
				filters:{pfiltro:'dcv.importe_anticipo',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'importe_retgar',
				fieldLabel: 'Ret. Garantia',
				qtip: 'Importe retenido por garantia',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100
			},
				type:'NumberField',
				filters:{pfiltro:'dcv.importe_retgar',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
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
				name: 'nombre_auxiliar',
				fieldLabel: 'Cuenta Corriente',
				allowBlank: false,
				anchor: '80%',
				gwidth: 150,
				maxLength:180, 
				renderer:function (value,p,record){
					if(value){
					  return  String.format('({0}) - {1}',record.data.codigo_auxiliar, record.data.nombre_auxiliar);
					}
            	}   
			
			},
				type:'TextField',
				filters:{pfiltro:'aux.codigo_auxiliar#aux.nombre_auxiliar',type:'string'},
				id_grupo:0,
				grid: true,
				bottom_filter: true,
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
		}
	],
	tam_pag: 50,	
	title: 'Documentos Compra/Venta',
	ActSave: '../../sis_contabilidad/control/AgrupadorDoc/insertarAgrupadorDoc',
	ActDel:  '../../sis_contabilidad/control/AgrupadorDoc/eliminarAgrupadorDoc',
	ActList: '../../sis_contabilidad/control/AgrupadorDoc/listarAgrupadorDoc',
	id_store: 'id_agrupador_doc',
	fields: [
	    {name:'id_agrupador_doc', type: 'string'},
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
		{name:'importe_pendiente', type: 'numeric'},
		{name:'importe_anticipo', type: 'numeric'},
		{name:'importe_retgar', type: 'numeric'},
		{name:'importe_neto', type: 'numeric'},
		'desc_depto','desc_plantilla',
		'importe_descuento_ley',
		'importe_pago_liquido','nro_dui','id_moneda','desc_moneda','id_auxiliar',
		'codigo_auxiliar','nombre_auxiliar'
		
	],
	sortInfo:{
		field: 'id_agrupador_doc',
		direction: 'ASC'
	},
	bdel: true,
	bnew: true,
	bedit: false,
	bsave: false,
	onButtonNew:function(){         
            Phx.vista.AgrupadorDoc.superclass.onButtonNew.call(this);
            this.Cmp.id_agrupador.setValue(this.id_agrupador); 
            
            this.Cmp.id_doc_compra_venta.store.baseParams = Ext.apply(this.Cmp.id_doc_compra_venta.store.baseParams,
            	  {
            	  tipo: this.tipoDoc, 
            	  fecha_cbte: this.fecha_cbte, 
            	  sin_cbte: 'si',
            	  manual: 'si',
            	  id_agrupador: this.id_agrupador}); 
            	  
            this.Cmp.id_doc_compra_venta.modificado = true;
    }
   
   
    
    
})
</script>