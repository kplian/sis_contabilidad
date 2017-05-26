<?php
/**
*@package pXP
*@file    SubirArchivo.php
*@author  Rensi ARteaga Copari
*@date    27-03-2014
*@description permites subir archivos a la tabla de documento_sol
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.EntregaForm=Ext.extend(Phx.frmInterfaz,{
    ActSave:'../../sis_workflow/control/DocumentoWf/subirArchivoWf',
    layout: 'fit',
    maxCount: 0,
    constructor:function(config){   
        Phx.vista.EntregaForm.superclass.constructor.call(this,config);
        this.init(); 
         
    },
   
    Atributos:[
        {
            //configuracion del componente
            config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_entrega'
            },
            type:'Field',
            form:true 
        },
        {
            config: {
                name: 'c31',
                fieldLabel: 'Nro Cbte',
                qtip:'Número cbte relacionado sigep/sigma/otro/C31',
                allowBlank: false,
                anchor: '80%',
                maxLength:500
            },
            type:'TextField',
            form:true 
        },
        {
			config:{
				name: 'fecha_c31',
				fieldLabel: 'Fecha Cbte',
				qtip:'Fecha de cbte de SIGMA/SIGEP/OTRO/C31',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				format: 'd/m/Y', 
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'ent.fecha_c31',type:'date'},
				id_grupo:1,
				grid:true,
				form:true
		},
        {
            config: {
                name: 'obs',
                fieldLabel: 'Obs',
                allowBlank: false,
                anchor: '80%',
                maxLength:500
            },
            type:'TextArea',
            form:true 
        },  
         {
			config : {
				name : 'id_tipo_relacion_comprobante',
				fieldLabel : 'Incluir Relación',
				qtip : 'Si selecciona una de estas relaciones el nro de entrega se extendera a los comprobantes marcados como relacioandos por el tipo seleccionado solo si ysolo si: "no tiene una entrega"',
				allowBlank : true,
				emptyText : 'Elija una opción...',
				store : new Ext.data.JsonStore({
					url : '../../sis_contabilidad/control/TipoRelacionComprobante/listarTipoRelacionComprobante',
					id : 'id_tipo_relacion_comprobante',
					root : 'datos',
					sortInfo : {
						field : 'id_tipo_relacion_comprobante',
						direction : 'ASC'
					},
					totalProperty : 'total',
					fields : ['id_tipo_relacion_comprobante', 'codigo', 'nombre'],
					remoteSort : true,
					baseParams : {
						par_filtro : 'tiprelco.nombre#tiprelco.codigo'
					}
				}),
				valueField : 'id_tipo_relacion_comprobante',
				displayField : 'nombre',
				gdisplayField : 'desc_tipo_relacion_comprobante',
				hiddenName : 'id_tipo_relacion_comprobante',
				//forceSelection: true,
				typeAhead : false,
				triggerAction : 'all',
				lazyRender : true,
				mode : 'remote',
				pageSize : 15,
				queryDelay : 1000,
				width : 250,
				anchor: '80%',
				gwidth : 150,
				minChars : 2,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['desc_tipo_relacion_comprobante']);
				}
			},
			type : 'ComboBox',
			id_grupo : 1,
			filters : {
				pfiltro : 'incbte.desc_tipo_relacion_comprobante',
				type : 'string'
			},
			grid : true,
			form : true
		}
            
    ],
    
    title:'Estado del WF',
    
    onSubmit:function(){
       //TODO passar los datos obtenidos del wizard y pasar  el evento save 
       if (this.form.getForm().isValid()) {
           this.fireEvent('beforesave', this, this.getValues());
       }
    },
    getValues:function(){
    	console.log('this.estado_destino',this.estado_destino)
    	
    	var resp = {    id_entrega: this.data.id_entrega,
                        c31:  this.Cmp.c31.getValue(),
                        fecha_c31:  this.Cmp.fecha_c31.getValue().dateFormat('d/m/Y'),  
                        id_tipo_relacion_comprobante: this.Cmp.id_tipo_relacion_comprobante.getValue(),    
                        obs: this.Cmp.obs.getValue(),
                     }
                     
    	
            
         return resp;   
     }
    
    
})    
</script>
