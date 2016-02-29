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
Phx.vista.CbteDependencias=Ext.extend(Phx.arbGridInterfaz,{
	bedit: false,
    bnew: false,
    bsave: false,
    bdel: false,

	constructor:function(config){
		var me = this;
		this.maestro=config.maestro;
		
    	//llama al constructor de la clase padre
		Phx.vista.CbteDependencias.superclass.constructor.call(this,config);
		this.loaderTree.baseParams={id_int_comprobante_basico: config.id_int_comprobante};
		this.init();
		
		
		
		setTimeout(function() {
			me.root.expand(true);
		}, 100);
		
		
		
		
		
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
	
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_int_comprobante'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'id_int_comprobante_padre',
				inputType:'hidden'
			},
			type:'Field',
			form:true,
			grid:false
		},
		{
			config:{
				name: 'text',
				fieldLabel: 'Cbte',
				allowBlank: false,
				anchor: '80%',
				gwidth: 350,
				maxLength:100
			},
			type:'TextField',
			id_grupo:1,
			grid:true,
			form:false
		},{
			config:{
				name: 'glosa1',
				fieldLabel: 'Glosa',
				allowBlank: false,
				anchor: '80%',
				gwidth: 300,
				maxLength:30
			},
			type:'TextField',
			id_grupo:1,
			grid:true,
			form:true
		},{
			config:{
				name: 'nombre',
				fieldLabel: 'Relación',
				allowBlank: false,
				anchor: '80%',
				gwidth: 300,
				maxLength:30
			},
			type:'TextField',
			id_grupo:1,
			grid:true,
			form:true
		}
		
		 
	],
	
	title:'Dependencias',
	ActList:'../../sis_contabilidad/control/IntComprobante/listarCbteDependencias',
	id_store:'id_cuenta',
	
	textRoot:'Plan de Cuentas',
    id_nodo:'id_int_comprobante',
    id_nodo_p:'id_int_comprobante_padre',
	
	fields: [
		'id_int_comprobante','id_int_comprobante_padre','glosa1','nombre','nro_cbte'
		
	],
	
	sortInfo:{
		field: 'id_cuenta',
		direction: 'ASC'
	},
	
	rootVisible:true,
	expanded:true,
	
	
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
        // llamada funcion clase padre
        Phx.vista.CbteDependencias.superclass.preparaMenu.call(this,n);
    },
    
    liberaMenu:function(n){
        this.getBoton('bAux').disable();
        
        // llamada funcion clase padre
        Phx.vista.CbteDependencias.superclass.liberaMenu.call(this,n);
        
    }
    
    
    
   
	
   
    
   
})
</script>