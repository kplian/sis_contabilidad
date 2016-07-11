<?php
/**
*@package pXP
*@file gen-RelacionContable.php
*@author  (admin)
*@date 16-05-2013 21:51:43
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.RelacionContableTabla = {
	require:'../../../sis_contabilidad/vista/relacion_contable/RelacionContable.php',
	requireclase:'Phx.vista.RelacionContable',
	title:'Relacion Contable',
	tiene_partida:'no',
	tiene_auxiliar:'no',
	filtro_partida:'no',
	constructor:function(config){
		this.maestro=config.maestro;
		this.Atributos.splice(4, 0, {
			config:{
				name: 'id_tipo_relacion_contable',
				fieldLabel: 'Tipo Relación Contable',
				allowBlank: false,
				emptyText: 'Tipo ...',
				store: new Ext.data.JsonStore({

	    					url: '../../sis_contabilidad/control/TipoRelacionContable/listarTipoRelacionContable',
	    					id: 'id_tipo_relacion_contable',
	    					root: 'datos',
	    					sortInfo:{
	    						field: 'codigo_tipo_relacion',
	    						direction: 'ASC'
	    					},
	    					totalProperty: 'total',
	    					fields: ['id_tipo_relacion_contable','codigo_tipo_relacion','nombre_tipo_relacion',
	    							'tiene_centro_costo','tiene_partida','tiene_auxiliar','partida_tipo','partida_rubro'],
	    					// turn on remote sorting
	    					remoteSort: true,
	    					baseParams:{par_filtro:'codigo_tipo_relacion#nombre_tipo_relacion'}
	    				}),
        	    valueField: 'id_tipo_relacion_contable',
        	    displayField: 'nombre_tipo_relacion',
        	    gdisplayField: 'nombre_tipo_relacion',
        	    hiddenName: 'id_tipo_relacion_contable',
        	    triggerAction: 'all',
        	    //queryDelay:1000,
        	    pageSize:10,
				forceSelection: true,
				typeAhead: true,
				allowBlank: false,
				anchor: '80%',
				gwidth: 150,
				mode: 'remote'				
			},
	           			
			type:'ComboBox',
			filters:{pfiltro:'tiprelco.nombre_tipo_relacion',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		});
		
		this.Atributos.splice(4, 0, {
                config:{
                    name:'defecto',
                    fieldLabel:'Defecto',
                    allowBlank:false,
                    emptyText:'Defecto',
                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode: 'local',
                    gwidth: 100,
                    store:['si','no']
                },
                type:'ComboBox',
                id_grupo:1,
                grid:true,
                form:true
            });
		
    	//llama al constructor de la clase padre
		Phx.vista.RelacionContableTabla.superclass.constructor.call(this,config);
		this.bloquearMenus();		
	},
	onReloadPage:function(m){
		this.maestro=m;
		var id_tabla_padre = this.maestro[this.tabla_id];
		this.store.setBaseParam('id_tabla', id_tabla_padre);
		this.store.setBaseParam('nombre_tabla', this.nombre_tabla);
		
		this.load({params:{start:0, limit:this.tam_pag}});
		// add baseparams to tipo relacion contable by codigos_tipo_relacion
		this.Cmp.id_tipo_relacion_contable.store.setBaseParam('codigos_tipo_relacion',this.maestro.codigos_tipo_relacion);
		// add baseparams to tipo relacion contable by nombre_tabla
		this.Cmp.id_tipo_relacion_contable.store.setBaseParam('nombre_tabla',this.nombre_tabla);
		this.Cmp.id_tipo_relacion_contable.modificado = true;		
		
	},	
	iniciarEventos : function() {
		
		this.Cmp.id_gestion.on('select', function (c, r) {			
			this.Cmp.id_centro_costo.store.setBaseParam('id_gestion',r.data.id_gestion);
			this.Cmp.id_cuenta.store.setBaseParam('id_gestion',r.data.id_gestion);
			this.Cmp.id_auxiliar.store.setBaseParam('id_gestion',r.data.id_gestion);
			this.Cmp.id_partida.store.setBaseParam('id_gestion',r.data.id_gestion);
			
			this.Cmp.id_tipo_relacion_contable.enable();			 
			this.Cmp.id_cuenta.enable();			
			
			this.Cmp.id_centro_costo.modificado = true;
			this.Cmp.id_cuenta.modificado = true;
			this.Cmp.id_auxiliar.modificado = true;
			this.Cmp.id_partida.modificado = true;
			
			this.Cmp.id_centro_costo.reset();
			this.Cmp.id_cuenta.reset();
			this.Cmp.id_auxiliar.reset();
			this.Cmp.id_partida.reset();
			
		}, this);
		
		this.Cmp.id_cuenta.on('select', function (c,r,i) {
          
            this.Cmp.id_auxiliar.store.setBaseParam('id_cuenta',r.data.id_cuenta);
            this.Cmp.id_auxiliar.modificado = true;
            this.Cmp.id_auxiliar.reset();
            //if (this.filtro_partida == 'no') {
	          //  this.Cmp.id_partida.store.setBaseParam('id_cuenta',r.data.id_cuenta);
	            //this.Cmp.id_partida.modificado = true;
	            //this.Cmp.id_partida.reset(); 
	        //}           
            
        }, this);
        
        this.Cmp.id_centro_costo.on('select', function (c,r,i) {           
            //if (this.filtro_partida == 'no') {
	          //  this.Cmp.id_partida.store.setBaseParam('id_centro_costo',r.data.id_centro_costo);
	            //this.Cmp.id_partida.modificado = true;
	            //this.Cmp.id_partida.reset(); 
	        //}           
            
        }, this);        
		
		
		this.Cmp.id_tipo_relacion_contable.on('select', function (c,r,i) {
			if ('filtro_cuenta' in this.maestro && r.data.codigo == this.maestro.filtro_cuenta.tipo) {
				this.Cmp.id_cuenta.store.setBaseParam(this.maestro.filtro_cuenta.propiedad,this.maestro.filtro_cuenta.valor);
				this.Cmp.id_cuenta.modificado = true;
			}		
			
			if ('filtro_centro_costo' in this.maestro && r.data.codigo == this.maestro.filtro_centro_costo.tipo) {
				this.Cmp.id_centro_costo.store.setBaseParam(this.maestro.filtro_centro_costo.propiedad,this.maestro.filtro_centro_costo.valor);
				this.Cmp.id_centro_costo.modificado = true;
			}
			//centro de costo
			if (r.data.tiene_centro_costo == 'si') {
				this.mostrarComponente(this.Cmp.id_centro_costo);
				this.setAllowBlank(this.Cmp.id_centro_costo, false);
				this.setAllowBlank(this.Cmp.id_cuenta, false);
				this.Cmp.id_centro_costo.enable();
			} else if (r.data.tiene_centro_costo == 'si-general') {
				this.mostrarComponente(this.Cmp.id_centro_costo);
				this.setAllowBlank(this.Cmp.id_centro_costo, true);
				this.setAllowBlank(this.Cmp.id_cuenta, false);
				this.Cmp.id_centro_costo.enable();
			} else if (r.data.tiene_centro_costo == 'si-unico') {
                this.mostrarComponente(this.Cmp.id_centro_costo);
                this.setAllowBlank(this.Cmp.id_centro_costo, false);
                this.setAllowBlank(this.Cmp.id_cuenta, true);
                this.Cmp.id_centro_costo.enable();
            } else {
				this.Cmp.id_centro_costo.reset();
				this.ocultarComponente(this.Cmp.id_centro_costo);
				this.setAllowBlank(this.Cmp.id_centro_costo, true);
				this.setAllowBlank(this.Cmp.id_cuenta, false);
			}
			//partida
			if (r.data.tiene_partida == 'si') {
				
				this.tiene_partida = 'si';
				this.mostrarComponente(this.Cmp.id_partida);
				this.setAllowBlank(this.Cmp.id_partida, false);
				this.Cmp.id_partida.enable(); 
				//Seteo del store del combo de partida
				Ext.apply(this.Cmp.id_partida.store.baseParams,{
					partida_tipo:r.data.partida_tipo,
					partida_rubro:r.data.partida_rubro});
				//anade el filtro de partida en caso de que exista
				if ('filtro_partida' in this.maestro && r.data.codigo_tipo_relacion == this.maestro.filtro_partida.tipo) {
						
					this.Cmp.id_partida.store.setBaseParam(this.maestro.filtro_partida.propiedad,this.maestro.filtro_partida.valor);
					this.Cmp.id_partida.modificado = true;
				}	
				this.filtro_partida = 'no';
				if ('filtro_partida' in this.maestro) {
				//carga el combo de partida si existe una sola partida			
		            this.Cmp.id_partida.store.load({params:{start:0,limit:this.tam_pag}, 
			        	callback : function (r) {
				       		if (r.length == 1 ) {	       				       				
				    			this.Cmp.id_partida.setValue(r[0].data.id_partida);
				    			this.Cmp.id_partida.collapse();
				    			//this.Cmp.id_cuenta.store.setBaseParam('id_partida', this.Cmp.id_partida.getValue());
				    			//si se selecciona automaticamente la partida ya no se filtrara por cuenta ni por centro de costo
				    			this.filtro_partida = 'si';
				    			//si selecciona automaticamante la partida es necesario aplicar nuevo filtro al centro de costos
				    			this.Cmp.id_centro_costo.store.setBaseParam('id_partida',r[0].data.id_partida);
				    		}			    			    		
				    	}, scope : this
				    });
				}
				
			} else {
				this.tiene_partida = 'no';
				this.Cmp.id_partida.reset();
				this.ocultarComponente(this.Cmp.id_partida);
				this.setAllowBlank(this.Cmp.id_partida, true);
			}
			//auxiliar
			if (r.data.tiene_auxiliar == 'si') {
				this.tiene_auxiliar = 'si';
				this.mostrarComponente(this.Cmp.id_auxiliar);
				this.setAllowBlank(this.Cmp.id_auxiliar, false);
				this.Cmp.id_auxiliar.enable();
				if ('filtro_auxiliar' in this.maestro && r.data.codigo == this.maestro.filtro_auxiliar.tipo) {
					this.Cmp.id_partida.store.setBaseParam(this.maestro.filtro_partida.propiedad,this.maestro.filtro_partida.valor);
					this.Cmp.id_partida.modificado = true;
				}
				
			} else {
				this.tiene_auxiliar = 'no';
				this.Cmp.id_auxiliar.reset();
				this.ocultarComponente(this.Cmp.id_auxiliar);
				this.setAllowBlank(this.Cmp.id_auxiliar, true);
			}
			
		}, this);
	},
	onButtonNew : function () {
		Phx.vista.RelacionContableTabla.superclass.onButtonNew.call(this);	
			
		this.setAllowBlank(this.Cmp.id_cuenta, true);		
		this.Cmp.id_tabla.setValue(this.maestro[this.tabla_id]);
		this.Cmp.nombre_tabla.setValue(this.maestro.nombre_tabla);	
		this.Cmp.id_centro_costo.disable(); 
		this.Cmp.id_cuenta.disable();  
		this.Cmp.id_auxiliar.disable(); 
		this.Cmp.id_partida.disable();
		this.Cmp.id_gestion.store.load({params:{start:0,limit:this.tam_pag}, 
	       callback : function (r) {
	       		if (r.length > 0 ) {	       				       				
	    			this.Cmp.id_gestion.setValue(r[0].data.id_gestion);
	    			this.Cmp.id_gestion.fireEvent('select',this.Cmp.id_gestion, r[0]);
	    			this.Cmp.id_gestion.collapse();	 
	    		}    
	    			    		
	    	}, scope : this
	    });
	       
	} ,
	onButtonEdit : function () {
	   
		Phx.vista.RelacionContableTabla.superclass.onButtonEdit.call(this);
		var selected = this.sm.getSelected().data;
		this.setAllowBlank(this.Cmp.id_cuenta, true);
		//centro de costo
		if (selected.tiene_centro_costo == 'si') {
			this.mostrarComponente(this.Cmp.id_centro_costo);
			this.setAllowBlank(this.Cmp.id_centro_costo, false);
			
		
		} else if (selected.tiene_centro_costo == 'si-general') {
				this.mostrarComponente(this.Cmp.id_centro_costo);
				this.setAllowBlank(this.Cmp.id_centro_costo, true);				
		} else if (selected.tiene_centro_costo == 'si-unico') {
                this.mostrarComponente(this.Cmp.id_centro_costo);
                this.setAllowBlank(this.Cmp.id_cuenta, false);
                this.setAllowBlank(this.Cmp.id_centro_costo, true);             
        } else {
			this.Cmp.id_centro_costo.reset();
			this.ocultarComponente(this.Cmp.id_centro_costo);
			this.setAllowBlank(this.Cmp.id_centro_costo, true);
		}
		//partida
		if (selected.tiene_partida == 'si') {
			this.mostrarComponente(this.Cmp.id_partida);
			this.setAllowBlank(this.Cmp.id_partida, false);
			this.tiene_partida = 'si';
		} else {
			this.Cmp.id_partida.reset();
			this.ocultarComponente(this.Cmp.id_partida);
			this.setAllowBlank(this.Cmp.id_partida, true);
			this.tiene_partida = 'no';
			
		}
		//auxiliar
		if (selected.tiene_auxiliar == 'si') {
			this.mostrarComponente(this.Cmp.id_auxiliar);
			this.setAllowBlank(this.Cmp.id_auxiliar, false);
			this.tiene_auxiliar = 'si';
		} else {
			this.Cmp.id_auxiliar.reset();
			this.ocultarComponente(this.Cmp.id_auxiliar);
			this.setAllowBlank(this.Cmp.id_auxiliar, false);
			this.tiene_auxiliar = 'no';
		}
		
		this.Cmp.id_tabla.setValue(this.maestro[this.tabla_id]);
		
		this.Cmp.id_centro_costo.store.setBaseParam('id_gestion',selected.id_gestion);
		this.Cmp.id_cuenta.store.setBaseParam('id_gestion',selected.id_gestion);
		this.Cmp.id_auxiliar.store.setBaseParam('id_gestion',selected.id_gestion);
		this.Cmp.id_partida.store.setBaseParam('id_gestion',selected.id_gestion);
		
		this.Cmp.id_auxiliar.store.setBaseParam('id_cuenta',selected.id_cuenta);
		this.Cmp.id_partida.store.setBaseParam('id_cuenta',selected.id_gestion);
		
		this.Cmp.id_tipo_relacion_contable.enable(); 
		this.Cmp.id_centro_costo.enable(); 
		this.Cmp.id_cuenta.enable();  
		this.Cmp.id_auxiliar.enable(); 
		this.Cmp.id_partida.enable();
		
		this.Cmp.id_centro_costo.modificado = true;
		this.Cmp.id_cuenta.modificado = true;
		this.Cmp.id_auxiliar.modificado = true;
		this.Cmp.id_partida.modificado = true;
		
	}, 
	loadValoresIniciales:function()  
    {
    	this.Cmp.defecto.setValue('no');
        Phx.vista.RelacionContableTabla.superclass.loadValoresIniciales.call(this);        
    },
};
</script>