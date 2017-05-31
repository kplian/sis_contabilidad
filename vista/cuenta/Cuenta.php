<?php
/**
*@package pXP
*@file Cuenta.php
*@author  Gonzalo Sarmiento Sejas
*@date 21-02-2013 15:04:03
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Cuenta=Ext.extend(Phx.arbGridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
		this.initButtons=[this.cmbGestion];
    	//llama al constructor de la clase padre
		Phx.vista.Cuenta.superclass.constructor.call(this,config);
		this.loaderTree.baseParams={id_gestion:0};
		this.init();
		this.iniciarEventos();
		
		this.cmbGestion.on('select',this.capturaFiltros,this);
		this.addButton('bAux',{text:'Auxiliares',iconCls: 'blist',disabled:true,handler:this.onButonAux,tooltip: '<b>Auxiliares de la cuenta</b><br/>Se habilita si esta cuenta tiene permitido el registro de auxiliares '});
        this.addButton('btnImprimir',
			{
				text: 'Imprimir',
				iconCls: 'bprint',
				disabled: true,
				handler: this.imprimirCbte,
				tooltip: '<b>Imprimir Plan de Cuentas</b><br/>Imprime el Plan de Cuentas en el formato oficial.'
			}
		);
		//Crea el botón para llamar a la replicación
		this.addButton('btnRepRelCon',
			{
				text: 'Duplicar Plan de Cuentas',
				iconCls: 'bchecklist',
				disabled: false,
				handler: this.duplicarCuentas,
				tooltip: '<b>Clonar  las cuentas para las gestión siguiente </b><br/>Clonar las cuentas, para la gestión siguiente guardando las relacion entre las mismas'
			}
		);
		
		
		
	},
	
	
	
	duplicarCuentas: function(){
		if(this.cmbGestion.getValue()){
			Phx.CP.loadingShow(); 
	   		Ext.Ajax.request({
				url: '../../sis_contabilidad/control/Cuenta/clonarCuentasGestion',
			  	params:{
			  		id_gestion: this.cmbGestion.getValue()
			      },
			      success: this.successRep,
			      failure: this.conexionFailure,
			      timeout: this.timeout,
			      scope: this
			});
		}
		else{
			alert('primero debe selecionar la gestion origen');
		}
   		
   },
   
   successRep:function(resp){
        Phx.CP.loadingHide();
        var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
        if(!reg.ROOT.error){
            this.reload();
            alert(reg.ROOT.datos.observaciones)
        }else{
            alert('Ocurrió un error durante el proceso')
        }
	},
	
	capturaFiltros:function(combo, record, index){
		
		this.loaderTree.baseParams={id_gestion:this.cmbGestion.getValue()};
		this.root.reload();
		if(this.cmbGestion.getValue()){
        	this.getBoton('btnImprimir').setDisabled(false);
        }
        else{
        	this.getBoton('btnImprimir').setDisabled(true);
        }
	},
	imprimirCbte: function(){
		Phx.CP.loadingShow();
		Ext.Ajax.request({
						//url : '../../sis_contabilidad/control/IntComprobante/reporteComprobante',
						url : '../../sis_contabilidad/control/Cuenta/reportePlanCuentas',
						params : {
							'id_gestion' : this.cmbGestion.getValue()
						},
						success : this.successExport,
						failure : this.conexionFailure,
						timeout : this.timeout,
						scope : this
					});
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_cuenta'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'id_cuenta_padre',
				inputType:'hidden'
			},
			type:'Field',
			form:true,
			grid:false
		},
		{
			config:{
				name: 'id_gestion',
				inputType:'hidden'
			},
			type:'Field',
			form:true
		},
		{
			config: {
				name: 'tipo_cuenta',
				fieldLabel: 'Tipo Cuenta',
				typeAhead: false,
				forceSelection: false,
				allowBlank: false,
				emptyText: 'Tipos...',
				store: new Ext.data.JsonStore({
					url: '../../sis_contabilidad/control/ConfigTipoCuenta/listarConfigTipoCuenta',
					id: 'tipo_cuenta',
					root: 'datos',
					sortInfo: {
						field: 'nro_base',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['tipo_cuenta', 'nro_base'],
					// turn on remote sorting
					remoteSort: true,
					baseParams: {par_filtro: 'tipo_cuenta'}
				}),
				valueField: 'tipo_cuenta',
				displayField: 'tipo_cuenta',
				gdisplayField: 'tipo_cuenta',
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 20,
				queryDelay: 200,
				listWidth:280,
				minChars: 2,
				gwidth: 90
				},
			type: 'ComboBox',
			id_grupo: 0,
			form: true
		},
		{
	       		config:{
	       			name:'tipo_cuenta_pat',
	       			fieldLabel:'Cap./Res.',
	       			allowBlank:false,
	       			emptyText:'Tipo...',
	       			typeAhead: true,
	       		    triggerAction: 'all',
	       		    lazyRender:true,
	       		    mode: 'local',
	       		    gwidth: 100,
	       		    store:['capital','reserva','resultado']
	       		},
	       		type:'ComboBox',
	       		id_grupo:0,
	       		grid:false,
	       		form:true
	       },
	       {
			config:{
				name: 'digito',
				fieldLabel: 'Digito',
				allowBlank: false,
				allowNegative: false,
				vtype: 'alpha',
				//regex: new RegExp('/^[0-9]$/'),
				//regexText: 'Solo números',
				anchor: '80%',
				gwidth: 100,
				maxLength:5
			},
			type:'Field',
			id_grupo:1,
			grid:false,
			form:true
		},
		{
			config:{
				name: 'text',
				fieldLabel: 'Cuenta',
				allowBlank: false,
				anchor: '80%',
				gwidth: 400,
				maxLength:100
			},
			type:'TextField',
			id_grupo:1,
			grid:true,
			form:false
		},{
			config:{
				name: 'nro_cuenta',
				fieldLabel: 'Nro Cuenta',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:30
			},
			type:'TextField',
			id_grupo:1,
			grid:false,
			form:true
		},
		{
			config:{
				name: 'nombre_cuenta',
				fieldLabel: 'Nombre Cuenta',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextField',
			id_grupo:1,
			grid:false,
			form:true
		},
		{
			config:{
				name: 'desc_cuenta',
				fieldLabel: 'Desc Cuenta',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:500
			},
			type:'TextArea',
			id_grupo:1,
			grid:true,
			form:true
		},
		{
	       		config:{
	       			name:'sw_transaccional',
	       			fieldLabel:'Operación',
	       			allowBlank:false,
	       			emptyText:'Tipo...',
	       			typeAhead: true,
	       		    triggerAction: 'all',
	       		    lazyRender:true,
	       		    mode: 'local',
	       		    gwidth: 100,
	       		    store:['movimiento','titular']
	       		},
	       		type:'ComboBox',
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	       	},
				
		 {
   			config:{
       		    name:'id_moneda',
          		origen:'MONEDA',
   				fieldLabel:'Moneda',
   				allowBlank:false,
   				gdisplayField:'desc_moneda',//mapea al store del grid
   			    gwidth:200,
   			     renderer:function (value, p, record){return String.format('{0}', record.data['desc_moneda']);}
       	     },
   			type:'ComboRec',
   			id_grupo:1,
   			grid:true,
   			form:true
   	      },
   	      {
	       		config:{
	       			name:'sw_auxiliar',
	       			fieldLabel:'Permite Auxiliares',
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
	       			name:'sw_control_efectivo',
	       			fieldLabel:'Control Efectivo',
	       			qtip: 'Para identificar la cuentas contables que manejas efectivo, como bancos y cajas',
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
	       			name:'valor_incremento',
	       			fieldLabel:'Incremento',
	       			qtip: 'si la cuenta es negativa resta en el mayor',
	       			allowBlank:false,
	       			emptyText:'Tipo...',
	       			typeAhead: true,
	       		    triggerAction: 'all',
	       		    lazyRender:true,
	       		    mode: 'local',
	       		    gwidth: 100,
	       		    store:['positivo','negativo']
	       		},
	       		type:'ComboBox',
	       		valorInicial: 'positivo',
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	       	},
   	      {
       			config:{
       				name:'eeff',
       				fieldLabel:'EEFF',
       				allowBlank:true,
       				emptyText:'Roles...',
       				store: new Ext.data.ArrayStore({
                        fields: ['variable', 'valor'],
                        data : [ ['balance', 'Balance'],
                                 ['resultado', 'Resultado'],
                               ]
                        }),
       				valueField: 'variable',
				    displayField: 'valor',
       				forceSelection:true,
       				typeAhead: true,
           			triggerAction: 'all',
           			lazyRender:true,
       				mode:'local',
       				pageSize:10,
       				queryDelay:1000,
       				width:250,
       				minChars:2,
	       			enableMultiSelect:true
       			},
       			type:'AwesomeCombo',
       			id_grupo:0,
       			grid:true,
       			form:true
       	}
   	      
		
		
	],
	
	title:'Cuenta',
	ActSave:'../../sis_contabilidad/control/Cuenta/insertarCuenta',
	ActDel:'../../sis_contabilidad/control/Cuenta/eliminarCuenta',
	ActList:'../../sis_contabilidad/control/Cuenta/listarCuentaArb',
	id_store:'id_cuenta',
	
	textRoot:'Plan de Cuentas',
 id_nodo:'id_cuenta',
 id_nodo_p:'id_cuenta_padre',
	
	fields: [
		{name:'id_cuenta', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'nombre_cuenta', type: 'string'},
		{name:'sw_auxiliar', type: 'numeric'},
		{name:'tipo_cuenta', type: 'string'},
		{name:'id_cuenta_padre', type: 'numeric'},
		{name:'desc_cuenta', type: 'string'},
		{name:'nro_cuenta', type: 'string'},
		{name:'id_moneda', type: 'numeric'},
		{name:'sw_transaccional', type: 'string'},
		{name:'id_gestion', type: 'numeric'},'desc_moneda','valor_incremento','eeff','sw_control_efectivo'
		
	],
	cmbGestion: new Ext.form.ComboBox({
				fieldLabel: 'Gestion',
				allowBlank: true,
				emptyText:'Gestion...',
				store:new Ext.data.JsonStore(
				{
					url: '../../sis_parametros/control/Gestion/listarGestion',
					id: 'id_gestion',
					root: 'datos',
					sortInfo:{
						field: 'gestion',
						direction: 'DESC'
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
	
	sortInfo:{
		field: 'id_cuenta',
		direction: 'ASC'
	},
	bdel:true,
	bsave:false,
	rootVisible:true,
	expanded:false,
	
	
    getTipoCuentaPadre: function(n) {
			var direc
			var padre = n.parentNode;
            if (padre) {
				if (padre.attributes.id != 'id') {
					return this.getTipoCuentaPadre(padre);
				} else {
					return n.attributes.tipo_cuenta;
				}
			} else {
				return undefined;
			}
		},
   
    preparaMenu:function(n){
        if(n.attributes.tipo_nodo == 'hijo' || n.attributes.tipo_nodo == 'raiz' || n.attributes.id == 'id'){
            this.tbar.items.get('b-new-'+this.idContenedor).enable()
        }
        else {
            this.tbar.items.get('b-new-'+this.idContenedor).disable()
        }
        
        if(n.attributes.sw_auxiliar == 'si'){
            this.getBoton('bAux').enable();
        }
        else{
           this.getBoton('bAux').disable(); 
        }
        
       
        // llamada funcion clase padre
        Phx.vista.Cuenta.superclass.preparaMenu.call(this,n);
    },
    
    liberaMenu:function(n){
        this.getBoton('bAux').disable();
        
        // llamada funcion clase padre
        Phx.vista.Cuenta.superclass.liberaMenu.call(this,n);
        
    },
    
    
    
    
    loadValoresIniciales:function()
	{
		Phx.vista.Cuenta.superclass.loadValoresIniciales.call(this);
		this.getComponente('id_gestion').setValue(this.cmbGestion.getValue());	
		
	},
	onButtonEdit:function(n){
		this.ocultarComponente(this.cmpTipoCuenta);
		this.ocultarComponente(this.cmpTipoCuentaPat);
		this.ocultarComponente(this.cmpDigito);
		//this.cmpNroCuenta.disable();
		Phx.vista.Cuenta.superclass.onButtonEdit.call(this);
		
		var nodo = this.sm.getSelectedNode(this.cmpTipoCuenta);           
	        
	    if(this.cmpTipoCuenta.getValue() =='patrimonio'){
					this.mostrarComponente(this.cmpTipoCuentaPat);
				} else{
					this.ocultarComponente(this.cmpTipoCuentaPat);
				}
		
		
		
	},
	
    onButtonNew:function(n){
    	
    	if(this.cmbGestion.getValue()){
    		
    		this.ocultarComponente(this.cmpTipoCuentaPat);
    		this.mostrarComponente(this.cmpTipoCuenta);
    		
    		this.cmpNroCuenta.disable();
		
			Phx.vista.Cuenta.superclass.onButtonNew.call(this);
	        var nodo = this.sm.getSelectedNode(this.cmpTipoCuenta);           
	        
	        
	        if(nodo && nodo.attributes.id!='id'){
	        	console.log('nodos .... ',nodo, n)
	        	//si no es el nodo raiz
	        	this.cmpTipoCuenta.disable();
	        	this.cmpTipoCuenta.setValue(this.getTipoCuentaPadre(nodo));
	        	this.Cmp.valor_incremento.setValue(nodo.attributes.valor_incremento);
	        	this.Cmp.eeff.setValue(nodo.attributes.eeff);
	        	
	        	
	        	
	        	if(this.cmpTipoCuenta.getValue() =='patrimonio'){
					this.mostrarComponente(this.cmpTipoCuentaPat);
				} else{
					this.ocultarComponente(this.cmpTipoCuentaPat);
				}
	        	
	        	this.mostrarComponente(this.cmpDigito);
	        	this.cmpNroCuenta.setValue(nodo.attributes.nro_cuenta); 
	        }
	        else{
	        	//si es el nodo raiz
	        	this.ocultarComponente(this.cmpDigito);
	        	this.cmpTipoCuenta.enable();
	        }
	     }
	     else
	     {
	     	alert("seleccione una gestion primero");
	     	
	     }   
    },
    
    onButonAux:function(){
        var nodo = this.sm.getSelectedNode();
        Phx.CP.loadWindows('../../../sis_contabilidad/vista/cuenta_auxiliar/CuentaAuxiliar.php',
                    'Interfaces',
                    {
                        width:900,
                        height:400
                    },nodo.attributes,this.idContenedor,'CuentaAuxiliar')
       },
    iniciarEventos:function(){
    	
    	
    	 this.cmpTipoCuenta = this.getComponente('tipo_cuenta');
    	 this.cmpNroCuenta=this.getComponente('nro_cuenta');
    	 this.cmpDigito =this.getComponente('digito');
    	 this.cmpNombreCuenta=this.getComponente('nombre_cuenta')
    	 this.cmpSwTransaccional=this.getComponente('sw_transaccional')
    	 this.cmpTipoCuentaPat=this.getComponente('tipo_cuenta_pat')
    	
		 this.cmpTipoCuenta.on('beforeselect',function(combo,record,index){
				
				this.cmpNroCuenta.setValue(record.data.nro_base);
				if(record.data.tipo_cuenta =='patrimonio'){
					this.mostrarComponente(this.cmpTipoCuentaPat);
				} else{
					this.ocultarComponente(this.cmpTipoCuentaPat);
				} 
				
				this.cmpNombreCuenta.setValue( Ext.util.Format.capitalize(record.data.tipo_cuenta));
				this.cmpSwTransaccional.setValue('titular');
				
			},this);
			
			
			this.cmpDigito.on('change',function(field,n,o){
				
				var nodo = this.sm.getSelectedNode(this.cmpTipoCuenta);
				if(nodo){
					this.cmpNroCuenta.setValue( nodo.attributes.nro_cuenta+'.'+n);
				}
				
			},this);
		},
		
		
		
		tabeast:[
		  {
    		  url:'../../../sis_contabilidad/vista/cuenta_partida/CuentaPartida.php',
    		  title:'Partidas', 
    		  width:'60%',
    		  cls:'CuentaPartida'
		  }
		  
		]
})
</script>