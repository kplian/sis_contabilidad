Ext.namespace('Phx','Phx.comborec.sis_contabilidad');		

Phx.comborec.sis_contabilidad.configini = function (config){
	
	if (config.origen == 'CUENTA') {
		return {
			 origen: 'CUENTA',
			 tinit:false,
			 tasignacion:true,
			 resizable:true,
			 tname:'id_cuenta',
			 tdisplayField:'nombre_cuenta',
			 pid:this.idContenedor,
			 name:'id_cuenta',
 				fieldLabel:'Cuenta',
 				allowBlank:true,
 				emptyText:'Cuenta...',
				store: new Ext.data.JsonStore({
						 url: '../../sis_contabilidad/control/Cuenta/listarCuenta',
						 id: 'id_cuenta',
						 root: 'datos',
						 sortInfo:{
							field: 'nombre_cuenta',
							direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_cuenta','nombre_cuenta','desc_cuenta','nro_cuenta'],
					// turn on remote sorting
					remoteSort: true,
					baseParams:{par_filtro:'nro_cuenta#nombre_cuenta#desc_cuenta',sw_transaccional:'movimiento'}
					}),
				valueField: 'id_cuenta',
 				displayField: 'nombre_cuenta',
 				hiddenName: 'id_cuenta',
				tpl:'<tpl for="."><div class="x-combo-list-item"><p>{nro_cuenta}</p><p>Nombre:{nombre_cuenta}</p> </div></tpl>',
				forceSelection:true,
 				typeAhead: false,
                triggerAction: 'all',
                lazyRender:true,
 				mode:'remote',
 				pageSize:10,
 				queryDelay:1000,
 				width:250,
				listWidth:'280',
				minChars:2
		}
		
	}
	if (config.origen == 'AUXILIAR') {
		return {
			 origen: 'AUXILIAR',
			 tinit:false,
			 tasignacion:true,
			 resizable:true,
			 tname:'id_auxiliar',
			 tdisplayField:'nombre_auxiliar',
			 pid:this.idContenedor,
			 name:'id_auxiliar',
 				fieldLabel:'Auxiliar',
 				allowBlank:true,
 				emptyText:'Auxiliar...',
				store: new Ext.data.JsonStore({
						 url: '../../sis_contabilidad/control/Auxiliar/listarAuxiliar',
						 id: 'id_auxiliar',
						 root: 'datos',
						 sortInfo:{
							field: 'nombre_auxiliar',
							direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_auxiliar','nombre_auxiliar','codigo_auxiliar'],
					// turn on remote sorting
					remoteSort: true,
					baseParams:{par_filtro:'codigo_auxiliar#nombre_auxiliar'}
					}),
				valueField: 'id_auxiliar',
 				displayField: 'nombre_auxiliar',
 				hiddenName: 'id_auxiliar',
				tpl:'<tpl for="."><div class="x-combo-list-item"><p>{codigo_auxiliar}</p><p>Nombre:{nombre_auxiliar}</p> </div></tpl>',
				forceSelection:true,
 				typeAhead: false,
                triggerAction: 'all',
                lazyRender:true,
 				mode:'remote',
 				pageSize:10,
 				queryDelay:1000,
 				width:250,
				listWidth:'280',
				minChars:2
		}
		
	}
	if (config.origen == 'OT') {
		return {
			 origen: 'OT',
			 tinit:false,
			 tasignacion:true,
			 resizable:true,
			 name: 'id_orden_trabajo',
             fieldLabel: 'Orden Trabajo',
             allowBlank: true,
             emptyText : 'OT...',
             store : new Ext.data.JsonStore({
                            url:'../../sis_contabilidad/control/OrdenTrabajo/listarOrdenTrabajo',
                            id : 'id_orden_trabajo',
                            root: 'datos',
                            sortInfo:{
                                    field: 'motivo_orden',
                                    direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_orden_trabajo','motivo_orden','desc_orden','motivo_orden'],
                            remoteSort: true,
                            baseParams:{par_filtro:'desc_orden#motivo_orden'}
                }),
               valueField: 'id_orden_trabajo',
               displayField: 'desc_orden',
               gdisplayField: 'desc_orden',
               hiddenName: 'id_orden_trabajo',
               forceSelection:true,
               typeAhead: false,
               triggerAction: 'all',
                listWidth:350,
               lazyRender:true,
               mode:'remote',
               pageSize:10,
               queryDelay:1000,
               width:350,
               listWidth:'280',
               gwidth:350,
               minChars:2
            }
	}


}
	    		

	    